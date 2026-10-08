<%--
**********************************************
* 메뉴 : 
* 화면 : 최종발주일보기 
* 기능 : 
* 프로그램 ID : PG_03_M_003_03
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-27
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
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_contract_no = CommonUtil.nvl((String) request.getParameter("st_contract_no"),"");  //  (조회조건)
String st_contract_seq = CommonUtil.nvl((String) request.getParameter("st_contract_seq"),"");  //  (조회조건)
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String st_site = CommonUtil.nvl((String) request.getParameter("st_site"),""); //  (조회조건)
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
  	$('#masterMdCmFinalOrderDateViewPop').attr("action", "/mdcm/getMasterMdCmFinalOrderDateViewPop.do").submit();    
}
 //-->
</script> 
<body onload="popupOnload()">
<form name="masterMdCmFinalOrderDateViewPop" id="masterMdCmFinalOrderDateViewPop" method=post >
<input type=hidden name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type=hidden name="st_contract_no" id="st_contract_no"  value="<%=st_contract_no%>">
<input type=hidden name="st_contract_seq" id="st_contract_seq"  value="<%=st_contract_seq%>">
<input type=hidden name="st_buyer_item_no" id="st_buyer_item_no"  value="<%=st_buyer_item_no%>">
<input type=hidden name="st_site" id="st_site"  value="<%=st_site%>">
<input type=hidden name="status_flag" id="status_flag"  value="<%=status_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:244px;">
    	<div id="popHeader">
        	<h1 class="title">최종발주일 보기 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:180px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>최종발주일 보기</caption>
                    <colgroup>
                        <col width="29%" />
						<col width="27%" />
						<col width="27%" />
						<col width="17%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사명</th> 
                            <th scope="col">품목명</th> 
                            <th scope="col">규격</th> 
                            <th scope="col">최종발주일</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "133">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
                        	<td class="left">
								<%=_tmp.get("BUYER_NAME")%>
							</td>
							<td class="left">
								<%=_tmp.get("DESCRIPTION")%>
							</td>
							<td class="left">
								<%=_tmp.get("SPECIFICATION")%>
							</td>
							<td>
								<%=CommonUtil.formatDate(_tmp.get("ADD_DATE"))%>
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
