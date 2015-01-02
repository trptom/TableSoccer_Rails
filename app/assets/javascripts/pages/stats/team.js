function changeTeam() {
    var url = $("#url").val().replace("id", $("#team_select").val());
    var season = $("#season_select").val();
    
    if (season && parseInt(season, 10) > 0) {
        url = url.replace("season", season);
    } else {
        url = url.replace("/season", "");
    }
    
    redirect(url);
};