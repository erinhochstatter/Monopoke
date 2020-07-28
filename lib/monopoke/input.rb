require "monopoke/battle"

class Monopoke
  class Input
    attr_accessor :string
    def initialize(string)
      self.string = string
    end

    def instructions
      file = File.open(string, 'r')
      lines = file.readlines.map(&:chomp)
      lines.map { |line| line.split(" ") }
    end
  end
end