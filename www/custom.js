$(document).on('shiny:inputchanged', function(event) {

  if (event.name === 'submit') {

    var r = confirm("Please confirm submission of your picks");
    
    if (r === false) {
      event.preventDefault();
    } 

  }

});