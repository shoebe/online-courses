def wrap(value, bounds)
  value += 26 while value < bounds[0]
  value -= 26 while value > bounds[1]
  return value
end

def caesar_cipher(string, amount)
  lowerBound = [97, 122] # 'a'.ord, 'z'.ord
  upperBound = [65, 90]  # 'A'.ord, 'Z'.ord
  string.chars.map do |letter|
    val = letter.ord
    val = wrap(val + amount, lowerBound) if val.between?(*lowerBound)
    val = wrap(val + amount, upperBound) if val.between?(*upperBound)
    val.chr
  end.join
end

# caesar_cipher("hello",3)

def substrings(string, dictionary)
  string.downcase!
  dictionary.reduce(Hash.new(0)) do |hash, word|
    i=0
    while (match = string.match(word,i)) do
      i = match.begin(0) + word.length
      hash[word] += 1
    end
    hash
  end
end

# dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
# puts(substrings("below", dictionary))
# puts(substrings("Howdy partner, sit down! How's it going?", dictionary))

def stock_picker(arr)
  biggest = days = [0, 0]
  arr.each_with_index  do |item, i|
    if item < arr[days[0]]
      biggest = days if arr[days[1]] - arr[days[0]] > 
                        arr[biggest[1]] - arr[biggest[0]] 
      days = [i, i]
    end
    days[1] = i if item > arr[days[1]]
  end
  return biggest
end



# puts(stock_picker([17,3,6,9,15,8,6,1,10]))

def bubble_sort(arr)
  max = arr.length-1
  (max..2).step(-1).each do |last|
    last.times do |i|
      arr[i],arr[i+1] = arr[i+1], arr[i] if arr[i+1] > arr[i]
    end
  end
  return arr
end

puts(bubble_sort([4,3,78,2,0,2]))

