<%--
**********************************************
* 메뉴 : wms>차량정보
* 화면 : 배차정보 팝업
* 기능 : * 배차정보(차량정보)를 매핑하는 팝업 - 추가
* 프로그램 ID : PG_08_M_001_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),""); 
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

var comWare = KepSheetComboQueryIdData('common.masterWareHosueCodeList','','');	// IBSHEET : 물류센터
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"차량아이디",	SaveName:"CAR_ID"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"차량번호",	SaveName:"CAR_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"기사명",	SaveName:"CAR_PERSON_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"연락처",	SaveName:"CAR_PERSON_TEL"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"톤급",	SaveName:"TON"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"소속사",	SaveName:"AFFILIATED_CMPY"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:8,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"차량등록일",	SaveName:"REGISTRATION_DATE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"지역",	SaveName:"AREA"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Combo",	Header:"물류센터",	SaveName:"WAREHOUSE_CODE",ComboText:comWare.ComboText, 	ComboCode:comWare.ComboCode}
	    			];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	setLinkCol(mySheet, "CAR_ID");
	kepSearch(document.searchCondition,  mySheet , "/wmdl/getMasterWmDlIntervalsInfoRegAllList.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlIntervalsInfoRegAllList.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrIntervalsInfoPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if (column == "CAR_ID" ){ 
		grbRow = Row;
			var value1 = mySheet.GetCellValue(Row, "CAR_ID")+"@"+mySheet.GetCellValue(Row, "CAR_NO")+"@"+mySheet.GetCellValue(Row, "CAR_PERSON_NAME");
			var value2=  mySheet.GetCellValue(Row, "CAR_PERSON_TEL")+"@"+mySheet.GetCellValue(Row, "TON")+"@"+mySheet.GetCellValue(Row, "AFFILIATED_CMPY")+"@"+mySheet.GetCellValue(Row, "REGISTRATION_DATE")+"@"+mySheet.GetCellValue(Row, "WAREHOUSE_CODE");
			opener.setPopupReturn(value1,value2);
			this.close();
	
	}
	return;
}


</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">	
	<input type="hidden" name="st_warehouse_code" id="st_warehouse_code" value="<%=st_warehouse_code %>">
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">차량정보등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>검색 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="90%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>차량번호</td>
							<td> 
								<input type="text" name="st_car_no"  id="st_car_no" size=20 value="" onkeydown="kepEnter()" style="ime-mode:active" > 
                            </td>
                         </tr> 
                         <tr>
                         	<td>기사명</td>						
							<td><input type="text" name="st_car_person_name"  id="st_car_person_name" size=20 value="" onkeydown="kepEnter()" style="ime-mode:active" >   
                            </td>
                         </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
