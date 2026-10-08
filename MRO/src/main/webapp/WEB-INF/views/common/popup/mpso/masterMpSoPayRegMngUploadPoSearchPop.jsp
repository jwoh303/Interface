<%--
**********************************************
* 메뉴 : 
* 화면 : 지급이슈 등록 및 조회 팝업 내 발주 검색 팝업
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
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<%

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

%>

<script>

var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;


//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	$('#st_buyer').val('<%=st_buyer%>');
	$('#st_buyer_name').val('<%=st_buyer_name%>');
	$('#st_po_no').val('<%=st_po_no%>');
	$('#st_buyer_item_no').val('<%=st_buyer_item_no%>');
}

//기능함수
function doAction(str) {
	var buyer = $('#st_buyer').val();
	var po_no = $('#st_po_no').val();
	var buyer_item_no = $('#st_buyer_item_no').val();
	switch (str) {	
		case "search": //조회
			if(buyer == '' || buyer == null) {
				alert("고객사는 필수입력 입니다.");
				return;
			}
			if(po_no == "" && buyer_item_no == "") {
				alert("발주번호나 품목코드 하나는 입력 필수 입니다.");
				return;
			}
			$('#poSearchForm').attr("action", "/mpso/getMasterMpSoPayRegMngUploadPoSearchPop.do").submit();
			break;
		
	}
}

//기능함수
function doPop(str) {
	switch (str) {
		case "masterBuyercmpyPop": // 고객사 팝업
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "masterBuyercmpyPop";
			break;
		
	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
}


function setReturn(value1,value2,value3,value4,value5,value6,value7,value8)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8);
  this.close();
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterBuyercmpyPop") {	// 고객사, 협력사 팝업
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	
}

</script>

<body onload="kep_onload_view()">
<form name="poSearchForm" id="poSearchForm" method="post">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:350px;">
    	<div id="popHeader">
        	<h1 class="title">발주 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">        	 
             <div class="fr">             	
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>발주 조회 </caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
                            <col width="10%" />
                            <col width="40%" />
						</colgroup>
						<tbody>
						<tr>
							<td><font color="#FF6600">*</font>고객사</td>
							<td colspan="3"> 
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" value="" readonly onclick="javascript:doPop('masterBuyercmpyPop');">
								<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">								
								<a href="javascript:doPop('masterBuyercmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr>
							<td>발주번호</td>						 
							<td> 
								<input type=text name="st_po_no" id="st_po_no" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
							<td>품목코드</td>
							<td>
								<input type=text name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();">
							</td>
						</tr>
						
					</tbody>
				</table>
            </div>
            <!--grid-->
            <div style="height:200px">
	            <table  class="cont_t_list02" style="width:100%;">
	                <caption>상세내역</caption>
	                <colgroup>
	                    <col width="15%" />
	                    <col width="12%" />
	                    <col width="12%" />
	                    <col width="12%" />
	                    <col width="8%" />
	                    <col width="9%" />
	                    <col width="*%" />	                    
	                </colgroup>
	                <thead>
	                    <tr>
	                        <th scope="col" class="center">고객사명</th>
	                        <th scope="col" class="center">발주번호</th>
	                        <th scope="col" class="center">품목코드</th>
	                        <th scope="col" class="center">입고번호</th>
	                        <th scope="col" class="center">입고항번</th>
	                        <th scope="col" class="center">입고일</th>
	                        <th scope="col" class="center">품명/규격</th>	                        
	                    </tr>
	                </thead>
	                <tbody>
				<%
				if (_dataList == null || _dataList.size() == 0){
				%>
					<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
		<%}else{
		%>	                
				<% 
				for (int j=0; j<_dataList.size(); j++) {
					Map<String,String> _tmp = _dataList.get(j);
				%>                 
	                    <tr>
	                        <td class="center">		                        
		                    	<%=CommonUtil.nvl(_tmp.get("BUYER_NAME"))%>									
	                        </td>
	                        <td>	                        	
	                        	<%=CommonUtil.nvl(_tmp.get("PO_NO"))%>
	                        </td>
	                        <td>
	                        	<b><a style="color: blue;" href="javascript:setReturn('<%=CommonUtil.nvl(_tmp.get("BUYER"))%>','<%=CommonUtil.nvl(_tmp.get("PO_NO"))%>',
	                        							 '<%=CommonUtil.nvl(_tmp.get("PO_SEQ"))%>','<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%>',
	                        							 '<%=CommonUtil.nvl(_tmp.get("AGENT_NAME"))%>','<%=CommonUtil.nvl(_tmp.get("AGENT_IRS_NO"))%>',
	                        							 '<%=CommonUtil.nvl(_tmp.get("BUYER_NAME"))%>','<%=CommonUtil.nvl(_tmp.get("BUYER_IRS_NO"))%>')">
	                        							 <%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></a></b>
	                        </td>
	                         <td>
	                        	<%=CommonUtil.nvl(_tmp.get("GR_NO"))%>
	                        </td>
	                         <td>
	                        	<%=CommonUtil.nvl(_tmp.get("GR_SEQ"))%>
	                        </td>
	                         <td>
	                        	<%=CommonUtil.nvl(_tmp.get("GR_DATE"))%>
	                        </td>
	                         <td>
	                        	<%=CommonUtil.nvl(_tmp.get("ITEM_INFO"))%>
	                        </td>	                        
	                    </tr>
	<% } }%>
	                </tbody>
	            </table>
	    	</div>      
          
    </div>        
</div>
</form>
</body>
</html>
