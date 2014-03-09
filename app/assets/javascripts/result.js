$(document).ready(function() {
  $('.site').click(function() { 
    url = $(this).data('url');
    $('a').removeClass('active');
    $(this).addClass('active');
    
    $('.results .block').hide();
    $('.results .block').each(function() {
      if ($(this).data('url') == url) {
        $(this).show();
      }
    })
  })
  
  $('.all-sites').click(function() { $('.results .block').show(); $('a').removeClass('active'); $(this).addClass('active'); });
});
