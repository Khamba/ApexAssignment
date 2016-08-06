var rangeAdded = false;

$(document).ready(function(){
  // We add appropriate classes to parent divs because simple form is
  // not allowing us to do so
  addRangeableToParentDivs();

  listenForHoverEvents();

  $(".form-group").on('click', '.add_range', function(){
    var input = $(this).parent().find('input');
    $('.add_range').remove();
    var input_for = input.attr("placeholder", "From").attr('id').replace('option_', '');
    $("input#option_range_attribute").val(input_for);
    $("div.option_interval").removeClass('hidden');
    appendRangeToInputElement(input);
    rangeAdded = true;
  });

  $(".form-group").on('click', '.remove_range', function(){
    $(this).parent().find('input:nth-child(2)').remove();
    $(this).parent().find('input:first-child').css('width', '100%').attr('placeholder', '').parent().removeClass('remove-rangeable').addClass('add-rangeable');
    $("input#option_range_attribute").val('');
    $("div.option_interval").addClass('hidden');
    $("p.error#interval_error").html('');
    $('.remove_range').remove();
    rangeAdded = false;
  });

});

function appendRangeToInputElement(from_input, value){
  value = value || "";
  var width = from_input.css('width').replace('data-','');
  width = parseInt(width) / 2;
  from_input.parent().removeClass('add-rangeable').addClass('remove-rangeable');
  from_input.css('width', 'calc(' + width + 'px - 1.5%)');
  var inputElement = '<input style="width: calc(' + width + 'px - 1.5%);" class="numeric decimal optional remove-rangeable form-control" step="any" name="option[range_to]" id="option_range_to" type="number" placeholder="To" value="' + value + '">';
  from_input.parent().append(inputElement);
}

function addRangeableToParentDivs(){
  $('.add-rangeable').removeClass('add-rangeable').parent().addClass('add-rangeable');
  $('.remove-rangeable').removeClass('remove-rangeable').parent().addClass('remove-rangeable');
}

function listenForHoverEvents(){
  $('.form-group').on('mouseenter', 'div.col-sm-9.add-rangeable', function(){
    if (!rangeAdded) {
      $(this).append('<a class="add_range range-control"> Add a range and get a chart </a>');
    }
  });
  $('.form-group').on('mouseleave', 'div.col-sm-9.add-rangeable', function(){
    $('.add_range').remove();
  });

  $('.form-group').on('mouseenter', 'div.col-sm-9.remove-rangeable', function(){
    $(this).append('<a class="remove_range range-control"> Remove the range and add a single value </a>');
  });
  $('.form-group').on('mouseleave', 'div.col-sm-9.remove-rangeable', function(){
    $('.remove_range').remove();
  });
}
