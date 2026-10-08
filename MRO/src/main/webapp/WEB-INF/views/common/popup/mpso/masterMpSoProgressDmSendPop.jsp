<%--
**********************************************
* 메뉴 : 주문관리 > 주문진행 > 고객사DM발송
* 화면 : 견적 DM 발송
* 기능 : 견적 DM 발송
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2024-06-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String userTel = (String)_sessionInfo.getTel();
	String userEmail = (String)_sessionInfo.getEmail();
	String userName = (String)_sessionInfo.getUserNameLoc();
	
	String st_polist = CommonUtil.nvl((String) request.getParameter("st_polist"),"");	
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode					= "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel					= "";



// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
		
	var initsheet = {};
	initsheet.Cols = [
		{Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"},
		{Align:"Center",	Width:60,	Edit:true,	EditLen:40,		Hidden:false,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"},
		{Align:"Center",	Width:200,	Edit:true,	EditLen:160,	Hidden:false,	Type:"Text",		Header:"수신자",		SaveName:"RECV_NAME"},
		{Align:"Center",	Width:370,	Edit:true,	EditLen:250,	Hidden:false,	Type:"Text",		Header:"이메일",		SaveName:"EMAIL"},
		{Align:"Center",	Width:200,	Edit:true,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"휴대폰 번호",	SaveName:"MOBILE"}
	];

	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);

	
	doAction('search');
}
//기능함수
function doAction(str) {
	switch (str) {
		case "search": // 수신 정보 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpso/getMasterMpSoProgressDmSendPopUserList.do", "");
			break;
		case "save": // 발송 & 변경정보 저장
			// 수신정보 체크
			if(validSendCnt() && validSendCheck()){
				// sms 전송 종류 set
				setSmsKind();
				// 발송 전 개행 replace				
				var remark = $('#st_mail_remark').val() + "<br>" + $('#st_mail_remark2').val();
				var brCnt = remark.match(/(\n|\r\n)/g);
				if(brCnt != null ) {
					if(brCnt.length > 6) {
						alert("운영자 메모 입력 시 개행은 최대 6회까지 가능합니다.");
						return;
					}
				}
				remark = remark.replaceAll(/(\n|\r\n)/g, '<br>');
				$('#st_mail_remark').val(remark);
				// dm 전송
				kepSave(document.searchCondition ,mySheet , "/mpso/saveMasterMpSoProgressDmSend.do", "SELECTED");
			}
			break;
	}
}


//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
		$('#st_mail_remark').val('안녕하세요. 코리아이플랫폼의 <%=userName %>입니다.');
	}
	
	if(code>0){		
		self.close();
	}
}

function addrows() {
	var rows = mySheet.DataInsert(-1);
}

function delrows() {
	var totRow = mySheet.RowCount();
	mySheet.RowDelete(totRow, 0);
}

// 수신자 확인
function validSendCnt(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	

	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 수신자가 없습니다.");
		return false;
	}
	
	if($('#st_mail_check_flag').val() == "N"){
		alert("발신수단 E-mail 체크를 확인하시기 바랍니다.");
		return false;
	}
	
	return true;
}

/**
 * sms 발송시 sms mms 종류 set
 */
function setSmsKind(){
	// init
	const smsContents = $('#st_sms_contents').val();
	var tempChar = "";										// TextArea의 문자를 한글자씩 담는다
	var countChar = 0;										// 한글자씩 담긴 문자를 카운트 한다
	var tempHangul = 0;										// 한글을 카운트 한다

	// 글자수 바이트 체크를 위한 반복
	for(var i = 0 ; i < smsContents.length; i++) {
		tempChar = smsContents.charAt(i);
		// 한글일 경우 2 추가, 영문일 경우 1 추가
		if(escape(tempChar).length > 4) {
			countChar += 2;
			tempHangul++;
		} else {
			countChar++;
		}
	}

	if( countChar > 90){
		document.forms.searchCondition.st_kind.value = "M";
	}else{
		document.forms.searchCondition.st_kind.value = "S";
	}
}

