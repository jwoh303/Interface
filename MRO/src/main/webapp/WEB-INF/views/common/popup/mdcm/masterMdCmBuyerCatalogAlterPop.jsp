<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 카탈로그 변경 
* 기능 : 고객사카탈로그 상세정보 팝업
* 프로그램 ID : PG_03_M_002_01 / PG_03_M_002_05
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
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
<head>
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
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _userDataList = (List<Map<String,String>>) request.getAttribute("userData"); // 조회된 결과(담당자)
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String sessionUserId = _sessionInfo.getUserId();
String st_user_dept = _sessionInfo.getDepartment();
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)
String st_catalog_com_code = CommonUtil.nvl((String) request.getParameter("st_catalog_com_code"),"");  //  (조회조건)
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String bFlagCmsUser = CommonUtil.nvl((String)request.getAttribute("bFlagCmsUser"),"N");  
String open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"");
String st_approval_yn = CommonUtil.nvl((String) request.getParameter("st_approval_yn"),"N");
String st_edit_yn = CommonUtil.nvl((String) request.getParameter("st_edit_yn"),"Y");  //  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

String moq_use_flag = "N";
String area_use_flag = "N";

//삼성계열사(MOQ, 발주배수 필수 사용)
boolean p04404101 = CommonUtil.getSpecialCheckReturn(st_buyer_code,"P04-4041-01");

if(p04404101 == true){
	moq_use_flag = "Y";
}

//삼성계열사(납품지역 필수 사용)
boolean p04404102 = CommonUtil.getSpecialCheckReturn(st_buyer_code,"P04-4041-02");

if(p04404102 == true){
	area_use_flag = "Y";
}

//소싱부서 여부(담당고객사 관계없이 저장 버튼 활성)
String st_sour_dept_yn = "";
boolean st_sour_dept = CommonUtil.getCodeCheckReturn("SOURDEPT",st_user_dept);
if(st_sour_dept == true){
	st_sour_dept_yn = "Y";
}else{
	st_sour_dept_yn = "N";
}

// 보관조건 저장 권한자(물질정보 담당자)
boolean getRoleYn = CommonUtil.getCodeCheckReturn("CM10",_sessionInfo.getUserId());
%>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var g_doc_type = ""; // doc_Type

var pre_process_type = new Array();
var process_source  = new Array();

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    var productGbn2 = KepSheetComboData("M074","SEL");
    var comboInfo2 = {ComboCode: productGbn2.ComboCode, ComboText:productGbn2.ComboText};
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Left",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Left",	Width:60,	Edit : true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:20,	Edit:false,	EditLen:100,	Type:"Text",	FontColor:"#003694", Header:" ",	SaveName:"INS"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"협력사",	SaveName:"AGENT_NAME" ,BackColor:"${optColor}" }
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"물류관련협력사",	SaveName:"ORIGIN_AGENT_NAME"  ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Type:"Text",	Header:"협력사품목코드",	SaveName:"SELLER_ITEM_NO" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:90,	Edit:true,	EditLen:25,	Type:"Text",	Header:"제조사모델번호",	SaveName:"MAKER_PART_NO" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:200,	Type:"Text",	 FontColor:"#003694", Header:"원산지",	SaveName:"ORIGIN_TEXT" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	FontColor:"#003694", Header:"거래유형",	SaveName:"PROCESS_TEXT" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"물류비(%)", SaveName:"LOGISTICS_RATE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"책정사유", SaveName:"LOGIS_RATE_STATUS"}
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:20,	Type:"Float",	Format:"${priceFormat}", Header:"매출단가",	SaveName:"UNIT_PRICE" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:110,	Edit:true,	EditLen:20,	Type:"Combo",   Header:"매출단가 변동사유",	SaveName:"UNIT_PRICE_CHANGE_REASON" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:20,	Type:"Float",	Format:"${priceFormat}", Header:"매입단가",	SaveName:"LIST_PRICE" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:110,	Edit:true,	EditLen:20,	Type:"Combo",   Header:"매입단가 변동사유",	SaveName:"LIST_PRICE_CHANGE_REASON" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"적용구분",	SaveName:"BELOW_TEXT" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:90,	Edit:true,	EditLen:300,	Type:"Float",	Header:"표준납기일",	SaveName:"DELIVERY_LT",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,  Type:"Combo", Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Date", Format:"Ymd",Header:"단가변경일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:300,	Type:"Float", Format:"${priceFormat}", Header:"최근발주단가",	SaveName:"LAST_PO_PRICE"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:300,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	 Header:"수입여부",	SaveName:"IMPORT_FLAG"  ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"계정항목",	SaveName:"ACCOUNT_TEXT"}
					,{ Align:"Left",	Width:80,	Edit:false,	Hidden:true, EditLen:300,	Type:"Text",	 Header:"상품구분",	SaveName:"ITEM_GROUP_TEXT"}
					 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:300,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}
					 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"계약항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_DELIVERY_LT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_ITEM_MAKE_TYPE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"LAST_PO_QTY"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"LAST_PO_DATE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BUYER"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"ORIGIN_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"ORIGIN_AGENT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BELOW_COMORG_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"STATUS"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"ITEM_GROUP"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"MAKER_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"PROCESS_SOURCE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"EP_CHECK"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CHECK_FLAG"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_CONTRACT_SEQ"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_UNIT_PRICE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_LIST_PRICE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_ORIGIN_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_MAKER_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_MAKER_NAME"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BEF_AGENT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"NEW_YN"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BELOW_ARRAY"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BELOW_CHANGE_YN"}
					,{ Align:"Right",	Width:50,	Edit:true,	EditLen:10,	Type:"Int",	Header:"MOQ",		SaveName:"MIN_ORDER_QTY",	BackColor:"${optColor}"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Int",	Header:"",	SaveName:"BEF_MIN_ORDER_QTY"}
					,{ Align:"Right",	Width:60,	Edit:true,	EditLen:10,	Type:"Int",	Header:"발주배수",	SaveName:"PUR_UNIT_QTY",		BackColor:"${optColor}"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Int",	Header:"",	SaveName:"BEF_PUR_UNIT_QTY"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Type:"Image",	Header:"납품지역",	SaveName:"SELLER_AREA_IMG"}
	    			,{ Align:"Center",	Width:0,	Hidden:true,	Type:"Text",		Header:"납품지역",	SaveName:"SELLER_AREA"}
	    			,{ Align:"Center",	Width:0,	Hidden:true,	Type:"Text",		Header:"납품지역",	SaveName:"BEF_SELLER_AREA"}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Type:"Image",	Header:"외화단가",	SaveName:"CUNRRENCY_IMG"}
	    			,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BUYER_ITEM_NO"}
	    			,{ Align:"Center",	Width:0,	Hidden:true, Type:"Text",	Header:"삭제사유코드",	SaveName:"DEL_STATUS_CODE"}
	    			,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"삭제사유",	SaveName:"DEL_STATUS_CODE_TEXT"}
	    			,{ Align:"Center",	Width:0,	Hidden:true, Type:"Text",	Header:"단종사유코드",	SaveName:"CLOSE_STATUS_CODE"}
	    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:300,	Type:"Image",	Header:"단가이력",	SaveName:"UNIT_PRICE_HISTORY_IMG"}
	    			,{Align : "Center",SaveName : "CH_SELL_CLOSE_DATE",		Header : "매출\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : true}
	    			,{Align : "Center",SaveName : "CH_BUY_CLOSE_DATE",		Header : "매입\n단가유효일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : true}
	    			,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"RE_SELL_CLOSE_DATE"}
	    			,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"RE_BUY_CLOSE_DATE"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:4};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "ORIGIN_AGENT_NAME");
	setLinkCol(mySheet, "ORIGIN_TEXT");
	setLinkCol(mySheet, "PROCESS_TEXT");
	setLinkCol(mySheet, "BELOW_TEXT");
	setLinkCol(mySheet, "MAKER_NAME");
	setLinkCol(mySheet, "SELLER_AREA_IMG");
	setLinkCol(mySheet, "LOGISTICS_RATE");
	setLinkCol(mySheet, "CUNRRENCY_IMG");
	setLinkCol(mySheet, "UNIT_PRICE_HISTORY_IMG");
	
	mySheet.SetImageList(5, areaOn);
	mySheet.SetImageList(4, areaOff);
	kepSetCalender("st_from_date");
	//콤보셋팅
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet.SetColProperty("UNIT_PRICE_CHANGE_REASON", comboInfo2);
	mySheet.SetColProperty("LIST_PRICE_CHANGE_REASON", comboInfo2);
	
	<% if (_dataList!=null && _dataList.size() > 0) { %>
		doAction('search');
	<% }else{ %>
		alert("카탈로그 정보가 없습니다.");
		this.close();
	<% }%>
}


