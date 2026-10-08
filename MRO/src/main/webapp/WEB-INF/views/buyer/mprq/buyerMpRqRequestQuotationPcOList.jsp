<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품견적의뢰
* 기능 : 고객사가 운영사에게 신규상품 견적의뢰를 한다
* 프로그램 ID : PG_02_B_000834_011
* 담당자 : 현명환
* 생성일 : 2015-03-16
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
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
	String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
	String buyer =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
    String inventory_gubun_flag2  = CommonUtil.nvl((String)request.getAttribute("inventory_gubun_flag2"),"");
    SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
    if(inventory_gubun_flag2.equals(""))
    {
       inventory_gubun_flag2 = "ALL";
    }
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
	String read_only =""; 
	 //전사공구 주문가능
	 boolean getCode144 = CommonUtil.getCodeCheckReturn("M144",sessionInfo.getUserId());

%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
	
<div id="ContArea">
	<h3>신규상품 견적의뢰</h3>
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_pass_flag" id="st_pass_flag" value="">
			<input type="hidden" name="inventory_gubun_flag2" value="<%=inventory_gubun_flag2%>">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			<input type="hidden" name="rowi"                value="">
			<!-- 비교견적서 변수-->
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption>신규상품 견적의뢰</caption>
					<colgroup>
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
						<col width="22%" />
					</colgroup>
					
					<tbody>
					<tr >
						<td >의뢰자</td>
						<td ><label>: ${sessionInfo.userNameLoc}</label></td>
						<td >이메일</td>
						<td ><input type="text"  id="st_btoa_user_mail" name="st_btoa_user_mail"  style="width:90%" value="${sessionInfo.email}"></td>
						<td >연락처</td>
						<td ><input type="text" id="st_btoa_user_tel" name="st_btoa_user_tel"  style="width:90%" value="${sessionInfo.tel}"></td>
					</tr>
				</tbody>
			</table>
		</div>
			※ <span><font color="blue"><b>C</b></font></span> : 클릭 행 복사, <span><font color="blue"><b>D</b></font></span> : 클릭 행 삭제
	</form> 
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<input type="hidden" name="file_get_y" id="file_get_y"         value="">
	<input type="hidden" name="rowi" id="rowi"               value="">
	<table class="cont_t_list02" style="width:100%">
		<colgroup>
            <col width="5%" />
            <col width="5%" />
            <col width="10%" />
            <col width="37%" />
            <col width="10%" />
            <col width="10%" />
            <col width="11%" />
            <col width="12%" />
        </colgroup>
        <thead>
			<tr >
				<th rowspan="2" > 
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="checkAll();">
				</th> 
				<th rowspan="2" >번호</th>
				<th>품목코드</th>
				<th><font color="#FF6600">*</font>품목명</th>
				<th>실적단가</th>  
				<th>단위</th>
				<th><font color="#FF6600">*</font>품목구분</th>
				<th>년예상소요량</th>
			</tr>
			<tr >
				<th><font color="#FF6600">*</font>수량</th>
				<th><font color="#FF6600">*</font>규격</th>  
				<th><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;">회신요청일</font></a></th> 
				<th>첨부파일</th>
				<th colspan="2" style="text-decoration:underline;"><a href="javascript:remarkCopy();">비고</a></th>
			</tr> 
		</thead>
            </table>
            <table id="tblshow" class='cont_t_list022'></table>
		<!--페이징-->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!--버튼영역-->
		<div class="btnArea">
        	<div class="fl">
				<span class="btn_03 mr04"><a href="javascript:doAction('saveTemp')">임시저장</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('add')">행추가</a></span>
				<span class="btn_02"><a href="javascript:doAction('del')">삭제</a></span>
            </div>
            <div class="fr">
				<span class="btn_02">
					<a href="javascript:doAction('reg');">견적의뢰</a>
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
var gridIndex = 0;  
var popupSel = "";
var btnEvent = "";
var g_Row          =  0;
// 최초 화면 함수
function kep_onload_view(){
	addrows();
}	

