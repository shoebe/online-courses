class Board
  def initialize
    @board = Array.new(3){Array.new(3," ")}
  end

  def check_for_win
    [ 
      *@board,
      *@board.transpose,
      [@board[0][0], @board[1][1], @board[2][2]],
      [@board[2][0], @board[1][1], @board[0][2]]
    ].each do |set|
      return true if set.uniq.length == 1 && set[0] != " "
    end
    false
  end

  def check_for_tie
    @board.each do |row|
      row.each {|item| return false if item == " "}
    end
    true
  end

  def add_symbol(symbol, pos)
    return false unless @board[pos[0]][pos[1]] == " " && 
                        (pos[0] < 3 && pos[1] < 3)
    @board[pos[0]][pos[1]] = symbol
    rescue
      return false
  end

  def to_s
    arr = ["\n "]
    @board.each do |row|
      row.each do |item|
        arr.append(item)
        arr.append(" | ")
      end
      arr.pop # pop trailing " | "
      arr.append("\n---+---+---\n ")
    end
    arr.pop
    arr.append("\n\n")
    arr.join()
  end
end



class Game
  @@players = {:P1 => "X", :P2 => "O"}

  def initialize
    @board = Board.new
  end

  def place
    loop do
      @@players.keys.each do |player|
        puts(@board)
        print("#{player}, enter position (ex: x,y): ")
        pos = gets.chomp.split(",").map {|int| int.to_i}
        until @board.add_symbol(@@players[player], pos)
          print("Invalid position, try again: ")
          pos = gets.chomp.split(",").map {|int| int.to_i}
        end
        return player if @board.check_for_win
        return false if @board.check_for_tie
      end
    end
  end

  def play
    result = place
    puts(@board)
    result ? puts("#{result} wins!") : puts("Tie!")
  end
end

if $PROGRAM_NAME == __FILE__
  game = Game.new
  game.play
end