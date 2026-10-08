<%--
**********************************************
* 메뉴 : 상품견적현황
* 화면 : 견적요청
* 기능 : 
* 프로그램 ID : BU0301001
* 담당자 : 이민아
* 착수일 : 2026-01-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
		@SuppressWarnings (value="unchecked")
		List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String b_com_code =  _sessionInfo.getComCode();
		String b_user_type =  _sessionInfo.getUserType();
		String b_user_auth = _sessionInfo.getUserAuth();
		
		// 조회조건 S
		String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
		String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
		String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 품명선택
		String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
		String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
		String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
		String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
		String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
		String st_btoa_user_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_name"),"");  // 견적번호
//	 	String st_all_re = CommonUtil.nvl((String) request.getParameter("st_all_re"),"N");  // 기간무시 체크
//	 	String st_sourcing_sort = CommonUtil.nvl((String) request.getParameter("st_sourcing_sort"),"");  // 정렬기능
		
		// 조회조건 E
		String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
		String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
		String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode()); 
		String st_user_group=  CommonUtil.nvl((String) request.getParameter("st_user_group"), _sessionInfo.getUserGroup()); 
		String st_user_id = _sessionInfo.getUserId();
		
		//SLOGIC-BEGIN(P04-4026-04)
		String reportid = "RD_04_B_006_05"; 
		String reporttype = "E"; 
		if (_gridList!= null ){
			if (_gridList.size() > 0){
				Map<String, String> p04402604 = CommonUtil.getSpecialCheckReturnMap(com_code,"P04-4026-04");   // com_code , 특수로직아이디
				if (p04402604 != null){
					reporttype = CommonUtil.nvl(p04402604.get("COL01_DATA"),reporttype); // 레포트type
					reportid = CommonUtil.nvl(p04402604.get("COL02_DATA"),reportid); // 레포트아이디
				}
			}
		}
		//SLOGIC-END
		
		//SLOGIC-BEGIN(P06-0000036) P04-4026-08 : 장바구니 url 변경
		 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
		 String p060000036 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000036","COL02_DATA", request); // 권한별URL
		 if (p060000036 == null){
		 	p060000036 = defaultUrl;
		 }else if ("".equals(p060000036)){
		 	p060000036 = defaultUrl;
		 }
		
		//고객사 그룹통합여부 여부
		boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
		String group_mng_flag = "N";
		String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  // 계열사정보
		if(getCodeTGCM == true){
			group_mng_flag = "Y"; 
		}
		
		//엑셀다운로드 기능 통제
		boolean p170000001 = CommonUtil.getSpecialCheckReturn(com_code,"P17-0000001");
		//상세 엑셀다운로드 기능 통제
		boolean p170000002 = CommonUtil.getSpecialCheckReturn(com_code,"P17-0000002");
		
		// MSDS 표기 여부
		String msds_view_flag = "N";
		boolean p060000123 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000123");
		if(p060000123 == true){
			msds_view_flag = "Y";
		}
		
		//견적서 상세 추가 출력 (셰플러용)
		boolean bqt00001 = CommonUtil.getSpecialCheckReturn(com_code,"BQT000001");
		
		/*견적 단가 눌렀을 때 나오는 팝업의 크기 조정용 */
		//견적상세 팝업
	    boolean p04402705 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-05");
	  	//네고이력 팝업
	    boolean p04402706 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-06");
	  	/**********************************/
		//SLOGIC-END
	%>
<script type="text/javascript">
var mySheet2 = new ibsheetObject();
var mySheet5 = new ibsheetObject();
var tFlag = "N";
var btoa_user_chk = "Y";
var tmpParam = "";

