<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 견적진행상태조회
* 기능 : 
* 프로그램 ID : PG_04_B_005_00
* 담당자 : 김영미 (설계:권우재)
* 생성일 : 2014-08-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10")); // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String b_com_code =  _sessionInfo.getComCode();
	String b_user_type =   _sessionInfo.getUserType();
	
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 품명선택
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	String st_btoa_user_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_name"),"");  // 견적번호
	String st_all_re = CommonUtil.nvl((String) request.getParameter("st_all_re"),"N");  // 기간무시 체크
	String st_sourcing_sort = CommonUtil.nvl((String) request.getParameter("st_sourcing_sort"),"");  // 정렬기능
	
	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode()); 
	String st_user_group=  CommonUtil.nvl((String) request.getParameter("st_user_group"), _sessionInfo.getUserGroup()); 
	String st_user_id = _sessionInfo.getUserId();
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
	
	//SLOGIC-BEGIN(P06-0000036) P04-4026-08
	 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	 String p060000036 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000036","COL02_DATA", request); // 권한별URL
	 if (p060000036 == null){
	 	p060000036 = defaultUrl;
	 }else if ("".equals(p060000036)){
	 	p060000036 = defaultUrl;
	 }
	/*
	프로그램ID: PG_02_B_000834_008
	수정자: 현명환
	수정일: 2015.03.06
	펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000052");
		//고객사 그룹통합여부 여부
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
	String group_mng_flag = "N";
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  // 계열사정보
	if(getCodeTGCM == true){
		group_mng_flag = "Y"; 
	}
	/*고객사 본인,전체 조회권한부여*/
	boolean P04405101 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4051-01");
	String searchRole = "ALL";
	if(P04405101 == true){
		if(b_user_type.equals("A")){
			searchRole = "ALL";
		}else{
			searchRole = "N";	
		}
	}
	//안전인증서 표기 여부
	boolean p04405701 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4057-01");
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(com_code,"P17-0000001");
	//상세 엑셀다운로드 기능 통제
	boolean p170000002 = CommonUtil.getSpecialCheckReturn(com_code,"P17-0000002");	
	//중앙대 사용자별 합의자 지정
	boolean getCodeM_01 = CommonUtil.getCode3CheckReturnCodeAllParam("M-01", "", st_user_id, com_code, "", "", "", "A");
	String assign_agrmnt_flag = "N";
	if(getCodeM_01 == true){
		assign_agrmnt_flag = "Y"; 
	}
	
	// 단가합의 사유 추가
	boolean p04402709 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-09");
	
	// MSDS 표기 여부
	String msds_view_flag = "N";
	boolean p060000123 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000123");
	if(p060000123 == true){
		msds_view_flag = "Y";
	}
	
	//견적상세 팝업
    boolean p04402705 = CommonUtil.getSpecialCheckReturn(com_code,"P04-4027-05");
	//SLOGIC-END
%>

