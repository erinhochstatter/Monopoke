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
    team.add_monster(monopoke_id, health_points, attack_points)
  end

  class << self
    def create (team_id, monopoke_id, health_points, attack_points)
      new.create(team_id, monopoke_id, health_points, attack_points)
    end
  end
end