function addrows(){
	var unit_measure    = "<select name='st_unit_measure' id=\"st_unit_measure\"><%= CommonUtil.getCodeBComboList("KRDOOD0001","SEL","C013","ICOMCOD2","CODE","TEXT1") %></select>";
	var item_gubun    = "<select name='st_item_gubun_flag' id=\"st_item_gubun_flag\"><%= CommonUtil.getCodeBComboList("KRDOOD0001","SEL","C014","ICOMCOD2","CODE","TEXT1") %></select>";
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var idx         = rows.length;

	bFlag			= true;

    var vSeq = document.all['seqNo'];

    if(vSeq == null) {
          numkey =idx +1;
    }else {
        if(vSeq.length == null) {
           numkey =2;
         }else {
          numkey = vSeq.length+1;
         }
    }

    var newRow  = objrow.insertRow(idx);
    var td00 = newRow.insertCell();
    var td01 = newRow.insertCell();
    var td02 = newRow.insertCell();
    var td03 = newRow.insertCell();
    var td04 = newRow.insertCell();
    var td05 = newRow.insertCell();
    var td06 = newRow.insertCell();

    newRow.onmouseover = function() {objrow.clickedRowIndex=this.rowIndex;};

    td00.width = "5%";
    td00.innerHTML = "<table width='100%'><tr><td align='center'><input type='checkbox' name='InCheck'"+numkey+" id='InCheck'"+numkey+"><input type='hidden' name='excel_up' id='excel_up' value='N'></td></tr><tr><td>&nbsp;</td></tr></table>";

    td01.width = "5%";
    td01.innerHTML = "<table border='0' width='100%'><tr><td align='center'><label id='seqNo'>"+numkey+"</label></td></tr><tr><td align='center'><a href=\"javascript:Del();\"><font color='blue'>D</font></a> | <a href=\"javascript:copy();\"><font color='blue'>C</font></a></td></tr></table>";

    td02.width = "10%";
    td02.innerHTML = "<table border='0' width='100%'><tr><td align='center'><input type=\"text\" name='st_buyer_item_no' id='st_buyer_item_no' class=\"bbb\" style=\"width:95%;\"></td></tr><tr><td align='center'><input type=\"hidden\" name='st_item_qty' id='st_item_qty' style=\"width:95%;\"><input type=\"text\" name='st_item_qty_text' id='st_item_qty_text' style=\"width:95%;text-align:right; padding-right:1px;\" onblur=\"displayNumbering('ITEM_QTY', "+numkey+");\"></td></tr></table>";

	td03.width = "37%";
    td03.innerHTML = "<table border='0' width='100%'><tr><td align='center'><input type=\"text\" name='st_description' id='st_description' class=\"bbb\" maxlength=\"50\" style=\"width:90%;\" onclick=\"addItemInfo(this.rowIndex);\" readonly></td></tr><tr><td align='center'><input type=\"text\" name='st_specification' id='st_specification' maxlength=\"250\" class=\"bbb\" style=\"width:90%;\"></td></tr></table>";

    td04.width = "10%";
    td04.innerHTML = "<table border='0' width='100%'><tr><td width=\"50%\"><input type=\"hidden\" name='st_buyer_target_price' id='st_buyer_target_price'><input type=\"text\" name='st_buyer_target_price_text' id='st_buyer_target_price_text' <%=read_only%> style=\"width:92%;text-align:right;padding-right:1px;\" onblur=\"displayNumbering('BUYER_TARGET_PRICE', "+numkey+");\"></td></tr><tr><td><input type=\"text\" name='st_btoa_end_date_text' id='st_btoa_end_date_text' style=\"width:92%;text-align:center;\" onclick=\"doPop('calendar',"+numkey+");\" readonly><input type=\"hidden\" name='st_btoa_end_date' id='st_btoa_end_date' value=\"\"></td></tr></table>";

    td05.width = "10%";
    td05.innerHTML = "<table border='0' width='100%'><tr><td align='center'>"+unit_measure+"</td></tr><tr><td align='center'><input type='hidden' name='st_category_id' id='st_category_id' value=''><input type='hidden' name='st_save_flag' id='st_save_flag' value=''><input type='hidden' name='inventory_gubun_flag' id='inventory_gubun_flag' value=''><input type='hidden' name='st_image_key' id='st_image_key' value=''><a href=\"javascript:doPop('attach',this)\"><img src=\"/resources/images/disk_off.gif\" name=\"Image2\" width=\"14\" height=\"14\" border=\"0\"></a></td></tr></table>";
    td06.width ="23%";
    td06.innerHTML = "<table border='0' width='100%'><tr><td width=\"110\">"+item_gubun+"</td><td width=\"130\"><input type=\"text\" name='st_year_qty_text' id='st_year_qty_text' style=\"width:95%;;text-align:right;\" class=\"bbb\" ></td></tr><tr><td colspan='3'><input type=\"text\" name='st_btoa_remark' id='st_btoa_remark' maxlength=\"400\" class=\"bbb\" style=\"width:99%;\"></td></tr></table>";
  	
}
function setReturnValue2(description, specification, category_id, inventory_gubun_flag){
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
    var rowi        = document.searchForm.rowi.value;

    document.searchForm.inventory_gubun_flag2.value = inventory_gubun_flag;

    if(eval(tot_cnt) < 2){

        document.contentForm.InCheck.checked        = true;
        document.contentForm.st_description.value   = description;
        document.contentForm.st_specification.value = specification;
        document.contentForm.st_category_id.value   = category_id;
        document.contentForm.inventory_gubun_flag.value = inventory_gubun_flag;

    }else {

        document.contentForm.InCheck[rowi].checked        = true;
        document.contentForm.st_description[rowi].value   = description;
        document.contentForm.st_specification[rowi].value = specification;
        document.contentForm.st_category_id[rowi].value   = category_id;
        document.contentForm.inventory_gubun_flag[rowi].value = inventory_gubun_flag;
    }

    document.searchForm.rowi.value="";
}
//각 해당 ROW 삭제
function Del(){
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
	bFlag			= true;

    if(tot_cnt <=1) {
        alert("삭제할수 없습니다.");
        return;
    }

    objrow.deleteRow(objrow.clickedRowIndex);
    LabelSort();

}
function addItemInfo(row)
{
	var objrow      = document.all['tblshow'];
    document.searchForm.rowi.value = objrow.clickedRowIndex;
	 var buyer = "<%=buyer%>";
	 var inventory_gubun_flag2 = 	document.searchForm.inventory_gubun_flag2.value;
	 
    if(buyer == "KRDOOS0004"){
    	
    }else{

	    if(inventory_gubun_flag2 == "ALL"){
	    	getBuyerSourcingItemGubunPop();
	    }else{
	    	getBuyerSourcingItemPop();
	    }
    }
}
//레이블 소팅
function LabelSort() {
    var vSeqNo = document.all['seqNo'];

    if(vSeqNo == null){

    }else if(vSeqNo.length == null) {
          vSeqNo.innerHTML =1;
    } else {
        for(var i=0; i<vSeqNo.length; i++) {
        	vSeqNo[i].innerHTML = i+1;
        }
    }
}

