module UI
  class Web < UI::View
    def load_html(str)
      proxy.loadData(str, 'text/html', nil)
    end

    def proxy
      @proxy ||= begin
        web_view = Android::Webkit::WebView.new(UI.context)
        web_view.settings.javaScriptEnabled = true
        web_view
      end
    end
  end
end
