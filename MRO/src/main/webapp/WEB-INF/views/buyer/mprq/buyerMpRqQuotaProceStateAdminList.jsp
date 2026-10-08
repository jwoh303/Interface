<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 두산인프라의 경우 관리자 전용 견적진행상태정보를 조회한다
* 기능 : 두산인프라의 경우 관리자 전용 견적진행상태정보를 조회한다
* 프로그램 ID : PG_04_B_0056_00
* 담당자 : 김영미 (설계:권우재)
* 생성일 : 2014-08-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 품명선택
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode()); 
	//SLOGIC-BEGIN(P04-4026-04)
		String reportid = "RD_04_B_006_05"; 
		String reporttype = "E"; 
		if (_gridList!= null ){
			if (_gridList.size() > 0){
				Map<String, String> p04402604 = CommonUtil.getSpecialCheckReturnMap(com_code,"P04-4026-04");   // com_code , 특수로직아이디
				if (p04402604 != null){
					reporttype = CommonUtil.nvl(p04402604.get("COL01_DATA"),reporttype); // 레포트type
					reportid = CommonUtil.nvl(p04402604.get("COL02_DATA"),reportid); // 레포트아이디
				}
			}
		}
	//SLOGIC-END
%>

<body onload="kep_onload_view()">
	<div id="wrapper">
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerHeader" />
			<c:param name="part" value="header" />
		</c:import>

		<div id="container2">
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>

			<!--내용 시작-->

			<div id="ContArea">
				<h3>진행상태조회</h3>
				<!--버튼영역-->
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> <span class="btn_reset"><a href="javascript:reload();">초기화</a></span>
				</div>
				<!--조회영역-->
				<form name="searchForm" id="searchForm" method="post">
					<!--HIDDEN-->
					<input type="hidden" name="st_check" id="st_check" value=""> 
					<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
					<!-- 비교견적서 변수-->
					<input type="hidden" name="st_comp_quotation_no" id="st_comp_quotation_no" value=""> <input type="hidden" name="st_comp_revision"
						id="st_comp_quotation_no" value=""> <input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />

					<div id="cont_searchA">
						<table class="cont_t_list01" >
							<caption>진행상태조회</caption>
							<colgroup>
								<col width="12%" />
								<col width="21%" />
								<col width="12%" />
								<col width="21%" />
								<col width="12%" />
								<col width="21%" />
							</colgroup>

							<tbody>
								<tr>
									<th><label for="b_code" class="hidden">조회일자선택</label> <select name="st_search_type" id="st_search_type" style="width: 90%; height: 20px;" class="TitSelect">
											<option value="BTOA" <%if ("BTOA".equals(st_search_type)) {%> selected <%} %>>견적의뢰일</option>
											<option value="ATOS" <%if ("ATOS".equals(st_search_type)) {%> selected <%} %>>견적요청일</option>
											<option value="BTOAE" <%if ("BTOAE".equals(st_search_type)) {%> selected <%} %>>회신요청일</option>
											<option value="ATOSE" <%if ("ATOS".equals(st_search_type)) {%> selected <%} %>>견적마감일</option>
										</select>
									</th>
									<td colspan="3">
										<input type="text" name="st_from_date" id="st_from_date" readOnly style="width: 20%; text-align: center;" value="<%=st_from_date%>"> 
										<a href="javascript:kepCalendar('st_from_date')"></a> 
										- 
										<input type="text" name="st_to_date" id="st_to_date" readOnly style="width: 20%; text-align: center;" value="<%=st_to_date%>"> 
										<a href="javascript:kepCalendar('st_to_date')"></a> &nbsp;&nbsp; 
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
										<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
										<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>		
									</td>
									<th>고객사</th>
									<td>
									<!-- //SLOGIC-BEGIN(P04-4028-01) -->
										<select name="st_buyer_code" name="st_buyer_code" style="width:90%;height:20px;">
											<option value="">전체</option>
											<option value="KRDHIM0001">두산인프라코어(주)</option>
											<option value="KRDHIM0003">두산인프라코어(주) 총무</option>
											<option value="KRDHIM0002">두산인프라코어(주) 일반사무</option>
											<option value="KRDAEW0023">두산인프라코어(주) 창원1공장</option>
											<option value="KRDOOS0003">두산인프라코어(주) 창원3공장</option>
											<option value="KRDAEW0043">두산인프라코어(주) 창원 일반사무</option>
											<option value="KRDAEW0045">두산인프라코어(주) 창원1공장 총무</option>
										</select>
									<!-- //SLOGIC-END  -->
									</td>
								</tr>
								<tr>
									<th>견적번호</th>
									<td><input type="text" name="st_quotation_no" id="st_quotation_no" style="width: 87%;" value="<%=st_quotation_no%>"
										onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()"></td>
									<th>담당자</th>
									<td>
										<select name="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px;" disabled>
										</select>
									</td>	
									<th>진행상태</th>
									<td><label for="b_delivery" class="hidden">진행상태선택</label> <select name="st_sourcing_status" id="st_sourcing_status"
										style="width: 90%; height: 20px;">
										<option value="" <%if ("".equals(st_sourcing_status)) {%> selected <%} %>>전체</option>
			                            <option value="CMS매핑의뢰" <%if ("CMS매핑의뢰".equals(st_sourcing_status)) {%> selected <%} %>>CMS매핑의뢰</option>
			                            <option value="CMS매핑중" <%if ("CMS매핑중".equals(st_sourcing_status)) {%> selected <%} %>>CMS매핑중</option>
			                            <option value="CMS재요청" <%if ("CMS재요청".equals(st_sourcing_status)) {%> selected <%} %>>CMS재요청</option>
			                            <option value="구매사견적의뢰" <%if ("구매사견적의뢰".equals(st_sourcing_status)) {%> selected <%} %>>구매사견적의뢰</option>
			                            <option value="공급사견적요청" <%if ("공급사견적요청".equals(st_sourcing_status)) {%> selected <%} %>>공급사견적요청</option>
			                            <option value="공급사선정완료" <%if ("공급사선정완료".equals(st_sourcing_status)) {%> selected <%} %>>공급사선정완료</option>
			                            <option value="공급사재견적요청" <%if ("공급사재견적요청".equals(st_sourcing_status)) {%> selected <%} %>>공급사재견적요청</option>
			                            <option value="구매사견적제시" <%if ("구매사견적제시".equals(st_sourcing_status)) {%> selected <%} %>>구매사견적제시</option>
			                            <option value="구매사NEGO의뢰" <%if ("구매사NEGO의뢰".equals(st_sourcing_status)) {%> selected <%} %>>구매사NEGO의뢰</option>
			                            <option value="구매사NEGO견적제출" <%if ("구매사NEGO견적제출".equals(st_sourcing_status)) {%> selected <%} %>>구매사NEGO견적제출</option>
			                            <option value="결재진행중" <%if ("결재진행중".equals(st_sourcing_status)) {%> selected <%} %>>결재진행중</option>
			                            <option value="결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%> selected <%} %>>결재반려</option>
			                            <option value="내부품의및카탈로그등록중" <%if ("내부품의및카탈로그등록중".equals(st_sourcing_status)) {%> selected <%} %>>내부품의및카탈로그등록중</option>
			                            <option value="합의완료" <%if ("합의완료".equals(st_sourcing_status)) {%> selected <%} %>>합의완료</option>
			                            <option value="장바구니" <%if ("장바구니".equals(st_sourcing_status)) {%> selected <%} %>>장바구니</option>
			                            <option value="견적취소" <%if ("견적취소".equals(st_sourcing_status)) {%> selected <%} %>>견적취소</option>
									</select></td>
								</tr>
								<tr>
									<th>요청자</th>
				                    <td>
				                        <input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width:87%" value="" onkeydown="if(event.keyCode == 13) {kepSearch(1);}">
				                    </td>
				                    <th>품명/규격</th>
				                    <td>
										<input type="text" name="st_desc_spec" id="st_desc_spec" style="width:87%;ime-mode:active" value="" onkeydown="if(event.keyCode == 13) {kepSearch(1);}">
				                    </td>
									<th>품목코드</th>
				                    <td>
										<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%" value="" onkeydown="if(event.keyCode == 13) {kepSearch(1);}">
				                    </td>
								</tr>
							</tbody>
						</table>
					</div>

					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" /> <label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow">
							<option value="10" <%if ("10".equals(onepagerow)) {%> selected <%} %>>10건</option>
							<option value="20" <%if ("20".equals(onepagerow)) {%> selected <%} %>>20건</option>
							<option value="30" <%if ("30".equals(onepagerow)) {%> selected <%} %>>30건</option>
							<option value="40" <%if ("40".equals(onepagerow)) {%> selected <%} %>>40건</option>
							<option value="50" <%if ("50".equals(onepagerow)) {%> selected <%} %>>50건</option>
					</select> </span> <span class="fr">총건수 <%=total_cnt %></span> <br>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
					<table class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="2%" />
							<col width="4%" />
							<col width="12%" />
							<col width="8%" />
							<col width="11%" />
							<col width="*" />
							<col width="7%" />
							<col width="8%" />
							<col width="8%" />
							<col width="9%" />
							<col width="8%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="check_status" id="check_status" value="선택" style="cursor: hand;"
									onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
								</th>
								<th scope="col">번호</th>
								<th scope="col">견적번호<br>진행상태
								</th>
								<th scope="col">순번<br>품목코드
								</th>
								<th scope="col">견적의뢰일<br>회신요청일
								</th>
								<th scope="col">품목명<br>규격
								</th>
								<th scope="col">제조사<br>원산지
								</th>
								<th scope="col">단위/수량<br>매입단가
								</th>
								<th scope="col">견적단가<br>Nego단가
								</th>
								<th scope="col">협력사<br>KeP담당자
								</th>
								<th scope="col">요청자<br>요청부서
								</th>
							</tr>
						</thead>
						<tbody>
							<%
        if (_gridList == null || _gridList.size() == 0){
        %>
							<tr>
								<td colspan="15" align="center" height="50"><span>조회된 데이타가 없습니다.</span></td>
							</tr>
							<%
        }else{
        	
        	String aaa=null;
            
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
// 				if ((j%2) == 1) tclass = "#FFFFFF";
//                 else tclass = "f4f5f9";
		%>
							<tr align="center" bgcolor="<%=tclass%>">
								<td rowspan="2" class="font1_black1" align="center">
								<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
								<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>">
								</td>
								<td rowspan="2" class="font1_black1" align="center"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %> <input
									type="hidden" name="st_buyer" id="st_buyer" value="<%=rowData.get("BUYER") %>"> 
								<!-- //SLOGIC-BEGIN(P04-4026-01) -->
								<% if (com_code == "KRKOLO0077") { %> 
										<input type="hidden" name="st_user_id" id="st_user_id" value="ALL"> 
								<!-- //SLOGIC-END -->
								<% } else { %>
									<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 
								<% } %>
									<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO") %>"> 
									<input type="hidden" name="st_agent" id="st_agent" value="<%=CommonUtil.nvl(rowData.get("AGENT")) %>"> 
									<input type="hidden" name="st_contract_no" id="st_contract_no" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>"> 
									<input type="hidden" name="st_contract_seq" id="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ")) %>"> 
									<input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code" value="<%=rowData.get("BYCA_COMORG_CODE") %>"> 
									<input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=String.valueOf(rowData.get("ITEM_QTY")) %>"> 
									<input type="hidden" name="st_btoa_remark" id="st_btoa_remark" value="<%=CommonUtil.nvl(rowData.get("BTOA_REMARK")) %>"> 
									<input type="hidden" name="st_rivision" id="st_rivision" value="<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>"> 
									<input type="hidden" name="st_status" id="st_status" value="<%=rowData.get("SOURCING_STATUS") %>">
									<input type="hidden" name="st_quotation_no2" id="st_quotation_no2" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>">
									<input type="hidden" name="st_quotation_seq2" id="st_quotation_seq2" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>">
								</td>

								<td title="견적번호"><a class="hyperLink b"
									href="javascript:doPop('quotationReDetailPop','<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("QUOTATION_NO"))%>', '<%=String.valueOf(rowData.get("REVISION"))%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%></b></a>
								</td>
								<td title="순번"><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%></td>
								<td title="견적의뢰일"><%=rowData.get("BTOA_DATE")%></td>
								<td title="품목명"><%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%></td>
								<td title="제조사"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
								<td title="단위/수량"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%>/<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,0)%></td>
								<td title="견적단가">
									<%              // 2013.07.15 Jinsoo
                     // 특정 고객사에 대해서만 조회가능 하도록 처리함.
                     //SLOGIC-BEGIN(P04-4026-03)
                     String company_list = "KRDAEW0023, KRDAEW0043, KRDAEW0045, KRDHIM0005, KRDOOS0046, KRDIGU0001, KRDHIM0002, KRDHIM0003, KRDHIM0001";
                     if( company_list.indexOf(String.valueOf(rowData.get("BUYER"))) > -1 ) {        %> <a class="hyperLink"
									href="javascript:doPop('SourcingHistoryDt','<%=String.valueOf(rowData.get("BUYER_NAME"))%>', '<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("QUOTATION_NO"))%>', '<%=String.valueOf(rowData.get("QUOTATION_SEQ"))%>', '<%=String.valueOf(rowData.get("REVISION"))%>');">
										<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ATOB_UNIT_PRICE")),true,0,3)%>
								</a> <%              } else {        %> <%=CommonUtil.formatNumber(String.valueOf(rowData.get("ATOB_UNIT_PRICE")),true,0,3)%> <%              }                %>
					<!-- //SLOGIC-END -->
								</td>

								<td title="협력사"><a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("AGENT"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_NAME")))%></a></td>
								<td title="요청자"><a class="hyperLink" href="javascript:doPop('user_display','<%=String.valueOf(rowData.get("BTOA_USER_ID"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_NAME")))%></a></td>
							</tr>
							<tr bgcolor="<%=tclass%>" align="center" height="25">
								<td title="진행상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("SOURCING_STATUS")))%></td>
								<td title="품목코드"><input type="hidden" name="li_quotation_no" id="li_quotation_no"
									value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>"> <input type="hidden" name="li_quotation_seq"
									id="li_quotation_seq" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>"> <input type="hidden"
									name="li_revision" id="li_revision" value="<%=String.valueOf(rowData.get("REVISION"))%>"> <input type="hidden" name="li_agent"
									id="li_agent" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>"> <input type="hidden" name="li_open_flag"
									id="li_open_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>"> <a class="hyperLink"
									href="javascript:quotation_print('<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>','<%=String.valueOf(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></a>
								</td>
								<td title="회신요청일"><b> <%=String.valueOf(rowData.get("BTOA_END_DATE"))%>
								</b></td>
								<td title="규격"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
								<td title="원산지"><%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%></td>
								<td title="매입단가"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("STOA_LIST_PRICE")),true,0,3)%></td>
								<td title="Nego단가"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("BTOA_NEGO_PRICE")),true,0,3)%></td>
								<td title="KeP담당자"><a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=String.valueOf(rowData.get("KEP_USER_ID"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("KEP_USER_NAME")))%></a></td>
								<td title="요청부서"><%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_DEPT")))%></td>
							</tr>
							<%
                        } 
            %>
							<%
                    } 
            %>

						</tbody>
					</table>
					<!--페이징-->
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>
					</p>

					<!--버튼영역-->
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04 mr04"> <a href="javascript:ExcelDown()">엑셀다운로드</a>
							</span>
						</div>
					</div>
				</form>

				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" /> <input type="hidden" name="buyer" id="buyer" value="" /> <input
						type="hidden" name="gubun" id="gubun" value="" /> <input type="hidden" name="total_cnt" id="total_cnt" value="<%=total_cnt %>" /> <input
						type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> <input type="hidden" name="onepagerow" id="onepagerow"
						value="<%=onepagerow %>" />
					<div id="process"></div>
				</form>
			</div>

			<!--내용 종료-->
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
	</div>