<body onload="kep_onload_view()">
	<div id="wrapper">
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerHeader" />
			<c:param name="part" value="header" />
		</c:import>

			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>

			<!--내용 시작-->
			<div id="container2">
			<div id="ContArea">
				<h3><%=CommonLang.get("HTITLE149")%></h3><!-- 진행상태조회 -->
				<!--버튼영역-->
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> <span class="btn_reset"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
				</div>
				<!--조회영역-->
				<form name="searchForm" id="searchForm" method="post">
					<!--HIDDEN-->
					<input type="hidden" name="st_check" id="st_check" value=""> 
					<input type="hidden" name="st_all_re"  id="st_all_re" value ="N">
					<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
					<input type="hidden" name="assign_agrmnt_flag" id="assign_agrmnt_flag" value="<%=assign_agrmnt_flag%>">
					<input type="hidden" name="st_searchRole" id="st_searchRole" value="<%=searchRole%>">
					<input type="hidden" name="st_group_info" id="st_group_info" value="">
					<!-- 비교견적서 변수-->
					<input type="hidden" name="st_comp_quotation_no" id="st_comp_quotation_no" value=""> <input type="hidden" name="st_comp_revision"
						id="st_comp_quotation_no" value=""> <input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">					
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> <input type="hidden" name="st_user_group" id="st_user_group"
						value="<%=st_user_group %>" />
					<!-- //SLOGIC-BEGIN(P04-4026-01) -->
					<% if (com_code == "KRKOLO0077") { %>
					<input type="hidden" name="st_user_id" id="st_user_id" value="ALL">
					<!-- //SLOGIC-END -->
					<% } else { %>
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
					<% } %>

					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption><%=CommonLang.get("HTITLE149")%><!-- 진행상태조회 --></caption>
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
									<td><%=CommonLang.get("HTITLE151")%><!-- 견적일 --></td>
									<td colspan="3"><input type="text" name="st_from_date" id="st_from_date" readOnly style="width: 20%; text-align: center;"
										value="<%=st_from_date%>"> <a href="javascript:kepCalendar('st_from_date')"></a> - 
										<input type="text" name="st_to_date" id="st_to_date" readOnly style="width: 20%; text-align: center;" value="<%=st_to_date%>"> 
										<a href="javascript:kepCalendar('st_to_date')"></a> &nbsp;&nbsp; 
										<span class="btn_month"> <a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
											<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
											<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
											<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>		
											<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" <%if("Y".equals(st_all_re)){%>checked<%}%>>&nbsp;<%=CommonLang.get("HTITLE603")%><!-- 기간무시 -->
											</td>

									<td><label for="b_code" class="hidden">품목명선택</label> <select name="st_search_type" id="st_search_type" style="width: 90%; height: 20px;"
										class="TitSelect">
											<option value="DE" <%if ("DE".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
											<option value="SP" <%if ("SP".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE14")%><!-- 규격 --></option>
											<option value="BC" <%if ("BC".equals(st_search_type)) {%> selected <%} %>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
									</select></td>
									<td><input type="text" name="st_search_code" id="st_search_code" style="width: 87%;" value="<%=st_search_code%>" onkeydown="kepEnter()" /></td>
								</tr>
								<tr>
									<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>
									<td><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></td>
									<td><label for="b_delivery" class="hidden">진행상태선택</label> <select name="st_sourcing_status" id="st_sourcing_status"
										style="width: 90%; height: 20px;">
											<option value="" <%if ("".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
											<option value="견적의뢰" <%if ("견적의뢰".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></option>
											<option value="견적진행중" <%if ("견적진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE154")%><!-- 견적진행중 --></option>
											<option value="단가합의대상" <%if ("단가합의대상".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></option>
											<option value="Nego견적의뢰" <%if ("Nego견적의뢰".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE156")%><!-- Nego견적의뢰 --></option>
											<option value="Nego진행중" <%if ("Nego진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE157")%><!-- Nego진행중 --></option>
											<option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE138")%><!-- Nego합의대상 --></option>
											<option value="KeP결재진행중" <%if ("결재진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE621")%><!-- KeP결재진행중 --></option>
											<option value="KeP결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE622")%><!-- KeP결재반려 --></option>
											<option value="코드부여중" <%if ("코드부여중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE159")%><!-- 코드부여중 --></option>
											<option value="합의완료" <%if ("합의완료".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE160")%><!-- 합의완료 --></option>
											<option value="발주" <%if ("발주".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE162")%><!-- 발주 --></option>
											<option value="견적취소" <%if ("견적취소".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></option>
									</select></td>
									<td><%=CommonLang.get("HTITLE126")%><!-- 견적번호 --></td>
									<td><input type="text" name="st_quotation_no" id="st_quotation_no" style="width: 87%;" value="<%=st_quotation_no%>"
										onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()"></td>
									<td></td>
									<td></td>
<%}else{ %>
									<td><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></td>
									<td><input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width: 55%; ime-mode: active"
										value="<%=st_btoa_user_dept_name%>" READONLY> <input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code"
										value="<%=st_btoa_user_dept_code%>"> <a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif"></a> <a
										href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a></td>
									<td><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></td>
									<td><label for="b_delivery" class="hidden">진행상태선택</label> <select name="st_sourcing_status" id="st_sourcing_status"
										style="width: 90%; height: 20px;">
											<option value="" <%if ("".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
											<option value="의뢰결재중" <%if ("의뢰결재중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE152")%><!-- 의뢰결재중 --></option>
											<option value="의뢰반려" <%if ("의뢰반려".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE153")%><!-- 의뢰반려 --></option>
											<option value="견적의뢰" <%if ("견적의뢰".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></option>
											<option value="견적진행중" <%if ("견적진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE154")%><!-- 견적진행중 --></option>
											<option value="단가합의대상" <%if ("단가합의대상".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE155")%><!-- 단가합의대상 --></option>
											<option value="Nego견적의뢰" <%if ("Nego견적의뢰".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE156")%><!-- Nego견적의뢰 --></option>
											<option value="Nego진행중" <%if ("Nego진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE157")%><!-- Nego진행중 --></option>
											<option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE138")%><!-- Nego합의대상 --></option>
											<option value="결재진행중" <%if ("결재진행중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE158")%><!-- 결재진행중 --></option>
											<option value="결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE139")%><!-- 결재반려 --></option>
											<option value="코드부여중" <%if ("코드부여중".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE159")%><!-- 코드부여중 --></option>
											<option value="합의완료" <%if ("합의완료".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE160")%><!-- 합의완료 --></option>
											<option value="장바구니" <%if ("장바구니".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --></option>
											<option value="발주" <%if ("발주".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE162")%><!-- 발주 --></option>
											<option value="견적취소" <%if ("견적취소".equals(st_sourcing_status)) {%> selected <%} %>><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></option>
									</select></td>
									<td><%=CommonLang.get("HTITLE126")%><!-- 견적번호 --></td>
									<td><input type="text" name="st_quotation_no" id="st_quotation_no" style="width: 87%;" value="<%=st_quotation_no%>"
										onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()"></td>
									<%} %>
								</tr>
								<tr>
					<%if(searchRole.equals("N")){%>								
							<td><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></td>
							<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width: 87%;" value="${sessionInfo.userNameLoc}" READONLY></td>
					<%}else{%>
							<td><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></td>
							<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width: 87%;" value="<%=st_btoa_user_name%>" onKeyDown="kepEnter()"></td>
					<%}%>
					<%if(group_mng_flag.equals("Y")){%>
						<td><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></td>
				      	<td>
					        <select name="st_buyer" id="st_buyer" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
				      	</td>
					<%}else{%>
							<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
					<%}%>
									<td></td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>

					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" /> <label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow">
							<option value="10" <%if ("10".equals(onepagerow)) {%> selected <%} %>>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
							<option value="20" <%if ("20".equals(onepagerow)) {%> selected <%} %>>20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
							<option value="30" <%if ("30".equals(onepagerow)) {%> selected <%} %>>30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
							<option value="40" <%if ("40".equals(onepagerow)) {%> selected <%} %>>40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
							<option value="50" <%if ("50".equals(onepagerow)) {%> selected <%} %>>50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					</select> 
					<select name="st_sourcing_sort">
						<option value="A"  <%if ("A".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE126")%>▼</option>	<!-- 견적번호▼ -->
						<option value="B"  <%if ("B".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE126")%>▲</option>	<!-- 견적번호▲ -->
						<option value="C"  <%if ("C".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE127")%>▼</option>	<!-- 견적의뢰▲ -->
						<option value="D"  <%if ("D".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE127")%>▲</option>	<!-- 견적의뢰▲ -->
						<option value="E"  <%if ("E".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE51")%>▼</option>	<!-- 회신요청일▼ -->
						<option value="F"  <%if ("F".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE51")%>▲</option>	<!-- 회신요청일▲ -->
						<option value="G"  <%if ("G".equals(st_sourcing_sort)) {%>selected<%} %>>제조사명▼</option>
						<option value="H"  <%if ("H".equals(st_sourcing_sort)) {%>selected<%} %>>제조사명▲</option>
						<option value="I"  <%if ("I".equals(st_sourcing_sort)) {%>selected<%} %>>요청부서명▼</option>
						<option value="J"  <%if ("J".equals(st_sourcing_sort)) {%>selected<%} %>>요청부서명▲</option>
					</select>
					</span> <span class="fr"> <%=CommonLang.get("HTITLE608")%><!--  총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly
						style="width: 30px; border: 0" value="<%=total_cnt %>" />
					</span> <br>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>

						<colgroup>
							<col width="2%" />
							<col width="4%" />
							<col width="12%" />
							<col width="12%" />
							<col width="10%" />
							<col width="*" />
							<col width="7%" />
							<col width="7%" />
							<col width="7%" />
							<col width="11%" />
							<col width="4%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="check_status" id="check_status" value="선택" style="cursor: hand;" onclick="kepCheckAll2();">
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE44") %><!-- 번호 --></th>
								<th scope="col"><%=CommonLang.get("HTITLE126") %><!-- 견적번호 --><br><%=CommonLang.get("HTITLE606") %><!-- 진행상태 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE140") %><!-- 순번 --><br><%=CommonLang.get("HTITLE12") %><!-- 품목코드 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE127") %><!-- 견적의뢰일 --><br><%=CommonLang.get("HTITLE51") %><!-- 회신요청일 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --><br><%=CommonLang.get("HTITLE120") %><!-- 원산지 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE45") %><!-- 수량 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE145") %><!-- 견적단가 --><br><%=CommonLang.get("HTITLE165") %><!-- Nego단가 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE625") %><!-- 청구자 --><br><%=CommonLang.get("HTITLE144") %><!-- 협력사 -->
								<th scope="col"><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>
							</tr>
<%}else{ %>
						
						<colgroup>
							<col width="2%" />
							<col width="4%" />
			<%if(group_mng_flag.equals("Y")){%>
				<col width="8%" />
			<%}%>
							<col width="8%" />
							<col width="8%" />
							<col width="8%" />
							<col width="*" />
							<col width="8%" />
							<col width="6%" />
							<col width="6%" />
							<col width="9%" />
							<col width="8%" />
							<col width="5%" />
							<col width="5%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="check_status" id="check_status" value="선택" style="cursor: hand;" onclick="kepCheckAll2();">
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE44") %><!-- 번호 --></th>
						<%if(group_mng_flag.equals("Y")){%>
								<th scope="col"><%=CommonLang.get("HTITLE290") %><!-- 고객사코드 --><br><%=CommonLang.get("HTITLE291") %><!-- 고객사명 -->
								</th>
						<%}%>
								<th scope="col"><%=CommonLang.get("HTITLE126") %><!-- 견적번호 --><br><%=CommonLang.get("HTITLE606") %><!-- 진행상태 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE140") %><!-- 순번 --><br><%=CommonLang.get("HTITLE12") %><!-- 품목코드 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE127") %><!-- 견적의뢰일 --><br><%=CommonLang.get("HTITLE51") %><!-- 회신요청일 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --><br><%=CommonLang.get("HTITLE120") %><!-- 원산지 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE163") %><!-- 단위/수량 --><br><%=CommonLang.get("HTITLE578") %><!-- 조달일수 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE145") %><!-- 견적단가 --><br><%=CommonLang.get("HTITLE165") %><!-- Nego단가 -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><%=CommonLang.get("HTITLE963") %><!-- 담당자(총괄/견적) -->
								</th>
								<th scope="col"><%=CommonLang.get("HTITLE133") %><!-- 요청자 -->/<%=CommonLang.get("HTITLE687") %><!--합의자 --><br><%=CommonLang.get("HTITLE135") %><!-- 요청부서 -->
								<th scope="col"><%=CommonLang.get("HTITLE166") %><!-- 첨부 -->/<%=CommonLang.get("HTITLE122")%><!-- 비고 --><br><%=CommonLang.get("HTITLE686") %><!-- 취소/지연 --></th>
						        <%
						        //안전인증서 표기 여부
						        if((p04405701 == true)) {
						        %>
						        	<th scope="col"><%=CommonLang.get("HTITLE914") %><!--MSDS --><%=CommonLang.get("HTITLE970") %><!--요청 --><br><%=CommonLang.get("HTITLE915") %><!-- 안전인증서 --></th>
						        <%
						        }else{
						        %>
						        	<th scope="col"><%=CommonLang.get("HTITLE914") %><!--MSDS --><%=CommonLang.get("HTITLE970") %><!--요청 --></th>
						        <%
						        }
						        %>
							</tr>
							<%}%>
						</thead>
						<tbody>
							<%
        if (_gridList == null || _gridList.size() == 0){
        %>
							<tr>
								<td colspan="15" align="center" height="50"><span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span></td>
							</tr>
							<%
        }else{
        	
        	String aaa=null;
            
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>
							<tr align="center" bgcolor="<%=tclass%>">
								<td rowspan="2" class="font1_black1" align="center"><input type="checkbox" name="checkbox" id="checkbox<%=j%>"> <input
									type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>"></td>
								<td rowspan="2" class="font1_black1" align="center"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %> <input
									type="hidden" name="st_buyer" id="st_buyer" value="<%=rowData.get("BUYER") %>"> <input type="hidden" name="st_user_id"
									id="st_user_id" value="${sessionInfo.userId}"> <input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no"
									value="<%=rowData.get("BUYER_ITEM_NO") %>"> <input type="hidden" name="st_agent" id="st_agent"
									value="<%=CommonUtil.nvl(rowData.get("AGENT")) %>"> <input type="hidden" name="st_contract_no" id="st_contract_no"
									value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>"> <input type="hidden" name="st_contract_seq" id="st_contract_seq"
									value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ")) %>"> <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code"
									value="<%=rowData.get("BYCA_COMORG_CODE") %>"> <input type="hidden" name="st_item_qty" id="st_item_qty"
									value="<%=String.valueOf(rowData.get("ITEM_QTY")) %>"> <input type="hidden" name="st_btoa_remark" id="st_btoa_remark"
									value="<%=CommonUtil.nvl(rowData.get("BTOA_REMARK")) %>"> <input type="hidden" name="st_rivision" id="st_rivision"
									value="<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>"> <input type="hidden" name="st_status" id="st_status"
									value="<%=rowData.get("SOURCING_STATUS") %>"> <input type="hidden" name="st_quotation_no2" id="st_quotation_no2"
									value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>"> <input type="hidden" name="st_quotation_seq2"
									id="st_quotation_seq2" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>"> <input type="hidden"
									name="st_product_close_flag" id="st_product_close_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")))%>">
								</td>
								<td title="견적번호"><a class="hyperLink b"
									href="javascript:doPop('buyerMpRqDepartmentPCOPop','<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("QUOTATION_NO"))%>', '<%=String.valueOf(rowData.get("REVISION"))%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%></b></a>
								</td>
								<td title="순번"><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%></td>
								<td title="견적의뢰일"><%=rowData.get("BTOA_DATE")%></td>
								<td title="품목명" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%></td>
								<td title="제조사"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
								<td title="단위"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></td>
								<td title="견적단가" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ATOB_UNIT_PRICE")),true,0,3)%></td>
								<td title="청구자"><%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_NAME")))%></td>
								<td title="첨부" rowspan="2">
									<%
                                        if(!rowData.get("IMAGE_KEY").equals("")) {
                                    %> <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img
										name="st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a> <%
                                        }else {
                                    %> <img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0"> <%
                                        }
                                    %>
								</td>
							</tr>
							<tr bgcolor="<%=tclass%>" align="center" height="25">
								<td title="진행상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("SOURCING_STATUS")))%></td>
								<td title="품목코드"><input type="hidden" name="li_quotation_no" id="li_quotation_no"
									value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>"> <input type="hidden" name="li_quotation_seq"
									id="li_quotation_seq" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>"> <input type="hidden"
									name="li_revision" id="li_revision" value="<%=String.valueOf(rowData.get("REVISION"))%>"> <input type="hidden" name="li_agent"
									id="li_agent" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>"> <input type="hidden" name="li_open_flag"
									id="li_open_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>"> <a class="hyperLink"
									href="javascript:quotation_print('<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>','<%=String.valueOf(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>', '<%=String.valueOf(CommonUtil.nvl(rowData.get("BID_SUCCESS_QUOTATION_SEQ")))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></a>
								</td>
								<td title="회신요청일"><b> <%=String.valueOf(rowData.get("BTOA_END_DATE"))%>
								</b></td>
								<td title="규격"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
								<td title="원산지"><%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%></td>
								<td title="수량" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,0)%></td>
								<td title="Nego단가" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("BTOA_NEGO_PRICE")),true,0,3)%></td>
								<td title="협력사"><a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("AGENT"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_NAME")))%></a></td>
							</tr>
<% }else{ %>
							<tr align="center" bgcolor="<%=tclass%>">
								<td rowspan="2" class="font1_black1" align="center">
									<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
									<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>">
								</td>
								<td rowspan="2" class="font1_black1" align="center">
									<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>
									<input type="hidden" name="st_buyer" id="st_buyer" value="<%=rowData.get("BUYER") %>">
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
									<input type="hidden" name="st_product_close_flag" id="st_product_close_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")))%>">
									<input type="hidden" name="st_recv_flag" id="st_recv_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("RECV_FLAG")))%>">
									<input type="hidden" name="st_confirm_user_id2"     value="${sessionInfo.userId}">
									<input type="hidden" name="st_buyer2" id="st_buyer2"              value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%>">
	                            	<input type="hidden" name="st_revision2" id="st_revision2"           value="<%=String.valueOf(CommonUtil.nvl(rowData.get("REVISION")))%>">
	                            	<input type="hidden" name="st_btoa_user_id" id="st_btoa_user_id" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_ID")))%>">
	                            	<input type="hidden" name="st_bid_success_quotation_seq" id="st_bid_success_quotation_seq" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("BID_SUCCESS_QUOTATION_SEQ")))%>">
				<%if(p060000123 == true && "Y".equals(rowData.get("MSDS_YN"))){%>
				    	<br>
				    	<a class="hyperLink" href="javascript:doPop('getMsdsView','<%=rowData.get("MSDS_NO")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');"><%=CommonLang.get("HTITLE914") %><!--MSDS--></a>
				<%}%>
				<%if("Y".equals(rowData.get("PRE_GR_FLAG"))){%>
						<br>
						<b>선입고</b>
				<%}%>	                            	
								</td>
				<%if(group_mng_flag.equals("Y")){%>
								<td title="고객사코드"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%></td>
				<%}%>
								<td title="견적번호"><a class="hyperLink b"
									href="javascript:doPop('buyerMpRqDepartmentTotalPop','<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("QUOTATION_NO"))%>', '<%=String.valueOf(rowData.get("REVISION"))%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%></b></a>
								</td>
								<td title="순번"><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%></td>
								<td title="견적의뢰일"><%=rowData.get("BTOA_DATE")%></td>
								<td title="품목명"><%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%></td>
								<td title="제조사"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
								<td title="단위/수량"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%>/<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,0)%></td>
								<td title="견적단가">
								<%
									if(p04402705 == true){ //견적상세 특수로직
								%>
									<a class="hyperLink" href="javascript:doPop('kepQuotDetailInfo','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("REVISION"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>');">
										<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ATOB_UNIT_PRICE")),true,0,3)%>
									</a>
								<%
									} else {
								%>
									<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ATOB_UNIT_PRICE")),true,0,3)%>
								<%
									}
								%>
								</td>

								<td title="협력사"><a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("AGENT"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_NAME")))%></a></td>
								<td title="요청자"><%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_NAME")))%>/<%=String.valueOf(CommonUtil.nvl(rowData.get("CONFIRM_USER_NM")))%></td>
								<td title="첨부/비고">
									<%
                                        if(!rowData.get("IMAGE_KEY").equals("")) {
                                    %> <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img
										name="st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a> <%
                                        }else {
                                    %> <img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0"> <%
                                        }
                                    %>
                                    <%
                                    if(p04402709 == true) {
                                    	
                                    	if(rowData.get("ATOB_REMARK").equals("") && rowData.get("CONFIRM_REMARK").equals("")) {
        	                                %>
        	                                		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
        	                                <%
        	                                        }else {
        	                                %>
        	                                            <a href="javascript:doPop('confirm_remark','<%=CommonUtil.nvl(rowData.get("ATOB_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BTOA_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BUYER"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"), "")%>','<%=CommonUtil.nvl(rowData.get("REVISION"), "")%>','<%=CommonUtil.nvl(rowData.get("CONFIRM_REMARK"), "")%>')"><img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
        	                                <%
        	                                        }
                                    		
                                    	} else {
                                        if(rowData.get("ATOB_REMARK").equals("")) {
	                                %>
	                                		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
	                                <%
	                                        }else {
	                                %>
	                                            <a href="javascript:doPop('remark','<%=CommonUtil.nvl(rowData.get("ATOB_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BTOA_REMARK"), "")%>');"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
	                                <%
	                                        }
                                    	}   
	                                %>
								</td>
						        <%
						        //안전인증서 표기 여부
						        if((p04405701 == true)) {
						        %>
						        	<td title="MSDS">
						        		<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_MSDS_YN")))%>
						        	</td>
						        <%
						        }else{
						        %>
						        	<td rowspan="2" title="MSDS">
						        		<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_MSDS_YN")))%>
						        	</td>
						        <%
						        }
						        %>
							</tr>
							<tr bgcolor="<%=tclass%>" align="center" height="25">
				<%if(group_mng_flag.equals("Y")){%>
								<td title="고객사명"><%=String.valueOf(CommonUtil.nvl(rowData.get("COM_NAME_LOC")))%></td>
				<%}%>
								<td title="진행상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("SOURCING_STATUS")))%></td>
								<td title="품목코드"><input type="hidden" name="li_quotation_no" id="li_quotation_no"
									value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>"> <input type="hidden" name="li_quotation_seq"
									id="li_quotation_seq" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>"> <input type="hidden"
									name="li_revision" id="li_revision" value="<%=String.valueOf(rowData.get("REVISION"))%>"> <input type="hidden" name="li_agent"
									id="li_agent" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>"> <input type="hidden" name="li_open_flag"
									id="li_open_flag" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>"> <a class="hyperLink"
									href="javascript:quotation_print('<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%>','<%=String.valueOf(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_OPEN_FLAG")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("BID_SUCCESS_QUOTATION_SEQ")))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></a>
								</td>
								<td title="회신요청일"><b> <%=String.valueOf(rowData.get("BTOA_END_DATE"))%>
								</b></td>
								<td title="규격"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
								<td title="원산지"><%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%></td>
								<td title="조달일수"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("LEAD_TIME")),true,0,3)%>일</td>
								<td title="Nego단가"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("BTOA_NEGO_PRICE")),true,0,3)%></td>
								<td title="담당자(총괄/견적)"><a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=String.valueOf(rowData.get("MIS_USER_ID"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("MIS_BUYER_NAME")))%></a>/<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=String.valueOf(rowData.get("KEP_USER_ID"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("KEP_USER_NAME")))%></a></td>
								<td title="요청부서"><%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_DEPT")))%></td>
                                <td title="취소/지연">
                                <input type="hidden" name="st_cancle_remark"	 id="st_cancle_remark" value="<%=rowData.get("CANCEL_REMARK")%>">
                                <input type="hidden" name="st_org_cancle_remark"	 id="st_org_cancle_remark" value="<%=rowData.get("CANCEL_REMARK")%>">
                                <input type="hidden" name="st_cancle_remark_code"	 id="st_cancle_remark_code" value="<%=rowData.get("CANCEL_REMARK_CODE")%>">
