$(document).ready(function(){
	$.get("/options", function(data){
		$("div#saved_options").html(data);
	});
});