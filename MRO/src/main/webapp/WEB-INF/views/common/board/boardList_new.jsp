<%--
**********************************************
* 메뉴 : 관리자>게시판>게시판
* 화면 : 게시판
* 기능 : 게시판 관리
* 프로그램 ID : 
* 담당자 : 원지성  
* 착수일 : 2025-12-30
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!doctype html>
<html>
<head> 
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _bbsList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과

	String total_cnt =  CommonUtil.nvlObj((List<Map<String,String>>) _bbsList ,"0");  // 조회된결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"50");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	// 승인 권한 여부
	Boolean hasApprovalAuthAttr = (Boolean) request.getAttribute("hasApprovalAuth");
	boolean hasApprovalAuth = (hasApprovalAuthAttr != null) ? hasApprovalAuthAttr : false;

	String sbtype = CommonUtil.nvl((String) request.getParameter("sbtype"),"ALL");  //   (조회조건)

	// 날짜 기본값 설정 (12개월 전 ~ 오늘)
	String defaultEndDate = DateTimeUtil.getFormatString("yyyy/MM/dd");
	String defaultStartDate = defaultEndDate;
	try {
		defaultStartDate = DateTimeUtil.addMonths(defaultEndDate, -12, "yyyy/MM/dd");
	} catch (Exception e) {
		// 예외 발생 시 오늘 날짜 사용
	}

	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"), defaultStartDate);  //   (조회조건) 시작일
	String endDate = CommonUtil.nvl((String) request.getParameter("endDate"), defaultEndDate);  //   (조회조건) 종료일
	String st_open_flag = CommonUtil.nvl((String) request.getParameter("st_open_flag"),"ALL");  //   (조회조건)

	// 추가 조회조건
	String dateType = CommonUtil.nvl((String) request.getParameter("dateType"),"POST");  // 기간유형 (기본: 게시기간)
	String exposeTarget = CommonUtil.nvl((String) request.getParameter("exposeTarget"),"ALL");  // 노출대상
	String noticeType = CommonUtil.nvl((String) request.getParameter("noticeType"),"ALL");  // 공지유형
	String targetCustomer = CommonUtil.nvl((String) request.getParameter("targetCustomer"),"");  // 대상고객사
	String postStatus = CommonUtil.nvl((String) request.getParameter("postStatus"),"ALL");  // 게시상태
	String approvalStatus = CommonUtil.nvl((String) request.getParameter("approvalStatus"), hasApprovalAuth ? "N" : "ALL");  // 승인상태
	String titleSearch = CommonUtil.nvl((String) request.getParameter("titleSearch"),"");  // 제목검색
	String regUser = CommonUtil.nvl((String) request.getParameter("regUser"),"");  // 등록자
	String importantOnly = CommonUtil.nvl((String) request.getParameter("importantOnly"),"");  // 중요건만조회
%> 
<body onload="kep_onload_view()" style="overflow: hidden;">  

