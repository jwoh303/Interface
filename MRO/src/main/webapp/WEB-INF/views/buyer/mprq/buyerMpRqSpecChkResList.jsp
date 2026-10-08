<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품규격확인
* 기능 : 고객사가 운영사에게 신규상품 규격의뢰 한 건들의 규격확인을 조회, 관리한다
* 프로그램 ID : PG_04_B_002_00
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
// String total_cnt = CommonUtil.nvl((String) request.getAttribute("TOTALPAGE"),"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String st_fb_flag = CommonUtil.nvl((String) request.getParameter("st_fb_flag"),"");  // 상태페이지 (조회조건)
String st_ser_rav_no = CommonUtil.nvl((String) request.getParameter("st_ser_rav_no"),"");  // 접수번호 (조회조건)
String byit_comorg_code=  CommonUtil.nvl(_sessionInfo.getBycaComorgCode(),_sessionInfo.getComCode()); 
String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
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
        	<h3>신규상품 규격확인</h3>
			<!--버튼영역-->
	        <div id="searchBtnA">
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
	        </div>    
        	
            <!--조회영역-->
       	<form name = "searchForm" method = "post">
            <div id="cont_searchA">
 			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" name="buyer" id="buyer" value="${sessionInfo.comCode}">
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
            	<table  class="cont_t_list01" style="width:100%;">
						<caption>신규상품 규격확인</caption>
						<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>상태조회</th>
							<td>			 
                      			<select id="st_fb_flag" name="st_fb_flag" style="width:90%;height:20px" >
				                <option value="ALL" <%if ("ALL".equals(st_fb_flag)) {%>selected<%} %>>전체</option>
				                <option value="Y" <%if ("Y".equals(st_fb_flag)) {%>selected<%} %>>확인</option>
				                <option value="N" <%if ("N".equals(st_fb_flag)) {%>selected<%} %> >미확인</option>
				              </select>	 
                            </td>
						    <td>접수번호</td>
							<td>
                            	<label for="b_delivery" class="hidden">접수번호</label>
					  			<input type="text" name="st_ser_rav_no" id="st_ser_rav_no" style="width:90%;" onKeyDown="kepToUpper('st_ser_rav_no')" onKeyDown="kepEnter()" value="<%=st_ser_rav_no%>">
                            </td>
                            <td></td><td></td>
<!-- 							<td rowspan="2" class="right"><span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> <span class="btn_reset"><a href="javascript:reload();">초기화</a></span></td> -->
						</tr> 
					</tbody>
				</table>
             </div>
 
 
  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
			</select>
      	</span>      
       <span class="fr">
       총건수 <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       </span>
       <br>
		            
		</form>

		 <form name = "contentForm" method = "post">
		 <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		 <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
            	<!--grid-->
                <table  class="cont_t_list02" style="width:100%;">
                    <caption>리스트</caption>
                    <colgroup>
                        <col width="4%" />
                        <col width="9%" />
                        <col width="9%" />
                        <col width="17%" />
                        <col width="*" />
                        <col width="10%" />
                        <col width="9%" />
                        <col width="10%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"  rowspan="2" class="rLine"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();"> </th>
