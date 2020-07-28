require "thor"
require "monopoke"

class Monopoke
  class CLI < Thor::Group
    desc "Takes an input file"
    argument :string

    def import
      Monopoke.start_battle(string)
    end

  end
end