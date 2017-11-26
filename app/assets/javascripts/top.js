$(window).on('turbolinks:load', function() {
  $('a').tooltip();
});

$(window).on('turbolinks:load', function() {
  $('.btn-top').click(function() {
    $('html,body').animate({scrollTop: 0}, 500, 'swing');
  });
});

$(window).on('turbolinks:load', function() {
  $('.btn-bottom').click(function() {
    $('html,body').animate({scrollTop: $('html,body')[0].scrollHeight}, 500, 'swing');
  });
});
