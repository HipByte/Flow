class WelcomeScreen < UI::Screen

  def on_show
    self.navigation.hide_bar
  end

  def on_load
    $screen = self

    background = UI::View.new
    background.flex = 1
    background.margin = 25
    background.background_color = :white
    self.view.add_child(background)

    label = UI::Label.new
    #label.height = 50
    label.margin = [10, 10, 5, 10]
    label.text = "It is a period of civil war. Rebel spaceships, striking from a hidden base, have won their first victory against the evil Galactic Empire."
    label.font = { :name => 'Starjedi', :size => 18.0 }
    label.background_color = :red
    label.color = :white
    label.text_alignment = :center
    background.add_child(label)
    $label = label

    button = UI::Button.new
    button.height = 50
    button.margin = [0, 5]
    button.title = "Submit"
    button.background_color = :blue
    button.color = :black
    #button.border_width = 2.0
    #button.border_color = :black
    #button.border_radius = 3.0
    background.add_child(button)

    text_field = UI::TextInput.new
    text_field.height = 50
    text_field.margin = [10, 5]
    text_field.text = "A textfield"
    text_field.background_color = :green
    text_field.color = :black
    #text_field.on(:change) { |text| p text }
    #text_field.on(:blur) { p 'blur'}
    #text_field.on(:focus) { p 'focus' }
    background.add_child(text_field)

    logo = UI::Image.new
    logo.source = "rubymotion-logo.png"
    logo.height = 100
    logo.margin = [10, 5]
    logo.resize_mode = :contain
    background.add_child(logo)

    # label.height = 200
    # label.animate(delay: 1.0, duration: 0.25) do
    #   p "animation ended"
    # end

    # list = UI::List.new
    # list.render_row do |data|
    #   label = UI::Label.new
    #   label.text = data
    #   # label.flex = 1
    #   # label.margin = 5
    #   label.height = 100
    #   label.width = 100
    #   label.background_color = :green
    #   label
    # end
    # list.data_source = ["laurent", "mark", "watson"]
    # list.height = 150
    # list.margin = 5
    # background.add_child(list)
    #
    # Task.after 2.0 do
    #   list.data_source = ["laurent", "mark", "watson"].reverse
    # end

    self.view.update_layout
  end
end
