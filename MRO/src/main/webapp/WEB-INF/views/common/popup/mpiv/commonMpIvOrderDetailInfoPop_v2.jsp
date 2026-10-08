<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 주문상세팝업
* 기능 : 주문상세팝업
* 프로그램 ID : BU0402002
* 담당자 : 최찬규
* 착수일 : 2026-04-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_v2.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

	String byca_comorg_code = ""; 
	String buyer = ""; 
	String user_dept              = ""; 
	String userId = "";
	String byca_comorg_level = "";
	String dept_name = "";
	String budget_flag = "";
	String person_author = "";
	String empNo	= "";
	
	if (sessionInfo != null){ 
		byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
		dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
		userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
		byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
	    budget_flag           = CommonUtil.nvl((String)sessionInfo.getBudgetFlag());  // 구매사 예산 사용여부 
	    person_author =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());  
	    empNo	= CommonUtil.nvl((String)sessionInfo.getEmpNo());
	}
	
	Map<String,String> _infoMap 		= (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	String pr_status_code = CommonUtil.nvl(_infoMap.get("PR_STATUS_CODE"));
	
// 	@SuppressWarnings (value="unchecked")
// 	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String p_buyer = CommonUtil.nvl((String) request.getParameter("buyer"),(String)sessionInfo.getComCode());
	String p_po_no = CommonUtil.nvl((String) request.getParameter("po_no"),"");
	String p_recv_flag = CommonUtil.nvl((String) request.getParameter("recv_flag"),"");
	
	String reportText= CommonLang.get("HTITLE704");	//"품의서출력"; // default 버튼명
	String reportid = "RD_06_B_002_12";
	
	Map<String, String> p060000016 = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P06-0000016");   // com_code , 특수로직아이디
	if (p060000016 != null){
		reportText= CommonUtil.nvl(p060000016.get("COL01_DATA"),reportText); // 레포트 버튼명
		reportid = CommonUtil.nvl(p060000016.get("COL02_DATA"),reportid); // 레포트아이디
	}
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String p060000036 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	} 
	
	
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N";

