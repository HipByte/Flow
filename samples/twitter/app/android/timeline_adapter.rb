class TimelineAdapter < Android::Widget::ArrayAdapter
  def tweets=(tweets)
    @tweets = tweets
  end

  # Instead of a generic TextView, we return a custom view for each schedule item.
  def getView(position, convertView, parent)
    avatar_view = Android::Widget::ImageView.new(context)
    layout_params = Android::Widget::LinearLayout::LayoutParams.new(100,100)
    layout_params.setMargins(10, 10, 10, 10)
    avatar_view.setLayoutParams(layout_params)

    Net::AsyncTask.async do
      stream = Java::Net::URL.new(@tweets[position].user.profile_image_url).openStream
      bitmap = Android::Graphics::BitmapFactory.decodeStream(stream)

      Net::AsyncTask.main_async do
        avatar_view.setImageBitmap(bitmap)
      end
    end

    name_view = Android::Widget::TextView.new(context)
    name_view.text = @tweets[position].user.name
    name_view.textSize = 18
    name_view.setTypeface(nil, Android::Graphics::Typeface::BOLD)
    name_view.textColor = Android::Graphics::Color::BLACK

    username_view = Android::Widget::TextView.new(context)
    username_view.text = "@#{@tweets[position].user.screen_name}"
    username_view.textSize = 16
    username_view.textColor = Android::Graphics::Color::BLACK
    username_view.setPadding(10,0,0,0)

    title_view = Android::Widget::LinearLayout.new(context)
    title_view.orientation = Android::Widget::LinearLayout::HORIZONTAL
    title_view.addView(name_view)
    title_view.addView(username_view)

    status_view = Android::Widget::TextView.new(context)
    status_view.text = @tweets[position].text
    status_view.textSize = 14
    status_view.textColor = Android::Graphics::Color::BLACK

    right_view = Android::Widget::LinearLayout.new(context)
    right_view.orientation = Android::Widget::LinearLayout::VERTICAL
    right_view.addView(title_view)
    right_view.addView(status_view)

    layout = Android::Widget::LinearLayout.new(context)
    layout.orientation = Android::Widget::LinearLayout::HORIZONTAL
    layout.addView(avatar_view)
    layout.addView(right_view)
    layout
  end
end
