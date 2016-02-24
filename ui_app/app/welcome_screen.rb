class WelcomeScreen < UI::Screen
  background_color "#F0C419"

  def on_load
    background = UI::View.new
    background.flex = 1
    background.margin = 25
    background.background_color = :blue
    self.view.add_child(background)

    label = UI::Label.new
    label.height = 50
    label.margin = [10, 10, 50, 50]
    label.text = "Hello world"
    label.background_color = :red
    label.color = :white
    label.text_alignment = :right
    background.add_child(label)

    button = UI::Button.new
    button.height = 50
    button.margin = [0, 5]
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
