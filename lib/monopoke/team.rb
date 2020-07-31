class Monopoke
  Team = Struct.new(:name, :monsters, keyword_init: true) do

    def initialize(*args)
      exit(1) unless !!args[0][:name]
      super
    end

    def add_monster(monopoke_id, health_points, attack_points)
      self.monsters << Monster.new(name: monopoke_id, hp: health_points, ap: attack_points)
      Monopoke.handle_output("#{monopoke_id} has been added to team #{self.name}")
    end

    def find_monster(monster_id)
      existing_monster = monsters.select { |monster| monster.name == monster_id }.first
      existing_monster || exit(1)
    end

    def choose_monster(monster_id)
      monsters.map { |monster| monster.chosen = false }
      monster = find_monster(monster_id)
      monster.chosen = true
      monster
    end

    def chosen_monster
      monsters.select { |monster| monster.chosen == true }.first
    end

    def available_monsters
      monsters.select { |monster| monster.available? == true } || []
    end
  end
end