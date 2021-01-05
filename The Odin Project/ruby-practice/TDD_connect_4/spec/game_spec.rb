require './lib/game'
require 'stringio'

def put_to_input(io, *input)
  input.each do |inp|
    io.puts inp
  end
  io.rewind
end

describe Game do
  let(:io) {StringIO.new}
  subject {Game.new(input: io)}

  describe "#new" do
    it "saves a Board instance to @board" do
      expect(subject.board.is_a?(Board)).to eql(true)
    end
  end



  describe "#clear_and_print" do
    it "prints something" do
      expect{subject.clear_and_print}.to output.to_stdout
    end
  end



  describe "#input_coords" do
    it "receives input and returns selected row" do
      put_to_input(io,"0")
      expect(subject.input_coords()).to eql(0)
    end

    context "bad input" do
      it "returns false on out of bounds (row 7)" do
        put_to_input(io,"7")
        expect(subject.input_coords()).to be false
      end
      
      it "returns false on out of bounds (row -1)" do
        put_to_input(io,"-1")
        expect(subject.input_coords()).to be false
      end

      it "returns false on invalid format" do
        put_to_input(io,"(7,3)")
        expect(subject.input_coords()).to be false
      end

      it "doesnt return erroneous data" do
        put_to_input(io,"a")
        expect(subject.input_coords()).to_not eql(0)
      end
    end
  end

  describe "#winner" do
    it "prints something" do
      expect{subject.winner(:P1)}.to output.to_stdout
    end
  end


  describe "#play" do

    it "alternates between players" do 
      put_to_input(io,"1","1","2","2","3","3","4","4")
      subject.play
      expect(subject.board.board[1][0]).to_not eql(subject.board.board[1][1])  
    end

    it "wins" do
      put_to_input(io,"1","1","2","2","3","3","4","4")
      expect{subject.play}.to output(/(P1 has won!)$/).to_stdout
    end
  end
  
end