<%
			if(st_user_group.equals("C") || st_user_group.equals("A") || st_user_group.equals("N")|| st_user_group.equals("Q")) {
				if(!CommonUtil.nvl(rowData.get("CANCEL_REMARK")).equals("") || !CommonUtil.nvl(rowData.get("CANCEL_REMARK_CODE")).equals("")) {
%>
                                  <a href="javascript:doPop('canclereq',<%=j%>)"><img name="cancleImage" id="cancleImage" src="/resources/images/icon.gif"></a>
<%
				}else{
%>
								<a href="javascript:doPop('canclereq',<%=j%>)"><img name="cancleImage" id="cancleImage" src="/resources/images/icon2.gif"></a>					
<%
				}
			}
%>
									<%
                                        if(!CommonUtil.nvl(rowData.get("DELAY_REASON_CODE")).equals("")) {
                                    %>
                                            <a href="javascript:doPop('delayPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("QUOTATION_SEQ")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("DELAY_REASON_CODE")%>');"><img name="delayImage" id="delayImage" src="/resources/images/icon.gif"></a>
                                    <%
                                        }else {
                                    %>
                                            <a href="javascript:doPop('delayPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("QUOTATION_SEQ")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("DELAY_REASON_CODE")%>');"><img name="delayImage" id="delayImage" src="/resources/images/icon2.gif"></a>
                                    <%
                                        }
                                    %>
                                </td>
						        <%
						        //안전인증서 표기 여부
						        if((p04405701 == true)) {
						        %>
						        	<td title="안전인증서상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("SAFETY_FLAG_TEXT")))%></td>
						        <%
						        }
						        %>
							</tr>
							<%} 
                        } 
         
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
						<div class="fl">
							<%
							//엑셀다운로드 기능 통제
							if(p170000001 == false){
							%>
								<span class="btn_04 mr04"> <a href="javascript:ExcelDown()"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
								</span>
							<%
							}
							%>
							<%
							//엑셀 상세다운로드 기능 통제
							if(p170000002 == true){
							%>
								<span class="btn_04 mr04"> <a href="javascript:ExcelDetailDown()"><%=CommonLang.get("HTITLE917") %><!-- 상세 다운로드 --></a>
								</span>
							<%
							}
							%>
						</div>
						<div class="fr">
							<!-- //SLOGIC-BEGIN(P04-4026-06) -->
