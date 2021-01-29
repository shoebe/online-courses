# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces | 
                  [rotations([[-1, 1], [-1, 0], [0, 1], [0, 0], [1, 1]]),  # square with a piece jutting out
                  [ [[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]], 
                    [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]], # extra long (only needs two)
                  rotations([[0, 0], [1, 0], [0, 1]])] # square missing a piece
  
  Cheat_Piece = [[0,0]] # a single square
  
  def self.next_piece (board)
    Piece.new(All_My_Pieces.sample, board)
  end

  def self.cheat_piece (board)
    Piece.new(Cheat_Piece, board)
  end

end

class MyBoard < Board
  def initialize (game)
    super
    @cheat_piece_next = false
  end
  
  def next_piece
    if @cheat_piece_next
      @current_block = MyPiece.cheat_piece(self)
      @cheat_piece_next = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  def rotate_180_deg
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def store_current
    # New pieces can have less or more than 4 squares, range is 0..numofpieces-1
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.length-1)).each{|index| 
      current = locations[index]
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  def on_cheat_button_click
    if !@cheat_piece_next and @score >= 100
      @score -= 100
      @cheat_piece_next = true
    end
  end
end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

def key_bindings
    super
    @root.bind('u', proc {@board.rotate_180_deg})
    @root.bind('c', proc {@board.on_cheat_button_click})
  end

end


