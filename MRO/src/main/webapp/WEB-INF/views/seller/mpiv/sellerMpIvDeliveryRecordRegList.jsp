<%--
**********************************************
* 메뉴 : 납품관리>납품등록>납품실적등록
* 화면 : 납품실적등록
* 기능 : 기 생성된 거래명세서 목록을 조회하고 선택하여 납품실적을 등록한다.
* 프로그램 ID : PG_07_A_005_00
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
<script src="/resources/js/kep_common.js"></script>
 
<%
	// 공통
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
	initSearchCondition("searchForm", "st_inv_no", "${st_inv_no}");	//거래명세서번호
	initSearchCondition("searchForm", "st_parcel_yn", "${st_parcel_yn}");	//배송유형
	initSearchCondition("searchForm", "st_insert_flag", "${st_insert_flag}");	//입력대상 건 hidden값
	
	if("${st_insert_flag}" == "Y"){
		$("#st_insert_flag").val("Y");
		$("#st_insert_flag_check").attr("checked", "checked");
	} else {
		$("#st_insert_flag_check").removeAttr("checked");
	}
	
	
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
			$("#st_insert_flag").val("N");
			$("#st_insert_flag_check").removeAttr("checked");
//			$("#st_insert_flag_check").attr("checked", "checked");
			
// 			kepSearch("-1");
			jspTableClean("table_list");
			break;

		case "saveParcel":	//택배사정보 저장
			if(parcelInvNoCheck()){
				setParcel();
			}
			break;
			
		case "create":	//등록
			setDeliveryRsltCreate();
			break;	
			
		case "excelDownload": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvDeliveryRecordRegList.do";
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
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvDeliveryRecordRegList.do").submit();
}


