# frozen_string_literal: true

module MGoL
  module DotFile
    def self.file_name
      'build-in'
    end

    def self.name
      "\1DOT"
    end

    def self.width
      1
    end

    def self.height
      1
    end

    def self.each_point
      block_given? ? yield(0, 0) : to_enum(__method__)
    end
  end
end