function displayNumbering(type, row) {
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
    var rowIndex = eval(row)-1;
    var imsi_target_qty = "";
    var imsi_buyer_target_price = "";
     if(eval(tot_cnt) < 2){
        imsi_target_qty             = kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));          // 수량 - 고정
        imsi_buyer_target_price     = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price.value           = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text.value      = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty.value             = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text.value        = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }else{
        imsi_target_qty             = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty_text[rowIndex].value));            // 수량 - 고정
        imsi_buyer_target_price     = kepTrimStr(kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[rowIndex].value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price[rowIndex].value         = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text[rowIndex].value        = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty[rowIndex].value           = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text[rowIndex].value      = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }
}
function btoaDateCopy() {
    var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_end_date_text  = "";
    var btoa_end_date       = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text.value;
            btoa_end_date   =  document.forms.contentForm.st_btoa_end_date.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text[j].value;
                btoa_end_date   =  document.forms.contentForm.st_btoa_end_date[j].value;
                break;
            }
        }
    }
    if(checked_count==0) {
        alert("회신요청일을 복사할 품목을 선택하여 주십시요.");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_end_date[j].value         = btoa_end_date;
                document.forms.contentForm.st_btoa_end_date_text[j].value    = btoa_end_date_text;
            }else {
                document.forms.contentForm.st_btoa_end_date[j].value         = "";
                document.forms.contentForm.st_btoa_end_date_text[j].value    = "";
            }
        }
    }else {
        alert("견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.");
        return;
    }
}

