<%--
**********************************************
* 메뉴 : 
* 화면 : 부서코드 조회 (부서 검색)
* 기능 : 부서코드 조회 (부서 검색) 팝업
* 프로그램 ID : PG_90_C_900_56
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-02
**********************************************
--%>
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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), "");
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"C001");  //  (조회조건)
String st_open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String st_init_flag = CommonUtil.nvl((String) request.getParameter("st_init_flag"),"N");
String st_coway_yn = CommonUtil.nvl((String) request.getAttribute("st_coway_yn"),request.getParameter("st_coway_yn"));
String st_dept_type = CommonUtil.nvl((String) request.getParameter("dept_type"), "D");  //  (조회조건)
String st_user_id = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null) {
	st_user_id = CommonUtil.nvl( sessionInfo.getUserId(), "");
}else{
	st_user_id = "";
}
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
String group_mng_flag = "N";
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

%>

<script type="text/javascript">
<!--
function kep_onload()
{  
	<% if (!"Y".equals(st_init_flag)){%>
		$('#deptCodeAdminPop').attr("action", "/common/getDeptCodeAdminCowayYn.do").submit(); 
	<%}%>
}

function setQuery()
{
	if(isEmpty($("#st_req_dept_name").val()) && isEmpty($("#st_req_dept_code").val())){
		//부서코드 또는 부서명을 한자 이상 입력 하세요.
		alert("<%=CommonLang.msg("MSG410") %>");
		$("#st_req_dept_name").focus();
		return;
	}
  $('#deptCodeAdminPop').attr("action", "/common/commonList.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3,"dept");
  this.close();
}
 //-->
</script> 
<body onload="kep_onload();">
	 <form name=deptCodeAdminPop id=deptCodeAdminPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	 <input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>"> 
	 <input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	 <input type=hidden name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type=hidden name="st_open" id="st_open"  value="<%=st_open%>">
	 <input type=hidden name="st_init_flag" id="st_init_flag"  value="Y">
	 <input type=hidden name="st_coway_yn" id="st_coway_yn"  value="<%=st_coway_yn%>">
	 <input type=hidden name="group_mng_flag" id="group_mng_flag"  value="<%=group_mng_flag%>">
	 <input type=hidden name="st_dept_type" id="st_dept_type" value="<%=st_dept_type%>">
	 <input type=hidden name="dept_type" id="dept_type" value="<%=st_dept_type%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE712") %><!-- 부서검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>부서검색 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></td>
							<td> 
								<input type=text name=st_req_dept_code id="st_req_dept_code" style="width:90%" value="" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></td>	
							<td> 
								<input type=text name=st_req_dept_name id="st_req_dept_name" style="width:90%" value="<%=st_req_dept_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:348px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서검색 리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE380") %><!-- 부서코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE490") %><!-- 요약 부서명 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE491") %><!-- 상세 부서명 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
<%-- // SLOGIC-BEGIN ( P01-1010-03 ) --%>
						<td>
						 	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=com_code.equals("KRKEPB0004") || com_code.equals("KRDHIM0002") ? rowData.get("DEPT_USER_COUNT") : "" %>')">
							<%=rowData.get("CODE")%></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=com_code.equals("KRKEPB0004") || com_code.equals("KRDHIM0002") ? rowData.get("DEPT_USER_COUNT") : "" %>')">
							<%=rowData.get("TEXT1")%></a>
					   </td>
						<td class="left">
								<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','<%=com_code.equals("KRKEPB0004") || com_code.equals("KRDHIM0002") ? rowData.get("DEPT_USER_COUNT") : "" %>')">
							<%=CommonUtil.nvl(rowData.get("TEXT2"))%></a>
						</td>
<%-- // SLOGIC-END --%>
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
