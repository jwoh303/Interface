<%--
**********************************************
* 메뉴 : wms>반품
* 화면 : 반품입력 중 접수번호가 있는 경우(반품조치)
* 기능 : 
* 프로그램 ID : PG_08_M_019_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-8-6
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String buyer = "";
	String userid = "";
	
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	
	String st_WMRE_TYPE = CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE"),"");
	String st_PROCESS_TYPE = CommonUtil.nvl((String) request.getParameter("st_PROCESS_TYPE"),"");
	
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	String st_B_REQ_DATE = "";
	String st_M_REC_FLAG = "";
	String st_S_REC_DATE = "";
	String st_S_PRT_DATE = "";
	String st_W_GR_DATE = "";
	String st_W_RIV_DATE = "";
	String st_W_IVK_DATE = "";
	String st_S_GR_DATE = "";
	String st_W_CHGR_DATE = "";
	String st_W_CHDELI_DATE = "";
	String st_S_CHDELI_DATE = "";
	String st_M_CLOSE_DATE = "";
	String st_END_DATE = "";
	
	
	
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);

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
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var varCheckFlag = true;

var st;
var mt;
var temp;
function popupOnload(){
	
	<% if("19".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") )  || "13".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") ) ) { %>
	if(document.getElementById('st_end_flag') != null  ){
		$('#st_end_flag').attr("disabled",true);
	}
	
	if( document.getElementById('st_s_gr_flag') != null  ){ 

		$('#st_s_gr_flag').attr("disabled",true);           
		$('#st_s_gr_remark').attr("readonly",true);   
	}
	
	if( document.getElementById('st_s_chdeli_flag') != null  ){  

		$('#st_s_chdeli_flag').attr("disabled",true);       
		$('#st_s_chdeli_remark').attr("readonly",true);     
	}
	

	if( document.getElementById('st_s_rec_flag') != null  ){ 
		$('#st_s_rec_flag').attr("disabled",true); 
		$('#st_s_rec_remark').prop("readonly",true); 
	}

	$('#st_s_rec_remark').prop("readonly",true); 
	$('#st_m_rec_remark').prop("readonly",true); 
	$('#st_b_req_remark').prop("readonly",true); 
	$('#st_cancel_remark').prop("readonly",true); 
	$('#st_w_gr_qty').prop("readonly",true);
<%} %>	
	
/**
	kepSetCalender("st_b_req_date");
	kepSetCalender("st_m_rec_date");
	kepSetCalender("st_s_rec_date");
	kepSetCalender("st_s_prt_date");
	kepSetCalender("st_w_gr_date");
	kepSetCalender("st_w_riv_date");
	kepSetCalender("st_w_ivk_date");
	kepSetCalender("st_s_gr_date");
	kepSetCalender("st_w_chgr_date");
	kepSetCalender("st_w_chdeli_date");
	kepSetCalender("st_s_chdeli_date");
	kepSetCalender("st_m_close_date");
	kepSetCalender("st_end_date");
*/
	//출고 구분이 '0'(직납)
	if('0' ==$("#st_PROCESS_TYPE").val() ){
		//물류센터 회수 정보 
		$("#st_w_gr_flag").attr('disabled',true);
		$("#st_w_gr_qty").attr('disabled',true);
		$("#st_w_gr_date").attr('disabled',true);
		$("#st_w_gr_user_id").attr('disabled',true);
		$("#st_w_gr_remark").attr('disabled',true);		
		//    물류센터 반출정보 
		$("#st_w_riv_flag").attr('disabled',true);
		$("#st_w_riv_date").attr('disabled',true);
		$("#st_w_riv_user_id").attr('disabled',true);
		$("#st_w_riv_remark").attr('disabled',true);		
		
		//물류센터 출고정보 
		$("#st_w_ivk_flag").attr('disabled',true);
		$("#st_w_ivk_type").attr('disabled',true);
		$("#st_w_ivk_date").attr('disabled',true);
		$("#st_w_ivk_user_id").attr('disabled',true);		
		$("#st_w_ivk_remark").attr('disabled',true);	
		
		//물류센터 교환입고 
		$("#st_w_chgr_flag").attr('disabled',true);
		$("#st_w_chgr_date").attr('disabled',true);
		$("#st_w_chgr_user_id").attr('disabled',true);
		$("#st_w_chgr_remark").attr('disabled',true);		
		
		//물류센터 교환납품
		$("#st_w_chdeli_flag").attr('disabled',true);
		$("#st_w_chdeli_date").attr('disabled',true);
		$("#st_w_chdeli_user_id").attr('disabled',true);
		$("#st_w_chdeli_remark").attr('disabled',true);		
	
	}		
	
	//반품유형 '01' 반품
	if('01' ==$("#st_WMRE_TYPE").val() ){
	
		//물류센터 교환입고
		$("#st_w_chgr_flag").attr('disabled',true);
		$("#st_w_chgr_date").attr('disabled',true);
		$("#st_w_chgr_user_id").attr('disabled',true);
		$("#st_w_chgr_remark").attr('disabled',true);
		//물류센터교환납품
		$("#st_w_chdeli_flag").attr('disabled',true);
		$("#st_w_chdeli_date").attr('disabled',true);
		$("#st_w_chdeli_user_id").attr('disabled',true);
		$("#st_w_chdeli_remark").attr('disabled',true);
		
		//협력사 교환납품 
		$("#st_s_chdeli_flag").attr('disabled',true);
		$("#st_s_chdeli_date").attr('disabled',true);
		$("#st_s_chdeli_user_id").attr('disabled',true);
		$("#st_s_chdeli_remark").attr('disabled',true);

	}
	
}


