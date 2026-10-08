<%--
**********************************************
* 메뉴 : 
* 화면 : 동화산업 
* 기능 : 동화산업  장바구니 관리번호 선택 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2020-12-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");
String st_item_no = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");
//팝업 수정 불가
String st_close_yn = CommonUtil.nvl((String) request.getParameter("st_close_yn"),"N");

String st_user_id             = _sessionInfo.getUserId();
String st_user_name           = _sessionInfo.getUserNameLoc();

String plantCode = ""; //플랜트
String saveLoc = ""; //저장위치
String Account = ""; //계정구분
String Asset = "";//AssetCode
String AssetName = "";//AssetName
String costCenter = "";//cost Center
String costCenterName = "";//cost Center Name
String unloadingPt = "";//unloading point
String glAccount = ""; //G/L Account
String Recipient = ""; //Recipient
String glAccount_fill_flag = "N";//G/L Account 필수입력 여부

if("4".equals(st_item_no.substring(0, 1))){ // 4로 시작하는 품목코드
	glAccount_fill_flag = "Y";
}

if(!st_ref_no.equals("")){
	String mg_arr[] = st_ref_no.split("%%");
	plantCode = mg_arr[0];
	saveLoc = mg_arr[1];
	if(mg_arr.length == 2){
		Account = "";	
	}else{
		Account = mg_arr[2];
		if(!Account.equals("")|| Account != null){
			Asset = mg_arr[3];
			AssetName = mg_arr[4];
			if(Asset.length() == 0){
				costCenter = mg_arr[5];
				costCenterName = mg_arr[6];
				unloadingPt = mg_arr[7];
				glAccount = mg_arr[8];
				Recipient = mg_arr[9];	
			}
		}		
	}
}
%>

<script type="text/javascript">


// 최초 화면 함수 
function kep_onload(){
	var st_buyer = $("#st_buyer").val();
	//콤보 데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_plant_code','getComboCod2',st_buyer,'C020','SEL','');
	kepAjaxCommonQueryIdSearchTwoCombo('st_gl_account','getComboCod2',st_buyer,'C021','SEL','');
	$("#st_plant_code").val("<%=plantCode%>");
	$("#st_gl_account").val("<%=glAccount%>");
	
	//계정에 따른 초기 셋팅
	var account = "<%=Account%>";
	var buyer = "<%=st_buyer%>";

 	if(account == "" && buyer == "KRDONG1109"){
		account ="K";
		ChangeAttr(account);
	} 
 	if($("#st_unloading_point").val()== "")	$("#st_unloading_point").val("자재창고");
 	if($("#st_recipient").val()== "") $("#st_recipient").val("<%=st_user_name%>"); 	

 	if(account == "K"){
		$("#st_asset_name_href").removeAttr("href");
		$("#st_cost_center_name_href").attr("href","javascript:getCostCenterPop()");
		$("#st_gl_account").attr("disabled",false);
		$("#st_asset_name").css("background-color", "#b3b3b3");
		$("#st_cost_center_name").css("background-color", "#ffffff");
		$("#st_gl_account").css("background-color", "#ffffff");
	}else if(account == "A"){
		$("#st_cost_center_name_href").removeAttr("href");
		$("#st_asset_name_href").attr("href","javascript:getAssetPop()");
		$("#st_gl_account").attr("disabled",true);
		$("#st_asset_name").css("background-color", "#ffffff");
		$("#st_cost_center_name").css("background-color", "#b3b3b3");
		$("#st_gl_account").css("background-color", "#b3b3b3");
	}else{
		$("#st_asset_name_href").removeAttr("href");
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_cost_center_name_href").removeAttr("href");
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_gl_account").attr("disabled",true);
		$("#st_asset_name").css("background-color", "#b3b3b3");
		$("#st_cost_center_name").css("background-color", "#b3b3b3");
		$("#st_gl_account").css("background-color", "#b3b3b3");
	}
 	
	//팝업 수정 불가
	var st_close_yn = "<%=st_close_yn%>";
	//팝업수정일때 추가 수정
	if(st_close_yn =="Y"){
		$("#st_plant_code").attr("disabled",true);
		$("#st_save_loc").attr("readonly",true);
		$("#st_account").attr("disabled",true);
		$("#st_asset_name_href").removeAttr("href");
		$("#st_cost_center_name_href").removeAttr("href");
		$("#st_unloading_point").attr("readonly",true);
		$("#st_gl_account").attr("disabled",true);
		$("#st_recipient").attr("readonly",true);
	}
	
}

