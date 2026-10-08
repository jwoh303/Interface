<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 진행현황 (FB) 상세정보 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_800_15
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-16
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : null;
%>

<script type="text/javascript">
//팝업함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "req_attach"://파일 첨부
			popupSel = "fileUpload";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key1").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부
			break;
		
		case "ds_attach"://파일 첨부
			popupSel = "fileUpload1";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key2").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부 
			break;
			
		case "feedback_attach"://파일 첨부
			popupSel = "fileUpload2";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key3").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부 
			break;
	}
}
</script> 
<body onload="">
	 <form name="masterMpVoVocProgressStateFBPop" id="masterMpVoVocProgressStateFBPop" method="post" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">VOC 진행현황</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<%
if(_dataList == null || _dataList.size() <= 0){
%>
			<table  class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
				<caption>VOC 진행현황</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="30%" />
				</colgroup>
				<tbody>
		    	<tr>
					<td colspan="4" class="center"><font color="blue"><b>조회 된 데이터가 없습니다.</b></font></td>
				</tr>
		        </tbody>
		   </table>
<%	
}else{
%>
			<table  class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
				<caption>VOC 진행현황</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="30%" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">접수번호</th>
					<td colspan="3"><font color="blue"><b><%=CommonUtil.nvl(rowData.get("VC_NO"))%></b></font></td>
				</tr>
		    	<tr> 
		    		<th scope="row">고객사</th>
					<td><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("MRO_AREA_TEXT"))%></td>
		    		<th scope="row">요청자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("REQ_USER_TEL"))%>)</td>
				</tr>
				<tr>
					<th scope="row">접수자</th>
					<td><%=CommonUtil.nvl(rowData.get("CD_USER_NAME"))%></td>
					<th scope="row">처리자</th>
					<td><%=CommonUtil.nvl(rowData.get("DS_USER_NAME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">발주번호</th>
					<td><%=CommonUtil.nvl(rowData.get("PO_NO"))%></td>
					<th scope="row">접수일자</th>
					<td><%=CommonUtil.nvl(rowData.get("CD_DATE"))%> <%=CommonUtil.nvl(rowData.get("CD_TIME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">품목코드</th>
					<td><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
					<th scope="row">요청일자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_DATE"))%> <%=CommonUtil.nvl(rowData.get("REQ_TIME"))%></td>
				  </tr>
				  <tr>
					<th scope="row">처리일자</th>
					<td><%=CommonUtil.nvl(rowData.get("DF_DATE"))%></td>
					<th scope="row">진행상태</th>
					<td><%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%></td>
				  </tr>
				  <tr>
					<th scope="row">VOC 유형</th>
					<td scope="row" colspan="3"><%=CommonUtil.nvl(rowData.get("CLAIM_MASTER"))%> > <%=CommonUtil.nvl(rowData.get("CLAIM_TEXT"))%></td>
				  </tr>
		        </tbody>
		   </table> 
			<table  class="cont_t_list06 mb15" style="width:100%;">
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="30%" />
				</colgroup>
				<tbody>
		    	<tr> 
		    		<th scope="row">SRM연계 협력사귀책</th>
					<td colspan="3"><%=CommonUtil.nvl(rowData.get("IMPUTE_TEXT"))%></td>
				</tr>
		    	<tr> 
		    		<th scope="row">업체지정</th>
					<td><%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%></td>
		    		<th scope="row">클레임등급</th>
					<td><%=CommonUtil.nvl(rowData.get("CLAIM_GRADE"))%></td>
				</tr>
				<tr>
					<th scope="row">요청 첨부파일</th>
					<td colspan="3">
						<input type="hidden" id="st_image_key1" name="st_image_key1" value="<%=CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY"))%>" />
				<%
					if(!CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY")).equals("")) {
				%>
						<a class="hyperLink" href="javascript:doPop('req_attach', 'R')">
							<img name="st_req_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
						</a>
				<%
					} else {
				%>
						<img name="st_req_image_key_img" id="st_req_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
				<%
					}
				%>
					</td>
				</tr>
				<tr>
					<th scope="row">요청사항</th>
					<td colspan="3" style="height:100px;">
						<textarea rows="6" cols="70" name="st_req_remark" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("REQ_REMARK"))%></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">처리자 첨부파일</th>
					<td colspan="3">
						<input type="hidden" id="st_image_key2" name="st_image_key2" value="<%=CommonUtil.nvl(rowData.get("DS_IMAGE_KEY"))%>" />
				<%
					if(!CommonUtil.nvl(rowData.get("DS_IMAGE_KEY")).equals("")) {
				%>
						<a class="hyperLink" href="javascript:doPop('ds_attach', 'R')">
							<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
						</a>
				<%
					} else {
				%>
						<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
				<%
					}
				%>
					</td>
				</tr>
				<tr>
					<th scope="row">처리자 진행내역</th>
					<td colspan="3" style="height:100px;">
						<textarea rows="6" cols="70" name="st_df_remark_a" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DS_REMARK_A"))%></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">회신용 첨부파일</th>
					<td colspan="3">
						<input type="hidden" id="st_image_key3" name="st_image_key3" value="<%=CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY"))%>" />
				<%
					if(!CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY")).equals("")) {
				%>
						<a class="hyperLink" href="javascript:doPop('feedback_attach', 'R')">
							<img name="st_feedback_image_key_img" id="st_feedback_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
						</a>
				<%
					} else {
				%>
						<img name="st_feedback_image_key_img" id="st_feedback_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
				<%
					}
				%>
					</td>
				</tr>
				<tr>
					<th scope="row">고객사 회신내용</th>
					<td colspan="3" style="height:100px;">
						<textarea rows="6" cols="70" name="st_df_remark" style="text-align:left;width:100%;" readonly ><%=CommonUtil.nvl(rowData.get("DF_REMARK"))%></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">고객사 메일전송</th>
					<td colspan="3">
						<%=CommonUtil.nvl(rowData.get("MAIL_SEND_FLAG"))%>
					</td>
				</tr>
			</tbody>
		</table> 
<% } %>
	</div>
</div>         
</form> 
</body>
</html>
