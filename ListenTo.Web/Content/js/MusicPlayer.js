

/**
Based upon http://ejohn.org/blog/simple-javascript-inheritance/#postcomment 
*/
(function(){
  var initializing = false, fnTest = /xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/;

  // The base Class implementation (does nothing)
  this.Class = function(){};
 
  // Create a new Class that inherits from this class
  Class.extend = function(prop) {
    var _super = this.prototype;
   
    // Instantiate a base class (but only create the instance,
    // don't run the init constructor)
    initializing = true;
    var prototype = new this();
    initializing = false;
   
    // Copy the properties over onto the new prototype
    for (var name in prop) {
      // Check if we're overwriting an existing function
      prototype[name] = typeof prop[name] == "function" &&
        typeof _super[name] == "function" && fnTest.test(prop[name]) ?
        (function(name, fn){
          return function() {
            var tmp = this._super;
           
            // Add a new ._super() method that is the same method
            // but on the super-class
            this._super = _super[name];
           
            // The method only need to be bound temporarily, so we
            // remove it when we're done executing
            var ret = fn.apply(this, arguments);       
            this._super = tmp;
           
            return ret;
          };
        })(name, prop[name]) :
        prop[name];
    }
   
    // The dummy class constructor
    function Class() {
      // All construction is actually done in the init method
      if ( !initializing && this.init )
        this.init.apply(this, arguments);
    }
   
    // Populate our constructed prototype object
    Class.prototype = prototype;
   
    // Enforce the constructor to be what we expect
    Class.constructor = Class;

    // And make this class extendable
    Class.extend = arguments.callee;
   
    return Class;
  };
})();


var Control = Class.extend({

    _listeners: {},
    
    addListener: function(name, listener) {
    
        if(this._listeners[name]==undefined) {
            this._listeners[name] = [];
        }
        
        addToArray(listener, this._listeners[name]);
    },


    _raise:function(name){
        var listeners = this._listeners[name];
        jQuery.each(
            listeners,
            function( intIndex, listener ){
                listener();
            }
        );
    }
});



function addToArray(item, array) {
    var added = false;     
    if(jQuery.inArray(item, array)==-1){
        var numItems = array.length;
        array[numItems] = item;
        added= true;
    }
    return added;
}

function removeFromArray(item, array) {
    var removed = false;     
    var index = jQuery.inArray(item, array);
    if(index!=-1){
        array.splice( index, 1 ); 
        removed = true;
    }
    return removed;
}

