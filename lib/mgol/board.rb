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
      @gen = {}
      @gen.default = 0
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
      ret, fringe = {}, {}
      ret.default = 0
      @gen.each_key do |key|
        alive_neighbors = 0

        k = key - 1
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        k = key + 1
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        # above
        k = key - @width
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        k -= 1
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        k += 2
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        # below
        k = key + @width
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        k -= 1
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        k += 2
        v = @gen[k]
        alive_neighbors += v
        fringe[k] = 1 if v.zero?

        ret[key] = 1 if 2 == alive_neighbors || 3 == alive_neighbors
      end
      fringe.each_key{ |k| ret[k] = 1 if 3 == alive_neighbors_at(k) }
      ret
    end

    def alive_neighbors_at(key)
      above = key - @width
      below = key + @width
      @gen[above - 1] +
        @gen[above] +
        @gen[above + 1] +
        @gen[key - 1] +
        @gen[key + 1] +
        @gen[below - 1] +
        @gen[below] +
        @gen[below + 1]
    end
  end
end
