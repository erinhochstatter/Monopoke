require "active_support"
require "monopoke/battle"
require "monopoke/monster"
require "monopoke/team"
require "monopoke/version"

class Monopoke
  attr_accessor :battle

  def initialize
    self.battle = Battle.new(teams: [])
  end

  def create (team_id, monopoke_id, health_points, attack_points)
    team = battle.find_or_create_team(team_id)
    monster_name = monopoke_id

    if !battle.unique_monster_id?(monopoke_id)
      monster_name = "#{monopoke_id} +"
      puts "#{monopoke_id} was taken, so your monopoké is named: #{monster_name}"
    end

    team.add_monster(monster_name, health_points, attack_points)
  end

  def i_choose_you(monopoke_id)
    battle.choose_monster(monopoke_id)
  end

  def attack
    battle.attack
  end

  class << self
    def create (team_id, monopoke_id, health_points, attack_points)
      new.create(team_id, monopoke_id, health_points, attack_points)
    end
  end
end
