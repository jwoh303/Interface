<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
String st_btoa_remark = CommonUtil.nvl((String) request.getParameter("st_btoa_remark"),"");  //  (조회조건)
String st_atos_remark = CommonUtil.nvl((String) request.getParameter("st_atos_remark"),"");  //  (조회조건)
String st_stoa_remark = CommonUtil.nvl((String) request.getParameter("st_stoa_remark"),"");  //  (조회조건)
String st_atob_remark = CommonUtil.nvl((String) request.getParameter("st_atob_remark"),"");  //  (조회조건)

st_btoa_remark = st_btoa_remark.replaceAll("&lt;br&gt;","\n");
st_atos_remark = st_atos_remark.replaceAll("&lt;br&gt;","\n");
st_stoa_remark = st_stoa_remark.replaceAll("&lt;br&gt;","\n");
st_atob_remark = st_atob_remark.replaceAll("&lt;br&gt;","\n");

//견적의뢰접수 견적정보 추가.
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var gType = "<%=st_type%>"; //SOUR: 업체선정및 견적제출일 화면에서 팝업 호출 할때만 사용 됨
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

function init(){
	$("#st_atob_remark").focus();
	
	if(gType == "SOUR"){
		var initsheet = {};
		
		initsheet.Cols = [  
			      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1}
			      			,{ Align:"Center",	Width:20,	Edit:true,	EditLen:50,		Hidden:false,	Type:"Radio",	Header:"",		SaveName:"SELECTED"}
							,{ Align:"Left",	Width:540,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"특이사항",	SaveName:"ADD_NOTE", Sort:0}
							,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",	SaveName:"IMAGE_KEY_IMG", Sort:0}
			    			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",	SaveName:"IMAGE_KEY", Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM", Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록일시",	SaveName:"ADD_DATE", Sort:0}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NM", Sort:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정일시",	SaveName:"CHANGE_DATE", Sort:0}
							
			];
		IBS_InitSheet(mySheet, initsheet,pagingMode);
		kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationRemarkPop.do" , pagingMode );
		
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		setLinkCol(mySheet, "IMAGE_KEY_IMG"); //첨부
	}
}

function kepConfirm()
{ 
  var value1 = kepTrim("st_atob_remark");
  value1 = value1.replace(/\r?\n/g, '<br>');
  
  var value2 = "";
  opener.setPopupReturn(value1,value2);
  this.close();
}


function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
		doAction("search");
	}
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationRemarkPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;

	if(column == "IMAGE_KEY_IMG"){
		popupSel = "basFileUpload";
		var type="RFQ";
		var viewType="R";
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	return;
}

//특이사항 메일발송
function kepMailSend(){
	var totRow = mySheet.RowCount();
	if( totRow <= 0){
		alert("메일발송 가능한 특이사항이 없습니다.");
		return;
	}

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var st_add_note = mySheet.GetCellValue(arrRow[0], "ADD_NOTE");
	var st_add_user_nm = mySheet.GetCellValue(arrRow[0], "ADD_USER_NM");
	var st_add_date = mySheet.GetCellValue(arrRow[0], "ADD_DATE");
	var st_change_user_nm = mySheet.GetCellValue(arrRow[0], "CHANGE_USER_NM");
	var st_change_date = mySheet.GetCellValue(arrRow[0], "CHANGE_DATE");
	var st_buyer = $('#st_buyer').val();
	
	if (selectedGrid.length == 0){
        alert("메일 발송할 특이사항를 선택하여 주십시요.");
        return;
	}
	kepSave(document.searchCondition ,  mySheet , "/mprq/insertMasterMpRqAddNoteSendMail.do" , "SELECTED");
}
</script>  
<body onload="init(); " >
	<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">	
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:602px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

			<table class="cont_t_list02" style="background-color: #FAF9CF; width: 100%;">
                <tr> 
                    <th >고객사<br><br>▶<br><br>운영자</th>
                    <td >
                        <textarea id="st_btoa_remark" name="st_btoa_remark" style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_btoa_remark%></textarea>
                    </td>
                </tr>
            </table>
			<table class="cont_t_list02" style="background-color: #FAF9CF; width: 100%;">
                <tr> 
                    <th >운영자<br><br>▶<br>선정<br>협력사</th>
                    <td >
                        <textarea id="st_atos_remark" name="st_atos_remark" style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_atos_remark%></textarea>
                    </td>
                </tr>
            </table>
			<table class="cont_t_list02" style="background-color: #FAF9CF; width: 100%;">
                <tr> 
                    <th >선정<br>협력사<br>▶<br><br>운영자</th>
                    <td >
                        <textarea id="st_stoa_remark" name="st_stoa_remark" style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_stoa_remark%></textarea>
                    </td>
                </tr>
            </table>
			<table class="cont_t_list02" style="background-color: #FAF9CF; width: 100%;">
                <tr> 
                    <th >운영자<br><br>▶<br><br>고객사</th>
                    <td >
                        <textarea id="st_atob_remark" name="st_atob_remark" style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_atob_remark%></textarea>
                    </td>
                </tr>
            </table>
            <table style=" width: 100%;">
                <tr> 
                    <td></td>
                </tr>
            </table>
            <%
            	if(st_type.equals("SOUR")){
            %>
		        	<!--grid-->
		 			<div style="border-top:2px solid #3c639c">
						<script type="text/javascript">
							createIBSheet("mySheet", "", "120px");
						</script>
					</div>
					<div id="pageindex"></div>
            <%
            	}
            %>
	       	<div class="btnArea" style="margin-bottom:2px;">
	       		<span class="btn_06"><a href="javascript:kepMailSend()">운영 메일발송</a></span>
				<span class="btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div> 		
        </div>
    </div>
   </form>
</body>
</html>