function remarkCopy() {
	var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_remark         = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_remark =  document.forms.contentForm.st_btoa_remark.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_remark =  document.forms.contentForm.st_btoa_remark[j].value;
                break;
            }
        }
    }

    if(checked_count==0) {
        alert("복사할 비고를 선택하여 주십시요.");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_remark[j].value           = btoa_remark;
            }else {
                document.forms.contentForm.st_btoa_remark[j].value           = "";
            }
        }
    }else {
        alert("견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.");
        return;
    }
}

// 행복사
function copy(obj) {
    var objrow      = document.all['tblshow'];
	bFlag=true;
    addrows();
    
    var targetIndex = objrow.rows.length-1;
    if(objrow.rows.length > 1) {
        document.forms.contentForm.st_buyer_item_no[targetIndex].value           = document.forms.contentForm.st_buyer_item_no[objrow.clickedRowIndex].value;         // 제품번호
        document.forms.contentForm.st_item_qty_text[targetIndex].value           = document.forms.contentForm.st_item_qty_text[objrow.clickedRowIndex].value;         // 수량
        document.forms.contentForm.st_description[targetIndex].value             = document.forms.contentForm.st_description[objrow.clickedRowIndex].value;           // 품명
        document.forms.contentForm.st_buyer_target_price_text[targetIndex].value     = document.forms.contentForm.st_buyer_target_price_text[objrow.clickedRowIndex].value;   // 실적단가
        document.forms.contentForm.st_btoa_end_date[targetIndex].value           = document.forms.contentForm.st_btoa_end_date[objrow.clickedRowIndex].value;         // 회신요처일
        document.forms.contentForm.st_btoa_end_date_text[targetIndex].value      = document.forms.contentForm.st_btoa_end_date_text[objrow.clickedRowIndex].value;    // 회신요처일
        document.forms.contentForm.st_specification[targetIndex].value           = document.forms.contentForm.st_specification[objrow.clickedRowIndex].value;         // 규격
        document.forms.contentForm.st_unit_measure[targetIndex].value        = document.forms.contentForm.st_unit_measure[objrow.clickedRowIndex].value;          // 단위
        document.forms.contentForm.st_btoa_remark[targetIndex].value         = document.forms.contentForm.st_btoa_remark[objrow.clickedRowIndex].value;           // 비고
        document.forms.contentForm.st_year_qty_text[targetIndex].value         = document.forms.contentForm.st_year_qty_text[objrow.clickedRowIndex].value;           // 카테고리번호
        document.forms.contentForm.st_year_qty_text[targetIndex].value         = document.forms.contentForm.st_year_qty_text[objrow.clickedRowIndex].value;           // 년예상소요량
        document.forms.contentForm.st_item_gubun_flag[targetIndex].value         = document.forms.contentForm.st_item_gubun_flag[objrow.clickedRowIndex].value;           // 아이템구분
        document.forms.contentForm.inventory_gubun_flag[targetIndex].value       = document.forms.contentForm.inventory_gubun_flag[objrow.clickedRowIndex].value;     // 재고구분
        document.forms.contentForm.st_category_id[targetIndex].value             = document.forms.contentForm.st_category_id[objrow.clickedRowIndex].value;           //
        document.forms.contentForm.InCheck[targetIndex].checked = true;
    }
}

//기능함수
function doAction(str) {
	btnEvent = str;
	st = new Date();
	switch (str) {
	case "reg":
		saveReq("REG");
		break;
	case "add":
		addrows();
		break;
	case "del":
		checkedDel();
		break;
	case "saveTemp":
		saveReq("TEMP");
		break;
	}
}


/**
 * FORM 을 초기화
 */
function reload(){
	$('#searchForm').attr("action", "/mprq/showBuyerMpRqRequestQuotationPcO.do").submit();   
}
/**
 * 임시저장
 */
