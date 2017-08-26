# frozen_string_literal: true

module MGoL
  module Edit
    def self.toggle(board, x, y)
      board[x, y] = !board[x, y]
    end

    def self.randomize(board, density: 11)
      to_set = ((density * board.height * board.width) / 100)
      board.clear!
      x_range = (0..board.width - 1)
      y_range = (0..board.height - 1)
      while to_set > board.count
        board[rand(x_range), rand(y_range)] = true
      end
    end

    def self.insert(board, x, y, points)
      x.upto(x + points.width - 1) do |i|
        y.upto(y + points.height - 1){ |j| board[i, j] = false }
      end
      points.each_point{ |i, j| board[x + i, y + j] = true }
    end
  end
end
