require './tic-tac-toe.rb'

describe Board do
  it "wins when 3 in a row" do
    b = Board.new
    b.add_symbol('x',[0,0])
    b.add_symbol('x',[0,1])
    b.add_symbol('x',[0,2])
    expect(b.check_for_win).to eql(true)
  end

  it "wins when 3 in a column" do
    b = Board.new
    b.add_symbol('x',[0,0])
    b.add_symbol('x',[1,0])
    b.add_symbol('x',[2,0])
    expect(b.check_for_win).to eql(true)
  end

  it "wins when 3 in a diagonal" do
    b = Board.new
    b.add_symbol('x',[0,0])
    b.add_symbol('x',[1,1])
    b.add_symbol('x',[2,2])
    expect(b.check_for_win).to eql(true)
  end

  it "wins when 3 in other diagonal" do
    b = Board.new
    b.add_symbol('x',[2,0])
    b.add_symbol('x',[1,1])
    b.add_symbol('x',[0,2])
    expect(b.check_for_win).to eql(true)
  end

  it "ties when no more spots available" do 
    b = Board.new
    b.add_symbol('x',[0,0])
    b.add_symbol('x',[0,1])
    b.add_symbol('o',[0,2])
    b.add_symbol('x',[1,0])
    b.add_symbol('o',[1,1])
    b.add_symbol('o',[1,2])
    b.add_symbol('o',[2,0])
    b.add_symbol('x',[2,1])
    b.add_symbol('x',[2,2])
    expect(b.check_for_tie).to eql(true)
  end

  it "doesn't always return true" do
    b = Board.new
    b.add_symbol('x',[0,0])
    b.add_symbol('x',[0,1])
    b.add_symbol('x',[1,0])
    b.add_symbol('o',[1,1])
    b.add_symbol('x',[2,1])
    b.add_symbol('x',[2,2])
    expect(b.check_for_win).to eql(false)
  end
end