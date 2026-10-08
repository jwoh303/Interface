<%--
**********************************************
* 메뉴 : 납품관리>수주접수(품목별)
* 화면 : 수주접수
* 기능 : 품목별 수주내역을 조회하고 접수처리 하기 위한 화면
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
    String user_id      = _sessionInfo.getUserId();
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
 	// MSDS 수주접수 통제 예외 협력사 확인
 	boolean p060000079 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000079");
 	
%> 

<script type="text/javascript"> 
var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_req_user_info", "${st_req_user_info}");	//요청정보
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬기준
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
	
	var searchYn = "${initSearchYn}";
	
	// 초기 화면호출시 자동조회
	if(searchYn != "N"){
		doAction("search");	
	}
	
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
			jspTableClean("table_list");
			break;
	
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvObtnodrMultiReceiptList.do";
			document.forms.searchForm.submit();
			break;
		case "pors": //수주접수
			setDeliverySchedule();
			break;
			
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvObtnodrMultiReceiptList.do").submit();   
}	
//지연사유 팝업창
function setDelayReason(x){
	
	$("#x").val(x);
	var buyer =$("input[name=st_buyer]").eq(x).val();
	
	openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", "?buyer="+buyer+"&st_pop_type=confirm", "520,410,no");
	
}

//지연사유 값 얻기
function getDelayReason(){

    var disp_cnt = $("#display_item_cnt").val();
    var x        = $("#x").val();
    var reason_text = "";
    if(eval(disp_cnt) < 2){
        reason_text = document.contentForm.st_delay_reason.value;
    }else{
        reason_text = document.contentForm.st_delay_reason[x].value;
    }
    return reason_text;
}

