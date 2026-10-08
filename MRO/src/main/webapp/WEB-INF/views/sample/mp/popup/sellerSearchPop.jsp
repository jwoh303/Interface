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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	
}

function kepSearch()
{  
  $('#deptCodeAdminPop').attr("action", "/mprq/commonList.do").submit();    
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
<body onload="kep_onload_view">
<form name="deptCodeAdminPop" id="deptCodeAdminPop" method=post >
<input type="hidden" name="codeGubun" id="codeGubun"  value="deptCodeAdminPop">
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">

	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">팝업타이틀</h1>
            <p class="popClose"><a href="#"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="#">조회</a></span> <span class="btn_reset"><a href="#">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="50px" />
							<col width="18%" />
							<col width="50px" />
							<col width="*" />
							
						</colgroup>
						
						<tbody>
						<tr>
							<td>부서</td>
							<td>
                            	<label for="b_team" class="hidden">부서선택</label>
					  			<select name="b_team" id="b_team">
                            		<option>전체</option>
                            		<option>건설사업팀</option>
                                    <option>수도사업팀</option>
                                </select>
                            </td>
							<td>고객사</td>
							<td><input type="text" name="input4"class="input_type_text" title="" style="width:100px;" /> <a href="#"><img src="/resources/images/btn_search03.gif" alt="검색" /></a></td>
						  </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
            <table  class="cont_t_list02"  style="width:100%">
                <caption>고객카드관리 리스트</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="*" />
                    <col width="12%" />
                    <col width="11%" />
                    <col width="11%" />
                    <col width="11%" />
                    <col width="11%" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">고객사코드</th>
                        <th scope="col">고객사명</th>
                        <th scope="col">부서명</th>
                        <th scope="col">담당BM</th>
                        <th scope="col">최종방문일시</th>
                        <th scope="col">전월방문여부</th>
                        <th scope="col">당월방문여부</th>
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
	Map<String,String> rowData = _dataList.get(j);
%>                 
                    <tr>
                        <td><%=CommonUtil.nvl(rowData.get("TEXT2"))%></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
<% } 
}%>                      
                </tbody>
            </table>
            <!--버튼영역-->
            <div class="btnArea">
               	<span class="btn_04 mr04"><a href="#">다운로드</a></span>
               	<span class="btn_08"><a href="#">다운로드다운로드</a></span>
            </div>
        </div>
    </div>
</form> 
</body>
</html>
