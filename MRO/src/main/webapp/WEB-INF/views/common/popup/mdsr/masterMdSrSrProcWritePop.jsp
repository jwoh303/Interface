<%--
**********************************************
* 메뉴 : 
* 화면 : S/R 처리안 작성 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_700_09
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 2014-08-07
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

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	// 조회조건 초기화
	kepSetCalenderTime("st_ds_date","st_ds_time");
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
				var viewType = "R";
				openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_req_image_key").val()+"&TYPE=SR&viewType="+viewType, "500,430,no");
			}
			break;
	}
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "save":	 // 완료
			if(isEmpty($("#st_ds_date").val())) {
				alert("처리예정일을 입력하여 주십시요.");
				$("#st_ds_date").focus();
				return;
			}
		
			if(isEmpty($("#st_ds_remark").val())) {
		        alert("처리안을 입력하여 주십시요.");
		        $("#st_ds_remark").focus();
		        return;
		    }
		
			if(confirm("처리안을 상신하시겠습니까?")){
				kepAjaxPopFormCall("/mdsr/saveMasterMdSrSrProcWritePop.do","masterMdSrSrProcWritePop","save");
			}
			
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == "OK") {
			alert("정상적으로 처리안이 상신되었습니다.");
		} else {
			alert("처리안을 상신하던중 오류가 발생하였습니다.");
		}
	}
	
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	alert("처리안을 상신하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("처리안을 상신하던중 오류가 발생하였습니다.");
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
	 <form name="masterMdSrSrProcWritePop" id="masterMdSrSrProcWritePop" method="post" >
	 <input type="hidden" id="st_user_id" name="st_user_id"	value="<%=sessionUserId %>">
	 <input type="hidden" id="st_sr_user_id" name="st_sr_user_id"	value="<%=st_sr_user_id %>">
	 <input type="hidden" id="st_sr_no" name="st_sr_no"	value="<%=st_sr_no %>">
	 <input type="hidden" id="st_recv_flag" name="st_recv_flag"	value="">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:580px;">
    	<div id="popHeader">
        	<h1 class="title">S/R 처리안 작성</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:550px;">
        	<div class="scrollArea" style="height:530px">
<%
if(_dataList == null || _dataList.size() <= 0){
%>
			<table  class="cont_t_list06 mb15" summary="S/R 처리안 작성" style="width:100%;">
				<caption>S/R 처리안 작성</caption>
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
			<table  class="cont_t_list06 mb15" summary="S/R 처리안 작성" style="width:100%;">
				<caption>S/R 처리안 작성</caption>
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
					<th scope="row">요청자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%></td>
					<th scope="row">요청일시</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("REQ_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("REQ_TIME"))%></td>
				</tr>
		    	<tr> 
		    		<th scope="row">시스템구분</th>
					<td><%=CommonUtil.nvl(rowData.get("SYS_TEXT"))%></td>
					<th scope="row">요청영역/내역</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_TEXT"))%></td>
					<th scope="row">결재자</th>
					<td><a class="hyperLink"  href="javascript:openSearchPopup('/common/popup/approval/buyerCommonPassStatusPop.do','?COMPANY=KRKORE0001&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>' , '800,400,no')">
						<%=CommonUtil.nvl(rowData.get("REQ_CONFIRM_NAME"))%>
					</td>
				</tr>
				<tr> 
					<th scope="row">처리예정일</th>
					<td>
						<input type="text" class="input_type_text" name="st_ds_date" id="st_ds_date" readOnly style="width:100px; text-align:center;" value="" >
						<select id="st_ds_time" name="st_ds_time">
							<option value="090000">09:00</option>
							<option value="100000">10:00</option>
							<option value="110000">11:00</option>
							<option value="120000">12:00</option>
							<option value="130000">13:00</option>
							<option value="140000">14:00</option>
							<option value="150000">15:00</option>
							<option value="160000">16:00</option>
							<option value="170000">17:00</option>
						</select>
					</td>
		    		<th scope="row">처리희망일</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("PH_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("PH_TIME"))%></td>
					<th scope="row">결재일자</th>
					<td><%=CommonUtil.formatStrinigDate(rowData.get("REQ_CONFIRM_DATE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("REQ_CONFIRM_TIME"))%></td>
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
					<th scope="row">처리안</th>
					<td colspan="5" ><textarea id="st_ds_remark" name="st_ds_remark"rows="10" style="padding:3px;width:90%;ime-mode:active"></textarea></td>
				</tr>
		        </tbody>
		   </table>
        </div>
        <br>
		   <div class="btnArea" >
				<span class="fr">
					<span class="btn_05"><a href="javascript:doAction('save');" >처리안 상신</a></span>
				</span>                	
			</div>
<% } %>
        </div>
    </div>         
</form> 
</body>
</html>