function setPopupReturn(code, text){
	 
	if(user_flag == "Asset"){
		document.forms.buyer_pr_display_pop.st_asset.value = code;
		document.forms.buyer_pr_display_pop.st_asset_name.value = text;
	}else if(user_flag == "costCenter"){
		document.forms.buyer_pr_display_pop.st_cost_center.value = code;
		document.forms.buyer_pr_display_pop.st_cost_center_name.value = text;
	}
}

function getCostCenterPop(){
	user_flag = "costCenter";
	var param = encodeURI("?open=Y&com_code=<%=st_buyer%>&type=C022&codeGubun=geticomcod2Pop&title=CostCenterList");
	openSearchPopup('/common/commonIcomcod2List.do', param, "500,500,no");
}
function getAssetPop(){
	user_flag = "Asset";
	var param = encodeURI("?open=Y&com_code=<%=st_buyer%>&type=C023&codeGubun=geticomcod2Pop&title=AssetList");
	openSearchPopup('/common/commonIcomcod2List.do', param, "500,500,no");
}

//장바구니에 반영
function setRefList(){
	var st_plant_code = document.forms.buyer_pr_display_pop.st_plant_code.value;
	var st_save_loc = document.forms.buyer_pr_display_pop.st_save_loc.value; 
	var st_account = document.forms.buyer_pr_display_pop.st_account.value; 
	var st_asset = document.forms.buyer_pr_display_pop.st_asset.value;
	var st_asset_name = document.forms.buyer_pr_display_pop.st_asset_name.value;
	var st_cost_center = document.forms.buyer_pr_display_pop.st_cost_center.value;
	var st_cost_center_name = document.forms.buyer_pr_display_pop.st_cost_center_name.value;
	var st_unloading_point = document.forms.buyer_pr_display_pop.st_unloading_point.value;
	var st_gl_account = document.forms.buyer_pr_display_pop.st_gl_account.value;
	var st_recipient = document.forms.buyer_pr_display_pop.st_recipient.value;
	
	if(st_plant_code == ""){
		alert("플랜트를 선택하십시오.");
		document.forms.buyer_pr_display_pop.st_plant_code.focus();
		return;
	}
	if(st_save_loc == ""){
		alert("저장위치를 입력하십시오.");
		document.forms.buyer_pr_display_pop.st_save_loc.focus();
		return;
	}
	if(st_account == "K"){
		if(st_cost_center == ""){
			alert("Cost Center을 선택하십시오.");
			document.forms.buyer_pr_display_pop.st_cost_center_name.focus();
			return;
		}
		if(st_unloading_point == ""){
			alert("Unloading Point를 입력하십시오.");
			document.forms.buyer_pr_display_pop.st_unloading_point.focus();
			return;
		}
		if(st_gl_account == ""){
			alert("G/L Account를 선택하십시오.");
			document.forms.buyer_pr_display_pop.st_gl_account.focus();
			return;
		}
		if(st_recipient == ""){
			alert("Recipient를 입력하십시오.");
			document.forms.buyer_pr_display_pop.st_recipient.focus();
			return;
		}
	}
	else if(st_account == "A"){
		if(st_asset == ""){
			alert("Asset을 선택하십시오.");
			document.forms.buyer_pr_display_pop.st_asset_name.focus();
			return;
		}
	}
	
	if("<%=glAccount_fill_flag%>" == "Y"){
		if(st_gl_account == ""){
			alert("4***** 품목코드는 G/L Account가 필수입력입니다.");
			return;
		}
	}
	
	var st_ref_no = st_plant_code+"%%"+st_save_loc+"%%"+st_account+"%%"+st_asset+"%%"+st_asset_name+"%%"+st_cost_center+"%%"+st_cost_center_name+"%%"+st_unloading_point+"%%"+st_gl_account+"%%"+st_recipient;
	document.forms.buyer_pr_display_pop.st_ref_no.value = st_ref_no;
	opener.setRefInfo('<%=st_row%>', st_ref_no, st_ref_no);
	self.close();
	 
}

