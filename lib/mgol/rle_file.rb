module MGoL
  class RLEFile
    attr_reader :file_name, :name, :width, :height

    def initialize(file_name)
      @file_name = file_name
      @name = File.basename(file_name).freeze
      @width = @height = 0
      @content = content_from(file_name).freeze
    end

    def each_point
      return to_enum(__method__) unless block_given?
      @count_str = ''
      x = y = 0
      @content.each_char do |c|
        case c
        when '!'.freeze
          return self
        when '$'.freeze
          x = 0
          y += 1
          @count_str = ''
        when '0'.freeze..'9'.freeze
          @count_str << c
        when 'b'.freeze
          x += count
        when 'o'.freeze
          count.times do |i|
            yield(x, y)
            x += 1
          end
        end
      end
      self
    end

    private

    RE_EOH = /^x = (\d+), y = (\d+)/.freeze

    def count
      return 1 if @count_str.empty?
      ret, @count_str = @count_str.to_i, ''
      ret
    end

    def content_from(file_name)
      content = ''
      in_body = false
      IO.read(@file_name).each_line do |line|
        if in_body
          content += line
          line.index('!'.freeze) ? break : next
        end
        if line.start_with?('#N'.freeze)
          @name = line.rstrip[2..-1].tr('_'.freeze, ' '.freeze).freeze
          next
        end
        match = RE_EOH.match(line) or next
        @width = match[1].to_i
        @height = match[2].to_i
        in_body = true
      end
      content
    end
  end
end
