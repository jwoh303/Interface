<%--
**********************************************
* 메뉴 : 
* 화면 : S/R 상세정보 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_700_08
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
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

String sessionUserId = _sessionInfo.getUserId();

String st_sr_user_id = CommonUtil.nvl((String) request.getParameter("st_sr_user_id"), "");
String st_sr_no = CommonUtil.nvl((String) request.getParameter("st_sr_no"), "");

%>

<script type="text/javascript">
var g_chk_pass = "Y";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_rub_type','getSrsysTypeList','SR03','4','','');
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		
		case 	"fileUploadReq": //요청파일 첨부보기
			var st_req_image_key = $("#st_req_image_key").val();
			if(st_req_image_key == ""){
				alert("첨부된 파일이 없습니다.");
			}else{
				var viewType="R";
				openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_req_image_key").val()+"&TYPE=SR&viewType="+viewType, "500,430,no");
			}
			break;
			
		case 	"fileUploadFf": //처리파일 첨부보기
			var st_ff_image_key = $("#st_ff_image_key").val();
			if(st_ff_image_key == ""){
				alert("첨부된 파일이 없습니다.");
			}else{
				var viewType="R";
				openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_ff_image_key").val()+"&TYPE=SR&viewType"+viewType, "500,430,no");
			}
			break;
	}
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "complete":	 // 완료
			if(confirm("완료 처리하시겠습니까?")){
				$("#st_recv_flag").val("GG");
				kepAjaxPopFormCall("/mdsr/saveMasterMdSrSrDetailPop.do","masterMdSrSrDetailPop","complete");
			}
			
			break;
		
		case "cancel":	//취소 
			if(confirm("취소 하시겠습니까?")){
				$("#st_recv_flag").val("GS");
				kepAjaxPopFormCall("/mdsr/saveMasterMdSrSrDetailPop.do","masterMdSrSrDetailPop","cancel");
			}
			
			break;
		case "excelDown":	//엑셀다운로드 
			var st_chk_pass_yn = document.forms.masterMdSrSrDetailPop.st_chk_pass_yn.value;
			if(st_chk_pass_yn == "N"){
				alert("결재일 기준 3일 이후는 다운로드가 불가능 합니다. ");
				return;
			}
			if(g_chk_pass  == "N"){
				alert("지금 다운로드 중이니 잠시만 기다려 주세요.");
				return;
			}
			if(confirm("엑셀다운로드 하시겠습니까?")){
				g_chk_pass = "N";
				var st_req_data_type = document.forms.masterMdSrSrDetailPop.st_req_data_type.value;
				if(st_req_data_type == "PO"||st_req_data_type == "GR"){
					document.forms.masterMdSrSrDetailPop.action = "/mdsr/excelMasterMdsrPoGrList.do";
					document.forms.masterMdSrSrDetailPop.submit();					
				}else if(st_req_data_type == "AR"){
					document.forms.masterMdSrSrDetailPop.action = "/mdsr/excelMasterMdsrArList.do";
					document.forms.masterMdSrSrDetailPop.submit();					
				}else if(st_req_data_type == "RE"){
					document.forms.masterMdSrSrDetailPop.action = "/mdsr/excelMasterMdsrRerList.do";
					document.forms.masterMdSrSrDetailPop.submit();					
				}

			}
			
			break;			
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "complete") {
		if (sMsg == "OK") {
			alert("정상적으로 완료 처리 되었습니다.");
		} else {
			alert("처리 하던중 오류가 발생하였습니다.");
		}
	} else if (pMethod == "cancel") {
		if (sMsg == "OK") {
			alert("정상적으로 취소 처리 되었습니다.");
		} else {
			alert("처리 하던중 오류가 발생하였습니다.");
		}
	}
	
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

/**
 * 첨부보기 팝업창 닫기버튼시 필요한 콜백함수(없으면 script에러 발생함으로 추가.)
 */
function setPopupReturn(value1, value2){
	
}

 </script> 
