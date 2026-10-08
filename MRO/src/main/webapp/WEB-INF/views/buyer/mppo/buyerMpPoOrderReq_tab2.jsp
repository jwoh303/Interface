<%--
**********************************************
* 메뉴 : 주문 > 주문요청처리
* 화면 : 주문요청 탭
* 기능 : 주문요청에 대한 리스트를 확인하고 처리할 수 있다
* 프로그램 ID : BU0501008
* 담당자 : 최찬규
* 착수일 : 2026-04-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
// 	String buyer1 = CommonUtil.nvl((String)_sessionInfo.getComCode());

@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
	String buyer             = "";
	String SessionComCode             = "";
	String zip_code          = "";
	String SessionUserId            = "";
	String userName          = "";
	String SessionUserDept          = "";
	String userTel           = "";
	String email             = "";
	String fax_no            = "";
	String mobile            = "";
	
	String SessionComorgLevel = "";
	String SessionComorgCode  = "";
	String using_catal_type  = "";
	String location_code     = "";
	String location_name     = "";
	String purchaseDeptCode  = "";
	String purchaseDeptName  = ""; 
	
	String img_view_flag  = ""; 
	String budget_flag   = ""; 
	String SessionAgentOpenFlag = ""; 
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		buyer             = sessionInfo.getComCode();      
		SessionComCode             = sessionInfo.getComCode();      
		SessionUserId            = sessionInfo.getUserId();
		userName          = sessionInfo.getUserNameLoc();
		SessionUserDept          = sessionInfo.getDepartment(); 
		userTel           = sessionInfo.getTel();
		email             = sessionInfo.getEmail();
		fax_no            = sessionInfo.getFax();
		mobile            = sessionInfo.getmPhone();
		using_catal_type  = sessionInfo.getUsingCatalType();
		
		zip_code          = sessionInfo.getZipCode();
		SessionComorgLevel = sessionInfo.getBycaComorgLevel();
		SessionComorgCode  = sessionInfo.getBycaComorgCode();      
		location_code     = CommonUtil.nvl(sessionInfo.getDelyToLocation());
		location_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationName());
		purchaseDeptCode  = sessionInfo.getPurchaseDept();
		purchaseDeptName  = sessionInfo.getPurchaseDeptName();
		
		img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
		
		budget_flag           = sessionInfo.getBudgetFlag();
		SessionAgentOpenFlag  = sessionInfo.getAgentOpenFlag();
	} 	
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, buyer);
	
	String group_mng_flag = "N";
	
	if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
	}
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
	
	//관리번호 텍스트로 관리
	boolean bca00004 = CommonUtil.getSpecialCheckReturn(buyer,"BCA00004");
	
	//발주 개수 제한
	boolean p060000017 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000017"); // KRJINR0007
	//품의서 출력 버튼 활성화
    boolean p060000011 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000011"); // KRJINR0004 KRJINR0005 KRJINR0007
    
    //품목 체크해서 메시지
    String p060000130_col01 = ""; // 고객사 품목코드
	String p060000130_col02 = ""; // 알림 메시지
    Map<String, String> p060000130_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000130");
	if(p060000130_map != null){
	 	p060000130_col01 = CommonUtil.nvl(p060000130_map.get("COL01_DATA"), p060000130_col01);
	 	p060000130_col02 = CommonUtil.nvl(p060000130_map.get("COL02_DATA"), p060000130_col02);
 	}
	// 구매요청접수 구매발주시 체크된 주문의 부서만 예산 체크
	boolean p060000134 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000134");
	
%>
<style>
	#calendarContainer{
		z-index:99999 !important;
	}
