<%--
**********************************************
* 메뉴 : 주문관리>장바구니(코웨이용)
* 화면 : 장바구니(코웨이용)
* 기능 : 코웨이용 장바구니
* 프로그램 ID : PG_06_B_010_00	- CY20006243 -- 20015159
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="cu" uri="/WEB-INF/tld/commonUtil.tld"%>
<%
	String buyer             = "";
	String userType 		 = "";
	String userID 		     = "";
	String userName 		 = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String row_cnt          ="";
	if (sessionInfo != null){
		buyer             = sessionInfo.getComCode();
		userType         = sessionInfo.getUserType();
	    userID            = sessionInfo.getUserId();
	    userName          = sessionInfo.getUserNameLoc();
	    row_cnt = CommonUtil.nvl((String)sessionInfo.getRowCnt()); //20070704 추가 페이지 기본 개수
	}
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt);  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	//p060000058 일반사용자 배송지변경 불가 SLOGIC
	boolean p060000058= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000058");
	 //해당사용자는 대표코드사용 
	 boolean getCodeC007 = CommonUtil.getCode2CheckReturn("C007",userID,buyer);
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf" %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<script type="text/javascript">
	var popupSel = "";
	// 최초 화면 함수 
	function kep_onload_view(){
		/*
		var st_buyer = $('#st_buyer').val();
		if(st_buyer == 'KRCOWA0003')
			getCowayPoint();
		*/
	}
	
	//기능함수
	var str = "";
	function doAction(str) {
		switch (str) { 
			case "PrSheet": 
				item_qty_update('PrSheet');
				break; 
	
			case "getCowayBudgetList":	//예산조회
				getCowayBudgetList();
				break; 
	
			case "SAVE":	//저장
				item_qty_update('SAVE');
				break; 
	
			case "setMyCatalogReg":	//나의상품등록
				setMyCatalogReg();
				break; 
	
			case "setCartDelete":	//삭제
				setCartDelete();
				break; 
	
			case "CART":
				item_check('CART');
				break; 
	
			case "ORDER":
				item_check('ORDER');
				break; 
	
		}
	}
	
	function item_qty_updateSel(row){
		lnCheckFalse(); // 전체 선택박스 해제
		var box = eval("document.forms.contentForm.lnCheck" + row);
		box.checked = true;
		var userRole2 = $('#userRole2').val();
		var stQueryCart = document.forms.searchForm.st_query_cart.value;//$('#st_query_cart').val();
		if(userRole2 == '+'){
			if(stQueryCart == 'ALL'){
				doAction('CART');
			} else {
				doAction('ORDER');
			}
		}
	}
	
	function setMyCatalogRegSel(row){
		lnCheckFalse(); // 전체 선택박스 해제
		var box = eval("document.forms.contentForm.lnCheck" + row);
		box.checked =true;	
		doAction('setMyCatalogReg'); 
	}
	
	function lnCheckFalse(){
		var tot_cnt =$("#display_item_cnt").val();
		if(eval(tot_cnt) < 2)	{ 
			var box = eval("document.forms.contentForm.lnCheck0");
			box.checked = false;
		} else{
			for(var x=0; x<eval(tot_cnt); x++) {
				var box = eval("document.forms.contentForm.lnCheck" + x);
				box.checked = false;
			} 
		}
	}
	
	// 조회
	function kepSearch(curPage){
		document.forms.searchForm.curPage.value = curPage;
		document.forms.searchForm.st_ji_gubun.value = document.forms.contentForm.st_ji_gubun.value;
		document.forms.searchForm.st_sin_gubun.value = document.forms.contentForm.st_sin_gubun.value;
		$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartCowayClcsList.do").submit();	
	}
	
	//이미지 보이기 숨기기
	function imageHideView(){ 
		var image_status	= $("#st_image_status").val();
		if(image_status == "IMAGE_HIDDEN"){
			image_status = "IMAGE_VIEW"; 
		}else if(image_status == "IMAGE_VIEW"){
			image_status = "IMAGE_HIDDEN"; 
		}
		$("#st_image_status").val(image_status);
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}

	function attach_popup(img_key, obj1){
		var type = "PR";
		var viewType = "C";
		gridIndex = obj1;
		popupSel = "attach";
		kepFileUploadOpenPopup(img_key,type,viewType); 
	}
	
	/**
	 * 첨부파일 구현
	 */
	var gridIndex = 0;
	function gridPopOpen(obj1){ 
		gridIndex = obj1;
		popupSel = "attach";
		//attach_popup($("input[name=st_image_key]").eq(gridIndex).val());
		attach_popup(document.forms.contentForm.st_image_key.value, gridIndex);
		
	}

	
	//파일정보 저장
	 function saveAttach(g_row){
		var st_user_id = $('#st_user_id').val();
		var st_buyer = $('#st_buyer').val();
		var query = "";
		var tot_cnt = $("#display_item_cnt").val();
		var st_item_no = "";
		var st_contract_no = "";
		var st_contract_seq = "";
		var st_cart_seq = "";
		if(tot_cnt<=1) {
			st_item_no = document.forms.contentForm.st_item_no.value;
			st_contract_no = document.forms.contentForm.st_contract_no.value;
			st_contract_seq = document.forms.contentForm.st_contract_seq.value;
			image_key = document.forms.contentForm.st_image_key.value;
			st_cart_seq = document.contentForm.st_cart_seq.value;
			
		}else {
			st_item_no = document.forms.contentForm.st_item_no[g_row].value;
			st_contract_no = document.forms.contentForm.st_contract_no[g_row].value;
			st_contract_seq = document.forms.contentForm.st_contract_seq[g_row].value;
			image_key = document.forms.contentForm.st_image_key[g_row].value;
			st_cart_seq = document.contentForm.st_cart_seq[g_row].value;
			
		}
		if(isEmpty(TrimCommon(image_key))) 
			image_key="";
		query += image_key + "@@";
		query += st_buyer + "@@";
		query += st_user_id + "@@";
		query += st_contract_no + "@@";
		query += st_contract_seq + "@@";
		query += st_item_no + "@@";
		query += st_cart_seq + "@@";
		document.forms.processForm.st_query2.value = query;	
		kepAjaxFormCall("/mpso/getBuyerShoppingcartListAttachUpdate.do","processForm","FILE");
	}
	
	//상품 큰이미지
	function getBigImage(file_dir, file_name){
		var getUrl = $('#getUrl').val();
		var realImgUploadPath = $('#realImgUploadPath').val();
		getBigImageView(getUrl+realImgUploadPath, file_dir, file_name);
	}
	
	//예산부서 팝업 조회 PG_06_B_010_01 비용부서조회
	function getDeptAccountPop(buyer,row) {
		var tot_cnt = $("#display_item_cnt").val();
		var st_byit_bdgt_flag = "";
		if(eval(tot_cnt) < 2){
			st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag.value;
			var box = eval("document.forms.contentForm.lnCheck0");
			box.checked =true;
		} else {
			st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag[row].value; 
			var box = eval("document.forms.contentForm.lnCheck" + row);
			box.checked =true;
		}
		
		if(st_byit_bdgt_flag == "Y"){ 
			var cnt = getCheckedRowCount(tot_cnt); 
			var user_id = $('#st_user_id').val();
			openSearchPopup("/mpso/showBuyerUserCowayBudgetOrderListPop.do","?open=Y&userId="+user_id, "600,500,no"); 
			return;
		} else {
			alert("예산통제 품목이 아닙니다.");
			return;
		}
	}

	//예산부서설정
	function setDeptAccount(dept_code , dept_name){
		var tot_cnt = $("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
			document.forms.contentForm.st_budget_dept_name.value	= dept_name;
			document.forms.contentForm.st_budget_dept.value	= dept_code;
			document.forms.contentForm.st_account_type_name.value	= "선택";
			document.forms.contentForm.st_account_type.value = "";
			
		} else {
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.lnCheck" + k);
				if(box.checked == true){
					if(document.forms.contentForm.st_byit_bdgt_flag[k].value =="Y"){
						document.forms.contentForm.st_budget_dept_name[k].value	= dept_name;
						document.forms.contentForm.st_budget_dept[k].value		= dept_code;
						document.forms.contentForm.st_account_type_name[k].value	= "선택";
						document.forms.contentForm.st_account_type[k].value = "";
	
					} else {
						document.forms.contentForm.st_budget_dept_name[k].value = "";
						document.forms.contentForm.st_budget_dept[k].value = "";
						document.forms.contentForm.st_account_type_name[k].value = "";
						document.forms.contentForm.st_account_type[k].value = "";
	
					}
				}
			}
		}
	}
	
	
	//예산계정 선택 팝업 PG_06_B_010_02 계정조회
	function getBdgtAccountPop(com_code,dept_code,row){
		var tot_cnt = $("#display_item_cnt").val();
		var dept_cd="";
		var cart_sum_price = "";
		var st_byit_bdgt_flag = "";
	
		if(eval(tot_cnt) < 2){
			dept_cd = document.forms.contentForm.st_budget_dept.value;
			cart_sum_price = eval(filterNum(document.forms.contentForm.st_sum_price.value));
			st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag.value;
			var box = eval("document.forms.contentForm.lnCheck0");
			box.checked =true;

		} else {
			dept_cd = document.forms.contentForm.st_budget_dept[row].value;
			cart_sum_price = eval(filterNum(document.forms.contentForm.st_sum_price[row].value));
			st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag[row].value;
			var box = eval("document.forms.contentForm.lnCheck" + row);
			box.checked = true;
			var initBudgetDept = "";
			var cnt = 0;
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.lnCheck" + k);
				if(box.checked == true){
					if(document.forms.contentForm.st_byit_bdgt_flag[k].value !="Y"){
						document.forms.contentForm.st_budget_dept_name[k].value = "";
						document.forms.contentForm.st_budget_dept[k].value = "";
						document.forms.contentForm.st_account_type_name[k].value = "";
						document.forms.contentForm.st_account_type[k].value = "";
						
					}
					if(cnt < 1){
						initBudgetDept = document.forms.contentForm.st_budget_dept[k].value;
						cnt++;
					} else {
						if( initBudgetDept != document.forms.contentForm.st_budget_dept[k].value ){
							alert("서로 다른 예산부서가 선택되었거나\n 예산비통제 품목이 선택 되었습니다.");
							return;
						}
					}
				}
			}
		}

		//COWAY 예산 사용경우st_byit_bdgt_flag == "Y"
		if(st_byit_bdgt_flag == "Y"){ 
			if(dept_cd.length == 0){
				alert("예산부서를 선택하여 주세요.");
				return;
			}
			var cnt = getCheckedRowCount(tot_cnt);
			cart_sum_price = document.forms.searchForm.st_check_sum_price.value;
			openSearchPopup("/mpso/showBuyerUserCowayBudgetAccountListPop.do","?open=Y&st_buyer="+ com_code+"&st_userDept="+dept_cd+"&st_cart_sum_price="+cart_sum_price , "1000,510,no"); 
			return;
		} else {
			alert("예산통제 품목이 아닙니다.");
		}
	 }
	 
	//예산계정 설정
	 function setBdgtAccount(account_type , account_name){
		var tot_cnt =$("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
			document.forms.contentForm.st_account_type_name.value	= account_name;
			document.forms.contentForm.st_account_type.value = account_type;
	
		} else {
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.lnCheck" + k);
				if(box.checked == true){
					if(document.forms.contentForm.st_byit_bdgt_flag[k].value =="Y"){
						document.forms.contentForm.st_account_type_name[k].value	= account_name;
						document.forms.contentForm.st_account_type[k].value		= account_type;
					} else {
						document.forms.contentForm.st_account_type_name[k].value	= "";
						document.forms.contentForm.st_account_type[k].value		= "";
					}
				}
			}
		}
	}
	
	//코웨이예산내역 조회 PG_06_B_010_03 부서예산조회
	function getCowayBudgetList(){
		var stUserDept = $('#st_user_dept').va();
		var account_type ="ALL";
		var term_type ="ALL";
		var select_year =$('#selectYear').val();
		var st_buyer = $('#st_buyer').val();
		openSearchPopup("/mpso/showBuyerCowayUserBudgetAccountListPop.do","?open=Y&st_buyer="+st_buyer+"&st_dept_code="+stUserDept+"&st_account_type="+account_type+"&st_term_type="+term_type+"&st_from_year="+select_year , "800,500,no"); 
	}
	
	function price_update(cart_qty, y_num, buy_price,orgin_cart_qty){
		var st_buyer = $('#st_buyer').val();
		var tot_cnt = $("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
			if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
			} else {
				var sum_price = kepGetRound((cart_qty * buy_price),3);
				document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
				if(st_buyer == "KRCOWA0002" || st_buyer == "KRCOWA0007" || st_buyer == "KRCOWA0003" || st_buyer == "KRCOWA0008"){
					var sum_budam_price = document.contentForm.st_sum_budam_price.value;
					var sum_budam_amt = kepGetRound((cart_qty * sum_budam_price),3);
					document.contentForm.st_sum_budam_amt.value = kepCommaNum(sum_budam_amt);
				}
			}
		} else {
			if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
			} else {
				var sum_price = kepGetRound((cart_qty * buy_price),3);
				document.forms.contentForm.st_sum_price[y_num-1].value = kepCommaNum(sum_price);
				if(st_buyer == "KRCOWA0002" || st_buyer == "KRCOWA0007" || st_buyer == "KRCOWA0003" || st_buyer == "KRCOWA0008"){
					var sum_budam_price  = document.contentForm.st_sum_budam_price[y_num-1].value;
					var sum_budam_amt = kepGetRound((cart_qty * sum_budam_price),3);
					document.contentForm.st_sum_budam_amt[y_num-1].value = kepCommaNum(sum_budam_amt);
				}
			}
		}
		chk_sum_price(); // 선택 품목 총 합계금액
	}

	function price_update_P(y_num, buy_price,orgin_cart_qty){
		var tot_cnt = $("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
			var cart_qty = document.forms.contentForm.st_order_qty.value;
			if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
			} else {
				var sum_price = kepGetRound((cart_qty * buy_price),3);
				document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
			}

		} else {
			var cart_qty = document.forms.contentForm.st_order_qty[y_num-1].value;
			if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
			} else {
				var sum_price = kepGetRound((cart_qty * kepRemoveComma(buy_price)),3);
				document.forms.contentForm.st_sum_price[y_num-1].value = kepCommaNum(sum_price);
			}
		}
		chk_sum_price(); // 선택 품목 총 합계금액
	}

	//선택 품목 총 합계금액
	function chk_sum_price(){
		var maxRow = $("#display_item_cnt").val();
		var sum_price = 0;
		if(eval(maxRow) < 2){
			var box = eval("document.forms.contentForm.lnCheck"+0);
			if(box.checked == true){
				sum_price = eval(sum_price) + eval(kepFilterNum(document.forms.contentForm.st_sum_price.value));
			}
		} else {
			for(var j = 0; j < maxRow; j++){
				var box = eval("document.forms.contentForm.lnCheck" + j);
				if(box.checked == true){
					sum_price = eval(sum_price) + eval(kepFilterNum(kepRemoveComma(document.forms.contentForm.st_sum_price[j].value)));
				}
			}
		}
		document.forms.searchForm.check_sum_price.value = kepCommaNum(sum_price) + " 원";
		document.forms.searchForm.st_check_sum_price.value = sum_price;
		
	}

	function item_qty_update(next_status){ // CART : 배송지 입력화면 이동,	ORDER : 주문최종 확인 화면 이동
		var tot_cnt = $("#display_item_cnt").val();
		var chk_cnt = 0;
		var query = "";
		var next_status = next_status;
		var ck_ref_pr_no ="";
		var ck_ref_pr_dept ="";
		var budget_flag = $("#budgetFlag").val();
		var st_buyer = $('#st_buyer').val();
		if(eval(tot_cnt) == 0) {
			alert("조회한 데이타가 없습니다.");
			return;
		}
		chk_cnt = getCheckedRowCount(tot_cnt);
		if(chk_cnt == "0"){
			alert("하나 이상의 상품이 선택되어야 합니다.	");
			return;
		}
		if(eval(tot_cnt) < 2){
			var box = eval("document.forms.contentForm.lnCheck0" );
			var st_item_no = document.forms.contentForm.st_item_no.value;
			var st_order_qty = TrimCommon(document.forms.contentForm.st_order_qty.value);
			var st_ref_pr_no = document.forms.contentForm.st_ref_pr_no.value;
			var st_contract_no = document.forms.contentForm.st_contract_no.value;
			var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
			var st_fixed_price_flag = document.forms.contentForm.st_fixed_price_flag.value;
			var st_order_price = document.forms.contentForm.st_order_price.value;
			var st_account_type = document.forms.contentForm.st_account_type.value;
			var st_budget_dept = document.forms.contentForm.st_budget_dept.value;
			var product_close_flag = document.forms.contentForm.st_product_close_flag.value;
			var process_type = document.forms.contentForm.st_process_type.value;
			var stock_item_flag = document.forms.contentForm.st_stock_item_flag.value;
			var ref_pr_dept = document.forms.contentForm.st_ref_pr_dept.value;
			var image_key = document.forms.contentForm.st_image_key.value;
			var format_type = document.forms.contentForm.st_format_type.value;
			//코웨이 예산체크 플래그
			var st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag.value;
			var remark = "NO_REMARK";
			var st_cart_seq = document.contentForm.st_cart_seq.value;
			var st_mg_code = document.contentForm.st_mg_code.value;
			var st_mg_note = document.contentForm.st_mg_note.value;
			var st_bcode = document.contentForm.st_bcode.value;
			var st_zcode = document.contentForm.st_zcode.value;
			var st_zcode_count = document.contentForm.st_zcode_count.value;
			//부담금
			var st_sum_budam_amt = document.contentForm.st_sum_budam_amt.value;
			var st_gongje = document.contentForm.st_gongje.value;
			var st_smenge = "";
			var st_lmenge = "";
			var st_ji_gubun = "";
			var st_sin_gubun = "";
			var st_drcp_gubun = "";
			
			if(box.checked == true){
				if(product_close_flag == "Y"){
					alert("해당 품목은 단종되었습니다.");
					box.checked = false;
					return;
				}
				if(process_type=="1" && stock_item_flag=="N"){
					alert("해당 품목은 재고품목 입니다.\n\n품목상태가 올바르지 않습니다.\n\n담당자에게 확인 바랍니다.");
					box.checked = false;
					return;
				}
				if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || isEmpty(st_order_qty) || !chkDecimal(st_order_qty,3)){
					alert("품목의 발주수량(숫자)을 입력하여 주십시요.");
					document.forms.contentForm.st_order_qty.focus();
					return;
				}
				//양식타입이 있을경우 파일 첨부는 반드시 있어야 할것.
				if(format_type == "A" || format_type== "B" || format_type == "C" || format_type== "E"){
					if(image_key == "" || image_key == "null" || image_key == null || image_key == " "){
						alert("해당품목의 양식을 첨부하여 주십시요.");
						return;
					}
				}
				if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
					st_ref_pr_no = " ";
				}
				if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
					if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
						if(st_byit_bdgt_flag == "Y"){
							alert("예산 적용 부서 및 계정을 선택해 주십시요");
							return;
						}
					}
				}

				if(st_byit_bdgt_flag == "N"){
					document.forms.contentForm.st_budget_dept.value = "";
					document.forms.contentForm.st_account_type.value = "";
					st_budget_dept = "";
					st_account_type = "";
				}
				if((st_buyer=="KRCOWA0002"||st_buyer=="KRCOWA0007"||st_buyer=="KRCOWA0003"||st_buyer=="KRCOWA0008") && (next_status == "CART" || next_status =="ORDER")){
					st_smenge = document.contentForm.st_smenge.value;
					st_lmenge = document.contentForm.st_lmenge.value;
					st_ji_gubun = document.contentForm.st_ji_gubun.value;
					st_sin_gubun = document.contentForm.st_sin_gubun.value;
					if(eval(st_zcode_count) > 0 && (st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " ")){
						alert("대상자를 선택하셔야 합니다.");
						return;
					}
					if(eval(st_zcode_count) > 1 && st_zcode == ""){
						alert("파일첨부/양식 아래 선택(빨간색) 버튼을 눌러서 진행해 주세요.");
						getZcodePop("0", st_item_no);
						return;
					}
					if( st_sum_budam_amt == "null" || st_sum_budam_amt == null || st_sum_budam_amt == ""){
						alert("파일첨부/양식 아래 선택(빨간색) 버튼을 눌러서 진행해 주세요.");
						getZcodePop("0", st_item_no);
						return;
					}
					if( st_zcode == "null" || st_zcode == null || st_zcode == ""){
						alert("해당 품목의 대표코드 정보가 없습니다.");
						return;
					}
					if(eval(st_zcode_count) > 0){
						st_mg_note = st_zcode+"&"+st_bcode+"&"+st_ji_gubun+"&"+st_sin_gubun+"&"+st_sum_budam_amt+"&"+st_gongje+"&";
					}
					var st_comma_Smenge = st_smenge.replace(",","");
					if(eval(st_comma_Smenge) > eval(st_order_qty)){
						alert("해당 품목의 최소값 "+st_smenge+" 이상 주문하셔야 합니다.");
						return;
					}
					var st_comma_lmenge = st_lmenge.replace(",","");
					if(eval(st_comma_lmenge) < eval(st_order_qty)){
						alert("해당 품목의 최대값 "+st_lmenge+" 이하 주문하셔야 합니다.");
						return;
					}
					if(st_buyer=="KRCOWA0003"){
						st_drcp_gubun = document.contentForm.st_drcp_gubun.value;
						if(st_drcp_gubun=="Y"){
							if(confirm("포인트 사용 하시겠습니까?")){
// 								alert(document.searchForm.st_check_sum_price.value)
// 								alert(document.searchForm.pointValue.value)
								if(document.searchForm.pointValue.value == '0'){
									alert('잔여 포인트가 없습니다.');
									return;
								}
								document.locationForm.st_drcp_gubun.value = document.contentForm.st_drcp_gubun.value;
								var buy_price = document.contentForm.st_order_price.value;
								var cart_qty = document.contentForm.st_order_qty.value;
								var sum_price = kepGetRound((cart_qty * kepRemoveComma(buy_price)),3);
								st_mg_code = sum_price;
								document.contentForm.st_mg_code.value = st_mg_code;
							} else {
								document.contentForm.st_drcp_gubun.value = "N";
								return;
							}
						} else {
							st_mg_code = "";
							document.contentForm.st_mg_code.value = st_mg_code;
						}
					}
				}
				query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+st_mg_code+ "@@"+st_mg_note+ "@@"+st_cart_seq;
				query += "|";
			}
		} else {
			var cNum = 0;
			var old_st_agent_code="";
			var diff_agent_status="false";
			var old_st_budget_flag="";
			var diff_budget_flag_status="false";
			for(var j = 0; j < tot_cnt; j++){
				var box = eval("document.forms.contentForm.lnCheck" + j);
				var st_item_no = document.forms.contentForm.st_item_no[j].value;
				var st_order_qty = TrimCommon(document.forms.contentForm.st_order_qty[j].value);
				var st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[j].value;
				var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
				var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
				var st_fixed_price_flag = document.forms.contentForm.st_fixed_price_flag[j].value;
				var st_order_price = document.forms.contentForm.st_order_price[j].value;
				var st_account_type = document.forms.contentForm.st_account_type[j].value;
				var st_budget_dept = document.forms.contentForm.st_budget_dept[j].value;
				var product_close_flag = document.forms.contentForm.st_product_close_flag[j].value;
				var process_type = document.forms.contentForm.st_process_type[j].value;
				var stock_item_flag = document.forms.contentForm.st_stock_item_flag[j].value;
				var ref_pr_dept = document.forms.contentForm.st_ref_pr_dept[j].value;
				var remark = "NO_REMARK";
				var st_agent_code = document.forms.contentForm.st_agent_code[j].value;
				var image_key = document.forms.contentForm.st_image_key[j].value;
				var format_type = document.forms.contentForm.st_format_type[j].value;
				var st_category_no = document.forms.contentForm.st_category_no[j].value;
				var st_cate_appr = document.forms.contentForm.st_cate_appr[j].value;
				//코웨이 예산체크 플래그
				var st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag[j].value;
				var st_cart_seq = document.contentForm.st_cart_seq[j].value;
				var st_mg_code = document.contentForm.st_mg_code[j].value;
				var st_mg_note = document.contentForm.st_mg_note[j].value;
				var st_bcode = document.contentForm.st_bcode[j].value;
				var st_zcode = document.contentForm.st_zcode[j].value;
				var st_zcode_count = document.contentForm.st_zcode_count[j].value;
				//부담금
				var st_sum_budam_amt = document.contentForm.st_sum_budam_amt[j].value;
				var st_gongje = document.contentForm.st_gongje[j].value;
				var st_smenge = "";
				var st_lmenge = "";
				var st_ji_gubun = "";
				var st_sin_gubun = "";
				var st_drcp_gubun = "";
				if(box.checked == true) {
					cNum++;
					if(cNum ==1 ){
						ck_ref_pr_dept = ref_pr_dept;
					}
					if(old_st_agent_code != '' && old_st_agent_code != st_agent_code){
						diff_agent_status = "true";
					}
					old_st_agent_code=st_agent_code;
					for(var k = 0; k< tot_cnt; k++){
						var k_box = eval("document.forms.contentForm.lnCheck" + k);
						if(k_box.checked == true) {
							var k_gongje = document.contentForm.st_gongje[k].value;		
							if(st_gongje != k_gongje){
								alert("운영비 공제와 수수료 공제 품목은 함께 주문할 수 없습니다.");
								return;
							}
						}
					}
					if(product_close_flag == "Y"){
						alert((j+1)+"번째 품목은 단종되었습니다.");
						box.checked = false;
						return;
					}
					if(process_type=="1" && stock_item_flag=="N"){
						alert("해당 품목은 재고품목 입니다.\n\n품목상태가 올바르지 않습니다.\n\n담당자에게 확인 바랍니다.");
						box.checked = false;
						return;
					}
					//양식타입이 있을경우 파일 첨부는 반드시 있어야 할것.
					if(format_type == "A" || format_type== "B" || format_type == "C" || format_type== "E"){
						if(image_key == "" || image_key == "null" || image_key == null || image_key == " "){
							alert((j+1)+"번째 품목의 양식을 첨부하여 주십시요.");
							return;
						}
					}
					if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || isEmpty(st_order_qty) || !chkDecimal(st_order_qty,3)){
						alert((j+1)+"번째 품목의 발주수량(숫자)을 입력하여 주십시요.");
						document.forms.contentForm.st_order_qty[j].focus();
						return;
					}
					if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
						st_ref_pr_no = " ";
					}
					//카테고리별결재담당자가 정해져 있는 품목은 동일 카테고리끼리만 주문 가능하다.
					if(st_cate_appr > 0){
						var st_tmp_category_no = "";
						var st_tmp_cate_appr = 0;
						for(var k = 0; k < tot_cnt; k++){
							var box2 = eval("document.forms.contentForm.lnCheck" + k);
							if(box2.checked == true){
								st_tmp_category_no = document.forms.contentForm.st_category_no[k].value;
								st_tmp_cate_appr = document.forms.contentForm.st_cate_appr[k].value;
								if((st_tmp_cate_appr == 0) || (st_category_no != st_tmp_category_no)){
									alert("카테고리별 결재 담당자 지정 품목은 동일 카테고리 품목만 주문 가능합니다.");
									return;
								}
							}
						}
					}
					if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
						if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
							if(st_byit_bdgt_flag == "Y"){
								alert( (j+1) + " 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요");
								return;
							}
						}
					}
					if(st_byit_bdgt_flag == "N"){
						document.forms.contentForm.st_budget_dept[j].value = "";
						document.forms.contentForm.st_account_type[j].value = "";
						st_budget_dept = "";
						st_account_type = "";
					}
					if(old_st_budget_flag != '' && old_st_budget_flag != st_byit_bdgt_flag){
						diff_budget_flag_status = "true";
					}
					var st_buyer = $('#st_buyer').val();
					if(st_buyer == 'KRCOWA0001' || st_buyer == 'KRCOWA0005' || st_buyer == 'KRCOWA0006'){
						if(next_status == 'CART' || next_status == 'ORDER'){
							if(diff_budget_flag_status == 'true'){
								alert("☞사전예산통제품목(MRO)은 일반품목과 함께 주문할 수 없습니다.");
								return;
							}
						}
					}
					
					old_st_budget_flag=st_byit_bdgt_flag;
					if((st_buyer=="KRCOWA0002"||st_buyer=="KRCOWA0007"||st_buyer=="KRCOWA0003"||st_buyer=="KRCOWA0008") && (next_status == "CART" || next_status == "ORDER")){
						st_smenge = document.contentForm.st_smenge[j].value;
						st_lmenge = document.contentForm.st_lmenge[j].value;
						st_ji_gubun = document.contentForm.st_ji_gubun.value;
						st_sin_gubun = document.contentForm.st_sin_gubun.value;
						for(var k = 1; k <= tot_cnt; k++){
							var box2 = eval("document.contentForm.lnCheck" + k-1);
							var tmp_zcode_count = "";
							if(box2.checked == true){
								tmp_zcode_count = document.contentForm.st_zcode_count[k-1].value;
								if(eval(st_zcode_count) == 0){
									if(eval(tmp_zcode_count) > 0){
										alert("품목관리 타입과 같이 주문할 수 없습니다.");
										return;
									}
								}
								if(eval(st_zcode_count) > 0){
									if(eval(tmp_zcode_count) == 0){
										alert("품목관리 타입과 같이 주문할 수 없습니다.");
										return;
									}
								}
							}
						}
						if(eval(st_zcode_count) > 0 && (st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " ")){
							alert( eval(j+1)+"번째 대상자를 선택하셔야 합니다.");
							return;
						}
						if( st_zcode == "null" || st_zcode == null || st_zcode == ""){
							alert(eval(j+1) + " 번째 대표코드 정보가 없습니다..");
							return;
						}
						if(eval(st_zcode_count) > 1 && st_zcode == ""){
							alert(eval(j+1) + " 번째 대표코드를 선택하셔야 합니다.");
							getZcodePop(j+1, st_item_no);
							return;
						}
						if( st_sum_budam_amt == "null" || st_sum_budam_amt == null || st_sum_budam_amt == ""){
							alert(eval(j+1) + " 번째 대표코드를 선택하셔야 합니다.");
							getZcodePop(j+1, st_item_no);
							return;
						}						
						if(eval(st_zcode_count) > 0){
							st_mg_note = st_zcode+"&"+st_bcode+"&"+st_ji_gubun+"&"+st_sin_gubun+"&"+st_sum_budam_amt+"&"+st_gongje+"&";
						}
						var st_comma_Smenge = st_smenge.replace(",","");
						if(eval(st_comma_Smenge) > eval(st_order_qty)){
							alert(eval(j+1) + " 번째 품목의 최소값 "+st_smenge+" 이상 주문하셔야 합니다.");
							return;
						}
						var st_comma_lmenge = st_lmenge.replace(",","");
						if(eval(st_comma_lmenge) < eval(st_order_qty)){
							alert(eval(j+1) + " 번째 품목의 최대값 "+st_lmenge+" 이하 주문하셔야 합니다.");
							return;
						}
						if(st_buyer=="KRCOWA0003"){
							st_drcp_gubun = document.contentForm.st_drcp_gubun.value;
							if(st_drcp_gubun=="Y"){
								var buy_price = "";
								var cart_qty = "";
								var sum_pric = "";
								if(cNum ==1  && !confirm("포인트 사용 하시겠습니까?")){
									document.contentForm.st_drcp_gubun.value = "N";
									return;
								} else {
// 								alert(document.searchForm.st_check_sum_price.value)
// 								alert(document.searchForm.pointValue.value)
									if(document.searchForm.pointValue.value == '0'){
										alert('잔여 포인트가 없습니다.');
										return;
									}
									document.locationForm.st_drcp_gubun.value = document.contentForm.st_drcp_gubun.value;
									buy_price = document.contentForm.st_order_price[j].value;
									cart_qty = document.contentForm.st_order_qty[j].value;
									sum_price = kepGetRound((cart_qty * kepRemoveComma(buy_price)),3);
									st_mg_code = sum_price;
									document.contentForm.st_mg_code[j].value = st_mg_code;
								}
							} else {
								st_mg_code = "";
								document.contentForm.st_mg_code[j].value = st_mg_code;
							}
						}
					}
	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+st_mg_code+ "@@"+st_mg_note+ "@@"+st_cart_seq;
					query += "|";
				}
			}
		}
		
		document.forms.processForm.next_status.value = next_status;
		document.forms.processForm.st_update.value = query;
		kepAjaxFormCall("/mpso/saveBuyerShoppingcartQtyCowayUpdate.do","processForm",next_status); 
	}
	
	function setMyCatalogReg(){	///////////////////////////// 나의상품등록 //////////////////////////////////
		var tot_cnt = $("#display_item_cnt").val();
		var chk_cnt = 0;
		var cnt	= 0;
		var query	= "";
		if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null || tot_cnt == "0"){
			alert(" 목록에 표시된 상품이 없습니다.	");
			return;
		}
		chk_cnt = getCheckedRowCount(tot_cnt);
		if(chk_cnt == "0"){
			alert(" 하나 이상의 상품이 선택되어야 합니다.	");
			return;
		} else {
			if(eval(tot_cnt) < 2){
				var box = eval("document.forms.contentForm.lnCheck0" );
				var order_qty = document.forms.contentForm.st_order_qty.value;
				var key_flag = document.forms.contentForm.st_key_flag.value;
				if(box.checked == true){
					if(!chkDecimal(order_qty,3)){
						alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.	");
						document.forms.contentForm.st_order_qty.focus();
						return;
					}
					if(key_flag == "Y"){
						alert( " 상품구분이 필요한 항목입니다. \n\n 상품 상세보기에서 나의상품등록을 하실 수 있습니다. ");
						box.checked = false;
						return;
					}
				}
			} else {
				for(var i = 0; i < tot_cnt; i++){
					var box = eval("document.forms.contentForm.lnCheck" + i);
					var order_qty = document.forms.contentForm.st_order_qty[i].value;
					if(box.checked == true){
						if(!chkDecimal(order_qty,3)){
							alert( (i+1)+" 번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.	");
							document.forms.contentForm.st_order_qty[i].focus();
							return;
						}
						if(key_flag == "Y"){
							alert( " 상품구분이 필요한 항목입니다. \n\n 상품 상세보기에서 나의상품등록을 하실 수 있습니다. ");
							box.checked = false;
							return;
						}
					}
				}
			}
		}
		ok = confirm(" 선택하신 상품을 나의 상품으로 등록하시겠습니까?	");
		if(!ok){
			return;
		} else {
			var move_flag = "N";
		}
		if(eval(tot_cnt) < 2){
			var box = eval("document.forms.contentForm.lnCheck0" );
			var st_item_no	= document.forms.contentForm.st_item_no.value;
			var st_order_qty = document.forms.contentForm.st_order_qty.value;
			var st_contract_no = document.forms.contentForm.st_contract_no.value;
			var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
			var st_agent_code = document.forms.contentForm.st_agent_code.value;
			var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
			if(box.checked == true){
				if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null){
					st_order_qty = "1";
				}
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "&&";
			}
		} else {
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.lnCheck" + k);
				var st_item_no	= document.forms.contentForm.st_item_no[k].value;
				var st_order_qty = document.forms.contentForm.st_order_qty[k].value;
				var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
				var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
				var st_agent_code = document.forms.contentForm.st_agent_code[k].value;
				var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[k].value;
				if(box.checked == true){
					if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null){
						st_order_qty = "1";
					}
					query += st_item_no + "@@" + st_order_qty + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code;
					query += "&&";
				}
			}
		}
		
		document.forms.processForm.st_use_flag.value = "R"; 
		document.forms.processForm.st_query2.value = query; 
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","RsaveProcess"); 
	}
	
	function setCartDelete(){
		var tot_cnt = $("#display_item_cnt").val();
		var chk_cnt = 0;
		var query	= "";
		if(eval(tot_cnt) == 0) {
			alert("조회한 데이타가 없습니다.");
			return;
		}
		chk_cnt = getCheckedRowCount(tot_cnt);
		if(chk_cnt == "0"){
			alert("하나 이상의 상품이 선택되어야 합니다.	");
			return;
		} else {
			ok = confirm(" 선택된 상품을 장바구니에서 삭제하시겠습니까??	");
			if(ok){
				if(eval(tot_cnt) < 2){
						var box = eval("document.forms.contentForm.lnCheck0" );
						var st_item_no	= document.forms.contentForm.st_item_no.value;
						var st_order_qty = document.forms.contentForm.st_order_qty.value;
						var st_contract_no = document.forms.contentForm.st_contract_no.value;
						var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
						var st_agent_code = document.forms.contentForm.st_agent_code.value;
						var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
						var st_cart_seq = document.contentForm.st_cart_seq.value;
						if(box.checked == true){
							query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq + "&&";
						}
				} else {
						for(var j = 0; j < tot_cnt; j++){
							var box = eval("document.forms.contentForm.lnCheck" + j);
							var st_item_no	= document.forms.contentForm.st_item_no[j].value;
							var st_order_qty = document.forms.contentForm.st_order_qty[j].value;
							var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
							var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
							var st_agent_code = document.forms.contentForm.st_agent_code[j].value;
							var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[j].value;
							var st_cart_seq = document.contentForm.st_cart_seq[j].value;
							if(box.checked == true){
								query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq;
								query += "&&";
							}
						}
				}
				document.forms.processForm.next_status.value = "DELETE";
				document.forms.processForm.st_update.value = query; 
				kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartClcsDelReg.do","processForm","DELETE"); 
			} else {
				return;
			}
		}
	}
	
	/**
	* 체크 된 수
	*/
	function getCheckedRowCount(tot_cnt) {
		tot_cnt = $("#display_item_cnt").val();///////////
		var chk_cnt = 0;
		if(eval(tot_cnt) < 2){
			var box = eval("document.forms.contentForm.lnCheck0");
			if(box.checked == true) chk_cnt++;
		} else {
			for(var j = 0; j < tot_cnt; j++){
				var box = eval("document.forms.contentForm.lnCheck" + j);
				if(box.checked == true){
					chk_cnt++;
				}
			}
		}
		return chk_cnt;
	}

	function item_check(next_status){
		var tot_cnt = $("#display_item_cnt").val();
		if(eval(tot_cnt) == 0) {
			alert("조회한 데이타가 없습니다.");
			return;
		}
		var chk_cnt = 0;
		chk_cnt = getCheckedRowCount(tot_cnt);
		if(chk_cnt == "0"){
			alert("하나 이상의 상품이 선택되어야 합니다.");
			return;
		}

		var st_item_no = "";
		var st_item_no_arr = "";
		var ckCnt = 0;
		if(eval(tot_cnt) < 2){
			var box = eval("document.forms.contentForm.lnCheck0" );
			if(box.checked == true){
				st_item_no	= document.forms.contentForm.st_item_no.value;
				st_item_no_arr +=	st_item_no + "@@";
			}
		} else {
			for(var j = 0; j < tot_cnt; j++){
				var box = eval("document.forms.contentForm.lnCheck" + j);
				if(box.checked == true){
					ckCnt++;
					st_item_no = document.forms.contentForm.st_item_no[j].value;
					if(ckCnt==1){
						st_item_no_arr += st_item_no + "@@";
					} else {
						st_item_no_arr += st_item_no + "@@";
					}
				}
			}
		}
		document.forms.processForm.st_item_chk.value = st_item_no_arr;
		document.forms.processForm.next_status.value = next_status;
		kepAjaxFormCall("/mpso/getBuyerShoppingcartSangjoitemSearch.do","processForm",next_status); 
	}

	function set_item_check(sangjo_cnt){
		var tot_cnt = $("#display_item_cnt").val();
		if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
			alert(" 목록에 표시된 상품이 없습니다.	");
			return;
		}
		var chk_cnt = 0;
		chk_cnt = getCheckedRowCount(tot_cnt);
		var next_status = document.forms.processForm.next_status.value;
		document.forms.contentForm.sangjo_cnt.value = sangjo_cnt;
		if(eval(sangjo_cnt) > 1){
			alert("상조용품은 건별로 주문가능합니다.");
			return;
		} else if(eval(sangjo_cnt)== 1 && chk_cnt > 1){
			alert("상조용품은 다른 품목과 주문할 수 없습니다.");
			return;
		} else {
			item_qty_update(next_status);
		}
	}

	/**
	* 팝업호출
	*/
	function cartPrSheet(){
		var user_id = $('#st_user_id').val()
		var tot_cnt = $("#display_item_cnt").val();
		var st_buyer = $('#st_buyer').val();
		var chk_cnt = 0; 
		var query	= "";
		if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
			alert(" 목록에 표시된 상품이 없습니다.	");
			return;
		}
		chk_cnt = getCheckedRowCount(tot_cnt);
		if(chk_cnt == "0"){
			alert(" 하나 이상의 상품이 선택되어야 합니다.	");
			return;
		} else {
			if(eval(tot_cnt) < 2){
				var box = eval("document.forms.contentForm.lnCheck0");
				var st_item_no	= document.forms.contentForm.st_item_no.value;
				var st_contract_no = document.forms.contentForm.st_contract_no.value;
				var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
				var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
				if(box.checked == true){
					query = st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "^Y^" + "@@";
				}
			} else {
				for(var k = 0; k < tot_cnt; k++){
					var box = eval("document.forms.contentForm.lnCheck" + k);
					var st_item_no	= document.forms.contentForm.st_item_no[k].value;
					var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
					var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
					var st_cart_seq = document.forms.contentForm.st_cart_seq[k].value;
					if(box.checked == true){
						query += st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "^Y^" + "@@"; 
					}
				}
			}
		}//end else
		var reportId = $('#reportid').val();
		reportOpen(reportId,"["+query+"]["+st_buyer+"]["+user_id+"]");	
	}

	/**
	* ajax 공통 호출후 성공시 처리 함수
	*/ 
	function kepAjaxSuccess(pMethod , response){
		var sMsg = response.msg.MSG;
		var tot_cnt = $("#display_item_cnt").val();
		var query = "";
		var sangjo_cnt = document.forms.contentForm.sangjo_cnt.value;
		var url = "";
		if(pMethod == "WEBSERVICE"){
			$('#cowayPoint').html(response.page);
			$('#pointValue').val(response.pointValue);
		}
		if(sMsg == "CREATE_OK"){ // asis = setCartResult_Refresh
			if(pMethod == "RsaveProcess") {// 나의상품 등록
				alert("나의상품으로 등록 되었습니다.	");
				// 처리후 재조회
				kepSearch($("#curPage").val());
			}
		} else if (sMsg == "UPDATE_OK") { // asis setQtyUpdateResults -- 저장,바로주문
			if(pMethod == "CART"){
				var st_order_remark = "";
				if(eval(tot_cnt) < 2){
					var box = eval("document.forms.contentForm.lnCheck0");
					var st_item_no	= document.forms.contentForm.st_item_no.value;
					var st_contract_no = document.forms.contentForm.st_contract_no.value;
					var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
					var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
					var st_gongje = document.forms.contentForm.st_gongje.value;
					var req_user_name = document.forms.contentForm.req_user_name.value;
					var list_user_name = "";
					if(box.checked == true){
						query += st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "@@";
						st_order_remark =st_gongje;
						list_user_name = req_user_name;
					}
				} else {
					var list_user_name = "";
					for(var j = 0; j < tot_cnt; j++){
						var box = eval("document.forms.contentForm.lnCheck" + j);
						var st_item_no = document.forms.contentForm.st_item_no[j].value;
						var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
						var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
						var st_cart_seq = document.forms.contentForm.st_cart_seq[j].value;
						var st_zcode_nm = document.forms.contentForm.st_zcode_nm[j].value;
						var st_gongje = document.forms.contentForm.st_gongje[j].value;
						var req_user_name = document.forms.contentForm.req_user_name[j].value;
						if(box.checked == true){ 
							query += st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "@@";
							st_order_remark = st_gongje;
							if(list_user_name.indexOf(req_user_name,0) < 0){
								list_user_name += req_user_name+" ";
							}
						}
					}//END FOR
				}//END IF
				list_user_name = list_user_name.substring(0,17);
				//카테고리별결재담당자 품목도 상조화면으로 이동
				var cate_appr_cnt = 0;
				var st_cate_appr = 0;
				if(eval(tot_cnt) < 2){
					var box = eval("document.forms.contentForm.lnCheck0");
					if(box.checked == true){
						st_cate_appr = document.forms.contentForm.st_cate_appr.value;
						if(st_cate_appr > 0){
							cate_appr_cnt++;
						}
					}
				} else {
					for(var j = 0; j < tot_cnt; j++){
						var box = eval("document.forms.contentForm.lnCheck" + j);
						if(box.checked == true){
							st_cate_appr = document.forms.contentForm.st_cate_appr[j].value;
							if(st_cate_appr > 0){
								cate_appr_cnt++;
							}
						}
					}
				}

				var hSslurl2 = $('#hSslurl2').val();
				if((sangjo_cnt != 0) || (cate_appr_cnt > 0)){
					var recv_date = document.forms.searchForm.st_recv_date.value;
					var zip_code	= document.forms.searchForm.st_zip_code.value;
					var tel_no	= document.forms.searchForm.st_tel_no.value;
					var fax_no	= document.forms.searchForm.st_fax_no.value;
					var mobile	= document.forms.searchForm.st_mobile_no.value;
					document.forms.locationForm.st_query_cart.value = query;
					document.forms.locationForm.st_zip_code.value = zip_code;
					document.forms.locationForm.st_tel_no.value = tel_no;
					document.forms.locationForm.st_fax_no.value = fax_no;
					document.forms.locationForm.st_mobile_no.value = mobile;
					document.forms.locationForm.st_recv_date.value = recv_date;
					document.forms.locationForm.st_mg_code.value = document.forms.contentForm.st_mg_code.value;
					//alert("코웨이 상조 주문 으로 이동 PG_06_B_010_06");
					url = hSslurl2+"/mpso/getBuyerMpSoOrderInfoSangjoList.do";

				} else {
					document.forms.locationForm.st_query_cart.value = query; 
					document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;
					//특이사항표시.
					var st_gone_nm = "";
					if(st_order_remark=="1"){
						st_gone_nm= "수수료공제";
					}else if(st_order_remark=="2"){
						st_gone_nm= "운영비공제";
					}else if(st_order_remark=="3"){
						st_gone_nm= "급여공제";
					}
					
					document.forms.locationForm.st_order_remark.value =  st_gone_nm;
					document.forms.locationForm.st_gongje_mark.value =  st_order_remark;
					document.forms.locationForm.st_list_user_name.value =  list_user_name;
					// "일반 코웨이 배송 으로 이동 PG_06_B_010_04"
					url = hSslurl2+"/mpso/getBuyerMpSoDlvryInfoCowayList.do";

				}

				$('#locationForm').attr("action", url).submit();

			} else if(pMethod == "ORDER"){
				var st_order_remark = "";
				if(eval(tot_cnt) < 2){
					var box = eval("document.forms.contentForm.lnCheck0");
					var st_item_no	= document.forms.contentForm.st_item_no.value;
					var st_contract_no = document.forms.contentForm.st_contract_no.value;
					var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
					var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
					var st_zcode_nm = document.forms.contentForm.st_zcode_nm.value;
					var st_gongje = document.contentForm.st_gongje.value;
					var req_user_name = document.forms.contentForm.req_user_name.value;
					var list_user_name = "";
					if(box.checked == true){
						query += st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "@@";
						st_order_remark = st_gongje;
						list_user_name = req_user_name;
					}

				} else {
					var list_user_name = "";
					for(var j = 0; j < tot_cnt; j++){
						var box = eval("document.forms.contentForm.lnCheck" + j);
						var st_item_no	= document.forms.contentForm.st_item_no[j].value;
						var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
						var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
						var st_cart_seq = document.forms.contentForm.st_cart_seq[j].value;
						var st_zcode_nm = document.forms.contentForm.st_zcode_nm[j].value;
						var st_gongje = document.contentForm.st_gongje[j].value;
						var req_user_name = document.forms.contentForm.req_user_name[j].value;
						if(box.checked == true){
							query += st_item_no + st_contract_no + st_contract_seq + st_cart_seq + "@@";
							st_order_remark = st_gongje;
							if(list_user_name.indexOf(req_user_name,0) < 0){
								list_user_name += req_user_name+" ";
							}
						}
					}
				}
				var recv_date = document.forms.searchForm.st_recv_date.value;
				var zip_code = document.forms.searchForm.st_zip_code.value;
				var tel_no	= document.forms.searchForm.st_tel_no.value;
				var fax_no	= document.forms.searchForm.st_fax_no.value;
				var mobile	= document.forms.searchForm.st_mobile_no.value;
				document.forms.locationForm.st_query_cart.value = query;
				document.forms.locationForm.st_zip_code.value = zip_code;
				document.forms.locationForm.st_tel_no.value	= tel_no;
				document.forms.locationForm.st_fax_no.value	= fax_no;
				document.forms.locationForm.st_mobile_no.value = mobile;
				document.forms.locationForm.st_recv_date.value = recv_date;
				document.forms.locationForm.st_mg_code.value = document.forms.contentForm.st_mg_code.value;
				document.forms.locationForm.st_query_cart.value = query; 
				document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value; 
				//카테고리별결재담당자 품목도 상조화면으로 이동
				var cate_appr_cnt = 0;
				var st_cate_appr = 0;
				if(eval(tot_cnt) < 2){
					var box = eval("document.forms.contentForm.lnCheck0");
					if(box.checked == true){
						st_cate_appr = document.forms.contentForm.st_cate_appr.value;
						if(st_cate_appr > 0){
							cate_appr_cnt++;
						}
					}
				} else {
					for(var j = 0; j < tot_cnt; j++){
						var box = eval("document.forms.contentForm.lnCheck" + j);
						if(box.checked == true){
							st_cate_appr = document.forms.contentForm.st_cate_appr[j].value;
							if(st_cate_appr > 0){
								cate_appr_cnt++;
							}
						}
					}
				}
				var hSslurl2 = $('#hSslurl2').val();
				if((sangjo_cnt != 0) || (cate_appr_cnt > 0)){
					//alert("코웨이 상조 주문 으로 이동 PG_06_B_010_06");
					url = hSslurl2+"/mpso/getBuyerMpSoOrderInfoSangjoList.do";
				} else {
					// /kr/coway_buyer/shopping_cart/buyer_delivery_list.jsp
					//특이사항표시.
					var st_gone_nm = "";
					if(st_order_remark=="1"){
						st_gone_nm= "수수료공제";
					}else if(st_order_remark=="2"){
						st_gone_nm= "운영비공제";
					}else if(st_order_remark=="3"){
						st_gone_nm= "급여공제";
					}
					list_user_name = list_user_name.substring(0,17);
					document.forms.locationForm.st_order_remark.value =  st_gone_nm;
					document.forms.locationForm.st_gongje_mark.value =  st_order_remark;
					document.forms.locationForm.st_list_user_name.value =  list_user_name;
					url = hSslurl2+"/mpso/getBuyerMpSoOrderInfoCowayList.do";
				}
				$('#locationForm').attr("action", url).submit();	
			
			} else if(pMethod == "PrSheet") {
				cartPrSheet();//***********************

			} else if(pMethod == "SAVE") {
				alert(" 정상적으로 저장되었습니다.");
				kepSearch($("#curPage").val()); 
			
			} else if(pMethod == "DELETE") { // asis setResulte -- 삭제
				alert(" 정상적으로 삭제되었습니다.	");
				var chk_cnt = getCheckedRowCount(tot_cnt);
				if( tot_cnt == chk_cnt ) allDelFlag = "Y";
				kepSearch($("#curPage").val()); 
			} 
		} else {
			if(pMethod == "CART" || pMethod == "ORDER") {
				set_item_check(sMsg);

			} else if(pMethod == "RsaveProcess") {
				alert("품목코드 (" + sMsg + ") 은 이미 나의 상품으로 저장된 항목입니다. ");
				kepSearch($("#curPage").val());
			}
		}
	}

	/**
	* ajax 공통 호출후 에러시 처리 함수
	*/
	function kepAjaxError(pMethod , response) {
		if (pMethod == "RsaveProcess"){ 
			alert("나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. "); 
		} else if (pMethod == "DELETE"){ 
			alert("삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. "); 
		} else{
			alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다. "); 
		}
	} 

	function number_filter(str_value) {
		return str_value.replace(/[^0-9]/gi, ""); 
	}
	
	//대상자선택
	function getReqUserSelect(popRow){
		document.searchForm.st_pop_rownum.value = popRow;
		var st_buyer = $('#st_buyer').val();
		/* ODS변경관리 */
		var tot_cnt = $("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
			var box = eval("document.contentForm.lnCheck" + 0);
			//box.checked =true;
		}else{
			var cnt2 = eval(popRow)+eval(-1);
			var box = eval("document.contentForm.lnCheck" + cnt2);
			//box.checked = true;
			
		}
		getUserSelect(st_buyer);
	}
	
	//대상자셋팅
	function setUserSelect(user_id, user_name, phone_number, email, dept, dept_name, address_loc, fax_number, legacy_user_id, mobile_phone){
		var tot_cnt =$("#display_item_cnt").val();
		var st_pop_rownum = document.searchForm.st_pop_rownum.value;
		if(eval(tot_cnt) < 2) {
			document.contentForm.st_ref_pr_no.value = user_id;
			document.contentForm.st_user_name.value = user_name;
			document.contentForm.st_dept_code.value = dept;
		}else{
			var box = eval("document.contentForm.lnCheck" + k);
			if(box.checked == true){
				document.contentForm.st_ref_pr_no[k-1].value = user_id;
				document.contentForm.st_user_name[k-1].value = user_name;
				document.contentForm.st_dept_code[k-1].value = dept;
			}
		}
	}
	
	//콜백함수(파일명은 모두 동일)
	function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
		var tot_cnt =$("#display_item_cnt").val();
		var st_pop_rownum = document.searchForm.st_pop_rownum.value;

		if (popupSel == "USER") {	// 사용자
			if(eval(tot_cnt) < 2) {
				var box = eval("document.contentForm.lnCheck0");
				box.checked = true;
				document.contentForm.st_ref_pr_no.value = value1;
				document.contentForm.req_user_name.value = value2;
			}else{
				var chk_row = st_pop_rownum-1;
				var box = eval("document.contentForm.lnCheck"+chk_row);
				box.checked = true;
				document.contentForm.st_ref_pr_no[st_pop_rownum-1].value = value1;
				document.contentForm.req_user_name[st_pop_rownum-1].value = value2;

			}
		}else if(popupSel =="ALLUSER"){
			if(eval(tot_cnt) < 2) {
				var box = eval("document.contentForm.lnCheck0");
				box.checked = true
				document.contentForm.st_ref_pr_no.value = value1;
				document.contentForm.req_user_name.value = value2;
			}else{
				for(var k = 0; k < tot_cnt; k++){
					var box = eval("document.contentForm.lnCheck" + k);
					document.contentForm.st_ref_pr_no[k].value = value1;
					document.contentForm.req_user_name[k].value = value2;
					box.checked = true
				}
			}
			chk_sum_price();
		}else if(popupSel == "attach"){
			//$("input[name=st_image_key]").eq(gridIndex).val(value1);
			if(eval(tot_cnt) < 2){    	
		    	document.forms.contentForm.st_image_key.value = value1;
		    }else{
		    	document.forms.contentForm.st_image_key[gridIndex].value = value1;
		    }
			saveAttach(gridIndex);
		}
	} 

	// 사용자선택
	function getUserSelect(buyer){
		popupSel = "USER";
		var dept_code = "";
		openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+buyer +'&dept_code='+dept_code, "650,500,no");
	}
	
	function getZcodePop(popRow, item_no){
		var left = 0;
		var top = 0;
		var width = 600;
		var height = 200;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';
		var zcode = "";
		var bcode = "";
		var tot_cnt =$("#display_item_cnt").val();
		var ji_gubun  = document.contentForm.st_ji_gubun.value;
		var sin_gubun  = document.contentForm.st_sin_gubun.value;
		var getCodeC007 = <%=getCodeC007%>;
		var userId = "<%=userID%>";
		var zcode_yn = "";
		document.searchForm.st_pop_rownum.value = popRow;
		if(eval(tot_cnt) < 2){
		  zcode = document.contentForm.st_zcode.value;
		  bcode = document.contentForm.st_bcode.value;
		}else{
		  zcode = document.contentForm.st_zcode[popRow-1].value;
		  bcode = document.contentForm.st_bcode[popRow-1].value;
		}
		
		if(getCodeC007 == true){
			zcode_yn ="Y";
		}else{
			zcode_yn ="";
		}
		var buyer = $('#st_buyer').val();
		window.open('/common/getZcodeList.do?st_buyer='+buyer+'&st_item_no='+item_no+'&st_zcode='+zcode+'&st_bcode='+bcode+'&st_ji_gubun='+ji_gubun+'&st_sin_gubun='+sin_gubun+'&zcode_yn='+zcode_yn+'&userId='+userId, 'getZcodePop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function setZcodePop(zbcode){
		var st_pop_rownum  = document.searchForm.st_pop_rownum.value;
		var tot_cnt =$("#display_item_cnt").val();
		var zbcode_arr = zbcode.split("&");
		var zcode = zbcode_arr[0];
		var bcode = zbcode_arr[1];
		var zcode_nm = zbcode_arr[3];
		var coway_budam_price = zbcode_arr[2];
		var gongje = zbcode_arr[4];
		var lmenge = zbcode_arr[5];
		var smenge = zbcode_arr[6];
		var cart_qty = 0;
		var buy_price = 0;
		var rowNum = 0;
		if(eval(tot_cnt) < 2){
			document.contentForm.st_zcode.value = zcode;
			document.contentForm.st_bcode.value = bcode;
			document.contentForm.st_sum_budam_price.value = coway_budam_price;
			document.contentForm.st_zcode_nm.value = zcode_nm;
			document.contentForm.st_gongje.value = gongje;
			document.contentForm.st_smenge.value = smenge;
			document.contentForm.st_lmenge.value = lmenge;
			cart_qty = document.contentForm.st_order_qty.value;
			buy_price = document.contentForm.st_order_price.value;
		}else{
			document.contentForm.st_zcode[st_pop_rownum-1].value = zcode;
			document.contentForm.st_bcode[st_pop_rownum-1].value = bcode;
			document.contentForm.st_sum_budam_price[st_pop_rownum-1].value = coway_budam_price;
			document.contentForm.st_zcode_nm[st_pop_rownum-1].value = zcode_nm;
			document.contentForm.st_gongje[st_pop_rownum-1].value = gongje;
			document.contentForm.st_smenge[st_pop_rownum-1].value = smenge;
			document.contentForm.st_lmenge[st_pop_rownum-1].value = lmenge;
			cart_qty = document.contentForm.st_order_qty[st_pop_rownum-1].value;
			buy_price = document.contentForm.st_order_price[st_pop_rownum-1].value;
		}
		rowNum = eval(st_pop_rownum);
		price_update(cart_qty, rowNum, kepRemoveComma(buy_price), cart_qty);
	}
	function getCowayPoint(){
		kepAjaxFormCall("/webservice/getCowayWebService.do","webserviceForm","WEBSERVICE");
// 		alert($('#rntMessage').val())
	}
	//대상자전체선택
	function getReqUserSelectAll(){
		popupSel = "ALLUSER";
		var buyer = document.searchForm.st_buyer.value;
		var dept_code = "";
		openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+buyer +'&dept_code='+dept_code, "650,500,no");
	}

