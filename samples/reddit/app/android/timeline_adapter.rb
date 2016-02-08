class TimelineAdapter < Android::Widget::ArrayAdapter
  def posts=(posts)
    @posts = posts
  end

  # Instead of a generic TextView, we return a custom view for each schedule item.
  def getView(position, convertView, parent)
    avatar_view = Android::Widget::ImageView.new(context)
    layout_params = Android::Widget::LinearLayout::LayoutParams.new(100,100)
    layout_params.setMargins(10, 10, 10, 10)
    avatar_view.setLayoutParams(layout_params)
    avatar_view.visibility = Android::View::View::GONE

    post = @posts[position]

    if post.thumbnail
      Task.background do
        stream = Java::Net::URL.new(post.thumbnail).openStream
        bitmap = Android::Graphics::BitmapFactory.decodeStream(stream)

        Task.main do
          avatar_view.setImageBitmap(bitmap)
          avatar_view.visibility = Android::View::View::VISIBLE
        end
      end
    end

    title_view = Android::Widget::TextView.new(context)
    title_view.text = post.title
    title_view.textSize = 18
    title_view.setTypeface(nil, Android::Graphics::Typeface::BOLD)
    title_view.textColor = Android::Graphics::Color::BLACK

    subreddit_view = Android::Widget::TextView.new(context)
    subreddit_view.text = "@#{post.subreddit}"
    subreddit_view.textSize = 16
    subreddit_view.textColor = Android::Graphics::Color::BLACK
    subreddit_view.setPadding(10,0,0,0)

    title_layout = Android::Widget::LinearLayout.new(context)
    title_layout.orientation = Android::Widget::LinearLayout::HORIZONTAL
    title_layout.addView(title_view)
    title_layout.addView(subreddit_view)

    right_view = Android::Widget::LinearLayout.new(context)
    right_view.orientation = Android::Widget::LinearLayout::VERTICAL
    right_view.addView(title_layout)

    layout = Android::Widget::LinearLayout.new(context)
    layout.orientation = Android::Widget::LinearLayout::HORIZONTAL
    layout.addView(avatar_view)
    layout.addView(right_view)
    layout
  end
end
