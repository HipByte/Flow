class Base64
  # Converts a string into its base64 equivalent string
  #
  # @param [String] string
  #   The original string to be converted
  #
  # @return [String]
  #   The base64 encoded string
  #
  # @example
  #   Base64.encode('xx')
  #   #=> eHg=
  # @!method self.encode(string)

  # Decodes a base64 string
  #
  # @param [String] string
  #   The base64 encoded string
  #
  # @return [String]
  #   The decoded string
  #
  # @example
  #   Base64.decode('eHg=')
  #   #=> xx
  #@!method self.decode(string)
end