var st;
var mt;
// 기능함수
function doAction(str, flag) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	
	
	//선택된 항목 유무 체크
	if (str !="search" && str !="loadExcel" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.masterMdCmBuyerCatalogAlterPop,  mySheet , "/mdcm/getMasterMdCmBuyerCatalogAlterPop.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('masterMdCmBuyerCatalogAlterPop');
		mySheet.RemoveAll();
		break;
	
	case "save": // 저장
		
		
		kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );
		break;
		
	case "del":	//삭제
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		
		var maxRow  = mySheet.RowCount();
		//신규건 삭제
		for(var i=maxRow; i>= 0; i--){	
			var new_yn = mySheet.GetCellValue(i,"NEW_YN");
			var currency = mySheet.GetCellValue(i,"CUNRRENCY_IMG");
			if(currency == areaOn){
				alert("선택하신 품목 중 외화단가 매핑건이 존재합니다. 외화 매핑삭제 후 진행 바랍니다.");
				return;
			}
			var selectedRow = mySheet.GetCellValue(i,"SELECTED");
			if(new_yn == "Y" && selectedRow == "1"){
				mySheet.RowDelete(i, 0);	
			}
		}
		
		popupSel = "delReasonPop";
		openSearchPopup("/common/catlgCloseDelReasonPop.do", "?st_type=D", "500, 150, no");

		break;	
	
	case "delCancel":	//삭제취소
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		
		if (!confirm(" 선택하신 품목을 사용 처리 하시겠습니까?  ")) {
			return;
		}else{
			kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/delCancelMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );	
		}		
		
		break;		
		
	case "confirm": // 등록
		
		var text = "";
		if(flag == "N"){
			text = "승인";
		}else {
			text = "미승인 또는 단종";
		}
		
		//행추가 된 행은 승인/미승인 처리 할 수 없음.
		for(var i=0; i<arrRow.length; i++){
			var new_yn = mySheet.GetCellValue(arrRow[i],"NEW_YN");
			
			if(new_yn == "Y"){
				alert("행추가 된 "+arrRow[i]+"번째 행은 "+text+"처리할 수 없습니다.\n저장 한 후에 "+text+"처리하세요.");
				return;
			}
		}
		
		if (selectedGrid.length == 0){
			alert(text+" 처리할 대상을 선택해 주십시요.");
			return;
		}

		if(flag == "N"){
			if (!confirm("품목을 "+text+" 처리 하시겠습니까?  ")) {
				return;
			}else{
				$("#st_product_flag").val(flag);
				kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/confirmMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );	
			}	
		}else{
			popupSel = "closeReasonPop";
			openSearchPopup("/common/catlgCloseDelReasonPop.do", "?st_type=C", "500, 150, no");
		}
		
		break;
	case "addCmc":	//물질정보제출
		if (!confirm("물질정보 요청 하시겠습니까?")) {
			return;
		}else{
			kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/reqMasterMdCmSellerChemicalMat.do" , "SELECTED" );	
		}		
		break;	
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AGENT_NAME') { // 협력사 선택
		popupSel = "masterMdCmSellerCmpyChoicePop";
		
		var processType = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		
		
		if(processType == "1" || processType == "3"){
			  alert("재고/VMI 건의 협력사는 물류센터입니다.\n\n수정 할 수 없습니다.");
		    return;
		}
		openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
	}else if(column == 'ORIGIN_AGENT_NAME'){  // 물류관련협력사 선택
		var process_type =mySheet.GetCellValue(Row,"PROCESS_TYPE");
		//프로세스 소스 코딩 필요
		var process_source = mySheet.GetCellValue(Row,"PROCESS_SOURCE");
		if((process_type=="1"||process_type=="3") && (process_source == "STCK" || process_source == "")){
			alert('물류센터의 재고/VMI 는 물류관련 공급회원사를 선택 하실 수 없습니다.');
			return;
		}
		if(process_type == '2'){
	       alert('TR의 물류관련 협력사는 물류센터 입니다.\n\n 센터 변경은 거래유형 수정에서 수정 하세요');
		   return;
	    }

       if(process_type == "0")
       {
          alert("직납건은 물류관련 공급회원사를 선택하실 수 없습니다.");
          return;
       }else {
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "agent_single";
       }
	}else if (column == 'PROCESS_TEXT') { // 거래유형 선택
		var new_yn = mySheet.GetCellValue(Row,"NEW_YN");
		if(new_yn == "Y")return;
		popupSel = "commonCoCoGoodsDlvyClssifyPop2";
	
		pre_process_type[Row] = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop2.do?st_gubun=RQ", "", "500,250,no");
	   
	}else  if (column == 'BELOW_TEXT' ){  // 적용구분 선택
		var buyer_code = $("#st_buyer_code").val();
		var catalog_com_code = $("#st_catalog_com_code").val();
		var buyer_item_no = $("#st_buyer_item_no").val();
		var agent = mySheet.GetCellValue(Row,"AGENT");
		var process_type = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		var new_yn = mySheet.GetCellValue(Row,"NEW_YN");
		
		//그룹에 속해있지 않은 고객사는 적용구분 default
		if(buyer_code == catalog_com_code){
			//alert("그룹에 속해있지 않은 고객사는 적용구분을 선택할 수 없습니다.");
			return;
		}else if(new_yn == "Y"){
			alert("행추가된 row는 저장 한 후에 적용구분을 변경하세요.");
			return;
		}
		
		popupSel = "commonCoCoBottomOrgCodeMutilPop";
		openSearchPopup("/coco/getCommonCoCoBottomOrgCodeMultiPop.do", "?st_buyer="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no+"&st_agent="+agent+"&st_process_type="+process_type+"&st_org_code="+buyer_code, "700,300,no");
		
	}else if (column == 'ORIGIN_TEXT' ){ // 원산지 선택
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
	
	}else if (column == 'ITEM_GROUP_TEXT') { // 상품구분 선택
		popupSel = "commonCoCoTeamClassifyPop";		
		//신규 행추가시 default로 사업팀 set
		//kepOpenPopup(popupSel);	
		
	}else if (column == 'MAKER_NAME') { // 제조사명 선택
		popupSel = "maker";		
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
		
	}else if (column == 'UNIT_PRICE') { //매출단가 선택
		/*var sStatus = mySheet.GetCellValue(Row,"sStatus");
		if(sStatus == "I"){
			mySheet.SetCellEditable(Row, "UNIT_PRICE", 1);
		}else{
			// 매출단가 변경은 무조건 품의시스템 이용.
			alert("매출단가 변경시 품의시스템 이용 바랍니다.");
		}*/
	
	}else if (column == 'CHANGE_DATE') { // 단가변경일 선택
		var catalog_com_code = $("#st_catalog_com_code").val();
		var buyer_code = $("#st_buyer_code").val();
		var buyer_item_no = $("#st_buyer_item_no").val();
		var contract_no = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contract_seq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		//SLOGIC-BEGIN(P03-3022-02)
		if(catalog_com_code=='KRDONGG004' || buyer_code=='KRDONG0154' || buyer_code=='KRDONG0153' || buyer_code=='KRDONG0099'){
			popupSel = "commonCoCoBuyerCatalogDetailPop";
			openSearchPopup("/coco/showCommonCoCoBuyerCatalogDetailPop.do", "?buyer="+buyer_code+"&buyer_item_no="+buyer_item_no+"&contract_no="+contract_no+"&contract_seq="+contract_seq, "500,500,no");
		}
		//SLOGIC-END
	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = $("#st_buyer_code").val();
		var seller_area = mySheet.GetCellValue(Row, "SELLER_AREA");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=Y&st_area_chk_flag=N', "400,270,no");
	}else if(column == "LOGISTICS_RATE"){ // 물류비
		var code = mySheet.GetCellValue(Row, "LOGIS_RATE_STATUS");
		openSearchPopup('/common/getLogisFeeReasonPop.do','?st_reason_code=' + code, '600,180,no');// 물류비 책정 사유
	}else if(column == "CUNRRENCY_IMG"){//외화단가 정보
		popupSel = "currencyPop";
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_below_code = mySheet.GetCellValue(Row, "BELOW_COMORG_CODE");
		var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
		var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_unit_price = mySheet.GetCellValue(Row, "UNIT_PRICE");
		
		openSearchPopup("/coco/showCommonCoCoBuyerCurrencyPop.do", '?st_buyer='+st_buyer+'&st_contract_no='+st_contract_no+'&st_contract_seq='+st_contract_seq+'&st_buyer_item_no='+st_buyer_item_no+'&st_unit_price='+st_unit_price+'&st_below_code='+st_below_code, "750,380,no");
	}else if (column == 'UNIT_PRICE_HISTORY_IMG') { // 단가이력
		popupSel = "unitPriceHistoryPop";
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
		var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");

		openSearchPopup("/mdcm/showMasterMdCmCatalogUnitPriceHistoryPop.do", '?st_buyer='+buyer+'&st_contract_no='+st_contract_no+'&st_contract_seq='+st_contract_seq+'&st_buyer_item_no='+st_buyer_item_no, "920,400,no");
		
	}
	return;
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function setImageView(img_dr,img_name){
	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		var st_img_dr = img_dr+img_name;
		window.open(st_img_dr,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=700,height=700');
	}
	
}
//이미지 확대보기
function setImageView2(img_dr,img_name){
	if(img_name == "icon_emptyimg.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		var st_img_dr = img_dr+img_name;
		window.open(st_img_dr,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=600,height=600');	
	}
	
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "commonCoCoAccountItemPop": // 계정항목
			openSearchPopup("/coco/getCommonCoCoAccountItemPop.do", "", "410,250,no");
			break;
		
		case "commonCoCoStndrdCatalogSearchPop": //표준 카탈로그 검색(CMS)
			popupSel = "stndCatlg";

			// 조회 팝업		
			openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_type=CATLG_REG","900,800,no");
			
			break;
		
		case "commonCoCoBuyerCategoryChoicePop": //고객사 카테고리
			popupSel = "commonCoCoBuyerCategoryChoicePop";
			var buyer_code = $("#st_buyer_code").val();
			
			//SLOGIC-BEGIN(P03-3022-05)
		    if( buyer_code == "KRKEPB0007" || buyer_code == "KRDDDD0001" || buyer_code == "KRHYUN0026" || buyer_code == "KRHYUN0033" || buyer_code == "KRKYUN0002" || buyer_code == "KRISUC0002" || buyer_code == "KRISUC0007"){
		    	popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
		    	openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do", '?st_buyer='+buyer_code, "400,500,no");
			}else if( buyer_code == "KRDOOD0001" || buyer_code == "KRDOOS0004" || buyer_code == "KRILJI0003" || buyer_code == "KRILJI0015"  || buyer_code == "KRILJI0026" || buyer_code == "KRHSDE0003" ){
				openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", '?st_buyer='+buyer_code+'&st_flag=ITM', "400,500,no");
			}else{
				openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer='+buyer_code+'&st_flag=ITM', "728,510,no");
				
			}
			break;	
			//SLOGIC-END
			
		case "masterMdCmChangeReasonPop": //변경사유
			openSearchPopup("/mdcm/showMasterMdCmChangeReasonPop.do", "", "550,280,no");
			break;
		case "fileUpload2":				//파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMdCmSellerCmpyChoicePop") {	// 협력사 선택
		var processType = mySheet.GetCellValue(grbRow,"PROCESS_TYPE");
		if((processType == "0" || processType == "2") && value8 > 0){
			alert("거래유형이 직납,TR인 경우\n\n물류센타를 협력사로 지정 할수 없습니다.\n\n확인 바랍니다.  ");
		}else{
			mySheet.SetCellValue(grbRow, 'AGENT', value1);
			mySheet.SetCellValue(grbRow, 'AGENT_NAME', value2);
			mySheet.SetCellValue(grbRow, 'SELECTED', '1');
		}
	}else if(popupSel == "commonCoCoAccountItemPop"){ //계정항목 선택
		$("#st_account_type").val(value1);
		$("#st_account_text").val(value2);
	}else if (popupSel == "stndCatlg"){ // 표준카탈로그코드
		if(value1 == "manual"){ // 직접선택 시 표준카탈로그조회 팝업
			this.focus();

			openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_type=CATLG_REG","900,800,no");
		}else if(value1 == "rcmd"){
			popupSel = "stndCatlg";
			
			var desc = $("#st_description").val(); // 품목명
 			var spec = $("#st_specification").val(); // 규격
 			var maker = ""; // 제조사명
 			
			var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
		    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
		    document.catlgFlow.target = "categ";
		    document.catlgFlow.method = "post";
		    
		    document.catlgFlow.catlg_desc_flow.value = escape(desc);
		    document.catlgFlow.catlg_spec_flow.value = escape(spec);
		    document.catlgFlow.catlg_maker_flow.value = escape(maker);
		    
		    document.catlgFlow.submit();
		    new_popup.focus();
		}else{
			$("#st_stdcatlg_id").val(value1);
			$("#st_catalog_choice_type").val(value3); 
		}
	}else if(popupSel == "agent_single"){
		mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', value2);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	}else if (popupSel == "commonCoCoGoodsDlvyClssifyPop2") {	//거래유형
		if(pre_process_type[grbRow] == "3" && value1 == "1"){
			alert("VMI 상품에서 재고 상품으로 변경은 불가합니다.");
	        return;
		}
	
		if(pre_process_type[grbRow] == "1" && value1 == "3"){
			alert("재고 상품에서 VMI 상품으로 변경은 불가합니다.\n\n재고소진 및 반품등을 구매담당자와 센타 협의 후 가능합니다.");
	        return;
		}
		
		if(value1 == "1" || value1 == "3"){  						//재고/VMI 선택
			process_source[grbRow] = "STCK";
		
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TEXT', value2);
			mySheet.SetCellValue(grbRow, 'LIST_PRICE', value7);
			mySheet.SetCellValue(grbRow, 'MAKER_NAME', value10);
			mySheet.SetCellValue(grbRow, 'MAKER_PART_NO', value11);
			mySheet.SetCellValue(grbRow, 'ORIGIN_TEXT', value12);
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value11);
			mySheet.SetCellValue(grbRow, 'UNIT_MEASURE', value8);
			$("#st_stdcatlg_id").val(value9);
			mySheet.SetCellValue(grbRow, 'AGENT_NAME', value4);
			mySheet.SetCellValue(grbRow, 'AGENT_CODE', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', value6);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', value5);
			
		}else if(value1 == "2"){ 									//TR 선택
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TEXT', value2);
			
			if(pre_process_type[grbRow] == '1' || pre_process_type[grbRow] == '3' ){
				mySheet.SetCellValue(grbRow,"AGENT_NAME", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT_NAME"));
				mySheet.SetCellValue(grbRow,"AGENT_CODE", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT"));
			}
			
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', value4);
		}else{
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TEXT', value2);	
			
			var temp = "";
		    var process_type       = TrimCommon(mySheet.GetCellValue(grbRow, 'PROCESS_TYPE'));
		    var agent_text         = TrimCommon(mySheet.GetCellValue(grbRow, 'AGENT_NAME'));
		    var agent_code         = TrimCommon(mySheet.GetCellValue(grbRow, 'AGENT_CODE'));
		    var origin_agent_text  = TrimCommon(mySheet.GetCellValue(grbRow, 'ORIGIN_AGENT_NAME'));
		    var origin_agent_code  = TrimCommon(mySheet.GetCellValue(grbRow, 'ORIGIN_AGENT'));
			var st_pre_process_type   = pre_process_type[grbRow];
			
			if(process_type == "0"){
				
				//getBuyerPrimeCostRate(grbRow);
				
				if(agent_code == "KRKORE0069"||agent_code == "KRKORE0127"){
					if((origin_agent_code != "KRKORE0068"||origin_agent_code != "KRKORE0126") || origin_agent_code != ""){
						mySheet.SetCellValue(grbRow,"AGENT_NAME", origin_agent_text);
						mySheet.SetCellValue(grbRow,"AGENT_CODE", origin_agent_code);
						mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', temp);
						mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', temp);
					}
					
					return;
				}else {
					if(origin_agent_code == "KRKORE0068"||origin_agent_code == "KRKORE0126") {
						mySheet.SetCellValue(grbRow,"AGENT_NAME", agent_text);
						mySheet.SetCellValue(grbRow,"AGENT_CODE", agent_code);
						mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', temp);
						mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', temp);
						
						return;
					}else{
						if(st_pre_process_type != '0' ){
							mySheet.SetCellValue(grbRow,"AGENT_NAME", origin_agent_text);
							mySheet.SetCellValue(grbRow,"AGENT_CODE", origin_agent_code);
							mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', temp);
							mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', temp);
						}
						
						return;
					}
				}
			}else if((process_type == "1"||process_type == "3")  && (agent_code != "KRKORE0069"||agent_code != "KRKORE0127")) {
				mySheet.SetCellValue(grbRow,"AGENT_NAME", "경남 Hub센터");
				mySheet.SetCellValue(grbRow,"AGENT_CODE", "KRKORE0069");
				mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', agent_text);
				mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', agent_code);
				return;

			}else if(process_type == "2") {
				if(origin_agent_code == "") {
					mySheet.SetCellValue(grbRow,"AGENT_NAME", agent_text);
					mySheet.SetCellValue(grbRow,"AGENT_CODE", agent_code);
					mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', "KRKORE0068");
					mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', "경남 Hub센터");
					return;
				}else {
					mySheet.SetCellValue(grbRow,"AGENT_NAME", origin_agent_text);
					mySheet.SetCellValue(grbRow,"AGENT_CODE", origin_agent_code);
					mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', "KRKORE0068");
					mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', "경남 Hub센터");
					return;
				}
			}
			
		}
		
		//매출원가 재계산
		//getBuyerPrimeCostRate(grbRow);
		
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	} else if (popupSel == "commonCoCoBottomOrgCodeMutilPop") {	//적용구분(하위부서코드)
		mySheet.SetCellValue(grbRow, 'BELOW_ARRAY', value1);
		mySheet.SetCellValue(grbRow, 'BELOW_TEXT', value2.replace(/@/gi,","));
		mySheet.SetCellValue(grbRow, 'BELOW_CHANGE_YN', 'Y');		
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	
	/*} else if (popupSel == "commonCoCoBottomOrgCodePop") {	//적용구분(하위부서코드)
		mySheet.SetCellValue(grbRow, 'BELOW_COMORG_CODE', value1);
		mySheet.SetCellValue(grbRow, 'BELOW_TEXT', value2);
		getBuyerPrimeCostRate(grbRow);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); */
	}else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_TEXT', value3);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	}else if (popupSel == "commonCoCoTeamClassifyPop") {	//담당팀
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP_TEXT', value1);
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP', value2);	
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	}else if (popupSel == "maker") {	//제조사
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	}else if(popupSel == "masterMdCmChangeReasonPop"){ //변경사유
		$("#st_change_remark").val(value1);
		doAction('save');
	}else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 고객사카테고리
		$("#st_category_id").val(value1);
		$("#st_category_name").val(value2);
		$("#st_category_path").val(value4);
	}else if (popupSel == "fileUpload2") {	// 첨부파일
		$("#st_image_key").val(value1);
	   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif"); 
		return;
	}else if (popupSel == "commonCoCoBuyerCategoryChoiceTreePop") {	// 고객사카테고리 트리형
		if(value3 != "ITM" ){
			alert("ITEM 카테고리가 아닙니다.\n최하위 카테고리를 선택하여 주십시요.  ");
			return;
		}else{
			$("#st_category_id").val(value1);
			$("#st_category_name").val(value2);
			$("#st_category_path").val(value7);
		}
	}else if (popupSel == "deliAreaPop"){ // 납품지역
		mySheet.SetCellValue(grbRow, 'SELLER_AREA', value1);
	 	 if(value1 ==""){
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOff);
	 	 }else{
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOn);
	 	 }
	}else if(popupSel == "delReasonPop"){ // 삭제
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		for(var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i],"DEL_STATUS_CODE", value1);
			mySheet.SetCellValue(arrRow[i],"DEL_STATUS_CODE_TEXT", value2);
		}
		kepSave(document.masterMdCmBuyerCatalogAlterPop, mySheet, "/mdcm/delMasterMdCmBuyerCatalogAlterPop.do", "SELECTED");
	}else if(popupSel == "closeReasonPop"){ // 단종
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		for(var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i],"CLOSE_STATUS_CODE", value1);
		}
		
		$("#st_product_flag").val("Y");
		kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/confirmMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );
	}
	grbRow="";	//초기화
}

