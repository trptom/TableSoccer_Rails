var Squad = {
    BlackDot: {
        dialog: null,
        countInput: null,
        reasonInput: null,
        descriptionArea: null,
        submitButton: null,
        
        groupSpan: null,
        simpleSpan: null,
        detailBody: null,
        
        playerId: null,
        
        init: function() {
            this.dialog = $("#add_black_dot");
            this.countInput = $("#black_dot_count");
            this.reasonInput = $("#black_dot_reason");
            this.descriptionArea = $("#black_dot_description");
            this.submitButton = $("#black_dot_submit");
        },
        
        clicked: function(id) {
            this.playerId = id;
            
            this.groupSpan = document.getElementById("grouped_dots_" + id);
            this.simpleSpan = document.getElementById("simple_dots_" + id);
            this.detailBody = document.getElementById("detail_body_" + id);
        },
        
        add: function() {
            var _this = this;

            var id = this.lastShownId;
            var btn = $("plus_button_" + id);
            var loader = $("loader_" + id);
            
            var countVal = _this.countInput.val();
            var reasonVal = _this.reasonInput.val();

            btn.hide();
            loader.show();

            $.ajax({
                url: $("#add_black_dot_url").val().replace("0", _this.playerId),
                type: "POST",
                dataType: "json",
                async: true,
                
                data: {
                    count: countVal === "" ? null : countVal,
                    reason: reasonVal === "" ? null : reasonVal,
                    description: _this.descriptionArea.val()
                },

                success: function(responseObj) {
                    _this.addToList(responseObj);
                },

                error: function() {
                    loader.hide();
                    btn.show();
                }
            });

            this.dialog.modal('hide');
        },
        
        addToList: function(responseObj) {
            for (var a=0; a<responseObj.dot.count; a++) {
                var img = this.generateImage(responseObj.type, responseObj.description);
                this.simpleSpan.appendChild(img);
            }
            
            // when 3 or more items, group first 3 to beer
            var currentImages = this.simpleSpan.getElementsByTagName("img");
            while (currentImages.length >= 3) {
                console.log("removing 3 items");
                this.simpleSpan.removeChild(currentImages[2]);
                this.simpleSpan.removeChild(currentImages[1]);
                this.simpleSpan.removeChild(currentImages[0]);
                
                var beerImg = this.generateBeerImage(responseObj.dot.player_id);
                this.groupSpan.appendChild(beerImg);
                
                currentImages = this.simpleSpan.getElementsByTagName("img");
            }
            
            var row = this.generateDotDetailRow(responseObj.dot, responseObj.reason);
            this.detailBody.appendChild(row);
        },
        
        addingFailed: function() {
            alert("Error"); // TODO
        },
        
        generateImage: function() {
            var img = document.createElement("img");
            
            img.src = "/assets/icons/black_dot.ico";
            
            return img;
        },
                
        generateBeerImage: function(playerId) {
            var img = document.createElement("img");
            
            img.src = "/assets/icons/beer.png";
            img.className = "link";
            img.onclick = function() {
                Squad.BlackDot.markBeerAsPaid(playerId, img);
            };
            
            return img;
        },
                
        generateDotDetailRow: function(dotInfo, reason) {
            var row = document.createElement("tr");
            var cell = [
                document.createElement("td"),
                document.createElement("td")
            ];
            row.appendChild(cell[0]);
            row.appendChild(cell[1]);
            
            for (var a=0; a<dotInfo.count; a++) {
                var img = this.generateImage();
                cell[0].appendChild(img);
            }
            
            var reasonStr = "";
            if (reason) {
                reasonStr += reason;
            }
            if (reason && dotInfo.description) {
                reasonStr += "<br />";
            }
            if (dotInfo.description) {
                reasonStr += dotInfo.description;
            }
            cell[1].innerHTML = reasonStr;
            
            return row;
        },
        
        markBeerAsPaid: function(id, elem) {
            $.ajax({
                url: $("#pay_beer_url").val().replace("0", id),
                type: "POST",
                dataType: "json",
                async: true,
                
                data: {},

                success: function(responseObj) {
                    if (responseObj.status) {
                        console.log("status ok");
                        
                        if (elem !== null) {
                            $(elem).removeClass("link");
                            elem.src = "/assets/icons/beer_completed.png";
                            elem.onclick = null;
                        }
                    }
                },

                error: function() {
                    alert("Error");
                }
            });
        }
    },
    
    detailClicked: function(elem, playerId) {
        if (elem.innerHTML === "+") {
            elem.innerHTML = "-";
            $("#detail_" + playerId).show(500);
        } else {
            elem.innerHTML = "+";
            $("#detail_" + playerId).hide(500);
        }
    }
};

$(document).ready(function() {
    Squad.BlackDot.init();
});
