
function configurePlaylist(playList) {

    var styleId;
    
    $('.button.style.selected').each(function(index, item){
        //Find all the intially selected style buttons
        playList.addStyle(extractStyleIdFromDomElement(this));
    
    });
    
    $('.button').click( function(){
    
        if( $(this).hasClass("selected") ){
            $(this).removeClass("selected");
            //removeStyleFromPlayList(this);
            playList.removeStyle(extractStyleIdFromDomElement(this));
        } else {
            $(this).addClass("selected");
            playList.addStyle(extractStyleIdFromDomElement(this));
            //addStyleToPlayList(this);
        }
    });
};

function extractStyleIdFromDomElement (elem) {
    return elem.id;
}

