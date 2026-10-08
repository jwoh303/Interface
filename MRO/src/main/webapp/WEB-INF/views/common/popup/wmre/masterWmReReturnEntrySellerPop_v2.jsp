<%--
**********************************************
* 메뉴 : 
* 화면 : 교환/반품현황 상세
* 기능 : 
* 프로그램 ID : BU0402002
* 담당자 : 최찬규
* 착수일 : 2025-11-03
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
<%@ include file="../../include/head_v2.jspf"  %>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
</head>
<%
	String buyer = "";
	String userid = "";
	String userName = "";
	
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());  	
	}
	
	String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");
	
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	String st_wmre_no ="";
	String st_wmre_type2 = "";
	String st_wmre_type3 ="";
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		st_wmre_no =		CommonUtil.nvl(_rowData.get("WMRE_NO"));
		st_wmre_type2 =  CommonUtil.nvl(_rowData.get("WMRE_TYPE2"));
		st_wmre_type3 = CommonUtil.nvl(_rowData.get("WMRE_TYPE3"));
	}	


	
%>

<script type="text/javascript">
window.calendarPositionOffset = {
	top:-150,
	left:-150
};

function popupOnload(){
	$("#st_s_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_s_gr_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "save":
			var msg = "";
			var flag = $("#st_FLAG").val();
			if(flag == "02"){ //협력사 접수 처리할 때 , 입고도 같이 처리할 지 체크
				var st_delivery_flag = $("input[name=st_delivery_flag]:checked").val();
				if(st_delivery_flag == undefined){
					alert("물품수령여부를 선택해주세요.");
					return;
				}
				if(st_delivery_flag == "Y"){ //협력사 입고도 같이 처리
					$("#st_s_gr_date").val($("#st_s_rec_date").val());
					$("#st_s_gr_remark").val($("#st_s_rec_remark").val());
					$("#st_s_gr_flag").val("Y");
					$("#st_s_gr_user_id").val($("#st_s_rec_user_id").val());
					msg = "반품 접수 및 입고 처리를 하시겠습니까?";
				}else{ //협력사 접수만 처리
					$("#st_s_gr_date").val("");
					$("#st_s_gr_remark").val("");
					$("#st_s_gr_flag").val("");
					$("#st_s_gr_user_id").val("");
					msg = "반품 접수 처리를 하시겠습니까?";
				}
			}else{
				msg = "반품 입고 처리를 하시겠습니까?";
			}
			
		    if(!confirm(msg)) {
		        return;
		    }else{
		       kepAjaxFormCall("/wmre/saveMasterWmReReturnWmNoPop_v2.do","searchCondition","save"); 	   
		    }
			break;
		case "downLoadFile": //첨부파일 다운로드
			var doc_no = $("#st_wmre_file").val();
			if(doc_no != ""){
				location.href="/common/download_v2.do?DOC_NO="+doc_no;
			}
			break;
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	
	if (pMethod == "save"){ 
		 alert("반품 등록에 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	
	var result = response.msg.MSG;  
	
	if(result=="Ok"){
		alert("정상적으로 처리 되었습니다.");
		parent.doAction('search');
		parent.closePop();

	}else{
		alert(result);
		return;
	}
}



</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_WMRE_NO"  name="st_WMRE_NO" value="<%=st_wmre_no%>">
	<div class="wrapPopup">
  <div class="PopupTit">교환/반품 상세 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubState">발주정보 </div>
  <%if(_rowData != null ){ %>
  <input type="hidden" id="st_FLAG"  name="st_FLAG" value="<%=CommonUtil.nvl(_rowData.get("FLAG"))  %>"  >
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
    <tr>
      <th>발주번호</th>
      <td><%=CommonUtil.nvl(_rowData.get("PO_NO"))  %></td>
      <th>발주일</th>
      <td><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("PO_CREATE_DATE")))  %></td>
      <th>고객사</th>
      <td><%=CommonUtil.nvl(_rowData.get("BUYER_NAME"))  %></td>
    </tr>
    <tr>
      <th>발주자</th>
      <td><%=CommonUtil.nvl(_rowData.get("PURCHASER_NAME"))  %></td>      
      <th>품목수량</th>
      <td align="right"><%=CommonUtil.formatNumber(CommonUtil.nvl(_rowData.get("ITEM_CNT")),true,0,3) %></td>
      <th>발주금액</th>
      <td align="right"><%=CommonUtil.formatNumber(CommonUtil.nvl(_rowData.get("AGENT_PO_TTL_AMT")),true,0,3) %></td>
    </tr>
    <tr>
      <th>비고</th>
      <td colspan="5"><%=CommonUtil.nvl(_rowData.get("PO_REMARK"))  %></td> 
    </tr>           
  </table>  
  <div class="PopupTitSub">고객사 요청정보</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
    <tr>
      <th>구분</th>
      <td><%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_NAME")) %></td>
      <th>요청일</th>
      <td><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("B_REQ_DATE"))) %></td>
      <th>요청수량</th>
      <td align="right"><%=CommonUtil.formatNumber(String.valueOf(_rowData.get("WMRE_QTY")),true,0,0)%></td>
      
    </tr>
    <tr>
      <th>사유</th>
      <td colspan="5"><%=CommonUtil.nvl(_rowData.get("B_REQ_REMARK")) %></td>
    </tr>       
  </table>

  <div class="PopupTitSub">귀책정보</div>
   <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
