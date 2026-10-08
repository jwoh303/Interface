<%--
**********************************************
* 메뉴 : 납품관리 > 납품실적등록 > 엑셀업로드 
* 화면 : 엑셀업로드
* 기능 : 택배송장번호 일괄 엑셀업로드
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 현명환 )
* 착수일 : 2016-01-15
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());
%>

<script type="text/javascript">
var popupSel = "";
var btnEvent = "";

//최초 화면 함수
function kep_onload_view(){
}	

function setExcelUp() {  		 
	if (isEmpty($("#files").val())==true){
		alert("업로드 대상이 없습니다. 확인 부탁드립니다.");
		return;
	}
	if(setExcelUpValid() == true){
		$('#UploadForm').attr("action", "/mpiv/setMpIvExcelUp.do").submit();
	}
}

function setExcelUpValid() {
	if (IsExt($("#files").val())) { //파일명 체크
	    alert("해당 형식의 파일은 업로드할 수 없습니다.");
		return;
// 	    doAction("search");
	}
	return true;
}

function IsExt(str) {
    var urltext = str.toLowerCase(); //받아온 파일명을 소문자로 변경한다.

    if (/xls/.test(urltext)){
       return false; //해당 파일명에 xls라는 단어가 있음.
    } else {
      return true; //해당 파일명에 xls라는 단어가 없음.
    }
 }
 
//팝업함수호출
var gridIndex = "";
function doPop(str,value1, value2, value3) {
}

function setPopupReturn(code, text, value){
}