<!--                             <th scope="col" rowspan="2" class="rLine">번호</th> -->
                            <th scope="col" >진행상태</th>
                            <th scope="col" >접수번호</th>
                            <th scope="col" ><font color="#FF6600">의뢰</font>품목명</th>
                            <th scope="col" >규격</th>
                            <th scope="col" >단위</th>
                            <th scope="col" >제조사</th>
                            <th scope="col" >KeP 담당자</th> 
                        </tr>                
                        <tr>
                            <th scope="col" >품목상태</th>
                            <th scope="col" >품목코드</th>
                            <th scope="col" ><font color="#FF6600">확인</font>품목명</th>
                            <th scope="col" >규격</th>
                            <th scope="col" >단위</th>
                            <th scope="col" >제조사</th>
                            <th scope="col" >비고 /  첨부</th> 
                        </tr>                
                    </thead>
                    <tbody>
                                        <%
        if (_gridList == null || _gridList.size() == 0){
        %>
                            <tr bgcolor="#FFFFFF">
                        <td colspan="9" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		%> 
						<tr bgcolor="<%=tclass%>">
							<td rowspan ="2" class="font1_black1"  align="center">
								<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
			                    <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
								<input type="hidden" name="st_buyer"	value="<%= rowData.get("BUYER") %>">
								<input type="hidden" name="st_rav_no"		value="<%= rowData.get("RAV_NO") %>">
								<input type="hidden" name="st_rav_seq"	value="<%=CommonUtil.bnvl( rowData.get("RAV_SEQ"))%>"	>
								<input type="hidden" name="st_buyer_item"	value="<%=CommonUtil.nvl( rowData.get("KEP_BUYER_ITEM_NO")) %>">
								<input type="hidden" name="st_item_flag"		value="<%=CommonUtil.nvl( rowData.get("KEP_ITEM_STATUS")) %>">
								<input type="hidden" name="st_job_flag"	value="<%= CommonUtil.nvl(rowData.get("FEEDBACK_FLAG")) %>">
								<input type="hidden" name="st_contract_no"		value="<%=CommonUtil.bnvl( rowData.get("CONTRACT_NO")) %>">
								<input type="hidden" name="st_contract_seq"	value="<%=CommonUtil.bnvl( rowData.get("CONTRACT_SEQ")) %>">
							</td>

<%-- 							<td rowspan ="2"   align="center"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td> --%>
							<td  align="center"><%=rowData.get("FEEDBACK_FLAG").equals("Y")?"확인":"미확인"%></td> 
							<td  align="center"><%=rowData.get("RAV_NO")%></td> 
							<td class="left"><%=rowData.get("DESCRIPTION")%></td> 
							<td class="left"><%=rowData.get("SPECIFICATION")%></td> 
							<td align="center"><%=rowData.get("UNIT_MEASURE")%></td> 
							<td><%=rowData.get("MAKER_NAME")%></td> 
							<td>
							<%
								if(!CommonUtil.nvl(rowData.get("KEP_USER_ID")).equals("")){									
							%>
								<%=CommonUtil.nvl(rowData.get("KEP_USER_ID"))%> (<%=CommonUtil.nvl(rowData.get("KEP_PHONE_NUMBER"))%>)
							<%
								}
							%>
							</td>  
						</tr> 					
						<tr bgcolor="<%=tclass%>">    
							<td align="center"><%="K".equals(CommonUtil.nvl(rowData.get("KEP_ITEM_STATUS")))?"기등록":"신규"%></td> 
							<td align="center">
							<% 
										if(rowData.get("KEP_ITEM_STATUS").equals("K")){
								%>
											<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("KEP_BUYER_ITEM_NO"))%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><b><font color="#5B5B5B"><%=CommonUtil.nvl(rowData.get("KEP_BUYER_ITEM_NO"))%></font></b></a>
								<% 
										}else{
								%>	
										
								<%	
										}
								%>		
							</td> 
							<td class="left"><%=CommonUtil.nvl(rowData.get("KEP_DESCRIPTION"))%></td> 
							<td class="left"><%=CommonUtil.nvl(rowData.get("KEP_SPECIFICATION"))%></td> 
							<td  align="center"><%=CommonUtil.nvl(rowData.get("KEP_UNIT_MEASURE"))%></td> 
							<td><%=CommonUtil.nvl(rowData.get("KEP_MAKER_NAME"))%></td> 
							<td   align="center">
								<input type="hidden" name="st_btoa_remark"	value="<%=CommonUtil.nvl(rowData.get("BUYER_REMARK"))%>">
								<input type="hidden" name="st_atob_remark"	value="<%=CommonUtil.nvl(rowData.get("KEP_KEP_REMARK"))%>">
								<%
									if (("").equals(CommonUtil.nvl(rowData.get("KEP_KEP_REMARK")))) {
								%>
									<a class="hyperLink" href="javascript:doPop('remark', '<%=CommonUtil.nvl(rowData.get("BUYER_REMARK"))%>','<%=CommonUtil.nvl(rowData.get("KEP_KEP_REMARK"))%>','')"><img name = "st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0"></a>
								<%
									}else{
								%>         
									<a class="hyperLink" href="javascript:doPop('remark', '<%=CommonUtil.nvl(rowData.get("BUYER_REMARK"))%>','<%=CommonUtil.nvl(rowData.get("KEP_KEP_REMARK"))%>','')"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>           
								<%
									}
								%>
							  /						
								<input type="hidden" name="st_image_key"	value="<%=CommonUtil.nvl( rowData.get("IMAGE_KEY"))%>"> 
								<%
								if (("").equals(CommonUtil.nvl( rowData.get("IMAGE_KEY")))) { 
								%>
									<img name = "st_image_key_img" src="/resources/images/disk_off.gif" border="0">
								<%
									}else{
								%>         
									<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>    
								<%
									}
								%>			 
							</td> 
						</tr>
              		<%
			}
		%>
        <%
        }
		%>	        
                    </tbody>
                </table>
            </form>
	            <!--페이징-->
	            <p class="paging" >
	            <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				</p>
            	<div>
            	※ KEP담당자가 확인한 품목에 대해 다음으로 진행할 수 있습니다.<br>
				    - 품목상태 <b>'신규'</b>로 확인된 품목은 신상품 등록을 신청할 수 있습니다.<b>(등록신청)</b><br>
				    - 품목상태 <b>'기등록'</b>으로 확인된 품목은 품목코드에 기존상품코드가 표기되며, 확인후 <b>(장바구니담기)</b>로 구매신청할 수 있습니다.<br>
				    - <b>(삭제)</b>버튼은 해당 진행정보가 완전히 삭제됩니다. 
            	</div>
                <!--버튼영역-->
                <div class="btnArea"> 
	                <span class="fr">
						<span class="btn_04 mr04"><a href="javaScript:doAction('reg');">등록신청</a></span>
						<span class="btn_04 mr04"><a href="javaScript:doAction('cart');">장바구니담기</a></span>
						<span class="btn_04 "><a href="javaScript:doAction('del');">삭제</a></span>
					</span>                	
				 </div>
				 
         </div>    <!-- end of contents -->
                
			
    
	<form name="processForm" id="processForm"  method="post">	
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="buyer" id="buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="gubun" id="gubun" value="" />
		<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
		<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
		<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
		<input type="hidden" name="st_fb_flag" id="st_fb_flag"  value="<%=st_fb_flag %>"/>
		<input type="hidden" name="st_ser_rav_no" id="st_ser_rav_no"  value="<%=st_ser_rav_no %>"/>
		<div id="process">
		</div>
	</form>
    

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>    
</body>

    
<script type="text/javascript">

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
	case "search":
		kepSearch(1);
		break;
	case "reload":
		kepReload('searchForm');
		$('#st_total_cnt').val('0');
		kepSearch(-1);
