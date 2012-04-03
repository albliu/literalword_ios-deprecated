var selectedVerses=new Array();

function sortVerse(a,b)
{
	return a - b;
}

function findInArray(arr,val) {
	for (var i = 0; i < arr.length; i++) {
		if (arr[i] == val) return i;
	}
	return -1;
}

function jumpToElement(id) {
    var elem = document.getElementById(id);
    var x = 0;
    var y = 0;

    while (elem != null) {
        x += elem.offsetLeft;
        y += elem.offsetTop;
        elem = elem.offsetParent;
    }
    
    window.scrollTo(x,y);
}

function highlight(id) {
	var elem = document.getElementById(id);
	elem.className = 'active';
	window.verse.clickVerse(elem.id, elem.innerText, elem.className);
	
	var dchild = elem.getElementsByTagName('div');
	for (var i = 0; i < dchild.length; i++) {
		dchild[i].firstChild.className = elem.className;
	}
}

function unhighlight(id) {
	var elem = document.getElementById(id);
	elem.className = '';
	window.verse.clickVerse(elem.id, elem.innerText, elem.className);

	var dchild = elem.getElementsByTagName('div');
	for (var i = 0; i < dchild.length; i++) {
		dchild[i].firstChild.className = elem.className;
	}
}

function highlightPoint(x, y) {

	var elem = document.elementFromPoint(x,y);
	if (elem == null) return selectedVerses.length;

	while (elem.tagName != "V") {
    		elem = elem.parentNode;
	}

	if (elem.className == "active") {
		elem.className = '';
		var exists = findInArray(selectedVerses, elem.id);
		if (exists != -1) selectedVerses.splice(exists, 1); 

	} else {
		elem.className = 'active';
		selectedVerses.push(elem.id);	
	}

	var dchild = elem.getElementsByTagName('div');
	for (var i = 0; i < dchild.length; i++) {
		dchild[i].firstChild.className = elem.className;
	}	

	return selectedVerses.length;

}

function clearhighlight() {
	
	
	for (var i = 0; i < selectedVerses.length;i++) {
		var elem = document.getElementById(selectedVerses[i]);
		elem.className = '';
	}
	selectedVerses.length = 0;
}

function highlightedVerses() {

	var retString = '';

	selectedVerses.sort(sortVerse);	
	for (var i = 0; i < selectedVerses.length;i++) {
		retString += selectedVerses[i] ;
		if  (i != (selectedVerses.length -1)) retString += ':'; 
	}

	return retString;
}

