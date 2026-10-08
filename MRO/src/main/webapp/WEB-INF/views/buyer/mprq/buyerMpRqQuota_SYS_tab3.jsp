<%--
**********************************************
* 메뉴 : 상품견적현황
* 화면 : 견적합의대상(삼양사)
* 기능 : 
* 프로그램 ID : BU0301001
* 담당자 : 최찬규
* 착수일 : 2026-04-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
	// 공통
	@SuppressWarnings(value = "unchecked")
	List<Map<String, String>> _gridList = (List<Map<String, String>>) request.getAttribute("data"); // 조회된 결과
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String total_cnt = CommonUtil.nvlObj((List<Map<String, String>>) _gridList, "0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"), "1"); // 현재페이지  (필수)
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), ""); // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), ""); // 조회일(To)
	String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), ""); // 조회필드콤보
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"), ""); // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"), ""); // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"), ""); // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"), ""); // 견적번호
	String st_desc_spec = CommonUtil.nvl((String) request.getParameter("st_desc_spec"), "");
	String st_btoa_user_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_name"), "");
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"), "");
	String user_group = CommonUtil.nvl((String) _sessionInfo.getUserGroup(), "");
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String st_com_code = _sessionInfo.getComCode();
	String user_id = _sessionInfo.getUserId();
	String st_term_pass_flag = CommonUtil.nvl((String) request.getParameter("st_term_pass_flag"), "N"); // 기간무시 체크
	String st_sourcing_sort = CommonUtil.nvl((String) request.getParameter("st_sourcing_sort"), ""); // 정렬기능
	String st_user_group = CommonUtil.nvl((String) request.getParameter("st_user_group"),_sessionInfo.getUserGroup());
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer_select"),"");  // 계열사정보
	// 조회조건 E
	//SLOGIC-BEGIN(P04-4027-02)
	String reportid = "RD_04_M_004_03";
	String reporttype = "B";
	if (_gridList != null) {
		if (_gridList.size() > 0) {
			Map<String, String> p04402702 = CommonUtil.getSpecialCheckReturnMap(st_com_code, "P04-4027-02"); // st_com_code , 특수로직아이디
			if (p04402702 != null) {
				reporttype = CommonUtil.nvl(p04402702.get("COL01_DATA"), reporttype); // 레포트type
				reportid = CommonUtil.nvl(p04402702.get("COL02_DATA"), reportid); // 레포트아이디
			}
		}
	}
%>
<script type="text/javascript">
var mySheet3 = new ibsheetObject();
var tFlag = "N";
var btoa_user_chk = "Y";
var tmpParam="";
var popupSel="";

