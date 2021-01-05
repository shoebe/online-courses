require 'set'

def get_rand_word()
  word = ''
  File.open('5desk.txt', 'r') do |file|
    lines = file.readlines
    until word.length > 5 && word.length < 12
      word = lines[rand(lines.length)].chomp
    end
  end
  word
end

class Game
  def initialize(word, lives = 6)
    @lives = lives
    @word = word
    @letters_found = Set.new
  end

  def get_input
    print('Enter guess: ')
    gets.chomp
  end

  def try_letter(letter)
    @word.downcase.include?(letter.downcase) && @letters_found.add(letter)
  end

  def play
    while @lives > 0
      puts(to_s)
      guess = get_input()

      next save() if guess == 'save'

      @lives -= 1 unless try_letter(guess)
      return win() if @letters_found.size >= @word.size
    end
    game_over()
  end

  def game_over
    puts("You lost!\nWord was: #{@word}")
  end

  def win
    puts('Victory!')
  end

  def to_s
    @word.chars.each do |char|
      @letters_found.include?(char.downcase) ? print(char + ' ') : print('_ ')
    end
    puts("  #{@lives} tries remaining!")
  end

  def save
    num = 0
    num += 1 while File.exist?("saves/save#{num}.sv")
    File.open("saves/save#{num}.sv", 'w') do |file|
      Marshal.dump(self, file)
    end
  end

  def self.load
    puts saves = Dir.glob('saves/*').map { |save| save.split('/').last }
    print 'Enter save file name: '
    save = gets.chomp until saves.include?(save)
    Marshal.load(File.new("saves/#{save}"))
  end
end

print("'load' or 'play'\n> ")
c = gets.chomp until %w[load play].include?(c)
g = Game.load if c == 'load'
g = Game.new(get_rand_word) if c == 'play'
g.play
