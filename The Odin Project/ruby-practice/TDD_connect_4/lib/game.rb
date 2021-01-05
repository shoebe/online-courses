require './lib/board'

class Game
  attr_accessor :board, :input
  @@players = {:P1 => "X", :P2 => "Y"}
  def initialize(input: $stdin)
    @board = Board.new
    @input = input
  end

  def clear_and_print()
    print "\e[H\e[2J" # clears screen
    puts "0 1 2 3 4 5 6"
    puts "-------------"
    puts @board.to_s
  end

  def input_coords()
    inp = @input.gets.chomp
    p inp
    return false unless inp =~ /^[0-9]/
    inp = inp.to_i
    return false unless (0..6).include?(inp)
    inp
  end

  def winner(player)
    clear_and_print()
    puts "#{player} has won!"
  end
#...............................
#...............................FFFF
  def play
    loop do
      @@players.keys.each do |player|
        clear_and_print()
        print ">> #{player}: "
        until (row = input_coords()) do 
          print "> Please enter a valid row number (ex: 0): "
        end
        position = @board.drop_symbol(@@players[player], row)
        if @board.winning_move?(position)
          winner(player)
          return
        end
      end
    end
  end

end

input = StringIO.new
["1","1","2","2","3","3","4","4"].each() {|thing| input.puts(thing)}
input.rewind
g = Game.new(input: input)
g.play