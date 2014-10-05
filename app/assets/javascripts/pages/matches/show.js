function addNewPossibleDate(matchId) {
    var start = $("#start_new").val();
    var end = $("#end_new").val();
    
    if (start && end) {
        start = encodeURIComponent(start);
        end = encodeURIComponent(end);
        redirect('/matches/' + matchId + '/add_possible_date/?start=' + start + "&end=" + end);
    }
}

function updatePossibleDate(dateId) {
    var start = $("#start_" + dateId).val();
    var end = $("#end_" + dateId).val();
    
    if (start && end) {
        start = encodeURIComponent(start);
        end = encodeURIComponent(end);
        redirect('/matches/update_possible_date/' + dateId + '?start=' + start + "&end=" + end);
    }
}