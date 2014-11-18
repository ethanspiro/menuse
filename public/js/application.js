$(document).ready(function() {

    //validation of user signup
    $("#form_user").validate({
      rules:
      {
        username: {
          required: true,
          rangelength: [3, 15]
        },
        email: {
          required: true,
          email: true
        },
        password: {
          required: true,
          rangelength: [4, 20]
        },
        password_confirm: {
          required: true,
          equalTo: "#password"
        }
      }
      }); //validate ends here


    //validation of restaurant sign up
    $("#form_restaurant").validate({
      rules:
      {
        name_restaurant: {
          required: true,
        },
        email: {
          required: true,
          email: true
        },
        password: {
          required: true,
          rangelength: [4, 20]
        },
        password_confirm: {
          required: true,
          equalTo: "#password"
        }
      }
      }); //validate ends here

    bindEvents();

    function bindEvents() {
      console.log("in the bind events function");
      $('.pin_form').on('submit', pinItem);
      $('.pin_delete_form').on('submit', deletePin);
    }

    //~~~~~~~~~~~ pin an item ~~~~~~~~~~~~
    function pinItem(e) {
      e.preventDefault();
      e.stopPropagation();
      pin_button = this
      var the_data = $(this).serialize();
      $.ajax({
        url: this.action,
        type: 'post',
        data: the_data
      })
      .done(function(server_data) {
        pin_button.firstElementChild.nextElementSibling.outerHTML = '<img class="small_heart" src="/images/heart.png" />';
      })
      .fail(function() {
      })
    }

    //~~~~~~~~~~~ pin an item ~~~~~~~~~~~~
    function deletePin(e) {
      console.log("ajax - initial");
      e.preventDefault();
      delete_button = this;
      var the_data = $(this).serialize();
      $.ajax({
        url: this.action,
        type: 'delete',
        data: the_data
      })
      .done(function(server_data) {
        console.log("ajax - success");
        delete_button.parentElement.parentElement.parentElement.parentElement.remove();
      })
      .fail(function() {
        console.log("ajax - failure");
      })
    }

  });