</body>

<script type="text/javascript">
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqQuotaProceStateAdmin.do").submit();   
}

/**
 * FORM 을 초기화
 */
function reload(){
	
	kepReload("searchForm");
	
	//document.forms.searchForm.reset();
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
}
  
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
	
	<%if ("runCheck".equals(gubun_msg)){%>
		alert("등록신청이 성공적으로 이루어 졌습니다. ");
	<%}else if ("delCheck".equals(gubun_msg)){%>
		alert("삭제 작업이 성공적으로 이루어 졌습니다. ");
	<%}else if ("cartCheck".equals(gubun_msg)){%>
		alert("아래와 같이 작업이 진행 되었습니다. \n\n<%=item_cnt_no_msg%>");
	<%}%> 
	
}	

//팝업함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	
	switch (str) {
	case "dept": // 요청부서
		openSearchPopup("/common/deptCodeAdminPop.do");
		break;
	case "quotationReDetailPop": // 견적번호
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "1020,500,no");
		break;
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "user_display": // 요청자
		openSearchPopup('/common/userDisplayPop.do','?st_user_id='+value1,"800,500,no");
		break;
	case "SourcingHistoryDt": // 견적단가이력
		openSearchPopup('/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do','?st_buyer_name='+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5,"900,600,no");
		break;
	}
}

