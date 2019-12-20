function request(x) {
	console.log(this);
	console.log(x.json)
	if (x.json.error === true) {
		wd$("#message").item(0).textContent = x.json.message;
	} else {
		wd$("#message").item(0).textContent = "Operation successfully performed";
		wd$("#form").item(0).reset();
	}
	wd$("#dialog").action("open");
	return;
};
