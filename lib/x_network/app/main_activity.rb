# class MainActivity < Android::App::Activity
#   def onCreate(savedInstanceState)
#     super
#
#     XNetwork.get('https://news.ycombinator.com') do |response|
#       p '---------------------'
#       p response
#       p response.status
#       p response.headers
#       p response.status_message
#       p response.body
#     end
#   end
# end
