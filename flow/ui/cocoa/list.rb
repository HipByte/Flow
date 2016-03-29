module UI
  class List < View
    include Eventable

    class CustomListCell < UITableViewCell
      IDENTIFIER = "CustomListCell"

      attr_reader :content_view

      def content_view=(content_view)
        @content_view = content_view
        self.contentView.addSubview(@content_view.proxy)
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
      @cached_rows = {}
      @cached_rows_height = {}
    end

    def numberOfSectionsInTableView(table_view)
      1
    end

    def tableView(table_view, numberOfRowsInSection: section)
      @data_source.size
    end

    def tableView(table_view, cellForRowAtIndexPath: index_path)
      row_klass = @render_row_block.call(index_path.section, index_path.row)
      data = @data_source[index_path.row]
      cell_identifier = CustomListCell::IDENTIFIER + row_klass.name
      cell = table_view.dequeueReusableCellWithIdentifier(cell_identifier)
      unless cell
        row = (@cached_rows[data] ||= row_klass.new)
        row.list = self if row.respond_to?(:list=)
        cell = CustomListCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: cell_identifier)
        cell.content_view = row
      end
      cell.content_view.update(data) if cell.content_view.respond_to?(:update)
      cell.content_view.update_layout
      @cached_rows_height[index_path.row] = cell.content_view.layout[3]
      cell
    end

    def tableView(table_view, heightForRowAtIndexPath: index_path)
      @cached_rows_height[index_path.row] or UITableViewAutomaticDimension
    end

    def _row_at_index_path(index_path)
      proxy.cellForRowAtIndexPath(index_path).content_view
    end

    def tableView(table_view, shouldHighlightRowAtIndexPath: index_path)
      view = _row_at_index_path(index_path)
      view.respond_to?(:selectable?) ? view.selectable? : true
    end

    def tableView(table_view, didSelectRowAtIndexPath: index_path)
      trigger :select, @data_source[index_path.row], index_path.row
    end

    attr_reader :data_source

    def data_source=(data_source)
      if @data_source != data_source
        @data_source = data_source
        proxy.reloadData
      end
    end

    def render_row(&block)
      @render_row_block = block.weak!
    end

    def row_at_index(pos)
      _row_at_index_path(NSIndexPath.indexPathForItem(pos, inSection:0))
    end

    def proxy
      @proxy ||= begin
        ui_table_view = UITableView.alloc.init
        ui_table_view.delegate = self
        ui_table_view.dataSource = self
        ui_table_view.separatorStyle = UITableViewCellSeparatorStyleNone
        ui_table_view
      end
    end
  end
end
