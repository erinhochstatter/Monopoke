RSpec.describe Monopoke do
  describe 'create' do
    let(:team_id) { "Rocket" }
    let(:team_id_2) { "Green" }
    let(:team_id_3) { "Orange" }
    let(:monopoke_id) { "Meekachu" }
    let(:monopoke_id_2) { "Rastly" }
    let(:monopoke_id_3) { "Flirtle" }
    let(:hp) { 3 }
    let(:ap) { 1 }
    let(:hp_2) { 5 }
    let(:ap_2) { 6 }
    let(:hp_3) { 4 }
    let(:ap_3) { 3 }

    context 'when all arguments are present and valid' do
      context 'when no team exists with the given team id' do
        before do
          subject.battle.teams = []
          subject.create(team_id, monopoke_id, hp, ap)
        end

        it 'creates a new team with that id' do
          team_names = subject.battle.teams.map(&:name)

          expect(subject.battle.teams.count).to eq(1)
          expect(team_names).to match_array([team_id])
        end

        xit 'tracks whether the team was created first' do
          first_team = subject.battle.teams.first
          expect(first_team[:is_player_one?]).to be(true)
        end

        it 'assigns the team a monopoké with the given id' do
          monster_names = subject.battle.teams.flat_map(&:monsters).map(&:name)

          expect(monster_names).to match_array([monopoke_id])
        end

        it 'assigns the monopoké the provided hp' do
          monsters_hp = subject.battle.teams.flat_map(&:monsters).map(&:hp)

          expect(monsters_hp).to match_array([hp])
        end

        it 'assigns the monopoké the provided ap' do
          monsters_ap = subject.battle.teams.flat_map(&:monsters).map(&:ap)

          expect(monsters_ap).to match_array([ap])
        end
      end

      context 'when a team exists with the given team_id' do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id, monopoke_id_2, hp_2, ap_2)
        end

        it 'does not create a new team' do
          team_names = subject.battle.teams.map { |team| team[:name] }

          expect(subject.battle.teams.count).to eq(1)
          expect(team_names).to match_array([team_id])
        end

        it 'assigns the team a monopoké with the given id' do
          monsters = subject.battle.teams.map { |team| team[:monsters] }
          monopoke_names = monsters.flatten.map { |mon| mon[:name] }

          expect(monopoke_names).to match_array([monopoke_id, monopoke_id_2])
        end

        it 'assigns the monopoké the provided hp' do
          monsters = subject.battle.teams.map { |team| team[:monsters] }
          monsters_hp = monsters.flatten.map { |mon| mon[:hp] }

          expect(monsters_hp).to match_array([hp, hp_2])
        end

        it 'assigns the monopoké the provided ap' do
          monsters = subject.battle.teams.map { |team| team[:monsters] }
          monsters_ap = monsters.flatten.map { |mon| mon[:ap] }

          expect(monsters_ap).to match_array([ap, ap_2])
        end
      end

      context "when two teams already exist" do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id_2, monopoke_id_2, hp_2, ap_2)
        end

        it "throws an ArgumentError" do
          expect{ subject.create(team_id_3, monopoke_id_3, hp_3, ap_3) }.to raise_error("There are already two teams, let's Battle!")
        end
      end

      context "when a monster exists with the same name" do
        before do
          subject.create(team_id, monopoke_id, hp, ap)
          subject.create(team_id_2, monopoke_id, hp_2, ap_2)
        end

        it "appends a plus to the name" do
          monsters = subject.battle.teams.map { |team| team[:monsters] }
          monopoke_names = monsters.flatten.map { |mon| mon[:name] }

          expect(monopoke_names).to match_array([monopoke_id, "#{monopoke_id} +"])
        end
      end
    end

    context 'when an argument is missing or invalid' do
      it 'generates error output when team_id is missing' do
        expect{ subject.create(nil, monopoke_id_3, hp_3, ap_3) }.to raise_error(ArgumentError)
      end

      it 'generates error output when monopoké_id is missing' do
        expect{ subject.create(team_id_3, nil, hp_3, ap_3) }.to raise_error(ArgumentError)
      end

      it 'generates error output when hp is missing' do
        expect{ subject.create(team_id_3, monopoke_id_3, nil, ap_3) }.to raise_error(ArgumentError)
      end

      it 'generates error output when ap is missing' do
        expect{ subject.create(team_id_3, monopoke_id_3, hp_3) }.to raise_error(ArgumentError)
      end

      it 'generates an error if hp is < 1' do
        expect{ subject.create(team_id_3, monopoke_id_3, 0, ap_3) }.to raise_error(ArgumentError)
      end

      it 'generates an error if ap is < 1' do
        expect{ subject.create(team_id_3, monopoke_id_3, hp_3, -2) }.to raise_error(ArgumentError)
      end
    end
  end
end