//그리드 셀 편집한 직후에 이벤트
function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	var new_yn = mySheet.GetCellValue(Row,"NEW_YN");
	if(column == 'LIST_PRICE' && new_yn != 'Y'){   //매입단가 수정시(신규는 해당없음.)
		 
		var agent_code   = mySheet.GetCellValue(Row,"AGENT");
		var process_type = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		var list_price   = mySheet.GetCellValue(Row,"LIST_PRICE");
		var process_source = mySheet.GetCellValue(Row,"PROCESS_SOURCE");
		
		if(process_type=="1"){
			alert("재고는 매입단가를 수정하실 수 없습니다.\n\n재고 매입단가 변경은 타 고객사 담당자와 협의후 기술연구소로 연락 주십시오");
			mySheet.ReturnCellData( Row , Col);
			return;
		}
		
		if(agent_code=="KRSESI0003"){
			alert("협력사가 KEP유통 경우 매입단가 변경이 되지 않습니다.");
			mySheet.ReturnCellData( Row , Col);
			return ;
		}
		
		// 매입단가 변경시
		if( isEmpty(list_price)){
			alert("매입단가를 확인 후 다시 입력해 주십시요");
			mySheet.ReturnCellData( Row , Col);
			return;
		}
		
		//매출원가 재계산
		//getBuyerPrimeCostRate(Row);
		
		mySheet.SetCellValue(Row,"SELECTED", "1");
		
	}
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {	
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		if(typeof(msg) == "object"){
			alert(msg.msg);			
		}else{
			alert(msg);
		}
	}
	
	if(code>0){
		//품의상신 flag 초기화.
		var st_approval_yn = $("#st_approval_yn").val();
		fn_change_approval('N');
		
		if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N" && msg.usrmsg != null && st_approval_yn == "Y"){
			var type = "";
			if(g_doc_type == "CCA"){
				type = "CCA";//품의구분CCA 계약추가
			}else{
				type = "CA";//품의구분	
			}			
			var buyer_code	= $("#st_buyer_code").val();
			
			//결재
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+buyer_code, "1000,500,no");
		}else{
			//저장 성공시 재조회
			location.reload();
		}
	}
		
}

