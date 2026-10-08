<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String st_mail_recv = CommonUtil.nvl((String) request.getParameter("st_mail_recv"),"YYYYYYYYYYY");
%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
<script type="text/javascript">
function kep_onload_view(){
	var st_mail_recv = "<%=st_mail_recv%>";
	if(st_mail_recv == null || st_mail_recv =="") return;
	var str_area_list = st_mail_recv.split("");
	var tot_cnt = $("#count").val();
	// 파라미터 선택된 값 체크하기
	for(var i=0; i< tot_cnt; i++){
		if(str_area_list[i] == "Y"){
			document.getElementById("st_recv_mail_flag"+i).checked = true;
		}else{
			document.getElementById("st_recv_mail_flag"+i).checked = false;
		}
	}

}
//확인 클릭시 정보 저장됨.
function choiceMail(){  
	var tmpChoiceMail = "";
	var tot_cnt = $("#count").val();
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.recvMailChoice.st_recv_mail_flag"+i);
		if(box.checked == true){
			tmpChoiceMail += "Y";
		}else{
			tmpChoiceMail += "N";
		}
	}
	//메일설정 자리수 체크 때문에 쓰임.
	tmpChoiceMail=tmpChoiceMail+"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
	opener.setPopupReturn(tmpChoiceMail);
	this.close();
}
</script>
</head>

<body onload="kep_onload_view();">
	 <form name="recvMailChoice" id="recvMailChoice" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deliAreaPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:100%; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE892") %></h1><!-- 메일수신항목 -->
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div  class="scrollArea" style="height:150px"> 
            	<!--grid-->
                <table style="width:100%">
                    <caption>검색 리스트</caption>
						<colgroup>
						    <col width="33%" /> 
						    <col width="33%" />
						    <col width="33%" /> 
						</colgroup>
                    <thead>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               			<tr bgcolor="#FFFFFF">
							<td colspan="3" align="center" height = "195">
							<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
            	            </td> 
        	            </tr>
<%}else{%>
						<tr>
<%
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>
							<td style="text-align:left;" height="30px"><input id="st_recv_mail_flag<%=j%>" name="st_recv_mail_flag<%=j%>" type="checkbox" value="<%=CommonUtil.nvl(rowData.get("TEXT1"))%>" style="vertical-align:middle"> <%=CommonUtil.nvl(rowData.get("TEXT4"))%></td>
	<%if((j > 0) && ((j+1)%3 == 0)){%>
						</tr>
						<tr>
	<%}%>
<%}%>
						</tr>
					</tbody>

					<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">
<%}%>
				</table>
			</div>
			
			<br>
			
			<div class="btnArea">
				<span class="fr">
				<span class="btn_02"><a href="javascript:choiceMail()"><%=CommonLang.get("HTITLE516") %></a></span><!-- 확인 -->
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
