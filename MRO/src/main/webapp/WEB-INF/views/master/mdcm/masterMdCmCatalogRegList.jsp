<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>카탈로그 등록
* 화면 : 카탈로그 등록
* 기능 : 고객사카탈로그 관리
* 프로그램 ID : PG_03_M_001_00 / PG_03_M_001_03
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script src="/resources/js/kep_common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var regOn = "/resources/images/rd_pin.gif";
var regOff = "/resources/images/icon_g.gif";
var regRed = "/resources/images/icon_r.gif";
var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

var process_source  = new Array();
var pre_process_type = new Array();

var db_buyer_adapt_flag		= "";		
var db_buyer_rate			= "";	
var db_buyer_standard_rate= ""; 
var db_supply_direct_rate	= ""; 
var db_stock_rate			= ""; 
var db_tr_rate				= ""; 
var db_vmi_rate				= ""; 
var db_import_rate		= ""; 
var db_BelowComorgCode		= "";  // BELOW_COMORG_CODE 하위적용구분 추가 
var copyGbn = false;

var AjaxCallCount = 0;	// Ajax 콜 횟수
var AjaxSuccCount = 0;	// 자동추천 시 사용할 SEQ
var AjaxFailFlag = "Y"; // Ajax 콜 후 에러 발생 시 Y로 세팅됨

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var productGbn = KepSheetComboData("M132","SEL");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    
    var cb_tax_type = KepSheetComboData("TX17","");
    var tax_type = {ComboCode: cb_tax_type.ComboCode, ComboText: cb_tax_type.ComboText};
    
	var initsheet = {};
	initsheet.HeaderMode = {ColMove:0, Sort : 0};
	initsheet.Cols = [ 
						 { Align:"Left",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{ Align:"Left",	Width:60,	Edit : true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:110,	Type:"Seq",	Header:"NO",	SaveName:"NO"}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Type:"Image", ImgWidth:12, ImgHeight:12,	Header:"구분",	SaveName:"CQDT_COUNT"}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Type:"Image", ImgWidth:12, ImgHeight:12,	Header:"중복",	SaveName:"ADD_COUNT"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Type:"Text",	Header:"표준 카테고리명",	SaveName:"CMS_CATEG_NAME" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Type:"Text",	Header:"표준카탈로그",	SaveName:"CMS_CATLG_ID",BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:50,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO" ,BackColor:"${notnullColor}",KeyField:true}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:150,	Type:"Text",	Header:"카테고리명",	SaveName:"CATEGORY_TEXT" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"표준품목명",	SaveName:"KEP_DESCRIPTION" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"품목명(영문)",	SaveName:"DESCRIPTION_ENG" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"표준규격",	SaveName:"KEP_SPECIFICATION" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Type:"Text",	Header:"규격(영문)",	SaveName:"SPECIFICATION_ENG" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"표준제조사명",	SaveName:"KEP_MAKER_NAME" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:25,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:25,	Type:"Text",	Header:"표준모델명",	SaveName:"KEP_MAKER_PART_NO" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:40,	Edit:true,	EditLen:5,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:5,	Type:"Text",	Header:"표준단위",	SaveName:"KEP_UNIT_MEASURE" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"적용구분",	SaveName:"BELOW_COMORG_NAME" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE_NAME" ,BackColor:"${notnullColor}" }
						,{ Align:"Right",	Width:80,	Edit:true,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매출단가",	SaveName:"UNIT_PRICE" ,BackColor:"${notnullColor}"}
						,{ Align:"Right",	Width:80,	Edit:true,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매입단가",	SaveName:"LIST_PRICE" ,BackColor:"${notnullColor}"}
						,{ Align:"Right",	Width:80,	Edit:true,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"시장단가",	SaveName:"PREV_DEAL_PRICE" ,BackColor:"${optColor}"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:300,	Type:"Text",	Header:"표준매익적용가",	SaveName:"S_PRICE"}
						,{ Align:"Right",	Width:80,	Edit:false,	EditLen:300,	Type:"Float",	ColMerge:0, Format:"#,##0.00",Header:"매익률",	SaveName:"PRICE_RATE" }
						,{ Align:"Right",	Width:100,	Edit:true,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"별도정산원가",	SaveName:"LOGISTICS_FEE" ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	Hidden:true, EditLen:300,	Type:"Text",	Header:"담당팀",	SaveName:"ITEM_GROUP_NAME"}
						,{ Align:"Center",	Width:80,	Edit:true,	EditLen:1,	Type:"Text",	Header:"수입여부",	SaveName:"IMPORT_FLAG" ,BackColor:"${optColor}"}
						,{ Align:"Right",	Width:80,	Edit:true,	EditLen:8,	Type:"Text",	Header:"표준납기일",	SaveName:"DELIVERY_LT" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:20,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO" ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Type:"Text",	Header:"협력사품목코드",	SaveName:"SELLER_ITEM_NO"  ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:200,	Type:"Text",	Header:"원산지명",	SaveName:"ORIGIN_NAME"  ,BackColor:"${notnullColor}"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Type:"Text",	Header:"표준원산지명",	SaveName:"KEP_ORIGIN_NAME"  ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:130,	Edit:false,	EditLen:200,	Type:"Text",	Header:"물류관련협력사",	SaveName:"ORIGIN_AGENT_NAME"  ,BackColor:"${optColor}"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Type:"Text",	Header:"표준카테고리No",	SaveName:"CMS_CATEG_ID"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Type:"Text",	Header:"카테고리No",	SaveName:"CATEGORY_NO"}
						,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
						,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"적용구분코드",	SaveName:"BELOW_COMORG_CODE"}
						,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"담당팀코드",	SaveName:"ITEM_GROUP"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"거래유형No",	SaveName:"PROCESS_TYPE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"물류관련협력사코드",	SaveName:"ORIGIN_AGENT"}
						,{ Align:"Left",	Width:50,	Edit:false,	EditLen:100,	Type:"Text",	Header:"순번",	SaveName:"SEQ"}
						,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE"}
						,{ Align:"Left",	Width:80,	Edit:true,	EditLen:20,	Type:"Text",	Header:"품목번호",	SaveName:"ITEM_NO"}						
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"BUYER"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"STANDARD_RATE"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"STATUS"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_ATTR_FLAG"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"ITEM_SEQ"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"QUOTATION_SEQ"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_REVISION"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_ITEM_QTY"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_QUOTATION_SUM"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_MASTERFLAG"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"KEP_MAKER_CODE"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"KEP_ORIGIN_CODE"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"IMGFILE_NAME"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"IMGFILE_DIR"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"NEW_YN"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_AGENT_USE_FLAG"}
						,{ Align:"Left",	Width:0,	Edit:false,	Hidden:true, EditLen:100,	Type:"Text",	Header:"",	SaveName:"H_AGENT_USE_MSG"}
						,{ Align:"Left",	Width:80,	Edit:true,	Hidden:true, EditLen:30,	Type:"Text",	Header:"품의제목",	SaveName:"GPM_NO"}
						,{ Align:"Left",	Width:80,	Edit:true,	Hidden:true, EditLen:30,	Type:"Text",	Header:"거래구분",	SaveName:"PRODUCT_CLOSE_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,  Type:"Combo", Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE" ,BackColor:"${notnullColor}"}
						,{ Align:"Right",	Width:90,	Edit:true,	EditLen:100,	Hidden:true,	Type : "Text",  	Header:"최소수량",	SaveName:"MOQ_QTY"}
						,{ Align:"Right",	Width:50,	Edit:true,	EditLen:10,		Hidden:false,	Type:"Text",		Header:"MOQ",				SaveName:"MIN_ORDER_QTY",	BackColor:"${optColor}"}
						,{ Align:"Right",	Width:60,	Edit:true,	EditLen:10,		Hidden:false,	Type:"Text",		Header:"발주배수",			SaveName:"PUR_UNIT_QTY",		BackColor:"${optColor}"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"MOQ_사용여부",	SaveName:"MOQ_USE_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"매출\n단가유효일",	SaveName:"SELL_CLOSE_DATE"}
						,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",Header:"과세구분",	SaveName:"TAX_TYPE"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Image",	Header:"납품지역",	SaveName:"SELLER_AREA_IMG"}
		    			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"납품지역",	SaveName:"SELLER_AREA"}
		    			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"납품지역_사용여부",	SaveName:"AREA_USE_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CHOICE_TYPE",	SaveName:"CATEGORY_CHOICE_TYPE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카테고리셋팅",	SaveName:"CATEGORY_CHOICE_TYPE_NM"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CATLG_CHOICE_TYPE",	SaveName:"CATALOG_CHOICE_TYPE"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준카탈로그셋팅",	SaveName:"CATALOG_CHOICE_TYPE_NM"}
						,{ Align:"Center",	Width:80,	Edit:true,	EditLen:10,		Hidden:false,	Type:"Text",		Header:"환율코드",				SaveName:"EXP_CODE",	BackColor:"${optColor}"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"영문_사용여부",	SaveName:"ENG_USE_FLAG"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"매입\n단가유효일",	SaveName:"BUY_CLOSE_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

	//구분이미지설정
	mySheet.SetImageList(0, regOff);
	mySheet.SetImageList(1, regOn);
	mySheet.SetImageList(2, regRed);
	mySheet.SetImageList(5, areaOn);
	mySheet.SetImageList(4, areaOff);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATEG_NAME");
	setLinkCol(mySheet, "CATEGORY_TEXT");
	setLinkCol(mySheet, "MAKER_NAME");
	setLinkCol(mySheet, "KEP_MAKER_NAME");
	setLinkCol(mySheet, "BELOW_COMORG_NAME");
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "PROCESS_TYPE_NAME");
	setLinkCol(mySheet, "ORIGIN_NAME");
	setLinkCol(mySheet, "KEP_ORIGIN_NAME");
	setLinkCol(mySheet, "ORIGIN_AGENT_NAME");
	setLinkCol(mySheet, "CONTRACT_NO");
	setLinkCol(mySheet, "SELLER_AREA_IMG");
	setLinkCol(mySheet, "CMS_CATLG_ID");
	
	mySheet.SetCellFontUnderline(0, "DELIVERY_LT", true);	
	mySheet.SetCellFontUnderline(0, "DESCRIPTION", true);	
	mySheet.SetCellFontUnderline(0, "SPECIFICATION", true);
	mySheet.SetCellFontUnderline(0, "MAKER_PART_NO", true);
	mySheet.SetCellFontUnderline(0, "KEP_MAKER_PART_NO", true);
	mySheet.SetCellFontUnderline(0, "CONTRACT_NO", true);
	mySheet.SetCellFontUnderline(0, "MAKER_NAME", true);
	mySheet.SetCellFontUnderline(0, "KEP_MAKER_NAME", true);
	mySheet.SetCellFontUnderline(0, "UNIT_MEASURE", true);
	mySheet.SetCellFontUnderline(0, "KEP_UNIT_MEASURE", true);
	mySheet.SetCellFontUnderline(0, "CATEGORY_TEXT", true);
	mySheet.SetCellFontUnderline(0, "AGENT_NAME", true);
	mySheet.SetCellFontUnderline(0, "PROCESS_TYPE_NAME", true);
	mySheet.SetCellFontUnderline(0, "ORIGIN_NAME", true);
	mySheet.SetCellFontUnderline(0, "KEP_ORIGIN_NAME", true);
	mySheet.SetCellFontUnderline(0, "BELOW_COMORG_NAME", true);
	mySheet.SetCellFontUnderline(0, "GPM_NO", true);
	mySheet.SetCellFontUnderline(0, "ITEM_MAKE_TYPE", true);
	
	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	mySheet.SetColProperty("TAX_TYPE", tax_type);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
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
	
		var buyer	= $("#st_buyer_code").val();
	    
    	if(buyer == "") {
			alert("고객사는 필수 선택사항입니다.  ");
			return;
		}
		/*
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogRegList.do" , pagingMode );
		*/
		//kepSearch()
		/*IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mdcm/getMasterMdCmCatalogRegList.do", param);*/
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogRegList.do" , "N" );
		
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		
		$("#st_mode").val("");
		$("#st_product_close_flag").val("");
		$("#st_copy_cnt").val("");
		$("#st_buyer_code").val("");
		$("#st_org_buyer").val("");
		$("#st_org_com_code").val("");
		
		AjaxSuccCount = 0;
		break;
	
	case "save": // 저장
	
	
		var st_type = $("#st_type").val();
		var buyer	= $("#st_buyer_code").val();
		var buyer_name	= $("#st_buyer_name").val();
		
		for(var i=0; i<arrRow.length; i++){
			var unit_price = eval(Number(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE"))); //매출단가
			var list_price = eval(Number(mySheet.GetCellValue(arrRow[i],"LIST_PRICE")));  //매입단가
			//var kep_price  = eval(Number(mySheet.GetCellValue(arrRow[i],"KEP_PRICE")));   //매출원가	

			/*if(kep_price==0){   // 매출원가 계산
				if(!getBuyerPrimeCostRate(arrRow[i])){
					return ;
			  	}
			}*/

			if(unit_price > 0 || list_price > 0){
				if(list_price > unit_price){
					cc = confirm(arrRow[i]+"번째행의 매입단가(="+list_price+")가 매출단가(="+unit_price+")보다 큽니다.\n이대로 저장 하시겠습니까?  ");
					
					if(cc == false){
						mySheet.SetCellValue(arrRow[i],"SELECTED", "0");
						return;
					}
				}
				//엑셀 업로드인 경우는 없을 수 있으니 
				if(mySheet.GetCellValue(arrRow[i],'PRICE_RATE') == 0 || mySheet.GetCellValue(arrRow[i],'PRICE_RATE') =="" || mySheet.GetCellValue(arrRow[i],'PRICE_RATE')  == null){
					setMarginRate(arrRow[i]);
				}
				
			} 

			//품목명,규격 좌우 공백 제거
			trimValue(arrRow[i]);
			
			//품목코드 입력여부 확인.
			var buyer_item_no = mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO");
			if(buyer_item_no == ""){
				alert(arrRow[i]+"번째행의 품목코드는 필수 입력사항입니다.");
				return;
			}
			 
			//표준카테고리 입력여부 확인.
			var cms_categ_name = mySheet.GetCellValue(arrRow[i],"CMS_CATEG_NAME");
			if(cms_categ_name == ""){
				alert(arrRow[i]+"번째행의 표준카테고리는 필수 입력사항입니다.");
				return;
			}
			
			//적용구분
			var below_comorg_code = mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_CODE");			
			if (st_type == "그룹"){
				if (fn_belowComorgCode(below_comorg_code)==false) {
					alert(arrRow[i]+"번째행의 "+buyer_name + " 그룹의 해당되는 사업장이 아닙니다.\확인부탁드립니다.");
					return;
				}
			}else{
				if (buyer != below_comorg_code) {
					alert(arrRow[i]+"번째행의 "+buyer_name + " 고객사와 적용구분이 동일해야 합니다.\확인부탁드립니다.");
					return;
				}
			} 			
			
			// MOQ, 발주배수
			var moq_use_flag = mySheet.GetCellValue(arrRow[i], "MOQ_USE_FLAG");
			var min_order_qty = mySheet.GetCellValue(arrRow[i], "MIN_ORDER_QTY");
			var pur_unit_qty = mySheet.GetCellValue(arrRow[i], "PUR_UNIT_QTY");
			
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
			
			// 납품지역
			var area_use_flag = mySheet.GetCellValue(arrRow[i], "AREA_USE_FLAG");
			var seller_area = mySheet.GetCellValue(arrRow[i], "SELLER_AREA");
			
			if(area_use_flag == "Y"){
				if(kepIsValueNull(seller_area)){
					alert("납품지역을 선택하여 주십시요.");
					mySheet.SelectCell(arrRow[i], "SELLER_AREA_IMG");
					return;
				}
			}
			
			// 협력사
			var agent_code = mySheet.GetCellValue(arrRow[i], "AGENT_CODE");
			var agent_name = mySheet.GetCellValue(arrRow[i], "AGENT_NAME");
			
			if(kepIsValueNull(agent_code) || kepIsValueNull(agent_name)){
				alert(arrRow[i]+ "번째 행의 협력사정보를 확인하세요.");
				mySheet.SelectCell(arrRow[i], "AGENT_NAME"); 
				return;
			}
			
			// 물류관련 협력사 거래유형 2 인 경우 확인
			var warehouse_code = mySheet.GetCellValue(arrRow[i], "ORIGIN_AGENT_NAME"); 
			var process_text = mySheet.GetCellValue(arrRow[i], "PROCESS_TYPE"); 
			if(process_text == "2" && kepIsValueNull(warehouse_code)){
				alert(arrRow[i]+ "번째 행에 물류관련협력사 명을 정확히 입력하세요.");
				return;
			}
			
		}


		cc = confirm("선택하신 제품을 저장 하시겠습니까?  ");
		if(cc){
	    	var buyer	= $("#st_buyer_code").val();
	    	var buyer_item_no   = kepToUpper('st_buyer_item_no');
	        $("#st_buyer_item_no").val(buyer_item_no);
		    var description     = $("#st_description").val();
		    
	    	if(buyer == "") {
				alert("고객사는 필수 선택사항입니다.  ");
				return;
			}
	    	
			if(buyer_item_no.length < 1){
				buyer_item_no = "ALL";
			}
			if(description.length < 1){
				description = "ALL";
			}
			
			//ins모드 set
		    $("#st_mode").val("ins");
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCatalogRegList.do" , "SELECTED" );
		}else {
			return;
		}
		break;
		
	case "del":	//삭제
	
		if (mySheet.RowCount() == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		
		for(var i=0; i<arrRow.length; i++){
			var status    = mySheet.GetCellValue(arrRow[i],"STATUS");
			
			if(status=="X") {
	            alert("CMS팀에서 Mapping 중입니다.\n\n삭제 할 수 없습니다. ");
	            mySheet.SetCellValue(arrRow[i],"SELECTED","0"); 
	            return ;
	        }
			
			if(status=="J") {
	            alert("CMS팀에서 재요청 상태입니다.\n\n삭제 할 수 없습니다.  ");
	            mySheet.SetCellValue(arrRow[i],"SELECTED","0"); 
	            return ;
	        }
		}
		
		var maxRow  = mySheet.RowCount();
		//신규건 삭제
		for(var i=maxRow; i>= 0; i--){	
			var sStatus = mySheet.GetCellValue(i,"sStatus");
			var selectedRow = mySheet.GetCellValue(i,"SELECTED");
			if(sStatus == "I" && selectedRow == "1"){
				mySheet.RowDelete(i, 0);	
			}
		}
		
		//신규건이 삭제된 후에 삭제처리할 건이 남아있으면 수행
		if(mySheet.FindCheckedRow("SELECTED").length != 0){
			if (!confirm("선택된 내역을 삭제 하시겠습니까?  ")) {
				return;
			}else{
				kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCatalogRegList.do" , "SELECTED" );	
			}		
		}
		
		break;	
		
	case "cons": // 품의상신
	  	//cons모드 set
	    $("#st_mode").val("cons");
		kepSave(document.searchCondition ,  mySheet , "/mdcm/consMasterMdCmCatalogRegList.do" , "SELECTED" );
		break;
	
	case "copy": // 복사
		
		var cnt = arrRow.length;
		
		if(cnt > 1){
			alert("복사는 한건씩만 가능합니다.  ");
			return;
		}
		
		for(var i=0; i<arrRow.length; i++){
			var rowStatus    = mySheet.GetCellValue(arrRow[i],"sStatus");
			
			if(rowStatus == "I"){
				alert("행추가 row는 복사할 수 없습니다.");
				return;
			}
		}
		
		cc = confirm("선택하신 제품을 복사하시겠습니까?   ");
	    if(cc){
	    	doPop('masterMdCmCopyCountPop');
	    }else {
	        return;
	    }
		
		break;
		
	case "copyTran": //복사건수 선택 완료
		
		kepSave(document.searchCondition ,  mySheet , "/mdcm/copyMasterMdCmCatalogRegList.do" , "SELECTED" );
		break;
	
	case "reg": // 등록
		
		$("#st_product_close_flag").val("N");
		
		//reg모드 set
	    $("#st_mode").val("reg");
		kepSave(document.searchCondition ,  mySheet , "/mdcm/regMasterMdCmCatalogRegList.do" , "SELECTED" );
		
		break;

	case "loadExcel": // 일괄 업로드
	
		var buyer = $("#st_buyer_code").val();
		if(buyer == "") {
			alert("고객사는 필수 선택사항입니다.  ");
			return;
		}	  
		    
		mySheet.RemoveAll();
		
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||||||35|3||5|22|38|6|23|39|||8|25|9|24||||11|12|13||||||14|15|16||||2|4|10|1|20|19|18|17|||7|21|1||||||||||26|27|28|29||||||30|31|31|33||32|36||34||||||37||40|"};
		mySheet.LoadExcel(params);

		break;
		
	case "confirm": // CMS등록
		//reg모드 set
	    $("#st_mode").val("confirm");
		kepSave(document.searchCondition ,  mySheet , "/mdcm/confirmMasterMdCmCatalogRegList.do" , "SELECTED" );
		
		break;
		
	case "categ":
		AjaxCallCount = 0;
		AjaxSuccCount = 0;
		AjaxFailFlag = "N";
		
		for (var i=0; i<arrRow.length; i++){
			var st_categ_desc = mySheet.GetCellValue(arrRow[i],"DESCRIPTION"); // 품목명
			var st_categ_spec = mySheet.GetCellValue(arrRow[i],"SPECIFICATION"); // 규격
			
			if(kepIsValueNull(st_categ_desc)) {
				alert('품목명은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "DESCRIPTION", 1, "");
				return;
			}
			
			if(kepIsValueNull(st_categ_spec)) {
				alert('규격은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "SPECIFICATION", 1, "");
				return;
			}
		}
		
		if(confirm("데이터량에 따라 최대 3분 정도 소요될 수 있습니다. \n자동추천을 실행하시겠습니까?")){
			for (var i=0; i<arrRow.length; i++){
				var st_categ_desc = mySheet.GetCellValue(arrRow[i],"DESCRIPTION"); // 품목명
				var st_categ_spec = mySheet.GetCellValue(arrRow[i],"SPECIFICATION"); // 규격
				var st_categ_maker = mySheet.GetCellValue(arrRow[i],"MAKER_NAME"); // 제조사명
				var st_categ_model = mySheet.GetCellValue(arrRow[i],"MAKER_PART_NO"); // 모델번호
				
				document.categForm.categ_row_no.value = arrRow[i];
				document.categForm.categ_desc.value = st_categ_desc;
				document.categForm.categ_spec.value = st_categ_spec;
				document.categForm.categ_maker.value = st_categ_maker;
				document.categForm.categ_model.value = st_categ_model;
				
				kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			}
		}
		break;
	}
}

function fn_belowComorgCode(param_below_comorg_code){
	var st_below_comorg_code = $("#st_below_comorg_code").val();
	var below_comorg_code_array = st_below_comorg_code.split(",,,"); 
	var belowArrayLength = below_comorg_code_array.length;
	var cnt = 0;
	for (var i =0; i<belowArrayLength; i++){ 
		if (below_comorg_code_array[i] == param_below_comorg_code) {
			cnt = 1;
		}
	}
	
	if (cnt == 0){
		return false; // 하위적용구분 맞는게 하나도 없다
	}else{
		return true; // 하위적용구분 맞는게 있따
	}
}

function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}

	var buyer = $("#st_buyer_code").val();
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
		var v_spec = mySheet.GetCellValue(i,"SPECIFICATION");
		var v_seller_area = mySheet.GetCellValue(i,"SELLER_AREA");
		var v_seller_area_chk = "";
  		if(v_spec.length > 300){
			alert("엑셀 "+ i + "번째 행의 규격이 300자 이상입니다.\n\n300자 이상 등록 할 수 없습니다.");			
			mySheet.RemoveAll();
			return;
		}
  		
  		if(v_seller_area.length > 2){ // 납품지역 입력이 있으면
  			v_seller_area_chk = v_seller_area.substr(v_seller_area.length - 2, 2);
  			if(v_seller_area_chk != "__"){ // 마지막 구분자 체크
  				alert("엑셀 " + i + "번째 행의 납품지역 코드를 확인하여 주십시오.");
  				mySheet.RemoveAll();
  				return;
  			}
  		}

  		var v_process_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
  		if(v_process_type != "0" && v_process_type != "1" && v_process_type != "2" && v_process_type != "3"){
  			alert("엑셀 " + i + "번째 행의 거래유형코드를 확인하여 주십시오.");
			mySheet.RemoveAll();
  			return;
  		}
  		
  		var unit_price = eval(Number(mySheet.GetCellValue(i,"UNIT_PRICE"))); //매출단가
		var list_price = eval(Number(mySheet.GetCellValue(i,"LIST_PRICE")));  //매입단가
		
		if(unit_price > 0 || list_price > 0){//엑셀 업로드인 경우는 없을 수 있으니 
			setMarginRate(i);
		}
		
		mySheet.SetCellValue(i, "CATEGORY_CHOICE_TYPE", "EXLCATE");
		mySheet.SetCellValue(i, "CATALOG_CHOICE_TYPE", "EXLCATE");
  		mySheet.SetCellValue(i,"BUYER", buyer);
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCatalogRegList.do" , "SELECTED" );
	
}

//품의상신 validation check
//SLOGIC-BEGIN(P03-3010-02)
function setSysopNewCatalogPmSendImsi(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	//품의상신 선택 유무 체크
	if (selectedGrid.length == 0) {
		alert("품의상신할 대상을 선택해 주십시요.  ");
		return;
	}
	
	//상태 체크.
	var status_ing = $("#st_status_ing option:selected").val();
	if(status_ing != "CO"){
		  alert("상태를 카탈로그 등록 가능으로 선택 하시기 바랍니다. ");
		  //$("#st_status_ing option:eq(1)").attr("selected", "selected");
		  $("#st_status_ing").val("CO");
		  doAction('search');
		  return;
	}
	
    var buyer = $("#st_buyer_code").val();
	
    var arrRow = selectedGrid.split("|");
	for(var i=0; i<arrRow.length; i++){
		var check_no = mySheet.GetCellValue(arrRow[i],"NO");                //NO            
				      
		if(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO") == ""){
			  alert(check_no+"번째 행의 품목코드를 입력하여 주십시요.  ");
			  return;
		}
		//등록VALIDATION CHECK. 품의상신에 포함되어 추가.
		/*if(mySheet.GetCellValue(arrRow[i],"KEP_PRICE") == ""){
			if(!getBuyerPrimeCostRate(arrRow[i])) {
				return ;
			}
		}*/
		//등록VALIDATION CHECK. 품의상신에 포함되어 추가.
		
		if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION")== "" ) {
			alert(check_no+"번째 행의 품목명을 입력하여 주십시요.  ");
			return;
			}
	
		if(mySheet.GetCellValue(arrRow[i],"SPECIFICATION")== "") {
			alert(check_no+"번째 행의 규격을 입력하여 주십시요.  ");
			return;
		}
		if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_NAME") == ""){
			  alert(check_no+"번째 행의 표준카테고리를 입력하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ""){
			  alert(check_no+"번째 행의 표준카테고리를 입력하여 주십시요.  ");
			  return;
		}		
		//체크순서 변경 2014.11.4
		if(mySheet.GetCellValue(arrRow[i],"ADD_COUNT") == "Y" && buyer != "KRDOOD0001"){
            alert(check_no+"번째 행은 중복된 건 입니다.확인하여 주십시요.\n\n같은 품목코드에 협력사가 중복으로 된 경우 입니다.  ");
            return;
        }
		if(mySheet.GetCellValue(arrRow[i],"CATEGORY_NO") == ""  || kepIsValueNull(mySheet.GetCellValue(arrRow[i],"CATEGORY_TEXT")) || mySheet.GetCellValue(arrRow[i],"CATEGORY_TEXT") == " "){
            alert(check_no+"번째 행의 제품 카테고리를 선택하여 주십시요.  ");
            return;
		}
		if(mySheet.GetCellValue(arrRow[i],"MAKER_CODE") == "" || mySheet.GetCellValue(arrRow[i],"MAKER_CODE") ==" "){
			alert(check_no+"번째 행의 제조사를 선택 하여 주세요.  ");
			return;
        }	
		if(mySheet.GetCellValue(arrRow[i],"UNIT_MEASURE") == ""){
			  alert(check_no+"번째 행의 단위를 입력하여 주십시요.  ");
			  return;
		}		
		if(kepIsValueNull(mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_CODE")) || kepIsValueNull(mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_NAME"))){
			  alert(check_no+"번째 행의 적용구분을 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == ""){
			  alert(check_no+"번째 행의 협력사를 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"DELIVERY_LT") == "" || mySheet.GetCellValue(arrRow[i],"DELIVERY_LT") == " "){
			  alert(check_no+"번째 행의 표준납기일을 입력하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"CONTRACT_NO") == "" || mySheet.GetCellValue(arrRow[i],"CONTRACT_NO") == " "){
			  alert(check_no+"번째 행의 계약서 번호를 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE") == "" || mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE") == " "){
			  alert(check_no+"번째 행의 원산지를 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0069" && mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "2" && mySheet.GetCellValue(arrRow[i],"ORIGIN_AGENT") == ""){
			  alert(check_no+"번째 행의 실공급업체를 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "" || mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == " "){
			   alert(check_no+"번째 행의 제품조달방법을 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"ITEM_MAKE_TYPE") == "" || mySheet.GetCellValue(arrRow[i],"ITEM_MAKE_TYPE") == " "){
			   alert(check_no+"번째 행의 품목구분을 선택하여 주십시요.  ");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"H_AGENT_USE_FLAG") == "N"){
			var agent_use_msg = mySheet.GetCellValue(arrRow[i],"H_AGENT_USE_MSG");
			alert(check_no+"번째 행은 "+ agent_use_msg+" 사유로 등록 불가능 합니다.");
			return;
		}
		if(mySheet.GetCellValue(arrRow[i],"PRODUCT_CLOSE_FLAG") == "S"){
			alert(check_no+"번째 행은 신규소싱 진행 중인 품목이므로 등록 불가능 합니다.  ");
			return;			
		}
		if(mySheet.GetCellValue(arrRow[i],"PRODUCT_CLOSE_FLAG") == "G"){
			alert(check_no+"번째 행은 가합의 품목이므로 등록 불가능 합니다.  ");
			return;			
		}
		if(mySheet.GetCellValue(arrRow[i],"SELL_CLOSE_DATE") == "" || mySheet.GetCellValue(arrRow[i],"SELL_CLOSE_DATE") == " "){
			   alert(check_no+"번째 행의 매출단가 유효일 입력 바랍니다.");
			   mySheet.SelectCell(arrRow[i], "SELL_CLOSE_DATE");
			  return;
		}
		if(mySheet.GetCellValue(arrRow[i],"BUY_CLOSE_DATE") == "" || mySheet.GetCellValue(arrRow[i],"BUY_CLOSE_DATE") == " "){
			   alert(check_no+"번째 행의 매입단가 유효일 입력 바랍니다.");
			   mySheet.SelectCell(arrRow[i], "BUY_CLOSE_DATE");
			  return;
		}
           if(mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "1" || mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "3"){
               if(!(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0069" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0127" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0161" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0193" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0305" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0235" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0237" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0267" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0247" || 
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0313" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0413" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0425" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0439" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0405" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0441" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0563" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0593" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0609" ||
                    mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0669")){
	                
	                alert(check_no+"번째 행은 조달방법이 물류창고재고, VMI이므로 협력사는 물류센타이어야 합니다. ");
	                mySheet.SetCellValue(arrRow[i],"AGENT_CODE",temp);
	                mySheet.SetCellValue(arrRow[i],"AGENT_NAME","&" + temp+"&"+temp);
	                return;
              }
             //등록VALIDATION CHECK. 품의상신에 포함되어 추가.
               if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") =='' || mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ' '){
                   alert(check_no+"번째 행은 조달방법이 물류창고 재고 입니다.\n\n표준카테고리를 반드시 입력 하셔야 합니다.  ");
                   return;
               }
		}
		if((mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "2" || mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "3") && 
				(mySheet.GetCellValue(arrRow[i],"ORIGIN_AGENT") == "" || mySheet.GetCellValue(arrRow[i],"ORIGIN_AGENT") == " ")){ // TR, VMI 건 물류센터코드 입력 확인
			alert(check_no+"번째 행은 물류관련협력사코드가 필수입니다.");
			return;
		}
		
		if( buyer == "KRHANW0013" && (common.Trim(mySheet.GetCellValue(arrRow[i],"ITEM_NO"))  == "")){
			alert(check_no+"번째 행에 ITEM_NO가 입력되지 않았습니다.\n\n ITEM_NO를 입력해 주십시오. ");
			return;
		}
		/*
		if(mySheet.GetCellValue(arrRow[i],"ITEM_GROUP") == ""){
			alert("담당팀을 선택 해주세요.  ");
			return;
		}
		*/
        if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") =='' || mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ' '){
            alert(check_no+"번째 표준카테고리를 반드시 입력 하셔야 합니다.  ");
            return;
        }
		//등록VALIDATION CHECK. 품의상신에 포함되어 추가.
		if(mySheet.GetCellValue(arrRow[i],"STATUS") == 'X'){
			alert("CMS 등록 요청건을 등록 할수 없습니다\n\n CMS 처리를 먼저 해주세요.  ");
			return;
		}
		
		//데이터 유효성 체크.
		/*
		var v_check =  mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_CODE")+"|"+mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO")+"|"+ mySheet.GetCellValue(arrRow[i],"AGENT_CODE") + "|" +
			mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") + "|" + mySheet.GetCellValue(arrRow[i],"UNIT_PRICE") + "|" + mySheet.GetCellValue(arrRow[i],"LIST_PRICE");
		var v_no_code_check =  mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_CODE")+"|"+mySheet.GetCellValue(arrRow[i],"DESCRIPTION")+"|"+ +"|"+mySheet.GetCellValue(arrRow[i],"SPECIFICATION")+"|"+
			mySheet.GetCellValue(arrRow[i],"AGENT_CODE") + "|" +mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") + "|" + mySheet.GetCellValue(arrRow[i],"UNIT_PRICE") + "|" + mySheet.GetCellValue(arrRow[i],"LIST_PRICE");
		for(var j=0; j<arrRow.length;j++){
			var v_check_2 =  mySheet.GetCellValue(arrRow[j],"BELOW_COMORG_CODE")+"|"+mySheet.GetCellValue(arrRow[j],"BUYER_ITEM_NO")+"|"+ mySheet.GetCellValue(arrRow[j],"AGENT_CODE") + "|" +
			mySheet.GetCellValue(arrRow[j],"PROCESS_TYPE") + "|" + mySheet.GetCellValue(arrRow[j],"UNIT_PRICE") + "|" + mySheet.GetCellValue(arrRow[j],"LIST_PRICE");
			var  v_no_code_check_2 =  mySheet.GetCellValue(arrRow[j],"BELOW_COMORG_CODE")+"|"+mySheet.GetCellValue(arrRow[j],"DESCRIPTION")+"|"+ +"|"+mySheet.GetCellValue(arrRow[j],"SPECIFICATION")+"|"+ 
				mySheet.GetCellValue(arrRow[j],"AGENT_CODE") + "|" +mySheet.GetCellValue(arrRow[j],"PROCESS_TYPE") + "|" + mySheet.GetCellValue(arrRow[j],"UNIT_PRICE") + "|" + mySheet.GetCellValue(arrRow[j],"LIST_PRICE");
			var buyer_item_no = mySheet.GetCellValue(arrRow[j],"BUYER_ITEM_NO");
			var check_no_2 = mySheet.GetCellValue(arrRow[j],"NO");  
			if(buyer_item_no == "NO_CODE"){
				if(v_no_code_check==v_no_code_check_2&&check_no!=check_no_2){
				 	alert(check_no+"번째 행과 "+check_no_2+"행의 데이터가 품목명,규격, 협력사, 거래유형, 매출단가, 매입단가가 동일 합니다.");
				 	return;
				}				
			}else{
				if(v_check==v_check_2&&check_no!=check_no_2){
				 	alert(check_no+"번째 행과 "+check_no_2+"행의 데이터가 품목코드, 협력사, 거래유형, 매출단가, 매입단가가 동일 합니다.");
				 	return;
				}
			}
		}*/
		var v_cms_description		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_DESCRIPTION"))); 
		var v_cms_specification	= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_SPECIFICATION")));
		var v_cms_maker_name		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_NAME")));
		var v_cms_part_no				= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_PART_NO")));
		var v_cms_unit_measure	= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_UNIT_MEASURE")));
		var v_cms_origin_name		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_ORIGIN_NAME")));
		var h_cms_maker_code		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_CODE")));
		var h_cms_origin_code		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_ORIGIN_CODE")));
				 
				 
		var t_text = "";

		if(v_cms_description||v_cms_specification||v_cms_maker_name||v_cms_part_no||v_cms_unit_measure||v_cms_origin_name||h_cms_maker_code||h_cms_origin_code){
 
			var no = mySheet.GetCellValue(arrRow[i],"NO");

			if(v_cms_description){
				t_text="표준 품목명";
			}else if (v_cms_specification){
				t_text="표준 규격";
			}else if (v_cms_maker_name){
				t_text="표준 제조사";
			}else if (v_cms_part_no){
				t_text="표준 모델명";
			}else if (v_cms_unit_measure){
				t_text="표준 단위";
			}else if (v_cms_origin_name){
				t_text="표준 원산지";
			}else if (h_cms_maker_code){
				t_text="표준 제조사코드";
			}else if (h_cms_origin_code){
				t_text="표준 원산지코드";
			}
			alert(no+"번째행의 "+t_text+" 를 입력하여 주세요. ");  
			return;
		}
		
		// MOQ, 발주배수
		var moq_use_flag = mySheet.GetCellValue(arrRow[i], "MOQ_USE_FLAG");
		var min_order_qty = mySheet.GetCellValue(arrRow[i], "MIN_ORDER_QTY");
		var pur_unit_qty = mySheet.GetCellValue(arrRow[i], "PUR_UNIT_QTY");
		
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
		
		// 납품지역
		var area_use_flag = mySheet.GetCellValue(arrRow[i], "AREA_USE_FLAG");
		var seller_area = mySheet.GetCellValue(arrRow[i], "SELLER_AREA");
		
		if(area_use_flag == "Y"){
			if(kepIsValueNull(seller_area)){
				alert("납품지역을 선택하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "SELLER_AREA_IMG");
				return;
			}
		}
		
		// 품명,규격 영문명 20171027 by HSJ
		var eng_use_flag = mySheet.GetCellValue(arrRow[i], "ENG_USE_FLAG");
		var description_eng = mySheet.GetCellValue(arrRow[i], "DESCRIPTION_ENG");
		var specification_eng = mySheet.GetCellValue(arrRow[i], "SPECIFICATION_ENG");
		
		if(eng_use_flag == "Y"){
			if(kepIsValueNull(description_eng)){
				alert("품목명(영문)을 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "DESCRIPTION_ENG");
				return;
			}
			
			if(kepIsValueNull(specification_eng)){
				alert("규격(영문)을 입력하여 주십시요.");
				mySheet.SelectCell(arrRow[i], "SPECIFICATION_ENG");
				return;
			}
		}
		
		// 협력사
		var agent_code = mySheet.GetCellValue(arrRow[i], "AGENT_CODE");
		var agent_name = mySheet.GetCellValue(arrRow[i], "AGENT_NAME");
		
		if(kepIsValueNull(agent_code) || kepIsValueNull(agent_name)){
			alert(arrRow[i]+ "번째 행의 협력사정보를 확인하세요.");
			mySheet.SelectCell(arrRow[i], "AGENT_NAME"); 
			return;
		}
		
		// 매출단가 , 매입단가 품의상신 직전 수정해서 0원 들어가는 거  방지
		var unit_price = mySheet.GetCellValue(arrRow[i],"UNIT_PRICE"); //매출단가
		var list_price = mySheet.GetCellValue(arrRow[i],"LIST_PRICE"); //매입단가
		
		if(kepIsValueNull(unit_price) || unit_price <= 0) {
			alert(arrRow[i]+ "번째 행의 매출단가를 확인하세요.");
			mySheet.SelectCell(arrRow[i], "UNIT_PRICE"); 
			return;
		}
		if(kepIsValueNull(list_price) || list_price <= 0) {
			alert(arrRow[i]+ "번째 행의 매입단가를 확인하세요.");
			mySheet.SelectCell(arrRow[i], "LIST_PRICE"); 
			return;
		}
		
	}
    
	if(buyer == "") {
		alert("고객사는 필수 선택사항입니다.  ");
		return;
	}
	
	if(!confirm("품의상신  하시겠습니까?")){
		return;
	}
    
	/* 선택된 건들만 품의상신 태우도록 처리.
    var maxRow  = mySheet.RowCount();
    for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED", "1" );
	}
    */
		
    //var trxl_gubun = "NCA";
	//품의상신 action
    doAction('cons');
    
}
//SLOGIC-END

//SLOGIC-BEGIN(P03-3010-03)
//등록 validation check
function setNewSysopCatalogRegSaveImsi(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	//등록 선택 유무 체크
	if (selectedGrid.length == 0) {
		alert("등록할 대상을 선택해 주십시요.  ");
		return;
	}
	
	//AS-IS저장 후 로직.
	var status_ing = $("#st_status_ing option:selected").val();
	if(status_ing != "CO"){
		  alert("상태를 카탈로그 등록 가능으로 선택 하시기 바랍니다. ");
		  //$("#st_status_ing option:eq(1)").attr("selected", "selected");
		  $("#st_status_ing").val("CO");
		  doAction('search');
		  return;
	}
	
	process_source = null;
    process_source = new Array();

    var buyer = $("#st_buyer_code").val();
    var temp = "";
    
    for(var i=0; i<arrRow.length; i++){
		var check_no = mySheet.GetCellValue(arrRow[i],"NO");  //NO            
	      
		if(mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO") == ""){
			alert(check_no+"번째 행의 품목코드를 입력하여 주십시요.  ");
			return;
		}
		/*
		if(mySheet.GetCellValue(arrRow[i],"KEP_PRICE") == ""){
			if(!getBuyerPrimeCostRate(arrRow[i])) {
				return ;
			}
		}*/
		
		if(mySheet.GetCellValue(arrRow[i],"MAKER_CODE") == "" || mySheet.GetCellValue(arrRow[i],"MAKER_CODE") ==" "){
			alert(check_no+"번째 행의 제조사를 선택 하여 주세요.  ");
			return;
        }
        if(mySheet.GetCellValue(arrRow[i],"ADD_COUNT") == "Y" && buyer != "KRDOOD0001"){
            alert(check_no+"번째 행은 중복된 건 입니다.확인하여 주십시요.\n\n같은 품목코드에 협력사가 중복으로 된 경우 입니다.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"BELOW_COMORG_NAME") == ""){
            alert(check_no+"번째 행의 적용구분을 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"CATEGORY_NO") == "" || (mySheet.GetCellValue(arrRow[i],"CATEGORY_TEXT") == "" || mySheet.GetCellValue(arrRow[i],"CATEGORY_TEXT") == " ")){
            alert(check_no+"번째 행의 제품 카테고리를 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"UNIT_MEASURE") == ""){
            alert(check_no+"번째 행의 단위를 입력하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == ""){
            alert(check_no+"번째 행의 협력사를 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"DELIVERY_LT") == "" || mySheet.GetCellValue(arrRow[i],"DELIVERY_LT") == " "){
            alert(check_no+"번째 행의 표준납기일을 입력하여 주십시요.");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"CONTRACT_NO") == "" || mySheet.GetCellValue(arrRow[i],"CONTRACT_NO") == " "){
            alert(check_no+"번째 행의 계약서 번호를 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "" || mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == " "){
            alert(check_no+"번째 행의 제품조달방법을 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE") == "" || mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE") == " "){
            alert(check_no+"번째 행의 원산지를 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0069" && mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") != "2" && mySheet.GetCellValue(arrRow[i],"ORIGIN_AGENT") == ""){
            alert(check_no+"번째 행의 실공급업체를 선택하여 주십시요.  ");
            return;
        }
        if(mySheet.GetCellValue(arrRow[i],"H_AGENT_USE_FLAG") == "N"){
			var agent_use_msg = mySheet.GetCellValue(arrRow[i],"H_AGENT_USE_MSG");
			alert(check_no+"번째 행은 "+ agent_use_msg+" 사유로 등록 불가능 합니다.");
			return;
		}
        
        if(mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "1"||mySheet.GetCellValue(arrRow[i],"PROCESS_TYPE") == "3"){
            if(!(mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0069" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0127" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0161" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0193" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0305" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0235" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0237" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0267" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0247" || 
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0313" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0413" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0425" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0439" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0405" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0441" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0563" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0593" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0609" ||
                 mySheet.GetCellValue(arrRow[i],"AGENT_CODE") == "KRKORE0669")){
	                alert(check_no+"번째 행은 조달방법이 물류창고재고, VMI이므로 협력사는 물류센타이어야 합니다. ");
	                mySheet.SetCellValue(arrRow[i],"AGENT_CODE", temp);
	                mySheet.SetCellValue(arrRow[i],"AGENT_NAME", "&" + temp+"&"+temp);
	                return;
            }
            if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") =='' || mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ' '){
                alert(check_no+"번째 행은 조달방법이 물류창고 재고 입니다.\n\n표준카테고리를 반드시 입력 하셔야 합니다.  ");
                return;
            }
       }
       /*
        if(mySheet.GetCellValue(arrRow[i],"ITEM_GROUP") == ""){
            alert("담당팀을 선택 해주세요.  ");
            return;
       }
       */
		if(eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE"))>=eval(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE"))) {
			alert("노마진/역마진겁니다.\n\n품의 상신 후 등록 바랍니다.  ");
			return ;
		}
		if(mySheet.GetCellValue(arrRow[i],"STATUS") == 'X'){
			alert("CMS 등록 요청건을 등록 할수 없습니다\n\n CMS 처리를 먼저 해주세요.  ");
			return;
		}				  
		if(buyer == "KRHANW0013" && (common.Trim(mySheet.GetCellValue(arrRow[i],"ITEM_NO"))  == "")){
			alert(check_no+"번째 행에 ITEM_NO가 입력되지 않았습니다.\n\nITEM_NO를 입력해 주십시오  .");
			return;
		}
		trimValue(arrRow[i]);
    	
    }
    
	if(buyer == "") {
		alert("고객사는 필수 선택사항입니다.  ");
		return;
	}
	
	setNewSysopCatalogReg();
}
//SLOGIC-END
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	//mode, product_close_flag 초기화
	$("st_mode").val("");
	$("st_product_close_flag").val("");
	if (msg != "") {
		if(typeof(msg) == "object"){
			alert(msg.msg);			
		}else{
			alert(msg);
		}
	}

	if(code == 1 && msg.usrmsg != "" && msg.usrmsg != "undefined" && msg.usrmsg != "N"){
		var type = "NCA";
		var org_com_code = $("#st_org_com_code").val();
		
		//결재
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+org_com_code, "1000,500,no");
	}else if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
		
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMdCmCatalogBuyerChoicePop": // 카탈로그 고객사 선택
			openSearchPopup("/mdcm/showMasterMdCmCatalogBuyerChoicePop.do", "", "500,550,no");
			break;
		
		case "masterMdCmCopyCountPop": //복사 건수 입력
			openSearchPopup("/mdcm/showMasterMdCmCopyCountPop.do", "", "400,130,no");
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zh&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

//그리드 셀 편집한 직후에 이벤트
function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	if(column == 'LIST_PRICE' &&
		(mySheet.GetCellValue(Row,"UNIT_PRICE") != '0' 
		|| mySheet.GetCellValue(Row,"UNIT_PRICE") != '' 
		|| mySheet.GetCellValue(Row,"UNIT_PRICE") != 'null' 
		|| mySheet.GetCellValue(Row,"UNIT_PRICE") != null)){   //매입단가 입력시
		 
		agent_code   = mySheet.GetCellValue(Row,"AGENT_CODE");
		process_type = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		unit_price   = mySheet.GetCellValue(Row,"UNIT_PRICE");
		list_price   = mySheet.GetCellValue(Row,"LIST_PRICE");
		
		if((process_type == "1" || process_type == "3") && process_source[Row] == 'STCK'){
			alert("재고 또는 VMI 제품은 매입단가를 수정하실 수 없습니다.  ");
			mySheet.ReturnCellData( Row , Col);
			return;
		}
		mySheet.SetCellValue(Row,"SELECTED", "1"); 
		setMarginRate(Row);	// 매입단가 수정 후 자동으로 매익률 계산
		//getBuyerPrimeCostRate(Row);	// 매출원가 재계산
	}
	
}

//그리드 셀 변경시 이벤트
//SLOGIC-BEGIN(P03-3010-01)
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	//적용구분 선택에 따른 신규복사는 이벤트를 태우지 않음.
	if(copyGbn){
		return;
	}
	
	if(column == "UNIT_PRICE" && 
		(mySheet.GetCellValue(Row,"LIST_PRICE") != '0' 
		|| mySheet.GetCellValue(Row,"LIST_PRICE") != '' 
		|| mySheet.GetCellValue(Row,"LIST_PRICE") != 'null' 
		|| mySheet.GetCellValue(Row,"LIST_PRICE") != null)){   //판매단가 입력시
	
		unit_price   = mySheet.GetCellValue(Row,"UNIT_PRICE");
		list_price   = mySheet.GetCellValue(Row,"LIST_PRICE");
		
		mySheet.SetCellValue(Row,"SELECTED", "1");
		setMarginRate(Row);	// 매출단가 수정 후 자동으로 매익률 계산
	}
	
	if(column == "BUYER_ITEM_NO"){   //품목코드 입력시
		var buyer_item_no_temp = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var buyer_item_no_upper = buyer_item_no_temp.toUpperCase();
		mySheet.SetCellValue(Row,"BUYER_ITEM_NO", buyer_item_no_upper);
		mySheet.SetCellValue(Row,"SELECTED", "1");       
	}
	
	if(column == "DESCRIPTION"){    //품목명 입력시
		mySheet.SetCellValue(Row,"DESCRIPTION", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_DESCRIPTION", FilterString(Value));
	}
	
	if(column == "SPECIFICATION"){ //규격 입력시
		mySheet.SetCellValue(Row,"SPECIFICATION", FilterString(Value));
		mySheet.SetCellValue(Row,"KEP_SPECIFICATION", FilterString(Value));
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "KEP_MAKER_NAME"){ //표준 제조사명 입력시
		mySheet.SetCellValue(Row,"SELECTED", "1");
		//openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	}
	
	if(column == "MAKER_PART_NO"){
		mySheet.SetCellValue(Row,"SELECTED", "1");
	}
	
	if(column == "UNIT_MEASURE"){
		var buyer_code = $("#st_buyer_code").val();
		var unit_measure_temp = mySheet.GetCellValue(Row,"UNIT_MEASURE");
		var unit_measure_temp_upper = "";

		if(buyer_code=="KRDOOD0001" || buyer_code=="KRDOOS0028"){
			  unit_measure_temp_upper = unit_measure_temp;
		}else {
			  unit_measure_temp_upper = unit_measure_temp.toUpperCase();
		}
		mySheet.SetCellValue(Row,"UNIT_MEASURE", unit_measure_temp_upper);
		mySheet.SetCellValue(Row,"KEP_UNIT_MEASURE", unit_measure_temp_upper);
		mySheet.SetCellValue(Row,"SELECTED", "1" );
		
	}
	
	if(column == "PREV_DEAL_PRICE"){
		  mySheet.SetCellValue(Row,"SELECTED", "1" );
	}
		
	if(column == "ORIGIN_NAME"){
		agent_code = mySheet.GetCellValue(Row,"AGENT_CODE");
	}
}
//SLOGIC-END

function FilterString(val){

    var str= "";
    // 특수문자 아스키코드 값
    // $    ==> 36
    // '    ==> 39
    // "    ==> 34
    // ^    ==> 94
    for(var i=0;i<val.length;i++){
        if(val.charCodeAt(i) == 36){
		      str+=val.charAt(i).replace("$", "＄");
			}else if(val.charCodeAt(i) == 39) {
				  str+=val.charAt(i).replace("'", "′");
			}else if(val.charCodeAt(i) == 34) {
				  str+=val.charAt(i).replace("\"", "″");
			}else if(val.charCodeAt(i) == 94) {
				  str+=val.charAt(i).replace("^", "＾");
			}else if(val.charCodeAt(i) == 60) {
				  str+=val.charAt(i).replace("<", "〈");
			}else if(val.charCodeAt(i) == 62) {
				  str+=val.charAt(i).replace(">", "〉");
			}else {
				  str+=val.charAt(i);
			}
    }
    return str;
}

//매익률 계산
function setMarginRate(xRow){
	
	var unit_price	= parseFloat(mySheet.GetCellValue(xRow,"UNIT_PRICE"));	// 판매단가
	var list_price	= mySheet.GetCellValue(xRow,"LIST_PRICE");	// 매입단가
	if(list_price == "" || list_price == null || list_price == " "){
		list_price = 0;
	}
	
	var v_margin_rate	= kepGetRound((eval(unit_price)-eval(list_price))/eval(unit_price),2)*100;
	
	//매출단가가 null이면 return
	if(mySheet.GetCellValue(xRow,"UNIT_PRICE") == ''){ 
		return;
	}
	
	mySheet.SetCellValue(xRow,"PRICE_RATE", v_margin_rate);
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	/*if (column == 'IMPORT_FLAG') { //수입여부 선택
		if(!getBuyerPrimeCostRate(Row)) {	// 수입여부에 따라 매출원가 계산 적용
			return ;
		}
	
	} else if (column == 'LOGISTICS_FEE') { //별도정산원가 선택
		if(!getBuyerPrimeCostRate(Row)){	// 물류비에 따라 매출원가 계산 적용
			return ;
		}
	} else*/ 
		
	if (column == 'CMS_CATEG_NAME') { // KEP 표준카테고리 선택
		popupSel = "masterMpRqKepStndrdCategorySelPop";
		var no           = mySheet.GetCellValue(Row,"NO");
		var status       = mySheet.GetCellValue(Row,"STATUS");
		var cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		
		var desc = mySheet.GetCellValue(Row,"DESCRIPTION"); // 품목명
		var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
		var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var model = mySheet.GetCellValue(Row,"MAKER_PART_NO"); // 모델번호
		var choice_type = mySheet.GetCellValue(Row,"CATEGORY_CHOICE_TYPE"); // 선택구분(DQCAT01: 자동추천, DQCAT02 : 추천팝업, OFFCATE : 수동)
		
		var new_popup = window.open('','categ','scrollbars=no,width=721,height=670,resizable=no');
	    document.categFlow.action = "/mprq/showMasterMpRqKepStndrdCategorySelPop.do";
	    document.categFlow.target = "categ";
	    document.categFlow.method = "post";
	    
	    document.categFlow.categ_desc_flow.value = escape(desc);
	    document.categFlow.categ_spec_flow.value = escape(spec);
	    document.categFlow.categ_maker_flow.value = escape(maker);
	    document.categFlow.categ_model_flow.value = escape(model);
	    
	    document.categFlow.submit();
	    new_popup.focus();
		
	} else if(column == "CMS_CATLG_ID"){ //표준 카탈로그 선택
		popupSel = "stndCatlg";
	
		var desc = mySheet.GetCellValue(Row,"DESCRIPTION"); // 품목명
		var spec = mySheet.GetCellValue(Row,"SPECIFICATION"); // 규격
		var maker = mySheet.GetCellValue(Row,"MAKER_NAME"); // 제조사명
		var model = mySheet.GetCellValue(Row,"MAKER_PART_NO"); // 모델번호
		var row_num = Row;
			
		var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
	    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
	    document.catlgFlow.target = "categ";
	    document.catlgFlow.method = "post";
	    
	    document.catlgFlow.catlg_desc_flow.value = escape(desc);
	    document.catlgFlow.catlg_spec_flow.value = escape(spec);
	    document.catlgFlow.catlg_maker_flow.value = escape(maker);
	    document.catlgFlow.catlg_model_flow.value = escape(model);
	    document.catlgFlow.catlg_row_num.value = escape(row_num);
	    
	    document.catlgFlow.submit();
	    new_popup.focus();

	} else if (column == 'CATEGORY_TEXT') { // 고객사카테고리 선택
		popupSel = "commonCoCoBuyerCategoryChoicePop";
	    var buyer = $("#st_org_com_code").val();

		if(buyer == "KRDDDD0001" || buyer == "KRHYUN0026" || buyer == "KRISUC0002" ){
			popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do", '?st_buyer='+buyer, "400,500,no");
		}else if( buyer == "KRDOOD0001" || buyer == "KRDOOS0047" || buyer == "KRDOOS0004" 
			  || buyer == "KRILJI0003" || buyer == "KRILJI0026" || buyer == "KRILJI0043" || buyer == "KRDOOS0028" || buyer == "KRHSDE0003"){
			openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", '?st_buyer='+buyer+'&st_flag=ITM', "728,710,no");
		}else {
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do", '?st_buyer='+buyer+'&st_flag=ITM', "728,510,no");
		}
		
	}else  if (column == "MAKER_NAME" ){  // 제조사 선택
		popupSel = "maker";
			
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	
	}else  if (column == "KEP_MAKER_NAME" ){  // 표준제조사 선택
		popupSel = "kepMaker";
			
		openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
	
	}else  if (column == "BELOW_COMORG_NAME" ){  // 적용구분 선택
		
		var buyer = $("#st_buyer_code").val();
		var org_com_code = $("#st_org_com_code").val();
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		
		//그룹에 속해있지 않은 고객사는 적용구분 default
		if(buyer == org_com_code){
			//alert("그룹에 속해있지 않은 고객사는 적용구분을 선택할 수 없습니다.");
			return;
		}
		
		popupSel = "commonCoCoBottomOrgCodeMutilPop";
		openSearchPopup("/coco/getCommonCoCoBottomOrgCodeMultiPop.do", '?st_buyer='+buyer+'&st_buyer_item_no='+buyerItemNo, "700,300,no");
		
	} else if (column == 'AGENT_NAME') { // 협력사 선택
		popupSel = "masterMdCmSellerCmpyChoicePop";
		
		var processType = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		
		if(processType == "" ){
			  alert("거래유형을 먼저 선택해 주십시오.  ");
			  return;
		}else if(processType == "1" || processType == "3"){
			  alert("재고/VMI 건의 협력사는 물류센터가 되어야 합니다.  ");
		    return;
		}
		openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");

	} else if (column == 'ITEM_GROUP_NAME') { // 담당팀 선택
		popupSel = "masterMpSoTeamClassifyPop";
		//담당팀은 사업팀으로 default
		//kepOpenPopup(popupSel);	
		
	} else if (column == 'CONTRACT_NO') { // 계약서 번호 선택
		popupSel = "masterMdCmContractSelPop";
		var buyer = $("#st_buyer_code").val();
		
		openSearchPopup("/mdcm/getMasterMdCmContractSelPop.do", '?st_buyer='+buyer, "700,250,no");
	
	} else if (column == 'PROCESS_TYPE_NAME') { // 거래유형 선택
		popupSel = "commonCoCoGoodsDlvyClssifyPop2";	
		
		pre_process_type[Row] = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		
		/*요구사항=>거래유형 팝업에서 TR 물류창고에 값이 있으면 값이 보이고, 아니면 고객사에 해당하는 default 물류센터가 셋팅된다.*/
		var origin_agent = mySheet.GetCellValue(Row,"ORIGIN_AGENT");
		if(origin_agent==""){
			origin_agent = $("#st_warehouse_code").val();
		}
		var st_buyer_code = $("#st_buyer_code").val();
		
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop2.do?st_buyer_code="+st_buyer_code+"&defaultTr="+origin_agent, "", "500,250,no");
	
	}else if (column == "ORIGIN_NAME" ){ // 원산지 선택
		popupSel = "country";
		
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
	
	}else if (column == "KEP_ORIGIN_NAME" ){ // 표준원산지 선택
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
		popupSel = "kepCountry";
		
	} else if (column == 'ORIGIN_AGENT_NAME') { //물류관련협력사 선택
		popupSel = "masterMdCmSellerCmpyChoicePop";
		var process_type = mySheet.GetCellValue(Row,"PROCESS_TYPE");
		var origin_agent = mySheet.GetCellValue(Row,"ORIGIN_AGENT");

		if(process_type == ""){
			  alert("거래유형을 먼저 선택해 주십시오.  ");
			  return;
		}else if(process_type == "0" ){
			  alert("직납건은 물류관련 협력사를 선택하실 수 없습니다.  ");
			  return;
		}else if((process_type != "0" && process_type !="2") && origin_agent !="") {
			  alert("기존 물류센터 재고가 있는 건은 물류관련 협력사를 선택하실 수 없습니다.  ");
			  return;
		}else if(process_type == '2'){
		  	alert("TR건의 물류관련 협력사는 물류센터가 되어야 합니다.  ");
			  return;
		}else{
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
		  	return;
		}
		//물류관련 협력사 value set하기 위함.
		popupSel = "masterMdCmOriginAgentChoicePop";

	}else if(column == "SELLER_AREA_IMG"){
		popupSel = "deliAreaPop";
		var buyer = $("#st_buyer_code").val();
		var seller_area = mySheet.GetCellValue(Row, "SELLER_AREA");
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+seller_area+'&mod_yn=Y&st_area_chk_flag=N', "400,270,no");
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMdCmCatalogBuyerChoicePop") {	// 카탈로그 고객사 선택
		$("#st_type").val(value1);
		$("#st_buyer_code").val(value2);
		$("#st_buyer_name").val(value3);
		$("#st_org_buyer").val(value4);
		$("#st_org_com_code").val(value5);
		$("#st_warehouse_code").val(value6);
		mySheet.RemoveAll();
		//조회조건 매익률 계산
		getBuyerStandardRate();
	
	} else if (popupSel == "masterMpRqKepStndrdCategorySelPop") {	//KEP 표준카테고리 선택 
		mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', value3);
		mySheet.SetCellValue(grbRow, 'CMS_CATEG_NAME', value5);
		mySheet.SetCellValue(grbRow, 'CATEGORY_CHOICE_TYPE', value6);
		if(value6 == "DQCAT02"){
			mySheet.SetCellValue(grbRow, "CATEGORY_CHOICE_TYPE_NM", "추천팝업");	
		}else if(value6 == "OFFCATE"){
			mySheet.SetCellValue(grbRow, "CATEGORY_CHOICE_TYPE_NM", "수동선택");	
		}
		
	}else if (popupSel == "commonCoCoStndrdCatalogSearchPop") {	// 표준카탈로그 선택(테스트 필요)
		mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', value1);
		mySheet.SetCellValue(grbRow, 'ITEM_SEQ', value2);
		mySheet.SetCellValue(grbRow, 'CMS_CATEG_NAME', value3);
		mySheet.SetCellValue(grbRow, 'H_ATTR_FLAG', value4);
		mySheet.SetCellValue(grbRow, 'DESCRIPTION', value5);
		mySheet.SetCellValue(grbRow, 'KEP_DESCRIPTION', value6);
		mySheet.SetCellValue(grbRow, 'SPECIFICATION', value7);
		mySheet.SetCellValue(grbRow, 'KEP_SPECIFICATION', value8);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value9);
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_NAME', value10);
		mySheet.SetCellValue(grbRow, 'MAKER_PART_NO', value11);
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_PART_NO', value12);
		mySheet.SetCellValue(grbRow, 'UNIT_MEASURE', value13);
		mySheet.SetCellValue(grbRow, 'KEP_UNIT_MEASURE', value14);
	}else if (popupSel == "masterMpRqBuyerCatalogPop") {	// 고객사 카테고리
		mySheet.SetCellValue(grbRow, 'CATEGORY_NO', value1);
		mySheet.SetCellValue(grbRow, 'CATEGORY_TEXT', value2);
	}else if (popupSel == "masterMdCmSellerCmpyChoicePop") {	// 협력사
		setSysopAgentSelect(value1,value2,value8,grbRow);	
	
	}else if (popupSel == " masterMdCmOriginAgentChoicePop") { //물류관련협력사
		mySheet.SetCellValue(grbRow,"ORIGIN_AGENT", value1);
		mySheet.SetCellValue(grbRow,"ORIGIN_AGENT_NAME", value2);
		
	}else if (popupSel == "commonCoCoStndrdCatalogSearchPop") {	// 표준카탈로그
		var cmscatlg	  = value1;
		var cmscateg	  = value2;
		var maker_code	= value3;
		var maker_name	= value4;
		var origin_code = value5;
		var origin_name = value6;
		var agent_price = value7;
		var cms_categ_name = value8;
		var unit_measure = value10;
		
		mySheet.SetCellValue(grbRow,"ORIGIN_NAME",  origin_name);
		mySheet.SetCellValue(grbRow,"KEP_ORIGIN_NAME",  origin_name);
		mySheet.SetCellValue(grbRow,"ORIGIN_CODE",origin_code);
		mySheet.SetCellValue(grbRow,"KEP_ORIGIN_CODE",origin_code);
		
		mySheet.SetCellValue(grbRow,"MAKER_CODE", maker_code);
		mySheet.SetCellValue(grbRow,"KEP_MAKER_CODE",maker_code);
	    mySheet.SetCellValue(grbRow,"MAKER_NAME", maker_name);
	    mySheet.SetCellValue(grbRow,"KEP_MAKER_NAME", maker_name);

		mySheet.SetCellValue(grbRow,"CMS_CATEG_ID",  cmscateg);
		mySheet.SetCellValue(grbRow,"CMS_CATEG_NAME",  cms_categ_name);
		mySheet.SetCellValue(grbRow,"CMS_CATLG_ID",  cmscatlg);

	    mySheet.SetCellValue(grbRow,"LIST_PRICE",  agent_price);
	    mySheet.SetCellValue(grbRow,"UNIT_MEASURE",  unit_measure);
	    mySheet.SetCellValue(grbRow,"KEP_UNIT_MEASURE",  unit_measure);  
		
	}else if (popupSel == "maker") {	// 제조사
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
		
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_CODE', value3);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_NAME', value4);	
	
	}else if (popupSel == "kepMaker") {	// 표준제조사
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'KEP_MAKER_NAME', value2);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_CODE', value3);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_NAME', value4);	
	
	}else if (popupSel == "commonCoCoBottomOrgCodeMutilPop") {	//적용구분(하위부서코드)
		var bellow_code_array = value1.split("@");
		var bellow_name_array = value2.split("@");
		
		var arrayLength = bellow_code_array.length;
		
		var copyRow = grbRow;
		
		
		if(arrayLength == 1){
			mySheet.SetCellValue(grbRow, 'BELOW_COMORG_CODE', bellow_code_array[0]);
			mySheet.SetCellValue(grbRow, 'BELOW_COMORG_NAME', bellow_name_array[0]);
		}else if(arrayLength > 1){
			for(var i=0; i<arrayLength-1; i++){
				if(i==0){
					mySheet.SetCellValue(grbRow, 'BELOW_COMORG_CODE', bellow_code_array[i]);
					mySheet.SetCellValue(grbRow, 'BELOW_COMORG_NAME', bellow_name_array[i]);
					mySheet.SetCellValue(grbRow, 'SELECTED', '1');
				}else{
					var buyer           = $("#st_buyer_code").val();

					if(buyer == "") {
					    alert("고객사는 필수 선택사항입니다.  ");
					    return;
					}
					copyGbn = true;
					var rows = mySheet.DataInsert();
					
					mySheet.SetCellValue(rows, 'BELOW_COMORG_CODE', bellow_code_array[i]);
					mySheet.SetCellValue(rows, 'BELOW_COMORG_NAME', bellow_name_array[i]);
					mySheet.SetCellValue(rows, 'CMS_CATEG_NAME', mySheet.GetCellValue(copyRow, 'CMS_CATEG_NAME'));          
					mySheet.SetCellValue(rows, 'CMS_CATLG_ID', mySheet.GetCellValue(copyRow, 'CMS_CATLG_ID'));              
					mySheet.SetCellValue(rows, 'BUYER_ITEM_NO', mySheet.GetCellValue(copyRow, 'BUYER_ITEM_NO'));            
					mySheet.SetCellValue(rows, 'CATEGORY_TEXT', mySheet.GetCellValue(copyRow, 'CATEGORY_TEXT'));            
					mySheet.SetCellValue(rows, 'DESCRIPTION', mySheet.GetCellValue(copyRow, 'DESCRIPTION'));                
					mySheet.SetCellValue(rows, 'KEP_DESCRIPTION', mySheet.GetCellValue(copyRow, 'KEP_DESCRIPTION'));        
					mySheet.SetCellValue(rows, 'SPECIFICATION', mySheet.GetCellValue(copyRow, 'SPECIFICATION'));            
					mySheet.SetCellValue(rows, 'KEP_SPECIFICATION', mySheet.GetCellValue(copyRow, 'KEP_SPECIFICATION'));    
					mySheet.SetCellValue(rows, 'MAKER_NAME', mySheet.GetCellValue(copyRow, 'MAKER_NAME'));                  
					mySheet.SetCellValue(rows, 'KEP_MAKER_NAME', mySheet.GetCellValue(copyRow, 'KEP_MAKER_NAME'));          
					mySheet.SetCellValue(rows, 'MAKER_PART_NO', mySheet.GetCellValue(copyRow, 'MAKER_PART_NO'));            
					mySheet.SetCellValue(rows, 'KEP_MAKER_PART_NO', mySheet.GetCellValue(copyRow, 'KEP_MAKER_PART_NO'));    
					mySheet.SetCellValue(rows, 'UNIT_MEASURE', mySheet.GetCellValue(copyRow, 'UNIT_MEASURE'));              
					mySheet.SetCellValue(rows, 'KEP_UNIT_MEASURE', mySheet.GetCellValue(copyRow, 'KEP_UNIT_MEASURE'));      
					mySheet.SetCellValue(rows, 'AGENT_NAME', mySheet.GetCellValue(copyRow, 'AGENT_NAME'));                  
					mySheet.SetCellValue(rows, 'PROCESS_TYPE_NAME', mySheet.GetCellValue(copyRow, 'PROCESS_TYPE_NAME'));    
					mySheet.SetCellValue(rows, 'UNIT_PRICE', mySheet.GetCellValue(copyRow, 'UNIT_PRICE'));                  
					mySheet.SetCellValue(rows, 'LIST_PRICE', mySheet.GetCellValue(copyRow, 'LIST_PRICE'));                  
					mySheet.SetCellValue(rows, 'PREV_DEAL_PRICE', mySheet.GetCellValue(copyRow, 'PREV_DEAL_PRICE'));        
					//mySheet.SetCellValue(rows, 'KEP_PRICE', mySheet.GetCellValue(copyRow, 'KEP_PRICE'));                    
					mySheet.SetCellValue(rows, 'S_PRICE', mySheet.GetCellValue(copyRow, 'S_PRICE'));                        
					mySheet.SetCellValue(rows, 'PRICE_RATE', mySheet.GetCellValue(copyRow, 'PRICE_RATE'));                  
					mySheet.SetCellValue(rows, 'LOGISTICS_FEE', mySheet.GetCellValue(copyRow, 'LOGISTICS_FEE'));            
					mySheet.SetCellValue(rows, 'ITEM_GROUP_NAME', mySheet.GetCellValue(copyRow, 'ITEM_GROUP_NAME'));        
					mySheet.SetCellValue(rows, 'IMPORT_FLAG', mySheet.GetCellValue(copyRow, 'IMPORT_FLAG'));                
					mySheet.SetCellValue(rows, 'DELIVERY_LT', mySheet.GetCellValue(copyRow, 'DELIVERY_LT'));                
					mySheet.SetCellValue(rows, 'CONTRACT_NO', mySheet.GetCellValue(copyRow, 'CONTRACT_NO'));                
					mySheet.SetCellValue(rows, 'SELLER_ITEM_NO', mySheet.GetCellValue(copyRow, 'SELLER_ITEM_NO'));          
					mySheet.SetCellValue(rows, 'ORIGIN_NAME', mySheet.GetCellValue(copyRow, 'ORIGIN_NAME'));                
					mySheet.SetCellValue(rows, 'KEP_ORIGIN_NAME', mySheet.GetCellValue(copyRow, 'KEP_ORIGIN_NAME'));        
					mySheet.SetCellValue(rows, 'ORIGIN_AGENT_NAME', mySheet.GetCellValue(copyRow, 'ORIGIN_AGENT_NAME'));    
					mySheet.SetCellValue(rows, 'CMS_CATEG_ID', mySheet.GetCellValue(copyRow, 'CMS_CATEG_ID'));              
					mySheet.SetCellValue(rows, 'CATEGORY_NO', mySheet.GetCellValue(copyRow, 'CATEGORY_NO'));                
					mySheet.SetCellValue(rows, 'AGENT_CODE', mySheet.GetCellValue(copyRow, 'AGENT_CODE'));                  
					mySheet.SetCellValue(rows, 'ITEM_GROUP', mySheet.GetCellValue(copyRow, 'ITEM_GROUP'));                  
					mySheet.SetCellValue(rows, 'PROCESS_TYPE', mySheet.GetCellValue(copyRow, 'PROCESS_TYPE'));              
					mySheet.SetCellValue(rows, 'ORIGIN_CODE', mySheet.GetCellValue(copyRow, 'ORIGIN_CODE'));                
					mySheet.SetCellValue(rows, 'ORIGIN_AGENT', mySheet.GetCellValue(copyRow, 'ORIGIN_AGENT'));              
					mySheet.SetCellValue(rows, 'SEQ', mySheet.GetCellValue(copyRow, 'SEQ'));                                
					mySheet.SetCellValue(rows, 'QUOTATION_NO', mySheet.GetCellValue(copyRow, 'QUOTATION_NO'));              
					mySheet.SetCellValue(rows, 'MAKER_CODE', mySheet.GetCellValue(copyRow, 'MAKER_CODE'));                  
					mySheet.SetCellValue(rows, 'ITEM_NO', mySheet.GetCellValue(copyRow, 'ITEM_NO'));                        
					mySheet.SetCellValue(rows, 'BUYER', mySheet.GetCellValue(copyRow, 'BUYER'));                            
					mySheet.SetCellValue(rows, 'STANDARD_RATE', mySheet.GetCellValue(copyRow, 'STANDARD_RATE'));            
					mySheet.SetCellValue(rows, 'STATUS', mySheet.GetCellValue(copyRow, 'STATUS'));                          
					mySheet.SetCellValue(rows, 'H_ATTR_FLAG', mySheet.GetCellValue(copyRow, 'H_ATTR_FLAG'));                
					mySheet.SetCellValue(rows, 'ITEM_SEQ', mySheet.GetCellValue(copyRow, 'ITEM_SEQ'));                      
					mySheet.SetCellValue(rows, 'QUOTATION_SEQ', mySheet.GetCellValue(copyRow, 'QUOTATION_SEQ'));            
					mySheet.SetCellValue(rows, 'H_REVISION', mySheet.GetCellValue(copyRow, 'H_REVISION'));                  
					mySheet.SetCellValue(rows, 'H_ITEM_QTY', mySheet.GetCellValue(copyRow, 'H_ITEM_QTY'));                  
					mySheet.SetCellValue(rows, 'H_QUOTATION_SUM', mySheet.GetCellValue(copyRow, 'H_QUOTATION_SUM'));        
					mySheet.SetCellValue(rows, 'H_MASTERFLAG', mySheet.GetCellValue(copyRow, 'H_MASTERFLAG'));              
					mySheet.SetCellValue(rows, 'KEP_MAKER_CODE', mySheet.GetCellValue(copyRow, 'KEP_MAKER_CODE'));          
					mySheet.SetCellValue(rows, 'KEP_ORIGIN_CODE', mySheet.GetCellValue(copyRow, 'KEP_ORIGIN_CODE'));        
					mySheet.SetCellValue(rows, 'IMGFILE_NAME', mySheet.GetCellValue(copyRow, 'IMGFILE_NAME'));              
					mySheet.SetCellValue(rows, 'IMGFILE_DIR', mySheet.GetCellValue(copyRow, 'IMGFILE_DIR'));    
					mySheet.SetCellValue(rows, 'MOQ_QTY', mySheet.GetCellValue(copyRow, 'MOQ_QTY'));
					mySheet.SetCellValue(rows, 'SELLER_AREA_IMG', areaOff);
					mySheet.SetCellValue(rows, 'NEW_YN', "Y");	
					mySheet.SetCellValue(rows, 'SELECTED', "1");
				}
			}
		}
		
		mySheet.SetCellValue(grbRow, 'SELECTED', '1');
		copyGbn = false;

	} else if (popupSel == "masterMpSoTeamClassifyPop") {	//담당팀
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP_NAME', value1);
		mySheet.SetCellValue(grbRow, 'ITEM_GROUP', value2);	
	
	} else if (popupSel == "masterMdCmContractSelPop") {	//계약서
		mySheet.SetCellValue(grbRow, 'CONTRACT_NO', value1);		
		
	} else if (popupSel == "commonCoCoGoodsDlvyClssifyPop2") {	//거래유형
		if(value1 == "1" || value1 == "3"){  						//재고/VMI 선택
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE_NAME', value2);
			mySheet.SetCellValue(grbRow, 'LIST_PRICE', value7);
			mySheet.SetCellValue(grbRow, 'UNIT_MEASURE', value8);
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_NAME', value16);
			mySheet.SetCellValue(grbRow, 'CMS_CATEG_ID', value14);
			process_source[grbRow] = "STCK";
			
			mySheet.SetCellValue(grbRow, 'AGENT_NAME', value4);
			mySheet.SetCellValue(grbRow, 'AGENT_CODE', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', value6);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', value5);
			mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', value9);
			
		}else if(value1 == "2"){ 									//TR 선택
		
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE_NAME', value2);
			
			if(pre_process_type[grbRow] == '1' || pre_process_type[grbRow] == '3' ){
				mySheet.SetCellValue(grbRow,"AGENT_NAME", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT_NAME"));
				mySheet.SetCellValue(grbRow,"AGENT_CODE", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT"));
			}

			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', value4);
		}else{															//직납 선택
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
			mySheet.SetCellValue(grbRow, 'PROCESS_TYPE_NAME', value2);
			mySheet.SetCellValue(grbRow, 'CMS_CATLG_ID', "");
			
			if(pre_process_type[grbRow] == '1' || pre_process_type[grbRow] == '3' ){
				mySheet.SetCellValue(grbRow,"AGENT_NAME", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT_NAME"));
				mySheet.SetCellValue(grbRow,"AGENT_CODE", mySheet.GetCellValue(grbRow,"ORIGIN_AGENT"));
			}
			
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT', "");
			mySheet.SetCellValue(grbRow, 'ORIGIN_AGENT_NAME', "");
		}
		// 거래유형 따라 매출원가 계산 적용
		//getBuyerPrimeCostRate(grbRow);
	
	} else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
		
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_NAME', value3);
	} else if (popupSel == "kepCountry") {	// 표준원산지
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'KEP_ORIGIN_NAME', value3);	
		
	} else if (popupSel == "masterMdCmCopyCountPop") {	// 복사건수
		$("#st_copy_cnt").val(value1);
		doAction('copyTran');
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 고객사카테고리
		mySheet.SetCellValue(grbRow, 'CATEGORY_NO', value1);
		mySheet.SetCellValue(grbRow, 'CATEGORY_TEXT', value2);
	} else if(popupSel == "commonCoCoBuyerCategoryChoiceTreePop"){ //고객사카테고리 트리형
		if(value3 != "ITM" ){
			alert("ITEM 카테고리가 아닙니다.\n최하위 카테고리를 선택하여 주십시요.  ");
			return;
		}else{
			mySheet.SetCellValue(grbRow, 'CATEGORY_NO', value1);
			mySheet.SetCellValue(grbRow, 'CATEGORY_TEXT', value2);
		}
	} else if (popupSel == "deliAreaPop"){ // 납품지역
		mySheet.SetCellValue(grbRow, 'SELLER_AREA', value1);
	 	 if(value1 ==""){
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOff);
	 	 }else{
	 		mySheet.SetCellValue(grbRow, 'SELLER_AREA_IMG', areaOn);
	 	 }
	} else if (popupSel == "stndCatlg"){ // 표준카탈로그코드
		if(value1 == "manual"){ // 직접선택 시 표준카탈로그조회 팝업
			this.focus();

			openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_type=CATLG_REG&st_row_no="+value2,"900,800,no");
		}else if(value1 == "rcmd"){
			popupSel = "stndCatlg";
			
			var desc = mySheet.GetCellValue(value2,"DESCRIPTION"); // 품목명
 			var spec = mySheet.GetCellValue(value2,"SPECIFICATION"); // 규격
 			var maker = mySheet.GetCellValue(value2,"MAKER_NAME"); // 제조사명
 			var model = mySheet.GetCellValue(value2,"MAKER_PART_NO"); // 모델번호
 			var row_num = value2;
 			
			var new_popup = window.open('','categ','scrollbars=no,width=1000,height=600,resizable=no');
		    document.catlgFlow.action = "/mprq/showMasterMpRqCmsCatlgRcmdPop.do";
		    document.catlgFlow.target = "categ";
		    document.catlgFlow.method = "post";
		    
		    document.catlgFlow.catlg_desc_flow.value = escape(desc);
		    document.catlgFlow.catlg_spec_flow.value = escape(spec);
		    document.catlgFlow.catlg_maker_flow.value = escape(maker);
		    document.catlgFlow.catlg_model_flow.value = escape(model);
		    document.catlgFlow.catlg_row_num.value = escape(row_num);
		    
		    document.catlgFlow.submit();
		    new_popup.focus();
		}else{
			mySheet.SetCellValue(value2, 'CMS_CATLG_ID', value1);
			mySheet.SetCellValue(value2, 'CATALOG_CHOICE_TYPE', value3);
			if(value3 == "DQCAT02"){
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "추천팝업");	
			}else if(value3 == "OFFCATE"){
				mySheet.SetCellValue(value2, "CATALOG_CHOICE_TYPE_NM", "수동선택");	
			}
		}
	}
	
	mySheet.SetCellValue(grbRow, 'SELECTED', '1');
	grbRow="";	//초기화
}


//TABLE의 ROW 데이타 생성
function addrows() {
	
	var buyer           = $("#st_buyer_code").val();
    var buyer_item_no   = kepToUpper('st_buyer_item_no');
    var org_com_code = $("#st_org_com_code").val();
    $("#st_buyer_item_no").val(buyer_item_no);

	if(buyer == "") {
	    alert("고객사는 필수 선택사항입니다.  ");
	    return;
	}
	
	var rows = mySheet.DataInsert(-1);
	
	//그룹에 속해있지 않은 고객사는 적용구분 default
	if(buyer == org_com_code){
		mySheet.SetCellValue(rows, 'BELOW_COMORG_NAME', $("#st_buyer_name").val());
		mySheet.SetCellValue(rows, 'BELOW_COMORG_CODE', buyer);
	}
	
	mySheet.SetCellValue(rows, 'ORIGIN_NAME', "대한민국");
	mySheet.SetCellValue(rows, 'KEP_ORIGIN_NAME', "대한민국");
	mySheet.SetCellValue(rows, 'ORIGIN_CODE', "KR");
	mySheet.SetCellValue(rows, 'KEP_ORIGIN_CODE', "KR");
	mySheet.SetCellValue(rows, 'LOGISTICS_FEE', 0);
	mySheet.SetCellValue(rows, 'ITEM_GROUP_NAME', "사업팀");
	mySheet.SetCellValue(rows, 'ITEM_GROUP', "M");
	mySheet.SetCellValue(rows, 'BUYER', buyer);
	mySheet.SetCellValue(rows, 'NEW_YN', "Y");	
	mySheet.SetCellValue(rows, 'SELECTED', "1");
	mySheet.SetCellValue(rows, 'SELLER_AREA_IMG', areaOff);
	//mySheet.SetCellValue(rows, 'ITEM_MAKE_TYPE', "");
}

//체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
// 재귀함수
function checkedDel() {

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	if (mySheet.RowCount() == 0){
		alert("행이 없습니다.");
	}
	
	if (selectedGrid.length == 0){
		alert("선택하신 행이 없습니다.");
		return;
	}
	
	if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
		return;
	}

}

