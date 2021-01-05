require "./basic.rb"

describe "caesar_cipher" do
  it "works with a few letters and small jumps" do
    expect(caesar_cipher("aAa",1)).to eql("bBb")
  end
  it "wraps lowercase and uppercase characters" do
    expect(caesar_cipher("Yyy",2)).to eql("Aaa")
  end
  it "wraps lowercase and uppercase characters" do
    expect(caesar_cipher("Yyyyy",2)).to eql("Aaaaa")
  end
  it "wraps lowercase and uppercase characters with negative jumps" do
    expect(caesar_cipher("Aaa",-2)).to eql("Yyy")
  end
  it "ignores anything that is not a letter" do
    expect(caesar_cipher("Hello {my} name is bob.",1)).to eql("Ifmmp {nz} obnf jt cpc.")
  end
  it "wraps properly" do 
    expect(caesar_cipher("a",27)).to eql("b")
  end
  it "wraps properly with huge jumps" do 
    expect(caesar_cipher("s",-105)).to eql("r")
  end
end
