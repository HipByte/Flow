# Classes hierarchy

* [CSSNode](#css_node)
  * [View](#view)
    * [Label](#label)
    * [Control](#control)
      * [TextInput](#text_input)
      * [Button](#button)

# <a name="css_node"></a>CSSNode


## Constructor

This method is designed to be the super class of all the elements, you shouldn't instanciate it.

## Managing layout

CSSNode relies on https://github.com/facebook/css-layout to layout elements.
All the supported attributes are implemented : width, height, min_width, min_height, max_width, max_height, left, right, top, bottom, margin, margin_left, margin_right, margin_top, margin_bottom, padding, padding_left, padding_right, padding_top, padding_bottom, border_width, border_left_width, border_right_width, border_top_width, border_bottom_width, flex_direction, justify_content, align_items, align_self, flex, flex_wrap, position

```ruby
another_view = UI::View.new

view.padding = 5
view.padding = [5, 5, 5, 5]
view.padding = [5, 5, 5]
view.padding = [5, 5]

view.border = 5
view.border = [5, 5, 5, 5]
view.border = [5, 5, 5]
view.border = [5, 5]

view.margin = 5
view.margin = [5, 5, 5, 5]
view.margin = [5, 5, 5]
view.margin = [5, 5]

view.width = 200
view.height = 200
```


## Update layout

```ruby
# this will update the position of the element and all its children.
view.layout!
```


# <a name="view"></a>View


## Constructor

```ruby
view = UI::View.new
```

## Managing children

```ruby
another_view = UI::View.new
view.add_child(another_view)
view.remove_child(another_view)
```

## Customizing the view

```ruby
view.background_color = :red
view.hidden = true
```

## Accessing the platform component

```ruby
view.container
```

# <a name="label"></a>Label


## Constructor

```ruby
label = UI::Label.new
```

## Customizing the view

```ruby
label.text = "Hello World"
label.color = :blue
label.text_alignment = :right #:right, :left, :center, :justify
```

# <a name="control"></a>Control


## Constructor

Control is not designed to be instantiated, it shares common behavior for controls.

### CONTROL_STATES

Available states for controls changing behavior for various states.

```ruby
:normal
:highlighted
:disabled
:selected
:focused
```

# <a name="button"></a>Button


## Constructor

```ruby
button = UI::Button.new
```

## Customizing the view

```ruby
button.title = "Title"
# or for various states
button.title = {normal: "Title", selected: "Selected title"}
button.color = :red
# or for various states
button.color = {normal: :black, focused: :red}
button.border_width = 2
button.border_color = :green
button.border_radius = 3
```

# <a name="text_input"></a>TextInput


## Constructor

```ruby
input = UI::TextInput.new
```

## Customizing the view

```ruby
input.text = "Some text"
input.text_alignment = :center
input.color = :red
input.secure = true
```

### Events

```ruby
input.on(:change) {|text| }
input.on(:blur) {}
input.on(:focus) {}
```
