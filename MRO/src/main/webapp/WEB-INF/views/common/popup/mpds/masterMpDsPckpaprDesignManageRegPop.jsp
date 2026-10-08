<%--
**********************************************
* 메뉴 : 
* 화면 : 포장지 도안 관리 등록 (작물보호)
* 기능 : 신규 포장지 도안을 등록하기 위한 팝업
* 프로그램 ID : PG_07_M_003_02
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
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
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "ITEM_NO_TEXT",		Header : "바코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true, Hidden : false},
	    			{Align : "Center",SaveName : "IMAGE_KEY",		Header : "첨부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:true},
	    			{Align : "Center",SaveName : "IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "BUYER",		Header : "고객사코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "계약번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "계약순번",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "AGENT",		Header : "협력사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true, Hidden : true},
	    			{Align : "Center",SaveName : "BELOW_COMORG_CODE",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "ITEM_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	// 조회조건 초기화
	kepSetCalender("st_rd_date");
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "IMAGE_KEY_IMG");
	
	//첨부이미지설정
	mySheet.SetImageList(1, diskOn);
	mySheet.SetImageList(0, diskOff);

}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	switch (str) {
		case "search": //조회
			current_page = -1;
		    var buyer_item_no  = document.searchCondition.st_buyer_item_no.value;
		    var desc_spec      = document.searchCondition.st_desc_spec.value;
		    var maker_name     = document.searchCondition.st_maker_name.value;

		    if(buyer_item_no == "" && desc_spec =="" && maker_name ==""){
		        alert("조회 조건을 하나 이상 입력해 주십시요.\n\n품목코드, 품명 또는 규격, 제조사 중 한개");
		        return;
		    }
		    
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsPckpaprDesignManageRegPop.do" , pagingMode );
			break;
		case "reg": //등록
			if (selectedGrid.length == 0) {
				alert("선택한 상품이 없습니다. \n\n 먼저 등록 할 상품을 선택하시기 바랍니다.");
				return;
			}else {
				if($("#st_rd_date").val() ==""){
			        alert("시작일을 선택해 주십시요.");
			        return;
			    }
				if($("#st_safety_open").val() ==""){
			        alert("안전마개여부를 선택해 주십시요.");
			        return;
			    }
				
				
				if (!confirm('선택한 상품을 등록 하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mpds/regMasterMpDsPckpaprDesignManageRegPop.do" , "SELECTED" );
				
			}
			break;
		case "reload":
			kepReload('searchCondition');
			$("#st_rd_date").val('');
			$("input:radio[id='st_safety_open']").attr("checked",false);
			mySheet.RemoveAll();
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
	
	if (msg != "") {
		alert(msg);
	}

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
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsPckpaprDesignManageRegPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	
	if(column == "SELECTED"){ // 선택
		var buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		for(i=0; i<arrRow.length; i++){
			var buyer_item_no_chk = mySheet.GetCellValue(arrRow[i], "BUYER_ITEM_NO");
			if(arrRow[i] != Row && buyer_item_no_chk==buyer_item_no){
				mySheet.SetCellValue(arrRow[i], "SELECTED", false);
			}
		}
		
	} else if(column == "IMAGE_KEY_IMG"){ // 파일첨부
		popupSel = "fileUpload";
		var type="DONGBU";
		var viewType="IV"; // 보기전용
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
// 		if (image_key != "") {
			openSearchPopup('/common/fileUploadPop.do','?DATE_DIR=Y&DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
// 		}
   }
	
	return;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if(code>0){
		//저장 성공시 재조회
		doAction('reload');
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	if(popupSel == "fileUpload") {	//파일 첨부
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
 		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2 =="on")? diskOn : diskOff);
	}
}

//확인
function kepConfirm()
{ 
//  var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
//  var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 	var value1="";
 	var value2="";
 	opener.setPopupReturn(value1,value2);
 	this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" name="st_buyer_code"       value="">
    
	<div id="popWrapper" style="height:524px;">
    	<div id="popHeader">
        	<h1 class="title">포장지 도안 관리 등록 (작물보호)</h1>
            <p class="popClose"><a href="javascript:kepConfirm()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
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
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						
						<tbody>
					        <tr>
					          <th>구분</th>
					          <td>
<%-- 					              <option <%=(byca_comorg_code.equals("KRDONGG004") ? "selected" : "")%> value="KRDONGG004">작물보호</option> --%>
					            <select id="st_byca_comorg_code" name="st_byca_comorg_code" style="width:80%;height:20px">
					            	<option value="KRDONGG004" selected>작물보호</option>
					            </select>
					          </td>
					          <th>구분</th>
					          <td>
					            <select name="st_gubun_flag" style="width:30%;">
					              <option value="NW">신규</option>
					              <option value="OD">기존</option>
					            </select>
								&nbsp;//&nbsp;
								<select name="st_use_flag" style="width:30%;">
					              <option value="N">일반</option>
					              <option value="S">긴급</option>
					            </select>
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">품목코드</th>
					          <td >
					            <input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:95%" value="" OnKeyDown="kepEnter()" onKeyUp="kepToUpper('st_buyer_item_no')">
					          </td>
					          <th >안전마개</th>
					          <td >
					            <input class="Noborder" type="radio" name="st_safety_open" id="st_safety_open" value='Y'>적용
								<input class="Noborder" type="radio" name="st_safety_open" id="st_safety_open"  value='N'>미적용
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">품목명/규격</th>
					          <td >
										<input type="text" name="st_desc_spec" style="ime-mode:active;width:95%" value="" OnKeyDown="kepEnter()">
					          </td>
					          <th >시작일</th>
					          <td >
								<input type="text" name="st_rd_date" id="st_rd_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_rd_date')"></a>
<!-- 					            <input type="hidden" name="st_rd_date" value=""> -->
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">제조사</th>
					          <td >
										<input type="text" name="st_maker_name" style="width:95%" value="" OnKeyDown="kepEnter()">
					          </td>
					          <th >요청공장</th>
					          <td >
					            <select name="st_buyer">
					              <option value="KRDONG0110">동부한농(주)인천공장</option>
					              <option value="KRDONG0107">동부한농(주)구미공장</option>
					              <option value="KRDONG0128">동부정밀(주)전주공장</option>
					            </select>
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
	        <!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('reg');">등록</a></span>
				</span>
	       </div>
		</div>	
        
    </div>
</form> 
</body>
</html>
