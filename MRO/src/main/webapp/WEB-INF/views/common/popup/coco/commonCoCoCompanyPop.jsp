<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사/고객사 선택 팝업
* 기능 : 협력사 또는 고객사를 검색 조회 할 수 있는 팝업
* 프로그램 ID : 
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-30
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   

String com_type	  	= CommonUtil.nvl((String)  request.getParameter("com_type"),"");
String safety_flag	  	= CommonUtil.nvl((String)  request.getParameter("safety_flag"),"");
String kway_flag	  	= CommonUtil.nvl((String)  request.getParameter("kway_flag"),"");
String com_name	  	= CommonUtil.nvl((String)  request.getParameter("com_name"),"");

String title = "";
if( com_type.equals("B")){
	title = "고객사 선택" ;
}else{
	title = "협력사 선택" ;
}

%>

<script type="text/javascript">
<!--
function kepSearch(){
	if(isEmpty($("#com_name").val())){
		alert("검색조건을 입력해 주십시요");
		$("#com_name").focus();
		return;
	}
	
	$('#commonCoCoCompanyPop').attr("action", "/coco/getCommonCoCoCompanyPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(com_code, com_name, com_org_level, com_org_code, site) {
	var db_com_code = "'" + com_code + "'";
	var com_info = com_name;
	var com_type = $("input[name=com_type]").val();
	
	opener.setPopupReturn(com_code, com_name, com_org_level, com_org_code, db_com_code, com_info, com_type, site);
	this.close();
}

function reload(){
	document.location.href = "/coco/showCommonCoCoCompanyPop.do?com_type=<%=com_type%>&safety_flag=<%=safety_flag%>&kway_flag=<%=kway_flag%>";
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoCompanyPop" id="commonCoCoCompanyPop" method=post >
	<input type=hidden name=com_type    value="<%=com_type%>">
	<input type=hidden name=safety_flag  value="<%=safety_flag%>">
	<input type=hidden name=kway_flag  value="<%=kway_flag%>">
	<input type=hidden name=com_code    value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title %></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
            	<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption><%=title %> 리스트</caption>
						<colgroup>
                            <col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><% if(com_type.equals("B")){ out.println( "고객사" ); }else{ out.println( "협력사" ); } %>&nbsp;</td>
							<td>
								<input type=text name=com_name id="com_name" value="<%=com_name%>" style="width: 80%;" onkeydown="kepEnter()" class="input_type_text">
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" />
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption><%=title %> 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">업체코드</th> 
                            <th scope="col">업체명</th> 
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
						 	<a href="javascript:setReturn('<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("COM_NAME")%>','<%=_tmp.get("CLEVEL")%>','<%=_tmp.get("COMG_CODE")%>','<%=_tmp.get("SITE")%>')">
							<%=_tmp.get("COM_CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("COM_NAME")%>','<%=_tmp.get("CLEVEL")%>','<%=_tmp.get("COMG_CODE")%>','<%=_tmp.get("SITE")%>')">
							<%=_tmp.get("COM_NAME")%></a>
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
