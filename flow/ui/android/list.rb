class FlowUIListViewAdapter < Android::Widget::BaseAdapter
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

  def notifyDataSetChanged
    @views = nil
    super
  end

  def getView(pos, convert_view, parent_view)
    @views ||= []
    @views[pos] ||= begin
      view = @list.render_row_block.call(0, pos).new
      view.width = parent_view.width / UI.density
      view.update(@list.data_source[pos]) if view.respond_to?(:update)
      view.update_layout
      view._autolayout_when_resized = true
      view.container
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
        container.adapter.notifyDataSetChanged
      end
    end

    attr_reader :render_row_block

    def render_row(&block)
      @render_row_block = block
    end

    def container
      @container ||= begin
        list = Android::Widget::ListView.new(UI.context)
        list.adapter = FlowUIListViewAdapter.new(self)
        list.onItemClickListener = FlowUIListItemClickListener.new(self)
        list.divider = nil
        list.dividerHeight = 0
        list.itemsCanFocus = true
        list.descendantFocusability = Android::View::ViewGroup::FOCUS_AFTER_DESCENDANTS
        list
      end
    end
  end
end