<!--내용 시작-->	
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<h3>게시판</h3>
        	<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span>
		    <span class="btn_reset"><a href="javascript:kepReload();">초기화</a></span>
		    <span class="btn_search"><a href="javascript:kepWriteForm();">등록</a></span>
		</div>
		<!--조회영역-->
       	<form id="searchCondition"  name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="BID" id="BID" value="" />
			<input type="hidden" name="BTYPE" id="BTYPE" value="NT" />
			<input type="hidden" name="sbtype" id="sbtype" value="<%=sbtype %>" />

            	<table class="cont_t_list01" style="table-layout:fixed; width:100%;">
					<caption>게시판</caption>
					<colgroup>
						<col style="width:9%;" />
						<col style="width:24%;" />
						<col style="width:9%;" />
						<col style="width:24%;" />
						<col style="width:9%;" />
						<col style="width:24%;" />
					</colgroup>
					<tbody>
						<!-- 1행: 기간 조회, 노출 대상, 공지 유형 -->
						<tr>
							<th>
								<select id="dateType" name="dateType" style="width:100%;height: 25px;">
									<option <%=(dateType.equals("POST") ? "selected" : "")%> value="POST">게시 기간</option>
									<option <%=(dateType.equals("REG") ? "selected" : "")%> value="REG">등록일</option>
								</select>
							</th>
							<td style="white-space:nowrap; padding-left: 50px; padding-right:50px;">
								<input type="text" id="startDate" class="input_type_text" name="startDate" value="<%=startDate %>" style="width:100px; text-align: center;">
								<span style="padding:0 3px;">~</span>
								<input type="text" id="endDate" class="input_type_text" name="endDate" value="<%=endDate %>" style="width:100px; text-align: center;">
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">노출 대상</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<select id="exposeTarget" name="exposeTarget" style="width:100%;">
									<option <%=(exposeTarget.equals("ALL") ? "selected" : "")%> value="ALL">전체</option>
									<option <%=(exposeTarget.equals("BUY") ? "selected" : "")%> value="BUY">고객사</option>
									<option <%=(exposeTarget.equals("SEL") ? "selected" : "")%> value="SEL">협력사</option>
								</select>
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">공지 유형</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<select id="noticeType" name="noticeType" style="width:100%;">
									<option <%=(noticeType.equals("ALL") ? "selected" : "")%> value="ALL">전체</option>
									<option <%=(noticeType.equals("CMN") ? "selected" : "")%> value="CMN">공통</option>
									<option <%=(noticeType.equals("CST") ? "selected" : "")%> value="CST">고객사별</option>
								</select>
							</td>
						</tr>
						<!-- 2행: 대상 고객사, 게시 상태, 승인 상태 -->
						<tr>
							<th>대상 고객사</th>
							<td style="white-space:nowrap; padding-left:50px;padding-right: 100px;">
								<input type="text" id="targetCustomer" name="targetCustomer" class="input_type_text" value="<%=targetCustomer %>" style="width:98%;" placeholder="고객사명 입력">
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">게시 상태</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<select id="postStatus" name="postStatus" style="width:100%;">
									<option <%=(postStatus.equals("ALL") ? "selected" : "")%> value="ALL">전체</option>
									<option <%=(postStatus.equals("SCH") ? "selected" : "")%> value="SCH">예정</option>
									<option <%=(postStatus.equals("ING") ? "selected" : "")%> value="ING">게시중</option>
									<option <%=(postStatus.equals("END") ? "selected" : "")%> value="END">종료</option>
								</select>
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">승인 상태</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<select id="approvalStatus" name="approvalStatus" style="width:100%;">
									<option <%=(approvalStatus.equals("ALL") ? "selected" : "")%> value="ALL">전체</option>
									<option <%=(approvalStatus.equals("N") ? "selected" : "")%> value="N">대기</option>
									<option <%=(approvalStatus.equals("Y") ? "selected" : "")%> value="Y">완료</option>
								</select>
							</td>
						</tr>
						<!-- 3행: 제목 검색, 등록자, 중요 여부 -->
						<tr>
							<th>제목 검색</th>
							<td style="white-space:nowrap; padding-left:50px; padding-right: 100px;">
								<input type="text" id="titleSearch" name="titleSearch" class="input_type_text" value="<%=titleSearch %>" style="width:98%;" placeholder="제목 입력">
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">등록자</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<input type="text" id="regUser" name="regUser" class="input_type_text" value="<%=regUser %>" style="width:98%;" placeholder="등록자 입력">
							</td>
							<th style="white-space:nowrap; padding-left: 50px;">중요 여부</th>
							<td style="white-space:nowrap; padding-right: 100px;">
								<label style="cursor:pointer;">
									<input type="checkbox" id="importantOnly" name="importantOnly" value="Y" <%=(importantOnly.equals("Y") ? "checked" : "")%>>
									중요 건만 조회
								</label>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="onepagerow" class="hidden">정렬개수선택</label>
					<select id="onepagerow" name="onepagerow" style="width: 70px;" onchange="kepSearch(1);">
					<option value="20" <%=(onepagerow.equals("20") ? "selected" : "")%>>20건</option>
					<option value="50" <%=(onepagerow.equals("50") ? "selected" : "")%>>50건</option>
					<option value="100" <%=(onepagerow.equals("100") ? "selected" : "")%>>100건</option>
					<option value="200" <%=(onepagerow.equals("200") ? "selected" : "")%>>200건</option>
					<option value="500" <%=(onepagerow.equals("500") ? "selected" : "")%>>500건</option>
				</select>
			</span>
			<br>
		</form>
            <div style="max-height: calc(100vh - 200px); overflow-y: auto;">
				<fieldset>
					<legend>게시판 </legend>
					<form name = "contentForm"  id="contentForm" method = "post">
					<table id="table_list" class="cont_t_list03" style="border-top:none !important;">
					<caption>게시판 </caption>
                    <colgroup>
                        <col width="6%" />
                        <col width="5%" />
                        <col width="20%" />
                        <col width="6%" />
                        <col width="10%" />
                        <col width="6%" />
                        <col width="6%" />
                        <col width="14%" />
                        <col width="5%" />
                        <col width="8%" />
                        <col width="8%" />
                    </colgroup>
                    <thead style="position: sticky; top: 0; z-index: 1;">
                        <tr>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">노출대상</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">중요</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">제 목</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">공지유형</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">대상고객사</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">승인상태</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">게시상태</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">게시기간</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">노출수</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">등록자</th>
                            <th scope="col" style="box-shadow: inset 0 2px 0 #6a6a6a;">등록일</th>
                        </tr>
						</thead>
						<tbody>
