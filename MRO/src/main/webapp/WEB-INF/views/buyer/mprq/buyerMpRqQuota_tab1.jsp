<%--
**********************************************
* 메뉴 : 상품견적현황
* 화면 : 전체
* 기능 : 
* 프로그램 ID : BU0301001
* 담당자 : 이민아
* 착수일 : 2026-01-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
	@SuppressWarnings(value = "unchecked")
	List<Map<String, String>> _gridList = (List<Map<String, String>>) request.getAttribute("data"); // 조회된결과
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String b_com_code = _sessionInfo.getComCode();
	String b_user_type = _sessionInfo.getUserType();
	String b_user_auth = _sessionInfo.getUserAuth();

	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), ""); // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), ""); // 견적일(To)
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"), ""); // 품명선택
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"), ""); // 
	String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), ""); //
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"), ""); // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"), ""); // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"), ""); // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"), ""); // 견적번호
	String st_btoa_user_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_name"), ""); // 견적번호
	//	 	String st_all_re = CommonUtil.nvl((String) request.getParameter("st_all_re"),"N");  // 기간무시 체크
	//	 	String st_sourcing_sort = CommonUtil.nvl((String) request.getParameter("st_sourcing_sort"),"");  // 정렬기능

	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String) request.getAttribute("gubun_msg"), ""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String) request.getAttribute("item_cnt_no_msg"), ""); // 등록후 결과
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String st_user_group = CommonUtil.nvl((String) request.getParameter("st_user_group"),_sessionInfo.getUserGroup());
	String st_user_id = _sessionInfo.getUserId();

	//SLOGIC-BEGIN(P04-4026-04)
	String reportid = "RD_04_B_006_05";
	String reporttype = "E";
// 	if (_gridList != null) {
// 		if (_gridList.size() > 0) {
			Map<String, String> p04402604 = CommonUtil.getSpecialCheckReturnMap(com_code, "P04-4026-04"); // com_code , 특수로직아이디
			if (p04402604 != null) {
				reporttype = CommonUtil.nvl(p04402604.get("COL01_DATA"), reporttype); // 레포트type
				reportid = CommonUtil.nvl(p04402604.get("COL02_DATA"), reportid); // 레포트아이디
			}
// 		}
// 	}
	//SLOGIC-END

	//SLOGIC-BEGIN(P06-0000036) P04-4026-08 : 장바구니 url 변경
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(com_code, "P06-0000036", "COL02_DATA", request); // 권한별URL
	if (p060000036 == null) {
		p060000036 = defaultUrl;
	} else if ("".equals(p060000036)) {
		p060000036 = defaultUrl;
	}

	//고객사 그룹통합여부 여부
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
	String group_mng_flag = "N";
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer"), ""); // 계열사정보
	if (getCodeTGCM == true) {
		group_mng_flag = "Y";
	}

	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(com_code, "P17-0000001");
	//상세 엑셀다운로드 기능 통제
	boolean p170000002 = CommonUtil.getSpecialCheckReturn(com_code, "P17-0000002");

	// MSDS 표기 여부
	String msds_view_flag = "N";
	boolean p060000123 = CommonUtil.getSpecialCheckReturn(com_code, "P06-0000123");
	if (p060000123 == true) {
		msds_view_flag = "Y";
	}

	//견적서 상세 추가 출력 (셰플러용)
	boolean bqt00001 = CommonUtil.getSpecialCheckReturn(com_code, "BQT00001");

	/*견적 단가 눌렀을 때 나오는 팝업의 크기 조정용 */
	//견적상세 팝업
    boolean p04402705 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-05");
  	//네고이력 팝업
    boolean p04402706 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-06");
  	/**********************************/
  	
	//SLOGIC-END
	
	String selStatus = CommonUtil.nvl((String) request.getParameter("selStatus"), ""); // selStatus
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();
var mySheet4 = new ibsheetObject();
var tFlag = "N";
var btoa_user_chk = "Y";
var popupSel = "";

