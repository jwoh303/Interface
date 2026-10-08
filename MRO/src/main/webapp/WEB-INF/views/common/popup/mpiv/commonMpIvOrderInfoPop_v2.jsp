<%--
**********************************************
* 메뉴 : 납품진행현황 > 발주정보조회 팝업
* 화면 : 발주정보 조회
* 기능 : 발주상세정보를 확인할 수 있는 팝업(협력사에서)
* 프로그램 ID : SU0501003
* 담당자 : 최찬규
* 착수일 : 2025-09-17
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
	@SuppressWarnings (value="unchecked")

	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id      = _sessionInfo.getUserId();
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String p_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String p_status = CommonUtil.nvl((String) request.getParameter("st_status"),"");  //  (조회조건)
	
	
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("detailInfo"); // 조회결과 - 상세정보
	Map<String,String> orderRecvHeader = (Map<String,String>) request.getAttribute("orderRecvHeader"); // 조회결과 - 발주서인쇄 정보 조회
	Map<String,String> specialLogicInfo = (Map<String,String>) request.getAttribute("specialLogicInfo"); // 조회결과 - 특수로직 정보 조회
	
	int page_display_cnt = 0;
	
	// 발주서인쇄, 납부지시서 이벤트 시 사용
	String buyer_tr = "";
	String seller = "";
	String ref_if_no = "";
	String add_user_id = "";
	String agent_code = "";
	
	if(orderRecvHeader != null){
		
		buyer_tr = CommonUtil.nvl(orderRecvHeader.get("BUYER2"));
		seller = CommonUtil.nvl(orderRecvHeader.get("SELLER"));
		ref_if_no = CommonUtil.nvl(orderRecvHeader.get("REF_IF_NO"));
		add_user_id = CommonUtil.nvl(orderRecvHeader.get("ADD_USER_ID"));
		agent_code = CommonUtil.nvl(orderRecvHeader.get("AGENT"));
		
		//buyer_tr = "KRDAEW0016";
	}
	
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

//최초 화면 함수 
function kep_onload_view(){
	//RD_DATE=고객수령희망일, ST_DATE=표준납품일
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_PRICE",			Header:"단가",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"AGENT_ITEM_AMT",		Header:"합계",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",		Header:"파일첨부",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,ClassName :'Type02'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"파일첨부",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:true,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.contentForm, mySheet, "/mpiv/getCommonMpIvOrderInfoPop_v2.do" , pagingMode);
}
</script>
<script type="text/javascript"> 
 var popupSel = "";
 
// 팝업호출
var gridIndex = 0;

function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		case "attach"://파일 첨부
			popupSel = "fileUpload";

			var type="PO";
			var imageKey =  value1;
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+imageKey+"&TYPE="+type+"&viewType="+viewType, "500,430,no");
			break;
	}
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	$("#itemCnt").html("("+mySheet.RowCount()+")");
	$("#buyerItemCnt").text(mySheet.RowCount());
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		var but1text = "확인";
		var but1func = "javascript:closePopText2(); return false;";
		var but1width = "120px";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
	var st_image_key_yn = mySheet.GetCellValue(Row, "IMAGE_KEY_YN");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	var st_buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");

	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=Y";
		openLayerPop2(src,"650px","600px");
		
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	if(column == "IMAGE_KEY_YN"){
		if(st_image_key_yn == ""){
			return;
		}
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	
	return;
}

// 발주서 인쇄
function btnSheet() {
	var po_no        = "<%=p_po_no%>";
	var buyer       = "<%=p_buyer%>";
	var seller      = "<%=CommonUtil.nvl(specialLogicInfo.get("SELLER"))%>";

	<%
		String Agent_rptUrl = CommonUtil.nvl(specialLogicInfo.get("AGENT_RPT_URL"));
		
		if(Agent_rptUrl.equals("")){
			Agent_rptUrl = "RD_06_S_002_06";
		}
	%>
	
	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=Agent_rptUrl%>";
	
	reportOpen(fileName,param);
	
	return;	
	
}

function SheetWin_daewoo_3(){  //신규 납품지시서
	 var agent_code  = "<%--=String.valueOf(vt.elementAt(4)) --%>";
	 window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}

</script> 