function saveReq(GBN){
	   var objrow        = document.all['tblshow'];
	    var rows          = objrow.rows;
	    var tot_cnt       = rows.length;
	    var query         = "";
	    var checked_count = 0;
	    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
	    var user_id		=  document.searchForm.st_user_id.value;
	    var getCode144 = <%=getCode144%>;
	    
	    if(tot_cnt==1) {
	        if(document.contentForm.InCheck.checked==true) checked_count = 1;
	    }else {
	        for(var j = 0; j < tot_cnt; j++) {
	            if(document.contentForm.InCheck[j].checked==true) {
	                checked_count++;
	            }
	        }
	    }
	    
	    if(checked_count==0) {
	        alert("견적의뢰할 품목을 선택하여 주십시요.");
	        return;
	    }
	    if(tot_cnt==1) {
	        if(document.forms.contentForm.InCheck.checked==true) {
	            var item_qty                = document.forms.contentForm.st_item_qty.value;              // 수량
	            var item_qty_text           = kepFilterNum(document.forms.contentForm.st_item_qty_text.value);    // 수량
	            var description             = document.forms.contentForm.st_description.value;           // 품명
	            var buyer_target_price      = document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
	            var buyer_target_price_text = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));    // 실적단가
	            var btoa_end_date           = document.forms.contentForm.st_btoa_end_date.value;         // 회신요처일
	            var specification           = document.forms.contentForm.st_specification.value;         // 규격
	            var year_qty_text           = kepFilterNum(kepTrimStr(document.forms.contentForm.st_year_qty_text.value));              // 년예상소요량
	            var item_gubun_flag         = document.forms.contentForm.st_item_gubun_flag.value;       // 품목구분
	            var unit_measure         = document.forms.contentForm.st_unit_measure.value;          // 단위
	            var image_key            = document.forms.contentForm.st_image_key.value              // 첨부파일 이미지 키
	            var btoa_remark          = document.forms.contentForm.st_btoa_remark.value;           // 비고
	            var inventory_gubun_flag = document.forms.contentForm.inventory_gubun_flag.value;
	            var category_id          = document.forms.contentForm.st_category_id.value;
	            var category_id_msg      = category_id.substr(0,6);
	            var buyer_item_no        = document.forms.contentForm.st_buyer_item_no.value;
	            
	            if(GBN == "TEMP"){
	            	document.forms.contentForm.st_save_flag.value = "TEMP";
	            }else{
	            	document.forms.contentForm.st_save_flag.value = "REG";
	            }
	            
	            
	            if(parseInt(btoa_end_date) < parseInt(nowDate)) {
	                alert("회신요청일은 현재일 이후여야 합니다.");
	                return;
	            }
	            if(category_id_msg == "R-G-03"){
	            	if(getCode144 != true){
	            	    alert("법정 안전보호구 카테고리는 산업안전보호법의 규정에 따르기 위해 아래 담당자만 가능 합니다.  \n\n  원자력 BG : 조진용 사원(7449)  \n\n  주단 BG : 정영재 대리(7260)  \n\n  터빈/발전 BG : 황규원 사원(7294)  \n\n  보일러 BG : 전상우 대리(7293)  \n\n  전사/관리부분 : 이태용 대리(7915), 허녕 대리(7921)   ");
	            	    return; 
	            	}
	        	}else if (category_id_msg == "R-A-04"){
            	    alert("작업공구류 견적시 TTMS에서 08코드 먼저 생성 후 해당코드로 견적의뢰 하시기 바랍니다.");
            	    return;
	        	}
	            if(item_gubun_flag == "T"){
            	  if(kepIsValueNull(year_qty_text)){
            	  	 alert(" 단가계약요청품목의 경우 년간예상소요량을 입력하셔야 합니다.  ");
            	     return;
            	  }
	            }else{
			       year_qty_text = 0;
			    }
	            if(kepIsValueNull(item_gubun_flag)){
	            	alert(" 품목구분정보를 선택해 주시기 바랍니다.   ");
	            	return;
	            }
	            if(kepIsValueNull(unit_measure)){
	            	alert(" 단위를 선택해 주십시오.   ");
	            	return;
	            }
	            if(!kepIsNumChkStr(item_qty_text, 3)) {
	                alert("수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.  ");
	                document.contentForm.st_item_qty.value ="";
	                return;
	            }

	            // 품명 체크
	            if(kepIsValueNull(kepTrimStr(description))) {
	                alert("품명을 입력하여 주십시오.");
	                return;
	            }

	            if(!kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
	                if(!chkDecimal(buyer_target_price_text, 3)) {
	                    alert("실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.");
	                    document.contentForm.st_buyer_target_price.value   = "";
	                    return;
	                }
	            }else {
	                buyer_target_price = 0;
	            }

				// 규격 체크
	            if(kepIsValueNull(kepTrimStr(specification))) {
	                alert("규격을 입력하여 주십시오.");
	                return;
	            }
	            // 회신요청일 체크
	            if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	                alert("회신요청일을 입력하여 주십시오..");
	                return;
	            }


	            document.forms.contentForm.st_description.value   = FilterString(description);
	            document.forms.contentForm.st_specification.value = FilterString(specification);
	            document.forms.contentForm.st_btoa_remark.value   = FilterString(btoa_remark);

	        }

	    }else {
	        for(var i = 0; i < tot_cnt; i++) {
		        if(document.forms.contentForm.InCheck[i].checked==true) {
		            var item_qty                = document.forms.contentForm.st_item_qty[i].value;              // 수량
		            var item_qty_text           = kepFilterNum(document.forms.contentForm.st_item_qty_text[i].value);    // 수량
		            var description             = document.forms.contentForm.st_description[i].value;           // 품명
		            var buyer_target_price      = document.forms.contentForm.st_buyer_target_price[i].value;    // 실적단가
		            var buyer_target_price_text = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text[i].value));    // 실적단가
		            var btoa_end_date           = document.forms.contentForm.st_btoa_end_date[i].value;         // 회신요처일
		            var specification           = document.forms.contentForm.st_specification[i].value;         // 규격
		            var year_qty_text           = kepFilterNum(kepTrimStr(document.forms.contentForm.st_year_qty_text[i].value));              // 년예상소요량
		            var item_gubun_flag         = document.forms.contentForm.st_item_gubun_flag[i].value;       // 품목구분
		            var unit_measure         = document.forms.contentForm.st_unit_measure[i].value;          // 단위
		            var image_key            = document.forms.contentForm.st_image_key[i].value              // 첨부파일 이미지 키
		            var btoa_remark          = document.forms.contentForm.st_btoa_remark[i].value;           // 비고
		            var inventory_gubun_flag = document.forms.contentForm.inventory_gubun_flag[i].value;
		            var category_id          = document.forms.contentForm.st_category_id[i].value;
		            var category_id_msg      = category_id.substr(0,6);
		            var buyer_item_no        = document.forms.contentForm.st_buyer_item_no[i].value;
		            
		            if(GBN == "TEMP"){
		            	document.forms.contentForm.st_save_flag[i].value = "TEMP";
		            }else{
		            	document.forms.contentForm.st_save_flag[i].value = "REG";
		            }
		            
		            if(parseInt(btoa_end_date) < parseInt(nowDate)) {
		                alert("회신요청일은 현재일 이후여야 합니다.");
		                return;
		            }
		            if(category_id_msg == "R-G-03"){
		            	if(getCode144 != true){
		            	    alert("법정 안전보호구 카테고리는 산업안전보호법의 규정에 따르기 위해 아래 담당자만 가능 합니다.  \n\n  원자력 BG : 조진용 사원(7449)  \n\n  주단 BG : 정영재 대리(7260)  \n\n  터빈/발전 BG : 황규원 사원(7294)  \n\n  보일러 BG : 전상우 대리(7293)  \n\n  전사/관리부분 : 이태용 대리(7915), 허녕 대리(7921)   ");
		            	    return; 
		            	}
		        	}else if (category_id_msg == "R-A-04"){
	            	    alert("작업공구류 견적시 TTMS에서 08코드 먼저 생성 후 해당코드로 견적의뢰 하시기 바랍니다.");
	            	    return;
		        	}
		            if(item_gubun_flag == "T"){
	            	  if(kepIsValueNull(year_qty_text)){
	            	  	 alert(" 단가계약요청품목의 경우 년간예상소요량을 입력하셔야 합니다.  ");
	            	     return;
	            	  }
		            }else{
				       year_qty_text = 0;
				    }
		            if(kepIsValueNull(item_gubun_flag)){
		            	alert(" 품목구분정보를 선택해 주시기 바랍니다.   ");
		            	return;
		            }
		            if(kepIsValueNull(unit_measure)){
		            	alert(" 단위를 선택해 주십시오.   ");
		            	return;
		            }
		            if(!kepIsNumChkStr(item_qty_text, 3)) {
		                alert("수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.  ");
		                document.contentForm.st_item_qty.value ="";
		                return;
		            }

		            // 품명 체크
		            if(kepIsValueNull(kepTrimStr(description))) {
		                alert("품명을 입력하여 주십시오.");
		                return;
		            }

		            if(!kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
		                if(!chkDecimal(buyer_target_price_text, 3)) {
		                    alert("실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.");
		                    document.contentForm.st_buyer_target_price.value   = "";
		                    return;
		                }
		            }else {
		                buyer_target_price = 0;
		            }

					// 규격 체크
		            if(kepIsValueNull(kepTrimStr(specification))) {
		                alert("규격을 입력하여 주십시오.");
		                return;
		            }
		            // 회신요청일 체크
		            if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
		                alert("회신요청일을 입력하여 주십시오..");
		                return;
		            }


		            document.forms.contentForm.st_description[i].value   = FilterString(description);
		            document.forms.contentForm.st_specification[i].value = FilterString(specification);
		            document.forms.contentForm.st_btoa_remark[i].value   = FilterString(btoa_remark);

		        }
	        }
	    }
		var chkFlag = false;
		var chkGridValue = {};
		var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
		if(formArr != null && formArr !=""){

			$("#processForm").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
			$("#process").html(formArr[1]);
			$("#process").find("#check_status").remove();
		}else{
			alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
			return;
		}
		kepAjaxFormCall("/mprq/saveBuyerMpRqTempQuotationPCO.do","processForm",btnEvent); 
}
//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
	case "calendar": // 달력
		g_Row = value1;
		gridIndex = value1;
		openSearchPopup('/common/calendarPop.do','','130,240,no');
		break;
	case "attach":
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt         = rows.length;
		var image_key = "";
	    if(eval(tot_cnt) < 2) {
	        image_key = document.forms.contentForm.st_image_key.value;
	    }else{
	        image_key = document.forms.contentForm.st_image_key[objrow.clickedRowIndex].value;
	    }
	    document.forms.contentForm.file_get_y.value = objrow.clickedRowIndex;

		var type="RFQ";
		var viewType="VI";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "country") {
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    var rowi        = document.forms.contentForm.rowi.value;

	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.InCheck.checked        = true;
	        document.forms.contentForm.st_origin_name.value   = value;
	        document.forms.contentForm.st_origin_code.value   = code;
	    }else {
	        document.forms.contentForm.InCheck[rowi].checked      = true;
	        document.forms.contentForm.st_origin_name[rowi].value = value ;
	        document.forms.contentForm.st_origin_code[rowi].value = code ;
	    }
	    document.forms.contentForm.rowi.value="";
	} else if (popupSel == "buyerMpRqUserRemarkPop"){
		
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt         = rows.length;
	    
	    if(eval(tot_cnt)<=1) { 
	        document.forms.contentForm.st_btoa_remark.value  = code; 
	    }else { 
	        var pos = document.forms.contentForm.file_get_y.value; 
	        document.forms.contentForm.st_btoa_remark[pos].value = code; 
	    } 
	}else if (popupSel == "attach") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    var y       = document.forms.contentForm.file_get_y.value;
	    
	    if(eval(tot_cnt) < 2) {
	        document.forms.contentForm.st_image_key.value = code;
	    }else {
	        document.forms.contentForm.st_image_key[y].value = code;
	    }
	    if(code != ''){
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = code;
	            document.forms.contentForm.Image2.src = diskOn;
	        }else{
	            document.forms.contentForm.st_image_key[y].value = code;
	            document.forms.contentForm.Image2[y].src = diskOn;
	        }
	    }else{
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = "";
	            document.forms.contentForm.Image2.src = diskOff;
	        }else{
	            document.forms.contentForm.st_image_key[y].value = "";
	             document.forms.contentForm.Image2[y].src = diskOff;
	        }
	    }
		
	}
}

