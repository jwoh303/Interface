<%--
**********************************************
* 메뉴 : 통계>경영실적통계>S/G 실적
* 화면 : S/G 실적
* 기능 : SG별 실적을 조회 조건대로 집계하여 보여주는 화면
* 프로그램 ID : PG_90_C_600_05
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
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Type:"Seq",	Header:"순번",	SaveName:"RN"}
					,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	ColMerge:0, Type:"Text",	Header:"SG명",	SaveName:"SG_NM"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Float",	Format:"${priceFormat}",	Header:"매출",	SaveName:"SALES_AMT"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Float",	Format:"${priceFormat}",	Header:"매출이익",	SaveName:"SALES_PROFIT"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Text",		Header:"매익율",	SaveName:"SALES_PROFIT_RATE"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Text",		Header:"매출비중",	SaveName:"SALES_PORTION"}
					,{ Align:"Right",	Width:150,	Edit:false,	EditLen:17,	ColMerge:0, Type:"Text",		Header:"매익비중",	SaveName:"SALES_PROFIT_PORTION"}
					,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Type:"Text",	Header:"",	SaveName:"SG_ID",Hidden:true}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	//var cfg = {MergeSheet:msAll};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');	
	
	//하이퍼링크 설정
	//setLinkCol(mySheet, "SG_NM"); 협의필요 2014.12.5
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mdcd.selectMasterMdCdBuyerCardManageDeptList99','ALL', '');
	kepAjaxCommonQueryIdCombo('st_buyer_group','commonPopup.getMasterMdStBuyerGroup','ALL', '');
}
	
	
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpst/getMasterMpStSgResultList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_year").val("<%=nowYear%>");
		$("#st_corp_code").val("");		
		break;
	case "excelDown": // 엑셀다운로드
		var param = {FileName:"S/G 실적.xlsx"};
	    kepDownExcel(document.searchCondition ,mySheet , "/mpst/excelMasterMpStSgResultList.do", param);
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

	
}


function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
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

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'SG_NM') { // SG명 선택D");
	
	//협의필요 2014.12.5
	return;
		var st_sg_cd = mySheet.GetCellValue(Row,"SG_ID");
		
		openSearchPopup("/mpst/showMasterMpStCategoryRecordPop.do", '?st_sg_cd='+st_sg_cd, "800,600,no");
	
	}
	return;
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>S/G 실적</h3>
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
					<caption>S/G 실적</caption>
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
  					createIBSheet("mySheet", "100%", "550px");
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