<%-- 						<!-- 23.08.04 셰플러 그룹내 고객사 같은 견적서 출력을 위해 주석-->	
							<%if(b_com_code.equals("KRSCHA0001")) {%> <!-- 									셰플러안산에만 적용 (운영적용시 주석해제) -->--%>
<%-- 									<span class="btn_03 mr04"> <a href="javascript:printPum()"><%=CommonLang.get("HTITLE619") %><!-- 견적서출력 --></a> --%>
<!-- 									</span> -->
<%-- 							<%}else{%> --%>
									<span class="btn_03 mr04"> <a href="javascript:rqdtList();"><%=CommonLang.get("HTITLE619") %><!-- 견적서출력 --></a>
									</span>
<%-- 							<%}%> --%>
							<!-- //SLOGIC-END -->
							<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>
							<span class="btn_04"> <a href="javascript:deleteRqdt();"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a> 
<%}else{ %>
	<%
		if(st_user_group.equals("C") || st_user_group.equals("A")|| st_user_group.equals("N")|| st_user_group.equals("Q")) {
	%>
	        	<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');"><%=CommonLang.get("HTITLE129") %><!-- 견적취소 --></a>
				</span>
	<%} %>
							<span class="btn_04"> <a href="javascript:cartCheck();"><%=CommonLang.get("HTITLE11") %><!-- 장바구니담기 --></a>
<%} %>
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
				<form name="locationForm" id="locationForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>"> <input type="hidden" name="st_com_code"
						id="st_com_code" value="${sessionInfo.comCode}"> <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

				</form>
			</div>

			<!--내용 종료-->
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp"%>
	</div>