function getCmsPopChoice() {
	var stSgKepYn = $("#st_sg_kep_yn").val();
	stSgKepYn = "Y";
	if(stSgKepYn=="Y") {
		doPop('commonCoCoStndrdCatalogSearchPop');
	}else {
		alert("표준카탈로그 매핑은 전략소싱팀에 요청 바랍니다.");
	}
	return ;
}

//이미지 미리보기
function preview_new(img) {
	$("#st_image_no").val(img);
	$("#image1").attr("src","");
	var dest    = document.getElementById("image1");
     //dest.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img + "',sizingMethod=scale)";
     dest.src = img;
}

//이미지 상세미리보기
function preview_detail_new(img) {
	$("#st_image_detail_no").val(img);
	$("#imageDetail1").attr("src","");
	var dest    = document.getElementById("imageDetail1"); 
     //dest.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img + "',sizingMethod=scale)";
     dest.src = img;
}
//이미지등록
function kepAddImage(){
	var fileName = $("#files").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	var dest1Width    = document.getElementById("image1").naturalWidth; 
	$("#masterMdCmBuyerCatalogAlterPop").attr("target","account_work");
	$("#masterMdCmBuyerCatalogAlterPop").attr("action","/mdcm/addMasterMdCmBuyerCatalogAlterPop.do").submit();
 	
}
//이미지등록
function kepAddDetailImage(){
	var fileName = $("#files2").val();
	if (fileName == ""){
		alert("이미지를 선택하세요.");
		return;
	} 	
	
	var dot = fileName.lastIndexOf(".");
	var ext = fileName.substring(dot).toLowerCase();
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		return;
	}
	
	$("#masterMdCmBuyerCatalogAlterPop").attr("target","account_work");
	$("#masterMdCmBuyerCatalogAlterPop").attr("action","/mdcm/addMasterMdCmBuyerCatalogAlterDetailPop.do").submit();
 	
}
//이미지 삭제
function kepDelImage(){
	if (!confirm(" 이미지를 삭제 처리 하시겠습니까?  ")) {
		return;
	}else{
		kepAjaxFormCall("/mdcm/delMasterMdCmCatalogImage.do","masterMdCmBuyerCatalogAlterPop","delImage");
	}
}

// 보관조건 저장(물질정보 담당자만)
function temp_cond_save(){
	if (!confirm("보관조건을 저장하시겠습니까?")) {
		return;
	}else{
		kepAjaxFormCall("/mdcm/saveMasterMdCmCatalogTempCond.do","masterMdCmBuyerCatalogAlterPop","saveTempCond");
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "delImage"){
		alert("이미지가 삭제되었습니다.");
		location.reload();
		return;
	}else if(pMethod == "saveTempCond"){
		alert("보관조건이 저장되었습니다.");
		location.reload();
		return;
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "delImage"){
		alert("이미지 삭제 중 오류가 발생하였습니다.");
		return;
	}else if(pMethod == "saveTempCond"){
		alert("보관조건 저장 중 오류가 발생하였습니다.");
		return;
	}
} 

function upSet(){
	alert("이미지가 등록/ 수정되었습니다.");
	loader_obj("N");
	location.reload();
	return;
}

//그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	var new_yn = mySheet.GetCellValue(Row,"NEW_YN");
	
	//신규 매출단가,매입단가 validation 체크 
	if(new_yn == "Y" && column == 'UNIT_PRICE'){
		if(isEmpty(Value) || !kepIsNumberString(Value)){
			alert("매출단가를 확인 후 다시 입력해 주십시요");
			mySheet.SetCellValue(Row,"UNIT_PRICE",mySheet.GetCellValue(1, "UNIT_PRICE"));
			return;			
		}
	}else if(new_yn == "Y" && column == 'LIST_PRICE'){
		if(isEmpty(Value) || !kepIsNumberString(Value)){
			alert("매입단가를 확인 후 다시 입력해 주십시요");
			mySheet.SetCellValue(Row,"LIST_PRICE",mySheet.GetCellValue(1, "LIST_PRICE"));
			return;			
		}
		//매출원가 재계산
		//getBuyerPrimeCostRate(Row);
	}
	
	//단가변경이력 관리를 위한 flag
	if(column == 'UNIT_PRICE' || column == 'LIST_PRICE'){   
		if(new_yn != "Y"){
			mySheet.SetCellValue(Row,"EP_CHECK","Y");
		}
	}
	
	//원산지, 제조사, 협력사, 매출, 매입, 품목구분, 표준납기일,단가유효일 변경시 품의상신 flag set
	// 변경 전 값을 확인하지 않아 변경점이 없어도 발생할 수 있음(매출, 매입 단가만 제외 후 따로 처리)
	if(column == 'AGENT' || column == 'ORIGIN_CODE' || column == 'ITEM_MAKE_TYPE' || column == 'DELIVERY_LT'|| column == 'CH_SELL_CLOSE_DATE'|| column == 'CH_BUY_CLOSE_DATE'){   //
		if(new_yn != "Y"){
			fn_change_approval('Y');
		}
	}
	
	mySheet.SetCellValue(Row,"SELECTED","1");
}