<%
if (_bbsList == null || _bbsList.size() == 0){
%>
                   <tr bgcolor="#FFFFFF">
                        <td colspan="11" align="center" height = "50">
                        <span>조회된 데이타가 없습니다.</span>
                        </td>
                    </tr>
<%
     }else{
for (int j=0; j<_bbsList.size(); j++) {
	Map<String,String> rowData = _bbsList.get(j);
	String importantFlag = CommonUtil.nvl(rowData.get("IMPORTANT_FLAG"));
	String allCustomerFlag = CommonUtil.nvl(rowData.get("ALL_CUSTOMER_FLAG"));
%>
						<tr>
		                       <td><%=CommonUtil.nvl(rowData.get("EXPOSE_TARGET_NM"))%></td>
		                       <td><%="Y".equals(importantFlag) ? "<img src='/resources/images/s_img_circle.gif' alt='중요' title='중요 게시물' width='10' height='10' style='vertical-align:middle;'>" : ""%></td>
		                       <td class="left"><a href="javascript:kepEditForm('<%=CommonUtil.bnvl(rowData.get("BID"))%>','<%=CommonUtil.bnvl(rowData.get("BTYPE"))%>')" style="color:#0066cc; text-decoration:none; cursor:pointer;"><%=CommonUtil.nvl(rowData.get("SUBJECT"))%></a></td>
		                       <td><%=CommonUtil.nvl(rowData.get("NOTICE_TYPE_NM"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("TARGET_CUSTOMER_NM"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("OPEN_FLAG_NM"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("PUBLISHING_STATUS_NM"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("POST_PERIOD"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("EXPOSE_CNT"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("REG_USER_NAME"))%></td>
		                       <td><%=CommonUtil.nvl(rowData.get("REG_DATE"))%></td>
						</tr>

<%
}
%>
<%
}
%>		
			</tbody>
		</table>					
</form>
	</fieldset>
        </div>
<!--페이징-->
<p id="paging" class="paging">
    <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>
    <span class="cl">[ 총 <%=total_cnt %> 건 ]</span>
</p>
 
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	 
 
 
</body>
<script type="text/javascript">
 
function kep_onload_view(){

	kepNoSetCalender("startDate",""); // 시작일 달력세팅
	kepNoSetCalender("endDate","");   // 종료일 달력세팅

}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	$("#curPage").val(curPage);
	$('#searchCondition').attr("action", "/notice/noticeList.do").submit();
}

/**
 * FORM 을 초기화
 */
function kepReload(){
	// 기존 필드 초기화
	$("#sbtype").val("ALL");
	$("#st_open_flag").val("ALL");

	// 신규 필드 초기화
	$("#dateType").val("POST");
	$("#exposeTarget").val("ALL");
	$("#noticeType").val("ALL");
	$("#targetCustomer").val("");
	$("#postStatus").val("ALL");
	$("#approvalStatus").val(<%=hasApprovalAuth%> ? "N" : "ALL");
	$("#titleSearch").val("");
	$("#regUser").val("");
	$("#importantOnly").prop("checked", false);

	// 달력 초기화 (1년 전 ~ 오늘)
	kepNoSetCalender("startDate","Y");
	kepNoSetCalender("endDate","Y");

	jspTableClean("table_list","11");
} 

/**
 * 등록폼이동
 */
function kepWriteForm(){
	$('#searchCondition').attr("action", "/notice/noticeWriteForm.do").submit();
}
/**
 * 수정폼이동
 */
function kepEditForm(bid,btype){
	$("#BID").val(bid);
	$("#BTYPE").val(btype);
	$('#searchCondition').attr("action", "/notice/noticeDetail.do").submit();
}
</script>
</html>
