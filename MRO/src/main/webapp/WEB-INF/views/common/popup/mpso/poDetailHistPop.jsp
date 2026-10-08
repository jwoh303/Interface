<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>코리아 e 플랫폼</title>
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
String st_hist_id = CommonUtil.nvl((String) request.getParameter("st_hist_id"),"");  //  (조회조건)
String st_hist_dttm = CommonUtil.nvl((String) request.getParameter("st_hist_dttm"),"");  //  (조회조건)
Map<String,String> rowData = null;
double tot_price = 0;
String seller = "";
String add_user_id ="";
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1;
	seller = rowData.get("SELLER");
	add_user_id = rowData.get("ADD_USER_ID");
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
  $('#poDetailHistPop').attr("action", "/mpso/poDetailHistPop.do").submit();   
}

//팝업함수호출
function doPop(str, value1, value2, value3, value4) {
	switch (str) {
	
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "catalogDetailPop": // 품목코드
		getBuyerCatalogDisplayPop(value1, value2, value3, value4);
		break;
	case "reportViewerPop": //발주서 출력
		var fileName = "RD_06_B_003_02"; // 리포트파일 이름
		var pono			= "<%=st_po_no%>";
		var buyer			= "<%=st_buyer%>";
		var seller		= "<%=seller%>";
		var add_user_id	= "<%=add_user_id%>";
		
		var param = "["+pono+"]["+seller+"]["+buyer+"]"; // 파라미터

	     if((buyer == 'KRDOOD0001' || buyer == 'KRDOOS0004' ) && add_user_id != "1110"){	// 1110 ==> 지원)총무팀
				reportOpen("RD_06_B_003_00",param);
	       }else if(buyer == 'KRDAEW0023' || buyer == 'KRDHIM0001'){
				reportOpen("RD_06_B_003_02",param);
	       }else if(buyer == 'KRILJI0026'){
				reportOpen("RD_06_S_003_00",param);
	       }else{
				reportOpen("RD_06_S_002_06",param);
	       }
		break;
	}
}


