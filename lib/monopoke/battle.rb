class Monopoke
  Battle = Struct.new(:teams, :active_team, :active, keyword_init: true) do
    def initialize(*args)
      super
      self.active = false
    end

    def create (team_id, monopoke_id, health_points, attack_points)
      hp = health_points.to_i if health_points
      ap = attack_points.to_i if attack_points

      team = find_or_create_team(team_id)
      monster_name = monopoke_id

      if !unique_monster_id?(monopoke_id)
        monster_name = "#{monopoke_id} +"
        Monopoke.handle_output("#{monopoke_id} was taken, so your monopoké is named: #{monster_name}")
      end
      team.add_monster(monster_name, hp, ap)
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
        exit(1)
      end

      update_current_turn
    end

    def ichooseyou(monster_id)
      if teams.count < 2
        exit(1)
      end

      monster = active_team.choose_monster(monster_id)
      Monopoke.handle_output("#{monster.name} has entered the battle!")

      self.active = true
      update_current_turn
    end

    def finish_game
      self.active = false
      Monopoke.handle_output("Team #{active_team.name} wins!")
      exit(0)
    end

    # helper methods
    def find_or_create_team(team_id)
      existing_team = teams.select { |team| team.name == team_id }.first

      if existing_team
        existing_team
      elsif teams.count >= 2
        exit(1)
      else
        new_team(team_id)
      end
    end

    def handle_damage(target_monster, attack_monster)
      attack_points = attack_monster.ap
      target_monster.take_hit(attack_points)
      Monopoke.handle_output("#{attack_monster.name} attacked #{target_monster.name} for #{attack_points} damage!")

      target_monster.defeat! if target_monster.defeated?
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

    def all_monsters
      teams.flat_map(&:monsters)
    end

    def unique_monster_id?(monster_id)
      !all_monsters.map(&:name).include?(monster_id)
    end

    def other_team
      active_team == teams.first ? teams.last : teams.first
    end
  end
end