</style>
<script type="text/javascript">
var mySheet2 = new ibsheetObject();
var mySheet4 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerMpPoOrderReq_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMpPoOrderReq_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	g_dt_buyer:"",
	payment_flag : "Y",
	product_cnt : 0,
	product_amt : 0,
	tot_order_amt : 0,
	init:function(){
		if($("#st_from_date_2").val() ==  ""){
			$("#st_from_date_2").val(kepToMonthAdd("1","M"));
			$("#st_to_date_2").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet2 = {};
		initsheet2.Cfg = {FrozenCol:2,MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet2.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:40,	Edit:true,	EditLen:100,	Hidden:false}
				,{ Align:"Center",	SaveName:"NO",					Header:"<%=CommonLang.get("HTITLE44")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true} /*번호*/
				,{ Align:"Center",	SaveName:"STATUS_TEXT",				Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*진행상태*/
				,{ Align:"Left",	SaveName:"BUYER_NAME_LOC",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*고객사명*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*주문요청번호*/
				,{ Align:"Center",	SaveName:"DOC_TYPE",			Header:"<%=CommonLang.get("HTITLE582")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*선입고여부*/
				,{ Align:"Left",	SaveName:"REQ_DEPT",			Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서*/
				,{ Align:"Left",	SaveName:"ADD_USER_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
				,{ Align:"Left",	SaveName:"PUR_DEPT",			Header:"<%=CommonLang.get("HTITLE188")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주부서*/
				,{ Align:"Left",	SaveName:"PUR_USER_NAME",			Header:"<%=CommonLang.get("HTITLE187")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주자*/
				,{ Align:"Center",	SaveName:"GYULJAE_FLAG",				Header:"<%=CommonLang.get("HTITLE253")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false} /*결재유무*/
				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE567")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*협력사명*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				,{ Align:"Left",	SaveName:"PRICE_REMARK",				Header:"<%=CommonLang.get("HTITLE1367")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*단가비고*/
				
				,{ Align:"Right",	SaveName:"TARGET_QTY",				Header:"<%=CommonLang.get("HTITLE651")%>",				Type:"Float",		Width:90,	Edit:false,	Hidden:false}/*요청수량*/
				,{ Align:"Right",	SaveName:"RECV_QTY",				Header:"<%=CommonLang.get("HTITLE242")%>",				Type:"Float",		Width:90,	Edit:true,	Hidden:false,BackColor:"${optColor}"}/*승인수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
				
				,{ Align:"Center",	SaveName:"RD_DATE",			Header:"<%=CommonLang.get("HTITLE831")%>",				Type:"Date",		Width:120,	Edit:true,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd",BackColor:"${optColor}"} /*수령희망일*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT_NAME",			Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정*/
				,{ Align:"Center",	SaveName:"PO_REMARK",			Header:"<%=CommonLang.get("HTITLE122")%>",				Type:"Text",		Width:120,	Edit:false,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*비고*/
<%-- 				,{ Align:"Center",	SaveName:"IMSI_PO_CREATE_DATE",			Header:"<%=CommonLang.get("HTITLE665")%>",				Type:"Date",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"} /*선입고발주일*/ --%>
<%-- 				,{ Align:"Center",	SaveName:"ST_PO_CREATE_DATE",			Header:"<%=CommonLang.get("HTITLE665")%>",				Type:"Date",		Width:120,	Edit:false,	EditLen:100,	Hidden:true, Format:"yyyy-MM-dd"} /*선입고발주일*/ --%>
				
				,{ Align:"Center",	SaveName:"REF_PR_TEXT",			Header:"REF_PR_TEXT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RECV_FLAG",			Header:"RECV_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"CONTRACT_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",			Header:"AGENT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_SEQ",			Header:"PR_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"STATUS_CODE",			Header:"STATUS_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GW_NO",			Header:"GW_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PLAN_AMT_FLAG",			Header:"PLAN_AMT_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CHANGE_USER_DEPT",			Header:"CHANGE_USER_DEPT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONFIRM_YN",			Header:"CONFIRM_YN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PASS_YN",			Header:"PASS_YN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BDGT_FLAG",			Header:"BDGT_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUDGET_DEPT",			Header:"BUDGET_DEPT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",			Header:"ACCOUNT_TYPE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RETURN_REASON",			Header:"RETURN_REASON",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"TEMP_QTY",			Header:"TEMP_QTY",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PAY_TERMS",			Header:"PAY_TERMS",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_REMARK",			Header:"PR_REMARK",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"DOC_TYPE_REMARK",			Header:"DOC_TYPE_REMARK",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Right",	SaveName:"PR_TARGET_PRICE",		Header:"PR_TARGET_PRICE",		Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:true, Format:"${priceFormat}"}
		];
		
		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		IBS_InitSheet(mySheet4, initsheet2, this.pagingMode);
		
		
	},
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var com_code = $("#st_com_code_2").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_2").val(com_code);
		}else{
			$("#st_group_info_2").val("");
		}
		$("#st_all_page_2").val("N");
		this.current_page = 1;
		kepSearch_v2(document.searchCondition2, mySheet2, "/mppo/getBuyerMpPoOrderReqList_v2.do?page="+this.current_page, this.pagingMode);
	},
	search2:function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var com_code = $("#st_com_code_2").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_2").val(com_code);
		}else{
			$("#st_group_info_2").val("");
		}
		$("#st_all_page_2").val("Y");
		kepSearch_v2(document.searchCondition2, mySheet4, "/mppo/getBuyerMpPoOrderReqList_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		kepMonth_v2('st_from_date_2','st_to_date_2','1');
		$("#st_req_dept_code_2").val("");
// 		$("#st_pur_user_id_2").val("");
// 		$("#st_pur_dept_code_2").val("");
		mySheet2.RemoveAll();
		mySheet4.RemoveAll();
		this.tot_order_amt = 0;
		$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	doAction:function(str){
		switch (str) {
		case "reqDepartmentErase":
			$("#st_req_dept_code_2").val("");
			$("#st_req_dept_name_2").val("");
			break;
		case "purDepartmentErase":
			$("#st_pur_dept_code_2").val("");
			$("#st_pur_dept_name_2").val("");
			break;
		case "createPR":
			this.createPR('1');
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_2").val();
		if(com_code == ""){
			var text = "<%=CommonLang.msg("MSG239")%>";//고객사를 전체 아닌 값으로 선택해야 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		switch (str) {
		case "purDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpPoOrderReq_tab2", "720,580,no"); 
			break;
		case "reqDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpPoOrderReq_tab2", "720,580,no"); 
			break;
		case "purUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpPoOrderReq_tab2", "780,550,no");
			break;
		case "reqUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpPoOrderReq_tab2", "780,550,no");
			break;
		case "changeRdDate":
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var rowList = new Array();
			var rowJson = "";
			var gridJsonList = "";
			
			for(var idx = 0; idx<arrRow.length; idx++){
				var param = {
						"PR_NO" : mySheet2.GetCellValue(arrRow[idx],"PR_NO")
						,"BUYER_ITEM_NO" : mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
						,"DESCRIPTION" : mySheet2.GetCellValue(arrRow[idx],"DESCRIPTION")
						,"UNIT_PRICE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_PRICE")
						,"TARGET_QTY" : mySheet2.GetCellValue(arrRow[idx],"TARGET_QTY")
						,"RECV_QTY" : mySheet2.GetCellValue(arrRow[idx],"RECV_QTY")
						,"UNIT_MEASURE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_MEASURE")
						,"AMT" : mySheet2.GetCellValue(arrRow[idx],"AMT")
					};
				rowJson = JSON.stringify(param);
				rowList.push(rowJson);
			}

			gridJsonList =  "[" + rowList.toString() + "]";
			$("#info").val(gridJsonList);
			
			openSearchPopupPost("/mppo/showBuyerMpPoChangeRdDate_v2.do","popupForm","showBuyerMpPoChangeRdDate_v2","width=840,height=600,resizable=no,scrollbars=no");
			
			break;
		case "transferDept":
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var rowList = new Array();
			var rowJson = "";
			var gridJsonList = "";
			
			var status_text_temp = mySheet2.GetCellValue(arrRow[0],"STATUS_TEXT");
			
			for(var idx = 0; idx<arrRow.length; idx++){
				if(mySheet2.GetCellValue(arrRow[idx],"STATUS_TEXT") != status_text_temp){
					//진행상태가 다른 주문은 함께 처리할 수 없습니다. 동일한 진행상태의 요청만 선택해 주세요.
					var text = "<%=CommonLang.msg("MSG998") %>";
	 				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	 	            return;
				}
					
				
				var param = {
						"PR_NO" : mySheet2.GetCellValue(arrRow[idx],"PR_NO")
						,"BUYER_ITEM_NO" : mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
						,"DESCRIPTION" : mySheet2.GetCellValue(arrRow[idx],"DESCRIPTION")
						,"UNIT_PRICE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_PRICE")
						,"TARGET_QTY" : mySheet2.GetCellValue(arrRow[idx],"TARGET_QTY")
						,"RECV_QTY" : mySheet2.GetCellValue(arrRow[idx],"RECV_QTY")
						,"UNIT_MEASURE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_MEASURE")
						,"AMT" : mySheet2.GetCellValue(arrRow[idx],"AMT")
					};
				rowJson = JSON.stringify(param);
				rowList.push(rowJson);
			}

			if(status_text_temp == "주문요청"){
				$("#st_reqHold").val("REQ");
			}else{
				$("#st_reqHold").val("HOLD");
			}
			gridJsonList =  "[" + rowList.toString() + "]";
			$("#info").val(gridJsonList);
			
			openSearchPopupPost("/mppo/showBuyerMpPoTransferDept_v2.do","popupForm","showBuyerMpPoTransferDept_v2","width=840,height=600,resizable=no,scrollbars=no");
			break;
		case "prReturn":
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			if(checkRows == ""){
				//하나 이상의 대상이 선택되어야 합니다.
				var text = "<%=CommonLang.msg("MSG259") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var rowList = new Array();
			var rowJson = "";
			var gridJsonList = "";
			
			for(var idx = 0; idx<arrRow.length; idx++){
// 				var st_buyer = mySheet2.GetCellValue(arrRow[idx],"BUYER");
<%-- 				if(st_buyer != "<%=SessionComCode%>"){ //세션 고객사랑 선택한 고객사랑 다를 경우 주문처리 x --%>
// 					//고객사가 다를경우 처리 불가능합니다.
<%-- 					var text = "<%=CommonLang.msg("MSG210") %>"; --%>
// 	 				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
// 	 	            return;
// 				}
				
				var st_confirm_yn = mySheet2.GetCellValue(arrRow[idx],"CONFIRM_YN");
				if(st_confirm_yn == "N"){
			    	//해당 고객사는의 처리권한이 없습니다.
			    	var text = "<%=CommonLang.msg("MSG198") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			    	return;
			    }
				
				var param = {
						"PR_NO" : mySheet2.GetCellValue(arrRow[idx],"PR_NO")
						,"BUYER_ITEM_NO" : mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
						,"DESCRIPTION" : mySheet2.GetCellValue(arrRow[idx],"DESCRIPTION")
						,"UNIT_PRICE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_PRICE")
						,"TARGET_QTY" : mySheet2.GetCellValue(arrRow[idx],"TARGET_QTY")
						,"RECV_QTY" : mySheet2.GetCellValue(arrRow[idx],"RECV_QTY")
						,"UNIT_MEASURE" : mySheet2.GetCellValue(arrRow[idx],"UNIT_MEASURE")
						,"AMT" : mySheet2.GetCellValue(arrRow[idx],"AMT")
					};
				rowJson = JSON.stringify(param);
				rowList.push(rowJson);
			}

			gridJsonList =  "[" + rowList.toString() + "]";
			$("#info").val(gridJsonList);
			
			openSearchPopupPost("/mppo/showBuyerMpPoRejectReasonPop.do","popupForm","showBuyerMpPoRejectReasonPop","width=840,height=600,resizable=no,scrollbars=no");
			
			break;
		case "PrRecvReturnReasonPop":
			closePopText2();
			
			var imsi_qty = mySheet2.GetCellValue(this.grbRow,"RECV_QTY");
			var imsi_buy_price = mySheet2.GetCellValue(this.grbRow,"UNIT_PRICE");
			var imsi_req_qty = mySheet2.GetCellValue(this.grbRow,"TARGET_QTY");
			var old_amt = imsi_req_qty * imsi_buy_price;
			var new_amt = imsi_qty * imsi_buy_price;
//	 		var buyer = mySheet2.GetCellValue(this.grbRow,"BUYER"); //this.grbRow별 고객사가 아니라 sessionComCode?? TGCM 있는 고객사들은 로그인 고객사로 처리하는지 확인..
			var buyer = $("#st_buyer_2").val();
			var account_type = mySheet2.GetCellValue(this.grbRow,"ACCOUNT_TYPE");
			var budget_dept = mySheet2.GetCellValue(this.grbRow,"BUDGET_DEPT");
			
			var pr_no = mySheet2.GetCellValue(this.grbRow,"PR_NO");
			var pr_seq = mySheet2.GetCellValue(this.grbRow,"PR_SEQ");
            var reason = mySheet2.GetCellValue(this.grbRow,"RETURN_REASON");
            
            var budget_flag = "<%=budget_flag%>";
            
            document.forms.popupForm.return_reason.value = reason;
            document.forms.popupForm.recv_qty.value = imsi_qty;
            document.forms.popupForm.st_pr_no.value = pr_no;
            document.forms.popupForm.st_pr_seq.value = pr_seq;
            document.forms.popupForm.st_old_amt.value = old_amt;
            document.forms.popupForm.st_new_amt.value = new_amt;
            document.forms.popupForm.st_account_type.value = account_type;
            document.forms.popupForm.st_budget_dept.value = budget_dept;
            document.forms.popupForm.st_budget_flag.value = budget_flag;
            document.forms.popupForm.st_row.value = 0;
            
            openSearchPopupPost("/mppo/showBuyerPrRecvReturnReasonPop.do","popupForm","showBuyerPrRecvReturnReasonPop","width=500,height=350,resizable=no,scrollbars=no");
			break;
		default:
			break;
		}
	},
	PRSheetMsg:function(){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//출력할 목록을 선택 하세요. 
			var text = "<%=CommonLang.msg("MSG187") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		var buyerCheck = "Y";
		var st_dt_buyer_code = "";
		
		for(var idx=0; idx<arrRow.length; idx++){
			if(idx == 0){
				st_dt_buyer_code = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			}else{
				if(st_dt_buyer_code != mySheet2.GetCellValue(arrRow[idx],"BUYER")){
					buyerCheck = "N";
				}
			}
		}
        if(buyerCheck=="N"){
        	//고객사가 다를경우 품의서 출력이 불가능합니다.
            var text = "<%=CommonLang.msg("MSG188") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
            return;
        }
		
		$("#confirmPrSheetArea").show();
		$("#confirmPrSheetAreaOverlay").show();
	},
	PRSheetCancel:function(){
		document.forms.searchCondition2.prsheetreport.value = "dept_item";
		$("#confirmPrSheetArea").hide();
		$("#confirmPrSheetAreaOverlay").hide();
	},
	PRSheet:function(){
		$("#confirmPrSheetArea").hide();
		$("#confirmPrSheetAreaOverlay").hide();
		
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
	    var pr_no   =  "";
	    var ref_no   =  document.getElementById('st_search_type_2').value=='RN'?document.forms.searchCondition2.st_search_code.value:'';
	    var buyer = document.forms.searchCondition2.st_buyer.value;
	    var user_dept = document.forms.searchCondition2.userDept.value;    
	    var req_dept_code =  document.forms.searchCondition2.st_req_dept_code.value;
	    
	    
	    var query = "";
	    var st_dt_buyer_code = "";
		for(var idx=0; idx<arrRow.length; idx++){
			st_dt_buyer_code = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			
			query += mySheet2.GetCellValue(arrRow[idx],"PR_NO");
			query += mySheet2.GetCellValue(arrRow[idx],"PR_SEQ");
			query += "@@";
		}
        
		buyer = st_dt_buyer_code;
		
		
		var reportid = "";
		var prsheetreport = kepRadioSelectVal("prsheetreport"); 
	    if (prsheetreport == "dept"){ // 부서별
	    	reportid = "RD_06_S_003_08";
	    }else if (prsheetreport == "item"){ // 품목별
	    	reportid = "RD_06_S_003_09";
	    }else if (prsheetreport == "no"){ // 품의번호별
	    	reportid = "RD_06_S_003_10";
	    }else if (prsheetreport == "dept_item"){ // 부서&품목별	
	    	reportid = "RD_06_S_003_11";
	    }
		
	    document.forms.processForm.st_query.value = query;
	    reportPostOpen(reportid, "["+buyer+"]["+req_dept_code+"]["+ref_no+"]["+pr_no+"]["+user_dept+"]["+query+"]");
	},
	pageSearch:function(param){
		this.current_page = param.page;
		$("#st_all_page_2").val("N");
		kepSearch_v2(document.searchCondition2, mySheet2, "/mppo/getBuyerMpPoOrderReqList_v2.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if (this.popupSel == "purDepartment") {
			$("#st_pur_dept_code_2").val(value1);
			$("#st_pur_dept_name_2").val(value2);
		} else if(this.popupSel == "reqDepartment") {
			$("#st_req_dept_code_2").val(value1);
			$("#st_req_dept_name_2").val(value2);
		}else if(this.popupSel == "purUser") {
			$("#st_pur_user_id_2").val(value1);
			$("#st_pur_user_name_2").val(value2);
		}else if(this.popupSel == "reqUser") {
			$("#st_req_user_id_2").val(value1);
			$("#st_req_user_name_2").val(value2);
		}else if(this.popupSel == "changeRdDate"){
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			for(var idx = 0; idx<arrRow.length; idx++){
				mySheet2.SetCellValue(arrRow[idx],"RD_DATE",value1);
			}
		}else if(this.popupSel == "transferDept"){
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			var query = "";
			for(var idx = 0; idx<arrRow.length; idx++){
				query += mySheet2.GetCellValue(arrRow[idx],"BUYER") + "@@" + mySheet2.GetCellValue(arrRow[idx],"PR_NO") + "@@" + mySheet2.GetCellValue(arrRow[idx],"PR_SEQ");
				query += "|";
			}
			
			document.forms.processForm.st_query.value  = query;         
	        document.forms.processForm.st_purchaserDept.value  = value1;         
	        document.forms.processForm.st_buyer.value  = $("#st_buyer_2").val();       

	        kepAjaxFormCallTab("/mppo/saveDeptTramsfer.do","processForm","DEPT_TRANSFER","buyerMpPoOrderReq_tab2");//부서이관
		}else if(this.popupSel == "prReturn"){
			var checkRows = mySheet2.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			
			var query = "";
			for(var idx = 0; idx<arrRow.length; idx++){
				query += mySheet2.GetCellValue(arrRow[idx],"BUYER") + "@@" + mySheet2.GetCellValue(arrRow[idx],"PR_NO") + "@@" + mySheet2.GetCellValue(arrRow[idx],"PR_SEQ");
				query += "@@"+value1;
				query += "@@"+mySheet2.GetCellValue(arrRow[idx],"TARGET_QTY");
				query += "@@"+mySheet2.GetCellValue(arrRow[idx],"CHANGE_USER_DEPT");
				query += "@@"+mySheet2.GetCellValue(arrRow[idx],"ACCOUNT_TYPE");
				query += "@@"+mySheet2.GetCellValue(arrRow[idx],"PLAN_AMT_FLAG");
				query += "|";
			}
			
			document.forms.processForm.st_query.value  = query;            
		    document.forms.processForm.st_pr_return_type.value  = "PR";       
		    kepAjaxFormCallTab("/mppo/saveSerPrReturn.do","processForm","REJECT","buyerMpPoOrderReq_tab2");//반려     
		}else if(this.popupSel == "poRemark"){
			mySheet2.SetCellValue(this.grbRow,"PO_REMARK",value1);
		}
	},
	thisPopClose:function(){
		closePopText2();
		$("#imsi_po_create_date_2").val(""); //혹시 선입고 발주일 입력했으면 초기화해주기
		this.search();
	},
	excelDown:function(){
		if(mySheet4.RowCount() == 0){
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		mySheet4.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i = 1; i <= mySheet4.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<= mySheet4.LastCol(); i++){
			if(!mySheet4.GetColHidden(i) && mySheet4.ColSaveName(i) !="SELECTED" && mySheet4.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "<%=CommonLang.get("HTITLE194")%>"+"_"; //주문요청_
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet4.Down2Excel(param);
	},
	buyerChange:function(){
		$("#st_req_dept_code_2").val("");
		$("#st_req_dept_name_2").val("");
// 		$("#st_pur_dept_code_2").val("");
// 		$("#st_pur_dept_name_2").val("");
	},
	kepAjaxSuccess:function(pMethod , response){
		if(pMethod == "DEPT_TRANSFER"){
			var result = response.msg.MSG;
			
			if (result == "DUP"){
				 //선택된 대상중 발주 진행된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		         var text = "<%=CommonLang.msg("MSG213") %>  ";  
		  		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		         return;
			}
			
			if (result == "DUP2"){
				   //선택된 대상중 반려된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		           var text = "<%=CommonLang.msg("MSG214") %>  ";  
			  	   openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		           return;
			}
			//부서이관이 성공적으로 이루어 졌습니다.
	    	 var text = "<%=CommonLang.msg("MSG215") %>  ";  
		  	 openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
		}else if(pMethod == "REJECT"){
			var result = response.msg.MSG; 
			
			if (result == "DUP"){
				 //선택된 대상중 발주 진행된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		         var text = "<%=CommonLang.msg("MSG213") %>  ";  
		  		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		         return;
			}
			if (result == "DUP2"){
				   //선택된 대상중 반려된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		           var text = "<%=CommonLang.msg("MSG214") %>  ";  
			  	   openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		           return;
			}
			//반려가 성공적으로 이루어 졌습니다.
	    	 var text = "<%=CommonLang.msg("MSG216") %>  ";  
		  	 openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
		}else if (pMethod ==  "BUYERADMINBDGTTEMPQTYCHECK"){
			
	    	if (response.data.length > 0){
	    		var result = $.trim(eval("response.data[0].CNT")); 
				this.setResultCheckBdgtAmt(result, this.grbRow);
				
	    	}
		}else if(pMethod == "BUYERADMINBDGTTEMPORDERCHECK"){
			var gbnYn = "Y";
			var recvFlag =  document.forms.processForm.recvFlag.value;
			var end_price =  document.forms.processForm.end_price.value;
    		for(var i=0; i < response.data.length; i++ ){
				flag = $.trim(eval("response.data["+i+"].BUYER_CHECK"));
				budget_dept_name = $.trim(eval("response.data["+i+"].BUDGET_DEPT_NAME"));
				account_text = $.trim(eval("response.data["+i+"].ACCOUNT_TYPE_TEXT"));
				plan_amt = $.trim(eval("response.data["+i+"].PLAN_AMT"));
				result_amt = $.trim(eval("response.data["+i+"].RESULT_AMT"));
				temp_amt = $.trim(eval("response.data["+i+"].TEMP_AMT"));
				tot_price = $.trim(eval("response.data["+i+"].TOT_AMT"));
			    if(flag == "예산초과"){
			    	//예산 원 구매가능 예산 원 구매금액 원 예산이 초과되어 구매할 수 없습니다.
// 			        alert(budget_dept_name +
<%-- 			              "\n\n"+account_text+" <%=CommonLang.msg("MSG381") %>   "+kepCommaNum(plan_amt)+" <%=CommonLang.get("HTITLE660") %>"+ --%>
<%-- 			              "\n\n"+account_text+" <%=CommonLang.msg("MSG382") %>   "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+" <%=CommonLang.get("HTITLE660") %>"+ --%>
<%-- 			              "\n\n"+account_text+" <%=CommonLang.msg("MSG383") %>   "+kepCommaNum(tot_price)+" <%=CommonLang.get("HTITLE660") %>"+ --%>
<%-- 			              "\n\n<%=CommonLang.msg("MSG384") %>"); --%>
			        var text = budget_dept_name+"</br>"+account_text+"<%=CommonLang.msg("MSG381") %>"+kepCommaNum(plan_amt)+"<%=CommonLang.get("HTITLE660") %>";
			        text += "</br>"+account_text+"<%=CommonLang.msg("MSG382") %>"+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+"<%=CommonLang.get("HTITLE660") %>";
			        text += +"</br>"+account_text+"<%=CommonLang.msg("MSG383") %>"+kepCommaNum(tot_price)+"<%=CommonLang.get("HTITLE660") %>";
			        text += +"</br>"+account_text+"<%=CommonLang.msg("MSG384") %>";
				  	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			        gbnYn = "N";
			        return ;
			    } else if(flag == "예산미편성"){
			    	//예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
			    	var text = budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>";
			    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			        gbnYn = "N";
			        return;
			    } else if(flag == "100"){
			    	//예산이 편성되어 있지 않습니다. 확인 후 다시 주문해 주시기 바랍니다.
			    	var text = "<%=CommonLang.msg("MSG219") %>";
			    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			    	gbnYn = "N";
			        return;
			    }
    		}
    		if(gbnYn == "Y"){
    			this.setCheckEnd('OK',recvFlag,end_price);
    		}
		}else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
			var checkpass = response.msg.CHECKPASS;   
			var pass_flag = response.msg.PASS_FLAG;   		
			this.GoPass_v2(checkpass,pass_flag,this.product_amt,this.g_dt_buyer);
		}else if(pMethod == "SAVEINSERTMERGEPXPO"){
			var result = response.msg.MSG;   	
			if (result == "DUP"){
				 //선택된 대상중 발주 진행된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		         var text = "<%=CommonLang.msg("MSG213") %>  ";  
		  		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		         return;
			}
			if (result == "DUP2"){
				   //선택된 대상중 반려된 요청번호가 존재합니다.재 조회 후 확인부탁드립니다.
		           var text = "<%=CommonLang.msg("MSG214") %>  ";  
			  	   openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		           return;
			}
			
	        var pr_no_value   = result.substr(0,2);
	        var gw_no_new     = document.forms.searchCondition2.gw_no_new.value;
	        var recv_flag_new = document.forms.searchCondition2.recv_flag_new.value;
	        var as_flag_new   = document.forms.searchCondition2.as_flag_new.value;
	        if(pr_no_value == "PR" || pr_no_value == "PX"){
	            if((!(result == "" || result == "null")) && gw_no_new == 'N' && recv_flag_new =='1' ) {
	            	//구매대행 발주가 성공적으로 이루어 졌습니다.\n\n구매대행 발주번호는 입니다.
	                var text = "<%=CommonLang.msg("MSG221") %> "+ result + " <%=CommonLang.msg("MSG385") %>";  
				  	openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
	            }else if((!(result == "" || result == "null"))&&  as_flag_new =='PS' ) {
	            	//구매대행발주 결재상신이 성공적으로 이루어 졌습니다.\n\n결재상신된 구매대행번호는 입니다.
	                var text = "<%=CommonLang.msg("MSG222") %> "+ result + " <%=CommonLang.msg("MSG385") %>";  
				  	openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
	            }
	        }else{
	        	//구매대행 발주생성에 실패하였습니다. 다시 확인하여 주시기 바랍니다.
	            var text = "<%=CommonLang.msg("MSG224") %>";  
			  	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	            return;
	        }
		}
	    
	},
	kepAjaxError:function(pMethod , response){
		//오류발생하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG163") %>  ";  
		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	},
	createPR:function(recvFlag){
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		if(checkRows == ""){
			//하나 이상의 대상이 선택되어야 합니다.
			var text = "<%=CommonLang.msg("MSG259") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		// 진로 청원 발주수량 50건 이하로 제한
	    <%if (p060000017 == true) { %> 
			if(arrRow.length > 50){
				//안정적인 주문 처리를 위해 한 번에 최대 50건까지 선택할 수 있습니다. 상위 50건을 먼저 선택하시겠습니까?
				var text = "<%=CommonLang.msg("MSG804")%>"; 
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerMpPoOrderReq_tab2.checkFunction('1'); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	         	return;
			}//end if 
		<%}%>
		
		this.createPRcontinue(recvFlag);
	},
	checkFunction:function(recvFlag){
		closePopText1();
		
		//50개 넘어간건 체크 해제
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx = 50; idx<arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx],"SELECTED",false);
		}
		
		this.createPRcontinue(recvFlag);
	},
	createPRcontinue:function(recvFlag){
		
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		var st_buyer = "";
		var st_imsi_po_create_date = "";
		
		var status_text_temp = mySheet2.GetCellValue(arrRow[0],"STATUS_TEXT");
		var st_buyer_temp = "";
		for(var idx = 0; idx<arrRow.length; idx++){
			if(mySheet2.GetCellValue(arrRow[idx],"STATUS_TEXT") != status_text_temp){
				//진행상태가 다른 주문은 함께 처리할 수 없습니다. 동일한 진행상태의 요청만 선택해 주세요.
				var text = "<%=CommonLang.msg("MSG998") %>";
 				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
 	            return;
			}
			if(idx == 0){
				st_buyer_temp = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			}else{
				if(mySheet2.GetCellValue(arrRow[idx],"BUYER") != st_buyer_temp){
					//고객사가 다를경우 처리 불가능합니다.
					var text = "<%=CommonLang.msg("MSG210") %>";
	 				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	 	            return;
				}
			}
// 			var st_buyer = mySheet2.GetCellValue(arrRow[idx],"BUYER");
<%-- 			if(st_buyer != "<%=SessionComCode%>"){ //세션 고객사랑 선택한 고객사랑 다를 경우 주문처리 x --%>
// 				//고객사가 다를경우 처리 불가능합니다.
<%-- 				var text = "<%=CommonLang.msg("MSG210") %>"; --%>
//  				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
//  	            return;
// 			}
		}
		
		if(status_text_temp == "주문요청"){
			$("#st_reqHold").val("REQ");
		}else{
			$("#st_reqHold").val("HOLD");
		}
		
		var st_group_mng_flag = $("#st_group_mng_flag_2").val();
		
		for(var idx = 0; idx<arrRow.length; idx++){
			var st_confirm_yn = mySheet2.GetCellValue(arrRow[idx],"CONFIRM_YN");
			if(st_confirm_yn == "N"){
		    	//해당 고객사는의 처리권한이 없습니다.
		    	var text = "<%=CommonLang.msg("MSG198") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return;
		    }
			if(mySheet2.GetCellValue(arrRow[idx],"PASS_YN")=="Y"&& st_group_mng_flag=="Y"){
	           	//번째 고객사는 전자결재범위가 발주품의이므로 처리 불가능합니다.
	            var text = (idx+1) + "<%=CommonLang.msg("MSG204") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	            return;            	
	        }
			var st_qty = mySheet2.GetCellValue(arrRow[idx],"RECV_QTY");
			if(st_qty == "0" || st_qty == ""){
				//수량이 입력되지 않았습니다.
				var text = "<%=CommonLang.msg("MSG796") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return;
			}
			
			var st_rd_date = mySheet2.GetCellValue(arrRow[idx],"RD_DATE");
			var cur_date = kepGetNowTimeStr("YYYYMMDD","");
			if(st_rd_date == ""){
				//수령희망일을 입력해주세요.
				var text = "<%=CommonLang.msg("MSG797") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var st_gr_flag = mySheet2.GetCellValue(arrRow[idx],"DOC_TYPE");
			if(st_gr_flag == "Y"){ //선입고일 때
				$("#grDateSelOverlay").show();
				$("#grDateSel").show();
				
				return;
			}
			if(st_rd_date < cur_date){
				//수령희망일은 현재일 이후로 선택하셔야 합니다.
				var text = "<%=CommonLang.msg("MSG444") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
		}
		
		this.doCheckAMT(recvFlag);
	},
	grDateCancel:function(){
		$("#grDateSelOverlay").hide();
		$("#grDateSel").hide();
	},
	grDateSel:function(recvFlag){
		if($("#imsi_po_create_date_2").val() == ""){
			//선입고 날짜를 선택하세요
			var text = "<%=CommonLang.msg("MSG906") %>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#grDateSelOverlay").hide();
		$("#grDateSel").hide();
		
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		var st_buyer_temp = "";
		for(var idx = 0; idx<arrRow.length; idx++){
			if(idx == 0){
				st_buyer_temp = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			}else{
				if(mySheet2.GetCellValue(arrRow[idx],"BUYER") != st_buyer_temp){
					//고객사가 다를경우 처리 불가능합니다.
					var text = "<%=CommonLang.msg("MSG210") %>";
	 				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	 	            return;
				}
			}
			
// 			var st_buyer = mySheet2.GetCellValue(arrRow[idx],"BUYER");
<%-- 			if(st_buyer != "<%=SessionComCode%>"){ //세션 고객사랑 선택한 고객사랑 다를 경우 주문처리 x --%>
// 				//고객사가 다를경우 처리 불가능합니다.
<%-- 				var text = "<%=CommonLang.msg("MSG210") %>"; --%>
//  				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
//  	            return;
// 			}
		}
		
		var st_group_mng_flag = $("#st_group_mng_flag_2").val();
		
		for(var idx = 0; idx<arrRow.length; idx++){
			var st_confirm_yn = mySheet2.GetCellValue(arrRow[idx],"CONFIRM_YN");
			if(st_confirm_yn == "N"){
		    	//해당 고객사는의 처리권한이 없습니다.
		    	var text = "<%=CommonLang.msg("MSG198") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return;
		    }
			if(mySheet2.GetCellValue(arrRow[idx],"PASS_YN")=="Y"&& st_group_mng_flag=="Y"){
	           	//번째 고객사는 전자결재범위가 발주품의이므로 처리 불가능합니다.
	            var text = (idx+1) + "<%=CommonLang.msg("MSG204") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	            return;            	
	        }
			var st_qty = mySheet2.GetCellValue(arrRow[idx],"RECV_QTY");
			if(st_qty == "0" || st_qty == ""){
				//수량이 입력되지 않았습니다.
				var text = "<%=CommonLang.msg("MSG796") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return;
			}
			
			var st_rd_date = mySheet2.GetCellValue(arrRow[idx],"RD_DATE");
			var cur_date = kepGetNowTimeStr("YYYYMMDD","");
			if(st_rd_date == ""){
				//수령희망일을 입력해주세요.
				var text = "<%=CommonLang.msg("MSG797") %>";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
			var st_gr_flag = mySheet2.GetCellValue(arrRow[idx],"DOC_TYPE");
			var st_imsi_po_create_date = $("#imsi_po_create_date_2").val().replace(/[/]/gi,"");
			
			if(st_gr_flag == "Y"){
				if(st_rd_date < st_imsi_po_create_date){
					//수령희망일은 발주일 이후로 선택하셔야 합니다.
					var text = "<%=CommonLang.msg("MSG801") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					return;
				}
			}else{
				if(st_rd_date < cur_date){
					//수령희망일은 현재일 이후로 선택하셔야 합니다.
					var text = "<%=CommonLang.msg("MSG444") %>";
					openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
					return;
				}
			}
		}
		
		this.doCheckAMT(recvFlag);
	},
	doCheckAMT:function(recvFlag){
		tabs.buyerMpPoOrderReq_tab2.g_dt_buyer = "";
		var buyer = $("#st_buyer_2").val();
		var budget_dept_flg = "<%=p060000134%>";
		var pr_no = "";
		var query = "";
		
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx = 0; idx<arrRow.length; idx++){
			pr_no = mySheet2.GetCellValue(arrRow[idx],"PR_NO");
			var pr_seq = mySheet2.GetCellValue(arrRow[idx],"PR_SEQ");
			var recv_qty = mySheet2.GetCellValue(arrRow[idx],"RECV_QTY");
			var account_type = mySheet2.GetCellValue(arrRow[idx],"ACCOUNT_TYPE");
			var budget_dept = mySheet2.GetCellValue(arrRow[idx],"BUDGET_DEPT");
			var buyer = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			tabs.buyerMpPoOrderReq_tab2.g_dt_buyer = buyer;
			var total   = pr_seq+"@@"+recv_qty+"@@"+account_type+"@@"+budget_dept+"@@"+pr_no+"@@"+buyer;
            query += total;
            query += "|";
		}
		
		document.forms.processForm.st_query.value  = query;            
	    document.forms.processForm.st_buyer.value  = tabs.buyerMpPoOrderReq_tab2.g_dt_buyer;           
	    document.forms.processForm.st_bdgt_pr_no.value  = pr_no;           
	    document.forms.processForm.recvFlag.value  = recvFlag;           
	    document.forms.processForm.st_budget_dept_flg.value = budget_dept_flg;
	    kepAjaxFormCallTab("/mppo/buyerAdminBdgtTempOrderDetailCheck.do","processForm","BUYERADMINBDGTTEMPORDERCHECK","buyerMpPoOrderReq_tab2"); 
		
	},
	setCheckEnd:function(FLAG,recvFlag,end_price){
		if(FLAG == "OK"){
			document.forms.searchCondition2.nu_end_price.value = end_price;
	        this.setData(recvFlag);
		}
	},
	setData:function(recvFlag){
		var f = document.forms.searchCondition2;
		var buyer	 = f.st_buyer.value;
	    var userID          = f.userID.value;
	    var userTEL         = f.st_add_user_tel.value;
	    var userDept        = f.userDept.value;
		var checked_cnt		= 0;
	    var prSubject       = "";
	    var remark          = "";
	    var notify          = "";
	    var tel             = f.st_add_user_tel.value;
	    var dely_to_address = ""; 
	    f.delete_flag.value = "N";
	    f.multi_flag.value  = "N";
	    
	    
	    var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		var alert_flag = false;
		var product_cnt = 0;
		var product_amt = 0;
		for(var idx = 0; idx<arrRow.length; idx++){
			var temp_buyer_item_no = mySheet2.GetCellValue(arrRow[idx],"BUYER_ITEM_NO");
			
			if(!isEmpty("<%=p060000130_col01%>") && "<%=p060000130_col01%>" == temp_buyer_item_no){
				alert_flag = true;
            }
			product_cnt ++;
			product_amt += mySheet2.GetCellValue(arrRow[idx],"AMT");
		}
		tabs.buyerMpPoOrderReq_tab2.product_cnt = product_cnt;
		tabs.buyerMpPoOrderReq_tab2.product_amt = product_amt;
		if(alert_flag){
			var text = "<%=p060000130_col02%>";
			openLayerPopText2(text,this.but1text,"tabs.buyerMpPoOrderReq_tab2.setDataContinue("+product_cnt+","+product_amt+");return false;",this.but1width);
		}else{
			this.setDataContinue(product_cnt,product_amt);
		}
	    
	    
	},
	setDataContinue:function(product_cnt,product_amt){
		closePopText2();
		
		// 품목수 : 총 금액 :  선택한 품목을 구매대행 발주하시겠습니까?
		var text = "<%=CommonLang.msg("MSG378") %> : "+kepCommaNum(product_cnt)+", <%=CommonLang.get("HTITLE172") %> : "+kepCommaNum(product_amt)+"<br/>"+"<%=CommonLang.msg("MSG380") %>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:tabs.buyerMpPoOrderReq_tab2.setDataEnd(); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

	},
	setDataEnd:function(){
		closePopText1();
		document.forms.processForm.TYPE.value = "PX";	 
      	document.forms.processForm.COM_CODE.value = tabs.buyerMpPoOrderReq_tab2.g_dt_buyer;
      	kepAjaxFormCallTab("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ","buyerMpPoOrderReq_tab2");   
	},
	GoPass_v2:function(checkpass,pass_flag,nu_tot_price,pass_buyer,pass_attach_yn){
		var type =  document.forms.processForm.TYPE.value;

     // 경동보일러 일 경우 회원사 결재조건 설정여부와 상관없이 발주결재상신(PS) 상태로 처리함
     // 경동보일러(KRBOIL0002) 그룹웨어 결재 사용(결재완료시 I/F 쪽에서 발주생성함) , KOREAB2B.COM 사이트에서는  발주결재상신(PS) 상태까지 진행하고 ,  이후 진행은 I/F 에서 발주처리
     // ServerCall(GW_NO,recvFlag) ==> 발주모듈 생성할때  ==> GW_NO = 'GW0200XXX' 결재 처리한 건 ,  GW_NO = 'N' 결재 미처리 건, GW_NO = 'GROUPWARE' 경동보일러 건

     //  그룹웨어 결재 if(buyer == "KRBOIL0002" || buyer == "KRKDBO0001" || buyer == "KRKDBO0002" || buyer == "KRKDPR0001") 일 경우
     if(pass_flag == "G"){
         this.ServerCall("GROUPWARE","PS");
         return;
     }
     
     if(checkpass == "false" || checkpass == false) {        // 결재 처리를 하지 않는 경우

		this.ServerCall("N","PC");
		return;

     }else{                  // 결재 처리 하는 경우
    	 var type = document.forms.processForm.TYPE.value;
         if(pass_flag == "N"){
        	 	var text = "<%=CommonLang.msg("MSG802")%>";
        		var content = "<%=CommonLang.msg("MSG803")%>";
        		var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
        		var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; //  전자결재
        		var but3textC = "<%=CommonLang.get("HTITLE197")%>"; // 주문
        		var but1funcC = "javascript:closePopText3(); return false;";
        		var but2funcC = "javascript:tabs.buyerMpPoOrderReq_tab2.executeReg('1','"+type+"'); return false";
        		var but3funcC = "javascript:tabs.buyerMpPoOrderReq_tab2.executeReg('2','"+type+"'); return false";
        		var but1widthC = "120px";
        		var but2widthC = "150px";
        		var but3widthC = "150px";
        		openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
         }else{
        	 
	         openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=' + type + '&requesTemptYn=Y&DOCU_NO=&BIZ_DOCU_NO=&nu_tot_price='+this.product_amt+'&nu_tot_cnt='+this.product_cnt+'&st_category_no='+'&st_buyer='+this.g_dt_buyer+'&pass_attach_yn='+'&tab_id=buyerMpPoOrderReq_tab2' , "800,860,no");
         }
 		
     } 
	},
	executeReg:function(flag,type){
		closePopText3();
		if(flag == "1"){ //전자결재
			openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=' + type + '&requesTemptYn=Y&DOCU_NO=&BIZ_DOCU_NO=&nu_tot_price='+this.product_amt+'&nu_tot_cnt='+this.product_cnt+'&st_category_no='+'&st_buyer='+this.g_dt_buyer+'&pass_attach_yn='+'&tab_id=buyerMpPoOrderReq_tab2' , "800,860,no");
		}else if(flag == "2"){ //바로 주문
			this.ServerCall("N","PC");
		}
	},
	ServerCall:function(GW_NO,recvFlag){
		var query = "";
	    var asFlag = recvFlag;
	  
	    if(recvFlag =="PC" || recvFlag =="PS" || recvFlag =="1") {
	            recvFlag= '1';
	    }else{
	            recvFlag='3';
	    }
	    
	    var f = document.forms.searchCondition2;
	     
	    
	    
	    f.gw_no_new.value     = GW_NO;
	    f.recv_flag_new.value = recvFlag;
	    f.as_flag_new.value   = asFlag; 
	    var buyer                = f.st_buyer.value;
	    var userID               = f.userID.value;
	    var userDept             = f.userDept.value;
	    var reqDept              = f.reqDept.value;
	    var prSubject            = " ";
	    var remark               = " ";
	    var notify               = f.st_notify.value;
	    var tel                  = f.st_add_user_tel.value;
	    var dely_to_address_text = " ";
	    var dely_to_address      = " ";
	    var account_type_code    = f.st_account_type_code.value;      // ACCOUNT_TYPE (계정분류)
	    if(reqDept==""){
	        reqDept=" ";
	    }
	    if(account_type_code==""){
	        account_type_code=" ";
	    }
	    var userTel              = "<%=userTel%>";
	    if(userTel==""){
	        userTel=" ";
	    }
	    var usrname              = "<%=userName%>";
	    if(usrname==""){
	        usrname=" ";
	    }
	    var end_price            = f.nu_end_price.value; //예산차액
	    if(end_price==""){
	        end_price ="0";
	    }
	    var po_create_date = "<%=curDate%>";
	    // 선입고
	    f.st_gr_flag.value = "N";
	    var gr_flag = f.st_gr_flag.value;
	    var st_dt_buyer_code = "";
	    
	    var checkRows = mySheet2.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		for(var idx = 0; idx<arrRow.length; idx++){
			var pr_no           = mySheet2.GetCellValue(arrRow[idx],"PR_NO");
            var pr_seq          = mySheet2.GetCellValue(arrRow[idx],"PR_SEQ");
            var recv_qty        = mySheet2.GetCellValue(arrRow[idx],"RECV_QTY");
            var ref_no          = mySheet2.GetCellValue(arrRow[idx],"REF_PR_NO");
            var return_reason   = mySheet2.GetCellValue(arrRow[idx],"RETURN_REASON");
            var rd_date         = mySheet2.GetCellValue(arrRow[idx],"RD_DATE");
			var po_remark       = mySheet2.GetCellValue(arrRow[idx],"PO_REMARK");
			st_dt_buyer_code    = mySheet2.GetCellValue(arrRow[idx],"BUYER");
			
			po_create_date = $("#imsi_po_create_date_2").val().replace(/[/]/gi,"");
            if(ref_no ==""){
                ref_no = " ";
            }
            if(return_reason ==""){
                return_reason = " ";
            }
			if(po_remark ==""){
                po_remark = " ";
            }
			var total   = pr_no+"~~~"+pr_seq+"~~~"+recv_qty+"~~~"+ref_no+"~~~"+return_reason+"~~~"+rd_date+"~~~"+po_remark+"~~~";
            query += total;
            query += "@@";
		}
	    query += "|";
	    query += st_dt_buyer_code;
	    query += "|";
	    query += userID;
	    query += "|";
	    query += userDept;
	    query += "|";
	    query += recvFlag;
	    query += "|";
	    query += userTel;
	    query += "|";
	    query += usrname;
	    query += "|";
	    query += GW_NO;
	    query += "|";
	    query += po_create_date;
	    query += "|";
	    query += gr_flag;
	    query += "|";
	    query += end_price;
	    query += "|";
	    query += "PRPO";                 // (PXPR)직발주 인지 , (PRPO)요청접수발주인지 구분
	    query += "|";
	    query += account_type_code;      // 계정분류
	    query += "|";
	    query += reqDept;                // 요청부서
	    query += "|";
	    
	    document.forms.processForm.nu_end_price.value =  f.nu_end_price.value;	    
	    document.forms.processForm.st_po_create_date.value = po_create_date;	  
	    document.forms.processForm.st_account_type_code.value =  f.st_account_type_code.value;	  
	    document.forms.processForm.gw_no_new.value =  f.gw_no_new.value;	  
	    document.forms.processForm.recv_flag_new.value =  f.recv_flag_new.value;	  
	    document.forms.processForm.as_flag_new.value =  f.as_flag_new.value;	      
	    document.forms.processForm.st_query.value = query;	  
	    
	    if($("#st_reqHold").val() == "REQ"){
		    kepAjaxFormCallTab("/mppo/saveInsertMergePxPo.do","processForm","SAVEINSERTMERGEPXPO","buyerMpPoOrderReq_tab2");   
	    }else{
	    	kepAjaxFormCallTab("/mppo/saveChangeMergePxPo.do","processForm","SAVEINSERTMERGEPXPO","buyerMpPoOrderReq_tab2");   
	    	
	    }
	},
	setResultCheckBdgtAmt:function(result,row){
		if(eval(result) < 1){
			//예산초과하여 수량변경을 할 수 없습니다.
            var text = "<%=CommonLang.msg("MSG212") %>";
    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
            mySheet2.SetCellValue(row,"RECV_QTY",mySheet2.GetCellValue(row,"TARGET_QTY"));
            mySheet2.SetCellValue(row,"AMT",mySheet2.GetCellValue(row,"TARGET_QTY")*mySheet2.GetCellValue(row,"UNIT_PRICE"));
            return;
		}else{
			//요청수량 변경사유를 입력해 주십시요
			var text = "<%=CommonLang.msg("MSG193")%>";
			openLayerPopText2(text,this.but1text,"tabs.buyerMpPoOrderReq_tab2.doPop('PrRecvReturnReasonPop');",this.but1width);
		}
	},
	setReturnReason:function(value){
		mySheet2.SetCellValue(this.grbRow,"RETURN_REASON",value);
	},
	prRecvReturnReasonResult:function(result){
		if(result=="OK"){
			mySheet2.SetCellValue(this.grbRow,"TEMP_QTY", mySheet2.GetCellValue(this.grbRow,"RECV_QTY"));
		}else{
			//예산이 부족하여 수량변경을 할 수 없습니다.예산을 확인하여 주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG195") %>";
    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
            mySheet2.SetCellValue(row,"RECV_QTY",mySheet2.GetCellValue(row,"TARGET_QTY"));
            mySheet2.SetCellValue(row,"AMT",mySheet2.GetCellValue(row,"TARGET_QTY")*mySheet2.GetCellValue(row,"UNIT_PRICE"));
            return;
		}
	},
	kepApprovalReturn:function(ERR,GW_NO){
		this.EndPassProcess(ERR,GW_NO)
	},
	EndPassProcess:function(ERR,GW_NO){
		if(ERR == "true"){
			this.ServerCall(GW_NO,"PS");
		}
	}
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
	}
	
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet2.SetColHidden("BUYER_NAME_LOC",false);
	}
	var budget_flag = "<%=budget_flag%>";
	if(budget_flag == "Y"){
		mySheet2.SetColHidden("BUDGET_DEPT_NAME",false);
		mySheet2.SetColHidden("ACCOUNT_NAME",false);
	}
	var bca00004 = "<%=bca00004%>";
	if(bca00004 == "true"){
		for(var i = 1; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i,"REF_PR_NO",mySheet2.GetCellValue(i,"REF_PR_TEXT"));
		}
	}
	
	var curDate = "<%=curDate%>";
	for(var i = 1 ; i<=mySheet2.RowCount(); i++){
		var status = mySheet2.GetCellValue(i,"STATUS_CODE");
		if(status == "STATUS01"){ //주문요청
			mySheet2.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE194")%>");
		}else if(status == "STATUS02"){ //요청반려
			mySheet2.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE192")%>");
		}else if(status == "STATUS03"){ //주문결재중
			mySheet2.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE195")%>");
		}else if(status == "STATUS04"){ //주문결재반려
			mySheet2.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE261")%>");
		}else if(status == "STATUS05"){ //주문완료
			mySheet2.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE1005")%>");
		}
		
		if(mySheet2.GetCellValue(i,"UNIT_PRICE") != mySheet2.GetCellValue(i,"PR_TARGET_PRICE")){
			mySheet2.SetCellValue(i,"PRICE_REMARK","주문단가 : "+mySheet2.GetCellValue(i,"PR_TARGET_PRICE"));
		}
		
	}
	tabs.buyerMpPoOrderReq_tab2.tot_order_amt = 0;
	$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원

	makePageIndex_v3( mySheet2 , tabs.buyerMpPoOrderReq_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerMpPoOrderReq_tab","2");	
}
//조회 후처리
function mySheet4_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
	}
	
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet4.SetColHidden("BUYER_NAME_LOC",false);
	}
	var bca00004 = "<%=bca00004%>";
	if(bca00004 == "true"){
		for(var i = 1; i<=mySheet4.RowCount(); i++){
			mySheet4.SetCellValue(i,"REF_PR_NO",mySheet2.GetCellValue(i,"REF_PR_TEXT"));
		}
	}
	
	for(var i = 1 ; i<=mySheet4.RowCount(); i++){
		var status = mySheet4.GetCellValue(i,"STATUS_CODE");
		if(status == "STATUS01"){ //주문요청
			mySheet4.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE194")%>");
		}else if(status == "STATUS02"){ //요청반려
			mySheet4.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE192")%>");
		}else if(status == "STATUS03"){ //주문결재중
			mySheet4.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE195")%>");
		}else if(status == "STATUS04"){ //주문결재반려
			mySheet4.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE261")%>");
		}else if(status == "STATUS05"){ //주문완료
			mySheet4.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE1005")%>");
		}
	}
	
	tabs.buyerMpPoOrderReq_tab2.excelDown();
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	tabs.buyerMpPoOrderReq_tab2.grbRow = Row;
	
	var buyer = mySheet2.GetCellValue(Row,"BUYER");
	var pr_no = mySheet2.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet2.GetCellValue(Row,"PR_SEQ");
	var gw_no = mySheet2.GetCellValue(Row,"GW_NO");
	var recv_flag = mySheet2.GetCellValue(Row,"RECV_FLAG");
	var po_remark = mySheet2.GetCellValue(Row,"PO_REMARK");
	
	var doc_type = mySheet2.GetCellValue(Row,"DOC_TYPE");
	var doc_type_remark = mySheet2.GetCellValue(Row,"DOC_TYPE_REMARK");
	
	var agent_code = mySheet2.GetCellValue(Row,"AGENT_CODE");
	
	if(column == "PR_NO"){ //PR번호 클릭 시
		if(pr_no != ""){
			if(gw_no != ""){
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,890,no"); 
			}else{
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,690,no"); 
			}
		}
	}else if(column == "PO_REMARK"){
		tabs.buyerMpPoOrderReq_tab2.popupSel = "poRemark";
		document.forms.poRemarkForm.remark.value = po_remark;
		openSearchPopupPost("/mppo/showBuyerMpPoOrderRemarkInsPop.do","poRemarkForm","showBuyerMpPoOrderRemarkInsPop","width=500,height=340,resizable=no,scrollbars=no");
	}else if(column == "DOC_TYPE"){
		if(doc_type == "Y"){
			document.forms.docTypeRemarkForm.remark.value = doc_type_remark;
			openSearchPopupPost("/mppo/showBuyerMpPoDocTypeRemarkPop_v2.do","docTypeRemarkForm","showBuyerMpPoDocTypeRemarkPop_v2","width=500,height=340,resizable=no,scrollbars=no");
		}
	}else if(column == "AGENT_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+agent_code; 
		openLayerPop(src,"800px","680px");
	}
	return;
}
function mySheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	tabs.buyerMpPoOrderReq_tab2.grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "RD_DATE"){ 
		var rd_date = mySheet2.GetCellValue(Row, "RD_DATE");
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		var gr_flag = mySheet2.GetCellValue(Row, "DOC_TYPE");
		var st_po_create_date = $("#imsi_po_create_date_2").val().replace(/[/]/gi,"");
		if(gr_flag == "Y" && st_po_create_date != ""){ //선입고여부
			if(rd_date < st_po_create_date && rd_date !=""){
				//수령희망일은 발주일 이후로 선택하셔야 합니다.
				var text = "<%=CommonLang.msg("MSG801")%>";
				openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
				mySheet2.SetCellValue(Row,"RD_DATE","");
		        mySheet2.SelectCell(Row,"RD_DATE");
		        return;
			}
		}else{
			if(rd_date < cur_date && rd_date !=""){
				//수령희망일은 현재일 이후로 선택하셔야 합니다.
				var text = "<%=CommonLang.msg("MSG444")%>";
				openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
				mySheet2.SetCellValue(Row,"RD_DATE","");
		        mySheet2.SelectCell(Row,"RD_DATE");
		        return;
			}
		}
		
	}else if(column == "RECV_QTY"){
		if(mySheet2.GetCellValue(Row,"RECV_QTY") > mySheet2.GetCellValue(Row,"TARGET_QTY")){
			//승인수량이 요청수량보다 많을 수 없습니다.
			var text = "<%=CommonLang.msg("MSG959")%>";
			openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
			mySheet2.SetCellValue(Row,"RECV_QTY",mySheet2.GetCellValue(Row,"TARGET_QTY"));
			return;
		}
		if(mySheet2.GetCellValue(Row,"RECV_QTY") <=0){
			//수량에 1 이상의 숫자를 입력해 주십시요
			var text = "<%=CommonLang.msg("MSG192")%>";
			openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,tabs.buyerMpPoOrderReq_tab2.but1func,tabs.buyerMpPoOrderReq_tab2.but1width);
			mySheet2.SetCellValue(Row,"RECV_QTY",mySheet2.GetCellValue(Row,"TARGET_QTY"));
			return;
		}
		
		var imsi_qty = mySheet2.GetCellValue(Row,"RECV_QTY");
		var imsi_buy_price = mySheet2.GetCellValue(Row,"UNIT_PRICE");
		var imsi_req_qty = mySheet2.GetCellValue(Row,"TARGET_QTY");
		var old_amt = imsi_req_qty * imsi_buy_price;
		var new_amt = imsi_qty * imsi_buy_price;
		mySheet2.SelectCell(Row,"AMT"); ;
		mySheet2.SetCellValue(Row,"AMT",new_amt);
		
		//합계금액 수정
		tabs.buyerMpPoOrderReq_tab2.tot_order_amt = 0;
		for(var i = mySheet2.HeaderRows(); i<=mySheet2.LastRow(); i++){
			if(mySheet2.GetCellValue(i,"sStatus") != "R") continue;
			if(mySheet2.GetRowHidden(i)) continue;
			
			if(mySheet2.GetCellValue(i,"SELECTED") == 1){
				tabs.buyerMpPoOrderReq_tab2.tot_order_amt += mySheet2.GetCellValue(i,"AMT");
			}
		}
		$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tabs.buyerMpPoOrderReq_tab2.tot_order_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
		
