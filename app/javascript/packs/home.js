import "../stylesheets/home_extra"

class Officer {
  constructor(name, role, imageURL){
    this.name = name;
    this.role = role;
    this.imageURL = imageURL;
  }

  createOfficer() {

  var div1 = document.createElement('div');
  div1.className = "col-lg-4";
  var div2 = document.createElement('div');
  div2.className = "team-member";

  const img = document.createElement("img");
  img.src = "/assets/" + this.imageURL;
  img.className = "mx-auto rounded-circle";
  img.setAttribute("style", "border-radius: 50%;");
  div2.appendChild(img);

  var nameField = document.createElement("h4");
  nameField.textContent = this.name;
  div2.appendChild(nameField);

  var roleField = document.createElement("p");
  roleField.textContent = this.role;
  div2.appendChild(roleField);
  div1.appendChild(div2);

  document.getElementById("officer-row").appendChild(div1);
  }
}
$(document).ready(function () {
  var officers = [];
  var officer1 = new Officer("Jane Doe", "President", "1.jpg");
  officers.push(officer1);

  var officer2 = new Officer("Matt Smith", "Vice President", "2.jpg");
  officers.push(officer2);

  var officer3 = new Officer("Tina Philips", "Treasurer", "3.jpg");
  officers.push(officer3);

  for (var i = 0; i < officers.length; i++){
    officers[i].createOfficer();
  }





});

(function($) {
    "use strict"; // Start of use strict

      // Preloader JS
jQuery(window).on('load', function () {
  // $('.preloader').fadeOut();
});
  
    // Smooth scrolling using jQuery easing
    $('a.js-scroll-trigger[href*="#"]:not([href="#"])').click(function() {
      if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
        if (target.length) {
          $('html, body').animate({
            scrollTop: (target.offset().top - 56)
          }, 1000, "easeInOutExpo");
          return false;
        }
      }
    });
  
    // Closes responsive menu when a scroll trigger link is clicked
    $('.js-scroll-trigger').click(function() {
      $('.navbar-collapse').collapse('hide');
    });
  
    // // Activate scrollspy to add active class to navbar items on scroll
    // $('body').scrollspy({
    //   target: '#mainNav',
    //   offset: 56
    // });
  
  })(jQuery); // End of use strict



  
  