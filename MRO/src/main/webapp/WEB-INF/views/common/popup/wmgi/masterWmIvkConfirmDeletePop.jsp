<%--
**********************************************
* 메뉴 : 
* 화면 : 배송확정조회 및 삭제
* 기능 : * 거래명세서(특수로직) 출력 호출 팝업 : 리포트 별도 취합 
* 프로그램 ID : PG_08_M_008_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<title>코리아 e 플랫폼</title>
<%@ include file="../../../common/include/head.jspf"  %> 
<%
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

%>
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var carExist;
var agentImg = "/resources/images/btn_search03.gif";
var remarkOn="/resources/images/but_icon01.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "LEGACY_NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "PROCESS_TEXT",		Header : "구분",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
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
	    			{Align : "Right",SaveName : "GI_DELIVERY_QTY",		Header : "기출고수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false}	    			
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
	    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CAR_NO"}
	];
	initsheet.Cfg = {FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, agentImg);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO"); 
	setLinkCol(mySheet, "GR_NO"); 
	setLinkCol(mySheet, "BUYER_ITEM_NO"); 
	
	setLinkCol(mySheet, "AGENT_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG");
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmIvkConfirmDeletePop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "del": //출고삭제
			if(!"출고"=="<%=CommonUtil.nvl((String) request.getParameter("st_STATUS_TEXT"),"") %>"){
			       alert("배송확정이 되어 있는 송장입니다. \n\n배송확정을 먼저 취소하시고 출고를 삭제 하십시요. ");
			       return;
			}
			var buyer ="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>";
			var podt_gr_qty ="<%=CommonUtil.nvl((String) request.getParameter("st_PODT_GR_QTY"),"") %>";
			if(buyer.substring(0,5)=="KRXPR" || buyer=="KRXPV00001"){
				if(eval(podt_gr_qty) > 0) 
				{
					alert("구매사 입고가 잡혀서 삭제 불가 합니다.");                     
					return;
				}
			}
			var auto_gr_yn ="<%=CommonUtil.nvl((String) request.getParameter("st_AUTO_GR_YN"),"N") %>";
			if(auto_gr_yn == "Y"){
				alert("납품실적등록으로 자동 입고 생성되는 고객사입니다.\n\n사업팀에게 요청 바랍니다.(시스템팀에서 처리 필요)");
				return;
			}
			
			var mod_flag =  "<%=CommonUtil.nvl((String) request.getParameter("st_MODIFIABLE"),"") %>";
			if(mod_flag == "N"){
				alert("현재월 이전 배송확정 건(재고)으로 배송확정 삭제가 불가능합니다.\n\n(전월 배송확정 건은 매월 6일까지만 삭제 가능합니다.)");
				return;
			}
		    if(!confirm("배송확정을 삭제 하시겠습니까?")) {
		        return;
		    }else{
				kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmIvkConfirmDeletePop.do","PO_NO" );
		    }

			break;
		case "report":
			
			//차량유무 
			carExist = "";
			for(var i = 1 ; i<mySheet.GetTotalRows()+1; i++){
				if(mySheet.GetCellValue(i,'CAR_NO') != ""){
					carExist  = "Y";
				}
			}
			if("P08-0000011-23"=="<%=pP08_0000011id%>" ){

				setWmsTrSheet("<%=pP08_0000011id%>",carExist,'<%=deptMap%>',document.searchCondition.st_ware_house_code.value ,document.searchCondition.st_buyer.value, document.searchCondition.st_IK_NO.value,document.searchCondition.USER_ID.value, '', '' ,'',''); 
			}else{
			
				setWmsTrSheet("<%=pP08_0000011id%>",carExist,'',document.searchCondition.st_ware_house_code.value ,document.searchCondition.st_buyer.value, document.searchCondition.st_IK_NO.value,document.searchCondition.USER_ID.value, '', '' ,'',''); 
			}
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
	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if(mySheet.GetCellValue(i,"PO_REMARK")!="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		if(mySheet.GetCellValue(i,"AGENT")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
		}
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
	      alert("정상적으로 배송확정 취소 되었습니다");
	      opener.doAction('search');
	      window.close();
	}else {
      alert("배송확정 삭제가 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다.");
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
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
			popupSel = "remarkBtoA";
		}		
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
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_ware_house_code"  name="st_ware_house_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_ware_house_code"),"") %>">
    <input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
    <input type="hidden" id="st_IK_NO"  name="st_IK_NO" value="<%=CommonUtil.nvl((String) request.getParameter("st_IK_NO"),"") %>">	
    <input type="hidden" id="st_BUYER_NAME"  name="st_BUYER_NAME" value="<%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %>">	
    <input type="hidden" id="st_PODT_GR_QTY"  name="st_PODT_GR_QTY" value="<%=CommonUtil.nvl((String) request.getParameter("st_PODT_GR_QTY"),"") %>">	
     <input type="hidden" id="st_MODIFIABLE"  name="st_MODIFIABLE" value="<%=CommonUtil.nvl((String) request.getParameter("st_MODIFIABLE"),"") %>">	
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
<c:if test="${param.workType eq 'MP' }">
        	<h1 class="title">TR배송 확정 조회</h1>
</c:if>        	
<c:if test="${param.workType ne 'MP' }">
        	<h1 class="title">배송확정조회 및 삭제</h1>
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
							<td ><b><%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %></b></td>
							<th >출고일</th>
							<td  ><%=CommonUtil.nvl((String) request.getParameter("st_INV_DATE"),"") %></td>
                  			<th >납품일</th>
					  		<td  ><%=CommonUtil.nvl((String) request.getParameter("st_DELIVERY_DATE"),"") %></td>
						 </tr>
						 <tr>
							<th >송장번호</th>
							<td  ><B><%=CommonUtil.nvl((String) request.getParameter("st_IK_NO"),"") %></B></td>
                  			<th >상태</th>
					  		<td  ><%=CommonUtil.nvl((String) request.getParameter("st_STATUS_TEXT"),"") %></td>
							<th >요청자</th>
							<td  ><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_NAME"),"") %><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"").equals("")?"":"(" +CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"")+")"%>
							</td>
						 </tr>
						 <tr>
							<th >배송처</th>
							<td   colspan='5'><%=CommonUtil.nvl((String) request.getParameter("st_DELY_TO_LOCATION"),"") %></td>
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
			
        <!--버튼영역-->
        <div class="btnArea mr25">

<span class="fl">
			<span class="btn_05 mr04"><a href="javascript:doAction('report')">거래명세서</a></span>		
</span>			
				<span class="fr">
<% if(CommonUtil.nvl((String) request.getParameter("st_type"),"") .equals("W")) { %>			
				<span class="btn_06 mr04"><a href="javascript:doAction('del')">배송확정삭제</a></span>
<% } %>				
			</span>
       </div>			
</div>			

        
    </div>
</form> 
</body>
</html>
