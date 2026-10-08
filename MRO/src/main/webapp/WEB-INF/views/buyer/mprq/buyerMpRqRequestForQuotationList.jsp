<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품견적의뢰
* 기능 : 고객사가 운영사에게 신규상품 견적의뢰를 한다 (두산인프라전용)
* 프로그램 ID : PG_04_B_003_03
* 담당자 : 김영미(설계:권우재)
* 생성일 : 2014-08-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 E
	String st_btoa_end_date = CommonUtil.nvl((String) request.getParameter("st_btoa_end_date"),"");  // 등록요청일
	String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
	String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
<div id="container2">	
<div id="ContArea">
	<h3>신규상품 견적의뢰</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		<span class="btn_reset"><a href="javascript:reload();">초기화</a></span>
     </div>
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<!-- 비교견적서 변수-->
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" name="file_get_y" id="file_get_y"         value="">
			<input type="hidden" name="rowi" id="rowi"               value="">
		
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption>신규상품 견적의뢰</caption>
					<colgroup>
						<col width="8%" />
						<col width="12%" />
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup>
					
					<tbody>
					<tr >
						<td >의뢰자</td>
						<td ><label>: ${sessionInfo.userNameLoc}</label></td>
						<td >이메일</td>
						<td ><input type="text"  id="st_btoa_user_mail" name="st_btoa_user_mail"  style="width:90%" value="${sessionInfo.email}"></td>
						<td >연락처</td>
						<td ><input type="text" id="st_btoa_user_tel" name="st_btoa_user_tel"  style="width:90%" value="${sessionInfo.tel}"></td>
						<td >팩스번호</td>
						<td ><input type="text" id="st_btoa_user_fax" name="st_btoa_user_fax"  style="width:90%;" value="${sessionInfo.fax}"></td>
					</tr>
				</tbody>
			</table>
		</div>
  		
  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
       	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option <%=(pg_row.equals("10")  ? "selected" : "")%> value = "10">10</option>
				<option <%=(pg_row.equals("20")  ? "selected" : "")%> value = "20">20</option>
				<option <%=(pg_row.equals("30")  ? "selected" : "")%> value = "30">30</option>
				<option <%=(pg_row.equals("40")  ? "selected" : "")%> value = "40">40</option>
				<option <%=(pg_row.equals("50")  ? "selected" : "")%> value = "50">50</option>
				<option <%=(pg_row.equals("100") ? "selected" : "")%> value = "100">100</option>
				<option <%=(pg_row.equals("200") ? "selected" : "")%> value = "200">200</option>
				<option <%=(pg_row.equals("2000") ? "selected" : "")%> value = "2000">2000</option>
			</select>
       	</span>
        <span class="fr">
       총건수 <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       </span>
 
	</form> 
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<table id="table_list" class="cont_t_list02" style="width:100%">
		<colgroup>
            <col width="5%" />
            <col width="10%" />
            <col width="25%" />
            <col width="15%" />
            <col width="7%" />
            <col width="11%" />
            <col width="12%" />
            <col width="15%" />
        </colgroup>
        <thead>
			<tr >
				<th rowspan="2" > 
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
				</th> 
				<th>제품번호</th>
				<th rowspan="2">품목명/규격</th>
				<th rowspan="2"><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;">등록요청일</font></a></th>  
				<th>단위</th>
				<th>제조사</th>
				<th>원산지</th>
				<th>기존협력사</th>
			</tr>
			<tr >
				<th ><font color="#FF6600">*</font>수량</th>
				<th >첨부파일</th>
				<th  colspan="3" style="text-decoration:underline;"><a href="javascript:remarkCopy();">비고</a></th>
			</tr> 
		</thead>
		<tbody>
 		<%
        if (_dataList == null || _dataList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
        	
        	String aaa=null;
            String tclass = "";
            
			for (int j=0; j<_dataList.size(); j++) {
				Map<String,String> rowData = _dataList.get(j);
				
		%> 
				 <tr> 
					<td rowspan ="2">
						<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
						<input type="hidden" name="st_buyer2" id="st_buyer2"              value="<%=rowData.get("BUYER")%>">
						<input type="hidden" name='st_rav_no' id="st_rav_no"  value="<%=rowData.get("RAV_NO")%>">
						<input type="hidden" name='st_rav_seq' id="st_rav_seq" value="<%=rowData.get("RAV_SEQ")%>">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
						<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
						<input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}">
						<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department}">
						<input type="hidden" name="st_btoa_user_mail2" id="st_btoa_user_mail2" value="${sessionInfo.email}">
						<input type="hidden" id="st_btoa_user_tel2" name="st_btoa_user_tel2" value="${sessionInfo.tel}" >
						<input type="hidden" id="st_btoa_user_fax2" name="st_btoa_user_fax2" value="${sessionInfo.fax}">
						
					</td>
					<td align='center'><input type="text" name='st_buyer_item_no' id="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>" readonly style="border:0;"></td>
					<td class="left">
						<input type="text" name='st_description' id="st_description"  value="<%=rowData.get("DESCRIPTION")%>" readonly style="border:0">
					</td>
					<td align='center' rowspan="2">
