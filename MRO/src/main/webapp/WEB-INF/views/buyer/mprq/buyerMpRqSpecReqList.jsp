<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품규격의뢰
* 기능 : 고객사의 견적의뢰를 조회하거나 피드백 하는 기능(예)
* 프로그램 ID : PG_04_B_001_00
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
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String st_fb_flag = CommonUtil.nvl((String) request.getParameter("st_fb_flag"),"");  // 상태페이지 (조회조건)
String st_ser_rav_no = CommonUtil.nvl((String) request.getParameter("st_ser_rav_no"),"");  // 접수번호 (조회조건)
String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
%>

<body onload="kep_onload_view();">
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
        	<h3>신규상품 규격의뢰</h3>
            
		 <form name = "contentForm" method = "post">
			 <input type="hidden" name="st_row" value="">
			 <input type="hidden" name="st_query" value="">
			 <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
				 
            	<!--grid-->
                <table  class="cont_t_list02" style="width:100%;">
                    <caption>리스트</caption>
                    <colgroup>
                        <col width="5%" />
                        <col width="20%" />
                        <col width="20%" />
                        <col width="20%" />
                        <col width="10%" />
                        <col width="10%" />
                        <col width="10%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">
								<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
							</th>
                            <th scope="col">품목명</th>
                            <th scope="col">규격</th>
                            <th scope="col">제조사</th>
                            <th scope="col">단위</th>
                            <th scope="col">비고</th>
                            <th scope="col">첨부</th>
<!--                             <th scope="col"></th> -->
                        </tr>                
                    </thead>
                    <tbody id="d_tbody" >
			            <tr>
							<td>
								<input type="checkbox" name="checkbox" id="checkbox">
								<input type='hidden' name='st_item_no'  value='NO_CODE'>
							</td>
							<td><input type='text' id="st_description" name='st_description'  value=''  required="품목명"  ></td>
							<td><input type='text' id="st_specification" name='st_specification' style='width:95%' value='' required="규격"></td>
							<td><input type='text' id="st_maker" name='st_maker'  value='' required="제조사"></td>
							<td><select id="st_unit" name="st_unit"><%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo","")%></select></td>
							<td class="1234"><input type='hidden' id="st_remark" name='st_remark' value=''><a class="hyperLink" href="#" onclick="javascript:doPop('remark',this);"><img id='st_remark_img' src='/resources/images/but_icon02.gif' border='0'></a></td>
							<td><input type='hidden' id="st_image_key" name='st_image_key' value=''><a class="hyperLink" href="#" onclick="javascript:doPop('attach',this)"><img id='st_image_key_img' src='/resources/images/disk_off.gif' border='0'></a></td>
<!-- 			                <td><a href="#" id="row_delete"  onclick="javascript:doAction('delrow', this)">행삭제</a></td> -->
			            </tr>
                    </tbody>
                </table>
                <!--버튼영역-->
                <div class="btnArea"> 
                	<span class="fr">
						<span class="btn_02 mr04"><a href="#" id="rowAdd"  onclick="javascript:doAction('addrow')">행추가</a></span>
						<span class="btn_02 mr04"><a href="#" id="rowDel"  onclick="javascript:doAction('delrow')">행삭제</a></span>
						<span class="btn_02"><a href="#" id="specReq"  onclick="javascript:doAction('save')">규격의뢰</a></span>
					</span>
				 </div>
		 	</form>
      </div>    
                
    
	<form name="processForm"  id="processForm"  method="post">	
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="buyer" id="buyer" value="">
		<input type="hidden" name="gubun" id="gubun" value="" />
		<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
		<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
		<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
		<input type="hidden" name="st_fb_flag" id="st_fb_flag"  value="<%=st_fb_flag %>"/>
		<input type="hidden" name="st_ser_rav_no" id="st_ser_rav_no"  value="<%=st_ser_rav_no %>"/>
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
		<div id="process">
		</div>
	</form>
    
    
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>    
</body>


<script type="text/javascript">
var popupSel = "";
var grbRow = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

function kep_onload_view(){
}

//기능함수
function doAction(str, obj) {
	st = new Date();
	switch (str) {
	case "addrow":
		rowAdd(obj);
		break;
	case "delrow":
		row_delete(obj);
		break;
	case "save":
		kepSave();
		break;
	}

}


