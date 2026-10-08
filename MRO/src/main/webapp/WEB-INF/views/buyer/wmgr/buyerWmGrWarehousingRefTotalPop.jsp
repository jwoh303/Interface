<%--
**********************************************
* 메뉴 : 구매사 > 입고조회 > 관리번호별 집계 팝업
* 화면 : 관리번호별 집계 팝업
* 기능 : 입고조회 결과값을 관리번호별로 정리하여 보여주는 팝업
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.net.URLDecoder" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<%
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  //  (조회조건)
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  //  (조회조건)
String st_coom_code = CommonUtil.nvl((String) request.getParameter("st_coom_code"),"");  //  (조회조건)
String cb_order = CommonUtil.nvl((String) request.getParameter("cb_order"),"");  //  (조회조건)

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

Map<String,String> rowData = null;

if (_dataList==null || _dataList.size()==0){
}else{	
	rowData = _dataList.get(0); 
} 


%>

<script type="text/javascript">
//조회
function kepSearch(curPage){ 
	$('#processForm').attr("action", "/wmgr/getBuyerWmGrRefTotalList.do").submit();   
}


</script> 
<body>
<form name="processForm" id="processForm" method=post >
<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" id="st_coom_code"  name="st_coom_code" value="<%=st_coom_code%>">
	<input type="hidden" id="st_from_date"  name="st_from_date" value="<%=st_from_date%>">
	<input type="hidden" id="st_to_date"  name="st_to_date" value="<%=st_to_date%>">
	
	<div id="popWrapper" style="height:590px;">
    	<div id="popHeader">
        	<h1 class="title">관리번호별 집계</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            	<table  class="board_write" summary="협력사별 집계">
					<caption>관리번호별 집계</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
				<tbody>
				<tr>
				  	<th scope="row">입고일자</th> 
					<td scope="row" colspan="3"> 
					<%=st_from_date%> ~ <%=st_to_date%> 
					</td>
				</tr>
		    	</tbody>
		    </table>
			
			<span class="fr">
				<label for="b_no02"><b>정렬하기</b></label>
				<select name="cb_order" id="cb_order" onchange="kepSearch(1);"> 
					<option <%=(cb_order.equals("2") ? "selected" : "")%> value = "2">관리번호별</option>
					<option <%=(cb_order.equals("3") ? "selected" : "")%> value = "3">발주금액별</option>
					<option <%=(cb_order.equals("4") ? "selected" : "")%> value = "4">입고금액별</option>
				</select>
			</span>
			
			<br>
			
			<!--grid-->
			<div class="scrollArea" style="height:245px">
		    	<table  class="cont_t_list02"  style="width:100%">
		        	<caption>리스트</caption>
		        	<colgroup>
			            <col width="*" />
			            <col width="18%" />
			            <col width="18%" />
			            <col width="18%" />
		        	</colgroup>
		        	<thead>
		            <tr>
		                <th scope="col">관리번호</th> 
		                <th scope="col">주문건 수</th> 
						<th scope="col">발주금액</th>					
						<th scope="col">입고금액</th>					
		            </tr>
		        	</thead>
		        	<tbody>
<%
double tot_po_amt = 0;
double tot_gr_amt = 0;
int tot_po_count = 0;

if (_dataList == null || _dataList.size() == 0){
%>
					<tr bgcolor="#FFFFFF">
		       			<td colspan="6" align="center">
		       			<span class="font1">조회된 데이타가 없습니다.</span>
		       			</td> 
					</tr>
<%}else{
	Map<String,String> _data = null;
	
	for (int j=0; j<_dataList.size(); j++) {
		_data = _dataList.get(j);
		tot_po_amt += Double.parseDouble(_data.get("PO_AMT"));
		tot_gr_amt += Double.parseDouble(_data.get("GR_AMT"));
		tot_po_count += Double.parseDouble(_data.get("PO_COUNT"));
%> 
					<tr>
						<input type="hidden"	name="db_buyer"	value="<%=_data.get("BUYER")%>">
						<tr class="center">
							<td title="관리번호" class="left"><%=_data.get("REF_PR_NO")%></td>						
							<td title="주문건 수" class="right"><%=_data.get("PO_COUNT")%></td>						
							<td title="발주금액" class="right"><%=CommonUtil.formatNumber(_data.get("PO_AMT"),true,0,3)%></td>						
							<td title="입고금액" class="right"><%=CommonUtil.formatNumber(_data.get("GR_AMT"),true,0,3)%></td>						
						</tr>
					</tr>
	<%}%>
					<tr>
						<tr class="center">
							<td title="합계"><b><font color="#990000">합 계</font></b></td>
							<td title="주문건 수" class="right"><b><font color="#990000"><%=tot_po_count%> 건</font></b></td>						
							<td title="발주금액" class="right"><b><font color="#990000"><%=CommonUtil.formatNumber(tot_po_amt,true,0,3)%></font></b></td>						
							<td title="입고금액" class="right"><b><font color="#990000"><%=CommonUtil.formatNumber(tot_gr_amt,true,0,3)%></font></b></td>						
						</tr>
					</tr>
<%}%>
					</tbody>
				</table>
			</div>
			<br>
		</div>
	</div>
</form>   
</body>
</html>
