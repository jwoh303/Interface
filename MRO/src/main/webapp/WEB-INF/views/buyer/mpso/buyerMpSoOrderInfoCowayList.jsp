<%--
**********************************************
* 메뉴 : 주문관리>장바구니>주문정보/배송정보 (코웨이용)
* 화면 : 주문정보/배송정보
* 기능 : 구매요청 전 최종 주문정보화 배송정보를 확인한다.
* 프로그램 ID : PG_06_B_010_05
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-06-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf" %>
<script src="/resources/js/kep_buyer.js"></script>

</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과	
	String pre_goods_count = (String)request.getAttribute("pre_goods_count"); //선입고발주 제외대상 업체 조회	
	String Hdata = "";
	Hdata = (String)request.getAttribute("Hdata"); // 홍익대학교-- 대학원 소속 체크
	
	String total_cnt = "0"; // 총 조회수 (필수)
	if (_gridList != null){
		total_cnt = String.valueOf(_gridList.size());
	}
	
	String st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
	String SessionComCode = "";
	String byca_comorg_code = ""; 
	String img_view_flag = "";
	String buyer			= "";
	String user_dept			= "";
	String budget_flag	= "";	// 고객사 예산 사용여부
	String userRole		= ""; 
	String userRole1 = ""; 
	String userRole2 = ""; 
	String userId = "";
	//String budget_falg = "";
	String row_cnt = ""; 
	String person_author = "";	
	String userType 		 = "";
	
	String _h_sslurl2 = CommonUtil.getSslURL(request, "https");
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode = CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code = CommonUtil.nvl((String)sessionInfo.getBycaComorgCode()); 
		img_view_flag = CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); // 20070704 이미지보기 우선여부
		buyer = SessionComCode;
		user_dept = CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		budget_flag = CommonUtil.nvl((String)sessionInfo.getBudgetFlag()); // 고객사 예산 사용여부 
		userRole = CommonUtil.nvl((String)sessionInfo.getRole()); 
		userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
		row_cnt = CommonUtil.nvl((String)sessionInfo.getRowCnt()); //20070704 추가 페이지 기본 개수		
		person_author	= CommonUtil.nvl((String)sessionInfo.getPersonAuthor()); 
		userType         = CommonUtil.nvl((String)sessionInfo.getUserType());
		
	}
	
	if(st_image_status.equals("")) {
		st_image_status = img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
	}
	String verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),"");
	String st_location_code = CommonUtil.nvl((String) request.getParameter("st_location_code"),"");
	String st_location_type = CommonUtil.nvl((String) request.getParameter("st_location_type"),"");
	String st_location_name = CommonUtil.nvl((String) request.getParameter("st_location_name"),"");
	String st_tel_no		= CommonUtil.nvl((String) request.getParameter("st_tel_no"),"");
	String st_fax_no		= CommonUtil.nvl((String) request.getParameter("st_fax_no"),"");
	String st_mobile_no	= CommonUtil.nvl((String) request.getParameter("st_mobile_no"),"");
	String st_user_name	= CommonUtil.nvl((String) request.getParameter("st_user_name"),"");
	String st_email		= CommonUtil.nvl((String) request.getParameter("st_email"),"");
	String st_query_cart	= CommonUtil.nvl((String) request.getParameter("st_query_cart"),"");
	String st_query_cart_date	= CommonUtil.nvl((String) request.getParameter("st_query_cart_date"),"");
	String st_query_cart_date_item	= CommonUtil.nvl((String) request.getParameter("st_query_cart_date_item"),"");
	String st_recv_date	= CommonUtil.nvl((String) request.getParameter("st_recv_date"),"");
	String st_recv_date2	= CommonUtil.nvl((String) request.getParameter("st_recv_date2"),"");
	String st_remark		= CommonUtil.nvl((String) request.getParameter("st_remark"),"");
	String st_gongje_mark		= CommonUtil.nvl((String) request.getParameter("st_gongje_mark"),"");
	
	String purchase_dept_name = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_name"),"");
	String purchase_dept_code = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_code"),"");
	String st_check		= CommonUtil.nvl((String) request.getParameter("st_check"),"PAGE_SEARCH");	
	String st_drcp_gubun	= CommonUtil.nvl((String) request.getParameter("st_drcp_gubun"),"");
	
	int rec_cnt = 0;
	String item_name = "";
	String contract_no = "";
	String contract_seq = "";
	if (_gridList != null){
		if (_gridList.size()>0){
			Map<String,String> rowItemData = _gridList.get(0);
			
			if (rowItemData != null){
				contract_no = rowItemData.get("CONTRACT_NO");
				contract_seq = rowItemData.get("CONTRACT_SEQ");

				rec_cnt = _gridList.size();
				if(rec_cnt > 1){
					item_name = rowItemData.get("DESCRIPTION_LOC") + " 외";
				}else{
					item_name = rowItemData.get("DESCRIPTION_LOC");
				}
			}
		}
	}
	double tot_price = 0;
	String account_type = "";
	String bdgt_flag = "";		
	boolean krcowa = false;
	if ("KRCOWA0001".equals(SessionComCode)){
		krcowa = true; // 인수자명 수정 가능하다
	}
	
	boolean submitFlag = false;
	boolean p060000032 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000032"); // KRCOWA0001 KRCOWA0005 KRCOWA0006
	//주문하기 메세지 표시
	boolean p060000061 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000061"); 
