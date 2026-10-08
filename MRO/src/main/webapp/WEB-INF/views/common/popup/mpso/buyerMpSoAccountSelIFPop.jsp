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

int rec_cnt = 0; 
%>

<script type="text/javascript">
function kep_onload(){
	
	<% if ("Y".equals(open)){%>
	kepSearch();
	<%}%>
}

function kepSearch()
{  
  $('#buyerMpSoAccountSelIFPop').attr("action", "/mpso/getBuyerMpSoAccountSelIFPop.do").submit();    
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
</script> 
<body onload="kep_onload()">
<form name="buyerMpSoAccountSelIFPop" id="buyerMpSoAccountSelIFPop" method=post >
	<input type="hidden" name="st_com_code"		value="<%=com_code%>">
	<input type="hidden" name="st_dept_code"		value="<%=dept_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">계정선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
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
							<td>예산부서</td>
							<td>
								<input type=text name="st_budget_dept" id="st_budget_dept" value="<%=st_budget_dept%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
    						
    						<td>계정</td>
							<td>
								<input type=text name="st_account" id="st_account" value="<%=st_account%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
					<caption>계정선택 리스트</caption>
                    <colgroup>
                        <col width="50%" />
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2" scope="col">예산부서</th>
                            <th rowspan="2" scope="col">계정</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="2" align="center" height = "260">
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td rowspan="1" class="left"> 
								<input type="hidden" name="st_dept_code"		value="<%=rowData.get("DEPT_CODE")%>">
								<input type="hidden" name="st_account_type"		value="<%=rowData.get("ACCOUNT_TYPE")%>">
								<input type="hidden" name="st_plan_amt_flag"	value="<%=rowData.get("PLAN_AMT_FLAG")%>">
								<a href="javascript:opener.setPopupReturn('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>');self.close();"><%=rowData.get("DEPT_CODE")%> / <%=rowData.get("DEPT_NAME")%></a>							
							</td>
							<td rowspan="1" class="left">
							<a href="javascript:opener.setPopupReturn('<%=rowData.get("ACCOUNT_TYPE")%>','<%=rowData.get("ACCOUNT_NAME")%>','<%=rowData.get("DEPT_CODE")%>','<%=rowData.get("DEPT_NAME")%>','<%=CommonUtil.formatNumber(rowData.get("AVAIL_AMT"),false,0,3)%>', '<%=rowData.get("MNG_FLAG")%>');self.close();"><%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_NAME")%></a>
							</td>
                        </tr>
 
<%
	}
}%>                               
                    </tbody>
                </table>      
        </div>
        <table height="10px"></table>
        <b>※ 사용가능금액이 <font color="red">*</font>0 인 계정은 선택시 예산 미적용 계정으로 처리됩니다.</b>
    </div>        
</div>
</form> 
</body>
</html>
