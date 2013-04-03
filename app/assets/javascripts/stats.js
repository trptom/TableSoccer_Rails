var Stats = {
    Players: {
        changeTeam: function () {
            redirect("/teams/"+$("#team-select").val()+"/playersstats");
        }
    },
    Player: {
        changePlayer: function () {
            redirect("/players/"+$("#player-select").val()+"/stats");
        }
    },
    Team: {
        changeTeam: function () {
            redirect("/teams/"+$("#team-select").val()+"/stats");
        }
    }
}