function changeTeam() {
    var season = $("#season_select").val();
    
    if (season && parseInt(season, 10) > 0) {
        redirect("/stats/team/" + $("#team_select").val() + "/" + season);
    } else {
        redirect("/stats/team/" + $("#team_select").val());
    }
};