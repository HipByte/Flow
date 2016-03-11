module UI
  class List < View
    class CustomListCell < UITableViewCell
      IDENTIFIER = "CustomListCell"

      attr_reader :content_view

      def content_view=(content_view)
        @content_view = content_view
        self.contentView.addSubview(@content_view.container)
        @content_view.width = contentView.frame.size.width
      end

      def layoutSubviews
        @content_view.width = contentView.frame.size.width
        @content_view.update_layout
        super
      end
    end

    def initialize
      super
      @data_source = []
      @render_row_block = lambda { |section_index, row_index| ListRow }
    end

    def numberOfSectionsInTableView(table_view)
      1
    end

    def tableView(table_view, numberOfRowsInSection: section)
      @data_source.size
    end

    def tableView(table_view, cellForRowAtIndexPath: index_path)
      row_klass = @render_row_block.call(index_path.section, index_path.row)
      cell_identifier = CustomListCell::IDENTIFIER + row_klass.name
      cell = table_view.dequeueReusableCellWithIdentifier(cell_identifier)
      unless cell
        cell = CustomListCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: cell_identifier)
        cell.content_view = row_klass.new
      end
      cell.content_view.update(@data_source[index_path.row]) if cell.content_view.respond_to?(:update)
      cell.content_view.update_layout
      cell
    end

    def tableView(table_view, heightForRowAtIndexPath: index_path)
      cell = tableView(table_view, cellForRowAtIndexPath: index_path)
      cell.content_view.layout[3]
    end

    attr_reader :data_source

    def data_source=(data_source)
      if @data_source != data_source
        @data_source = data_source
        container.reloadData
      end
    end

    def render_row(&block)
      @render_row_block = block.weak!
    end

    def container
      @container ||= begin
        ui_table_view = UITableView.alloc.init
        ui_table_view.delegate = self
        ui_table_view.dataSource = self
        ui_table_view
      end
    end
  end
end
