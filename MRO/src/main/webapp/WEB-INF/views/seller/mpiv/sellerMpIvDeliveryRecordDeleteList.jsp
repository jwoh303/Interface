<%--
**********************************************
* 메뉴 : 납품관리>납품등록>납품실적 조회 및 삭제
* 화면 : 납품실적 조회 및 삭제
* 기능 : 기 등록한 납품실적 목록을 조회하고 선택하여 삭제 할 수 있다.
* 프로그램 ID : PG_07_A_006_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
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
 
<%
	//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
 	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
	String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
	int tot_cnt = 0;                                    //전체데이타row수
 	int rec_cnt = 0;
	int page_display_cnt = 0;
%> 
<script type="text/javascript">

//최초 화면 함수 
function kep_onload_view(){
	
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToMonthAdd("2","M","noslash");
		to_date = kepGetNowTimeStr("YYYYMMDD","");
	}
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", from_date);	//납품 시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);	//납품 종료일자
	
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	// 고객사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_inv_no", "${st_inv_no}");	//발주번호
	
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}


function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n");
				return;
			}
		
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			$("#st_from_date").val(kepToMonthAdd("2","M","noslash"));
			$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD",""));
			
// 			kepSearch("-1");
			jspTableClean("table_list");
			break;
			
		case "delete":	//삭제
			setDeliveryRsltDelete();
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvDeliveryRecordDeleteList.do";
			document.forms.searchForm.submit();
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvDeliveryRecordDeleteList.do").submit();
}