// 수신정보 입력값 체크
function validSendCheck(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	

	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 수신자가 없습니다.");
		return false;
	}
	
	
	if (arrRow.length > 5) {		
		alert("수신 가능 인원 최대 5명입니다. 5명 이하로 선택 바랍니다.");
		return false;
	}
	
	if($('#st_mail_check_flag').val() == "N"){
		alert("발신수단 E-mail 체크를 확인하시기 바랍니다.");
		return false;
	}

	if($('#st_mail_subject').val() == ""){
		alert("메일 제목을 입력하세요.");
		return;
	}
	
	for(var i=0; i<arrRow.length;i++){
		var st_recv_email = mySheet.GetCellValue(arrRow[i],"EMAIL");
		var st_recv_mobile = mySheet.GetCellValue(arrRow[i],"MOBILE");
		
		if ($("#mailCheck").is(':checked') == true){
			// 이메일 빈값 체크
			if(kepIsValueNull(st_recv_email)){
				alert(arrRow[i]+"번째 이메일이 비어있습니다.");
				mySheet.SelectCell(arrRow[i], "EMAIL");
				return false;
			}
			
			// 이메일 형식 체크
			if(!kepIsValidEmailValue(st_recv_email)){
				alert(arrRow[i]+"번째 이메일 형식에 오류가 있습니다.");
				mySheet.SelectCell(arrRow[i], "EMAIL");
				return false;
			}
			if (i > 0){
				if (mySheet.GetCellValue(arrRow[0],"EMAIL") == mySheet.GetCellValue(arrRow[i],"EMAIL")){
					alert("동일한 이메일 주소가 있습니다. 중복 확인하여 주시기 바랍니다.");
					return false;
				}
			}			
		}
		
		if ($("#smsCheck").is(':checked') == true){
			// 모바일 빈값 체크
			if(kepIsValueNull(st_recv_mobile)){
				alert(arrRow[i]+"번째 휴대폰 번호가 비어있습니다.");
				mySheet.SelectCell(arrRow[i], "MOBILE");
				return false;
			}
			
			// 모바일 형식 체크
			if(!kepIsNumChkStr(st_recv_mobile, 4) || st_recv_mobile.substr(0,3) != "010" || st_recv_mobile.length < 10){
				alert(arrRow[i]+"번째 휴대폰 번호 형식에 오류가 있습니다.");
				mySheet.SelectCell(arrRow[i], "MOBILE");
				return false;
			}
			
			// - 갯수 확인
			var find_str = /-/g;
			var matches = st_recv_mobile.match(find_str);
			
			if(matches){
				var count = matches.length;
				if(count != 2){
					alert(arrRow[i]+"번째 휴대폰 번호 형식에 오류가 있습니다.");
					mySheet.SelectCell(arrRow[i], "MOBILE");
					return false;
				}
			}else{
				alert(arrRow[i]+"번째 휴대폰 번호 형식에 오류가 있습니다.");
				mySheet.SelectCell(arrRow[i], "MOBILE");
				return false;
			}
			if (i > 0){
				if (mySheet.GetCellValue(arrRow[0],"MOBILE") == mySheet.GetCellValue(arrRow[i],"MOBILE")){
					alert("동일한 휴대폰 번호가 있습니다. 중복 확인하여 주시기 바랍니다.");
					return false;
				}
			}
		}
	}
		
		
		
		// KEP발신자 이메일 미포함 체크(MAILSEND INSERT 키 충돌 방지)
		if($('#st_send_mail').val() == mySheet.GetCellValue(arrRow[i],"EMAIL")){
			alert("KEP 발송 담당자 본인의 주소는 추가하지 마세요.(자동 추가 발송됨)");
			return false;
		}
	
	
	return true;
}

function checkChange(){
	if ($("#mailCheck").is(':checked') == true){
		$('#st_mail_check_flag').val("Y");
		$('#st_mail_remark').css('background-color','');
		$('#st_mail_remark').attr('disabled', false);
	} else {
		$('#st_mail_check_flag').val("N");
		$('#st_mail_remark').css('background-color','lightgray');
		$('#st_mail_remark').attr('disabled', true);
	}
	
	if ($("#smsCheck").is(':checked') == true){
		$('#st_sms_check_flag').val("Y");
	} else {
		$('#st_sms_check_flag').val("N");
	}
}

