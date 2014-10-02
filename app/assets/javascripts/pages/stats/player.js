function changePlayer() {
    var season = $("#season_select").val();
    
    if (season && parseInt(season, 10) > 0) {
        redirect("/stats/player/" + $("#player_select").val() + "/" + season);
    } else {
        redirect("/stats/player/" + $("#player_select").val());
    }
};