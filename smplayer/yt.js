// Version: 2014-09-18

// Obsolete function
function aclara(a) {
	var d = a.split(".");
	var id = d[0].length + "." + (a.length - d[0].length - 1);

	if (id == "43.43") {
		return aclara_f(a);
	}
	return "";
}

function aclara_p(a,p) {
	var d = a.split(".");
	var id = d[0].length + "." + (a.length - d[0].length - 1);

	if ((p == "en_US-vflE7vgXe") || (id == "43.43")) {
		return aclara_f(a);
	}
	return "";
}

function aclara_f(a) {
	a=a.split("");
	sq.gm(a,46);
	sq.gm(a,22);
	sq.pY(a,79);
	sq.gm(a,33);
	sq.pY(a,47);
	sq.QD(a,3);
	sq.gm(a,18);
	sq.pY(a,62);
	sq.QD(a,3);
	return a.join("");
}

var sq ={pY:function(a){a.reverse()},QD:function(a,b){a.splice(0,b)},gm:function(a,b){var c=a[0];a[0]=a[b%a.length];a[b]=c} };

// A: NDMuNDM=
// B: ZW5fVVMtdmZsRTd2Z1hl
// C: MjAxNC0wOS0xOA==
// D: c3RzPTE2MzMx
// E: c3E=
