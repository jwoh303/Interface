<!--
function searching()
{  
	dhtml.style.left = 400;
	dhtml.style.top  = 300;

	var Pic = new Array() 
	   Pic[0] = 'img/clock.gif';
	
	var preLoad = new Array()
	for (i = 0; i < Pic.length ; i++){
	   	preLoad[i] = new Image();
	   	preLoad[i].src = Pic[i];
	}
	makeHtml();
}


function makeHtml()
{    
	document.all.dhtml.innerHTML=
	"<table><tr bgcolor=#BEBEBE><td align=center>\
	   <table border=0 cellspacing=0 cellpadding=0 Height=45 width='250'>\
         <tr bgColor=#FFFFFF>\
           <td rowspan=2 align=center><img src='img/clock.gif' align='absmiddle'></td>\
           <td valign=bottom><font color='blue'><b>&nbsp;데이터를 검색중입니다.</b></font></td></tr>\
         <tr bgColor=#FFFFFF>\
           <td><font color='blue'><b>&nbsp;잠시만 기다려주십시오....</b></font></td></tr>\
       </table>\
       </td></tr></table>";
       
	//image1 = window.document.statusImg;
	//var image1 = document.getElementById("statusImg");
	 

	// 이미지가 모두 로딩 완료시까지 10번동안 기다림
	/* 
	for(i=0;i<19999;i++) {
		// complete
		if(image1.readyState == 4) break;
	}
	*/

	dhtml.style.display = "block";
}
-->
