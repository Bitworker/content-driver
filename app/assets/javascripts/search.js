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
});
