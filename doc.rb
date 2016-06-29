class Store
  # Returns the value of a key.
  # @example
  #   Store['foo']
  #   #=> 42
  def self.[](key); end

  # Sets a value for a key.
  # @example
  #   Store['foo'] = 42
  def self.[]=(key, value); end

  # Deletes a key from storage.
  # @example
  #   Store.delete('foo')
  def self.delete(key); end

  # Returns a hash containing all the keys and values.
  # @example
  #   Store.all
  #   #=> { 'foo' => 42 }
  def self.all; end
end

class JSON
  # Converts a JSON string into a Hash
  # @param [String] string The original JSON string
  # @example
  #   JSON.load('{"foo":"bar"}')
  #   #=> {"foo" => "bar"}
  # @return [Hash] The hash generated from the JSON string
  def self.load(string); end
end

class Object
  # Converts an object to a JSON string
  # @example
  #   {"foo" => "bar"}.to_json
  #   #=> '{"foo":"bar"}'
  # @return [String] The JSON string generated from the object
  def to_json; end
end

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
# @attr position_type
class CSSNode
  def self.set_scale(scale); end

  # Adds a new child node
  # @param [CSSNode] child
  def add_child(child); end

  # Deletes a child node
  # @param [CSSNode] child
  def delete_child(child); end

  # Returns an array containing the child nodes
  # @return [Array<CSSNode>]
  def children; end

  # Returns the parent node
  # @return [CSSNode]
  def parent; end

  # Returns the root node
  # @return [CSSNode]
  def root; end
end

class Base64
  # Converts a string into its base64 equivalent string.
  # @param [String] string The original string to be converted
  # @example
  #   Base64.encode('xx') #=> eHg=
  # @return [String] The base64 encoded string
  def self.encode(string); end

  # Decodes a base64 string.
  # @param [String] string The base64 encoded string
  # @example
  #   Base64.decode('eHg=') #=> xx
  # @return [String] The decoded string
  def self.decode(string); end
end

# See {Digest::Base Digest::Base} to see the methods implemented in subclasses:
# - {Digest::MD5 Digest::MD5}
# - {Digest::SHA1 Digest::SHA1}
# - {Digest::SHA224 Digest::SHA224}
# - {Digest::SHA256 Digest::SHA256}
# - {Digest::SHA384 Digest::SHA384}
# - {Digest::SHA512 Digest::SHA512}
module Digest
  class Base
    # @example
    #   digest = Digest::MD5.new
    def initialize(algo); end

    # @example
    #  digest.update('hello')
    def update(str); end

    # @example
    #   digest.reset
    def reset; end

    # @example
    #   digest.digest
    #   #=> '5d41402abc4b2a76b9719d911017c592'
    def digest; end

    # @example
    #   Digest::MD5.digest('hello')
    #   #=> '5d41402abc4b2a76b9719d911017c592'
    def self.digest(str); end
  end

  class MD5 < Base; def initialize; super('MD5'); end; end
  class SHA1 < Base; def initialize; super('SHA1'); end; end
  class SHA224 < Base; def initialize; super('SHA224'); end; end
  class SHA256 < Base; def initialize; super('SHA256'); end; end
  class SHA384 < Base; def initialize; super('SHA384'); end; end
  class SHA512 < Base; def initialize; super('SHA512'); end; end
end

# @attr [Float] latitude Populated by the location monitoring service
# @attr [Float] latitude Populated by the location monitoring service
# @attr [Float] longitude Populated by the location monitoring service
# @attr [Float] altitude Populated by the location monitoring service
# @attr [Time]  time Populated by the location monitoring service
# @attr [Float] speed Populated by the location monitoring service
# @attr [Float] accuracy Populated by the location monitoring service
#
# @attr [String] name Populated after reverse geocoding a string
# @attr [String] address Populated after reverse geocoding a string
# @attr [String] localiton Populated after reverse geocoding a string
# @attr [String] postal_code Populated after reverse geocoding a string
# @attr [String] sub_area Populated after reverse geocoding a string
# @attr [String] area Populated after reverse geocoding a string
# @attr [String] country Populated after reverse geocoding a string
class Location
  # Checks if the location service is accessible
  # @example
  #   Location.monitor_enabled? # => true or false
  def self.monitor_enabled?; end

  # Starts monitoring for location updates.
  #
  # @param [Hash] options
  # @option options [Fixnum] :distance_filter The distance in meters from the
  #   previous location that should trigger a monitor update.
  #
  # @return [Monitor]
  #
  # @example
  #   monitor = Location.monitor do |location, err|
  #     if location
  #       puts location.latitude, location.longitude
  #     else
  #       puts err
  #     end
  #   end
  def self.monitor(options={}, &block); end

  # Checks if the geocoder service is accessible
  # @return [Boolean]
  def self.geocode_enabled?; end

  # Reverse geocode a string
  # @example
  #   Location.geocode('apple inc') do |location, err|
  #     if location
  #       puts location.address
  #     else
  #       puts err
  #     end
  #   end
  def self.geocode(str, &block); end

  def geocode(&block); end