// 		$('#searchForm').attr("action", "/mprq/showBuyerMpRqSpecChkRes.do").submit();
		break;
	case "reg": // 등록신청
		kepSave();
		break;
	case "cart": // 장바구니
		cartCheck();
		break;
	case "del": // 삭제
		delCheck();
		break;
	case "downexcel":
		break;
	}

}


/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
 	document.forms.searchForm.curPage.value = curPage;
	document.forms.searchForm.target = "_self";
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getBuyerMpRqSpecChkResList.do";
	document.forms.searchForm.submit(); 
	
}

function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $("#display_item_cnt").val();
// 	var check_status = $("#check_status").html();
	
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

/*
 *  최초 화면 함수
 */
function kep_onload_view(){
 
}

/*
 * 등록처리
 */
function kepSave(){ 
	var btnEvent = "regCheck";
	/* 그리드 데이터 셋팅 */
	
	if(setGridData(btnEvent)){
		if(!confirm("이동 하시겠습니까?")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/regReqBuyerMpRqSpecChkRes.do","processForm",btnEvent); 
	}
}

/* 장바구니 담기 */
function cartCheck() {   
	var btnEvent = "cartCheck";
	/* 그리드 데이터 셋팅 */
	if(setGridData(btnEvent)){
		if(!confirm("품목을 장바구니에 담으시겠습니까?")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/cartBuyerMpRqSpecChkRes.do","processForm",btnEvent); 	
	}
}

/* 삭제 */
function delCheck() {   
	var btnEvent = "delCheck";
	/* 그리드 데이터 셋팅 */
	if(setGridData(btnEvent)){
		if(!confirm("삭제 하시겠습니까?")){ 
			return;
		} 
		kepAjaxFormCall("/mprq/delBuyerMpRqSpecChkRes.do","processForm",btnEvent); 	
	}	
}

//선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkFlag = false;
	var tot_cnt  = $("#display_item_cnt").val(); 
 	var cnt      = getCheckedRowCount(tot_cnt);
 	
 	if(tot_cnt == 0){
		alert("품목이 없습니다.");
		return;
	} 
 	if(cnt == 0){
		alert("선택하신 품목이 없습니다.");
		return;
	}
       var box = "";
       if (tot_cnt < 2) {
    	   box = eval("document.forms.contentForm.checkbox0");
           if(box.checked == true){
				var st_item_flag				=	document.forms.contentForm.st_item_flag.value;	 
				var st_job_flag					=	document.forms.contentForm.st_job_flag.value;	 
				
				if(btnEvent =="regCheck" && (st_item_flag == "K" || st_job_flag == "N")){
					alert("신규상품, 진행상태가 확인 건만 등록신청이 가능 합니다.\n\n확인바랍니다.");				
					document.forms.contentForm.checkbox.checked = false;
					return false;
					return;
				}else if(btnEvent =="cartCheck" && (st_item_flag == "S" || st_job_flag == "N")){
					alert("기등록 상품, 진행상태가 확인 건만 장바구니로 이동 가능 합니다.\n\n확인바랍니다.");				
					document.forms.contentForm.checkbox.checked = false;
					return false;
				}
           }
       } else {
	       for(var k = 0; k < tot_cnt; k++){
	           box = eval("document.forms.contentForm.checkbox" + k);
	           if(box.checked == true){
					var st_item_flag				=	document.forms.contentForm.st_item_flag[k].value;	 
					var st_job_flag					=	document.forms.contentForm.st_job_flag[k].value;	 
					
					if(btnEvent =="regCheck" && (st_item_flag == "K" || st_job_flag == "N")){
						alert("신규상품, 진행상태가 확인 건만 등록신청이 가능 합니다.\n\n확인바랍니다.");				
						document.forms.contentForm.checkbox[k].checked = false;
						return false;
						return;
					}else if(btnEvent =="cartCheck" && (st_item_flag == "S" || st_job_flag == "N")){
						alert("기등록 상품, 진행상태가 확인 건만 장바구니로 이동 가능 합니다.\n\n확인바랍니다.");				
						document.forms.contentForm.checkbox[k].checked = false;
						return false;
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

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "regCheck") {
		alert("등록신청이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	} else if (pMethod == "cartCheck") {
		alert("장바구니에 담기를 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	} else if (pMethod == "delCheck") {
		alert("삭제 작업이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.");
	}
} 

//팝업함수호출
var gridIndex = 0;
function doPop(str, value1, value2, value3) {
	popupSel = str ;
	
	switch (str) {
	case "remark"://고객사 비고
		var viewType="R";
		openSearchPopup('/common/remarkPop.do','?st_btoa_remark='+value1+'&st_atob_remark='+value2+'&viewType='+viewType,'500,310,no'); 
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "catalogDetailPop":
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+'<%=byit_comorg_code%>'+'&BUYER_ITEM_NO='+value1+'&CONTRACT_NO='+value2+'&CONTRACT_SEQ='+value3, "800,290,no"); 
		break;
	}
}

	   
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	 if(popupSel == "remark") {	//고객사 비고
		 $("input[name=st_btoa_remark]").eq(gridIndex).val(value1);
		 $("input[name=st_atob_remark]").eq(gridIndex).val(value2);
		 if(value2 ==""){
	 		$("img[id=st_atob_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_atob_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
		 
	}else if(popupSel == "attach") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}

}
</script>
</html>
