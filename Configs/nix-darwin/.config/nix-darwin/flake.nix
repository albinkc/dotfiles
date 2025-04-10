{
  description = "Moi nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {

          # Let determinate handle nix
          nix.enable = false;

          environment.etc.nix-darwin.source = "/Users/albin/.config/nix-darwin";

          networking = {
            knownNetworkServices = [
              "Wi-Fi"
              "Ethernet Adaptor"
              "Thunderbolt Bridge"
            ];
            localHostName = "Albins-MacBook-Pro";
            dns = [
              "1.1.1.2"
              "1.0.0.2"
            ];
          };

          environment.variables = {
            EDITOR = "nvim";
            VISUAL = "nvim";
            ERL_AFLAGS = "-kernel shell_history enabled";
          };

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = with pkgs; [
            nixfmt-rfc-style # nix formatting
            git
            vim
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
            difftastic
            # uv
            # asahi-bless #not supported on macOS
            # JS
            # nodePackages_latest.nodejs
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
            # ast-grep # sg command not working on nix, brew for now
            mpv
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableFzfCompletion = true;
            enableFzfHistory = true;
            enableFastSyntaxHighlighting = true;
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          security.pam.services.sudo_local.touchIdAuth = true;

          system.activationScripts = {
            postUserActivation = {
              text = ''
                # Following line should allow us to avoid a logout/login cycle
                /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

                # Create Screenshots directory if it doesn't exist
                mkdir -p "$HOME/Pictures/screenshots"
              '';
            };
          };
          homebrew = {
            enable = true;
            caskArgs.no_quarantine = true;

            taps = [
              # "seatedro/glimpse"
            ];
            brews = [
              {
                name = "neovim";
                args = [ "HEAD" ];
              }
              "zsh-completions"
              "luarocks"
              "mise"
              "ast-grep"
              # "elixir-ls"
              # "glimpse"
              "unisonweb/unison/unison-language"
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
              # "Yomu EBook Reader" = 562211012;
              "The Unarchiver" = 425424353;
              "WireGuard" = 1451685025;
              "Xmind: Mind Map" = 1327661892;
            };
            casks = [
              "lulu"
              "iina"
              "karabiner-elements"
              "firefox"
              "zen-browser"
              "eloston-chromium"
              # "zed"
              "ghostty"
              "warp"
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
              "postico"
              "postgres-unofficial"
              "leader-key"
              #utilities
              "vivid"
              # "whatroute"
              # "chronycontrol"
              "logseq"
              "freedom"
              "livebook"
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
                  "60" = {
                    enabled = false;
                  };
                };
              };
              "com.apple.desktopservices" = {
                # Avoid creating .DS_Store files on network or USB volumes
                DSDontWriteNetworkStores = true;
                DSDontWriteUSBStores = true;
              };
              # larger screen size for iphone mirroring
              "com.apple.ScreenContinuity" = {
                lastWindowScalingPreset = 1;
              };

              "cx.c3.theunarchiver" = {
                selectExtractedItem = 0;
                AdditionalAnalyticsEnabled = 0;
                AnalyticsEnabled = 0;
              };

              "com.apple.systemsound" = {
                com.apple.sound.uiaudio.enabled = 0; # check
              };
              # "com.apple.Safari" = {
              #   # Privacy: don’t send search queries to Apple
              #   UniversalSearchEnabled = false;
              # };

              # IINA settings
              "com.colliderli.iina" = {
                enableAdvancedSettings = 1;
                useUserDefinedConfDir = 1;
                userDefinedConfDir = "~/.config/mpv";
              };

              # Tot
              "com.iconfactory.Tot" = {
                hideDockIcon = 1;
                smartIcons = 0;
                hideToutIOS = 1;
              };
            };

            alf = {
              globalstate = 1;
              stealthenabled = 1;
            };

            SoftwareUpdate = {
              AutomaticallyInstallMacOSUpdates = true;
            };

            NSGlobalDomain = {
              # Enable Spring-loading of directories
              # TODO Not working need to fix
              "com.apple.springing.enabled" = true;
              "com.apple.springing.delay" = 0.5;
              # TODO "com.apple.trackpad.scaling" = 3.0;

              # Metric FTW
              AppleMetricUnits = 1;
              AppleMeasurementUnits = "Centimeters";
              AppleTemperatureUnit = "Celsius";
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
              # AppleKeyboardUIMode = 2;

            };
            dock = {

              # this one saved my sanity
              mru-spaces = false;
              minimize-to-application = true;
              autohide = true;
              autohide-delay = 0.0;
              autohide-time-modifier = 0.2;
              expose-animation-duration = 0.2;
              tilesize = 48;
              show-recents = false;
              showhidden = true;
              scroll-to-open = true;
              persistent-apps = [
                "/Applications/Zen.app"
                "/Applications/Firefox.app"
                "/Applications/Ghostty.app"
                "/Applications/Neovide.app"
              ];
              # persistent-others = [
              # "~/projects/"
              # ];
              # Group windows by app in expose / for aerospace
              expose-group-apps = true;

              # disable quick note bottom right hot corner
              wvous-br-corner = 1;
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

            menuExtraClock = {
              ShowAMPM = true;
              FlashDateSeparators = true;
            };

            CustomSystemPreferences = {
              "com.apple.Safari" = {
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
              };

              # App Store
              "com.apple.AppStore" = {
                InAppReviewEnabled = 1;
              };
            };
            CustomUserPreferences = {
              # Turn on app auto-update
              # "com.apple.commerce".AutoUpdate = true;

              NSGlobalDomain = {
                # Add a context menu item for showing the Web Inspector in web views
                WebKitDeveloperExtras = true;
                # AppleMiniaturizeOnDoubleClick = false;
                # NSAutomaticTextCompletionEnabled = true;
                # "com.apple.sound.beep.flash" = false;
                AppleKeyboardUIMode = 2;
              };

            };
          };

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."Albins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
    };
}
