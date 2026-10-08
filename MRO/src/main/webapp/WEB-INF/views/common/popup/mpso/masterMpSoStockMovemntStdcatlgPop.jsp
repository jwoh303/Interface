<%--
**********************************************
* 메뉴 : 주문관리>재고관리>재고이동요청등록 품목검색
* 화면 : 재고이동요청등록 품목검색
* 기능 : 
* 프로그램 ID : PG_06_M_015_01
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

String st_warehouse_code_fr = CommonUtil.nvl((String) request.getParameter("st_warehouse_code_fr"),"");  //  (조회조건)
String st_item_no = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");  //  (조회조건)
String st_desc = CommonUtil.nvl((String) request.getParameter("st_desc"),"");  //  (조회조건)
String st_spec = CommonUtil.nvl((String) request.getParameter("st_spec"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch($("#curPage").val());
			break;
	}
}

//조회
function kepSearch(curPage) {
	$("#curPage").val(curPage); 
	$('#searchForm').attr("action", "/mpso/getMasterMpSoStockMovemntStdcatlgPop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2, value3, value4) { 
	opener.setPopupReturn(value1, value2, value3, value4);
	this.close();
}
 //-->
</script> 
<body onload="">
<form name=searchForm id="searchForm" method="post">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" />
<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
<input type="hidden" id="st_warehouse_code_fr" name="st_warehouse_code_fr"  value="<%=st_warehouse_code_fr%>" />
<input type="hidden" id="onepagerow" name="onepagerow"  value="<%=onepagerow%>" />
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />


	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
		<div id="popHeader">
			<h1 class="title">재고품목</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
			</div>   
            <!--조회영역-->
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>고객사결제조건 수정 리스트</caption>
					<colgroup>
						<col width="10%" />
						<col width="20%" />
						<col width="10%" />
						<col width="25%" />
						<col width="10%" />
						<col width="*" />
					</colgroup>						
					<tbody>
						<tr>
							<td>표준코드</td>
							<td> 
								<input type="text" id="st_item_no" name="st_item_no" value="<%=st_item_no%>" class="input_type_text" style="width:80%" onkeydown="kepEnter()" /> 
                            </td>
                            <td>품목명</td>
							<td> 
								<input type="text" id="st_desc" name="st_desc"  value="<%=st_desc%>" class="input_type_text" style="width:80%" onkeydown="kepEnter()" /> 
                            </td>
                            <td>규격</td>
							<td> 
								<input type="text" id="st_spec" name="st_spec"  value="<%=st_spec%>" class="input_type_text" style="width:80%" onkeydown="kepEnter()" />
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
			</div>            
			<!--grid-->
			<div class="scrollArea" style="height:348px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>품목 리스트</caption>
					<colgroup>
						<col width="17%" /> 
						<col width="24%" />
						<col width="24%" />
						<col width="10%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">품목코드</th> 
							<th scope="col">품목명</th> 
							<th scope="col">규격</th>
							<th scope="col">단위</th>
							<th scope="col">제조사</th> 
						</tr>
					</thead>
					<tbody>
					<% if (_dataList == null || _dataList.size() == 0) { %>
						<tr bgcolor="#FFFFFF">
							<td colspan="5" align="center" height = "280">
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
							<a href="javascript:setReturn('<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(_tmp.get("DESCRIPTION_LOC"))%>', '<%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%>', '<%=CommonUtil.nvl(_tmp.get("AVAIL_QTY"))%>' )"><%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%></a>
						</td>
						<td class="left">
							<a href="javascript:setReturn('<%=CommonUtil.nvl(_tmp.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(_tmp.get("DESCRIPTION_LOC"))%>','<%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%>', '<%=CommonUtil.nvl(_tmp.get("AVAIL_QTY"))%>' )"><%=CommonUtil.nvl(_tmp.get("DESCRIPTION_LOC"))%></a>
						</td>
						<td class="left"><%=CommonUtil.nvl(_tmp.get("SPECIFICATION"))%></td>
						<td><%=CommonUtil.nvl(_tmp.get("UNIT_MEASURE"))%></td>
						<td class="left"><%=CommonUtil.nvl(_tmp.get("MAKER_NAME"))%></td>
					</tr>
				<%
					} 
				}
				%>                               
				</tbody>
			</table>
			<p class="paging">
				<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			</p>
		</div>
	</div>        
</div>
</form> 
</body>
</html>