<%-- 		 				<input type="text" name="st_btoa_end_date" id="st_btoa_end_date" readOnly style="width:70%; text-align:center;" value="<%=rowData.get("MAKER_NAME")%>"> --%>
		 				<input type="text" name='st_btoa_end_date_text' id="st_btoa_end_date_text" value="<%=rowData.get("BTOA_EDT_DATE")%>" onclick="doPop('calendar','<%=j%>');" readonly style="width:70%; text-align:center;">
						<input type="hidden" name='st_btoa_end_date' id="st_btoa_end_date" value="<%=rowData.get("BTOA_ED_DATE")%>">
		 				<input type="hidden" name='st_buyer_target_price' id="st_buyer_target_price">
						<input type="hidden" name='st_buyer_target_price_text' id="st_buyer_target_price_text">
					</td>
					<td align='center'><select id="st_unit_measure" name="st_unit_measure" disabled="disabled"><%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo",rowData.get("UNIT_MEASURE"))%></select></td>
					<td align='center'>
						<input type="text" name='st_maker_name' id="st_maker_name" maxlength="40"   value="<%=rowData.get("MAKER_NAME")%>" readonly style="border:0"> 
					</td>
					<td align='center'>
						<input type="hidden" name="st_origin_code" id="st_origin_code" style="width:85%;" value="<%=rowData.get("ORIGIN_CODE")%>">
						<input type="text" name="st_origin_name" id="st_origin_name" maxlength="20"  value="<%=rowData.get("ORIGIN_NAME")%>" readonly style="border:0"> 
					</td>
					<td align='center'>
						<input type="text" name='st_agent_name' id="st_agent_name" style="width:95%;"  >
					</td> 
				</tr>
				<tr> 
					<td class='right'>
						<input type="hidden" name='st_item_qty' id="st_item_qty" style="width:95%;" value = "1">1
						<input type="hidden" name='st_item_qty_text' id="st_item_qty_text" value = "1">
					</td>
					<td class="left">
						<input type="text" name="st_specification" id="st_specification" value="<%=rowData.get("SPECIFICATION")%>" readonly style="border:0">
					</td>
					<td align='center'>
						<input type='hidden' name='st_image_key' id="st_image_key" value=''>
						<a class="hyperLink" href="javascript:doPop('attach', '<%=j%>');"><img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0"></a>
					</td>
					 <td colspan='3'>
						<input type="text" name='st_btoa_remark' ID="st_btoa_remark" maxlength="400"  style="width:99%;">
					 </td>  
				</tr>  
		

            <%
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
				<span class="btn_02 mr04">
					<a href="javascript:doAction('del')">삭제</a>
				</span>
            </div>
            <div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('reg');">신청품의</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="gubun" id="gubun" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var btnEvent = "";  
