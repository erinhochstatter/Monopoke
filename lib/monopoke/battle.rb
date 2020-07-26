class Monopoke
  Battle = Struct.new(:teams, keyword_init: true) do

    def find_or_create_team(team_id)
      existing_team = teams.select { |team| team[:name] == team_id }.first

      if existing_team
        existing_team
      elsif teams.count >= 2
        raise ArgumentError, "There are already two teams, let's Battle!"
      else
        new_team(team_id)
      end
    end

    def new_team(team_id)
      new_team = Team.new( name: team_id, monsters: [] )
      teams << new_team
      new_team
    end
  end
end