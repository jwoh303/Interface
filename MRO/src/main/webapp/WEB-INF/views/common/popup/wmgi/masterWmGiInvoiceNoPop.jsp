<%--
**********************************************
* 메뉴 : 
* 화면 : 출고조회 및 삭제
* 기능 : * 거래명세서(특수로직) 출력 호출 팝업 : 리포트 별도 취합 
* 프로그램 ID : PG_08_M_008_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String _dataDoosan = "";
_dataDoosan = (String) request.getAttribute("_dataDoosan"); // 조회된 결과

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");

String pP08_0000011id ="";
Map<String,String> formDataTemp = new HashMap<String,String>();
String  deptMap = "";
Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(CommonUtil.nvl((String) request.getParameter("st_buyer"),""));
if(_map!=null){
	pP08_0000011id = _map.get("SLG_ID");

	if("P08-0000011-23".equals(pP08_0000011id) ){
		
		formDataTemp.put("st_warehouse_code",CommonUtil.nvl((String) request.getParameter("st_ware_house_code"),"") );
		formDataTemp.put("st_ik_no_temp",CommonUtil.nvl((String) request.getParameter("st_IK_NO"),""));
		formDataTemp.put("st_buyer",CommonUtil.nvl((String) request.getParameter("st_buyer"),"") );
		deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formDataTemp );
	
		}
	
	
}


