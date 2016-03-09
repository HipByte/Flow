class FlowListViewAdapter < Android::Widget::BaseAdapter
  def initialize(list)
    @list = list
  end

  def getCount
    @list.data_source.size
  end

  def getItem(pos)
    @list.data_source[pos]
  end

  def getItemId(pos)
    pos
  end

  def getView(pos, convert_view, parent_view)
    # TODO caching
    view = @list.render_row_block.call(0, pos).new
    view.width = parent_view.width / UI.density
$rows||=[]
$rows<<view
    view.update(@list.data_source[pos])
    #view.height = 40.0
    view.update_layout
    view.container
  end
end

module UI
  class List < UI::View
    def initialize
      super
      @data_source = []
      @render_row_block = lambda { |section_index, row_index| ListRow }
    end

    attr_reader :data_source

    def data_source=(data_source)
      if @data_source != data_source
        @data_source = data_source
        container.getAdapter.notifyDataSetChanged
      end
    end

    attr_reader :render_row_block

    def render_row(&block)
      @render_row_block = block
    end

    def container
      @container ||= begin
        list = Android::Widget::ListView.new(UI.context)
        list.setAdapter(FlowListViewAdapter.new(self))
        list
      end
    end
  end
end
