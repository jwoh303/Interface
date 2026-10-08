<%--
**********************************************
* 메뉴 :  wms>입고
* 화면 : LEGACY_NO 상세정보
* 기능 : Legacy 상세 조회
* 프로그램 ID : PG_08_M_004_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-4
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
String st_dept_name = CommonUtil.nvl((String) request.getParameter("st_dept_name"),"");  //  (조회조건)

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
var LocationOn = "/resources/images/btn_search03.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var addUserName = "/resources/images/btn_search03.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "STATUS",		Header : "상태",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
		    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
						{Align : "Center",SaveName : "INV_NO",		Header : "입고번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			
		    			{Align : "Center",SaveName : "PO_CREATE_DATE",		Header : "발주일",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
						{Align : "Center",SaveName : "RD_DATE",		Header : "납품요청일",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "PORS_CD_DATE",		Header : "입고예정일",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
						{Align : "Center",SaveName : "WMS_GR_DATE",		Header : "입고일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},
	                    {Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
	                    {Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	                    {Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	                    {Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "PO_QTY",		Header : "발주수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	                    {Align : "Right",SaveName : "WMS_GR_QTY",		Header : "납품수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
						{Align : "Right",SaveName : "GI_GR_QTY",		Header : "기입고수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},	
		    			{Align : "Right",SaveName : "AGENT_PRICE",		Header : "매입단가",	Type : "Float",  Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "AGENT_ITEM_AMT",		Header : "매입금액",	Type:"Int",	 Format:"#,##0",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
						{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type : "Float",  Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매출금액",	Type:"Int",	 Format:"#,##0",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},	    			
		    			{Align : "Left",SaveName : "GUBUN",		Header : "구분",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align:"Center",	Width:60,	    Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자", SaveName:"ADD_USER_NAME_IMG"},
						{Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자", SaveName:"ADD_USER_NAME"}, 
		    			{Align : "Left",SaveName : "DELY_TO_LOCATION",		Header : "배송처",Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
						{Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"},
		    			{Align : "Left",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
		    			{Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}					
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"ADD_USER_TEL"} 
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"POHD_REMARK"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"BYIT_COMORG_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"CONTRACT_NO"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"비고", SaveName:"CONTRACT_SEQ"}		
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"AGENT"}		
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"POHD_REMARK"}	
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	
	//비고이미지설정
	mySheet.SetImageList(0, remarkOn);
	mySheet.SetImageList(1, LocationOn);
	mySheet.SetImageList(2, addUserName);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "PO_REMARK_IMG"); 
	setLinkCol(mySheet, "ADD_USER_NAME_IMG");
	setLinkCol(mySheet, "AGENT_NAME");
	
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrLegacyNoPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrLegacyNoPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
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
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', LocationOn);
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOff);
		}
		if(mySheet.GetCellValue(i,"PO_REMARK")!="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}
		
		if(mySheet.GetCellValue(i,"ADD_USER_NAME")!="")
		{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'ADD_USER_NAME_IMG', remarkOff);
		}
		
	}
	
	
}

function localDateEval(RD_DATEval)
{
	 	var yyyy = RD_DATEval.substr(0,4);
	 	var mm = eval(RD_DATEval.substr(4,2) + "- 1") ;
		var dd = RD_DATEval.substr(6,2);
    	var dt3 = new Date(yyyy, mm, eval(dd + '-' +'2'));
	   	 yyyy = dt3.getFullYear();
		 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
		 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();
		 return  "" + yyyy + "/" + mm + "/" + dd ;
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if(column=="DELY_TO_LOCATION_IMG" )
	{
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}
	//발주번호를 클릭했을 때 
	if(column == 'PO_NO')
	{
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
		    
			var buyer = mySheet.GetCellValue(Row,'BUYER');
	    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
	    	var inv_no = mySheet.GetCellValue(Row,'INV_NO');
	    	var BUYER_NAME  = document.searchCondition.BUYER_NAME.value;
	    	var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
	    	var RD_DATEval = mySheet.GetCellValue(Row,'RD_DATE');
	    	var DOC_TEXT = document.searchCondition.DOC_TEXT.value;
	    	var GR_DATE_RE = localDateEval(RD_DATEval);
	    	var ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME')+'('+mySheet.GetCellValue(Row,'ADD_USER_TEL')+')';
	    	var DELY_TO_LOCATION = document.searchCondition.DELY_TO_LOCATION.value;
	    	var PO_REMARK = mySheet.GetCellValue(Row,'POHD_REMARK');
	    	var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
	    	var AGENT = mySheet.GetCellValue(Row,"AGENT"); //협력사
	    	var st_STATUS = "TR";
	    	var st_LEGACY_PO_NO = document.searchCondition.LEGACY_PO_NO.value;
	    	var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
	    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no+'&BUYER_NAME='+BUYER_NAME+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&DOC_TEXT='+DOC_TEXT+'&GR_DATE_RE='
	    			+GR_DATE_RE+'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&PO_REMARK='+PO_REMARK+'&AGENT_NAME='+AGENT_NAME+'&st_STATUS='+st_STATUS+'&st_LEGACY_PO_NO='
	    			+st_LEGACY_PO_NO+'&st_DELY_TO_LOCATION='+DELY_TO_LOCATION+'&st_RD_DATE='+st_RD_DATE+'&AGENT='+AGENT, "900,500,no"); 
			popupSel = "masterWmGrTrOrderManagerPop";
		}
	}
	else if(column=="PO_REMARK_IMG" )
	{
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK , "500,220,no"); 
			popupSel = "remarkBtoA";
		}		
	}
	else if(column=="ADD_USER_NAME_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'POHD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK , "500,220,no"); 
			popupSel = "masterWmCoRequestPop.jsp";
		}		
	}
	else if((column == 'BUYER_ITEM_NO') )
	{
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			var buyer = mySheet.GetCellValue(Row,'BUYER');
			getBuyerCatalogDisplayPop(buyer,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ);
		   	openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ,800,255,no);
		}
	}else 	if(column == 'AGENT_NAME'){
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!=""){
			
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code , "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}
	return;
}


//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="LEGACY_PO_NO"  name="LEGACY_PO_NO" value="<%=CommonUtil.nvl((String) request.getParameter("LEGACY_PO_NO"),"") %>">
	<input type="hidden" id="BUYER"  name="BUYER" value="<%=CommonUtil.nvl((String) request.getParameter("BUYER"),"") %>">
	<input type="hidden" id="BUYER_NAME"  name="BUYER_NAME" value="<%=CommonUtil.nvl((String) request.getParameter("BUYER_NAME"),"") %>">
	<input type="hidden" id="DOC_TEXT"  name="DOC_TEXT" value="<%=CommonUtil.nvl((String) request.getParameter("DOC_TEXT"),"") %>">
	<input type="hidden" id="DELY_TO_LOCATION"  name="DELY_TO_LOCATION" value="<%=CommonUtil.nvl((String) request.getParameter("DELY_TO_LOCATION"),"") %>">
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">LEGACY_NO 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="90px" />
							<col width="20%" />
							<col width="100px" />
							<col width="20%" />
							<col width="100px" />
							<col width="20%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>고객사</th>
							<td ><b><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></b></td>
                  			<th >LEGACY_NO</th>
					  		<td ><b><%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%></b></td>
							<th >구분</th>
							<td ><%=CommonUtil.nvl(rowData.get("GUBUN"))%></td>
						 </tr>
						 <tr>
							<th >요청자</th>
							<td  ><%=CommonUtil.nvl(rowData.get("PR_USER"))%></td>
                  			<th >비고</th>
					  		<td  colspan="3"><%=CommonUtil.nvl(rowData.get("POHD_REMARK"))%></td>
						 </tr>
					</tbody>
				</table>
            <br/>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
