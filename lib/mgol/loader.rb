# frozen_string_literal: true

require_relative 'build_in_file'
require_relative 'rle_file'

module MGoL
  Loader = Class.new do
    def initialize
      clear!
    end

    def clear!
      @files = [DotFile]
      @current = 0
    end

    def current
      @files[@current]
    end

    def select_next
      @current += 1
      @current = 0 if @current == @files.size
    end

    def select_prev
      @current -= 1
      @current = @files.size - 1 if @current < 0
    end

    def load_file(file_name)
      return false unless File.file?(file_name) && File.readable?(file_name)
      @files << RLEFile.new(file_name)
      true
    end

    def load_dir(dir_name)
      Dir.glob("#{dir_name}/*.rle"){ |file_name| load_file(file_name) } if File.directory?(dir_name)
    end

    def sort!
      @files.sort_by!(&:name)
    end
  end.new
end
