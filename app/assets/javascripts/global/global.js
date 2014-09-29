function filterChildsByClass(element, className) {
    var rem = new Array();
    for (var a=0; a<element.childNodes.length; a++) {
        if (!$(element.childNodes[a]).hasClass(className)) {
            rem[rem.length] = element.childNodes[a];
        }
    }
    for (var index in rem) {
        element.removeChild(rem[index]);
    }
}

function redirect(url) {
    location.href = url;
}