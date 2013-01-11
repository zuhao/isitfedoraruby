$(function() {
  var search_text = null;

  $("#search_field").tokenInput("/searches/suggest_gems.json", {
  	onAdd: function (item) {
      $('input[id$=search_field]').val(item.name);
    },
      crossDomain: false,
      tokenLimit: 1,
      tokenValue: name
  });
  
  $('input[id$=token-input-search_field]').keyup(function() {
    search_text = $(this).val();
    $('input[id$=search_field]').val(search_text);
  });

  // XXX hack to preserve search text search box
  // looses focus
  $("#token-input-search_field").blur(function(event){
    $(event.target).val(search_text);
  });

});
