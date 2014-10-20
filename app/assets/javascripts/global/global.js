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

    $('[data-behaviour~=tooltip]').tooltip({
    });
    
    $('[data-behaviour~=popover]').popover({
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

/**
 * 
 * @param {HTMLElement} sender header cell that sent sort request.
 * @param {String} tableId id of table to be sorted.
 * @param {Number} colId 0-based number of column by which should be table
 * sorted.
 * @param {function(Object, Object)} comparator function that accepts two
 * objects (innerHTML of cells) to be compared and returns number (&lt; 0 when
 * o1 &lt; o2, 0 when o1 == o2 end &gt; 0 when o1 &gt; o2). When null, cells are
 * compared by its innerHTML (o1.innerHTML &lt; o2.innerHTML).
 * @param {function(HTMLElement)} selector function that accepts oen parameter
 * (table row) and decides whether this row should be displayed (returns
 * true/false). When null, all rows are accepted.
 * @returns {undefined}
 */
function sortTable(sender, tableId, colId, comparator, selector) {
    comparator = comparator ? comparator : Comparator.defaultComparator;
    
    // check whether should be sorted ASC or DESC
    var type = 1; // ASC
    if ($(sender).data("sort-type") == "DESC") {
        type = -1;
    }
    $(sender).data("sort-type", type === 1 ? "DESC" : "ASC"); // set to opposite for next click
    
    // get table body
    var tableBody = document.getElementById(tableId).getElementsByTagName("tbody")[0];
    
    // get list of rows
    var rowsSelect = tableBody.getElementsByTagName("tr");
    var rows = [];
    for (var a=0; a<rowsSelect.length; a++) {
        rows[rows.length] = rowsSelect[a];
    }
    
    
    // get list of cells
    var cells = [];
    for (var a=0; a<rows.length; a++) {
        cells[a] = rows[a].getElementsByTagName("td")[colId];
        console.log("cells[" + a + "] = " + cells[a].innerHTML);
    }
    
    // sort all rows/cells
    for (var a=0; a<rows.length-1; a++) {
        for (var b=a; b>=0; b--) {
            if (comparator(cells[b].innerHTML, cells[b+1].innerHTML) * type > 0) {
                var tmp = rows[b];
                rows[b] = rows[b+1];
                rows[b+1] = tmp;
                var tmp = cells[b];
                cells[b] = cells[b+1];
                cells[b+1] = tmp;
            }
        }
    }
    
    // show/hide rows depending on selector
    for (var a=0; a<rows.length; a++) {
        if (!selector || selector(this)) {
            $(rows[a]).removeClass("non-displayed");
        } else {
            $(rows[a]).addClass("non-displayed");
        }
    }
    
    // remove all rows from table
    for (var a=0; a<rows.length; a++) {
        tableBody.removeChild(rows[a]);
        console.log("deleting " + a);
    }
    
    // add all rows in right order
    for (var a=0; a<rows.length; a++) {
        tableBody.appendChild(rows[a]);
        console.log("adding " + a);
    }
    
    if (type === 1) {
        $(sortTable.arrow.asc).removeClass("non-displayed");
        $(sortTable.arrow.desc).addClass("non-displayed");
        sender.appendChild(sortTable.arrow.asc);
    } else {
        $(sortTable.arrow.desc).removeClass("non-displayed");
        $(sortTable.arrow.asc).addClass("non-displayed");
        sender.appendChild(sortTable.arrow.desc);
    }
}

sortTable.arrow = {
    asc: document.createElement("span"),
    desc: document.createElement("span")
};

sortTable.arrow.asc.innerHTML = "&nbsp;";
sortTable.arrow.desc.innerHTML = "&nbsp;";
$(sortTable.arrow.asc).addClass("icon icon-circle-arrow-up non-displayed");
$(sortTable.arrow.desc).addClass("icon icon-circle-arrow-down non-displayed");

Comparator = {
    defaultComparator: function(o1, o2) {
        if (o1 > o2) {
            return 1;
        }
        if (o1 < o2) {
            return -1;
        }
        return 0;
    },
    
    percentage: function(o1, o2) {
        var o1d = parseFloat(o1.replace(/ +%$/, ""));
        var o2d = parseFloat(o1.replace(/ +%$/, ""));

        if (o1d > o2d) {
            return 1;
        }
        if (o1d < o2d) {
            return -1;
        }
        return 0;
    }
};