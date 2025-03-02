# TODOS:
# Ctrl + Bksp = Delete
# Disable capslock delay
#   hidutil property --set '{"CapsLockDelayOverride":0}'
# Textedit
#
{
  description = "Moi nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # glimpse.url = "github:seatedro/glimpse";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      # sysctl.conf.kern.hostname = "Albins-MacBook-Pro"; TODO Figure out how to set hostname
      environment.systemPackages = with pkgs;
        [
          git
          vim
            # elixir
          jq
          zellij
          just
          bat
          nixd
          nil
          wget
          ffmpeg
          # tuckr
          broot
          eza
          yazi
          jujutsu
          skim
          asitop
          mise
          uv
          # asahi-bless #not supported on macOS

          # JS
          nodePackages_latest.nodejs
          biome

          # for lazyvim
          fzf
          ripgrep
          lazygit
          fd
          ast-grep
          viu
          chafa
          ueberzugpp

          # rust
          cargo-auditable-cargo-wrapper
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      security.pam.enableSudoTouchIdAuth = true;

      system.activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
      homebrew = {
        enable = true;
        taps = [
          # "seatedro/glimpse"
        ];
        brews = [
          # {
            # name = "neovim";
            # args = [ "HEAD" ];
          # }
          "zsh-completions"
          "luarocks"
          "elixir-ls"
          # "glimpse"
        ];
        masApps = {
          "Numbers" = 409203825;
          "Keynote" = 409183694;
          "Pages" = 409201541;
          "Tot" = 1491071483;
          "Amphetamine" = 937984704;
          "Paste - Endless Clipboard" = 967805235;
          "Whatsapp Messenger" = 310633997;
          "BBEdit" = 404009241;
          "Yomu EBook Reader" = 562211012;
          "The Unarchiver" = 425424353;
        };
        casks = [
          "lulu"
          "iina"
          "karabiner-elements"
          "firefox"
          "zed"
            # "ghostty"
          "visual-studio-code"
          "pearcleaner"
          "bartender"
          "libreoffice"
          "protonvpn"
          "neovide"
          "qbittorrent@lt20"
          "transmission"
          "github"
          # "ciphey" # for fun
          "postgres-unofficial"
          "postico"
          #utilities
          "whatroute"
          "chronycontrol"
        ];
      };
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      system = {
        startup.chime = false;
      };

      system.defaults = {
          CustomUserPreferences = {
            # Disable System Ctrl+Space so that VSCODE/Zed's works
            "com.apple.symbolichotkeys" = {
              AppleSymbolicHotKeys = {
                "60" = { enabled = false; };
              };
            };
          };

      # TODO: enable keyboard navigation

        SoftwareUpdate = {
          AutomaticallyInstallMacOSUpdates = true;
        };

        NSGlobalDomain = {
          # TODO "com.apple.trackpad.scaling" = 3.0;

          # Disable autocorrect and friends
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;

          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSDocumentSaveNewDocumentsToCloud = false;
          # speed up animation on open/save boxes (default:0.2)
          NSWindowResizeTime = 0.001;
          # when the below is on, it means you can hold cmd+ctrl and click anywhere on a window to drag it around
          # NSWindowShouldDragOnGesture = true; # dud
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;

          # enable key-repeat
          ApplePressAndHoldEnabled = false;
          # delay before repeating keystrokes
          InitialKeyRepeat = 14;
          # delay between repeated keystrokes upon holding a key
          KeyRepeat = 1;

          # testing-1
          AppleSpacesSwitchOnActivate = true;

          # Enable keyboard navigation
          # TODO: Open PR/issue on nix-darwin
          # Values should be {0,2}, but ND says {0,3}
          # AppleKeyboardUIMode = 3;

        };
        dock = {

          # this one saved my sanity
          mru-spaces = false;
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.2;
          expose-animation-duration = 0.2;
          tilesize = 48;
          show-recents = false;
          scroll-to-open = true;
          persistent-apps = [
            /Applications/Firefox.app
            /Applications/Ghostty.app
            /Applications/Neovide.app
          ];
          # Group windows by app in expose / for aerospace
          expose-group-apps = true;
      	};

        finder = {
          AppleShowAllFiles = true;
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          # ShowExternalHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          # “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View,
          # “Flwv” = Gallery View
          FXPreferredViewStyle = "clmv";
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
          QuitMenuItem = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
          _FXSortFoldersFirstOnDesktop = true;
          NewWindowTarget = "Home";
        };

        WindowManager = {
          EnableStandardClickToShowDesktop = false;
          EnableTiledWindowMargins = false;
        };

        controlcenter = {
          BatteryShowPercentage = true;
        };


        trackpad = {
          Clicking = true;
          # Dragging = true; # dud
        };


        # loginwindow.LoginwindowText = "enter phone number";

        screencapture = {
          type = "png";
          location = "~/Pictures/screenshots";
          disable-shadow = true;
          include-date = false;
        };

        menuExtraClock.FlashDateSeparators = true;

        CustomUserPreferences = {
          # Turn on app auto-update
          # "com.apple.commerce".AutoUpdate = true;

          NSGlobalDomain = {
            # Add a context menu item for showing the Web Inspector in web views
            WebKitDeveloperExtras = true;
            # AppleMiniaturizeOnDoubleClick = false;
            # NSAutomaticTextCompletionEnabled = true;
            # "com.apple.sound.beep.flash" = false;
          };

          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };

          "com.apple.systemsound" = {
            com.apple.sound.uiaudio.enabled = 0; # check
          };
          # "com.apple.Safari" = {
          #   # Privacy: don’t send search queries to Apple
          #   UniversalSearchEnabled = false;
          # };

        };
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Macbook
    darwinConfigurations."Macbook" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