</body>

<script type="text/javascript">
var btnEvent = "";
var gridIndex = 0;
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	
	var st_search_code = $("#st_search_code").val();
	var st_sourcing_status = $("#st_sourcing_status").val();
	var st_quotation_no = $("#st_quotation_no").val();
	var st_btoa_user_dept_name = $("#st_btoa_user_dept_name").val();
	var st_btoa_user_name = $("#st_btoa_user_name").val();
	
	if(document.forms.searchForm.st_checkbox.checked == true){
		if(st_search_code == "" && st_sourcing_status == "" && st_quotation_no == "" && st_search_code == ""&& st_btoa_user_dept_name == ""&& st_btoa_user_name == ""){
			//기간을 무시하고 조회시\n\n검색조건 한가지 이상을 기입해야 조회가 됩니다.
			alert("<%=CommonLang.msg("MSG96")%>");
		return;
		}
		$("#st_all_re").val('Y');
	} else{
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
			//조회기간을 6개월 단위로 조회가 가능합니다.
			alert("<%=CommonLang.msg("MSG494")%>");
			return;
		}
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_buyer.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqQuotaProceState.do").submit();   
}

//기능함수
function doAction(str) {
	st = new Date();
	btnEvent = str
	switch (str) {
	case "search":
		kepSearch(1);
		break;
	case "cancleSubmit": // 취소
		if(setGridData(btnEvent)){
			//견적을 취소 하시겠습니까?
			if(!confirm("<%=CommonLang.msg("MSG360")%>")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList.do","processForm",btnEvent); 
		}	
		break;
	}
}

/**
 * FORM 을 초기화
 */
function reload(){
	
	kepReload("searchForm");
	$('#st_btoa_user_dept_code').val('');
	
	//document.forms.searchForm.reset();
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	$('#st_total_cnt').val('0');
	document.forms.searchForm.st_checkbox.checked = false;
// 	kepSearch(-1);
	jspTableClean("table_list");
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
		//등록신청이 성공적으로 이루어 졌습니다. 
		alert("<%=CommonLang.msg("MSG97")%>");
	<%}else if ("delCheck".equals(gubun_msg)){%>
		//삭제 작업이 성공적으로 이루어 졌습니다. 
		alert("<%=CommonLang.msg("MSG98")%>");
	<%}else if ("cartCheck".equals(gubun_msg)){%>
		alert("<%=CommonLang.msg("MSG99")%> \n\n<%=item_cnt_no_msg%>");
	<%}%> 
	
}	

//팝업함수호출
var popupSel  = "";
function doPop(str,value1, value2, value3, value4, value5, value6, value7) {
	
	switch (str) {
	case "dept": // 요청부서
		var com_code = document.forms.searchForm.st_buyer.value; // 통합관리자인 경우 선택 고객사 or 본인 고객사
		if(com_code == ""){ // 그룹 통합관리자인 경우 전체 선택 시
			com_code = "<%=com_code%>";
		}
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
		break;
	case "buyerMpRqDepartmentTotalPop": // 견적번호
		openSearchPopup("/mprq/showBuyerMpRqDepartmentTotalPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "950,450,no");
		break;
	case "buyerMpRqDepartmentPCOPop": // 견적번호
		popupSel = "quotationReDetailPop";
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "1020,500,no");
		break;
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "SourcingHistoryDt": // 견적단가이력
		openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do", '?st_buyer_name='+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, "900,600,no");
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "canclereq"://취소팝업		
		popupSel = "cancelRemark";
		gridIndex = value1;
		var viewType="";
		var recv_flag = $("input[name=st_recv_flag]").eq(gridIndex).val();
		var org_cancel_remark = $("input[name=st_org_cancle_remark]").eq(gridIndex).val();
		var cancel_remark = $("input[name=st_cancle_remark]").eq(gridIndex).val();
		var cancel_remark_code = $("input[name=st_cancle_remark_code]").eq(gridIndex).val();
		
		if(recv_flag == "GD"){
			if(cancel_remark_code != ""){
				viewType = "kepRfqCancel_READONLY";
				openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType+'&cancel_remark_code='+cancel_remark_code,"500,320,no");
			}else{
				viewType = "READONLY";
				openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
			}
		}else{
			viewType = "R";
			openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
		}
		
		break;
	case "delayPop"://지연사유 팝업		
		if(value5 != ""){
				openSearchPopup('/mpiv/getMasterMpIvQuotationSendDelayReasonPop.jsp.do','?st_buyer='+value1+'&st_quotation_no='+value2+'&st_quotation_seq='+value3+'&st_revision='+value4+'&st_modify=N','450,350,no');
			}else{
				alert("<%=CommonLang.msg("MSG390")%>");
				return;
			}
		break;
	case "remark"://비고
		var viewType="R";
		var title = "ATOB";
		openSearchPopup('/common/remarkPop.do','?st_btoa_remark='+value2+'&st_atob_remark='+value1+'&viewType='+viewType+'&title='+title,'500,310,no');  
		break;
	case "confirm_remark":// 단가합의 비고
		var viewType="R";
		var confirmType="R";
		var title = "ATOB";
		openSearchPopup('/common/confirmRemarkPop.do','?st_btoa_remark='+value2+'&st_atob_remark='+value1+'&viewType='+viewType+'&confirmType='+confirmType+'&title='+title+'&confirm_remark='+value7+'&buyer='+value3+'&quotation_no='+value4+'&quotation_seq='+value5+'&revision='+value6,'600,400,no');  
		break;
	case "getMsdsView":
		if(value1 == ""){
			alert("현재 MSDS 매핑 준비중입니다.");
			return;
		}
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,580,no');
		break;
	case "kepQuotDetailInfo": //견적상세 팝업
		if(isEmpty(value5)) {
        	//견적서가 발행되지 않은 품목입니다.
            alert("<%=CommonLang.msg("MSG111")%>");
            return;
        }
		openSearchPopup("/common/getQuotDetailInfoPop.do", "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4, "430,210,yes");
		break;
	}
}

