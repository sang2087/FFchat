(function() {
  var client;

  client = new Faye.Client('/faye');

  client.subscribe('/chat', function(payload) {
    var time;
    time = moment(payload.created_at).format('D/M/YYYY H:mm:ss');
    return $('#chat_box').append("<li>" + time + " : " + payload.name + " | " + payload.message + "</li>");
  });

  $(document).ready(function() {
    var button, input;
    input = $('#msg_input');
    button = $('#post_button');
    user_name = $('#user_name');
    user_id = $('#user_id');

    return button.click(function() {
      var publication;
      button.attr('disabled', 'disabled');
      button.text('Posting...');

      publication = client.publish('/chat', {
				name: user_name.val(),
        message: input.val(),
        user_id: user_id.val(),
        created_at: new Date()
      });
      publication.callback(function() {
        input.attr('value', '');
        button.removeAttr('disabled');
        return button.text('Post');
      });
      return publication.errback(function() {
        button.removeAttr('disabled');
        return button.text('Try again');
      });
    });
  });

  window.client = client;

}).call(this);


