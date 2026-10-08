<%--
**********************************************
* 메뉴 : 
* 화면 : 상세조회 및 송장생성
* 기능 : 
* 프로그램 ID : PG_07_M_900_22
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-29
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

String st_search_flag					= CommonUtil.nvl((String) request.getParameter("st_search_flag"),"");
String st_agent					= CommonUtil.nvl((String) request.getParameter("st_agent"),"");
String st_vpo_no					= CommonUtil.nvl((String) request.getParameter("st_vpo_no"),"");
String st_item_amt					= CommonUtil.nvl((String) request.getParameter("st_item_amt"),"");
String st_rd_date					= CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");
String st_vpo_date					= CommonUtil.nvl((String) request.getParameter("st_vpo_date"),"");
String st_buyer					= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_dely_to_location_text    = CommonUtil.nvl((String) request.getParameter("st_dely_to_location"),"");

%>

<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (!"Y".equals(st_search_flag)){
	%>
		kepSearch();
	<%	
		}
	%>
}

function kepSearch()
{  
  $('#commonMpIvDetailInvoiceCreationPop').attr("action", "/mpiv/getCommonMpIvDetailInvoiceCreationPop.do").submit();
}

function setInvCreate(){
	var invCnt = $("input[name=buyer_item_no]").length;
	
	if(invCnt <= 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	
	var query = "";
	
	for(var inx = 0 ; inx < invCnt ; inx++){
		query += $("input[name=buyer_item_no]:eq("+inx+")").val();
		query += "@@";
		query += $("input[name=iv_qty]:eq("+inx+")").val();
		query += "@@";
		query += $("input[name=rd_date]:eq("+inx+")").val();
		query += "@@";
		query += $("input[name=buyer]:eq("+inx+")").val();
		query += "@@";
        query += $("input[name=vpo_seq]:eq("+inx+")").val(); 
        query += "^||^";
	}
	
	if(confirm("송장을 작성 하시겠습니까?")){
		$("#st_query").val(query);
		kepAjaxFormCall("/mpiv/saveCommonMpIvDetailInvoiceCreationPop.do","commonMpIvDetailInvoiceCreationPop","invCreate");
	}
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "invCreate"){
		alert("송장작성이 성공적으로 이루어 졌습니다.");
		setResult(response);
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

//거래명세서 작성 성공 후 호출
function setResult(response){
	var vpo_no = response.st_vpo_no;
	
	sheetWin(vpo_no); //거래명세서 출력.
	
	opener.setPopupReturn();
	this.close();
}

function sheetWin(vpo_no) {
	var tr_buyer	= $("#st_buyer").val();
	var st_agent	= $("#st_agent").val();
	var rpt_url		= "";
	
	// 고객사에 따른 REPORT 양식(기본 : RD_06_S_003_04), 조회된 결과로 특수로직 사용하기 어려워 하드코딩함.
    if(tr_buyer == "KRKORE0424"){ // GS칼텍스 여수 물류센터
    	rpt_url = "RD_06_S_003_50";
    }else{
    	rpt_url = "RD_06_S_003_04";
    }
	
    if(vpo_no.length == 0 ){
        alert("조회한 결과가 없습니다.");
        return;
    }else{
    	var param = "["+tr_buyer+"]["+vpo_no+"]["+st_agent+"]";
    	
    	reportOpen(rpt_url, param);
    }
}

//-->
</script> 
<body onload="kep_onload_view();">
<form name="commonMpIvDetailInvoiceCreationPop" id="commonMpIvDetailInvoiceCreationPop" method=post >
<input type="hidden" name="st_search_flag" id="st_search_flag"  value="Y">
<input type=hidden name="st_agent" id="st_agent"  value="<%=st_agent%>">
<input type=hidden name="st_vpo_no" id="st_vpo_no"  value="<%=st_vpo_no%>">
<input type=hidden name="st_item_amt" id="st_item_amt"  value="<%=st_item_amt%>">
<input type=hidden name="st_rd_date" id="st_rd_date"  value="<%=st_rd_date%>">
<input type=hidden name="st_vpo_date" id="st_vpo_date"  value="<%=st_vpo_date%>">
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type="hidden" name="st_dely_to_location_text" id="st_dely_to_location_text"  value="<%=st_dely_to_location_text%>">
<input type=hidden name="st_query" id="st_query"  value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">상세조회 및 송장생성</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<h2>상세정보</h2>
	
			<table  class="cont_t_list06 mb15" summary="회원사" style="width:100%;">
				<caption>상세조회</caption>
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="*" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">발주번호</th>
					<td><font color="blue"><%=st_vpo_no%></font></td>
		    		<th scope="row">권고발주일</th>
					<td><%=CommonUtil.formatStrinigDate(st_vpo_date)%></td>
		    		<th scope="row">입고요청일</th>
					<td><%=CommonUtil.formatStrinigDate(st_rd_date)%></td>
				</tr>
		    	<tr>
		    		<th scope="row">금액합계</th>
					<td><%=CommonUtil.formatNumber(String.valueOf(st_item_amt),true,0,3)%></td>
		    		<th scope="row">도착지</th>
					<td colspan="3"><%=st_dely_to_location_text%></td>
				</tr>
		        </tbody>
		   </table>
             
           	<!--grid-->
            <div class="scrollArea" style="height:284px">
                <table id="tblInv" class="cont_t_list02"  style="width:100%">
                    <caption>상세조회 및 송장생성 리스트</caption>
                    <colgroup>
                        <col width="19%" />
                        <col width="30%" /> 
                        <col width="11%" /> 
                        <col width="11%" /> 
                        <col width="11%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">물류센터명<br>품목코드</th> 
                            <th scope="col">품목명<br/>규격</th> 
                            <th scope="col">단위<br/>발주수량</th> 
                            <th scope="col">발주단가<br/>발주금액</th> 
                            <th scope="col">송장수량<br/>납품확정일</th> 
                            <th scope="col">비고</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%> 
                        <tr align="center" bgcolor="<%=tclass%>">
							<td class="left">
								<%=_tmp.get("WMS_NAME")%>
								<input type=hidden name="buyer_item_no" id="buyer_item_no"  value="<%=_tmp.get("BUYER_ITEM_NO")%>">
								<input type=hidden name="iv_qty" id="iv_qty"  value="<%=_tmp.get("IV_QTY")%>">
								<input type=hidden name="rd_date" id="rd_date"  value="<%=_tmp.get("RD_DATE")%>">
								<input type=hidden name="buyer" id="buyer"  value="<%=_tmp.get("BUYER")%>">
								<input type=hidden name="vpo_seq" id="vpo_seq"  value="<%=_tmp.get("VPO_SEQ")%>">
							</td>
							<td class="left"><%=_tmp.get("DESCRIPTION")%></td>
							<td class="center"><%=_tmp.get("UNIT_MEASURE")%></td>
							<td class="right"><%=CommonUtil.formatNumber(String.valueOf(_tmp.get("UNIT_PRICE")),true,0,3)%></td>
							<td class="right"><%=CommonUtil.formatNumber(String.valueOf(_tmp.get("IV_QTY")),true,0,3)%></td>
							<td class="left" rowspan="2"><%=_tmp.get("VPO_REMARK")%></td>
                        </tr>
                        <tr align="center" bgcolor="<%=tclass%>">
							<td><%=_tmp.get("BUYER_ITEM_NO")%></td>
							<td class="left"><%=_tmp.get("SPECIFICATION")%></td>
							<td class="right"><%=CommonUtil.formatNumber(String.valueOf(_tmp.get("ITEM_QTY")),true,0,3)%></td>
							<td class="right"><%=CommonUtil.formatNumber(String.valueOf(_tmp.get("ITEM_AMT")),true,0,3)%></td>
							<td class="center"><%=CommonUtil.formatStrinigDate(_tmp.get("RD_DATE"))%></td>
                        </tr>
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>
    
   	<!--버튼영역-->
	<div class="btnArea mr25">
		<span class="fr">
			<span class="btn_03 mr04"><a href="javascript:setInvCreate();">송장등록</a></span>
		</span>
	</div>
</div>
</form> 
</body>
</html>
