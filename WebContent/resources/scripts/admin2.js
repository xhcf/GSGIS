var status = 0;
var bar_status_history = 0;
var Menus = new DvMenuCls;

document.onclick=Menus.Clear;

function switchSysBar(){
	var switchPoint=document.getElementById("switchPoint");
	var frmTitle=document.getElementById("frmTitle");
	var mainleft=document.getElementById("mainleft");
	if (1 == window.status){
		window.status = 0;
		switchPoint.style.backgroundImage = 'url(../common/images/right.gif)';
		//frmTitle.style.display="none";
        frmTitle.style.right="-2000px";
        frmTitle.style.position="absolute";
		mainleft.style.width="98.5%"
	}
	else{
		window.status = 1;
		switchPoint.style.backgroundImage = 'url(../common/images/left.gif)';
        frmTitle.style.right="0px";
        frmTitle.style.position="absolute";
		mainleft.style.width="";
	}
	var x = $("#gismap").width()-120;
	$(".esriScalebar").css({"right":"0px","left":x});
}
function frmTitleShow(){
	var switchPoint=document.getElementById("switchPoint");
	var frmTitle=document.getElementById("frmTitle");
	var mainleft=document.getElementById("mainleft");
	switchPoint.style.backgroundImage = 'url(../common/images/left.gif)';
    frmTitle.style.right="0px";
    frmTitle.style.position="absolute";
	mainleft.style.width=""
}
function frmTitleHide(){
	var switchPoint=document.getElementById("switchPoint");
	var frmTitle=document.getElementById("frmTitle");
	var mainleft=document.getElementById("mainleft");
	switchPoint.style.backgroundImage = 'url(../common/images/right.gif)';
	//frmTitle.style.display="none";
    frmTitle.style.right="-2000px";
    frmTitle.style.position="absolute";
	mainleft.style.width="98.5%"
}
function DvMenuCls(){
	var MenuHides = new Array();
	this.Show = function(obj,depth){
		var childNode = this.GetChildNode(obj);
		if (!childNode){return ;}
		if (typeof(MenuHides[depth])=="object"){
			this.closediv(MenuHides[depth]);
			MenuHides[depth] = '';
		};
		if (depth>0){
			if (childNode.parentNode.offsetWidth>0){
				childNode.style.left= childNode.parentNode.offsetWidth+'px';

			}else{
				childNode.style.left='100px';
			};

			childNode.style.top = '-2px';
		};

		childNode.style.display ='none';
		MenuHides[depth]=childNode;

	};
	this.closediv = function(obj){
		if (typeof(obj)=="object"){
			if (obj.style.display!='none'){
				obj.style.display='none';
			}
		}
	}
	this.Hide = function(depth){
		var i=0;
		if (depth>0){
			i = depth
		};
		while(MenuHides[i]!=null && MenuHides[i]!=''){
			this.closediv(MenuHides[i]);
			MenuHides[i]='';
			i++;
		};

	};
	this.Clear = function(){
		for(var i=0;i<MenuHides.length;i++){
			if (MenuHides[i]!=null && MenuHides[i]!=''){
				MenuHides[i].style.display='none';
				MenuHides[i]='';
			}
		}
	}
	this.GetChildNode = function(submenu){
		for(var i=0;i<submenu.childNodes.length;i++)
		{
			if(submenu.childNodes[i].nodeName.toLowerCase()=="div")
			{
				var obj=submenu.childNodes[i];
				break;
			}
		}
		return obj;
	}

}


function getleftbar(obj){
	var leftobj;
	var titleobj=obj.getElementsByTagName("a");
	leftobj = document.all ? frames["frmleft"] : document.getElementById("frmleft").contentWindow;
	if (!leftobj){return;}
	var menubar = leftobj.document.getElementById("menubar")
	if (menubar){
		if (titleobj[0]){
			document.getElementById("leftmenu_title").innerHTML = titleobj[0].innerHTML;
		}
		var a=obj.getElementsByTagName("ul");
		for(var i=0;i<a.length;i++){
			menubar.innerHTML = a[i].innerHTML;
			//alert(a[i].innerHTML);
		}
	}
}
