module LookLike
  class Matchers
    @@matchers = []

    def self.define(config)
      @@matchers.unshift(LookLike::Matcher.new(config))
    end

    def self.find(expected, actual)
      matchers = [LookLike::NestedArrayMatcher.new(@@matchers), LookLike::ArrayMatcher.new(@@matchers)] + @@matchers
      matchers.find { |matcher| matcher.select(expected, actual) }
    end

    def self.match(actual, expected)
      find(expected, actual).match(actual, expected)
    end

    def self.error(actual, expected)
      find(expected, actual).error(actual, expected)
    end

    def self.negate_error(actual, expected)
      find(expected, actual).negate_error(actual, expected)
    end
  end

end