function setPopupCalendar(year,month,day){
    var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_end_date   = year.toString()+month.toString()+day.toString();
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    if(parseInt(btoa_end_date) < parseInt(nowDate)) {
        alert("회신요청일은 현재일 이후여야 합니다.");
        return;
    }
    if(eval(tot_cnt)<=1)  {
        document.forms.contentForm.InCheck.checked=true;
        document.forms.contentForm.st_btoa_end_date_text.value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date.value = btoa_end_date;
    }
    else {
        document.forms.contentForm.InCheck[g_Row-1].checked=true;
        document.forms.contentForm.st_btoa_end_date_text[g_Row-1].value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date[g_Row-1].value = btoa_end_date;
    }
}

//체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
//재귀함수
var changed_i=0;
var changed_tot_cnt     = 0;

function checkedDel() {
 changed_i=0;
 var vSeqNo              = document.all['seqNo'];
 var objrow              = document.all['tblshow'];
 var rows                = objrow.rows;
 changed_tot_cnt     = rows.length;
 var checked_count       = 0;

 if(changed_tot_cnt==1) {
     if(document.forms.contentForm.InCheck.checked==true) checked_count=1;
 }else {
     for(var j=0; j<changed_tot_cnt; j++) {
         if(document.forms.contentForm.InCheck[j].checked==true) checked_count++;
     }
 }
 if(checked_count==0 && changed_i==0) {
     LabelSort();
     return;
 }
 if(checked_count == changed_tot_cnt || changed_tot_cnt==1 || checked_count==0) {
     alert("모든 데이타를 삭제할수는 없습니다.");
     return;
 }else {
		if(bFlag) {
			if(confirm("삭제하시겠습니까?")) {
				bFlag=false;
				for(; changed_i<changed_tot_cnt; changed_i++) {
					if(document.forms.contentForm.InCheck[changed_i].checked==true) {
						objrow.deleteRow(changed_i);
						changed_tot_cnt=0;
						checkedDel();
					}
				}
			}
		}else {
			for(; changed_i<changed_tot_cnt; changed_i++) {
				if(document.forms.contentForm.InCheck[changed_i].checked==true) {
					objrow.deleteRow(changed_i);
					changed_tot_cnt=0;
					checkedDel();
				}
			}
		}
 }
 LabelSort();
}
//전체선택/해제