SessionInfo _sessionInfo1 = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String user_id = CommonUtil.nvl((String)_sessionInfo1.getUserId());
%>
<!doctype html>
<html>
<head>  
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script src="/resources/js/wms_tr_sheet.js"></script> 
<title>코리아 e 플랫폼</title>
<%@ include file="../../../common/include/head.jspf"  %> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var carExist;
var agentImg = "/resources/images/btn_search03.gif";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "LEGACY_NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "GUBUN_TEXT",		Header : "구분",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "MSDS_NO",		Header : "MSDS NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "GR_NO",		Header : "입고번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "GR_DATE",		Header : "입고일",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "PO_DATE",		Header : "발주일",	Type:"Date",Format:"Ymd",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납품요청일",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "PO_QTY",		Header : "발주수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "INV_QTY",		Header : "출고수량",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "DELIVERY_QTY",		Header : "납품수량",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "GI_DELIVERY_QTY",		Header : "기출고수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "BUYER_GR_QTY",		Header : "고객사입고수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "LIST_PRICE",		Header : "매입단가",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "LIST_AMT",		Header : "매입금액",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "UNIT_AMT",		Header : "매출금액",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사", SaveName:"AGENT"} 
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고", SaveName:"PO_REMARK"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"AGENT_NAME"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"AGENT_TEL_NO"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_HD_REMARK"} 	    		
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"DELY_TO_LOCATION"} 	
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"ADD_USER_NAME"} 	
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"ADD_USER_TEL"} 	
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"WAREHOUSE_CODE"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BUYER"} 
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"DOC_TEXT"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BYIT_COMORG_CODE"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_NO"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"IK_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TYPE"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TEXT"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"LEGACY_PO_SEQ"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CAR_NO", SaveName:"CAR_NO"}
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"KTAG_QTY"}	    			   			
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, agentImg);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "MSDS_NO");
	setLinkCol(mySheet, "GR_NO"); 
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	setLinkCol(mySheet, "DELIVERY_QTY"); 		
	setLinkCol(mySheet, "AGENT_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG");
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiInvoiceNoPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiInvoiceNoPop.do" , pagingMode );
			break;
		case "del": //출고삭제
			if(!"출고"=="<%=CommonUtil.nvl(rowData.get("STATUS_TEXT")) %>"){
			       alert("배송확정이 되어 있는 송장입니다. \n\n배송확정을 먼저 취소하시고 출고를 삭제 하십시요. ");
			       return;
			}
			var buyer ="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>";
			var sum_gr_qty = 0;
			for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++) {
				sum_gr_qty += mySheet.GetCellValue(i,"BUYER_GR_QTY");	
			}
			if(sum_gr_qty > 0) {
				alert("구매사 입고가 잡혀서 삭제 불가 합니다.");
				return;
			}

			

			if($("#workType").val() != 'MP' ){ // 발주관리화면이 아닌 WMS에서 띄울경우에만 트랜잭션 처리를 발생시킴 
			    if(!confirm("출고지시를 삭제 하시겠습니까?")) {
			        return;
			    }else{
					kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiInvoiceNoPop.do","PO_NO" );
			    }
			}

			break;			
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
		case "print":
			
			//차량유무 
			carExist = "";
			for(var i = 1 ; i<mySheet.GetTotalRows()+1; i++){
				if(mySheet.GetCellValue(i,'CAR_NO') != ""){
					carExist  = "Y";
				}
			}
			
			if("P08-0000011-23"=="<%=pP08_0000011id%>" ){

				setWmsTrSheet("<%=pP08_0000011id%>",carExist,'<%=deptMap%>',document.searchCondition.st_ware_house_code.value ,document.searchCondition.st_buyer.value, document.searchCondition.st_IK_NO.value,document.searchCondition.USER_ID.value, '<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO")) %>', document.searchCondition.st_legacy_po_seq_tot.vaue ,'<%=CommonUtil.nvl(rowData.get("LEGACY_IV_SERIAL")) %>',''); 
			}else{
			
				setWmsTrSheet("<%=pP08_0000011id%>",carExist,'',document.searchCondition.st_ware_house_code.value ,document.searchCondition.st_buyer.value, document.searchCondition.st_IK_NO.value,document.searchCondition.USER_ID.value, '<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO")) %>', document.searchCondition.st_legacy_po_seq_tot.vaue ,'<%=CommonUtil.nvl(rowData.get("LEGACY_IV_SERIAL")) %>',''); 
			}
			<%if(_dataDoosan.equals("POPUP_YES")){%>
				
		    	  var fileName = "RD_06_X_002_05";
		    	  var buyerFlag = document.searchCondition.st_buyer.value;
		    	  var invNo = document.searchCondition.st_IK_NO.value;
		    	  var param =  "["+<%=rowData.get("LEGACY_PO_NO")%>+"]";
		    	  reportOpen(fileName,param);
			<%}%>
			
			break;
		
		case "courier_print":
			var fileName = "RD_06_X_002_16";
			var buyer = document.searchCondition.st_buyer.value;
			var invNo = document.searchCondition.st_IK_NO.value;
			var param = "["+buyer+"]["+invNo+"]";
			reportOpen(fileName,param);			
			break;
		case "hj_print":
			var fileName = "RD_06_X_002_81";
			var buyer = document.searchCondition.st_buyer.value;
			var invNo = document.searchCondition.st_IK_NO.value;
			var param = "["+buyer+"]["+invNo+"]";
			reportOpen(fileName,param);			
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
	
	var legacy_po_seq_a = "";
	var legacy_po_seq_tot = "";
	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if(mySheet.GetCellValue(i,"PO_REMARK")=="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		if(mySheet.GetCellValue(i,"AGENT")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
		}
		
		if(document.searchCondition.st_buyer.value =="KRDOOS0035")
		{
			if(i ==mySheet.GetTotalRows() ){
				legacy_po_seq_a =mySheet.GetCellValue(i,"LEGACY_PO_SEQ") + "";
			}else{
				legacy_po_seq_a = mySheet.GetCellValue(i,"LEGACY_PO_SEQ") + ",";
			}
			legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;  

		}else{
			legacy_po_seq_a =mySheet.GetCellValue(i,"LEGACY_PO_SEQ")+ "@@";	
			legacy_po_seq_tot = legacy_po_seq_tot + legacy_po_seq_a;

		}
		if(mySheet.GetCellValue(i,"KTAG_QTY")!=""){
			mySheet.SetCellFontColor(i,"DELIVERY_QTY","red");
		}
		
	}

	document.searchCondition.st_legacy_po_seq_tot.vaue = legacy_po_seq_tot;

	
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
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiInvoiceNoPop.do?page="+current_page , pagingMode );
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
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if(code =="1" )
	{
	      alert("정상적으로 출고지시가 취소 되었습니다.");
	      opener.doAction('search');
	      window.close();
	}else {
		  if(msg!= ''){
		      alert(msg);
		  }
    }
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if(column=="AGENT_IMG" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else 	if(column=="PO_REMARK_IMG" )
	{
		var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
		openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "550,230,no"); 
		popupSel = "remarkBtoA";	
		
	}else if(column == 'PO_NO')
	{
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			
			if(mySheet.GetCellValue(Row,'PO_NO')!=""){
				
				
			    var ware_house_code = mySheet.GetCellValue(Row,'WAREHOUSE_CODE');
				var buyer = mySheet.GetCellValue(Row,'BUYER');
		    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
		    	var inv_no = mySheet.GetCellValue(Row,'GR_NO');
		    	var BUYER_NAME  = "<%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %>";
		    	var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_DATE');
		    	var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
		    	var DOC_TEXT = mySheet.GetCellValue(Row,'DOC_TEXT');
		    	var RD_DATEval = mySheet.GetCellValue(Row,'RD_DATE');
		    	var GR_DATE_RE =  localDateEval(RD_DATEval);
		    	var ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
		    	var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    	var PO_REMARK = mySheet.GetCellValue(Row,'PO_HD_REMARK');
		    	var AGENT = mySheet.GetCellValue(Row,'AGENT');
		    	var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
		    	var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
		    	var st_STATUS = mySheet.GetCellValue(Row,'PROCESS_TEXT');
		    	var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
		    	var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');

		    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no+'&INV_NO='+inv_no+'&BUYER_NAME='+BUYER_NAME+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&st_RD_DATE='
		    			+st_RD_DATE+'&DOC_TEXT='+DOC_TEXT+'&GR_DATE_RE='+GR_DATE_RE+'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&PO_REMARK='+PO_REMARK+'&AGENT_NAME='+AGENT_NAME
		    			+'&ware_house_code='+ware_house_code+'&st_STATUS='+st_STATUS+'&st_LEGACY_PO_NO='+st_LEGACY_PO_NO+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&AGENT='+AGENT+'&AGENT_TEL_NO='+AGENT_TEL_NO, "900,500,no"); 
				popupSel = "masterWmGrTrOrderManagerPop";
			}
		}
	}else if(column == 'GR_NO')
	{
		if(mySheet.GetCellValue(Row,'GR_NO')!=""){
			var st_buyer = mySheet.GetCellValue(Row,'BUYER');
			var st_po_no = mySheet.GetCellValue(Row,'PO_NO');
			var st_po_seq = mySheet.GetCellValue(Row,'PO_SEQ');
			openSearchPopup('/wmgr/getMasterWmGrWarehousingNoPop.do','?st_buyer='+st_buyer+'&st_po_no='+st_po_no+'&st_po_seq='+st_po_seq, "840,500,no"); 
					popupSel = "masterWmGrWarehousingNoPop";
		}
	}else if(column == 'BUYER_ITEM_NO')	{
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}else if(column == 'DELIVERY_QTY')	{
		if(mySheet.GetCellValue(Row, 'DELIVERY_QTY') =="1"){
			alert("수량 1개의 품목은 분할하실 수 없습니다.");
	        return;
		}
		
			var buyer = mySheet.GetCellValue(Row,'BUYER');
			var inv_no = document.searchCondition.st_IK_NO.value;
			var inv_seq = mySheet.GetCellValue(Row,'IK_SEQ');
			var buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var item_qty = mySheet.GetCellValue(Row,'DELIVERY_QTY');
			var description = mySheet.GetCellValue(Row,'DESCRIPTION');
			var po_no = mySheet.GetCellValue(Row,'PO_NO');
			var po_seq = mySheet.GetCellValue(Row,'PO_SEQ');
			
			 if(!confirm("Ktag출력시 수량분할하시겠습니까?")) return;
			 openSearchPopup("/mpiv/getsellerMpIvKtagPlanEntryPop.do", "?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq, "520,500,no");
			
		
	}else	if(column=="MSDS_NO" ){
			var st_msds_no = mySheet.GetCellValue(Row,'MSDS_NO');
			if(st_msds_no == ""){
				alert("선택한 MSDS 정보가 없습니다.");
				return;
			}else{
				openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+st_msds_no+"&st_btn_yn=N",'750,580,no'); 
				popupSel = "msdsDetailPop";
			}
	}
	return;
}

