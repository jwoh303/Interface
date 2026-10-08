<%--
**********************************************
* 메뉴 : 
* 화면 : 입고번호(거래명세서상세)
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
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
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>  

</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1},  
		    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true, Edit : false},
		    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "SCHEDULED_DATE",		Header : "* 출고예정일",	Type : "Date",	Format:"Ymd", Width : 100,	EditLen : 110,	Edit : true, BackColor:"${notnullColor}" },
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type:"Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매출금액",	Type : "Float", Format:"${priceFormat}",Width : 100,	EditLen : 110,	Edit : false},
						{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}" },
						{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지연사유",	SaveName:"DELAY_REMARK"},
		    			{Align : "Left",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 400,	EditLen : 110,	Edit : false,BackColor:"${optColor}"},
		    			{Align : "Left",SaveName : "ACCOUNT_TYPE",		Header : "예산계정코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BYIT_COMORG_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_SEQ"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_SEQ"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_QTY"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"PROCESS_TYPE"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
   
	kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvExportWarhsngProcDetailData.do" ,pagingMode );
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			mySheet.RemoveAll();
			kepSearch(document.searchCondition ,  mySheet , "/exiv/getExportExIvExportWarhsngProcDetailData.do" , pagingMode );
			break;
		case "save": // 저장
	 	 	if(mySheet.length == 0)
	 	 	{
	 	        alert(" 입고확정 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 	    if(!confirm("입고등록 하시겠습니까?")) {
	 	    	return;
	 	    }else{
	 	    	kepSaveAll(document.searchCondition ,  mySheet , "/exiv/saveExportExIvExportWarhsngProcList.do");
	 	    }
			break;			
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");

}

function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+"<%=CommonUtil.nvl(rowData.get("AGENT")) %>" , "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	//입고정상 등록
	if(msg == "OK"){
		alert("입고처리 되었습니다.");
		opener.doAction("search");
		this.close();
	}else{
		if (msg != "") {
			alert(msg);
			doAction('search');
		}		
	}
}

//페이지 인덱스 눌렀을 경우 조회


//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	if((column == 'BUYER_ITEM_NO') )
	{
		var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
		var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
		openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ , "800,260,no"); 
	}
	return;
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	grbRow="";	//초기화
}

</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_no"),"") %>">
	<input type="hidden" id="st_inv_no"  name="st_inv_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_inv_no"),"") %>">
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">입고등록</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"   style="height:448px;">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						<tbody>

						<tr>
							<th>고객사</th>
							<td ><b><%=CommonUtil.nvl(rowData.get("COM_NAME")) %></b></td>
                  			<th >발주번호</th>
					  		<td ><%=CommonUtil.nvl(rowData.get("PO_NO")) %><%="".equals(CommonUtil.nvl(rowData.get("LEGACY_PO_NO")))?"":"("+CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))+")" %></td>
							<th >발주일</th>
							<td ><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
						 </tr>
						 <tr>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
                  			<th >입고번호</th>
					  		<td  ><b><%=CommonUtil.nvl(rowData.get("INV_NO")) %></b>(<%=CommonUtil.nvl(rowData.get("STATUS"))%>)</td>
							<th >구분</th>
							<td  ><%=CommonUtil.nvl(rowData.get("DOC_TEXT"))%></td>
						 </tr>
						 <tr>
							<th >입고예정일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE_RE"))%></td>
                  			<th >협력사</th>
					  		<td colspan='3'  ><u><a href="javascript:doPop('buyer_multi')"><%=CommonUtil.nvl(rowData.get("AGENT_NAME")) %></a></u><%="".equals(CommonUtil.nvl(rowData.get("AGENT_TEL_NO")))?"":"("+CommonUtil.nvl(rowData.get("AGENT_TEL_NO"))+")"%></td>
					  	 </tr>
						 <tr>
							<th >요청자</th>
							<td ><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%><%="".equals(CommonUtil.nvl(rowData.get("ADD_USER_TEL")))?"":"("+CommonUtil.nvl(rowData.get("ADD_USER_TEL"))+")"%></td>
                  			<th >배송처</th>
					  		<td   colspan='3'><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
						 </tr>
						 <tr>
							<th >비고</th>
							<td   colspan='5'><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:225px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
			<br/>
			
			        <!--버튼영역-->
     
			<span class="fr">
				  				<table border="0" cellspacing="0" cellpadding="0">
				  					<TR>
				  						<td>
				  							  &nbsp;<span class="btn_02 mr04"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">입고등록</a></span>
				  						</td>
				  					</TR>
				  				</table>
			</span>
		</div>	

    </div>
</form> 
</body>
</html>