var gridIndex = 0;  
var popupSel = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
/*
 *  최초 화면 함수
 */
function kep_onload_view(){

}	

//기능함수
function doAction(str) {
	btnEvent = str;
	st = new Date();
	switch (str) {
	case "search":
		kepSearch($("#curPage").val());
		break;
	case "reg":
		$('#st_btoa_user_mail2').val($('#st_btoa_user_mail').val());
		$('#st_btoa_user_tel2').val($('#st_btoa_user_tel').val());
		$('#st_btoa_user_fax2').val($('#st_btoa_user_fax').val());
		
		if(setGridData(btnEvent)){
			kepAjaxFormCall("/mprq/saveBuyerMpRqRequestForQuotation.do","processForm",btnEvent); 
		}
		break;
	case "del":
		if(setGridData(btnEvent)){
			if(!confirm("삭제 하시겠습니까?")) return;
			kepAjaxFormCall("/mprq/delReqQuotation.do","processForm",btnEvent); 
		}
		break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqRequestForQuotation.do").submit();   
}

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload('searchForm');
// 	kepReload("searchForm");
// 	$('#searchForm').attr("action", "/mprq/showBuyerMpRqRequestForQuotation.do").submit();
	$("#st_btoa_user_mail").val('${sessionInfo.email}');
	$("#st_btoa_user_tel").val('${sessionInfo.tel}');
	$("#st_btoa_user_fax").val('${sessionInfo.fax}');
	$('#st_total_cnt').val('0');
	jspTableClean("table_list");
}

//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	gridIndex = value1;
	switch (str) {
	case "calendar": // 달력
		openSearchPopup('/common/calendarPop.do','','130,240,no');
		break;
	case "attach"://파일 첨부
		var type="RFQ";
		var viewType="VI";
		var image_key =  $("input[name=st_image_key]").eq(gridIndex).val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}

function setPopupCalendar(year,month,day){
	var dt = year+month+day;
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    
    if(parseInt(dt) < parseInt(nowDate)) {
        alert("등록요청일은 현재일 이후여야 합니다.");
        return;
    }
    
	$("input[name=st_btoa_end_date_text]").eq(gridIndex).val(year+'/'+month+'/'+day);
	$("input[name=st_btoa_end_date]").eq(gridIndex).val(dt);
	
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	 if(popupSel == "attach") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}

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
 //비고 복사.
function remarkCopy() {
	var tot_cnt = $("#display_item_cnt").val(); 
	var btoa_remark         = "";
	var checked_count       = 0;

	if(tot_cnt>1) {
		for(var j = 0; j < tot_cnt; j++) { 
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				checked_count++;
				btoa_remark =  document.forms.contentForm.st_btoa_remark[j].value;
				break;
			}
		}
	}else {
		alert("견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.");
		return;
	}
	if(checked_count==0) {
		alert("복사할 비고를 선택하여 주십시요.");
		return;
	}

	if(tot_cnt>=2) {
		
		for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				document.forms.contentForm.st_btoa_remark[j].value = btoa_remark;
			}else {
				document.forms.contentForm.st_btoa_remark[j].value = "";
			}
		}

	}
}
//등록요청일 복사
function btoaDateCopy() {
	var tot_cnt = $("#display_item_cnt").val(); 
	var btoa_end_date_text  = "";
	var btoa_end_date       = "";
	var checked_count       = 0;

	if(tot_cnt>1) {
		for(var j = 0; j < tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				checked_count++;
				btoa_end_date   =  document.forms.contentForm.st_btoa_end_date[j].value;
				btoa_end_date_text   =  document.forms.contentForm.st_btoa_end_date_text[j].value;
				break;
			}
		}
	}else {
		alert("견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.");
		return;
	}

	if(checked_count==0) {
		alert("등록요청일을 복사할 품목을 선택하여 주십시요.");
		return;
	}

	if(tot_cnt>=2) {
		for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				document.forms.contentForm.st_btoa_end_date[j].value         = btoa_end_date;
				document.forms.contentForm.st_btoa_end_date_text[j].value         = btoa_end_date_text;
			}else {
				document.forms.contentForm.st_btoa_end_date[j].value         = "";
				document.forms.contentForm.st_btoa_end_date_text[j].value         = "";
			}
		}
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

