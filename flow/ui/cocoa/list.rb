module UI
  class List < View
    class CustomListCell < UITableViewCell
      IDENTIFIER = "CustomListCell"

      def prepareForReuse
        super
        # this is far from optimal, we should find a better way
        # to achieve this
        self.contentView.subviews.each(&:removeFromSuperview)
      end

      def add_child(child)
        self.contentView.addSubview(child.container)
        child.width = self.contentView.bounds.size.width
        child.height = self.contentView.bounds.size.height
        child.update_layout
      end
    end

    def initialize
      super
      @data_source = []
      container.registerClass(CustomListCell, forCellReuseIdentifier: CustomListCell::IDENTIFIER)
    end

    def numberOfSectionsInTableView(table_view)
      1
    end

    def tableView(table_view, numberOfRowsInSection: section)
      @data_source.count
    end

    def tableView(table_view, cellForRowAtIndexPath: index_path)
      cell = table_view.dequeueReusableCellWithIdentifier(CustomListCell::IDENTIFIER, forIndexPath: index_path)
      content_view = @render_row_block.call(@data_source[index_path.row],
                                            index_path.row,
                                            index_path.section,
                                            {ui_table_view_cell: cell})
      cell.add_child(content_view)
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
