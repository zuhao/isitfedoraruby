$(function() {
    var gems = new Bloodhound({
        datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        limit: 10,
        remote: '/searches/suggest_gems.json?q=%QUERY'
    });
    gems.initialize();
    $('#search_field').typeahead(null, {
        displayKey: 'name',
        source: gems.ttAdapter()
    }).bind('typeahead:selected', {}, function(e, d) {
        window.location.replace("/rubygems/"+d['name']);
    });
});
