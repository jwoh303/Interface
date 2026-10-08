<%--
**********************************************
* 메뉴 : 
* 화면 : WMS검증
* 기능 : WMS검증 팝업
* 프로그램 ID : 
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
String st_site=  CommonUtil.nvl((String) request.getParameter("st_site"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function setWmsCheck(){
	var errorCnt = <%=_dataList.size()%>;
	
	if(errorCnt ==0){
		opener.setPopupReturn("Y");
	}
	self.close();
	
}


 //-->
</script> 
<body>
<form name="masterMdCmWmsCheckPop" id="masterMdCmWmsCheckPop" method=post >
<input type=hidden name="st_site" id="st_site"  value="<%=st_site%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:443px;">
    	<div id="popHeader">
        	<h1 class="title">WMS 검증 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:350px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>WMS 검증  리스트</caption>
                    <colgroup>
                        <col width="82" />
						<col width="95" />
						<col width="94" />
						<col width="82" />
						<col width="91" />
                        <col width="124" />
                        <col width="121" />
                        <col width="82" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사코드</th> 
                            <th scope="col">고객사명</th> 
                            <th scope="col">고객사품목코드</th> 
                            <th scope="col">물류센터</th> 
                            <th scope="col">기존 재고코드</th> 
                            <th scope="col">기존 재고코드 수량</th>
                            <th scope="col">신규 CMS 매핑코드</th> 
                            <th scope="col">유통사용여부</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="8" align="center" height = "280">
                        <span class="font1"><b>WMS 오류건이 없습니다 .</b></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
								<%=_tmp.get("BUYER")%>
							</td>
							<td>
								<%=_tmp.get("BUYER_NAME")%>
							</td>
							<td>
								<%=_tmp.get("BUYER_ITEM_NO")%>
							</td>
							<td class="right">
								<%=_tmp.get("AGENT_NAME")%>
						   </td>
						   <td class="right">
								<%=_tmp.get("CMS_CATLG_ID")%>
						   </td>
						   <td class="right">
								<%=_tmp.get("TOT_QTY")%>
						   </td>
						   <td class="left" >
								<%=_tmp.get("MAP_CMS_CATLG_ID")%>
						   </td>
						   <td class="left" >
								<%=_tmp.get("USE_YN").equals("0")?"미사용":"사용"%>
						   </td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
        
        <!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_02"><a href="javascript:setWmsCheck();">검증완료</a></span>
			</span>
		</div>
    </div>        
</div>
</form> 
</body>
</html>