// 		var buyer = mySheet2.GetCellValue(Row,"BUYER"); //row별 고객사가 아니라 sessionComCode?? TGCM 있는 고객사들은 로그인 고객사로 처리하는지 확인..
		var buyer = $("#st_buyer_2").val();
		var account_type = mySheet2.GetCellValue(Row,"ACCOUNT_TYPE");
		var budget_dept = mySheet2.GetCellValue(Row,"BUDGET_DEPT");
		
		var pr_no = mySheet2.GetCellValue(Row,"PR_NO");
		var pr_seq = mySheet2.GetCellValue(Row,"PR_SEQ");
		
		if(mySheet2.GetCellValue(Row,"PLAN_AMT_FLAG")=="Y" && mySheet2.GetCellValue(Row,"BDGT_FLAG")=="Y"){
			document.forms.processForm.st_buyer.value  = buyer;            
		    document.forms.processForm.st_account_type.value  = account_type;            
		    document.forms.processForm.st_budget_dept.value  = budget_dept;            
		    document.forms.processForm.st_old_amt.value  = old_amt;            
		    document.forms.processForm.st_new_amt.value  = new_amt;
		    kepAjaxFormCallTab("/mppo/buyerAdminBdgtTempQtyCheck.do","processForm","BUYERADMINBDGTTEMPQTYCHECK","buyerMpPoOrderReq_tab2");
		}else{
			if(mySheet2.GetCellValue(Row,"RECV_QTY") == mySheet2.GetCellValue(Row,"TARGET_QTY")){
				return;
			}else{
				//요청수량 변경사유를 입력해 주십시요
				var text = "<%=CommonLang.msg("MSG193")%>";
				openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab2.but1text,"tabs.buyerMpPoOrderReq_tab2.doPop('PrRecvReturnReasonPop');",tabs.buyerMpPoOrderReq_tab2.but1width);
			}
		}
	}
