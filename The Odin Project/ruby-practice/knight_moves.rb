class Node

  attr_accessor :x, :y, :neighbours
  def initialize(x,y)
    @x = x
    @y = y
    @neighbours = []
  end

  def init_neighbours(list)
    # clockwise
    [[-2,-1],[-2,1], #left
     [-1,2],[1,2],   #up
     [2,1],[2,-1],   #right
     [1,-2],[-1,-2]  #down
    ].each do |offset|
      neighbour_loc = [@x + offset[0], @y + offset[1]]
      if neighbour_loc.all? {|val| (0..7).include?(val)}
        @neighbours.append(list[neighbour_loc[0]][neighbour_loc[1]])
      end
    end
  end

  def self_and_neighbours_to_s
    s = String.new ""
    s << to_s + "neighbours:\n"
    @neighbours.each do |neighbour|
      s << neighbour.to_s << " "
    end
    s
  end

  def to_s
    "(#{@x}, #{@y})"
  end
end

class Board

  def initialize
    @node_list = self.class.build_board()
    each_node() {|node| node.init_neighbours(@node_list)}
  end

  def self.build_board
    ls = []
    (0..7).each do |i|
      temp = []
      (0..7).each do |j|
        temp.append(Node.new(i,j))
      end
      ls.append(temp)
    end
    ls
  end

  def each_node
    @node_list.each do |row|
      row.each do |node|
        yield node
      end
    end
  end

  def knight_moves(from, to)
    from = @node_list[from[0]][from[1]]
    to = @node_list[to[0]][to[1]]
    visited = Hash.new
    queue = [from]
    until (node = queue.shift) === to
      node.neighbours.each do |neighbour|
        next if visited.include?(neighbour)
        visited[neighbour] = node
        queue.append(neighbour)
      end
    end
    path = [node]
    until (node = visited[node]) === from
      path.unshift(node)
    end
    path.unshift(from)
  end
end

b = Board.new
from = [3,3]
to = [4,3]
puts "Move from #{from} to #{to}"
path = b.knight_moves(from,to)
puts "Made it in #{path.length-1} moves. Path:"
path.each do |node|
  puts node.to_s
end