//콜백함수(파일명은 모두 동일)
   function setPopupReturn(code, text){
		 if (popupSel == "cancelRemark") {
				$("input[name=st_cancle_remark]").eq(gridIndex).val(code);
				if(code ==""){
					$("img[id=cancleImage]").eq(gridIndex).attr("src","/resources/images/icon2.gif");
			 	 }else{
					$("img[id=cancleImage]").eq(gridIndex).attr("src","/resources/images/icon.gif");
			 	 }
		}else{
			$("#st_btoa_user_dept_code").val(code);
			$("#st_btoa_user_dept_name").val(text);			
		}
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
var tFlag = "N";
var btoa_user_chk = "Y";

function getCheckedStatusConfirm() {
    var tot_cnt = $("#display_item_cnt").val();
    var checked_count   = getCheckedRowCount(tot_cnt);
    var bFlag           = true;
    var box = "";

    if(checked_count==0) {
    	//선택된 품목이 없습니다.
        alert("<%=CommonLang.msg("MSG100")%>");
        return false;
    }
    if (tot_cnt < 2) {
    	  box = eval("document.forms.contentForm.checkbox0");
	       if(box.checked==true) {
	    	   if(document.forms.contentForm.st_user_id.value != document.forms.contentForm.st_btoa_user_id.value) {
	               btoa_user_chk = "N";
	           }
	           if(document.forms.contentForm.st_status.value != "합의완료" && document.forms.contentForm.st_status.value != "장바구니"&& document.forms.contentForm.st_status.value != "발주") {
	               bFlag=false;
	           } else {
	        	   if (document.forms.contentForm.st_product_close_flag.value == "T"){
		               bFlag=false;
		               tFlag="T";
	        	   }	        	   
	           }
	       }
    } else {
	   for(var j=0; j<tot_cnt; j++) {
		   box = eval("document.forms.contentForm.checkbox" + j);
	       if(box.checked==true) {
	    	   if(document.forms.contentForm.st_user_id[j].value != document.forms.contentForm.st_btoa_user_id[j].value) {
	               btoa_user_chk = "N";
	           }
	    	   
	           if(document.forms.contentForm.st_status[j].value!="합의완료" && document.forms.contentForm.st_status[j].value!="장바구니"&& document.forms.contentForm.st_status[j].value!="발주") {
	               bFlag=false;
	               break;
	           } else {
	        	   if (document.forms.contentForm.st_product_close_flag[j].value == "T"){
		               bFlag=false;
		               tFlag="T";
		               break;
	        	   }
	           }
	       }
	   }
    }
    return bFlag;
}

/* 장바구니 담기 */
function cartCheck() {
	if(!getCheckedStatusConfirm() && tFlag == "N") {
		//합의완료된 품목들만 장바구니에 담을수 있습니다.
        alert("<%=CommonLang.msg("MSG101")%>");
        return;
    } else if(!getCheckedStatusConfirm() && tFlag == "T") {
    	//인터페이스 품목입니다.
    	alert("<%=CommonLang.msg("MSG102")%>");
    	return;
    } 
	
	if(btoa_user_chk == "N"){
		//본인 요청건만 장바구니담기가 가능합니다.
    	alert("<%=CommonLang.msg("MSG103")%>");
    	return;
    }
	
	var btnEvent = "cartCheck";
	/* 그리드 데이터 셋팅 */
	if(setGridData(btnEvent)){
		//장바구니에 담으시겠습니까?
		if(!confirm("<%=CommonLang.msg("MSG104")%>")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/saveBuyerMpRqQuotaProceState.do","processForm",btnEvent); 	
	}
}

/* 삭제 */
function deleteRqdt() {   

	var btnEvent = "deleteRqdt";
	/* 그리드 데이터 셋팅 */
	if(setGridData(btnEvent)){
		//선택된 품목을 삭제 하시겠습니까?
		if(!confirm("<%=CommonLang.msg("MSG363")%>")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/deleteBuyerMpRqQuotaProceState.do","processForm",btnEvent); 	
	}
}

/* 선택된 그리드 값을 셋팅 */
function setGridData(btnEvent){
	var returnValue = true;
	var tot_cnt  = $("#display_item_cnt").val(); 

	var chkGridValue = {
			keys : ["st_status"] ,
			value0 : ["합의완료", "장바구니"],
			/* 합의완료된 품목들만 장바구니에 담을수 있습니다. */
			msg0 : ["<%=CommonLang.msg("MSG101")%>"]
	};
	if(btnEvent == "deleteRqdt"){
		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var st_status  = document.forms.contentForm.st_status.value;
	            	 if(st_status  !=  "견적의뢰") {
	            		 //견적진행중인 항목입니다. \n\n 항목삭제나 변경은 KeP담당자에게 요청하시기 바랍니다.
	                  alert("<%=CommonLang.msg("MSG105")%>");
	                  return false;
	               }
            }
		} else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
	            	var st_status  = document.forms.contentForm.st_status[k].value;
	            	 if(st_status  !=  "견적의뢰") {
	            		 //번째 항목은 견적진행중인 항목입니다. \n\n 항목삭제나 변경은 KeP담당자에게 요청하시기 바랍니다.
	                  alert(k+1 +"<%=CommonLang.msg("MSG106")%>");
	                  return false;
	               }
  	            }
  	        }
		}
	}else if (btnEvent == "cancleSubmit"){ // 취소
		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var st_cancle_remark  = document.forms.contentForm.st_cancle_remark.value;
	            	var st_recv_flag  = document.forms.contentForm.st_recv_flag.value;
	            	if(st_recv_flag != "NW"){
	            		if(st_recv_flag=="GD"){
	            			//이미 견적취소 처리가 되었습니다.
	            			alert("<%=CommonLang.msg("MSG107")%>");
	            			return false;
	            		}else{
	            			//견적접수 처리가되어 견적취소가 불가능합니다.
	            			alert("<%=CommonLang.msg("MSG108")%>");
	            			return false;
	            		}
	            	}
	  	           if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	        	   //견적취소 사유를 입력하여 주십시요.
	  	              alert("<%=CommonLang.msg("MSG88")%>");
	  	              document.forms.contentForm.st_cancle_remark.focus();
	  	              return false;
	  	           }
            }
		} else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	var st_cancle_remark  = document.forms.contentForm.st_cancle_remark[k].value;
	            	var st_recv_flag  = document.forms.contentForm.st_recv_flag[k].value;
	            	if(st_recv_flag != "NW"){
	            		if(st_recv_flag=="GD"){
	            			//이미 견적취소 처리가 되었습니다.
	            			alert("<%=CommonLang.msg("MSG107")%>");
	            			return false;
	            		}else{
	            			//견적접수 처리가되어 견적취소가 불가능합니다.
	            			alert("<%=CommonLang.msg("MSG108")%>");
	            			return false;
	            		}
	            	}
	  	           if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	        	   //견적취소 사유를 입력하여 주십시요.
	  	        	 alert("<%=CommonLang.msg("MSG88")%>");
	  	              document.forms.contentForm.st_cancle_remark[k].focus();
	  	              return false;
	  	           }
  	            }
  	        }
		}
  	}
	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
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
	//SLOGIC-BEGIN(P04-4026-08)
	if (pMethod == 'cartCheck'){
		var buyer = $("#st_buyer").val();
		//장바구니로 이동하시겠습니까?
		if(confirm("<%=CommonLang.msg("MSG364")%>")) {
// 			if(buyer=="KRKEPB0004" || buyer=="KRKOLO0016") {
// 				location.href = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
// 			}else {
// 				location.href = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";

				$('#locationForm').attr("action", "<%=p060000036%>").submit();  
// 			}
		} else {
			kepSearch($("#curPage").val());
		}
	}else if(pMethod =="deleteRqdt"){
	 	var msg = response.msg;   
	 	if (msg != ""){
	 		alert(msg);
	 		kepSearch($("#curPage").val());
	 	}
	} else if (pMethod=="cancleSubmit") {
		//견적취소 처리가 되었습니다.
		alert("<%=CommonLang.msg("MSG90")%>");
		kepSearch($("#curPage").val());
		return;
	}
	//SLOGIC-END
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod == "deleteRqdt"){
		//삭제 실패하였습니다.
		alert("<%=CommonLang.msg("MSG109")%>");
		return;
	}else{
		//장바구니 담기에 실패하였습니다.
		alert("<%=CommonLang.msg("MSG110")%>");
		return;
	}
} 