function setSysopCatalogChange() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var ccaYn = "";
	
	var moq_use_flag = "<%=moq_use_flag%>";
	var area_use_flag = "<%=area_use_flag%>";
	
	var price_chg_cnt = 0;
	
	//선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert(" 변경 할 대상을 선택해 주십시요.");
		return;
	}
	
	var session_userid	= "<%=sessionUserId%>";
	var buyer				= $("#st_buyer_code").val(); 
	
	if(session_userid == "KOREAB2B" || session_userid == "MASTER") {
		var sessionuser = $("#st_sessionuser").val();
		var sessionuser_str = sessionuser.split("@@");
		
		$("#st_user_id").val(sessionuser_str[0]);
		$("#st_user_name").val(sessionuser_str[1]);
		$("#st_user_tel").val(sessionuser_str[2]);
		$("#st_user_dept").val(sessionuser_str[3]);

		var select_user = $("#st_user_id").val();

		if((session_userid == "KOREAB2B" || session_userid == "MASTER" ) && (select_user == "KOREAB2B" || sessionuser == "ALL"))
		{
			alert("DB Admin은 실 수정자를 선택해 주십시요");
			return;
		}
	}
	for(var i=0; i<arrRow.length; i++){
		var new_yn = mySheet.GetCellValue(arrRow[i],"NEW_YN");
		if(new_yn != "Y"){
			ccaYn = "N";
		}
	}
	for(var i=0; i<arrRow.length; i++){
		var new_yn = mySheet.GetCellValue(arrRow[i],"NEW_YN");
		var gbn_product = mySheet.GetCellValue(arrRow[i],"ITEM_MAKE_TYPE");
		var gbn_delivery_lt = mySheet.GetCellValue(arrRow[i],"DELIVERY_LT");
		var min_order_qty = mySheet.GetCellValue(arrRow[i], "MIN_ORDER_QTY");
		var pur_unit_qty = mySheet.GetCellValue(arrRow[i], "PUR_UNIT_QTY");
		var seller_area = mySheet.GetCellValue(arrRow[i], "SELLER_AREA");
		var sell_close_date = mySheet.GetCellValue(arrRow[i], "CH_SELL_CLOSE_DATE");
		var buy_close_date = mySheet.GetCellValue(arrRow[i], "CH_BUY_CLOSE_DATE");
		if(gbn_delivery_lt== ""){
			alert("표준납기일을 입력해주세요.");
			return;
		}		
		if(gbn_product== ""){
			alert("품목구분을 선택해주세요.");
			return;
		}
		//수정일 때는 마진율 체크. 신규 저장은 skip		
		if(new_yn!="Y"){
	        var unit_price = eval(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE")); //매출단가
	        var list_price = eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE")); //매입단가
			
	        if(unit_price <= 0){
	        	alert("매출단가를 확인해주세요.");
	        	return;
	        }

			var rate      = ((unit_price - list_price)/unit_price)*100;
			//두산중공업의 경우 마진율을 2.97가 넘으면 안된다. 체크는 2.97로 체크
			var dood0001_rate      = kepGetRound(((unit_price - list_price)/unit_price)*100,3);
			
			var check_flag = mySheet.GetCellValue(arrRow[i],"CHECK_FLAG");
			if(check_flag == "Y"){
				if(buyer == "KRDOOD0001" || buyer == "KRDOOS0004") {
					if(eval(dood0001_rate) > 3.05) {
						alert("마진이 3.05 이상입니다.\n\n등록 불가 합니다.");
						 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
						//setSysopCatalogChange();
						return;
					}
				} else if(buyer=="KRDOOS0033" || buyer=="KRDOOS0035" || buyer=="KRDOOS0041") {
					if(eval(dood0001_rate) > 4.10) {
						alert("마진이 4.10 이상입니다.\n\n등록 불가 합니다.");
						 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
						//setSysopCatalogChange();
						return;
					}
				} else if(buyer=="KRKORE0254" || buyer=="KRDOOS0006") {//KEP_건설_두산메카텍, 두산건설(주) 산업기계
					if(eval(dood0001_rate) > 3.9) {
						alert("마진이 3.9 이상입니다.\n\n등록 불가 합니다.");
						 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
						//setSysopCatalogChange();
						return;
					}
	            }else if(buyer=="KRHSDE0001" || buyer=="KRHSDE0003") {//두산엔진(주) 
					if(eval(dood0001_rate) > 3.69) {
						alert("마진이 3.69 이상입니다.\n\n등록 불가 합니다.");
						 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
						//setSysopCatalogChange();
						return;
					}
				}
				
				/* 요구사항(REQ_182)
				if(eval(kep_price)>=eval(unit_price)) {
					alert("노마진/역마진 입니다.\n\n품의시스템을 이용하여 단가를 수정하시길 바랍니다.");
					return ;
				}
				*/
				
				if(eval(rate) > 30) {
					cc = confirm(arrRow[i]+"번째행의 마진율이 30% 이상입니다.\n\n현재 단가로 등록하시겠습니까?");
					if(cc == false){
						mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
						//setSysopCatalogChange();
						return;
					}
				}				
			}
			
			var bef_unit_price = eval(mySheet.GetCellValue(arrRow[i],"BEF_UNIT_PRICE")); //변경 전 매출단가
			var unit_price_chg_reason = mySheet.GetCellValue(arrRow[i],"UNIT_PRICE_CHANGE_REASON");
			if(bef_unit_price == unit_price) { // 변경 전 매출단가와 변경 후 매출단가가 같은경우				
				if(unit_price_chg_reason != "") { // 매출단가 변동사유가 채워져있는 경우
					alert("매출단가 변동 없습니다. 매출단가 변동사유 확인바랍니다.");					
					return;
				}
			} else {
				price_chg_cnt++;
			}
			var bef_list_price = eval(mySheet.GetCellValue(arrRow[i],"BEF_LIST_PRICE")); //변경 전 매입단가
			var list_price_chg_reason = mySheet.GetCellValue(arrRow[i],"LIST_PRICE_CHANGE_REASON");
			if(bef_list_price == list_price) { // 변경 전 매입단가와 변경 후 매입단가가 같은경우				
				if(list_price_chg_reason != "") { // 매입단가 변동사유가 채워져있는 경우
					alert("매입단가 변동 없습니다. 매입단가 변동사유 확인바랍니다.");					
					return;
				}
			} else {
				price_chg_cnt++;
			}
			
			g_doc_type = "CA";
		}else{
			if(ccaYn == "N"){
				alert("계약추가건만 저장 가능합니다.");
				 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
				return;
			}
			g_doc_type = "CCA";
		}
		
		if(moq_use_flag == "Y"){
			if(min_order_qty < 1 || kepIsValueNull(min_order_qty)){
				alert("MOQ(숫자형식)를 입력하세요.(최소값:1)");
				mySheet.SelectCell(arrRow[i], "MIN_ORDER_QTY");
				return;
			}
			if(pur_unit_qty < 1 || kepIsValueNull(pur_unit_qty)){
				alert("발주배수(숫자형식)를 입력하세요.(최소값:1)");
				mySheet.SelectCell(arrRow[i], "PUR_UNIT_QTY");
				return;
			}
		}
		
		if(area_use_flag == "Y"){
			if(kepIsValueNull(seller_area)){
				alert("납품지역을 선택하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "SELLER_AREA_IMG");
				return;
			}
		}
		if(sell_close_date== ""){
			alert("매출단가 유효일을 입력하세요.");
			mySheet.SelectCell(arrRow[i], "CH_SELL_CLOSE_DATE");
			return;
		}
		if(buy_close_date== ""){
			alert("매입단가 유효일을 입력하세요.");
			mySheet.SelectCell(arrRow[i], "CH_BUY_CLOSE_DATE");
			return;
		}
	}
	
	if(price_chg_cnt > 0) { // 체크된 것중 단가변경이 있으면 품의
		fn_change_approval('Y');
	}
	//안전인증서 상태 체크
	var st_old_safety_flag = $('#st_old_safety_flag').val();
	var st_safety_flag = $('#st_safety_flag').val();
	var st_image_key = $('#st_image_key').val();
	if(st_old_safety_flag=="Y" && st_safety_flag =="N"){
		alert("고객사에서 안전 인증서를 요청한 견적건은 미요청으로 변경 불가능 합니다.");
		$('#st_safety_flag').focus();
		return;		
	}
	//안전인증서 첨부시 첨부파일 체크
	if(kepIsValueNull(st_image_key) && st_safety_flag =="A"){
		alert("안전인증서 첨부 바랍니다.");
		return;		
	}
	var st_approval_yn = $("#st_approval_yn").val();
	if(st_approval_yn == "Y"){
		doPop('masterMdCmChangeReasonPop');
	}else{
		doAction('save');
	}
}

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	
	mySheet.SetCellValue(rows, 'NEW_YN', 'Y');
	mySheet.SetCellValue(rows, 'INS', 'N');
	mySheet.SetCellValue(rows, 'SELECTED', "1");
	mySheet.SetCellValue(rows, 'ITEM_GROUP_TEXT', "사업팀");
	mySheet.SetCellValue(rows, 'ITEM_GROUP', "M");
	mySheet.SetCellValue(rows, 'AGENT_NAME', mySheet.GetCellValue(1, 'AGENT_NAME'));
	mySheet.SetCellValue(rows, 'AGENT', mySheet.GetCellValue(1, 'AGENT'));
	mySheet.SetCellValue(rows, 'MAKER_NAME', mySheet.GetCellValue(1, 'MAKER_NAME'));
	mySheet.SetCellValue(rows, 'MAKER_CODE', mySheet.GetCellValue(1, 'MAKER_CODE'));	
	mySheet.SetCellValue(rows, 'MAKER_PART_NO', mySheet.GetCellValue(1, 'MAKER_PART_NO'));
	mySheet.SetCellValue(rows, 'UNIT_PRICE', mySheet.GetCellValue(1, 'UNIT_PRICE'));
	mySheet.SetCellValue(rows, 'LIST_PRICE', mySheet.GetCellValue(1, 'LIST_PRICE'));
	mySheet.SetCellValue(rows, 'ORIGIN_TEXT', mySheet.GetCellValue(1, 'ORIGIN_TEXT'));
	mySheet.SetCellValue(rows, 'ORIGIN_CODE', mySheet.GetCellValue(1, 'ORIGIN_CODE'));
	mySheet.SetCellValue(rows, 'PROCESS_TYPE', mySheet.GetCellValue(1, 'PROCESS_TYPE'));
	mySheet.SetCellValue(rows, 'PROCESS_TEXT', mySheet.GetCellValue(1, 'PROCESS_TEXT'));
	mySheet.SetCellValue(rows, 'BELOW_COMORG_CODE', mySheet.GetCellValue(1, 'BELOW_COMORG_CODE'));
	mySheet.SetCellValue(rows, 'BELOW_TEXT', mySheet.GetCellValue(1, 'BELOW_TEXT'));
	mySheet.SetCellValue(rows, 'ORIGIN_AGENT', mySheet.GetCellValue(1, 'ORIGIN_AGENT'));
	mySheet.SetCellValue(rows, 'ORIGIN_AGENT_NAME', mySheet.GetCellValue(1, 'ORIGIN_AGENT_NAME'));
	//mySheet.SetCellValue(rows, 'KEP_PRICE', mySheet.GetCellValue(1, 'KEP_PRICE'));
	mySheet.SetCellValue(rows, 'IMPORT_FLAG', mySheet.GetCellValue(1, 'IMPORT_FLAG'));
	mySheet.SetCellValue(rows, 'CONTRACT_NO', mySheet.GetCellValue(1, 'CONTRACT_NO'));
	mySheet.SetCellValue(rows, 'BEF_CONTRACT_SEQ', mySheet.GetCellValue(1, 'CONTRACT_SEQ'));
	mySheet.SetCellValue(rows, 'SELLER_ITEM_NO', mySheet.GetCellValue(1, 'SELLER_ITEM_NO'));
	//mySheet.SetCellValue(rows, 'LOGISTICS_FEE', '0');
	mySheet.SetCellValue(rows, 'BEF_UNIT_PRICE', mySheet.GetCellValue(1, 'BEF_UNIT_PRICE'));
	mySheet.SetCellValue(rows, 'BEF_LIST_PRICE', mySheet.GetCellValue(1, 'BEF_LIST_PRICE'));
	//mySheet.SetCellValue(rows, 'BEF_KEP_PRICE', mySheet.GetCellValue(1, 'BEF_KEP_PRICE'));
	mySheet.SetCellValue(rows, 'BEF_ORIGIN_CODE', mySheet.GetCellValue(1, 'BEF_ORIGIN_CODE'));
	mySheet.SetCellValue(rows, 'BEF_MAKER_CODE', mySheet.GetCellValue(1, 'BEF_MAKER_CODE'));
	mySheet.SetCellValue(rows, 'BEF_MAKER_NAME', mySheet.GetCellValue(1, 'BEF_MAKER_NAME'));
	mySheet.SetCellValue(rows, 'BEF_AGENT', mySheet.GetCellValue(1, 'BEF_AGENT'));
	mySheet.SetCellEditable(rows, "MAKER_PART_NO", 0);
	//mySheet.SetCellEditable(rows, "SELLER_ITEM_NO", 0); - 2017.04.05 HSJ 삭제(전략소싱팀 박수지DR 요청)
	mySheet.SetCellEditable(rows, "IMPORT_FLAG", 0);	
	mySheet.SetCellValue(rows, "SELLER_AREA_IMG", areaOff);
	mySheet.SetCellValue(rows, 'CH_SELL_CLOSE_DATE', mySheet.GetCellValue(1, 'CH_SELL_CLOSE_DATE'));
	mySheet.SetCellValue(rows, 'CH_BUY_CLOSE_DATE', mySheet.GetCellValue(1, 'CH_BUY_CLOSE_DATE'));
	
	fn_change_approval('Y');
}

