fetch("/README.txt")
		.then(data => data.text())
		.then(text => {
			console.log(text);
		});