%>
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	<% if (krcowa == true) { %>
	mobile_distinct(0);
	<%}%>
	<% if (_gridList != null){ %>
	kep_listkepSetCalender2("fromDate" , <%=rec_cnt%> ); 
	<%}%>
// 	if($("#st_prev_url").val() == '/mpso/getBuyerMpSoNewDoctorBatchRegList.do' || $("#st_prev_url").val() == '/mpso/getBuyerMpSoGroupPurchaseList.do'){
	if($("#st_prev_url").val() == '/mpso/getBuyerMpSoGroupPurchaseList.do'){
		$('#span_order_cancle').html('<a href="javascript:order_cancle();">신청취소</a>');
		$('#span_order_submit').html('<a href="javascript:order_submit(1)">신청하기</a>');
	}
}

function mobile_distinct(set){
	var tel_no		= "<%=st_mobile_no%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
	if(kepTrimStr(tel_no)!="") { 
		var tot_lenth	= tel_no.length;
		var no_1_cnt	= tel_no.indexOf("-");
		no_1 = tel_no.substr(0,no_1_cnt); //지역번호
		var no_2_cnt_temp = tel_no.substr(no_1_cnt+1,tot_lenth); // 3016-8964
		var no_2_cnt	= no_2_cnt_temp.indexOf("-"); //4
		no_2 = no_2_cnt_temp.substr(0,no_2_cnt); //국번
		no_3 = no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호
		document.forms.contentForm.st_mobile_no2.value = no_2;
		document.forms.contentForm.st_mobile_no3.value = no_3;
		document.forms.contentForm.st_mobile_no1.value = no_1;
	}
}