end

module Net
  class Request
    def initialize(url, options = {}, session = nil); end

    def run(&callback); end
  end

  class Session
    attr_reader :authorization

    def initialize(base_url, &block); end

    def self.build(base_url, &block); end

    # Sets a key/value pair header to be used in all requests in this session
    # @param [String] field
    # @param [String] value
    # @example
    #   session.header("Content-Type", "application/json")
    def header(field, value); end

    # Returns a hash containing key/value pairs of headers
    # @return [Hash]
    # @example
    #   response.headers
    #   #=> { 'Content-Type' => 'application/json' }
    def headers; end

    # Sets the Basic authentication data to be used in all requests
    # @param [Hash] options
    # @option options [String] user
    # @option options [String] password
    # @option options [String] token
    def authorize(options); end
  end

  class Response
    # @!visibility private
    attr_accessor :options, :mock

    # @!visibility private
    def initialize(options = {}); end

    # Returns the HTTP status code of the response
    # @return [Fixnum]
    # @example
    #   response.status_code
    #   #=> 200
    def status; end

    # Returns the HTTP status message of the response according to RFC 2616
    # @return [String]
    # @example
    #   response.status_message
    #   #=> "OK"
    def status_message; end

    # Returns the mime type of the response
    # @return [String]
    # @example
    #   repsonse.mime_type
    #   #=> "application/json"
    def mime_type; end

    # Returns body of the response
    # @return [String]
    # @example
    #   response.body
    #   #=> "Hello World"
    def body; end

    # Returns a hash containing key/value pairs of headers
    # @return [Hash]
    # @example
    #   response.headers
    #   #=> { 'Content-Type' => 'application/json' }
    def headers; end
  end

  class << self
    # Creates a session with common configuration
    # @example
    #   session = Net.build('https://httpbin.org') do
    #     header(:content_type, :json)
    #   end
    #   session.get("/users") do |response|
    #   end
    #   session.get("/posts") do |response|
    #   end
    def build(base_url, &block); end

    # Track the reachability of a hostname
    # @example
    #   # this block will be called each time network status is updated
    #   reachability = Net.reachable?("www.google.fr") do |reachable|
    #     if reachable
    #       ###
    #     end
    #   end
    #   # stop network reachability tracking
    #   reachability.stop
    def reachable?(hostname = 'www.google.com', &block); end

    # Stub an url to return the desired Response object
    # @example
    #   Net.stub('www.example.com').and_return(Response.new(body:"example"))
    #   Net.get("www.example.com") do |response|
    #     response.body # example
    #   end
    def stub(base_url); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.get(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.post(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.put(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.delete(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.patch(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.options(base_url, options); end

    # @param [String] base_url The url to request
    # @param [Hash] options
    # @option options [Hash] headers
    # @option options [String] body
    # @option options [Fixnum] connection_timeout
    # @option options [Fixnum] read_timeout
    # @yield [response]
    # @yieldparam [Response] response
    def self.head(base_url, options); end
  end

  module Config
    class << self
      # User agent string to be used in all requests
      # @return [String]
      attr_accessor :user_agent
      # Time in seconds to wait for a connection to be made. Default is 30 seconds.
      # @return [Fixnum]
      attr_accessor :connect_timeout
      # Time in seconds to wait for a resource to finnish downloading. Default
      # is 7 days.
      # @return [Fixnum]
      attr_accessor :read_timeout
    end
  end
end

class Task
  class Timer
    # Cancel a scheduled block
    def stop; end
  end

  class Queue
    # Run a block on a serial queue. Blocks will be run on the thread associated
    # to the queue in sequential order. The first block will have to finish
    # before the second block can run.
    # @example
    #   q = Task.queue
    #   q.schedule {  }
    def schedule; end

    # Wait for all scheduled blocks to finish on a serial queue
    # @example
    #   q = Task.queue
    #   q.wait
    def wait; end
  end

  # Schedule a block at every given interval (in seconds)
  # @return [Timer]
  # @example
  #   timer = Task.every 2.5 do
  #     # ...
  #   end
  def self.every(interval, &block); end

  # Schedule a block after a given interval (in seconds)
  # @example
  #   timer = Task.after 0.5 do
  #     # ...
  #   end
  def self.after(delay, &block); end

  # Run a block on the main thread
  # @example
  #   Task.main do
  #     # ...
  #   end
  def self.main(&block); end

  # Run a block concurrently in the background
  # Blocks will be distributed among a pool of threads and may be executed in parallel.
  # @example
  #   Task.background do
  #     # ...
  #   end
  def self.background(&block); end

  # Create a serial queue
  # A <code>Task::Queue</code> object keeps a reference to a single thread.
  # @return [Queue]]
  # @example
  #   q = Task.queue
  def self.queue; end

  # Check is the method has been called from the main thread.
  def self.main?; end
end

module UI
  # @!parse
  #   # Hash keys: :left, :center, :right, :justify
  #   TEXT_ALIGNMENT = {}

  # @return [Color]
  def self.Color(color); end

  # Represents a color. Can be initialized in several ways:
  #   - With a hex number:
  #     UI::Color.hex("#d2603c")
  #   - With RGB values:
  #     UI::Color.rgb(123, 200, 78)
  #   - Using one of the preset colors
  class Color
    attr_reader :proxy
  end

  # @param [Hash] options
  # @option options [String] title The title of the alert
  # @option options [String] message The message of the alert
  # @option options [String] cancel The title for the Cancel button
  # @option options [String] default The title of the 'default' button, usually
  #   the 'ok' button.
  def self.alert(options={}, &block); end

  # @param [Hash] font
  # @option font [String] name
  # @option font [Fixnum] size
  # @option font [Symbol] trait :normal, :bold, :italic, :bold_italic
  # @return [Font]
  def self.Font(font); end

  class Font
    attr_reader :proxy

    # @param [String] name
    # @param [Fixnum] size
    # @param [Symbol] trait :normal, :bold, :italic, :bold_italic
    def initialize(name, size, trait=nil); end

    # Returns wether the font is italic
    # @return [Boolean]
    def italic?; end

    # Returns wether the font is bold
    # @return [Boolean]
    def bold?; end
  end

  class Application
    # Returns the singleton Application object
    # @return [Application]
    def instance; end

    # Starts the application
    def start; end
  end

  # @attr [Color] color
  # @attr [String] title
  # @attr [Image] image
  # @attr [Font] font
  class Button < Control
  end

  # @attr [String] source The name of the file of hte image to use
  # @attr resize_mode See {RESIZE_MODES RESIZE_MODES} for possible values
  class Image < View
    # @!parse
    #   # Posible values for the <code>resize_mode</code> atttribute.  Hash keys: :cover, :contain, :stretch
    #   RESIZE_MODES = {}
  end

  # @attr text_alignment
  # @attr [Color] color
  # @attr [String] text
  # @attr [Font] font
  class Label < View
  end

  # @attr [Screen] root_screen
  class Navigation
    # @param [Screen] root_screen The initial screen
    def initialize(root_screen); end

    # Returns the current screen being shown
    # @return [Screen]
    def screen; end

    # Shows the navigation bar
    def show_bar; end

    # Hides the navigation bar
    def hide_bar; end

    # Returns wether the navigation bar is hidden
    def bar_hidden?; end

    # Sets the title shown in the navigation bar
    # @param [String] title
    def title=(title); end

    # Sets the color of the navigation bar
    # @param [Color] color
    def bar_color=(color); end

    # Pushes a screen onto the navigation stack, optionally animating the
    # transition
    # @param [Screen] screen
    # @param [Boolean] animated
    def push(screen, animated=true); end

    # Pushes a screen from the navigation stack, optionally animating the
    # transition
    # @param [Boolean] animated
    def pop(animated=true); end
  end

  # @attr [Navigation] navigation Returns the navigation object associated to
  #   this screen
  class Screen
    # Called after the screen has been loaded
    def on_load; end

    # Called after the screen is hown
    def on_show; end

    # Returns the root view of this screen
    # @return [View]
    def view; end

    # Returns the patform-specific object
    def proxy; end
  end

  # @attr text_alignment
  # @attr [Color] color
  # @attr secure
  # @attr [String] text
  # @attr [String] placeholder
  # @attr [Font] font
  class TextInput < Control
    include Eventable

    # Execute a block when a certain event happens. Possible event values:
    #   :on_change, :on_focus, :on_blur
    def on(event, &block); end
  end

  # @attr border_width
  # @attr [Color] border_color
  # @attr [Fixnum] border_radius
  # @attr [Color] background_color
  # @attr [Float] alpha
  class View < CSSNode
    # Returns wether the view is hidden
    # @return [Boolean]
    def hidden?; end

    # Sets the hidden state of the view
    # @param [Boolean] hidden
    def hidden=(hidden); end

    # Update the position of the view and all its children
    def update_layout; end

    # Returns the platform-spegific object
    def proxy; end
  end

  class ActivityIndicator < View
    # Start animating the view
    def start; end

    # Stop animating the view
    def stop; end

    # Returns wether the indicator is currently animating
    # @return [Boolean]
    def animating?; end

    # Set the color of the activity indicator
    # @param [Color] color
    def color=(color); end
  end

  class ListRow < View
    def initialize; end
    def update(data); end
  end

  class Eventable
    def on(event, action=nil, &block); end
    def trigger(event, *args); end
  end
end
