class Monopoke
  Battle = Struct.new(:teams, :active_team, :active, keyword_init: true) do
    def initialize(*args)
      super
      self.active = false
    end

    def find_or_create_team(team_id)
      existing_team = teams.select { |team| team.name == team_id }.first

      if existing_team
        existing_team
      elsif teams.count >= 2
        raise ArgumentError, "There are already two teams, let's Battle!"
      else
        new_team(team_id)
      end
    end

    def new_team(team_id)
      new_team = Team.new( name: team_id, monsters: [] )
      teams << new_team
      update_current_turn
      new_team
    end

    def update_current_turn
      return if teams.count.zero?

      if active
        self.active_team = active_team == teams.first ? teams.last : teams.first
      else
        self.active_team = teams.first
      end
    end

    def choose_monster(monster_id)
      raise StandardError, "Please add another team before choosing your Monpoké." if teams.count < 2

      monster = active_team.find_monster(monster_id)
      monster.chosen = true
      self.active = true
    end

    def all_monster_ids
      teams.flat_map(&:monsters).map(&:name)
    end

    def unique_monster_id?(monster_id)
      !all_monster_ids.include?(monster_id)
    end
  end
end
