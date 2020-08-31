# frozen_string_literal: true

class Node
    attr_accessor :next, :data
    def initialize(data)
        @data = data
        @next = nil
    end
end

class LinkedList
    def initialize
        @head = Node.new("I head")
        @tail = Node.new("I tail")
        @head.next = @tail
    end

    def append(node)
        @tail.next = node
        @tail = node
    end

    def prepend(node)
        node.next = @head
        @head = node
    end

    def size
        count = 1
        node = @head
        count += 1 until (node = node.next).nil?
        count
    end

    def at(index)
        node = @head
        node = node.next until (index -= 1) == -1
        node
    end

    def pop
        node = @head
        node = node.next until node.next.next.nil? 
        node.next = nil
        @tail = node
    end

    def contains?(data)
        node = @head
        loop do 
            return true if node.data == data
            break if (node = node.next).nil?
        end
        false
    end

    def find(data)
        node = @head
        ind = 0
        loop do
            return ind if node.data == data
            break if (node = node.next).nil?
            ind += 1
        end
        nil
    end

    def to_s
        s = String.new ""
        node = @head
        loop do
            s << "( #{node.data} ) -> "
            break if (node = node.next).nil?
        end
        s << "nil"
    end

    def insert_at(node, ind)
        node_at_index = at(ind-1)
        node.next = node_at_index.next
        node_at_index.next = node
    end

    def remove_at(ind)
        node_at_previous_index = at(ind-1)
        node_at_previous_index.next = node_at_previous_index.next.next
    end
end

ll = LinkedList.new
[Node.new("hi"), Node.new("bonjour mon ami"), Node.new("yes")].each do |node|
    ll.append(node)
end
puts ll
puts "pop"
ll.pop
puts ll
puts "find 'hi'"
puts ll.find("hi")
puts "contains 'bonjour mon ami'"
puts ll.contains?("bonjour mon ami")
puts "at 1"
puts ll.at(1).data
puts "insert 'i am here' at 1"
ll.insert_at(Node.new("i am here"), 1)
puts ll
puts "remove item at 3"
ll.remove_at(3)
puts ll
puts "size"
puts ll.size
puts "append 'actual last', prepend 'actual first'"
ll.append(Node.new("actual last"))
ll.prepend(Node.new("actual first"))
puts ll