//창 닫을때 이벤트 발생.
function winClose(){
	var flag = $("#st_open_flag").val();
	if(flag =="DONGBU_NW"){ 
		opener.doAction('search');
	}else if(flag =="DONGBU_IG"){ 
		var des = $("#st_description").val(); 
		var spe = $("#st_specification").val();
		opener.setDesSpe(des, spe);
	}
}

// TEXTAREA 최대값 체크
function fn_TextAreaInputLimit(gbn,maxSize) {

    var tempText = $("textarea[name='"+gbn+"']");
    var tempChar = "";                                        // TextArea의 문자를 한글자씩 담는다
    var tempChar2 = "";                                        // 절삭된 문자들을 담기 위한 변수
    var countChar = 0;                                        // 한글자씩 담긴 문자를 카운트 한다
    var tempHangul = 0;                                        // 한글을 카운트 한다

    // 글자수 바이트 체크를 위한 반복
    for(var i = 0 ; i < tempText.val().length; i++) {
        tempChar = tempText.val().charAt(i);
        // 한글일 경우 2 추가, 영문일 경우 1 추가
        if(escape(tempChar).length > 4) {
            countChar += 2;
            tempHangul++;
        } else {
            countChar++;
        }
    }
    // 카운트된 문자수가 MAX 값을 초과하게 되면 절삭 수치까지만 출력을 한다.(한글 입력 체크)
    // 내용에 한글이 입력되어 있는 경우 한글에 해당하는 카운트 만큼을 전체 카운트에서 뺀 숫자가 maxSize보다 크면 수행
    if((countChar-tempHangul) > maxSize) {
        alert("최대 입력 글자수를 초과하였습니다.");
        tempChar2 = tempText.val().substr(0, maxSize-1);
        tempText.val(tempChar2);
    }
}

function fn_change_approval(flag){
	$("#st_approval_yn").val(flag);
}

function kepApprovalReturn(flag,docu_no){
	//결재상신시에 페이지 새로고침.
	location.reload();
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}
}
//납품가능협력사 팝업.
function getBtoaSprInfo(){
	var buyer= "<%=st_buyer_code%>";
	var catalog_com_code = "<%=st_catalog_com_code%>";
	var buyer_item_no = "<%=st_buyer_item_no%>";
	openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogBtoaPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"500,350,no");
}

 //-->
