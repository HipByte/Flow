module UI
  class Web < UI::View
    def load_html(str)
      container.loadData(str, 'text/html', nil)
    end

    def container
      @container ||= begin
        view = Android::Webkit::WebView.new(UI.context)
        view.settings.javaScriptEnabled = true
        view
      end
    end
  end
end