//콜백함수(파일명은 모두 동일)
   function setPopupReturn(code, text){
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
   }

   /**
    * 체크 된 수
    */
   function getCheckedRowCount(tot_cnt) {
   	
   	var chk_cnt = 0;
   	if(eval(tot_cnt) < 2){
   	    var box = eval("document.forms.contentForm.checkbox0");
   	    if(box.checked == true) chk_cnt++;
   	}else{
   	    for(var j = 0; j < tot_cnt; j++){
   	         var box = eval("document.forms.contentForm.checkbox" + j);
   	         if(box.checked == true){
   	              chk_cnt++;
   	         }
   	    }
   	}
   	return chk_cnt;
   }

function getCheckedStatusConfirm() {
    var tot_cnt = $("#display_item_cnt").val();
    var checked_count   = getCheckedRowCount(tot_cnt);
    var bFlag           = true;
    var box = "";

    if(checked_count==0) {
        alert("선택된 품목이 없습니다.");
        return false;
    }
   for(var j=0; j<tot_cnt; j++) {
	   box = eval("document.forms.contentForm.checkbox" + j);
       if(box.checked==true) {
           if(document.forms.contentForm.st_status[j].value!="합의완료" && document.forms.contentForm.st_status[j].value!="장바구니") {
               bFlag=false;
               break;
           }
       }
   }
    return bFlag;
}

