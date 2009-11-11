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
    said: function(ev) {
        $( "#logs" ).prepend(
            '<div style="color: ' + ev.color + '">' +
            ev.member.name + '(size=' + ev.size + ')<br>' +
            ev.comment + 
            '</div>'
        );
    }
});


} );