function flagMng(){
	
	if(document.getElementById('st_end_flag') != null && $("input:checked[id='st_end_flag']").is(":checked") ){
		
		if( document.getElementById('st_s_chdeli_flag') != null && !$("input:checked[id='st_s_chdeli_flag']").is(":checked") ){ //협력사 교환 납품 
			$('#st_s_chdeli_flag').prop('checked',true);
			checkFlag('st_s_chdeli_flag');
		}
		
		
		if( document.getElementById('st_s_gr_flag') != null &&  !$("input:checked[id='st_s_gr_flag']").is(":checked") ){    //협력사 입고

			$('#st_s_gr_flag').prop('checked',true);
			checkFlag('st_s_gr_flag');
		}
		
		if( document.getElementById('st_s_rec_flag') != null &&  !$("input:checked[id='st_s_rec_flag']").is(":checked") ){    //협력사 입고

			$('#st_s_rec_flag').prop('checked',true);
			checkFlag('st_s_rec_flag');
		}
		
	}
	
	if(document.getElementById('st_s_chdeli_flag') != null && $("input:checked[id='st_s_chdeli_flag']").is(":checked") ){
		
		if( document.getElementById('st_s_gr_flag') != null &&  !$("input:checked[id='st_s_gr_flag']").is(":checked") ){    //협력사 입고

			$('#st_s_gr_flag').prop('checked',true);
			checkFlag('st_s_gr_flag');
		}
		
		if( document.getElementById('st_s_rec_flag') != null &&  !$("input:checked[id='st_s_rec_flag']").is(":checked") ){    //협력사 입고

			$('#st_s_rec_flag').prop('checked',true);
			checkFlag('st_s_rec_flag');
		}
		
	}
	
	if(document.getElementById('st_s_gr_flag') != null && $("input:checked[id='st_s_gr_flag']").is(":checked") ){
		
		if( document.getElementById('st_s_rec_flag') != null &&  !$("input:checked[id='st_s_rec_flag']").is(":checked") ){    //협력사 입고

			$('#st_s_rec_flag').prop('checked',true);
			checkFlag('st_s_rec_flag');
		}
		
	}
	
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "save":

			
		
			if($("input:checked").length== 0){
				alert('선택 된 항목이 없습니다.');
				return;
			}
			if( $("input:checked[id='st_w_gr_flag']").is(":checked")   ){
				
				if($('#st_w_gr_qty').val()==''){
					
					alert('수량을 입력 하세요 ');
					$('#st_w_gr_qty').focus();
					return;
				}
				if(eval($('#st_item_qty').val().replace(/,/gi,""))  < eval($('#st_w_gr_qty').val().replace(/,/gi,"") )){
					alert('발주수량('+$('#st_item_qty').val()+') 보다 \n입력한 물류센터 회수 수량('+$('#st_w_gr_qty').val()+')이 더 큽니다.');
					$('#st_w_gr_qty').val('');
					$('#st_w_gr_qty').focus();
					return;
				}
			}
			if( $("input:checked[id='st_w_riv_flag']").is(":checked")   ){
				if($('#st_w_ivk_type').val() ==''){
					
					alert('출고 방법을 선택 하세요 .');
					$('#st_w_ivk_type').focus();
					return;
				}
			}
			if( $("input:checked[id='st_cancel_flag']").is(":checked")   ){
				if($('#st_cancel_remark').val() ==''){
					alert('취소 사유를 입력  하세요 .');
					$('#st_cancel_remark').focus();
					return;
					
				}
			}
			flagMng();
			//alert(varCheckFlag);
			if(varCheckFlag){
			    if(!confirm("반품조치등록을 하시겠습니까?  ")) {
			        return;
			    }else{
			       kepAjaxFormCall("/wmre/saveMasterWmReReturnWmNoPop.do","searchCondition","save"); 	   
			    }  
			}

		    
			break;
		
		case "printAgent":
			<% if(!"19".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") )  && !"13".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") ) ) { %>
	    	  var fileName = "RD_08_M_006_71";
	    	  var param =  "["+$('#st_WMRE_NO').val()+"]";
	    	  reportOpen(fileName,param);
	    	  <%}%>
			break;
		case "printWare":
			<% if(!"19".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") )  && !"13".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") ) ) { %>
	    	  var fileName = "RD_08_M_006_70";
	    	  var param =  "["+$('#st_WMRE_NO').val()+"]";
	    	  reportOpen(fileName,param);
	    	 <%}%>
			break;
		case "printReturn":
			<% if(!"19".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") )  && !"13".equals(  CommonUtil.nvl((String) request.getParameter("st_flag"),"") ) ) { %>
	    	  var fileName = "RD_08_M_006_66";
	    	  var param =  "["+$('#st_WMRE_NO').val()+"]";
	    	  reportOpen(fileName,param);
	    	  <%}%>
			break;				
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "save"){ 
		 alert("반품조치등록에 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var result = response.msg.MSG;  
	
	if(result=="Ok"){
		alert("정상적으로 저장 되었습니다.");
		opener.doAction('search');
		this.close();

	}else{
		alert(result);
		return;
	}
}



//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {

	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	
	grbRow="";	//초기화
}


