<%--
**********************************************
* 메뉴 :
* 화면 : 계정변경
* 기능 : 금액미통제 계정에 한하여 예산부서/예산계정별 주문기간의 사용금액을 표시 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@include file="../../include/head_v2.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과     

String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과

String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),CommonUtil.nvl((String) request.getParameter("st_com_code")));
String pr_no = CommonUtil.nvl((String) request.getParameter("pr_no"),"");  //  (조회조건)
String pr_seq = CommonUtil.nvl((String) request.getParameter("pr_seq"),"");  //  (조회조건)
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String dept_name = CommonUtil.nvl((String) request.getParameter("dept_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)

String cur_dept_name = CommonUtil.nvl((String) request.getParameter("cur_dept_name"),"");  //  (조회조건)
String cur_account_name = CommonUtil.nvl((String) request.getParameter("cur_account_name"),"");  //  (조회조건)
String cur_account_code = CommonUtil.nvl((String) request.getParameter("cur_account_code"),"");  //  (조회조건)
String cur_amt = CommonUtil.nvl((String) request.getParameter("cur_amt"),"");  //  (조회조건)
  
String SessionUserDept = _sessionInfo.getDepartment();
String SessionUserDeptName = _sessionInfo.getDepartmentName();
String SessionUserId = _sessionInfo.getUserId();

String st_budget_dept = CommonUtil.nvl((String) request.getParameter("st_budget_dept"),"");  //  (조회조건)
String st_account = CommonUtil.nvl((String) request.getParameter("st_account"),"");  //  (조회조건)

String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),""); // 조회조건
String endDate = CommonUtil.nvl((String) request.getParameter("endDate"),""); // 조회조건

//예산부서, 예산계정 셀렉트박스 선택 형식
boolean bca00005 = CommonUtil.getSpecialCheckReturn(com_code, "BCA00005");
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload(){
	<% if ("".equals(_CRUD)){%>
		$("#startDate").val(kepToMonthAdd('1','M'));
		$("#endDate").val(kepGetNowTimeStr('YYYYMMDD','/'));
		<% if("Y".equals(open)){%>
			kepSearch();
		<%}%>
	<%}%>
	
		$("#st_budget_dept").change(function(){
			kepSearch();
		});
		
		$("#st_account").change(function(){
			kepSearch();
		});
}

