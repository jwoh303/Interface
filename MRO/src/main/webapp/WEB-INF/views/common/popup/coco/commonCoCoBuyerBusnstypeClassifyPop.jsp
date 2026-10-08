<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 업종구분표
* 기능 : 고객사 등록정보 중 업종구분표 선택 팝업
* 프로그램 ID : PG_01_M_001_02
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-20
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
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#commonCoCoBuyerBusnstypeClassifyPop').attr("action", "/coco/getCommonCoCoBuyerBusnstypeClassifyPop.do").submit();    
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
<form name="commonCoCoBuyerBusnstypeClassifyPop" id="commonCoCoBuyerBusnstypeClassifyPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:444px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 업종구분표</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:368px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>고객사 업종구분표 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="15%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">업종코드</th> 
                            <th scope="col">업종명</th> 
                            <th scope="col">세부 업종 내역</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
						 	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=_tmp.get("TEXT1")%></a>
					   </td>
						<td class="left">
								<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT1")%>','')">
							<%=CommonUtil.nvl(_tmp.get("TEXT2"))%></a>
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