//납품실적등록
function setDeliveryRsltCreate(){
	
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 납품실적등록할 품목수
	
	var buyer           = "";
	var po_no           = "";
	var po_seq          = "";
	var inv_no          = "";
	var inv_seq         = "";
	var delivery_date   = "";
	var delivery_qty    = "";
	var invoice_date    = "";
	//자동입고 여부. 고객사옵션
	var st_gr_auto_flag = "";
	var db_parcel_com_name = "";
	var st_image_key = "";
	var db_buyer_nm = "";
	var db_process_type = "";
	//자동입고처리 FLAG
	var exe_gr_auto_flag = "N"
	var cur_date        = kepGetNowTimeStr("YYYYMMDD", "");		// 현재날짜
	var avail_date      = kepToDateAdd("2","M","noslash");		// 현재날짜 -2일
	var st_parcel_com_code_2 = "";
	var st_parcel_inv_no_2 = "";
	var p070000029_YN = "N";
	var st_parcel_yn = "";
	var st_parcel_changed="N";
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이터가 없습니다.");
		return;
	}
	
	if(eval(tot_cnt) < 2){
	
		var box = eval("document.contentForm.checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.contentForm.db_buyer.value;
			po_no           = document.contentForm.db_po_no.value;
			po_seq          = document.contentForm.db_po_seq.value;
			inv_no          = document.contentForm.db_inv_no.value;
			inv_seq         = document.contentForm.db_inv_seq.value;
			invoice_date    = document.contentForm.db_invoice_date.value;
			delivery_qty    = document.contentForm.st_delivery_qty.value;
			//delivery_date   = document.contentForm.st_delivery_date_text.value;     // 납품확정일에 입력한 날짜
			//자동입고
			st_gr_auto_flag= document.contentForm.st_gr_auto_flag.value; 
			db_parcel_com_name = document.contentForm.db_parcel_com_name.value;
			db_buyer_nm = document.contentForm.db_buyer_nm.value;
			st_image_key = document.contentForm.st_image_key.value;
			db_process_type = document.contentForm.db_process_type.value;
			st_parcel_com_code_2 = document.contentForm.st_parcel_com_code.value;
			st_parcel_inv_no_2 = $("#st_parcel_inv_no").text();
			p070000029_YN = document.contentForm.p070000029_YN.value;
			st_parcel_yn = $("#st_item_parcel_yn0").val();
			
			if(st_parcel_yn == "Y"){
				alert("택배 예정건은 실적등록을 직접 할 수 없습니다.\n택배송장번호를 입력하여 주시기 바랍니다.\n택배회사의 송장을 확인하여 추후 자동처리됩니다.");
				return;
			}
			delivery_date = $.datepicker.formatDate('yymmdd', $("input[name=st_delivery_date_text]").datepicker("getDate"));
			
			if(delivery_date == ""){
				alert("고객 수령일을 입력해 주십시요");
				return;
			}
			
			if(eval(invoice_date) > eval(cur_date)){
				alert("납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
				box.checked = false;
				return;
			}
			
			// 납품확정일 >= 거래명세서 작성일 인경우에만 실적등록 가능
			if(eval(delivery_date) < eval(invoice_date)){
				alert( "고객수령일(납품확정일)은 납품일 이후 날짜만 입력 가능합니다.\n\n*납품일 : 거래명세서 작성 시 등록한 납품일자");
				return;
			}
			/*
			고객사 옵션이 자동입고 로직
			1. 직납일때만 첨부기능.(협력사)
			2. 택배송장번호 입력건은 배송증빙처리 불필요
			3. 택번거 이외 모든건 배송증빙 처리 해야함
			*/
			if(st_gr_auto_flag == "Y"&&db_process_type == "0"){
				exe_gr_auto_flag = "Y";	
				if(st_parcel_com_code_2 == "" || st_parcel_com_code_2 == null){
					if(st_image_key == "" || st_image_key == null){
						alert("고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"\n배송완료 증빙 처리 바랍니다.");
						return;
					}
				}else{
					//택배건은 자동입고 처리 안함.
					exe_gr_auto_flag = "N";	
				}
			}

			// 해당 고객사 직납 납품실적 등록 시 택배 or 배송증빙 필수
			if(p070000029_YN == "Y"){
				if(db_process_type == "0"){
					if(st_parcel_com_code_2 == "" && st_image_key == ""){
						alert("고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"\n택배송장번호 or 배송완료증빙 등록바랍니다.");
						return;
					}
				}
			}
			
			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  inv_no        + "@@";
			query +=  inv_seq       + "@@";
			query +=  delivery_qty  + "@@";
			query +=  delivery_date + "@@";
			query +=  st_image_key + "@@";
			query +=  exe_gr_auto_flag+ "@@";
			query +=  st_parcel_com_code_2+ "@@";
			query +=  st_parcel_inv_no_2 + "@@";
			query +=  st_parcel_yn+ "@@";
			query +=  st_parcel_changed;
			query +=  "^||^" ; 
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.contentForm.db_buyer[k].value;
				po_no           = document.contentForm.db_po_no[k].value;
				po_seq          = document.contentForm.db_po_seq[k].value;
				inv_no          = document.contentForm.db_inv_no[k].value;
				inv_seq         = document.contentForm.db_inv_seq[k].value;
				invoice_date    = document.contentForm.db_invoice_date[k].value;
				delivery_qty    = document.contentForm.st_delivery_qty[k].value;
				//delivery_date   = document.contentForm.st_delivery_date_text[k-1].value;
				delivery_date = $.datepicker.formatDate('yymmdd', $("input[name=st_delivery_date_text]").eq(k).datepicker("getDate"));
				st_gr_auto_flag= document.contentForm.st_gr_auto_flag[k].value;
				db_parcel_com_name = document.contentForm.db_parcel_com_name[k].value;
				db_buyer_nm = document.contentForm.db_buyer_nm[k].value;
				st_image_key = document.contentForm.st_image_key[k].value;
				db_process_type = document.contentForm.db_process_type[k].value;
				st_parcel_com_code_2 = document.contentForm.st_parcel_com_code[k].value;
				st_parcel_inv_no_2 = $("#st_parcel_inv_no"+k).text();
				p070000029_YN = document.contentForm.p070000029_YN[k].value;
				st_parcel_yn = $("#st_item_parcel_yn"+k).val();
				
				if(st_parcel_yn == "Y"){
					alert("택배 예정건은 실적등록을 직접 할 수 없습니다.\n택배송장번호를 입력하여 주시기 바랍니다.\n택배회사의 송장을 확인하여 추후 자동처리됩니다.");
					return;
				}
				
				if(delivery_date == ""){
					alert( (k+1) + "번째 줄에 고객 수령일을 입력해 주십시요"+delivery_date);
					return;
				}
				
				if(eval(invoice_date) > eval(cur_date)){
					alert((k+1) + "번째 품목은 납품일("+invoice_date+") 이 후 부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
					box.checked = false;
					return;
				}

				// 납품확정일 >= 거래명세서 작성일 인경우에만 실적등록 가능
				if(eval(delivery_date) < eval(invoice_date)){
					alert( (k+1) + "번째 줄에 고객수령일(납품확정일)은 납품일 이후 날짜만 입력 가능합니다.\n\n*납품일 : 거래명세서 작성 시 등록한 납품일자");
					return;
				}
				/*
				고객사 옵션이 자동입고 로직
				1. 직납일때만 첨부기능.(협력사)
				2. 택배송장번호 입력건은 배송증빙처리 불필요
				3. 택번거 이외 모든건 배송증빙 처리 해야함
				*/
				if(st_gr_auto_flag == "Y"&&db_process_type == "0"){
					exe_gr_auto_flag = "Y";
					if(st_parcel_com_code_2 == "" || st_parcel_com_code_2 == null){
						if(st_image_key == "" || st_image_key == null){
							alert("고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"\n배송완료 증빙 처리 바랍니다.");
							return;
						}
					}else{
						//택배건은 자동입고 처리 안함.
						exe_gr_auto_flag = "N";	
					}
				}

				// 해당 고객사 직납 납품실적 등록 시 택배 or 배송증빙 필수
				if(p070000029_YN == "Y"){
					if(db_process_type == "0"){
						if(st_parcel_com_code_2 == "" && st_image_key == ""){
							alert("고객사: "+db_buyer_nm+ ", 거래명세서번호: "+inv_no+"\n택배송장번호 or 배송완료증빙 등록바랍니다.");
							return;
						}
					}
				}
				
				query +=  buyer         + "@@";
				query +=  po_no         + "@@";
				query +=  po_seq        + "@@";
				query +=  inv_no        + "@@";
				query +=  inv_seq       + "@@";
				query +=  delivery_qty  + "@@";
				query +=  delivery_date + "@@";
				query +=  st_image_key + "@@";
				query +=  exe_gr_auto_flag+ "@@";
				query +=  st_parcel_com_code_2+ "@@";
				query +=  st_parcel_inv_no_2+ "@@";
				query +=  st_parcel_yn+ "@@";
				query +=  st_parcel_changed;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == "0"){
		alert("납품실적등록할 품목을 선택하여 주십시요");
		return;
	}
	
	//alert(query);
	
	if(!confirm("납품실적을 등록 하시겠습니까?")) return;
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordRegList.do","searchForm","btnCreate");
	
	/*
	
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/delivery/agent_delivery_rslt_cre_reg.jsp";
	document.forms[0].submit();
	*/

}


//택배사정보등록
function setParcel(){
	
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 택배사 정보 등록할 품목수
	
	var buyer           = "";
	var inv_no          = "";
	var parcel_com_code	= "";
	var parcel_inv_no	= "";
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	
	parcel_com_code = $("#st_parcel_com_code").val();
	parcel_inv_no 	= $("#st_parcel_inv_no").val();
	
	
	if(isEmpty(parcel_com_code)){
		alert("택배사정보를 선택해주십시오.");
		return;
	}	

	if(isEmpty(parcel_inv_no)){
		alert("운송장번호를 입력해주십시오.");
		return;
	}
	// 택배사 정보 선택체크
	if(eval(tot_cnt) < 2){
	
		var box = eval("document.contentForm.checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.contentForm.db_buyer.value;
			inv_no          = document.contentForm.db_inv_no.value;
			
			query +=  buyer         + "@@";
			query +=  inv_no        + "@@";
			query +=  parcel_com_code  + "@@";
			query +=  parcel_inv_no       ;
			query +=  "^||^" ;
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.contentForm.db_buyer[k].value;
				inv_no          = document.contentForm.db_inv_no[k].value;
				
				query +=  buyer         + "@@";
				query +=  inv_no        + "@@";
				query +=  parcel_com_code  + "@@";
				query +=  parcel_inv_no       ;
				query +=  "^||^" ;
			}
		}
	}
	
	//console.log("query ==>> " + query);
	
	if(chk_cnt == "0"){
		alert("택배사정보를 등록할 품목을 선택하여 주십시요");
		return;
	}
	
	if(!confirm("택배사정보를 등록 하시겠습니까?")) return;
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordParcelRegList.do","searchForm","btnParcel");
	
	/*
	
	document.forms[0].target = "work";
	document.forms[0].method = "post";
	document.forms[0].action = "/kr/agent/delivery/agent_delivery_rslt_cre_reg.jsp";
	document.forms[0].submit();
	*/

}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnCreate"){
		alert("납품실적등록이  정상적으로 완료 되었습니다.");
		doAction("search");
	    //setQuery();   
	} else if(pMethod == "btnParcel"){
		alert("택배사 정보가 정상적으로 등록되었습니다.");
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
var gridIndex = "";
var popupSel= "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
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
			openSearchPopup("/mpiv/getCommonMpIvTranStatementDetailIVPop.do", param, "850,600,no");
			break;
			
		case "excelUpload": 
			openSearchPopup('/mpiv/showSellerMpIvExcelUploadPop.do','','900,700,no');
			break;
		case "attachSet"://파일 첨부(등록)
			var type="IV";
			var viewType="VI";
			gridIndex = value1;
			var image_key =  $("input[name=st_image_key]").eq(gridIndex).val();
			var st_buyer =  $("input[name=db_buyer]").eq(gridIndex).val();
			var st_inv_no =  $("input[name=db_inv_no]").eq(gridIndex).val();
			popupSel = "attachSet";
			openSearchPopup('/common/imageFileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no');// 파일첨부
			break;
		case "setParcelInfo": // 배송번호 입력 창
			popupSel = "setParcelInfo";
			gridIndex = value1;
			
			var st_buyer =  $("input[name=db_buyer]").eq(gridIndex).val();
			var st_inv_no =  $("input[name=db_inv_no]").eq(gridIndex).val();
			var st_parcel_inv_no = $("#st_parcel_inv_no"+gridIndex).text();
			var st_parcel_com_code =  $("input[name=st_parcel_com_code]").eq(gridIndex).val();
			console.log(st_parcel_com_code);
			openSearchPopup("/mpiv/showSellerMpIvDeliveryRecordParcelRegPop.do", "?st_buyer="+st_buyer+"&st_inv_no="+st_inv_no+"&st_parcel_com_code="+st_parcel_com_code+"&st_parcel_inv_no="+st_parcel_inv_no+"&st_num="+gridIndex, "550,150,no");// 파일첨부
			break;
		case "deliveryDateMulti": //고객 수령일 입력
			var tot_cnt = $("#display_item_cnt").val();
			var cnt = getCheckedRowCount(tot_cnt);
			if(cnt <= 0){
				alert("선택된 항목 중 고객 수령일을 등록할 수 있는 항목이 없습니다.");
				return;
			}
			openSearchPopup('/common/calendarPop.do','','230,245,no');
			break;
	}
}

function setPopupCalendar(year,month,day){

	var tot_cnt  = $("#display_item_cnt").val();
	var input_date = year+""+month+""+day;
	for(var k=0; k<tot_cnt; k++){
		var box = eval("document.forms.contentForm.checkbox" + k);
		if(box.checked == true && $("#st_item_parcel_yn"+k).val() == 'N'){
	    	$("#st_delivery_date_text"+k).val(year+"/"+month+"/"+day);	
		}
	}
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	if (tot_cnt == 0){
		return 0;
	}
	
	var chk_cnt = 0;
	for(var j = 0; j < tot_cnt; j++){
		var box = eval("document.forms.contentForm.checkbox" + j);
		if(box.checked == true &&  $("#st_item_parcel_yn"+j).val() == 'N'){
			chk_cnt++;
		}
	}
	return chk_cnt;
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5){	
	
	if(popupSel == "attachSet") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}else if(popupSel == "setParcelInfo"){
		
		var stnd_inv_no = $("input[name=db_inv_no]").eq(value5).val();
		var length = $("input[id=onepagerow]").val();
		for(var i = 0; i < length ; i++){//같은 거래명세서번호인 경우 이미 update 되었으므로 같이 변경
			if(stnd_inv_no == $("input[name=db_inv_no]").eq(i).val()) {
				$("span[id=st_parcel_inv_no"+i+"]").text(value1);
				$("input[name=st_parcel_com_code]").eq(i).val(value2);
				$("span[id=st_parcel_com_name"+i+"]").text(value3);
				
				document.getElementById("st_parcel_real_url"+i).href = value4;
				
				$("#parcel_btn"+i).attr('class',"div_black_04");
				$("span[id=parcel_text"+i+"]").css("display","block");
				$("a[id=st_parcel_real_url"+i+"]").css("display","block");
				
				$("#st_item_parcel_yn"+i).css("display","none");
				$("#st_item_parcel_yn_text"+i).css("display","block");
			}
		}
		
	}
}
function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}


