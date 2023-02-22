require 'active_support'
require 'monopoke/battle'
require 'monopoke/monster'
require 'monopoke/team'
require 'monopoke/version'
require 'monopoke/input'
require 'pry'

class Monopoke
  attr_accessor :battle, :input, :output

  def initialize(string)
    self.input = Input.new(string)
    self.battle = Battle.new(teams: [])
    self.output = create_output_file(string)
  end

  def start_battle
    input.instructions.each do |instruction|
      command, *args = instruction
      battle.send(command.downcase, *args)
    end
  end

  def create_output_file(string)
    file_path = path_without_input_name(string)
    file_name = "BattleResults_#{Time.now.strftime('%-d%H%M_%H%M00')}.txt"
    File.new("#{file_path}/#{file_name}", 'w+')
  end

  # helpers
  def path_without_input_name(string)
    file_path_elements = string.split('/')
    file_path_elements.pop
    file_path_elements.join('/')
  end

  def handle_output(message)
    puts message
    output.write("#{message}\n")
  end

  class << self
    attr_accessor :instance

    def handle_output(message)
      instance.handle_output(message)
    end

    def start_battle(string)
      self.instance = new(string)
      instance.start_battle
    end
  end
end