</script>
			
<c:set var="sessionInfo" value="${sessionInfo }"/>
<c:set var="st_buyer" value="${sessionInfo.comCode }"/>
<c:set var="st_user_type" value="${sessionInfo.userType }"/>
<c:set var="buyer" value="${sessionInfo.comCode }"/>
<c:set var="userRole" value='${sessionInfo.role }'/>
<c:set var="userRole1" value=''/>
<c:set var="userRole2" value='${userRole2 }'/>
<c:if test="${userRole != null }">
	<c:if test="${fn:length(userRole) == 2 }">
		<c:set var="userRole1" value='${fn:substring(userRole, 0, 1) }'/>
		<c:set var="userRole2" value='${fn:substring(userRole, 1, 2) }'/>
	</c:if>
</c:if>
<c:if test='${st_query_cart == null}'>
	<c:set var="st_query_cart" value="ALL"/>
</c:if>
<c:set var="budget_flag" value='${sessionInfo.budgetFlag }'/>
<c:set var="st_image_status" value='${st_image_status }'/>
<c:set var="realImgUploadPath" value='<%=CommonUtil.realImgS3UploadPath %>'/>
<c:set var="getUrl" value='<%=CommonUtil.getURL(request) %>'/>
<c:set var="hSslurl" value='<%=CommonUtil.getSslURL(request, "http") %>'/>
<c:set var="hSslurl2" value='<%=CommonUtil.getSslURL(request, "https") %>'/>
<c:set var="p060000034" value='<%=CommonUtil.getSpecialCheckReturn((String)pageContext.getAttribute("buyer"), "P06-0000034") %>'/>
<c:set var="p060000035" value='<%=CommonUtil.getSpecialCheckReturnMap((String)pageContext.getAttribute("buyer"),"P06-0000035") %>'/>
<c:set var="reportText" value="품의서출력"/>
<c:set var="reportid" value="RD_06_B_001_17"/>
<c:set var="reportFunction" value="doAction('PrSheet')"/>
<c:if test="${p060000035 != null }">
	<c:set var="reportText" value='${p060000035.COL01_DATA}'/>
	<c:set var="reportid" value='${p060000035.COL02_DATA}'/>
	<c:set var="reportFunction" value='${p060000035.COL04_DATA}'/>