/* 장바구니 담기 */
function cartCheck() {   
	
	if(!getCheckedStatusConfirm()) {
        alert("합의완료된 품목들만 장바구니에 담을수 있습니다.");
        return false;
    }
	
	var btnEvent = "cartCheck";
	/* 그리드 데이터 셋팅 */
	if(setGridData(btnEvent)){
		if(!confirm("장바구니에 담으시겠습니까?")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/saveBuyerMpRqQuotaProceState.do","processForm",btnEvent); 	
	}
}

/* 선택된 그리드 값을 셋팅 */
function setGridData(btnEvent){
	var returnValue = true;
	//선택된 항목수 취득
// 	var tot_cnt	 = document.forms.contentForm.display_item_cnt.value;
// 	alert("start")

	var chkGridValue = {
			keys : ["st_status"] ,
			value0 : ["합의완료", "장바구니"],
			msg0 : ["합의완료된 품목들만 장바구니에 담을수 있습니다."]
	};

	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
// 		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
// 	var msg = response.msg.MSG;   
// 	if (msg != ""){
// 		alert(msg);
// 	}

	// 처리후 재조회
// 	kepSearch($("#curPage").val());
	
	if (pMethod == 'cartCheck'){
		var buyer = $("#st_buyer").val();
		if(confirm("장바구니로 이동하시겠습니까?")) {
			if(buyer=="KRKEPB0004" || buyer=="KRKOLO0016") {
				location.href = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
// 				document.forms[0].action = "/kr/buyer/shopping_cart/buyer_krkolo0016_shoppingcart_list.jsp";
			}else {
				location.href = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
// 				document.forms[0].action = "/kr/buyer/shopping_cart/buyer_shoppingcart_list.jsp";
			}
		} else {
			kepSearch($("#curPage").val());
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	 var msg = response.msg.MSG;   
	
	if (msg != ""){
		alert(msg);
	}
} 

//엑셀다운로드
function ExcelDown(){
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getBuyerAdminExcelDown.do";
	document.forms.searchForm.submit();
}

//견적제출현황 출력
function rd_onload(){

	var buyer = $("#st_buyer").val();
	var user_id = $("#st_user_id").val();
	var from_date = kepReplaceAll('st_from_date','\\/','');
	var to_date = kepReplaceAll('st_to_date','\\/','');
	
	var fileName = "RD_04_B_004_00";
	var param =  "["+buyer+"]["+from_date+"]["+to_date+"]["+user_id+"]";
  	reportOpen(fileName,param);
	return;
	
}

function movePage() {
<%-- 	var buyer		= "<%=buyer%>"; --%>
// 	if(confirm("장바구니로 이동하시겠습니까?")) {
// 		document.forms[0].target="cen";
// 		document.forms[0].method="POST";
// 		if(buyer=="KRKEPB0004" || buyer=="KRKOLO0016") {
// 			document.forms[0].action = "/kr/customer/shopping_cart/buyer_krkolo0016_shoppingcart_list.jsp";
// 		}else {
// 			document.forms[0].action = "/kr/customer/shopping_cart/buyer_shoppingcart_list.jsp";
// 		}
// 		document.forms[0].submit();
// 	}
}

function setCartResult_Refresh(msg, use_flag){
<%--     var com_code = "<%=buyer%>"; --%>
//     if(msg == "CREATE_OK"){
//        if(use_flag == "C"){
//            alert(" 장바구니에 저장되었습니다.   ");
//            document.forms[0].target = "cen";
//            document.forms[0].method ="post";

//            if(com_code =="KRDOOD0001"){
//                document.forms[0].action = "/kr/customer/doosan/shopping_cart/buyer_shoppingcart_list_doosan.jsp";
//            }else{
//                document.forms[0].action = "/kr/customer/shopping_cart/buyer_shoppingcart_list.jsp";
//            }
//            document.forms[0].submit();
//            return;
//        }
//     }else {
//        if(use_flag == "C") {
//            alert("품목코드 (" + msg + ") 은 이미 장바구니에 저장된 항목입니다.  ");
//        }else {
//            alert("품목코드 (" + msg + ") 은 이미 나의상품으로 등록된 항목입니다.  ");
//        }
//     }
}

function printPum(){
// 	BuyerSourcingStatusList.quotation_print_per_item();
}
// 품목코드 클릭시 출력물 연결
function quotation_print(quotation_no, quotation_seq, revision, agent,open_flag) {
	
	if(isEmpty(agent)) {
		alert("견적서가 발행되지 않은 품목입니다.");
		return;
	}

// 	open_flag = "N";
	var buyer = "<%=com_code%>";
	var fileName = "<%=reportid%>";
	var type = "<%=reporttype%>";
	var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+open_flag+"]";
	if (type == "A"){
		param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+open_flag+"]";
	}
	alert(fileName+"             "+param);
  	reportOpen(fileName,param);
	return;
}
function souList(){
	 var checked_count    = getCheckedRowCount();

	    if(checked_count == 0){
	        alert('선택된 품목이 없습니다');
	        return;
	    }

	    var tot_cnt  = document.forms.contentForm.display_item_cnt.value;//document.forms[0].display_item_cnt.value;

	    var chk_cnt = 0;
	    var cnt     = 0;
	    var query   = "";

	    if(tot_cnt==1) {
	    	var box =  eval("document.forms.contentForm.checkbox");
			
	    	if(box.checked==true) {
		        var li_quotation_no     = document.forms.contentForm.li_quotation_no.value;
		        var li_quotation_seq    = document.forms.contentForm.li_quotation_seq.value;
		        var li_revision         = document.forms.contentForm.li_revision.value;
		        var li_agent            = document.forms.contentForm.li_agent.value;
	    	}
	
            if(isEmpty(li_agent)) {

                alert("견적서가 발행되지 않은 품목입니다.");
                return;

            }
//             query = li_quotation_no + "@@" + li_quotation_seq + "@@" + li_revision  + "@@" + li_agent + "^||^";

	    }else {
	        var prev_quotation_no = "";
	        
	        for(var j=1; j<=tot_cnt; j++) {
	            var box = eval("document.forms.contentForm.checkbox");
	        
	            var li_quotation_no     = document.forms.contentForm.li_quotation_no[j-1].value;
		        var li_quotation_seq    = document.forms.contentForm.li_quotation_seq[j-1].value;
		        var li_revision         = document.forms.contentForm.li_revision[j-1].value;
		        var li_agent            = document.forms.contentForm.li_agent[j-1].value;
	            
	            if(box.checked==true) {
	            	 if(isEmpty(li_agent)) {

		                    alert("견적서가 발행되지 않은 품목입니다.");
		                    return;

	                }

	                if(prev_quotation_no != li_quotation_no && prev_quotation_no != ""){
	                    alert('견적번호가 같은 품목들을 선택 하십시오');
	                    return;
	                }else{
	                    prev_quotation_no = li_quotation_no;
	                }

// 		                query += li_quotation_no + "@@" + li_quotation_seq + "@@" + li_revision  + "@@" + li_agent ;
// 		                query += "^||^";
	            	
	            }
	        }
	        
	    }

	    var buyer = ${sessionInfo.comCode};
	    var open_flag = "N";

	    // 요부분은 수정 필요(나머지 위는 컨버팅 한 부분 테스트는 필요)
	    window.open("/kr/customer/new_sourcing/sheet/buyer/sysop_sourcing_print_sntdw.jsp?st_buyer="+buyer+"&st_quotation_no="+li_quotation_no+"&st_quotation_seq="+li_quotation_seq+"&st_revision="+li_revision, "SheetSntdw","width=1100,height=700,resizable=NO,scrollbars=NO,top=0,left=0");

}

</script>
</html>
