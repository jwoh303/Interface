<%--
**********************************************
* 메뉴 : 
* 화면 : 거래 고객사 선택
* 기능 : 
* 프로그램 ID : PG_07_M_900_01
* 담당자 :  ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String comCode = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
	String buyerName = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
	String invoice_flag = CommonUtil.nvl((String) request.getParameter("invoice_flag"),"");  //  (조회조건)
%>

<script type="text/javascript">

function kep_onload_view(){
	$("#st_buyer_name").focus();
}

//기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			$('#commonMpIvTranBuyerChoicePop').attr("action", "/mpiv/getCommonMpIvTranBuyerChoicePop.do").submit();
			break;
	
	}
}

function doPop(str, value1) {
	switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
	}
}

function setReturn(buyer, com_name){
	opener.setBuyerChoiceReturn(buyer, com_name);
	self.close();
}


</script> 
</head>
 
<body onload="kep_onload_view()">
<form name="commonMpIvTranBuyerChoicePop" id="commonMpIvTranBuyerChoicePop" method="post">
	<input type="hidden" name="st_com_code" value="<%=comCode%>" />
	<input type="hidden" name="invoice_flag" value="<%=invoice_flag%>" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">거래 고객사 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
			</div>   
			<!--조회영역-->
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>요청자 정보 리스트</caption>
					<colgroup>
						<col width="20%" />
						<col width="80%" />
					</colgroup>
					<tbody>
						<tr>
							<td>고객사명</td>
							<td> 
								<input type="text" name="st_buyer_name" id="st_buyer_name" size="20" value="<%=buyerName%>" onkeydown="kepEnter();" class="input_type_text">
							</td>
						</tr>
					</tbody>
				</table>
			</div>

        	<font color="#666666">&nbsp;&nbsp; ※ 고객사코드 클릭시 고객사 상세정보, 고객사명 클릭시 선택.</font>
        	<br>
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02" style="width:100%">
                    <caption>거래 고객사 선택 리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="*" /> 
                        <col width="*" />
                        <col width="8%" />
                        <col width="20%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사코드</th> 
                            <th scope="col">고객사명</th> 
                            <th scope="col">고객사 주소</th>
                            <th scope="col">KEP<br>담당자</th>
                            <th scope="col">연락처<br>이메일</th>
                        </tr>
                    </thead>
                    <tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
						<tr bgcolor="#FFFFFF">
							<td colspan="3" align="center" height = "50">
								<span class="font1">조회된 데이타가 없습니다.</span>
							</td> 
						</tr>
				<%	} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
				%> 
                        <tr>
							<td class="center">
								<a href="javascript:doPop('agent', '<%=_tmp.get("BUYER")%>')" class="hyperLink">
								<%=_tmp.get("BUYER")%></a>
							</td>
							<td class="left">
								<a href="javascript:setReturn('<%=_tmp.get("BUYER")%>','<%=_tmp.get("COM_NAME_LOC")%>')"  class="hyperLink">
								<%=_tmp.get("COM_NAME_LOC")%></a>
							</td>
							<td class="left">
								<%=CommonUtil.nvl(_tmp.get("ADDRESS_LOC"))%>
							</td>
							<td class="center">
								<%=CommonUtil.nvl(_tmp.get("KEP_USER_NAME"))%>
							</td>
							<td class="center">
								<%=CommonUtil.nvl(_tmp.get("KEP_USER_PHONE"))%><br>
								<%=CommonUtil.nvl(_tmp.get("KEP_USER_EMAIL"))%>
							</td>
						</tr> 
				<%
						}
					}
				%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