//납품실적등록 가능 여부 체크 , 납품일 이후부터 실적등록이 가능함
function checkInvoiceDate(invoice_date,row){
	var cur_date    = kepGetNowTimeStr("YYYYMMDD", "");

	var box         = eval("document.contentForm.checkbox"+row);
	if(box.checked == true){
	    if(eval(invoice_date) > eval(cur_date)){
			alert("납품일("+kepDateSlashAdd(invoice_date)+") 이후부터 실적등록이 가능합니다.\n\n※ 납품 완료 후 실적을 등록해 주십시요");
			box.checked = false;
			return;
		}
	}
}

// 납품수량 input check
function updateQty(row){
    var tot_cnt  = $("#display_item_cnt").val();

    if(eval(tot_cnt) < 2){
        var imsi_qty            = $.trim(filterNum(document.contentForm.delivery_qty.value));    // 납품수량
        var imsi_inv_qty        = $.trim(filterNum(document.contentForm.st_inv_qty.value));      // 송장수량

        if( isEmpty(imsi_qty) || !kepIsNumberString(imsi_qty) || (imsi_qty == 0) || (eval(imsi_qty) > eval(imsi_inv_qty)) ){
            alert("납품수량에 1 이상 " + imsi_inv_qty + " 이하의 숫자를 입력해 주십시요");
            document.contentForm.delivery_qty.value    = CommaNum(imsi_inv_qty);
            document.contentForm.st_delivery_qty.value = imsi_inv_qty;
            document.contentForm.delivery_qty.focus();
            return;
        }

        if(imsi_qty!=""){
            document.contentForm.delivery_qty.value    = CommaNum(imsi_qty);
            document.contentForm.st_delivery_qty.value = imsi_qty;
        }

    }else{
        var imsi_qty            = $.trim(filterNum(document.contentForm.delivery_qty[row].value));          // 납품수량
        var imsi_inv_qty        = $.trim(filterNum(document.contentForm.st_inv_qty[row].value));      // 송장수량

        if( isEmpty(imsi_qty) || !kepIsNumberString(imsi_qty) || (imsi_qty == 0) || (eval(imsi_qty) > eval(imsi_inv_qty)) ){
            alert("납품수량에 1 이상 " + imsi_inv_qty + " 이하의 숫자를 입력해 주십시요");
            document.contentForm.delivery_qty[row].value     = kepCommaNum(imsi_inv_qty);
            document.contentForm.st_delivery_qty[row].value  = imsi_inv_qty;
            document.contentForm.delivery_qty[row].focus();
            return;
        }

        if(imsi_qty!=""){
            document.contentForm.delivery_qty[row].value     = kepCommaNum(imsi_qty);
            document.contentForm.st_delivery_qty[row].value  = imsi_qty;
        }
    }// end else
}


