# @attr flex
# @attr width
# @attr height
# @attr min_width
# @attr min_height
# @attr max_width
# @attr max_height
# @attr left
# @attr right
# @attr top
# @attr bottom
# @attr padding
# @attr margin
# @attr border_width
# @attr padding_top
# @attr padding_right
# @attr padding_bottom
# @attr padding_left
# @attr padding_start
# @attr padding_end
# @attr margin_top
# @attr margin_right
# @attr margin_bottom
# @attr margin_left
# @attr margin_start
# @attr margin_end
# @attr border_top_width
# @attr border_right_width
# @attr border_bottom_width
# @attr border_left_width
# @attr border_start
# @attr border_end
# @attr name
# @attr flex_direction
# @attr justify_content
# @attr align_items
# @attr align_self
# @attr flex
# @attr flex_wrap
# @attr position
class CSSNode
  # @!method self.set_scale(scale)

  # Adds a new child node
  # @!method add_child(child)
  # @param [CSSNode] child

  # Deletes a child node
  # @!method delete_child(child)
  # @param [CSSNode] child

  # Returns an array containing the child nodes
  # @!method children
  # @return [Array<CSSNore>]

  # Returns the parent node
  # @!method parent
  # @return [CSSNode]

  # Returns the root node
  # @!method root
  # @return [CSSNode]
end
