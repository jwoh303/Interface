<%--
**********************************************
* 메뉴 : 
* 화면 : MSDS 조회 
* 기능 : MSDS 등록/조회/맵핑
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-08-19
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
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)
String st_catalog_com_code = CommonUtil.nvl((String) request.getParameter("st_catalog_com_code"),"");  //  (조회조건)
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String bFlagCmsUser = CommonUtil.nvl((String)request.getAttribute("bFlagCmsUser"),"N");  
String open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"");
String st_approval_yn = CommonUtil.nvl((String) request.getParameter("st_approval_yn"),"N");


Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Left",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Left",	Width:60,	Edit : true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"MSDS NO",	SaveName:"MSDS_NO" ,BackColor:"${optColor}" }
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"품명",	SaveName:"DESCRIPTION"  ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:25,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:90,	Edit:true,	EditLen:25,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:90,	Edit:true,	EditLen:25,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:90,	Edit:true,	EditLen:25,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM" ,BackColor:"${optColor}"}

	];
		
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
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
		
		
		cc = confirm(" 선택하신 품목을 저장 하시겠습니까?  ");
		if(cc){
			kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/saveMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );
		}else {
			return;
		}
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
			var selectedRow = mySheet.GetCellValue(i,"SELECTED");
			if(new_yn == "Y" && selectedRow == "1"){
				mySheet.RowDelete(i, 0);	
			}
		}
		
		//신규건이 삭제된 후에 삭제처리할 건이 남아있으면 수행
		if(mySheet.FindCheckedRow("SELECTED").length != 0){
			if (!confirm(" 선택하신 품목을 삭제 처리 하시겠습니까?  ")) {
				return;
			}else{
				kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/delMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );	
			}
		}
		
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
		
		if (!confirm("품목을 "+text+" 처리 하시겠습니까?  ")) {
			return;
		}else{
			$("#st_product_flag").val(flag);
			kepSave(document.masterMdCmBuyerCatalogAlterPop ,  mySheet , "/mdcm/confirmMasterMdCmBuyerCatalogAlterPop.do" , "SELECTED" );	
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
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
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
			openSearchPopup("/coco/getCommonCoCoStndrdCatalogSearchPop.do", "?st_customer_code=6035", "1000,800,no");
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
			openSearchPopup("/mdcm/showMasterMdCmChangeReasonPop.do", "", "500,300,no");
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
		
		if((process_type=="1"||process_type=="3") && (process_source == "STCK" || process_source == "")){
			alert("재고 또는 VMI 제품은 매입단가를 수정하실 수 없습니다.\n\n재고 매입단가 변경은 타 고객사 담당자와 협의후 기술연구소로 연락 주십시오");
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
	
	if (msg.msg != "") {
		alert(msg.msg);
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
	
	var maxRow  = mySheet.RowCount();
	var is_agent_check_flag = "N";
	
	for(var i=1; i<= maxRow; i++){	
		var agent_code = mySheet.GetCellValue(i,"AGENT");
		
		if(agent_code == "KRSESI0003"){
			is_agent_check_flag = "Y";
			break;
		}
	}

	if(is_agent_check_flag=="Y") {
		doPop('commonCoCoStndrdCatalogSearchPop');
	}else {
		alert("표준카탈로그 매핑은 CMS에 요청 바랍니다.");
	}
	return ;
}

//이미지 미리보기
function preview_new(img) {
	$("#st_image_no").val(img);
	$("#image1").attr("src","");
	var dest    = document.getElementById("image1"); 
     dest.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img + "',sizingMethod=scale)"; 
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
	
	$("#masterMdCmBuyerCatalogAlterPop").attr("target","account_work");
	$("#masterMdCmBuyerCatalogAlterPop").attr("action","/mdcm/addMasterMdCmBuyerCatalogAlterPop.do").submit();
 	
}

//이미지 삭제
function kepDelImage(){
	if (!confirm(" 이미지를 삭제 처리 하시겠습니까?  ")) {
		return;
	}else{
		kepAjaxFormCall("/mdcm/delMasterMdCmCatalogImage.do","masterMdCmBuyerCatalogAlterPop","delImage");
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
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "delImage"){
		alert("이미지 삭제 중 오류가 발생하였습니다.");
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
	
	/*if(column == 'KEP_PRICE'){   //
		mySheet.SetCellValue(Row,"CHECK_FLAG","Y");
	}else*/ 
	
	if(column == 'MAKER_NAME'){  //제조사 변경시 st_masterflag_check 'Y' set
		$("#st_masterflag_check").val("Y");
	}
	
	//단가변경이력 관리를 위한 flag
	if(column == 'UNIT_PRICE' || column == 'LIST_PRICE'){   
		if(new_yn != "Y"){
			mySheet.SetCellValue(Row,"EP_CHECK","Y");
		}
	}
	
	//원산지, 제조사, 협력사, 매출, 매입, 품목구분, 표준납기일 변경시 품의상신 flag set
	if(column == 'AGENT' || column == 'UNIT_PRICE' || column == 'LIST_PRICE' || column == 'ORIGIN_CODE' || column == 'MAKER_CODE' || column == 'ITEM_MAKE_TYPE' || column == 'DELIVERY_LT'){   //
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
			g_doc_type = "CA";
		}else{
			if(ccaYn == "N"){
				alert("계약추가건만 저장 가능합니다.");
				 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" );
				return;
			}
			g_doc_type = "CCA";
		}
		
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
	mySheet.SetCellEditable(rows, "SELLER_ITEM_NO", 0);
	mySheet.SetCellEditable(rows, "IMPORT_FLAG", 0);	
	
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
			
        	</div>
        	<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "200px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">계약추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>				
  					<span class="btn_02"><a href="javascript:setSysopCatalogChange();">저장</a></span>
  				</span>
  			 </div>
    		</div>
    	</div>        
</div>
</form> 
</body>
</html>