window.tabs = window.tabs || {};
tabs.buyerMpRqQuota_tab3 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>", //확인
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMpRqQuota_tab3.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	product_amt : 0,
	product_cnt : 0,
		
	init:function(){
		
		var initsheet3 = {};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight: 50, DataRowHeight: 30, Alternate : 0, UseNoDataRow:1, FrozenCol:2};
		initsheet3.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태",	SaveName: "sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",		SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",		SaveName:"QUOTATION_NO", Cursor:"Pointer", FontColor:"#3a72c7"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",		SaveName:"SOURCING_TEXT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"진행상태",		SaveName:"SOURCING_STATUS"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MSDS상태",		SaveName:"MSDS_TYPE_TEXT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS_STATUS",		SaveName:"MSDS_STATUS"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",		SaveName:"BUYER_NAME"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",		SaveName:"QUOTATION_SEQ"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",		SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:290,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",		SaveName:"MAKER_PART_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수량",		SaveName:"ITEM_QTY"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"조달일수",		SaveName:"LEAD_TIME"}
		,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"견적단가",		SaveName:"ATOB_UNIT_PRICE",	Format:"${priceFormat}", Cursor:"Pointer", FontColor:"#3a72c7"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"Nego요청단가",	SaveName:"BTOA_NEGO_PRICE",	Format:"${priceFormat}"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Button",	Header:"첨부",		SaveName:"IMAGE_KEY_CNT",	ClassName:'Type03'}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"첨부",		SaveName:"IMAGE_KEY"}			
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적요청일",	SaveName:"BTOA_DATE"} // 기존 견적의뢰일
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적제출일",	SaveName:"ATOB_DATE"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",		SaveName:"ORIGIN_NAME"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"MSDS",		SaveName:"MSDS_IMAGE" , Cursor:"Pointer", FontColor:"#3a72c7" }
        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선입고",		SaveName:"PRE_GR_FLAG"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",		SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",		SaveName:"AGENT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",		SaveName:"BTOA_USER_DEPT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",		SaveName:"BTOA_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"재고코드",		SaveName:"RE_ITEM_NO"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"MSDS_NO",		SaveName:"MSDS_NO"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"REVISION",		SaveName:"REVISION"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BID_SUCCESS_QUOTATION_SEQ",		SaveName:"BID_SUCCESS_QUOTATION_SEQ"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"AGENT_OPEN_FLAG",		SaveName:"AGENT_OPEN_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"PRODUCT_CLOSE_FLAG",		SaveName:"PRODUCT_CLOSE_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BTOA_USER_ID",		SaveName:"BTOA_USER_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE",		SaveName:"BYCA_COMORG_CODE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"NEGO_YN",		SaveName:"NEGO_YN"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CONFIRM_YN",	SaveName:"CONFIRM_YN"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CANCEL_REMARK",	SaveName:"CANCEL_REMARK"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BTOA_END_DATE2",	SaveName:"BTOA_END_DATE2"}  // 네고요청 시 새로운 회신요청일
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BTOA_NEGO_PRICE2",	SaveName:"BTOA_NEGO_PRICE2"}  // 네고 요청 시 입력한 네고단가
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"NEGO_REMARK",	SaveName:"NEGO_REMARK"}  // 네고 요청 시 입력한 요청사항
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"NOCODE_YN",		SaveName:"NOCODE_YN"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BUYER_TARGET_PRICE",		SaveName:"BUYER_TARGET_PRICE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"REG_ITEM_NO",		SaveName:"REG_ITEM_NO"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"KEP_USER_ID",		SaveName:"KEP_USER_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"STOA_LIST_PRICE",		SaveName:"STOA_LIST_PRICE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"ORIGIN_CODE",		SaveName:"ORIGIN_CODE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"LOAD_USER_ID",		SaveName:"LOAD_USER_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CMS_CATEG_ID",		SaveName:"CMS_CATEG_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"CMS_CATLG_ID",		SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"PROCESS_TYPE",		SaveName:"PROCESS_TYPE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"IMPORT_FLAG",		SaveName:"IMPORT_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"WAREHOUSE_CODE",	SaveName:"WAREHOUSE_CODE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BELOW_COMORG_CODE",		SaveName:"BELOW_COMORG_CODE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"ITEM_GROUP",		SaveName:"ITEM_GROUP"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"ITEM_DETAIL_DESC",		SaveName:"ITEM_DETAIL_DESC"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"IMGFILE_NAME",		SaveName:"IMGFILE_NAME"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"IMGFILE_DIR",		SaveName:"IMGFILE_DIR"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"GREEN_FLAG",		SaveName:"GREEN_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"MIN_ORDER_QTY",		SaveName:"MIN_ORDER_QTY"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"PUR_UNIT_QTY",		SaveName:"PUR_UNIT_QTY"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"SELL_CLOSE_DATE",		SaveName:"SELL_CLOSE_DATE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BUY_CLOSE_DATE",		SaveName:"BUY_CLOSE_DATE"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"REG_ITEM_NO",		SaveName:"REG_ITEM_NO"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"REG_ITEM_NO2",		SaveName:"REG_ITEM_NO2"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"MSDS_YN",		SaveName:"MSDS_YN"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BUYER_MSDS_YN",		SaveName:"BUYER_MSDS_YN"}
		];

		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		
		mySheet3.SetHighlightAfterSort(2);
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		
	},
	
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_3").val(),$("#st_to_date_3").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_3','st_to_date_3','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		this.current_page = 1;
		
		kepSearch_v2(document.searchCondition3, mySheet3, "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2.do?page="+this.current_page , this.pagingMode);
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition3, mySheet3, "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition3');
		kepMonth_v2('st_from_date_3','st_to_date_3','1');
		mySheet3.RemoveAll();
	},
	doPop:function(str,value1,value2,value3,value4,value5, value6){
		switch (str) {
		case "getMsdsView":
			if(value1 == ""){
				return;
			}
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop_v2.do","?st_msds_no="+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,700,no');
			break;
		case "kepQuotDetailInfo": //견적상세 팝업
			var src = "/common/getBuyerQuotDetailInfoPopSYS_v2.do";
			var parm = "?st_buyer="+value1+"&st_quotation_no="+value2+
			"&st_quotation_seq="+value3+"&st_revision="+value4+"&st_agent="+value5+"&st_idx="+value6+"&type=3&reportId=<%=reportid%>&reportType=<%=reporttype%>";
			openSearchPopup(src,parm, '940,930,no');
			break;
		case "kepQuotPriceInfo": //견적단가 상세 팝업
			var src = "/common/getQuotDetailInfoPop_v2.do";
			var parm = "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4+"&st_agent="+value5;
			if(isEmpty(value5)) {
				var text ="<%=CommonLang.msg("MSG111")%>"; //견적서가 발행되지 않은 품목입니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
				return;
	        }
			
			var size=380;
			
			openSearchPopup("/common/getQuotDetailInfoPop_v2.do", "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4, "520,"+size+",yes");
			break;
		}
	},
	excelDownload:function(){
		if(mySheet3.RowCount() == 0){
//	 		alert("조회된 데이터가 없습니다.");
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		if (kep_dateSearchCheck($("#st_from_date_3").val(),$("#st_to_date_3").val()) == false) return;

		if (kepGetDateDiff('st_from_date_3','st_to_date_3','D') > 372 ){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var checkRows = mySheet3.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		
		// 선택된 항목 유무 체크
		if (checkRows.length == 0) {
			var text = "항목을 선택해주세요.";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		mySheet3.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i = 1; i <= mySheet3.RowCount(); i++) {
			if(mySheet3.GetCellValue(i,"SELECTED"))
				downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<= mySheet3.LastCol(); i++){
			if(!mySheet3.GetColHidden(i) && mySheet3.ColSaveName(i) !="SELECTED" && mySheet3.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		downCol = downCol+"|MIS_BUYER_NAME|KEP_USER_NAME";
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "상품견적현황_합의대상";
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet3.Down2Excel(param);
	},
	quotation_print:function(buyer, quotation_no, quotation_seq, revision, agent, buyer_item_no) { // 품목코드 클릭 / 견적서 출력
		if(isEmpty(agent)) {
			var text = "<%=CommonLang.msg("MSG111")%>"; //견적서가 발행되지 않은 품목입니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return
		}
		
		//SLOGIC-BEGIN(P04-4027-02)
		var fileName = "<%=reportid%>";
		var type = "<%=reporttype%>";
		var param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+buyer_item_no+"]";
		if (type == "A"){
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+buyer_item_no+"]";
		} else if (type == "E"){
			var query = "";
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+query+"]";
		} else if (type == "F"){
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+buyer+"]";
		}
	  	reportOpen(fileName,param);
	/*
	A	RD_04_B_004_01
	B	RD_04_M_004_03
	C	RD_04_B_006_02
	D	RD_04_B_004_05
	E	RD_04_B_006_03
	F	RD_04_B_006_04
	*/
		//SLOGIC-END
		
		return;
	},
	rqdtList:function(){ // 기존 견적서 출력 버튼
	    var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
	    var arrRow  = selectedGrid.split("|");
	    
	    if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
		if(arrRow.length > 1){
	        var text = "<%=CommonLang.msg("MSG497")%>"; // 한 건 이상은 선택이 불가능 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
		}
        
		var li_agent = mySheet3.GetCellValue(arrRow[0],"AGENT");
        
		if(isEmpty(li_agent)) {
			var text = "<%=CommonLang.msg("MSG111")%>";	// 견적서가 발행되지 않은 품목입니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
		
        var st_buyer = mySheet3.GetCellValue(arrRow[0],"BUYER");
		var li_quotation_no     = mySheet3.GetCellValue(arrRow[0],"QUOTATION_NO");
        var li_quotation_seq    = mySheet3.GetCellValue(arrRow[0],"QUOTATION_SEQ");
        var li_revision         = mySheet3.GetCellValue(arrRow[0],"REVISION");
		var li_buyer_item_no = mySheet3.GetCellValue(arrRow[0],"BUYER_ITEM_NO");
		
        this.quotation_print(st_buyer,li_quotation_no,li_quotation_seq,li_revision,li_agent,li_buyer_item_no);
        
	},
	setPopupReturn:function (value1,value2,value3,value4, value5){
		if(popupSel == "cancelRemark"){
		    if(isEmpty(value1)){return;}
		    var value1Row = value1.split(":::");
			var value2Row = value2.split(":::");
			var value3Row = value3.split(":::");
			var value4Row = value4.split(":::");
			var value5Row = value5.split(":::");
			
			for(var i = 0; i < value1Row.length; i++){
				var curIdx = value1Row[i];
				if(mySheet3.GetCellValue(curIdx, "QUOTATION_NO") == value2Row[i] && mySheet3.GetCellValue(curIdx, "QUOTATION_SEQ") == value3Row[i]
				&& mySheet3.GetCellValue(curIdx, "BUYER") == value5Row[i] ) {// 고객사, 견적번호, 견적항번 같은 경우
					mySheet3.SetCellValue(curIdx, "CANCEL_REMARK", value4Row[i]); // 해당 행 취소사유 값에 채워넣기
				}
			}
			kepSave(document.searchCondition3, mySheet3, "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2.do", "SELECTED");
			
		}else if(popupSel == "negoSubmit"){ // 1 : idx, 2: 견적단가, 3 : 요청사항, 4: 네고 회신 요청일
		    if(isEmpty(value1)){return;}
		    
			var value1Row = value1.split("^^");
			var value2Row = value2.split("^^");
			var value3Row = value3.split("^^");
			var value4Row = value4.split("^^");
			
			for(var i = 0; i < value1Row.length; i++){
				var curIdx = value1Row[i];
				mySheet3.SetCellValue(curIdx, "BTOA_NEGO_PRICE2", value2Row[i]); // 견적단가 
				mySheet3.SetCellValue(curIdx, "NEGO_REMARK", value3Row[i]); // 해당 행 취소사유 값에 채워넣기
				mySheet3.SetCellValue(curIdx, "BTOA_END_DATE2", value4Row[i]); // 네고회신요청일
			}
			kepSave(document.searchCondition3, mySheet3, "/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqList_v2.do", "SELECTED");
		}else{ // 상세팝업
			if(isEmpty(value1)){return;}
			if(value1 == "cancelRqdt"){
				mySheet3.SetCellValue(value2, "CANCEL_REMARK", value3); // 해당 행 취소사유 값에 채워넣기
				
				kepSave(document.searchCondition3, mySheet3, "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2.do", "SELECTED");
			}else if(value1 == "negoRqdt"){
				mySheet3.SetCellValue(value2, "BTOA_NEGO_PRICE2", value3); // 견적단가 
				mySheet3.SetCellValue(value2, "NEGO_REMARK", value4); // 해당 행 취소사유 값에 채워넣기
				mySheet3.SetCellValue(value2, "BTOA_END_DATE2", value5); // 네고회신요청일
				kepSave(document.searchCondition3, mySheet3, "/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqList_v2.do", "SELECTED");
			}
		}
	},
	cancelRqdt:function(){ //견적취소
	    var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
	    var arrRow  = selectedGrid.split("|");
	    tmpParam ="";
	    if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
	    
	    for(var i = 0 ; i < arrRow.length; i++){
	    	var curIdx = arrRow[i]
        	var st_confirm_yn = mySheet3.GetCellValue(curIdx,"CONFIRM_YN");
        	
	     	if(st_confirm_yn == "N"){
		    	//선택한 고객사는 네고요청 권한이 없습니다.
		    	var text = "<%=CommonLang.msg("MSG79")%>";
		    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return false;
		    }
	     	
	    	 // 0 : idx, 1 : 견적번호 , 2 : 견적항번, 3 : 품목코드 , 4 : 품목명, 5: 고객사코드
	    	tmpParam += curIdx+":::"+mySheet3.GetCellValue(curIdx, "QUOTATION_NO")+":::"+mySheet3.GetCellValue(curIdx, "QUOTATION_SEQ")
	    	+":::"+mySheet3.GetCellValue(curIdx, "BUYER_ITEM_NO")+":::"+mySheet3.GetCellValue(curIdx, "DESCRIPTION")+":::"+mySheet3.GetCellValue(curIdx, "BUYER")+"@@";
		}
	    
	    var text = arrRow.length + "건의 상품 견적을 취소하시겠습니까?";	
	    var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpRqQuota_tab3.saveBuyerMprqCancelList_v2(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	},
	saveBuyerMprqCancelList_v2:function(){
		closePopText1();
		popupSel = "cancelRemark";
		openSearchPopup('/common/remarkCancelPop.do','?tab_id=buyerMpRqQuota_tab3'+'&viewType='+popupSel+'&param='+encodeURIComponent(tmpParam),'870,480,no');
	},
	negoSubmit:function(){ // 네고요청 
		var returnValue = true;
		var chkFlag = false;
		tmpParam="";
		var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
	    var arrRow  = selectedGrid.split("|");
	    
	    if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
		
	    
		for(var i = 0 ; i < arrRow.length; i++){
			var curIdx = arrRow[i];
        	var st_confirm_yn = mySheet3.GetCellValue(curIdx,"CONFIRM_YN");
        	var st_nego_yn=  mySheet3.GetCellValue(curIdx,"NEGO_YN"); //네고여부
        	var st_confirm_price = mySheet3.GetCellValue(curIdx,"ATOB_UNIT_PRICE"); // 견적단가
        	
        	if(st_confirm_price == 0 || st_confirm_price == "0") {
        		var text = "<%=CommonLang.msg("MSG599")%>";
   				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
       			return false;
          	}

	       	if(st_confirm_yn == "N"){
		    	//선택한 고객사는 네고요청 권한이 없습니다.
		    	var text = "<%=CommonLang.msg("MSG79")%>";
		    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return false;
		    }
	       	// 0 : idx, 1 : 견적번호 , 2 : 견적항번, 3 : 품목코드 , 4 : 품목명, 5: 견적 단가
	    	tmpParam += curIdx+":::"+mySheet3.GetCellValue(curIdx, "QUOTATION_NO")+":::"+mySheet3.GetCellValue(curIdx, "QUOTATION_SEQ")+":::"+mySheet3.GetCellValue(curIdx, "BUYER_ITEM_NO")
	    		+":::"+mySheet3.GetCellValue(curIdx, "DESCRIPTION")+":::"+mySheet3.GetCellValue(curIdx, "ATOB_UNIT_PRICE")+"@@";
       }
	
		var text = arrRow.length + "건의 상품을 Nego 요청하시겠습니까?";	
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpRqQuota_tab3.saveBuyerMprqNegoList_v2(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	},
	saveBuyerMprqNegoList_v2:function(){
		closePopText1();
		popupSel = "negoSubmit";
		openSearchPopup('/mprq/showBuyerMpRqNegoReqPop_v2.do','?param='+tmpParam,'1020,775,no');
	},
	getQuotationHiteLists:function (){ //SLOGIC-BEGIN(P04-4027-03) //하이트 강원 견적서 // 견적서 출력 버튼
		var query = "";
		
		var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
		var arrRow  = selectedGrid.split("|");
		var curIdx = 0;
		var tmpBuyer = "";
		
		if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
		
		for(var j=0; j<arrRow.length; j++) {
			curIdx=arrRow[j];
			if(j == 0){
				tmpBuyer = mySheet3.GetCellValue(curIdx, "BUYER");
			}
			var li_buyer			= mySheet3.GetCellValue(curIdx, "BUYER");
			var li_quotation_no     = mySheet3.GetCellValue(curIdx, "QUOTATION_NO");
			var li_quotation_seq    = mySheet3.GetCellValue(curIdx, "QUOTATION_SEQ");
			var li_revision         = mySheet3.GetCellValue(curIdx, "REVISION");
			var agent				= mySheet3.GetCellValue(curIdx, "AGENT");
			
	        if(tmpBuyer != li_buyer){
	        	//고객사가 다를경우 견적서 출력이 불가능합니다.
		    	var text = "<%=CommonLang.msg("MSG93")%>";
		    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return false;
	        }
	        
			if(isEmpty(agent) || agent=="") {
				//번째 품목은 견적서가 생성되지 않았습니다.
				var text = (j+1)+"<%=CommonLang.msg("MSG94")%>";
		    	openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		    	return false;
			}
					
			query	+= li_buyer			+"$$";
			query	+= li_quotation_no	+"$$";
			query	+= li_quotation_seq	+"$$";
			query	+= li_revision			 ;
			query	+= "^||^";
		
		}
		
		var param = "";
		
 		fileName = "RD_04_B_006_03";
		param = "["+tmpBuyer+"]["+query+"]";
	  	reportOpen(fileName,param);
	  	
		return;
	}, confirmKepPrice:function(){ // 단가합의
		
		var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
		var arrRow  = selectedGrid.split("|");
		var curIdx = 0;
		
		for(var j=0; j<arrRow.length; j++) {
			curIdx=arrRow[j];
			
			var msds_yn = mySheet3.GetCellValue(curIdx,"MSDS_YN");
			var msds_status = mySheet3.GetCellValue(curIdx,"MSDS_STATUS");
			var st_confirm_price = mySheet3.GetCellValue(curIdx,"ATOB_UNIT_PRICE"); // 견적단가
        	
        	if(st_confirm_price == 0 || st_confirm_price == "0" || st_confirm_price == "") {
        		var text = "<%=CommonLang.msg("MSG599")%>"; //견적단가 0원인 건은 합의할 수 없습니다. KEP담당자에게 문의 바랍니다.
    			openLayerPopText2(text, this.but1text, this.but1func, this.but1width); 
        		return;
        	}
	    	if(mySheet3.GetCellValue(curIdx,"ITEM_GUBUN") == "I"){
	    		doos_item_no_back = mySheet3.GetCellValue(curIdx,"RE_ITEM_NO");
	        	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
	        		var text = "<%=CommonLang.msg("MSG84")%>"; //재고코드가 입력되지 않았습니다.
	  				  openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	                  return;
	               }	            		
	    	}
	    	if(msds_yn == "Y"){
	        	if(msds_status != "A"){
	                  var text = "<%=CommonLang.msg("MSG784")%>"; //MSDS가 승인되지 않았습니다.
	  				  openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	                  return;
	            }	            		
            }
	    	
	    	this.product_amt +=  mySheet3.GetCellValue(curIdx, "ATOB_UNIT_PRICE");
		   	this.product_cnt ++;
		}
		
		var text = "<%=CommonLang.msg("MSG361")%>"; //단가합의 하시겠습니까?	
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpRqQuota_tab3.proceedConfirmKepPrice(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
	}, proceedConfirmKepPrice:function() {
		closePopText1();
		var formArr = this.getSheetToForm();
		
		if(formArr != null && formArr !=""){
			document.forms.contentForm.s_SAVENAME.value = formArr[0];
			$("#content").html(formArr[1]);
		} else {
			var text = "<%=CommonLang.msg("MSG13")%>"; //그리드 데이터 변환에 실패하였습니다.
			openLayerPopText2(text, this.but1text, this.but1func, this.but1width); 
	        return;
		}
		
		kepAjaxFormCallTab("/mprq/saveBuyerMpRqUnitpriceAgrmntMulti.do", "contentForm", "confirmKepPrice","buyerMpRqQuota_tab3");

	}, getSheetToForm:function(){
		const form = document.getElementById("contentForm");
		form.reset();
		
	    var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
		var arrRow  = selectedGrid.split("|");
		var curIdx = 0;
		
		var arrRow = selectedGrid.split("|");
		var resultArr = ["", ""]; // [0]: Name 리스트, [1]: Input 태그 리스트
		
	    // 2. Input Name과 Sheet SaveName 매핑 설정
		const fieldMap = {
	        "st_buyer2": "BUYER",
	        "st_quotation_no2": "QUOTATION_NO",
	        "st_quotation_seq2": "QUOTATION_SEQ",
	        "st_revision2": "REVISION",
	        "st_btoa_nego_price2": "BTOA_NEGO_PRICE2",
	        "st_btoa_end_date2": "BTOA_END_DATE2",
	        "st_agent2": "AGENT",
	        "st_reg_item_no2": "REG_ITEM_NO",
	        "st_contract_no": "CONTRACT_NO",
	        "st_contract_seq": "CONTRACT_SEQ",
	        "st_byit_comorg_code": "BYCA_COMORG_CODE",
	        "st_kep_user_id": "KEP_USER_ID",
	        "st_buyer_target_price": "BUYER_TARGET_PRICE",
	        "st_target_price": "BUYER_TARGET_PRICE",
	        "st_stoa_list_price": "STOA_LIST_PRICE",
	        "st_description": "DESCRIPTION",
	        "st_specification": "SPECIFICATION",
	        "st_unit_measure": "UNIT_MEASURE",
	        "st_maker_name": "MAKER_NAME",
	        "st_origin_code": "ORIGIN_CODE",
	        "st_lead_time": "LEAD_TIME",
	        "st_load_user_id": "LOAD_USER_ID",
	        "st_atob_unit_price": "ATOB_UNIT_PRICE",
	        "st_cms_categ_id": "CMS_CATEG_ID",
	        "st_cms_catlg_id": "CMS_CATLG_ID",
	        "st_process_type": "PROCESS_TYPE",
	        "st_import_flag": "IMPORT_FLAG",
	        "st_warehouse_code": "WAREHOUSE_CODE",
	        "st_below_comorg_code": "BELOW_COMORG_CODE",
	        "st_item_group": "ITEM_GROUP",
	        "st_image_key": "IMAGE_KEY",
	        "st_item_detail_desc": "ITEM_DETAIL_DESC",
	        "st_imgfile_name": "IMGFILE_NAME",
	        "st_imgfile_dir": "IMGFILE_DIR",
	        "st_product_close_flag": "PRODUCT_CLOSE_FLAG",
	        "st_nocode_yn": "NOCODE_YN",
	        "st_green_flag": "GREEN_FLAG",
	        "st_msds_yn": "BUYER_MSDS_YN",
	        "st_msds_status": "MSDS_STATUS",
	        "st_msds_yn" : "MSDS_YN",
	        "st_msds_no": "MSDS_NO",
	        "st_cancle_remark": "CANCEL_REMARK",
	        "st_confirm_yn": "CONFIRM_YN",
	        "st_pre_gr_flag": "PRE_GR_FLAG",
	        "st_btoa_user_id": "BTOA_USER_ID",
	        "st_min_order_qty": "MIN_ORDER_QTY",
	        "st_pur_unit_qty": "PUR_UNIT_QTY",
	        "st_nego_yn": "NEGO_YN",
	        "st_sell_close_date": "SELL_CLOSE_DATE",
	        "st_buy_close_date": "BUY_CLOSE_DATE",
	        "st_confirm_price": "ATOB_UNIT_PRICE",
	        "st_buyer_item_no2": "BUYER_ITEM_NO",
	        "st_buyer_item_no3": "BUYER_ITEM_NO",
	        "st_doos_item_no_back":"RE_ITEM_NO",
	        "st_doos_item_no_first":"REG_ITEM_NO2",
	        "st_kep_item_no":"REG_ITEM_NO"
	    };
		
		// 2. 시트에 없는 고정값 매핑 (직접 값 입력)
	    const fixedFieldMap = {
	        "st_confirm_user_id2": "<%=user_id%>",
	        "st_user_id": "<%=user_id%>",
	        "st_buyer": "<%=st_com_code%>",
	        "st_btoa_end_time2": "190000"
	    };

	    const sheetKeys = Object.keys(fieldMap);
	    const fixedKeys = Object.keys(fixedFieldMap);
	    
		// 2. 선택된 행 반복
	    for (var j = 0; j < arrRow.length; j++) {
	        var curIdx = arrRow[j];
	        
	     // A. 시트에서 가져오는 항목 처리
	        sheetKeys.forEach(function(inputName) {
	            var saveName = fieldMap[inputName];
	            var cellValue = mySheet3.GetCellValue(curIdx, saveName);
	            
	            resultArr[0] += inputName + "|";
	            resultArr[1] += "<input type='hidden' name='" + inputName + "' value='" + cellValue + "'>";
	        });

	        // B. 시트에 없는 고정값 항목 처리 (추가된 부분)
	        fixedKeys.forEach(function(inputName) {
	            var fixedValue = fixedFieldMap[inputName];
	            
	            resultArr[0] += inputName + "|";
	            resultArr[1] += "<input type='hidden' name='" + inputName + "' value='" + fixedValue + "'>";
	        });
	    }

	    // 4. 마지막 파이프(|) 제거
	    if (resultArr[0] !== "") {
	        resultArr[0] = resultArr[0].substring(0, resultArr[0].length - 1);
	    }

	    return resultArr;
	},proceedAppSend:function(){
		closePopText1(); 
		
		var formArr = this.getSheetToForm();
		
		if(formArr != null && formArr !=""){
			document.forms.contentForm.s_SAVENAME.value = formArr[0];
			$("#content").html(formArr[1]);
		} else {
			var text = "<%=CommonLang.msg("MSG13")%>"; //그리드 데이터 변환에 실패하였습니다.
			openLayerPopText2(text, this.but1text, this.but1func, this.but1width); 
	        return;
		}
		<%-- updateRqdtAppSendDBlinkList 호출 시 INSERT INTO KEP_APIF_LOTTECS@keplink (AP_TYPE, AP_NO, AP_RESULT, AP_NOTE, AP_DATE, IF_FLAG, IF_DATE, MNG_DATE)
			       VALUES ('Q', 'Q260400001' /**P*/,null,null,null,'Y',SYSDATE, null) 이런식으로 이미 null 들어가잇음 오류 아님 --%>
		kepAjaxFormCallTab("/mprq/getBuyerMpRqAppSend.do","contentForm","appSend","buyerMpRqQuota_tab3"); 
	},
	kepAjaxSuccess:function(pMethod , response){
		if (pMethod=="nonPassAgrmnt") {
			var text = response.msg.msg;
			openLayerPopText2(text, this.but1text, this.but1funcSearch, this.but1width); 
			return;
		}
		var buyer = "<%=st_com_code%>";
		if (pMethod == 'confirmKepPrice'){
			if (response.msg.usrmsg == "N"){
				var text = response.msg.msg;
				openLayerPopText2(text, this.but1text, this.but1funcSearch, this.but1width); 
				return;
			}
			if (response.msg.passflag == "N"){
					this.btn3Layer(buyer,response.msg.usrmsg);
// 					var type = "NS"; // 소싱합의
// 					openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&tab_id=buyerMpRqQuota_tab3', "1000,500,no");
				
			} else { // 필수
				if (response.msg.buyerpopflag == "Y") {
					window.open(response.msg.callurl,"AppPop");
					this.search();
				} else {
					var type = "NS"; // 소싱합의
					openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&tab_id=buyerMpRqQuota_tab3&nu_tot_price='+this.product_amt+'&nu_tot_cnt='+this.product_cnt, "800,860,no");	
				}
			}
		}else {
			// 처리후 재조회
			this.search();
		}
	},
	kepAjaxError:function(pMethod , response) {
		var text =  "<%=CommonLang.msg("MSG418")%>"; // 오류발생하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	},
	thisPopClose:function(){
		closePopText2();
		
		this.search();
	},
	kepApprovalReturn:function(flag,DOCU_NO){
		this.search();
	},
	btn3Layer:function(buyer,docu_no){
		//단가합의 방식에 따라 전자결재 진행 여부를 선택해주세요. 
		var text = "<%=CommonLang.msg("MSG783")%>";
		var content = "<%=CommonLang.msg("MSG782")%>";
		var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
		var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; // 전자결재
		var but3textC = "<%=CommonLang.get("HTITLE131")%>"; // 단가합의
		var but1funcC = "javascript:closePopText3(); return false;";
		var but2funcC = "javascript:tabs.buyerMpRqQuota_tab3.exec('1','"+buyer+"','"+docu_no+"'); return false";
		var but3funcC = "javascript:tabs.buyerMpRqQuota_tab3.exec('2'); return false";
		var but1widthC = "120px";
		var but2widthC = "120px";
		var but3widthC = "120px";
		openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
	},
	exec:function(flag,buyer,docu_no){
		closePopText3();
		
		if(flag == "1"){ //전자결재
			var type = "NS";
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+docu_no+'&PARAM1='+buyer+'&tab_id=buyerMpRqQuota_tab3&nu_tot_price='+this.product_amt+'&nu_tot_cnt='+this.product_cnt, "800,860,no");
		}else{ //단가합의
			kepAjaxFormCallTab("/mprq/saveBuyerMpRqUnitpriceAgrmntNonPass.do","contentForm","nonPassAgrmnt","buyerMpRqQuota_tab3"); 
		}
	}
};


//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpRqQuota_tab3.but1text,tabs.buyerMpRqQuota_tab3.but1func,tabs.buyerMpRqQuota_tab3.but1width);
	}
	
	for(var i = 1; i <= mySheet3.RowCount(); i++){
		if(mySheet3.GetCellValue(i,"ITEM_GUBUN") == "I"){
			mySheet3.SetCellEditable(i,"RE_ITEM_NO",true);
		}else{
			mySheet3.SetCellValue(i,"RE_ITEM_NO",mySheet3.GetCellValue(i,"REG_ITEM_NO2"))
		}
	}
	makePageIndex_v3( mySheet3 , tabs.buyerMpRqQuota_tab3.current_page , document.searchCondition3.onepagerow.value,"buyerMpRqQuota_tab","3");
}
//그리드 셀클릭 이벤트
function mySheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet3.ColSaveName(mySheet3.GetSelectCol());
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet3.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		var st_image_key = mySheet3.GetCellValue(Row, "IMAGE_KEY");
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}else if(column =="QUOTATION_NO"){
		mySheet3.SetCellValue(Row, 1, 1); // 팝업 눌렀던 행 선택되도룩
		tabs.buyerMpRqQuota_tab3.doPop('kepQuotDetailInfo', mySheet3.GetCellValue(Row, "BUYER"), mySheet3.GetCellValue(Row, "QUOTATION_NO"), mySheet3.GetCellValue(Row, "QUOTATION_SEQ"), mySheet3.GetCellValue(Row, "REVISION"), mySheet3.GetCellValue(Row, "AGENT"),Row);
	}
// 	else if(column =="BUYER_ITEM_NO"){
// 		tabs.buyerMpRqQuota_tab3.quotation_print(mySheet3.GetCellValue(Row, "BUYER"), mySheet3.GetCellValue(Row, "QUOTATION_NO"), mySheet3.GetCellValue(Row, "QUOTATION_SEQ"), mySheet3.GetCellValue(Row, "REVISION"), mySheet3.GetCellValue(Row, "AGENT"), mySheet3.GetCellValue(Row, "BUYER_ITEM_NO"));
// 	}
	else if(column =="ATOB_UNIT_PRICE"){
		tabs.buyerMpRqQuota_tab3.doPop('kepQuotPriceInfo', mySheet3.GetCellValue(Row, "BUYER"), mySheet3.GetCellValue(Row, "QUOTATION_NO"), mySheet3.GetCellValue(Row, "QUOTATION_SEQ"), mySheet3.GetCellValue(Row, "REVISION"), mySheet3.GetCellValue(Row, "AGENT"));
	}else if(column =="MSDS_IMAGE"){
		if(mySheet3.GetCellValue(Row, "MSDS_NO") != ""){
			tabs.buyerMpRqQuota_tab3.doPop('getMsdsView',mySheet3.GetCellValue(Row, "MSDS_NO"), mySheet3.GetCellValue(Row, "BUYER"), mySheet3.GetCellValue(Row, "QUOTATION_NO"), mySheet3.GetCellValue(Row, "QUOTATION_SEQ"), mySheet3.GetCellValue(Row, "REVISION"));
		}
	}
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet3_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(msg != ""){
		if(code == 0){ //재조회
			openLayerPopText2(msg,tabs.buyerMpRqQuota_tab3.but1text,tabs.buyerMpRqQuota_tab3.but1funcSearch,tabs.buyerMpRqQuota_tab3.but1width);
// 			kepSearch(document.searchCondition2, mySheet2, "/mprq/getBuyerMpRqQuotaProceState_v2.do" , this.pagingMode);
		}else{
			openLayerPopText2(msg,tabs.buyerMpRqQuota_tab3.but1text,tabs.buyerMpRqQuota_tab3.but1func,tabs.buyerMpRqQuota_tab3.but1width);
		}
		return;
	}
	
}
</script>
<div id="Search3" class="SearchContent">
	<div class="Importance">
		<img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.get("HTITLE1505")%> <!-- '단가합의대상', '단가합의결재반려', 'Nego합의대상' 상태의 상품견적을 확인하실 수 있으며, 단가합의와 NEGO 요청,견적취소를 진행할 수 있습니다. -->
	</div>
	<form name="searchCondition3" id="searchCondition3" method="POST">
		<!--HIDDEN-->
		<input type="hidden" name="s_SAVENAME" /> 
		<input type="hidden" name="st_user_group" id="st_user_group_3" value="<%=st_user_group %>" />
		<input type="hidden" name="onepagerow" id="onepagerow_3" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_3" name="pageflag" value="1" />
		<input type="hidden" name="st_user_id" id="st_user_id_3" value="${sessionInfo.userId}"> 
		<input type="hidden" name="st_query" id="st_query" value="" />
		<input type="hidden" name="st_com_code" id="st_com_code_3" value="${sessionInfo.comCode}">
		<table class="TabSearchTable" id="table_list">
			<colgroup>
				<col width="125px" />
				<col width="450px" />
				<col width="80px" />
				<col width="300px" />
				<col width="85px" />
				<col width="240px" />
			</colgroup>
			<tr>
				<th><label for="b_code" class="hidden"><%=CommonLang.get("HTITLE151")%><!-- 견적일 --></label>
					<select name="st_date_type" id="st_date_type" class="Select" style="font:10px;width:95%">
						<option value="BTOA" >견적요청일</option>
						<option value="ATOB" selected >견적제출일</option>
					</select>
				</th>
				<td>
					<div class="Buyer-datepicker-wrap"
						style="width: 231px; margin-right: 8px">
						<div class="Buyer-date-input" data-datepicker>
							<input style="" type="text" placeholder="" name="st_from_date" id="st_from_date_3" readonly /><span></span>
						</div>
						<span class="Buyer-dash">~</span>
						<div class="Buyer-date-input" data-datepicker>
							<input style="" type="text" placeholder="" name="st_to_date" id="st_to_date_3" readonly /><span></span>
						</div>
					</div>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','1'); return false;">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','3'); return false;">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','6'); return false;">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
<%-- 					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_3','st_to_date_3','12'); return false;">1<%=CommonLang.get("HTITLE424")%><!-- 년 --></button> --%>
				</td>
				<th>견적번호</th>
				<td><input class="input40" type="text" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab3')">
				</td>
				<th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
				<td><label for="b_delivery" class="hidden">진행상태선택</label>
					<select name="st_sourcing_status" id="st_sourcing_status" class="Select40"  style="width:83%">
						<option value="" <%if ("".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
						<option value="RQ14" ><%=CommonLang.get("HTITLE138")%><!-- Nego합의대상 --></option>
						<option value="RQ13" ><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></option>
						<option value="RQ09" ><%=CommonLang.get("HTITLE1217")%><!-- 합의결재반려 --></option>
					</select>
				</td>
				
			</tr>
			<tr>
				<th><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				<td><input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" class="input40" value="<%=st_btoa_user_dept_name%>" style="width:89%" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab3')"/></td>
				<th><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
				<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" class="input40" value="<%=st_btoa_user_name%>" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab3')"></td>
				<th>MSDS상태</th>
				<td><label for="b_delivery" class="hidden">진행상태선택</label>
					<select name="st_sourcing_status" id="st_sourcing_status" class="Select40"  style="width:83%">
						<option value="" ><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
						<option value="YC" >MSDS제출</option>
						<option value="YT" >MSDS검토</option>
						<option value="YA" >MSDS승인</option>
					</select>
				</td>
			</tr>
			<tr>
				<th><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
				<td><select name="st_buyer_select" id="st_buyer_select" class="Select40" style="width:90%">
						<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TCFM",_sessionInfo.getComCode(), "ICOMCOD3", st_buyer_select, "") %>
				</select></td>
			</tr>
		</table>
	</form>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab3.reload(); return false;"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></button>
		<button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab3.search(); return false;"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></button>
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
			<button class="But_ExcelDown40" onclick="javascript:tabs.buyerMpRqQuota_tab3.excelDownload(); return false;"><%=CommonLang.get("HTITLE150")%><!--엑셀 다운로드--></button>
			<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab3.getQuotationHiteLists(); return false;"><%=CommonLang.get("HTITLE128")%><!--견적서 출력--></button>
		</div>
		<div class="buttonRight"> 
	<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab3.cancelRqdt(); return false;"><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></button>
	<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab3.negoSubmit(); return false;"><%=CommonLang.get("HTITLE130")%><!-- 네고요청 --></button>
	<button class="ButMPrimary"		  onclick="javascript:tabs.buyerMpRqQuota_tab3.confirmKepPrice(); return false;"><%=CommonLang.get("HTITLE131")%><!-- 단가합의 --></button>
		</div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">
			createIBSheet("mySheet3", "", "100%");
		</script>
	</div>
	<!--IBSheetBuyer 끝 -->
	<div class="PagingCenter mt10" id="pageindex3"></div>
	<div class="h50"></div>
	<form id="contentForm" name="contentForm">
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
		<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
		<input type="hidden" name="onepagerow" id="onepagerow_3" value="<%=request.getParameter("rowCnt")%>">
	    <input type="hidden" name="st_close_remark" id="st_close_remark"      value="">
	    <input type="hidden" name="st_recv_flag" id="st_recv_flag"      value="">
		<div id="content">
		</div>
	</form>
	<!-- 애경 단가합의 결재정보 -->
	<form name="aekyApprForm" id="aekyApprForm" method="post">	
		<input type="hidden" name="ak_docu_no" id="ak_docu_no" value="" />	
	</form>
</div>
<!--tab3끝 -->
