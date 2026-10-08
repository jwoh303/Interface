<%--
**********************************************
* 메뉴 : 통계>KPI통계>고객사별 역마진/노마진 매출현황
* 화면 : 고객사별 역마진/노마진 매출현황
* 기능 : 역마진을 조회 조건대로 집계하여 보여주는 화면
* 프로그램 ID : PG_90_C_600_06
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-13
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
							 { Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사업팀|총합계",	SaveName:"KEP_DEPT_NM"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"고객사코드|고객사코드",	SaveName:"BUYER"} 
							,{ Align:"Center",	Width:220,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사|고객사",	SaveName:"BUYER_NM"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"누계|역마진",	SaveName:"NE_ITEM_AMT"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"누계|노마진매출",	SaveName:"NO_AMT"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"1월|역마진",	SaveName:"NE_ITEM_AMT01"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"1월|노마진매출",	SaveName:"NO_AMT01"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"2월|역마진",	SaveName:"NE_ITEM_AMT02"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"2월|노마진매출",	SaveName:"NO_AMT02"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"3월|역마진",	SaveName:"NE_ITEM_AMT03"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"3월|노마진매출",	SaveName:"NO_AMT03"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"4월|역마진",	SaveName:"NE_ITEM_AMT04"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"4월|노마진매출",	SaveName:"NO_AMT04"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"5월|역마진",	SaveName:"NE_ITEM_AMT05"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"5월|노마진매출",	SaveName:"NO_AMT05"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"6월|역마진",	SaveName:"NE_ITEM_AMT06"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"6월|노마진매출",	SaveName:"NO_AMT06"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"7월|역마진",	SaveName:"NE_ITEM_AMT07"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"7월|노마진매출",	SaveName:"NO_AMT07"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"8월|역마진",	SaveName:"NE_ITEM_AMT08"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"8월|노마진매출",	SaveName:"NO_AMT08"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"9월|역마진",	SaveName:"NE_ITEM_AMT09"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"9월|노마진매출",	SaveName:"NO_AMT09"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"10월|역마진",	SaveName:"NE_ITEM_AMT10"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"10월|노마진매출",	SaveName:"NO_AMT10"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"11월|역마진",	SaveName:"NE_ITEM_AMT11"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"11월|노마진매출",	SaveName:"NO_AMT11"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"12월|역마진",	SaveName:"NE_ITEM_AMT12"}
							,{ Align:"Right",	Width:60,	Edit:false,	EditLen:17,	Type:"AutoSum",	ColMerge:0, Header:"12월|노마진매출",	SaveName:"NO_AMT12"}

	];
	
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:3};
	
	var info = [ {StdCol:"KEP_DEPT_NM", SumCols:"NE_ITEM_AMT|NO_AMT|NE_ITEM_AMT01|NO_AMT01|NE_ITEM_AMT02|NO_AMT02|NE_ITEM_AMT03|NO_AMT03|NE_ITEM_AMT04|NO_AMT04|NE_ITEM_AMT05|NO_AMT05|NE_ITEM_AMT06|NO_AMT06|NE_ITEM_AMT07|NO_AMT07|NE_ITEM_AMT08|NO_AMT08|NE_ITEM_AMT09|NO_AMT09|NE_ITEM_AMT10|NO_AMT10|NE_ITEM_AMT11|NO_AMT11|NE_ITEM_AMT12|NO_AMT12",
		 CaptionCol:"KEP_DEPT_NM", ShowCumulate:0, CaptionText:"- 소 계 -"} ];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');	
	mySheet.ShowSubSum(info);
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	kepAjaxCommonQueryIdCombo('st_buyer_group','commonPopup.getMasterMdStBuyerGroup','ALL', '');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStBuyerMarginStatsList.do" , pagingMode );
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
		kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStBuyerMarginStatsList.do", param);
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
// 	mySheet.SetCellFont("FontColor", 2,0,2,mySheet.LastCol(),"#ed5e00") ;
// 	mySheet.SetCellFont("FontBold", 1,0,1,mySheet.LastCol(),1) ;
	mySheet.SetSumValue(0,"- 합 계 -");
// 	mySheet.SetCellAlign(mySheet.LastRow(),0,"Center");
	
	 
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStBuyerMarginStatsList.do?page="+current_page , pagingMode );
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
		case "kepCorpCcode": //고객사 법인그룹선택
			openSearchPopup("/mdct/showMasterMdctBuyerCorpGroupPop.do", '?st_group_code='+$("#st_buyer_group").val(), "500,500,no");
			popupSel = "kepCorpCcode";
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "kepCorpCcode") {
		$("#st_corp_code").val(code);
		$("#st_corp_name").val(text);
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>역마진/노마진 (고객사별)</h3>
			(단위 : 십만원)
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
					<caption>역마진/노마진 (고객사별)</caption>
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
							<th></th>
							<td>
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