function checkFlag(thisid){
	
	var div1 = thisid+"_1";
	var div2 = thisid+"_2";
	<% if(   "2".equals( st_PROCESS_TYPE)   ) { %>				
	if(thisid == 'st_s_gr_flag'){
		if( !$("input:checked[id='st_w_gr_flag']").is(":checked")  ){
			alert("물류센터 회수가 아직 되지 않은 상태 입니다.");
			$('#st_s_gr_flag').prop('checked',false);
			varCheckFlag = false;
			return;
		}
		
		if(!$("input:checked[id='st_w_riv_flag']").is(":checked")){
			alert("물류센터 반출이 아직 되지 않은 상태 입니다.");
			$('#st_s_gr_flag').prop('checked',false);
			varCheckFlag = false;
			return;
		}
	}
	<%}%>
	
	if( $("input:checked[id='"+thisid+"']").is(":checked")   ){
	
		document.getElementById(div1).style.display = "block"; 
		document.getElementById(div2).style.display = "block"; 

	}
	else
	{
		document.getElementById(div1).style.display = "none"; 
		document.getElementById(div2).style.display = "none"; 
	}

}	


</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_PROCESS_TYPE"  name="st_PROCESS_TYPE" value="<%=CommonUtil.nvl((String) request.getParameter("st_PROCESS_TYPE"),"") %>">	
	<input type="hidden" id="st_WMRE_TYPE"  name="st_WMRE_TYPE" value="<%=CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE"),"") %>" >	
	<input type="hidden" id="st_WMRE_NO"  name="st_WMRE_NO" value="<%=CommonUtil.nvl((String) request.getParameter("st_WMRE_NO"),"") %>">		
	<input type="hidden" id="st_item_qty"  name="st_item_qty" value="<%=CommonUtil.nvl((String) request.getParameter("st_item_qty"),"") %>">	
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonUtil.nvl((String) request.getParameter("st_PROCESS_TYPE_NM"),"") %>/<%=CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE_NAME"),"") %>조치등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:463px">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list03" style="width:100%">
						<caption>조회</caption>
						<colgroup>
                        <col width="15%" />
                        <col width="10%" /> 
                        <col width="12%" /> 
                        <col width="12%" />
                        <col width="18%" />
                         <col width="*" />                                    
						</colgroup>
                    <thead>
                        <tr>
                            <th scope="col"></th>
                            <th scope="col">처리여부</th>
                            <th scope="col"></th>
                            <th scope="col">처리자</th>
                            <th scope="col">일자</th>
                            <th scope="col">비고</th>
                        </tr>
                    </thead>
						<tbody>
						<tr>
                            <td class="al">&nbsp;고객사 요청</td>
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("B_REQ_FLAG")) )) { %>
                            	<td><input type="checkbox"  name="st_b_req_flag_fake" id="st_b_req_flag_fake"  value="01" checked disabled  />
                            	<div style="display:none;"><input type="checkbox"  name="st_b_req_flag" id="st_b_req_flag_fake"  value="01" checked ></div>
                            	</td>
                            	 <td></td>
                            	<td><%=CommonUtil.nvl(_rowData.get("B_REQ_USER_NAME")) %></td>
                            	 <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("B_REQ_DATE")))? "":CommonUtil.formatStrinigDate(_rowData.get("B_REQ_DATE"))   %>	</td>
                            <%}else{ %>
                    			<td><input type="checkbox"  name="st_b_req_flag" id="st_b_req_flag"  value="01"  onclick="javascript:checkFlag(this.id);"></td>
    							<td></td>
    							<td><div style="display:none;" id="st_b_req_flag_1">${sessionInfo.userNameLoc} <input type="hidden"  name="st_B_REQ_USER_ID" id="st_B_REQ_USER_ID"   value="${sessionInfo.userId}"  /></div></td>
    							<td><div style="display:none;" id="st_b_req_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %><input type="hidden"  name="st_B_REQ_DATE" id="st_B_REQ_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>
                    		<%} %>
                             <td><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("B_REQ_REMARK")) %>"   /></td>
						 </tr>
						<tr>
                            <td class="al">&nbsp;운영사 접수</td>
                            
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("M_REC_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_m_rec_flag_fake"" id="st_m_rec_flag_fake" value="02" checked disabled  >
                             <div style="display:none;"><input type="checkbox" name="st_m_rec_flag" id="st_m_rec_flag" value="02" checked></div>
                             </td>
                             <td></td>
                             <td><%=CommonUtil.nvl(_rowData.get("M_REC_USER_NAME")) %></td>
                             <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("M_REC_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("M_REC_DATE"))  %></td>                       
                            <%}else{ %>
                              <td><input type="checkbox" name="st_m_rec_flag" id="st_m_rec_flag" value="02"   onclick="javascript:checkFlag(this.id);">
                                <td></td>
    							<td><div style="display:none;" id="st_m_rec_flag_1">${sessionInfo.userNameLoc} <input type="hidden"  name="st_M_REC_USER_ID" id="st_M_REC_USER_ID"   value="${sessionInfo.userId}"  /></div></td>
    							<td><div style="display:none;" id="st_m_rec_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %><input type="hidden"  name="st_M_REC_DATE" id="st_M_REC_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>
                            <%} %>       
                            <td><input type="text" name="st_m_rec_remark" id="st_m_rec_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("M_REC_REMARK")) %>" /></td>
						 </tr>
						 
			 
						<tr>
                            <td class="al">&nbsp;협력사 접수</td>
                           
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("S_REC_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_s_rec_flag_facke" id="st_s_rec_flag_facke" value="03" checked disabled>
                            		<div style="display:none;"> <input type="checkbox" name="st_s_rec_flag" id="st_s_rec_flag" value="03" checked ></div>
                            </td>
                            <td></td>
                            <td><%=CommonUtil.nvl(_rowData.get("S_REC_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("S_REC_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("S_REC_DATE"))%></td>                       
                             <%}else{ %>
                            	<td><input type="checkbox" name="st_s_rec_flag" id="st_s_rec_flag" value="03" onclick="javascript:checkFlag(this.id);"></td>
                                <td></td>
    							<td><div style="display:none;" id="st_s_rec_flag_1"   name="st_s_rec_flag_1">${sessionInfo.userNameLoc}<input type="hidden"  name="st_S_REC_USER_ID"   id="st_S_REC_USER_ID"   value="${sessionInfo.userId}"  /></div></td>
    							<td><div style="display:none;" id="st_s_rec_flag_2"  name="st_s_rec_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %><input type="hidden"  name="st_S_REC_DATE" id="st_S_REC_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>                        
                            <%} %>
                            <td><input type="text" name="st_s_rec_remark" id="st_s_rec_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("S_REC_REMARK")) %>" /></td>
						 </tr>
						 
<% if(  ("01".equals( st_WMRE_TYPE) && "2".equals( st_PROCESS_TYPE) ) ||("02".equals( st_WMRE_TYPE) && "2".equals( st_PROCESS_TYPE) )  ) { %>						 
						<tr>
                            <td class="al">&nbsp;물류센터 회수 </td>
                           
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("W_GR_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_w_gr_flag_fake" id="st_w_gr_flag_fake"   value="05" checked disabled>
                            <div style="display:none;"> <input type="checkbox" name="st_w_gr_flag" id="st_w_gr_flag"   value="05" checked></div></td>
                            <td class="al">수량<br/><input type="text" name="st_w_gr_qty" id="st_w_gr_qty"  maxlength="15"   onkeyup="checkNumAddComma(this);"class="ar" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_GR_QTY")) %>"   readonly/></td>
                             <td><%=CommonUtil.nvl(_rowData.get("W_GR_USER_NAME")) %></td>		
                             <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("W_GR_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("W_GR_DATE"))%></td>
                            <%}else{ %>
                             <td><input type="checkbox" name="st_w_gr_flag" id="st_w_gr_flag"   value="05"  onclick="javascript:checkFlag(this.id);" disabled></td>
                             <td class="al">수량<br/><input type="text" name="st_w_gr_qty" id="st_w_gr_qty"  maxlength="15"   onkeyup="checkNumAddComma(this);"class="ar" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_GR_QTY")) %>"  disabled /></td>
    							<td><div style="display:none;" id="st_w_gr_flag_1"   name="st_w_gr_flag_1">${sessionInfo.userNameLoc} <input type="hidden"  name="st_W_GR_USER_ID" id="st_W_GR_USER_ID"   value="${sessionInfo.userId}"  /></div></td>
    							<td><div style="display:none;" id="st_w_gr_flag_2"  name="st_w_gr_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %><input type="hidden"  name="st_W_GR_DATE" id="st_W_GR_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>                                       
                             <%} %>
                            <td><input type="text" name="st_w_gr_remark" id="st_w_gr_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_GR_REMARK")) %>" readonly/></td>
						 </tr>			 

						<tr>
                            <td class="al">&nbsp;물류센터 반출</td>
                           
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("W_RIV_FLAG")) )) { %>
                             <td><input type="checkbox" name="st_w_riv_flag_fake" id="st_w_riv_flag_fake"  value="06" checked disabled>
                            		<div style="display:none;"><input type="checkbox" name="st_w_riv_flag" id="st_w_riv_flag"  value="06" checked></div>
                            </td>
                             <td class="al">
                             <span class="btn_05 mr04"><a href="javascript:doAction('printWare')">명세서 출력</a></span><br/>
                             출고방법<br/>
                             <select  name="st_w_ivk_type" id= "st_w_ivk_type" style="width:90%;height:20px"   disalbed>
                                                       getCodeComboQueryIdList(String queryId,String gubun,Map<String, String> search,String dataValue) 
							  <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM06","SEL",CommonUtil.nvl(_rowData.get("W_IVK_TYPE"))   ) %>
							</select></td>
                            <td><%=CommonUtil.nvl(_rowData.get("W_RIV_USER_NAME")) %></td>		
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("W_RIV_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("W_RIV_DATE"))%></td>
                             <%}else{ %>
                            <td><input type="checkbox" name="st_w_riv_flag" id="st_w_riv_flag"  value="06"  onclick="javascript:checkFlag(this.id);" disabled></td>
                             <td class="al">
                             <span class="btn_05 mr04"><a href="javascript:doAction('print')">명세서 출력</a></span><br/>
                             출고방법<br/>
                             <select  name="st_w_ivk_type" id= "st_w_ivk_type" style="width:90%;height:20px"  readonly>
                                                       getCodeComboQueryIdList(String queryId,String gubun,Map<String, String> search,String dataValue) 
							  <%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM06","SEL",CommonUtil.nvl(_rowData.get("W_IVK_TYPE"))   ) %>
							</select></td>
    							<td><div style="display:none;" id="st_w_riv_flag_1"   name="st_w_riv_flag_1">${sessionInfo.userNameLoc}</div><input type="hidden"  name="st_W_RIV_USER_ID" id="st_W_RIV_USER_ID"   value="${sessionInfo.userId}"  /></td>
    							<td><div style="display:none;" id="st_w_riv_flag_2"  name="st_w_riv_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %><input type="hidden"  name="st_W_RIV_DATE" id="st_W_RIV_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>                              
                            <%} %>
                            <td><input type="text" name="st_w_riv_remark" id="st_w_riv_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_RIV_REMARK")) %>"  readonly/></td>
						 </tr>	
						