function kepSearch(){
	if (kep_dateSearchCheck($("#startDate").val(),$("#endDate").val()) == false) return;
	
	if (kepGetDateDiff('startDate','endDate','D') > 365 ){
		var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	$('#buyerMpSoChangeAccountPop').attr("action", "/mpso/getBuyerMpSoChangeAccountPop_v2.do").submit();
}

function kepEnter(){
	if(event.keyCode == 13){
		kepSearch();
	}
}

function changeAccount(){
	var tot_cnt = $("#tot_cnt").val();
	for(var i = 0 ; i<tot_cnt; i++){
		if($("#budgetDept"+i).is(":checked")){
			$("#budget_dept").val($("#td_budget_dept"+i).val());
			$("#account_type").val($("#td_account_code"+i).val());
		}
	}
	
	
	kepAjaxPopFormCall("/mpso/saveBuyerMpSoChangeAccountPop.do","buyerMpSoChangeAccountPop","changeAccount");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxPopSuccess(pMethod, response){
	if(pMethod == "changeAccount"){
		//정상적으로 수정되었습니다.
		var text = "<%=CommonLang.msg("MSG687")%>";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		return;
		
		
	}  
}
function thisPopClose(){
	closePopText2();
	
	opener.location.reload();
	self.close();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxPopError(pMethod, response){
	if(pMethod == "changeAccount"){
		//수정 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG688")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
}

function changeDept(dept_name,account_name,account_code){
	$("#selAccount").html(dept_name+"·"+account_name+"("+account_code+")");
}

function clickTr(index){
	$("#budgetDept"+index).prop("checked",true);
	changeDept($("#td_budget_dept_name"+index).val(),$("#td_account_name"+index).val(),$("#td_account_code"+index).val());
}
</script>
<body onload="kep_onload()">
<form name="buyerMpSoChangeAccountPop" id="buyerMpSoChangeAccountPop" method="post">
	<input type="hidden" id="st_com_code" name="st_com_code" value="<%=com_code%>">
	<input type="hidden" id="pr_no" name="pr_no" value="<%=pr_no%>">
	<input type="hidden" id="pr_seq" name="pr_seq" value="<%=pr_seq%>">
	<input type="hidden" id="dept_code" name="dept_code" value="<%=dept_code%>">
	<input type="hidden" id="dept_name" name="dept_name" value="<%=dept_name%>">
	<input type="hidden" id="cur_dept_name" name="cur_dept_name" value="<%=cur_dept_name%>">
	<input type="hidden" id="cur_account_name" name="cur_account_name" value="<%=cur_account_name%>">
	<input type="hidden" id="cur_account_code" name="cur_account_code" value="<%=cur_account_code%>">
	<input type="hidden" id="cur_amt" name="cur_amt" value="<%=cur_amt%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE428")%><%=CommonLang.get("HTITLE825")%><!-- 계정+변경 --><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Importance_Popup_red01 mt10"><img src="/resources/imgs/Icon_Importance.png" /><%=CommonLang.msg("MSG875")%><!--예산이 편성된 계정은--> <span class="font600"><%=CommonLang.msg("MSG876")%><!--선택 불가--></span><%=CommonLang.msg("MSG877")%><!--로 표시되며 변경할 수 없습니다.--> <%=CommonLang.msg("MSG878")%><!--아래에서--> <span class="font600"><%=CommonLang.msg("MSG879")%><!--선택 가능--></span> <%=CommonLang.msg("MSG880")%><!--계정을 선택 후 변경을 적용해주세요.--></div>
  <div class="Popup_GrayBox mt05 font17px font600" > <span class="ChipsDark_Black mr10"><%=CommonLang.get("HTITLE1420")%><!--현재 계정--></span> <%=cur_dept_name%> · <%=cur_account_name%><%=cur_account_code%> · <%=CommonUtil.formatNumber(cur_amt,true,0,3)%><%=CommonLang.get("HTITLE660")%><!-- 원 -->  </div> 
  <table class="PopTableThLTdL mt10" width="100%">
    <colgroup>
      <col width="13%" />
      <col width="37%" />
      <col width="13%" />
      <col width="37%" />
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></th>
      <td colspan="3"><div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
		  <div class="Buyer-date-input"  data-datepicker><input style=" " type="text" id="startDate" name="startDate" readonly value="<%=startDate%>" /><span></span></div>
		  <span class="Buyer-dash">~</span>
		  <div class="Buyer-date-input" data-datepicker><input type="text" id="endDate" name="endDate" readonly value="<%=endDate%>"/><span></span></div>
		</div>
        <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('startDate','endDate','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
        <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('startDate','endDate','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
        <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('startDate','endDate','6'); return false;">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
        <button class="But_Month" style="width:73px" onclick="javascript:setCurMonth('startDate','endDate'); return false;"><%=CommonLang.get("HTITLE1334") %></button>
      </td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
      <td><select id="st_budget_dept" name="st_budget_dept" class="Select40" style="width:233px;">
          <%
			Map<String, String> _map = new HashMap<String, String>();
				_map.put("BUYER", com_code);
				_map.put("TYPE", "DTOD");
				_map.put("CODE1", SessionUserDept);
			%>
			<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetDept","ALL",_map,st_budget_dept) %>
        </select>
      </td>
      <th><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
      <td><select id="st_account" name="st_account" class="Select40" style="width:240px;">
          <%
			Map<String, String> _map2 = new HashMap<String, String>();
				_map2.put("BUYER", com_code);
				_map2.put("TYPE", "DTOA");
				_map2.put("CODE1", SessionUserDept);
			%>
			<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetAccount","ALL",_map2,st_account) %>
        </select>
      </td>
    </tr>
  </table>
  <div class="PopupListBtnBox_Center mt15">
	<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:kepSearch(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
  </div> 
  <div class="TotalArray mt20 font15px"><span class="ChipsRound_Blue"><%=CommonLang.msg("MSG879")%><!--선택 가능--></span> <%=CommonLang.msg("MSG881")%><!--예산 한도 없이 사용 가능한 계정--> &nbsp; &nbsp;  <span class="ChipsRound_Gray"><%=CommonLang.msg("MSG876")%><!--선택 불가--></span> <%=CommonLang.msg("MSG882")%><!--예산 한도가 설정되어 변경 불가--></div>
  <div class="ScrollBox borderTop01 mt10 borderbottom01_de" style="height:340px;">
    <table class="TableTHTDBottom1px" style="width:100%">
      <colgroup>
        <col width="10%" /> 
        <col width="70%" /> 
        <col width="20%" /> 
      </colgroup>  
      <tr>
        <th></th>
        <th><%=CommonLang.get("HTITLE419")%><!-- 예산부서 -->/<%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
        <th><%=CommonLang.get("HTITLE909")%><!-- 사용금액 --><%=CommonLang.get("HTITLE1419")%><!-- (원) --></th>
      </tr>
      <%if (_dataList == null){%>
	  	<tr>
        	<td colspan="3" align="center" height="274px;">
        		<span class="font1"><%=CommonLang.msg("MSG558") %><!-- 조회 조건을 확인 후 조회 버튼을 클릭하여 주시기 바랍니다. --></span>
			</td>
      	</tr>
	  <%}else if(_dataList.size() == 0) {%>
	  	<tr>
        	<td colspan="3" align="center" height="274px;">
        		<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
			</td>
      	</tr>
	  <%}else{ %>
       	<input type="hidden" id="tot_cnt" name="tot_cnt" value="<%=_dataList.size()%>">
	  	<%for(int j = 0 ; j<_dataList.size(); j++) {%>
	  		<%Map<String,String> rowData = _dataList.get(j);%>
	  		<%if(rowData.get("POSB_FLAG").equals("N")){%>
			  	<tr onclick="javascript:clickTr('<%=j%>');">
		        	<td><label class="RadioLargeLabel"><input type="radio" name="budgetDept" id="budgetDept<%=j %>" onchange="javascript:changeDept('<%=rowData.get("BUDGET_DEPT_NAME")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("ACCOUNT_CODE")%>');"><span class="RadioLargeTxt"></span></label></td>
		        	<td align="left"><p class="font400 mb05"><%=rowData.get("BUDGET_DEPT_NAME")%></p><p class="font500"> <%=rowData.get("ACCOUNT_NAME")%> (<%=rowData.get("ACCOUNT_CODE")%>) <span class="ChipsRound_Blue">선택 가능</span></p> </td>
		        	<td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_AMT"),true,0,3)%></td>
		      	</tr>
        	<%}else{%>
        		<tr class="blur-row">
			        <td><label class="RadioLargeLabel"><input type="radio" name="budgetDept" onclick="return false;"><span class="RadioLargeTxt"></span></label></td>
			        <td align="left"><p class="font400 mb05"><%=rowData.get("BUDGET_DEPT_NAME")%></p><p class="font500"> <%=rowData.get("ACCOUNT_NAME")%> (<%=rowData.get("ACCOUNT_CODE")%>) <span class="ChipsRound_Gray">선택 불가</span></p> </td>
			        <td align="right"><span class="F6495F"><%=CommonUtil.formatNumber(rowData.get("TARGET_AMT"),true,0,3)%></span></td>
			    </tr>
        	<%} %>
        	<input type="hidden" id="td_budget_dept<%=j %>" name="td_budget_dept" value="<%=rowData.get("BUDGET_DEPT")%>">
        	<input type="hidden" id="td_budget_dept_name<%=j %>" name="td_budget_dept_name" value="<%=rowData.get("BUDGET_DEPT_NAME")%>">
       		<input type="hidden" id="td_account_code<%=j %>" name="td_account_code" value="<%=rowData.get("ACCOUNT_CODE")%>">
       		<input type="hidden" id="td_account_name<%=j %>" name="td_account_name" value="<%=rowData.get("ACCOUNT_NAME")%>">
        <%} %>
	  <%} %>         
      
       	<input type="hidden" id="budget_dept" name="budget_dept" value="">
       	<input type="hidden" id="account_type" name="account_type" value="">
    </table>
  </div>
  <div class="PopupListBtnBox mt20">
    <div class="fl left font16px font600"><%=CommonLang.get("HTITLE1422")%><!--선택된 계정--> : <span style="color:#2172EC" id="selAccount"><%=cur_dept_name%>·<%=cur_account_name%><%=cur_account_code%></span></div>
    <div class="fr right"><button class="ButQuaternary_large closePopup" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button> <button class="ButPrimary_large" onclick="javascript:changeAccount(); return false;"><%=CommonLang.get("HTITLE1423")%><!--변경 적용--></button></div>
  </div>  
</div><!-- wrapPopup 끝-->
</form>
</body>
</html>
