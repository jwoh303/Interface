<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form3)
* 기능 : 관리번호 팝업(form3)
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");


String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");
String st_item_no = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");  //  (조회조건)
//팝업 수정 불가
String st_close_yn = CommonUtil.nvl((String) request.getParameter("st_close_yn"),"N");
String glAccount_fill_flag_all = CommonUtil.nvl((String) request.getParameter("glAccount_fill_flag_all"),"");

String st_user_id             = sessionInfoPop.getUserId();
String st_user_name           = sessionInfoPop.getUserNameLoc();

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

if(glAccount_fill_flag_all.equals("")){
	if("4".equals(st_item_no.substring(0, 1))){ // 4로 시작하는 품목코드
		glAccount_fill_flag = "Y";
	}
}else{
	glAccount_fill_flag = glAccount_fill_flag_all;
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
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";


var st_ref_pr_no = "";
var st_ref_pr_no_text = "";
var st_buyer = "<%=st_buyer%>";

function kep_onload_view(){
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
		$("#st_asset_name_href").prop("disabled",true);
		$("#st_cost_center_name_href").prop("disabled",false);
		$("#st_gl_account").attr("disabled",false);
		$("#st_asset_div").attr("class","SearchPopupInput38disabled");
		$("#st_cost_center_div").attr("class","SearchPopupInput38");
		
		$("#st_asset_name").prop("disabled",true);
		$("#st_cost_center_name").prop("disabled",false);
		
	}else if(account == "A"){
		$("#st_asset_name_href").prop("disabled",false);
		$("#st_cost_center_name_href").prop("disabled",true);
		$("#st_gl_account").attr("disabled",true);
		$("#st_asset_div").attr("class","SearchPopupInput38");
		$("#st_cost_center_div").attr("class","SearchPopupInput38disabled");
		
		$("#st_asset_name").prop("disabled",false);
		$("#st_cost_center_name").prop("disabled",true);
		
	}else{
		$("#st_asset_name_href").prop("disabled",true);
		$("#st_cost_center_name_href").prop("disabled",true);
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_gl_account").attr("disabled",true);
		$("#st_asset_div").attr("class","SearchPopupInput38disabled");
		$("#st_cost_center_div").attr("class","SearchPopupInput38disabled");
		
		$("#st_asset_name").prop("disabled",true);
		$("#st_cost_center_name").prop("disabled",true);
		
	}
 	
	//팝업 수정 불가
	var st_close_yn = "<%=st_close_yn%>";
	//팝업수정일때 추가 수정
	if(st_close_yn =="Y"){
		$("#st_plant_code").attr("disabled",true);
		$("#st_save_loc").attr("readonly",true);
		$("#st_account").attr("disabled",true);
		$("#st_asset_name_href").prop("disabled",true);
		$("#st_cost_center_name_href").prop("disabled",true);
		$("#st_unloading_point").attr("readonly",true);
		$("#st_gl_account").attr("disabled",true);
		$("#st_recipient").attr("readonly",true);
		
		$("#st_asset_name").prop("disabled",true);
		$("#st_cost_center_name").prop("disabled",true);
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
	openSearchPopup('/common/commonIcomcod2List.do', param, "710,590,no");
}
function getAssetPop(){
	user_flag = "Asset";
	var param = encodeURI("?open=Y&com_code=<%=st_buyer%>&type=C023&codeGubun=geticomcod2Pop&title=AssetList");
	openSearchPopup('/common/commonIcomcod2List.do', param, "710,590,no");
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
		//플랜트를 선택하세요
		var text = "<%=CommonLang.msg("MSG845")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.forms.buyer_pr_display_pop.st_plant_code.focus();
		return;
	}
	if(st_save_loc == ""){
		//저장위치를 입력하세요.
		var text = "<%=CommonLang.msg("MSG846")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.forms.buyer_pr_display_pop.st_save_loc.focus();
		return;
	}
	if(st_account == "K"){
		if(st_cost_center == ""){
			//Cost Center를 선택하세요
			var text = "<%=CommonLang.msg("MSG847")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			document.forms.buyer_pr_display_pop.st_cost_center_name.focus();
			return;
		}
		if(st_unloading_point == ""){
			//Unloading Point를 입력하세요
			var text = "<%=CommonLang.msg("MSG848")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			document.forms.buyer_pr_display_pop.st_unloading_point.focus();
			return;
		}
		if(st_gl_account == ""){
			//G/L Account를 선택하세요
			var text = "<%=CommonLang.msg("MSG849")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			document.forms.buyer_pr_display_pop.st_gl_account.focus();
			return;
		}
		if(st_recipient == ""){
			//Recipient를 입력하세요
			var text = "<%=CommonLang.msg("MSG850")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			document.forms.buyer_pr_display_pop.st_recipient.focus();
			return;
		}
	}
	else if(st_account == "A"){
		if(st_asset == ""){
			//Asset을 선택하세요
			var text = "<%=CommonLang.msg("MSG851")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			document.forms.buyer_pr_display_pop.st_asset_name.focus();
			return;
		}
	}
	
	if("<%=glAccount_fill_flag%>" == "Y"){
		if(st_gl_account == ""){
			//4***** 품목코드는 G/L Account가 필수입력입니다.
			var text = "<%=CommonLang.msg("MSG852")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	var st_ref_no = st_plant_code+"%%"+st_save_loc+"%%"+st_account+"%%"+st_asset+"%%"+st_asset_name+"%%"+st_cost_center+"%%"+st_cost_center_name+"%%"+st_unloading_point+"%%"+st_gl_account+"%%"+st_recipient;
	document.forms.buyer_pr_display_pop.st_ref_no.value = st_ref_no;
	var tab_id = "<%=st_tab_id%>";
	var st_row = "<%=st_row%>";
	if(tab_id == ""){
		opener.setPopupReturn(st_row,st_ref_no,st_ref_no);
	}else{
		opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_no,st_ref_no);
	}
	
	self.close();
	 
}

//선택하는 계정에 따라 설정하기
function ChangeAttr(flag){
	if(flag == "K"){
		$("#st_asset_name_href").prop("disabled",true);
		$("#st_cost_center_name_href").prop("disabled",false);
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_gl_account").attr("disabled",false);
		$("#st_gl_account").val("");
		$("#st_asset_div").attr("class","SearchPopupInput38disabled");
		$("#st_cost_center_div").attr("class","SearchPopupInput38");
		
		$("#st_asset_name").prop("disabled",true);
		$("#st_cost_center_name").prop("disabled",false);
		

	}else if(flag == "A"){
		$("#st_asset_name_href").prop("disabled",false);
		$("#st_cost_center_name_href").prop("disabled",true);
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_gl_account").attr("disabled",true);
		$("#st_gl_account").val("");
		$("#st_asset_div").attr("class","SearchPopupInput38");
		$("#st_cost_center_div").attr("class","SearchPopupInput38disabled");
		
		$("#st_asset_name").prop("disabled",false);
		$("#st_cost_center_name").prop("disabled",true);
		
	}else{
		$("#st_asset_name_href").prop("disabled",true);
		$("#st_cost_center_name_href").prop("disabled",true);
		$("#st_asset").val("");
		$("#st_asset_name").val("");
		$("#st_cost_center_name").val("");
		$("#st_cost_center").val("");
		$("#st_gl_account").attr("disabled",true);
		$("#st_gl_account").val("");
		$("#st_asset_div").attr("class","SearchPopupInput38disabled");
		$("#st_cost_center_div").attr("class","SearchPopupInput38disabled");
		
		$("#st_asset_name").prop("disabled",true);
		$("#st_cost_center_name").prop("disabled",true);
		
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="buyer_pr_display_pop" id="buyer_pr_display_pop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer %>">
	<input type="hidden" name="st_ref_no" id="st_ref_no" value="<%=st_ref_no %>">

  <div class="PopupTit"><%=st_title %></div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="110px" />
      <col width="240px" />
      <col width="135px" />
      <col width="*" />
	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE1266") %><!-- 플랜트 --></th>
      <td><select name="st_plant_code" id="st_plant_code" class="Select40" style="width:200px" >
        </select></td>
      <th><%=CommonLang.get("HTITLE1446")%><!--저장위치--></th>
      <td><input class="input40" id="st_save_loc" name="st_save_loc" style="width:210px" type="text" value="<%=!"".equals(saveLoc)?saveLoc:"5110"%>"/></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1447")%><!--계정구분--></th>
      <td><select id="st_account" name="st_account" onChange="ChangeAttr(this.value)" class="Select40" style="width:200px" >         
		    <option value=""> </option>	
			<option value="K" <%=!"".equals(Account)?"K".equals(Account)?"selected":"":""%>>K(Cost Center)</option>
			<option value="A" <%=!"".equals(Account)?"A".equals(Account)?"selected":"":""%>>A(Asset)</option>
        </select></td>
      <th><%=CommonLang.get("HTITLE1448")%><!--Asset--></th>
      <td><input type="hidden" id="st_asset" name="st_asset" value="<%=!"".equals(Asset)?Asset:""%>" readonly>
      	<div id="st_asset_div" class="SearchPopupInput38" style="width:230px;">
        <input type="text" id="st_asset_name" name="st_asset_name" style=" width:78%;" value="<%=!"".equals(AssetName)?AssetName:""%>" readonly>
        <button type="button" onclick="javascript:getAssetPop(); return false;" id="st_asset_name_href" ></button> </div> </td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1449")%><!--Cost Center--></th>
      <td><input type="hidden" id="st_cost_center" name="st_cost_center" style="width:60%" value="<%=!"".equals(costCenter)?costCenter:""%>" class="input_type_text">
      	<div id="st_cost_center_div" class="SearchPopupInput38" style="width:198px;">
        <input type="text" id="st_cost_center_name" name="st_cost_center_name" style=" width:76%;" value="<%=!"".equals(costCenterName)?costCenterName:""%>" readonly>
        <button type="button" onclick="javascript:getCostCenterPop();return false;" id="st_cost_center_name_href"></button> </div> </td>
      <th><%=CommonLang.get("HTITLE1450")%><!--Unloading Point--></th>
      <td><input class="input40" style="width:210px" id="st_unloading_point" name="st_unloading_point" type="text" value="<%=!"".equals(unloadingPt)?unloadingPt:""%>"/></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1451")%><!--G/L Account--></th>
      <td><select id="st_gl_account" name="st_gl_account" class="Select40" style="width:200px">
        </select></td>
      <th><%=CommonLang.get("HTITLE1452")%><!--Recipient--></th>
      <td><input class="input40" style="width:210px" id="st_recipient" name="st_recipient" type="text" value="<%=!"".equals(Recipient)?Recipient:""%>"/></td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
  <%if(st_close_yn.equals("N")){ %>
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setRefList();return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
  <%} %> 
  </div>
  </form> 
</div><!-- wrapPopup 끝-->  
</body>
</html>
