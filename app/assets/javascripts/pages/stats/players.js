function changeTeam() {
    var season = $("#season_select").val();
    
    if (season && parseInt(season, 10) > 0) {
        redirect("/stats/players/" + $("#team_select").val() + "/" + season);
    } else {
        redirect("/stats/players/" + $("#team_select").val());
    }
};