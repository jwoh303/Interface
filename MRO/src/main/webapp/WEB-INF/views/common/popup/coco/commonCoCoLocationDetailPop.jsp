<%--
**********************************************
* 메뉴 : 
* 화면 : 소재지역명 상세 
* 기능 : 
* 프로그램 ID : PG_04_M_005_02
* 담당자 : 김영미 ( 설계 : 공통 )
* 착수일 : 2014-05-27
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_ag_id=  CommonUtil.nvl((String) request.getParameter("st_ag_id"), "");
%>

<script type="text/javascript">
function kep_onload_view(){
	<% if ("Y".equals(open)){%>
		kepSearch();
	<%}%>
}

function kepSearch()
{  
	$('#commonCoCoLocationDetailPop').attr("action", "/common/commonFolderList.do").submit();    
}

</script> 
<body onload="kep_onload_view()">
<form name="commonCoCoLocationDetailPop" id="commonCoCoLocationDetailPop" method=post >
<input type="hidden" name="codeGubun" id="codeGubun"  value="commonCoCoLocationDetailPop">
<input type="hidden" name="folder" id="folder"  value="coco">
<input type="hidden" name="st_ag_id" id="st_ag_id"  value="<%=st_ag_id%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:394px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">소재지역명 상세 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
           	<!--grid-->
            <div class="scrollArea" style="height:310px">
                <table  class="cont_t_list09"  style="width:100%">
                    <caption>소재지역명 상세  리스트</caption>
                    <colgroup>
                        <col width="50%" /> 
                        <col width="50%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">시(도)</th> 
                            <th scope="col">군(구)</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "260">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
							<td>
								<%=_tmp.get("SIDO")%>
							</td>
							<td>
								<%=_tmp.get("GUGUN")%>
						   </td>
							<td>
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
