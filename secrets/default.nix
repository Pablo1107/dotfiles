{ config, pkgs, inputs, ... }:

{
  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  # age.identityPaths = [
  #   "/home/ryan/.ssh/juliet-age"
  # ];

  age.secrets."example" = {
    # whether secrets are symlinked to age.secrets.<name>.path
    symlink = true;
    # target path for decrypted file
    path = "/etc/example/";
    # encrypted file path
    file = "${inputs.secrets}/example.age"; # refer to ./xxx.age located in `mysecrets` repo
    mode = "0400";
    owner = "root";
    group = "root";
  };
}
