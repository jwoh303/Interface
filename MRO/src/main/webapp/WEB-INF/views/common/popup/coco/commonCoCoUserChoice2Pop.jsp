<%--
**********************************************
* 메뉴 : 
* 화면 : 사용자 선택 2
* 기능 : 사용자를 선택하기 위한 팝업
* 프로그램 ID : PG_90_C_900_24
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-03
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
String st_user_name   = CommonUtil.nvl((String) request.getParameter("st_user_name"));
String st_com_name    = CommonUtil.nvl((String) request.getParameter("st_com_name"));
String st_com_code    = CommonUtil.nvl((String) request.getParameter("st_com_code"));
%>

<script type="text/javascript">
function kep_onload_view(){ 
<%
	if(_sessionInfo == null){
%>
		$('#commonCoCoUserChoice2Pop').attr("action", "http://www.koreab2b.com").submit();
<%
	}else{
		if(_sessionInfo.getComCode().equals("KRKORE0001") == false){
			st_com_code = _sessionInfo.getComCode(); 	
		}
	}
%>
}
<!--
function kepSearch(){
	var user_name = $("#st_user_name").val();
	var com_name = $("#st_com_name").val();
	var com_code = $("#st_com_code").val();
	
	if( isEmpty(user_name) && isEmpty(com_name) && isEmpty(com_code) ){
		alert("적어도 한가지 조건을 입력하시야 합니다.");
		return;
	}

	$('#commonCoCoUserChoice2Pop').attr("action", "/coco/getCommonCoCoUserChoice2Pop.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="commonCoCoUserChoice2Pop" id="commonCoCoUserChoice2Pop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 선택 2</h1>
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
						<caption>사용자 선택 2 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>이름</td>
							<td><input type=text name="st_user_name" id="st_user_name" size=20 value="<%=st_user_name%>" onkeydown="kepEnter()" class="input_type_text" style="ime-mode:active" /></td>
							<td>회원사명</td>
							<td><input type=text name="st_com_name" id="st_com_name" size=20 value="<%=st_com_name%>" onkeydown="kepEnter()" class="input_type_text" style="ime-mode:active" /></td>
							<td>회원사코드</td>
							<td>
								<input type=text name="st_com_code" id="st_com_code" size=20 value="<%=st_com_code%>" onkeydown="kepEnter()" onkeyup="kepToUpper('st_com_code');" class="input_type_text" style="ime-mode:disabled">
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>사용자 선택 2 리스트</caption>
                    <colgroup>
                        <col width="12%" /> 
                        <col width="12%" /> 
                        <col width="20%" /> 
                        <col width="16%" /> 
                        <col width="15%" /> 
                        <col width="15%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">ID</th> 
                            <th scope="col">이름</th> 
                            <th scope="col">회원사</th> 
                            <th scope="col">부서</th> 
                            <th scope="col">전화번호</th> 
                            <th scope="col">E-MAIL</th> 
                            <th scope="col">구분</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
					<tr>
						<td class="left">
						 	<a href="javascript:openSearchPopup('/common/userDisplayPop.do','?user_id=<%=_tmp.get("USER_ID")%>','800,500,no')">
							<%=_tmp.get("USER_ID")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("USER_ID")%>','<%=_tmp.get("USER_NAME_LOC")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("DEPARTMENT_NAME")%>','<%=_tmp.get("PHONE_NUMBER")%>','<%=_tmp.get("EMAIL")%>','<%=_tmp.get("GUBUN")%>','<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("DEPARTMENT")%>');">
							<%=_tmp.get("USER_NAME_LOC")%></a>
					   </td>
						<td class="left">
								<a href="javascript:openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code=<%=_tmp.get("COM_CODE")%>','800,550,no')">
							<%=CommonUtil.nvl(_tmp.get("COM_NAME_LOC"))%></a>
						</td>
						<td class="left"><%=_tmp.get("DEPARTMENT_NAME")%></td>
						<td class="left"><%=_tmp.get("PHONE_NUMBER")%></td>
						<td class="left"><%=_tmp.get("EMAIL")%></td>
						<td><%=_tmp.get("GUBUN")%></td>
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
