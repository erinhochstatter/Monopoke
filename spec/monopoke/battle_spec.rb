RSpec.describe Monopoke::Battle do
  let(:team_id) { "Rocket" }
  let(:team_id_2) { "Green" }
  let(:team_id_3) { "Orange" }
  let(:monopoke_id) { "Meekachu" }
  let(:monopoke_id_2) { "Rastly" }
  let(:monopoke_id_3) { "Flirtle" }
  let(:hp) { "3" }
  let(:ap) { "1" }
  let(:hp_2) { "5" }
  let(:ap_2) { "6" }
  let(:hp_3) { "4" }
  let(:ap_3) { "3" }

  before do
    subject.teams = []
    Monopoke.instance = double(Monopoke, handle_output: nil)
  end

  describe 'create' do
    context 'when all arguments are present and valid' do
      context 'when no team exists with the given team id' do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
        end

        it 'creates a new team with that id' do
          team_names = subject.teams.map(&:name)

          expect(subject.teams.count).to eq(1)
          expect(team_names).to match_array([team_id])
        end

        it 'assigns the team a monopoké with the given id' do
          monster_names = subject.teams.flat_map(&:monsters).map(&:name)

          expect(monster_names).to match_array([monopoke_id])
        end

        it 'assigns the monopoké the provided hp' do
          monsters_hp = subject.teams.flat_map(&:monsters).map(&:hp)

          expect(monsters_hp).to match_array([hp.to_i])
        end

        it 'assigns the monopoké the provided ap' do
          monsters_ap = subject.teams.flat_map(&:monsters).map(&:ap)

          expect(monsters_ap).to match_array([ap.to_i])
        end
      end

      context 'when a team exists with the given team_id' do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id, monopoke_id_2, hp_2, ap_2)
        end

        it 'does not create a new team' do
          team_names = subject.teams.map(&:name)

          expect(subject.teams.count).to eq(1)
          expect(team_names).to match_array([team_id])
        end

        it 'assigns the team a monopoké with the given id' do
          monsters = subject.teams.map(&:monsters)
          monopoke_names = monsters.flatten.map(&:name)

          expect(monopoke_names).to match_array([monopoke_id, monopoke_id_2])
        end

        it 'assigns the monopoké the provided hp' do
          monsters = subject.teams.map(&:monsters)
          monsters_hp = monsters.flatten.map(&:hp)

          expect(monsters_hp).to match_array([hp.to_i, hp_2.to_i])
        end

        it 'assigns the monopoké the provided ap' do
          monsters = subject.teams.map(&:monsters)
          monsters_ap = monsters.flatten.map(&:ap)

          expect(monsters_ap).to match_array([ap.to_i, ap_2.to_i])
        end
      end

      context "when two teams already exist" do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
        end

        it "throws an error" do
          expect{ subject.create(team_id_3, monopoke_id_3, hp_3, ap_3) }.to raise_error(SystemExit)
        end
      end

      context "when a monster exists with the same name" do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id_2, monopoke_id, hp_2, ap_2)
        end

        it "appends a plus to the name" do
          monsters = subject.teams.map { |team| team[:monsters] }
          monopoke_names = monsters.flatten.map { |mon| mon[:name] }

          expect(monopoke_names).to match_array([monopoke_id, "#{monopoke_id} +"])
        end
      end
    end

    context 'when an argument is missing or invalid' do
      it 'generates error output when team_id is missing' do
        expect{ subject.create(nil, monopoke_id_3, hp_3, ap_3) }.to raise_error(SystemExit)
      end

      it 'generates error output when monopoké_id is missing' do
        expect{ subject.create(team_id_3, nil, hp_3, ap_3) }.to raise_error(SystemExit)
      end

      it 'generates error output when hp is missing' do
        expect{ subject.create(team_id_3, monopoke_id_3, nil, ap_3) }.to raise_error(SystemExit)
      end

      it 'generates error output when ap is missing' do
        expect{ subject.create(team_id_3, monopoke_id_3, hp_3, nil) }.to raise_error(SystemExit)
      end

      it 'generates an error if hp is < 1' do
        expect{ subject.create(team_id_3, monopoke_id_3, 0, ap_3) }.to raise_error(SystemExit)
      end

      it 'generates an error if ap is < 1' do
        expect{ subject.create(team_id_3, monopoke_id_3, hp_3, -2) }.to raise_error(SystemExit)
      end
    end
  end

  describe 'ichooseyou' do
    context "without both teams" do
      before do
        subject.create(team_id, monopoke_id, hp, ap)
      end
      it "throws an error" do
        expect{ subject.ichooseyou(monopoke_id) }.to raise_error(SystemExit)
      end
    end

    context "when both teams are present" do
      before do
        subject.create(team_id, monopoke_id, hp, ap)
        subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
      end

      context "when player one chooses first" do
        before do
          subject.ichooseyou(monopoke_id)
        end

        it "chooses the monster" do
          first_monster = subject.teams.first.monsters.first

          expect(first_monster.chosen).to eq(true)
        end

        it "starts the battle" do
          expect(subject.active).to eq(true)
        end
      end

      context "when player two chooses first" do
        # Note: I might refactor the input to take a team id argument on this command.

        it "throws an error" do
          expect{ subject.ichooseyou(monopoke_id_2) }.to raise_error(SystemExit)
        end
      end
    end
  end

  describe "attack" do
    before do
      subject.create(team_id, monopoke_id, hp, ap)
      subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
      subject.ichooseyou(monopoke_id)
      subject.ichooseyou(monopoke_id_2)
    end

    context "when called on the chosen monster" do
      let(:target) { subject.all_monsters.select { |monster| monster.name == monopoke_id_2 }.first }
      let(:first_team) { subject.teams.first }
      let(:second_team) { subject.teams.last }

      it "subtracts its ap value from the opposing monster's health" do
        expect{ subject.attack }.to change(target, :hp).from(hp_2.to_i).to(hp_2.to_i - ap.to_i)
      end

      describe "after the damage calculated" do
        context "when the opposing player has > 0 hp" do
          it "sets the next turn to the other team" do
            target.hp = 10
            expect(subject.active).to eq(true)
            expect{ subject.attack }.to change(subject, :active_team).from(first_team).to(second_team)
          end
        end

        context "when the opposing player has <= 0 hp" do
          before do
            target.hp = 1
          end

          it "the monster is defeated" do
            expect{ subject.attack }.to change(target, :defeated?).from(false).to(true)
          end

          it "ends the game if no additional monsters are available" do
            expect{ subject.attack }.to change(subject, :active).from(true).to(false)
          end

          it "requires the opposing player to select a new monster, if possible" do

            subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
            expect{ subject.attack }.to change(subject, :active_team).from(first_team).to(second_team)
            expect{ subject.attack }.to change(subject, :active_team).from(second_team).to(first_team)
          end
        end
      end
    end
  end

  describe "finish_game" do
    before do
      subject.create(team_id, monopoke_id, hp, ap)
      subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
      subject.ichooseyou(monopoke_id)
    end

    it "sets the current battle to inactive" do
      expect{subject.finish_game}.to change(subject, :active).from(true).to(false)
    end

    it "exits the app" do
      expect{subject.finish_game}.to raise_error(SystemExit:true)
    end
  end
end
