$(document).ready(function () {
//    handleDate(
//        $("#StartDate_Hour"), 
//        $("#Doors_evaluated"),
//        $("#DoorsJSValue"),  
//        "",
//        "",
//        "h:mm:ss tt"
//    );

    
    $("#Venue_Name").autocomplete("/venue/fetchLike/", {
		dataType:"json",
		multiple: false,
        matchContains: true,
	    formatItem: function(data,i,max,value,term){
          return value;
        },
        formatResult: function(row){
          return value;
        },
        parse: function(data){
          var acd = new Array();
          var value = "";
          for(var i=0;i<data.length;i++){
            value = data[i].Name;
            if ( data[i].Address ) {
                value+= " (" + data[i].Address + ")";
            }
            acd[acd.length] = { data:data[i], value:value, result:data[i].Name };
          }
          return acd;
        }}
      ).result(function(event, data, formatted) {
         $('#Venue_Id').val(data.ID);
     });
    

    $("#linkedDates").datepicker( {     
            minDate: new Date(2001, 1 - 1, 1),    
            maxDate: new Date(2010, 12 - 1, 31),     
            beforeShow: readLinked,     
            onSelect: updateLinked,     
            showOn: "both",     
            buttonImage: "/content/images/datepicker/calendar.gif",     
            buttonImageOnly: true
    }); 
    
    
    $("#ActNames").autocomplete("/band/fetchLike/", {
		dataType:"json",
		multiple: true,
        matchContains: true,
	    formatItem: function(data,i,max,value,term){
          return value;
        },
        formatResult: function(row){
          return value;
        },
        parse: function(data){
          var acd = new Array();
          var value = "";
          for(var i=0;i<data.length;i++){
            value = data[i].Name;
            acd[acd.length] = { data:data[i], value:value, result:data[i].Name };
          }
          return acd;
        }}
      ).result(function(event, data, formatted) {
        var hidden = $("#ArtistIds");
		hidden.val( (hidden.val() ? hidden.val() + ";" : hidden.val()) + data.ID);
     });
     
    $("#month, #year").change(checkLinkedDays);

});



function handleDate( input , date_string, hidden, input_empty, empty_string, format) {

    var messages = ["Nope", "Keep Trying", "Nadda", "Sorry", "No one\'s home", "Arg", "Bummer", "Faux pas", "Whoops", "Snafu", "Blunder"];
    var date = null;
    input.val(input_empty);
    date_string.text(empty_string);
    hidden.val("");
    
    input.keyup(
        function (e) {
            date_string.removeClass("error")
            if (input.val().length > 0) {
                date = Date.parse(input.val());
                if (date !== null) {
                    input.removeClass("error");
                    date_string.addClass("accept").text(date.toString(format));
                    hidden.attr("value", date.toString("yyyy-MM-ddTHH:mm:ssZ")); 
                   // hidden.text(date.toString("yyyy-MM-ddTHH:mm:ssZ"));
                } else {
                    input.addClass("error");
                    date_string.addClass("error").text(messages[Math.round(messages.length * Math.random())] + "...");
                }
            } else {
                date_string.text(empty_string).addClass("empty");
            }
        }
    );
    
    input.focus(
        function (e) {
            if (input.val() === input_empty) {
                input.val("");
            }
        }
    );
     
    input.blur(
        function (e) {
            if (input.val() === "") {
                input.val(input_empty).removeClass();
            }
        }
    );
};
 


// Prepare to show a date picker linked to three select controls 
function readLinked() { 
    $('#linkedDates').val($('#month').val() + '/' + 
        $('#day').val() + '/' + $('#year').val()); 
    return {}; 
} 
 
// Update three select controls to match a date picker selection 
function updateLinked(date) { 
    $('#month').val(date.substring(0, 2)); 
    $('#day').val(date.substring(3, 5)); 
    $('#year').val(date.substring(6, 10)); 
} 
 
// Prevent selection of invalid dates through the select controls 
function checkLinkedDays() { 
    var daysInMonth = 32 - new Date($('#year').val(), 
     $('#month').val() - 1, 32).getDate(); 
    $('#day option').attr('disabled', ''); 
    $('#day option:gt(' + (daysInMonth - 1) +')').attr('disabled', 'disabled'); 
    if ($('#day').val() > daysInMonth) { 
        $('#day').val(daysInMonth); 
    } 
} 

