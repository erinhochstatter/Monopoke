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
    # TODO: Warn of changed name
    monster_name = battle.unique_monster_id?(monopoke_id) ? monopoke_id : "#{monopoke_id} +"
    team.add_monster(monster_name, health_points, attack_points)
  end

  def i_choose_you(monopoke_id)
    battle.choose_monster(monopoke_id)
  end

  class << self
    def create (team_id, monopoke_id, health_points, attack_points)
      new.create(team_id, monopoke_id, health_points, attack_points)
    end
  end
end