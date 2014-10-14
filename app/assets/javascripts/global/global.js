$(document).ready(function() {
    // defaultni chovani pro datepiskery a timepickery
    $('[data-behaviour~=datepicker]').datepicker({
        format: 'yyyy-mm-dd'
    });
    
    $('[data-behaviour~=timepicker]').timepicker({
        minuteStep: 1,
        template: 'modal',
        appendWidgetTo: 'body',
        showSeconds: true,
        showMeridian: false,
        defaultTime: false
    });
    
    $('[data-behaviour~=datetimepicker]').datetimepicker({
    });
});

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

function dateFromDb(dbDateStr) {
    dbDateStr = dbDateStr.replace(/ UTC$/, "");
    
    var tmp1 = dbDateStr.split(" ");
    var tmpYMD = tmp1[0].split("-");
    var tmpHMS = tmp1[1].split(":");
    
    return new Date(Date.UTC(
            parseInt(tmpYMD[0], 10),
            parseInt(tmpYMD[1], 10)-1,
            parseInt(tmpYMD[2], 10),
            parseInt(tmpHMS[0], 10),
            parseInt(tmpHMS[1], 10),
            parseInt(tmpHMS[2], 10),
            0));
}