function sheetTagListWin1() {
	
	var buyer	= "<%=st_buyer%>"; 
	var seller	= "KRKORE0001";
// 	var inv_no	= document.searchCondition.st_IK_NO.value;
	var inv_no  = document.searchCondition.st_IK_NO.value;
	var legacy_po_no = "<%=rowData.get("LEGACY_PO_NO")%>";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();
	
	if(ktag_start >= 2){
		alert("K tag(1칸)은 출력위치 1 이하만 가능합니다.");
		return;
	}
	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+inv_no+"&buyer="+buyer;
    reportOpen("RD_06_X_002_17", param);
	return;
}

function sheetTagListWin4() {
	
	var buyer	= "<%=st_buyer%>"; 
	var seller	= "KRKORE0001";
// 	var inv_no	= document.searchCondition.st_IK_NO.value;
	var inv_no  = document.searchCondition.st_IK_NO.value;
	var legacy_po_no = "<%=rowData.get("LEGACY_PO_NO")%>";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var print_size = $("#ktag_selectbox3").val();
	var fileName = "";
	
	if(ktag_start >= 5){
		alert("K tag(4칸)은 출력위치 4 이하만 가능합니다.");
		return;
	}
	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
   	
   	if(print_size == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if(print_size == "N"){
 		fileName = "RD_06_X_002_19";
 	}
   	
    reportOpen(fileName, param);
    
	return;
}

function sheetTagListWin12() {
	
	var buyer	= "<%=st_buyer%>"; 
// 	var seller	= document.searchCondition.st_ware_house_code.value;
	var seller = "KRKORE0001";
// 	var inv_no	= document.searchCondition.st_IK_NO.value;
	var inv_no = document.searchCondition.st_IK_NO.value;
	var legacy_po_no = "<%=rowData.get("LEGACY_PO_NO")%>";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val(); 
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+inv_no+"&buyer="+buyer;   
    reportOpen("RD_06_X_002_11", param); 
	return;
}

function setKtagDivide( buyer, inv_no, inv_seq , buyer_item_no , item_qty ,description ,po_no,po_seq,  x ){


    if(item_qty =='1'){   
        alert("수량 1개의 품목은 분할하실 수 없습니다.");
        return;
    }


        if(!confirm("Ktag출력시 수량분할하시겠습니까?")) return;

    
//     document.forms.sellerMpIvObtnodrReceiptDetailPop.x.value = x;

     openSearchPopup("/mpiv/getsellerMpIvKtagPlanEntryPop.do", "?st_buyer="+buyer+"&st_inv_no="+inv_no+"&st_inv_seq="+inv_seq +"&st_buyer_item_no="+buyer_item_no+"&st_item_qty="+item_qty+"&st_description="+description+"&st_po_no="+po_no+"&st_po_seq="+po_seq, "520,500,no");
    
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
<body onLoad="kep_onload_view();">
<form name = "searchCondition" method = "post" onSubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="workType"  name="workType" value="${param.workType}">
	<input type="hidden" id="st_ware_house_code"  name="st_ware_house_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_ware_house_code"),"") %>">
    <input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
    <input type="hidden" id="st_IK_NO"  name="st_IK_NO" value="<%=CommonUtil.nvl((String) request.getParameter("st_IK_NO"),"") %>">	
    <input type="hidden" id="st_BUYER_NAME"  name="st_BUYER_NAME" value="<%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %>">	
    <input type="hidden" id="st_PODT_GR_QTY"  name="st_PODT_GR_QTY" value="<%=CommonUtil.nvl((String) request.getParameter("st_PODT_GR_QTY"),"") %>">
     <input type="hidden" id="st_legacy_po_seq_tot"  name="st_legacy_po_seq_tot" value="">	
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
<c:if test="${param.workType eq 'MP' }">
        	<h1 class="title">TR출고 조회</h1>