// 	else if(column == "IMSI_PO_CREATE_DATE"){
// 		mySheet2.SetCellValue(Row,"ST_PO_CREATE_DATE",Value);
// 	}
	return;
}

function mySheet2_OnBeforeCheck(row, col) {
	var tot_order_amt = Number(tabs.buyerMpPoOrderReq_tab2.tot_order_amt) || 0;
	var amt = Number(mySheet2.GetCellValue(row,"AMT")) || 0;
	
	if(mySheet2.GetCellValue(row,"SELECTED") == 0){ //체크전에 확인하는거라 0이면 -> 이후 체크 된다는 뜻임
		tot_order_amt += amt;
	}else if(mySheet2.GetCellValue(row,"SELECTED") == 1){ //체크전에 확인하는거라 1이면 -> 이후 체크 해제된다는 뜻임
		tot_order_amt -= amt;
	}
	
	tabs.buyerMpPoOrderReq_tab2.tot_order_amt = tot_order_amt;
	$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tabs.buyerMpPoOrderReq_tab2.tot_order_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
}
function mySheet2_OnCheckAllEnd(col, value) {
	tabs.buyerMpPoOrderReq_tab2.tot_order_amt = 0;
	if(value == 1){ // 체크하는 경우
		var checkRows = mySheet2.FindCheckedRow("SELECTED");
	
		if(checkRows != ""){
			var arrRow = checkRows.split("|");
			for(var i = 0; i<arrRow.length; i++){
				if(mySheet2.GetRowHidden(arrRow[i])){
					mySheet2.SetCellValue(arrRow[i],"SELECTED",0,0);
				}else{
					tabs.buyerMpPoOrderReq_tab2.tot_order_amt += Number(mySheet2.GetCellValue(arrRow[i],"AMT")) || 0;
				}
			}
		}
	}
	
	$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tabs.buyerMpPoOrderReq_tab2.tot_order_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원
}