function mySheet_OnPopupClick(Row,Col) {
	//팝업을 연다.
	window.open("Sheet_Popup.jsp?row="+Row+"&col="+Col, "list",
	"scrollbars=no,fullscreen=no,width=250,height=350");
}

function getKwayCatlgInfo(){
	var customer_code = "25";  //KEPMRO = 25, 구매대행 = 6035
	openSearchPopup("/coco/getCommonCoCoStndrdCatalogSearchPop.do", '?CUSTOMER_CODE='+customer_code, "1000,800,no");
}

//매익률 계산
function getBuyerStandardRate(){
	var buyer	= $("#st_buyer_code").val();
	
	var param = {st_buyer_code: buyer};
	kepAjaxCall("/mdcm/getBuyerStandardRate.do",param,"getBuyerStandardRate");
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {

	if (pMethod == "getBuyerStandardRate") {
		db_buyer_adapt_flag		= $.trim("response.data.BUYER_ADAPT_FLAG");
		db_buyer_rate				= $.trim(eval("response.data.BUYER_RATE"));
		db_buyer_standard_rate	= $.trim(eval("response.data.BUYER_STANDARD_RATE"));   
		db_supply_direct_rate	= $.trim(eval("response.data.SUPPLY_DIRECT_RATE"));  
		db_stock_rate				= $.trim(eval("response.data.STOCK_RATE"));  
		db_tr_rate					= $.trim(eval("response.data.TR_RATE"));  
		db_vmi_rate				= $.trim(eval("response.data.VMI_RATE"));  
		db_import_rate			= $.trim(eval("response.data.IMPORT_RATE"));
		db_BelowComorgCode			= $.trim(eval("response.data.BELOW_COMORG_CODE")); // BELOW_COMORG_CODE 하위적용구분 추가 
		
		$("#st_below_comorg_code").val(db_BelowComorgCode); 		
		$("#st_buyer_standard_rate").val(Number(db_buyer_standard_rate));
		return;
	}
	
	if(pMethod == "DQCAT"){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		AjaxCallCount++;
		AjaxSuccCount++;
		
		loader_obj("Y");
		
		// response.categ_row_no1 = 매치율 1순위 리턴값만 사용 (ex response.categ_row_no5 = 5순위 리턴값)
		var categ_row_no = response.categ_row_no1;
		
		mySheet.SetCellValue(categ_row_no, "CMS_CATEG_NAME", response.categName1);
		mySheet.SetCellValue(categ_row_no, "CMS_CATEG_ID", response.cmsCategId1);
		mySheet.SetCellValue(categ_row_no, "CATEGORY_CHOICE_TYPE", response.choice_type1);
		mySheet.SetCellValue(categ_row_no, "CATEGORY_CHOICE_TYPE_NM", "자동추천");	
		
		if(AjaxCallCount == arrRow.length){
			if(AjaxSuccCount == arrRow.length){
				loader_obj("N");
				AjaxFailFlag = "N";
				alert("추천이 성공적으로 완료되었습니다.");
			}else{
				loader_obj("N");
				alert("추천 중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.");
			}
		}
    }
}

//ajax 공통 호출후 오류시 처리 함수
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "getBuyerStandardRate") {
		alert("매익률 계산 및 하위적용구분조회 오류 발생하였습니다.");
		return;
	}
	
	if(pMethod == "DQCAT"){
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		AjaxCallCount++;
		
		if(AjaxCallCount == arrRow.length){
			if(AjaxFailFlag == "Y"){
				loader_obj("N");
				alert("추천 중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.");
			}
		}
	}
} 

