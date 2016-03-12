module UI
  def self.Color(color)
    if UI::Color._native?(color)
      UI::Color.new(color)
    else
      case color
        when UI::Color
          self
        when String
          UI::Color.hex(color)
        when Symbol
          UI::Color.symbol(color)
        when Array
          case color.size
            when 3
              color = color + [255]
            when 4
            else
              raise "Expected Array of 3 or 4 elements"
          end
          UI::Color.rgba(*color)
        else
          raise "Expected UI::Color, String, Symbol or Array of Fixnum objects"
      end
    end
  end

  class Color
    attr_reader :container
    def initialize(container)
      @container = container
    end

    def self.symbol(symbol)
      send(symbol)
    end

    def self.hex(hex_color)
      hex_color.gsub!("#", "")

      colors =  case hex_color.size
                when 3
                  hex_color.scan(%r{[0-9A-Fa-f]}).map!{ |el| (el * 2).to_i(16) }
                when 6, 8
                  hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
                else
                  raise ArgumentError
                end

      if colors.size == 3
        rgb(*colors)
      elsif colors.size == 4
        rgba(*colors[1..3], colors[0])
      else
        raise ArgumentError
      end
    end

    def self.rgb(r, g, b)
      rgba(r, g, b, 255)
    end

    def self.clear; rgba(0, 0, 0, 0); end

    def self.alice_blue; hex("#F0F8FF"); end
    def self.antique_white; hex("#FAEBD7"); end
    def self.aqua; hex("#00FFFF"); end
    def self.aquamarine; hex("#7FFFD4"); end
    def self.azure; hex("#F0FFFF"); end
    def self.beige; hex("#F5F5DC"); end
    def self.bisque; hex("#FFE4C4"); end
    def self.black; hex("#000000"); end
    def self.blanched_almond; hex("#FFEBCD"); end
    def self.blue; hex("#0000FF"); end
    def self.blue_violet; hex("#8A2BE2"); end
    def self.brown; hex("#A52A2A"); end
    def self.burly_wood; hex("#DEB887"); end
    def self.cadet_blue; hex("#5F9EA0"); end
    def self.chartreuse; hex("#7FFF00"); end
    def self.chocolate; hex("#D2691E"); end
    def self.coral; hex("#FF7F50"); end
    def self.cornflower_blue; hex("#6495ED"); end
    def self.cornsilk; hex("#FFF8DC"); end
    def self.crimson; hex("#DC143C"); end
    def self.cyan; hex("#00FFFF"); end
    def self.dark_blue; hex("#00008B"); end
    def self.dark_cyan; hex("#008B8B"); end
    def self.dark_golden_rod; hex("#B8860B"); end
    def self.dark_gray; hex("#A9A9A9"); end
    def self.dark_grey; hex("#A9A9A9"); end
    def self.dark_green; hex("#006400"); end
    def self.dark_khaki; hex("#BDB76B"); end
    def self.dark_magenta; hex("#8B008B"); end
    def self.dark_olive_green; hex("#556B2F"); end
    def self.dark_orange; hex("#FF8C00"); end
    def self.dark_orchid; hex("#9932CC"); end
    def self.dark_red; hex("#8B0000"); end
    def self.dark_salmon; hex("#E9967A"); end
    def self.dark_sea_green; hex("#8FBC8F"); end
    def self.dark_slate_blue; hex("#483D8B"); end
    def self.dark_slate_gray; hex("#2F4F4F"); end
    def self.dark_slate_grey; hex("#2F4F4F"); end
    def self.dark_turquoise; hex("#00CED1"); end
    def self.dark_violet; hex("#9400D3"); end
    def self.deep_pink; hex("#FF1493"); end
    def self.deep_sky_blue; hex("#00BFFF"); end
    def self.dim_gray; hex("#696969"); end
    def self.dim_grey; hex("#696969"); end
    def self.dodger_blue; hex("#1E90FF"); end
    def self.fire_brick; hex("#B22222"); end
    def self.floral_white; hex("#FFFAF0"); end
    def self.forest_green; hex("#228B22"); end
    def self.fuchsia; hex("#FF00FF"); end
    def self.gainsboro; hex("#DCDCDC"); end
    def self.ghost_white; hex("#F8F8FF"); end
    def self.gold; hex("#FFD700"); end
    def self.golden_rod; hex("#DAA520"); end
    def self.gray; hex("#808080"); end
    def self.grey; hex("#808080"); end
    def self.green; hex("#008000"); end
    def self.green_yellow; hex("#ADFF2F"); end
    def self.honey_dew; hex("#F0FFF0"); end
    def self.hot_pink; hex("#FF69B4"); end
    def self.indian_red; hex("#CD5C5C"); end
    def self.indigo; hex("#4B0082"); end
    def self.ivory; hex("#FFFFF0"); end
    def self.khaki; hex("#F0E68C"); end
    def self.lavender; hex("#E6E6FA"); end
    def self.lavender_blush; hex("#FFF0F5"); end
    def self.lawn_green; hex("#7CFC00"); end
    def self.lemon_chiffon; hex("#FFFACD"); end
    def self.light_blue; hex("#ADD8E6"); end
    def self.light_coral; hex("#F08080"); end
    def self.light_cyan; hex("#E0FFFF"); end
    def self.light_golden_rod_yellow; hex("#FAFAD2"); end
    def self.light_gray; hex("#D3D3D3"); end
    def self.light_grey; hex("#D3D3D3"); end
    def self.light_green; hex("#90EE90"); end
    def self.light_pink; hex("#FFB6C1"); end
    def self.light_salmon; hex("#FFA07A"); end
    def self.light_sea_green; hex("#20B2AA"); end
    def self.light_sky_blue; hex("#87CEFA"); end
    def self.light_slate_gray; hex("#778899"); end
    def self.light_slate_grey; hex("#778899"); end
    def self.light_steel_blue; hex("#B0C4DE"); end
    def self.light_yellow; hex("#FFFFE0"); end
    def self.lime; hex("#00FF00"); end
    def self.lime_green; hex("#32CD32"); end
    def self.linen; hex("#FAF0E6"); end
    def self.magenta; hex("#FF00FF"); end
    def self.maroon; hex("#800000"); end
    def self.medium_aqua_marine; hex("#66CDAA"); end
    def self.medium_blue; hex("#0000CD"); end
    def self.medium_orchid; hex("#BA55D3"); end
    def self.medium_purple; hex("#9370DB"); end
    def self.medium_sea_green; hex("#3CB371"); end
    def self.medium_slate_blue; hex("#7B68EE"); end
    def self.medium_spring_green; hex("#00FA9A"); end
    def self.medium_turquoise; hex("#48D1CC"); end
    def self.medium_violet_red; hex("#C71585"); end
    def self.midnight_blue; hex("#191970"); end
    def self.mint_cream; hex("#F5FFFA"); end
    def self.misty_rose; hex("#FFE4E1"); end
    def self.moccasin; hex("#FFE4B5"); end
    def self.navajo_white; hex("#FFDEAD"); end
    def self.navy; hex("#000080"); end
    def self.old_lace; hex("#FDF5E6"); end
    def self.olive; hex("#808000"); end
    def self.olive_drab; hex("#6B8E23"); end
    def self.orange; hex("#FFA500"); end
    def self.orange_red; hex("#FF4500"); end
    def self.orchid; hex("#DA70D6"); end
    def self.pale_golden_rod; hex("#EEE8AA"); end
    def self.pale_green; hex("#98FB98"); end
    def self.pale_turquoise; hex("#AFEEEE"); end
    def self.pale_violet_red; hex("#DB7093"); end
    def self.papaya_whip; hex("#FFEFD5"); end
    def self.peach_puff; hex("#FFDAB9"); end
    def self.peru; hex("#CD853F"); end
    def self.pink; hex("#FFC0CB"); end
    def self.plum; hex("#DDA0DD"); end
    def self.powder_blue; hex("#B0E0E6"); end
    def self.purple; hex("#800080"); end
    def self.rebecca_purple; hex("#663399"); end
    def self.red; hex("#FF0000"); end
    def self.rosy_brown; hex("#BC8F8F"); end
    def self.royal_blue; hex("#4169E1"); end
    def self.saddle_brown; hex("#8B4513"); end
    def self.salmon; hex("#FA8072"); end
    def self.sandy_brown; hex("#F4A460"); end
    def self.sea_green; hex("#2E8B57"); end
    def self.sea_shell; hex("#FFF5EE"); end
    def self.sienna; hex("#A0522D"); end
    def self.silver; hex("#C0C0C0"); end
    def self.sky_blue; hex("#87CEEB"); end
    def self.slate_blue; hex("#6A5ACD"); end
    def self.slate_gray; hex("#708090"); end
    def self.slate_grey; hex("#708090"); end
    def self.snow; hex("#FFFAFA"); end
    def self.spring_green; hex("#00FF7F"); end
    def self.steel_blue; hex("#4682B4"); end
    def self.tan; hex("#D2B48C"); end
    def self.teal; hex("#008080"); end
    def self.thistle; hex("#D8BFD8"); end
    def self.tomato; hex("#FF6347"); end
    def self.turquoise; hex("#40E0D0"); end
    def self.violet; hex("#EE82EE"); end
    def self.wheat; hex("#F5DEB3"); end
    def self.white; hex("#FFFFFF"); end
    def self.white_smoke; hex("#F5F5F5"); end
    def self.yellow; hex("#FFFF00"); end
    def self.yellow_green; hex("#9ACD32"); end
  end
end
