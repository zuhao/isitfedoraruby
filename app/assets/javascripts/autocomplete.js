$(function() {

  $('#search_field').typeahead({
    source: function(typeahead, query) {
      var _this = this;
      return $.ajax({
        url: "/searches/suggest_gems.json?q=" + query,
        success: function(data) {
          return typeahead.process(data);
        }
      });
    },
    property: "name",
    onselect: function(item){
      window.location.replace("/searches/"+item['name']);
    }
  });

});
