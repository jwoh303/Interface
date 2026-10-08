<%--
**********************************************
* 메뉴 : 
* 화면 : 품목코드 납품가능 협력사 정보 
* 기능 : 품목코드 납품가능 협력사 정보
* 프로그램 ID : PG_01_M_008_02
* 담당자 : 현명환
* 착수일 : 2015-11-24
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>

<script type="text/javascript">
<!--

//최초 화면 함수 
function kep_onload_view() {

}
function getAgentInfoPop(agent){
	openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do",'?com_code='+agent,"800,600,no");		
}

 //-->
</script> 
<body onload="kep_onload_view();">
<form name="masterMdCpCompyDetailViewPop" id="masterMdCpCompyDetailViewPop" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">납품가능 협력사 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:510px;" >
				<table class="cont_t_list02" style="width:100%">
					<colgroup>
						<col width="20%" />
						<col width="*" />
						<col width="18%" />
						<col width="18%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">협력사코드</th>
							<th scope="col">협력사명</th>
							<th scope="col">등록자</th>
							<th scope="col">등록일</th>
						</tr>
					</thead>
					<tbody>
					<% if (_gridList == null || _gridList.size() == 0) { %>
						<tr>
							<td colspan="15" align="center" height = "50"> 
								<span>조회된 데이타가 없습니다.</span>
							</td>
						</tr>
					<%
					} else {
						for (int j=0; j<_gridList.size(); j++) {
							Map<String,String> rowData2 = _gridList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
						<tr align="center" bgcolor="<%=tclass%>">
							<td title="협력사코드">
								<a href="javascript:getAgentInfoPop('<%=String.valueOf(CommonUtil.nvl(rowData2.get("AGENT")))%>','')"><font color = blue><%=String.valueOf(CommonUtil.nvl(rowData2.get("AGENT")))%></font></a>
							</td>
							<td title="협력사명">
								<a href="javascript:getAgentInfoPop('<%=String.valueOf(CommonUtil.nvl(rowData2.get("AGENT")))%>','')"><font color = blue><%=String.valueOf(CommonUtil.nvl(rowData2.get("AGENT_NAME_LOC")))%></font></a>
							</td>
							<td title="등록자"><%=String.valueOf(CommonUtil.nvl(rowData2.get("USER_NAME_LOC")))%></td>
							<td title="등록일"><%=String.valueOf(CommonUtil.nvl(rowData2.get("ADD_DATM")))%></td>
						</tr>
					<%
						} 
					}
					%>
					</tbody>
				</table>
				</div>
			</div>
		</div>
</form> 
</body>
</html>