//SLOGIC-BEGIN(P03-3010-05)
//카탈로그 등록시 마진율, 일정금액 이상 체크
function setNewSysopCatalogReg(){

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	//선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		return;
	}
	
    var user_id = $("#st_user_id").val();
    
    for(var i=0; i<arrRow.length; i++){

        var unit_price = eval(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE")); //매출단가
        var list_price = eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE")); //매입단가
        var rate = ((unit_price - list_price)/unit_price)*100;

        var stdcateg_id   = mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID");   //표준카테고리번호
        var item_qty      = mySheet.GetCellValue(arrRow[i],"H_ITEM_QTY");       //신규소싱시 수량
        var quotation_sum = mySheet.GetCellValue(arrRow[i],"H_QUOTATION_SUM");  //신규소싱시 수량*단가

        var dood0001_rate = kepGetRound(((unit_price - list_price)/unit_price)*100,3);
        var standard_rate = mySheet.GetCellValue(arrRow[i],"STANDARD_RATE");
              
		if(stdcateg_id == "" || stdcateg_id == "null" || stdcateg_id == null) { 
            no = mySheet.GetCellValue(arrRow[i],"NO");
            alert(no+"번째행의 표준카테고리를 매핑바랍니다.  ");
			mySheet.SetCellValue(arrRow[i],"SELECTED","0" ); 
            return;				  
		}
		
		 if(eval(dood0001_rate) > eval(standard_rate) && standard_rate > 0){
             no = mySheet.GetCellValue(arrRow[i],"NO");
             alert(no+"번째행의 마진이 "+standard_rate+" 이상입니다.\n\n등록 불가 합니다.  ");
             mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
             setNewSysopCatalogReg();
             return;
         }
		
         if(unit_price == 0){
             no = mySheet.GetCellValue(arrRow[i],"NO");
             cc = confirm(no+"번째행의 판매단가가 0 입니다.\n가변단가로 등록하시겠습니까?  ");
             if(cc == false){
                 mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
                 setNewSysopCatalogReg();
                 return;
             }
         }
		if(user_id != "KOREAB2B"){
			if(eval(rate) > 30){
				no = mySheet.GetCellValue(arrRow[i],"NO");
				cc = confirm(no+"번째행의 마진율이 30% 이상입니다.\n현재 단가로 등록하시겠습니까?  ");
				if(cc == false){
					mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
					setNewSysopCatalogReg();
					return;
				}
			}
	        if(eval(unit_price) < eval(list_price)){
	            no = mySheet.GetCellValue(arrRow[i],"NO");
	            alert(no+"번째행의 단가는 역마진 입니다.\n\n등록 불가 합니다.\n\n품의 상신하여 주십시요.  ");
	            mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
	            setNewSysopCatalogReg();
	            return;
	        }
	        if(eval(unit_price) == eval(list_price)){
	            no = mySheet.GetCellValue(arrRow[i],"NO");
	            alert(no+"번째행의 단가는 노마진 입니다.\n\n등록 불가 합니다.\n\n품의 상신하여 주십시요.  ");
	            mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
	            setNewSysopCatalogReg();
	            return;
	        }
	        if(eval(quotation_sum) >= 500000){
	            no = mySheet.GetCellValue(arrRow[i],"NO");
	            alert(no+"번째행의 카탈로그는 신규소싱의 제출건입니다.\n\n현재 수량*매출단가는 50만원 이상입니다.\n\n품의 상신하여 주십시요.\n\n("+CommaNum(item_qty)+"*"+CommaNum(unit_price)+"="+CommaNum(quotation_sum)+")");
	            mySheet.SetCellValue(arrRow[i],"SELECTED", "0" ); 
	            setNewSysopCatalogReg();
	            return;
	        }
		}

	   if( stdcateg_id == "060101" ||
	       stdcateg_id == "060102" ||
	       stdcateg_id == "060103" ||
	       stdcateg_id == "060104" ||
	       stdcateg_id == "060201" ||
	       stdcateg_id == "060403" ||
	       stdcateg_id == "060601" ||
	       stdcateg_id == "060602" ||
	       stdcateg_id == "060603" ||
	       stdcateg_id == "060604" ||
	       stdcateg_id == "060605" ||
	       stdcateg_id == "060701" ||
	       stdcateg_id == "110101" ||
	       stdcateg_id == "110401" ||
	       stdcateg_id == "110402" ||
	       stdcateg_id == "110404" ||
	       stdcateg_id == "110405" ||
	       stdcateg_id == "110406" ||
	       stdcateg_id == "110407" ||
	       stdcateg_id == "110408") {
	      
	       no = mySheet.GetCellValue(arrRow[i],"NO");
	       alert(no+"번째행의 건은 사무용품 파트 정성욱 팀장에게 품의 상신하셔야 합니다.\n\n사무자재/전산용품은 따로 품의 바랍니다. ");
	       mySheet.SetCellValue(arrRow[i],"SELECTED", i, "0" ); 
	       setNewSysopCatalogReg();
	       return;
	  }


		var v_cms_description		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_DESCRIPTION"))); 
		var v_cms_specification	= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_SPECIFICATION")));
		var v_cms_maker_name		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_NAME")));
		var v_cms_part_no				= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_PART_NO")));
		var v_cms_unit_measure	= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_UNIT_MEASURE")));
		var v_cms_origin_name		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_ORIGIN_NAME")));
		var h_cms_maker_code		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_MAKER_CODE")));
		var h_cms_origin_code		= isEmpty(common.Trim(mySheet.GetCellValue(arrRow[i],"KEP_ORIGIN_CODE")));
		
		var t_text = "";

		if(v_cms_description||v_cms_specification||v_cms_maker_name||v_cms_part_no||v_cms_unit_measure||v_cms_origin_name||h_cms_maker_code||h_cms_origin_code){

				no = mySheet.GetCellValue(arrRow[i],"NO");

			  if (v_cms_description){
			 	    t_text="표준 품목명";
			  }else if (v_cms_specification){
			     	t_text="표준 규격";
			  }else if (v_cms_maker_name){
			 	    t_text="표준 제조사";
			  }else if (v_cms_part_no){
			 	    t_text="표준 모델명";
			  }else if (v_cms_unit_measure){
			 	    t_text="표준 단위";
			  }else if (v_cms_origin_name=""){
			     	t_text="표준 원산지";
			  }	   

				alert(no+"번째행의 "+t_text+" 를 입력하여 주세요.  ");  
					 return;
		 }
    }

    cc = confirm("선택하신 제품을 카탈로그 등록하시겠습니까?  ");
    if(cc){
        doAction('reg');
    }else {
        return;
    }
}
//SLOGIC-END

