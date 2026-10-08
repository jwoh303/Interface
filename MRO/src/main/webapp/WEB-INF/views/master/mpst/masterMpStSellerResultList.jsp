<%--
**********************************************
* 메뉴 : 통계>경영실적통계>협력사별 고객사실적
* 화면 : 협력사별 고객사실적
* 기능 : 협력사 1개사의 거래 고객사 실적을 월단위로 집계하여 보여주는 화면
* 프로그램 ID : PG_90_C_600_03
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
int nowYear             = Integer.parseInt(check_date.substring(0,4));
int startYear = 2010;
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
					 { Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",	Header:"법인그룹명",	SaveName:"GROUP_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",	Header:"부서명",	SaveName:"TEAM_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"구분",	SaveName:"GUBUN"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"계",	SaveName:"TOTAL"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"1월",	SaveName:"JAN"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"2월",	SaveName:"FEB"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"3월",	SaveName:"MAR"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"4월",	SaveName:"APR"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"5월",	SaveName:"MAY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"6월",	SaveName:"JUN"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"7월",	SaveName:"JUL"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"8월",	SaveName:"AUG"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"9월",	SaveName:"SEP"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"10월",	SaveName:"OCT"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"11월",	SaveName:"NOV"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"#,##0.0",	Header:"12월",	SaveName:"DEC"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	//var cfg = {MergeSheet:msAll};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');	
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		var agent	= $("#st_agent_code").val();
	    
    	if(agent == "") {
			alert("협력사는 필수 선택사항입니다.");
			return;
		}
		
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStSellerResultList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		$("#st_corp_code").val("");		
		$("#st_agent_code").val("");		
		break;
	case "excelDown": // 엑셀다운로드
		var param = {FileName:"협력사별 고객사실적.xlsx"};
	    kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStSellerResultList.do", param);
		break;			
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
// 		mySheet.SetDataAlternateBackColor("#FFFFFF");
		if(mySheet.GetCellValue(i, 'TEAM_NM') == "소계" ||mySheet.GetCellValue(i, 'TEAM_NM') == "합계" ){  
			mySheet.SetCellFont("FontColor", i,1,i,mySheet.LastCol(),"#ed5e00") ;
		}
		
		if(mySheet.GetCellValue(i, 'GUBUN').indexOf("매익률")>-1){
			mySheet.SetCellValue(i, 'GUBUN', mySheet.GetCellValue(i, 'GUBUN') + "(%)" );
		}
		
		
	}
	if (msg != "") {
		alert(msg);
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStSellerResultList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
		case "kepCorpCcode": //고객사 법인그룹선택
			openSearchPopup("/mdct/showMasterMdctBuyerCorpGroupPop.do", "", "500,500,no");
			popupSel = "kepCorpCcode";
			break;
			
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "kepCorpCcode") {
		$("#st_corp_code").val(code);
		$("#st_corp_name").val(text);
	}else if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(code);
		$("#st_agent_name").val(text);
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사별 고객사실적</h3>
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
					<caption>협력사별 고객사실적</caption>
					<colgroup>
						<col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="10%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />					    					    
					    <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:55%" onclick="doPop('agent_single');" readonly>
								<input type="hidden" name="st_agent_code" id="st_agent_code">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>년도</th>
							<td>
								<select id="st_year" name="st_year" style="width:60px;">
								<% 
								  	for (int i=startYear ; i<=nowYear; i++) {
								  		out.println("<option value='"+i+"'" + ((i == nowYear) ? " selected>" : ">")+i);
								  	} 
								 %>
								</select>							
							</td>
							<th>부서</th>
							<td>
								<select id="st_user_dept" name="st_user_dept" style="width:150px;">
								</select>
							</td>
							<th>법인그룹</th>
							<td>
								<input type="hidden" id="st_corp_code" name="st_corp_code"  />
	                        	<input type="text" id="st_corp_name" name="st_corp_name" class="input_type_text" title="" style="width:50%;"  readonly />
	                        	<a href="javascript:doPop('kepCorpCcode');"><img src="/resources/images/btn_search03.gif"></a>
	                        	<a href="javascript:kepEraser('st_corp_code','st_corp_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "570px");
  				</script>
  			</div>
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
<!--   					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span> -->
  				</span>
  				</div>

<!--내용 종료-->	                 

</body>
</html>