function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $("#display_item_cnt").val();
	
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

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnParcel"){
		alert("택배사 정보가 정상적으로 등록되었습니다.");
		kepAjaxFormCall("/mpiv/delMpIvExcelUp.do","searchForm","delete");
	}	

	if(pMethod == "delete"){
		self.close();
	}
	return;
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response){
	alert("택배사 정보 등록에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
}

//택배사정보등록
function setParcel(){
	
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 택배사 정보 등록할 품목수
	
	var buyer					= "";	// 고객사코드
	var buyer_name			= "";	// 고객사명
	var inv_no					= "";	// 거래명세서번호
	var parcel_com_code	= "";	// 택배사코드
	var parcel_com_name	= "";	// 택배사명
	var parcel_inv_no			= "";	// 택배송장번호
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	// 택배사 정보 선택체크
	if(eval(tot_cnt) < 2){
		var box = eval("document.contentForm.checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer					= document.forms.contentForm.db_buyer_code.value;
			buyer_name		= document.forms.contentForm.db_buyer_name.value;
			inv_no				= document.forms.contentForm.db_inv_no.value;
			parcel_com_code	= document.forms.contentForm.db_parcel_com_code.value;
			parcel_com_name= document.forms.contentForm.db_parcel_com_name.value;
			parcel_inv_no		= document.forms.contentForm.db_parcel_inv_no.value;
			
			// 고객사명 체크
			if(kepIsValueNull(buyer_name)){
				alert("고객사코드를 확인하여 주십시오.");
				return;
			}
			
			// 택배사명 체크
			if(kepIsValueNull(parcel_com_name)){
				alert("택배사코드를 확인하여 주십시오.");
				return;
			}
			
			// 택배송장번호 체크
			if(!alphaNumChk(parcel_inv_no)){
				alert("택배송장번호는 영문, 숫자만 입력가능합니다.");
				return;
			}
			
			query +=  buyer + "@@";
			query +=  inv_no + "@@";
			query +=  parcel_com_code + "@@";
			query +=  parcel_inv_no;
			query +=  "^||^" ;
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
				
				buyer						= document.forms.contentForm.db_buyer_code[k].value;
				buyer_name			= document.forms.contentForm.db_buyer_name[k].value;
				inv_no					= document.forms.contentForm.db_inv_no[k].value;
				parcel_com_code		= document.forms.contentForm.db_parcel_com_code[k].value;
				parcel_com_name	= document.forms.contentForm.db_parcel_com_name[k].value;
				parcel_inv_no			= document.forms.contentForm.db_parcel_inv_no[k].value;
				
				// 고객사명 체크
				if(kepIsValueNull(buyer_name)){
					alert((k+1)+"번째 행의 고객사코드를 확인하여 주십시오.");
					return;
				}
				
				// 택배사명 체크
				if(kepIsValueNull(parcel_com_name)){
					alert((k+1)+"번째 행의 택배사코드를 확인하여 주십시오.");
					return;
				}
				
				// 택배송장번호 체크
				if(!alphaNumChk(parcel_inv_no)){
					alert((k+1)+"번째 행의 택배송장번호는 영문, 숫자만 입력가능합니다.");
					return;
				}
				
				query +=  buyer					+ "@@";
				query +=  inv_no					+ "@@";
				query +=  parcel_com_code	+ "@@";
				query +=  parcel_inv_no;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == 0){
		alert("택배사정보를 등록할 품목을 선택하여 주십시요");
		return;
	}
	
	if(!confirm("택배사정보를 등록 하시겠습니까?")) return;
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordParcelRegList.do","searchForm","btnParcel");
}

// 택배송장번호 영문과 숫자만 사용
function alphaNumChk(text) {
	
	var input = text; 	
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    for (var inx = 0; inx < input.length; inx++) {
        if (chars.indexOf(input.charAt(inx)) == -1){
            return false;
        }
     }
     return true;
}

</script> 
<body onload="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:702px;">
    	<div id="popHeader">
        	<h1 class="title">엑셀업로드 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:628px">
             <div id="searchBtnA02">
             	<form method="post" action="/mpso/setExcelUp.do"  name="UploadForm" id="UploadForm" modelAttribute="uploadForm" enctype="multipart/form-data">      
					<table  class="board_write" summary="파일업로드" id="fileTable">
					<caption>엑셀업로드 올리기</caption>
					<colgroup> 
						<col width="*" />
					</colgroup>
					<tbody> 
					  <tr> 
							<td scope="row">
							<input name="files" id="files" type="file"  class="input_type_text" onchange="setExcelUpValid()" />
							<a href="javascript:setExcelUp()"><img src="/resources/images/but_reg.gif" alt="등록" /></a>	
							<span class="btn_04 mr04"><a href="/resources/excel/work/MPIV/SellerMpIvExcelUploadPop.xls">양식다운로드</a></span>
							</td>        
					  </tr>   
					</table>    	
				</form>
            </div>   
            <!--조회영역-->
            <form name = "searchForm" id="searchForm" method = "post">
	            <input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
				<input type=hidden name="st_user_id" id="st_user_id"  value="<%=user_id%>">
				<input type=hidden name="st_excel_type" id="st_excel_type"  value="">
            	<input type="hidden" name="st_query" id="st_query" value ="">
            </form>
           	<!--grid-->
      	<form name="contentForm" id="contentForm" method=post >
			<input type=hidden name="cellCount" id="cellCount"  value="10">
			
            <div class="scrollArea" style="height:550px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>엑셀업로드 리스트</caption>
                    <colgroup>
                        <col width="3%"/>
                        <col width="3%"/>
                        <col width="10%"/>
                        <col width="16%"/>
                        <col width="10%"/>
                        <col width="8%"/>
						<col width="10%"/>
						<col width="10%"/>
                    </colgroup>
                    <thead>
                        <tr>
                        	<th rowspan="2" > 
								<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
							</th> 
							<th rowspan="2" >번호</th>
							<th>고객사코드</th>
							<th>품명</th>
							<th rowspan="2">거래명세서번호</th>
							<th rowspan="2">택배사코드</th>
							<th rowspan="2">택배사명</th>
							<th rowspan="2">택배송장번호</th>
						</tr>
						<tr>
							<th>고객사명</th>
							<th>규격</th>
						</tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="9" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td rowspan="2" title="">
								<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
								<input type="hidden" name="db_buyer_code"        value="<%=CommonUtil.nvl(rowData.get("BUYER_CODE"))%>">
								<input type="hidden" name="db_buyer_name"        value="<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>">
						        <input type="hidden" name="db_inv_no"       value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>">
						        <input type="hidden" name="db_parcel_com_code"       value="<%=CommonUtil.nvl(rowData.get("PARCEL_COM_CODE"))%>">
						        <input type="hidden" name="db_parcel_com_name"       value="<%=CommonUtil.nvl(rowData.get("PARCEL_COM_NAME"))%>">
						        <input type="hidden" name="db_parcel_inv_no"       value="<%=CommonUtil.nvl(rowData.get("PARCEL_INV_NO"))%>">
								<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>">
								<input type="hidden" name="excel_up" id="excel_up" value="Y" >
							</td>
							<td rowspan="2" title="번호">
								<%=j+1%>
							</td>
							<td title="고객사코드">
								<%=CommonUtil.nvl(rowData.get("BUYER_CODE"))%>
						    </td>
						    <td title="품명">
								<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
						    </td>
							<td rowspan="2" title="거래명세서번호">
								<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
						    </td>
						    <td rowspan="2" title="택배사코드">
								<%=CommonUtil.nvl(rowData.get("PARCEL_COM_CODE"))%>
							</td>
							<td rowspan="2" title="택배사명">
								<%=CommonUtil.nvl(rowData.get("PARCEL_COM_NAME"))%>
						    </td>
							<td rowspan="2" title="택배송장번호">
								<%=CommonUtil.nvl(rowData.get("PARCEL_INV_NO"))%>
							</td>
                        </tr>
                        <tr>
							<td title="고객사명">
								<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
							</td>
							<td title="규격">
								<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
						    </td>
                        </tr>
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
        </form> 
        <form name="processForm" id="processForm" method="post">	
			<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
			<input type="hidden" name="buyer" id="buyer" value="" />
			<input type="hidden" name="gubun" id="gubun" value="" />
			<div id="process">
			</div>
		</form>
        <!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fr"> 
				<span class="btn_03 mt05">
					<a href="javascript:setParcel();">적용</a>
				</span>		        	
			</div>
		</div>
    </div>        
</div>

</body>
</html>
