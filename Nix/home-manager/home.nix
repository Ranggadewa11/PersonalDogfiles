{ config, pkgs, inputs, ... }:

{
  # =========================
  # HOME
  # =========================
  home.username = "dewtf";
  home.homeDirectory = "/home/dewtf";
  home.stateVersion = "26.05";

  programs.fish = {
  enable = true;

  # =========================
  # PATH (Nix aware)
  # =========================
  shellInit = ''
    fish_add_path $HOME/.nix-profile/bin
    fish_add_path /etc/profiles/per-user/$USER/bin
    fish_add_path /run/current-system/sw/bin

    set -gx EDITOR hx
    set -gx VISUAL hx
    set -gx PAGER bat
    set -gx BAT_THEME Catppuccin-mocha
  '';

  # =========================
  # INTERACTIVE CONFIG
  # =========================
  interactiveShellInit = ''
    # Disable greeting
    set -g fish_greeting

    # Fish default bindings
    set -g fish_key_bindings fish_default_key_bindings

    # Accept autosuggestion → →
    bind \e\[C accept-autosuggestion

    # History search ↑ ↓ (fish-like)
    bind \e\[A history-prefix-search-backward
    bind \e\[B history-prefix-search-forward

    # ===== FZF (Catppuccin Mocha) =====
    set -gx FZF_DEFAULT_OPTS "
      --height=40%
      --layout=reverse
      --border
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5c2e7,hl:#f38ba8
      --color=fg:#cdd6f4,header:#f2cdcd,info:#cba6f7,pointer:#f5c2e7
      --color=marker:#f5c2e7,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    "
  '';

  # =========================
  # ALIASES
  # =========================
  shellAliases = {
    # Core
    ll = "ls -lah";
    la = "ls -A";
    l  = "ls";
    c  = "clear";
    q  = "exit";

    # Git
    g   = "git";
    gs  = "git status";
    ga  = "git add";
    gaa = "git add .";
    gc  = "git commit";
    gcm = "git commit -m";
    gp  = "git push";
    gl  = "git pull";
    gd  = "git diff";
    glg = "git log --oneline --graph --decorate";

    # Nix
    nixs = "sudo nixos-rebuild switch --flake /etc/nixos#ax14r5";
    nixh = "home-manager switch --flake /etc/nixos#dewtf";
    nixgc = "sudo nix-collect-garbage -d";

    # Edit
    ditflake = "sudo hx /etc/nixos/flake.nix";
    dithome  = "hx ~/.config/home-manager/home.nix";
    ditconf  = "sudo hx /etc/nixos/configuration.nix";
  };

  # =========================
  # FUNCTIONS
  # =========================
    functions = {
      y = {
        description = "yazi with auto-cd";
        body = ''
          set tmp (mktemp -t yazi-cwd.XXXXXX)
          yazi --cwd-file="$tmp"
          if test -f "$tmp"
            cd (cat "$tmp")
            rm "$tmp"
          end
        '';
      };
    };
  };
  
  # =========================
  # HOME MANAGER
  # =========================
  programs.home-manager.enable = true;

  # =========================
  # PUNTEN PAKET
  # =========================
  home.packages = with pkgs; [
    ripgrep
    bat
    fastfetch
    wl-clipboard
    cliphist
    fcitx5
    satty
    slurp
    grim
    discord
    unzip
    yazi
    fzf
    typst
    typst-live
    tinymist
    inputs.zen-browser.packages."${system}".default
    # =====================
    # Go
    # =====================
    go
    gopls
    gosimports

    # =====================
    # Markdown
    # =====================
    marksman
    ltex-ls
    mpls

    # =====================
    # Web (HTML / CSS / JS / JSON)
    # =====================
    nodejs
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    # =====================
    # Python
    # =====================
    (python3.withPackages (ps: with ps; [
    pandas
    pandas-stubs
    numpy
    matplotlib
    seaborn
    plotly
    ipython
    jupyterlab
    ruff
    black
    pyright
    python-lsp-server
    pylsp-mypy
    ]))
    #RRRRRRRRRRRRRRRRRRRRRRRRRRRR    
    R
    
    # =====================
    # Rust
    # =====================
    rustc
    cargo
    rust-analyzer
    rustfmt

    # =====================
    # C
    # =====================
    clang-tools
  ];

  # =========================
  # MANGO CONFIG (LENGKAP)
  # =========================

  # systemd target mango
  xdg.configFile."systemd/user/mango-session.target".source =
    ./mango-session.target;

  # mango config folder
  xdg.configFile."mango".source =
    ./mango-conf;

  #manage-nix
  programs.nix-monitor.enable = true;
  programs.nix-monitor.rebuildCommand =[ "bash" "-c" 
             "cd /etc/nixos/" "home-manager switch --flake /etc/nixos#dewtf"
  ];

  #dms-shell
  imports = [
  inputs.dms.homeModules.dank-material-shell
  ];
  #Helix
  xdg.configFile."helix".source =
  builtins.path {
    path = ./helix-conf;
    name = "helix-conf";
  };
 }