//납품확정일 복사
function setMultiDeliverydate(){

	var tot_cnt  = $("#display_item_cnt").val();
	var chk_cnt = 0;
	
	if(eval(tot_cnt) < 2){
		// 품목이 하나일 경우는 생략
	}else{
		for(var k=0; k<tot_cnt ; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				if(document.contentForm.db_parcel_yn[k].value == 'N'){ // 배송유형 자차인 경우에만 납품확정일 복사
					chk_cnt++;
					if(chk_cnt==1){  // 체크한 품목중에 첫번째 납품확정일을 구해서 , 나머지 품목에 복사
						//delivery_date     = document.contentForm.st_delivery_date[k].value;
						delivery_date_text  = document.contentForm.st_delivery_date_text[k].value;
					}
			
					//document.contentForm.st_delivery_date[k].value       = delivery_date;
					document.contentForm.st_delivery_date_text[k].value  = delivery_date_text;
				}
			}
		}// end for
	}
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
 }else{
     for(var j = 0; j < tot_cnt; j++){
         var box = eval("document.contentForm.checkbox" + j);
         var check_status = "전체";

         if(box.checked == true) box.checked = false;
         $("#check_status").html(check_status);
     }
 }
}

function parcelInvNoCheck(){
	if(!kepIsAlphaNum("st_parcel_inv_no")){
		alert("영문, 숫자만 입력가능합니다.");
		$("#st_parcel_inv_no").focus();
		return false;
	}
	return true;
}

