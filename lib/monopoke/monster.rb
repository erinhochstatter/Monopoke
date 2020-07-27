require "active_support"

class Monopoke
  Monster = Struct.new(:name, :hp, :ap, :chosen, keyword_init: true) do

    def initialize(*args)
      raise ArgumentError, "Incorrect arguments" unless !!args[0][:name] && !!args[0][:hp] && !!args[0][:ap]
      raise ArgumentError, "Incorrect arguments: HP must be more than 1" if (args[0][:hp] < 1)
      raise ArgumentError, "Incorrect arguments: AP must be more than 1" if (args[0][:ap] < 1)

      super
      self.chosen = false
    end

    def defeated?
      hp <= 0
    end

    def take_hit(ap)
      self.hp -= ap
    end

    def available
      return false if defeated?
      return false if chosen == true
      return true
    end
  end
end
