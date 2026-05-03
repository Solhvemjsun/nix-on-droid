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
      pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }
    }/share/fonts/truetype/NerdFonts/DejaVuSansMonoNerdFont-Regular.ttf";
colors = {
    background = "#000000"; # base00
    foreground = "#c1c8d7"; # base05
    cursor     = "#c1c8d7"; # base05

    # Normal colors
    color0  = "#000000"; # Black (base00)
    color1  = "#f71118"; # Red (base08)
    color2  = "#2cc55d"; # Green (base0B)
    color3  = "#ecb90f"; # Yellow (base09)
    color4  = "#2a84d2"; # Blue (base0D)
    color5  = "#4e59b7"; # Magenta (base0E)
    color6  = "#0f80d5"; # Cyan (base0C)
    color7  = "#c1c8d7"; # White (base05)

    # Bright colors 
    color8  = "#343d50"; # Bright Black / Gray (base03)
    color9  = "#ff0000"; # Bright Red (base12)
    color10 = "#00ff00"; # Bright Green (base14)
    color11 = "#ffff00"; # Bright Yellow (base13)
    color12 = "#0000ff"; # Bright Blue (base16)
    color13 = "#ff00ff"; # Bright Magenta (base17)
    color14 = "#00ffff"; # Bright Cyan (base15)
    color15 = "#ffffff"; # Bright White (base07)
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
