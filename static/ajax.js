( function ($) {

function sysMessage(message) {
    return '<div style="color: #999">' + message + '</div>';
}


function errMessage(message) {
    return '<div style="color: #F00">' + message + '</div>';
}


function member(member){
    return member.name + '(' + member.id + ')';
}


// Entry point
jQuery( function ($) {

var channel = $("[name=channel]").val();

function say() {
    $.post( 
        "post/" + channel, 
        [{name: "text", value: $("[name=text]").val()}], 
        undefined,
        "json"
    );
    $("[name=text]").val( "" );
}

$("#say").click(say);
$("#text").keypress( function (ev) {
    if(ev.keyCode == 13) say();
} );

$.ev.loop("poll/" + channel + "?session=" + Math.random(), {
    said: function(ev) {
        $( "#logs" ).prepend(
            '<div style="color: ' + ev.color + '">' +
            member( ev.member ) + '(size=' + ev.size + ')<br>' +
            ev.comment + 
            '</div>'
        );
    },

    enter: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            '入室した。sock: ' + ev.sockid + ', chatid: ' + ev.chatid + 
            ', hash: ' + ev.hash
        ) );
    },

    member_entered: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'が入室した。'
        ) );
    },

    member_leaving: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'が去った。'
        ) );
    },

    member_kicked: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'が' + member( ev.kicker ) + 'に蹴られた。'
        ) );
    }, 

    member_statchanged: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'の状態変更: ' + ev.oldstat + '→' + ev.stat
        ) );
    }, 

    member_namechanged: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'の名前変更: ' + ev.oldname + '→' + ev.name
        ) );
    }, 

    member_facechanged: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            member( ev.member ) + 'の表情変更: ' + ev.oldface + '→' + ev.face
        ) );
    },

    owner_changed: function(ev) {
        $( "#logs" ).prepend( sysMessage(
            'オーナー変更: ' + member( ev.oldowner ) + '→' + member( ev.owner )
        ) );
    },

    error: function(ev) {
        $( "#logs" ).prepend( errMessage( 
            "エラー: " + ev.messages.join(",") 
        ) );
    },

    unknwon_command: function(ev) {
        $( "#logs" ).prepend( errMessage( "不明なタグ: " + ev.data ) );
    },

    disconnect: function(ev) {
        $( "#logs" ).prepend( errMessage( "切断" ) );
    }
});

// Polling to refresh member list (It's work well though it's too bad.)
setInterval( function () { $.post(
    "members/" + channel, 
    "", 
    function ( members ) {
        var htmls = [];
        for( var i = 0; i < members.length; i++ ){
            var m = members[i];
            htmls.push( m.name );
        }

        $( "#members" ).html( htmls.join("、") );
    },
    "json"
); }, 1000 );

} );

} )(jQuery);
