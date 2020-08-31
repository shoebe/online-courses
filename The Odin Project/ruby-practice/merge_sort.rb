# frozen_string_literal: true

def add_rest(iter, index, arr)
  loop do
    arr[index] = iter.next
    index += 1
  end
end

def two_ranges(arr, range1, range2)
  a = arr[range1].each
  b = arr[range2].each
  insert = range1.first
  loop do
    arr[insert] = a.peek > b.peek ? a.next : b.next
    insert += 1
  end
  [a, b].each { |rest| add_rest(rest, insert, arr) }
end

def merge_sort(arr)
  step = 1
  until step*2 > arr.length
    for cur_ind in (step..arr.length-step).step(step*2)
      two_ranges(arr,
                cur_ind-step..cur_ind-1,
                cur_ind..cur_ind+step-1 )
    end
    # sort last bit left out from ^^
    two_ranges(arr,
               cur_ind-step..cur_ind+step-1, # entire last range from ^^
               cur_ind+step..arr.length-1)
    step *= 2
  end
end



def is_sorted(arr)
  puts("Not sorted!!  #{arr}, #{arr.sort.reverse}") if arr != arr.sort.reverse
end

50.times do 
  ls = Array.new(2134) {rand(124214)}
  merge_sort(ls)
  is_sorted(ls)
end