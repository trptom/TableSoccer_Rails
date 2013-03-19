$(document).ready(function() {
    var elements = document.getElementsByClassName("btn-group");
    for (var a=0; a<elements.length; a++) {
        filterChildsByClass(elements[a], "btn");
    }
});