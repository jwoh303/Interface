<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 전체 탭
* 기능 : 전체 탭
* 프로그램 ID : BU0101001
* 담당자 : 최찬규
* 착수일 : 2026-03-30
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

	//SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", request.getParameter("userId"), request.getParameter("buyer"));
	
	String group_mng_flag = "N";
	
	if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
	}
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	
	boolean bca00008 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"BCA00008");
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerMpSoOrderProgress_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMpSoOrderProgress_tab1.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	grbStatus: "",
	init:function(){
		if($("#st_from_date_1").val() ==  ""){
			$("#st_from_date_1").val(kepToMonthAdd("1","M"));
			$("#st_to_date_1").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet1 = {};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet1.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"NO",					Header:"<%=CommonLang.get("HTITLE44")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true} /*번호*/
				,{ Align:"Center",	SaveName:"STATUS_TEXT",				Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*진행상태*/
				,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"<%=CommonLang.get("HTITLE306")%>",		SaveName:"DOC_TYPE_IMAGE"}/*유형*/
				,{ Align:"Left",	SaveName:"BUYER_NAME",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*고객사명*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*주문요청번호*/
				,{ Align:"Center",	SaveName:"PO_NO",			Header:"<%=CommonLang.get("HTITLE203")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*발주번호*/
				,{ Align:"Center",	SaveName:"INV_NO",				Header:"<%=CommonLang.get("HTITLE784")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false , FontColor:"#3a72c7", Cursor:"Pointer"} /*거래명세서번호*/
				,{ Align:"Center",	SaveName:"AGENT_TEXT",			Header:"<%=CommonLang.get("HTITLE567")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*협력사명*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				,{ Align:"Right",	SaveName:"TARGET_QTY",				Header:"<%=CommonLang.get("HTITLE651")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*요청수량*/
				,{ Align:"Right",	SaveName:"ITEM_QTY",				Header:"<%=CommonLang.get("HTITLE217")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*발주수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"ITEM_AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
				,{ Align:"Center",	SaveName:"PR_ADD_DATE",			Header:"<%=CommonLang.get("HTITLE1235")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문요청일*/
				,{ Align:"Center",	SaveName:"PO_ADD_DATE",			Header:"<%=CommonLang.get("HTITLE185")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*주문일*/
				,{ Align:"Center",	SaveName:"RD_DATE",			Header:"<%=CommonLang.get("HTITLE831")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*수령희망일*/
				,{ Align:"Center",	SaveName:"CD_DATE",			Header:"<%=CommonLang.get("HTITLE206")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*납품예정일*/
				,{ Align:"Left",	SaveName:"REQ_USER_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
				,{ Align:"Left",	SaveName:"REQ_USER_DEPT",				Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서*/
				,{ Align:"Left",	SaveName:"PURCHASER_NAME",				Header:"<%=CommonLang.get("HTITLE187")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주자*/
				,{ Align:"Left",	SaveName:"PURCHASER_DEPT",				Header:"<%=CommonLang.get("HTITLE188")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주부서*/
				,{ Align:"Left",	SaveName:"LEGACY_PO_NO",				Header:"<%=CommonLang.get("HTITLE885")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*I/F발주번호*/
				,{ Align:"Center",	SaveName:"CART_BUTTON",			Header:"<%=CommonLang.get("HTITLE11")%>",				Type:"Image",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Cursor:"Pointer", ImgHeight:20}/*장바구니*/
				,{ Align:"Center",	SaveName:"CANCEL_BUTTON",			Header:"<%=CommonLang.get("HTITLE1257")%>",				Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:false}/*취소.교환.반품 요청*/
				,{ Align:"Center",	SaveName:"CANCEL_FLAG",			Header:"<%=CommonLang.get("HTITLE1257")%>",				Type:"Text",		Width:130,	Edit:false,	EditLen:100,	Hidden:true}/*취소.교환.반품 요청*/
				,{ Align:"Left",	SaveName:"POHD_REMARK",				Header:"<%=CommonLang.get("HTITLE1532")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true} /*실제요청자*/
				
				,{ Align:"Center",	SaveName:"STATUS_CODE",			Header:"STATUS_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GW_NO",			Header:"GW_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_SEQ",			Header:"PR_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PO_SEQ",			Header:"PO_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"INV_SEQ",			Header:"INV_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RE_WMRE_TYP",			Header:"RE_WMRE_TYP",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RE_PO",			Header:"RE_PO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_JOBDATE",			Header:"PR_JOBDATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PO_JOBDATE",			Header:"PO_JOBDATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IV_JOBDATE",			Header:"IV_JOBDATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"WMS_JOBDATE",			Header:"WMS_JOBDATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GR_JOBDATE",			Header:"GR_JOBDATE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"REF_NO",			Header:"REF_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RECV_FLAG",			Header:"RECV_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"CONTRACT_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",			Header:"AGENT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"STATUS_ROW_CNT",			Header:"STATUS_ROW_CNT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_STTS",			Header:"PR_STTS",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PX_STTS",			Header:"PX_STTS",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IV_STTS",			Header:"IV_STTS",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GR_STTS",			Header:"GR_STTS",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PURCHASER_ID",	Header:"PURCHASER_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"SELLER",			Header:"SELLER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",			Header:"WAREHOUSE_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				
		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
		IBS_InitSheet(mySheet2, initsheet1, this.pagingMode);
		
	},
	search:function(value,init){ //메인화면 대시보드에서 누를 경우 init에 값 넣어줌
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		if(value != "" && value != null && init != "true"){
			if(mySheet2.RowCount() == 0){
				var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
			}
		}
		$("#st_status_1").val(value);
		this.grbStatus = value;
		$("#st_all_page").val("N");
		$("#st_excel_yn").val("N");
		
		var com_code = $("#st_com_code_1").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_1").val(com_code);
		}else{
			$("#st_group_info_1").val("");
		}
		this.current_page = 1;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mpso/getBuyerMpSoOrderProgressList_v2.do?page="+this.current_page, this.pagingMode);
	},
	search2:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_status_1").val("");
		$("#st_all_page").val("Y");
		kepSearch_v2(document.searchCondition1, mySheet2, "/mpso/getBuyerMpSoOrderProgressList_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		kepMonth_v2('st_from_date_1','st_to_date_1','1');
		$("#st_pur_dept_code_1").val("");
		$("#st_req_dept_code_1").val("");
		mySheet1.RemoveAll();
		mySheet2.RemoveAll();
		$("#st_own_search_flag").val("Y");
		$("#st_ing_search_flag").val("N");
		$("#st_own_check").attr("checked",true);
		$("#st_ing_check").attr("checked",false);
		for(var i = 1; i<=8; i++){
			$("#cnt_"+i).html("0");
		}
		$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+"0"+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : 0원
	},
	doAction:function(str){
		switch (str) {
		case "reqDepartmentErase":
			$("#st_req_dept_code_1").val("");
			$("#st_req_dept_name_1").val("");
			break;
		case "purDepartmentErase":
			$("#st_pur_dept_code_1").val("");
			$("#st_pur_dept_name_1").val("");
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_1").val();
		if(com_code == ""){
			var text = "<%=CommonLang.msg("MSG239")%>";//고객사를 전체 아닌 값으로 선택해야 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		switch (str) {
		case "purDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpSoOrderProgress_tab1", "720,580,no"); 
			break;
		case "reqDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpSoOrderProgress_tab1", "720,580,no"); 
			break;
		case "purUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpSoOrderProgress_tab1", "780,550,no");
			break;
		case "reqUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpSoOrderProgress_tab1", "780,550,no");
			break;
		default:
			break;
		}
	},
	saveBuyerPrCancel:function(){
		closePopText1();
		document.forms.processForm.st_buyer.value = mySheet1.GetCellValue(this.grbRow,"BUYER");
		document.forms.processForm.st_pr_no.value = mySheet1.GetCellValue(this.grbRow,"PR_NO");
		document.forms.processForm.st_pr_seq.value = mySheet1.GetCellValue(this.grbRow,"PR_SEQ");
		kepAjaxFormCallTab("/mpso/saveBuyerPrCancel.do","processForm","SAVE","buyerMpSoOrderProgress_tab1");
	},
	pageSearch:function(param){
		$("#st_status_1").val(this.grbStatus);
		$("#st_all_page").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mpso/getBuyerMpSoOrderProgressList_v2.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if (this.popupSel == "purDepartment") {
			$("#st_pur_dept_code_1").val(value1);
			$("#st_pur_dept_name_1").val(value2);
		} else if(this.popupSel == "reqDepartment") {
			$("#st_req_dept_code_1").val(value1);
			$("#st_req_dept_name_1").val(value2);
		}else if(this.popupSel == "purUser") {
			$("#st_pur_user_id_1").val(value1);
			$("#st_pur_user_name_1").val(value2);
		}else if(this.popupSel == "reqUser") {
			$("#st_req_user_id_1").val(value1);
			$("#st_req_user_name_1").val(value2);
		}
	},
	kepAjaxSuccess:function(pMethod , response){
		var sMsg = response.msg.MSG;   
		if(pMethod == "SAVE"){
			if (sMsg == "UPDATE_OK"){
				if(pMethod == "SAVE"){
					var text = "<%=CommonLang.msg("MSG507") %> "; //정상적으로 처리되었습니다. 
					openLayerPopText2(text,this.but1text,this.but1funcSearch,this.but1width);
				}
			} else {
				this.search();
			}  
		}else if(pMethod == "CsaveProcess"){
			if (sMsg == "CREATE_OK"){
				//장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?
				var text = "<%=CommonLang.msg("MSG695")%>" +" "+ "<%=CommonLang.msg("MSG364")%>"; 
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerMpSoOrderProgress_tab1.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			} else{
				//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
				var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
				var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
				var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	         	var but1funcC = "javascript:tabs.buyerMpSoOrderProgress_tab1.goCart(); return false;";
	         	var but2funcC = "javascript:closePopText1(); return false;";
	         	var but1widthC = "120px";
	         	var but2widthC = "120px";
	         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			}
		} 
	    
	},
	kepAjaxError:function(pMethod , response){
		//오류발생하였습니다.다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG163") %>  ";  
		 openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	},
	cartInsert:function(){
		closePopText1();
		
		var query = "";
		query += mySheet1.GetCellValue(this.grbRow,"BUYER_ITEM_NO") + "@@" + "1" + "@@" + mySheet1.GetCellValue(this.grbRow,"AGENT_CODE") + "@@" + mySheet1.GetCellValue(this.grbRow,"CONTRACT_NO") + "@@" + mySheet1.GetCellValue(this.grbRow,"CONTRACT_SEQ") + "@@" + mySheet1.GetCellValue(this.grbRow,"BYIT_COMORG_CODE");
		query += "&&";
		
		document.forms.processForm.st_pf_my_group.value = "";
		document.forms.processForm.st_use_flag.value = "C"; 
		document.forms.processForm.st_query2.value = query;
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCallTab("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess","buyerMpSoOrderProgress_tab1");
	},
	goCart:function(){
		closePopText1();
		location.href = "<%=p060000036%>";
	},
	excelDown:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		$("#st_status_1").val(this.grbStatus);
		$("#st_all_page").val("N");
		$("#st_excel_yn").val("Y");
		
		document.forms.searchCondition1.action = "/mpso/excelBuyerMpSoOrderProgressList_v2.do";
		document.forms.searchCondition1.submit();
		
	},
	setFlag:function(flag){
		if(flag == "1"){
			if($("#st_own_check").is(":checked")) {
				$("#st_own_search_flag").val("Y");		
			} else {
				$("#st_own_search_flag").val("N");
			}
		}else {
			if($("#st_ing_check").is(":checked")) {
				$("#st_ing_search_flag").val("Y");		
			} else {
				$("#st_ing_search_flag").val("N");
			}
		}
		
	},
	buyerChange:function(){
		$("#st_req_dept_code_1").val("");
		$("#st_req_dept_name_1").val("");
		$("#st_pur_dept_code_1").val("");
		$("#st_pur_dept_name_1").val("");
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var p060000091 = $("#p060000091").val();
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet1.SetColHidden("BUYER_NAME",false);
	}
	
	var bca00008 = "<%=bca00008%>"; //실제요청자 컬럼 노출(pohd.remark)
	if(bca00008 == "true"){
		mySheet1.SetColHidden("POHD_REMARK",false);
	}
	
	var tot_amt = 0;
	var startRow = mySheet1.HeaderRows();
	var endRow = mySheet1.LastRow();
	
	for(var i = startRow; i<=endRow; i++){
		//조회된 데이터 행(status:R)이 아닌 경우 제외(필터행,합계행 등)
		if(mySheet1.GetCellValue(i,"sStatus") != "R") continue;
		
		//필터링 등으로 화면에서 숨겨진 행 제외
		if(mySheet1.GetRowHidden(i)) continue;
		
		//정상데이터 금액 합산(Number 로 NaN방지)
		tot_amt += Number(mySheet1.GetCellValue(i,"ITEM_AMT")) || 0;
		
		mySheet1.SetCellValue(i,"CART_BUTTON","/resources/imgs/UserCart.png");
		
		var status = mySheet1.GetCellValue(i,"STATUS_CODE");
		var po_no = mySheet1.GetCellValue(i,"PO_NO");
		var re_po = mySheet1.GetCellValue(i,"RE_PO");
		var re_wmre_typ = mySheet1.GetCellValue(i,"RE_WMRE_TYP");
		if(re_wmre_typ == "WMRE_CODE1"){ // 반품 확인중
			re_wmre_typ = "<%=CommonLang.get("HTITLE1248")%>";
		}else if(re_wmre_typ == "WMRE_CODE2"){ // 교환 확인중
			re_wmre_typ = "<%=CommonLang.get("HTITLE1249")%>";
		}else if(re_wmre_typ == "WMRE_CODE3"){ //주문취소 확인중
			re_wmre_typ = "<%=CommonLang.get("HTITLE1250")%>";
		}
		
		
		if(po_no != "" && re_po == "Y"){
			if(status == "PX10" || status == "PX20"){ //주문취소
				mySheet1.SetCellValue(i,"CANCEL_FLAG","2");
				mySheet1.SetCellValue(i,"CANCEL_BUTTON","<%=CommonLang.get("HTITLE225")%>");
				mySheet1.SetCellFontColor(i, "CANCEL_BUTTON", "#3a72c7");
				mySheet1.SetCellCursor(i, "CANCEL_BUTTON", "Pointer");
				mySheet1.SetCellFontUnderline(i,"CANCEL_BUTTON",1);
			}else if(status == "PX30" || status == "PX40" || status == "PX50" || status == "PX60" || status == "PX70" || status == "GR10" || status == "GR20"){//교환/반품
				mySheet1.SetCellValue(i,"CANCEL_FLAG","3");
				mySheet1.SetCellValue(i,"CANCEL_BUTTON","<%=CommonLang.get("HTITLE503")%>");
				mySheet1.SetCellFontColor(i, "CANCEL_BUTTON", "#3a72c7");
				mySheet1.SetCellCursor(i, "CANCEL_BUTTON", "Pointer");
				mySheet1.SetCellFontUnderline(i,"CANCEL_BUTTON",1);
			}
		}else if(status == "PR50"){
			if(p060000091 == "false"){ //주문요청취소 버튼 제어 특수로직
				mySheet1.SetCellValue(i,"CANCEL_FLAG","1");
				mySheet1.SetCellValue(i,"CANCEL_BUTTON","<%=CommonLang.get("HTITLE1180")%>"); //주문요청취소
				mySheet1.SetCellFontColor(i, "CANCEL_BUTTON", "#3a72c7");
				mySheet1.SetCellCursor(i, "CANCEL_BUTTON", "Pointer");
				mySheet1.SetCellFontUnderline(i,"CANCEL_BUTTON",1);
			}
		}else {
			mySheet1.SetCellValue(i,"CANCEL_BUTTON",re_wmre_typ);
		}
	}
	
	$("#tot_amt").html("<%=CommonLang.get("HTITLE1469")%>"+ " : "+kepCommaNum(tot_amt)+"<%=CommonLang.get("HTITLE660")%>");// 합계금액 : x원

	makePageIndex_v3( mySheet1 , tabs.buyerMpSoOrderProgress_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerMpSoOrderProgress_tab","1");	
	tabs.buyerMpSoOrderProgress_tab1.search2(); //대시보드를 위한 search
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpSoOrderProgress_tab1.but1text,tabs.buyerMpSoOrderProgress_tab1.but1func,tabs.buyerMpSoOrderProgress_tab1.but1width);
	}
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var cnt = [0,0,0,0,0,0,0,0,0];
	
	for(var i = 1; i<= mySheet2.RowCount(); i++){
		var status = mySheet2.GetCellValue(i,"STATUS_CODE");
		
		if(status == "PR10" || status == "PR50" || status == "PR60" || status == "PR80"){ //주문요청 = {요청결재중, 주문요청, 주문결재중, 발주대기}
			cnt[1]++;
		}else if(status == "PR40" || status == "PR90"){ //주문요청취소 = {상신취소, 주문요청취소}
			cnt[2]++;
		}else if(status == "PR20" || status == "PR30" || status == "PR100"){ //주문요청반려 = {요청결재반려, 요청반려, 주문결재반려}
			cnt[3]++;
		}else if(status == "PX10"){ //주문완료 = {주문}
			cnt[4]++;
		}else if(status == "PX20"){ //품목준비중 = {주문접수(물품준비중)}
			cnt[5]++;
		}else if(status == "PX30" || status == "PX40" || status == "PX50" || status == "PX60"){ //배송중 = {거래명세서생성(배송중), 거래명세서생성(협력사->KeP물류센터), KeP물류센터 입고완료(출고대기), KeP물류센터 출고(배송중)}
			cnt[6]++;
		}else if(status == "PX70"){ //배송완료 = {배송완료}
			cnt[7]++;
		}else if(status == "GR10" || status == "GR20"){ //입고완료 = {부분입고, 입고완료}
			cnt[8]++;
		}
	}
	
	for(var i = 1; i<=8; i++){
		$("#cnt_"+i).html(cnt[i]);
	}

// 	makePageIndex_v3( mySheet2 , tabs.buyerMpSoOrderProgress_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerNewPass_tab","1");	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpSoOrderProgress_tab1.but1text,tabs.buyerMpSoOrderProgress_tab1.but1func,tabs.buyerMpSoOrderProgress_tab1.but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	tabs.buyerMpSoOrderProgress_tab1.grbRow = Row;
	
	var user_id = $("#st_user_id_1").val();
	var buyer = mySheet1.GetCellValue(Row,"BUYER");
	var pr_no = mySheet1.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet1.GetCellValue(Row,"PR_SEQ");
	var po_no = mySheet1.GetCellValue(Row,"PO_NO");
	var po_seq = mySheet1.GetCellValue(Row,"PO_SEQ");
	var ref_no = mySheet1.GetCellValue(Row,"REF_NO");
	var recv_flag = mySheet1.GetCellValue(Row,"RECV_FLAG");
	
	var pr_jobdate = mySheet1.GetCellValue(Row,"PR_JOBDATE");
	var po_jobdate = mySheet1.GetCellValue(Row,"PO_JOBDATE");
	var iv_jobdate = mySheet1.GetCellValue(Row,"IV_JOBDATE");
	var wms_jobdate = mySheet1.GetCellValue(Row,"WMS_JOBDATE");
	var gr_jobdate = mySheet1.GetCellValue(Row,"GR_JOBDATE");
	
	var status_code = mySheet1.GetCellValue(Row,"STATUS_CODE");
	var status_text = mySheet1.GetCellValue(Row,"STATUS_TEXT");
	
	var gw_no = mySheet1.GetCellValue(Row,"GW_NO");
	var status_row_cnt = mySheet1.GetCellValue(Row,"STATUS_ROW_CNT");
	var pr_stts = mySheet1.GetCellValue(Row,"PR_STTS");
	var px_stts = mySheet1.GetCellValue(Row,"PX_STTS");
	var iv_stts = mySheet1.GetCellValue(Row,"IV_STTS");
	var gr_stts = mySheet1.GetCellValue(Row,"GR_STTS");
	
	var warehouse_code = mySheet1.GetCellValue(Row,"WAREHOUSE_CODE");
	var seller = mySheet1.GetCellValue(Row,"SELLER");
	var inv_no = mySheet1.GetCellValue(Row,"INV_NO");
	var purchaser_id = mySheet1.GetCellValue(Row,"PURCHASER_ID");
	
	var agent_code = mySheet1.GetCellValue(Row,"AGENT_CODE");
	
	if(column == "STATUS_TEXT"){ //진행상태 클릭 시
		document.forms.statusForm.st_buyer.value = buyer;
		document.forms.statusForm.PR_NO.value = pr_no;
		document.forms.statusForm.PR_SEQ.value = pr_seq;
		document.forms.statusForm.PO_NO.value = po_no;
		document.forms.statusForm.REF_NO.value = ref_no;
		document.forms.statusForm.ROW_CNT.value = status_row_cnt;
		document.forms.statusForm.PR_STTS.value = pr_stts;
		document.forms.statusForm.PX_STTS.value = px_stts;
		document.forms.statusForm.IV_STTS.value = iv_stts;
		document.forms.statusForm.GR_STTS.value = gr_stts;
		document.forms.statusForm.st_pr_jobdate.value = pr_jobdate;
		document.forms.statusForm.st_po_jobdate.value = po_jobdate;
		if(mySheet1.GetCellValue(Row,"PROCESS_TYPE") == "2"){
			document.forms.statusForm.st_iv_jobdate.value = wms_jobdate;
		}else{
			document.forms.statusForm.st_iv_jobdate.value = iv_jobdate;
		}
		document.forms.statusForm.st_gr_jobdate.value = gr_jobdate;
		document.forms.statusForm.st_status_code.value = status_code;
		document.forms.statusForm.st_status_text.value = status_text;
		openSearchPopupPost("/mpso/getBuyerMpSoOrderProgressStatusPop_v2.do", "statusForm", 'buyerMpSoOrderProgressStatusPop_v2', "width=790,height=750,resizable=no,scrollbars=no");
		
	}else if(column == "PR_NO"){ //PR번호 클릭 시
		if(pr_no != ""){
			if(gw_no != ""){
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,890,no"); 
			}else{
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,690,no"); 
			}
		}
	}else if(column == "PO_NO"){ //PO번호 클릭 시
		if(po_no != ""){
			openSearchPopup('/mpiv/getCommonMpIvBuyerOrderDetailInfoPop_v2.do','?buyer='+buyer+'&po_no='+po_no+'&po_seq='+po_seq+'&recv_flag='+recv_flag , "1330,800,no"); 
		}
	}else if(column == "INV_NO"){ //거래명세서번호 클릭 시
		if(inv_no != ""){
			if(inv_no.substring(0,2) == "IV") {
				openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIVPop_v2.do", "?buyer="+buyer+"&seller="+seller+"&inv_no="+inv_no+"&po_no="+po_no+"&pur_id="+purchaser_id+"&user_id="+user_id, "1330,700,no");
			}else{
				openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIKPop_v2.do", "?buyer="+buyer+"&seller="+seller+"&inv_no="+inv_no+"&po_no="+po_no+"&warehouse_code="+warehouse_code, "1330,700,no");
			}
		}
	}else if(column == "CART_BUTTON"){ //장바구니 담기 클릭 시
		var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpSoOrderProgress_tab1.cartInsert(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	}else if(column == "CANCEL_BUTTON"){ //취소/교환/반품 클릭 시
		var flag = mySheet1.GetCellValue(Row,"CANCEL_FLAG");
		
		if(flag == "1"){ //주문요청취소
			//주문요청취소 하시겠습니까?
			var text = "<%=CommonLang.msg("MSG772")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMpSoOrderProgress_tab1.saveBuyerPrCancel(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "100px";
			var but2widthC = "100px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

		}else if(flag == "2"){ //주문취소
			openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerCancelPop.do','?st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_buyer_code='+buyer+'&tab_id=buyerMpSoOrderProgress_tab1' , '800,550,no'); 
		}else if(flag == "3"){ //교환 반품
			openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerPop.do','?st_po_no='+po_no+'&st_po_seq='+po_seq+'&st_buyer_code='+buyer+'&tab_id=buyerMpSoOrderProgress_tab1' , '800,550,no'); 
		}
	}else if(column == "AGENT_TEXT"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+agent_code; 
		openLayerPop(src,"800px","680px");
	}
	return;
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_user_id" id="st_user_id_1" value="${sessionInfo.userId}">
		<input type="hidden" name="st_userDept" id="st_userDept_1" value="${sessionInfo.department}">
		<input type="hidden" name="st_unit_part"   value ="ST_USER_ID">	
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_1" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info_1" value="">
		<input type="hidden" name="st_all_page" id="st_all_page" value="N">

		<input type="hidden" name="st_buyer"    value ="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_userid"    value ="${sessionInfo.userId}"> 
		<input type="hidden" name="st_p060000114"  id="st_p060000114"    value="<%=request.getParameter("p060000114")%>">
		<input type="hidden" name="st_p060000114_search" id="st_p060000114_search"     value="<%=request.getParameter("p060000114_search")%>">
		<input type="hidden" name="p060000091" id="p060000091"     value="<%=request.getParameter("p060000091")%>">
		<input type="hidden" name="st_pr_mng_flag"      value="<%=request.getParameter("prMngFlag")%>">
        <input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" name="p060000080" id="p060000080" value="<%=request.getParameter("p060000080")%>">
        <input type="hidden" id="pageflag_1" name="pageflag" value="1" />
        <input type="hidden" name="st_own_search_flag" id="st_own_search_flag" value="Y">
        <input type="hidden" name="st_ing_search_flag" id="st_ing_search_flag" value="N">
	<div id="Search1" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG788")%><!--주문 및 배송에 대한 전반적인 정보를 확인할 수 있으며, 주문취소,교환·반품 신청이 가능합니다.--></div>
      <div class="SHProgress mt05 mb10">
        <div class="ProgressBox"><p id="cnt_1" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PR10,PR50,PR60,PR80');"></p><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_2" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PR40,PR90');"></p><%=CommonLang.get("HTITLE1180")%><!--주문요청취소--></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_3" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PR20,PR30,PR100');"></p><%=CommonLang.get("HTITLE1181")%><!--주문요청반려--></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_4" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PX10');"></p><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_5" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PX20');"></p><%=CommonLang.get("HTITLE1006")%><!--상품준비중--></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_6" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PX30,PX40,PX50,PX60');"></p><%=CommonLang.get("HTITLE1007") %><!-- 배송중 --></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_7" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('PX70');"></p><%=CommonLang.get("HTITLE1008") %><!-- 배송완료 --></div>
        <div class="ProgressBR"></div>
        <div class="ProgressBox"><p id="cnt_8" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search('GR10,GR20');"></p><%=CommonLang.get("HTITLE201") %><!-- 입고완료 --></div>
      </div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="90px" />
          <col width="350px" />
          <col width="90px" />
          <col width="350px" />
          <col width="90px" />
          <col width="310px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE423")%><!-- 기간 --></th>
          <td colspan="3">
            <select name="st_date_type" id="st_date_type_1" class="Select40" style=" float:left; width:192px; margin-right:7px">
              <option value="PR_DATE"><%=CommonLang.get("HTITLE1235") %><!-- 주문요청일 --></option>
              <option value="PO_DATE"><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></option>
            </select>               
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" placeholder="" readonly id="st_from_date_1" name="st_from_date"/><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text" placeholder="" readonly id="st_to_date_1" name="st_to_date"/><span></span></div>
            </div>
            <!--div class="Buyer-datepicker-wrap" style=" width:120px">
              <div class="Buyer-date-input" data-monthpicker><input type="text" placeholder="" readonly /><span>1</span></div>
            </div-->               
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE552")%><!-- 검색어 --></th>
          <td>
            <select name="st_search_type" class="Select40" style=" float:left;width:130px; margin-right:5px">
              <option value="DE"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
              <option value="SP"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>
              <option value="BC"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
              <option value="PR"><%=CommonLang.get("HTITLE1179") %><!-- 주문요청번호 --></option>
              <option value="PO"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></option>
              <option value="IV"><%=CommonLang.get("HTITLE271") %><!-- 송장번호 --></option>
              <option value="MN"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></option>
              <option value="IF"><%=CommonLang.get("HTITLE885") %><!-- I/F발주번호 --></option>
            </select>  
            <input class="input40" style="width:143px" name="st_search_no" type="text" onKeyDown="kepEnter_v3('buyerMpSoOrderProgress_tab1')"/>
          </td>
        </tr>
		<tr>
		  <th><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>					
          <td>
            <input type="text"  class="input40" name="st_pur_user_name" id="st_pur_user_name_1" value=""  style=" width:310px;" onKeyDown="kepEnter_v3('buyerMpSoOrderProgress_tab1')">
<!--             <input type="hidden" name="st_pur_user_id" id="st_pur_user_id_1" value=""> -->
<!--             <button type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doPop('purUser'); return false;" ></button> -->
          </td>
          <th><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
          <td><div class="TabShIconTwo" style="width:308px ">
            <input type="text"  name="st_pur_dept_name" id="st_pur_dept_name_1" value=""  style=" width:240px;" readonly>
            <input type="hidden" name="st_pur_dept_code" id="st_pur_dept_code_1" value="">
            <button class="Search" type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doPop('purDepartment'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doAction('purDepartmentErase'); return false;"></button></div></td>
          <%if(group_mng_flag.equals("Y")) {%>
          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
	      <td>
		      <select name="st_com_code" id="st_com_code_1" class="Select40" style=" float:left; width:300px; margin-right:7px" onchange="javascript:tabs.buyerMpSoOrderProgress_tab1.buyerChange();">
		        <%= CommonUtil.getCode3ComboList(request.getParameter("buyer"), "ALL", "TGCM",request.getParameter("userId"), "ICOMCOD3", request.getParameter("buyer"), "") %>
		       </select>
	      </td>
		  <%}else{ %>
		  <input type="hidden" name="st_com_code" id="st_com_code_1" value="${sessionInfo.comCode}">
		  <%} %>
		</tr>
<%-- 		<%if(request.getParameter("prMngFlag").equals("Y")) { %> --%>
		<th><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>					
          <td>
            <input type="text" class="input40" name="st_req_user_name" id="st_req_user_name_1" value=""  style=" width:310px;" onKeyDown="kepEnter_v3('buyerMpSoOrderProgress_tab1')">
<!--             <input type="hidden" name="st_req_user_id" id="st_req_user_id_1" value=""> -->
<!--             <button type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doPop('reqUser'); return false;"></button> -->
          </td>
          <th><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
          <td><div class="TabShIconTwo" style="width:308px ">
            <input type="text"  name="st_req_dept_name" id="st_req_dept_name_1" value=""  style=" width:240px;" readonly>
            <input type="hidden" name="st_req_dept_code" id="st_req_dept_code_1" value="">
            <button class="Search" type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doPop('reqDepartment'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.doAction('reqDepartmentErase'); return false;"></button></div></td>
<%-- 		<%} %>            --%>
		  <td colspan="2">
          <label class="CheckLargeLabel" style="margin:0px;"><input type="checkbox"name="st_checkbox" id="st_own_check" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.setFlag('1');" checked><span class="CheckLargeCustom"></span></label>
    	  &nbsp;<%=CommonLang.get("HTITLE1258") %><!-- 본인 요청건만 조회 -->
    	  &nbsp;&nbsp;
    	  <label class="CheckLargeLabel" style="margin:0px;"><input type="checkbox"name="st_checkbox2" id="st_ing_check" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.setFlag('2');"><span class="CheckLargeCustom"></span></label>
    	  &nbsp;<%=CommonLang.get("HTITLE1470") %><!-- 상품준비중·배송중만 조회 -->
          </td>  
		<tr>
		  <th style="display:none; "><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
          <td style="display:none; ">
            <select name="st_status"  id="st_status_1" class="Select40" style="width:310px;">
            	<option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
            	<option value="PR10,PR50,PR60,PR80"><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></option>
            	<option value="PR40,PR90"><%=CommonLang.get("HTITLE1180")%><!--주문요청취소--></option>
            	<option value="PR20,PR30,PR100"><%=CommonLang.get("HTITLE1181")%><!--주문요청반려--></option>
            	<option value="PX10"><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></option>
            	<option value="PX20"><%=CommonLang.get("HTITLE1006")%><!--상품준비중--></option>
            	<option value="PX30,PX40,PX50,PX60"><%=CommonLang.get("HTITLE1007") %><!-- 배송중 --></option>
            	<option value="PX70"><%=CommonLang.get("HTITLE1008") %><!-- 배송완료 --></option>
            	<option value="GR10,GR20"><%=CommonLang.get("HTITLE201") %><!-- 입고완료 --></option>
            </select>  
          </td>
          <th></th>
          <td></td>
          <th></th>
          <td></td>
		</tr>
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMpSoOrderProgress_tab1.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="ArraySub mt30 mb10">
      	<div class="buttonLeft">
      	<%if(request.getParameter("p170000001").equals("false")){%>
          <button class="But_ExcelDown40" onclick="tabs.buyerMpSoOrderProgress_tab1.excelDown(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %> 
        </div>
        <div class="buttonRight"></div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet1", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
       <div class="ArraySub mt10">
        <div class="buttonRight"><span class="allprice" id="tot_amt"></span></div>
	   </div>
      <div class="IBSheetBuyer" style="display: none;">
      	<script type="text/javascript">
          	createIBSheet("mySheet2", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 -->
      <div class="PagingCenter mt10" id="pageindex1"></div>
      <div class="h50"></div>         
    </div><!--Tab1끝 -->
</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="">
	<input type="hidden" name="st_pr_seq" id="st_pr_seq" value="">
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="">
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="">
	<input type="hidden" name="st_query2" id="st_query2" value="">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="">
</form> 
<form name="statusForm" id="statusForm" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="PR_NO" id="PR_NO" value="" />
	<input type="hidden" name="REF_NO" id="REF_NO" value="" />
	<input type="hidden" name="PO_NO" id="PO_NO" value="" />
	<input type="hidden" name="PR_SEQ" id="PR_SEQ" value="" />
	<input type="hidden" name="ROW_CNT" id="ROW_CNT" value="" />
	<input type="hidden" name="PR_STTS" id="PR_STTS" value="" />
	<input type="hidden" name="PX_STTS" id="PX_STTS" value="" />
	<input type="hidden" name="IV_STTS" id="IV_STTS" value="" />
	<input type="hidden" name="GR_STTS" id="GR_STTS" value="" />
	<input type="hidden" name="st_pr_jobdate" id="st_pr_jobdate" value="">
	<input type="hidden" name="st_po_jobdate" id="st_po_jobdate" value="">
	<input type="hidden" name="st_iv_jobdate" id="st_iv_jobdate" value="">
	<input type="hidden" name="st_gr_jobdate" id="st_gr_jobdate" value="">
	<input type="hidden" name="st_status_code" id="st_status_code" value="">
	<input type="hidden" name="st_status_text" id="st_status_text" value="">
</form>
