{ config, pkgs, unstable, ... }: {
  imports = [ 
    # ./firefox 
  ];

  services.glance.enable = true;
  services.glance.settings = {
    server.port = 5678;
    pages = [{
      name = "Home";
      columns = [
        {
          size = "small";
          widgets = [
            { type = "calendar"; }
            {
              type = "rss";
              limit = 10;
              collapse-after = 3;
              cache = "3h";
              feeds = [
                { url = "https://ciechanow.ski/atom.xml"; }
                # - url: https://www.joshwcomeau.com/rss.xml
                #   title: Josh Comeau
                # - url: https://samwho.dev/rss.xml
                # - url: https://awesomekling.github.io/feed.xml
                # - url: https://ishadeed.com/feed.xml
                #   title: Ahmad Shadeed
              ];
            }
            {
              type = "twitch-channels";
              channels = [
                # - theprimeagen
                # - cohhcarnage
                # - christitustech
                # - blurbs
                # - asmongold
                # - jembawls
              ];
            }
          ];
        }
        {
          size = "full";
          widgets = [
            { type = "hacker-news"; }
            {
              type = "videos";
              channels = [
                "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                "UCv6J_jJa8GJqFwQNgNrMuww" # ServeTheHome
                "UCOk-gHyjcWZNj3Br4oxwh0A" # Techno Tim
              ];
            }
            {
              type = "reddit";
              subreddit = "selfhosted";
            }
          ];
        }
        {
          size = "small";
          widgets = [
            # {
            #   type= "weather";
            #   location=  "London, United Kingdom";
            # }
            # {
            #         - type: markets
            #           markets:
            #             - symbol: SPY
            #               name: S&P 500
            #             - symbol: BTC-USD
            #               name: Bitcoin
            #             - symbol: NVDA
            #               name: NVIDIA
            #             - symbol: AAPL
            #               name: Apple
            #             - symbol: MSFT
            #               name: Microsoft
            #             - symbol: GOOGL
            #               name: Google
            #             - symbol: AMD
            #               name: AMD
            #             - symbol: RDDT
            #               name: Reddit
            # }
          ];
        }
      ];
    }];
  };


  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        variant = "mocha";
      };
    };
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
    font = {
      name = "Hack Nerd Font Medium";
      # package = pkgs.nerdfont.override { fonts = [ "Hack", "Mononoki" ] }
    };
  };
}
