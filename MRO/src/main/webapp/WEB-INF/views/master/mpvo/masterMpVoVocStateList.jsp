<%--
**********************************************
* 메뉴 : VOC Analysis>VOC 현황
* 화면 : VOC 현황
* 기능 : 
* 프로그램 ID : PG_90_C_800_04
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-18
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
String st_claim_flag = CommonUtil.nvl((String) request.getParameter("st_claim_flag"), "");
String st_claim_text= CommonUtil.nvl((String) request.getParameter("st_claim_text"), "");
String st_dashboard_flag = CommonUtil.nvl((String) request.getParameter("st_dashboard_flag"), "N");
String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), "");
String st_date_flag = CommonUtil.nvl((String) request.getParameter("st_date_flag"), "");

if(st_date_type.equals(""))
{
	st_date_type = "WEEK";
}

if(st_date_flag.equals(""))
{
	st_date_flag = "-14";
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
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"VOC 유형코드",	SaveName:"CLAIM_TYPE"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"VOC 유형",	SaveName:"CLAIM_TEXT"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"1일(당일포함)",	SaveName:"DATE_1"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"2일",	SaveName:"DATE_2"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"3일",	SaveName:"DATE_3"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"4일",	SaveName:"DATE_4"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"5일",	SaveName:"DATE_5"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"6일",	SaveName:"DATE_6"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"7일이상",	SaveName:"DATE_7"}
					,{ Align:"Center",	Width:95,	Edit:false,	EditLen:95,	Hidden:false,	Type:"AutoSum",	Header:"건수합계",	SaveName:"T_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	// 합계 컬럼 타이틀 변경 및 폰트 색상 변경
	mySheet.SetSumText("CLAIM_TEXT","유형별 합계");
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
	
		var date_flag = $("input:radio[name=st_date_flag]:checked").val();
	    var date_type = "";
	    
		if(date_flag == '-14'){
		    date_type = "WEEK";
		}else{
		    date_type = "MONTH";
		}    
		
		$("#st_date_type").val(date_type);
		
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpvo/getMasterMpVoVocStateList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_claim_flag").attr("checked",true);
		
		
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpvo/getMasterMpVoVocStateList.do?page="+current_page , pagingMode );
}

	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	return;
}
	
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>VOC 현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post">
       		<input type="hidden" id="st_date_type" name="st_date_type"  value="<%=st_date_type%>" />
       		
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>VOC 현황</caption>
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>발생기간</td>
							<td>
								<input type="radio" class="Noborder" name="st_date_flag" value="-14" <%if("-14".equals(st_date_flag)){out.print("checked");}%>> 최근2주
								<input type="radio" class="Noborder" name="st_date_flag" value="-1"  <%if("-1".equals(st_date_flag)){out.print("checked");}%>> 최근1개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-3"  <%if("-3".equals(st_date_flag)){out.print("checked");}%>> 최근3개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-6"  <%if("-6".equals(st_date_flag)){out.print("checked");}%>> 최근6개월
							</td>
							<td>클레임 등급</td>
							<td>
								<input type="radio" class="Noborder" name="st_claim_flag"  id="st_claim_flag" value="" <%if("".equals(st_claim_flag)){out.print("checked");}%>> 전체
								<input type="radio" class="Noborder" name="st_claim_flag" value="상" <%if("상".equals(st_claim_flag)){out.print("checked");}%>> 상
								<input type="radio" class="Noborder" name="st_claim_flag" value="중" <%if("중".equals(st_claim_flag)){out.print("checked");}%>> 중
								<input type="radio" class="Noborder" name="st_claim_flag" value="하" <%if("하".equals(st_claim_flag)){out.print("checked");}%>> 하 
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
