<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사, 협력사 팝업
* 기능 : 
* 프로그램 ID : PG_10_M_900_02
* 담당자 : 고영일 ( 설계 : 김상근 )
* 착수일 : 2014-08-18
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

String st_com_type = CommonUtil.nvl((String) request.getParameter("st_com_type"),"");
String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"),"");
String st_sys_change_flag = CommonUtil.nvl((String) request.getParameter("st_sys_change_flag"),"");
String st_com_name = CommonUtil.nvl((String) request.getParameter("st_com_name"),"");

String title = "";
if( st_com_type.equals("B")){
    title = "고객사" ;
}else{
    title = "협력사" ;
}

%>

<script type="text/javascript">
<!--
function kep_onload(){
	kepAjaxCommonComboDataValue('st_sys_type','VC04','ALL','<%=st_sys_type%>');
	if($("#st_sys_change_flag").val() == "Y"){
		$("#st_sys_type").show();
		$("#spanSysTypeNm").hide();
	}else{
		var st_sys_type_nm =  $("#st_sys_type option:eq(" + $("#st_sys_type option[value=" + $("#st_sys_type").val() +"]").index() + ")").text();
		$("#spanSysTypeNm").html(st_sys_type_nm);
		$("#st_sys_type").hide();
		$("#spanSysTypeNm").show();
	}
}

function kepSearch(){
	if(isEmpty($("#st_com_name").val())){
		alert("검색조건을 입력해 주십시요");
		$("#st_com_name").focus();
		return;
	}
	$('#masterCmCoBuyerAgntcmpyPop').attr("action", "/cmco/getMasterCmCoBuyerAgntcmpyPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2,value3,value4)
{ 
  	var st_com_type = $("#st_com_type").val();
	opener.setPopupReturn("",value1,value2,value4,value3,st_com_type);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload();">
<form name="masterCmCoBuyerAgntcmpyPop" id="masterCmCoBuyerAgntcmpyPop" method=post >
<input type="hidden" name="st_com_type" id="st_com_type"  value="<%=st_com_type%>">
<input type="hidden" name="st_sys_change_flag" id="st_sys_change_flag"  value="<%=st_sys_change_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title %> 선택 팝업</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption><%=title %> 팝업 리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="20%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=title %></td>
							<td>
								<select id="st_sys_type" name="st_sys_type" style="width: 70px; display: none;" ></select><span id="spanSysTypeNm" ></span>
                            </td>
						    <td>
								<input type=text name=st_com_name id="st_com_name" size=20 value="<%=st_com_name%>" onkeydown="kepEnter()" class="input_type_text"> 
						    </td>						 
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption><%=title %> 팝업 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                        <col width="30%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">시스템타입</th> 
                            <th scope="col"><%=title %>명</th> 
                            <th scope="col"><%=title %>코드</th> 
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
							 	<a href="javascript:setReturn('<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("SYS_TYPE")%>','<%=_tmp.get("COM_TYPE")%>')">
								<%=_tmp.get("SYS_TYPE_TEXT")%></a>
							</td>
							<td class="left">
							  	<a href="javascript:setReturn('<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("SYS_TYPE")%>','<%=_tmp.get("COM_TYPE")%>')">
								<%=_tmp.get("COM_NAME_LOC")%></a>
						   </td>
							<td>
								<a href="javascript:setReturn('<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("SYS_TYPE")%>','<%=_tmp.get("COM_TYPE")%>')">
								<%=CommonUtil.nvl(_tmp.get("COM_CODE"))%></a>
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
