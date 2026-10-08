<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 견적단가이력 팝업
* 기능 : 고객사 단가합의 및 네고요청 > 견적내역 상세 팝업 > 차수에 따른 견적단가이력 조회 
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 2016-06-16
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

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String p_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String p_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String p_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String p_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
%>

</head>
<body>
<form name="buyerMpRqQuotationNegoHistioryPop" id="buyerMpRqQuotationNegoHistioryPop" method=post >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title">견적단가이력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 견적단가이력 -->
			<!--grid-->
			<div class="scrollArea" style="height:230px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>견적단가이력 리스트</caption>
						<colgroup>
						<col width="7%" />
						<col width="12%" />
						<col width="6%" />
						<col width="5%" />
						<col width="12%" />
						<col width="12%" />
						<col width="10%" />
						<col width="*" />
						<col width="12%" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">네고순번</th>
							<th scope="col">견적번호</th>
							<th scope="col">순번</th>
							<th scope="col">차수</th>
							<th scope="col">Nego단가</th>
							<th scope="col">고객사Nego단가</th>
							<th scope="col">Nego일자</th>
							<th scope="col">Nego사유</th>
							<th scope="col">생성자</th> 
						</tr>
					</thead>
					<tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="9" align="center" >
	                        <span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
				<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
				%>
						<tr>
							<td>
							 		<%=_tmp.get("NEGO_SEQ")%>
							</td>
							<td>
							 	<%=_tmp.get("QUOTATION_NO")%>
							</td>
							<td>
							 	<%=_tmp.get("QUOTATION_SEQ")%>
							</td>
							<td>
								<%=_tmp.get("REVISION")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("NEGO_PRICE"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("BTOA_NEGO_PRICE"),true,0,3)%>
							</td>
							<td>
							 	<%=CommonUtil.formatStrinigDate(_tmp.get("NEGO_DATE"))%>
							</td>
							<td class="left">
							 	<%=_tmp.get("BTOA_NEGO_REMARK")%>
							</td>
							<td>
							 	<%=_tmp.get("CREATE_USER_ID")%>
							</td>
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
