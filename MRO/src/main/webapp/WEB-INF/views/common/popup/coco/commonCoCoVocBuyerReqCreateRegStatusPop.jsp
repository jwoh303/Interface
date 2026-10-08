<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 결과
* 기능 : 
* 프로그램 ID :  
* 담당자 : CEJ ( 설계 : 공통 )
* 착수일 : 2014-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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
<%@ include file="../../../common/include/head_pop.jspf"%>
</head>
<%
Map<String,String> rowData = null;
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
if (_gridList != null){
	rowData = _gridList.get(0);
}
%>

<script type="text/javascript">
function kep_onload_view() {
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "reqFileUpload": // 요청첨부
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_req_image_key").val()+"&TYPE=VOC&viewType=R", "500,430,no");
			break;
		case "feedbackFileUpload": // 피드백첨부
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_feedback_image_key").val()+"&TYPE=VOC&viewType=R", "500,430,no");
			break;
	}
}
</script>
<body onload="kep_onload_view()">
<form name="commonCoCoVocBuyerReqCreateRegStatusPop" id="commonCoCoVocBuyerReqCreateRegStatusPop" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">
        		<%=CommonLang.get("HTITLE739") %><!-- 고객센터 -->
        	</h1>
            <p class="popClose">
            	<a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
            </p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="contArea">
        		<table class="cont_t_list06" style="width:100%">
        			<caption>고객센터</caption>
					<colgroup>
						<col width="12%" />
						<col width="40%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					
					<tbody>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE604") %><!-- 고객사 -->
							</th>
							<td class="left">
								<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
							</td>
							<th scope="col">
								<%=CommonLang.get("HTITLE801") %><!-- 접수번호 -->
							</th>
							<td class="left">
								<%=CommonUtil.nvl(rowData.get("VC_NO"))%>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE501") %><!-- VOC 유형 -->
							</th>
							<td class="left">
							<%if("".equals(CommonUtil.nvl(rowData.get("CLAIM_TEXT")))){%>
	            				<%=rowData.get("CLAIM_MASTER")%>
	          				<%}else{%>
	          					<%=rowData.get("CLAIM_MASTER")%>(<%=CommonUtil.nvl(rowData.get("CLAIM_TEXT"))%>)
	          				<%}%>
							</td>
							<th scope="col">
								<%=CommonLang.get("HTITLE650") %><!-- 요청일자 -->
							</th>
							<td class="left">
								<%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATE"))%>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE135") %><!-- 요청부서 -->
							</th>
							<td class="left">
								<%=CommonUtil.nvl(rowData.get("USER_DEPT"))%>
							</td>
							<th scope="col">
								<%=CommonLang.get("HTITLE565") %><!-- 품명 -->
							</th>
							<td class="left">
								<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE606") %><!-- 진행상태 -->
							</th>
							<td class="left">
								<%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%>
							</td> 	
							<th scope="col">
								<%=CommonLang.get("HTITLE802") %><!-- 처리일자 -->
							</th>
							<td class="left">
								<%=CommonUtil.formatStrinigDate(rowData.get("DF_DATE"))%>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE509") %><!-- 요청내역 -->
							</th>
							<td class="left" colspan="3">
								<textarea name="st_req_remark" rows="8" style="padding:3px;width:100%;border-width:0px;color:#fa7c0d;" readonly id="remark"><%=CommonUtil.nvl(rowData.get("REQ_REMARK"))%></textarea>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE509") %><!-- 요청내역 --><%=CommonLang.get("HTITLE166") %><!-- 첨부 -->
							</th>
							<td class="left" colspan="3">
								<input type="hidden" id="st_req_image_key" name="st_req_image_key" value="<%=CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY"))%>" />
						<%
							if(!CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY")).equals("")) {
						%>
								
								<a href="javascript:doPop('reqFileUpload');"><img src="/resources/images/disk_on.gif" id="st_req_image_key_img" name="st_req_image_key_img" border="0" style="vertical-align: text-bottom;"></a>
						<%
							} else {
						%>
								<img src="/resources/images/disk_off.gif" id="st_req_image_key_img" name="st_req_image_key_img" border="0" style="vertical-align: text-bottom;">
						<%
							}
						%>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE812") %><!-- 처리내역 -->
							</th>
							<td class="left" colspan="3">
								<textarea name="st_req_remark" rows="8" style="padding:3px;width:100%;border-width:0px;" readonly id="remark"><%=CommonUtil.nvl(rowData.get("DF_REMARK"))%></textarea>
							</td>
						</tr>
						<tr>
							<th scope="col">
								<%=CommonLang.get("HTITLE812") %><!-- 처리내역 --><%=CommonLang.get("HTITLE166") %><!-- 첨부 -->
							</th>
							<td class="left" colspan="3">
								<input type="hidden" id="st_feedback_image_key" name="st_feedback_image_key" value="<%=CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY"))%>" />
								
						<%
							if(!CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY")).equals("")) {
						%>
								
								<a href="javascript:doPop('feedbackFileUpload');"><img src="/resources/images/disk_on.gif" id="st_feedback_image_key_img" name="st_feedback_image_key_img" border="0" style="vertical-align: text-bottom;"></a>
						<%
							} else {
						%>
								<img src="/resources/images/disk_off.gif" id="st_feedback_image_key_img" name="st_feedback_image_key_img" border="0" style="vertical-align: text-bottom;">
						<%
							}
						%>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>
</body>
</html>