window.tabs = window.tabs || {};
tabs.buyerMpRqQuota_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",//확인
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMpRqQuota_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
		
	init:function(){
		
		var initsheet2 = {};
		initsheet2.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight: 50, DataRowHeight: 30, Alternate : 0, UseNoDataRow:1, FrozenCol:2};
		initsheet2.Cols = [
		 { Align:"Center",	Hidden:true,Type:"Text",	Header:"상태",	SaveName: "sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",		SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",		SaveName:"QUOTATION_NO", Cursor:"Pointer", FontColor:"#3a72c7"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",		SaveName:"SOURCING_TEXT"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"진행상태",		SaveName:"SOURCING_STATUS"}
		<%if(group_mng_flag.equals("Y")){%>
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",		SaveName:"BUYER_NAME"}
		<%}else {%>
		,{ Align:"Center",	Width:110,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
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
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"첨부",		SaveName:"IMAGE_KEY"}						
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"견적요청일",	SaveName:"BTOA_DATE"} // 기존 견적의뢰일
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"회신요청일",	SaveName:"BTOA_END_DATE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지",		SaveName:"ORIGIN_NAME"}
		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"MSDS",		SaveName:"MSDS_IMAGE" , Cursor:"Pointer", FontColor:"#3a72c7" }
    	   ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"안전인증서상태",		SaveName:"SAFETY_FLAG_TEXT"}
        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선입고",		SaveName:"PRE_GR_FLAG"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",		SaveName:"AGENT_NAME"}
		,{ Align:"Center",	Width:150,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사",		SaveName:"AGENT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",		SaveName:"BTOA_USER_DEPT"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",		SaveName:"BTOA_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"합의자",		SaveName:"CONFIRM_USER_NM"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"담당자(총괄)",		SaveName:"MIS_BUYER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"담당자(견적)",		SaveName:"KEP_USER_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"MSDS_NO",		SaveName:"MSDS_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"차수",		SaveName:"REVISION"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사 비고",		SaveName:"BTOA_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"KeP 비고",		SaveName:"ATOB_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BID_SUCCESS_QUOTATION_SEQ",		SaveName:"BID_SUCCESS_QUOTATION_SEQ"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"AGENT_OPEN_FLAG",		SaveName:"AGENT_OPEN_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"PRODUCT_CLOSE_FLAG",		SaveName:"PRODUCT_CLOSE_FLAG"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BTOA_USER_ID",		SaveName:"BTOA_USER_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"BYCA_COMORG_CODE",		SaveName:"BYCA_COMORG_CODE"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"CANCEL_REMARK",		SaveName:"CANCEL_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Text",	Header:"RECV_FLAG",		SaveName:"RECV_FLAG"}
		,{ Align:"Center",	Hidden:true,	Type:"Text",	Header:"BUYER_MSDS_YN",		SaveName:"BUYER_MSDS_YN"}
		];

		IBS_InitSheet(mySheet2, initsheet2, this.pagingMode);
		IBS_InitSheet(mySheet5, initsheet2, this.pagingMode);
		
		mySheet2.SetHighlightAfterSort(2);
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");

	},
	
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		//조회그룹으로 추가.
		var st_com_code = $("#st_buyer_2").val();
		console.log("after"+ st_com_code);
		if(st_com_code.indexOf("GROUP") >=0){
			document.forms.searchCondition2.st_group_info.value = st_com_code; 
			$("#st_group_info_2").val(st_com_code);
		}else{
			document.forms.searchCondition2.st_group_info.value = "";
			$("#st_group_info_2").val();
		}
		this.current_page = 1;
		$("#st_excel_yn_2").val("N");
		kepSearch_v2(document.searchCondition2, mySheet2, "/mprq/getBuyerMpRqQuotaProceState2_v2.do?page="+this.current_page , this.pagingMode);
	},
	search2:function(){
		if (kep_dateSearchCheck($("#st_from_date_2").val(),$("#st_to_date_2").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_2','st_to_date_2','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";  //1년 이내 조회만 가능합니다
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		//조회그룹으로 추가.
		var st_com_code = $("#st_buyer_2").val();
		if(st_com_code.indexOf("GROUP") >=0){
			document.forms.searchCondition2.st_group_info.value = st_com_code; 
			$("#st_group_info_2").val(st_com_code);
		}else{
			document.forms.searchCondition2.st_group_info.value = "";
			$("#st_group_info_2").val();
		}
		$("#st_excel_yn_2").val("Y");
		kepSearch_v2(document.searchCondition2, mySheet5, "/mprq/getBuyerMpRqQuotaProceState2_v2.do" , this.pagingMode);
	},
	pageSearch:function(param){
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition2, mySheet2, "/mprq/getBuyerMpRqQuotaProceState2_v2.do?page="+this.current_page, this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		kepMonth_v2('st_from_date_2','st_to_date_2','1');
		mySheet2.RemoveAll();
	},
	doPop:function(str,value1,value2,value3,value4,value5,value6){
		switch (str) {
		case "getMsdsView":
			if(value1 == ""){
				return;
			}
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop_v2.do","?st_msds_no="+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,700,no');
			break;
		case "kepQuotDetailInfo": //견적상세 팝업
			var userAuth = "<%=b_user_auth%>";
			if(userAuth == "ROLE_BSAMYANG_ALL_GE"){ //삼양사 단가합의 권한
				var src = "/common/getBuyerQuotDetailInfoPopSYS_v2.do";
			}else{
				var src = "/common/getBuyerQuotDetailInfoPop_v2.do";
			}
			var parm = "?st_buyer="+value1+"&st_quotation_no="+value2+
			"&st_quotation_seq="+value3+"&st_revision="+value4+"&st_agent="+value5+"&st_idx="+value6+"&type=2&reportId=<%=reportid%>&reportType=<%=reporttype%>";
			openSearchPopup(src, parm,'940,930,no');
// 			openLayerPop(src,"750px","580px");
			break;
		case "kepQuotPriceInfo": //견적단가 상세 팝업
			var src = "/common/getQuotDetailInfoPop_v2.do";
			var parm = "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4+"&st_agent="+value5;
			if(isEmpty(value5)) {
				var text ="<%=CommonLang.msg("MSG111")%>"; //견적서가 발행되지 않은 품목입니다.
				openLayerPopText2(text,but1text,but1func,but1width);
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
	excelDownload:function(){
		if(mySheet5.RowCount() == 0){
//	 		alert("조회된 데이터가 없습니다.");
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		mySheet5.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i = 1; i <= mySheet5.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<= mySheet5.LastCol(); i++){
			if(!mySheet5.GetColHidden(i) && mySheet5.ColSaveName(i) !="SELECTED" && mySheet5.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		downCol = downCol+"|MIS_BUYER_NAME|KEP_USER_NAME";
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "견적관리_견적요청_";
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet5.Down2Excel(param);
	},
	cancelRqdt:function(){ //견적취소
	    var selectedGrid = mySheet2.FindCheckedRow("SELECTED");
	    var arrRow  = selectedGrid.split("|");
	    tmpParam ="";
	    if(isEmpty(selectedGrid)){
	        var text = "<%=CommonLang.msg("MSG100")%>"; //선택된 품목이 없습니다
			openLayerPopText2(text,but1text,but1func,but1width);
	        return;
	    }
	    
	    for(var i = 0 ; i < arrRow.length; i++){
	    	var curIdx = arrRow[i]
	    	var curFlag = mySheet2.GetCellValue(curIdx, "RECV_FLAG");
	    	if(curFlag != "NW"){
	    		if(curFlag == "GD"){
		    		var text = "<%=CommonLang.msg("MSG107")%>";	//이미 견적취소 처리가 되었습니다.
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}else{
					var text = "<%=CommonLang.msg("MSG108")%>"; //견적접수 처리가 되어 견적취소가 불가능합니다.
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
	    		}
	    	}// 0 : idx, 1 : 견적번호 , 2 : 견적항번, 3 : 품목코드 , 4 : 품목명
	    	tmpParam += curIdx+":::"+mySheet2.GetCellValue(curIdx, "QUOTATION_NO")+":::"+mySheet2.GetCellValue(curIdx, "QUOTATION_SEQ")
	    	+":::"+mySheet2.GetCellValue(curIdx, "BUYER_ITEM_NO")+":::"+mySheet2.GetCellValue(curIdx, "DESCRIPTION")+":::"+mySheet2.GetCellValue(curIdx, "BUYER")+"@@";
		}
	    
	    var text = arrRow.length + "건의 상품 견적을 취소하시겠습니까?";	
	    var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:tabs.buyerMpRqQuota_tab2.saveBuyerMprqCancelList_v2(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	},
	saveBuyerMprqCancelList_v2:function(){
		closePopText1();
		popupSel = "cancelRemark";
		openSearchPopup('/common/remarkCancelPop.do','?tab_id=buyerMpRqQuota_tab2'+'&viewType='+popupSel+'&param='+encodeURIComponent(tmpParam),'870,480,no');
	},
// 	quotation_print:function(buyer, quotation_no, quotation_seq, revision, agent, open_flag) { // 기존 품목코드 클릭 시 연결되는 출력물 출력 함수
			
// 		if(isEmpty(agent)) {
<%-- 			var text = "<%=CommonLang.msg("MSG111")%>";		//견적서가 발행되지 않은 품목입니다. --%>
// 			openLayerPopText2(text,but1text,but1func,but1width);
// 	        return;
// 		}

// 		open_flag = "N";   // 협력사는 무조건 안보이게 되어있음
<%-- 		var type = "<%=reporttype%>"; --%>
<%-- 		var fileName = "<%=reportid%>"; --%>
// 		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+open_flag+"]";
// 		if (type == "A"){
// 			param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+open_flag+"]";
// 		}
// 	  	reportOpen(fileName,param);
	  	
// 	  	param = encodeURI(param);
	  	
<%-- 		if(<%=bqt00001%> == true){//셰플러코리아만 견적서 상세 출력. --%>
// 			var url = "/coco/showReportViewer.do";
// 			window.open(url + "" + "?fileName=RD_04_M_004_11&param="+param, "","width=770,height=800,resizable=YES");	
// 		}
		
// 		return;
// 	},
	setPopupReturn:function (value1,value2,value3,value4,value5){
		if(popupSel == "cancelRemark"){
		    if(isEmpty(value1)){return;}
		    
			var value1Row = value1.split(":::");
			var value2Row = value2.split(":::");
			var value3Row = value3.split(":::");
			var value4Row = value4.split(":::");
			var value5Row = value5.split(":::");
			
			for(var i = 0; i < value1Row.length; i++){
				var curIdx = value1Row[i];
				if(mySheet2.GetCellValue(curIdx, "QUOTATION_NO") == value2Row[i] && mySheet2.GetCellValue(curIdx, "QUOTATION_SEQ") == value3Row[i]
				&& mySheet2.GetCellValue(curIdx, "BUYER") == value5Row[i] ) {// 고객사, 견적번호, 견적항번 같은 경우
					mySheet2.SetCellValue(curIdx, "CANCEL_REMARK", value4Row[i]); // 해당 행 취소사유 값에 채워넣기
				}
			}
			kepSave(document.searchCondition2, mySheet2, "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2.do", "SELECTED");
		}else{ // 상세팝업
			if(isEmpty(value1)){return;}
			if(value1 == "cancelRqdt"){
				mySheet2.SetCellValue(value2, "CANCEL_REMARK", value3); // 해당 행 취소사유 값에 채워넣기
				
				kepSave(document.searchCondition2, mySheet2, "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2.do", "SELECTED");
			}
		}
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	}
	
};
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpRqQuota_tab2.but1text,tabs.buyerMpRqQuota_tab2.but1func,tabs.buyerMpRqQuota_tab2.but1width);
		return;
	}
	
	makePageIndex_v3( mySheet2 , tabs.buyerMpRqQuota_tab2.current_page , document.searchCondition2.onepagerow.value,"buyerMpRqQuota_tab","2");
}
function mySheet5_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpRqQuota_tab2.but1text,tabs.buyerMpRqQuota_tab2.but1func,tabs.buyerMpRqQuota_tab2.but1width);
		return;
	}
	
	tabs.buyerMpRqQuota_tab2.excelDownload();
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet2.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		var st_image_key = mySheet2.GetCellValue(Row, "IMAGE_KEY");
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}else if(column =="QUOTATION_NO"){
		mySheet2.CheckAll(1, 0);// 전체체크해제
		mySheet2.SetCellValue(Row, 1, 1); // 팝업 눌렀던 행 선택되도룩
		tabs.buyerMpRqQuota_tab2.doPop('kepQuotDetailInfo', mySheet2.GetCellValue(Row, "BUYER"), mySheet2.GetCellValue(Row, "QUOTATION_NO"), mySheet2.GetCellValue(Row, "QUOTATION_SEQ"), mySheet2.GetCellValue(Row, "REVISION"), mySheet2.GetCellValue(Row, "AGENT"), Row);
	}else if(column =="ATOB_UNIT_PRICE"){
		tabs.buyerMpRqQuota_tab2.doPop('kepQuotPriceInfo', mySheet2.GetCellValue(Row, "BUYER"), mySheet2.GetCellValue(Row, "QUOTATION_NO"), mySheet2.GetCellValue(Row, "QUOTATION_SEQ"), mySheet2.GetCellValue(Row, "REVISION"), mySheet2.GetCellValue(Row, "AGENT"));
	}else if(column =="MSDS_IMAGE"){
		if(mySheet2.GetCellValue(Row, "MSDS_NO") != ""){
			tabs.buyerMpRqQuota_tab2.doPop('getMsdsView',mySheet2.GetCellValue(Row, "MSDS_NO"), mySheet2.GetCellValue(Row, "BUYER"), mySheet2.GetCellValue(Row, "QUOTATION_NO"), mySheet2.GetCellValue(Row, "QUOTATION_SEQ"), mySheet2.GetCellValue(Row, "REVISION"));
		}
	}
	
	return;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(msg != ""){
		if(code == 0){ //재조회
			openLayerPopText2(msg,tabs.buyerMpRqQuota_tab2.but1text,tabs.buyerMpRqQuota_tab2.but1funcSearch,tabs.buyerMpRqQuota_tab2.but1width);
// 			kepSearch(document.searchCondition2, mySheet2, "/mprq/getBuyerMpRqQuotaProceState_v2.do" , this.pagingMode);
		}else{
			openLayerPopText2(msg,tabs.buyerMpRqQuota_tab2.but1text,tabs.buyerMpRqQuota_tab2.but1func,tabs.buyerMpRqQuota_tab2.but1width);
		}
		return;
	}
	
}
</script>
<div id="Search2" class="SearchContent">
	<div class="Importance">
		<img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.get("HTITLE1504")%> <!-- '요청결재중', '견적요청', '견적진행중', 'Nego견적요청', 'Nego진행중' 상태의 상품견적을 확인할 수 있으며, 필요 시 견적취소가 가능합니다. -->
	</div>
	<form name="searchCondition2" id="searchCondition2" method="post">
		<!--HIDDEN-->
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_check" id="st_check" value=""> 
		<input type="hidden" name="st_all_re" id="st_all_re" value ="N">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info_2" value="">
		<input type="hidden" name="st_user_group" id="st_user_group" value="<%=st_user_group %>" />
		<input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_2" name="pageflag" value="1" />
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_query" id="st_query" value =""/>
		<input type="hidden" name="st_excel_yn" id="st_excel_yn_2" value ="N"/>
<%-- 		<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">					 --%>
     	<table class="TabSearchTable" >
			<colgroup>
				<col width="85px" />
				<col width="490px" />
				<col width="80px" />
				<col width="310px" />
				<col width="75px" />
				<col width="250px" />
			</colgroup>           	
	        <tr>
				<th>견적요청일</th>
				<td>
					<div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
						<div class="Buyer-date-input"  data-datepicker><input style=" " type="text" placeholder=""  name="st_from_date" id="st_from_date_2" readonly /><span></span></div>
						<span class="Buyer-dash">~</span>
						<div class="Buyer-date-input" data-datepicker><input  style=" " type="text" placeholder=""  name="st_to_date" id="st_to_date_2" readonly /><span></span></div>
				 	</div>
					<button class="But_Month" style="width:50px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','1'); return false;">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button> 
					<button class="But_Month" style="width:50px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','3'); return false;">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
					<button class="But_Month" style="width:50px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','6'); return false;">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></button>
<%-- 					<button class="But_Month" style="width:50px" onclick="javascript:kepMonth_v2('st_from_date_2','st_to_date_2','12'); return false;">1<%=CommonLang.get("HTITLE424")%><!-- 년 --></button> --%>
				</td>
		        <th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
				<td><label for="b_delivery" class="hidden">진행상태선택</label>
					<select name="st_sourcing_status" id="st_sourcing_status" class="Select40" style="width:80%" > 
						<option value="" <%if ("".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
						<option value="RQ10" <%if ("RQ10".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE1010")%><!-- 견적요청 --></option>
						<option value="RQ07" <%if ("RQ07".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE190")%><!-- 요청결재중 --></option>
						<option value="RQ05" <%if ("RQ05".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE154")%><!-- 견적진행중 --></option>
						<option value="RQ11" <%if ("RQ11".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE1169")%><!-- Nego견적의뢰 --></option>
						<option value="RQ12" <%if ("RQ12".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE157")%><!-- Nego진행중 --></option>
					</select>
				</td>
	          	<th>견적번호</th>
	          	<td>
	          		<input class="input40" type="text" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab2')">
				</td>                    
	        </tr>
			<tr>
				<th><%=CommonLang.get("HTITLE552")%><!-- 검색어 --></th>	
				<td>
					<label for="b_code" class="hidden"><%=CommonLang.get("HTITLE552")%><!-- 검색어 --></label>
					<select name="st_search_type" id="st_search_type" class="Select40">
						<option value="DE" <%if ("DE".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
						<option value="SP" <%if ("SP".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE14")%><!-- 규격 --></option>
						<option value="BC" <%if ("BC".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
					</select>
					<input type="text" name="st_search_code" id="st_search_code"  class ="input40" style="width:57%"  value="<%=st_search_code%>" onkeydown="kepEnter_v3('buyerMpRqQuota_tab2')" />
				</td>
				<th><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				<td>
					<input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name"class="input40" value="<%=st_btoa_user_dept_name%>" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab2')"/> 
				</td>
				<th><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
				<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name"  class ="input40" value="<%=st_btoa_user_name%>" onKeyDown="kepEnter_v3('buyerMpRqQuota_tab2')"></td>
			</tr>  
			<%if(group_mng_flag.equals("Y")){%>
			<tr>
				<th><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
		      	<td>
			        <select name="st_buyer" id="st_buyer_2"class="Select40" style="width:83%" >
			        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
			        </select>
		      	</td>
			</tr>
			<%}else{%>
					<input type="hidden" name="st_buyer" id="st_buyer_2" value="${sessionInfo.comCode}">
			<%}%>
		</table>
	</form>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></button>
		<button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab2.search(); return false;"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></button> 
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
		<%if(p170000001 == false){ //엑셀다운로드 기능 통제%>
			<button class="But_ExcelDown40" onclick="javascript:tabs.buyerMpRqQuota_tab2.search2(); return false;"><%=CommonLang.get("HTITLE150")%><!--엑셀 다운로드--></button>
		<% } %>
<%-- 			<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab2.rqdtList(); return false;"><%=CommonLang.get("HTITLE128")%><!--견적서 출력--></button>  --%>
		</div>
		<div class="buttonRight">
			<button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpRqQuota_tab2.cancelRqdt(); return false;"><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></button>
		</div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">
			createIBSheet("mySheet2", "", "100%");
		</script>
	</div> 
	<div class="IBSheetBuyer" style="display: none;">
		<script type="text/javascript">
			createIBSheet("mySheet5", "", "100%");
		</script>
	</div>
    <!--IBSheetBuyer 끝 --> 
    <div class="PagingCenter mt10" id="pageindex2"></div>
	<div class="h50"></div>     
	<form name="locationForm" id="locationForm" method="post"> <%-- 장바구니 이동용 --%>
		<input type="hidden" id="upperId" name="upperId" value="${param.upperId}"/> 
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	</form>    
</div>
<!--tab2끝 --> 