class Code

  def initialize(code=nil)
    @code = code ? code : Array.new(4) {rand(6)}
  end

  def self.valid_code?(code)
    return false unless code.length == 4
    code.all? {|num| (0..5).include?(num)}
  end

  def differences(other)
    blacks = 0
    whites = 0
    hash = Hash.new(0)
    @code.each_index do |i|
      if @code[i] == other[i]
        blacks += 1 
      else
        whites += 1 if hash[@code[i]] > 0 || hash[other[i]] < 0
        hash[@code[i]] -= 1
        hash[other[i]] += 1
      end
    end
    return [blacks, whites]
  end

  def to_s
    return @code.to_s
  end

  def [](number)
    return @code[number]
  end
end


class Game
  def initialize
    @round_count = 12
    @master_code = Code.new
    @history = []
  end

  

  def self.get_guess
    print("Enter guess: ")
    until Code.valid_code?(inp = gets.chomp.split(" ").map {|num| num.to_i})
      print("Try again: ")
    end
    Code.new(inp)
  end

  def play_round
    guess = self.class.get_guess
    blacks, whites = @master_code.differences(guess)
    @history.append([guess,blacks,whites])
    printHistory()
    if blacks == 4
      puts("You win!")
      return true
    end
    false
  end

  def printHistory
    @history.each {|guess| printGuess(*guess)}
    puts("Rounds left: #{@round_count}")
  end

  def printGuess(guess,blacks,whites)
    puts("#{guess} B:#{blacks} W:#{whites}\n")
    # puts(@master_code.to_s)
  end

  def play
    while @round_count > 0
      @round_count -= 1
      wins = play_round
      return if wins
    end
    puts("You lost!")
    puts("code was: #{@master_code.code}")
  end
end

g = Game.new()
g.play()