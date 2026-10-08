<%--
**********************************************
* 메뉴 : 통계>KPI통계>역마진 통계
* 화면 : 역마진 통계
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
					 { Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:1, Type:"Text",	Header:"법인그룹명",	SaveName:"GROUP_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"부서명",	SaveName:"TEAM_NM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	ColMerge:0, Type:"Text",	Header:"구분",	SaveName:"GUBUN"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"계",	SaveName:"TOT"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"1월",	SaveName:"JAN"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"2월",	SaveName:"FEB"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"3월",	SaveName:"MAR"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"4월",	SaveName:"APR"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"5월",	SaveName:"MAY"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"6월",	SaveName:"JUN"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"7월",	SaveName:"JUL"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"8월",	SaveName:"AUG"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"9월",	SaveName:"SEP"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"10월",	SaveName:"OCT"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"11월",	SaveName:"NOV"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:17,	Type:"Float",	ColMerge:0, Format:"${priceFormat}",	Header:"12월",	SaveName:"DEC"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);	
	
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	kepAjaxCommonQueryIdCombo('st_buyer_group','commonPopup.getMasterMdStBuyerGroup','ALL', '');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStReverseMarginStatsList.do" , pagingMode );
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
		kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStReverseMarginStatsList.do", param);
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
	mySheet.SetCellFont("FontColor", 1,0,1,mySheet.LastCol(),"#ed5e00") ;
	mySheet.SetCellFont("FontBold", 1,0,1,mySheet.LastCol(),1) ;

	
	 
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpst/getMasterMpStReverseMarginStatsList.do?page="+current_page , pagingMode );
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
			<h3>역마진 통계</h3>
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
					<caption>역마진 통계</caption>
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
							<th>그룹</th>
							<td>
								<select id="st_buyer_group" name="st_buyer_group" style="width:150px;">
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
  					createIBSheet("mySheet", "100%", "450px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
