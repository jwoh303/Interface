<%--
**********************************************
* 메뉴 : VOC Analysis>VOC Lead Time
* 화면 : VOC Lead Time
* 기능 : 
* 프로그램 ID : PG_90_C_800_05
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-21
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_year = CommonUtil.nvl((String) request.getParameter("st_year") , "");
String curr_date = DateTimeUtil.getFormatString("yyyyMMdd");
if("".equals(st_year)){
	st_year = curr_date.substring(0,4);
}
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"선택|선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"VOC 유형코드|VOC 유형코드",	SaveName:"CLAIM_TYPE"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"VOC 유형|VOC 유형",	SaveName:"CLAIM_TEXT"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|1월",	SaveName:"DATE_1"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|2월",	SaveName:"DATE_2"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|3월",	SaveName:"DATE_3"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|4월",	SaveName:"DATE_4"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|5월",	SaveName:"DATE_5"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|6월",	SaveName:"DATE_6"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|7월",	SaveName:"DATE_7"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|8월",	SaveName:"DATE_8"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|9월",	SaveName:"DATE_9"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|10월",	SaveName:"DATE_10"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|11월",	SaveName:"DATE_11"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:false,	Type:"Text",	Header:"<%=st_year%>년|12월",	SaveName:"DATE_12"}
					,{ Align:"Center",	Width:75,	Edit:false,	EditLen:75,	Hidden:true,	Type:"AutoAvg",	Header:"|1월",	SaveName:"AUTO_AVG"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	// 합계 컬럼 타이틀 변경 및 폰트 색상 변경
	mySheet.SetSumText("CLAIM_TEXT","평 균 Lead Time");
	mySheet.SetSumFontColor("#0000FF");
	mySheet.SetSumFontBold(true);
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		kepSearch(document.searchCondition,  mySheet , "/mpvo/getMasterMpVoVocLeadTimeList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;

	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	
	var mon_1			= 0;
	var mon_2			= 0;
	var mon_3			= 0;
	var mon_4			= 0;
	var mon_5			= 0;
	var mon_6			= 0;
	var mon_7			= 0;
	var mon_8			= 0;
	var mon_9			= 0;
	var mon_10			= 0;
	var mon_11			= 0;
	var mon_12			= 0;

	for( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		mon_1 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_1"))) ?eval(mySheet.GetCellValue(i, "DATE_1")) : 0;
		mon_2 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_2"))) ?eval(mySheet.GetCellValue(i, "DATE_2")) : 0;
		mon_3 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_3"))) ?eval(mySheet.GetCellValue(i, "DATE_3")) : 0;
		mon_4 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_4"))) ?eval(mySheet.GetCellValue(i, "DATE_4")) : 0;
		mon_5 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_5"))) ?eval(mySheet.GetCellValue(i, "DATE_5")) : 0;
		mon_6 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_6"))) ?eval(mySheet.GetCellValue(i, "DATE_6")) : 0;
		mon_7 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_7"))) ?eval(mySheet.GetCellValue(i, "DATE_7")) : 0;
		mon_8 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_8"))) ?eval(mySheet.GetCellValue(i, "DATE_8")) : 0;
		mon_9 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_9"))) ?eval(mySheet.GetCellValue(i, "DATE_9")) : 0;
		mon_10 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_10"))) ?eval(mySheet.GetCellValue(i, "DATE_10")) : 0;
		mon_11 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_11"))) ?eval(mySheet.GetCellValue(i, "DATE_11")) : 0;
		mon_12 += (kepIsNumberString(mySheet.GetCellValue(i, "DATA_12"))) ?eval(mySheet.GetCellValue(i, "DATE_12")) : 0;
	}
	
	// 합계 컬럼의 값을 정수값으로 바꾼다.
	mySheet.SetSumText(4, Math.floor(mon_1/8) + " 일");
	mySheet.SetSumText(5, Math.floor(mon_2/8) + " 일");
	mySheet.SetSumText(6, Math.floor(mon_3/8) + " 일");
	mySheet.SetSumText(7, Math.floor(mon_4/8) + " 일");
	mySheet.SetSumText(8, Math.floor(mon_5/8) + " 일");
	mySheet.SetSumText(9, Math.floor(mon_6/8) + " 일");
	mySheet.SetSumText(10, Math.floor(mon_7/8) + " 일");
	mySheet.SetSumText(11, Math.floor(mon_8/8) + " 일");
	mySheet.SetSumText(12, Math.floor(mon_9/8) + " 일");
	mySheet.SetSumText(13, Math.floor(mon_10/8) + " 일");
	mySheet.SetSumText(14, Math.floor(mon_11/8) + " 일");
	mySheet.SetSumText(15, Math.floor(mon_12/8) + " 일");
}
	
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>VOC Lead Time</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>VOC Lead Time</caption>
					<colgroup>
						<col width="10%" />
						<col width="" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>기준년도</td>
							<td colspan="5">
								<select name="st_year" style="width: 70px;">
					                <option <%=(st_year.equals(curr_date.substring(0,4)) ? "selected" : "")%> value="<%=curr_date.substring(0,4)%>"><%=curr_date.substring(0,4)%></option>
					                <option <%=(st_year.equals(DateTimeUtil.addYears(curr_date, -1).substring(0,4)) ? "selected" : "")%> value="<%=DateTimeUtil.addYears(curr_date, -1).substring(0,4)%>"><%=DateTimeUtil.addYears(curr_date, -1).substring(0,4)%></option>
					                <option <%=(st_year.equals(DateTimeUtil.addYears(curr_date, -2).substring(0,4)) ? "selected" : "")%> value="<%=DateTimeUtil.addYears(curr_date, -2).substring(0,4)%>"><%=DateTimeUtil.addYears(curr_date, -2).substring(0,4)%></option>                
					                <option <%=(st_year.equals(DateTimeUtil.addYears(curr_date, -3).substring(0,4)) ? "selected" : "")%> value="<%=DateTimeUtil.addYears(curr_date, -3).substring(0,4)%>"><%=DateTimeUtil.addYears(curr_date, -3).substring(0,4)%></option>                
					                <option <%=(st_year.equals(DateTimeUtil.addYears(curr_date, -4).substring(0,4)) ? "selected" : "")%> value="<%=DateTimeUtil.addYears(curr_date, -4).substring(0,4)%>"><%=DateTimeUtil.addYears(curr_date, -4).substring(0,4)%></option>                
					            </select>&nbsp;&nbsp; <b>Lead Time = 평균일수(VOC접수일 ~ Feed Back완료일), 단순문의 제외</b>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
<!--내용 종료-->	                 

</body>
</html>
