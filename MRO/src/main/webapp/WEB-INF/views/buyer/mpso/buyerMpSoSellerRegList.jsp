<%--
**********************************************
* 메뉴 : 주문관리 > 판매인 등록증 신청화면
* 화면 : 판매인 등록증 신청화면
* 기능 : 판매인 등록증 신청화면
* 담당자 : 현명환
* 착수일 : 2016-03-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String buyer             = "";
	String userType 		 = "";
	String userID 		     = "";
	String userName 		 = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){
		buyer             = sessionInfo.getComCode();
		userType         = sessionInfo.getUserType();
	    userID            = sessionInfo.getUserId();
	    userName          = sessionInfo.getUserNameLoc();
	}
	//화면타이틀
	String menuTitle = "";
	Map<String, String>menuTitleInfo = CommonUtil.getIcomCode2ReturnMap(buyer,"M018","C001"); 
    if (menuTitleInfo != null){
    	menuTitle= CommonUtil.nvl(menuTitleInfo.get("TEXT3"),"");
    }     
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>
</head>
<body>
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="sessionInfo" value="${sessionInfo }"/>
			<c:set var="comCode" value="${sessionInfo.comCode }"/>
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="0" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:set var="realImgUploadPath" value='<%=CommonUtil.realImgS3UploadPath %>'/>
			<c:if test='${st_from_date == null || st_from_date == "" }'>
				<c:set var="fromDate" value='<%=CommonUtil.addDate(new Date(), "M", -1, 1) %>' />
				<c:set var="toDate" value='<%=CommonUtil.getCurrentDay_Time("yyyyMMdd") %>' />
			</c:if>
			<jsp:useBean id="toDay" class="java.util.Date" />
			<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="currDate"/>
			<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" var="stCurrDate"/>

			<c:if test='${!(st_from_date == null || st_from_date == "") }'>
				<c:set var="toDate" value='${st_to_date }' />
			</c:if>
			<c:set var="rowNumber" value='0' />
			<div id="container2">
			<div id="ContArea">
				<h3><%=menuTitle %> 등록</h3>
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_dept" id="st_dept" value="${sessionInfo.department}">
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_query_cart" id="st_query_cart" value="" />
					<input type="hidden" name="st_prev_url" id="st_prev_url" value="" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="5%" />
							<col width="15%" />
							<col width="10%" />
							<col width="20%" />
							<col width="*"/>
							<col width="20%" />							
							<col width="8%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">선택</th>
								<th scope="col"></th>
								<th scope="col">품목코드</th>
								<th scope="col">품목명</th>
								<th scope="col">규격</th>
								<th scope="col">대상자</th>
								<th scope="col">첨부파일</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${data == null || fn:length(data) == 0}">
									<tr>
										<td colspan="15" align="center" height="50">
											<span>조회된 데이타가 없습니다.</span>
										</td>
									</tr>
								</c:when>
								<c:when test="${fn:length(data) > 0}">
									<c:set var="tclass" value='#FFFFFF' />
									<c:forEach items="${data}" var="_gridList" varStatus="status">
										<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
										<c:set var="rowNumber" value='${status.index +1 }' />
										<c:if test='${rowNumber % 2 != 0 }' >
											<c:set var="tclass" value="#FAFAFA"/>
										</c:if>
										<c:if test='${rowNumber % 2 == 0 }' >
											<c:set var="tclass" value="#FFFFFF"/>
										</c:if>
										<tr align="center" bgcolor="${tclass }" height="25" >
											<td width="5%" title="선택" class="td02">
												<input type="checkbox" name="st_checkbox"  value="${_gridList.RN-1 }" />
												<input type="hidden" name="st_no" value="${_gridList.RN - 1 }" />
												<input type="hidden" name="st_contract_no" value="${_gridList.CONTRACT_NO }" />
												<input type="hidden" name="st_contract_seq" value="${_gridList.CONTRACT_SEQ }" />
												<input type="hidden" name="st_buyer_item_no" value="${_gridList.BUYER_ITEM_NO }" />
												<input type="hidden" name="st_use_flag" value="${_gridList.USE_FLAG }" />
												<input type="hidden" name="st_byit_comorg_code" value="${_gridList.BELOW_COMORG_CODE }" />
												<input type="hidden" name="st_agent" value="${_gridList.AGENT }" />												
											</td>
											<td width="*" title="상품" class="td02" style="text-align:center">
												<c:if test='${_gridList.IMGFILE_DIR != null }'> 
													<a href="javascript:getBigImage('${_gridList.IMGFILE_DIR }','${_gridList.IMGFILE_NAME }');">
														<img src='${realImgUploadPath }/${_gridList.IMGFILE_DIR }/${_gridList.IMGFILE_NAME }' onerror="javasrcipt:this.src='/resources/images/noimage.gif'" name="image1" width="160" height="160" border="0">
													</a>
												</c:if>
											<c:if test='${_gridList.IMGFILE_DIR == null }'>
												<img src="/resources/images/noimage.gif" width="160" height="160" border="0">
											</c:if>
											</td>
											<td width="* title="품목코드" class="td02" style="text-align:left">
												${_gridList.BUYER_ITEM_NO }
											</td>
											<td width="* title="상품명" class="td02" style="text-align:left">
												${_gridList.DESCRIPTION }
											</td>
											<td width="* title="규격" class="td02" style="text-align:left">
												${_gridList.SPECIFICATION }
											</td>
											<td>
											<div title="대상자" class="TextNomal">
												<input type=hidden name="toContent" id="toContent"  value="">
												<input type=hidden name="req_user_id" id="req_user_id"  value="">
												<input type=hidden name="st_image_key" id="st_image_key"  value="">
												<input type='text' name='req_user_name' id='req_user_name' size="26" value="" style="text-align:left" readOnly/>&nbsp;
  												<a href="javascript:getReqUserSelect('${_gridList.RN }');">
													<img src="/resources/images/but_query.gif" width="19" height="19">
												</a>
											</div>
											</td>
											<td>
												<a href="javascript:doPop('attach',this)"><img src="/resources/images/disk_off.gif" name="Image2" width="14" height="14" border="0"></a>
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					<c:if test="${data != null && fn:length(data) > 0}">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value= "${total_cnt }" />
					</c:if>
					<br/>
					<div class="btnArea ac" style="margin-bottom:0px; margin-top: 5px;">
						<span class="fr btn_02">
							<a href="javascript:doAction('regOrder');">주문하기</a>
						</span>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "regOrder": // 주문하기
		var tot_cnt = document.contentForm.display_item_cnt.value;
		var gbn = "N"; 
	    if(eval(tot_cnt) < 2)     {
	        var box = eval("document.forms.contentForm.st_checkbox");
	        if(box.checked==true) {
	        	var req_user_name = document.forms.contentForm.req_user_name.value;
	        	var image_key = document.forms.contentForm.st_image_key.value;
	        	var req_user_id = document.forms.contentForm.req_user_id.value;
	        	if(req_user_name == null||req_user_name==""){
					alert("대상자 정보가 없습니다.\n대상자 정보 입력 바랍니다.");
					return;
	        	}
	        	if(image_key == null||image_key==""){
	        		alert("주문하려는 품목에 파일 첨부 바랍니다.");
					return;
	        	}
	        	gbn= "Y";
	            /*
	            var newUserId = getNewUserInfo(req_user_id);
	            if(newUserId.length !=0){
					alert(newUserId+" 2016년 이전 가입자 입니다.");
					return;
	        	}
	            */
	            var orderUserId = getOrderUserInfo(req_user_id);
	        	if(orderUserId.length !=0){
					alert(orderUserId+" 구매 내력이 있어 주문 불가능 합니다.");
					return;	        		
	        	}
	        		
	        }
	      } else{
	    	  
	        for(var x=0; x<eval(tot_cnt); x++) {
	            if(document.forms.contentForm.st_checkbox[x].checked==true) {
	                var req_user_name = document.forms.contentForm.req_user_name[x].value;
	                var image_key = document.forms.contentForm.st_image_key[x].value;
		        	var req_user_id = document.forms.contentForm.req_user_id[x].value;
	                if(req_user_name == null||req_user_name==""){
						alert("대상자 정보가 없습니다.");
						return;
		        	}
		        	if(image_key == null||image_key==""){
		        		alert("대상자 정보가 없습니다.\n대상자 정보 입력 바랍니다.");
						return;
		        	}
		        	gbn= "Y";
		            /*
		            var newUserId = getNewUserInfo(req_user_id);
		            if(newUserId.length!=0){
						alert(newUserId+" 2016년 이전 가입자 입니다.");
						return;
		        	}
		            */
		            var orderUserId = getOrderUserInfo(req_user_id);
		            if(orderUserId.length!=0){
						alert(orderUserId+" 구매 내력이 있어 주문 불가능 합니다.");
						return;	        		
		        	}
	            }
	        } 
	      }
		if(gbn == "N"){
			alert("품목을 선택하여 주십시요. ");
			return;
		}
		if(!confirm("주문 신청 하시겠습니까?")){ 
			return;
		} 

		kepAjaxFormCall("/mpso/setBuyerMpSoSellerRegListdo.do","contentForm","regOrder");
		break;
	}
}
//2016년1월1일 사용자 체크
function getNewUserInfo(newUserId) {  
	   var strBuyer = "<%=buyer%>";
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getNewUserInfo.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: strBuyer,param2: newUserId},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		rtnData = $.trim(eval("response.data["+i+"].USER_ID")); 
		 		      }	 		    
	    		  }
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
		return rtnData;
	}