</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_user_id" id="st_user_id_2" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept" id="st_user_dept_2" value="<%=SessionUserDept%>">

		<input type="hidden" name="st_buyer" id="st_buyer_2"   value ="${sessionInfo.comCode}">
		<input type="hidden" name="st_userid"    value ="${sessionInfo.userId}"> 
        <input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
        <input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_2" value="<%=group_mng_flag%>">
        <input type="hidden" name="st_group_info" id="st_group_info_2" value="">
        <input type="hidden" name="st_all_page" id="st_all_page_2" value="N">
        
        <input type="hidden" name="page_type"value ="">
		<input type="hidden" name="st_query"            value="">
		<input type="hidden" name="st_y_position"       value="">
		<input type="hidden" name="st_bdgt_query"       value="">   <!-- 예산 계정 체크위해 추가 20050401 -->
		<input type="hidden" name="st_pr_return_type"   value="PR"> <!-- 예산 계정 PR ==> PR_NO , PX ==> REF_NO 이용해서 , 구매요청 반려시 예산 차감 -->
		<input type="hidden" name="st_account_type_code"    value="">
		<input type="hidden" name="comCode"                value="<%=SessionComCode%>">
		<input type="hidden" name="userID"                  value="<%=SessionUserId%>">
		<input type="hidden" name="userDept"                value="<%=SessionUserDept%>">
		<input type="hidden" name="reqDept"                 value="">
		<input type="hidden" name="st_byca_comorg_code"     value="<%=SessionComorgCode%>">
		<input type="hidden" name="st_byca_comorg_level"    value="<%=SessionComorgLevel%>">
		<input type="hidden" name="st_using_catal_type"     value="<%=using_catal_type%>">
		<input type="hidden" name="st_add_user_tel"         value="<%=userTel%>">
		<input type="hidden" name="st_agent_open_flag"      value="">
		<input type="hidden" name="file_get_y"              value="">
		<input type="hidden" name="reject"                  value="N">
		<input type="hidden" name="x"                       value="">
		<input type="hidden" name="y"                       value="">
		<input type="hidden" name="st_check_setQuery"       value="">
		
		<input type="hidden" name="st_gr_flag" size="10" value="N">
		<!--   Login Buyer Code 입력 -->
		<input type="hidden" name="st_notify"  value="<%=SessionComCode%>">
		<!--   Sample Flag 입력 -->
		<input type="hidden" name="st_sample_flag" value = "N">
		<!-- Current Date -->
		<!--   new_item : JTABLE의 제품코드 click시에 사용   -->
		<input type="hidden" name="chknc"           value="NO">
		<input type="hidden" name="y"               value="null">
		<input type="hidden" name="list"            value="create">
		<input type="hidden" name="file_get_y"      value="">
		<input type="hidden" name="st_ref_no_sub"   value="">
		<input type="hidden" name="st_item_no_sub"  value="">
		<input type="hidden" name="gw_no_new"       value="">
		<input type="hidden" name="recv_flag_new"   value="">
		<input type="hidden" name="as_flag_new"     value="">
		<input type="hidden" name="payment_new"     value="">
		<input type="hidden" name="nu_end_price"    value="">
		<!--   이니시스 거래명세서 출력시 사용할 PXnumber -->
		<input type="hidden" name="pxnumber"  value="">
		<!--   일부품목 카드 결제를 위한 변수  2002/07/27   -->
		<input type="hidden" name="multi_flag"    value="">     <!--  구매대행발주와  카드결제 발주가 동시에 생성되는지 여부 -->
		<input type="hidden" name="payment_flag"  value="">     <!--  카드결제 여부                                   -->
		<input type="hidden" name="cc_flag"       value="">     <!--  카드결제 품목 리스트                                -->
		<input type="hidden" name="cs_flag"       value="">     <!--  현금결제 품목 리스트                                -->
		<input type="hidden" name="popup_flag"    value="">     <!--  팝업창 종료여부(임시저장목록에서 발주시 사용)       -->
		<input type="hidden" name="delete_flag"   value="">     <!--  현금결제 품목 리스트        -->
        
	<div id="Search2" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG790")%><!--주문요청 건을 조회하고 수령희망일, 발주부서, 승인수량 등을 변경해 주문하거나 요청을 반려할 수 있습니다.--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="66px" />
          <col width="155px" />
          <col width="56px" />
          <col width="320px" />
          <col width="66px" />
          <col width="135px" />
          
          <col width="56px" />
          <col width="200px" />
          <col width="66px" />
          <col width="160px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
          <td colspan="5">
            <select name="st_date_type" id="st_date_type_2" class="Select40" style=" float:left; width:125px; margin-right:7px" disabled>
              <option value="PR_DATE"><%=CommonLang.get("HTITLE1235") %><!-- 주문요청일 --></option>
            </select>
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " id="st_from_date_2" name="st_from_date" type="text" placeholder="" readonly /><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text"  id="st_to_date_2" name="st_to_date" placeholder="" readonly /><span></span></div>
            </div>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
          <td>
            <input type="text" class="input40"  value="" id="st_req_user_name_2" name="st_req_user_name" style=" width:163px;" onKeyDown="kepEnter_v3('buyerMpPoOrderReq_tab2')">
