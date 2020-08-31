class Node
    include Comparable
    attr_accessor :left, :right, :data
    def initialize(data)
        @data = data
    end

    def to_s
        return "#{data} "
    end
    
    def <=>(other)
        @data <=> other.data
    end
end

class Tree
    attr_accessor :root

    def initialize(arr)
        @root = build_tree(arr.uniq.sort)
    end

    def build_tree(arr)
        return nil if arr.length == 0
        mid = arr.length / 2
        root = Node.new(arr[mid])
        return root if arr.length <= 1
        root.left = build_tree(arr[0..mid-1])
        root.right = build_tree(arr[mid+1..arr.length-1])
        root
    end

    def insert(data)
        node = @root
        loop do
            if data < node.data
                if node.left.nil?
                    node.left = Node.new(data)
                    return true
                end
                node = node.left 
            elsif data > node.data
                if node.right.nil?
                    node.right = Node.new(data)
                    return true
                end
                node = node.right
            else #data == node.data
                return false
            end
        end       
    end
    

    def find(data)
        node = @root
        until node.nil? do
            if data < node.data
                node = node.left
            elsif data > node.data
                node = node.right
            else # data == node.data
                return node
            end
        end
        false
    end

    def get_parent(data)
        parent = nil
        node = @root
        until node.nil? do
            if data < node.data
                parent = node
                node = node.left
            elsif data > node.data
                parent = node
                node = node.right
            else # data == node.data
                return parent
            end
        end
        false
    end

    def count_children(node)
        count = 0
        count += 1 unless node.left.nil?
        count += 1 unless node.right.nil?
        count
    end

    def delete(data)
        parent = get_parent(data)
        return false if parent === false
        if parent.nil?
            parent = Node.new(:placeholder)
            parent.left = @root
        end

        side = parent.left.data == data ? :l : :r 
        node = side == :r ? parent.right : parent.left

        new_node = nil # node to replace current node
        if count_children(node) > 0
            if node.right.nil?
                new_node = node.left
            elsif node.left.nil?
                new_node = node.right

            else # both are not nil
                new_node = node.left
                toAdd = new_node.right unless new_node.right.nil?
                new_node.right = node.right
            end
        end
        if parent.data == :placeholder
            @root = new_node
        elsif side == :r 
            parent.right = new_node
        else
            parent.left = new_node
        end

        insert(toAdd.data) unless toAdd.nil?
        true
    end

    def _depth_order(node, order, &block)
        return if node.nil?
        l = [node.left, node, node.right]
        order.each do |i|
            if i == 1
                yield l[i] 
            else
                _depth_order(l[i], order, &block)
            end
        end
    end

    def _handle_depth(order,&block)
        if block_given?
            _depth_order(@root,order,&block)
        else
            arr = []
            _depth_order(@root, order) {|node| arr.append(node)}
            arr
        end
    end

    
    def preorder(&block) _handle_depth([1,0,2],&block) end
    def inorder(&block) _handle_depth([0,1,2],&block) end
    def postorder(&block) _handle_depth([0,2,1], &block) end


    def _level_order
        queue = [@root]
        until queue.empty?
            yield (node = queue.shift)
            queue.append(node.left) unless node.left.nil?
            queue.append(node.right) unless node.right.nil?
        end
    end

    def level_order(&block)
        if block_given?
            _level_order(&block)
        else
            arr = []
            _level_order {|node| arr.append(node)}
            arr
        end

    end

    def depth(node)
        return 0 if node.nil?
        l = depth(node.left) 
        r = depth(node.right)
        1 + (l > r ? l : r)
    end

    def balanced?(node=@root)
        return true if node.nil?
        b = (depth(node.left) - depth(node.right)).abs <= 1
        return b && balanced?(node.left) && balanced?(node.right)
    end

    def rebalance!
        arr = inorder()
        @root = build_tree(arr)
    end

    def to_s(order=:level_order)
        s = String.new ""
        method(order).call do |node|
            s += "n" + node.to_s
            s += "l:" + node.left.to_s unless node.left.nil?
            s += "r:" + node.right.to_s unless node.right.nil?
            s += "\n"
        end
        s
    end
end

t = Tree.new(Array.new(15) {rand(100)})
puts t.balanced?
[:level_order, :preorder, :inorder, :postorder].each do |order|
    puts "\n#{order}\n#{t.to_s(order)}"
end
[101,102,103,104].each do |num|
    t.insert(num)
end
puts "Balanced after addition: " + t.balanced?.to_s
t.rebalance!
puts "Balanced after rebalance: " + t.balanced?.to_s
[:level_order, :preorder, :inorder, :postorder].each do |order|
    puts "\n#{order}\n#{t.to_s(order)}"
end