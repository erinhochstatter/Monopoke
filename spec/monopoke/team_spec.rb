RSpec.describe Monopoke::Team do
  subject { Monopoke::Team.new(name: "Valorious", monsters: []) }
  let(:name) { "Whatatta" }
  let(:hp) {4}
  let(:ap) {2}

  before do
    Monopoke.instance = double(Monopoke, handle_output: nil)
  end

  describe "add_monster" do
    context "with the correct monster arguments" do
      it "creates a new monster" do
        expect(Monopoke::Monster).to receive(:new).with(name: name, hp: hp, ap: ap)
        subject.add_monster(name, hp, ap)
      end

      it "adds the new monster to the team's roster" do
        subject.add_monster(name, hp, ap)
        expect(subject.monsters).to include(Monopoke::Monster)
      end
    end
  end

  describe "find_monster"

  describe "choose_monster"

  describe "chosen_monster"

  describe "available_monsters"
end