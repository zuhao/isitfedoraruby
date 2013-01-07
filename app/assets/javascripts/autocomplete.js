$(function() {
$("#search_field").tokenInput("/searches/suggest_gems.json", {
   onAdd: function (item) {
   document.getElementById("search_field").value = item.name;
   },
   crossDomain: false,
   tokenLimit: 1,
   tokenValue: name
  });
$('input[id$=token-input-search_field]').keyup(function() {
  var copyVal = $(this).val();
  $('input[id$=search_field]').val(copyVal);
  });
  });
