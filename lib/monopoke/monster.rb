require "active_support"

class Monopoke
  Monster = Struct.new(:name, :hp, :ap, keyword_init: true) do
    def initialize(*args)
      raise ArgumentError, "Incorrect arguments" unless !!args[0][:name] && !!args[0][:hp] && !!args[0][:ap]
      raise ArgumentError, "Incorrect arguments: HP must be more than 1" if (args[0][:hp] < 1)
      raise ArgumentError, "Incorrect arguments: AP must be more than 1" if (args[0][:ap] < 1)

      super(*args)
      self.freeze
    end
  end
end