//지연사유 입력
function setReason(value,flag,st_year,st_month,st_day){ // value(지연사유) , flag ==> 해당품목(one) 또는 모든품목(all)
	
	var disp_cnt        = $("#display_item_cnt").val();
	var x               = $("#x").val();
	// 해당 row 지연
	var ds_date         = $("#st_ds_date"+x).val();
	var ds_date_text	= $("#st_ds_date_text"+x).val();
	
	var image_obj = "";
	var image_url = "";
	
	if(value==""){
		image_url = "/resources/images/but_img_off.gif";
	}else{
		image_url = "/resources/images/but_img_on.gif";
	}
	
	if(flag =="confirm"){ // 해당품목 적용
		
		$("#st_delay_reason"+x).val(value);
	
		image_obj = "ds_delay_reason_img" + x;
		
		MM_swapImage(image_obj,'',image_url,1);
		
	}else if(flag =="multi_confirm"){ // 납품지연사유 일괄 입력
		var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
		
		for(var k=0; k<tot_cnt; k++){
			var box = eval("document.forms.contentForm.checkbox" + k);
			if(box.checked == true){
				var delay_reason = $("#st_delay_reason"+k).val();
				if(isEmpty(delay_reason)){
					$("#st_delay_reason"+k).val(value);
					image_obj = "ds_delay_reason_img" + k;
					MM_swapImage(image_obj,'',image_url,1);
				}
			}
		}
	}else if(flag =="delay_multi_confirm"){ //납품예정일 입력후 지연건에 대한 지연 사유 일괄 입력
		var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
		for(var k=0; k<tot_cnt; k++){
			var box = eval("document.forms.contentForm.checkbox" + k);
			if(box.checked == true){
				var delay_reason = $("#st_delay_reason"+k).val();
				if(isEmpty(delay_reason)){
					if(st_year == ""|| st_year == null){
						$("#st_ds_date"+k).val(ds_date);
						$("#st_ds_date_text"+k).val(ds_date_text);						
					}else{
						$("#st_ds_date"+k).val(st_year+st_month+st_day);
						$("#st_ds_date_text"+k).val(st_year+"/"+st_month+"/"+st_day);						
					}
					var rd_date = $("#st_rd_date"+k).val();
					rd_date = rd_date.replace(/[/]/gi,"");

					if(st_year+st_month+st_day > rd_date){
						$("#st_delay_reason"+k).val(value);
						image_obj = "ds_delay_reason_img" + k;
						MM_swapImage(image_obj,'',image_url,1);
					}					
				}
			}
		}
	}
}
// 팝업 함수호출
function doPop(str,value1, value2,value3) {
	popupSel = str;
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "sellerMpIvObtnodrReceiptDetailPop": // 수주접수
			if(value3 == "Y"){
				alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
	    		return;
			}
			openSearchPopup("/mpiv/getSellerMpIvObtnodrReceiptDetailPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "1400,610,no");
			break;

		case "dsDelayReasonMulti": //납품지연 사유입력
			var tot_cnt = document.forms.contentForm.display_item_cnt.value;
			var cnt = getCheckedRowCount(tot_cnt);
			if(cnt <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}else if(cnt < 2){
				alert("일괄선정은 2건 이상 선택이 필요합니다.");
				return;
			}
			openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", "?st_pop_type=multi_confirm", "500,410,no");
			break;
		case "dsDateMulti": //납품예정일 입력
			var tot_cnt = document.forms.contentForm.display_item_cnt.value;
			var cnt = getCheckedRowCount(tot_cnt);
			if(cnt <= 0){
				alert("선택된 항목이 없습니다.");
				return;
			}else if(cnt < 2){
				alert("일괄선정은 2건 이상 선택이 필요합니다.");
				return;
			}
			openSearchPopup('/common/calendarPop.do','','230,245,no');
			break;
	}
}
function setPopupCalendar(year,month,day){

	var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
	var input_date = year+""+month+""+day;
	var delayGbn = "N";
	for(var k=0; k<tot_cnt; k++){
		var box = eval("document.forms.contentForm.checkbox" + k);
		if(box.checked == true){
			var rd_date = $("#st_rd_date"+k).val();
			rd_date = rd_date.replace(/[/]/gi,"");
			var reason_txt = $("#st_delay_reason"+k).val();
			if(input_date > rd_date && reason_txt==""){
				delayGbn = "Y";
		    }else{
		    	$("#st_ds_date"+k).val(input_date);
		    	$("#st_ds_date_text"+k).val(year+"/"+month+"/"+day);	
		    }
		}
	}
	if(delayGbn == "Y"){
        alert("납기요청일 보다 지연건이 존재합니다.\n지연사유을 입력하시기 바랍니다.");
        setDelayMultiReason(year,month,day);		
	}
}
//지연사유 팝업창
function setDelayMultiReason(year,month,day){
	
	openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", "?st_year="+year+"&st_month="+month+"&st_day="+day+"&st_pop_type=delay_multi_confirm", "520,410,no");
	
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	if (tot_cnt == 0){
		return 0;
	}
	
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
function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
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
//납품예정일 calender callback event
function calenderChange(dateText,num){
	var input_date = dateText.replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	var st_date = $.trim($("#st_st_date"+num).val());
	st_date = st_date.replace(/[/]/gi,"");
	var reason_txt = $.trim($("#st_delay_reason"+num).val());
	
	if(isEmpty(dateText)){
		if(cur_date > st_date && reason_txt==""){
	        alert("표준납기일 보다 이후날짜입니다. 지연사유을 입력하시기 바랍니다. ");
	        setDelayReason(num);
	    }
		$("#st_ds_date"+num).val(cur_date);
	} else {
		if(input_date > st_date && reason_txt==""){
	        alert("표준납기일 보다 이후날짜입니다. 지연사유을 입력하시기 바랍니다. ");
	        setDelayReason(num);
	    }
		$("#st_ds_date"+num).val(input_date);
	}
}
//일괄수주접수
function setDeliverySchedule(){
    var disp_cnt = document.contentForm.display_item_cnt.value;
    var query = "";

    var buyer        = "";
    var po_no        = "";
    var po_seq       = "";
    var po_qty       = "";
    var seller       = "";
    var cd_qty       = "";
    var user_id      = "<%=user_id%>";
    var delay_reason = "";
    var rd_date     = "";
	var ds_date		= "";
	var st_date		= "";
	var po_create_date = "";
	
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var harmful_check   = ""; //유해화학물질 여부 체크
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	var p070000033_check = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	var process_type = "";
	var warehouse_code = "";
	var tr_warehouse_yn = "";
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	var chk_cnt = 0;    // 선택건 체크
	
	document.forms.processForm.st_monitor.value = "AGENT_M_0";
	
    if(eval(disp_cnt) < 2){
    	pors_check = document.contentForm.st_pors_check.value;
    	
    	if(pors_check =="Y"){
    		alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
    		return;
    	}
    	
    	cod_check = document.contentForm.st_cod_check.value;
    	msds_check = document.contentForm.st_msds_check.value;
    	req_check = document.contentForm.st_req_check.value;

    	p070000033_check = document.contentForm.st_p070000033_check.value;
    	sg118_check = document.contentForm.st_sg118_check.value;
    	temp_check = document.contentForm.st_temp_check.value;
    	
    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
    		var flag = true;
    		for(var i = 0; i<buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
    			if(document.contentForm.st_buyer_item_no.value==buyer_item_no_arr[i]){
    				flag = false;
		    		break;		
    			}
    		}
    		if(flag)
    			buyer_item_no_arr.push(document.contentForm.st_buyer_item_no.value);
     	}
    	
    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
    		var flag1 = true;
    		for(var i = 0; i<msds_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
    			if(document.contentForm.st_buyer_item_no.value==msds_no_reg_buyer_item_no_arr[i]){
    				flag1 = false;
		    		break;		
    			}
    		}
    		if(flag1)
    			msds_no_reg_buyer_item_no_arr.push(document.contentForm.st_buyer_item_no.value);
     	}
     	
    	if(p070000033_check != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
    		var flag1 = true;
    		for(var i = 0; i<tempMng_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
    			if(document.contentForm.st_buyer_item_no.value==tempMng_no_reg_buyer_item_no_arr[i]){
    				flag1 = false;
		    		break;		
    			}
    		}
    		if(flag1)
    			tempMng_no_reg_buyer_item_no_arr.push(document.contentForm.st_buyer_item_no.value);
     	}
    	
        buyer       = document.contentForm.st_buyer.value;
        po_no       = document.contentForm.st_po_no.value;
        po_seq      = document.contentForm.st_po_seq.value;
        po_qty      = document.contentForm.st_cd_qty.value;
        cd_qty      = document.contentForm.st_cd_qty.value;
        seller      = document.contentForm.st_seller.value;
        delay_reason= document.contentForm.st_delay_reason.value;
        rd_date     = document.contentForm.st_rd_date.value;
    	rd_date     = rd_date.replace(/[/]/gi,"");
		ds_date		= document.contentForm.st_ds_date.value;
		st_date     = document.contentForm.st_st_date.value;
    	st_date     = st_date.replace(/[/]/gi,"");
    	po_create_date = document.contentForm.st_hd_po_date.value;
    	process_type = document.contentForm.st_process_type.value;
    	warehouse_code = document.contentForm.st_warehouse_code.value;
    	tr_warehouse_yn = document.contentForm.tr_warehouse_yn.value; 
    	temp_cond = document.contentForm.st_temp_cond.value;
    	harmful_check = document.contentForm.st_harmful_check.value;
    	
    	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
    	if(p070000033_check == "TYPE1"){ // 아모레퍼시픽(TYPE1)
    		if(sg118_check == "Y"){ // 시약류
    			if(harmful_check != "Y"){ // 유해화학물질 여부
        			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
            			if(process_type != "2"){
            				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
               				return;
            			}
            		}else{
            			if(process_type != "0"){
            				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
               				return;
            			}
            		}
        		}	
    		}
    	}
    	
    	if(harmful_check == "Y"){ // 유해화학물질 여부
    		if(process_type != "0"){ // 무조건 직납
				alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
   				return;
			}
    	}
    	
   		if(process_type == '2') {
   			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
   				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
   				return;
   			}
   		}
    	
    	
		// 매입단가유효일 진행 통제
		buy_close_date_chk = document.contentForm.st_buy_close_date_chk.value;
		if(buy_close_date_chk == "Y"){
			alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
			return;
		}
		
        if(ds_date==""){
            alert("납품예정일을 입력해 주십시요");
            return;
        }

		if((st_date < ds_date) && isEmpty(delay_reason)) {
			alert("납품지연사유를 입력하여 주십시요.");
			return;
		}
		chk_cnt++;
		
        query +=  buyer         + "@@";
        query +=  po_no         + "@@";
        query +=  po_seq        + "@@";
        query +=  po_qty        + "@@";
        query +=  ds_date       + "@@";
        query +=  cd_qty        + "@@";
        query +=  "Y"           + "@@"; 
        query +=  seller        + "@@";
        query +=  user_id       + "@@";
        query +=  delay_reason  + "@@";
        query +=  ds_date   + "@@";
        query +=  rd_date   + "@@";
        query +=  st_date   + "@@";
        query +=  "N"; // DS_YN
        query +=  "^||^" ;
        
        document.forms.processForm.st_monitor.value = "AGENT_M_S";
    }else{
        for(var  k=0; k<disp_cnt ; k++){
	         var box = eval("document.forms.contentForm.checkbox" + k);
	         if(box.checked == true){
	        	 pors_check = document.contentForm.st_pors_check[k].value;
	         	
	         	if(pors_check =="Y"){
	         		alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
	         		return;
	         	}
	        	 
	        	 chk_cnt++;
	        	 cod_check = document.contentForm.st_cod_check[k].value;
	        	 msds_check = document.contentForm.st_msds_check[k].value;
	        	 req_check = document.contentForm.st_req_check[k].value;
	        	 
	        	 p070000033_check = document.contentForm.st_p070000033_check[k].value;
	        	 sg118_check = document.contentForm.st_sg118_check[k].value;
	        	 temp_check = document.contentForm.st_temp_check[k].value;
	        	 
	        	 if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
	        		var flag = true;
	        	 
	        	 	for(var i = 0; i<buyer_item_no_arr.length;i++){ //buyer_item_no 중복 출력 방지
	        			if(document.contentForm.st_buyer_item_no[k].value==buyer_item_no_arr[i]){
	        				flag = false;
	    		    		break;		
	        			}
	        		}
	        		if(flag)
	        			buyer_item_no_arr.push(document.contentForm.st_buyer_item_no[k].value);
	         	}
	        	 
				if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
					var flag1 = true;
	        	 	for(var i = 0; i<msds_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
	         			if(document.contentForm.st_buyer_item_no[k].value==msds_no_reg_buyer_item_no_arr[i]){
	         				flag1 = false;
	     		    		break;		
	         			}
	         		}
	         		if(flag1)
	         			msds_no_reg_buyer_item_no_arr.push(document.contentForm.st_buyer_item_no[k].value);
	          	}
				
				if(p070000033_check != "" && sg118_check == "Y" && temp_check == "Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
		    		var flag1 = true;
		    		for(var i = 0; i<tempMng_no_reg_buyer_item_no_arr.length;i++){ //buyer_item_no 중복출력 방지
		    			if(document.contentForm.st_buyer_item_no[k].value==tempMng_no_reg_buyer_item_no_arr[i]){
		    				flag1 = false;
				    		break;		
		    			}
		    		}
		    		if(flag1)
		    			tempMng_no_reg_buyer_item_no_arr.push(document.contentForm.st_buyer_item_no[k].value);
		     	}
	         	
	            buyer       = document.contentForm.st_buyer[k].value;
	            po_no       = document.contentForm.st_po_no[k].value;
	            po_seq      = document.contentForm.st_po_seq[k].value;
	            po_qty      = document.contentForm.st_cd_qty[k].value;
	            cd_qty      = document.contentForm.st_cd_qty[k].value;
	            seller      = document.contentForm.st_seller[k].value;
	            delay_reason= document.contentForm.st_delay_reason[k].value;
	            rd_date     = document.contentForm.st_rd_date[k].value;
	        	rd_date     = rd_date.replace(/[/]/gi,"");
	    		ds_date		= document.contentForm.st_ds_date[k].value;
	    		st_date     = document.contentForm.st_st_date[k].value;
	        	st_date     = st_date.replace(/[/]/gi,"");
	        	po_create_date = document.contentForm.st_hd_po_date[k].value;
	        	process_type = document.contentForm.st_process_type[k].value;
	        	warehouse_code = document.contentForm.st_warehouse_code[k].value;
	        	tr_warehouse_yn = document.contentForm.tr_warehouse_yn[k].value; 
	        	harmful_check = document.contentForm.st_harmful_check[k].value;
	        	
	        	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
	        	if(p070000033_check == "TYPE1"){ // 아모레퍼시픽(TYPE1)
	        		if(sg118_check == "Y"){ // 시약류
	        			if(harmful_check != "Y"){ // 유해화학물질 여부
	            			if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
	                			if(process_type != "2"){
	                				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	                   				return;
	                			}
	                		}else{
	                			if(process_type != "0"){
	                				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	                   				return;
	                			}
	                		}
	            		}	
	        		}
	        	}
	        	
	        	if(harmful_check == "Y"){ // 유해화학물질 여부
	        		if(process_type != "0"){ // 무조건 직납
	    				alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	       				return;
	    			}
	        	}
	        	
        		if(process_type == '2') {
        			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
        				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
        				return;
        			}
        		}
	    		
	    		// 매입단가유효일 진행 통제
	    		buy_close_date_chk = document.contentForm.st_buy_close_date_chk[k].value;
	    		if(buy_close_date_chk == "Y"){
	    			alert( (k+1) + "번째 발주번호("+po_no+")는 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
	    			return;
	    		}
	    		
	    		var po_cnt = document.contentForm.st_po_cnt[k].value;
	    		var cnt = 0;
	    		for(var  j=0; j<disp_cnt ; j++){
		   	         var box = eval("document.forms.contentForm.checkbox" + j);
			         if(box.checked == true){
			            var s_buyer       = document.contentForm.st_buyer[j].value;
			            var s_po_no       = document.contentForm.st_po_no[j].value;
			            if(buyer+po_no == s_buyer+s_po_no){
			            	cnt ++;
			            }
			         }
	    		}
	    		if(po_cnt != cnt){
	    			alert( (k+1) + "번째 발주번호("+po_no+") 단위로 수주접수 가능합니다.");
	    			return;
	    		}
	            if(ds_date==""){
	                alert( (k+1) + "번째 품목에 납품예정일을 입력해 주십시요");
	                return;
	            }
	
				if((st_date < ds_date) && isEmpty(delay_reason)) {
					alert( (k+1) + "번째 납품지연사유를 입력하여 주십시요.");
					return;
				}
	
	            query +=  buyer         + "@@";
	            query +=  po_no         + "@@";
	            query +=  po_seq        + "@@";
	            query +=  po_qty        + "@@";
	            query +=  ds_date       + "@@";
	            query +=  cd_qty        + "@@";
	            query +=  "Y"           + "@@"; // DS_FLAG
	            query +=  seller        + "@@";
	            query +=  user_id       + "@@";
	            query +=  delay_reason  + "@@";
	            query +=  ds_date  + "@@";
	            query +=  rd_date   + "@@";
	            query +=  st_date   + "@@";
	            query +=  "N"; // DS_YN
	            query +=  "^||^" ;
	            
	            document.forms.processForm.st_monitor.value = "AGENT_M_M";
	         }
        }
    }
	
    if(chk_cnt == 0){
		alert("수주접수 항목을 선택하여 주십시요");
		return;
	}
    
    if(buyer_item_no_arr.length != 0 && <%=p060000079%> == false){ //수주접수 통제해야되는 건이 있는 경우(통제 예외 협력사도 아니어야 함)
		if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			if(setGridData(query)){
				document.forms.searchForm.st_query.value  = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
				kepSearch(1);
			}
		}
    }else if(tempMng_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
		if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
			//KEP_CMC_REQ insert 코드
			if(setGridData(query)){
				document.forms.searchForm.st_query.value = query;
				kepAjaxFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
			}
		}
	}else if(msds_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
		alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
		return;
	}else{//통제 건 없는 경우 수주접수 진행	
		document.forms.searchForm.st_query.value  = query;
		document.forms.processForm.st_po_create_date.value = po_create_date;
		
		if(setGridData(query)){
			if(!confirm("수주접수 하시겠습니까?")){ 
				return;
			}
			kepAjaxFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","btnSave"); 	
		}
    }
  
}
//선택된 그리드 값을 셋팅
function setGridData(query) {
	var returnValue = true;

	var resultArr = new Array(2);
	resultArr = ['',''];
	var name = new Array(14);
	name = ['st_buyer','st_po_no','st_po_seq','st_po_qty','st_ds_date','st_cd_qty','st_ds_flag','st_seller','st_user_id','st_delay_reason','st_max_cd_date','st_rd_date','st_st_date','st_ds_yn'];

	var st_query = query.split("^||^");
	for(var j = 0; j < st_query.length-1; j++){
		var value = st_query[j].split("@@",-1);
		for(var k = 0; k < name.length; k++){
			resultArr[0] = resultArr[0]+ name[k] + "|";
			resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		}
	}
	//마지막에 | 를 없애기 위함
	if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
		
	if(resultArr != null && resultArr !=""){
		
		document.forms.processForm.s_SAVENAME.value = resultArr[0];
		$("#process").html(resultArr[1]);
		
	} else {
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}
	
	return returnValue;
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		if(pMethod == "msds"){
			alert("물질정보 등록요청 완료.\n물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 수주접수 하시기 바랍니다.");
		}else{
			alert("수주 접수가 정상적으로 이루어 졌습니다.\n\n입력하신 날짜에 납품이 가능도록 하여 주시기 바랍니다.");
		}
		
		kepSearch(1);
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
	<h3>일괄수주접수</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		<input type="hidden" name="initSearchYn" id="initSearchYn" value="N" />
		<input type="hidden" name="st_query" id="st_query" value="" />
		<!-- <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> -->
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>고객사</td>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" READONLY>
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" >
						<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
				   <td>발주번호</td>
					<td>
					   <input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
					</td>					
					<td>요청정보</td>
					<td>
						<input type="text" class="input_type_text" name="st_req_user_info" id="st_req_user_info" style="width:80%;" onKeyDown="kepEnter();">
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
				<font size: 12px;"><b>※분할납품시 발주번호 클릭하여 수주접수 상세 팝업창에서 처리 바랍니다.</b></font>
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
                 <col width="10%" />
                 <col width="9%" />
                 <col width="9%" />
                 <col width="*" />
                 <col width="10%" />
                 <col width="6%" />
                 <col width="5%" />
                 <col width="6%" />
                 <col width="7%" />
                 <col width="3%" />
                 <col width="10%" />
	        </colgroup>
	        <thead>
			<tr>
				<th rowspan="2"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')"> </th>
                <th scope="col" rowspan="2">고객사</th>
                <th scope="col">발주번호</th>
                <th scope="col">발주순번</th>
                <th scope="col">품목명</th>
                <th scope="col">제조사</th>
                <th scope="col">발주수량 / 단위</th>
                <th scope="col">단가</th>
                <th scope="col">KeP담당자</th>
                <th scope="col">표준납기일</th>
                <th scope="col">첨부</th>
                <th rowspan="2" scope="col">비고</th>
			</tr>
			<tr>
                <th scope="col">관리번호</th>
                <th scope="col">품목코드</th>
                <th scope="col">규격</th>
                <th scope="col">모델번호</th>
                <th scope="col">납기요청일</th>
				<th scope="col">발주금액</th>
				<th scope="col">담당자연락처</th>
				<th scope="col">*납품예정일</th>
				<th scope="col">*사유</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="9" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#D5D5D5";
				page_display_cnt++;
		%> 
				<tr align="center" bgcolor="<%=tclass%>">          
		          	<td  rowspan="2">
		          		<input type="hidden"   name="st_buyer"      value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
						<input type="hidden"   name="st_po_no"      value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
						<input type="hidden"   name="st_po_seq"     value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
						<input type="hidden"   name="st_cd_qty"     value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
						<input type="hidden"   name="st_ds_flag"    value="<%=CommonUtil.nvl(rowData.get("DS_FLAG"))%>">
						<input type="hidden"   name="st_seller"     value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>">
						<input type="hidden"   name="st_po_cnt"     value="<%=CommonUtil.nvl(rowData.get("PO_CNT"))%>">
						<input type="hidden"   name="st_cod_check"      value="<%=CommonUtil.nvl(rowData.get("COD_CHECK"))%>">
						<input type="hidden"   name="st_msds_check"      value="<%=CommonUtil.nvl(rowData.get("MSDS_CHECK"))%>">
						<input type="hidden"   name="st_req_check"      value="<%=CommonUtil.nvl(rowData.get("REQ_CHECK"))%>">
						<input type="hidden"   name="st_buyer_item_no"      value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
						<input type="hidden"   name="st_buy_close_date_chk"      value="<%=CommonUtil.nvl(rowData.get("BUY_CLOSE_DATE_CHK"))%>">
						<input type="hidden"   name="st_hd_po_date" id="st_hd_po_date<%=j%>" value="<%=CommonUtil.nvl(rowData.get("PH_PO_DATE"))%>">
						<input type="hidden"   name="st_pors_check"      value="<%=CommonUtil.nvl(rowData.get("PORS_CHECK"))%>">
						<input type="hidden"   name="st_process_type" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>">
						<input type="hidden"   name="st_warehouse_code" value="<%=CommonUtil.nvl(rowData.get("WAREHOUSE_CODE"))%>">
						<input type="hidden"   name="tr_warehouse_yn" value="<%=CommonUtil.nvl(rowData.get("TR_WAREHOUSE_YN"))%>">
						<input type="hidden"   name="st_harmful_check" value="<%=CommonUtil.nvl(rowData.get("HARMFUL_CHECK"))%>">
						<input type="hidden"   name="st_temp_check" value="<%=CommonUtil.nvl(rowData.get("TEMP_CHECK"))%>">
						<input type="hidden"   name="st_p070000033_check" value="<%=CommonUtil.nvl(rowData.get("P070000033_CHECK"))%>">
						<input type="hidden"   name="st_temp_cond" value="<%=CommonUtil.nvl(rowData.get("TEMP_COND"))%>">
						<input type="hidden"   name="st_sg118_check" value="<%=CommonUtil.nvl(rowData.get("SG118_CHECK"))%>">
		          		<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
		          	</td>
                   	<td title="고객사" class="left" rowspan="2">
                   		<a class="hyperLink" href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');">
                   			<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
                   		</a>
                   	</td>
                    <td title="발주번호">
                    	
                    	<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('sellerMpIvObtnodrReceiptDetailPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>','<%=CommonUtil.nvl(rowData.get("PORS_CHECK"))%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
	                    </a>
                    </td>
                   	<td title="발주순번" >
                   		<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>
                   	</td>
                    <td title="품목명" class="left"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
                    <td title="제조사" class="left"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
                    <td title="단위"><%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%> / <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
                    <td title="단가" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("UNIT_PRICE")),true,0,3)%></td>
                    <td title="KeP담당자"><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td>
                    <td title="표준납기일"  class="center">
                   		<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ST_DATE")))%>
                   		<input type="hidden" name="st_st_date" size="10" id="st_st_date<%=j%>" value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ST_DATE")))%>' >
                   	</td>
                    <td title="첨부">
								<!-- 첨부 -->
							 	<%
									if (("").equals(CommonUtil.nvl(rowData.get("IMAGE_KEY")))) {
								%>
										<img name = "st_image_key_img" src="/resources/images/disk_off.gif" border="0">
								<%
									}else{
								%>         
										<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')">
											<img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0">
										</a>
								<%
									}
								%>
					</td>
                    <td title="비고" class="left"  rowspan="2"><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
                   	<td title="관리번호" class="left">
                   		<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
                   	</td>
                    <td title="품목코드">
						<!-- 품목코드-->
						<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
							<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
						</a>
                    </td>
                   	<td title="규격"  class="left">
				<%if(CommonUtil.nvl(rowData.get("P070000033_CHECK")).equals("TYPE0") || CommonUtil.nvl(rowData.get("P070000033_CHECK")).equals("TYPE1")){%>
					<%if(CommonUtil.nvl(rowData.get("SG118_CHECK")).equals("Y")){%>
					 	<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_COND_TEXT"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("TEMP_RANGE"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("HARMFUL_TEXT"))%>
					<%}else{%>
						<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
					<%}%>	
				<%}else{%>
						<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
				<%}%>                   	
                   	</td>
                   	<td title="모델번호"  class="left">
                   		<%=CommonUtil.nvl(rowData.get("MAKER_PART_NO"))%>
                   	</td>
                   	<td title="납기요청일">
                  		<!-- 납기요청일 -->
					 	<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>
					 	<input type="hidden" name="st_rd_date" size="10" id="st_rd_date<%=j%>" value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%>' >
                    </td>
                   	<td title="발주금액"  class="right">
                   		<%=CommonUtil.formatNumber(CommonUtil.nvl(rowData.get("ITEM_AMT")),true,0,3)%>
                   	</td>
                   	<td title="담당자연락처"><%=CommonUtil.nvl(rowData.get("USER_PHONE_NUMBER"))%></td>
                   	<td title="납품예정일" >
					 	<input type="text"   name="st_ds_date_text" size="10" id="st_ds_date_text<%=j%>" class="input_type_text"  value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>' readonly>
	                    <input type="hidden" name="st_ds_date"      size="10" id="st_ds_date<%=j%>" value='<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>' >
	                </td>
                    <td title="사유">
						<a href="javascript:setDelayReason('<%=j%>');">
					 		<img id="ds_delay_reason_img<%=j%>" name = "ds_delay_reason_img<%=j%>" src='/resources/images/<%=CommonUtil.nvl(rowData.get("DS_DELAY_REASON_IMG"))%>' border="0" align="absmiddle">
					 	</a>
					 	<input type="hidden"   id="st_delay_reason<%=j%>" name="st_delay_reason"   value="<%=CommonUtil.nvl(rowData.get("DS_DELAY_REASON"))%>">
                    </td>
				</tr>
            <%
                        } 
        			}
            %>

           		</tbody>
            </table>
            <input type="hidden" id="display_item_cnt" name="display_item_cnt"    value="<%=page_display_cnt%>">
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fl">
				<span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
            </div>
			<div class="fr">
				<span class="btn_08 mr04"><a href="javaScript:doPop('dsDateMulti');">납품예정일 입력</a></span>
				<span class="btn_08 mr04"><a href="javaScript:doPop('dsDelayReasonMulti');">납품지연사유 입력</a></span>
				<span class="btn_04 mr04"><a href="javaScript:doAction('pors');">수주접수</a></span>	
            </div>
        </div>
</form>
<form name="sellerMpIvObtnodrReceiptDetailPop" id="sellerMpIvObtnodrMultiReceiptDetailPop" method=post >
	<!-- HIDDEN -->
	<input type="hidden" id="x" name="x"		value="">
	<input type="hidden" name="st_query"    	value="">
	<input type="hidden" name="file_get_y"		value="">
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_po_create_date" id="st_po_create_date"  value=""> <!-- 장납기 이슈등록 판단 기준-->
	<input type="hidden" name="st_monitor" id="st_monitor" value=""> <!-- 모니터링용. 남아있는거 보이면 삭제하세요-->
	
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
	<script>
		$(document).ready(function() {
<% 
			if (_gridList == null || _gridList.size() == 0){ 
			}else{
				for (int j=0; j<_gridList.size(); j++) {
%>
					kepSetCalender('st_ds_date_text<%=j%>',"1","Y","<%=j%>");

<%
				}
			}
%>
		});
	</script> 
