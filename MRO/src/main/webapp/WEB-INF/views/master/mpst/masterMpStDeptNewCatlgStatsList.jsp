<%--
**********************************************
* 메뉴 : 통계>기타통계>신규카탈로그표준화통계(부서)
* 화면 : 카탈로그표준화통계(부서)
* 기능 : 카탈로그표준화통계(부서)
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
					 { Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:1, 	Type:"Text",	Header:"부서|부서",	SaveName:"DEPT_NM"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:1,	Type:"Text",	Header:"담당자|담당자",	SaveName:"KEP_USER_NM"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,ColMerge:0,	Type:"Float",	Header:"합계|대상건",	SaveName:"TARGET"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Float",	Header:"합계|매핑완료",	SaveName:"RESULT"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"합계|매핑율(%)",	SaveName:"RESULT_RATE"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"1월|대상건",	SaveName:"TARGET_01"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"1월|매핑완료",	SaveName:"RESULT_01"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"1월|매핑율(%)",	SaveName:"RESULT_RATE_01"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"2월|대상건",	SaveName:"TARGET_02"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"2월|매핑완료",	SaveName:"RESULT_02"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"2월|매핑율(%)",	SaveName:"RESULT_RATE_02"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"3월|대상건",	SaveName:"TARGET_03"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"3월|매핑완료",	SaveName:"RESULT_03"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"3월|매핑율(%)",	SaveName:"RESULT_RATE_03"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"4월|대상건",	SaveName:"TARGET_04"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"4월|매핑완료",	SaveName:"RESULT_04"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"4월|매핑율(%)",	SaveName:"RESULT_RATE_04"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"5월|대상건",	SaveName:"TARGET_05"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"5월|매핑완료",	SaveName:"RESULT_05"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"5월|매핑율(%)",	SaveName:"RESULT_RATE_05"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"6월|대상건",	SaveName:"TARGET_06"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"6월|매핑완료",	SaveName:"RESULT_06"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"6월|매핑율(%)",	SaveName:"RESULT_RATE_06"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"7월|대상건",	SaveName:"TARGET_07"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"7월|매핑완료",	SaveName:"RESULT_07"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"7월|매핑율(%)",	SaveName:"RESULT_RATE_07"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"8월|대상건",	SaveName:"TARGET_08"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"8월|매핑완료",	SaveName:"RESULT_08"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"8월|매핑율(%)",	SaveName:"RESULT_RATE_08"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"9월|대상건",	SaveName:"TARGET_09"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"9월|매핑완료",	SaveName:"RESULT_09"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"9월|매핑율(%)",	SaveName:"RESULT_RATE_09"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"10월|대상건",	SaveName:"TARGET_10"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"10월|매핑완료",	SaveName:"RESULT_10"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"10월|매핑율(%)",	SaveName:"RESULT_RATE_10"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"11월|대상건",	SaveName:"TARGET_11"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"11월|매핑완료",	SaveName:"RESULT_11"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"11월|매핑율(%)",	SaveName:"RESULT_RATE_11"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"12월|대상건",	SaveName:"TARGET_12"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Header:"12월|매핑완료",	SaveName:"RESULT_12"}
					,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"Text",	ColMerge:0, Header:"12월|매핑율(%)",	SaveName:"RESULT_RATE_12"}
	];
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStDeptNewCatlgStatsList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		$("#st_corp_code").val("");		
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
	    current_page = -1;
		var param = {FileName:"역마진통계.xlsx",DownCols:"GROUP_NM|TEAM_NM|GUBUN|TOT|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStDeptNewCatlgStatsList.do", param);
		$("#pageflag").val('1');
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
   	
	if (msg != "") {
		alert(msg);
	} 
	 
	

	var maxRow = mySheet.RowCount();     
    for(var i = 0; i<=maxRow; i++){
		var TEAM_NM =mySheet.GetCellValue(i,"TEAM_NM");
		if(TEAM_NM == "소계"){  
			mySheet.SetCellFont("FontColor", i,1,i,mySheet.LastCol(),"#ed5e00") ;
		} 
	}  
	mySheet.SetSumValue(0,"- 합 계 -");
	
	 
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStDeptNewCatlgStatsList.do?page="+current_page , pagingMode );
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>신규카탈로그표준화통계(부서)</h3>
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
					<caption>신규카탈로그표준화통계(부서)</caption>
					<colgroup>
						<col width="5%" />
					    <col width="10%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />
					    <col width="5%" />
					    <col width="15%" />					    					    
					    <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
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
							<th>작업구분</th>
							<td>
								  <select name="st_job_type" id="st_job_type" style="width:80%">           
						         	 <%= CommonUtil.getCode3ComboList("", "NO", "M158","", "ICOMCOD1", "", "") %>
						         </select>
							</td>
							<th></th>
							<td>
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
  					createIBSheet("mySheet", "100%", "450px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
<!--   					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span> -->
  				</span>
  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
