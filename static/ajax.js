jQuery( function ($) {


$("#say").click(function () {
    $.post( 
        "/post", 
        [{name: "text", value: $("[name=text]").val()}], 
        undefined,
        "JSON"
    );
});


$.ev.loop('/poll?session=' + Math.random(), {
    message: function(ev) {
        $( "#logs" ).prepend( ev.log + "<br>" );
    }
});


} );
