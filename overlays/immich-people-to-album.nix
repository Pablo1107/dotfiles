self: pkgs:

with pkgs;

{
  immich-people-to-album = writers.writePython3Bin "immich-people-to-album" {
    libraries = with pkgs.python3Packages; [ requests ];
  } ''
    import argparse
    import requests
    import json

    config = dict()


    def login_to_api(server_url, email, password):
        login_url = f"{server_url}/api/auth/login"
        login_payload = json.dumps({
            "email": email,
            "password": password
        })
        login_headers = {'Content-Type': 'application/json',
                         'Accept': 'application/json'}
        response = requests.request(
            "POST", login_url, headers=login_headers, data=login_payload)
        if config.get('debug', False):
            print(f"Login response: {response.status_code}, Body: {response.text}")
        else:
            print(f"Login response: {response.status_code}")
        return response.json()['accessToken']


    def get_photos(server_url, token, count, people_id):
        photo_url = f"{server_url}/api/person/{people_id}/assets"
        photo_headers = {
          'Authorization': f'Bearer {token}',
          'Accept': 'application/json'
        }
        photo_response = requests.get(photo_url, headers=photo_headers)
        assets = photo_response.json()
        if config.get('debug', False):
            print(f"Fetched assets: {assets}")
        else:
            print(f"Fetched {len(assets)} assets.")
        photos = [asset for asset in assets if asset['type'] == 'IMAGE']
        photos.sort(key=lambda x: x['fileCreatedAt'], reverse=True)
        return photos[:count]


    def add_assets_to_album(server_url, token, album_id, asset_ids, key=None):
        url = f"{server_url}/api/album/{album_id}/assets"
        headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
        payload = json.dumps({"ids": asset_ids})
        params = {'key': key} if key else {}
        if config.get('debug', False):
            print(f"Sending request to {url} with payload: "
                  f"{payload} and params: {params}")
        response = requests.put(url, headers=headers, data=payload, params=params)
        if config.get('debug', False):
            print(f"Add assets response: {response.status_code}, "
                  f"Body: {response.text}")
        if response.status_code == 200:
            response_json = response.json()
            success_count = sum([1 for asset in response_json if asset['success']])
            print(f"{success_count} assets successfully added to the album.")
            return True
        else:
            try:
                error_response = response.json().get('error', 'Unknown error')
                print(f"Error adding assets to album: {error_response}")
            except json.JSONDecodeError:
                if config.get('debug', False):
                    print(f"Failed to decode JSON response. "
                          f"Status code: {response.status_code}, "
                          f"Response text: {response.text}")
                else:
                    print(f"Failed to decode JSON response. "
                          f"Status code: {response.status_code}")
            return False


    def main():
        parser = argparse.ArgumentParser()
        parser.add_argument('--server_url')
        parser.add_argument('--email')
        parser.add_argument('--password')
        parser.add_argument('--people_id')
        parser.add_argument('--album_id')
        parser.add_argument(
            '--debug', action=argparse.BooleanOptionalAction, default=False)
        args = parser.parse_args()
        if args.debug:
            config['debug'] = args.debug

        print(f"Server URL: {args.server_url}")
        print(f"Email: {args.email}")
        print(f"People ID: {args.people_id}")
        print(f"Album ID: {args.album_id}")
        token = login_to_api(args.server_url, args.email, args.password)
        # Fetching the latest 100 assets
        assets = get_photos(args.server_url, token, 100, args.people_id)
        asset_ids = [asset['id'] for asset in assets if asset['type']
                     == 'IMAGE']  # Extracting the IDs
        add_assets_to_album(args.server_url, token, args.album_id, asset_ids)


    if __name__ == "__main__":
        main()
  '';
}