<body onload="kep_onload_view();">
	 <form name="masterMdSrSrDetailPop" id="masterMdSrSrDetailPop" method="post" >
	 <input type="hidden" id="st_user_id" name="st_user_id"	value="<%=sessionUserId %>">
	 <input type="hidden" id="st_sr_user_id" name="st_sr_user_id"	value="<%=st_sr_user_id %>">
	 <input type="hidden" id="st_sr_no" name="st_sr_no"	value="<%=st_sr_no %>">
	 <input type="hidden" id="st_recv_flag" name="st_recv_flag"	value="">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:580px;">
    	<div id="popHeader">
        	<h1 class="title">S/R 상세내역 보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:550px;">
        	<div class="scrollArea" style="height:530px">
<%
if(_dataList == null || _dataList.size() <= 0){
%>
			<table  class="cont_t_list06 mb15" summary="S/R 상세내역 보기" style="width:100%;">
				<caption>S/R 상세내역 보기</caption>
				<colgroup>
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="24%" />
				</colgroup>
				<tbody>
		    	<tr>
					<td colspan="6" class="center"><font color="blue"><b>조회 된 데이터가 없습니다.</b></font></td>
				</tr>
		        </tbody>
		   </table>
<%	
}else{
%>
			<table  class="cont_t_list06 mb15" summary="S/R 상세내역 보기" style="width:100%;">
				<caption>S/R 상세내역 보기</caption>
				<colgroup>
					<col width="11%" />
					<col width="21%" />
					<col width="11%" />
					<col width="21%" />
					<col width="11%" />
					<col width="22%" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">S/R번호</th>
					<td><b><%=CommonUtil.nvl(rowData.get("SR_NO"))%></b></td>
					<th scope="row">진행상태</th>
					<td><b><%=CommonUtil.nvl(rowData.get("RECV_TEXT"))%></b></td>
					<th scope="row">요청자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%></td>
				</tr>
		    	<tr> 
		    		<th scope="row">시스템구분</th>
					<td><%=CommonUtil.nvl(rowData.get("SYS_TEXT"))%></td>
					<th scope="row">요청영역/내역</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_TEXT"))%></td>
					<th scope="row">요청일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("REQ_TIME"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">처리희망일</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("PH_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("PH_TIME"))%></td>
					<th scope="row">결재자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_CONFIRM_NAME"))%></td>
					<th scope="row">결재일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("REQ_CONFIRM_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("REQ_CONFIRM_TIME"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">접수자</th>
					<td><%=CommonUtil.nvl(rowData.get("CD_USER_NAME"))%></td>
					<th scope="row">접수일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("CD_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("CD_TIME"))%></td>
					<th scope="row">처리예정일</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("DS_TIME"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">처리자</th>
					<td><%=CommonUtil.nvl(rowData.get("DS_USER_NAME"))%></td>
					<th scope="row">처리일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("DF_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("DF_TIME"))%></td>
					<th scope="row">완료일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("FF_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("FF_TIME"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">제목</th>
					<td colspan="5"><%=CommonUtil.nvl(rowData.get("SR_SUBJECT"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">요청내역</th>
					<td colspan="5"><%=CommonUtil.formatHTMLCode(rowData.get("REQ_REMARK"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">첨부파일</th>
					<td colspan="5">
					<input type="hidden" id="st_req_image_key" name="st_req_image_key" value="<%=CommonUtil.nvl(rowData.get("REQ_ATTKEY"))%>" />
					<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUploadReq')">첨부보기</a></span>
					</td>
				</tr>
				<tr> 
		    		<th scope="row">처리내역</th>
					<td colspan="5"><%=CommonUtil.formatHTMLCode(rowData.get("DF_REMARK"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">첨부파일</th>
					<td colspan="5">
					<input type="hidden" id="st_ff_image_key" name="st_ff_image_key" value="<%=CommonUtil.nvl(rowData.get("FF_ATTKEY"))%>" />
					<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUploadFf')">첨부보기</a></span>
					<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="<%=CommonUtil.nvl(rowData.get("REQ_DATA_BUYER"))%>" />
					<input type="hidden" id="st_req_data_type" name="st_req_data_type" value="<%=CommonUtil.nvl(rowData.get("REQ_DATA_CD"))%>" />
					<input type="hidden" id="st_req_data_buyer" name="st_req_data_buyer" value="<%=CommonUtil.nvl(rowData.get("REQ_DATA_BUYER"))%>" />
					<input type="hidden" id="st_from_date" name="st_from_date" value="<%=CommonUtil.nvl(rowData.get("REQ_DATA_FROM_DATE"))%>" />
					<input type="hidden" id="st_to_date" name="st_to_date" value="<%=CommonUtil.nvl(rowData.get("REQ_DATA_TO_DATE"))%>" />
					<input type="hidden" id="st_chk_pass_yn" name="st_chk_pass_yn" value="<%=CommonUtil.nvl(rowData.get("PASS_YN"))%>" />
					
					</td>
				</tr>
<%
			if(CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("DL")&&CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("PA") && sessionUserId.equals(CommonUtil.nvl(rowData.get("USER_ID")))
				||CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("DL")&&CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("GG") && sessionUserId.equals(CommonUtil.nvl(rowData.get("USER_ID")))) {
%>
				<tr> 
		    		<th scope="row">자료 요청타입</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_DATA_TYPE"))%></td>
		    		<th scope="row">고객사</th>
					<td><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td>
		    		<th scope="row">조회기간</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATA_FROM_DATE"))%> ~ <%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATA_TO_DATE"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">자료다운로드</th>
					<td colspan="5">
						<span class="btn_gray_03" title="파일첨부"><a href="javascript:doAction('excelDown')">다운로드</a></span>
					</td>
				</tr>
<%
			}
%>	
<%
			if(CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("PA") && sessionUserId.equals(CommonUtil.nvl(rowData.get("USER_ID")))) {
%>
				<tr> 
		    		<th scope="row">만족도</th>
					<td><select id="st_rub_type" name="st_rub_type"></select></td>
					<th scope="row">남기실말</th>
					<td colspan="3" ><textarea id="st_rub_remark"  name="st_rub_remark" rows="3" style="padding:3px;width:90%;ime-mode:active"></textarea></td>
				</tr>
<%
			}
%>		

<%
			if(CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("GG")) {
%>
				<tr> 
		    		<th scope="row">만족도</th>
					<td><%=CommonUtil.nvl(rowData.get("RUB_TEXT"))%></td>
					<th scope="row">남기실말</th>
					<td colspan="3"  style="padding:8px;line-height:150%"><%=CommonUtil.formatHTMLCode(rowData.get("RUB_REMARK"))%></td>
				</tr>
<%
			}

			if(CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("GB")){
%>		
				<tr> 
					<th scope="row">반려사유</th>
					<td colspan="5"  style="padding:8px;line-height:150%"><%=CommonUtil.nvl(rowData.get("RETURN_REASON"))%></td>
				</tr>
<%
			}
%>	
		        </tbody>
        </div>
        </div>
		   </table>
		   <div class="btnArea" >
				<span class="fr">
<%
			if(CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("PA") && sessionUserId.equals(CommonUtil.nvl(rowData.get("USER_ID")))) {
%>
				※처리 완료된 건 입니다. 요청자께서 최종 만족도 및 완료를 해 주시기 바랍니다.&nbsp;<span class="btn_02"><a href="javascript:doAction('complete');" >완료</a></span>
<%
			}

			if(CommonUtil.nvl(rowData.get("RECV_FLAG")).equals("GA") && sessionUserId.equals(CommonUtil.nvl(rowData.get("USER_ID")))) {
%>	
					<span class="btn_02"><a href="javascript:doAction('cancel');" >취소</a></span>
<%
			}
%>
				</span>                	
			</div>
<% } %>
    </div>         
</form> 
</body>
</html>