//미리보기 팝업
function doPreviewPop(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	

	if($('#st_mail_check_flag').val() == "N"){
		alert("발신수단 E-mail 체크를 확인하시기 바랍니다.");
		return;
	}
	
	if($('#st_mail_subject').val() == ""){
		alert("메일 제목을 입력하세요.");
		return;
	}
	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 수신자가 없습니다.");
		return false;
	}
	
	for(var i=0; i<arrRow.length;i++){
		// KEP발신자 이메일 미포함 체크(MAILSEND INSERT 키 충돌 방지)
		if($('#st_send_mail').val() == mySheet.GetCellValue(arrRow[i],"EMAIL")){
			alert("KEP 발송 담당자 본인의 주소는 추가하지 마세요.(자동 추가 발송됨)");
			return false;
		}
	}
	
	var fixSendMail = "운영자<sender@koreab2b.com>";
	
	
	var st_polist = $("#st_polist").val();	
	var st_mail_subject = $("#st_mail_subject").val();
	var st_send_user_name = "<%=userName%>";
	var st_send_user_mail = "<%=userEmail%>";
	var st_send_user_tel = "<%=userTel%>";
	var st_send_mail = fixSendMail;
	var st_recv_mail = mySheet.GetCellValue(arrRow[0], "RECV_NAME") + "<" + mySheet.GetCellValue(arrRow[0], "EMAIL") + ">";
	var st_mail_remark = $("#st_mail_remark").val() + "<br>" + $("#st_mail_remark2").val();
	st_mail_remark = st_mail_remark.replaceAll(/(\n|\r\n)/g, '<br>'); // 개행 시 <br> 태그로 replace
	var st_mail_contents = $("#st_mail_contents").val();
	
	var st_form_name = "ProgressDmSendPreviewPopForm";
	var st_popup_url = "/mpso/showMasterMpSoProgressDmPreviewPop.do";
	var st_popup_param = 
						"st_polist@@"+ st_polist + "^||^" +						
						"st_mail_subject@@"+ st_mail_subject + "^||^" +
						"st_send_user_name@@" + st_send_user_name + "^||^" +
						"st_send_user_mail@@" + st_send_user_mail + "^||^" +
						"st_send_user_tel@@" + st_send_user_tel + "^||^" +
						"st_send_mail@@" + st_send_mail + "^||^" +
						"st_recv_mail@@" + st_recv_mail + "^||^" +
						"st_mail_remark@@" + st_mail_remark 
	;
	
	var st_popup_option = "1040,850,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
}