//이미지 보이기 숨기기
function imageHideView(){
	var image_status = $("#st_image_status").val();
	if(image_status == "IMAGE_HIDDEN"){
		image_status = "IMAGE_VIEW"; 
	}else if(image_status == "IMAGE_VIEW"){
		image_status = "IMAGE_HIDDEN"; 
	}
	$("#st_image_status").val(image_status);
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

//조회
function kepSearch(curPage){
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderInfoCowayList.do").submit(); 
}
 
function order_cancle(){
	
	//////////////////// 주문취소 후 장바구니 화면이동 //////////////////////////
	if(!confirm(" 주문을 취소하시겠습니까? \n\n 장바구니 화면으로 돌아갑니다. ")){
		return;
	}
	if($("#st_prev_url").val() == '/mpso/getBuyerMpSoNewDoctorBatchRegList.do' || $("#st_prev_url").val() == '/mpso/getBuyerMpSoGroupPurchaseList.do'){
		kepAjaxFormCall("/mpso/setDeleteTempCart.do","contentForm","delete_cart");
	} else {
		document.forms.contentForm.st_query_cart.value = "";
		$('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit();
	}
}

function dely_info_modify(){
	////////////////////	배송 정보 변경	//////////////////////////
	//PG_06_B_010_04
	$('#contentForm').attr("action", "<%=_h_sslurl2%>/mpso/getBuyerMpSoDlvryInfoCowayList.do").submit(); 
}

function order_info_modify(){
	////////////////////	주문 정보 변경	//////////////////////////
	var buyer = document.forms.contentForm.st_buyer.value;
	//코웨일 경우 장바구니 URL 분기처리 현
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit(); 
}

function order_submit(recvFlag){
	//////////////////// 주문접수 후 DB INSERT //////////////////////////
	var person_author = document.forms.contentForm.st_person_author.value;
<%  
if (krcowa == true) { %>
	var user_name = TrimCommon(document.forms.contentForm.st_user_name.value); 
	if(user_name == "") {
		alert("인수자명은 필수 입력 사항입니다.");
		document.forms.contentForm.st_user_id.focus();
		return;
	}
	var mobile2 = document.forms.contentForm.st_mobile_no2.value;
	var mobile3 = document.forms.contentForm.st_mobile_no3.value;
	if(mobile2 == "") {
		alert("연락처를 입력 바랍니다.");
		document.forms.contentForm.st_mobile_no2.focus();
		return;
	}
	if(mobile3 == "") {
		alert("연락처를 입력 바랍니다.");
		document.forms.contentForm.st_mobile_no3.focus();
		return;
	}
	var mobile_phone = document.forms.contentForm.st_mobile_no1.value +"-"+ mobile2 +"-"+ mobile3;
	document.forms.contentForm.st_mobile_no.value = mobile_phone;
	/* 2015-04-08 코웨이 요청사항 수정.
	 * document.forms.contentForm.st_tel_no.value  = mobile_phone;
	 */
<%
}%>
var buyer		= document.forms.contentForm.st_buyer.value;
<%if(p060000061==true&&userType.equals("U")){%>
	if(person_author == "PO"){
		if(recvFlag == '1' && !confirm("구매발주 하시겠습니까? ")) return;
	}else {
		var v_gongje = document.forms.contentForm.st_gongje_mark.value;
		if(v_gongje=="1"){
			if(buyer == "KRCOWA0008"){
				if(recvFlag == '1' && !confirm("수수료공제 품목입니다. 구매요청 하시겠습니까? \n[공제 동의 확인]\n해당 품목에 대해 공제하는 것에 동의합니다.\n※ 공제 방법 : 특이사항에 명시")) return;
			}else{
				if(recvFlag == '1' && !confirm("수수료공제 품목입니다. 구매요청 하시겠습니까? ")) return;
			}
		}else if(v_gongje=="2"){
			if(recvFlag == '1' && !confirm("운영비공제 품목입니다. 구매요청 하시겠습니까? ")) return;			
		}else{
			if(recvFlag == '1' && !confirm("구매요청 하시겠습니까? ")) return;
		}		
	}
<%}else{%>    
	if(person_author == "PO"){
		if(recvFlag == '1' && !confirm("구매발주 하시겠습니까? ")) return;
	}else {
		if(recvFlag == '1' && !confirm("구매요청 하시겠습니까? ")) return;
	}
<%}%>

	var userDept	= document.forms.contentForm.st_user_dept.value;
	var ACCOUNT_TYPE = document.forms.contentForm.st_account_type.value;
	var tot_price	= eval(document.forms.contentForm.nu_tot_price.value);
	var bdgt_flag	= document.forms.contentForm.st_bdgt_flag.value; 
	var budget_flag = "<%=budget_flag%>";
	var drcp_gubun = document.forms.contentForm.st_drcp_gubun.value; 
	
	if(budget_flag == "Y") {
		doCheckAMT(buyer,userDept,ACCOUNT_TYPE,tot_price,tot_price,recvFlag);
	} else if((buyer == 'KRCOWA0003'|| buyer == 'KRCOWA0008') && drcp_gubun == "Y"){
		doCheckCowayPoint(tot_price);
	} else {
		setData(recvFlag);
	}
}

function set_cart_date(limit){
	if (limit == 0) return;
	var str = "";
	for (var i=0; i<eval(limit); i++){
		str = str + $("#BUYER_ITEM_NO_ARRRAY"+i).val() + "|" + $("#fromDate"+i).val().replace(/[/]/gi,"") + "@@"; 
	}
	$("#st_query_cart_date").val(str);	
}
 
function doCheckAMT(buyer,user_dept,account_type,end_price,tot_price,recvFlag){
	document.forms.processForm.buyer.value = buyer;
	document.forms.processForm.account_type.value = account_type;
	document.forms.processForm.end_price.value = end_price;
	document.forms.processForm.tot_price.value = tot_price;
	document.forms.processForm.recvFlag.value = recvFlag; 		
	document.forms.processForm.st_query_cart.value = document.forms.contentForm.st_query_cart.value; 	
	document.forms.processForm.st_query_cart_date.value = document.forms.contentForm.st_query_cart_date.value; 	
	//코웨이일경우 예산 체크
	<%
	//SLOGIC-BEGIN(P06-0000032)
	if (p060000032 == true){ %>
		kepAjaxFormCall("/mpso/coway_cowayBuyerAdminBdgtTempCheck.do","processForm","COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}else{%>
		kepAjaxFormCall("/mpso/buyerAdminBdgtTempCheck.do","processForm","BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}
	//SLOGIC-END
	%>
}
function doCheckCowayPoint(tot_price){
	//코웨이 포인트 사용하는 고객사일 경우
	document.forms.processForm.COM_CODE.value = '<%=buyer%>';
	document.forms.processForm.tot_price.value = tot_price;
	kepAjaxFormCall("/mpso/cowayBuyerAdminPointTempCheck.do","processForm","POINT_TEMP_CHECK");
}
function setCheckEnd(FLAG,recvFlag){
	if(FLAG == "OK"){
		setData(recvFlag);
	}else{
		alert(recvFlag);
		document.forms.contentForm.st_query_cart.value = "";
		$('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit();
	}
}
function setData(recvFlag) {
	var person_author = document.forms.contentForm.st_person_author.value;
	if (recvFlag=="3"){
		ServerCall("N","GA");
	} else{
		if(person_author == "PO") {
			document.forms.processForm.TYPE.value = "PX";
		}else {
			document.forms.processForm.TYPE.value = "PR";
		}
		document.forms.processForm.COM_CODE.value = '<%=buyer%>';
		kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ"); 
	}
}

function ServerCall(GW_NO,recvFlag){ 
	if(document.forms.contentForm.cbx.checked == true){ // 선입고 여부 Y(선입고) , N(발주)
		document.forms.contentForm.st_gr_flag.value = "S";
	}else if(document.forms.contentForm.cbx1.checked == true){
		document.forms.contentForm.st_gr_flag.value = "F"; // 선입고 여부 Y(선입고) , N(발주)
	}else{
		document.forms.contentForm.st_gr_flag.value = "N"; // 선입고 여부 Y(선입고) , N(발주)
	}
	document.forms.contentForm.GW_NO.value = GW_NO;
	document.forms.contentForm.recvFlag.value = recvFlag;
	var buyer = document.forms.contentForm.st_buyer.value;
	var limit = "<%=rec_cnt%>";	
	set_cart_date(limit);
	kepAjaxFormCall("/mpso/buyerNewCreateOrder.do","contentForm","BUYER_NEW_CREATE_ORDER"); 
}

function setCheckBox(){
	if(document.forms.contentForm.cbx.checked == true){
		if(confirm("작성하신 주문을 선입고 하시겠습니까?\n\n선입고시 발주일을 변경하실 수 있습니다.")){
		if(document.forms.contentForm.cbx1.checked == true){
			alert("선입고 선택 시 긴급발주 선택을 하실 수 없습니다.");
			document.forms.contentForm.cbx1.checked = false;
			return;
		}
			return;
		}else{
			document.forms.contentForm.cbx.checked = false;
			return;
		}
	}else if(document.forms.contentForm.cbx.checked == false){
		document.forms.contentForm.imsi_po_create_date.value = document.forms.contentForm.ToDateTemp.value;
		return;
	}
}

function setCheckBox1(){
	if(document.forms.contentForm.cbx.checked == true){
		alert("선입고 선택 시 긴급발주 선택을 하실 수 없습니다.");
		document.forms.contentForm.cbx.checked = false;
		return;
	}
}

function CalendarCheck(check){
	if(document.forms.contentForm.cbx.checked == false){
		alert("선입고의 경우에만 발주일을 변경하실 수 있습니다.");
		return;
	}else{
		date_check = check;
		//Calendar_Open();
		kepCalendarOpenPopup();
	}
}

function setPopupCalendar(year,month,day){
	document.forms.contentForm.imsi_po_create_date.value=year+"/"+month+"/"+day+"";
	document.forms.contentForm.st_po_create_date.value=year+""+month+""+day+"";	
}

function setCheckEnd(FLAG,recvFlag){
	if(FLAG == "OK"){			
		setData(recvFlag);
	}
}

function ServerCallByCard(GW_NO,recvFlag){
	alert('ServerCallByCard실 발주 호출');
	return;
	if(document.forms.contentForm.cbx.checked == true){
		document.forms.contentForm.st_gr_flag.value = "S";
	}else if(document.forms.contentForm.cbx1.checked == true){
		document.forms.contentForm.st_gr_flag.value = "F";
	}else{
		document.forms.contentForm.st_gr_flag.value = "N";
	}
	document.forms.contentForm.GW_NO.value = GW_NO;
	document.forms.contentForm.recvFlag.value = recvFlag;
	var buyer = document.forms.contentForm.st_buyer.value;
	kepAjaxFormCall("/mpso/buyerNewCreateOrder.do","contentForm","BUYER_NEW_CREATE_ORDER"); 
}

function kepApprovalReturn(ERR,GW_NO){ 
		EndPassProcess(ERR,GW_NO); 
}

// 상신결과
function EndPassProcess(ERR,GW_NO){
	if(ERR=="true"){
		ServerCall(GW_NO,"GS");
	}
}

function setDongMail(pr_no){
	var buyer = document.forms.contentForm.st_buyer.value;
	document.forms.contentForm.st_pr_no.value = pr_no;
	kepAjaxFormCall("/mpso/adminBuyerMasterPrCreateMailReg.do","contentForm","ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"); 
}

function setCreate_Results(response){
	var result = response.msg.MSG; 
	var pr_type = result.substring(0,2);
	var person_author = document.forms.contentForm.st_person_author.value;
	
	if(pr_type != "PR" && pr_type != "PX"){
		if(person_author == "PO"){
			alert("구매발주가 실패 하였습니다. 확인 후 다시 주문해 주십시요.");
			return;
		}else {
			alert(response.msg.MESSAGE)
			alert("구매요청이 실패 하였습니다. 확인 후 다시 주문해 주십시요.");
			return;
		}
	}

	var byca_comorg_code = document.forms.contentForm.st_byca_comorg_code.value;
	var buyer = document.forms.contentForm.st_buyer.value;
	
	if( (buyer=="KRCOWA0002" || buyer=="KRCOWA0003" || buyer=="KRCOWA0007" || buyer=="KRCOWA0008") && person_author=="PR" ){
		$('#contentForm').attr("action", "/mpso/getBuyerMpSoClcsOrderProgressList.do").submit();
	}else{
		$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderProgressList.do").submit();
	}
}

function setResult(response){
	if(outflag == "true"){
		alert("메일 발송이 정상적으로 되었습니다.");
	}else{
		alert("메일 발송이 실패하였습니다.");
	}
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderProgressList.do").submit(); 
}

function DraftSentenceView(){
	var f = document.forms.contentForm;
	var buyer = "<%=buyer%>";
	var user_id = "<%=userId%>";
	var contract_no = '<%=contract_no%>';
	var contract_seq = '<%=contract_seq%>';
	reportOpen("RD_06_S_001_99","["+buyer+"]["+user_id+"]["+contract_no+"]["+contract_seq+"]");
}

function attach_popup(img_key){	
	
	var type = "PR";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}


/**
 * 첨부파일 구현
 */
var gridIndex = 0;
function gridPopOpen(obj1){ 
	gridIndex = obj1;
	popupSel = "attach";
	attach_popup("");
}
 
function setPopupReturn(value1){
	if (popupSel == "attach"){
 		$("input[name=st_image_key]").eq(gridIndex).val(value1); 
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var flag = "";
	var budget_dept_name = "";
	var account_text = "";
	var plan_amt = "";
	var result_amt = "";
	var temp_amt = "";
	var tot_price = "";
	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK" || pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){
		var recvFlag = document.forms.processForm.recvFlag.value;
		var end_price = document.forms.processForm.end_price.value;
		if (response.data.length > 0){
			flag = $.trim(eval("response.data[0].BUYER_CHECK"));
			budget_dept_name = $.trim(eval("response.data[0].BUDGET_DEPT_NAME"));
			account_text = $.trim(eval("response.data[0].ACCOUNT_TYPE_TEXT"));
			plan_amt = $.trim(eval("response.data[0].MPAMT"));
			result_amt = $.trim(eval("response.data[0].RESULT_AMT"));
			temp_amt = $.trim(eval("response.data[0].TEMP_AMT"));
			tot_price = $.trim(eval("response.data[0].TOT_AMT"));
		}
		if(flag == "예산초과"){
			alert(budget_dept_name +
				"\n\n"+account_text+" 예산 "+kepCommaNum(plan_amt)+" 원"+
				"\n\n"+account_text+" 구매가능 예산 "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+" 원"+
				"\n\n"+account_text+" 구매금액 "+kepCommaNum(tot_price)+" 원"+
				"\n\n예산이 초과되어 구매할 수 없습니다.");
			return ;
		} else if(flag == "예산미편성"){
			alert(budget_dept_name + " "+account_text+ " 예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.");
			return;
		} else {
			setCheckEnd('OK',recvFlag,end_price);
		}
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 
		var result = response.msg.MSG;
		if(result == "DUP"){
			alert("해당 주문은 이미 진행되었습니다.");
			return;
		}
		setCreate_Results(response);
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 
		setResult(response);
	}else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 
		var checkpass = response.msg.CHECKPASS; 
		var pass_flag = response.msg.PASS_FLAG; 
		GoPass(checkpass,pass_flag,"");
	}else if (pMethod == "WEBSERVICE"){
		var out = response.msg.OUT;
		var status = response.msg.STATUS;
		var result = response.msg.RESULT;
		if(status == "ERROR"){
			setCheckEnd('NO',result);
			return ;
		}else if(status == "OK"){
			setCheckEnd('OK',result);
			return;
		}else {
			alert("시스템 오류입니다. 관리자에게 전화하시기 바랍니다.");
			return;
		}
	}else if (pMethod == "POINT_TEMP_CHECK"){
		var recvFlag = document.forms.processForm.recvFlag.value;
		setData(recvFlag);
	}else if (pMethod == "delete_cart"){
		document.forms.contentForm.st_query_cart.value = "";
		$('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit();
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function kepAjaxError(pMethod , response) {
	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("시스템 오류입니다. 관리자에게 전화하시기 바랍니다.");
	}else if (pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("시스템 오류입니다. 관리자에게 전화하시기 바랍니다.");
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. "); 
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. "); 
	}

}


//총금액 PG_06_B_006_50
function category_list_pop(){
	var byca_comorg_code = "<%=byca_comorg_code%>";
	var user_id			= "<%=userId%>";	
	openSearchPopup("/mpso/getCategoryListSelectPop.do","?byca_comorg_code="+byca_comorg_code+"&user_id="+user_id , "500,500,no"); 
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %>"+"<%= CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

//인수자명
function getUserSelect(buyer){
	popupSel = "user";
	openSearchPopup('/common/misUserSelectAllPop.do', "?open=Y&com_code="+buyer , "500,500,no"); 
}

function setPopupReturn(value1, value2, value3, value4, value5 ,value6, value7, value8, value9){
 
	document.forms.contentForm.st_user_id.value = value1; 
	document.forms.contentForm.st_user_name.value = value2; 
	//document.forms.contentForm.st_dept_code.value = value3; 
	//document.forms.contentForm.st_dept_name.value = value4; 
	
	var no_1 = "";
	var no_2 = "";
	var no_3 = "";
	if(value9!="")
	{
		var tot_lenth	= value9.length;
		var no_1_cnt	= value9.indexOf("-");
			no_1		= value9.substr(0,no_1_cnt); //통신사번호
		var no_2_cnt_temp = value9.substr(no_1_cnt+1,tot_lenth); // 3016-8964 
		var no_2_cnt	= no_2_cnt_temp.indexOf("-"); //4 
			no_2		= no_2_cnt_temp.substr(0,no_2_cnt); //국번
			no_3		= no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호
		document.forms.contentForm.st_mobile_no.value = value9;
		document.forms.contentForm.st_mobile_no1.value = no_1;
		document.forms.contentForm.st_mobile_no2.value = no_2;
		document.forms.contentForm.st_mobile_no3.value = no_3;
		document.forms.contentForm.st_tel_no.value = value9;
	}
}

function calenderChange(){
	
}
</script>
<body onload="kep_onload_view()">
	<div id="wrapper"> 
	<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>
		<div id="container2">
			<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerLeft"/>
			<c:param name="part" value="${param.upperId}"/>
			</c:import>
			<!-- 메뉴 E -->
			<!--내용 시작-->
			<div id="ContArea">
				<div class="btnArea">
					<div class="fl">
						<h3>주문정보</h3>
					</div>
					<div class="fr">
						<span class="btn_reset" title="변경"><a href="javascript:order_info_modify();">품목변경</a> </span>
					</div>
				</div>
				 
				<!--조회영역-->
				<form name = "contentForm" id="contentForm" method = "post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">	
					<!-- 경동 결재관련 변수-->
					<input type="hidden" name="cmd" value="iPR">
					<input type="hidden" name="buyer" value="">
					<input type="hidden" name="prNo" value="">
					<input type="hidden" name="pxNo" value="">
			
					<!-- 경동 결재관련 변수-->
					<input type="hidden" name="st_check" value="<%=st_check%>">
					<input type="hidden" name="st_person_author" value="<%=person_author%>">
					<input type="hidden" name="st_buyer" value="<%=buyer%>">
					<input type="hidden" name="st_user_dept" value="<%=user_dept%>">
					<input type="hidden" name="st_byca_comorg_code" value="<%=byca_comorg_code%>">
					<input type="hidden" name="st_pr_no" value="">
					<input type="hidden" name="st_tel_no" value="<%=st_tel_no%>">
					<input type="hidden" name="st_fax_no" value="<%=st_fax_no%>"> 
					<input type="hidden" name="st_email" value="<%=st_email%>">
					<input type="hidden" name="st_query_cart" id="st_query_cart"	value="<%=st_query_cart%>">
					<input type="hidden" name="st_prev_url" id="st_prev_url"	value="${param.st_prev_url }">
					<input type="hidden" name="st_query_cart_date" id="st_query_cart_date"	value="<%=st_query_cart_date%>">
					<input type="hidden" name="st_query_cart_date_item" id="st_query_cart_date_item"	value="<%=st_query_cart_date_item%>">
					<input type="hidden" name="st_recv_date" value="<%=st_recv_date%>">
					<input type="hidden" name="st_recv_date2" value="<%=st_recv_date2%>">
					<input type="hidden" name="st_remark" value="<%=st_remark%>">
					<input type="hidden" name="st_gongje_mark" value="<%=st_gongje_mark%>">
					<input type="hidden" name="st_image_status" id="st_image_status"	value="<%=st_image_status%>">
					<input type="hidden" name="st_location_type" value="<%=st_location_type%>">
					<input type="hidden" name="st_location_name" value="<%=st_location_name%>">
					<input type="hidden" name="st_location_code" value="<%=st_location_code%>">
					<input type="hidden" name="st_purchase_dept_name" value="<%=purchase_dept_name%>">
					<input type="hidden" name="st_purchase_dept_code" value="<%=purchase_dept_code%>">
					<input type="hidden" name="recvFlag" value="">
					<input type="hidden" name="GW_NO" value="">
					<input type="hidden" name="st_gr_flag" value="">
					<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
					<input type="hidden" name="st_po_create_date" value="<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>">
					<input type="hidden" name="st_verif_num" value="<%=verif_num%>">
					<input type="hidden" name="st_drcp_gubun" value="<%=st_drcp_gubun%>">
					<!-- 신용카드결제 변수 -->
					<input type="hidden" name="st_item_name" value="<%=item_name%>">
					<input type="hidden" name="st_mg_note" value="">
					<input type="hidden" name="st_ref_pr_no" value="">
					<input type="hidden" name="card_cd" value="">
					<input type="hidden" name="card_name" value="">
					<input type="hidden" name="tno" value="">
					<input type="hidden" name="amount" value="">
					<!--데이타그리드-->
					<div class="fl">
						<span class="btn_imghide">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){ %>
								<a href="javascript:imageHideView();" title="이미지보이기" >이미지보이기</a>
<%  }else{ %>
								<a href="javascript:imageHideView();" title="이미지감추기" >이미지감추기</a>
<%  } %>
						</span>
					</div>
					<div class="fr">
						(기준 : 원)
					</div>
					<table class="cont_t_list02" style="width:100%">
						<colgroup>
							<col width="5%" />
							<col width="25%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="5%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">&nbsp;</th>
								<th scope="col">품목코드 / 품목명 / 규격</th>
								<th scope="col">협력사/단위</th>
								<th scope="col">단가/구매수량</th>
								<th scope="col">구매액</th>
								<th scope="col">수령희망일</th>
								<th scope="col">첨부</th>
							</tr>
<%  if (_gridList == null || _gridList.size() == 0){%>
							<tr>
								<td colspan="6" align="center" height = "50"> 
									<span>조회된 데이타가 없습니다.</span>
								</td> 
							</tr>
<%  }else{
		submitFlag = true;
		Map<String,String> rowData = null;
		for (int j=0; j<rec_cnt; j++) {
			rowData = _gridList.get(j);
			String tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA"; 
			tot_price += Double.parseDouble(rowData.get("TOT_SUM"));
			account_type = rowData.get("ACCOUNT_TYPE");
			bdgt_flag	= rowData.get("BDGT_FLAG");
%> 
							<tr bgcolor="<%=tclass%>">
								<td title="이미지" >
<% 			if(st_image_status.equals("IMAGE_HIDDEN")){
				if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
									<img src="/resources/images/but_img_off.gif" border="0">
<%				}else{ %>
									<a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
										<img src="/resources/images/but_img_on.gif" border="0">
									</a>

<%				}
			}else{
				if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
									<img src="/resources/images/noimage.gif" width="50" height="50" class="PDimg">
<%				} else{ %>
									<a href="javascript:getBigImage('<%=rowData.get("IMGFILE_DIR")%>','<%=rowData.get("IMGFILE_NAME")%>');">
										<img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/"+rowData.get("IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/images/noimage.gif'" name="image1" width="50" height="50" border="0">
									</a>
<%				}
			}
			String tmpTitle = "구매액";
%>
								</td>
								<td class="left" title="품목코드/품목명/규격" >
									&nbsp;
<%-- <% if("/mpso/getBuyerMpSoCartCowayClcsList.do".equals(request.getParameter("st_prev_url"))){ %> --%>
<% if("KRCOWA0002".equals(buyer)||"KRCOWA0003".equals(buyer)||"KRCOWA0007".equals(buyer)||"KRCOWA0008".equals(buyer)){ %>
									<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%><%=rowData.get("CART_SEQ")%>" />
<% } else { %>
									<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%><%=rowData.get("CART_SEQ")%>" />
<% } %>
									<a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
										<b><font color="#5B5B5B"><%=rowData.get("BUYER_ITEM_NO")%></font></b>
									</a>
									<br>
									&nbsp;&nbsp;<%=rowData.get("DESCRIPTION_LOC")%><%=rowData.get("SPECIFICATION")%>
								</td>
								<td title="협력사/단위" >
									<a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');">
										<%=(rowData.get("AGENT").equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : rowData.get("AGENT")%>
									</a>
									<br>
									<%=rowData.get("UNIT_MEASURE")%>
								</td>
								<td class="right" title="단가/구매수량" >
									<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%> 원
									<br>
									<%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%>
								</td>
								<td class="right" title="<%=tmpTitle%>">
									<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%> 원
								</td>
								<td title="수령희망일">
									<input type="text" class="input_type_text" name="recv_date_hope" id="fromDate<%=j%>" size="10" readOnly value="<%=CommonUtil.formatStrinigDate(st_recv_date2)%>">
								</td>
								<td title="파일">
									<input type="hidden" name="st_image_key" id="st_image_key" value="<%=rowData.get("IMAGE_KEY")%>">
<%			if(!rowData.get("IMAGE_KEY").equals("")) { %>
									<a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>');">
										<img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0">
									</a>
<%			}else {%>
									<a href="javascript:gridPopOpen('<%=j%>');">
										<img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0">
									</a>
<%			}%>
									<input type="hidden" name="list_mg_note<%=j%>" id="list_mg_note<%=j%>" value="<%=rowData.get("MG_NOTE")%>">
								</td>
							</tr>
<%		}
	}%>
						</thead>
					</table>
					<div class="fr">
						금액합계 : <%=CommonUtil.formatNumber(tot_price,true,0,3)%> 원
						<input type="hidden" name="nu_tot_price" value="<%=tot_price%>">
						<input type="hidden" name="st_account_type" value="<%=account_type%>">
						<input type="hidden" name="st_bdgt_flag" value="<%=bdgt_flag%>">
					</div>
					<br/>
					<br/>
					<div class="btnArea">
						<div class="fl">
							<h3>배송정보</h3>
						</div>
						<div class="fr">
							<span class="btn_04 mr04" title="변경">
								<a href="javascript:dely_info_modify()">배송정보변경</a>
							</span>
					 	</div>
					</div> 	
					<table class="cont_t_list06" style="width:99%;">
						<caption>제품상세보기 리스트</caption>
						<colgroup>
							<col width="100px" />
							<col width="*" />
							<col width="100px" />
							<col width="33%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">발주부서</th>
								<td colspan="3">&nbsp;<%=purchase_dept_name%></td>
							</tr> 
							<tr>
								<th scope="row">배송처</th>
								<td colspan="3">&nbsp;<%=st_location_name%></td>
							</tr>
							<tr>
								<th scope="row">전화번호</th>
								<td>&nbsp;<%=st_tel_no%></td>
								<th scope="row">팩스번호</th>
								<td>&nbsp;<%=st_fax_no%></td>
							</tr>
<%  if (krcowa == true) { %>
							<tr>
								<th scope="row">인수자명</th>
								<td>
									<input type="text" name="st_user_id" class="input_type_text" style="width:20%" value="<%=userId%>">
									<span class="btn_gray_02" title="변경" > <a href="javascript:getUserSelect('<%=buyer%>')">변경</a></span>
									<input type="text" name="st_user_name" value="<%=st_user_name%>" class="input_type_text" style="width:20%" readonly>
								</td>
								<th scope="row">휴대폰</th>
								<td>
									&nbsp;
									<input type="hidden" name="st_mobile_no" size="6" id="text">
									<select name="st_mobile_no1" id="incolor">
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
									</select>
									-
									<input type="text" name="st_mobile_no2" class="input_type_text" size="8" maxlength="4" onkeyup="kepNumcheck(this);">
									-
									<input type="text" name="st_mobile_no3" class="input_type_text" size="8" maxlength="4" onkeyup="kepNumcheck(this);">
								</td>
							</tr>
<% }else{ %>
							<tr>
								<th scope="row">인수자명</th>
								<td>&nbsp;<%=st_user_name%><input type="hidden" name="st_user_id" value="<%=userId%>"><input type="hidden" name="st_user_name" value="<%=st_user_name%>"></td>
								<th scope="row">휴대폰</th>
								<td>&nbsp;<%=st_mobile_no%><input type="hidden" name="st_mobile_no" size="6" id="text" value=<%=st_mobile_no %>></td>
							</tr>
<%  } %>
							<tr>
								<th scope="row">이메일</th>
								<td colspan="3">&nbsp;<%=st_email%>
								</td>
							</tr>	
							<tr>
								<th scope="row">특이사항</th>
								<td colspan="3">&nbsp;<%=st_remark%>
								</td>
							</tr>
						</tbody>
					</table>
					<!-- 버튼영역 -->
					<div class="btnArea"> 
						<div class="fr">
							<span class="btn_04" title="주문취소" id="span_order_cancle">
								<a href="javascript:order_cancle();">주문취소</a>
							</span>	
							<input type="checkbox" name="card_yn" value="N" style="width:0px; height:0px; border:0px" DISABLED >
<%  if (submitFlag == true) { %>
							<span class="btn_04 mr04" title="주문하기"id="span_order_submit">
								<a href="javascript:order_submit('1')">주문하기</a>
							</span>
<%  } %>
						</div>
					</div>
					<div class="fl">
<%  if(!pre_goods_count.equals("0")){%>
						<div style="display:none">
							<input type="checkbox" name="cbx" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" DISABLED>
						</div> 
						발주일 :<input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>" class="input_type_text" readonly> &nbsp;&nbsp;&nbsp;&nbsp;
						<br/>
						<div style="display:block">
							<font color="#990000"><b>긴급발주</b></font>
							 :
							 <input type="checkbox" name="cbx1" onClick = "setCheckBox1();">&nbsp;체크 시 운영자에게 SMS통보.
						</div>
<%  }else{%>
						<b>선입고 :</b> 
						<input type="checkbox" name="cbx" onClick = "setCheckBox();" > &nbsp;&nbsp;발주일 :
						<input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>" class="input_type_text" readonly>
						<span title="검색"> <a href="javascript:CalendarCheck('from')"><img src="/resources/images/btn_calendar.gif" border="0" alt="검색"></a></span>
						 &nbsp;&nbsp;&nbsp;&nbsp;
						<br>
						<span class="fl"><font color="#990000"><b>긴급발주</b></font> :<input type="checkbox" name="cbx1" onClick = "setCheckBox1();">&nbsp;체크 시 운영자에게 SMS통보.</span>
<%  }
//SLOGIC-END
			%>
					</div> 
				</form>
				<form name="processForm" id="processForm" method="post">	
					<input type="hidden" name="buyer" id="buyer" value="" />
					<input type="hidden" name="account_type" id="account_type" value="" />
					<input type="hidden" name="end_price" id="end_price" value="" />
					<input type="hidden" name="tot_price" id="tot_price" value="" />
					<input type="hidden" name="recvFlag" id="recvFlag" value="" /> 	
					<input type="hidden" name="st_query_cart" id="st_query_cart" value="" /> 
					<input type="hidden" name="st_query_cart_date" value="" />
					<input type="hidden" name="st_query_cart_date_item" value="" />	
					<input type="hidden" name="TYPE" id="TYPE" value="" /> 
					<input type="hidden" name="COM_CODE" id="COM_CODE" value="" />
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>"> 
				</form>
			</div>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %> 
	</div>
</body>
</html>
