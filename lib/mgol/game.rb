# frozen_string_literal: true

require 'gosu'
require_relative 'board'
require_relative 'edit'
require_relative 'loader'

module MGoL
  Game = Class.new(Gosu::Window) do
    def self.run!(board_class = MGoL::Board)
      new(board_class).show
    end

    def initialize(board_class)
      super(1024, 768, fullscreen: false)
      self.caption = %(Mike's Game of Life Ruby Implementation)
      @board_class = board_class
      @color = Gosu::Color.new(0xff_b89605)
      @small_font = Gosu::Font.new(12)
      @font = Gosu::Font.new(14)
      @paused = true
      clear(8)
    end

    def clear(cell_size = @cell_size)
      @cell_size = cell_size
      @board = @board_class.new(width / cell_size, height / cell_size)
    end

    def update
      @board.generate! unless @paused
    end

    def draw
      @board.each_alive do |x, y|
        Gosu.draw_rect(
          x * @cell_size, y * @cell_size, @cell_size, @cell_size, @color
        )
      end
      @small_font.draw_text(@board.count, 0, height - 16, 0xfffffff1)
      c = Loader.current
      if @paused
        @font.draw_text("#{c.name} (#{c.width}x#{c.height})", 0, 0, 0xfffffff1)
      end
      @small_font.draw_text(Gosu.fps, width - 16, 0, 0xfffffff1)
    end

    def needs_cursor?
      @paused
    end

    def button_down(button_id)
      case button_id
      when Gosu::MS_LEFT
        Edit.insert(@board, *mouse_pos, Loader.current) if @paused
      when Gosu::MS_RIGHT
        Edit.toggle(@board, *mouse_pos) if @paused
      when Gosu::KB_SPACE
        @paused = !@paused
      when Gosu::KB_BACKSPACE
        clear
        @paused = true
      when Gosu::KB_RETURN
        Edit.randomize(@board)
      when Gosu::KB_ESCAPE
        close!
      when Gosu::KB_1..Gosu::KB_9
        clear((button_id - Gosu::KB_1 + 1) * 2)
      when Gosu::KB_LEFT, Gosu::KB_UP
        Loader.select_prev
      when Gosu::KB_RIGHT, Gosu::KB_DOWN
        Loader.select_next
      end
    end

    def mouse_pos
      [(mouse_x / @cell_size).to_i, (mouse_y / @cell_size).to_i]
    end
  end
end
