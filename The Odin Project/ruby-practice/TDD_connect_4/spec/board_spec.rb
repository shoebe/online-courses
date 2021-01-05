require './lib/board'

describe Board do


  describe "#make_board" do
    it "makes a board of a certain size" do
      b = Board.make_board(4,5)
      expect([b.length, b[0].length]).to eql([4,5])  
    end
    it "initializes with a default value" do
      b = Board.make_board(2,2)
      expect(b).to satisfy {|b| b.flatten.all?(Board.default_value)}
    end
  end

  let(:b) {Board.new}



  describe "#initialize" do
    it "saves a 7x6 board to @board using make_board" do
      expect([b.board.length, b.board[0].length]).to eql([7,6])  
    end
  end



  describe "#drop_symbol" do
    it "drops a symbol in an empty column" do
      b.drop_symbol('X', 0)
      expect(b.board[0][0]).to eql('X')  
    end

    it "drops a symbol in a non-empty column" do
      b.drop_symbol('X', 0)
      b.drop_symbol('Y', 0)
      expect(b.board[0][1]).to eql('Y')  
    end

    it "returns the position of drop on sucessful drop" do
      b.drop_symbol('Y',0)
      expect(b.drop_symbol('X', 0)).to eql([0,1])  
    end


    context "full column" do
      it "returns false on attempt to drop symbol" do
        6.times {b.drop_symbol('X',0)}
        expect(b.drop_symbol('X',0)).to be false 
      end
  

      it "doesn't ovewrite any symbols" do
        6.times {b.drop_symbol('X',0)}
        b.drop_symbol('Y',0)
        expect(b.board[0].all?('X')).to be true
      end
    end
  end



  describe "#winning_move?" do


    context "should return true" do
      
      it "if four in a column" do
        # X
        # X
        # X
        # X
        b.drop_symbol('X',3)
        b.drop_symbol('X',3)
        b.drop_symbol('X',3)
        pos = b.drop_symbol('X',3)
        expect(b.winning_move?(pos)).to be true
      end

      it "if four in a row" do
        # X X X X
        b.drop_symbol('X',0)
        b.drop_symbol('X',1)
        b.drop_symbol('X',2)
        pos = b.drop_symbol('X',3)
        expect(b.winning_move?(pos)).to be true
      end

      it "if four in a diagonal(up-right/down-left)" do
        #       X
        #     X .
        #   X . . 
        # X . . .
        b.drop_symbol('X',0)
  
        b.drop_symbol('.',1)
        b.drop_symbol('X',1)
  
        b.drop_symbol('.',2)
        b.drop_symbol('.',2)
        b.drop_symbol('X',2)
  
        b.drop_symbol('.',3)
        b.drop_symbol('.',3)
        b.drop_symbol('.',3)
        pos = b.drop_symbol('X',3)
  
        expect(b.winning_move?(pos)).to be true
      end
  
      it "if four in a diagonal(up-left/down-right)" do
        # X
        # . X 
        # . . X 
        # . . . X 
        b.drop_symbol('X',3)
  
        b.drop_symbol('.',2)
        b.drop_symbol('X',2)
  
        b.drop_symbol('.',1)
        b.drop_symbol('.',1)
        b.drop_symbol('X',1)
  
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        pos = b.drop_symbol('X',0)
  
        expect(b.winning_move?(pos)).to be true
      end

      it "every position of 4-in-row" do
        # X
        # . X 
        # . . X 
        # . . . X 
        positions = []
        positions.append(b.drop_symbol('X',3))
  
        b.drop_symbol('.',2)
        positions.append(b.drop_symbol('X',2))
  
        b.drop_symbol('.',1)
        b.drop_symbol('.',1)
        positions.append(b.drop_symbol('X',1))
  
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        positions.append(b.drop_symbol('X',0))
  
        expect(positions).to satisfy do |arr|
           arr.each{|pos| b.winning_move?(pos)}  
        end
      end

      it "on boundary case (y=5)" do
        # X
        # X
        # X
        # X 
        # X 
        # X
        6.times {b.drop_symbol("X", 0)}
        expect(b.winning_move?([0,5])).to be true
      end 
  
      it "on boundary case (x=6)" do
        # X X X X X X X
        7.times do |num|
          b.drop_symbol("X", num)
        end
        expect(b.winning_move?([6,0])).to be true
      end
    end
    

    context "should return false" do
      it "if only 3 in a column" do
        # X
        # X
        # X
        b.drop_symbol('X',3)
        b.drop_symbol('X',3)
        pos = b.drop_symbol('X',3)
        expect(b.winning_move?(pos)).to be false 
      end
  
      it "if four obstructed by an item in a column" do
        # X
        # X
        # .
        # X
        # X
        b.drop_symbol('X',3)
        b.drop_symbol('X',3)
        b.drop_symbol('.',3)
        b.drop_symbol('X',3)
        pos = b.drop_symbol('X',3)
        expect(b.winning_move?(pos)).to be false 
      end
  
      it "if four in a row with obstruction" do
        # X X X . X
        b.drop_symbol('X',0)
        b.drop_symbol('X',1)
        b.drop_symbol('X',2)
        b.drop_symbol('.',3)
        pos = b.drop_symbol('X',4)
        expect(b.winning_move?(pos)).to be false 
      end
  
      it "if four in a diagonal(up-left/down-right) with obstruction)" do
        # X
        # . X
        # . . I
        # . . . X
        # . . . . X 
        b.drop_symbol('X',4)
  
        b.drop_symbol('.',3)
        b.drop_symbol('X',3)
  
        b.drop_symbol('.',2)
        b.drop_symbol('.',2)
        b.drop_symbol('I',2)
  
        b.drop_symbol('.',1)
        b.drop_symbol('.',1)
        b.drop_symbol('.',1)
        pos = b.drop_symbol('X',1)
  
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        b.drop_symbol('.',0)
        b.drop_symbol('X',0)
  
        expect(b.winning_move?(pos)).to be false 
      end
      
      it "if 4 or more in a row but not in a constant direction" do
        #       X
        #     X .
        # X X . . 
        b.drop_symbol("X",0)
  
        pos = b.drop_symbol("X",1)
  
        b.drop_symbol(".",2)
        b.drop_symbol("X",2)
  
        b.drop_symbol(".",3)
        b.drop_symbol(".",3)
        b.drop_symbol("X",3)
  
        expect(b.winning_move?(pos)).to be false
      end
      
      it "on all positions, with obstructions" do
        # X X X . X . X
        positions = []
  
        positions.append(b.drop_symbol("X",0))
        positions.append(b.drop_symbol("X",1))
        positions.append(b.drop_symbol("X",2))
        b.drop_symbol(".",3)
        positions.append(b.drop_symbol("X",4))
        b.drop_symbol(".",5)
        positions.append(b.drop_symbol("X",6))
  
        expect(positions).to satisfy do |arr|
          arr.each {|pos| !b.winning_move?(pos)}
        end
      end
    end
  end


  
  describe "#to_s" do
    d = Board.default_value
    expected = Array.new(6) {
                            ([d] * 7).join(" ")
                            }
    it "prints only the default values if empty" do
      expect(b.to_s).to eql(expected.join("\n"))
    end

    it "prints values if they are added" do
      e = expected.dup
      b.drop_symbol("X",0)
      e[5][0] = "X"
      expect(b.to_s).to eql(e.join("\n"))
    end
  end
end
