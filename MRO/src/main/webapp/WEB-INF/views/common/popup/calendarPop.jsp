<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/common_layout.css" type="text/css" />
</head>
<script type="text/javascript">
//<![CDATA[ 
function calOnload() 
{ 
     var now = new Date(); 
     window.document.getElementById('select_year').innerHTML  = now.getFullYear(); 
     window.document.getElementById('select_month').innerHTML = now.getMonth()+1; 
     calendar(now.getFullYear(),now.getMonth()); //<2011년9월> 달력 시작페이지의 년/월 <월은 0 = 1월> 
} 
function setday(year,month,day){
	
	month = month + 1;	 
	if (eval(month) <10){
		month = "0"+month;
	}
	if (eval(day) <10){
		day = "0"+day;
	}	 
	opener.setPopupCalendar(year,month,day);
	self.close();
} 

function calendar(year, month, dd) 
{ 
	

	
     var tags = '<table class="t_carlendar"><caption>달력 리스트</caption>'; //테이블 지정 
     tags += '<colgroup><col width="30px" /><col width="30px" /><col width="30px" /><col width="30px" /><col width="30px" /><col width="30px" /><col width="30px" /></colgroup><thead>';
     tags += '<tr><th scope="col">일</th><th scope="col">월</th><th scope="col">화</th><th scope="col">수</th><th scope="col">목</th><th scope="col">금</th><th scope="col">토</th></tr></thead><tbody><tr>'; // 달력 요일 구성 
     var date = new Date(); 
     
     var today = date.getDate();
     var tomonth = date.getMonth();
      
     date.setFullYear(year,month,1); 
     var day = date.getDay(); //요일(0=일요일 1=월요일 2=화요일 3=수요일 4=목요일 5=금요일 6=토요일) 
     for(var i=0; i<day;i++) //요일 앞에 테이블을 빈 값으로 채움 
     { 
            tags += '<td>&nbsp;</td>'; 
     } 
     while(date.getMonth()==month) //같은 달인지 확인 
     { 
            if(date.getDate()!=1&&date.getDay()==0) 
            { 
                   tags += '</tr><tr>'; 
            }   
             
            if ((today == date.getDate())  && (tomonth==month)){
            	 tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')" class="today">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
            }else{
	            if ( date.getDay() == '0' ) 
	            { 
	                   if(dd!=undefined && dd==date.getDate()) 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')" class="sun">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	                   else 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')"  class="sun">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	            } 
	            else if ( date.getDay() == '6' ) 
	            { 
	                   if(dd!=undefined && dd==date.getDate()) 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')" class="sat">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	                   else 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')" class="sat">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	            } 
	            else 
	            { 
	                   if(dd!=undefined && dd==date.getDate()) 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	                   else 
	                       tags += '<td><a href="javascript:setday('+year+','+month+','+date.getDate()+')">'+date.getDate()+'</a></td>'; // 표에 날자를 입력 
	            } 
            }
            date.setDate(date.getDate()+1); // 1일 증가 <마지막에 1증가해서 다음 달로 넘어감> 
     } 
     var days=date.getDay(); //다음달 1일 
     if(days!=0) // 다음달 1일이 일요일이 아니면 빈칸을 공백으로 채움 
     { 
            var last = 6-days+1; 
            for(var i=0;i<last;i++) 
            { 
                   tags += '<td>&nbsp;</td>'; 
            } 
     } 
     tags += '</tbody></tr></table>'; // 테이블 닫음  
     var print = document.getElementById('test'); 
     print.innerHTML=tags; // tags테이블을 출력 
} 
function before_month() //이전 달 
{ 
     var year= window.document.getElementById('select_year'); 
     var month= window.document.getElementById('select_month'); 
     if(month.innerHTML==1){ // 1월일 때 ◀ 버튼을 누르면 다음은 12월을 출력 
        month.innerHTML=12; 
        year.innerHTML= parseInt(year.innerHTML)-1; // 년도 1감소 
        }else{ 
        month.innerHTML=parseInt(month.innerHTML)-1; // 월 -1감소 
     } 
     calendar(year.innerHTML,parseInt(month.innerHTML)-1); //달력호출 
} 
function after_month() //다음 달 
{ 
     var year = window.document.getElementById('select_year'); 
     var month = window.document.getElementById('select_month'); 
     if(month.innerHTML==12) // 12월일 때 ▶ 버튼을 누르면 다음은 1월을 출력 
     { 
            month.innerHTML=1; 
            year.innerHTML=parseInt(year.innerHTML)+1; // 년을 증가 
     } 
     else 
     { 
            month.innerHTML=parseInt(month.innerHTML)+1; // 1달 증가 
     } 
     calendar(year.innerHTML,parseInt(month.innerHTML)-1); //달력호출 
} 
function goto_today() // 현재 년도 달로 돌아감 
{ 
     var now = new Date(); 
     calendar(now.getFullYear(),now.getMonth(), now.getDate()); 
     window.document.getElementById('select_year').innerHTML  = now.getFullYear(); 
     window.document.getElementById('select_month').innerHTML = now.getMonth()+1; 
} 
//]]> 
</script> 
</head> 
<body onload='calOnload(); '>
<div align="center">
<div id="cldrArea">
    	<div id="cldrTop"> 
            <span class="btn"><a href="javascript:before_month();"><img src="/resources/images/btn_prevcldr.gif" alt="이전으로가기" /></a></span>
             <span id='select_year'> 2012</span>년 
            <span id='select_month'>9</span> 월 
            <span class="btn"><a href="javascript:after_month();"><img src="/resources/images/btn_nextcldr.gif" alt="다음으로가기" /></a></span> 
            </div>             
          <div id ='test'></div>  
            <div id="cldrBtnArea">
			<span class="btn_imghide"><a href="javascript:goto_today();">오늘날짜</a></span>
       		 </div>     
     </div>
    </div>
</body>
</html>