<%--   	<% if(  "02".equals(CommonUtil.nvl(_rowData.get("FLAG")) ) ||"19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ) {%> --%>
    <tr>
      <th>귀책대상</th>
      <td><%=CommonUtil.nvl(_rowData.get("WMRE_TYPE2_NAME")) %></td>
      <th>파일첨부</th>
      <td><a href="javascript:doAction('downLoadFile');" ><%=CommonUtil.nvl(_rowData.get("WMRE_FILE_CNT")) %></a>
      <input type="hidden" name="st_wmre_file" id="st_wmre_file" value="<%=CommonUtil.nvl(_rowData.get("WMRE_FILE")) %>">
      </td>
      <th>귀책사유</th>
      <td><%=CommonUtil.nvl(_rowData.get("WMRE_TYPE3_NAME")) %></td>
    </tr>
    <tr>
      <th>귀책상세사유</th>
      <td colspan="5"><%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_DETAIL")) %></td>
    </tr>
<%--     <%}else{ %> --%>
<!-- 	위에 상태가 아닐 땐 운영사 접수까지 진행하려고 귀책대상,사유 선택하는 것 같은데 이 부분은 제거 -->
<%--     <%} %>        --%>
  </table> 
  <div class="PopupTitSub">협력사 처리정보</div>
  	<table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
      <col width="160px" />
      <col width="240px" />
  	</colgroup>
  <%if(!viewType.equals("R")) {%>
  	<% if("02".equals(CommonUtil.nvl(_rowData.get("FLAG")))) {%> <!-- 운영사접수상태 > 협력사접수,입고 할 차례 -->
    <tr>
      <th>처리자</th>
      <td>${sessionInfo.userNameLoc}</td>
      <th>물품수령여부</th>
      <td><label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="Y"><span class="RadioMediumTxt"></span>수령</label> 
          <label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="N"><span class="RadioMediumTxt"></span>미수령</label>     
      </td>
      <th>처리일</th>
      <td>
      <div class="datepicker-wrap" style=" width:162px">
          <div class="date-input" data-datepicker style=" width:162px">
          <input type="text" placeholder="" id="st_s_rec_date" name="st_s_rec_date" readonly style=" width:120px"/><span id="calendar-btn"> </span>
          <input type="hidden" placeholder="" id="st_s_gr_date" name="st_s_gr_date" readonly style=" width:120px"/>
          </div>
        </div>
      </td>
    </tr>
    <tr>
      <th>메모</th>
      <td colspan="5"><input class="input30" style="width:942px" name="st_s_rec_remark" id="st_s_rec_remark" type="text" />
      <input class="input30" style="width:1035px" name="st_s_gr_remark" id="st_s_gr_remark" type="hidden" /></td> 
    </tr>
    <input type="hidden" id="st_s_rec_flag"  name="st_s_rec_flag" value="Y">
    <input type="hidden" id="st_s_gr_flag"  name="st_s_gr_flag" value="">
    <input type="hidden" id="st_s_rec_user_id"  name="st_s_rec_user_id" value="${sessionInfo.userId}">
    <input type="hidden" id="st_s_gr_user_id"  name="st_s_gr_user_id" value="">
    <%}else if("03".equals(CommonUtil.nvl(_rowData.get("FLAG")))) {%> <!-- 협력사 접수 상태 > 협력사 입고할 차례 -->
    <tr>
      <th>처리자</th>
      <td>${sessionInfo.userNameLoc}</td>
      <th>물품수령여부</th>
      <td><label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="Y" checked disabled="disabled"><span class="RadioMediumTxt"></span>수령</label> 
          <label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="N" disabled="disabled"><span class="RadioMediumTxt"></span>미수령</label>     
      </td>
      <th>처리일</th>
      <td>
      <div class="datepicker-wrap" style=" width:162px">
          <div class="date-input" data-datepicker style=" width:162px">
          <input type="text" placeholder="" id="st_s_gr_date" name="st_s_gr_date" readonly style=" width:120px"/><span id="calendar-btn"> </span>
          </div>
        </div>
      </td>
    </tr>
    <tr>
      <th>메모</th>
      <td colspan="5"><input class="input30" style="width:942px" name="st_s_gr_remark" id="st_s_gr_remark" type="text" /></td> 
    </tr>
    <input type="hidden" id="st_s_gr_flag"  name="st_s_gr_flag" value="Y">
    <input type="hidden" id="st_s_gr_user_id"  name="st_s_gr_user_id" value="${sessionInfo.userId}">
    <%}else{ %>
    <tr>
      <th>처리자</th>
      <td><%=CommonUtil.nvl(_rowData.get("S_REC_USER_NAME")) %></td>
      <th>물품수령여부</th>
      <td><label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="Y" <%if(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")).equals("Y")) {%>checked<%} %> disabled="disabled"><span class="RadioMediumTxt"></span>수령</label> 
          <label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="N" <%if(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")).equals("N")) {%>checked<%} %> disabled="disabled"><span class="RadioMediumTxt"></span>미수령</label>     
      </td>
      <th>처리일</th>
      <td><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_DATE"))) %></td>
    </tr>
    <tr>
      <th>메모</th>
      <td colspan="5"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_REMARK"))) %></td> 
    </tr>
    <%} %>
   <%}else{ %>
   	<tr>
      <th>처리자</th>
      <td><%=CommonUtil.nvl(_rowData.get("S_REC_USER_NAME")) %></td>
      <th>물품수령여부</th>
      <td><label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="Y" <%if(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")).equals("Y")) {%>checked<%} %> disabled="disabled"><span class="RadioMediumTxt"></span>수령</label> 
          <label class="RadioMediumLabel"><input type="radio" name="st_delivery_flag" value="N" <%if(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")).equals("N")) {%>checked<%} %> disabled="disabled"><span class="RadioMediumTxt"></span>미수령</label>     
      </td>
      <th>처리일</th>
      <td><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_DATE"))) %></td>
    </tr>
    <tr>
      <th>메모</th>
      <td colspan="5"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_REMARK"))) %></td> 
    </tr>
   <%} %>       
   </table>
  <div class="h30"></div>
  	<% if(("02".equals(CommonUtil.nvl(_rowData.get("FLAG"))) || "03".equals(CommonUtil.nvl(_rowData.get("FLAG")))) && !viewType.equals("R")) {%>
	  <div class="PopupListBtnBox_Center" style="width:1190px;">
	    <button class="ButPrimary_large" onclick="javascript:doAction('save');return false;" >반품처리</button>
	  </div>
  	<%} %>  
  <%} %>    
</div><!-- warp 끝-->
</form> 
</body>
</html>