//엑셀다운로드
function ExcelDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
<%
	if(!(b_com_code.equals("KRDHIM0001") || b_com_code.equals("KRDHIM0002") || b_com_code.equals("KRDHIM0003") 
			 || b_com_code.equals("KRDHIM0005") || b_com_code.equals("KRDIGU0001") || b_com_code.equals("KRDOOS0024") 
			 || b_com_code.equals("KRDAEW0045") || b_com_code.equals("KRDAEW0046") || b_com_code.equals("KRDAEW0043") 
			 || b_com_code.equals("KRDOOS0020") || b_com_code.equals("KRDAEW0023") || b_com_code.equals("KRDOOS0046")
			 || b_com_code.equals("KRDIGU0001") 
			   )){	
	%>
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
<% } %>
	
	var st_search_code = $("#st_search_code").val();
	var st_sourcing_status = $("#st_sourcing_status").val();
	var st_quotation_no = $("#st_quotation_no").val();
	var st_btoa_user_dept_name = $("#st_btoa_user_dept_name").val();
	var st_btoa_user_name = $("#st_btoa_user_name").val();
	if(document.forms.searchForm.st_checkbox.checked == true){
		if(st_search_code == "" && st_sourcing_status == "" && st_quotation_no == "" && st_search_code == ""&& st_btoa_user_dept_name == ""&& st_btoa_user_name == ""){
			//기간을 무시하고 조회시\n\n검색조건 한가지 이상을 기입해야 조회가 됩니다.
			alert("<%=CommonLang.msg("MSG96")%>");
		return;
		}
		$("#st_all_re").val('Y');
	}
	
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_buyer.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getBuyerExcelDown.do";
	document.forms.searchForm.submit();
}
//엑셀 상세 다운로드
function ExcelDetailDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;

	if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
	
	var st_search_code = $("#st_search_code").val();
	var st_sourcing_status = $("#st_sourcing_status").val();
	var st_quotation_no = $("#st_quotation_no").val();
	var st_btoa_user_dept_name = $("#st_btoa_user_dept_name").val();
	var st_btoa_user_name = $("#st_btoa_user_name").val();
	if(document.forms.searchForm.st_checkbox.checked == true){
		if(st_search_code == "" && st_sourcing_status == "" && st_quotation_no == "" && st_search_code == ""&& st_btoa_user_dept_name == ""&& st_btoa_user_name == ""){
			//기간을 무시하고 조회시\n\n검색조건 한가지 이상을 기입해야 조회가 됩니다.
			alert("<%=CommonLang.msg("MSG96")%>");
		return;
		}
		$("#st_all_re").val('Y');
	}
	
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_buyer.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getBuyerExcelDetailDown.do";
	document.forms.searchForm.submit();
}

//견적제출현황 출력
function rd_onload(){

	var buyer = $("#st_buyer").val();
	var user_id = $("#st_user_id").val();
	var from_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var to_date = $("#st_to_date").val().replace(/[/]/gi,"");
	
	var fileName = "RD_04_B_004_00";
	var param =  "["+buyer+"]["+from_date+"]["+to_date+"]["+user_id+"]";
  	reportOpen(fileName,param);
	return;
	
}

