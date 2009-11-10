jQuery( function ($) {

var channel = $("[name=channel]").val();

$("#say").click(function () {
    $.post( 
        "/post/" + channel, 
        [{name: "text", value: $("[name=text]").val()}], 
        undefined,
        "JSON"
    );
});


$.ev.loop("/poll/" + channel + "?session=" + Math.random(), {
    message: function(ev) {
        $( "#logs" ).prepend( ev.log + "<br>" );
    }
});


} );
