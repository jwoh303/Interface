<%--
**********************************************
* 메뉴 : 납품관리>납품현황>납품 지연 현황
* 화면 : 납품 지연 현황
* 기능 : 납품지연된 수주건 목록을 조회할 수 있다.
* 프로그램 ID : PG_07_A_007_00
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
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}

function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch("1");
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		
		// hidden값은 공통에서 처리안됨.
		$("#st_buyer_code").val("");
		
// 		kepSearch("-1");
		jspTableClean("table_list");
		break;
	
	case "save":	//저장
		setDsRemark();
		break;	

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpiv/excelSellerMpIvDeliveryDelayStateList.do";
		document.forms.searchForm.submit();
		break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	
	if(curPage != "-1"){
		if(kepIsEmpty("st_buyer_code")){
			alert("고객사를 선택해주십시오.");
			return;
		}
	}
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvDeliveryDelayStateList.do").submit();
}	

// 납품지연사유 저장
function setDsRemark(){

	var tot_cnt = $("#display_item_cnt").val();
	
	var query   = "";
    var chk_cnt	= 0;	

	var buyer			= "";
	var po_no			= "";
	var po_seq			= "";
	var ds_date			= "";
	var ds_remark		= "";

	if(eval(tot_cnt) == 0){
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
			ds_date			= document.contentForm.db_ds_date.value;
			ds_remark		= document.contentForm.st_ds_remark.value;

			if(ds_remark == ""){
				alert("납기지연사유를 입력해 주십시요");
				return;
			}

			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  ds_date		+ "@@";
			query +=  ds_remark			  ;
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
				ds_date			= document.contentForm.db_ds_date[k].value;
				ds_remark		= document.contentForm.st_ds_remark[k].value;

				if(ds_remark == ""){
					alert( (k+1) + "번째 줄에 납기지연사유를 입력해 주십시요");
					box.focus();
					return;
				}

				query +=  buyer			+ "@@";
				query +=  po_no			+ "@@";
				query +=  po_seq		+ "@@";
				query +=  ds_date		+ "@@";
				query +=  ds_remark			  ;
				query +=  "^||^" ;
			}
		}
    }

    if(chk_cnt == "0"){
        alert("납기지연사유를 저장할 품목을 선택하여 주십시요");
        return;
    }   

	//console.log(query);
	
	if(!confirm("납기지연사유를 저장 하시겠습니까?")) return;

	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryDelayStateList.do","searchForm","btnSave");
	
	/*
	document.forms[0].st_query.value  = query;
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/delivery/agent_delivery_delay_ds_remark_reg.jsp";
	document.forms[0].submit();
	*/
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	//var msg = response.Message;
	
	if(pMethod == "btnSave"){
		alert("납기지연사유가 정상적으로 저장 되었습니다.");
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
function doPop(str,value1, value2, value3, value4) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
		case "sellerMpIvDeliveryDelayBuyerChoicePop": // 납품지연고객사선택
			openSearchPopup("/mpiv/getSellerMpIvDeliveryDelayBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "460,410,no");
			// return setBuyerChoiceReturn
			break;
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
	}
}

//지연사유 팝업창
function setDelayReason(x){
	
	$("#x").val(x);
	
	openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayStateReasonPop.do", "", "520,410,no");
}

//지연사유 값 얻기
function getReason(){

  var disp_cnt = $("#display_item_cnt").val();
  var x        = $("#x").val();
  var reason_text = "";

  if(eval(disp_cnt) < 2){
      reason_text = document.contentForm.st_ds_remark.value;
  }else{
      reason_text = document.contentForm.st_ds_remark[x].value;
  }
  return reason_text;
}

//지연사유 입력
 // value(지연사유) , flag ==> 해당품목(one) 또는 모든품목(all)
function setReason(value,flag){
	
	var disp_cnt	= $("#display_item_cnt").val();
	var x			= $("#x").val();
	
	var image_obj = "";
	var image_url = "";
	
	if(value==""){
		image_url = "/resources/images/but_img_off.gif";
	}else{
		image_url = "/resources/images/but_img_on.gif";
	}	
	
	if(flag =="one"){ // 해당품목 적용
		
		$("#st_ds_remark"+x).val(value);
	
		image_obj = "reason_img" + x;
		
		MM_swapImage(image_obj,'',image_url,1);
		
		// 체크박스
		var box = eval("document.contentForm.checkbox" + x);
		box.checked = true;
		
	} else { // 모든품목에 적용

		if(eval(disp_cnt) < 2){
			$("#st_ds_remark"+x).val(value);
			
			image_obj = "reason_img" + x;
			
			MM_swapImage(image_obj,'',image_url,1);
			
			// 체크박스
			var box = eval("document.contentForm.checkbox" + x);
			box.checked = true;
		} else {

			var buyer	= document.contentForm.db_buyer[x].value;
			var po_no	= document.contentForm.db_po_no[x].value;
			var ds_date = document.contentForm.db_ds_date[x].value;
			
			for(var k=0; k<disp_cnt ; k++) {
				// 같은 납품예정일인지 체크 
				var temp_buyer		= document.contentForm.db_buyer[k].value;
				var temp_po_no		= document.contentForm.db_po_no[k].value;
				var temp_ds_date	= document.contentForm.db_ds_date[k].value;
				
				if(buyer == temp_buyer && po_no == temp_po_no && ds_date == temp_ds_date){
					document.contentForm.st_ds_remark[k].value = value;
					image_obj = "reason_img" + k;
					MM_swapImage(image_obj,'',image_url,1);
					
					var box = eval("document.contentForm.checkbox" + k);
					box.checked = true;
				}
			}
		}
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

//전체선택/해제
function checkAll(){
	var tot_cnt      = document.contentForm.display_item_cnt.value;
	var check_status = $("#check_status").html();
	
	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "해제";
			
			if(box.checked == false) box.checked = true;
			
			$("#check_status").html(check_status);
		}
	} else {
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "전체";
			
			if(box.checked == true) box.checked = false;
			
			$("#check_status").html(check_status);
		}
	}
}