function setSysopByitAddSaveCMS(){
	process_source = null;
    process_source = new Array();
    
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	//선택 유무 체크
	if (selectedGrid.length == 0) {
		alert("대상을 선택해 주십시요.  ");
		return;
	}

    for(var i=0; i<arrRow.length; i++){
		var check_no = mySheet.GetCellValue(arrRow[i],"NO");  //NO  
		var unit_price    = eval(mySheet.GetCellValue(arrRow[i],"UNIT_PRICE"));    //판매단가
        var list_price    = eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE"));    //구입단가
        var status        = mySheet.GetCellValue(arrRow[i],"STATUS");              //STATUS
        var stdcateg_id   = mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID");        //표준카탈로그
        var buyer_item_no = mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO");       //품목코드
        var agent_code    = mySheet.GetCellValue(arrRow[i],"AGENT_CODE");          //협력사 코드
        
        if(buyer_item_no=="") {
            alert(check_no+"번째 품목코드를 입력하여 주십시요.  ");
            return ;
        }
		if(agent_code==""){
			alert(check_no+"번째 협력사를 지정 하여 주십시요.  ");
			return ;
		}
        if(status=="X" || status == "J" || stdcateg_id.length > 1) {
            alert(check_no+"번째 행은 이미 CMS 등록의뢰 하였습니다.  ");
            return ;
        }

        if(unit_price > 0 || list_price > 0){
            if(list_price > unit_price){
                cc = confirm(check_no+"번째행의 구입단가(="+list_price+")가 판매단가(="+unit_price+")보다 큽니다.\n이대로 저장 하시겠습니까?  ");
                if(cc == false){
                    mySheet.SetCellValue(arrRow[i],"SELECTED","0");
                    setSysopByitAddSaveCMS();
                    return;
                }
            }
        }

		trimValue(arrRow[i]);
    	
    }
    
    var buyer = $("#st_buyer_code").val();
	if(buyer == "") {
		alert("고객사는 필수 선택사항입니다.  ");
		return;
	}
    
	cc = confirm("CMS 등록 의뢰 하시겠습니까?  ");
    if(cc){
    	//CMS등록
        doAction('confirm');
    }else {
        return;
    }
}

