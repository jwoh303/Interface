<%--
**********************************************
* 메뉴 : 재고관리>공구자재 재고현황>공구자재 재고현황
* 화면 : 거래고객사 팝업
* 기능 : 
* 프로그램 ID : PG_08_A_602_01
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head_pop.jspf"%>
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
%>

<script type="text/javascript">
<!--
	function kepSearch()
	{  
		$('#masterCmCoBuyerCorpRegNoListPop').attr("action", "/cmco/getMasterCmCoBuyerCorpRegNoListPop.do").submit();    
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
//-->
</script> 
<body onload="">
<form name="masterCmCoBuyerCorpRegNoListPop" id="masterCmCoBuyerCorpRegNoListPop" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">거래 고객사 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div id="searchBtnA02"></div>   
           	<!--grid-->
            <div class="scrollArea" style="height:160px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>거래 고객사 선택 리스트</caption>
                    <colgroup>
                        <col width="60%" />
                        <col width="40%" />
                    </colgroup>
                    <thead>
                        <tr>
                    		<th  scope="col">고객사명</th>
                    		<th  scope="col">재고 품목 건수</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if ( _dataList == null || _dataList.size() == 0 ) {
%>
						<tr bgcolor="#FFFFFF">
	                        <td colspan="2" align="center" height = "100px">
	                        	<span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
                    	</tr>
<%
} else {
	for ( int j=0; j<_dataList.size(); j++ ) {
		Map<String,String> _tmp = _dataList.get(j);
%> 
                    	<tr>
							<td class="left pl20">
								<a href="javascript:setReturn('<%=_tmp.get("BUYER")%>','<%=_tmp.get("BUYER_NAME")%>','')"><%=CommonUtil.nvl(_tmp.get("BUYER_NAME"))%></a>
							</td>
							<td class="right pr20">
								<a href="javascript:setReturn('<%=_tmp.get("BUYER")%>','<%=_tmp.get("BUYER_NAME")%>','')"><%=CommonUtil.formatNumber(_tmp.get("CNT"),true,0,3)%></a>
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
