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

    def attack
      target_monster = other_team.chosen_monster
      attack_monster = active_team.chosen_monster

      if attack_monster
        handle_damage(target_monster, attack_monster)
      else
        puts "Choose a new Monopoké"
      end

      update_current_turn
    end

    def handle_damage(target_monster, attack_monster)
      attack_points = attack_monster.ap
      target_monster.take_hit(attack_points)
      target_monster.chosen = false if target_monster.defeated?

      finish_game if target_monster.defeated? && other_team.available_monsters.count.zero?
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
      self.active = true #TODO: Is there a way to not call this every time?
      update_current_turn
    end

    def all_monsters
      teams.flat_map(&:monsters)
    end

    def unique_monster_id?(monster_id)
      !all_monsters.map(&:name).include?(monster_id)
    end

    def other_team
      active_team == teams.first ? teams.last : teams.first
    end

    def finish_game
      self.active = false
    end
  end
end
