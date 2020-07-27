class Monopoke
  Team = Struct.new(:name, :monsters, keyword_init: true) do

    def initialize(*args)
      raise ArgumentError, "Incorrect arguments: Missing Team ID" unless !!args[0][:name]
      super
    end

    def add_monster(monopoke_id, health_points, attack_points)
      self.monsters << Monster.new(name: monopoke_id, hp: health_points, ap: attack_points)
    end

    def find_monster(monster_id)
      existing_monster = monsters.select { |monster| monster.name == monster_id }.first

      existing_monster || raise(ArgumentError, "Hmm, it doesn't look like that Monopoké is on your team.  Try again.")
    end

    def chosen_monster
      monsters.select { |monster| monster.chosen == true }.first
    end

    def available_monsters
      monsters.select { |monster| monster.available == true } || []
    end
  end
end