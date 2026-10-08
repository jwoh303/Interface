<%--
**********************************************
* 메뉴 : 신규영업관리 > 잠재고객 정보 계약등록
* 화면 : 잠재고객 정보 셋업 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;	
	String userid = "";
	String userName = "";
	if (_sessionInfo != null){ 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());  	
	}
	String sbuyer = "";
	String st_process_type = "";
	String st_close_flag = "";
	String st_b_revision =  "";

	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		sbuyer = CommonUtil.nvl(_rowData.get("BUYER"));
		if(st_b_revision.equals("")){
			st_b_revision =CommonUtil.nvl(_rowData.get("REVISION"));
		}
		st_process_type = CommonUtil.nvl(_rowData.get("PROCESS_TYPE"),"");
		st_close_flag = CommonUtil.nvl(_rowData.get("BUYER_CLOSE_FLAG"),"");
		
	}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var popupSel = "";
var grbRow = "";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function popupOnload(){

}

//기능함수
function doAction(str) {
	switch (str) {
		case "search":
			kepAjaxFormCall("/mdct/getMasterMdCtNewCustomerConList.do","searchCondition","");
			break;
		case "reg":
			if (checkSaveSubmit()) {
			    if(!confirm("완료 처리 하시겠습니까?\n완료처리 되면 수정 불가능 합니다.  ")) {
			        return;
			    }else{
				   document.forms.searchCondition.st_data_gbn.value = "reg";
				   document.forms.searchCondition.st_process_type.value = "CP";
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomerConList.do","searchCondition","reg"); 	   
			    }
			}
			break;
		case "end"://종결처리
			// 사유입력
			if(confirm("잠재고객 정보 종결 하시겠습니까?  ")) {
				popupSel = "reasonPop";
				openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");				
			}
			break;
		case "reStart"://재개
			if(confirm("잠재고객 정보 재개하시겠습니까?  ")) {
			    $("#st_end_remark").val("");
			    $("#st_buyer_close_flag_in").val("N");
				kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","restart");				
			}
			break;
	}

}

//팝업리턴
function setReason(value){
    
	//사유저장
	if (popupSel == "reasonPop"){
	    $("#st_end_remark").val(value);
	    $("#st_buyer_close_flag_in").val("Y");
	    kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","end");
	}
	
}
function checkSaveSubmit(){

	if (isEmpty($("#st_con_note").val())) {
		alert("특이사항이 입력되지 않았습니다. ");
		$("#st_con_note").focus();
		return false;
	}

	if (isEmpty($("#st_image_key").val())) {
		alert("첨부파일 등록 바랍니다. ");
		return false;
	}
	return true;
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "reg"||pMethod == "update"||pMethod == "cancle"||pMethod == "save"||pMethod == "end"||pMethod == "restart"){
		 alert("처리 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var result = response.msg.MSG;  
	if(pMethod=="reg"){
		if(result=="Ok"){
			alert("셋업등록 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}
	}else if(pMethod=="update"){
		if(result=="Ok"){
			alert("수정 되었습니다.");
			doAction("search")
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="cancle"){
		if(result=="Ok"){
			alert("취소 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="end"){
		if(result=="Ok"){
			alert("잠재고객사 종결 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="restart"){
		if(result=="Ok"){
			alert("잠재고객사 재개 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}
}


//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	switch (str) {
		case 	"fileUpload": //파일업로드
			popupSel = "fileUpload";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=CSTM", "500,430,no");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
									,value31,value32){
	if(popupSel == "fileUpload"){//첨부파일
		$("#st_image_key").val(value1);
		$("#st_image_key_text").val(value2);
	}
}



</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="com_code"  name="com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_com_code"  name="st_com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_buyer_close_flag_in"  name="st_buyer_close_flag_in"  value="">
	<input type="hidden" id="st_end_remark"  name="st_end_remark"  value="">
	<input type="hidden" id="st_revision"  name="st_revision"  value="<%=CommonUtil.nvl(_rowData.get("REVISION")) %>">
	<input type="hidden" id="st_data_gbn"  name="st_data_gbn"  value="">
	<input type="hidden" id="st_process_type"  name="st_process_type"  value="">
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title">잠재고객 계약정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
        	<!--버튼영역-->
            <!--조회영역-->
            <h4><b>잠재고객 계약정보</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="*" />                                          
						</colgroup>
						<tbody>
						  <tr>		
							<th>고객사명</th>			
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("BUYER_NAME")) %>"/></td>	
							<th>그룹사</th>			
							<td><input type="text" name="st_group" id="st_group" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readonly value="<%=CommonUtil.nvl(_rowData.get("GROUP_NAME")) %>"/></td>		
							<th>입찰차수</th>			
							<td>
								<input type="text" name="st_b_revision" id="st_b_revision" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("REVISION")) %>"/>
							</td>
						 </tr>
					</tbody>
				</table>	
            <h4><b>계약</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="*" />                                         
						</colgroup>
						<tbody>
						  <tr>		
							<th>*특이사항</th>			
							<td colspan="5"><input type="text" name="st_con_note" id="st_con_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_NOTE")) %>"/></td>		
						 </tr>
						  <tr>		
							<th>*첨부파일</th>			
							<td>								
								<input type="hidden" id="st_image_key" name="st_image_key" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY")) %>" />
								<input type="hidden" id="st_image_key_Text" 	name="st_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUpload')">첨부등록</a></span> <br>Ex) 계약서 등
							</td>			
							<th>등록일</th>			
							<td><input type="text" name="st_add_date" id="st_add_date" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("CONTRACT_ADD_DATE"))) %>"/></td>
							<th>등록자</th>			
							<td><input type="text" name="st_add_user_nm" id="st_add_user_nm" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_ADD_USER_NM")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
            <!--grid-->
			<span class="fr">
			<%
			if(st_close_flag.equals("Y")){
			%>
				<span class="btn_02 mr04"><a href="javascript:doAction('reStart')">재개</a></span>
			<%
			}else{
				//셋업 완료일 경우.
				if(st_process_type.equals("CN")){
			%>
				<span class="btn_04 mr04"><a href="javascript:doAction('reg')">완료</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('end')">종결</a></span>
			<%
				}
			}
			%>					
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