</c:if>        	
<c:if test="${param.workType ne 'MP' }">
        	<h1 class="title">출고조회</h1>
</c:if>        	
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            </div>
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%">
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
							<td ><b><%=CommonUtil.nvl(rowData.get("BUYER_NAME")) %></b></td>
							<th >출고일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("INV_DATE"))%></td>
                  			<th >납품일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("DELIVERY_DATE"))%></td>
						 </tr>
						 <tr>
							<th >송장번호</th>
							<td  ><B><%=CommonUtil.nvl(rowData.get("IK_NO")) %></B></td>
                  			<th >상태</th>
					  		<td  ><%=CommonUtil.nvl(rowData.get("STATUS_TEXT")) %></td>
							<th >요청자</th>
							<td  ><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME")) %><%="".equals(rowData.get("ADD_USER_TEL"))? "" : "("+rowData.get("ADD_USER_TEL")+")"%></td>
						 </tr>
						 <tr>
						 	 <th >출고자</th>
							<td ><%=CommonUtil.nvl(rowData.get("ADD_USER_ID")) %></b></td>
							<th >배송처</th>
							<td   colspan='3'><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION")) %></td>
						 </tr>
						
					</tbody>
				</table>

            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:255px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
	
        <!--버튼영역-->
        <div class="btnArea">
        	<div style="position:absolute; left:20px">
				<%
				if(CommonUtil.nvl(rowData.get("COURIER_TAG_YN")).equals("Y")){ 
				%>
				<span class="btn_02 mr04"><a href="javascript:doAction('courier_print')">택배라벨</a></span>
				<%
				} 
				%>
				<%
				if(CommonUtil.nvl(rowData.get("HANJIN_TAG_YN")).equals("Y")){ 
				%>
				<span class="btn_02 mr04"><a href="javascript:doAction('hj_print')">택배라벨</a></span>
				<%
				} 
				%>
        		<span class="btn_05 mr04"><a href="javascript:doAction('print' )">거래명세서</a></span>
        		
                    <span class ="btn_10_blue" style="color:#FFF; display: none;">
                        KTAG출력위치
                        <select id="ktag_selectbox" name="ktag_selectbox" style="width:40px; ">
                        <option value="1" selected>1</option>
                        <option value="2" >2</option>
                        <option value="3" >3</option>
                        <option value="4" >4</option>
                        <option value="5" >5</option>
                        <option value="6" >6</option>
                        <option value="7" >7</option>
                        <option value="8" >8</option>
                        <option value="9" >9</option>
                        <option value="10" >10</option>
                        <option value="11" >11</option>
                        <option value="12" >12</option>
                        </select>
                    </span>
                    <span class ="btn_10_blue" style="width:115px; color:#FFF">
                        	박스수량: 
                        <select id="ktag_box_qty" name="ktag_box_qty" style="width:40px; ">
                        <option value="1" selected>1</option>
                        <option value="2" >2</option>
                        <option value="3" >3</option>
                        <option value="4" >4</option>
                        <option value="5" >5</option>
                        <option value="6" >6</option>
                        <option value="7" >7</option>
                        <option value="8" >8</option>
                        <option value="9" >9</option>
                        <option value="10" >10</option>
                        <option value="11" >11</option>
                        <option value="12" >12</option>
                        <option value="13" >13</option>
                        <option value="14" >14</option>
                        <option value="15" >15</option>
                        <option value="16" >16</option>
	                    <option value="17" >17</option>
	                    <option value="18" >18</option>
	                    <option value="19" >19</option>
	                    <option value="20" >20</option>
	                    <option value="21" >21</option>
	                    <option value="22" >22</option>
	                    <option value="23" >23</option>
	                    <option value="24" >24</option>
	                    <option value="25" >25</option>
	                    <option value="26" >26</option>
	                    <option value="27" >27</option>
	                    <option value="28" >28</option>
	                    <option value="29" >29</option>
	                    <option value="30" >30</option>
	                    <option value="31" >31</option>
						<option value="32" >32</option>
						<option value="33" >33</option>
						<option value="34" >34</option>
						<option value="35" >35</option>
						<option value="36" >36</option>
						<option value="37" >37</option>
						<option value="38" >38</option>
						<option value="39" >39</option>
						<option value="40" >40</option>
						<option value="41" >41</option>
						<option value="42" >42</option>
						<option value="43" >43</option>
						<option value="44" >44</option>
						<option value="45" >45</option>
						<option value="46" >46</option>
						<option value="47" >47</option>
						<option value="48" >48</option>
						<option value="49" >49</option>
						<option value="50" >50</option>
                        </select> 
                    </span>
                    
                    <span class="btn_10_blue" style="color:#FFF;">
						출력방식&nbsp;&nbsp;
						<select id="ktag_selectbox3" name="ktag_selectbox3" style="width:60px; margin-top:3px">
		                    <option value="L">라벨</option>
		                    <option value="N" selected>일반</option>
	                    </select>
					</span>
					
                    <span class="btn_06" ><a href="javascript:sheetTagListWin4();">품목TAG 출력</a></span>
        	</div>
			<% if(CommonUtil.nvl((String) request.getParameter("st_type"),"") .equals("W") ) { %>				
						<span class="btn_02 mr04"><a href="javascript:doAction('del')">출고삭제</a></span>				
            <% } %>				
       </div>
			
</div>			
        
    </div>
</form> 
</body>
</html>