</script> 
<body onload="kep_onload_view();" onunload="winClose();">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="masterMdCmBuyerCatalogAlterPop" id="masterMdCmBuyerCatalogAlterPop" method=post  modelAttribute="uploadForm" enctype="multipart/form-data">
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<!-- 화면 내 정의 -->
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_user_name" name="st_user_name"  value="${sessionInfo.userNameLoc}">
	<input type="hidden" id="st_user_tel" name="st_user_tel"  value="${sessionInfo.tel}">
	<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
	<input type="hidden" id="st_product_flag" name="st_product_flag" value ="">
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=st_buyer_code%>">
	<input type="hidden" id="st_catalog_com_code"  name="st_catalog_com_code" value="<%=st_catalog_com_code%>">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="<%=st_buyer_item_no%>">
	<input type="hidden" id="st_change_remark" name="st_change_remark"		value ="">
	<input type="hidden" id="st_flag_cms_user" name="st_flag_cms_user"		value ="<%=bFlagCmsUser%>">
	<input type="hidden" id="st_masterflag_check"  name="st_masterflag_check" value="">
	<input type="hidden" id="st_open_flag"  name="st_open_flag"  value="<%=open_flag%>">
	<input type="hidden" id="st_approval_yn"  name="st_approval_yn"  value="<%=st_approval_yn%>">
	<input type="hidden" name="onepagerow" value="10" >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:720px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 카탈로그 변경 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<div id="ContArea" style="width:940px;margin-left:0;" >
           	<!--grid-->
            <div class="scrollArea" style="height:365px">
			
			<% if (_rowData != null) {  %>
                <table  style="width:100%">
                    <caption>고객사 카탈로그 변경  리스트</caption>
                    <colgroup>
                    	<col width="220px" />
	                    <col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td width="220" vAlign="top">
								<table border="0" cellSpacing="0" cellPadding="0" width="100%">
								<tbody>
									<tr>
										<td height="230" vAlign="top" align="center">&nbsp;&nbsp; &nbsp; 
										<%
		                                 String image_dr  = _rowData.get("IMGFILE_DIR");
		                                 String image_sm = _rowData.get("IMGFILE_NAME");
		                                 if (image_sm == null || image_sm.equals("null") || image_sm.equals("") || image_sm.equals(" ")){
		                                	 image_sm = "icon_emptyimg.gif";
		                                 }
		                                 if(image_sm.equals("icon_emptyimg.gif")) {
										%>
											<img src = "/resources/images/<%=image_sm%>"  id="image1" name="image1" width="200" height="200">
										<%}else{%>
											<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"%>','<%=image_sm%>')" >
		                                    	<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"+image_sm%>"   id="image1" name = "image1" width="200" height="200" border="0">
		                                    </a>
										<%}%>
										</td>
										<td width="20">&nbsp;</TD>
									</tr>
								</tbody>
								</table>
								<table align="center" border="0" cellSpacing="0" cellPadding="0">
								<tbody>
								<tr>
									<td width="25">
										<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"%>','<%=image_sm%>')">
											<img src="/resources/images/btn_search03.gif">
										</a>
									</td>
									<td>
										<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"%>','<%=image_sm%>')">상품이미지 확대보기</a>
										<input id="st_image_dir" name=st_image_dir type=hidden value="<%=_rowData.get("IMGFILE_DIR")%>" > 
										<input id="st_image_name" name=st_image_name type=hidden value="<%=_rowData.get("IMGFILE_NAME")%>" > 
										<input id="st_image_dir2" name=st_image_dir2" type=hidden value="<%=_rowData.get("DETAIL_IMGFILE_DIR")%>" > 
										<input id="st_image_name2" name=st_image_name2"  type=hidden value="<%=_rowData.get("DETAIL_IMGFILE_NAME")%>" > 
									</td>
								</tr>
								</tbody>
								<table border="0" cellSpacing="0" cellPadding="0" width="100%">
								<tbody>
								<!-- tr>
										<td height="230" vAlign="top" align="center">&nbsp;&nbsp; &nbsp; 
										<%
		                                 String image_dr1  = _rowData.get("DETAIL_IMGFILE_DIR");
		                                 String image_sm1 = _rowData.get("DETAIL_IMGFILE_NAME");
		                                 if (image_sm1 == null || image_sm1.equals("null") || image_sm1.equals("") || image_sm1.equals(" ")){
		                                	 image_sm1 = "icon_emptyimg.gif";
		                                 }
		                                 if(image_sm1.equals("icon_emptyimg.gif")) {
										%>
											<img src = "/resources/images/<%=image_sm1%>"  id="imageDetail1" name="imageDetail1" width="200" height="200">
										<%}else{%>
											<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"%>','<%=image_sm1%>')" >
		                                    	<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"+image_sm1%>"   id="imageDetail1" name = "imageDetail1" width="200" height="200" border="0">
		                                    </a>
										<%}%>
										</td>
										<td width="20">&nbsp;</TD>
									</tr -->
								</tbody>
								</table>
								<table align="center" border="0" cellSpacing="0" cellPadding="0">
								<tbody>
								<!--tr>
									<td width="25">
										<a href="javascript:setImageView2('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"%>','<%=image_sm1%>')">
											<img src="/resources/images/btn_search03.gif">
										</a>
									</td>
									<td>
										<a href="javascript:setImageView2('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr1+"/"%>','<%=image_sm1%>')">상품상세 확대보기</a>
										<input id="st_image_dir2" name=st_image_dir2" type=hidden value="<%=_rowData.get("DETAIL_IMGFILE_DIR")%>" > 
										<input id="st_image_name2" name=st_image_name2"  type=hidden value="<%=_rowData.get("DETAIL_IMGFILE_NAME")%>" > 
									</td>
								</tr-->
								</tbody>
								</table>
								
							</td>
							<td align="center">
							<table  class="cont_t_list06"  style="width:100%">
								<colgroup>
				                    <col width="120px" />
				                    <col width="32%" />
				                    <col width="120px" />
				                    <col width="32%" />
				                </colgroup>
				                <tbody>
					                <tr>
				                        <th  scope="row">품목코드</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("BUYER_ITEM_NO"))%>
				                      		<input type="hidden" id="st_sg_kep_yn"  name="st_sg_kep_yn"  value="<%=_rowData.get("SG_KEP_YN")%>">
				                      	</td>
				                        <th  scope="row">적용구분</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("CATAL_TYPE"))%>
				                      	</td>
				                    </tr>
				                    <tr>
				                        <th  scope="row">상태</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("STATUS_TEXT"))%>&nbsp;/&nbsp;
				                      		<%
				                      			//SLOGIC-BEGIN(P03-3022-04)
												if(st_buyer_code.equals("KRDUPO0001")) { 
											%> 
													<select id="st_process_flag" name="st_process_flag">
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("N") ? "selected" : "")%> value = "N">승인</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("Y") ? "selected" : "")%> value = "Y">단종</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("T") ? "selected" : "")%> value = "T">I/F품목</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("A") ? "selected" : "")%> value = "A">일회용_미발주</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("C") ? "selected" : "")%> value = "C">일회용_기발주</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("B") ? "selected" : "")%> value = "B">BLOCKED</option> 
													</select>  						  
											<%
												} else if(st_buyer_code.equals("KRDOOD0001")) { 
											%> 											  
													<select id="st_process_flag" name="st_process_flag">
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("N") ? "selected" : "")%> value = "N">승인</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("Y") ? "selected" : "")%> value = "Y">단종</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("T") ? "selected" : "")%> value = "T">I/F품목</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("A") ? "selected" : "")%> value = "A">일회용_미발주</option>
													  <option <%=(_rowData.get("PRODUCT_CLOSE_FLAG").equals("C") ? "selected" : "")%> value = "C">신규요청품목</option> 
													</select>														  
																						  
											<%
												} else {
											%>
													<%=_rowData.get("PRODUCT_TEXT")%>
													<input type="hidden" id="st_process_flag" name="st_process_flag" value = "<%=_rowData.get("PRODUCT_CLOSE_FLAG")%>">
											<%
												}
				                      			//SLOGIC-END
											%> 	
											     <%=_rowData.get("STCK_ITEM_NO")%> 
				                      	</td>
				                        <th  scope="row">단가유형</th>
				                      	<td>
				                      		<select id="st_fixed_price_flag" name="st_fixed_price_flag">
                                               <option <%=(_rowData.get("FIXED_PRICE_FLAG").equals("Y") ? "selected" : "")%> value = "Y">·고정단가</option>
                                               <option <%=(_rowData.get("FIXED_PRICE_FLAG").equals("N") ? "selected" : "")%> value = "N">·가변단가  </option>
                                             </select>
									    </td>
				                    </tr>
				                    <tr>
									   <th scope="row">첨부파일</th>
				                      	<td>
				                      		<input type="hidden" id="st_image_key" name="st_image_key" class="input_type_text" title="" style="width:110px;" value="<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>" />
		                      		
					                      		<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload2','<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>')">파일첨부</a></span>
					                      						               
					                      		<%
											if (("").equals(CommonUtil.nvl(_rowData.get("IMAGE_KEY")))) { 
											%>
												<img class="center" name = "image_key_img"  id="diskimg"  src="/resources/images/disk_off.gif" border="0"   >
											<%
												}else{
											%>         
												<a class="center" class="hyperLink" href="javascript:doPop('fileUpload2','<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>')"><img name = "image_key_img"  id="diskimg"  src="/resources/images/disk_on.gif" border="0"></a>    
											<%
												}
											%>
				                      	</td>
				                      	<input type="hidden" id="st_moq_qty" name="st_moq_qty" class="input_type_text" title=""  maxlength="10" style="width:70%;"  value="<%=_rowData.get("MOQ_QTY")%>" />
				                      	<th  scope="row">단종사유</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("CLOSE_STATUS_CODE_TEXT"))%>
				                      	</td>
 			                       </tr>
				                    <tr>
										<th scope="row" >안전인증서상태</th>
				                        <td>
				                        	<input type="hidden"  id="st_old_safety_flag"  name="st_old_safety_flag"  value="<%=_rowData.get("SAFETY_FLAG")%>" />
				                      		<select id="st_safety_flag" name="st_safety_flag" style="width:110px;height:20px">
												<%= CommonUtil.getCodeComboList("M160", "", CommonUtil.nvl(_rowData.get("SAFETY_FLAG"), "N"), "", "", "") %>
				                      		</select>
				                        </td>
										<th scope="row" >HS CODE</th>
				                        <td>
				                        	<input type="text" id="st_hscode" name="st_hscode"  class="input_type_text" title="" style="width:93%;" value = "<%=_rowData.get("HS_CODE")%>" />
				                        </td>
									</tr>
				                    <tr>
										<th scope="row" >품절여부</th>
				                        <td colspan="3" >
				                      		<select id="st_over_short_flag" name="st_over_short_flag">
                                               <option <%=(CommonUtil.nvl(_rowData.get("OVER_SHORT_FLAG"),"N").equals("N") ? "selected" : "")%> value = "N">N</option>
                                               <option <%=(CommonUtil.nvl(_rowData.get("OVER_SHORT_FLAG"),"N").equals("Y") ? "selected" : "")%> value = "Y">Y</option>
                                             </select>
				                        	<input type="text"  class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:63px; text-align:center;" value="<%=CommonUtil.formatStrinigDate(_rowData.get("HS_NO"))%>"><a href="javascript:kepCalendar('st_from_date')"></a>
				                        	<a href="javascript:kepEraser('st_from_date');"><img src="/resources/images/btn_eraser2.gif"></a>
				                        </td>
									</tr>
				                    <tr>
										<th scope="row" >품목명</th>
				                        <td colspan="3" >
				                        	<!-- <input type="text" id="st_description" name="st_description"  class="input_type_text" title="" style="width:93%;" value = "<%=_rowData.get("DESCRIPTION_LOC")%>"   onclick = "alert('품목명변경 필요시 S/R요청 바랍니다.')" READONLY/> -->
				                        	<input type="text" id="st_description" name="st_description"  class="input_type_text" title="" style="width:93%;" value = "<%=_rowData.get("DESCRIPTION_LOC")%>" onchange="fn_change_approval('Y');"/>
				                        	<input type="hidden" id="st_bef_description"  name="st_bef_description"  value="<%=_rowData.get("DESCRIPTION_LOC")%>">
				                        </td>
									</tr>
									<tr>
										<th scope="row">규격</th>
				                        <td colspan="3">
				                        	<input type="text" id="st_specification" name="st_specification"class="input_type_text" title="" style="width:93%;" maxlength="1000" value = "<%=_rowData.get("SPECIFICATION")%>"  onchange=""/>
				                        	<input type="hidden" id="st_bef_specification"  name="st_bef_specification"  value="<%=_rowData.get("SPECIFICATION")%>">
				                        </td>
									</tr>
									<tr>
										<th scope="row" >품목명(영문)</th>
				                        <td colspan="3" >
				                        	<input type="text" id="st_description_eng" name="st_description_eng" class="input_type_text" title="" style="width:93%;" value = "<%=_rowData.get("DESCRIPTION_ENG")%>" />
				                        </td>
									</tr>
									<tr>
										<th scope="row">규격(영문)</th>
				                        <td colspan="3">
				                        	<input type="text" id="st_specification_eng" name="st_specification_eng" class="input_type_text" title="" style="width:93%;" maxlength="1000" value = "<%=_rowData.get("SPECIFICATION_ENG")%>" />
				                        </td>
									</tr>
									<tr>
										<th scope="row">KeP표준화규격</th>
				                        <td colspan="3">
				                        	<%=CommonUtil.nvl(_rowData.get("REFINE_NOTE"))%>
				                        </td>
									</tr>
				                    <tr>
					                    <th scope="row">보관조건 / 온도</th>
				                      	<td colspan="3">
				                      		<select id="st_temp_cond" name="st_temp_cond" style="width:110px;height:24px" <%=getRoleYn == true ? "" : "disabled"%>>
				                      			<%= CommonUtil.getCodeComboList("M203", "SEL", CommonUtil.nvl(_rowData.get("TEMP_COND")), "", "", "") %>
				                      		</select>
				                      		/
				                      		<input type="text" id="st_temp_range" name="st_temp_range" class="input_type_text" title="" style="width:45%;" value="<%=_rowData.get("TEMP_RANGE")%>" <%=getRoleYn == true ? "" : "disabled"%>/>
									<%if(getRoleYn == true){%>
				                      		<span class="btn_gray_06">
				                      			<a href="javascript:temp_cond_save();">보관조건 저장</a>
				                      		</span>
									<%}%>
				                      	</td>
			                      	</tr>
			                      	<tr>
					                    <th scope="row" >표준화진행자</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("REFINE_USER_NM"))%>
				                      	</td>
				                        <th scope="row" >납품가능협력사</th>
				                      	<td>
				                      		<a href="javascript:getBtoaSprInfo()"><font color="blue"><%=CommonUtil.nvl(_rowData.get("BTOA_MNG_CNT"))%></font></a>
				                      	</td>
			                      	</tr>
									<tr>
				                        <th scope="row" >단위</th>
				                      	<td>
				                      		<input type="text" id="st_unit_measure" name="st_unit_measure" class="input_type_text" title=""  maxlength="10" style="width:93%;" value = "<%=_rowData.get("UNIT_MEASURE")%>"  onchange=""/>
				                      		<input type="hidden" id="st_bef_unit_measure"  name="st_bef_unit_measure"  value="<%=_rowData.get("UNIT_MEASURE")%>">
				                      	</td>
				                        <th scope="row" >SG / 과세구분</th>
				                      	<td>
				                      		<%=CommonUtil.nvl(_rowData.get("SG_NM"))%>&nbsp;/&nbsp;
				                      		<select id="st_tax_type" name="st_tax_type"><%= CommonUtil.getCodeComboList("TX17", "", CommonUtil.nvl(_rowData.get("TAX_TYPE")), "", "", "") %></select>
				                      	</td>
				                    </tr>
				                    <tr>
					                    <th scope="row" >계정항목</th>
				                      	<td>
				                      		<input type="text" id="st_account_text" name="st_account_text"class="input_type_text" title="" style="width:70%;" value="<%=_rowData.get("ACCOUNT_TEXT")%>"  READONLY />
				                      		<a href="javascript:doPop('commonCoCoAccountItemPop');"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="st_account_type" name="st_account_type" value = "<%=_rowData.get("ACCOUNT_TYPE")%>">
				                      	</td>
				                        <th scope="row" >표준카탈로그</th>
				                      	<td>
				                      		<input type="text" id="st_stdcatlg_id" name="st_stdcatlg_id"class="input_type_text" title="" style="width:70%;"  value="<%=_rowData.get("CMS_CATLG_ID")%>"  readonly />
				                      		<a href="javascript:getCmsPopChoice();"><img src="/resources/images/btn_search03.gif"></a>
				                      		<input type="hidden" id="org_stdcatlg_id" name="org_stdcatlg_id" value = "<%=_rowData.get("CMS_CATLG_ID")%>">
                                            <input type="hidden" id="st_item_seq" name="st_item_seq" value="">
                                            <input type="hidden" id="st_std_check" name="st_std_check" value="<%=_rowData.get("MATTR_CHECK")%>">
                                            <input type="hidden" id="st_catalog_choice_type" name="st_catalog_choice_type" value="<%=_rowData.get("CATALOG_CHOICE_TYPE")%>">
				                      	</td>
			                      	</tr>
			                      	<tr>
										<th scope="row">카테고리</th>
				                        <td colspan="3">
				                        	<input type="text" id="st_category_path" name="st_category_path"class="input_type_text" title="" style="width:88%;" maxlength="150" value="<%=_rowData.get("CATEG_PATH")%>"  READONLY/>
				                        	<a href="javascript:doPop('commonCoCoBuyerCategoryChoicePop');"><img src="/resources/images/btn_search03.gif"></a>
				                        	<input type="hidden" id="st_category_id" name="st_category_id" value = "<%=_rowData.get("CATEGORY_NO")%>">
                                            <input type="hidden" id="st_category_name" name="st_category_name" value = "<%=_rowData.get("CATEGORY_NAME")%>">
				                        </td>
									</tr>
									<tr>
										<th scope="row">표준카테고리</th>
				                        <td colspan="3">
				                        	<input type="text" id="st_stdcateg_path" name="st_stdcateg_path" class="input_type_text" title="" style="width:93%;" maxlength="150" value="<%=_rowData.get("STD_CATEG_PATH")%>"  READONLY/>
				                        </td>
				                        <input type="hidden" id="st_stdcateg_no" name="st_stdcateg_no" value = "<%=_rowData.get("CMS_CATEG_ID")%>">
									</tr>
									<tr>
										<th scope="row">운영자이력</th>
				                        <td colspan="3">
				                        	<textarea rows="3" class="input_type_text" style="width:95%" id = "kep_remark" name = "kep_remark" onkeyup="javascript:fn_TextAreaInputLimit('kep_remark',200);"><%=_rowData.get("KEP_REMARK")%></textarea></td>
				                        </td>
									</tr>
									<tr>
										<th scope="row">상세설명</th>
				                        <td colspan="3">
				                        	<textarea rows="3" class="input_type_text" style="width:95%" id = "st_detail_desc" name = "st_detail_desc" onkeyup="javascript:fn_TextAreaInputLimit('st_detail_desc',1000);"><%=_rowData.get("ITEM_DETAIL_DESC")%></textarea></td>
				                        </td>
									</tr>
									<tr>
										<th scope="row">카탈로그 이미지</th>
				                        <td colspan="3">
						                	<input type="hidden" name="st_image_no" id="st_image_no" value="" />
											<input name="files" id="files" type="file" size="18" onchange="preview_new(this.value);" value=""  style="width:200px;"/>										
											<span class="btn_gray_02"><a href="javascript:kepAddImage();">등록/수정</a></span>
											<font color="red"><b>*</b>이미지 등록시 [등록/수정]버튼 꼭 클릭</font>
				                        </td>
									</tr>
									<tr>
										<th scope="row">상세이미지</th>
				                        <td colspan="3">
						                	<input type="hidden" name="st_detail_image_no" id="st_detail_image_no" value="" />
											<input name="files2" id="files2" type="file" size="18" onchange="preview_detail_new(this.value);" value=""  style="width:200px;"/>					
											<span class="btn_gray_02"><a href="javascript:kepAddDetailImage();">등록/수정</a></span>
											<font color="red"><b>*</b>이미지 등록시 [등록/수정]버튼 꼭 클릭</font>
				                        </td>
									</tr>
				                </tbody>
								</table>
							</td>
						</tr>
					</tbody>
                </table>
        	<% }%>
        	</div>
        	<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "200px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