<%} %>
 

						<tr>
                            <td class="al">&nbsp;협력사 입고</td>
                           
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("S_GR_FLAG")) )) { %>
                             <td><input type="checkbox" name="st_s_gr_flag_fake" id="st_s_gr_flag_fake"   value="08" checked disabled>
                            <div style="display:none;"><input type="checkbox" name="st_s_gr_flag" id="st_s_gr_flag"   value="08" checked></div></td>
                            <td></td>
                            <td><%=CommonUtil.nvl(_rowData.get("W_S_GR_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("S_GR_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("S_GR_DATE"))%></a></td>
                             <%}else{ %>
                             <td><input type="checkbox"  name="st_s_gr_flag" id="st_s_gr_flag"  value="08"  onclick="javascript:checkFlag(this.id);" >
                                 <td></td>
    							<td><div style="display:none;" id="st_s_gr_flag_1"   name="st_s_gr_flag_1">${sessionInfo.userNameLoc}
    							<input type="hidden"  name="st_S_GR_USER_ID"   id="st_S_GR_USER_ID"   value="${sessionInfo.userId}"  />
    							</div></td>
    							<td><div style="display:none;" id="st_s_gr_flag_2"  name="st_s_gr_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_S_GR_DATE"  id="st_S_GR_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>                                   
                            <%} %>
                            <td><input type="text" name="st_s_gr_remark" id="st_s_gr_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("S_GR_REMARK")) %>"   /></td>
						 </tr>
 <% if(  ("02".equals( st_WMRE_TYPE) && "2".equals( st_PROCESS_TYPE))  ) { %>	
 						<tr>
                            <td class="al">&nbsp;물류센터 교환 입고</td>
                            
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("W_CHGR_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_w_chgr_flag_fake" id="st_w_chgr_flag_fake"  value="09"  checked disabled>
                            <div style="display:none;"><input type="checkbox" name="st_w_chgr_flag" id="st_w_chgr_flag"  value="09" checked></div>
                            </td>
                            <td> </td>
                             <td><%=CommonUtil.nvl(_rowData.get("W_CHGR_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("W_CHGR_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("W_CHGR_DATE"))%></td>
                            <%}else{ %>
                             <td><input type="checkbox" name="st_w_chgr_flag" id="st_w_chgr_flag"  value="09" onclick="javascript:checkFlag(this.id);" disabled></td>
                                <td> </td>
    							<td><div style="display:none;" id="st_w_chgr_flag_1"   name="st_w_chgr_flag_1">${sessionInfo.userNameLoc}
    							<input type="hidden"  name="st_W_CHGR_USER_ID" id="st_W_CHGR_USER_ID"   value="${sessionInfo.userId}"  />
    							</div></td>
    							<td><div style="display:none;" id="st_w_chgr_flag_2"  name="st_w_chgr_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_W_CHGR_DATE" id="st_W_CHGR_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  />
    							</div></td>                              
                            <%} %>                   
                            <td><input type="text" name="st_w_chgr_remark" id="st_w_chgr_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_CHGR_REMARK")) %>" readonly/></td>
						 </tr>
						 
						 <tr>
                            <td class="al">&nbsp;물류센터 교환 납품</td>
                            
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("W_CHDELI_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_w_chdeli_flag_fake" id="st_w_chdeli_flag_fake"  value="10" checked disabled>
                            <div style="display:none;"><input type="checkbox" name="st_w_chdeli_flag" id="st_w_chdeli_flag"  value="10" checked></div>
                            </td>
                            <td><span class="btn_05 mr04"><a href="javascript:doAction('printReturn')">명세서 출력</a></span><br/></td>
                            <td><%=CommonUtil.nvl(_rowData.get("W_CHDELI_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("W_CHDELI_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("W_CHDELI_DATE")) %></td>
                            <%}else{ %>
                            <td><input type="checkbox" name="st_w_chdeli_flag" id="st_w_chdeli_flag"  value="10"  onclick="javascript:checkFlag(this.id);"disabled ></td>
                                 <td><span class="btn_05 mr04"><a href="javascript:doAction('print')">명세서 출력</a></span><br/></td>
    							<td><div style="display:none;" id="st_w_chdeli_flag_1"   name="st_w_chdeli_flag_1">${sessionInfo.userNameLoc}
    							<input type="hidden"  name="st_W_CHDELI_USER_ID" id="st_W_CHDELI_USER_ID"   value="${sessionInfo.userId}"  />
    							</div></td>
    							<td><div style="display:none;" id="st_w_chdeli_flag_2"  name="st_w_chdeli_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_W_CHDELI_DATE" id="st_W_CHDELI_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  />
    							</div></td>                            
                            <%} %>
                            
                            <td><input type="text" name="st_w_chdeli_remark" id="st_w_chdeli_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("W_CHDELI_REMARK")) %>" readonly/></td>
						 </tr>
 
 <%} %>			 



 
<% if( "02".equals( st_WMRE_TYPE) && "0".equals( st_PROCESS_TYPE)   ) { %>					 
						<tr>
                            <td class="al">&nbsp;협력사 교환 납품</td>
                            
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("S_CHDELI_FLAG")) )) { %>
                            <td><input type="checkbox"  name="st_s_chdeli_flag_fake" id="st_s_chdeli_flag_fake"  value="11" checked disabled>
                            <div style="display:none;"><input type="checkbox"  name="st_s_chdeli_flag" id="st_s_chdeli_flag"  value="11" checked ></div>
                            </td>
                            <td>  <span class="btn_05 mr04"><a href="javascript:doAction('printAgent')">명세서 출력</a></span></td>
                            <td><%=CommonUtil.nvl(_rowData.get("S_CHDELI_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("S_CHDELI_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("S_CHDELI_DATE"))%></td>
                            
                            <%}else{ %>
                              <td><input type="checkbox"  name="st_s_chdeli_flag" id="st_s_chdeli_flag"  value="11"  onclick="javascript:checkFlag(this.id);" ></td>
                                 <td>  <span class="btn_05 mr04"><a href="javascript:doAction('print')">명세서 출력</a></span></td>
      							<td><div style="display:none;" id="st_s_chdeli_flag_1"   name="st_s_chdeli_flag_1">${sessionInfo.userNameLoc}
      							<input type="hidden"  name="st_S_CHDELI_USER_ID" id="st_S_CHDELI_USER_ID"   value="${sessionInfo.userId}"  />
      							</div></td>
    							<td><div style="display:none;" id="st_s_chdeli_flag_2"  name="st_s_chdeli_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_S_CHDELI_DATE"  id="st_S_CHDELI_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  />
    							</div></td>                               
                            <%} %>
                            <td><input type="text" name="st_s_chdeli_remark" id="st_s_chdeli_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("S_CHDELI_REMARK")) %>"  /></td>
						 </tr>
<%} %> 						 
		
						<tr>
                            <td class="al">&nbsp;운영사 마감</td>
                            
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("M_CLOSE_FLAG")) )) { %>
                            <td><input type="checkbox" name="st_m_close_flag-fake" id="st_m_close_flag-fake"   value="12" checked disabled>
                            <div style="display:none;"><input type="checkbox" name="st_m_close_flag" id="st_m_close_flag"   value="12" checked></div>
                            </td>
                            <td></td>
                            <td><%=CommonUtil.nvl(_rowData.get("M_CLOSE_USER_NAME")) %></td>
                            <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("M_CLOSE_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("M_CLOSE_DATE"))%></td>
                     
                            <%}else{ %>
                            <td><input type="checkbox" name="st_m_close_flag" id="st_m_close_flag"   value="12"  onclick="javascript:checkFlag(this.id);"  disabled></td>
                                 <td></td>
      							<td><div style="display:none;" id="st_m_close_flag_1"   name="st_m_close_flag_1">${sessionInfo.userNameLoc}
      							<input type="hidden"  name="st_M_CLOSE_USER_ID"  id="st_M_CLOSE_USER_ID"   value="${sessionInfo.userId}"  />
      							</div></td>
    							<td><div style="display:none;" id="st_m_close_flag_2"  name="st_m_close_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_M_CLOSE_DATE" id="st_M_CLOSE_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  /></div></td>                           
                             <%} %>
                            
                            <td><input type="text" name="st_m_close_remark" id="st_m_close_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("M_CLOSE_REMARK")) %>"   readonly /></td>
						 </tr>

				 
						<tr>
                            <td class="al">&nbsp;종결처리</td>
                            
                            <% if("03".equals(  CommonUtil.nvl(_rowData.get("END_FLAG")) )) { %>
                            <td><input type="checkbox"  name="st_end_flag_fake" id="st_end_flag_fake"  value="13" checked disabled>
                            <div style="display:none;"> <input type="checkbox"  name="st_end_flag" id="st_end_flag"  value="13" checked></div>
                            </td>
                            <td></td>
                            <td><%=CommonUtil.nvl(_rowData.get("END_USER_NAME")) %></td>
                             <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("END_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("END_DATE"))%></td>
                            <td></td>    
                            <%}else{ %>
                            <td><input type="checkbox"  name="st_end_flag" id="st_end_flag"  value="13"  onclick="javascript:checkFlag(this.id);" disabled></td>
                                <td></td>
      							<td><div style="display:none;" id="st_end_flag_1"   name="st_end_flag_1">${sessionInfo.userNameLoc}
								<input type="hidden"  name="st_END_USER_ID"  id="st_END_USER_ID"   value="${sessionInfo.userId}"  />
      							</div></td>
    							<td><div style="display:none;" id="st_end_flag_2"  name="st_end_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_END_DATE" id="st_END_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  />
    							</div></td>                           
                            <%} %>
                            <td></td>           
						 </tr>
										 
						 <tr>
                            <td class="al">&nbsp;취소</td>	
                            <% if("02".equals(  CommonUtil.nvl(_rowData.get("CANCEL_FLAG")) )) { %>
                            <td><input type="checkbox"  name="st_cancel_flag_fake" id="st_cancel_flag_fake"  value="19" checked disabled>
                            <div style="display:none;"> <input type="checkbox"  name="st_cancel_flag" id="st_cancel_flag"  value="19" checked></div>
                            </td>
                            <td></td>
                            <td><%=CommonUtil.nvl(_rowData.get("CANCEL_USER_NAME")) %></td>
                             <td><%="".equals(CommonUtil.formatStrinigDate(_rowData.get("CANCEL_DATE")))?"":CommonUtil.formatStrinigDate(_rowData.get("CANCEL_DATE"))%></td>
                            <td><input type="text" name="st_cancel_remark" id="st_cancel_remark" class="input_type_text" title="" style="width:90%;"  /></td>    
                            <%}else{ %>
                            <td>
                            <input type="checkbox"  name="st_cancel_flag" id="st_cancel_flag"  value="19"  onclick="javascript:checkFlag(this.id);"  disabled>
                        
</td>
                                <td></td>
      							<td><div style="display:none;" id="st_cancel_flag_1"   name="st_cancel_flag_1">${sessionInfo.userNameLoc}
      							<input type="hidden"  name="st_CANCEL_USER_ID"  id="st_CANCEL_USER_ID"   value="${sessionInfo.userId}"  />
      							</div></td>
    							<td><div style="display:none;" id="st_cancel_flag_2"  name="st_cancel_flag_2"><%=CommonUtil.formatStrinigDate(_rowData.get("CUR_DATE"))  %>
    							<input type="hidden"  name="st_CANCEL_DATE"   id="st_CANCEL_DATE"  value="<%=_rowData.get("CUR_DATE")%>"  />
    							</div></td>     
    							 <td><input type="text" name="st_cancel_remark" id="st_cancel_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CANCEL_REMARK")) %>"  readonly/></td>                      
                            <%} %>
                              
                        </tr>   
				 						 						 							 						 								 						 							 							 						 							 						 
					</tbody>
				</table>
				
            <!--grid-->

			<span class="fr">
			<% if(!"03".equals(  CommonUtil.nvl(_rowData.get("END_FLAG")) ) &&!("02".equals(  CommonUtil.nvl(_rowData.get("CANCEL_FLAG")) ))  ) { %>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
				<%} %>
			</span>
			<br/><br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
