require 'matrix'

class Board

  attr_accessor :board
  @@default_value = "*"

  def initialize(width=7,height=6)
    @board = self.class.make_board(width, height)
  end

  def self.default_value
    @@default_value
  end

  def self.make_board(width, height)
    board = []
    width.times do 
      ls = []
      height.times {ls.append(@@default_value)}
      board.append(ls)
    end
    board
  end

  def drop_symbol(symbol, column)
    row = 0
    until @board[column][row] == @@default_value
      return false if row >= 7
      row += 1
    end
    @board[column][row] = symbol
    [column, row]
  end

  def _get(pos)
    @board[pos[0]][pos[1]]
    rescue NoMethodError
      # out of bounds
      @@default_value
  end

  def winning_move?(pos)
    reference = _get(pos) 
    positions = [
      Vector[0,1], #up/down
      Vector[1,1], #up-right/down-left
      Vector[1,0], #right/left
      Vector[1,-1] #down-right/up-left
    ].each do |offset|
      count = 0
      temppos = Vector.elements(pos) - offset*3
      7.times do # 6 positions to check, temppos at the end is +1 offset
        if reference == _get(temppos)
          count += 1
        else
          count = 0
        end
        return true if count >= 4
        temppos += offset
      end
    end
    false
  end

  def to_s
    s = String.new ""
    proper = @board.transpose.reverse
    proper.each do |row|
      s += row.join(" ") + "\n"
    end
    s.rstrip
  end

end
