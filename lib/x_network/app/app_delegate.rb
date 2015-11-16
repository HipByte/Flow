class AppDelegate
  def application(application, didFinishLaunchingWithOptions: launchOptions)

    XNetwork.get('http://jsonplaceholder.typicode.com/posts/1') do |response|
      # p response.status
      # p response.headers
      # p response.status_message
      p response.body
    end

    true
  end
end
