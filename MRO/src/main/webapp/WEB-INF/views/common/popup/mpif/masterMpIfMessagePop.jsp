<%--
**********************************************
* 메뉴 : 
* 화면 : I/F 메세지 팝업
* 기능 : IF_WS_LOG 테이블에 저장된 메세지를 출력한다.
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2022-05-19
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

String ifMsg = "";

if (_dataList.size() > 0) {
	ifMsg = _dataList.get(0).get("CONTENTS");
}
System.out.println(ifMsg);
%>

<script type="text/javascript">

</script>  
<body onload="">
	<div id="popWrapper" style="height:174px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">I/F 메세지</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:150px">
			<table class="cont_t_list05">
                <tr> 
                    <th width=50px;>내용</th>
                    <td>
                    	<textarea id="st_return_remark" name="st_return_remark" rows="9" cols="70" readonly><%=ifMsg %></textarea>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </div>
</body>
</html>