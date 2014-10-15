var FillAttendance = {
    lastShownId: null,
    
    dialog: null,
    fromInput: null,
    toInput: null,
    prioritySelect: null,
    submitButton: null,
    
    init: function() {
        this.dialog = $("#fill_attendance");
        this.fromInput = $("#attendance_start");
        this.toInput = $("#attendance_end");
        this.fromInputData = $("#attendance_start input");
        this.toInputData = $("#attendance_end input");
        this.prioritySelect = $("#attendance_priority");
        this.submitButton = $("#fillAttendance_submit");
    },
    
    add: function() {
        if (this.lastShownId !== null) {
            var _this = this;
            
            var id = this.lastShownId;
            var btn = $("plus_button_" + id);
            var loader = $("loader_" + id);
            
            btn.hide();
            loader.show();

            $.ajax({
                url: "/users/add_attendance.json",
                type: "POST",
                dataType: "json",
                data: {
                    dateId: id,
                    from: _this.fromInputData.val(),
                    to: _this.toInputData.val(),
                    priority: _this.prioritySelect.val()
                },

                success: function(responseObj) {
                    loader.hide();
                    btn.show();
                    
                    _this.addToSelectedList(id, responseObj);
                },

                error: function() {
                    loader.hide();
                    btn.show();
                }
            });
            
            this.dialog.modal('hide');
        }
    },
    
    remove: function(id1, id2) {
        console.log("id1 = " + id1);
        console.log("id2 = " + id2);
        
        $.ajax({
            url: "/users/remove_attendance.json",
            type: "POST",
            dataType: "json",
            data: {
                id: id2
            },

            success: function(responseObj) {
                var elem = document.getElementById("remove_btn_" + id2);
                var wrapper = document.getElementById("selected_" + id1);
                
                wrapper.removeChild(elem);
            },

            error: function() {
            }
        });
    },
    
    addToSelectedList: function(id, responseObj) {
        var elem = document.createElement("span");
        
        elem.innerHTML = responseObj.formatted_start + " ... " + responseObj.formatted_end;
        elem.id = "remove_btn_" + responseObj.date.id;
        elem.className = "btn";
        elem.onclick = function() {
            FillAttendance.remove(id, responseObj.date.id);
        };
        
        document.getElementById("selected_" + id).appendChild(elem);
    },
    
    clearForm: function() {
        
    },
    
    plusClicked: function(id) {
        this.lastShownId = id;
        
        var startDate = $("#attendances_list_" + id).data("min");
        var endDate = $("#attendances_list_" + id).data("max");
        
        var startDateObj = dateFromDb(startDate);
        var endDateObj = dateFromDb(endDate);
        
        this.fromInput.data("datetimepicker").setDate(startDateObj);
        this.fromInput.data("datetimepicker").setStartDate(startDateObj);
        this.fromInput.data("datetimepicker").setEndDate(endDateObj);
        this.toInput.data("datetimepicker").setStartDate(startDateObj);
        this.toInput.data("datetimepicker").setEndDate(endDateObj);
        this.toInput.data("datetimepicker").setDate(endDateObj);
    }
};

$(document).ready(function() {
    FillAttendance.init();
});