</c:if>
<c:set var="total_cnt" value="0" />
<c:forEach items="${data }" var="_gridList" begin="0" end="1">
	<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
</c:forEach>
<c:if test="${st_check == null }">
	<c:set var='st_check' value='SEARCH'/>
</c:if>
<c:if test="${onepagerow == null }">
	<c:set var="onepagerow" value="10"/>
</c:if>
<c:if test="${st_sort_gubun == null }">
	<c:set var="st_sort_gubun" value="c_date"/>
</c:if>
<c:set var="stJiGubunDisabled" value=""/>
<c:if test='${st_buyer == "KRCOWA0003" || st_buyer == "KRCOWA0008" }'>
	<c:set var="stJiGubunDisabled" value="disabled"/>
</c:if>
<c:set var="stdrcpGubunDisabled" value=""/>
<c:if test='${st_buyer == "KRCOWA0008" }'>
	<c:set var="stdrcpGubunDisabled" value="disabled"/>
</c:if>
<c:set var="stSinGubunDisabled" value=""/>
<c:if test='${st_buyer == "KRCOWA0002" || st_buyer == "KRCOWA0007"  || st_buyer == "KRCOWA0008"}'>
		<c:set var="stSinGubunDisabled" value="disabled"/>
</c:if>
<c:if test='${st_buyer == "KRCOWA0003"&&st_user_type == "U" }'>
	<c:set var="stSinGubunDisabled" value="disabled"/>
