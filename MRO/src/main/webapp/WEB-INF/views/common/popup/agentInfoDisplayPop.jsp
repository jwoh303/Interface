<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String comType = (String)_sessionInfo.getBusinessCond();
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
Map<String,String> rowData = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (_dataList1==null || _dataList1.size()==0){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery()
{ 
  $('#agent_info_display_pop').attr("action", "/common/getAgentInfoDiaplayPop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
//팝업함수호출
function doPop(str) {
	var st_agent_code = "<%=st_com_code%>";
	
	switch (str) {
	case "agentCommunity": // 협력사 커뮤니티
		if(st_agent_code == "") {
			alert("존재하지 않는 협력사입니다.");
			break;
		}

		openSearchPopup('/mdcp/getMasterMdCpAgentCommunityInfoList.do','?com_code='+st_agent_code, '800,680,no');
		break;
	}
}
 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=agent_info_display_pop id=agent_info_display_pop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="agentInfoDisplayPop"> 
	 <input type="hidden"  name="st_com_code"  id="st_com_code"  value="<%=st_com_code%>"  onkeydown="kepEnter()" /> 
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE569") %><!-- 회원사정보 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" >
		<h2><%=CommonLang.get("HTITLE569") %><!-- 회원사정보 --></h2>

		<table  class="cont_t_list06 mb15" summary="회원사" style="width:100%;">
			<caption>회원사</caption>
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tbody>
	    	<tr>
	    		<th scope="row"><%=CommonLang.get("HTITLE570") %><!-- 회원사코드 --></th>
				<td colspan="3"><font color="blue"><b><%=st_com_code%></b></font></td>
			</tr>
	    	<tr> 
	    		<th scope="row"><%=CommonLang.get("HTITLE571") %><!-- 회원사명(한글) --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td>
	    		<th scope="row"><%=CommonLang.get("HTITLE572") %><!-- 회원사명(영문) --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("COM_NAME_ENG"))%></td>
			</tr>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE335") %><!-- 사업자등록번호 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("IRS_NO"))%></td>
				<th scope="row"><%=CommonLang.get("HTITLE573") %><!-- 대표자명 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("CEO_NAME_LOC"))%></td>
			  </tr>
			  <tr>
				<th scope="row"><%=CommonLang.get("HTITLE339") %><!-- 대표전화번호 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("TEL_NO"))%></td>
				<th scope="row"><%=CommonLang.get("HTITLE574") %><!-- 대표팩스번호 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("FAX_NO"))%></td>
			  </tr>
			  <tr>
				<th scope="row"><%=CommonLang.get("HTITLE341") %><!-- 업태 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("INDUSTRY_TYPE"))%></td>
				<th scope="row"><%=CommonLang.get("HTITLE342") %><!-- 종목 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("BUSINESS_ITEMS"))%></td>
			  </tr>
			  <tr>
				<th scope="row"><%=CommonLang.get("HTITLE343") %><!-- 우편번호 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%></td>
				<th scope="row"><%=CommonLang.get("HTITLE348") %><!-- 법인등록번호 --></th>
				<td scope="row"><%=CommonUtil.nvl(rowData.get("CORP_REG_NO"))%></td>
			  </tr>
			  <tr>
				<th scope="row"><%=CommonLang.get("HTITLE345") %><!-- 주소 --></th>
				<td scope="row" colspan="3"><%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%></td>
			  </tr>
			  <tr>
				<th scope="row"><%=CommonLang.get("HTITLE575") %><!-- 경리담당자 --></th>
				<td scope="row"><%=!"S".equals(comType) ? CommonUtil.nvl(rowData.get("AC_EMP_NM")) : ""%></td>
				<th scope="row"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
				<td scope="row" ><%=!"S".equals(comType) ? CommonUtil.nvl(rowData.get("AC_EMP_TEL")) : ""%></td>
			  </tr> 
<%
if ("M".equals(comType) && "S".equals(CommonUtil.nvl(rowData.get("BUSINESS_COND")))){
%>
<tr>
	<th scope="row">최근거래일</th>
	<td class="row" colspan="3"><%=CommonUtil.nvl(rowData.get("LAST_PO_DATE"))%></td>
</tr>
<tr>
	<th scope="row">대표SG(명)</th>
	<td class="row"><%=CommonUtil.nvl(rowData.get("SG_ID"))%>(<%=CommonUtil.nvl(rowData.get("SG_NAME"))%>)</td>
	<th scope="row">KeP담당자</th>
	<td class="row"><%=CommonUtil.nvl(rowData.get("KEP_USER_NAME"))%></td>
</tr> 

<% } %> 
	        </tbody>
	   </table> 
<%
if ("M".equals(comType) && "S".equals(CommonUtil.nvl(rowData.get("BUSINESS_COND")))){
%>
	<!--버튼영역-->
	<div class="btnArea02" >
		<span class="fr">
			<span class="btn_05 mr04"><a href="javascript:doPop('agentCommunity');">협력사 커뮤니티</a></span>
		</span>
	</div>
<% } %>   			 
	<h2><%=CommonLang.get("HTITLE445") %><!-- 개인정보 --></h2>
			<!--grid-->
			<div class="scrollArea"  style="height:180px">         
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>개인정보 리스트</caption>
                    <colgroup>
                        <col width="15%" />  
                        <col width="25%" />  
                        <col width="25%" />  
                        <col width="*" />    
                    </colgroup>		   
                    <thead> 
                        <tr>
                        	<th scope="col"><%=CommonLang.get("HTITLE476") %><!-- 직급 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE322") %><!-- 사용자명 --></th>   
                            <th scope="col"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>   
                            <th scope="col"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>   
                        </tr>
                    </thead>
                    <tbody>
<% 
for (int j=0; j<_dataList2.size(); j++) {
	Map<String,String> _tmp2 = _dataList2.get(j);
%>  
                        <tr>
						   <td class="center"><%=CommonUtil.nvl(_tmp2.get("POSITION_NAME"))%></td> 
						   <td class="center"><%=CommonUtil.nameMasking(CommonUtil.nvl(_tmp2.get("USER_NAME_LOC")))%></td> 
						   <td class="center"><%=CommonUtil.phoneMasking(CommonUtil.nvl(_tmp2.get("PHONE_NUMBER")))%></td> 
						   <td class="left"><%=CommonUtil.emailMasking(CommonUtil.nvl3(_tmp2.get("EMAIL"), ""))%></td> 
						</tr> 
<% } %>
                              
                    </tbody>
                </table>  
             </div>	
        </div>
    </div>         
<%}%>                     
</form> 
</body>
</html>
