{ config, options, lib, myLib, pkgs, pkgs-stable, inputs, ... }:

with lib;
with myLib;

let
  cfg = config.personal.minecraft-servers;
  nginxCfg = config.personal.reverse-proxy;
in
{
  options.personal.minecraft-servers = {
    enable = mkEnableOption "minecraft-servers";
  };

  config = mkIf cfg.enable {
    services.gatus.settings.endpoints = [
      {
        name = "Minecraft";
        url = "tcp://127.0.0.1:25565";
        interval = "5m";
        conditions = [ "[STATUS] == 200" "[RESPONSE_TIME] < 300" ];
      }
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/var/lib/minecraft-servers";
      servers.fabric = {
        enable = true;

        package = pkgs.fabricServers.fabric-1_20_1;

        jvmOpts = [
          "-Xms5G" # Initial heap size
          "-Xmx12G" # Maximum heap size
        ];

        serverProperties = {
          motd = "Bienvenidos Tomacindors! La familia elegida";
          max-players = 20;
          online-mode = false; # Set to false if you want to allow cracked clients
          difficulty = "normal"; # Options: peaceful, easy, normal, hard
          white-list = true; # Enable whitelist
        };

        # Specify the custom minecraft server package
        # package = pkgs.fabricServers.fabric-1_20_1.override {
        #   loaderVersion = "0.16.10";
        # }; # Specific fabric loader versionsha512-Yzs2xhyCW+mY5sfTC5FjjobIZjg5wH3nOeGzWtVKl7yM285VbRl06LK8gIU+nIGPFvKgrNo7Tfmg+LKKCDwu1A==

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              Fabric-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/UapVHwiP/fabric-api-0.92.6%2B1.20.1.jar";
                sha512 = "sha512-K9LtDO4iMFt/9JWXwQOlfI++X2S+VKkGeW1ItYmGJibJUf9Mv1yx7XZKTWR51pwwd1lOaTt6KRJA7uorsxMrDA==";
              };
              EasyWhitelist = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LODybUe5/versions/9OoxSFQz/easywhitelist-1.1.0.jar";
                sha512 = "sha512-Yzs2xhyCW+mY5sfTC5FjjobIZjg5wH3nOeGzWtVKl7yM285VbRl06LK8gIU+nIGPFvKgrNo7Tfmg+LKKCDwu1A==";
              };
              accessories = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/jtmvUHXj/versions/BmhkZr5J/accessories-fabric-1.0.0-beta.47%2B1.20.1.jar";
                sha512 = "sha512-JE6pn1DY685mUmTnjWRoZ2r4pWOa+C4nJcT/2ZLNM0fm2BTtKdiUFtcBOCgaFayi5cF8q2y8ixhubCrBOf8WLA==";
              };
              appliedenergistics2 = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/XxWD5pD3/versions/ZJYegSUG/appliedenergistics2-fabric-15.4.6.jar";
                sha512 = "sha512-6Vgo2mqt41LOYhYcAOiL/cxsk1q7sP8nH6j+0R/fqrtYq7kdvWlKiNKvSLjpAILKEtFlAWxAZZUw65yJXExaXA==";
              };
              aether = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/YhmgMVyu/versions/vRtYRS6T/aether-1.20.1-1.5.2-beta.8-fabric.jar";
                sha512 = "sha512-Vye4sABZWe8BttgIvJtzuVir3iG6VDYiJyS0EnGsImtFLo0ZVp/WiwOupKsSIDo1OrmqqdYByjbNcl/fTZQfqA==";
              };
              aquamirae = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/k23mNPhZ/versions/ouUaC54p/Aquamirae-6.jar";
                sha512 = "sha512-wEcGP7e1TPEHVUmSqTQUcMYiwXiomhE1ySBLNHA0v538dX8J8flvzCCFKGjAwR+xjKcVHsDiuHVW9RYBGw9ZsQ==";
              };
              balm = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/x05ZVyBJ/balm-fabric-1.20.1-7.3.31.jar";
                sha512 = "sha512-xM9wCMp9lU7V/BC0Y048RdijbVzAvYRs71gPPh/rgaTXALHlApoVTldENHBmKlb8vIQhF6L1WUfryQzVsIGoIw==";
              };
              bclib = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/BgNRHReB/versions/TPC86Pyz/bclib-3.0.14.jar";
                sha512 = "sha512-vDXMN6Ih+8b3/KKT5yqtCHfYydBwZ/8LTI9R3N27gqx8u7htFVDu92kLzR7PCWJfA4nzmumiUu7F2FEbp97sSg==";
              };
              better-end = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gc8OEnCC/versions/7QwyTILr/better-end-4.0.11.jar";
                sha512 = "sha512-X6rlyz2HWYN+w0HGBd2ci2syqQjn4fEkizslZ8X5lpB53zNpTN+2x0OnMr/J1YJIQ6k+3sB/CeaPi0CONV0V5w==";
              };
              BOMD = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/du3UfiLL/versions/yoCCX4Cc/BOMD-1.7.5-1.20.1.jar";
                sha512 = "sha512-RFUkfxZSzwl72rRFRn16sfGuWMa1lN4O9RGPyQjjLKiIEQvkA23ZQSVtOpV0mT+LESKkpvkNGV4vFC8W8xInpw==";
              };
              cardinal-components-api = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/K01OU20C/versions/Ielhod3p/cardinal-components-api-5.2.3.jar";
                sha512 = "sha512-8gSE1bx4C+6bOI/2B158O9Ewx/jK51pCW/0fto0DyhkojAmwcpmSmH/TLzokM7ScJRYuCG3oKr2NBu5F5OPJFw==";
              };
              carry-on = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/joEfVgkn/versions/Mkla4B3q/carryon-fabric-1.20.1-2.1.2.7.jar";
                sha512 = "sha512-ypb1bbpQ6kgn7HoVvFkMyymroBiWVQ08s5i+0YrN9GndNRzckxLkdD9UlVsxYudExY12yI63mx5eW0Vw9bM8ZA==";
              };
              collective = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/P0uRrvF9/collective-1.20.1-8.3.jar";
                sha512 = "sha512-ESY9tollvX1ycoTs/YQEfQCFxkevGqiQOJaUZRV0KuXO0hzztGSX3PXjX/Hw22RtrSvDMLnDmXz3WzBNNOT3RQ==";
              };
              comforts = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/SaCpeal4/versions/pMr60Kkq/comforts-fabric-6.4.0%2B1.20.1.jar";
                sha512 = "sha512-wXljeLR6oDVEt3LStjHXOH5DZboMCjRo3F54NI0m4EBr0BW1MOCsq2eeCQMQqv0gGhBuUZ07njKybg25kosEvg==";
              };
              doubledoors = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/JrvR9OHr/versions/F3Sryqc5/doubledoors-1.20.1-7.1.jar";
                sha512 = "sha512-1dZJEh5WInZCsxcb3lNZSNvcKU0hVJjhcydFbhy3sH7GxUyW00Che59JLHijLiby0kMVnfQYdrXfOTPJUxQl9g==";
              };
              cloth-config = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9s6osm5g/versions/2xQdCMyG/cloth-config-11.1.136-fabric.jar";
                sha512 = "sha512-LahcBxyFQiPMMMjkZ5Q5G3flPyjs273lncg7Pbvfx0vp5o2p7UZOf5i0NhAziZuk9oHr/x817cLGDlmaWXlvHA==";
              };
              DungeonsArise = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8DfbfASn/versions/Vd5XOXlj/DungeonsArise-1.20.1-2.1.57-fabric-release.jar";
                sha512 = "sha512-g1Ce1iQjbDIneQbYo5qBxV3rWxN4JQarpaZ3KNhhX5zOdmcf1SdDyqpNF1Fkc/4kizFUQAFGrbq6pDamUqqYNw==";
              };
              DungeonsAriseSevenSeas = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ZsrrjDbP/versions/ZQjAxRej/DungeonsAriseSevenSeas-1.20.x-1.0.2-fabric.jar";
                sha512 = "sha512-JmjxOSE383E2YbwM+GBEQfQ2W9GaWX1a90dXFFPPJWMRFx7mY599KJJAZwdK0yQzNuG/NCDFWquSMCgc6jXV2g==";
              };
              fabric-language-kotlin = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/mccDBWqV/fabric-language-kotlin-1.13.4%2Bkotlin.2.2.0.jar";
                sha512 = "sha512-Jra0SZv4cuvCxmYiey7XIc4OM6josZYylxJQ5ctuC581rvFaB85Tz0dVKF2dOMTgWl8TV7rVRNRLnjC4fAoAVQ==";
              };
              FarmersDelight = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/7vxePowz/versions/PB4pwRax/FarmersDelight-1.20.1-2.4.0%2Brefabricated.jar";
                sha512 = "sha512-KYpBb1cYkm37glclcF87qisbGuDYRi3z+gyg+dn2gVcO9DG57DfgzbUsgsGVxtAQZxpeKyNfoYLEvL+cKXjbeQ==";
              };
              geckolib = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/ezKSGafs/geckolib-fabric-1.20.1-4.7.2.jar";
                sha512 = "sha512-Iufln0xwj5J/DnwX6SSRoluyM+z8aZO28B1/bBqf4OiOsfCl8BmhvB1gCVp3uIvpA+flsBMuIU1DxbooCH8A9w==";
              };
              Incendium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ZVzW5oNS/versions/uUqarp2H/Incendium_1.20.x_v5.3.5.jar";
                sha512 = "sha512-BJRNy/Oqfujqh4VUngD3SkF8oXqldgWT45CQczqwqeOOvOB45PWvVEAwdZpUWcNxADYB/1p/7rvAl2X4xxK7JQ==";
              };
              jei = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/MMnbcAih/jei-1.20.1-fabric-15.20.0.112.jar";
                sha512 = "sha512-wT+6tnZK7H+PKerOI1kq6rryrfGqA69z6ZauzrLVU0hfqUthYodEZLs6tB5w80SO0sQlU+7Lyu+mgvD6AV3K5A==";
              };
              journeymap = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/ThfZM7jC/journeymap-1.20.1-5.10.3-fabric.jar";
                sha512 = "sha512-Dm1+WhefzFMe6hmsUzO5CrxFvxpbY9rd9SZroU4xfqsWDSCVkt2pWTV14LQ0ZgQhW6lL4DfLKrGRDbKattY6dQ==";
              };
              architectury = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/WbL7MStR/architectury-9.2.14-fabric.jar";
                sha512 = "sha512-TLjwCf1SLWinldLPWmV72+JIsyunwzzZaPWrUh6dYOGY+KP2xQ59lgorj1A3URa+DbH9RLVxDqdYaX2Opw0V3g==";
              };
              letsdo-api = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/4XJZeZbM/versions/kD7KNe4P/letsdo-API-fabric-1.2.15-fabric.jar";
                sha512 = "sha512-tRijanu7wNAz4+mJoMKsv84u0LaMOnOLZvLOVE+GkwIARs+633tO5NhVtVfFdoBz7BjW8tvhaCW3FcYH7GhbCg==";
              };
              letsdo-bakery = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/WFwYiVoG/versions/Fywe1lBT/letsdo-bakery-fabric-1.1.15.jar";
                sha512 = "sha512-xmowypw9KtOAi/sLniJYsrf0F8kjH7r5X42qYxMxMZ3F3ytHoU6/Bim4ZZn/0tmWOnQ2FA1DNsAYi6mDgZnN7A==";
              };
              letsdo-brewery = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/cV5LQXKx/versions/bNIWDoVP/letsdo-brewery-fabric-1.1.9.jar";
                sha512 = "sha512-SDsYoa9IKQ6/6aMQcR4w0JnJ14FIdVZ2g8CF+7UPgIi8P6/OtBKvHsTDS4T91e9TC7rkHqTMjfoihcZBlBa8Rw==";
              };
              letsdo-vinery = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1DWmBJVA/versions/WdjalkV8/letsdo-vinery-fabric-1.4.39.jar";
                sha512 = "sha512-i2pVuRSVMd/d6KFTkf8qq1aMXxpJ0Ng3pEIewj/p9Jqb1AlO0ZdXzJj0zsPAw00CSLEWA2tOTKdl0oT+WB+3oA==";
              };
              moonlight = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/twkfQtEc/versions/pCCm0cDl/moonlight-1.20-2.14.13-fabric.jar";
                sha512 = "sha512-vwspjzaC4BQyq19BuGMepmkMt8AAmh92viKZPn7+9nXulK4XmMfEnw9KIjzl9pZXl+1zEdaJvGyFK4oTPIFwDQ==";
              };
              MouseTweaks = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/aC3cM3Vq/versions/mjuG4AYd/MouseTweaks-fabric-mc1.20-2.26.jar";
                sha512 = "sha512-0PryAN2jWO/drS0oCfZGAj9N0GJUVyNp4H878zy2lB8PzbAttGdbMLTzvVQsv2GW4TVoC6kaK3TCsHHzSXji1Q==";
              };
              Obscure = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fU7jbFHc/versions/IWDYxZre/Obscure-API-16.jar";
                sha512 = "sha512-8JmNaRdAY0IAeP6W/5BGZaM/OVBHVTbIyo8L2kVBfvlKdVmNQXr0MC6S1qWerR6n5nIQYrU4+YH19N0W6MHFsQ==";
              };
              supplementaries = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fFEIiSDQ/versions/f3JSuj35/supplementaries-1.20-3.1.36-fabric.jar";
                sha512 = "sha512-MhHIYm8DG7YYsn/JiXNmQ4DJhJJWWIi0IZmYJOuGfkxocKdMVgxP+jzC3S8/kkezeCjJ1vVmzYewpzICMjoCTQ==";
              };
              waystones = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LOpKHB2A/versions/Q7vns7oI/waystones-fabric-1.20.1-14.1.13.jar";
                sha512 = "sha512-j8Z1ofamq8l6CFqpd1Kfymzpf/T2JoewxHkhMvoEt1ZkKMnhHRyOH/DFi3bxq5uePePM0P6ECjTCWC37tDcG1g==";
              };
              gravestones = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/Heh3BbSv/versions/MbhKsCJV/gravestones-1.0.12-1.20.1.jar";
                sha512 = "sha512-IGBuFolIslY+yVYokNhiG8CMAquXa5e/q3hS9p1blg9rNGuASoi+Z+deCcXei0AMCm2yROrVYmrrRDiE27PZ6Q==";
              };
              bag-of-holding = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/qbqWvc0D/versions/sxjgmBCY/BagOfHolding-v8.0.2-1.20.1-Fabric.jar";
                sha512 = "sha512-VjAkMmTv9wLtYU1c/UYiVqatU9qnJZr45JyMOJUZ4MJWlIvljTMmeXWjMqUDJ9n7jgrosdoHzGFUXx6WHQe2HQ==";
              };
              pneumonocore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ZLKQjA7t/versions/MtM4xjYo/pneumonocore-1.1.4%2B1.20.1.jar";
                sha512 = "sha512-576LR/b51YcTZ8Pp3UP2uVKMh8A7C3iAh1KL3Y4ZeYEmZh2M8Pb9H8wiYRXt8hFK0ef6oW3hkidoXd5ObRbiZg==";
              };
              configurabledespawntimer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9olMJ5Qp/versions/AhKpJOKA/configurabledespawntimer-1.20.1-4.3.jar";
                sha512 = "sha512-EIl89GKgRIA6u7UkW9l7NjeVlVcChWToZZaZosvOKhtKmmYiTx8H0L+0xFkRKnokbS3YFO3u0r5vcPSNxXS7cg==";
              };
              artifacts = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P0Mu4wcQ/versions/jf0yT7BF/artifacts-fabric-9.5.15.jar";
                sha512 = "sha512-MXwfWntI0AOlmwTMAHlSmb59CVDvg08p2d2LwaDQL7K5JBtO47vKdXpw1uwzhoDJqPUxyBoeqtPncShSc30EZA==";
              };
              polymorph = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/tagwiZkJ/versions/oARBy1is/polymorph-fabric-0.49.10%2B1.20.1.jar";
                sha512 = "sha512-Kkq3K/apJURf5KhRNyDib/1HvaPhTsWXeAm1MxAeGjhdWpxzurOy1MakFCHxPu62ZdqwRAxt/Ra6GiRkxG37vg==";
              };
              trinkets = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/5aaWibi9/versions/AHxQGtuC/trinkets-3.7.2.jar";
                sha512 = "sha512-vt+XyHxeVWQWQQJnEIrTWLMoBkSL4k74rhp5rGO3i0i5yFHADIRbiu38eAVgE4VCBxa55lMm/ashNA6Lo8xCdA==";
              };
              puzzleslib = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/QAGBst4M/versions/RbcWdHr1/PuzzlesLib-v8.1.32-1.20.1-Fabric.jar";
                sha512 = "sha512-NA9e5jeoo1ss5msv2gsugp5YuNzERYVqdjX093rXnIlKOO4mwlnUbDlztyuFk+slsH2EhNKri+vh2rlJ8Vz0VA==";
              };
              forgeconfigapiport = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ohNO6lps/versions/1aKtMQZE/ForgeConfigAPIPort-v8.0.2-1.20.1-Fabric.jar";
                sha512 = "sha512-x0/aTCX0Lxgsrk7yq6zraZLxQBWpuXVwRgyY887BXbb38oBvlw76HRD/q2LdUCV/hIbLWG2hKUWSJeOqjbca4A==";
              };
            }
          );
        };
      };
    };

    # users.users.minecraft = {
    #   isSystemUser = true;
    #   group = "minecraft";
    #   uid = 1003; # Ensure this matches your system's user ID for minecraft-servers
    # };
    # users.groups.minecraft = {
    #   gid = 1000; # Ensure this matches your system's group ID for minecraft-servers
    # };

    # Ensure the state directory exists
    # systemd.tmpfiles.rules = [
    #   "d /run/minecraft 0755 minecraft minecraft -"
    #   "d /var/lib/minecraft-servers 0755 minecraft minecraft -"
    # ];
  };
}
