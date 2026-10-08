<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업(점장용)
* 기능 : 에스와이에스리테일(KRSYSR0001) 점장용 명함 정보입력 팝업
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2022-10-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); 
SessionInfo _sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfoPop.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfoPop.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_position = CommonUtil.nvl((String) request.getParameter("param_text"),"");
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

function kep_onload(){
<%	
	if(_dataList != null || _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 26){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 소속
					document.forms.contentForm.st_division.value = remark_arr[i];
				}else if(i == 1){ // 성명
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 2){ // 블로그주소
					document.forms.contentForm.st_blog_addr.value = remark_arr[i];
				}else if(i == 3){ // 지점명
					document.forms.contentForm.st_branch_name.value = remark_arr[i];
				}else if(i == 4){ // 직위 - 파라미터로 받음
				}else if(i == 5){ // 지점주소
					document.forms.contentForm.st_kor_addr.value = remark_arr[i];
				}else if(i == 6){ // 지점번호
					document.forms.contentForm.st_phone_no.value = remark_arr[i];
				}else if(i == 7){ // 팩스번호
					document.forms.contentForm.st_fax_no.value = remark_arr[i];
				}else if(i == 8){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}else if(i == 9){ // 이메일주소
					document.forms.contentForm.st_email.value = remark_arr[i];
				}else if(i == 10){ // 자기소개1
					document.forms.contentForm.st_self_info.value = remark_arr[i];
				}else if(i == 11){ // 자기소개2
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 12){ // 자기소개3
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 13){ // 자기소개4
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 14){ // 자기소개5
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 15){ // 자기소개6
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 16){ // 자기소개7
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 17){ // 자기소개8
					document.forms.contentForm.st_self_info.value += "\n"+remark_arr[i];
				}else if(i == 18){ // 경력소개1
					document.forms.contentForm.st_carr_info.value = remark_arr[i];
				}else if(i == 19){ // 경력소개2
					document.forms.contentForm.st_carr_info.value += "\n"+remark_arr[i];
				}else if(i == 20){ // 경력소개3
					document.forms.contentForm.st_carr_info.value += "\n"+remark_arr[i];
				}else if(i == 21){ // 경력소개4
					document.forms.contentForm.st_carr_info.value += "\n"+remark_arr[i];
				}else if(i == 22){ // 경력소개5
					document.forms.contentForm.st_carr_info.value += "\n"+remark_arr[i];
				}else if(i == 23){ // 계좌명 : 고정(주)에스와이에스리테일
				}else if(i == 24){ // 은행명
					document.forms.contentForm.st_bank.value = remark_arr[i];
				}else if(i == 25){ // 계좌번호
					document.forms.contentForm.st_account.value = remark_arr[i];
				}
			}
			
			limitLines("st_self_info",8,20);
			limitLines("st_carr_info",5,25);
			
			
		}else if(remark_arr.length != 1){
			// 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			var text = "<%=CommonLang.msg("MSG435") %>  ";
	     	openLayerPopText2(text,but1text,"javascript:thisPopclose2(); return false;",but1width);
// 			this.close();
			return;
		}
<%
	}
%>
}

