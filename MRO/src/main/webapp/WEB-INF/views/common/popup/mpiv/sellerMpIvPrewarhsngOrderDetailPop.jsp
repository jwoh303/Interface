<%--
**********************************************
* 메뉴 : 
* 화면 : 선입고요청 상세정보
* 기능 : 선입고 주문건의 상세내역을 확인하고 송장을 생성출력/납품실적 등록처리한다.
* 프로그램 ID : PG_07_A_009_01
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-12
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"), "");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");
String st_inv_no = CommonUtil.nvl((String) request.getParameter("st_inv_no"), "");
Map<String,String> rowData = null;
String process_type = "";
String warehouse_code = "";

if(_dataList != null && _dataList.size() > 0){
	rowData = _dataList.get(0);
	process_type = rowData.get("PROCESS_TYPE");
	warehouse_code = rowData.get("WAREHOUSE_CODE");
}

%>

<script type="text/javascript">
//<!--
function doAction(str){
	switch (str){
		case "openReport": // 거래명세서 출력
		
		var fileName = "";
		var inv_no= "<%=st_inv_no%>";
		var com_code = "KRKORE0001";
		var buyer_code= "<%=st_buyer_code%>";
		var process_type = "<%=process_type%>";
		var warehouse_code = "<%=warehouse_code%>";
		
		if(process_type == "2" && warehouse_code == "KRKORE0126" ){	// TR (인천HUB센터)
			fileName = "RD_06_S_003_19";
		} else if(process_type == "2" && warehouse_code != "KRKORE0126" ){	// TR (인천HUB센터)가 아니면
			fileName = "RD_06_S_003_20";
		} else {
			fileName = "RD_06_S_003_17";
		}
		
		var param =  "["+inv_no+"]["+com_code+"]["+buyer_code+"]";
		reportOpen(fileName,param);
		break;
	}
}
 //-->
</script> 
<body onload="">
<form name="sellerMpIvPrewarhsngOrderDetailPop" id="sellerMpIvPrewarhsngOrderDetailPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=st_com_code%>">
<input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code%>">
<input type="hidden" name="st_inv_no" id="st_inv_no"  value="<%=st_inv_no%>">
<%
if (_dataList==null || _dataList.size()==0){
%>
<%}else{ %>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:505px;">
    	<div id="popHeader">
        	<h1 class="title">선입고요청 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:385px;">
		<h2>선입고요청 상세정보</h2>

		<table  class="cont_t_list06 mb15" summary="회원사" style="width:100%;">
			<caption>선입고요청 상세정보</caption>
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tbody>
	    	<tr>
	    		<th scope="row">거래명세서 번호</th>
				<td colspan="3"><font color="blue"><b><%=CommonUtil.nvl(rowData.get("INV_NO"))%></b></font></td>
			</tr>
	    	<tr> 
	    		<th scope="row">선입고요청일</th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("BEFORE_GR_DATE"))%></td>
	    		<th scope="row">총 금액</th>
				<td scope="row"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("TOT_INV_AMT")),true,0,3)%></td>
			</tr>
			<tr>
				<th scope="row">고객사</th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></td>
				<th scope="row">요청자</th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("PURCHASER_NAME"))%></td>
			  </tr>
			  <tr>
				<th scope="row">요청부서</th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("PURCHASER_DEPT_NAME"))%></td>
				<th scope="row">연락처</th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("REQ_USER_TEL_NO"))%></td>
			  </tr>
			  <tr>
				<th scope="row">배송지</th>
				<td scope="row" colspan="3"><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
			  </tr>
	        </tbody>
	   </table> 

	<h2>선입고요청 목록</h2>
			<!--grid-->
			<div class="scrollArea" style="height:180px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>선입고요청 목록 리스트</caption>
                    <colgroup>
                        <col width="10%" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="5%" />  
                        <col width="7%" />  
                        <col width="7%" />  
                        <col width="9%" />  
                        <col width="10%" />  
                        <col width="10%" />  
                        <col width="*" />    
                    </colgroup>		   
                    <thead> 
                        <tr>         
                            <th scope="col">품목코드</th>
                            <th scope="col">품목명</th>
                            <th scope="col">규격</th>
                            <th scope="col">단위</th>
                            <th scope="col">수량</th>
                            <th scope="col">단가</th>
                            <th scope="col">금액</th>
                            <th scope="col">제조사</th>
                            <th scope="col">원산지</th>
                            <th scope="col">비고</th>
                        </tr>
                    </thead>
                    <tbody>
<% 
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp2 = _dataList.get(j);
%>  
                        <tr>
						   <td class="left"><%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%></td> 
						   <td class="left"><%=CommonUtil.nvl(_tmp2.get("DESCRIPTION"))%></td> 
						   <td class="left"><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td> 
						   <td><%=CommonUtil.nvl(_tmp2.get("UNIT_MEASURE"))%></td> 
						   <td class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,3)%></td> 
						   <td class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("UNIT_PRICE")),true,0,3)%></td> 
						   <td class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("INV_AMT")),true,0,3)%></td> 
						   <td><%=CommonUtil.nvl(_tmp2.get("MAKER_NAME"))%></td> 
						   <td><%=CommonUtil.nvl(_tmp2.get("ORIGIN_NAME"))%></td> 
						   <td class="left"><%=CommonUtil.nvl(_tmp2.get("REMARK"))%></td> 
						</tr> 
<% } %>
                              
                    </tbody>
                </table>  
             </div>	
        </div>
        
        <!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_06" style="margin-right: 5px;">
					<a href="javascript:doAction('openReport');">거래명세서 출력</a>
				</span>	
            </div>
        </div>
        
    </div>
<%}%>
</form> 
</body>
</html>
