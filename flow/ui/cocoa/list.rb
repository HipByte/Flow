module UI
  class List < View
    class CustomListCell < UITableViewCell
      IDENTIFIER = "CustomListCell"

      attr_accessor :content_view

      def content_view=(content_view)
        @content_view = content_view
        self.contentView.addSubview(@content_view.container)
        @content_view.width = self.contentView.frame.size.width
      end
    end

    def initialize
      super
      @data_source = []
      @render_row_block = lambda {|section_index, row_index| ListRow }
      container.registerClass(CustomListCell, forCellReuseIdentifier: CustomListCell::IDENTIFIER)
      @sizing_cell = CustomListCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: CustomListCell::IDENTIFIER)
    end

    def numberOfSectionsInTableView(table_view)
      1
    end

    def tableView(table_view, numberOfRowsInSection: section)
      @data_source.count
    end

    def tableView(table_view, heightForRowAtIndexPath: index_path)
      if !@sizing_cell.content_view
        content_view = @render_row_block.call(index_path.section, index_path.row).new
        @sizing_cell.content_view = content_view
      end
      @sizing_cell.content_view.update(@data_source[index_path.row])
      @sizing_cell.content_view.update_layout
      @sizing_cell.content_view.layout[3]
    end

    def tableView(table_view, cellForRowAtIndexPath: index_path)
      cell = table_view.dequeueReusableCellWithIdentifier(CustomListCell::IDENTIFIER, forIndexPath: index_path)
      if !cell.content_view
        content_view = @render_row_block.call(index_path.section, index_path.row).new
        cell.content_view = content_view
      end
      cell.content_view.update(@data_source[index_path.row])
      cell.content_view.update_layout
      cell
    end

    def data_source=(data_source)
      @data_source = data_source
      container.reloadData
    end

    def render_row(&block)
      @render_row_block = block.weak!
    end

    def container
      @container ||=begin
        ui_table_view = UITableView.alloc.init
        ui_table_view.delegate = self
        ui_table_view.dataSource = self
        ui_table_view
      end
    end
  end
end