function printPum(){

	var tot_cnt = $("#display_item_cnt").val();
    var checked_count   = getCheckedRowCount(tot_cnt);

    if(checked_count == 0){
    	//선택된 품목이 없습니다
        alert('<%=CommonLang.msg("MSG100")%>');
        return;
    }

    var li_quotation_no = "";
    var li_quotation_seq = "";
    var li_revision = "";
    var li_agent = "";
    var buyer = "";
    if(tot_cnt==1) {
    	var box =  eval("document.forms.contentForm.checkbox0");
		
    	if(box.checked==true) {
    		buyer = document.forms.contentForm.st_buyer2.value;
	        li_quotation_no     = document.forms.contentForm.li_quotation_no.value;
	        li_quotation_seq    = document.forms.contentForm.li_quotation_seq.value + "@@";
	        li_revision         = document.forms.contentForm.li_revision.value + "@@";
	        li_agent            = document.forms.contentForm.li_agent.value + "@@";
    	}
        if(isEmpty(document.forms.contentForm.li_agent.value)) {
        	//견적서가 발행되지 않은 품목입니다.
            alert("<%=CommonLang.msg("MSG111")%>");
            return;
        }

    }else {
        var prev_quotation_no = "";
        var li_quotation_no_tmp = "";
        var li_quotation_seq_tmp = "";
        var li_revision_tmp = "";
        var li_agent_tmp = "";
        var buyerCheck = "Y";
        //중복진행체크
        for(var k=0; k<tot_cnt; k++) {
        	var box2 = eval("document.forms.contentForm.checkbox" + k);
        	if(box2.checked==true) {
        		for(var z=0; z<tot_cnt; z++) {
        			if(document.forms.contentForm.st_buyer2[k].value != document.forms.contentForm.st_buyer2[z].value){
        				buyerCheck= "N";			
        			} 
        		}
        		
        	}
        }
        if(buyerCheck=="N"){
        	//고객사가 다를경우 견적서 출력이 불가능합니다.
            alert("<%=CommonLang.msg("MSG93")%>");
            return;
        }
        for(var j=0; j<tot_cnt; j++) {
            var box = eval("document.forms.contentForm.checkbox" + j);
            li_quotation_no_tmp    = document.forms.contentForm.li_quotation_no[j].value;
	        li_quotation_seq_tmp    = document.forms.contentForm.li_quotation_seq[j].value;
	        li_revision_tmp         = document.forms.contentForm.li_revision[j].value;
	        li_agent_tmp            = document.forms.contentForm.li_agent[j].value;
            
            if(box.checked==true) {
            	buyer = document.forms.contentForm.st_buyer2[j].value;
            	 if(isEmpty(li_agent_tmp)) {
            		 	//견적서가 발행되지 않은 품목입니다.
	                    alert("<%=CommonLang.msg("MSG111")%>");
	                    return;
                }

                if(prev_quotation_no != li_quotation_no_tmp && prev_quotation_no != ""){
                	//견적번호가 같은 품목들을 선택 하십시오
                    alert('<%=CommonLang.msg("MSG112")%>');
                    return;
                }else{
                    prev_quotation_no = li_quotation_no_tmp;
                }

                li_quotation_no    = li_quotation_no_tmp;
    	        li_quotation_seq    = li_quotation_seq + li_quotation_seq_tmp + "@@";
    	        li_revision         = li_revision + li_revision_tmp + "@@";
    	        li_agent            = li_agent + li_agent_tmp + "@@";
            }
        }
    }

    
    var fileName = "RD_04_B_005_00";
    var param =  "["+buyer+"]["+li_quotation_no+"]["+li_quotation_seq+"]["+li_revision+"]["+li_agent+"]";

    reportOpen(fileName,param);
	return;
    
}
// 품목코드 클릭시 출력물 연결
function quotation_print(buyer, quotation_no, quotation_seq, revision, agent,open_flag, bid_success_quotation_seq) {
	
	if(isEmpty(agent)) {
		//견적서가 발행되지 않은 품목입니다.
        alert("<%=CommonLang.msg("MSG111")%>");
		return;
	}

	open_flag = "N";
	var fileName = "<%=reportid%>";
	var type = "<%=reporttype%>";
	var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+open_flag+"]";
	if (type == "A"){
		param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+open_flag+"]";
	}
  	reportOpen(fileName,param);
  	
  	param = encodeURI(param);
  	
	//셰플러코리아만 견적서 상세 출력.
	if(buyer =="KRFAGB0003" || buyer == "KRFAGB0001"||buyer =="KRFAGB0002" || buyer == "KRSCHA0001" || buyer == "KRSCHA0013"){
		var url = "/coco/showReportViewer.do";
		window.open(url + "" + "?fileName=RD_04_M_004_11&param="+param, "","width=770,height=800,resizable=YES");	
	}
// 	else if(buyer =="KRFAGB0002" || buyer == "KRSCHA0001"){ // 셰플러전주공장 선정업체 견적만 출력
// 		var url = "/coco/showReportViewer.do";
// 		param =  "["+buyer+"]["+quotation_no+"]["+bid_success_quotation_seq+"]["+revision+"][KRKORE0001][Y][Y]";
// 		param = encodeURI(param);
// 		window.open(url + "" + "?fileName=RD_04_M_004_04&param="+param, "","width=770,height=800,resizable=YES");
// 	}
	
	return;
}
function rqdtList(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count   = getCheckedRowCount(tot_cnt);

	    if(checked_count == 0){
	    	//선택된 품목이 없습니다
	        alert('<%=CommonLang.msg("MSG100")%>');
	        return;
	    }
		if(checked_count > 1){
	        alert('<%=CommonLang.msg("MSG497")%>');
	        return;
		}
	    if(tot_cnt==1) {
	    	var box =  eval("document.forms.contentForm.checkbox");
			
	    	if(box.checked==true) {
	    		var st_buyer     = document.forms.contentForm.st_buyer.value;
		        var li_quotation_no     = document.forms.contentForm.li_quotation_no.value;
		        var li_quotation_seq    = document.forms.contentForm.li_quotation_seq.value;
		        var li_revision         = document.forms.contentForm.li_revision.value;
		        var li_agent            = document.forms.contentForm.li_agent.value;
		        var li_open_flag            = document.forms.contentForm.li_open_flag.value;
		        var st_bid_success_quotation_seq            = document.forms.contentForm.st_bid_success_quotation_seq.value;
		        quotation_print(st_buyer,li_quotation_no,li_quotation_seq,li_revision,li_agent,li_open_flag,st_bid_success_quotation_seq);
	    	}
	    }else {
	        for(var j=0; j<=tot_cnt; j++) {
	            var box = eval("document.forms.contentForm.checkbox"+j);
	            var st_buyer     = document.forms.contentForm.st_buyer[j].value;
	            var li_quotation_no     = document.forms.contentForm.li_quotation_no[j].value;
		        var li_quotation_seq    = document.forms.contentForm.li_quotation_seq[j].value;
		        var li_revision         = document.forms.contentForm.li_revision[j].value;
		        var li_agent            = document.forms.contentForm.li_agent[j].value;
		        var li_open_flag            = document.forms.contentForm.li_open_flag[j].value;
		        var st_bid_success_quotation_seq   = document.forms.contentForm.st_bid_success_quotation_seq[j].value;
	            if(box.checked==true) {
	            	 if(isEmpty(li_agent)) {
	            		//견적서가 발행되지 않은 품목입니다.
	                     alert("<%=CommonLang.msg("MSG111")%>");
		                    return;
	                }
	            	 quotation_print(st_buyer,li_quotation_no,li_quotation_seq,li_revision,li_agent,li_open_flag,st_bid_success_quotation_seq);
	            	 return;
	            }
	        }
	    }

}
function souList(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count   = getCheckedRowCount(tot_cnt);

	    if(checked_count == 0){
	    	//선택된 품목이 없습니다
	        alert('<%=CommonLang.msg("MSG100")%>');
	        return;
	    }

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
            	//견적서가 발행되지 않은 품목입니다.
                alert("<%=CommonLang.msg("MSG111")%>");
                return;

            }
            query = li_quotation_no + "@@" + li_quotation_seq + "@@" + li_revision  + "@@" + li_agent + "^||^";

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

	            		//견적서가 발행되지 않은 품목입니다.
	                     alert("<%=CommonLang.msg("MSG111")%>");
		                    return;

	                }

	                if(prev_quotation_no != li_quotation_no && prev_quotation_no != ""){
	                	//견적번호가 같은 품목들을 선택 하십시오
	                    alert('<%=CommonLang.msg("MSG112")%>');
	                    return;
	                }else{
	                    prev_quotation_no = li_quotation_no;
	                }

		                query += li_quotation_no + "@@" + li_quotation_seq + "@@" + li_revision  + "@@" + li_agent ;
		                query += "^||^";
	            	
	            }
	        }
	        
	    }

	    var buyer = "${sessionInfo.comCode}";
	    var open_flag = "N";

	    var fileName = "RD_04_B_005_01";
	    var param =  "["+buyer+"]["+query+"]";
	    
	    reportOpen(fileName,param);
		return;

}
function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $("#display_item_cnt").val();
// 	var check_status = $("#check_status").html();
	
	var box = eval("document.forms.contentForm.check_status");
    
	if(box.checked == true) {
		if (tot_cnt < 2) {
		   var box = eval("document.contentForm.checkbox0");
	       if(box.checked == false) box.checked = true;
		} else {
			for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == false) box.checked = true;
		       
		   }
		}
	}else{
		if (tot_cnt < 2) {
	       var box = eval("document.contentForm.checkbox0");
	       if(box.checked == true) box.checked = false;
		} else {
		   for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == true) box.checked = false;
		   }
		}
	}
}
</script>
</html>
