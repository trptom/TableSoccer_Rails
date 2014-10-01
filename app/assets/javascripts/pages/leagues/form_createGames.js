var FormCreateGames = {
    changed: function() {
        if ($("#createGames_type").val() === "0") {
            $('#createGames_team').attr('disabled', 'disabled');
        } else {
            $('#createGames_team').removeAttr('disabled');
        }
    },
    
    setSeason: function(val) {
        $("#createGames_season").val(val);
        $("#createGames_season_str").val(val);
    }
};

$(document).ready(function() {
    FormCreateGames.changed();
});