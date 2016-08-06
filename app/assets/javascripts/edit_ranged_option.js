$(document).ready(function(){
  var range_attribute = $("input#option_range_attribute").val();
  var value = $("input#option_range_attribute").attr('data-range-to');
  if(range_attribute){
    $("div.option_interval").removeClass('hidden');
    var input = $("input#option_" + range_attribute).attr('placeholder', 'From');

    appendRangeToInputElement(input, value);
    rangeAdded = true;
  }
});
