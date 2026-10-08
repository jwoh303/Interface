<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
String st_reason_code = CommonUtil.nvl((String) request.getParameter("st_reason_code"),"");  //  (조회조건)
String codeGubun = CommonUtil.nvl((String) request.getParameter("codeGubun"),"");  //  (조회조건)

Map<String,String> rowData = null;
if(_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
}
%>

<script type="text/javascript">
function kep_onload_view(){
}

</script> 
<body onload="">
	 <form name=logis_fee_reason_pop id=logis_fee_reason_pop method=post >
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">물류비 책정 사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<h2>물류비 책정 사유</h2>
			<!--grid-->
			<div class="scrollArea" style="height:80px">
                <table class="cont_t_list02" style="width:100%">
					<caption>물류비 책정 사유</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
                    </colgroup>
                    
                    <thead>
<%
if (_dataList1==null || _dataList1.size()==0){
%>
						<tr>
							<td colspan="4" align="center" height = "50">
								<span>조회된 데이타가 없습니다.</span>
							</td>
						</tr>
<%}else{%>
						<tr>
							<th scope="row">코드</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
							<th scope="row">명칭</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></td>
						</tr>
		
				    	<tr>
		    				<th scope="row">설명</th>
							<td colspan="3"><%=CommonUtil.nvl(rowData.get("TEXT4"))%></td>
						</tr>
<%}%>						
                    </thead>
				</table>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
