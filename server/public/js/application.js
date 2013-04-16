var RCI = {}

RCI.config = {
	base_url: '',
}

RCI.toggle_code = function(lang, task) {
	var existing_samples = $('.' + lang + '.' + task);
	if(existing_samples.length > 0) {
		existing_samples.remove();
		return;
	}
	$.getJSON([RCI.config.base_url, 'Lang', lang, task + '.json'].join('/'), function(samples) {
		RCI.insert_code(lang, task, samples);
	});
}

RCI.insert_code = function(lang, task, samples) {
	var column = $('<div class="span4 ' + lang + ' ' + task +'"></div>');
	$('#code_container').append(column);
	column.append('<i style="float:right" class="close-sample icon-remove"></i>');
	column.append('<h4>' + lang + ': <br/>' + task + '</h4>');
	for (sample in samples) {
		var row = $('<div class="row"></div>');
		column.append(row);
		row.append('\
			<i style="float:right" class="close-sample icon-remove"></i>\
			<h4><a href="https://raw.github.com/acmeism/RosettaCodeData/master' + samples[sample].path +'">Sample ' + (Number(sample) + 1) + '</a></h4>\
			' + samples[sample].text + '\
		');
	}
}

RCI.set_lang_visibility = function(lang_index, visible) {
    var table = $('#matrix_table').dataTable();
    table.fnSetColumnVis(lang_index, visible);
    return visible;
}

RCI.set_task_visibility = function(task_index, visible) {
    var table = $('#matrix_table').dataTable();
    table.fnSetColumnVis(lang_index, visible);
    return visible;
}

RCI.add_minor_tasks = function() {
	var table = $('#matrix_table').dataTable();
	$.each(RCI.minor_tasks, function(i, task){
		task.counts.unshift(task.name);
		table.fnAddData(task.counts, false);
	});
	table.fnDraw();
}