</c:if>
<jsp:useBean id="toDay" class="java.util.Date" />
<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" var="to_day"/>
<c:set var='select_year' value='${fn:substring(to_day, 0, 4)}' />
<div id="container2">
<div id="ContArea">
	<h3>관리품목 장바구니</h3>
	<form name = "searchForm" id="searchForm" method = "post">
		<input type="hidden" id="realImgUploadPath" name="realImgUploadPath" value='${realImgUploadPath }'>
		<input type="hidden" id="getUrl" name="getUrl" value='${getUrl }'>
		<input type="hidden" id="hSslurl" name="hSslurl" value='${hSslurl }'>
		<input type="hidden" id="hSslurl2" name="hSslurl2" value='${hSslurl2 }'>
		<input type="hidden" id="userRole1" name="userRole1" value='${userRole1 }'>
		<input type="hidden" id="userRole2" name="userRole2" value='${userRole2 }'>
		<input type="hidden" id="reportid" name="reportid" value='${reportid }'>
		<input type="hidden" id="budgetFlag" name="budgetFlag" value='${budget_flag }'>
		<input type="hidden" id="selectYear" name="selectYear" value='${select_year }'>
		<input type="hidden" id="upperId" name="upperId" value='<c:out value="${param.upperId}"/>'>
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_department" id="st_department" value="${sessionInfo.department}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_verif_num" id="st_verif_num" value="${st_verif_num }" /> 
		<input type="hidden" name="st_sort_change" id="st_sort_change" value="${st_sort_change }"> 
 		<input type="hidden" name="st_image_status" id="st_image_status" value="${st_image_status }">
 		<input type="hidden" name="st_check" id="st_check" value="${st_check }">
 		<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department }">
		<input type="hidden" name="st_item_no_in" id="st_item_no_in" value="">
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		
		<input type="hidden" name="st_zip_code" value="${st_zip_code }">
		<input type="hidden" name="st_tel_no" value="${st_tel_no }">
		<input type="hidden" name="st_fax_no" value="${st_fax_no }">
		<input type="hidden" name="st_mobile_no" value="${st_mobile_no }">
		<input type="hidden" name="st_user_name" value="${st_user_name }">
		<input type="hidden" name="st_email" value="${st_email }">
		<input type="hidden" name="st_user_id" value="${st_user_id }">
		<input type="hidden" name="st_query_cart" value="${st_query_cart }">
		<input type="hidden" name="st_recv_date" value="${st_recv_date }">
		<input type="hidden" name="st_recv_date2" value="${st_recv_date2 }">
		<input type="hidden" name="st_remark" value="${st_remark }">
		<input type="hidden" name="st_location_code" value="${st_location_code }">
		<input type="hidden" name="st_location_type" value="${st_location_type }">
		<input type="hidden" name="st_location_name" value="${st_location_name }">
		<input type="hidden" name="st_purchase_dept_name" value="${st_purchase_dept_name }">
		<input type="hidden" name="st_purchase_dept_code" value="${st_purchase_dept_code }">
		
		<input type="hidden" name="st_ji_gubun" id="st_ji_gubun" value="">
		<input type="hidden" name="st_sin_gubun" id="st_sin_gubun" value="">
		<c:if test='${st_verif_num == null}'>
			<c:set var="st_verif_num" value="ALL"/>
		</c:if>
		<input type="hidden" name="st_verif_num" value="${st_verif_num }">
		<input type="hidden" name="file_get_y" value="">
		<input type="hidden" name="st_item_chk" value="">
		<input type="hidden" name="sangjo_cnt" value="">
		<input type="hidden" name="st_pop_rownum" value="">
		
 		<div>
			<div id="cont_searchA" >
				<table class="cont_t_list01" >
					<tr>
						<td>
							<div style="height:20px; margin-bottom:6px; " >
								<p class="cart"><img src="/resources/images/b_img_carting01.gif" alt="장바구니단계" /></p>
								<span class="sTitle">내가 담은 품목명은 총 
									<span class="text03"> ${total_cnt }</span>
									건입니다. 품목명을 확인하시고 주문해 주세요.
								</span>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="fl">
				<span class="fl">
					<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
					<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" onchange="javascript:kepSearch(1);">  
						<option <%=("10".equals(onepagerow) ? "selected" : "")%> value = "10">10건</option>
						<option <%=("15".equals(onepagerow) ? "selected" : "")%> value = "15">15건</option>
						<option <%=("20".equals(onepagerow) ? "selected" : "")%> value = "20">20건</option>
						<option <%=("25".equals(onepagerow) ? "selected" : "")%> value = "25">25건</option>
						<option <%=("50".equals(onepagerow)  ? "selected" : "")%> value = "50">50건</option>
						<option <%=("100".equals(onepagerow) ? "selected" : "")%> value = "100">100건</option>
						<option <%=("200".equals(onepagerow) ? "selected" : "")%> value = "200">200건</option>
						<option <%=("500".equals(onepagerow) ? "selected" : "")%> value = "500">500건</option>
					</select>
					<select name="st_sort_gubun" id="st_sort_gubun" onchange="javascript:kepSearch(1);">
						<option value = "c_date" <c:if test='${st_sort_gubun == "c_date" }'><c:out value='selected'/></c:if>>등록일시&nbsp;</option>
						<option value = "c_item" <c:if test='${st_sort_gubun == "c_item" }'><c:out value='selected'/></c:if>>품목코드&nbsp;</option>
						<option value = "c_prno" <c:if test='${st_sort_gubun == "c_prno" }'><c:out value='selected'/></c:if>>관리번호&nbsp;</option>
					</select>
					&nbsp;&nbsp;
				</span>
				<span class="btn_imghide">
					<c:if test='${st_image_status == "IMAGE_HIDDEN" }'>
						<a href="javascript:imageHideView();" title="이미지보이기" >이미지보이기</a>
					</c:if>
					<c:if test='${st_image_status != "IMAGE_HIDDEN" }'>
						<a href="javascript:imageHideView();" title="이미지감추기" >이미지감추기</a>
					</c:if>
				</span>
				<div class="fr">
				 &nbsp;* 운영비공제 :(운) / 수수료공제 : (수)
				</div>
				<!--
				<c:if test='${buyer == "KRCOWA0003" }'>
					<div class="fr" id="cowayPoint">
						<b>Point:조회중</b>
					</div>
				</c:if> 
				 -->
			</div>
			<div class="fr">
				<b>총 금액 :</b>
				<input type="text" name="check_sum_price" id="check_sum_price" class="input_type_text" value="0" style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" readOnly>&nbsp;
				<input type="hidden" name="st_check_sum_price" id="st_check_sum_price" value=""> 
				<input type="hidden" name="pointValue" id="pointValue" value=""> 
			</div>
		</div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="sangjo_cnt" id="sangjo_cnt" value="">
		<input type="hidden" name="st_key_flag"		value="">
		<input type="hidden" name="st_prev_url" id="st_prev_url" value="/mpso/getBuyerMpSoCartCowayClcsList.do" />
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="3%" />
				<col width="7%" /> 
				<col width="*" />
				<col width="13%" />
				<col width="10%" />
				<col width="10%" />
				<col width="8%" />
				<col width="8%" />
				<col width="8%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">
						<c:if test="${!(total_cnt == null || total_cnt == 0) }">
							<input type="checkbox" name="check_status" id="check_status" value="선택" style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');chk_sum_price();">
						</c:if>
					</th>
					<th scope="col">&nbsp;</th>
					<th scope="col">품목코드 / 품목명 / 규격</th>
					<th scope="col">협력사/단위</th>
					<c:if test='${budget_flag == "Y" }'>
						<th scope="col">예산부서/계정명</th>
					</c:if>
					<c:if test='${buyer == "KRCOWA0002" || buyer == "KRCOWA0007" || buyer == "KRCOWA0003" || buyer == "KRCOWA0008" }'>
						<th scope="col">대상자</th>
					</c:if>
					<th scope="col">단가/구매수량</th>
					<th scope="col">구매액/부담금</th> 
					<th scope="col">파일첨부/양식</th>
					<c:if test='${userRole2 == "+" }'>
						<th>선택</th>
					</c:if>	
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${total_cnt == null || total_cnt == 0 }">
						<tr>
							<td colspan="10" align="center" height = "50">
							<span>조회된 데이타가 없습니다.</span>
							</td> 
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach items="${data}" var="_gridList">
							<c:set var="tclass" value='${(_gridList.RN % 2 != 0)? "#FFFFFF" : "#FAFAFA" }' />
							<tr bgcolor="${tclass }">
								<td>
									<input type="checkbox" name="lnCheck${_gridList.RNO-1 }" onclick="chk_sum_price()">
								</td>
								<td>
									<c:if test='${st_image_status == "IMAGE_HIDDEN" }'>
										<c:if test='${_gridList.IMGFILE_DIR == "" }'>
											<img src="/resources/images/but_img_off.gif" border="0">
												<c:if test='${_gridList.OVER_SHORT_FLAG != "N" }'>
													<img src="/resources/images/outitem.gif">
												</c:if>
												<c:if test='${_gridList.PRODUCT_CLOSE_FLAG != "N" }'>
													<img src="/resources/images/outitem1.gif">
												</c:if>
										</c:if>
										<c:if test='${_gridList.IMGFILE_DIR != "" }'> 
											<a href="javascript:getBigImage('${_gridList.IMGFILE_DIR }','${_gridList.IMGFILE_NAME }');">
												<img src="/resources/images/but_img_on.gif" border="0">
											</a>
											<c:if test='${_gridList.OVER_SHORT_FLAG != "N" }'>
												<img src="/resources/images/outitem.gif">
											</c:if>
											<c:if test='${_gridList.PRODUCT_CLOSE_FLAG != "N" }'>
												<img src="/resources/images/outitem1.gif">
											</c:if> 
										</c:if>
									</c:if>
									<c:if test='${st_image_status != "IMAGE_HIDDEN" }'>
										<c:if test='${_gridList.IMGFILE_DIR == "" }'>
											<img src="/resources/images/noimage.gif" width="80" height="80" border="0">
											<c:if test='${_gridList.OVER_SHORT_FLAG != "N" }'>
												<img src="/resources/images/outitem.gif">
											</c:if>
											<c:if test='${_gridList.PRODUCT_CLOSE_FLAG != "N" }'>
												<img src="/resources/images/outitem1.gif">
											</c:if>
										</c:if>
										<c:if test='${_gridList.IMGFILE_DIR != "" }'>
											<a href="javascript:getBigImage('${_gridList.IMGFILE_DIR }' ,'${_gridList.IMGFILE_NAME }');">
												<img src='${realImgUploadPath }/${_gridList.IMGFILE_DIR }/${_gridList.IMGFILE_NAME }' onerror="javasrcipt:this.src='/resources/images/noimage.gif'" name="image1" width="80" height="80" border="0">
											</a>
											<c:if test='${_gridList.OVER_SHORT_FLAG != "N" }'>
												<img src="/resources/images/outitem.gif">
											</c:if>
											<c:if test='${_gridList.PRODUCT_CLOSE_FLAG != "N" }'>
												<img src="/resources/images/outitem1.gif">
											</c:if>
										</c:if>
									</c:if>
								</td>
								<td class="left">
									<input type="hidden" name="st_item_no" value="${_gridList.BUYER_ITEM_NO }" >
									<input type="hidden" name="st_contract_no" value="${_gridList.CONTRACT_NO }">
									<input type="hidden" name="st_contract_seq" value="${_gridList.CONTRACT_SEQ }">
									<input type="hidden" name="st_agent_code" value="${_gridList.AGENT_CODE }">
									<input type="hidden" name="st_byit_comorg_code"	value="${_gridList.BYIT_COMORG_CODE }">
									<input type="hidden" name="st_bdgt_flag" value="${_gridList.BDGT_FLAG }">
									<input type="hidden" name="st_product_close_flag" value="${_gridList.PRODUCT_CLOSE_FLAG }">
									<input type="hidden" name="st_process_type" value="${_gridList.PROCESS_TYPE }">
									<input type="hidden" name="st_stock_item_flag" value="${_gridList.STOCK_ITEM_FLAG }">
									<input type="hidden" name="st_ref_pr_dept" value="${_gridList.HI_DEPT_CODE }">
									<input type="hidden" name="st_image_key" value="${_gridList.IMAGE_KEY }">
									<input type="hidden" name="st_format_type" value="${_gridList.MG_CODE }">
									<input type="hidden" name="st_byit_bdgt_flag" value="${_gridList.MG_NOTE }">
									<input type="hidden" name="st_category_no" value="${_gridList.CATEGORY_NO }">
									<input type="hidden" name="st_cate_appr" value="${_gridList.CATE_APPR }">
									<input type="hidden" name="st_zcode_count" value="${_gridList.ZCODE_COUNT }" >
									<input type="hidden" name="st_cart_seq" value="${_gridList.CART_SEQ }" >
									<input type="hidden" name="st_mg_code" value="${_gridList.MG_CODE }" >
									<input type="hidden" name="st_gongje" value="${_gridList.GONGJE }" >
									<div title="품목코드">
										<a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('${_gridList.BYIT_COMORG_CODE }','${_gridList.BUYER_ITEM_NO }','${_gridList.CONTRACT_NO }','${_gridList.CONTRACT_SEQ }');">
											${_gridList.BUYER_ITEM_NO }
										</a>
										<span title="품목명">${_gridList.DESCRIPTION_LOC }</span>
									</div>
									<div title="규격">
										${_gridList.SPECIFICATION }
										<c:choose>
											<c:when test='${_gridList.PRODUCT_CLOSE_FLAG == "Y" || _gridList.OVER_SHORT_FLAG == "N"}'>
												&nbsp;
											</c:when>
											<c:otherwise>
												<br/>
												<font color="green">(재 판매일 :${cu:formatStrinigDate(_gridList.HS_NO) }</font>
											</c:otherwise>
										</c:choose>
									</div>
								</td>
								<td align="center">
									<div title="협력사">
										<a class="hyperLink" href="javascript:getAgentDisplayPop('${_gridList.AGENT3 }');">${_gridList.AGENT }</a>
									</div>
									<div title="단위">
										${_gridList.UNIT_MEASURE }
									</div>
								</td>
								<c:choose>
									<c:when test='${budget_flag == "Y" }'>
										<c:if test='${_gridList.ACCOUNT_NAME == "" }'>
											<c:if test='${_gridList.MG_NOTE == "N" }'>
												<td>
													<div title="예산부서"><input type="hidden" name="st_budget_dept_name" size="10" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly></div>
													<div title="계정명"><input type="hidden"	name="st_account_type_name" size="10" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly></div>
													<input type="hidden" name="st_account_type" value="">
													<input type="hidden" name="st_budget_dept" value="">
													<input type="hidden" name="st_budget_yn" value="N">
												</td>
											</c:if>
											<c:if test='${_gridList.MG_NOTE != "N" }'>
												<td>
													<c:if test='${_gridList.BUDGET_DEPT_CODE == "" }'>
														<div title="예산부서"><input type="text" name="st_budget_dept_name" size="10" value="선택" style="font-size: 9px; background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><a href="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif" align="top" /></a></div>
													</c:if>
													<c:if test='${_gridList.BUDGET_DEPT_CODE != "" }'>
														<div title="예산부서"><input type="text" name="st_budget_dept_name" size="10" value="${_gridList.BUDGET_DEPT_NAME }" style="font-size: 9px; background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><a href="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif" align="top" /></a></div>
													</c:if>
													<div title="계정명"><input type="text"	name="st_account_type_name"	size="10" value="선택" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getBdgtAccountPop('${st_buyer }','${sessionInfo.department }','${_gridList.RNO }');"><a href="javascript:getBdgtAccountPop('${st_buyer }','${sessionInfo.department }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif"	align="top" /></a></div>
													<input type="hidden" name="st_account_type" value="${_gridList.ACCOUNT_TYPE }">
													<input type="hidden" name="st_budget_dept" value="${_gridList.BUDGET_DEPT_CODE }">
													<input type="hidden" name="st_budget_yn" value="Y">
												</td>
											</c:if>
										</c:if>
										<c:if test='${_gridList.ACCOUNT_NAME != "" }'>
											<c:if test='${_gridList.MG_NOTE == "N" }'>
												<td>
													<div title="예산부서"><input type="hidden" name="st_budget_dept_name"	size="13" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly></div>
													<div title="계정명"><input type="hidden"	name="st_account_type_name" size="13" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly></div>
													<input type="hidden" name="st_account_type" value="">
													<input type="hidden" name="st_budget_dept" value="">
													<input type="hidden" name="st_budget_yn" value="N">
												</td>
											</c:if>
											<c:if test='${_gridList.MG_NOTE != "N" }'>
												<td>
													<c:if test='${_gridList.BUDGET_DEPT_CODE == "" }'>
														<div title="예산부서"><input type="text" name="st_budget_dept_name" size="13" value="선택" style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><a href="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif"	style="position:relative; top:50%; margin-top:-5px;" /></a></div>
													</c:if>
													<c:if test='${_gridList.BUDGET_DEPT_CODE != "" }'>
														<div title="예산부서"><input type="text" name="st_budget_dept_name" size="13" value="${_gridList.BUDGET_DEPT_NAME }" style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><a href="javascript:getDeptAccountPop('${st_buyer }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif"	style="position:relative; top:50%; margin-top:-5px;" /></a></div>
													</c:if>
													<div title="계정명"><input type="text"	name="st_account_type_name" size="13" value="${_gridList.ACCOUNT_NAME }" style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" readOnly onClick="javascript:getBdgtAccountPop('${st_buyer }','${sessionInfo.department }','${_gridList.RNO }');"><a href="javascript:getBdgtAccountPop('${st_buyer }','${sessionInfo.department }','${_gridList.RNO }');"><img src="/resources/images/btn_search03.gif"	align="top" /></a></div>
													<input type="hidden" name="st_account_type" value="${_gridList.ACCOUNT_TYPE }">
													<input type="hidden" name="st_budget_dept" value="${_gridList.BUDGET_DEPT_CODE }">
													<input type="hidden" name="st_budget_yn" value="Y">
												</td>
											</c:if>
										</c:if>
									</c:when>
									<c:when test='${buyer == "KRCOWA0002" || buyer == "KRCOWA0007" || buyer == "KRCOWA0003" || buyer == "KRCOWA0008"}'><!-- //CL/CS -->
<%-- 										<input type="hidden" name="st_account_type" value="${_gridList.ACCOUNT_TYPE }"> --%>
<!-- 										<input type="hidden" name="st_budget_dept" value=""> -->
<!-- 										<input type="hidden" name="st_budget_yn" value="N">  -->
										<td>
											<div title="대상자" class="TextNomal">
<%-- 												<input type="text" name="st_ref_pr_no" id="st_ref_pr_no" size="13" value="${_gridList.REF_PR_NO }" style="text-align:left" readOnly> --%>
                <%if(p060000058==true&&userType.equals("U")){
                %>
												<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" value="<%=userID%>">
												<input type='text' name='req_user_name' id='req_user_name' size="13" value="<%=userName%>" style="text-align:left" readOnly/>
												&nbsp;
                <%}else{ %>
												<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no">
												<input type='text' name='req_user_name' id='req_user_name' size="13" value="" style="text-align:left" readOnly/>
												&nbsp;
                <%} %>
  												<a href="javascript:getReqUserSelect('${_gridList.RNO }');">
													<img src="/resources/images/but_query.gif" width="19" height="19">
												</a>
											</div>
											<div title="대상자명" class="TextNomal">
												<input type="text" name="st_user_name" size="8" value="${st_user_name }" style="background-color :${tclass }; border:0;width:90%;text-align:left" readOnly>
												<input type="hidden" name="st_dept_code" value="">
												<input type="hidden" name="st_account_type" value="">
												<input type="hidden" name="st_budget_dept" value="">
												<input type="hidden" name="st_budget_yn" value="N">
												<input type="hidden" name="st_mg_note" value="${_gridList.MG_NOTE }" >
											</div>
										</td>
									</c:when>
									
									<c:otherwise>
										<input type="hidden" name="st_account_type" value="${_gridList.ACCOUNT_TYPE }">
										<input type="hidden" name="st_budget_dept" value="">
										<input type="hidden" name="st_budget_yn" value="N"> 
									</c:otherwise>
								</c:choose>
								<td align="right" >
									<c:if test='${_gridList.FIXED_PRICE_FLAG == "N" }'>
										<div title="단가">
											<input type="text" name="st_order_price" class="input_type_text" size="10" value='<fmt:formatNumber value="${_gridList.TARGET_PRICE }" pattern="###,###,###.#"/>' onChange="javascript:price_update_P('${_gridList.RNO }',this.value,'${_gridList.CART_QTY }');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('${_gridList.RNO }',this.value,'${_gridList.CART_QTY }');">
										</div>
									</c:if>
									<c:if test='${_gridList.FIXED_PRICE_FLAG != "N" }'>
										<div title="단가">
											<fmt:formatNumber value="${_gridList.TARGET_PRICE }" pattern="###,###,###.#"/>
											<input type="hidden" name="st_order_price" value='<fmt:formatNumber value="${_gridList.TARGET_PRICE }" pattern="###,###,###.#"/>'>
										</div>
									</c:if>
									<input type="hidden" name="st_fixed_price_flag" value="${_gridList.FIXED_PRICE_FLAG }">
									<div title="구매수량">
										<input type="text" name="st_order_qty" style="text-align:right;" class="input_type_text" id="line" size="7" value="${_gridList.CART_QTY }"  onChange="javascript:price_update(this.value,'${_gridList.RNO }','${_gridList.TARGET_PRICE }','${_gridList.CART_QTY }');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'${_gridList.RNO }','${_gridList.TARGET_PRICE }','${_gridList.CART_QTY }');" >
									</div> 
									<c:if test='${buyer == "KRCOWA0002" || buyer == "KRCOWA0007" || buyer == "KRCOWA0003" || buyer == "KRCOWA0008"}'>
										<div title="최소수량/최대수량" class="TextNomal">
										<input type="text" name="st_smenge" size="3" style="text-align:right;border:0"  value='<fmt:formatNumber value="${_gridList.SMENGE }" pattern="###,###,###.#"/>'   readOnly >
										~<input type="text" name="st_lmenge" size="6" style="text-align:center;border:0" value='<fmt:formatNumber value="${_gridList.LMENGE }" pattern="###,###,###.#"/>'  readOnly >
										</div> 
									</c:if>
								</td>
								<td align="right">
									<div title="구매액/부담금">
										<input type="text" name="st_sum_price" size="10" style="text-align:right;" value='<fmt:formatNumber value="${_gridList.TOT_SUM }" pattern="###,###,###.#"/>' class="input_type_text" readOnly >
									</div>
									<div title="부담금" class="PriceALL">
									<c:choose>
										<c:when test='${_gridList.ZCODE_COUNT != "0" }'><!-- 	//CL/CS대표코드COUNT가 있으면 대표코드 선택 -->
											<c:choose>
												<c:when test='${_gridList.ZCODE_COUNT == "1" }'>
													<input type="text" name="st_sum_budam_amt" size="10" style="text-align:right;" value="<fmt:formatNumber value="${_gridList.COWAY_BUDAM_AMT }" pattern="###,###,###.#"/>" class="input_type_text" readOnly>
												</c:when>
												<c:otherwise>
													<input type="text" name="st_sum_budam_amt" size="10" style="text-align:right;" value="" pattern="###,###,###.#" class="input_type_text" readOnly>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<input type="text" name="st_sum_budam_amt" size="10" style="text-align:right;" value="" pattern="###,###,###.#" class="input_type_text" readOnly>
										</c:otherwise>
									</c:choose>
										
									</div>
									<input type="hidden" name="st_sum_budam_price" value="${_gridList.COWAY_BUDAM_PRICE }">
								</td>
								<td align="center">
									<c:choose>
										<c:when test='${_gridList.ZCODE_COUNT != "0" }'><!-- 	//CL/CS대표코드COUNT가 있으면 대표코드 선택 -->
											<c:choose>
												<c:when test='${_gridList.ZCODE_COUNT == "1" }'>
													&nbsp;
												</c:when>
												<c:otherwise>
													<a href="#" onClick="javascript:getZcodePop('${_gridList.RNO }', '${_gridList.BUYER_ITEM_NO }');" >
														<b><font color="red">선택</font></b>
													</a>
												</c:otherwise>
											</c:choose>
											<div title="대표코드" class="TextNomal">
												<a href="#" onClick="javascript:getZcodePop('${_gridList.RNO }', '${_gridList.BUYER_ITEM_NO }');" class="hyperLink">
													<input type="text" name="st_zcode_nm" value="${_gridList.ZCODE_NM }" style="background-color :${tclass }; border:0;text-align:left;font-size=7pt" readOnly>
												</a>
											</div>
											<input type="hidden" name="st_zcode" value="${_gridList.ZCODE }">
											<input type="hidden" name="st_bcode" value="${_gridList.BCODE }" >
										</c:when>
										<c:otherwise>
											<input type="hidden" name="st_zcode_nm" value="" >
											<input type="hidden" name="st_bcode" value="" >
											<input type="hidden" name="st_zcode" value="" >
										</c:otherwise>
									</c:choose>
									<div title="첨부파일">
										<c:if test='${_gridList.IMAGE_KEY != "" }'>
											<span class="btn_quickbuy mb02" title="파일추가"><a href="javascript:attach_popup('${_gridList.IMAGE_KEY }', '${_gridList.RNO }');">파일추가</a></span>
										</c:if>
										<c:if test='${_gridList.IMAGE_KEY == "" }'>
											<span class="btn_wishproduct mb02" title="파일추가"><a href="javascript:gridPopOpen('${_gridList.RNO }');"> 파일추가</a></span>
										</c:if>
									</div> 
									<c:choose>
										<c:when test='${_gridList.MG_CODE == "A" }'>//명함 양식다운로드
											<div title="명함양식">
												<span class="btn_quickbuy mb02" title="명함양식"><a href="/resources/excel/coway_exceldown01.xls">명함양식</a></span>
											</div>
										</c:when>
										<c:when test='${_gridList.MG_CODE == "B" }'>//사원증 다운로드
											<div title="사원증양식">
												<span class="btn_quickbuy mb02" title="사원증양식"><a href="/resources/excel/coway_exceldown02.xls">사원증양식</a></span>
											</div>
										</c:when>
										<c:when test='${_gridList.MG_CODE == "C" }'>//사원증 다운로드(코디/닥터)
											<div title="사원증양식(코디/코닥)">
												<span class="btn_quickbuy mb02" title="사원증양식(코디/코닥)"><a href="/resources/excel/coway_exceldown03.xls">코디/코닥</a></span>
											</div>
										</c:when>
										<c:when test='${_gridList.MG_CODE == "D" }'>//양식다운(기타양식다운로드)
			<!-- 								<div title="첨부파일"> -->
			<!-- 									<a href="/kr/coway_buyer/guide_down/coway_exceldown04.xls"><img src="/kr/coway_buyer/images_new/but_coway_down.gif" alt="양식다운로드"></a> -->
			<!-- 								</div> -->
										</c:when>
										<c:when test='${_gridList.MG_CODE == "E" }'>//명함 양식다운로드(닥터)
											<div title="닥터명함양식">
												<span class="btn_quickbuy mb02" title="닥터명함양식"><a href="/kr/coway_buyer/guide_down/coway_exceldown05.xls">닥터명함양식(파일없음)</a></span>
											</div>
										</c:when>
									</c:choose>
								</td>
								<c:if test='${userRole2 == "+" }'>
									<td>
										<span class="btn_quickbuy mb02" title="바로주문"><a href="javascript:item_qty_updateSel('${_gridList.RNO - 1 }')">바로주문</a></span>
										<br>
										<span class="btn_wishproduct" title="나의상품"><a href="javascript:setMyCatalogRegSel('${_gridList.RNO - 1 }')">나의상품</a></span>
									</td> 
								</c:if>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<c:set var='display_item_cnt' value='${total_cnt }'/>
		<c:if test="${!(total_cnt == null || total_cnt == 0) }">

			<fmt:parseNumber type="number" value="${total_cnt }" var="total_cnt"/>
<%-- 			<fmt:parseNumber type="number" value="${onepagerow }" var="onepagerow"/> --%>
<%-- 			<c:out value="${9>=10 }"/> --%>
<%-- 			<c:out value="${integer.total_cnt ge onepagerow }"/> --%>
<%-- 			<c:out value='${total_cnt }'/> --%>
<%-- 			<c:out value="${onepagerow }"/> --%>
 			<c:if test="${total_cnt < onepagerow }">
				<c:set var='display_item_cnt' value='${onepagerow }'/>
			</c:if>
<%-- 			<c:out value="${display_item_cnt }"/> --%>
<%-- 	<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="${display_item_cnt }" > --%>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		</c:if>
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch", Integer.parseInt(pageContext.getAttribute("total_cnt").toString()), curPage, onepagerow)%>
			<span class="cl">[ 총 <c:out value="${total_cnt }" /> 건 ]</span> 
		</p>
		<% request.getSession().setAttribute("session_CART_CNT", Integer.parseInt(pageContext.getAttribute("total_cnt").toString())); %> 
		<script>
			$('#top_cart_cnt').html("${total_cnt }"); 
		</script>
		<div class="btnArea">
			<div class="fl" title="출력" >
				<c:if test="${!(p060000034 == true) }">
					<c:if test='${!(reportText == "NONE") }'>
						<span class="btn_04 mr04" title="${reportText }">
							<a href="javascript:${reportFunction }">${reportText }</a>
						</span> 
					</c:if>
				</c:if>
				<c:if test='${budget_flag == "Y" }'>
					<span class="btn_03 mr04" title="예산조회" >
						<a href="javascript:doAction('getCowayBudgetList');">예산조회</a>
					</span> 
				</c:if>
			</div>
			<div class="fr">
				<c:if test='${buyer == "KRCOWA0002" || buyer == "KRCOWA0007" || buyer == "KRCOWA0003" || buyer == "KRCOWA0008"}'>
				<!--
					<c:if test='${buyer == "KRCOWA0003" || buyer == "KRCOWA0008"}'>
						* 포인트사용:
						<select name="st_drcp_gubun" id="st_drcp_gubun" ${stdrcpGubunDisabled }>
							<option value = "N" selected>미사용</option>
							<option value = "Y" >사용</option>
						</select>&nbsp;
					</c:if> 
				 -->
				 	<input type="hidden" name="st_drcp_gubun" id="st_drcp_gubun" value="N" />
					* 지급기준 :
					<select name="st_ji_gubun" id="st_ji_gubun" ${stJiGubunDisabled }>
						<option value = "DENETPR_N" <c:if test='${ji_gubun ==  "DENETPR_N"}'><c:out value="selected"/></c:if>>추가</option>
						<option value = "DENETPR_Y" <c:if test='${ji_gubun ==  "DENETPR_Y"}'><c:out value="selected"/></c:if>>신규</option>
					</select>&nbsp;
					* 신입여부 :
					<select name="st_sin_gubun" id="st_sin_gubun" ${stSinGubunDisabled }>
						<option value = "DERATE_N" <c:if test='${ji_gubun ==  "DERATE_N"}'><c:out value="selected"/></c:if>>N</option>
						<option value = "DERATE_Y" <c:if test='${ji_gubun ==  "DERATE_Y"}'><c:out value="selected"/></c:if>>Y</option>
					</select>&nbsp;
					*대상자입력 :
					<input type="text" id="txtMember" size="10" />
					<input type="hidden" id="txtMemberId" />
					<span id="spanName"></span>
					<a href="javascript:getReqUserSelectAll();" id="btnMemberBatch"><img src="/resources/images/btn_search03.gif" alt="대상자 일괄입력" /></a>
				</c:if>
				<span class="btn_03 mr04" title="저장" ><a href="javascript:doAction('SAVE');">저장</a></span>
				<span class="btn_03 mr04" title="나의상품등록" ><a href="javascript:doAction('setMyCatalogReg');">나의상품등록</a></span>
				<span class="btn_03 mr04" title="삭제" ><a href="javascript:doAction('setCartDelete');">삭제</a></span>
				<span class="btn_03 mr04" title="상품검색" ><a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000">상품검색</a></span>
				<c:if test='${userRole2 == "+" }'>
					<c:if test='${st_query_cart == "ALL" }'>
						<span class="btn_order mr04" title="바로주문" ><a href="javascript:doAction('CART');">바로주문</a></span>
					</c:if>
					<c:if test='${st_query_cart != "ALL" }'>
						<span class="btn_order mr04" title="바로주문" ><a href="javascript:doAction('ORDER');">바로주문</a></span>
					</c:if>
				</c:if>
			</div>
		</div>
	</form>

	<form name="processForm" id="processForm" method="post">
		<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
		<input type="hidden" name="st_move_flag" id="st_move_flag" value=""/>
		<input type="hidden" name="st_query2" id="st_query2" value=""/>
		<input type="hidden" name="next_status" id="next_status" value=""/>
		<input type="hidden" name="st_item_chk" id="st_item_chk" value=""/>
		<input type="hidden" name="st_update" id="st_update" value=""/>
		<input type="hidden" name="st_buyer" id="st_buyer" value=""/>
		<input type="hidden" name="st_user_id" id="st_user_id" value=""/>
		<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
	</form>

	<form name="locationForm" id="locationForm" method="post">
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
		<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
		<input type="hidden" name="st_description" id="st_description" value="">
		<input type="hidden" name="st_specification" id="st_specification" value="">
		<input type="hidden" name="st_maker_name" id="st_maker_name" value="">
		<input type="hidden" name="st_verif_num" id="st_verif_num" value="${st_verif_num }" />
		
		<input type="hidden" name="st_zip_code" value="${st_zip_code }">
		<input type="hidden" name="st_tel_no" value="${st_tel_no }">
		<input type="hidden" name="st_fax_no" value="${st_fax_no }">
		<input type="hidden" name="st_mobile_no" value="${st_mobile_no }">
		<input type="hidden" name="st_user_name" value="${st_user_name }">
		<input type="hidden" name="st_email" value="${st_email }">
		<input type="hidden" name="st_user_id" value="${st_user_id }">
		<input type="hidden" name="st_query_cart" value="${st_query_cart }">
		<input type="hidden" name="st_recv_date" value="${st_recv_date }">
		<input type="hidden" name="st_recv_date2" value="${st_recv_date2 }">
		<input type="hidden" name="st_remark" value="${st_remark }">
		<input type="hidden" name="st_location_code" value="${st_location_code }">
		<input type="hidden" name="st_location_type" value="${st_location_type }">
		<input type="hidden" name="st_location_name" value="${st_location_name }">
		<input type="hidden" name="st_purchase_dept_name" value="${st_purchase_dept_name }">
		<input type="hidden" name="st_purchase_dept_code" value="${st_purchase_dept_code }">
		<input type="hidden" name="st_mg_code" value="" >
		<input type="hidden" name="st_order_remark" value="" >
		<input type="hidden" name="st_gongje_mark" value="" >
		<input type="hidden" name="st_list_user_name" value="" >
		<input type="hidden" name="st_susin_mark" value="" >
		<input type="hidden" name="st_drcp_gubun" id="st_drcp_gubun" value=""/>
	</form> 
	
	<form name="webserviceForm" id="webserviceForm" method="post">
		<input type="hidden" name="method" id="method" value="13" />
		<input type="hidden" name="rntMessage" id="rntMessage" value="" />
		<input type="hidden" name="emp_no16" id="emp_no16" value="${sessionInfo.userId }" />
<%-- 		<input type="hidden" name="emp_no16" id="emp_no16" value="CS20210541" /> --%>
	</form>
</div>
</div>
<c:import charEncoding="utf-8" url="/WEB-INF/views/common/include/buyerFooter.jsp" />
</div>
</body>
</html>
