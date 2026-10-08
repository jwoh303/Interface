<%--
**********************************************
* 메뉴 : 입고관리 > 입고집계표 > 상세팝업
* 화면 : 부서별 입고 상세
* 기능 : 
* 프로그램 ID : 
* 담당자 : 한승준(설계 : 현명환)
* 착수일 : 2016-08-10
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String p_buyer = CommonUtil.nvl((String)request.getParameter("buyer"));
	String p_req_dept = CommonUtil.nvl((String)request.getParameter("req_dept"));
	String p_from_date = CommonUtil.nvl((String)request.getParameter("fromDate"));
	String p_to_date = CommonUtil.nvl((String)request.getParameter("toDate"));
	String p_closing_yn = CommonUtil.nvl((String)request.getParameter("closing_yn"));
%>

<script type="text/javascript">

//최초 화면 함수 
function kep_onload_view(){
	var sum_price = document.forms.buyerWmGrWarehousingDetailPop.display_item_amt_sum.value;
    document.forms.buyerWmGrWarehousingDetailPop.s_display_item_amt_sum.value = kepCommaNum(sum_price);
    
    var tot_cnt = document.forms.buyerWmGrWarehousingDetailPop.total_cnt.value;
    document.forms.buyerWmGrWarehousingDetailPop.st_total_cnt.value = kepCommaNum(tot_cnt);
}

//기능함수
function doAction(str) {
	switch (str) {
	case "excelDown": // 엑셀다운로드
		document.forms.buyerWmGrWarehousingDetailPop.action = "/wmgr/excelBuyerWmGrWarehousingDetailPop.do";
		document.forms.buyerWmGrWarehousingDetailPop.submit();
		break;
	}
}

</script> 
</head>
<body onload="kep_onload_view()">
<form name="buyerWmGrWarehousingDetailPop" id="buyerWmGrWarehousingDetailPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="buyer" id="buyer" value="<%=p_buyer%>">
<input type="hidden" name="req_dept" id="req_dept" value="<%=p_req_dept%>">
<input type="hidden" name="fromDate" id=""fromDate"" value="<%=p_from_date%>">
<input type="hidden" name="toDate" id="toDate" value="<%=p_to_date%>">
<input type="hidden" name="closing_yn" id="closing_yn" value="<%=p_closing_yn%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE713") %><!-- 부서별 입고 상세 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<% int tot_price = 0; %>
			<% int tot_cnt = 0; %>
			<div>
				<table width="100%">
					<tr>
						<td align="right" height = "30" style="padding-bottom:2px">
							<b>
								<%=CommonLang.get("HTITLE172") %><!-- 총 금액 --> : 
								<input type="text" id="s_display_item_amt_sum" name="s_display_item_amt_sum" value=""  style="width:150px; text-align:right; background-color:#FFFFFF;font-weight:bold; font-size:9pt; border:#FFFFFF 1px solid;" READONLY>
					      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE594") %><!-- (기준 : 원) -->
					      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE608") %><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value=""/>
							</b>
						</td>
					</tr>
				</table>
			</div>
			
			<!--grid-->
			<div class="scrollArea" style="height:420px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>부서별 입고 상세</caption>
						<colgroup>
						<col width="8%" />
						<col width="6%" />
						<col width="7%" />
						<col width="10%" />
						<col width="*" />
						<col width="8%" />
						<col width="8%" />
						<col width="6%" />
						<col width="10%" />
						<col width="8%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE565") %><!-- 품명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE566") %><!-- 발주/입고수량 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>							
							<th scope="col"><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE567") %><!-- 협력사명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE568") %><!-- 예산부서코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></th> 
						</tr>
						<tr>
							<th scope="col"><%=CommonLang.get("HTITLE283") %><!-- 입고일 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE286") %><!-- 입고번호 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE287") %><!-- 입고금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE293") %><!-- 요청부서명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE386") %><!-- 계정코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE267") %><!-- 계정명 --></th> 
						</tr>
					</thead>
					<tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="11" align="center" height = "300px">
	                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	                        </td> 
	                    </tr>
				<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
							
							tot_price += Double.parseDouble(_tmp.get("ITEM_AMT"));
							tot_cnt = j+1;
				%> 
						<tr>
							<td rowspan="2">
							 	<%=_tmp.get("PX_NO")%>
							</td>
							<td>
							 	<%=CommonUtil.formatStrinigDate(_tmp.get("PO_CREATE_DATE"))%>
							</td>
							<td>
							 	<%=_tmp.get("PO_NO")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("BUYER_ITEM_NO")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("DESCRIPTION")%>
							</td>
							<td>
							 	<%=CommonUtil.formatNumber(_tmp.get("PO_ITEM_QTY"),true,0,3)%> / <%=CommonUtil.formatNumber(_tmp.get("GR_ITEM_QTY"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%>
							</td>
							<td>
							 	<%=_tmp.get("PO_CREATOR")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("AGENT_NAME")%>
							</td>
							<td>
							 	<%=_tmp.get("BUDGET_DEPT")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("BUDGET_DEPT_NAME")%>
							</td>
						</tr>
						<tr>
							<td>
							 	<%=CommonUtil.formatStrinigDate(_tmp.get("GR_DATE"))%>
							</td>
							<td>
							 	<%=_tmp.get("GR_NO")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("REF_PR_NO")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("SPECIFICATION")%>
							</td>
							<td>
							 	<%=_tmp.get("UNIT_MEASURE")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("ITEM_AMT"),true,0,3)%>
							</td>
							<td>
							 	<%=_tmp.get("ADD_USER_NAME")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("REQ_DEPT_NAME")%>
							</td>
							<td>
							 	<%=_tmp.get("ACCOUNT_TYPE")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("ACCOUNT_NAME")%>
							</td>
						</tr>
				<%
						}
					}
				%>                               
					</tbody>
				</table>
				<input type="hidden" name="display_item_amt_sum"  value="<%=tot_price%>">
				<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=tot_cnt %>"/>
	        </div>
	        
	        <div style="height:25px">
		        <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px;">
					<tr> 
						<td align="left" width="100px">
							<!-- 엑셀다운로드 버튼 -->
							<div class="btnArea">
								<div class="fr">
									<span class="btn_04">
										<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
									</span>	
					            </div>
					        </div>
						</td>
					</tr>
				</table>
			</div>
			
		</div>        
	</div>
</form> 
</body>
</html>
