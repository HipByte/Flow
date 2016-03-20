module UI
  class ListRow < UI::View
    def initialize
      super
      self.flex_direction = :row

      @label = UI::Label.new
      @label.flex = 1
      @label.margin = [10, 15]
      @label.padding = 5
      self.add_child(@label)
    end

    def update(data)
      @label.text = data
    end
  end
end