function kep_onload_view(){ 
	 
	 var initsheet = {};
		initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
				,{ Align:"Center",	SaveName:"PR_STATUS_TEXT",		Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*진행상태*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",			Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:170,	Edit:false,	EditLen:100,	Hidden:false}/*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*단가*/
				,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"<%=CommonLang.get("HTITLE45")%>",				Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"PO_AMT",				Header:"<%=CommonLang.get("HTITLE922")%>",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*합계*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT_NAME",	Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",		Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"<%=CommonLang.get("HTITLE177")%>",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*파일첨부*/
				,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"<%=CommonLang.get("HTITLE783")%>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*품목비고*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"IMAGE_KEY",										Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",									Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",									Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",								Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",	Header:"AGENT_CODE",								Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				
		];
		
		IBS_InitSheet(mySheet, initsheet, pagingMode);
		mySheet.SetHighlightAfterSort(2);
		
		mySheet.SetHeaderBackColor("#f2f7ff");
		mySheet.SetTheme("DB", "DeepBlue");
		
		kepSearch(document.commonMpIvOrderDetailPop, mySheet, "/mpiv/getCommonMpIvBuyerOrderDetailListPop_v2.do" , pagingMode);
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"IMAGE_KEY_CNT") == "0"){
			mySheet.SetCellValue(i,"IMAGE_KEY_CNT","");
		}else{
			mySheet.SetCellValue(i,"IMAGE_KEY_CNT","<%=CommonLang.get("HTITLE1202")%>"+mySheet.GetCellValue(i,"IMAGE_KEY_CNT")+"<%=CommonLang.get("HTITLE1203")%>"); // 첨부()
		}
	}
	
}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	var image_key = mySheet.GetCellValue(Row,"IMAGE_KEY");
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet.GetCellValue(Row, "IMAGE_KEY") != "")
			location.href="/common/download_v2.do?DOC_NO="+image_key;
	}
	return;
}
function btnSheet(){

	var po_no   = "<%=p_po_no%>";
	var buyer  = "<%=p_buyer%>";
	var seller = "KRKORE0001";
	var add_user_id = $("#st_add_user_id").val();


	<%
		String rptUrl = CommonUtil.nvl(_infoMap.get("RPT_URL"));
		
		if(rptUrl.equals("")){
			rptUrl = "RD_06_B_003_03";
			
		}
	%>
	
	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=rptUrl%>";
	
	reportOpen(fileName,param);
	
	return;	
}
function cartInsertText(){
	var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:cartInsert(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function cartInsert(){
	closePopText1();
	
	var query = "";
	for(var i = 1; i<=mySheet.RowCount(); i++){
		query += mySheet.GetCellValue(i,"BUYER_ITEM_NO") + "@@" + "1" + "@@" + mySheet.GetCellValue(i,"AGENT_CODE") + "@@" + mySheet.GetCellValue(i,"CONTRACT_NO") + "@@" + mySheet.GetCellValue(i,"CONTRACT_SEQ") + "@@" + mySheet.GetCellValue(i,"BYIT_COMORG_CODE");
		query += "&&";
	}
	
	document.forms.processForm.st_pf_my_group.value = "";
	document.forms.processForm.st_use_flag.value = "C"; 
	document.forms.processForm.st_query2.value = query;
	document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess");
}

function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	if(pMethod == "CsaveProcess"){
		if (sMsg == "CREATE_OK"){
			//장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = "<%=CommonLang.msg("MSG695")%>" +" "+ "<%=CommonLang.msg("MSG364")%>"; 
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		} else{
			//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG26") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 

function goCart(){
	closePopText1();
	
	opener.location.href = "<%=p060000036%>";
	self.close();
}
</script> 
</head>
<body onload="kep_onload_view()">
<form name="commonMpIvOrderDetailPop" id="commonMpIvOrderDetailPop" method=post >
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="COMPANY" value="<%=p_buyer%>"/>
<input type="hidden" name="buyer" value="<%=p_buyer%>"/>
<input type="hidden" name="po_no" value="<%=p_po_no %>" />
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_seller" id="st_seller" value="<%=_infoMap.get("SELLER")%>">
<input type="hidden" name="st_add_user_id" id="st_add_user_id" value="<%=_infoMap.get("CHANGE_USER_ID")%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1221")%><!--주문상세--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubState"><%=CommonLang.get("HTITLE1221")%><!-- 주문상세 -->  
  <%if(_infoMap.get("DOC_TYPE").equals("S")) {%>
  	<p class="ChipsType02_Blue" style="display:inline-block; margin-left:10px;line-height:13px;" ><%=CommonLang.get("HTITLE842")%><!-- 선입고 --></p>
  <%}else if(_infoMap.get("DOC_TYPE").equals("F")) {%>
  	<p class="ChipsType02_Blue" style="display:inline-block; margin-left:10px;line-height:13px;" ><%=CommonLang.get("HTITLE840")%><!-- 긴급발주 --></p>
  <%} %>
  
  </div>
  <table class="PopTableThLTdL" width="100%">
    <colgroup>
      <col width="20%" />
      <col width="30%" />
      <col width="20%" />
      <col width="30%" />
<!--       <col width="17%" /> -->
<!--       <col width="17%" /> -->
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE1179")%><!-- 주문요청번호 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("PR_NO")) %> (<%=CommonUtil.nvl(_infoMap.get("PR_CHANGE_DATE")) %>)</td>
      <th><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("PO_NO")) %> (<%=CommonUtil.nvl(_infoMap.get("PO_CREATE_DATE")) %>)</td>
<%--       <th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th> --%>
<%--       <td><p class="ChipsLarge_Blue" style="display:inline-block; margin-left:10px;line-height:13px;" ><%=CommonUtil.nvl(_infoMap.get("PR_STATUS_TEXT")) %></p></td> --%>
<!--     <th></th> -->
<!--     <td></td> -->
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("USER_DEPT")) %></td>
      <th><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("USER_NAME")) %>&nbsp;&nbsp;<%=CommonUtil.nvl(_infoMap.get("USER_PHONE")) %></td>
