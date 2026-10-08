<%--
**********************************************
* 메뉴 : 
* 화면 : 부서별 집계 
* 기능 : 부서별 집계 팝업
* 프로그램 ID : PG_04_B_004_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
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
Map<String,String> _dataList1 = (Map<String,String>) request.getAttribute("data1"); // Form 조회된결과 
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // Grid 조회된결과  
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)
Map<String,String> _tmp = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	_tmp = _dataList1;
}
%>
<script type="text/javascript">
function kep_onload_view(){
	<%
		if (_dataList1==null || _dataList1.size()==0){
	%>
			kepSearch();
	<%	
		}
	%>
}

function kepSearch()
{ 
  $('#buyerMpRqDepartmentTotalPop').attr("action", "/mprq/getBuyerMpRqDepartmentTotalPop.do").submit();    
}

//팝업함수호출
function doPop(str, value1) {
	switch (str) {
	case "attach":
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R"; // 보기전용
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		
		break;
		
	case "negoHistory":
		var buyer = $("#st_buyer").val();
		var quotation_no = $("#st_quotation_no").val();
		var revision = $("#st_revision").val();
		
		popupSel = "buyerMpRqQuotationNegoHistoryPop";
		openSearchPopup("/mprq/getBuyerMpRqQuotationNegoHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+value1+'&st_revision='+revision, "900,300,no");
		
		break;
	}
}

//-->
</script> 
<body onload="kep_onload_view();">
  <form name="buyerMpRqDepartmentTotalPop" id="buyerMpRqDepartmentTotalPop" method=post >
	<input type="hidden" name=st_buyer id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name=st_quotation_no id="st_quotation_no" size=20 value="<%=st_quotation_no%>" >
	<input type="hidden" name=st_revision id="st_revision" size=20 value="<%=st_revision%>" >
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 	
	<!--최소 가로길이 400px/ 900*500-->
	<div id="popWrapper" style="height:490px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE861") %><!-- 견적 상세내역 정보 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <!--데이타그리드-->
        	<table class="cont_t_list06 mb15" style="width:100%;">
            	<caption>견적 상세내역 정보</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
                      <td colspan="3"><%=CommonUtil.nvl(_tmp.get("BUYER_NAME"))%></td>
                      <th><%=CommonLang.get("HTITLE862") %><!-- 의뢰번호 --></th>
                      <td><%=st_quotation_no%></td>
                    </tr>
                    <tr>
                      <th><%=CommonLang.get("HTITLE40") %><!-- 의뢰자 --></th>
                      <td><%=CommonUtil.nvl(_tmp.get("BTOA_USER_NAME"))%></td>
                      <th><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
                      <td><%=CommonUtil.nvl(_tmp.get("BTOA_USER_MAIL"))%></td>
                      <th><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
                      <td><%=CommonUtil.nvl(_tmp.get("BTOA_USER_TEL"))%></td>
                    </tr>
                </tbody>
            </table>
            
            <!--grid-->
            <div class="scrollArea" style="height:303px">
	            <table  class="cont_t_list06"  style="width:100%">
	                <caption>견적 상세내역 정보</caption>
	                <colgroup>
	                    <col width="7%" />
	                    <col width="10%" />
	                    <col width="*%" />
	                    <col width="7%" />
	                    <col width="7%" />
	                    <col width="10%" />
	                    <col width="10%" />
	                    <col width="10%" />
	                    <col width="11%" />
	                    <col width="8%" />
	                </colgroup>
	                <thead>
	                    <tr>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE863") %><!-- 차수 --><br><%=CommonLang.get("HTITLE140") %><!-- 순번 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE565") %><!-- 품명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE45") %><!-- 수량 --><br><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --><br><%=CommonLang.get("HTITLE120") %><!-- 원산지 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE864") %><!-- 목표단가 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE865") %><!-- 합의담당자 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE866") %><!-- 고객사비고 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE867") %><!-- 견적취소사유 --></th>
	                        <th scope="col" class="center"><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>
	                    </tr>
	                </thead>
	                <tbody>
	<% 
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _tmp2 = _dataList2.get(j);
	%>                 
	                    <tr>
	                    	<%
	                    	if(!("").equals(CommonUtil.nvl(_tmp2.get("NEGO_COUNT")))){
	                    	%>
	                    		<td title="차수" class="center"><a class="hyperLink b" href="javascript:doPop('negoHistory','<%=CommonUtil.nvl( _tmp2.get("QUOTATION_SEQ"))%>')"><b><%=CommonUtil.nvl(String.valueOf(_tmp2.get("REVISION")))%></b></a></td>	
							<%
	                    	} else{
	                    	%>
		                    	<td title="차수" class="center"><%=CommonUtil.nvl(String.valueOf(_tmp2.get("REVISION")))%></td>
	                    	<%
	                    	}
	                    	%>
	                        <td title="품목코드"><%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%></td>
	                        <td title="품명"><%=CommonUtil.nvl(_tmp2.get("DESCRIPTION"))%></td>
	                        <td title="수량" class="right"><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></td>
	                        <td title="제조사"><%=CommonUtil.nvl(_tmp2.get("MAKER_NAME"))%></td>
	                        <td title="목표단가" class="right" rowspan="2"><%=CommonUtil.formatNumber(_tmp2.get("BUYER_TARGET_PRICE"),true,0,3)%></td>
	                        <td title="합의담당자" class="center" rowspan="2"><%=CommonUtil.nvl(_tmp2.get("CONFIRM_USER_ID"))%></td>
	                        <td title="고객사비고" rowspan="2"><%=CommonUtil.nvl(_tmp2.get("BTOA_REMARK"))%></td>
	                        <td title="견적취소사유" rowspan="2"><%=CommonUtil.nvl(_tmp2.get("CANCEL_REMARK"))%></td>
	                        <td title="첨부" class="center" rowspan="2">
	                        <%
								if (("").equals(CommonUtil.nvl(_tmp2.get("IMAGE_KEY")))) { 
								%>
									<img name = "image_key_img" src="/resources/images/disk_off.gif" border="0">
								<%
									}else{
								%>         
									<a class="hyperLink" href="javascript:doPop('attach','<%=CommonUtil.nvl( _tmp2.get("IMAGE_KEY"))%>')"><img name = "image_key_img" src="/resources/images/disk_on.gif" border="0"></a>    
								<%
									}
								%>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td title="순번" class="center"><%=CommonUtil.nvl(String.valueOf(_tmp2.get("QUOTATION_SEQ")))%></td>
	                        <td title="진행상태" class="center"><%=CommonUtil.nvl(_tmp2.get("SOURCING_STATUS"))%></td>
	                        <td title="규격"><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td>
	                        <td title="단위" class="center"><%=CommonUtil.nvl(_tmp2.get("UNIT_MEASURE"))%></td>
	                        <td title="원산지"><%=CommonUtil.nvl(_tmp2.get("ORIGIN_NAME"))%></td>
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
