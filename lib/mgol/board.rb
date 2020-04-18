# frozen_string_literal: true

# high optimized board version using hashes with integers offsets

module MGoL
  class Board
    attr_reader :width, :height

    def initialize(width, height)
      @width, @height = width, height
      @max_offset = width + height * width
      clear!
    end

    def count
      @gen.size
    end

    def [](x, y)
      @gen.key?((y * @width + x) % @max_offset)
    end

    def []=(x, y, alive)
      key = (y * @width + x) % @max_offset
      alive ? @gen[key] = 1 : @gen.delete(key)
    end

    def clear!
      @gen = Hash.new(0).compare_by_identity
    end

    def each_alive
      @gen.each_key do |key|
        y = key / @width
        yield(key - @width * y, y)
      end
    end

    def generate!
      @gen = next_generation
    end

    private

    def next_generation
      ret = Hash.new(0).compare_by_identity
      fringe = {}.compare_by_identity
      @gen.each_key do |key|
        alive_neighbors = 0

        k = key - 1 # left
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k -= @width # left above
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k += 1 # above
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k += 1 # right above
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k += @width # right
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k += @width # right below
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k -= 1 # below
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        k -= 1 # left below
        @gen.key?(k) ? alive_neighbors += 1 : fringe[k] = 1

        (2 == alive_neighbors || 3 == alive_neighbors) && ret[key] = 1
      end
      fringe.each_key{ |key| 3 == alive_neighbors_at(key) && ret[key] = 1 }
      ret
    end

    def alive_neighbors_at(key)
      @gen[key - 1] +
        @gen[key + 1] +
        @gen[above = key - @width] +
        @gen[above - 1] +
        @gen[above + 1] +
        @gen[below = key + @width] +
        @gen[below - 1] +
        @gen[below + 1]
    end
  end
end