<%--       <th><%=CommonLang.get("HTITLE1232")%><!-- 발주자 연락처 --></th> --%>
<%--       <td><%=CommonUtil.nvl(_infoMap.get("USER_PHONE")) %></td> --%>
    </tr>
    <%if(_infoMap.get("DOC_TYPE").equals("S")) {%>
    <tr>
      <th><%=CommonLang.get("HTITLE665")%><!-- 선입고 발주일 -->&nbsp;/&nbsp;<%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
      <td colspan="5"><%=CommonUtil.nvl(_infoMap.get("PO_CREATE_DATE")) %> / <%=CommonUtil.nvl(_infoMap.get("DOC_TYPE_REMARK").replaceAll("&lt;br&gt;"," ")) %></td>
    </tr> 
    <%}else if(_infoMap.get("DOC_TYPE").equals("F")) { %>
    <tr>
      <th><%=CommonLang.get("HTITLE1458")%><!-- 긴급발주 비고 --></th>
      <td colspan="5"><%=CommonUtil.nvl(_infoMap.get("DOC_TYPE_REMARK").replaceAll("&lt;br&gt;"," ")) %></td>
    </tr>
    <%} %>
    <tr>
      <th><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
      <td colspan="5"><%=CommonUtil.nvl(_infoMap.get("PO_REMARK")) %></td>
    </tr>    
  </table>
  
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE824")%><!-- 배송정보 --></div>
  <div class="Popup_GrayBox">
    <div class="txtbold"><%=CommonUtil.nvl(_infoMap.get("DELY_TO_LOCATION_TEXT")) %></div> 
    <div class="txt"> <%=CommonUtil.nvl(_infoMap.get("DELY_TO_LOCATION")) %></div> 
    <div class="txt">
    <%if(!CommonUtil.nvl(_infoMap.get("RECIPIENT_NAME"),"").equals("")) {%>
    	<%=CommonUtil.nvl(_infoMap.get("RECIPIENT_NAME")) %> |
    <%} %>
    <%if(!CommonUtil.nvl(_infoMap.get("RECIPIENT_PHONE"),"").equals("")) {%>
    	<%=CommonUtil.nvl(_infoMap.get("RECIPIENT_PHONE")) %> |
    <%} %> 
    <%=CommonLang.get("HTITLE831")%><!-- 수령희망일 -->  <%=CommonUtil.nvl(_infoMap.get("RD_DATE")) %>
    </div>
  </div>  
  <div class="PopupTitSub"  ><%=CommonLang.get("HTITLE1222")%><!-- 주문품목 --><p style="display:inline-block; margin-left:5px">(<%=CommonUtil.formatNumber(_infoMap.get("PO_CNT"),true,0,3)%> <%=CommonLang.get("HTITLE1233")%><!--품목--> / <%=CommonUtil.formatNumber(_infoMap.get("PO_TTL_AMT"),true,0,3)%><%=CommonLang.get("HTITLE660")%><!-- 원 -->)</p> </div>  
  <div class="ScrollBox " style="height:169px">
	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
	</script>
  </div>  
 
  <div class="PopupListBtnBox_Center mt20" >
    <button class="ButQuaternary_large" onclick="javascript:btnSheet(); return false;"><%=CommonLang.get("HTITLE1226")%><!--발주서출력--></button>
    <button class="ButQuaternary_large" onclick="javscript:cartInsertText(); return false;"><%=CommonLang.get("HTITLE1183")%><!-- 장바구니담기 --></button>
  </div>  
</div><!-- warp 끝-->
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

</body>
</html>
