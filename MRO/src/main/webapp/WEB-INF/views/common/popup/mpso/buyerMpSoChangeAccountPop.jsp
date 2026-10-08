<%--
**********************************************
* 메뉴 :
* 화면 : 계정변경
* 기능 : 금액미통제 계정에 한하여 예산부서/예산계정별 주문기간의 사용금액을 표시 팝업
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2026-04-09
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

<%@include file="../../../common/include/head.jspf" %>
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
function kep_onload(){
	<% if ("".equals(_CRUD)){%>
		kepNoSetCalender("startDate","/"); // 초기 시작하자마 해당 ID에 달력세팅
		kepNoSetCalender("endDate","/"); // 초기 시작하자마 해당 ID에 달력세팅
		$("#startDate").val(kepToMonthAdd('1','M'));
	<%}else{%>
		kepNoSetCalender("startDate",""); // 한 번 조회 후에는 사용한 일자 유지
		kepNoSetCalender("endDate",""); // 한 번 조회 후에는 사용한 일자 유지
	<%}%>
	
	// 예산부서, 예산계정 셀렉트박스 선택 형식
	<% if (bca00005 == true){%>
		$("#st_budget_dept").change(function(){
			kepSearch();
		});
		
		$("#st_account").change(function(){
			kepSearch();
		});
	<%}%>
	
	<% if("Y".equals(open)){%>
		kepSearch();
	<%}%>
}

function kepSearch(){
	if (kep_dateSearchCheck($("#startDate").val(),$("#endDate").val()) == false) return;
	
	if (kepGetDateDiff('startDate','endDate','D') > 365 ){
		alert("조회기간은 최대 1년까지 가능합니다.");
		return;
	}
	
	$('#buyerMpSoChangeAccountPop').attr("action", "/mpso/getBuyerMpSoChangeAccountPop.do").submit();
}

function kepEnter(){
	if(event.keyCode == 13){
		kepSearch();
	}
}

function changeAccount(budget, account){
	$("#budget_dept").val(budget);
	$("#account_type").val(account);
	
	kepAjaxPopFormCall("/mpso/saveBuyerMpSoChangeAccountPop.do","buyerMpSoChangeAccountPop","changeAccount");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxPopSuccess(pMethod, response){
	if(pMethod == "changeAccount"){
		alert("정상적으로 수정되었습니다.");
		
		opener.location.reload();
		self.close();
	}  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxPopError(pMethod, response){
	if(pMethod == "changeAccount"){
		alert("수정 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.");
	}
}
</script>
<body onload="kep_onload()">
<form name="buyerMpSoChangeAccountPop" id="buyerMpSoChangeAccountPop" method="post">
	<input type="hidden" id="st_com_code" name="st_com_code" value="<%=com_code%>">
	<input type="hidden" id="pr_no" name="pr_no" value="<%=pr_no%>">
	<input type="hidden" id="pr_seq" name="pr_seq" value="<%=pr_seq%>">
	<input type="hidden" id="dept_code" name="dept_code" value="<%=dept_code%>">
	<input type="hidden" id="dept_name" name="dept_name" value="<%=dept_name%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:480px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE428")%><%=CommonLang.get("HTITLE825")%><!-- 계정+변경 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
        	<span class="fl"><font color="red"><b>※ <%=CommonLang.msg("MSG786")%><!-- 예산이 편성된 계정은 선택할 수 없습니다. --></b></font></span>
            	<span class="btn_search"><a href="javascript:kepSearch();"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span>
            </div>
            
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
            		<caption>계정선택 리스트</caption>
					<colgroup>
						<col width="9%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
					</colgroup>

					<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></td>
							<td colspan="5">
								<input type="text" id="startDate" class="input_type_text" name="startDate" value="<%=startDate%>" style="width:70px; text-align:center;" >
								-
								<input type="text" id="endDate" class="input_type_text" name="endDate" value="<%=endDate%>" style="width:70px; text-align:center;" >
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','12')">12<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('startDate','endDate')">당월</a></span>
							</td>
						</tr>
						<tr>
							<td><%=CommonLang.get("HTITLE323")%><!-- 부서명 --></td>
							<td>
								<%=dept_name%>
                            </td>
                            
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
								<input type=text name="st_budget_dept" id="st_budget_dept" value="<%=st_budget_dept%>" onkeydown="kepEnter()" class="input_type_text" style="width: 90%">
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
								<input type=text name="st_account" id="st_account" value="<%=st_account%>" onkeydown="kepEnter()" class="input_type_text" style="width: 90%">
						<% } %>
                            </td>
						</tr>
					</tbody>
				</table>
            </div>

           	<!--grid-->
			<table class="cont_t_list02" style="width:100%">
				<caption>계정선택 리스트</caption>
				<colgroup>
					<col width="42%" />
					<col width="42%" />
					<col width="16%" />
				</colgroup>
				
				<thead>
					<tr>
						<th scope="col"><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
						<th scope="col"><%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
						<th scope="col"><%=CommonLang.get("HTITLE909")%><!-- 사용금액 --></th>
					</tr>
				</thead>
			</table>
            
            <div class="scrollArea" style="height:300px">
            	<table class="cont_t_list02" style="width:100%;border-top:0px solid #4b4948;">
            		<caption>계정선택 리스트</caption>
           			<colgroup>
           				<col width="42%" />
           				<col width="42%" />
           				<col width="16%" />
           			</colgroup>
            		
            		<tbody>
<%
if (_dataList == null){
%>
		                <tr bgcolor="#FFFFFF">
				            <td colspan="3" align="center" height = "260">
				            <span class="font1"><%=CommonLang.msg("MSG558") %><!-- 조회 조건을 확인 후 조회 버튼을 클릭하여 주시기 바랍니다. --></span>
				            </td> 
		           		</tr>
<%
}else if(_dataList.size() == 0){
%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="3" align="center" height = "260">
	                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	                        </td> 
	                    </tr>
<%
}else{
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);
%>
                        <tr>
							<td class="left">
								<input type="hidden" id="budget_dept" name="budget_dept" value="">
								<%=rowData.get("BUDGET_DEPT_NAME")%>
							</td>

							<td class="left">
								<input type="hidden" id="account_type" name="account_type" value="">
		<%if(rowData.get("POSB_FLAG").equals("N")){%>
								<a class="hyperLink" href="javascript:changeAccount('<%=rowData.get("BUDGET_DEPT")%>','<%=rowData.get("ACCOUNT_CODE")%>');"><%=rowData.get("ACCOUNT_NAME")%> (<%=rowData.get("ACCOUNT_CODE")%>)</a>
		<%}else{%>
								<%=rowData.get("ACCOUNT_NAME")%> (<%=rowData.get("ACCOUNT_CODE")%>)
		<%}%>
							</td>
							
							<td class="right">
								<%=CommonUtil.formatNumber(rowData.get("TARGET_AMT"),true,0,3)%>
							</td>
                        </tr>
<%
	}
}%>
					</tbody>
                </table>
        	</div>
		</div>
	</div>
</form>
</body>
</html>