window.tabs = window.tabs || {};
tabs.buyerMpRqQuota_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	init:function(){
		
		var initsheet = {};
		initsheet.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight: 50, DataRowHeight: 30, Alternate : 0, UseNoDataRow:1, FrozenCol:2};
		initsheet.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태",	SaveName: "sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",		SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE126")%>",		SaveName:"QUOTATION_NO", Cursor:"Pointer", FontColor:"#3a72c7"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE136")%>",		SaveName:"SOURCING_TEXT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SOURCING_STATUS",		SaveName:"SOURCING_STATUS"}
		<%if (group_mng_flag.equals("Y")) {%>
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE290")%>",	SaveName:"BUYER"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",		SaveName:"BUYER_NAME"}
		<%} else {%>
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE290")%>",	SaveName:"BUYER"}
		<%}%>
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
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",		SaveName:"IMAGE_KEY"}						
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적요청일",	SaveName:"BTOA_DATE"} // 기존 견적의뢰일
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적제출일",	SaveName:""}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",		SaveName:"ORIGIN_NAME"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"MSDS",		SaveName:"MSDS_IMAGE" , Cursor:"Pointer", FontColor:"#3a72c7"}
    	   ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"안전인증서상태",		SaveName:"SAFETY_FLAG_TEXT"}
        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선입고",		SaveName:"PRE_GR_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"장바구니",		SaveName:"CART_YN"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"주문",		SaveName:"ORDER_YN"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",		SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",		SaveName:"AGENT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",		SaveName:"BTOA_USER_DEPT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",		SaveName:"BTOA_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"합의자",		SaveName:"CONFIRM_USER_NM"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 비고",		SaveName:"BTOA_REMARK"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"KeP 비고",		SaveName:"ATOB_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"담당자(총괄)",		SaveName:"MIS_BUYER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"담당자(견적)",		SaveName:"KEP_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS_NO",		SaveName:"MSDS_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차수",		SaveName:"REVISION"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BID_SUCCESS_QUOTATION_SEQ",		SaveName:"BID_SUCCESS_QUOTATION_SEQ"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"AGENT_OPEN_FLAG",		SaveName:"AGENT_OPEN_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"PRODUCT_CLOSE_FLAG",		SaveName:"PRODUCT_CLOSE_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BTOA_USER_ID",		SaveName:"BTOA_USER_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE",		SaveName:"BYCA_COMORG_CODE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"ATOB_SEND_FLAG",		SaveName:"ATOB_SEND_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BUYER_MSDS_YN",		SaveName:"BUYER_MSDS_YN"}
		];

		IBS_InitSheet(mySheet1, initsheet, this.pagingMode);
		IBS_InitSheet(mySheet4, initsheet, this.pagingMode);
		
		mySheet1.SetHighlightAfterSort(2);
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
		var selStatus = "<%=selStatus%>";
		$("#st_sourcing_status").val(selStatus);

	},
	
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		//조회그룹으로 추가.
		var st_com_code = $("#st_buyer_1").val();
		if(st_com_code.indexOf("GROUP") >=0){
			document.forms.searchCondition1.st_group_info.value = st_com_code; 
			$("#st_group_info_1").val(st_com_code);
		}else{
			document.forms.searchCondition1.st_group_info.value = "";
			$("#st_group_info_1").val();
		}
		this.current_page = 1;
		$("#st_excel_yn_1").val("N");
		kepSearch_v2(document.searchCondition1, mySheet1, "/mprq/getBuyerMpRqQuotaProceState_v2.do?page="+this.current_page , this.pagingMode);
	},
	search2:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		//조회그룹으로 추가.
		var st_com_code = $("#st_buyer_1").val();
		if(st_com_code.indexOf("GROUP") >=0){
			document.forms.searchCondition1.st_group_info.value = st_com_code; 
			$("#st_group_info_1").val(st_com_code);
		}else{
			document.forms.searchCondition1.st_group_info.value = "";
			$("#st_group_info_1").val();
		}
		$("#st_excel_yn_1").val("Y");
		kepSearch_v2(document.searchCondition1, mySheet4, "/mprq/getBuyerMpRqQuotaProceState_v2.do" , this.pagingMode);
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mprq/getBuyerMpRqQuotaProceState_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		kepMonth_v2('st_from_date_1','st_to_date_1','1');
		mySheet1.RemoveAll();
	},
	doPop:function(str,value1,value2,value3,value4,value5){
		switch (str) {
		case "getMsdsView":
			if(value1 == ""){
				return;
			}
			openSearchPopup('/coco/showCommonCoCoMsdsDetailPop_v2.do','?st_msds_no='+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,700,no');
			break;
		case "kepQuotDetailInfo": //견적상세 팝업 -> 견적번호 눌렀을떄 나오는 팝업
			popupSel ='kepQuotDetailInfo';
			var userAuth = "<%=b_user_auth%>";
			if(userAuth == "ROLE_BSAMYANG_ALL_GE"){ //삼양사 단가합의 권한
				var src = "/common/getBuyerQuotDetailInfoPopSYS_v2.do";
			}else{
				var src = "/common/getBuyerQuotDetailInfoPop_v2.do";
			}
			var parm = "?st_page=1&st_buyer="+value1+"&st_quotation_no="+value2+
			"&st_quotation_seq="+value3+"&st_revision="+value4+"&st_agent="+value5+"&type=1&reportId=<%=reportid%>&reportType=<%=reporttype%>";
			openSearchPopup( src, parm, "940,930,no");
// 			openLayerPop(src,"750px","580px");
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
			<%if(p04402706){%>
				size+=300;
			<%}if(p04402705){%>
				size+=200;
			<%}%>
			
			openSearchPopup("/common/getQuotDetailInfoPop_v2.do", "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4, "540,"+size+",yes");
			break;
		default:
			break;
		}
	},
	setPopupReturn:function (value1){
		if(popupSel == "kepQuotDetailInfo"){
			if(isEmpty(value1)){return;}
			if(value1 == "cartCheck"){
				tabs.buyerMpRqQuota_tab1.search();
			}
		}
	},
	excelDownload:function(){
		if(mySheet4.RowCount() == 0){
//	 		alert("조회된 데이터가 없습니다.");
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
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
		downCol = downCol+"|MIS_BUYER_NAME|KEP_USER_NAME";
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "견적관리_전체_";
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet4.Down2Excel(param);
	},
	quotation_print:function(buyer, quotation_no, quotation_seq, revision, agent, open_flag) { // 기존 품목코드 클릭 시 연결되는 출력물 출력 함수
			
		if(isEmpty(agent)) {
			var text = "<%=CommonLang.msg("MSG111")%>";		//견적서가 발행되지 않은 품목입니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
		}

		open_flag = "N";   // 협력사는 무조건 안보이게 되어있음
		var type = "<%=reporttype%>";
		var fileName = "<%=reportid%>";
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+open_flag+"]";
		if (type == "A"){
			param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+open_flag+"]";
		}
	  	reportOpen(fileName,param);
	  	
	  	param = encodeURI(param);
	  	
		if(<%=bqt00001%> == true){//셰플러코리아만 견적서 상세 출력.
			var url = "/coco/showReportViewer.do";
			window.open(url + "" + "?fileName=RD_04_M_004_11&param="+param, "","width=770,height=800,resizable=YES");	
		}
		
		return;
	},
	rqdtList:function(){ //견적서 출력
	    var selectedGrid = mySheet1.FindCheckedRow("SELECTED");
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
        
		var li_agent = mySheet1.GetCellValue(arrRow[0],"AGENT");
        
		if(isEmpty(li_agent)) {
			var text = "<%=CommonLang.msg("MSG111")%>";	// 견적서가 발행되지 않은 품목입니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
		
        var st_buyer = mySheet1.GetCellValue(arrRow[0],"BUYER");
		var li_quotation_no     = mySheet1.GetCellValue(arrRow[0],"QUOTATION_NO");
        var li_quotation_seq    = mySheet1.GetCellValue(arrRow[0],"QUOTATION_SEQ");
        var li_revision         = mySheet1.GetCellValue(arrRow[0],"REVISION");
        var li_open_flag        = mySheet1.GetCellValue(arrRow[0],"AGENT_OPEN_FLAG");
		
        tabs.buyerMpRqQuota_tab1.quotation_print(st_buyer,li_quotation_no,li_quotation_seq,li_revision,li_agent,li_open_flag);
        
	},
	saveBuyerMpRqQuotaReqList_v2:function(){
		closePopText1();
		kepAjaxFormCallTab("/mprq/saveBuyerMpRqQuotaProceState_v2.do","searchCondition1","cartCheck","buyerMpRqQuota_tab1"); 	
	},
	cartCheck: function() { // 장바구니 담기
// 		var result = tabs.buyerMpRqQuota_tab1.getCheckedStatusConfirm();
	
		var tmpQuery = "";
	    
	    var selectedGrid = mySheet1.FindCheckedRow("SELECTED");
	    var arrRow  = selectedGrid.split("|");
	    
	    if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
	        openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	        return;
	    }
	    
	    for(var i = 0 ; i < arrRow.length; i++){
	    	var curIdx = arrRow[i];
	    	if(document.forms.searchCondition1.st_user_id.value != mySheet1.GetCellValue(curIdx, "BTOA_USER_ID")){
	    		var text = "<%=CommonLang.msg("MSG103")%>";//본인 요청건만 장바구니담기가 가능합니다.
	    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		        return;
	    	}
	    	if(mySheet1.GetCellValue(curIdx, "SOURCING_STATUS") != 'RQ04'){ // 장바구니, 합의완료 (COD1.C023)
				var text = "<%=CommonLang.msg("MSG780")%>"; //견적완료된 품목만 장바구니에 담을수 있습니다.
				openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		        return;
           	}
	    	if (mySheet1.GetCellValue(curIdx,"PRODUCT_CLOSE_FLAG") == "T"){
	    		var text = "<%=CommonLang.msg("MSG102")%>"; //인터페이스 품목입니다.
	    		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
		        return;
			}	        	   
	    	tmpQuery += mySheet1.GetCellValue(curIdx, "QUOTATION_NO")+"@@"+mySheet1.GetCellValue(curIdx, "QUOTATION_SEQ")+"@@"+mySheet1.GetCellValue(curIdx, "REVISION")
	    	+"@@"+mySheet1.GetCellValue(curIdx, "BUYER")+"@@"+mySheet1.GetCellValue(curIdx, "BUYER_ITEM_NO")
	    	+"@@"+mySheet1.GetCellValue(curIdx, "CONTRACT_NO")+"@@"+mySheet1.GetCellValue(curIdx, "CONTRACT_SEQ")
	    	+"@@"+mySheet1.GetCellValue(curIdx, "AGENT")+"@@"+mySheet1.GetCellValue(curIdx, "BYCA_COMORG_CODE")+"@@"+mySheet1.GetCellValue(curIdx, "ITEM_QTY")+"&&";
		}
	    
	    $("#st_query").val(tmpQuery);
	    
		var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpRqQuota_tab1.saveBuyerMpRqQuotaReqList_v2(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	},
	cartBack:function(){
		closePopText1();
		$('#locationForm').attr("action", "<%=p060000036%>").submit();
	},
	kepAjaxSuccess:function(pMethod , response){
		if (pMethod == 'cartCheck'){
			var text = response.msg +"<br>"+ "<%=CommonLang.msg("MSG364")%>";	//장바구니로 이동하시겠습니까?
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:tabs.buyerMpRqQuota_tab1.cartBack(); return false;";
			var but2funcC = "javascript:closePopText1();";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	},
	kepAjaxError:function(pMethod , response) {
		var text =  "<%=CommonLang.msg("MSG418")%>"; // 오류발생하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
		openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpRqQuota_tab1.but1text,tabs.buyerMpRqQuota_tab1.but1func,tabs.buyerMpRqQuota_tab1.but1width);
	}
	
	for(var i = 1; i<=mySheet1.RowCount(); i++){
		if(mySheet1.GetCellValue(i,"ATOB_SEND_FLAG") == "N"){
			mySheet1.SetCellValue(i,"ATOB_UNIT_PRICE","");
		}
	}
	
	makePageIndex_v3( mySheet1 , tabs.buyerMpRqQuota_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerMpRqQuota_tab","1");
}
function mySheet4_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpRqQuota_tab1.but1text,tabs.buyerMpRqQuota_tab1.but1func,tabs.buyerMpRqQuota_tab1.but1width);
	}
	
	tabs.buyerMpRqQuota_tab1.excelDownload();
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet1.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		var st_image_key = mySheet1.GetCellValue(Row, "IMAGE_KEY");
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}else if(column =="QUOTATION_NO"){
		mySheet1.CheckAll(1, 0);// 전체체크해제
		mySheet1.SetCellValue(Row, 1, 1); // 팝업 눌렀던 행 선택되도룩
		tabs.buyerMpRqQuota_tab1.doPop('kepQuotDetailInfo', mySheet1.GetCellValue(Row, "BUYER"), mySheet1.GetCellValue(Row, "QUOTATION_NO"), mySheet1.GetCellValue(Row, "QUOTATION_SEQ"), mySheet1.GetCellValue(Row, "REVISION"), mySheet1.GetCellValue(Row,"AGENT"));
	}
// 	else if(column =="BUYER_ITEM_NO"){
// 		tabs.buyerMpRqQuota_tab1.quotation_print(mySheet1.GetCellValue(Row, "BUYER"), mySheet1.GetCellValue(Row, "QUOTATION_NO"), mySheet1.GetCellValue(Row, "QUOTATION_SEQ"), mySheet1.GetCellValue(Row, "REVISION"), mySheet1.GetCellValue(Row, "AGENT"), mySheet1.GetCellValue(Row, "BUYER_ITEM_NO"), mySheet1.GetCellValue(Row, "AGENT_OPEN_FLAG"));
// 	}
	else if(column =="ATOB_UNIT_PRICE"){
		tabs.buyerMpRqQuota_tab1.doPop('kepQuotPriceInfo', mySheet1.GetCellValue(Row, "BUYER"), mySheet1.GetCellValue(Row, "QUOTATION_NO"), mySheet1.GetCellValue(Row, "QUOTATION_SEQ"), mySheet1.GetCellValue(Row, "REVISION"), mySheet1.GetCellValue(Row, "AGENT"));
	}else if(column =="MSDS_IMAGE"){ 
		if(mySheet1.GetCellValue(Row, "MSDS_NO") != ""){
			tabs.buyerMpRqQuota_tab1.doPop('getMsdsView',mySheet1.GetCellValue(Row, "MSDS_NO"), mySheet1.GetCellValue(Row, "BUYER"), mySheet1.GetCellValue(Row, "QUOTATION_NO"), mySheet1.GetCellValue(Row, "QUOTATION_SEQ"), mySheet1.GetCellValue(Row, "REVISION"));
		}
	}
	
	return;
}
</script>
<div id="Search1" class="SearchContent">
	<div class="Importance">
		<img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.get("HTITLE1206")%><!-- 모든 진행 상태의 상품견적을 확인할 수 있으며, 견적번호를 클릭하면 상세 정보를 볼 수 있습니다. -->
	</div>
	<form name="searchCondition1" id="searchCondition1" method="post">
		<!--HIDDEN-->
		<input type="hidden" name="s_SAVENAME" /> <input type="hidden" name="st_check" id="st_check" value=""> 
		<input type="hidden" name="st_all_re" id="st_all_re" value="N"> 
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>"> 
		<input type="hidden" name="st_group_info" id="st_group_info_1" value=""> 
		<input type="hidden" name="st_user_group" id="st_user_group"value="<%=st_user_group%>" />
		<input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_1" name="pageflag" value="1" />
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_query" id="st_query" value="" />
		<input type="hidden" name="st_excel_yn" id="st_excel_yn_1" value="N" />
		<%-- 		<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">					 --%>
		<table class="TabSearchTable">
			<colgroup>
				<col width="125px" />
				<col width="450px" />
				<col width="80px" />
				<col width="300px" />
				<col width="75px" />
				<col width="250px" />
			</colgroup>
			<tr>
				<th><label for="b_code" class="hidden"><%=CommonLang.get("HTITLE151")%><!-- 견적일 --></label>
					<select name="st_date_type" id="st_date_type" class="Select" style="font:10px;width:95%">
						<option value="BTOA" <%if ("A".equals(st_date_type)) {%> selected <%}%>><%=CommonLang.get("HTITLE1207")%><!-- 견적요청일 --></option>
						<option value="ATOB" <%if ("B".equals(st_date_type)) {%> selected <%}%>><%=CommonLang.get("HTITLE132")%><!-- 견적제출일 --></option>
					</select>
				</th>
				<td>
					<div class="Buyer-datepicker-wrap"
						style="width: 231px; margin-right: 8px">
						<div class="Buyer-date-input" data-datepicker>
							<input style="" type="text" placeholder="" name="st_from_date" id="st_from_date_1" readonly /><span></span>
						</div>
						<span class="Buyer-dash">~</span>
						<div class="Buyer-date-input" data-datepicker>
							<input style="" type="text" placeholder="" name="st_to_date" id="st_to_date_1" readonly /><span></span>
						</div>
					</div>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
					<button class="But_Month" style="width: 50px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','6'); return false;">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