//유통발주건의 유통진행상황팝업
//
function viewKwayProcessPop(buyer,po_no,po_seq)
{
    var left = 0;
    var top = 0;
    var width = 1000;
    var height = 380;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';

    window.open('/kr/sysop/proxbuy/order/progress/sysop_order_progress_order_kway_pop.jsp?st_buyer='+buyer+'&st_po_no='+po_no+'&st_po_seq='+po_seq, 'Win_', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

    return;

}

//-->
</script> 
<body onload="kep_onload_view();">
	<form name="poDetailHistPop" id="poDetailHistPop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_po_no" id="st_po_no" size=20 value="<%=st_po_no%>" >
	<input type="hidden" name="st_hist_id" id="st_hist_id" size=20 value="<%=st_hist_id%>" >
	<input type="hidden" name="st_hist_dttm" id="st_hist_dttm" size=20 value="<%=st_hist_dttm%>" >
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 	
	<!--최소 가로길이 400px-->
	<div id="popWrapper" style="height:544px;">
    	<div id="popHeader">
        	<h1 class="title">발주상세정보(이력)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <!--데이타그리드-->
        	<table class="cont_t_list06 mb15" style="width:100%;">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="*" />
                    <col width="12%" />
                    <col width="15%" />
                    <col width="12%" />
                    <col width="15%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th>고객사</th>
                      <td class="b"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></td>
                      <th>발주부서</th>
                      <td><%=CommonUtil.nvl(rowData.get("PO_DEPT_NAME"))%></td>
                      <th>요청부서</th>
                      <td><%=CommonUtil.nvl(rowData.get("REQ_DEPT_NAME"))%></td>
                    </tr>
                    <tr>
                      <th>발주번호</th>
                      <td class="b"><%=CommonUtil.nvl(rowData.get("PO_NO"))%></td>
                      <th>발주자</th>
                      <td><%=CommonUtil.nvl(rowData.get("PO_USER_NAME"))%></td>
                      <th>요청자</th>
                      <td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%></td>
                    </tr>
                    <tr>
                      <th>발주일</th>
                      <td><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("PO_CREATE_DATE")))%></td>
                      <th>매입금액</th>
                      <td><%=CommonUtil.formatNumber(rowData.get("AGENT_AMT"),true,0,3)%></td>
                      <th>매출금액</th>
                      <td><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>
                    </tr>
                    <tr>
                      <th>도착지</th>
                      <td colspan="3"><%=CommonUtil.nvl(rowData.get("DELY"))%></td>
                      <th>납품유형</th>
                      <td><%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%></td>
                    </tr>
                    <tr>
                      <th class="lineNone">비고</th>
                      <td colspan="5" class="lineNone"><%=CommonUtil.nvl(rowData.get("REMARK"))%></td>
                    </tr>
                </tbody>
            </table>
            
            <!--grid-->
            <div class="scrollArea" style="height:240px">
	            <table  class="cont_t_list06"  style="width:100%">
	                <caption>상세내역</caption>
	                <colgroup>
	                    <col width="12%" />
	                    <col width="12%" />
	                    <col width="12%" />
	                    <col width="11%" />
	                    <col width="9%" />
	                    <col width="9%" />
	                    <col width="13%" />
	                    <col width="15%" />
	                </colgroup>
	                <thead>
	                    <tr>
	                        <th scope="col">협력사</th>
	                        <th scope="col">품목코드</th>
	                        <th scope="col">발주일</th>
	                        <th scope="col">매출단가</th>
	                        <th scope="col">발주수량</th>
	                        <th scope="col">매출금액</th>
	                        <th scope="col">제조사</th>
	                        <th scope="col" class="rLineNone">I/F발주번호</th>
	                    </tr>
	                    <tr>
	                      <th scope="col">발주항번</th>
	                      <th scope="col">관리번호</th>
	                      <th scope="col">납기요청일</th>
	                      <th scope="col">매입단가</th>
	                      <th scope="col">단위</th>
	                      <th scope="col">매입금액</th>
	                      <th scope="col">협력사품목코드</th>
	                      <th scope="col" class="rLineNone">I/F발주행번</th>
	                    </tr>
	                    <tr>
	                      <th colspan="3" scope="col">품목명</th>
	                      <th colspan="4" scope="col">규격</th>
	                      <th scope="col" class="rLineNone">비고</th>
	                    </tr>
	                </thead>
	                <tbody>
	<% 
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _tmp2 = _dataList2.get(j);
		tot_price += Double.parseDouble(CommonUtil.formatNumber(_tmp2.get("PO_AMT"),false,0,3));
	%>                 
	                    <tr>
	                        <td><a href="javascript:doPop('agent','<%=CommonUtil.nvl(_tmp2.get("AGENT"))%>')" class="hyperLink"><%=CommonUtil.nvl(_tmp2.get("AGENT_NAME"))%></a></td>
	                        <td><a href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(_tmp2.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_SEQ"))%>')" class="hyperLink"><%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%></a></td>
	                        <td><%=CommonUtil.formatStrinigDate(_tmp2.get("PO_CREATE_DATE"))%></td>
	                        <td><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE"),true,0,3)%></td>
	                        <td><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></td>
	                        <td><%=CommonUtil.formatNumber(_tmp2.get("PO_AMT"),true,0,3)%></td>
	                        <td><%=CommonUtil.nvl(_tmp2.get("MAKER_NAME"))%></td>
	                        <td><%=CommonUtil.nvl(_tmp2.get("LEGACY_PO_NO"))%></td>
	                    </tr>
	                    <tr>
	                      <td><%=CommonUtil.nvl(_tmp2.get("PO_SEQ"))%></td>
	                      <td><%=CommonUtil.nvl(_tmp2.get("REF_PR_NO"))%></td>
	                      <td><%=CommonUtil.formatStrinigDate(_tmp2.get("RD_DATE"))%></td>
	                      <td><%=CommonUtil.formatNumber(_tmp2.get("AGENT_PRICE"),true,0,3)%></td>
	                      <td><%=CommonUtil.nvl(_tmp2.get("UNIT_MEASURE"))%></td>
	                      <td><%=CommonUtil.formatNumber(_tmp2.get("AGENT_AMT"),true,0,3)%></td>
	                      <td><%=CommonUtil.nvl(_tmp2.get("SELLER_ITEM_NO"))%></td>
	                      <td><%=CommonUtil.nvl(_tmp2.get("LEGACY_PO_SEQ"))%></td>
	                    </tr>
	                    <tr>
	                      <td colspan="3" ><%=CommonUtil.nvl(_tmp2.get("DESCRIPTION"))%></td>
	                      <td colspan="4" ><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td>
	                      <td><%=CommonUtil.nvl(_tmp2.get("PO_REMARK"))%></td>
	                    </tr>
	<% } %>
	                </tbody>
	            </table>
	         </div>
	            <table>
					  <tr>
					    <td class="right" height = "30" style="padding-bottom:2px"> <b><font color="#990000">금액합계</font> : <font color="#006699">
					             <%=CommonUtil.formatNumber(tot_price,true,0,3)%>&nbsp;원</font>&nbsp;</b>
					    </td>
					  </tr>
	            </table>
            <!--버튼영역-->
            <div class="btnArea mt05 mb0">
                <!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
                <span class="btn_04 mr04"><a href="javascript:doPop('reportViewerPop');">출력양식</a></span>
            </div>
            

        </div>
    </div>
<%}%>    
</form> 
</body>
</html>
