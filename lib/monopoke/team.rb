class Monopoke
  Team = Struct.new(:name, :monsters, keyword_init: true) do

    def initialize(*args)
      raise ArgumentError, "Incorrect arguments: Missing Team ID" unless !!args[0][:name]

      super(*args)
      self.freeze
    end

    def add_monster(monopoke_id, health_points, attack_points)
      self.monsters << Monster.new(name: monopoke_id, hp: health_points, ap: attack_points)
    end
  end
end