function setDeliveryRsltDelete(){
	
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt	= 0;	// 납품실적삭제할 품목수		
	
	var buyer			= "";
	var po_no			= "";
	var po_seq			= "";
	var inv_no			= "";
	var inv_seq			= "";
	var delivery_date	= "";
	var delivery_qty	= "";
	var db_gr_qty = "";
	var db_buyer_nm = "";
	if(eval(tot_cnt) == 0)
	{
	    alert("조회한 데이타가 없습니다.");
	    return;
	} 
	
	if(eval(tot_cnt) < 2){
	
	    var box = eval("document.contentForm.checkbox"+0);
	    if(box.checked == true){
			chk_cnt++;
	
			buyer			= document.contentForm.db_buyer.value;
			po_no			= document.contentForm.db_po_no.value;
			po_seq			= document.contentForm.db_po_seq.value;
			inv_no			= document.contentForm.db_inv_no.value;
			inv_seq			= document.contentForm.db_inv_seq.value;
			delivery_qty	= document.contentForm.st_delivery_qty.value;
			db_gr_qty	= document.contentForm.db_gr_qty.value;
			db_buyer_nm = document.contentForm.db_buyer_nm.value;
			if(db_gr_qty >0){
				alert("고객사: "+db_buyer_nm+ " 거래명세서번호: "+inv_no+"\n고객사 입고처리건이므로 납품실적 삭제가 불가능 합니다.");
				return;
			}
			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  delivery_qty;
			query +=  "^||^" ;
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
	
				buyer			= document.contentForm.db_buyer[k].value;
				po_no			= document.contentForm.db_po_no[k].value;
				po_seq			= document.contentForm.db_po_seq[k].value;
				inv_no			= document.contentForm.db_inv_no[k].value;
				inv_seq			= document.contentForm.db_inv_seq[k].value;
				delivery_qty	= document.contentForm.st_delivery_qty[k].value;
				db_gr_qty	= document.contentForm.db_gr_qty[k].value;
				db_buyer_nm = document.contentForm.db_buyer_nm[k].value;
				if(db_gr_qty >0){
					alert("고객사: "+db_buyer_nm+ " 거래명세서번호: "+inv_no+"\n고객사 입고처리건이므로 납품실적 삭제가 불가능 합니다.");
					return;
				}
				query +=  buyer			+ "@@";
				query +=  po_no			+ "@@";
				query +=  po_seq		+ "@@";
				query +=  inv_no		+ "@@";
				query +=  inv_seq		+ "@@";
				query +=  delivery_qty	+ "@@";
				query +=  "^||^" ;
			}
		}
	}
	if(chk_cnt == "0"){
	    alert("삭제할 목록을 선택하여 주십시요");
	    return;
	}   
	
	//console.log("query ==>> " + query);
	
	if(!confirm("납품실적을 삭제 하시겠습니까?")) return;
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordDeleteList.do","searchForm","btnDelete");
	
	/*
	document.forms[0].st_query.value  = query;
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/delivery/agent_delivery_rslt_edit_reg.jsp";
	document.forms[0].submit();
	*/
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnDelete"){
		alert("납품실적삭제가  정상적으로 완료 되었습니다.");
		doAction("search");
	    //setQuery();   
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
			
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
			
		case "commonMpIvTranStatementDetailIVPop": // 거래명세서 상세조회 IV
			//var loc = "/kr/agent/invoice/agent_invoice_display_pop.jsp?";
	        //loc +=  "st_buyer="+buyer+"&st_po_no="+po_no+"&st_inv_no="+inv_no+"&st_seller="+seller+"&st_legacy_iv_serial="+legacy_iv_serial;
	        
	        var param = "";
			param  = "?st_buyer="+value1;
			param += "&st_po_no="+value2;
			param += "&st_inv_no="+value3;
			param += "&st_seller="+value4;
			param += "&st_legacy_iv_serial="+value5;
			param += "&st_tr_buyer="+value6;
			param += "&st_user_id="+$("#st_user_id").val();
			
			openSearchPopup("/mpiv/getCommonMpIvTranStatementDetailIVPop.do", param, "750,600,no");
			break;
		case "attach"://파일 첨부(등록)
			var type="IV";
			var viewType="R";
			var st_image_key_inv =  $("input[name=st_image_key_inv]").eq(value1).val();
			var st_image_key_sign =  $("input[name=st_image_key_sign]").eq(value1).val();
			var st_buyer =  $("input[name=db_buyer]").eq(value1).val();
			var st_inv_no =  $("input[name=db_inv_no]").eq(value1).val();
			if(st_image_key_inv != ""){
				popupSel = "attach";
				openSearchPopupName('/common/imageFileUploadPop.do','?DOC_NO='+st_image_key_inv+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no','attach');// 파일첨부				
			}
			if(st_image_key_sign != ""){
				popupSel = "attachSign";
				openSearchPopupName('/common/imageFileUploadPop.do','?DOC_NO='+st_image_key_sign+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no','attachSign');// 파일첨부				
			}
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

//전체선택/해제
function checkAll(){

 var tot_cnt      = $("#display_item_cnt").val();
 var check_status = $("#check_status").html();

 if(check_status == "전체"){
     for(var j = 0; j < tot_cnt; j++){
         var box = eval("document.contentForm.checkbox" + j);
         var check_status = "해제";

         if(box.checked == false) box.checked = true;
         $("#check_status").html(check_status);
     }
 }else{
     for(var j = 0; j < tot_cnt; j++){
         var box = eval("document.contentForm.checkbox" + j);
         var check_status = "전체";

         if(box.checked == true) box.checked = false;
         $("#check_status").html(check_status);
     }
 }
}
</script>
</head>

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>납품실적 조회 및 삭제</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<input type="hidden" name="st_query" value ="">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="45%" />
					<col width="12%" />
					<col width="*" />
				</colgroup>
				
				<tbody>
			        <tr>
			          <td>납품일&nbsp;&nbsp;</td>
			          <td>
			          	<input type="text"   name="st_from_date" style="width:70px;" id="st_from_date" class="input_type_text"  value="" readonly>
			          	&nbsp;~&nbsp;
						<input type="text"   name="st_to_date" style="width:70px;" id="st_to_date" class="input_type_text"  value="" readonly>
						
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
			          </td>
			          <td>거래명세서번호&nbsp;&nbsp;</td>
			          <td>
			            <input type="text" class="input_type_text" name="st_inv_no" id="st_inv_no" style="width:80%;" onKeyDown="kepEnter();">
			          </td>
			        </tr>
			        <tr>
			          <td>고객사&nbsp;&nbsp;</td>
			          <td>
			          	<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
						<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
			          </td>
			          <td>발주번호&nbsp;&nbsp;</td>
			          <td>
			            <input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
			          </td>
			        </tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow">
					<option value = "10" >10건</option>
					<option value = "20" >20건</option>
					<option value = "30" >30건</option>
					<option value = "40" >40건</option>
					<option value = "50" >50건</option> 
				</select>
      	</span>      
		<span class="fr">총건수 <%=total_cnt %></span>
       	<br>
       	
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="3%" />
 				<col width="9%" />
				<col width="9%" />
				<col width="15%" />
				<col width="10%" />
				<col width="5%" />
				<col width="12%" />
				<col width="14%" />
				<col width="8%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">
						<a href="javascript:checkAll();" id="check_status">전체</a>
					</th>
					<th scope="col" >발주번호</th>
					<th scope="col" >거래명세서번호</th>
					<th scope="col" >고객사</th>
					<th scope="col" >거래유형</th>
					<th scope="col" >배송유형</th>
					<th scope="col" >송장번호</th>
					<th scope="col" >배송상태</th>
					<th scope="col" >납품예정일</th>
					<th scope="col" >납품확정일</th>
					<th scope="col" >증빙</th>
					<th scope="col" >선입고</th>
				</tr>
			</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="8" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				++page_display_cnt;
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
		          <td>
				    <input type="hidden" name="db_buyer"        value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
			        <input type="hidden" name="db_po_no"        value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
			        <input type="hidden" name="db_po_seq"       value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
			        <input type="hidden" name="db_inv_no"       value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>">
			        <input type="hidden" name="db_inv_seq"      value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>">
			        <input type="hidden" name="db_invoice_date" value="<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>">
			        <input type="hidden" name="db_tr_buyer" value="<%=CommonUtil.nvl(rowData.get("TR_BUYER"))%>">
			        <input type="hidden" name="db_gr_qty" value="<%=CommonUtil.nvl(rowData.get("GR_QTY"))%>">
			        <input type="hidden" name="db_buyer_nm" value="<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>">
			        <input type="hidden" name="st_delivery_qty" value="<%=CommonUtil.nvl(rowData.get("DELIVERY_QTY"))%>">
		            <input type="checkbox" name="checkbox<%=j%>" value="" id="check">
		          </td>
		          <td>
		                <a href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>')" class="hyperLink" ><%=CommonUtil.nvl(rowData.get("PO_NO"))%></a>
		          </td>
		          <td>
		                <a href="javascript:doPop('commonMpIvTranStatementDetailIVPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>' ,'<%=CommonUtil.nvl(rowData.get("INV_NO"))%>' ,'<%=CommonUtil.nvl(rowData.get("SELLER"))%>' ,'<%=CommonUtil.nvl(rowData.get("LEGACY_IV_SERIAL"))%>', '<%=CommonUtil.nvl(rowData.get("TR_BUYER"))%>')" class="hyperLink" >
			                <%=CommonUtil.nvl(rowData.get("INV_NO"))%>
		                </a>
		          </td>
		          <td class="left">
		                <a href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');" class="hyperLink" ><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></a>
		          </td>
		          <td>
		          		<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_TEXT")) %>
		          </td>
		           <td>
		          		<%=CommonUtil.nvl(rowData.get("PARCEL_YN_TEXT")) %>
		          </td>
		           <td>
		                <%=CommonUtil.nvl(rowData.get("PARCEL_COM_NAME"))%>&nbsp;&nbsp;<%=CommonUtil.nvl(rowData.get("PARCEL_INV_NO"))%>
		          </td>
		          <td>
		          		<a href="<%=CommonUtil.nvl3(rowData.get("PARCEL_REAL_URL"), "")%>" target='_blank'  class="hyperLink" ><%=CommonUtil.nvl(rowData.get("PARCEL_PRO_STATUS"))%></a>
		          </td>
		          <td>
		                <%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%>
		          </td>
		           <td>
		            <%=CommonUtil.formatStrinigDate(rowData.get("DELIVERY_DATE"))%>
		          </td>
		          
		          <td>
	          		<input type="hidden" name="st_image_key_sign" id="st_image_key_sign" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_SIGN"))%>">
	          		<input type="hidden" name="st_image_key_inv" id="st_image_key_inv" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_INV"))%>">
		          <%
		          		if(!"".equals(rowData.get("IMAGE_KEY_INV"))||!"".equals(rowData.get("IMAGE_KEY_SIGN"))) {
		          %>
						<a href="javascript:doPop('attach',<%=j%>);"><img src="/resources/images/disk_on.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
		          <%
			          	}else{
		          %>
						<a href="javascript:doPop('attach',<%=j%>);"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
		          <%
			          	}
		          %>
				  </td>

					<td>
						<%=CommonUtil.nvl(rowData.get("BFRE_STCK_YN"))%>
					</td>
				
		        </tr>
	            <%
	                        }
	        			}
	            %>
			  </tbody>
            </table>
           	<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl">
        		<span class="btn_04 mr04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			</div>
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('delete');">삭제</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
