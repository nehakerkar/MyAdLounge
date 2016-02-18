$("#lnkExport").click(function(event) {
	event.preventDefault();
});

function exportTableToCSV(tablename){
	//alert(tablename);
	var filename = "AdWords_Account_Structure.csv"
	var table = $(tablename);
	var $rows = table.find('tbody tr:has(td)');

	// Temporary delimiter characters unlikely to be typed by keyboard
	// This is to avoid accidentally splitting the actual contents
	tmpColDelim = String.fromCharCode(11), // vertical tab character
	tmpRowDelim = String.fromCharCode(0), // null character

	// actual delimiter characters for CSV format
	colDelim = '","', rowDelim = '"\r\n"',

	$labels = table.find('thead tr');
	csv = '"'
			+ $labels.map(function(i, label) {
				var $label = $(label), $cols = $label.find('th');

				return $cols.map(function(j, col) {
					var $col = $(col), text = $col.text();

					return text.replace(/"/g, '""'); // escape double quotes

				}).get().join(tmpColDelim);

			}).get().join(tmpRowDelim).split(tmpRowDelim).join(rowDelim).split(
					tmpColDelim).join(colDelim) + rowDelim,

	// Grab text from table into CSV formatted string
	csv += $rows.map(function(i, row) {
		var $row = $(row), $cols = $row.find('td');

		return $cols.map(function(j, col) {
			var $col = $(col), text = $col.text();

			return text.replace(/"/g, '""'); // escape double quotes

		}).get().join(tmpColDelim);

	}).get().join(tmpRowDelim).split(tmpRowDelim).join(rowDelim).split(
			tmpColDelim).join(colDelim)
			+ '"',

	// Data URI
	csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

	// alert("filename: " + filename);
	// alert(csvData);
	if (msieversion()) {
		var IEwindow = window.open();
		IEwindow.document.write('sep=,\r\n' + csvData);
		IEwindow.document.close();
		IEwindow.document.execCommand('SaveAs', true, filename);
		IEwindow.close();
	} else {
		var link = document.createElement("a");
		link.href = csvData;

		// set the visibility hidden so it will not effect on your web-layout
		link.style = "visibility:hidden";
		link.download = filename;

		// this part will append the anchor tag and remove it after automatic
		// click
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
	}
}

function exportTableToTSV(tablename){
	//alert(tablename);
	var filename = "AdWords_Account_Structure.tsv"
	var table = $(tablename);
	var $rows = table.find('tbody tr:has(td)');

	// Temporary delimiter characters unlikely to be typed by keyboard
	// This is to avoid accidentally splitting the actual contents
	tmpColDelim = String.fromCharCode(11), // vertical tab character
	tmpRowDelim = String.fromCharCode(0), // null character

	// actual delimiter characters for CSV format
	colDelim = '\t', rowDelim = '\r\n',

	$labels = table.find('thead tr');
	csv = $labels.map(function(i, label) {
				var $label = $(label), $cols = $label.find('th');

				return $cols.map(function(j, col) {
					var $col = $(col), text = $col.text();

					return text.replace(/"/g, ''); // escape double quotes

				}).get().join(tmpColDelim);

			}).get().join(tmpRowDelim).split(tmpRowDelim).join(rowDelim).split(
					tmpColDelim).join(colDelim) + rowDelim,

	// Grab text from table into CSV formatted string
	csv += $rows.map(function(i, row) {
		var $row = $(row), $cols = $row.find('td');

		return $cols.map(function(j, col) {
			var $col = $(col), text = $col.text();

			return text.replace(/"/g, ''); // escape double quotes

		}).get().join(tmpColDelim);

	}).get().join(tmpRowDelim).split(tmpRowDelim).join(rowDelim).split(
			tmpColDelim).join(colDelim),

	// Data URI
	csvData = 'data:application/tsv;charset=utf-8,' + encodeURIComponent(csv);

	// alert("filename: " + filename);
	// alert(csvData);
	if (msieversion()) {
		var IEwindow = window.open();
		IEwindow.document.write('sep=,\r\n' + csvData);
		IEwindow.document.close();
		IEwindow.document.execCommand('SaveAs', true, filename);
		IEwindow.close();
	} else {
		var link = document.createElement("a");
		link.href = csvData;

		// set the visibility hidden so it will not effect on your web-layout
		link.style = "visibility:hidden";
		link.download = filename;

		// this part will append the anchor tag and remove it after automatic
		// click
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
	}
}

function msieversion() {
	var ua = window.navigator.userAgent;
	var msie = ua.indexOf("MSIE ");
	// alert("user agent:"+ua);
	if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) // If
																		// Internet
																		// Explorer,
																		// return
																		// true
	{
		return true;
	} else { // If another browser,
		return false;
	}
	return false;
}