{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "America/Los_Angeles";

  environment = {
    motd = ''
      Fiat Nix!
    '';
    etcBackupExtension = ".bak";
    packages = with pkgs; [
      any-nix-shell
      eza
      vim
      nyancat
      neovim
      git
      gnumake
      openssh
      fastfetch
      which
      yazi
      zed
      zip
      unzip
    ];
  };

  user.shell = "${pkgs.fish}/bin/fish";

  terminal = {
    font = "${
      pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }
    }/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf";
    colors = {
      background = "#000000"; # Black
      foreground = "#CCCCCC"; # Grey
      cursor = "#FFFFFF"; # White

      # 基础 8 色 (暗色系)
      color0 = "#000000"; # Black
      color1 = "#AA0000"; # Red
      color2 = "#00AA00"; # Green
      color3 = "#AA5500"; # Yellow (Brown)
      color4 = "#0000AA"; # Blue
      color5 = "#AA00AA"; # Magenta
      color6 = "#00AAAA"; # Cyan
      color7 = "#AAAAAA"; # White (Light Gray)

      # 亮色 8 色 (高亮系)
      color8 = "#555555"; # Dark Gray
      color9 = "#FF5555"; # Light Red
      color10 = "#55FF55"; # Light Green
      color11 = "#FFFF55"; # Light Yellow
      color12 = "#5555FF"; # Light Blue
      color13 = "#FF55FF"; # Light Magenta
      color14 = "#55FFFF"; # Light Cyan
      color15 = "#FFFFFF"; # Bright White
    };
  };

  home-manager = {
    config =
      { ... }:
      {
        home.stateVersion = "24.05";
        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
            set fish_greeting ""
          '';
          shellAliases = {
            ll = "eza";
            tree = "eza -T";
            clock = "tty-clock -s -c -C 6 -t ";
          };
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        programs.starship = {
          enable = true;
          settings = {
            format = ''
              [┌───\(](blue)[$username@$hostname](bold white)[\)-\[](blue)[$directory](bold white)[\]](blue)$all[└─](blue)$character
            '';
            character = {
              format = "$symbol ";
              success_symbol = "[\\$](bold white)";
              error_symbol = "[\\$](bold red)";
            };
            username = {
              show_always = true;
              format = "[$user]($style)";
              style_root = "bold red";
              style_user = "bold white";
            };
            hostname = {
              ssh_only = false;
              format = "[$ssh_symbol$hostname]($style)";
              style = "bold white";
            };
            directory = {
              format = "[$path]($style)[$read_only]($read_only_style)";
              style = "bold white";
              read_only = "󰌾";
              read_only_style = "green";
              truncation_length = 0;
            };
            git_status = {
              style = "bold cyan";
            };
            git_branch = {
              format = " [$symbol$branch(:$remote_branch)]($style) ";
              style = "bold cyan";
            };
            add_newline = false;
            scan_timeout = 30;
          };
        };

        programs.zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

      };
    backupFileExtension = "backup";
    useGlobalPkgs = true;
  };
}
