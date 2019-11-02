var REPORT = {
	clients:   "lib/myReports.php?tab=clients",
	products:  "lib/myReports.php?tab=products",
	sales:     "lib/myReports.php?tab=sales",
	lclients:  "lib/myReports.php?tab=lclients",
	lproducts: "lib/myReports.php?tab=lproducts",
	lsales:    "lib/myReports.php?tab=lsales"
}

function request(x) {
	console.log(x.json)
	if (x.json.error === true) {
		wd$("#message").item(0).textContent = x.json.message;
	} else {
		wd$("#message").item(0).textContent = "Operation successfully performed";
	}
	wd$("#dialog").action("open");
	return;
};


















wd(window).handler({});
