<%--
**********************************************
* 메뉴 : 견적관리 > 고객사별견적비고관리
* 화면 : 고객사별견적비고관리
* 기능 : 고객사별견적비고관리
* 프로그램 ID : 
* 담당자 : HSJ  
* 착수일 : 2023-04-04
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
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //   (조회조건)
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //   (조회조건)
	String st_user_id = _sessionInfo.getUserId();
	
	boolean st_save_user = CommonUtil.getCodeCheckReturn("BQRMUSER", st_user_id);
%> 
<body onload="kep_onload_view()">  
<form id="searchCondition"  name = "searchCondition" method = "post" >
<!--내용 시작-->	
<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>고객사별 견적비고 관리</h3>
		<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span> 
		<span class="btn_reset"><a href="javascript:kepReload();">초기화</a></span>
	</div>
<!--조회영역-->
	<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	

		<table  class="cont_t_list01">
			<caption>게시판</caption>
			<colgroup>
				<col width="10%" />
				<col width="90%" />
			</colgroup>
			<tbody>
				<tr>
					<th><font color="red"><b>*</b></font>고객사</th>
					<td>
                       <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:20%;" value = "<%=st_buyer_name%>"  readonly>
                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="<%=st_buyer_code%>">
                       <a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<br>
	
	<div>
		<table id="table_list" class="cont_t_list05">
			<caption>게시판 </caption>
				<colgroup>
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
					<col width="20%" />
				</colgroup>
				
				<thead>
					<tr>
						<th scope="col">고객사견적특이사항</th>
						<th scope="col">DB클렌징<br>MOQ설정</th>
						<th scope="col">지정/선호협력사</th>
						<th scope="col">업체선정<br>고객사제출비고예문</th>
						<th scope="col">견적제출</th>
					</tr>          
				</thead>
				
				<tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
                   	<tr>
						<td><textarea id="st_remark1" name="st_remark1" style="width:95%;" rows="30"></textarea></td>
						<td><textarea id="st_remark2_1" name="st_remark2_1" style="width:95%;" rows="27"></textarea>
							<textarea id="st_remark2_2" name="st_remark2_2" style="width:95%;margin-top:10px;" rows="3" readonly></textarea>
						</td>
						<td><textarea id="st_remark3" name="st_remark3" style="width:95%;" rows="30"></textarea></td>
						<td><textarea id="st_remark4_1" name="st_remark4_1" style="width:95%;" rows="15"></textarea>
							<textarea id="st_remark4_2" name="st_remark4_2" style="width:95%;margin-top:10px;" rows="15" readonly></textarea>
						</td>
						<td><textarea id="st_remark5" name="st_remark5" style="width:95%;" rows="30"></textarea></td>
					</tr>
<%
}else{
	Map<String,String> rowData = _dataList.get(0);
%> 						
					<tr>
						<td><textarea id="st_remark1" name="st_remark1" style="width:95%;" rows="30"><%=CommonUtil.nvl( rowData.get("RE_NOTE"))%></textarea></td>
						<td><textarea id="st_remark2_1" name="st_remark2_1" style="width:95%;" rows="27"><%=CommonUtil.nvl( rowData.get("CLRM_REMARK"))%></textarea>
							<textarea id="st_remark2_2" name="st_remark2_2" style="width:95%;margin-top:10px;" rows="3"><%=CommonUtil.nvl( rowData.get("MOQT_REMARK"))%></textarea>
						</td>
						<td><textarea id="st_remark3" name="st_remark3" style="width:95%;" rows="30"><%=CommonUtil.nvl( rowData.get("DSRM_REMARK"))%></textarea></td>
						<td><textarea id="st_remark4_1" name="st_remark4_1" style="width:95%;" rows="15"><%=CommonUtil.nvl( rowData.get("ASRM_REMARK"))%></textarea>
							<textarea id="st_remark4_2" name="st_remark4_2" style="width:95%;margin-top:10px;" rows="15"><%=CommonUtil.nvl( rowData.get("ASRMGD_REMARK"))%></textarea>
						</td>
						<td><textarea id="st_remark5" name="st_remark5" style="width:95%;" rows="30"><%=CommonUtil.nvl( rowData.get("QSRM_REMARK"))%></textarea></td>
					</tr>
<%
}
%>		
				</tbody>
		</table>
</form>

<% if(st_save_user == true){ %>
	<div class="btnArea" align="right">  
		<span class="btn_04 mr04"><a href="javaScript:kepSave();">저장</a></span>
	</div>
<%}%>
	</div>
</body>
<script type="text/javascript">
//최초 화면 함수
function kep_onload_view(){
}
/*
 * FORM 을 이용한조회
 */
function kepSearch(){
	if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
		alert("고객사은(는) 필수입력 항목입니다.");
		return;
	}
	
	$('#searchCondition').attr("action", "/mprq/getMasterMpRqBuyerRemarkList.do").submit();   
}

/**
 * FORM 을 초기화
 */
function kepReload(){
	$("#st_buyer_code").val('');
	$("#st_buyer_name").val('');
	$("#st_remark1").val('');
	$("#st_remark2_1").val('');
	$("#st_remark2_2").val('');
	$("#st_remark3").val('');
	$("#st_remark4_1").val('');
	$("#st_remark4_2").val('');
	$("#st_remark5").val('');
}

// 저장
function kepSave(){
	if($("#st_buyer_code").val() == null||$("#st_buyer_code").val() == ""){
		alert("고객사은(는) 필수입력 항목입니다.");
		return;
	}
	
	kepAjaxFormCall("/mprq/saveMasterMpRqBuyerRemarkList.do","searchCondition","SAVE");
}

//팝업함수호출
function doPop(str) {
	switch (str) {
		case "buyerMulti": // 고객사 S
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			popupSel = "buyerMulti";
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code,text){
	if (popupSel == "buyerMulti") {	
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@"));
	} 		
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;    
	
	if (pMethod == "SAVE") {
		if (sMsg == 'OK') {
			alert("정상적으로 저장 완료 되었습니다.");
		} else {
			alert("저장이 실패하였습니다.\n시스템운영팀에게 문의하여 주시기 바랍니다.");
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
}
</script>
</html>
