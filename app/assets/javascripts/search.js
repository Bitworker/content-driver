// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('#sites').tagsInput({
   'height': '135px',
   'width': '600px',
   'interactive': true,
   'defaultText': 'Welche Seiten willst du durchsuchen?',
   'onAddTag':function(tag){
     // Validate?
   },
   'onRemoveTag':function(tag){
     //
   },
   'removeWithBackspace': true,
   'minChars': 2,
   'maxChars': 80,
   'placeholderColor': '#777'
  });

  $("#live-search input").keyup(function(){
    
    // Retrieve the input field text and reset the count to zero
    var filter = $(this).val();
    
    // Loop through the comment list
    $(".block").each(function(){

        // If the list item does not contain the text phrase fade it out
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).fadeOut();

        // Show the list item if the phrase matches and increase the count by 1
        } else {
            $(this).show();
        }
    });
  });
});
