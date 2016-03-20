class FlowUIListViewAdapter < Android::Widget::BaseAdapter
  def initialize(list)
    @list = list
    @cached_rows = {}
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
    data = @list.data_source[pos]
    @cached_rows[data] ||= begin
      view = @list.render_row_block.call(0, pos).new
      view.list = @list if view.respond_to?(:list=)
      view.width = parent_view.width / UI.density
      view.update(data) if view.respond_to?(:update)
      view.update_layout
      view._autolayout_when_resized = true
      view.proxy
    end
  end
end

class FlowUIListItemClickListener
  def initialize(list)
    @list = list
  end

  def onItemClick(parent, view, position, id)
    @list.trigger :select, @list.data_source[position], position
  end
end

module UI
  class List < UI::View
    include Eventable

    def initialize
      super
      @data_source = []
      @render_row_block = lambda { |section_index, row_index| ListRow }
    end

    attr_reader :data_source

    def data_source=(data_source)
      if @data_source != data_source
        @data_source = data_source
        proxy.adapter.notifyDataSetChanged
      end
    end

    attr_reader :render_row_block

    def render_row(&block)
      @render_row_block = block
    end

    def proxy
      @proxy ||= begin
        list_view = Android::Widget::ListView.new(UI.context)
        list_view.adapter = FlowUIListViewAdapter.new(self)
        list_view.onItemClickListener = FlowUIListItemClickListener.new(self)
        list_view.divider = nil
        list_view.dividerHeight = 0
        list_view.itemsCanFocus = true
        list_view.descendantFocusability = Android::View::ViewGroup::FOCUS_AFTER_DESCENDANTS
        list_view
      end
    end
  end
end
