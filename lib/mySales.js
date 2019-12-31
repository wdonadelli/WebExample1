function request(x) {
	console.log(this);
	console.log(x.text)
	if (x.json.error === true) {
		wd$("#message").item(0).textContent = x.json.message;
	} else {
		wd$("#message").item(0).textContent = "Operation successfully performed";
		wd$("#window").action("close");
	}
	wd$("#dialog").action("open");
	return;
};
