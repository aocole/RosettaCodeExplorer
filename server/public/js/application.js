var RCI = {}

RCI.config = {
	base_url: '',
}

RCI.load_code = function(lang, task) {
	$.getJSON([RCI.config.base_url, 'Lang', lang, task + '.json'].join('/'), function(samples) {
		var existing_samples = $('.' + lang + '.' + task);
		if(existing_samples.length > 0) {
			existing_samples.remove();
			return;
		}
		RCI.insert_code(lang, task, samples);
	});
}

RCI.insert_code = function(lang, task, samples) {
	for (sample in samples) {
		var codetainer = '#code' + sample;
		if($(codetainer).length == 0) {
			$('#code').append('<div class="row" id="' + codetainer.replace('#', '') + '"></div>');
		}
		$(codetainer).append('\
			<div class="span4 ' + lang + ' ' + task +'">\
				<h3>' + lang + ': ' + task + ' sample ' + sample + '</h3>\
				<pre class="pre-scrollable">' + samples[sample] + '</pre>\
			</div>\
		');
	}
}

