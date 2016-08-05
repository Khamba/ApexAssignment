$(document).ready(function(){
	$.get("/options.json", function(data){
		$("#saved_options").html('\
			<div aria-multiselectable="true" class="list-group" id="accordion" role="tablist">\
			</div>\
		');
		render_options(data["my_options"], "my_options", "My Saved Options");
		render_options(data["other_options"], "other_options", "Other People's Saved Options");
	});
});

// This function will render an accordion of the json data
// asynchronously obtained from the index path.
// How the renderd html will look like is given below the function
function render_options(options, id, title){
	var html = '\
		<div class="panel panel-default">\
			<div class="panel-heading" id="' + id + '" role="tab">\
				<h4 class="panel-title">\
					<a aria-controls="collapse' + id + '" aria-expanded="false" data-toggle="collapse" href="#collapse' + id + '" role="button">\
						' + title + '\
					</a>\
				</h4>\
			</div>\
			<div aria-labelledby="' + id + '" class="panel-collapse collapse" id="collapse' + id + '" role="tabpanel">\
				<div class="panel-body">\
	';
	$.each(options, function(index, option){
		html += '\
			<li class="list-group-item">\
				<a href="/options/' + option.id + '/edit"> ' + option.name + ' </a>\
			</li>\
		';
	});
	html += '\
		</div>\
		</div>\
		</div>\
	';
	$("#saved_options #accordion").append(html);
}

// <div aria-multiselectable="true" class="list-group" id="accordion" role="tablist">
//   <div class="panel panel-default">
//     <div class="panel-heading" id="my_options" role="tab">
//       <h4 class="panel-title">
//         <a aria-controls="collapseOne" aria-expanded="false" data-toggle="collapse" href="#collapseOne" role="button">
//           My Saved Options
//         </a>
//       </h4>
//     </div>
//     <div aria-labelledby="my_options" class="panel-collapse collapse" id="collapseOne" role="tabpanel">
//       <div class="panel-body">
//         <% @my_options.each do |option| %>
//           <li class="list-group-item">
//             <%= link_to option.name, edit_option_path(option) %>
//           </li>
//         <% end %>
//       </div>
//     </div>
//   </div>
//   <div class="panel panel-default">
//     <div class="panel-heading" id="other_options" role="tab">
//       <h4 class="panel-title">
//         <a aria-controls="collapseTwo" aria-expanded="false" class="collapsed" data-toggle="collapse" href="#collapseTwo" role="button">
//           Other People's Saved Options
//         </a>
//       </h4>
//     </div>
//     <div aria-labelledby="other_options" class="panel-collapse collapse" id="collapseTwo" role="tabpanel">
//       <div class="panel-body">
//         <% @other_options.each do |option| %>
//           <li class="list-group-item">
//             <%= link_to option.name, edit_option_path(option) %>
//           </li>
//         <% end %>
//       </div>
//     </div>
//   </div>
// </div>