function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $('#d_tbody tr').size(); 
	var box = eval("document.forms.contentForm.check_status");
 
	if(box.checked == true) {

		if(eval(tot_cnt) < 2){
	    	var box = eval("document.forms.contentForm.checkbox");
	    	box.checked = true;
	    }else{
		    for(var j = 0; j < tot_cnt; j++){
		         var box = eval("document.forms.contentForm.checkbox[" + j+"]");
		         box.checked = true;
	        }
	    }
	}else{
		if(eval(tot_cnt) < 2){
	    	var box = eval("document.forms.contentForm.checkbox");
	    	box.checked = false;
	    }else{
		    for(var j = 0; j < tot_cnt; j++){
		         var box = eval("document.forms.contentForm.checkbox[" + j+"]");
		         box.checked = false;
	        }
	    }
	}
}

//행추가함수
function rowAdd(obj) {
    $add_html = $('#d_tbody tr:last').clone();
    $('#d_tbody').append($add_html); 
}


//삭제함수
function row_delete(obj) {
//     if($('#d_tbody tr').size() > 1){
// 		if(!confirm("삭제 하시겠습니까?")){ 
// 			return;
// 		} 
//         $(obj).parent().parent().remove();
//     }
//     else {
//         alert('모든 데이타를 삭제할실수 없습니다.\n\n확인 바랍니다.');
//         return false;
//     }

	var tot_cnt      = $('#d_tbody tr').size(); 
	var cnt = 0;
	
	if(eval(tot_cnt) < 2){
    	var box = eval("document.forms.contentForm.checkbox");
    	if (box.checked == true){
    		cnt = cnt + 1;
    	}
    }else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox[" + j+"]");
	         if (box.checked == true){
	        	 cnt = cnt + 1;
	     	}
        }
    }
	
	if (cnt == 0) { alert("대상을 선택하세요"); return; }
	if (tot_cnt == cnt){
		alert('모든 데이타를 삭제할실수 없습니다.\n\n확인 바랍니다.');
      	return; 
	}
	
   	$("#d_tbody input:checked").parent().parent().remove();
	
}

//초기화
function row_init(obj) {
	$('#d_tbody tr:not(:first)').remove(); 
}


/*
 * 규격의뢰
 */
function kepSave(){
	var btnEvent = "specReqCheck";
	
	if(setGridData(btnEvent)){
		if(!confirm("규격의뢰 하시겠습니까?")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/saveBuyerMpRqSpecReq.do","processForm",btnEvent); 
	}
}



/* 선택된 그리드 값을 셋팅 */
function setGridData(btnEvent){
	var returnValue = true;
	
	var tot_cnt      = $('#d_tbody tr').size(); 
	var cnt = 0;
	
	if(eval(tot_cnt) < 2){
    	var box = eval("document.forms.contentForm.checkbox");
    	if (box.checked == true){
    		cnt = 1;
    	}
    }else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox[" + j+"]");
	         if (box.checked == true){
	        	 cnt = 1;
	     	}
        }
    }
	
	if (cnt == 0) { alert("대상을 선택하세요"); return; }
	
	
	if(eval(tot_cnt) < 2){
    	var box = eval("document.forms.contentForm.checkbox");
    	if (box.checked == true){ 
    		
    		if (document.forms.contentForm.st_unit.options[document.forms.contentForm.st_unit.selectedIndex].value == ""){
    			alert("단위를 선택하세요.");
    			return;
    		}
    	}
    }else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox[" + j+"]");
	     	if (box.checked == true){
	     		if (document.forms.contentForm.st_unit[j].options[document.forms.contentForm.st_unit[j].selectedIndex].value == ""){
	     			alert("단위를 선택하세요.");
	    			return;
	     		}
	    	}
        }
    }
	
	var chkGridValue = {
			keys : ["st_description"] ,
			value0 : "AA",
			msg0 : "품목명이 AA의 경우에는 규격의뢰할수 없습니다."
	}; 
	var formArr = getFormToArr("document.forms.contentForm",true,chkGridValue);
	if(formArr != null && formArr !=""){
		//alert(eval(document.forms.processForm));
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	} else{
// 		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}



/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert(msg);
	}
	location.reload();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("규격의뢰에 실패하였습니다.");
	
} 

//팝업함수호출
var gridIndex = 0;
function doPop(str, obj) { 
	 
	popupSel = str ;
	grbRow = obj;
	gridIndex = $(grbRow).parent().parent().index();    
	
	switch (str) {
	case "remark"://고객사 비고
		var btoaRemark =  $("input[name=st_remark]").eq(gridIndex).val();
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+btoaRemark, "500,230,no");  // 고객사 비고
		
		break;
	case "attach"://파일 첨부
		var type="RFQ";
		var viewType="VI";
		var imageKey =  $("input[name=st_image_key]").eq(gridIndex).val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+imageKey+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}

	   
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	 if(popupSel == "remark") {	//고객사 비고
		 $("input[name=st_remark]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
		 
	}else if(popupSel == "attach") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value2 =="on"){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }
	}

}

</script>
</html>
