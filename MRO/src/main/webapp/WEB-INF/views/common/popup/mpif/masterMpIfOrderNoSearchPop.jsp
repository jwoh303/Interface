<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 입고
* 화면 : 주문번호찾기 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_004_02
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    String buyer = CommonUtil.nvl(request.getParameter("buyer"),"");
	String legacy_gr_no = CommonUtil.nvl(request.getParameter("legacy_gr_no"),"");
	String legacy_gr_seq = CommonUtil.nvl(request.getParameter("legacy_gr_seq"),"");
	String buyer_item_no = CommonUtil.nvl(request.getParameter("buyer_item_no"),"");
	String legacy_po_no = CommonUtil.nvl(request.getParameter("legacy_po_no"),"");
	String legacy_po_seq = CommonUtil.nvl(request.getParameter("legacy_po_seq"),"");
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
<script src="/resources/libs/jquery/js/jquery-ui.custom.min.js" type="text/javascript"></script>
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [
   		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
   		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Radio",				Header:"",						SaveName:"SELECTED"}
   		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"고객사",				SaveName:"BUYER_NAME"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"주문번호",			SaveName:"LEGACY_PO_NO"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"주문항번",			SaveName:"LEGACY_PO_SEQ"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"관리번호",			SaveName:"REF_PR_NO"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"입고수량",			SaveName:"GR_QTY"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"PR번호",			SaveName:"PR_NO"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"PR순번",			SaveName:"PR_SEQ"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"요청수량",			SaveName:"ITEM_QTY"}
   		
   		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"발주번호",			SaveName:"PO_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"발주항번",			SaveName:"PO_SEQ"}
   		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품번호",			SaveName:"INV_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품항번",			SaveName:"INV_SEQ"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"발주일",				SaveName:"PO_CREATE_DATE"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주수량",			SaveName:"ITEM_QTY_PO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"납품일",				SaveName:"RD_DATE"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"납품수량",			SaveName:"IV_QTY"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"기입고수량",		SaveName:"GR_QTY_PRE"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"거래유형",			SaveName:"PROCESS_TYPE_NM"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사명",			SaveName:"AGENT_NM"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	
	doAction("search");
}

var st;
var mt;

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfOrderNoSearchPop.do", pagingMode);
			break;
			
		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			$("#job_kind").val("save");
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfOrderNoSearchPo.do", "SELECTED");
			break;
	}

}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
	if ( mySheet.RowCount() <= 0 ) return;
	
	// 헤더 정보 설정
	$("#v_buyer_name").val( mySheet.GetCellValue(1, "BUYER_NAME") );
	$("#v_legacy_po_no").val( mySheet.GetCellValue(1, "LEGACY_PO_NO") );
	$("#v_legacy_po_seq").val( mySheet.GetCellValue(1, "LEGACY_PO_SEQ") );
	
	$("#v_ref_pr_no").val( mySheet.GetCellValue(1, "REF_PR_NO") );
	$("#v_buyer_item_no").val( mySheet.GetCellValue(1, "BUYER_ITEM_NO") );
	$("#v_gr_qty").val( kepCommaNum(mySheet.GetCellValue(1, "GR_QTY")) );
	
	$("#v_pr_no").val( mySheet.GetCellValue(1, "PR_NO") );
	$("#v_pr_seq").val( mySheet.GetCellValue(1, "PR_SEQ") );
	$("#v_item_qty").val( kepCommaNum(mySheet.GetCellValue(1, "ITEM_QTY")) );
	
	if ( msg != "" ) {
		alert(msg);
	}
	
	if ( mySheet.RowCount() == 1 ) {
		mySheet.SetCellValue(1, "SELECTED", "1");
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		opener.setPopupReturn('', '', '', '');
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
			kepConfirm();
	}
	return;
}


// 확인
function kepConfirm()
{ 
	var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
	var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
	opener.setPopupReturn(value1,value2);
	this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=buyer%>">
	<input type="hidden" id="st_legacy_gr_no"  name="st_legacy_gr_no" value="<%=legacy_gr_no%>">
	<input type="hidden" id="st_legacy_gr_seq"  name="st_legacy_gr_seq" value="<%=legacy_gr_seq%>">
	<input type="hidden" id="st_legacy_po_no"  name="st_legacy_po_no" value="<%=legacy_po_no%>">
	<input type="hidden" id="st_legacy_po_seq"  name="st_legacy_po_seq" value="<%=legacy_po_seq%>">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="<%=buyer_item_no%>">
	
	<div id="popWrapper" style="height:410px;">
    	<div id="popHeader">
        	<h1 class="title">주문번호찾기 팝업</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>조회</caption>
					<colgroup>
						<col width="15px" />
						<col width="25%" />
						<col width="15px" />
						<col width="25%" />
						<col width="15px" />
						<col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>고객사</th>
							<td><input type="text" name="v_buyer_name" id="v_buyer_name" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>주문번호</th>
							<td><input type="text" name="v_legacy_po_no" id="v_legacy_po_no" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>주문항번</th>
							<td><input type="text" name="v_legacy_po_seq" id="v_legacy_po_seq" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
						</tr>
						<tr>
							<th>관리번호</th>
							<td><input type="text" name="v_ref_pr_no" id="v_ref_pr_no" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>품목코드</th>
							<td><input type="text" name="v_buyer_item_no" id="v_buyer_item_no" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>입고수량</th>
							<td><input type="text" name="v_gr_qty" id="v_gr_qty" class="input_type_text" title="" style="width:91%;text-align:right;" ReadOnly/></td>
						</tr>
						<tr>
							<th>PR번호</th>
							<td><input type="text" name="v_pr_no" id="v_pr_no" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>PR순번</th>
							<td><input type="text" name="v_pr_seq" id="v_pr_seq" class="input_type_text" title="" style="width:91%;text-align:left;" ReadOnly/></td>
							<th>요청수량</th>
							<td><input type="text" name="v_item_qty" id="v_item_qty" class="input_type_text" title="" style="width:91%;text-align:right;" ReadOnly/></td>
						</tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "135px");
				</script>
			</div>
		</div>
			
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
