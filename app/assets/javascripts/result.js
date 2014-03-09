$(document).ready(function() {
  $('.site').click(function() {
    new_url = $(this).data('url');
    old_url = $('.site.active').data('url');
    
    if (new_url == old_url) { return; }
    
    $("#live-search input").val("");
    
    $('.results .block').removeClass('active').addClass('inactive');
    $('.results .block').each(function() {
     if ($(this).data('url') == new_url) {
        $(this).removeClass('inactive').addClass('active');
      }
    })
    
    var old_block_count = $(".block.inactive[data-url='" + old_url + "']").length;
    new_link_text = $('.site.active').text().replace(/\(([^)]+)\)/, "") + " (" + old_block_count + ")";
    $('.site.active').html( new_link_text );
    
    $('.navigation a').removeClass('active');
    $(this).addClass('active');
  })
  
  $('.all-sites').click(function() {
    old_url = $('.site.active').data('url');
    
    $("#live-search input").val("");
    
    $('.results .block').removeClass('inactive').addClass('active');
    
    var old_block_count = $(".block.active[data-url='" + old_url + "']").length;
    new_link_text = $('.site.active').text().replace(/\(([^)]+)\)/, "") + " (" + old_block_count + ")";
    $(('.site.active')).html( new_link_text );
    
    $('.navigation a').removeClass('active');
    $(this).addClass('active');
  });
  
  $("#live-search").submit(function() { return false; });
  
  $("#live-search input").keyup(function(){
    
    // Retrieve the input field text and reset the count to zero
    var filter = $(this).val(), count = 0;
    
    // Loop through the comment list
    $(".block.active").each(function(){
        
        // If the list item does not contain the text phrase fade it out
        if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).removeClass('active').addClass('inactive');
        
        // Show the list item if the phrase matches and increase the count by 1
        } else {
            $(this).removeClass('inactive').addClass('active');
            count++;
        }
    });
    
    // Update the count
    var numberItems = count;
    new_link_text = $('.site.active').text().replace(/\(([^)]+)\)/, "") + " (" + numberItems + ")";
    $('.site.active').html( new_link_text );
  });
});