function createDelegate(instance, method ) {
    return function() {
        return method.apply(instance, arguments);
    }
 }


 var PlayList = Control.extend({

     _styles: [],
     _artists: [],
     _listeners: [],
     _currentTrack: null,
     _currentPlaylist: null,
     _page: 0,
     _isReady: false,
     _loopPlaylist: false,

     /**
     * Initialises the playlist
     * @param domElement  The element
     */
     init: function(domElement) {
         this._domElement = domElement;
         this._fetchPlayListCallback$Delegate = createDelegate(this, this._fetchPlayListCallback);
         this._failureCallback$Delegate = createDelegate(this, this._failureCallback);

     },

    /**
    * If called, the playlist will not request another set of tracks once the last track has played
    * Instead it will return to the first track in the current playlist
    */
    enableLoopPlaylist: function() {
        this._loopPlaylist = true;
    },


     /**
     * Add an artist to include in the playlist
     * @param artistId  The id of the artist
     */
     addArtist: function(artistId) {
         if (addToArray(artistId, this._artists)) {
             this.fetchPlayList();
         }
     },

     /**
     * Add a style to include in the playlist
     * @param styleId  The id of the style
     */
     addStyle: function(styleId) {
         if (addToArray(styleId, this._styles)) {
             this.fetchPlayList();
         }
     },

     /**
     * Remove a style to remove in the playlist
     * @param styleId  The id of the style
     */
     removeStyle: function(styleId) {
         if (removeFromArray(styleId, this._styles)) {
             this.fetchPlayList();
         }
     },

     /**
     * Request the playlist based upon the added styles
     */
     fetchPlayList: function() {

         this._isReady = false;

         var data = {
             styles: this._styles,
             artists: this._artists,
             page: this._page
         };


         jQuery.getJSON(
            "/radio/playlist/",
            data,
            this._fetchPlayListCallback$Delegate,
            this._failureCallback$Delegate

         );
     },

     /**
     * Handles the response to the request for a playlist
     * @param data The response data
     */
     _fetchPlayListCallback: function(data) {
         this._currentPlaylist = data;
         this._ready();
         this._renderPlaylist();
     },

     _failureCallback: function(data) {
         debugger;
     },

     /**
     * Gets the playlist
     * return The playlist
     */
     getPlaylist: function() {

         //Is the current track in the playlist? 
         //If not we'll add it so that the user isnt confused...
         if (this._currentTrack) {
             var found = false;
             var numTracks = this._currentPlaylist.length;
             for (var i = 0; i < this._currentPlaylist.length; i++) {
                 if (this._currentPlaylist[i].ID == this._currentTrack.ID) {
                     found = true;
                     break;
                 }
             }
             if (!found) {
                 this._currentPlaylist.splice(0, 0, this._currentTrack);
             }
         }

         return { current: this._currentTrack, playList: this._currentPlaylist };
     },

     /**
     * Gets the number of tracks in the current playlist
     * return The number of tracks in the current playlist
     */
     getNumberOfTracksInPlaylist: function() {
         return this._currentPlaylist.length;
     },

     _getTrackIndex: function(trackToFind) {
         var currentTrack;
         for (var i = 0; i < this._currentPlaylist.length; i++) {
             if (this._currentPlaylist[i].ID == trackToFind.ID) {
                 return i;
             }
         }
         return -1;

     },

     incrementTrack: function(incrementBy) {

         var numTracks = this.getNumberOfTracksInPlaylist();

         var track;
         if (this._currentTrack == null) {
             track = this._currentPlaylist[0];
         } else {
             var index = this._getTrackIndex(this._currentTrack);

             if (index == -1) {
                 throw "the current track is NOT part of this playlist...";
             }
             index = index + incrementBy;

             if (index < numTracks && index >= 0) {
                //We can move forward since the playlist still contains tracks
                 track = this._currentPlaylist[index];
             } else if (this._loopPlaylist == true && index == -1) {
                //if looping is enabled we can go backwards..
                track = this._currentPlaylist[numTracks-1];
             } else {
                 if (this._loopPlaylist == true) {
                     track = this._currentPlaylist[0];
                 } else {
                     //There are no more tracks!
                     //ask for the next page...
                     this._currentTrack = null;
                     this.fetchPlayList();
                     return
                 }
             }
         }

         this._currentTrack = track;
         this._renderPlaylist(true);
         return track;

     },

     /**
     * Gets the next track in the current playlist
     * return The next track
     */
     getNextTrack: function() {
         return this.incrementTrack(+1);
     },

     getPrevTrack: function() {
         return this.incrementTrack(-1);
     },

     getCurrentTrack: function() {
         return this._currentTrack;
     },

     _renderPlaylist: function(vetoHighlight) {

         if (vetoHighlight == undefined) {
             vetoHighlight = false;
         }

         var data = this.getPlaylist();
         var html = new EJS({ url: '/content/templates/playlist.html' }).render(data);
         this._domElement.innerHTML = html;

         //Highlight the area so that the user knows we've updated...
         if (!vetoHighlight) {
             $(this._domElement).effect("highlight", {}, 500);
         }

         //Scroll to the current track...
         var target = $("#" + this._currentTrack.ID).parent();

         if (target != null) {
             //$("#playList").scrollTo(target,200);
         } else {
             //$("#playList").scrollTo(0,200);
         }

         this._trackClick$Delegate = createDelegate(this, this._trackClick);
         $("#playerPlaylist li").find("a:first").click(this._trackClick$Delegate);

     },

     _trackClick: function(eventArgs) {
         var trackId = eventArgs.target.parentNode.id;
         var track = this.getTrackByID(trackId);
         this._currentTrack = track;
         this._renderPlaylist(true);
         this._ready();
     },

     getTrackByID: function(id) {
         var track = null;
         var playListLength = this._currentPlaylist.length;
         for (var i = 0; i < playListLength; i++) {
             if (this._currentPlaylist[i].ID == id) {
                 track = this._currentPlaylist[i];
                 break;
             }
         }

         return track;
     },

     ready: function(listener) {
         this.addListener("ready", listener);
     },

     _ready: function() {
         this._isReady = true;
         this._raise("ready");
     },

     getIsReady: function() {
         return this._isReady;
     }
 }); 