//선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkFlag = false;
	var tot_cnt = $("#display_item_cnt").val(); 
	var checked_count = getCheckedRowCount(tot_cnt);

	if(tot_cnt == 0){
   		alert("품목이 없습니다.");
   		return;
	}
	
	if(checked_count == 0 && btnEvent == "del"){
  		alert("선택하신 품목이 없습니다.");
  		return;
   	}
	
	if (btnEvent == "reg"){ // 신청품의
		if(checked_count == 0) {
			alert("견적의뢰할 품목을 선택하여 주십시요.");
			return;
		}
	
		if($('#st_buyer').val() != 'KRDONG0109' && checked_count > 1) {
			alert("한품목씩만 의뢰가능 합니다.\n\n확인 바랍니다.");
			return;
		}
		
  	    var box = "";
  	    if (tot_cnt < 2) {
  	    	box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
 				var btoa_end_date = document.forms.contentForm.st_btoa_end_date.value;

 				// 등록요청일 체크
 				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
 					alert((k+1)+"번째 행의 등록요청일을 입력하여 주십시오..");
 					return;
 				}
 				
 				if(parseInt(btoa_end_date) < parseInt(kepGetNowTimeStr('YYYYMMDD',''))) {
 					alert("등록요청일은 현재일 이후여야 합니다.");
 					return;
 				}
 			}
  	    } else {
  	    
  	        for(var k = 0; k < tot_cnt; k++){
  	        	box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
	 				var btoa_end_date = document.forms.contentForm.st_btoa_end_date[k].value;

	 				// 등록요청일 체크
	 				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	 					alert((k+1)+"번째 행의 등록요청일을 입력하여 주십시오..");
	 					return;
	 				}
	 				
	 				if(parseInt(btoa_end_date) < parseInt(kepGetNowTimeStr('YYYYMMDD',''))) {
	 					alert("등록요청일은 현재일 이후여야 합니다.");
	 					return;
	 				}
	 			}
  	        
  	        }
  	    }   
  	}
	var chkGridValue = {};
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if (btnEvent == "del"){ // 삭제
		var msg = response.msg;   
		if (msg != ""){
			alert(msg);
			kepSearch($("#curPage").val());
		}
	} else if (btnEvent == "reg"){ // 신청품의
<%-- 		var buyer = "<%=com_code%>"; --%>
// 		var type = "NG";
// 		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
			var type = "NG"; // 견적의뢰
			var buyer = "<%=com_code%>";
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		} else if (passFlag == "C"){
			if (!confirm("전자 결재 처리 하시겠습니까? \n\n바로 견적의뢰 하시려면 취소버튼을 눌러 주십시오.")){
				// 바로생성	
				btnEvent = "noPassReq";
				kepAjaxFormCall("/mprq/saveBuyerMpRqRequestForQuotationNoPassReq.do","processForm",btnEvent); 
			} else {
				// 결재 연결
				btnEvent = "passReq";
				kepAjaxFormCall("/mprq/saveBuyerMpRqRequestForQuotationPassReq.do","processForm",btnEvent); 
			}
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				alert(msg);
			}
			kepSearch($("#curPage").val());
		}

	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			alert(msg);
		}
		kepSearch($("#curPage").val());
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=com_code%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (btnEvent == "reg"){ // 신청품의
		alert("견적생성에 실패하였습니다.\n\n관리자에게 문의하여 주시기 바랍니다.");
	} else {
		alert("삭제가  실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
} 
function kepApprovalReturn(flag,docu_no){
	kepSearch($("#curPage").val());
}
</script>
</html>