//품목명,규격 좌우 공백 제거
function trimValue(row){ 
	  var ch_desc = $.trim(mySheet.GetCellValue(row,"DESCRIPTION"));
	  var ch_spec = $.trim(mySheet.GetCellValue(row,"SPECIFICATION"));
	  mySheet.SetCellValue(row, "DESCRIPTION", ch_desc);
	  mySheet.SetCellValue(row, "SPECIFICATION", ch_spec);
}

//조회 조건  - 팝업 링크 조건 초기화
function kepEraserCatalog(){
	$("#st_type").val("");
	$("#st_buyer_code").val("");
	$("#st_buyer_name").val("");
	$("#st_org_buyer").val("");
	$("#st_org_com_code").val("");
}

//SLOGIC-BEGIN(P03-3010-04)
//협력사 세팅
function setSysopAgentSelect(agent_code,agent_name,logistics_center_cnt,nu_i) {
	var process = mySheet.GetCellValue(nu_i,"PROCESS_TYPE");
	if((process == "0" || process == "2") && Number(logistics_center_cnt) > 0){
		alert("거래유형이 직납,TR인 경우\n\n물류센타를 협력사로 지정 할수 없습니다.\n\n확인 바랍니다.  ");
		mySheet.SetCellValue(nu_i,"AGENT_NAME", "");
		mySheet.SetCellValue(nu_i,"AGENT_CODE", "");
		return;
	}else{
	
		mySheet.SetCellValue(nu_i,"AGENT_NAME", agent_name);
		mySheet.SetCellValue(nu_i,"AGENT_CODE", agent_code);
		mySheet.SetCellValue(nu_i,"SELECTED", "1");
		/*if(!getBuyerPrimeCostRate(nu_i)) {	// 협력사변경 따라 매출원가 계사 적용
			return ;
		}*/
		/* KWAY유통 카탈로그 맵핑 제거.
		if(agent_code == "KRSESI0003"){
			alert("KWAY 연계품목은 KWAY 유통 카탈로그와 맵핑하셔야 합니다.  ");
			//getKwayCatlgInfo();
		}else{
			mySheet.SetCellValue(nu_i,"CMS_CATEG_ID", "");
			mySheet.SetCellValue(nu_i,"CMS_CATEG_NAME", "");
			mySheet.SetCellValue(nu_i,"CMS_CATLG_ID", "");
		}
		*/		
	}
}
//SLOGIC-END