function checkAll() {
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
//     var check_status = document.forms.contentForm.check_status.value;
    if(document.forms.contentForm.check_status.checked == true) {
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
//             var check_status = "해제";
            if(box.checked == false) box.checked = true;
//             document.forms.contentForm.check_status.value = check_status;
        }else {
            for(var j = 0; j < tot_cnt; j++) {
            	var box = document.forms.contentForm.InCheck[j];
//                 var check_status = "해제";
                if(box.checked == false) box.checked = true;
//                 document.forms.contentForm.check_status.value = check_status;
            }
        }
    }else{
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
//             var check_status = "선택";
            if(box.checked == true) box.checked = false;
//             document.forms.contentForm.check_status.value = check_status;
        }else {
            for(var j = 0; j < tot_cnt; j++){
                var box = document.forms.contentForm.InCheck[j];
//                 var check_status = "선택";
                if(box.checked == true) box.checked = false;
//                 document.forms.contentForm.check_status.value = check_status;
            }
        }
    }
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var msg = response.msg.msg;   
		if (msg != ""){
			alert(msg);
		}
		reload();
	} else if (pMethod == "saveTemp"){
		var msg = response.msg.msg;   
		if (msg != ""){
			alert(msg);
		}
		reload();
	}
};
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
	
} 
function kepApprovalReturn(flag,docu_no){
	
	
	reload();
}

</script>
</html>
