module PlayersHelper
    
    def team_num(team)
        @carps = Player.where(team: team)
    end
    
    def team_shortage(team)
        @shortage = Player.where(team: team).where(physical: nil)
    end
end
