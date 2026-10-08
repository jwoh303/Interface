<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String st_dely_area = CommonUtil.nvl((String) request.getParameter("st_dely_area")); //납품가능지역
%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
<script type="text/javascript">
function kep_onload_view(){
	var st_dely_area = "<%=st_dely_area%>";
	if(st_dely_area == null || st_dely_area =="") return;
	var st_dely_area_list = st_dely_area.split("");
	var tot_cnt = $("#count").val();
	// 파라미터 선택된 값 체크하기
	for(var i=0; i< tot_cnt; i++){
		if(st_dely_area_list[i] == "Y"){
			document.getElementById("st_dely_area"+i).checked = true;
		}else{
			document.getElementById("st_dely_area"+i).checked = false;
		}
	}

}
//확인 클릭시 정보 저장됨.
function choiceArea(){  
	var st_dely_area = "";
	var tot_cnt = $("#count").val();
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.DelyAreaChoice.st_dely_area"+i);
		if(box.checked == true){
			st_dely_area += "Y";
		}else{
			st_dely_area += "N";
		}
	}
	if(st_dely_area == "NNNNNNNNNNNN"){
		alert("납품가능지역을 선택해주시기 바랍니다.");
		return;
	}
	opener.setPopupReturn(st_dely_area);
	this.close();
	
}

</script>
</head>

<body onload="kep_onload_view();">
	 <form name="DelyAreaChoice" id="DelyAreaChoice" method="post" >
	 <input type="hidden" name="st_dely_area" id="st_dely_area"  value="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:100%; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 납품가능지역</h1>
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
							<td style="text-align:left;" height="30px"><input id="st_dely_area<%=j%>" name="st_dely_area<%=j%>" type="checkbox" value="<%=CommonUtil.nvl(rowData.get("TEXT1"))%>" style="vertical-align:middle"> <%=CommonUtil.nvl(rowData.get("TEXT1"))%></td>
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
				<span class="btn_02"><a href="javascript:choiceArea()">저장</a></span>
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