</script>
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height: 794px;">
		<div id="popHeader">
			<h1 class="title">고객사 DM 발송</h1>
			<p class="popClose">
				<a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
			</p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<form name="searchCondition" id="searchCondition" method=post>
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME"> 
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
				<input type="hidden" id="st_polist" name="st_polist" value="<%=st_polist%>">								
				<input type="hidden" id="st_mail_check_flag" name="st_mail_check_flag" value="Y">
				<input type="hidden" id="st_sms_check_flag" name="st_sms_check_flag" value="N">				
				<input type="hidden" id="st_send_tel" name="st_send_tel" value="<%=userTel%>">
				<input type="hidden" id="st_send_mail" name="st_send_mail" value="<%=userEmail%>">
				<input type="hidden" id="st_kind" name="st_kind" value="">
				<input type="hidden" id="st_org_mail_remark" name="st_org_mail_remark" value="">			

				<!-- 발신 수단 선택 영역 -->
				<h2>발신 정보</h2>
				<table class="cont_t_list06 mb15" summary="발신 정보"
					style="width: 100%;">
					<caption>발신 정보</caption>
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">발신수단</th>
							<td>
								<div>
									<input type="checkbox" id="mailCheck" name="mailCheck" checked onclick="javascript:checkChange();">
									<span>E-mail</span>
								</div>
							</td>
							<td colspan="3">
								<div>
									<input type="checkbox" id="smsCheck" name="smsCheck" onclick="javascript:checkChange();">
									<span>SMS</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>

				<!-- 이메일 정보 영역 -->
				<div class="mail_area">
					<h2>이메일 정보	</h2>
					<table class="cont_t_list02 mb15" summary="발신 정보" style="width: 100%;">
						<caption>이메일 정보</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">메일 발송 주소</th>
								<td style="text-align: left;  padding-left: 3px;"><%=userEmail %></td>
							</tr>			

							<tr>
								<th scope="row">메일 제목</th>
								<td>
									<div>
										<input type="text" id="st_mail_subject" name="st_mail_subject" class="input_type_text" value=""  placeholder="메일 제목 입력" style="width: 99%;">
									</div>
								</td>
							</tr>

							<tr>
								<th scope="row">운영담당자 메모</th>								
								<td>
									<input type="text" style="border: aliceblue; width: 99%;" id="st_mail_remark" name="st_mail_remark" class="input_type_text" value="안녕하세요. 코리아이플랫폼의 <%=userName %>입니다." readonly>
									<textarea rows="3" id="st_mail_remark2" name="st_mail_remark2" placeholder="운영자 메모 입력, 최대 500자 입력 가능" maxlength="500" style="width: 99%; margin: 5px 0px;"></textarea>
								</td>
							</tr>
							
							<tr>
								<th scope="row">발주내역정보</th>
								<td>
									<table  class="cont_t_list06"  style="width:100%">
					                <caption>상세내역</caption>
					                <colgroup>
					                    <col width="12%" />
					                    <col width="12%" />
					                    <col width="18%" />
					                    <col width="*" />
					                    <col width="9%" />
					                    <col width="9%" />
					                    <col width="9%" />
					                    <col width="11%" />
					                </colgroup>
	                <thead>
	                    <tr>
	                        <th scope="col" style="text-align: center;">발주번호</th>
	                        <th scope="col" style="text-align: center;">품목코드</th>
	                        <th scope="col" style="text-align: center;">품명</th>
	                        <th scope="col" style="text-align: center;">규격</th>
	                        <th scope="col" style="text-align: center;">수량</th>
	                        <th scope="col" style="text-align: center;">단가</th>
	                        <th scope="col" style="text-align: center;">금액</th>
	                        <th scope="col" style="text-align: center;">요청자</th>
	                    </tr>							
									<tbody>
									
	<%

	if (_dataList == null || _dataList.size() == 0){
		
	} else {
									
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> _tmp = _dataList.get(j);
	%>
							<tr>
								<td class="left"><%=CommonUtil.nvl(_tmp.get("PO_NO"))%></td>
								<td class="left"><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></td>
								<td class="left"><%=CommonUtil.nvl(_tmp.get("DESCRIPTION"))%></td>
								<td class="left"><%=CommonUtil.nvl3(_tmp.get("SPECIFICATION"),"")%></td>
								<td class="right"><%=CommonUtil.nvl3(_tmp.get("PO_QTY"),"")%></td>								
								<td class="right"><%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%></td>
								<td class="right"><%=CommonUtil.formatNumber(_tmp.get("ITEM_AMT"),true,0,3)%></td>
								<td class="left"><%=CommonUtil.nvl3(_tmp.get("REQ_USER_NAME"),"")%></td>								
							</tr>
	<% } } %>
									</tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- SMS 정보 영역 -->
				<div class="sms_area">
					<h2>SMS 정보</h2>
					<table class="cont_t_list06 mb15" summary="SMS 정보"
						style="width: 100%;">
						<caption>SMS 정보</caption>
						<colgroup>
							<col width="20%" />
							<col width="80%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">발신 번호</th>
								<td>
									<div>
										<input type="text" id="st_sms_send_info" name="st_sms_send_info" value="<%= userName %> ( <%= userTel %> )" style="width: 33%; font-size:12px; border: 0px; color:#666666; margin: 5px 0px;" readonly>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">SMS발송문구</th>
								<td>
									<div>
										<textarea id="st_sms_contents" name="st_sms_contents" maxlength="200" style="width: 99%; font-size:12px; border: 0px; color:#666666; margin: 5px 0px;"  disabled="disabled">[koreaB2B.com] 안녕하십니까. 코리아e플랫폼입니다. 문의사항 메일 드렸으니 확인 부탁드립니다. 감사합니다.</textarea>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- 수신 정보 -->
				<div class="info_area">
					<h2>수신 정보</h2>
					<!--grid-->
					<div class="ib_product" style="border-top: 2px solid #3c639c">
						<script type="text/javascript">
							createIBSheet("mySheet", "100%", "166px");
						</script>
					</div>
				</div>
			</form>
			<!--버튼영역-->
			<div class="btnArea">
				<span class="fl">
					<span class="btn_03 mr02"><a href="javascript:addrows();">행추가</a></span>
					<span class="btn_03 mr02"><a href="javascript:delrows();">행삭제</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_03 mr02"><a href="javascript:doPreviewPop();">미리보기</a></span> 
					<span class="btn_02 mr02"><a href="javascript:doAction('save');">발송</a></span>
  				</span>
  			</div>
		</div>
	</div>
</body>
</html>
