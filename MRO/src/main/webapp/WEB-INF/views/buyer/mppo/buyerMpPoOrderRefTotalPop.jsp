<%--
**********************************************
* 메뉴 : 구매사 > 발주진행관리 > 관리번호별 집계 팝업
* 화면 : 관리번호별 집계 팝업
* 기능 : 발주진행관리의 결과값을 관리번호별로 정리하여 보여주는 팝업
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
String st_fromDate = CommonUtil.nvl((String) request.getParameter("fromDate"),"");  //  (조회조건)
String st_toDate = CommonUtil.nvl((String) request.getParameter("toDate"),"");  //  (조회조건)

String cb_dept_code = CommonUtil.nvl((String) request.getParameter("cb_dept_code"),"");  //  (조회조건)
String cb_dept_text = CommonUtil.nvl((String) request.getParameter("cb_dept_text"),"");  //  (조회조건)
String st_dept_code = CommonUtil.nvl((String) request.getParameter("st_dept_code"),"");  //  (조회조건)
String st_dept_name = CommonUtil.nvl((String) request.getParameter("st_dept_name"),"");  //  (조회조건)

String cb_item_code = CommonUtil.nvl((String) request.getParameter("cb_item_code"),"");  //  (조회조건)
String cb_item_text = CommonUtil.nvl((String) request.getParameter("cb_item_text"),"");  //  (조회조건)
String itemNo = CommonUtil.nvl((String) request.getParameter("itemNo"),"");  //  (조회조건)

String cb_order_code = CommonUtil.nvl((String) request.getParameter("cb_order_code"),"");  //  (조회조건)
String cb_order_text = CommonUtil.nvl((String) request.getParameter("cb_order_text"),"");  //  (조회조건)
String orderNo = CommonUtil.nvl((String) request.getParameter("orderNo"),"");  //  (조회조건)

String status_code = CommonUtil.nvl((String) request.getParameter("status_code"),"");  //  (조회조건)
String status_text = CommonUtil.nvl((String) request.getParameter("status_text"),"");  //  (조회조건)

String cb_order = CommonUtil.nvl((String) request.getParameter("cb_order"),"2");  //  (조회조건)

String conv_fromDate = CommonUtil.formatDate(st_fromDate, 1);
String conv_toDate = CommonUtil.formatDate(st_toDate, 1);

// 요약부분 파라미터 Decode 하여 보여주기 위하여
st_dept_name = URLDecoder.decode(st_dept_name, "UTF-8");
itemNo = URLDecoder.decode(itemNo, "UTF-8");
orderNo = URLDecoder.decode(orderNo, "UTF-8");

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), sessionInfo.getComCode());
String st_user_id = sessionInfo.getUserId();

Map<String,String> rowData = null;

if (_dataList==null || _dataList.size()==0){
}else{	
	rowData = _dataList.get(0); 
} 

String SessionComCode = "";
String byca_comorg_code = ""; 
String buyer = ""; 
String user_dept              = ""; 
String userId = "";
String byca_comorg_level = "";
String dept_name = "";
String budget_flag = "";
String person_author = "";
String empNo	= "";

if (sessionInfo != null){ 
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
    budget_flag           = CommonUtil.nvl((String)sessionInfo.getBudgetFlag());  // 구매사 예산 사용여부 
    person_author =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());  
    empNo	= CommonUtil.nvl((String)sessionInfo.getEmpNo());
}   
 
buyer = CommonUtil.nvl((String) request.getParameter("buyer"), sessionInfo.getComCode());

String reportText= "출력"; // default 버튼명
String reportid = "RD_04_B_004_07";

%>

<script type="text/javascript">
//조회
function kepSearch(curPage){ 
	$('#processForm').attr("action", "/mppo/getBuyerMpPoOrderRefTotalList.do").submit();   
}

function prnSheet(){
	var buyer	= "<%=buyer%>";
	var fromDate	= "<%=st_fromDate%>";
	var toDate	= "<%=st_toDate%>";
	
	var cb_dept_code = "<%=cb_dept_code%>";
	var st_dept_code = "<%=st_dept_code%>";
	
	var cb_item_code = "<%=cb_item_code%>";
	var itemNo = "<%=itemNo%>";
	
	var cb_order_code = "<%=cb_order_code%>";
	var orderNo = "<%=orderNo%>";
	
	var status_code = "<%=status_code%>";
	
	var cb_order = "<%=cb_order%>";
	
	var fileName = "<%=reportid%>";
	var param =  "["+buyer+"]["+fromDate+"]["+toDate+"]["+cb_dept_code+"]["+st_dept_code+"]["+cb_item_code+"]["+itemNo+"]["+cb_order_code+"]["+orderNo+"]["+status_code+"]["+cb_order+"]";  // 통합된 파라미터
		
	reportOpen(fileName,param);
}

</script> 
<body>
<form name="processForm" id="processForm" method=post >
<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" id="buyer"  name="buyer" value="<%=buyer%>">
	<input type="hidden" id="fromDate"  name="fromDate" value="<%=st_fromDate%>">
	<input type="hidden" id="toDate"  name="toDate" value="<%=st_toDate%>">
	
	<input type="hidden" id="cb_dept_code"  name="cb_dept_code" value="<%=cb_dept_code%>">
	<input type="hidden" id="cb_dept_text"  name="cb_dept_text" value="<%=cb_dept_text%>">
	<input type="hidden" id="st_dept_code"  name="st_dept_code" value="<%=st_dept_code%>">
	<input type="hidden" id="st_dept_name"  name="st_dept_name" value="<%=st_dept_name%>">
	
	<input type="hidden" id="cb_item_code"  name="cb_item_code" value="<%=cb_item_code%>">
	<input type="hidden" id="cb_item_text"  name="cb_item_text" value="<%=cb_item_text%>">
	<input type="hidden" id="itemNo"  name="itemNo" value="<%=itemNo%>">
	
	<input type="hidden" id="cb_order_code"  name="cb_order_code" value="<%=cb_order_code%>">
	<input type="hidden" id="cb_order_text"  name="cb_order_text" value="<%=cb_order_text%>">
	<input type="hidden" id="orderNo"  name="orderNo" value="<%=orderNo%>">
	
	<input type="hidden" id="status_code"  name="status_code" value="<%=status_code%>">
	<input type="hidden" id="status_text"  name="status_text" value="<%=status_text%>">
	
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
				  	<th scope="row">주문일자</th> 
					<td scope="row" colspan="3"> 
					<%=conv_fromDate%> ~ <%=conv_toDate%> 
					</td>
				</tr>
				<tr>
					<th scope="row"><%=cb_dept_text%></th>
					<td scope="row"><%=CommonUtil.nvl(st_dept_name, "전체")%></td>
					<th scope="row"><%=cb_item_text%></th>
					<td scope="row"><%=CommonUtil.nvl(itemNo, "전체")%></td>
				</tr>
				<tr>
				  	<th scope="row"><%=cb_order_text%></th>
					<td scope="row"><%=CommonUtil.nvl(orderNo, "전체")%></td>
					<th scope="row">진행상태</th>
					<td scope="row"><%=status_text%></td>
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
