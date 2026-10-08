<%--
**********************************************
* 메뉴 : 
* 화면 : 단가변경이력 
* 기능 : 매출, 매입 단가변경이력 조회 팝업
* 프로그램 ID : PG_03_M_002_07
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-12
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
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String contract_no = CommonUtil.nvl((String) request.getParameter("st_contract_no"),"");  //  (조회조건)
String contract_seq = CommonUtil.nvl((String) request.getParameter("st_contract_seq"),"");  //  (조회조건)
String buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String site = CommonUtil.nvl((String) request.getParameter("st_site"),"");  //  (조회조건)
String status_flag = CommonUtil.nvl((String) request.getParameter("status_flag"),"");
%>

<script type="text/javascript">
<!--
function popupOnload(){
	var status_flag = $("#status_flag").val();
	if(status_flag!='N'){
		kepSearch();
	}
}


function kepSearch()
{  
	$("#status_flag").val("N");
  	$('#masterMdCmUnitpriceAlterHistoryPop').attr("action", "/mdcm/getMasterMdCmUnitpriceAlterHistoryPop.do").submit();    
}
 //-->
</script> 
<body onload="popupOnload()">
<form name="masterMdCmUnitpriceAlterHistoryPop" id="masterMdCmUnitpriceAlterHistoryPop" method=post >
<input type=hidden name="buyer" id="buyer"  value="<%=buyer%>">
<input type=hidden name="contract_no" id="contract_no"  value="<%=contract_no%>">
<input type=hidden name="contract_seq" id="contract_seq"  value="<%=contract_seq%>">
<input type=hidden name="buyer_item_no" id="buyer_item_no"  value="<%=buyer_item_no%>">
<input type=hidden name="site" id="site"  value="<%=site%>">
<input type=hidden name="status_flag" id="status_flag"  value="<%=status_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px;">
    	<div id="popHeader">
        	<h1 class="title">단가변경이력 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:180px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>단가변경이력  리스트</caption>
                    <colgroup>
                        <col width="5%" />
						<col width="11%" />
						<col width="11%" />
						<col width="10%" />
						<col width="10%" />
                        <col width="8%" />
                        <col width="17%" />
                        <col width="8%" />
                        <col width="20%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순번</th> 
                            <th scope="col">시작일</th> 
                            <th scope="col">종료일</th> 
                            <th scope="col">매출단가</th> 
                            <th scope="col">매입단가</th> 
                            <th scope="col">마진율</th>
                            <th scope="col">협력사</th> 
                            <th scope="col">수정자</th>
                            <th scope="col">비고</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="9" align="center" height = "133">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
								<%=(j+1)%>
							</td>
							<td>
								<%=CommonUtil.formatDate(_tmp.get("ADD_DATE"))%>
							</td>
							<td>
								<%=CommonUtil.formatDate(_tmp.get("TO_DATE"))%>
							</td>
							<td class="right">
								<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%>
						   </td>
						   <td class="right">
								<%=CommonUtil.formatNumber(_tmp.get("LIST_PRICE"),true,0,3)%>
						   </td>
						   <td class="right">
								<%=_tmp.get("PRE_MARGIN")%>
						   </td>
						   <td>
								<%=_tmp.get("AGENT_NAME")%>
						   </td>
						   <td>
								<%=_tmp.get("ADD_USER_NAME")%>
							</td>
						   <td class="left" >
								&nbsp;&nbsp;<%=_tmp.get("REMARK")%>
						   </td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
