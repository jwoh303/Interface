<%--
**********************************************
* 메뉴 : 
* 화면 : 공통코드조회팝업
* 기능 : 반품 선택을 위한 발주번호 팝업
* 프로그램 ID :
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
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
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 


<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "CODE",		Header : "코드",	Type : "Text",	Width : 120,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "TEXT1",		Header : "텍스트",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "CODE");
	setLinkCol(mySheet, "TEXT1");
   kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvIcomCodPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvIcomCodPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
		case "save": // 수정
			var st_code = "";
			var st_text = "";
	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		st_code = mySheet.GetCellValue(arrRow[i],"CODE");
	 	 		st_text = mySheet.GetCellValue(arrRow[i],"TEXT1");

	 	 	}
	 	 	opener.setPopupReturn(st_code,st_text);
	 	 	this.close();
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
}


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	if (column == "CODE"||column == "TEXT1" ){ 
		var st_value1 = mySheet.GetCellValue(Row,'CODE');
		var st_value2 = mySheet.GetCellValue(Row,'TEXT1');
		opener.setPopupReturn(st_value1,st_value2);
		 this.close();
	}
	return;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

</script> 

</head>
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" name="st_com_code" id="st_com_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_com_code"),"") %>">
	<input type="hidden" name="st_type" id="st_type" value="<%=CommonUtil.nvl((String) request.getParameter("st_type"),"") %>">

	<div id="popWrapper" style="height:485px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonUtil.nvl((String) request.getParameter("st_title"),"") %></h1>
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
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>코드</th>
							<td>
								<input type="text" name="st_code"  id="st_code" class="input_type_text" title="" style="width:80%;"  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"/>
							</td>
							<th>텍스트</th>
							<td>
								<input type="text" name="st_text"  id="st_text" class="input_type_text" title="" style="width:80%;"  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"/>
							</td>
						</tr>							
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:255px">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "255px");
				</script>
			</div>
		</div>	
  		<div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save');">등록</a></span>
			</span>
		</div>
    </div>
            <br/><br/><br/>
</form> 
</body>
</html>
