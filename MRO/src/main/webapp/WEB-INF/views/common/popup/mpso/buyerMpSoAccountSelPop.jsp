<%--
**********************************************
* 메뉴 : 
* 화면 : 계정선택
* 기능 : 예산을 사용하는 고객사의 경우 장바구니에 입력될 계정코드를 선택하기 위한 팝업
* 프로그램 ID : PG_06_B_006_40 
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과     

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"),CommonUtil.nvl((String) request.getParameter("st_com_code")));
 
String dept_code = CommonUtil.nvl((String) request.getParameter("dept_code"),"");  //  (조회조건)
String cart_sum_price = CommonUtil.nvl((String) request.getParameter("st_cart_sum_price"),"0");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
  
String SessionUserDept      = _sessionInfo.getDepartment();
String SessionUserDeptName  = _sessionInfo.getDepartmentName();
String SessionUserId  = _sessionInfo.getUserId();

String st_budget_dept = CommonUtil.nvl((String) request.getParameter("st_budget_dept"),"");  //  (조회조건)
String st_account = CommonUtil.nvl((String) request.getParameter("st_account"),"");  //  (조회조건)

String st_categ = CommonUtil.nvl((String) request.getParameter("st_categ"),"");  //  (조회조건)
String st_categ_acnt_set = CommonUtil.nvl((String) request.getParameter("st_categ_acnt_set"),"N");  //  (조회조건)
String st_search_set = CommonUtil.nvl((String) request.getParameter("st_search_set"),"N");  //  (조회조건)
String st_account_flg = CommonUtil.nvl((String) request.getParameter("st_account_flg"), null);  //  (조회조건)

int rec_cnt = 0;

// 예산부서, 예산계정 셀렉트박스 선택 형식
boolean bca00005 = CommonUtil.getSpecialCheckReturn(com_code, "BCA00005");
%>

<script type="text/javascript">
function kep_onload(){
// 예산부서, 예산계정 셀렉트박스 선택 형식
<% if (bca00005 == true){%>
	$("#st_budget_dept").change(function(){
		kepSearch();
	});
	
	$("#st_account").change(function(){
		kepSearch();
	});
<%}%>

// 자동조회
<% if ("Y".equals(open)){%>
	kepSearch();
<%}%>
}

function kepSearch(){
	<% if("Y".equals(st_search_set)){%>
		var budget_search = document.forms.buyerMpSoAccountSelPop.st_budget_dept.value;
		var account_search = document.forms.buyerMpSoAccountSelPop.st_account.value;

	    if(budget_search == "" && account_search == ""){
	        alert("조회조건을 하나라도 입력하셔야 합니다.");
	        return;
	    }
	    else{
			$('#buyerMpSoAccountSelPop').attr("action", "/mpso/getBuyerMpSoAccountSelPop.do").submit();
	    }
    <%}else{%>
		$('#buyerMpSoAccountSelPop').attr("action", "/mpso/getBuyerMpSoAccountSelPop.do").submit();
	<%}%>
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function overBdgt(value1,value2){ 
	alert("해당 계정의 사용가능금액이 부족합니다.\n다른 가능한 계정을 선택하시기 바랍니다.");
  	retrun;
}
</script> 
<body onload="kep_onload()">
<form name="buyerMpSoAccountSelPop" id="buyerMpSoAccountSelPop" method=post >
	<input type="hidden" name="st_com_code"		value="<%=com_code%>">
	<input type="hidden" name="st_dept_code"		value="<%=SessionUserDept%>">
	<input type="hidden" name="st_cart_sum_price"		value="<%=cart_sum_price%>">
	<input type="hidden" name="st_categ_acnt_set"		value="<%=st_categ_acnt_set%>">
	<input type="hidden" name="st_categ"		value="<%=st_categ%>">
	<input type="hidden" name="st_search_set"		value="<%=st_search_set%>">
	<input type="hidden" name="st_account_flg"		value="<%=st_account_flg%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE907")%><!-- 계정선택 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span>  
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>계정선택 리스트</caption>
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>						
					<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE323")%><!-- 부서명 -->  :</td>
							<td> 
								<%=SessionUserDeptName%>
                            </td>
						    
						    <td></td>						 
							<td></td>
						</tr>
						<tr>
							<td><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></td>
							<td>
						<% if (bca00005 == true){%>
								<select id="st_budget_dept" name="st_budget_dept">
									<%
										Map<String, String> _map = new HashMap<String, String>();
						 				_map.put("BUYER", com_code);
						 				_map.put("TYPE", "DTOD");
						 				_map.put("CODE1", SessionUserDept);
									%>
									<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetDept","ALL",_map,st_budget_dept) %>
						        </select>
						<% } else { %>
								<input type=text name="st_budget_dept" id="st_budget_dept" value="<%=st_budget_dept%>" onkeydown="kepEnter()" class="input_type_text">
						<% } %>
                            </td>
    						
    						<td><%=CommonLang.get("HTITLE428")%><!-- 계정 --></td>
							<td>
						<% if (bca00005 == true){%>
								<select id="st_account" name="st_account">
									<%
										Map<String, String> _map = new HashMap<String, String>();
						 				_map.put("BUYER", com_code);
						 				_map.put("TYPE", "DTOA");
						 				_map.put("CODE1", SessionUserDept);
									%>
									<%= CommonUtil.getCodeComboQueryIdList("common.getBudgetInfo_budgetAccount","ALL",_map,st_account) %>
								</select>
						<% } else { %>
								<input type=text name="st_account" id="st_account" value="<%=st_account%>" onkeydown="kepEnter()" class="input_type_text">
						<% } %>
                            </td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
