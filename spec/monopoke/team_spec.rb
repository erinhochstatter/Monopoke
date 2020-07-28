RSpec.describe Monopoke::Team do
  subject { Monopoke::Team.new(name: "Valorious", monsters: []) }

  before do
    Monopoke.instance = double(Monopoke, handle_output: nil)
  end

  describe "add_monster"
end