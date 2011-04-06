module FiveMobilePush
  ##
  # Stores supported platform names as defined constants.
  #--
  # Internal to this gem, this class also aids in building and verifying
  # selected platforms.
  class Platform
    ALL        = "all"
    IPHONE     = "iphone"
    BLACKBERRY = "blackberry"
    ANDROID    = "android"

    SUPPORTED_PLATFORMS = [
      ALL,
      IPHONE,
      BLACKBERRY,
      ANDROID
    ]

    # Exception to be raised when a user selects an invalid platform
    class InvalidPlatform < StandardError
    end

    # @private
    attr_reader :target_platforms

    # @param [Array<String>, String] target_platforms The platforms being
    #   targeted
    #
    # @private
    def initialize(*target_platforms)
      self.target_platforms = target_platforms
    end

    # @return [String] a formatted String with a list of the target platforms
    #
    # @private
    def build_list
      target_platforms.join(',')
    end

    # @param [Array<String>, String] target_platforms The platforms being
    #   targeted
    #
    # @private
    def target_platforms=(*target_platforms)
      @target_platforms = target_platforms.flatten
    end

    # @raise [InvalidPlatform] raised when an invalid target platform has been
    #   selected
    #
    # @private
    def validate!
      if invalid_target_platforms.empty?
        raise InvalidPlatform, "The following platforms are invalid: #{invalid_target_platforms}"
      end
    end

    private

    def invalid_target_platforms
      target_platforms - SUPPORTED_PLATFORMS
    end
  end
end