<table  class="cont_t_list02"  style="width:100%">
					<caption>계정선택 리스트</caption>
                    <colgroup>
                        <col width="20%" />
                        <col width="20%" />
                        <col width="20%" />
                        <col width="12%" /> 
						<col width="14%" /> 
                        <col width="14%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2" scope="col"><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
                            <th rowspan="2" scope="col"><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
                            <th rowspan="2" scope="col"><%=CommonLang.get("HTITLE916")%><!-- 관리부서 --></th>
                            <th rowspan="2" scope="col"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE430")%><!-- 예산금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE908")%><!-- 사용가능금액 --></th>
                        </tr>
                        
                        <tr>
							<th scope="col"><%=CommonLang.get("HTITLE909")%><!-- 사용금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE910")%><!-- 장바구니 금액 --></th>
                        </tr>
                    </thead>
                    </table>
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%;border-top:0px solid #4b4948;">
					<caption>계정선택 리스트</caption>
                    <colgroup>
                        <col width="20%" />
                        <col width="20%" />
                        <col width="20%" />
                        <col width="12%" /> 
						<col width="14%" /> 
                        <col width="14%" /> 
                    </colgroup>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="6" align="center" height = "260">
	                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	                        </td> 
	                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td rowspan="2" class="left"> 
								<input type="hidden" name="st_dept_code"		value="<%=rowData.get("DEPT_CODE")%>">
								<input type="hidden" name="st_account_type"		value="<%=rowData.get("ACCOUNT_TYPE")%>">
								<input type="hidden" name="st_plan_amt_flag"	value="<%=rowData.get("PLAN_AMT_FLAG")%>">
								<%  // 예산적용 계정인데 비적용처럼 보이게 하는 경우
								 if(rowData.get("VIEW_FLAG").equals("N")) {
								%>
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>
								<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
								} else	if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
								%>
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>	
								<%
								} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
								%>
									<a href="javascript:overBdgt();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>
								<%
								}
								%>
							</td>

							<td rowspan="2" class="left">
								<%  // 예산적용 계정인데 비적용처럼 보이게 하는 경우
								 if(rowData.get("VIEW_FLAG").equals("N")) {
								%>
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>
								<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
								} else if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
								%>
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>	
								<%
								} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
								%>
									<a href="javascript:overBdgt();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>
								<%
								}
								%>
							</td>
							<td rowspan="2" class="left">
								<% // 예산적용 계정인데 비적용처럼 보이게 하는 경우
								 if(rowData.get("VIEW_FLAG").equals("N")) {
								%>	
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','0', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>
								<%	// 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
								} else if( rowData.get("BDGT_FLAG2").equals("N") ||  (rowData.get("BDGT_FLAG2").equals("Y") && Double.parseDouble(rowData.get("AVAIL_AMT")) >= Double.parseDouble((cart_sum_price)))  ){
								%>
									<a href="javascript:opener.setBdgtAccount('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>','','<%=rowData.get("MNG_DEPT_CD")%>','<%=rowData.get("MNG_DEPT_NM")%>');self.close();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>	
								<%
								} else {	// 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정	
								%>
									<a href="javascript:overBdgt();"><%=rowData.get("MNG_DEPT_CD")%> / <%=rowData.get("MNG_DEPT_NM")%></a>
								<%
								}
								%>
							</td>			
							<td rowspan="2" class="left">
								<%=rowData.get("REMARK")%>
							</td>	
							<td class="right">
								<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
									0 
								<% } else { %>
									<%=CommonUtil.formatNumber(rowData.get("PLAN_AMT"),true,0,3)%>
								<% } %>
								
							</td>
							
							<td class="right">
								<%=(rowData.get("BDGT_FLAG2").equals("N") || rowData.get("VIEW_FLAG").equals("N"))?"<font color=red>*</font>":""%>
								
								<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
									 0 
								<% } else { %>
									<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),true,0,3)%>
								<% } %>
								
							</td>
                        </tr>
                        
                        <tr>
							<td class="right">
								<% if(rowData.get("VIEW_FLAG").equals("N")){ %>
									0 
								<% } else { %>
									<%=CommonUtil.formatNumber(rowData.get("RESULT_TEMP_AMT"),true,0,3)%>
								<% } %>
							</td>
							
							<td class="right">
								<%=CommonUtil.formatNumber(cart_sum_price,true,0,3)%>
							</td>
                        </tr>
<%
	}
}%>                               
                    </tbody>
                </table>      
        </div>
        <table height="10px"></table>
        <b>※ <%=CommonLang.msg("MSG531")%><!-- 사용가능금액이 --> <font color="red">*</font> <%=CommonLang.msg("MSG532")%><!-- 0 인 계정은 선택시 예산 미적용 계정으로 처리됩니다. --></b>
    </div>        
</div>
</form> 
</body>
</html>