<!-- 					<button class="But_Month" style="width: 50px" -->
<!-- 						onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;"> -->
<%-- 						1<%=CommonLang.get("HTITLE424")%><!-- 년 --> --%>
<!-- 					</button> -->
				</td>
				<th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
				<td><label for="b_delivery" class="hidden"><%=CommonLang.get("HTITLE136")%></label> 
					<select name="st_sourcing_status" id="st_sourcing_status" class="Select40" style="width:83%">
						<%=CommonUtil.getCodeComboList("C023", "ALL", st_sourcing_status)%>
				</select></td>
				<th>견적번호</th>
				<td><input class="input40" type="text" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>"	onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab1')">
				</td>
			</tr>
			<tr>
				<th><%=CommonLang.get("HTITLE552")%><!-- 검색어 --></th>
				<td><label for="b_code" class="hidden"><%=CommonLang.get("HTITLE552")%><!-- 검색어 --></label>
					<select name="st_search_type" id="st_search_type" class="Select40">
						<option value="DE" <%if ("DE".equals(st_search_type)) {%> selected <%}%>><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
						<option value="SP" <%if ("SP".equals(st_search_type)) {%> selected <%}%>><%=CommonLang.get("HTITLE14")%><!-- 규격 --></option>
						<option value="BC" <%if ("BC".equals(st_search_type)) {%> selected <%}%>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
					</select>
					<input type="text" name="st_search_code" id="st_search_code" class="input40" style="width:62%" value="<%=st_search_code%>" onkeydown="kepEnter_v3('buyerMpRqQuota_tab1')" />
				</td>
				<th><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				<td><input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" class="input40" value="<%=st_btoa_user_dept_name%>" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab1')"/></td>
				<th><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
				<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" class="input40" value="<%=st_btoa_user_name%>" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab1')"></td>
			</tr>
			<%
				if (group_mng_flag.equals("Y")) {
			%>
			<tr>
				<th><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
				<td><select name="st_buyer" id="st_buyer_1" class="Select40" style="width:90%">
					<%=CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "")%>
				</select></td>
			</tr>
			<%
				} else {
			%>
			<input type="hidden" name="st_buyer" id="st_buyer_1" value="${sessionInfo.comCode}">
			<%
				}
			%>
		</table>
	</form>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium"
			onclick="javascript:tabs.buyerMpRqQuota_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8")%><!-- 초기화 -->
		</button>
		<button class="ButDarkGray_Medium"
			onclick="javascript:tabs.buyerMpRqQuota_tab1.search(); return false;"><%=CommonLang.get("HTITLE7")%><!-- 조회 -->
		</button>
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
			<%
				if (p170000001 == false) { //엑셀다운로드 기능 통제
			%>
			<button class="But_ExcelDown40" onclick="javascript:tabs.buyerMpRqQuota_tab1.search2(); return false;"><%=CommonLang.get("HTITLE150")%><!--엑셀 다운로드-->
			</button>
			<%
				}
			%>
			<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab1.rqdtList(); return false;"><%=CommonLang.get("HTITLE128")%><!--견적서 출력-->
			</button>
		</div>
		<div class="buttonRight">
			<button class="ButMPrimary" onclick="javascript:tabs.buyerMpRqQuota_tab1.cartCheck(); return false;"><%=CommonLang.get("HTITLE11")%><!-- 장바구니 -->
			</button>
		</div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">
			createIBSheet("mySheet1", "", "100%");
		</script>
	</div>
	<div class="IBSheetBuyer" style="display: none;">
		<script type="text/javascript">
			createIBSheet("mySheet4", "", "100%");
		</script>
	</div>
	<!--IBSheetBuyer 끝 -->
	<div class="PagingCenter mt10" id="pageindex1"></div>
	<div class="h50"></div>
	<form name="locationForm" id="locationForm" method="post">
		<%-- 장바구니 이동용 --%>
		<input type="hidden" id="upperId" name="upperId"
			value="${param.upperId}" /> <input type="hidden" name="st_com_code"
			id="st_com_code" value="${sessionInfo.comCode}"> <input
			type="hidden" name="st_user_id" id="st_user_id"
			value="${sessionInfo.userId}">
	</form>
</div>
<!--Tab1끝 -->