//신청불가능체크
function getOrderUserInfo(newUserId) {  
	   var strBuyer = "<%=buyer%>";
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getOrderUserInfo.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: strBuyer,param2: newUserId},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		rtnData = $.trim(eval("response.data["+i+"].USER_ID")); 
		 		      }	 		    
	    		  }
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
		return rtnData;
	}
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

// 팝업 함수호출
var gridIndex = 0;
var grbRow = "";

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var status = response.msg.MSGTYPE;
	var msg = response.msg.MESSAGE;
	if(pMethod == 'setGrReturn'){
		if (status == "E"){
			alert("작업에 실패하였습니다. \n[" +msg+"]\n 위 메시지를 담당자에게 전달하시기 바랍니다.");
		}
		// 처리후 재조회
		kepSearch($("#curPage").val());
	} else if(pMethod == "regOrder"){
		alert("주문 신청 완료했습니다.");
		kepSearch(1);
	}
	
}
//조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoSellerRegList.do").submit();   
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
} 

var g_popRow = "";
//대상자선택
function getReqUserSelect(popRow){
	g_popRow = popRow;
	var st_buyer = "<%=buyer%>";
	getUserSelect(st_buyer);
}

// 사용자선택
function getUserSelect(buyer){
	popupSel = "USER";
	var tot_cnt = document.contentForm.display_item_cnt.value;    
    var option = "";
    if(eval(tot_cnt) < 2) {
    	option = "?toContent="+document.forms.contentForm.toContent.value;
    }else {
    	option = "?toContent="+document.forms.contentForm.toContent[g_popRow-1].value;
    }
	openSearchPopup('/mdam/showBuyerMdAmUserSelPop.do',option, "1000,470,no");
}
function setPopupApprovalReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4) {
	var tot_cnt = document.contentForm.display_item_cnt.value;
    if(eval(tot_cnt) < 2) {
    	document.forms.contentForm.toContent.value = tmptmp4;
    	document.forms.contentForm.req_user_name.value = tmptmp1;
    	document.forms.contentForm.req_user_id.value = tmptmp2;
    }else {
    	document.forms.contentForm.toContent[g_popRow-1].value = tmptmp4;
    	document.forms.contentForm.req_user_name[g_popRow-1].value = tmptmp4;
    	document.forms.contentForm.req_user_id[g_popRow-1].value = tmptmp2;
    }
}
//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
	case "attach":
		var tot_cnt = document.contentForm.display_item_cnt.value;
		var image_key = "";
	    if(eval(tot_cnt) < 2) {
	        image_key = document.forms.contentForm.st_image_key.value;
	    }else{
	        image_key = document.forms.contentForm.st_image_key[g_popRow-1].value;
	    }
		var type="RFQ";
		var viewType="VI";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "attach") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		var tot_cnt = document.contentForm.st_no.value;
	    
	    if(eval(tot_cnt) < 2) {
	        document.forms.contentForm.st_image_key.value = code;
	    }else {
	        document.forms.contentForm.st_image_key[g_popRow-1].value = code;
	    }
	    if(code != ''){
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = code;
	            document.forms.contentForm.Image2.src = diskOn;
	        }else{
	            document.forms.contentForm.st_image_key[g_popRow-1].value = code;
	            document.forms.contentForm.Image2[g_popRow-1].src = diskOn;
	        }
	    }else{
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = "";
	            document.forms.contentForm.Image2.src = diskOff;
	        }else{
	            document.forms.contentForm.st_image_key[g_popRow-1].value = "";
	             document.forms.contentForm.Image2[g_popRow-1].src = diskOff;
	        }
	    }
		
	}
}
</script>
</html>
