
class Monopoke
  Monster = Struct.new(:name, :hp, :ap, :chosen, keyword_init: true) do

    def initialize(name:, hp:, ap:, **args)
      raise exit(false) unless !!name && !!hp && !!ap
      raise exit(false) if (hp < 1)
      raise exit(false) if (ap < 1)

      super
      self.chosen = false
    end

    def defeated?
      hp <= 0
    end

    def defeat!
      self.chosen = false
      Monopoke.handle_output("#{name} has been defeated!")
    end

    def take_hit(ap)
      self.hp -= ap
    end

    def available?
      return false if defeated?
      return false if chosen == true
      return true
    end
  end
end
