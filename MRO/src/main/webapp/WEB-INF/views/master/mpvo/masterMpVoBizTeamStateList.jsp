<%--
**********************************************
* 메뉴 : VOC Analysis>사업팀 별 현황
* 화면 : 사업팀 별 현황
* 기능 : 
* 프로그램 ID : PG_90_C_800_06
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-22
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String user_name	= CommonUtil.nvl((String) request.getParameter("st_user_name"),_sessionInfo.getUserNameLoc());
String user_dept = CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());

String st_dashboard_flag = CommonUtil.nvl((String) request.getParameter("st_dashboard_flag"), "N");
String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), "");
String st_date_flag = CommonUtil.nvl((String) request.getParameter("st_date_flag"), "");

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

var public_ds_user_id = "";
var public_date_type = "";
var public_date_flag = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"선택|선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"사업팀코드|사업팀코드",	SaveName:"DS_DEPT"}
					,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사업팀|사업팀",	SaveName:"DS_DEPT_NAME"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"AutoSum",	Header:"발생건수|접수",	SaveName:"FLAG_DC"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"AutoSum",	Header:"발생건수|진행중",	SaveName:"FLAG_PS"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"AutoSum",	Header:"발생건수|처리완료",	SaveName:"FLAG_PA"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"AutoSum",	Header:"발생건수|F/B완료",	SaveName:"FLAG_FB"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:140,	Hidden:false,	Type:"AutoSum",	Header:"발생건수|사업팀별 합계",	SaveName:"T_FLAG"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	// 합계 컬럼 타이틀 변경 및 폰트 색상 변경
	mySheet.SetSumText("DS_DEPT_NAME","발생건 수 합계");
	mySheet.SetSumFontColor("#0000FF");
	mySheet.SetSumFontBold(true);

	//콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "<%=st_ds_user_id%>");
	kepAjaxCommonQueryIdCombo('st_ds_dept_code','getDeptSelectkorea2','ALL','<%=st_ds_dept_code%>');

	//하이퍼링크 설정
	setLinkCol(mySheet, "FLAG_DC");
	setLinkCol(mySheet, "FLAG_PS");
	setLinkCol(mySheet, "FLAG_PA");
	setLinkCol(mySheet, "FLAG_FB");
	
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
		
		public_ds_user_id = $("#st_ds_user_id").val();
		public_date_type = $("#st_date_type").val();
		public_date_flag = $("input[name=st_date_flag]:checked").val();
		
		kepSearch(document.searchCondition,  mySheet , "/mpvo/getMasterMpVoBizTeamStateList.do" , pagingMode );
	
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
	
// 팝업함수호출
function doPop(str, param) {
	popupSel = str;
	
	switch (str) {
		case "masterMpVoVocBizGenerateStatePop": // 사업팀 별 상세현황
			openSearchPopup("/mpvo/getMasterMpVoVocBizGenerateStatePop.do", param, "800,500,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'FLAG_DC' || column == 'FLAG_PS' || column == 'FLAG_PA' || column == 'FLAG_FB') {
		if(mySheet.GetCellValue(Row, Col) <= 0){
			alert("발생 건수가 없습니다. 다른 항목을 선택해주세요.");
		}else{
			var st_recv_flag = "";
			var st_recv_type = "";
			switch (column) {
				case "FLAG_DC" :
					st_recv_type = "DC";
					st_recv_flag = "접수완료";
					break;
				case "FLAG_PS" :
					st_recv_type = "PS";
					st_recv_flag = "진행중";
					break;
				case "FLAG_PA" :
					st_recv_type = "PA";
					st_recv_flag = "처리완료";
					break;
				case "FLAG_FB" :
					st_recv_type = "FB";
					st_recv_flag = "FB완료";
					break;
			}
			
			var param = "";
			param += "?st_ds_dept_code=" + mySheet.GetCellValue(Row, "DS_DEPT");
			param += "&st_recv_flag=" + st_recv_flag;
			param += "&st_recv_type=" + st_recv_type;
			param += "&st_ds_dept_name=" + mySheet.GetCellValue(Row, "DS_DEPT_NAME");
			param += "&st_item_cnt=" + mySheet.GetCellValue(Row, Col);
			param += "&st_ds_user_id=" + public_ds_user_id;
			param += "&st_date_type=" + public_date_type;
			param += "&st_date_flag=" + public_date_flag;
			
			doPop("masterMpVoVocBizGenerateStatePop", param);
		}
	}
	return;
}
	
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>사업팀 별 현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
       		<!-- HIDDEN -->
			<input type="hidden" id="st_user_id" name="st_user_id"		value="<%=user_id%>">
			<input type="hidden" id="st_user_name" name="st_user_name"	value="<%=user_name%>">
			<input type="hidden" id="st_user_dept" name="st_user_dept"	value="<%=user_dept%>">
			
			<input type="hidden" id="st_date_type" name="st_date_type"	value="<%=st_date_type%>">
			<input type="hidden" id="st_dashboard_flag" name="st_dashboard_flag"	value="<%=st_dashboard_flag %>">
			<!-- HIDDEN -->
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			
            	<table  class="cont_t_list01" >
					<caption>사업팀 별 현황</caption>
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
								<input type="radio" class="Noborder" name="st_date_flag" value="-14" <%if("-14".equals(st_date_flag)){out.print("checked");}%>> 최근2주
								<input type="radio" class="Noborder" name="st_date_flag" value="-1"  <%if("-1".equals(st_date_flag)){out.print("checked");}%>> 최근1개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-3"  <%if("-3".equals(st_date_flag)){out.print("checked");}%>> 최근3개월
								<input type="radio" class="Noborder" name="st_date_flag" value="-6"  <%if("-6".equals(st_date_flag)){out.print("checked");}%>> 최근6개월  
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

<!--내용 종료-->	                 

</body>
</html>
