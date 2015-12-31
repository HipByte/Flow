class RedditController
  def initialize
    @data = []

    scroll_view = NSScrollView.alloc.initWithFrame(NSMakeRect(0, 0, 480, 322))
    scroll_view.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable|NSViewHeightSizable
    scroll_view.hasVerticalScroller = true
    app.window.contentView.addSubview(scroll_view)

    @table_view = NSTableView.alloc.init
    column_title = NSTableColumn.alloc.initWithIdentifier("text")
    column_title.editable = false
    column_title.headerCell.setTitle("Text")
    column_title.width = 480
    @table_view.addTableColumn(column_title)

    @table_view.delegate = self
    @table_view.dataSource = self
    @table_view.autoresizingMask = NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin
    @table_view.target = self

    scroll_view.setDocumentView(@table_view)
  end

  def data=(data)
    @data = data
    @table_view.reloadData
  end

  def app
    NSApp.delegate
  end

  def numberOfRowsInTableView(aTableView)
    @data.size
  end

  def tableView(aTableView,
                objectValueForTableColumn: aTableColumn,
                row: rowIndex)
    @data[rowIndex].title
  end
end
