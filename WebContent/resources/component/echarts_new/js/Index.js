function changeTab(n){
    //tab个数
    var len=2;
    for(i=1;i<=len;i++){
	    document.getElementById("tab_"+i).style.display=(i==n)?"block":"none";
	    document.getElementById("tab_head_"+i).className=(i==n)?"isactive":"none";
    }
}



