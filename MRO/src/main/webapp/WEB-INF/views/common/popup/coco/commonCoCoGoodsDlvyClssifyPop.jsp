<%--
**********************************************
* 메뉴 : 제품조달방법-거래유형
* 화면 : 제품조달 방법 - 거래유형별 선택 팝업
* 기능 : 
* 프로그램 ID : 
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
Map<String,String> cmpy_info = (Map<String,String>) request.getAttribute("cmpy_info");
String st_gubun = CommonUtil.nvl((String) request.getAttribute("st_gubun"),"N");
String tr_code = "";
String vmi_code = "";
if(cmpy_info != null){
	tr_code = CommonUtil.nvl((String) cmpy_info.get("TR_CODE")); 
	vmi_code = CommonUtil.nvl((String) cmpy_info.get("VMI_CODE"));
}
%>

<script type="text/javascript">
<!--
$(document).ready(function(){
<%
if (_dataList != null && _dataList.size() > 0){
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> _item = _dataList.get(j);
// 		if("1".equals(_item.get("CODE")) || "3".equals(_item.get("CODE"))){
%>
<%-- 			kepAjaxCommonQueryIdSearchCombo("st_warehouse_code_<%=_item.get("CODE")%>","getWareHouseTypeList","<%=_item.get("CODE")%>","SEL","<%=vmi_code%>"); --%>
<%
// 		} else if( "2".equals(_item.get("CODE")) ){
%>
<%-- 			kepAjaxCommonQueryIdSearchCombo("st_warehouse_code_<%=_item.get("CODE")%>","getWareHouseTypeList","<%=_item.get("CODE")%>","SEL","<%=tr_code%>"); --%>
			kepAjaxCommonQueryIdSearchCombo("st_warehouse_code_<%=_item.get("CODE")%>","getWareHouseTypeList","2","SEL","<%=tr_code%>");
<%
// 		}
	}
}
%>
});

function setReturn(value1,value2)
{
	if($("#st_warehouse_code_"+value1).length > 0 && isEmpty($("#st_warehouse_code_"+value1).val())){
		alert(value2+"물류센터를 반드시 선택 하셔야 합니다");
		$("#st_warehouse_code_"+value1).focus();
		return;
	}
	
	if(value1 == "1" || value1 == "2" || value1 == "3"){
		var warehouse_code = $("#st_warehouse_code_"+value1).val();
		var warehouse_name = $("#st_warehouse_code_"+value1+" option:selected").text();
		opener.setPopupReturn(value1,value2,warehouse_code,warehouse_name);
	}else{
		opener.setPopupReturn(value1,value2);
	}
	this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoGoodsDlvyClssifyPop" id="commonCoCoGoodsDlvyClssifyPop" method=post >
	<input type="hidden" id="st_gubun" name="st_gubun" value="<%=st_gubun%>" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:255px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">제품조달 방법</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:177px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>배송처 선택 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="10%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드</th> 
                            <th scope="col" colspan="2">명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "110">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                     <tr>
						<td>
						 	<a class="hyperLink" href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT2")%>')"><%=_tmp.get("CODE")%></a>
						</td>
						<td class="hyperLink"  style="align:left; padding-left: 10px;">
						  	<a href="javascript:setReturn('<%=_tmp.get("CODE")%>','<%=_tmp.get("TEXT2")%>')"><%=_tmp.get("TEXT2")%></a>
					   </td>
					   <td class="left">
<%	if("1".equals(_tmp.get("CODE")) || "2".equals(_tmp.get("CODE")) || "3".equals(_tmp.get("CODE"))){	%>
							<select id="st_warehouse_code_<%=_tmp.get("CODE")%>" name="st_warehouse_code" >
							</select>
<%	}	%>
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