function MM_swapImage() { //v3.0
	var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function MM_findObj(n, d) { //v4.0
	var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	if(!x && document.getElementById) x=document.getElementById(n); return x;
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
	<h3>납품 지연 현황</h3>
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
			
		<input type="hidden" id="st_query" name="st_query" value ="">
		<input type="hidden" id="x" name="x" value="">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="35%" />
					<col width="9%" />
					<col width="*" />
				</colgroup>
				
				<tbody>
					<tr>
						<td><font color="red">*</font> 고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
							<a href="javascript:doPop('sellerMpIvDeliveryDelayBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
						<td>발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" value="" onKeyDown="kepEnter();">
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
      	<span class="fl">※한달 기준으로 납기지연건이 조회됩니다.</span>
      	<span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list04" style="width:100%">
			<colgroup>
	            <col width="3%" />
	            <col width="" />
	            <col width="9%" />
	            <col width="21%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="15%" />
	            <col width="10%" />
	            <col width="8%" />
	        </colgroup>
			<thead>
				<tr>
					<th scope="col" rowspan="2">
						<a href="javascript:checkAll();" id="check_status">전체</a>
					</th>
					<th scope="col">고객사</th> 
					<th scope="col">품목코드</th> 
					<th scope="col">품목명</th>
					<th scope="col">단가/단위</th>
					<th scope="col">발주수량</th>
					<th scope="col">발주자</th>
					<th scope="col">관리번호</th>
					<th scope="col">사유</th>
				</tr>
				<tr>
					<th scope="col">발주번호</th> 
					<th scope="col">발주일</th> 
					<th scope="col">규격</th>
					<th scope="col">납품예정일</th>
					<th scope="col">납품예정수량</th>
					<th scope="col">요청자(부서)</th>
					<th scope="col">KEP납품일</th>
					<th scope="col">지연일수</th>
				</tr>
			</thead>
			<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
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
					<!-- HIDDEN 공통 --> 
					<td rowspan="2">
						<input type="hidden" name="db_buyer"        value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
				    	<input type="hidden" name="db_po_no"        value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
				        <input type="hidden" name="db_po_seq"       value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
				        <input type="hidden" name="db_ds_date"       value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>">
			            <input type="checkbox" name="checkbox<%=j%>" value="" id="check">
					</td>
					<td title="고객사" class="left">
		                <a href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');" class="hyperLink" >
		                	<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
		                </a>
		          	</td>
                    <td title="품목코드" class="left">
	                    <a href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
						</a>
                    </td>
                    <td title="품목명" class="left"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
                    <td title="단가/단위" class="right"><%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
                    <td title="발주수량" class="right"><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
                    <td title="발주자"><%=CommonUtil.nvl(rowData.get("PURCHASER"))%></td>
                    <td title="관리번호" class="left"><%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%></td>
                    <td title="사유">
                    	<a href="javascript:setDelayReason('<%=j%>');">
					 		<img id="reason_img<%=j%>" name="reason_img<%=j%>" src='/resources/images/<%=CommonUtil.nvl(rowData.get("DS_REMARK_IMG"))%>' border="0" align="absmiddle">
					 	</a>
					 	<input type="hidden" id="st_ds_remark<%=j%>" name="st_ds_remark" value="<%=CommonUtil.nvl(rowData.get("DS_REMARK"))%>">
                    </td>
				</tr>
				<tr bgcolor="<%=tclass%>">
                    <td title="발주번호">
                    	<a href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>')" class="hyperLink" >
                    		<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
                    	</a>
                    </td>
                    <td title="발주일"><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
                    <td title="규격" class="left"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
                    <td title="납품예정일"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
                    <td title="납품예정수량" class="right"><%=CommonUtil.formatNumber(rowData.get("CD_QTY"),true,0,3)%></td>
                    <td title="요청자"><%=CommonUtil.nvl(rowData.get("REQ_USER"))%>(<%=CommonUtil.nvl(rowData.get("REQ_DEPT"))%>)</td>                    
                    <td title="KEP납품일" ><%=CommonUtil.formatStrinigDate(rowData.get("ST_DATE"))%></td>
                    <td title="지연일수"><%=CommonUtil.nvl(rowData.get("DS_DELAY_DAY"))%>일</td>
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
			</div>
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('save');">저장</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
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
