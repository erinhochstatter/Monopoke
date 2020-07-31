RSpec.describe Monopoke::Monster do
  subject { Monopoke::Monster.new(name: "Bulbapuff", hp: 2, ap: 3) }

  before do
    Monopoke.instance = double(Monopoke, handle_output: nil)
  end

  describe "defeated?" do
    it "returns true if the monster is out of hp" do
      subject.hp = 0
      expect(subject.defeated?).to eq(true)
    end

    it "returns false if the monster has hp" do
      expect(subject.defeated?).to eq(false)
    end
  end

  describe "defeat!" do
    it "updates the monster to be un-chosen" do
      subject.chosen = true
      expect{subject.defeat!}.to change(subject, :chosen).to(false)
    end

    it "sends some output to the handler"
  end

  describe "available?" do
    it "returns false if the monster defeated" do
      subject.hp = 0
      expect(subject.available?).to eq(false)
    end

    it "returns false if the monster is chosen" do
      subject.chosen = true
      expect(subject.available?).to eq(false)
    end

    it "returns true otherwise" do
      expect(subject.available?).to eq(true)
    end
  end
end