//선택하는 계정에 따라 설정하기
function ChangeAttr(flag){
	if(flag == "K"){
		$("#st_asset_name_href").removeAttr("href");
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_cost_center_name_href").attr("href","javascript:getCostCenterPop()");
		$("#st_gl_account").attr("disabled",false);
		$("#st_gl_account").val("");
		$("#st_asset_name").css("background-color", "#b3b3b3");
		$("#st_cost_center_name").css("background-color", "#ffffff");
		$("#st_gl_account").css("background-color", "#ffffff");

	}else if(flag == "A"){
		$("#st_cost_center_name_href").removeAttr("href");
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_asset_name_href").attr("href","javascript:getAssetPop()");
		$("#st_gl_account").attr("disabled",true);
		$("#st_gl_account").val("");
		$("#st_asset_name").css("background-color", "#ffffff");
		$("#st_cost_center_name").css("background-color", "#b3b3b3");
		$("#st_gl_account").css("background-color", "#b3b3b3");

	}else{
		$("#st_asset_name_href").removeAttr("href");
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_cost_center_name_href").removeAttr("href");
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_gl_account").attr("disabled",true);
		$("#st_gl_account").val("");
		$("#st_asset_name").css("background-color", "#b3b3b3");
		$("#st_cost_center_name").css("background-color", "#b3b3b3");
		$("#st_gl_account").css("background-color", "#b3b3b3");
	}
}

</script> 
<body onload="kep_onload()">
<form name="buyer_pr_display_pop" id="buyer_pr_display_pop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer %>">
	<input type="hidden" name="st_ref_no" id="st_ref_no" value="<%=st_ref_no %>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">MRO 구매품목 관리항목 등록 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
 
 
	<table  class="board_write"  style="width:100%">
		<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="20%" />
		<col width="30%" />
		</colgroup>
		<tr>
			<th scope="row">플랜트</th>
			<td>
				<select id="st_plant_code" name="st_plant_code" style="width:80%"></select>
			</td>
        	<th scope="row">저장위치</th>
        	<td>
				<input type="text" id="st_save_loc" name="st_save_loc" class="input_type_text" style="width:80%;" id="text" value="<%=!"".equals(saveLoc)?saveLoc:"5110"%>">
			</td>
		</tr>
		<tr>
			<th scope="row">계정구분</th>
			<td>
				<select id="st_account" name="st_account" onChange="ChangeAttr(this.value)" style="width:80%" > 
				<%if(!st_buyer.equals("KRDONG1109")){ %>
					<option value=""> </option>
				<%}%>	
				<option value="K" <%=!"".equals(Account)?"K".equals(Account)?"selected":"":""%>>K(Cost Center)</option>
				<option value="A" <%=!"".equals(Account)?"A".equals(Account)?"selected":"":""%>>A(Asset)</option>
				</select>
			</td>
			<th scope="row">Asset</th>
			<td>
				<input type="hidden" id="st_asset" name="st_asset" style="width:60%" value="<%=!"".equals(Asset)?Asset:""%>" class="input_type_text" readonly>
				<a href="javascript:getAssetPop()" id="st_asset_name_href">
				<input type="text" id="st_asset_name" name="st_asset_name" style="width:60%;cursor:pointer;" value="<%=!"".equals(AssetName)?AssetName:""%>" class="input_type_text" readonly>
				<img src="/resources/images/btn_search03.gif">
				</a>
			</td>
		<tr>
			<th scope="row">Cost Center</th>
			<td>
				<input type="hidden" id="st_cost_center" name="st_cost_center" style="width:60%" value="<%=!"".equals(costCenter)?costCenter:""%>" class="input_type_text">
				<a href="javascript:getCostCenterPop();" id="st_cost_center_name_href">
				<input type="text" id="st_cost_center_name" name="st_cost_center_name" style="width:60%;cursor:pointer;" value="<%=!"".equals(costCenterName)?costCenterName:""%>" class="input_type_text" readonly>
				<img src="/resources/images/btn_search03.gif">
				</a>
			</td>
			<th scope="row">Unloading Point</th>
			<td>
				<input type="text" id="st_unloading_point" name="st_unloading_point" class="input_type_text" style="width:80%;" id="text" value="<%=!"".equals(unloadingPt)?unloadingPt:""%>">
			</td>
		</tr>
		<tr>
			<th scope="row">G/L Account</th>
			<td>
				<select id="st_gl_account" name="st_gl_account" style="width:80%"></select>
			</td>
			<th scope="row">Recipient</th>
			<td>
				<input type="text" id="st_recipient" name="st_recipient" class="input_type_text" style="width:40%" value="<%=!"".equals(Recipient)?Recipient:""%>">
			</td>
		</tr>
	</table>
	 
         
    <div class="btnArea">
    <%if(st_close_yn.equals("N")){ %>
		<div class="fr">
			<span class="btn_03 mr04"><a href="javascript:setRefList();">확인</a>
			</span>
		</div>
	<%}%>		
	</div>
    </div>        
    



</div>
</form>

</body>
</html>
