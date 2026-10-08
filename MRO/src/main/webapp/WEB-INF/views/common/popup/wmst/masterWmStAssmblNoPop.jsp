<%--
**********************************************
* 메뉴 : 
* 화면 : 조립지시서
* 기능 : 조립지시서 조회 화면에서 조립서번호 클릭 시 호출되는 조립지시서 POPUP
* 프로그램 ID : PG_08_M_016_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-4
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
rowData = _dataList.get(0);
}
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
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	    			{Align : "Left",SaveName : "BOM_ID",		Header : "재고코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "BOM_QTY",		Header : "조립수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SUB_ID",		Header : "부품코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "SUB_QTY",		Header : "조립부품수량",	Type : "Float", Format:"${qtyFormat}",		Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblNoPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
	
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblNoPop.do" , pagingMode );
			break;
			
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
			
		case "cancle":
			if('<%=rowData.get("ASSEMB_FLAG")%>' =='Y'){
				alert("조립 완료건은 조립취소 하실 수 없습니다.");
				return;
			}
			if(!confirm("조립지시를 취소 하시겠습니까?")){
				return;
			}
			$('#st_confirm').val('N');
			kepSave(document.searchCondition ,  mySheet , "/wmst/cancleMasterWmStAssmblNoPop.do" , "BOM_ID"  );
			break;
		case "conplete":
			if('<%=rowData.get("ASSEMB_FLAG")%>' =='Y'){
				alert("조립 완료건입니다.");
				return;
			}
			if(!confirm("조립완료 하시겠습니까?")){
				return;
			}
			
			kepSave(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStAssmblNoPop.do" , "BOM_ID"  );

			break;
		case "print":
	    	  var st_as_no = $('#st_as_no').val();
	    	  var st_user_id = $('#st_user_id').val();
	    	  url ="/coco/showReportViewer.do";
	    	  window.open( url +""+"?fileName=RD_08_M_005_03&param=["+st_as_no+"]["+st_user_id+"]", "wms_assemb_picking_list", "width=770,height=800,resizable=YES,top=0,left=0");

	    	  window.open( url +""+"?fileName=RD_08_M_006_67&param=["+st_as_no+"]["+st_user_id+"]", "wms_assemb_order", "width=770,height=800,resizable=YES,top=0,left=200");
	    	
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


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(code == 1){
		
		alert("조립지시 취소 완료되었습니다.");
		//저장 성공시 재조회
		opener.doAction('search');
		window.close();
		
	}
	else if(code == 2)
	{
		alert("일부 또는 전체 조립품의 가용재고가 부족하여\n\n조립지시 취소가 불가능 합니다.");	
		
	}
	else if(code == 3){
		alert("조립 작업 완료되었습니다.");
		//저장 성공시 재조회
		opener.doAction('search');
		window.close();
	}
	else if(code == 4){
		alert("조립 작업중 오류가 발생했습니다");	
	}
	else {
		alert("조립지시 취소 작업중 오류가 발생했습니다");	
		alert(msg);
	}
}


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 

	}
	return;
}



</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	 <input type="hidden" name="st_confirm"  id="st_confirm" value="">
	<input type="hidden" id="st_as_no"  name="st_as_no" value="<%=request.getParameter("st_as_no")%>">
	<input type="hidden" name="st_work_type" value="<%=rowData.get("WORK_TYPE")%>">
  	<input type="hidden" name="st_complete_flag" value="<%=rowData.get("ASSEMB_FLAG")%>">
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">조립지시서</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:378px" >
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
                        <col width="15%" />
                        <col width="18%" />
                        <col width="15%" />
                        <col width="15%" />
                        <col width="15%" />
                        <col width="15%" />
						</colgroup>
						
						<tbody>
          <tr>
            <th >조립서번호</th>
            <td ><b><%=rowData.get("AS_NO")%></b></td>
            <th  >조립지시일자</th>
            <td ><%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%></td>
            <th >조립지시자</th>
            <td ><%=rowData.get("ADD_USER")%></td>
          </tr>
          <tr>
			<th >작업구분</th>
            <td ><%=rowData.get("WORK_TYPE_TEXT")%></td>
            <th>조립일자</th>
            <td ><%=CommonUtil.formatStrinigDate(rowData.get("ASSEMB_DATE"))%></td>
            <th  >조립자</th>
            <td ><%=CommonUtil.nvl(rowData.get("ASSEMB_USER"))%></td>
          </tr>
					</tbody>
				</table>

            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
		
		<br/>	
		<!--버튼영역-->

			<span class="fr">
			<%if( "N".equals(  rowData.get("ASSEMB_FLAG")) ){%>
				<span class="btn_05 mr04"><a href="javascript:doAction('conplete')">조립 완료</a></span>
			<%} %>	
				<span class="btn_05 mr04"><a href="javascript:doAction('cancle')">조립 취소</a></span>
				<span class="btn_09 mr04"><a href="javascript:doAction('print')">조립 지시서 출력</a></span>
			</span>

		</div>	

        
    </div>
</form> 
</body>
</html>
