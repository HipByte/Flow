module UI
  class Web < UI::View
    def load_html(str)
      proxy.loadData(str, 'text/html', nil)
    end

    def proxy
      @proxy ||= begin
        view = Android::Webkit::WebView.new(UI.context)
        view.settings.javaScriptEnabled = true
        view
      end
    end
  end
end
