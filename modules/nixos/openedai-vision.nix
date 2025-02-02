{ config, options, lib, myLib, pkgs, pkgs-stable,  ...  }:
with lib;
with myLib;

let
  cfg = config.personal.openedai-vision;
  nginxCfg = config.services.nginx.virtualHosts;
in
{
  options = {
    personal = {
      openedai-vision = {
        enable = mkEnableOption "OpenedAI Vision service";
      };
    };
  };

  config = mkIf cfg.enable {
    # services.nginx.virtualHosts = createVirtualHosts {
    #   inherit nginxCfg;
    #   subdomain = "openedai-vision";
    #   port = "5006";
    # };

    users.users.openedai-vision = {
      uid = 700;
      isSystemUser = true;
      group = "openedai-vision";
    };

    users.groups.openedai-vision = {
      gid = 700;
    };

    virtualisation.oci-containers.containers.openedai-vision = {
      image = "ghcr.io/matatonic/openedai-vision:latest";
      ports = [
        "5006:5006"
      ];
      # hostname = "shrinky";
      volumes = [
        "/var/lib/openedai-vision/hf_home:/app/hf_home"
        # "/var/lib/openedai-vision/model_conf_tests.json:/app/model_conf_tests.json"
      ];
      environment = {
        # This sample env file can be used to set environment variables for the docker-compose.yml
        # Copy this file to vision.env and uncomment the model of your choice.
        HF_HOME = "hf_home";
        HF_HUB_ENABLE_HF_TRANSFER = "1";
        #HF_TOKEN=hf-...
        #CUDA_VISIBLE_DEVICES=1,0
        #OPENEDAI_DEVICE_MAP="sequential"

        # CLI_COMMAND = "python vision.py -m AIDC-AI/Ovis1.6-Llama3.2-3B -A flash_attention_2";  # test pass✅, time: 13.1s, mem: 10.8GB, 13/13 tests passed, (125/3.9s) 32.4 T/s
        #CLI_COMMAND="python vision.py -m AIDC-AI/Ovis1.6-Gemma2-9B -A flash_attention_2"  # test pass✅, time: 34.1s, mem: 22.8GB, 13/13 tests passed, (133/10.6s) 12.5 T/s
        #CLI_COMMAND="python vision.py -m AIDC-AI/Ovis1.6-Gemma2-27B -A flash_attention_2"  # test pass✅, time: 29.1s, mem: 59.5GB, 13/13 tests passed, (68/9.2s) 7.4 T/s
        #CLI_COMMAND="python vision.py -m AIDC-AI/Ovis1.5-Gemma2-9B -A flash_attention_2"  # test pass✅, time: 9.6s, mem: 23.4GB, 13/13 tests passed, (32/2.8s) 11.3 T/s
        #CLI_COMMAND="python vision.py -m AIDC-AI/Ovis1.5-Llama3-8B -A flash_attention_2"  # test pass✅, time: 5.9s, mem: 19.4GB, 13/13 tests passed, (32/1.5s) 21.8 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Aquila-VL-2B-llava-qwen -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 26.6s, mem: 10.0GB, 13/13 tests passed, (27/8.0s) 3.4 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Aquila-VL-2B-llava-qwen -A flash_attention_2"  # test pass✅, time: 9.6s, mem: 11.4GB, 13/13 tests passed, (27/2.8s) 9.7 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-2B-zh --load-in-4bit"  # test pass✅, time: 7.8s, mem: 8.6GB, 13/13 tests passed, (39/1.5s) 25.5 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-2B-zh"  # test pass✅, time: 5.4s, mem: 11.1GB, 13/13 tests passed, (38/1.1s) 34.4 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-3B --load-in-4bit"  # test pass✅, time: 10.1s, mem: 8.4GB, 13/13 tests passed, (59/2.6s) 22.3 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-3B"  # test pass✅, time: 9.6s, mem: 12.1GB, 13/13 tests passed, (70/2.5s) 27.7 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-3B-zh"  # test pass✅, time: 8.0s, mem: 12.6GB, 13/13 tests passed, (37/1.8s) 20.5 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-4B --load-in-4bit"  # test pass✅, time: 8.7s, mem: 7.4GB, 13/13 tests passed, (48/2.5s) 19.6 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_0-4B"  # test pass✅, time: 7.1s, mem: 12.4GB, 13/13 tests passed, (44/2.0s) 22.3 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_1-4B --load-in-4bit"  # test pass✅, time: 10.3s, mem: 8.3GB, 13/13 tests passed, (44/2.9s) 15.1 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Bunny-v1_1-4B"  # test pass✅, time: 8.5s, mem: 13.3GB, 13/13 tests passed, (35/2.3s) 15.1 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Emu2-Chat --load-in-4bit"  # test pass✅, time: 29.2s, mem: 29.5GB, 13/13 tests passed, (65/8.0s) 8.1 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Emu2-Chat --max-memory=0:78GiB,1:20GiB"  # test pass✅, time: 21.7s, mem: 72.1GB, 13/13 tests passed, (71/6.1s) 11.6 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Emu3-Chat --load-in-4bit -A flash_attention_2"  # test pass✅, time: 63.6s, mem: 54.8GB, 13/13 tests passed, (137/20.4s) 6.7 T/s
        #CLI_COMMAND="python vision.py -m BAAI/Emu3-Chat -A flash_attention_2"  # test pass✅, time: 67.8s, mem: 65.1GB, 13/13 tests passed, (159/21.8s) 7.3 T/s
        #CLI_COMMAND="python vision.py -m HuggingFaceTB/SmolVLM-Instruct -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 9.6s, mem: 5.1GB, 13/13 tests passed, (33/2.4s) 13.7 T/s
        #CLI_COMMAND="python vision.py -m HuggingFaceTB/SmolVLM-Instruct -A flash_attention_2"  # test pass✅, time: 8.3s, mem: 8.1GB, 13/13 tests passed, (33/2.2s) 15.0 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL-Chat-V1-5 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 23.0s, mem: 27.2GB, 13/13 tests passed, (60/7.1s) 8.5 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL-Chat-V1-5 --device-map cuda:0 --max-tiles 40 --load-in-4bit"  # test pass✅, time: 29.6s, mem: 30.4GB, 13/13 tests passed, (58/9.2s) 6.3 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL-Chat-V1-5 --device-map cuda:0 --max-tiles 40"  # test pass✅, time: 25.5s, mem: 54.8GB, 13/13 tests passed, (45/8.0s) 5.6 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL-Chat-V1-5 --device-map cuda:0"  # test pass✅, time: 18.9s, mem: 52.3GB, 13/13 tests passed, (50/5.8s) 8.6 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-1B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 8.7s, mem: 2.6GB, 13/13 tests passed, (68/2.5s) 27.4 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-1B --device-map cuda:0 --max-tiles 12"  # test pass✅, time: 5.9s, mem: 3.3GB, 13/13 tests passed, (47/1.6s) 30.2 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-2B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 14.7s, mem: 6.8GB, 13/13 tests passed, (131/4.5s) 29.1 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-2B --device-map cuda:0 --max-tiles 12"  # test pass✅, time: 8.0s, mem: 8.6GB, 13/13 tests passed, (73/2.3s) 32.3 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-4B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 11.7s, mem: 4.4GB, 13/13 tests passed, (57/3.4s) 16.7 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-4B --device-map cuda:0 --max-tiles 12"  # test pass✅, time: 9.9s, mem: 8.6GB, 13/13 tests passed, (62/2.8s) 21.8 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-8B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 11.9s, mem: 11.3GB, 13/13 tests passed, (48/3.6s) 13.3 T/s
        CLI_COMMAND = "python vision.py -m OpenGVLab/InternVL2_5-8B --device-map cuda:0 --max-tiles 12";  # test pass✅, time: 9.4s, mem: 20.4GB, 13/13 tests passed, (42/2.7s) 15.7 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-26B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 29.1s, mem: 30.4GB, 13/13 tests passed, (51/9.1s) 5.6 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-26B --device-map cuda:0 --max-tiles 12"  # test pass✅, time: 27.1s, mem: 54.9GB, 13/13 tests passed, (52/8.6s) 6.0 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-38B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 40.9s, mem: 32.1GB, 13/13 tests passed, (67/13.0s) 5.1 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-38B --device-map cuda:0 --max-tiles 12"  # test pass✅, time: 35.9s, mem: 74.8GB, 13/13 tests passed, (57/11.6s) 4.9 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2_5-78B --device-map cuda:0 --max-tiles 12 --load-in-4bit"  # test pass✅, time: 57.7s, mem: 54.1GB, 13/13 tests passed, (53/18.4s) 2.9 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-1B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 25.6s, mem: 2.0GB, 13/13 tests passed, (271/8.0s) 33.8 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-1B --device-map cuda:0"  # test pass✅, time: 7.3s, mem: 2.7GB, 13/13 tests passed, (77/2.1s) 37.4 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-2B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 15.9s, mem: 4.8GB, 13/13 tests passed, (156/4.9s) 32.1 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-2B --device-map cuda:0"  # test pass✅, time: 8.4s, mem: 6.7GB, 13/13 tests passed, (90/2.3s) 38.3 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-8B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 9.0s, mem: 8.6GB, 13/13 tests passed, (43/2.6s) 16.4 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-8B --device-map cuda:0"  # test pass✅, time: 8.0s, mem: 18.3GB, 13/13 tests passed, (43/2.2s) 19.6 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-26B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 24.2s, mem: 26.9GB, 13/13 tests passed, (75/7.6s) 9.9 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-26B --device-map cuda:0"  # test pass✅, time: 20.3s, mem: 52.1GB, 13/13 tests passed, (59/6.3s) 9.3 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-40B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 33.8s, mem: 31.5GB, 13/13 tests passed, (82/10.5s) 7.8 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-40B --device-map cuda:0"  # test pass✅, time: 44.1s, mem: 76.5GB, 13/13 tests passed, (140/14.2s) 9.8 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/InternVL2-Llama3-76B --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 38.1s, mem: 51.5GB, 13/13 tests passed, (40/12.0s) 3.3 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/Mini-InternVL-Chat-2B-V1-5 --load-in-4bit"  # test pass✅, time: 6.1s, mem: 5.3GB, 13/13 tests passed, (42/1.6s) 26.0 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/Mini-InternVL-Chat-2B-V1-5 --max-tiles 40 --load-in-4bit"  # test pass✅, time: 7.1s, mem: 7.0GB, 13/13 tests passed, (42/2.0s) 21.5 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/Mini-InternVL-Chat-2B-V1-5 --max-tiles 40"  # test pass✅, time: 6.8s, mem: 8.9GB, 13/13 tests passed, (48/1.9s) 25.9 T/s
        #CLI_COMMAND="python vision.py -m OpenGVLab/Mini-InternVL-Chat-2B-V1-5"  # test pass✅, time: 5.8s, mem: 7.2GB, 13/13 tests passed, (48/1.5s) 31.4 T/s
        #CLI_COMMAND="python vision.py -m Qwen/Qwen-VL-Chat --load-in-4bit"  # test pass✅, time: 8.9s, mem: 12.1GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m Qwen/Qwen-VL-Chat"  # test pass✅, time: 6.9s, mem: 19.6GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m Qwen/Qwen2-VL-2B-Instruct-AWQ -A flash_attention_2"  # test pass✅, time: 11.0s, mem: 7.0GB, 13/13 tests passed, (44/3.2s) 13.6 T/s
        #CLI_COMMAND="python vision.py -m Qwen/Qwen2-VL-2B-Instruct -A flash_attention_2"  # test pass✅, time: 17.8s, mem: 16.4GB, 13/13 tests passed, (36/5.2s) 6.9 T/s
        #CLI_COMMAND="python vision.py -m Qwen/Qwen2-VL-7B-Instruct-AWQ -A flash_attention_2"  # test pass✅, time: 17.9s, mem: 18.6GB, 13/13 tests passed, (36/5.4s) 6.7 T/s
        #CLI_COMMAND="python vision.py -m Qwen/Qwen2-VL-7B-Instruct -A flash_attention_2"  # test pass✅, time: 16.2s, mem: 27.6GB, 13/13 tests passed, (31/4.8s) 6.4 T/s
        #CLI_COMMAND="python vision.py -m Qwen/Qwen2-VL-72B-Instruct-AWQ -A flash_attention_2"  # test pass✅, time: 34.0s, mem: 44.6GB, 13/13 tests passed, (31/10.6s) 2.9 T/s
        #CLI_COMMAND="python vision.py -m Salesforce/xgen-mm-phi3-mini-instruct-dpo-r-v1.5"  # test pass✅, time: 8.6s, mem: 9.5GB, 13/13 tests passed, (68/2.4s) 28.2 T/s
        #CLI_COMMAND="python vision.py -m Salesforce/xgen-mm-phi3-mini-instruct-interleave-r-v1.5"  # test pass✅, time: 3.5s, mem: 9.5GB, 13/13 tests passed, (10/0.8s) 13.3 T/s
        #CLI_COMMAND="python vision.py -m Salesforce/xgen-mm-phi3-mini-instruct-singleimg-r-v1.5"  # test pass✅, time: 9.1s, mem: 9.5GB, 13/13 tests passed, (73/2.5s) 29.0 T/s
        #CLI_COMMAND="python vision.py -m Salesforce/xgen-mm-phi3-mini-instruct-r-v1"  # test pass✅, time: 9.2s, mem: 10.0GB, 13/13 tests passed, (74/2.6s) 28.5 T/s
        #CLI_COMMAND="python vision.py -m TIGER-Lab/Mantis-8B-Fuyu --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 9.2s, mem: 11.6GB, 13/13 tests passed, (14/2.7s) 5.3 T/s
        #CLI_COMMAND="python vision.py -m TIGER-Lab/Mantis-8B-Fuyu --device-map cuda:0"  # test pass✅, time: 9.0s, mem: 20.4GB, 13/13 tests passed, (22/2.6s) 8.5 T/s
        #CLI_COMMAND="python vision.py -m adept/fuyu-8b --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 20.6s, mem: 16.0GB, 13/13 tests passed, (92/6.5s) 14.1 T/s
        #CLI_COMMAND="python vision.py -m adept/fuyu-8b --device-map cuda:0"  # test pass✅, time: 16.8s, mem: 25.1GB, 13/13 tests passed, (79/5.2s) 15.1 T/s
        #CLI_COMMAND="python vision.py -m allenai/MolmoE-1B-0924 -A flash_attention_2 --load-in-4bit --use-double-quant"  # test pass✅, time: 106.9s, mem: 6.0GB, 13/13 tests passed, (104/34.5s) 3.0 T/s
        #CLI_COMMAND="python vision.py -m allenai/MolmoE-1B-0924 -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 78.6s, mem: 6.3GB, 13/13 tests passed, (84/25.5s) 3.3 T/s
        #CLI_COMMAND="python vision.py -m allenai/MolmoE-1B-0924 -A flash_attention_2"  # test pass✅, time: 26.1s, mem: 15.4GB, 13/13 tests passed, (40/8.1s) 4.9 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-D-0924 -A flash_attention_2 --load-in-4bit --use-double-quant"  # test pass✅, time: 45.1s, mem: 8.1GB, 13/13 tests passed, (318/14.5s) 21.9 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-D-0924 -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 38.7s, mem: 8.4GB, 13/13 tests passed, (310/12.5s) 24.7 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-D-0924 -A flash_attention_2"  # test pass✅, time: 31.7s, mem: 18.3GB, 13/13 tests passed, (302/10.1s) 29.8 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-O-0924 -A flash_attention_2 --load-in-4bit --use-double-quant"  # test pass✅, time: 38.5s, mem: 8.7GB, 13/13 tests passed, (214/12.6s) 16.9 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-O-0924 -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 33.4s, mem: 9.0GB, 13/13 tests passed, (214/10.6s) 20.2 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-7B-O-0924 -A flash_attention_2"  # test pass✅, time: 29.2s, mem: 18.7GB, 13/13 tests passed, (208/9.2s) 22.5 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-72B-0924 -A flash_attention_2 --load-in-4bit --use-double-quant"  # test pass✅, time: 126.1s, mem: 43.4GB, 13/13 tests passed, (285/41.0s) 6.9 T/s
        #CLI_COMMAND="python vision.py -m allenai/Molmo-72B-0924 -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 110.2s, mem: 48.4GB, 13/13 tests passed, (271/35.9s) 7.5 T/s
        #CLI_COMMAND="python vision.py -m echo840/Monkey-Chat --load-in-4bit"  # test pass✅, time: 14.4s, mem: 16.0GB, 13/13 tests passed, (49/4.4s) 11.1 T/s
        #CLI_COMMAND="python vision.py -m echo840/Monkey-Chat"  # test pass✅, time: 11.5s, mem: 21.5GB, 13/13 tests passed, (32/3.4s) 9.3 T/s
        #CLI_COMMAND="python vision.py -m failspy/Phi-3-vision-128k-instruct-abliterated-alpha -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 10.1s, mem: 7.0GB, 13/13 tests passed, (37/2.9s) 12.7 T/s
        #CLI_COMMAND="python vision.py -m failspy/Phi-3-vision-128k-instruct-abliterated-alpha -A flash_attention_2"  # test pass✅, time: 9.1s, mem: 11.8GB, 13/13 tests passed, (37/2.6s) 14.5 T/s
        #CLI_COMMAND="python vision.py -m fancyfeast/joy-caption-alpha-two --load-in-4bit -A flash_attention_2"  # test pass✅, time: 55.5s, mem: 9.4GB, 13/13 tests passed, (248/20.0s) 12.4 T/s
        #CLI_COMMAND="python vision.py -m fancyfeast/joy-caption-alpha-two -A flash_attention_2"  # test pass✅, time: 34.5s, mem: 18.9GB, 13/13 tests passed, (148/8.2s) 18.1 T/s
        #CLI_COMMAND="python vision.py -m fancyfeast/joy-caption-pre-alpha --load-in-4bit -A flash_attention_2"  # test pass✅, time: 107.8s, mem: 8.6GB, 13/13 tests passed, (692/35.9s) 19.3 T/s
        #CLI_COMMAND="python vision.py -m fancyfeast/joy-caption-pre-alpha -A flash_attention_2"  # test pass✅, time: 61.0s, mem: 18.2GB, 13/13 tests passed, (707/20.9s) 33.8 T/s
        #CLI_COMMAND="python vision.py -m google/paligemma2-3b-ft-docci-448 -A flash_attention_2"  # test pass✅, time: 50.2s, mem: 7.4GB, 13/13 tests passed, (425/16.2s) 26.3 T/s
        #CLI_COMMAND="python vision.py -m google/paligemma2-10b-ft-docci-448 -A flash_attention_2"  # test fail❌, time: 29.0s, mem: 20.2GB, 7/13 tests passed, (129/9.1s) 14.1 T/s
        #CLI_COMMAND="python vision.py -m internlm/internlm-xcomposer2d5-7b -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test fail❌, time: 2.8s, mem: 9.1GB, 1/13 tests passed
        #CLI_COMMAND="python vision.py -m internlm/internlm-xcomposer2d5-7b -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 31.2s, mem: 28.4GB, 13/13 tests passed, (56/8.1s) 6.9 T/s
        #CLI_COMMAND="python vision.py -m internlm/internlm-xcomposer2-4khd-7b -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 21.7s, mem: 21.5GB, 13/13 tests passed, (46/7.1s) 6.5 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-1.5-13b-hf -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 11.1s, mem: 9.5GB, 13/13 tests passed, (58/3.1s) 18.5 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-1.5-13b-hf -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 8.9s, mem: 26.5GB, 13/13 tests passed, (59/2.5s) 23.7 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-1.5-7b-hf -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 9.1s, mem: 5.7GB, 13/13 tests passed, (62/2.6s) 23.4 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-1.5-7b-hf -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 7.5s, mem: 14.4GB, 13/13 tests passed, (65/2.1s) 31.2 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-34b-hf -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 52.2s, mem: 22.5GB, 13/13 tests passed, (184/16.7s) 11.0 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-34b-hf -A flash_attention_2"  # test pass✅, time: 73.2s, mem: 67.3GB, 13/13 tests passed, (246/23.8s) 10.3 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-vicuna-13b-hf -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 14.8s, mem: 12.8GB, 13/13 tests passed, (55/4.4s) 12.5 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-vicuna-13b-hf -A flash_attention_2"  # test pass✅, time: 14.2s, mem: 30.1GB, 13/13 tests passed, (55/4.3s) 12.9 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-vicuna-7b-hf -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 14.9s, mem: 7.9GB, 13/13 tests passed, (88/4.4s) 20.0 T/s
        #CLI_COMMAND="python vision.py -m llava-hf/llava-v1.6-vicuna-7b-hf -A flash_attention_2"  # test pass✅, time: 11.4s, mem: 16.5GB, 13/13 tests passed, (82/3.3s) 24.7 T/s
        #CLI_COMMAND="python vision.py -m lmms-lab/llava-onevision-qwen2-0.5b-ov -A flash_attention_2"  # test pass✅, time: 8.1s, mem: 9.3GB, 13/13 tests passed, (37/2.3s) 16.4 T/s
        #CLI_COMMAND="python vision.py -m lmms-lab/llava-onevision-qwen2-7b-ov -A flash_attention_2"  # test pass✅, time: 18.0s, mem: 22.4GB, 13/13 tests passed, (51/5.5s) 9.3 T/s
        #CLI_COMMAND="python vision.py -m meta-llama/Llama-3.2-11B-Vision-Instruct -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 34.9s, mem: 8.9GB, 13/13 tests passed, (331/16.9s) 19.6 T/s
        #CLI_COMMAND="python vision.py -m meta-llama/Llama-3.2-11B-Vision-Instruct -A flash_attention_2"  # test pass✅, time: 27.4s, mem: 22.5GB, 13/13 tests passed, (215/9.9s) 21.7 T/s
        #CLI_COMMAND="python vision.py -m meta-llama/Llama-3.2-90B-Vision-Instruct -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 151.9s, mem: 51.0GB, 13/13 tests passed, (171/30.2s) 5.7 T/s
        #CLI_COMMAND="python vision.py -m microsoft/Florence-2-base-ft -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 3.1s, mem: 1.1GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m microsoft/Florence-2-base-ft -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 2.5s, mem: 1.4GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m microsoft/Florence-2-large-ft -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 3.0s, mem: 1.6GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m microsoft/Florence-2-large-ft -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 2.3s, mem: 2.6GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m microsoft/Phi-3-vision-128k-instruct -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 12.2s, mem: 6.8GB, 13/13 tests passed, (51/3.6s) 14.2 T/s
        #CLI_COMMAND="python vision.py -m microsoft/Phi-3-vision-128k-instruct -A flash_attention_2"  # test pass✅, time: 9.0s, mem: 11.8GB, 13/13 tests passed, (37/2.6s) 14.4 T/s
        #CLI_COMMAND="python vision.py -m microsoft/Phi-3.5-vision-instruct -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 8.4s, mem: 4.8GB, 13/13 tests passed, (37/2.3s) 15.9 T/s
        #CLI_COMMAND="python vision.py -m microsoft/Phi-3.5-vision-instruct -A flash_attention_2"  # test pass✅, time: 8.1s, mem: 9.6GB, 13/13 tests passed, (41/2.3s) 18.0 T/s
        #CLI_COMMAND="python vision.py -m mistralai/Pixtral-12B-2409"  # test pass✅, time: 19.3s, mem: 35.9GB, 13/13 tests passed
        #CLI_COMMAND="python vision.py -m mx262/MiniMonkey -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 7.9s, mem: 7.8GB, 13/13 tests passed, (37/2.2s) 16.5 T/s
        #CLI_COMMAND="python vision.py -m mx262/MiniMonkey -A flash_attention_2"  # test pass✅, time: 7.2s, mem: 9.8GB, 13/13 tests passed, (37/2.0s) 18.5 T/s
        #CLI_COMMAND="python vision.py -m openbmb/MiniCPM-V-2_6-int4 -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 15.4s, mem: 9.7GB, 13/13 tests passed, (86/4.3s) 19.9 T/s
        #CLI_COMMAND="python vision.py -m openbmb/MiniCPM-V-2_6 -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 14.4s, mem: 9.9GB, 13/13 tests passed, (92/3.8s) 24.0 T/s
        #CLI_COMMAND="python vision.py -m openbmb/MiniCPM-V-2_6 -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 12.5s, mem: 19.3GB, 13/13 tests passed, (103/3.4s) 29.9 T/s
        #CLI_COMMAND="python vision.py -m openbmb/MiniCPM-Llama3-V-2_5 -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 26.2s, mem: 9.3GB, 13/13 tests passed, (61/7.9s) 7.7 T/s
        #CLI_COMMAND="python vision.py -m openbmb/MiniCPM-Llama3-V-2_5 -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 27.2s, mem: 19.3GB, 13/13 tests passed, (77/8.0s) 9.6 T/s
        #CLI_COMMAND="python vision.py -m qnguyen3/nanoLLaVA -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 8.9s, mem: 7.6GB, 13/13 tests passed, (45/1.7s) 25.8 T/s
        #CLI_COMMAND="python vision.py -m qnguyen3/nanoLLaVA -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 7.3s, mem: 8.2GB, 13/13 tests passed, (63/1.7s) 37.8 T/s
        #CLI_COMMAND="python vision.py -m qnguyen3/nanoLLaVA-1.5 -A flash_attention_2 --device-map cuda:0 --load-in-4bit"  # test pass✅, time: 7.4s, mem: 7.6GB, 13/13 tests passed, (48/1.7s) 28.0 T/s
        #CLI_COMMAND="python vision.py -m qnguyen3/nanoLLaVA-1.5 -A flash_attention_2 --device-map cuda:0"  # test pass✅, time: 6.9s, mem: 8.2GB, 13/13 tests passed, (52/1.5s) 35.3 T/s
        #CLI_COMMAND="python vision.py -m qresearch/llama-3-vision-alpha-hf --device cuda:0 --load-in-4bit"  # test pass✅, time: 11.4s, mem: 6.9GB, 13/13 tests passed, (69/3.1s) 22.0 T/s
        #CLI_COMMAND="python vision.py -m qresearch/llama-3-vision-alpha-hf --device cuda:0"  # test pass✅, time: 8.9s, mem: 16.8GB, 13/13 tests passed, (75/2.6s) 28.6 T/s
        #CLI_COMMAND="python vision.py -m rhymes-ai/Aria -A flash_attention_2"  # test pass✅, time: 70.6s, mem: 48.8GB, 13/13 tests passed, (210/22.1s) 9.5 T/s
        #CLI_COMMAND="python vision.py -m vikhyatk/moondream2 -A flash_attention_2 --load-in-4bit"  # test pass✅, time: 5.5s, mem: 2.8GB, 13/13 tests passed, (63/1.5s) 41.0 T/s
        #CLI_COMMAND="python vision.py -m vikhyatk/moondream2 -A flash_attention_2"  # test pass✅, time: 4.5s, mem: 4.6GB, 13/13 tests passed, (63/1.3s) 50.3 T/s
      };
      # extraDevices = [
      #   {
      #     path = "/dev/nvidia0";
      #     majorDeviceNumber = 195;
      #     minorDeviceNumber = 254;
      #   }
      #   {
      #     path = "/dev/nvidiactl";
      #     majorDeviceNumber = 195;
      #     minorDeviceNumber = 253;
      #   }
      # ];
      extraOptions = [
        "--gpus=all"
      ];
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-openedai-vision" = {
      wantedBy = mkForce [];
      enable = false;
    };

    systemd.services.openedai-vision-init = {
      enable = true;

      wantedBy = [
        "${config.virtualisation.oci-containers.backend}-openedai-vision.service"
      ];

      script = ''
        umask 077
        mkdir -p /var/lib/openedai-vision/hf_home
        umask 066
      '';

      serviceConfig = {
        User = "openedai-vision";
        Group = "openedai-vision";
        Type = "oneshot";
        RemainAfterExit = true;
        StateDirectory = "openedai-vision";
        StateDirectoryMode = "0700";
      };
    };
  };
}
