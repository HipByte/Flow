class WelcomeScreen < UI::Screen
  background_color "#F0C419"

  def on_load
    background = UI::View.new
    background.width = 300
    background.height = 400
    background.background_color = :blue
    self.view.add_child(background)

    label = UI::Label.new
    label.width = 230
    label.height = 30
    label.text = "Hello world"
    label.background_color = :red
    label.color = :white
    label.text_alignment = :right
    background.add_child(label)

    button = UI::Button.new
    button.width = 230
    button.height = 20
    button.title = "Submit"
    button.background_color =:yellow
    button.color = :black
    button.border_width = 2.0
    button.border_color = :black
    button.border_radius = 3.0
    background.add_child(button)

    background.layout!
  end
end
