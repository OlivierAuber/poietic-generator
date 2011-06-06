var session = null, picker;

// instead of windows.onload
$(document).ready( function() {
    // hide iphone/ipad URL bar
    setTimeout(function() { window.scrollTo(0, 1) }, 100);

    // initialize zoness
    session = new Session(
        SESSION_TYPE_DRAW,
        function() {
            //console.log("page_draw/ready: session callback ok");
	    var board = new Board( session, 'session-board');
            var drawing = new Drawing(session, 'session-drawing');
            // var globalzone = new GlobalZone(session, 'session-global');
            // var colorzone = new ColorZone(session, 'session-colors');

            //console.log("page_draw/ready: prepicker");
            $("#brush").click(function(event){
                event.preventDefault();
                var firstClick = false;
                if (undefined === picker) {
                    picker = new Color.Picker({
                        size: Math.floor($(window).width() / 3),
                        callback: function(hex) {
                            drawing.color_set( "#" + hex );
                        }
                    });
                    picker.el.style.bottom = "50px";
                    picker.el.style.left = "10px";
                    firstClick = true;
                    $("#brush-action").text("Masquer");
                }
                if (true === $(picker.el).is(":hidden")) {
                    $(picker.el).show();
                    $("#brush-action").text("Masquer");
                } else if (!firstClick) {
                    $(picker.el).hide();
                    $("#brush-action").text("Afficher");
                }
            });
        }
    );
});