<body onload="kep_onload_view();">
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="st_buyer" id="st_buyer" value= "<%=p_buyer %>" />
<input type="hidden" name="st_po_no" id="st_po_no" value= "<%=p_po_no %>" />
<input type="hidden" name="st_status" id="st_status" value= "<%=p_status %>" />
	<div class="wrapPopup">
	<%
        		
        		String doc_type = "";
        		String pre_gr_flag = "";
        		String buyer_name = "";
        		String buyer2 = "";
        		String purchaser_name = "";
        		String po_create_date = "";
        		
        		String tel_no = "";
        		String agent_po_ttl_amt = "";
        		
        		String dely_to_location = "";
        		String po_remark = "";
        		
				String center_tel_no = ""; 
				String process_type =  "";
				String delivery_remark = "";
				
				if(detailInfo != null){
					
					doc_type = CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
					pre_gr_flag = CommonUtil.nvl(detailInfo.get("KEPMRO_PRE_GR_FLAG"));
					buyer_name = CommonUtil.nvl(detailInfo.get("BUYER_NAME"));
	        		buyer2 = CommonUtil.nvl(detailInfo.get("BUYER2"));
	        		purchaser_name = CommonUtil.nvl(detailInfo.get("PURCHASER_NAME"));
	        		po_create_date = CommonUtil.formatStrinigDate(CommonUtil.nvl(detailInfo.get("PO_CREATE_DATE")));
	        		
	        		tel_no = CommonUtil.nvl(detailInfo.get("TEL_NO"));
	        		agent_po_ttl_amt = CommonUtil.formatNumber(CommonUtil.nvl(detailInfo.get("AGENT_PO_TTL_AMT")),true,0,3);
	        		
	        		dely_to_location = CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
	        		
	        		process_type = CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
	        		center_tel_no = CommonUtil.nvl(detailInfo.get("CENTER_TEL_NO"));
	        		delivery_remark = CommonUtil.nvl(detailInfo.get("DELIVERY_REMARK"));
	        		
	        		if("KRDAEH0123".equals(p_buyer) || "KRDAEH0133".equals(p_buyer) || "KRDAEH0134".equals(p_buyer)){
						po_remark = "";
					}else{
						po_remark = CommonUtil.nvl(detailInfo.get("PO_REMARK"));
					}
	        		
				}
			%>
  <div class="PopupTit">발주정보 조회<p class="ChipsLarge_Blue" style="display:inline-block; margin-left:10px"><%=p_status %></p><span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub" style="position:relative;width:1200px;">발주정보
  <%
	if(doc_type.equals("S")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 선입고 발주건입니다.</span>
  <%
	} else if(doc_type.equals("F")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 긴급 발주건입니다.</span>
  <%
	}
  %>
  </div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
  	<tr>
      <th>발주번호</th>
      <td><%=p_po_no%></td>
      <th>발주일</th>
      <td><%=po_create_date%></td>
      <th>고객사</th>
      <td><%=buyer_name%></td>
    </tr>
    <tr>
      <th>발주자</th>
      <td><%=purchaser_name%></td>      
      <th>품목수량</th>
      <td align="right" id="buyerItemCnt"></td>
      <th>발주금액</th>
      <td align="right"><%=agent_po_ttl_amt%></td>
    </tr>
    <tr>
      <th>비고</th>
      <td colspan="5"><%=po_remark%></td>
    </tr>
  </table>  
  <div class="PopupTitSub">발주/송장정보</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
<!--   	<tr> -->
<!--       <th>인수자명</th> -->
<!--       <td>김구매</td> -->
<!--       <th>연락처</th> -->
<!--       <td>02-5869-5823</td> -->
<!--       <th></th> -->
<!--       <td></td> -->
<!--     </tr> -->
    <tr>
      <th>배송지</th>
      <td colspan="5"><%=dely_to_location%> <%if(process_type.equals("2")){%>
      &nbsp;/ 수령자: 센터장&nbsp;/ 연락처 : <%=center_tel_no%>
	  <br/> 
	  <font color="F6495F"><b>&nbsp;택배 발송 시 상단의 센터 정보로 입력하여 발송바랍니다.</b></font>
	  <%} %></td>
    </tr>
    <tr>      
      <th>배송 특이사항</th>
      <td colspan="5"><%=delivery_remark %></td>
    </tr>
  </table>  
  <div class="PopupTitSub">주문품목<p  style="display:inline-block; margin-left:5px" id="itemCnt"></p></div>  
  <div class="IBSheetTablePopup" width="1200px">
    <script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>       
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
    <button class="ButQuaternary_large" onclick="javascript:btnSheet(); return false;">발주서 출력</button>
  </div>  
</div><!-- warp 끝-->        
</form>
</body>
</html>