<%
	//SLOGIC-BEGIN(P03-3022-03)
    if(sessionUserId.equals("MASTER") || sessionUserId.equals("KOREAB2B") ){
    	
%>  
	수정자 : <select id="st_sessionuser" name="st_sessionuser">
                <option value="ALL" selected>전체</option>
<%
		Map<String,String> _rowUserData = null;
		if (_userDataList != null && _userDataList.size() != 0) { 
			for( int z =0 ; z < _userDataList.size(); z++){
				_rowUserData = _userDataList.get(z);
%>                
                <option value="<%=_rowUserData.get("USER_ID")%>@@<%=_rowUserData.get("USER_NAME_LOC")%>@@<%=_rowUserData.get("PHONE_NUMBER")%>@@<%=_rowUserData.get("DEPARTMENT")%>"><%=_rowUserData.get("USER_NAME_LOC")%></option>
<%
     		}
		}
%>        
				</select>
				<input type="hidden" id="st_session_username" name="st_session_username" value="${sessionInfo.userNameLoc}">        
<%
    }else {
%>	          	
  					수정자 : <input type="text"   id="st_session_username" name="st_session_username" size="12"  value="${sessionInfo.userNameLoc}" READONLY >
<%
    }
	//SLOGIC-END
%>  					
  				</span>
  				
  				<span class="fr">
  				<%
  					if(_rowData != null){
  						if(_rowData.get("CMC_FLAG").equals("Y")){
  				%>
  						<span class="btn_06 mr04"><a href="javascript:doAction('addCmc');">물질정보 요청</a></span>  					
  				<%
  						}
  					}
  				%>
  					<!--  span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span-->
  					<!-- span class="btn_02 mr04"><a href="javascript:doAction('confirm','N');">거래</a></span-->
  					<!--  span class="btn_02 mr04"><a href="javascript:doAction('confirm','Y');">단종</a></span-->
				<%
  					if(!(st_edit_yn.equals("N"))) {
  				%>
  						<span class="btn_02 mr04"><a href="javascript:addrows();">계약추가</a></span>
  						<span class="btn_02"><a href="javascript:setSysopCatalogChange();">저장</a></span>
  				<%
  					}else{ // N 이면
  						if((st_sour_dept_yn.equals("Y"))) { // 구매팀이면 저장 보임
  				%>
  						<span class="btn_02 mr04"><a href="javascript:addrows();">계약추가</a></span>
  						<span class="btn_02"><a href="javascript:setSysopCatalogChange();">저장</a></span>
				<%
  						}
  					}
  				%>
  				</span>
  			 </div>
    		</div>
    	</div>        
</div>
</form>

<form name="catlgFlow" id="catlgFlow" method="post" action ="">
    <input type="hidden" name="catlg_desc_flow" id="catlg_desc_flow" value="">
    <input type="hidden" name="catlg_spec_flow" id="catlg_spec_flow" value="">
    <input type="hidden" name="catlg_maker_flow" id="catlg_maker_flow" value="">
    <input type="hidden" name="catlg_model_flow" id="catlg_model_flow" value="">
    <input type="hidden" name="catlg_row_num" id="catlg_row_num" value="">
</form>
</body>
</html>