// 배송유형 selectbox 선택시
function setParcelYN(idx, value){
	if(value  == "Y"){ // 택배로 변경 시
		var stnd_inv_no = $("input[name=db_inv_no]").eq(idx).val();
		var length = $("input[id=onepagerow]").val();
		for(var i = 0; i < length ; i++){//같은 거래명세서 번호인 경우 같이 변경(화면에서 같아보이도록)
			var ith_inv_no = $("input[name=db_inv_no]").eq(i).val();
			if(stnd_inv_no == ith_inv_no){
				$("#st_item_parcel_yn"+i).val(value);
				$("#parcel_btn"+i).css("display","block");
				$("input[id=st_delivery_date_text"+i+"]").prop("type","hidden");
				$("input[id=st_delivery_date_text"+i+"]").datepicker("destroy");
			}
		}
	}else{ // 자차로 변경 시 
		var stnd_inv_no = $("input[name=db_inv_no]").eq(idx).val();
		var length = $("input[id=onepagerow]").val();
		for(var i = 0; i < length ; i++){//같은 거래명세서 번호인 경우 같이 변경(화면에서 같아보이도록)
			var ith_inv_no = $("input[name=db_inv_no]").eq(i).val();
			if(stnd_inv_no == ith_inv_no){
				$("#st_item_parcel_yn"+i).val(value);
				
				$("#parcel_btn"+i).css("display","none");
				
				$("input[id=st_delivery_date_text"+i+"]").prop("type","text");
				kepSetCalender('st_delivery_date_text'+i);
				$("input[id=st_parcel_com_code"+i+"]").val();
				
				$("span[id=parcel_text"+i+"]").text();
				$("span[id=st_parcel_com_name"+i+"]").text();
				$("span[id=st_parcel_inv_no"+i+"]").text();
				$("span[id=parcel_text2_"+i+"]").text();
			}
		}
	}
}
// 입력 대상건 체크 해제 시
function  setCheckBox(){
	
	if($("#st_insert_flag_check").is(":checked")){
		$("#st_insert_flag").val("Y");
		
	} else {
		$("#st_insert_flag").val("N");
		
	}
}
</script>
</head>
<style>
.div_black_04 span{ display:inline-block; background:url(/resources/images/s_btn_04.gif) 0 0 no-repeat; text-align:center; font-family:"맑은 고딕"; padding-top:2px; 0 0 no-repeat; width:70px; height:20px; text-align:center; padding-top:2px;}
.div_black_04 a{ display:inline-block; width:70px; height:20px; font-size:11px; color:#FFFFFF; font-weight:normal;}
.div_gray_04  span{ display:inline-block; background:url(/resources/images/c_btn_gray04.gif) 0 0 no-repeat; width:70px; height:20px; text-align:center; padding-top:2px;}
.div_gray_04  a{ display:inline-block; width:70px; height:20px; font-size:11px; color:#333333; font-weight:normal;}
</style>
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
	<h3>납품실적등록</h3>
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
					<col width="12%" />
					<col width="12%" />
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
			          <td colspan="2">
				          <label>&nbsp;&nbsp;&nbsp;
				          	<input type="checkbox" id = "st_insert_flag_check" name="st_insert_flag_check" onChange="setCheckBox();" class="Noborder">&nbsp;입력 대상 건 </td>
				          	<input type="hidden" id="st_insert_flag" name="st_insert_flag"  value="N" >
				          </label>
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
			          <td style="text-align:center">배송유형</td>
					  <td width="20%" >	
						<select name="st_parcel_yn" id ="st_parcel_yn">
						  <option value="">전체</option>
						  <option value="Y">택배</option>
						  <option value="N">자차</option>
						</select>
					  </td>	
			        </tr>
				</tbody>
			</table>
		</div>
		<br>
		
 		<!-- 버튼영역 -->
		<div class="btnArea" style="margin-bottom: 0px;">
			<span class="fl" style="padding-top: 5px;">
				<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow">
						<option value = "10" >10건</option>
						<option value = "20" >20건</option>
						<option value = "30" >30건</option>
						<option value = "40" >40건</option>
						<option value = "50" >50건</option> 
					</select>
				<font color="#FF0000">※ 택배출고는 송장 입력 시 시스템 상 배송흐름 자동 조회 후 자동 실적 등록(배송완료 처리 불필요)</font>
	      	</span>      
			<div class="fr">
				<span class="btn_03 mr04"><a href="javascript:doAction('excelDownload')">엑셀다운로드</a></span>
				<span class="btn_08 mr04"><a href="javascript:doPop('excelUpload')">택배송장 일괄업로드</a></span>
				<span class="btn_08 mr04"><a href="javascript:doPop('deliveryDateMulti')" id="set_multi_date">고객 수령일 일괄등록</a></span>
				<span class="btn_04">
					<a href="javascript:doAction('create');">배송완료</a>
				</span>	
            </div>
        </div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list04" style="width:100%">
			<colgroup>
 	            <col width="3%" />
	            <col width="6%" /><!-- 발주번호 -->
	            <col width="6%" /><!-- 거래명세서번호-->
	            <col width="20%" /><!-- 고객사 -->
	            <col width="6%" /><!-- 거래유형 -->
	            <col width="13%" /><!-- 배송유형 -->
	            <col width="6%" /><!-- 택배송장등록 -->
	            <col width="6%" /><!-- 납품예정일 -->
	            <col width="15%" /><!-- 고객 수령일 -->
	            <col width="3%" /><!-- 배송완료 증빙 -->
	            <col width="3%" /><!-- 선입고 -->
	        </colgroup>
	        <thead>
				<tr>
					<th scope="col">
						<a href="javascript:checkAll();" id="check_status">전체</a>
					</th>
					<th scope="col">발주번호</th>
					<th scope="col">거래명세서</th>
					<th scope="col">고객사</th>
					<th scope="col">거래유형</th>
					<th scope="col">배송유형</th>
					<th scope="col">택배송장등록</th>
					<th scope="col">납품예정일</th>
					<th scope="col">고객 수령일</th>
					<th scope="col">배송완료증빙</th>
					<th scope="col">선입고</th>
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
	        <tr align="center" bgcolor="<%=tclass%>" height="50">
				<td>
					<input type="hidden" name="db_buyer"        value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
					<input type="hidden" name="db_po_no"        value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
					<input type="hidden" name="db_po_seq"       value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">
					<input type="hidden" name="db_inv_no"       value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>">
					<input type="hidden" name="db_inv_seq"      value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>">
					<input type="hidden" name="db_invoice_date" value="<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>">
					<input type="hidden" name="st_gr_auto_flag"     id="st_gr_auto_flag"      value="<%=rowData.get("AUTO_GR_FLAG") %>">
					<input type="hidden" name="db_parcel_com_name" value="<%=CommonUtil.nvl(rowData.get("PARCEL_COM_NAME"))%>">
					<input type="hidden" name="db_buyer_nm"        value="<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>">
					<input type="hidden" name="db_process_type"        value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>">
					<input type="checkbox" name="checkbox<%=j%>" value="" id="check" onClick="javascript:checkInvoiceDate('<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>','<%=j%>')">
					<input type="hidden" name="p070000029_YN"        value="<%=CommonUtil.nvl(rowData.get("P070000029_YN"))%>">
					<input type="hidden" name="db_parcel_yn" id="db_parcel_yn<%=j%>"        value="<%=CommonUtil.nvl(rowData.get("PARCEL_YN"))%>">
					<input type="hidden" name="delivery_qty" size="7" class="input_type_text ar"  value="<%=CommonUtil.formatNumber(rowData.get("DS_QTY"),true,0,3)%>" onchange="updateQty(<%=j%>)" readOnly>
	                <input type="hidden" name="st_delivery_qty" value="<%=CommonUtil.nvl(rowData.get("DS_QTY"))%>">
	                <input type="hidden" name="st_inv_qty"      value="<%=CommonUtil.nvl(rowData.get("DS_QTY"))%>">
				</td>
				<td><!-- 발주번호 -->
	                <a href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>')" class="hyperLink" ><%=CommonUtil.nvl(rowData.get("PO_NO"))%></a>
	          	</td>
	          	
				<td><!-- 거래명세서 -->
					<a href="javascript:doPop('commonMpIvTranStatementDetailIVPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>' ,'<%=CommonUtil.nvl(rowData.get("INV_NO"))%>' ,'<%=CommonUtil.nvl(rowData.get("SELLER"))%>' ,'<%=CommonUtil.nvl(rowData.get("LEGACY_IV_SERIAL"))%>'  ,'<%=CommonUtil.nvl(rowData.get("TR_BUYER"))%>')" class="hyperLink" >
						<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
	                </a>
	         	</td>
	      
				<td><!-- 고객사 -->
					<a href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');" class="hyperLink"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></a>
				</td>
	          
				<td><!-- 거래유형 -->
					<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_TEXT")) %>	
				</td>
				<td><!-- 배송유형 -->
					<% if(CommonUtil.nvl(rowData.get("PARCEL_COM_CODE")).isEmpty() || CommonUtil.nvl(rowData.get("PARCEL_INV_NO")).isEmpty()) {  %>
					<select name="st_item_parcel_yn" id ="st_item_parcel_yn<%=j%>" style="width:95px;text-align-last:center" onChange="setParcelYN(<%=j%>, this.value)">
					  <option value="Y" <%if (rowData.get("PARCEL_YN").equals("Y")) {%>selected<%} %>>택배</option>
					  <option value="N" <%if (rowData.get("PARCEL_YN").equals("N")) {%>selected<%} %>>자차</option>
					</select>
					<span id="st_item_parcel_yn_text<%=j%>" style="display:none;">택배</span>
					<%}else{ %>
					택배
					<input type="hidden" id ="st_item_parcel_yn<%=j%>" value="Y">
					<%} %>
				</td>	          
				<td><!-- 택배송장등록 -->
				<%if(CommonUtil.nvl(rowData.get("PARCEL_YN"), "N").equals("Y")) {
					if(CommonUtil.nvl(rowData.get("PARCEL_COM_CODE")).isEmpty() || CommonUtil.nvl(rowData.get("PARCEL_INV_NO")).isEmpty()) {
				%>
					<div class="div_gray_04"id="parcel_btn<%=j%>">
						<span class="btn_gray_04"><a href="javascript:doPop('setParcelInfo','<%=j%>')">송장등록</a></span>
					</div>
				<%	}else{  %>
					<div class="div_black_04" >
						<span><a href="javascript:doPop('setParcelInfo','<%=j%>')">송장등록</a></span>
					</div>
					
				<%	}
				}else{
			%>
				<div class="div_gray_04"id="parcel_btn<%=j%>" style="display:none;">
						<span class="btn_gray_04"><a href="javascript:doPop('setParcelInfo','<%=j%>')">송장등록</a></span>
				</div>
			<% }%>
				</td>
	          	<td><!-- 납품예정일 -->
	          		<%=CommonUtil.formatDate( rowData.get("DS_DATE"), 1)%>
	          	</td>
	          	
	            <td><!-- 고객 수령일 -->
	            	<input type="hidden" "id="st_parcel_com_code<%=j%>" name="st_parcel_com_code" value="<%=CommonUtil.nvl(rowData.get("PARCEL_COM_CODE"))%>">
	            	
					<span id="parcel_text<%=j%>" style="display:
						<%if(!CommonUtil.nvl(rowData.get("PARCEL_COM_CODE")).isEmpty() || !CommonUtil.nvl(rowData.get("PARCEL_INV_NO")).isEmpty()) {%>block<%}else{ %>none<%}%>;">
						<% if(rowData.get("PARCEL_PRO_STATUS").equals("검색되지않음")) { %>
							<font color="red">송장정보 확인요청</font>					
						<% } else { %>
							<%=CommonUtil.nvl3(rowData.get("PARCEL_PRO_STATUS"), "")%>
						<% } %>
						<br>
					</span>
					
					<a id="st_parcel_real_url<%=j%>" href="<%=CommonUtil.nvl3(rowData.get("PARCEL_REAL_URL"), "")%>" target="_blank" style="display:
								<%if(!CommonUtil.nvl(rowData.get("PARCEL_COM_CODE")).isEmpty() || !CommonUtil.nvl(rowData.get("PARCEL_INV_NO")).isEmpty()) {%>block;<%}else{%>none;<%}%>">
						( 
						<span id="st_parcel_com_name<%=j%>" name="st_parcel_com_name" size="14" style="background-color:<%=tclass%>; border:<%=tclass%> 1px solid;"><%=CommonUtil.nvl(rowData.get("PARCEL_COM_NAME"))%></span>
						<span id="st_parcel_inv_no<%=j%>" name ="st_parcel_inv_no" size="14" style="background-color:<%=tclass%>; border:<%=tclass%> 1px solid;"><%=CommonUtil.nvl(rowData.get("PARCEL_INV_NO"))%></span>
						)
					</a>
					 
					<input type=<%if(rowData.get("PARCEL_YN").equals("Y")) {%>"hidden"<%}else{%>"text"<%} %>  name="st_delivery_date_text" id="st_delivery_date_text<%=j%>" size="10" class="input_type_text"  value="<%=CommonUtil.formatStrinigDate(rowData.get("INVOICE_DATE"))%>" readonly>
				</td>
	          
	           <td><!-- 배송완료증빙 -->
					<input type="hidden" name="st_image_key" id="st_image_key" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_INV"))%>">
					<%
					if(CommonUtil.nvl(rowData.get("PROCESS_TYPE")).equals("0")){
						if(!"".equals(rowData.get("IMAGE_KEY_INV"))) {
					%>
					<a href="javascript:doPop('attachSet',<%=j%>);"><img src="/resources/images/disk_on.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
					<%
						}else{
					%>
					<a href="javascript:doPop('attachSet',<%=j%>);"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
					<%
						}
					} else { 
					%>
					<img style="display: none;" name="st_image_key_img" id="st_image_key_img">
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
		<div id="paging" class="paging" style="height:20px;">
			<div style="text-align:left;float:left;">
				<font style="font-size:12px;">&nbsp;총건수 <%=total_cnt%>			</font>
			</div>
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</div>  
		
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME"	id="s_SAVENAME"	value="" />
	<input type="hidden" name="total_cnt"	id="total_cnt"	value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" 	id="curPage"	value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow"	id="onepagerow"	value="<%=onepagerow %>"/>
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
				Map<String, String> _map = _gridList.get(j);
				String parcel_yn = _map.get("PARCEL_YN");
%>
				kepSetCalender("st_delivery_date_text<%=j%>");
				if("<%=parcel_yn%>" == "Y" ){
					$('input[id="st_delivery_date_text<%=j%>"]').datepicker("destroy");
				}
<%
			}
		}
%>
	});
</script>