/**
* Because flash is so shit we cant wrap it with an instantiatable obj
* So essentially this acts like a singleton
*/
 var MusicPlayer = {

     _swfPlayer: null,
     _currentPlayerState: null,
     _currentTrack: null,
     _isHighlighting: false,

     playerStateHandler: function(eventArgs) {
         this._currentPlayerState = eventArgs.newstate;
         if (this.hasFinishedPlaying()) {
             this.playNextTrack();
         }
     },

     isPlaying: function() {
         return this._currentPlayerState == "PLAYING";
     },

     hasFinishedPlaying: function() {
         return this._currentPlayerState == "COMPLETED";
     },

     init: function(domElement, swfPlayer, playList) {
         this._domElement = domElement;
         this._playList = playList;
         this._playListReady$Delegate = createDelegate(this, this._playListReady);
         this._playList.ready(this._playListReady$Delegate);
         this._swfPlayer = swfPlayer;
         this._swfPlayer.addModelListener("STATE", "MusicPlayer.playerStateHandler");

         if (this._playList.getIsReady()) {
             this.playNextTrack();
         }
     },

     playNextTrack: function() {
         var next = this._playList.getNextTrack();
         if (next) {
             this.playTrack(next);
         }
     },

     playPrevTrack: function() {
         var prev = this._playList.getPrevTrack();
         if (prev) {
             this.playTrack(prev);
         }
     },

     playTrack: function(track) {
         this._currentTrack = track;
         this._swfPlayer.sendEvent("LOAD", "/music/listen/" + track.ID + ".mp3");
         this._swfPlayer.sendEvent("PLAY", "true");
         this._renderMusicPlayerForTrack(track);
     },

     stopTrack: function() {
         this._swfPlayer.sendEvent("PLAY", "false");
         this._renderMusicPlayerForTrack(this._currentTrack);
     },

     continueTrack: function() {
         this._swfPlayer.sendEvent("PLAY", "true");
         this._renderMusicPlayerForTrack(this._currentTrack);
     },

     togglePlayTrack: function() {
         if (this.isPlaying()) {
             this.stopTrack();
         } else {
             this.continueTrack();
         }
     },

     _renderMusicPlayerForTrack: function(track) {
         var html = new EJS({ url: '/content/templates/musicplayer.html' }).render(track);
         this._domElement.innerHTML = html;
         this._playNextTrack$Delegate = createDelegate(this, this.playNextTrack);
         this._playPrevTrack$Delegate = createDelegate(this, this.playPrevTrack);
         this._togglePlayTrack$Delegate = createDelegate(this, this.togglePlayTrack);

         $("#buttonNext").click(this._playNextTrack$Delegate);
         $("#buttonPrev").click(this._playPrevTrack$Delegate);
         $("#buttonPlay").click(this._togglePlayTrack$Delegate);

         if (this.isPlaying()) {
             $("#buttonPlay").addClass("on");
             $("#playerSpools").show();
         } else {
             $("#buttonPlay").removeClass("on");
             $("#playerSpools").hide();
         }

         if (this._isHighlighting == false) {
             this._isHighlighting = true;
             $(this._domElement).effect("highlight", {}, 500, createDelegate(this, this._highlightComplete));
         }
     },

     _highlightComplete: function() {
         this._isHighlighting = false;
     },

     _playListReady: function() {
         if (this.isPlaying() == false || this._playList.getCurrentTrack() == null) {
             //I'm not playing....  or the playlist doesnt have a current track
             this.playNextTrack();
         } else if (this._currentTrack != null && this._currentTrack != this._playList.getCurrentTrack()) {
             //We are playing a track, but not the track that the playlist thinks we are playing
             this.playTrack(this._playList.getCurrentTrack());
         }
     }
 };




var playListDataModel;
var playList;
var musicPlayerDataModel;
var musicPlayer;

$(document).ready(function(){
   createSWFPlayer();
});
 
function createSWFPlayer(){

    var flashvars = {
        autostart:"true",
        width:"142",
        height:"17",
        displayheight:"0",
        backcolor:"#8c8c8c",
        fullscreen:false,
        screenalpha:"0",
        skin:"/content/flash/listento.swf",
        type:"sound"
    }
    var params = {
        allowfullscreen:"false", 
        allowscriptaccess:"always"
    }
    var attributes = {
        id:"radio",  
        name:"radio"
    }

    swfobject.embedSWF("/content/flash/player.swf", "playerPlaceholder", "142", "17", "9.0.115", false, flashvars, params, attributes);

}

/**
* This is foul. 
* I wanted to entirely encapsulate the player BUT...
* the idiot who designed the flash player has prevents me from specifying my own handler.... Bitch
* Flash is shit. Long live HTML 5
*/
function playerReady(obj)
{
    var swfPlayer = document.getElementById(obj.id);
    playList = new PlayList($("#playerPlaylist")[0]);
    MusicPlayer.init($("#playerMain")[0], swfPlayer, playList);
    configurePlaylist(playList);
};
