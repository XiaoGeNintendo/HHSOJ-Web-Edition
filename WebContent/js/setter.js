//Post function
function httpPost(URL, PARAMS) {
	var temp = document.createElement("form");
	temp.action = URL;
	temp.method = "post";
	temp.style.display = "none";

	for ( var x in PARAMS) {
		var opt = document.createElement("textarea");
		opt.name = x;
		opt.value = PARAMS[x];
		temp.appendChild(opt);
	}

	document.body.appendChild(temp);
	temp.submit();

	return temp;
}
	
function openEdit(pId,fn,mode){
	var para={
		"file":"problems/"+pId+"/"+fn,
		"mode":mode,
		"back":location.href
	}
	
	httpPost("set_editor.jsp",para);
}