function setReturn(){
	var division = document.forms.contentForm.st_division.value;
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var blog_addr = document.forms.contentForm.st_blog_addr.value;
	var branch_name = document.forms.contentForm.st_branch_name.value;
	var position = $("#st_position option:selected").text();
	var kor_addr = document.forms.contentForm.st_kor_addr.value;
	var phone_no = document.forms.contentForm.st_phone_no.value;
	var fax_no = document.forms.contentForm.st_fax_no.value;
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var email = document.forms.contentForm.st_email.value;
	var self_info = document.forms.contentForm.st_self_info.value;
	var carr_info = document.forms.contentForm.st_carr_info.value;
	var account_name = document.forms.contentForm.st_account_name.value;
	var bank = document.forms.contentForm.st_bank.value;
	var account = document.forms.contentForm.st_account.value;
	var remark = "";

	if(division == "SEL" || isEmpty(kor_name) || isEmpty(branch_name) || position == "선택" || isEmpty(kor_addr) || isEmpty(phone_no) || isEmpty(fax_no) || isEmpty(mobile_no) || isEmpty(account_name) || isEmpty(bank) || isEmpty(account) 
			|| isEmpty(self_info) ){
		//* 표시된 필수 명함정보를 모두 입력해주세요
		var text = "<%=CommonLang.msg("MSG863") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(containsChars(self_info, ";")){
		//자기소개란에 ; 는 사용 불가한 특수문자입니다
		var text = "<%=CommonLang.msg("MSG866") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(containsChars(carr_info, ";")){
		//경력소개란에 ; 는 사용 불가한 특수문자입니다
		var text = "<%=CommonLang.msg("MSG867") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var self_info_arr = self_info.split("\n");
	var self_info_str = "";
	for(var i=0; i<8; i++){
		if(i < self_info_arr.length){
			var st_var = self_info_arr[i];
			self_info_str += st_var + ";";
		}else{
			self_info_str += ";";
		}
		
		if(st_var.length > 20){
			//자개소개란은 한 줄에 20자 내로 기재바랍니다
			var text = "<%=CommonLang.msg("MSG868") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	var carr_info_arr = carr_info.split("\n");
	var carr_info_str = "";
	for(var i=0; i<5; i++){
		if(i < carr_info_arr.length){
			var st_var = carr_info_arr[i];
			carr_info_str += st_var + ";";
		}else{
			carr_info_str += ";";
		}
		if(st_var.length > 25){
			//경력소개란은 한 줄에 25자 내로 기재바랍니다
			var text = "<%=CommonLang.msg("MSG869") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	remark	=	division + ";"
			+	kor_name + ";"
			+	blog_addr + ";"
			+	branch_name + ";"
			+	position + ";"
			+	kor_addr + ";"
			+	phone_no + ";"
			+	fax_no + ";"
			+	mobile_no + ";"
			+	email + ";"
			+	self_info_str
			+	carr_info_str
			+	account_name + ";"
			+	bank + ";"
			+	account;
			
	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setPopupReturn(value1,value2,value3,value4,value5,value6){
	document.forms.contentForm.st_branch_name.value = value1;
	document.forms.contentForm.st_phone_no.value = value2;
	document.forms.contentForm.st_fax_no.value = value3;
	document.forms.contentForm.st_kor_addr.value = value4;
	document.forms.contentForm.st_bank.value = value5;
	document.forms.contentForm.st_account.value = value6;
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		//명함정보가 정상적으로 저장되었습니다.
		var text = "<%=CommonLang.msg("MSG864") %>  ";
     	openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
	return;
}
function thisPopClose(){
	closePopText2();
	
	var remark = document.forms.searchCondition.st_remark.value;
	opener.setPopupReturn(remark);
	this.close();
}
function thisPopClose2(){
	closePopText2();
	
	this.close();
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		var text = msg;
     	openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

//팝업함수호출
function doPop(str){
	popupSel = str;
	
	switch (str){
		case "get_branch": // 지점명
			popupSel = "get_branch";
			var st_buyer = "<%=st_buyer%>";
			var st_type = "NCIF";
			var st_gbn = "<%=CommonLang.get("HTITLE1404")%>"; //지점명 리스트
			var st_code1 = "BRAN";
			openSearchPopup("/common/getCode4PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code1="+st_code1, "1010,510,no");
			break;
	}
}

// 지점 선택 여부 확인
function checkSelDept(){
	var branch_name = document.forms.contentForm.st_branch_name.value;
	
	if(branch_name == "" || branch_name == null){
		//지점명을 먼저 선택 후 입력하여 주시기 바랍니다
		var text = "<%=CommonLang.msg("MSG865") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
		document.forms.contentForm.st_kor_addr.value = "";
		document.forms.contentForm.st_phone_no.value = "";
		document.forms.contentForm.st_fax_no.value = "";
		return;
	}
}

function limitLines(id,maxLines,maxPerLines){ //자기소개,경력소개 줄바꿈 제한
	const el = document.getElementById(id);
	
	el.addEventListener("keydown",function(e){
		const maxlinesCount = getLineCount(this); //줄바꿈 제한
		const maxPerLinesLength = getCurrentLineLength(this); //한 줄 길이 제한
		
		if(e.key === "enter"){
			
			if(maxlinesCount >= maxLines){
				e.preventDefault();
			}
			
			return;
		}
		
		if(e.ctrlKey || e.metaKey || e.altKey) return;
		
		if(e.key.length === 1 && maxPerLinesLength >= maxPerLines){
			e.preventDefault();
		}
		
	});
	
	el.addEventListener("input",function(){
		let lineData = this.value.split("\n");
		let modifyFlag = false;
		
		if(lineData.length > maxLines){
			lineData = lineData.slice(0,maxLines);
			modifyFlag = true;
		}
		
		lineData = lineData.map(function(line){if(line.length > maxPerLines){ modifyFlag = true; return line.slice(0,maxPerLines)} return line});
		const newValue = lineData.join("\n");
		
		
		if(modifyFlag){
			const cursor = this.selectionStart;
			this.value = newValue;
			
			this.selectionStart = this.selectionEnd = Math.min(cursor,newValue.length);
		}
	});
}

function getCurrentLineLength(textarea){
	const pos = textarea.selectionStart;
	const textBeforeCursor = textarea.value.substring(0,pos);
	return textBeforeCursor.split("\n").pop().length;
}
function getLineCount(textarea){
	return textarea.value.split("\n").length;
}

</script>
<body onload="kep_onload()">
<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
	<input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>">
	<input type="hidden" name="st_remark" id="st_remark" value="">
</form>
<form name="contentForm" id="contentForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1368")%><!--명함 정보 입력-->
  <span class="font500 font15px F6495F pt05">
  * <%=CommonLang.get("HTITLE1388")%><!-- 소속: 정직원 -> ㈜SYS Retail, 협력사 직원 -> (공란) 선택 -->
  </br>
  * <%=CommonLang.get("HTITLE1389")%><!-- 사진 유의사항: 뒷배경 단색, 유니폼 착용, 3x5 이미지 파일. -->
  </br>
  <%=CommonLang.get("HTITLE1390")%><!-- (장바구니 내"파일추가" 버튼 이용하여 사진 첨부) -->
  </br>
  * <%=CommonLang.get("HTITLE1391")%><!-- 영문 성명 기입 유의사항: 각 이름 첫영문자 대문자로 표기 (Hong Suk Su) -->
  </br>
  * <%=CommonLang.get("HTITLE1392")%><!-- 협력사 직원 각 메이커 전문상담사 선택, 미반영된 직위는 구매혁신그룹 요청 -->
  </span>
  </div>
  </br>
  </br>
  </br>
  </br>
  <table  class="PopupSearchTableNoline mt10" width="880px"    >
	<colgroup>
      <col width="150px" />
      <col width="280px" />
      <col width="130px" />
      <col width="290px" />
	</colgroup>
	<tr>
		<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1369")%><!--소속--></th>
		<td><select id="st_division" name="st_division" class="Select40" style="width:262px" >
				<option value='SEL' selected><%=CommonLang.get("HTITLE178")%><!-- 선택 --></option>
				<option value='(주)SYS Retail'><%=CommonLang.get("HTITLE1370")%><!--★정직원★(주)SYS Retail--></option>
				<option value=''><%=CommonLang.get("HTITLE1371")%><!--★협력사직원★(공란)--></option>
        </select></td>
	</tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1385")%><!--성명--></th>
      <td><input class="input40" style="width:240px" name="st_kor_name" id="st_kor_name" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1401")%><!--블로그주소--></th>
      <td><input class="input40" style="width:295px" name="st_blog_addr" id="st_blog_addr" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1374")%><!--지점명--></th>
      <td>
      	<div class="SearchPopupInput38" style="width:260px;">
        <input type="text" name="st_branch_name" id="st_branch_name" style=" width:78%;" value="" readonly>
        <button type="button" onclick="javascript:doPop('get_branch'); return false;"></button> </div> </td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1375")%><!--직위--></th>
      <td><select id="st_position" name="st_position" class="Select40" style="width:316px" >
          <%= CommonUtil.getTextComboList(st_buyer,"SEL","BRPS","ICOMCOD2","CODE",st_position)%>
        </select></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1376")%><!--지점주소--></th>
      <td colspan="3"><input class="input40" style="width:707px" name="st_kor_addr" id="st_kor_addr" type="text" onchange="checkSelDept();"/></td> 
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1377")%><!--지점번호--></th>
      <td><input class="input40" style="width:240px" name="st_phone_no" id="st_phone_no" type="text" onchange="checkSelDept();"/></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE43")%><!-- 팩스번호 --></th>
      <td><input class="input40" style="width:295px" name="st_fax_no" id="st_fax_no" type="text" onchange="checkSelDept();" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1378")%><!--휴대폰번호--></th>
      <td><input class="input40" style="width:240px" name="st_mobile_no" id="st_mobile_no" type="text" /></td>
      <th> &nbsp;&nbsp;&nbsp;<%=CommonLang.get("HTITLE1379")%><!--이메일주소--></th>
      <td><input class="input40" style="width:295px" name="st_email" id="st_email" type="text" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1402")%><!--자기소개--></th>
      <td>
      	<textarea rows="8" name="st_self_info" id="st_self_info" style="width:240px; height:130px; overflow-y:auto; border:1px solid #dedede;"></textarea>
      </td>
      <th> &nbsp;&nbsp;&nbsp;<%=CommonLang.get("HTITLE1403")%><!--경력소개--></th>
      <td>
      	<textarea rows="5" name="st_carr_info" id="st_carr_info" style="width:295px; height:130px; overflow-y:auto; border:1px solid #dedede;"></textarea>
      </td>
    </tr>
    
    <tr>
		<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1380")%><!--지점공식 계좌명--></th>
		<td><input class="input40" name="st_account_name" id="st_account_name" value="(주)에스와이에스리테일" style="width:240px" type="text" readOnly/></td>
	</tr>
	<tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1381")%><!--공식계좌 은행명--></th>
      <td><input class="input40" style="width:240px" name="st_bank" id="st_bank" type="text" /></td>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1382")%><!--지점공식 계좌번호--></th>
      <td><input class="input40" style="width:295px" name="st_account" id="st_account" type="text" /></td>
    </tr>
    
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:150px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE1383")%><!--확인 후 시안보기--></button> 
  </div> 
</div><!-- wrapPopup 끝-->  
</form>
</body>
</html>
