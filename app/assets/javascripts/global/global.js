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