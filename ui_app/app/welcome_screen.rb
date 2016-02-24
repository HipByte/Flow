class WelcomeScreen < UI::Screen
  background_color "#F0C419"

  def on_load
    background = UI::View.new
    background.flex = 1
    background.margin_top = 25
    background.margin_left = 25
    background.margin_right = 25
    background.margin_bottom = 25
    background.background_color = :blue
    self.view.add_child(background)

    label = UI::Label.new
    label.height = 50
    label.margin_top = 5
    label.margin_left = 5
    label.margin_right = 5
    label.margin_bottom = 5
    label.flex_direction = :column
    label.text = "Hello world"
    label.background_color = :red
    label.color = :white
    label.text_alignment = :right
    background.add_child(label)

    button = UI::Button.new
    button.height = 50
    button.margin_left = 5
    button.margin_right = 5
    button.flex_direction = :column
    button.title = "Submit"
    button.background_color = :yellow
    button.color = :black
    button.border_width = 2.0
    button.border_color = :black
    button.border_radius = 3.0
    background.add_child(button)

    self.view.layout!
  end
end
