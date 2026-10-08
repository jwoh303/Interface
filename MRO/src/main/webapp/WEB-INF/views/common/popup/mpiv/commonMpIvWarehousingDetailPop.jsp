<%--
**********************************************
* 메뉴 : 
* 화면 : 입고상세조회
* 기능 : 
* 프로그램 ID : PG_07_M_900_27
* 담당자 :  손상민( 설계 : 김지현 )
* 착수일 : 2014-07-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
Map<String,String> _dataList1 = (Map<String,String>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
String st_po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)

Map<String,String> rowData = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1;
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (_dataList1==null || _dataList1.size()==0){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery()
{ 
  $('#poDetailPop').attr("action", "/mpso/poDetailPop.do").submit();   
}


//-->
</script> 
<body onload="kep_onload_view();">
	<form name="poDetailPop" id="poDetailPop" method=post >
	<input type="hidden" name=st_buyer id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name=st_po_no id="st_po_no" size=20 value="<%=st_po_no%>" >
	<input type="hidden" name=st_po_seq id="st_po_seq" size=20 value="<%=st_po_seq%>" >
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 	
	<!--최소 가로길이 400px-->
	<div id="popWrapper" style="height:490px;">
    	<div id="popHeader">
        	<h1 class="title">입고상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <!--데이타그리드-->
        	<table class="cont_t_list06 mb15" style="width:100%;">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="11%" />
                    <col width="27%" />
                    <col width="9%" />
                    <col width="24%" />
                    <col width="9%" />
                    <col width="23%" />
                </colgroup>
                <tbody>
	               <tr>
	                    <th >고객사</th>
	                    <td ><font color="#5B5B5B"><b><%=rowData.get("BUYER_NAME")%></b></font><%=rowData.get("DOC_TEXT")%></td>
	                    <th >발주부서</th>
	                    <td ><%=rowData.get("PO_DEPT_NAME")%></td>
	                    <th >요청부서</th>
	                    <td ><%=rowData.get("REQ_DEPT_NAME")%></td>
	                </tr>
	                <tr>
	                    <th height="27" >발주번호</th>
	                    <td ><font color="#5B5B5B"><b><%=rowData.get("PO_NO")%></b></font>(<%=rowData.get("PO_SEQ")%>)</td>
	                    <th >발주자</th>
	                    <td ><%=rowData.get("PO_USER_NAME")%></td>
	                    <th >요청자</th>
	                    <td ><%=rowData.get("REQ_USER_NAME")%></td>
	                </tr>
	                <tr>
	                    <th height="27" >발주일</th>
	                    <td ><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>(<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>)</td>
	                    <th >매입금액</th>
	                    <td ><%=CommonUtil.formatNumber(rowData.get("AGENT_AMT"),true,0,3)%></td>
	                    <th >매출금액</th>
	                    <td ><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>
	                </tr>
	                <tr>
	                    <th height="27" >도착지</th>
	                    <td colspan="3" ><%=rowData.get("DELY")%></td>
	                    <th height="27" >공급원</th>
	                    <td colspan="2" ><%=rowData.get("AGENT_NAME")%></td> 
	                </tr>
	                <tr>
	                    <th height="27" >비고</th>
	                    <td colspan="5" ><%=rowData.get("REMARK")%></td>
	                </tr>
                </tbody>
            </table>
            
            <!--grid-->
            <div class="scrollArea" style="height:240px">
	            <table  class="cont_t_list09"  style="width:100%">
	                <caption>상세내역</caption>
	                <colgroup>
	                    <col width="17%" height="29"/>
	                    <col width="39%" />
	                    <col width="15%" />
	                    <col width="12%" />
	                    <col width="12%" />
	                </colgroup>
	                <thead>
	                    <tr>
		                    <th scope="col"  >협력사</th>
		                    <th scope="col" >품목명/제조사</th>
		                    <th scope="col" >발주수량/단위</th>
		                    <th scope="col" >단가</th>
		                    <th scope="col" >입고일</th>
	                        
	                    </tr>
	                    <tr>
		                    <th scope="col" >품목코드</th>
		                    <th scope="col" >규격</th>
		                    <th scope="col" >입고수량</th>
		                    <th scope="col" >입고금액</th>
		                    <th scope="col" >입고번호</th>
	                    </tr>
	                    
	                </thead>
	                <tbody>
	<% 
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _tmp2 = _dataList2.get(j);
	%>                 
                <tr> 
                    <td ><%=_tmp2.get("AGENT_NAME")%></td>
                    <td ><%=_tmp2.get("DESCRIPTION")%>/<%=_tmp2.get("MAKER_NAME")%></td>
                    <td ><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%>/<%=_tmp2.get("UNIT_MEASURE")%></td>
                    <td ><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE"),true,0,3)%></td>
                    <td ><%=CommonUtil.formatStrinigDate(_tmp2.get("GR_DATE"))%></td>
                </tr>
                <tr> 
                    <td ><%=_tmp2.get("BUYER_ITEM_NO")%></td>
                    <td ><%=_tmp2.get("SPECIFICATION")%></td>
                    <td ><%=CommonUtil.formatNumber(_tmp2.get("GR_ITEM_QTY"),true,0,3)%></td>
                    <td ><%=CommonUtil.formatNumber(_tmp2.get("AGENT_SUM"),true,0,3)%></td>
                    <td ><%=_tmp2.get("GR_NO")%><br>(<%=_tmp2.get("GR_SEQ")%>)</td>
                </tr>
	<% } %>
	                </tbody>
	            </table>
	         </div>
        </div>
    </div>
<%}%>    
</form> 
</body>
</html>