<!--             <input type="hidden"  value="" id="st_req_user_id_2" name="st_req_user_id" style=" width:113px;" readonly> -->
<!--             <button type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.doPop('reqUser'); return false;"></button> -->
          </td>
          <th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
          <td><div class="TabShIconTwo" style="width:163px ">
            <input type="text"  value="" id="st_req_dept_name_2" name="st_req_dept_name" style=" width:95px;" readonly>
            <input type="hidden"  value="" id="st_req_dept_code_2" name="st_req_dept_code" style=" width:95px;" readonly>
            <button class="Search" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.doPop('reqDepartment'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.doAction('reqDepartmentErase'); return false;"></button></div>
          </td>
        </tr>
		<tr>
          <th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
          <td>
          	<select name="st_status" id="st_status_2" class="Select40" style="width:125px;">
          	  <option value="GA,PT,PR"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="GA,PT"><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></option>
              <option value="PR"><%=CommonLang.get("HTITLE261") %><!-- 주문결재반려 --></option>
            </select>
          </td>
          <th><%=CommonLang.get("HTITLE552") %><!-- 검색어 --></th>
          <td >
            <select name="st_search_type" id="st_search_type_2" class="Select40" style=" float:left;width:140px; margin-right:5px">
              <option value="PR"><%=CommonLang.get("HTITLE1179") %><!-- 주문요청번호 --></option>
              <option value="DE"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
              <option value="RN"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></option>
              <option value="BC"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
            </select>  
            <input class="input40" style="width:120px" name="st_search_code" id="st_search_code_2" type="text" onKeyDown="kepEnter_v3('buyerMpPoOrderReq_tab2')"/>
          </td>  
          <th><%=CommonLang.get("HTITLE253") %><!-- 결재유무 --></th>
          <td >
            <select name="st_gyuljae" id="st_gyuljae_2" class="Select40" style=" float:left;width:93px; margin-right:5px">
              <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="Y">Y</option>
              <option value="N">N</option>
            </select>  
          </td>
          <%if(group_mng_flag.equals("Y")) {%>
          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
	      <td>
		      <select name="st_com_code" id="st_com_code_2" class="Select40" style="width:186px;" onchange="javascript:tabs.buyerMpPoOrderReq_tab2.buyerChange();">
		        <%= CommonUtil.getCode3ComboList(request.getParameter("buyer"), "ALL", "TGCM",request.getParameter("userid"), "ICOMCOD3", request.getParameter("buyer"), "") %>
		       </select>
	      </td>
		  <%}else{ %>
		  <input type="hidden" name="st_com_code" id="st_com_code_2" value="${sessionInfo.comCode}">
		  <%} %>
		</tr>
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button>
      </div>
      <div class="ArraySub mt30 mb10">
        <div class="buttonLeft">
        <%if(p170000001 ==false){%>
          <button class="But_ExcelDown40" onclick="tabs.buyerMpPoOrderReq_tab2.search2(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %> 
          <button class="ButOutline_Medium" onclick="tabs.buyerMpPoOrderReq_tab2.doPop('changeRdDate');return false;"><%=CommonLang.get("HTITLE1245") %><!-- 납품요청일 변경 --></button>
        <%if(group_mng_flag.equals("N")){%> 
          <button class="ButOutline_Medium" onclick="tabs.buyerMpPoOrderReq_tab2.doPop('transferDept');return false;"><%=CommonLang.get("HTITLE1246") %><!-- 발주부서 이관 --></button> 
        <%} %>
        <%if(p060000011 == true || p060000017 == true) {%>
           <button class="ButOutline_Medium" onclick="tabs.buyerMpPoOrderReq_tab2.PRSheetMsg();return false;"><%=CommonLang.get("HTITLE664") %><!-- 품의서 --></button> 
        <%} %>
        </div>
        <div class="buttonRight">
         <button class="ButOutline_Medium" onclick="tabs.buyerMpPoOrderReq_tab2.doPop('prReturn');return false;"><%=CommonLang.get("HTITLE1181") %><!-- 주문요청반려 --></button> 
         <button class="ButPrimary_Medium" onclick="tabs.buyerMpPoOrderReq_tab2.doAction('createPR');return false;"><%=CommonLang.get("HTITLE197") %><!-- 주문 --></button> 
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt"></span></div>
	   </div> 
      <div class="IBSheetBuyer" style="display: none;">
      	<script type="text/javascript">
          	createIBSheet("mySheet4", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 --> 
      <div class="PagingCenter mt10" id="pageindex2"></div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
    
<div class="DIVpopup-overlay popupOverlay" id="confirmPrSheetAreaOverlay" style="display: none;"></div>
<div class="DIVpopup" id="confirmPrSheetArea" style="display: none;">
  <div class="wrapPopupAlert">
    <div class="AlertTxtSmall">
    <span id="confirmPrSheetMsg" style="white-space: pre-line;"><%=CommonLang.msg("MSG805")%><!--품의서 양식을 선택해주세요.--></span></br>
	  <div class="Search-select mt20" id="prSheet" style="width:310px; margin:0 auto">
	  <label class="RadioMediumLabel" style="width:120px"><input type="radio" id="prsheetreport" name="prsheetreport" value="dept" ><span class="RadioMediumTxt"></span><%=CommonLang.get("HTITLE661") %><!-- 부서별 --></label>
	  <label class="RadioMediumLabel" style="width:120px"><input type="radio" id="prsheetreport" name="prsheetreport" value="item" ><span class="RadioMediumTxt"></span><%=CommonLang.get("HTITLE662") %><!-- 품목별 --></label>
	  <br/>
	  <br/>
	  <label class="RadioMediumLabel" style="width:120px"><input type="radio" id="prsheetreport" name="prsheetreport" value="no" ><span class="RadioMediumTxt"></span><%=CommonLang.get("HTITLE663") %><!-- 품의번호별 --></label>
	  <label class="RadioMediumLabel" style="width:120px"><input type="radio" id="prsheetreport" name="prsheetreport" value="dept_item" checked><span class="RadioMediumTxt"></span><%=CommonLang.get("HTITLE661") %><!-- 부서 -->&<%=CommonLang.get("HTITLE662") %><!-- 품목별 --></label>
	  </div> 
    </div>
    <div class="h20"></div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.PRSheetCancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.PRSheet(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
    </div>
  </div>
</div>

<div class="DIVpopup-overlay popupOverlay" id="grDateSelOverlay" style="display: none;"></div>
<div class="DIVpopup" id="grDateSel" style="display: none;">
  <div class="wrapPopupAlert small-calendar">
    <div class="AlertTxtSmall" style="display: flex; flex-direction:column; align-items:center;">
    <div class="OptionTit_Date"><%=CommonLang.get("HTITLE1432") %><!-- 선입고 날짜 --></div>
        <div class="datepicker-wrap" style=" width:150px; margin-right:8px"><div class="date-input" data-datepicker style=" width:140px;"><input type="text" id="imsi_po_create_date_2" name="imsi_po_create_date" placeholder="" readonly /><span> </span></div></div>
    </div>
    <div class="h20"></div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.grDateCancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:tabs.buyerMpPoOrderReq_tab2.grDateSel(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
    </div>
  </div>
</div> 
</form>


 
<form name = "popupForm" id="popupForm" method = "post">
<input type="hidden" id="info" name="info" value="" />
<input type="hidden" id="tab_id" name="tab_id" value="buyerMpPoOrderReq_tab2" />
<input type="hidden" id="popup_comCode" name="popup_comCode" value="<%=SessionComCode%>" />

<input type="hidden" id="return_reason" name="return_reason" value="" />
<input type="hidden" id="recv_qty" name="recv_qty" value="" />
<input type="hidden" id="st_pr_no" name="st_pr_no" value="" />
<input type="hidden" id="st_pr_seq" name="st_pr_seq" value="" />
<input type="hidden" name="st_com_code" value="${sessionInfo.comCode}"> 
<input type="hidden" id="st_old_amt" name="st_old_amt" value="" />
<input type="hidden" id="st_new_amt" name="st_new_amt" value="" />
<input type="hidden" id="st_account_type" name="st_account_type" value="" />
<input type="hidden" id="st_budget_dept" name="st_budget_dept" value="" />
<input type="hidden" id="st_row" name="st_row" value="" />
<input type="hidden" id="st_budget_flag" name="st_budget_flag" value="" />

</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_query" id="st_query" value="" /> 
	<input type="hidden" name="st_purchaserDept" id="st_purchaserDept" value="" /> 
	<input type="hidden" name="st_buyer" id="st_buyer" value="" /> 
	<input type="hidden" name="st_pr_return_type" id="st_pr_return_type" value="" />	
	<input type="hidden" name="st_bdgt_pr_no" id="st_bdgt_pr_no" value="" />
	<input type="hidden" name="recvFlag" id="recvFlag" value="" />
	<input type="hidden" name="end_price" id="end_price" value="" /> 	 
	<input type="hidden" name="TYPE" id="TYPE" value="" /> 
	<input type="hidden" name="COM_CODE" id="COM_CODE" value="" />	
	<input type="hidden" name="st_account_type" id="st_account_type" value="" /> 
	<input type="hidden" name="st_budget_dept" id="st_budget_dept" value="" /> 
	<input type="hidden" name="st_old_amt" id="st_old_amt" value="" /> 
	<input type="hidden" name="st_new_amt" id="st_new_amt" value="" />  
	<input type="hidden" name="nu_end_price" id="nu_end_price" value="" />   	
	<input type="hidden" name="st_po_create_date" id="st_po_create_date" value="<%=curDate%>" />   
	<input type="hidden" name="st_account_type_code" id="st_account_type_code" value="" />
	<input type="hidden" name="gw_no_new" id="gw_no_new" value="" />   	
	<input type="hidden" name="recv_flag_new" id="recv_flag_new" value="" />   	   	
	<input type="hidden" name="as_flag_new" id="as_flag_new" value="" />   	   	 
	<input type="hidden" name="st_reqHold" id="st_reqHold" value="" />   
<!-- 	<input type="hidden" name="st_reqHold" id="st_reqHold" value="REQ" />	   	 	 -->
	<input type="hidden" name="st_budget_dept_flg" id="st_budget_dept_flg" value="" />   	   	 	
</form>
<form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>
<form name="poRemarkForm" id="poRemarkForm" method="post">	 
	<input type="hidden" name="remark" value=""> 
	<input type="hidden" name="tab_id" value="buyerMpPoOrderReq_tab2">
	
</form>
<form name="docTypeRemarkForm" id="docTypeRemarkForm" method="post">	 
	<input type="hidden" name="remark" value=""> 
	
</form>
