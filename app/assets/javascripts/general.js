$(document).ready(function() {
 // flash message for people coming from other countries
 var htmlWrapperFront = [
                          '<div class="alert alert--alert alert--locality" role="alert" id="locality-alert">',
                          ' <div class="alert__content">',
                        ];
 var htmlWrapperBack = [
                          '   <a href="#top" class="alert__close js-alert__close" aria-label="close">',
                          '     <span aria-hidden="true">&times;</span>',
                          '   </a>',
                          ' </div>',
                          '</div>',
                        ];
var wholeMessage = '';
if(window.location.search.substring(1).search("country_name") == -1) {
  if (!$.cookie('has_seen_country_message')) {
    $.ajax({
      url: "/country_message",
      dataType: 'html',
      success: function(country_message){
        if (country_message != ''){
          wholeMessage = htmlWrapperFront.join('') + country_message + htmlWrapperBack.join('');
          $('#country-message').html(wholeMessage);
          $('body:not(.front) #locality-alert').show()
        }
      }
    })
  }
}

 // alerts
$('#locality-alert .js-alert__close').click(function() {
  $('#locality-alert').hide('slow');
  $.cookie('has_seen_country_message', 1, {expires: 365, path: '/'});
  return false;
});

$('#standard-alert .js-alert__close').click(function() {
  $('#standard-alert').hide('slow');
  $.cookie('seen_foi2', 1, { expires: 7, path: '/' });
  return false;
});


  // "link to this" box
  $('.cplink__button').click(function() {
    var box = $(this).prev('.cplink__field');
    box.select();
  });


     $('.close-button').click(function() { $(this).parent().hide() });
     $('div#variety-filter a').each(function() {
       $(this).click(function() {
         var form = $('form#search_form');
         form.attr('action', $(this).attr('href'));
         form.submit();
         return false;
     })
   })

   if($.cookie('seen_foi2') == 1) {
     //$('#standard-alert').hide();
   }

  // "Create widget" page
  $("#widgetbox").select()
  // Chrome workaround
  $("widgetbox").mouseup(function() {
    // Prevent further mouseup intervention
    $this.unbind("mouseup");
    return false;
  });

  $('.js-toggle-delivery-log').on('click', function(e){
    e.preventDefault();

    var $correspondence = $(this).parents('.correspondence');
    var url = $(this).attr('href');
    var $correspondence_delivery = $correspondence.find('.correspondence_delivery');

    if( $correspondence_delivery.length ){
      removeCorrespondenceDeliveryBox($correspondence_delivery);
    } else {
      loadCorrespondenceDeliveryBox($correspondence, url);
    }
  });

  var loadCorrespondenceDeliveryBox = function loadCorrespondenceDeliveryBox($correspondence, url){
    var $toggle = $correspondence.find('.js-toggle-delivery-log');
    var $correspondence_delivery = $('<div>')
      .addClass('correspondence_delivery')
      .addClass('correspondence_delivery--' + $toggle.attr('data-delivery-status'))
      .hide()
      .insertBefore( $correspondence.find('.correspondence_text') );

    $toggle.addClass('toggle-delivery-log--loading');

    $.ajax({
      url: url,
      dataType: "html"
    }).done(function(html){
      var $deliveryDiv = $(html).find('.controller_delivery_statuses');
      $correspondence_delivery.html( $deliveryDiv.html() );
      $correspondence_delivery.slideDown(200);
    }).fail(function(){
      var msgHtml = $('.js-delivery-log-ajax-error').html();
      $correspondence_delivery.html( msgHtml );
      $correspondence_delivery.slideDown(200);

    }).always(function(){
      $toggle.removeClass('toggle-delivery-log--loading');
    });
  }

  var removeCorrespondenceDeliveryBox = function removeCorrespondenceDeliveryBox($correspondence_delivery){
    $correspondence_delivery.slideUp(200, function(){
      $correspondence_delivery.remove();
    });
  }
})
