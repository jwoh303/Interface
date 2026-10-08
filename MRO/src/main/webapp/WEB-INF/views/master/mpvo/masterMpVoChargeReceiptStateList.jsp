<%--
**********************************************
* 메뉴 : VOC Analysis>담당자 별 접수현황
* 화면 : 담당자 별 접수현황
* 기능 : 
* 프로그램 ID : PG_90_C_800_09
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_dept = CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());

String st_dashboard_flag = CommonUtil.nvl((String) request.getParameter("st_dashboard_flag"), "N");
String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), "");
String st_date_flag = CommonUtil.nvl((String) request.getParameter("st_date_flag"), "");

String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");
String st_ds_user_id = CommonUtil.nvl((String) request.getParameter("st_ds_user_id"),"");
String st_ds_dept_code = CommonUtil.nvl((String) request.getParameter("st_ds_dept_code"),"");

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
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사업팀",	SaveName:"DS_DEPT_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"DS_USER_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"AutoSum",	Header:"전체건수",	SaveName:"TOT_CNT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"AutoSum",	Header:"Claim",	SaveName:"CLAIM_CNT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"AutoSum",	Header:"단순문의",	SaveName:"SIMPLE_CNT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"AutoSum",	Header:"해결완료건수",	SaveName:"CLT_CNT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"AutoSum",	Header:"미결건수",	SaveName:"NOT_CNT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",	Header:"사업팀코드",	SaveName:"DS_DEPT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:true,	Type:"Text",	Header:"담당자ID",	SaveName:"DS_USER_ID"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	// 합계 컬럼 타이틀 변경 및 폰트 색상 변경
	mySheet.SetSumValue(3,"발생건 수 합계");
	mySheet.SetSumFontColor("#0000FF");
	mySheet.SetSumFontBold(true);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "<%=st_ds_user_id%>");
	kepAjaxCommonQueryIdCombo('st_ds_dept_code','getDeptSelectkorea2','ALL','<%=st_ds_dept_code%>');

<% if( "Y".equals(st_dashboard_flag)){%>
	$("input:radio[name=st_date_flag], #st_ds_dept_code, #st_ds_user_id").change(function(){
		$("#st_dashboard_flag").val("");
	});
	doAction("search");
<% } %>
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
	    var date_type = $("input:hidden[name=st_date_type]").val();
	    
		if(date_flag == '-7' || date_flag == '-14'){
		    date_type = "WEEK";
		}else{
		    date_type = "MONTH";
		}    
		$("#st_date_type").val(date_type);
		
		public_ds_user_id = $("#st_ds_user_id").val();
		public_date_type = $("#st_date_type").val();
		public_date_flag = $("input[name=st_date_flag]:checked").val();
		
		kepSearch(document.searchCondition,  mySheet , "/mpvo/getMasterMpVoChargeReceiptStateList.do" , pagingMode );
	
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
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		openSearchPopup("/common/userDisplayPop.do", "?user_id="+ID, "800,500,no");
		
	}
	return;
}
	
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>담당자 별 접수현황</h3>
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
			<input type="hidden" id="st_date_type" name="st_date_type"  value="<%=st_date_type %>">
			<input type="hidden" id="st_dashboard_flag" name="st_dashboard_flag"  value="<%=st_dashboard_flag %>">
			
            	<table  class="cont_t_list01" >
					<caption>담당자 별 접수현황</caption>
					<colgroup>
						<col width="8%" />
						<col width="*" />
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
                        <col width="22%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>발생기간</td>
							<td>
								<input type="radio" class="Noborder" name="st_date_flag" value="-14" <%if("-14".equals(st_date_flag) && !"Y".equals(st_dashboard_flag)){out.print("checked");}%>> 최근2주
								<input type="radio" class="Noborder" name="st_date_flag" value="-1"  <%if("-1".equals(st_date_flag) && !"Y".equals(st_dashboard_flag)){out.print("checked");}%>> 최근1개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-3"  <%if("-3".equals(st_date_flag) && !"Y".equals(st_dashboard_flag)){out.print("checked");}%>> 최근3개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-6"  <%if("-6".equals(st_date_flag) && !"Y".equals(st_dashboard_flag)){out.print("checked");}%>> 최근6개월  
								<input type="radio" class="Noborder" name="st_date_flag" value="-7" <%if("-7".equals(st_date_flag)){out.print("checked");}%> style="display: none;">
							</td>
							<td>사업팀</td>
							<td>
								<select id="st_ds_dept_code" name="st_ds_dept_code" style="width:80%;height:20px"></select>
							</td>
							<td>담당자</td>
							<td>
								<select id="st_ds_user_id" name="st_ds_user_id" style="width:80%;height:20px"></select>
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
  			
</body>
</html>