//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "DELIVERY_LT"){ //표준납기일
		var value1 = mySheet.GetCellValue(arrRow[0], "DELIVERY_LT");
		if(kepIsValueNull(value1)){
			alert("복사할 표준납기일을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "DELIVERY_LT", value1);
		}
		
	} else if (mySheet.ColSaveName(Col) == "DESCRIPTION"){ // 품목명
		var value1 = mySheet.GetCellValue(arrRow[0], "DESCRIPTION");
		if(kepIsValueNull(value1)){
			alert("복사할 품목명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "DESCRIPTION", value1);
			mySheet.SetCellValue(arrRow[idx], "KEP_DESCRIPTION", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "SPECIFICATION"){ // 규격
		var value1 = mySheet.GetCellValue(arrRow[0], "SPECIFICATION");
		if(kepIsValueNull(value1)){
			alert("복사할 규격을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "SPECIFICATION", value1);
			mySheet.SetCellValue(arrRow[idx], "KEP_SPECIFICATION", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "MAKER_PART_NO"){ // PART_NO
		var value1 = mySheet.GetCellValue(arrRow[0], "MAKER_PART_NO");
		if(kepIsValueNull(value1)){
			alert("복사할 PART_NO를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "MAKER_PART_NO", value1);
			mySheet.SetCellValue(arrRow[idx], "KEP_MAKER_PART_NO", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "KEP_MAKER_PART_NO"){ // 표준모델명
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_MAKER_PART_NO");
		if(kepIsValueNull(value1)){
			alert("복사할 표준모델명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "KEP_MAKER_PART_NO", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "CONTRACT_NO"){ // 계약서번호
		var value1 = mySheet.GetCellValue(arrRow[0], "CONTRACT_NO");
		if(kepIsValueNull(value1)){
			alert("복사할 계약서번호를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CONTRACT_NO", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "MAKER_NAME"){ // 제조사명
		var value1 = mySheet.GetCellValue(arrRow[0], "MAKER_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "MAKER_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 제조사명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "MAKER_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "MAKER_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "KEP_MAKER_NAME"){ // 표준제조사명
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_MAKER_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "KEP_MAKER_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 표준제조사명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "KEP_MAKER_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "KEP_MAKER_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "UNIT_MEASURE"){ // 단위
		var value1 = mySheet.GetCellValue(arrRow[0], "UNIT_MEASURE");
		if(kepIsValueNull(value1)){
			alert("복사할 단위를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "UNIT_MEASURE", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "KEP_UNIT_MEASURE"){ // 표준단위
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_UNIT_MEASURE");
		if(kepIsValueNull(value1)){
			alert("복사할 표준단위를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "KEP_UNIT_MEASURE", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "CATEGORY_TEXT"){ // 카테고리명
		var value1 = mySheet.GetCellValue(arrRow[0], "CATEGORY_TEXT");
		var value2 = mySheet.GetCellValue(arrRow[0], "CATEGORY_NO");
		if(kepIsValueNull(value1)){
			alert("복사할 카테고리명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CATEGORY_TEXT", value1);
			mySheet.SetCellValue(arrRow[idx], "CATEGORY_NO", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "AGENT_NAME"){ // 협력사명
		var value1 = mySheet.GetCellValue(arrRow[0], "AGENT_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "AGENT_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 협력사명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "AGENT_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "AGENT_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "PROCESS_TYPE_NAME"){ // 거래유형
		var value1 = mySheet.GetCellValue(arrRow[0], "PROCESS_TYPE_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "PROCESS_TYPE");
		if(kepIsValueNull(value1)){
			alert("복사할 거래유형을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "PROCESS_TYPE_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "PROCESS_TYPE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "ORIGIN_NAME"){ // 원산지명
		var value1 = mySheet.GetCellValue(arrRow[0], "ORIGIN_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "ORIGIN_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 원산지명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "ORIGIN_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "ORIGIN_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "KEP_ORIGIN_NAME"){ // 표준원산지명
		var value1 = mySheet.GetCellValue(arrRow[0], "KEP_ORIGIN_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "KEP_ORIGIN_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 표준원산지명을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "KEP_ORIGIN_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "KEP_ORIGIN_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "BELOW_COMORG_NAME"){ // 적용구분
		var value1 = mySheet.GetCellValue(arrRow[0], "BELOW_COMORG_NAME");
		var value2 = mySheet.GetCellValue(arrRow[0], "BELOW_COMORG_CODE");
		if(kepIsValueNull(value1)){
			alert("복사할 적용구분을 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "BELOW_COMORG_NAME", value1);
			mySheet.SetCellValue(arrRow[idx], "BELOW_COMORG_CODE", value2);
		}
	} else if (mySheet.ColSaveName(Col) == "GPM_NO"){ // 품의번호
		var value1 = mySheet.GetCellValue(arrRow[0], "GPM_NO");
		if(kepIsValueNull(value1)){
			alert("복사할 품의번호를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "GPM_NO", value1);
		}
	} else if (mySheet.ColSaveName(Col) == "ITEM_MAKE_TYPE"){ // 품목구분
		var value1 = mySheet.GetCellValue(arrRow[0], "ITEM_MAKE_TYPE");
		if(kepIsValueNull(value1)){
			alert("복사할 품의번호를 입력하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "ITEM_MAKE_TYPE", value1);
		}
	}
}

function kepApprovalReturn(flag,docu_no){
	doAction('search');
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")
String userDept = _sessionInfo.getDepartment();
%>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>카탈로그 등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_user_name" name="st_user_name"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_mode" name="st_mode" >
			<input type="hidden" id="st_product_close_flag" name="st_product_close_flag" >
			<input type="hidden" id="st_copy_cnt" name="st_copy_cnt" value="">
			<input type="hidden" id="st_warehouse_code" name="st_warehouse_code" value="">
			<input type="hidden" id="st_below_comorg_code" name="st_below_comorg_code" value="">
			
            	<table  class="cont_t_list01" >
					<caption>카탈로그 등록</caption>
					<colgroup>
						<col width="90px" />
						<col width="41%" />
						<col width="90px" />
						<col width="15%" />
						<col width="90px" /> 
                        <col width="17%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th  align="right" ><font color="red"><b>*</b></font>고객사&nbsp;</th>
							<td>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<input type="hidden" name="st_org_buyer" id="st_org_buyer" value="">
								<input type="hidden" name="st_org_com_code" id="st_org_com_code" value="">
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:51%" onclick="doPop('masterMdCmCatalogBuyerChoicePop');" readonly><a href="javascript:doPop('masterMdCmCatalogBuyerChoicePop');"><img src="/resources/images/btn_search03.gif"></a><a href="javascript:kepEraserCatalog();"><img src="/resources/images/btn_eraser2.gif"></a>
								<input type="text" class="input_type_text" name="st_type" id="st_type" size="10" disabled> 
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							<th>표준매익률</th>
							<td class="font1_table_font" width="17%" align = "left">
			                  <input type="text" class="input_type_text"  name="st_buyer_standard_rate" id="st_buyer_standard_rate" style="width:20%;text-align:right;border-width:0px;background-color:rgb(245, 245, 245);" id="line" value = "" readonly>%
			                </td>
						</tr>
						<tr> 
							<th>상태</th>
							<td>
								<select name="st_status_ing" id="st_status_ing" >
				                    <option value="ALL">------전체------</option>
				                    <option value="CO">등록가능</option>
				                    <option value="IN">등록불가</option>
			                  </select>
							</td>
							<th >품목명</th>
				      		<td colspan="5"><input type="text" class="input_type_text"  name="st_description" id="st_description" style="width:60%;" value="" onKeyDown="kepEnter()"></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl">
           		<!-- 페이징처리 오류로 인한 hidden값 추가 -->
           		<input type="hidden" name="onepagerow" value="10" >
           		<input type="hidden" id="pageindex" >
				&nbsp;※구분:<img src="/resources/images/rd_pin.gif" style="width:12px; height:12px;">-->기 등록, <img src="/resources/images/icon_g.gif">-->신규,&nbsp;&nbsp;중복:<img src="/resources/images/rd_pin.gif" style="width:12px; height:12px;">-->등록대기중/준비중 <img src="/resources/images/icon_g.gif">-->신규 <img src="/resources/images/icon_r.gif">-->CMS매핑중
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
               <div class="btnArea" style="margin-bottom:0px;">
  	          	<span class="fl">
  					<span class="btn_02 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmCatalogReg.xls">등록양식</a></span>
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">일괄 업로드</a></span>
  					<span class="btn_06 mr04"><a href="/resources/excel/work/CATALOG/masterMdCmStandardCode.xls">표준코드 다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<%if(userDept.trim().equals("017")){%>
						<span class="btn_02 mr04"><a href="javascript:setSysopByitAddSaveCMS();">CMS등록</a></span>
					<%}%>
					
  					<span class="btn_02 mr04"><a href="javascript:doAction('categ');">추천</a></span> 
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span> 
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span> 
					<span class="btn_02 mr04"><a href="javascript:doAction('copy');">복사</a></span>
					<span class="btn_02"><a href="javascript:setSysopNewCatalogPmSendImsi();">품의상신</a></span>
					<!-- <span class="btn_02"><a href="javascript:setNewSysopCatalogRegSaveImsi();">등록</a></span> -->
  				</span>
  			 </div>
  			 <br>
  			 ※ <b><font color="red">업로드양식 항목 추가로 다시 다운받으시기 바랍니다.(2022/11/10 기준)</font></b><br>
  			 ※ 양식 업로드 시 헤더 순서에 영향이 있어 그리드 헤더의 이동 기능은 불가합니다. 
  			 ※ 실제 반영까지는 스케쥴링 작업으로 인해 최대 10분 정도 소요 예상.  			 

<!--내용 종료-->	                 
<form name="categForm" id="categForm" method="post" action ="">
	<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="60">
	<input type="hidden" name="categ_target_count" id="categ_target_count" value="1">
	<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
    <input type="hidden" name="categ_desc" id="categ_desc" value="">
    <input type="hidden" name="categ_spec" id="categ_spec" value="">
    <input type="hidden" name="categ_maker" id="categ_maker" value="">
    <input type="hidden" name="categ_model" id="categ_model" value="">
    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="true">
    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="true">
    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="true">
    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
</form>
<form name="categFlow" id="categFlow" method="post" action ="">
    <input type="hidden" name="categ_desc_flow" id="categ_desc_flow" value="">
    <input type="hidden" name="categ_spec_flow" id="categ_spec_flow" value="">
    <input type="hidden" name="categ_maker_flow" id="categ_maker_flow" value="">
    <input type="hidden" name="categ_model_flow" id="categ_model_flow" value="">
</form>
<form name="catlgForm" id="catlgForm" method="post" action ="">
	<input type="hidden" name="catlg_target_rate" id="catlg_target_rate" value="60">
	<input type="hidden" name="catlg_target_count" id="catlg_target_count" value="1">
	<input type="hidden" name="catlg_row_no" id="catlg_row_no" value="">
    <input type="hidden" name="catlg_desc" id="catlg_desc" value="">
    <input type="hidden" name="catlg_spec" id="catlg_spec" value="">
    <input type="hidden" name="catlg_maker" id="catlg_maker" value="">
    <input type="hidden" name="catlg_model" id="catlg_model" value="">
    <input type="hidden" name="catlg_desc_flag" id="catlg_desc_flag" value="true">
    <input type="hidden" name="catlg_spec_flag" id="catlg_spec_flag" value="true">
    <input type="hidden" name="catlg_maker_flag" id="catlg_maker_flag" value="true">
    <input type="hidden" name="catlg_model_flag" id="catlg_model_flag" value="false">
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
