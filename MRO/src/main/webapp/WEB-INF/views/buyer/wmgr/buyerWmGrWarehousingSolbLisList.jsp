<%--
**********************************************
* 메뉴 : 입고관리>입고조회(솔브레인 그룹전용)
* 화면 : 입고조회
* 기능 : 기입고처리 처리된 내역을 조회할 수 있다.
* 프로그램 ID : PG_07_B_002_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	Map<String,String> _sLogicMap = (Map<String,String>)request.getAttribute("sLogicInfo"); // 특수로직 조회된 결과

	String rowCntYn 	= "";	// 그리드 행개수
	String rowCnt 		= "";	// 그리드 default 개수
	String cardYn 		= "";	// 신용카드 사용 고객사 여부
	String deptFix 		= "";	// 요청부서 
	String prUserFix 	= "";	// 요청자만 selectbox
	String poUserFix 	= "";	// 발주자만 selectbox
	
	String extrReportBtn= "";	// 추가리포트버튼명	
	String extrReportId = "";	// 추가리포트아이디
	String clsdDnldYn 	= "";	// 마감다운로드버튼 여부
	
	// 최초 화면띄울때만 db조회, 이후 조회시에는 input 값으로 가지고다님.
	if(_sLogicMap != null){
		rowCntYn 	= CommonUtil.nvl(_sLogicMap.get("ROW_CNT_YN"));
		rowCnt 		= CommonUtil.nvl(String.valueOf(_sLogicMap.get("ROW_CNT")));
		cardYn 		= CommonUtil.nvl(_sLogicMap.get("CARD_YN"));
		deptFix 	= CommonUtil.nvl(_sLogicMap.get("DEPT_FIX"));
		prUserFix 	= CommonUtil.nvl(_sLogicMap.get("PR_USER_FIX")); 
		poUserFix 	= CommonUtil.nvl(_sLogicMap.get("PO_USER_FIX"));
		
		extrReportBtn	= CommonUtil.nvl(_sLogicMap.get("EXTR_REPORT_BTN"));
		extrReportId 	= CommonUtil.nvl(_sLogicMap.get("EXTR_REPORT_ID"));
		clsdDnldYn 		= CommonUtil.nvl(_sLogicMap.get("CLSD_DNLD_YN"));
		
		
	} else {
		
		rowCntYn 	= CommonUtil.nvl((String)request.getParameter("st_row_cnt_yn"));
		rowCnt 		= CommonUtil.nvl((String)request.getParameter("st_row_cnt"));
		cardYn 		= CommonUtil.nvl((String)request.getParameter("st_card_yn"));
		deptFix 	= CommonUtil.nvl((String)request.getParameter("st_dept_fix"));
		prUserFix 	= CommonUtil.nvl((String)request.getParameter("st_pr_user_fix")); 
		poUserFix 	= CommonUtil.nvl((String)request.getParameter("st_po_user_fix"));
		
		extrReportBtn	= CommonUtil.nvl((String)request.getParameter("st_extr_report_btn"));
		extrReportId 	= CommonUtil.nvl((String)request.getParameter("st_extr_report_id"));
		clsdDnldYn 		= CommonUtil.nvl((String)request.getParameter("st_clsd_dnld_yn"));
		
	}
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String)request.getParameter("onepagerow"),"");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_legacy_po_no = CommonUtil.nvl((String)request.getParameter("st_legacy_po_no"),"");  
	String st_ref_pr_no = CommonUtil.nvl((String)request.getParameter("st_ref_pr_no"),"");  
	String st_buyer_item_no = CommonUtil.nvl((String)request.getParameter("st_buyer_item_no"),"");
	String st_check_date = CommonUtil.nvl((String)request.getParameter("st_check_date"),"");
	
	String sessionRowCnt = CommonUtil.nvl(_sessionInfo.getRowCnt(),"10");
	
	//SLOGIC-BEGIN(P07-0000004) 그리드 default 행개수
	//if("Y".equals(rowCntYn)){
		//onepagerow = rowCnt;
	//}
	//SLOGIC-END
	
	if(onepagerow.equals("")) {
		onepagerow = sessionRowCnt;
	}
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;

    
    String sessionComCode = _sessionInfo.getComCode();
    String sessionUserType = _sessionInfo.getUserType();
    String sessionDeptCode = _sessionInfo.getDepartment();
    String sessionDeptName = _sessionInfo.getDepartmentName();
    String SessionUserId            = _sessionInfo.getUserId();
    //예산계정 사용유무 추가.
    String sessionBudget_flag =  CommonUtil.nvl((String)_sessionInfo.getBudgetFlag());
    
    String dept_type = CommonUtil.nvl((String)request.getParameter("st_dept_type"), "");
    String req_dept_code = CommonUtil.nvl((String)request.getParameter("st_req_dept_code"), "");
    String req_dept_name = CommonUtil.nvl((String)request.getParameter("st_req_dept_name"), "");
    String acnt_cd = CommonUtil.nvl((String)request.getParameter("st_acnt_cd"), "");
    String acnt_nm = CommonUtil.nvl((String)request.getParameter("st_acnt_nm"), "");
    
    
    if(dept_type.equals("")){
		dept_type = "PR";
	}
    

    if(deptFix.equals("Y")){
    	if(sessionUserType.equals("U") && req_dept_code.equals("")){
    		req_dept_code = sessionDeptCode;
    		req_dept_name = sessionDeptName;
    	}
    }
    
    String p060000029 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000029","COL01_DATA");
    String p070000011 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000011","COL01_DATA"); // 엑셀다운로드 유형   
    
		  
    String user_type = CommonUtil.nvl((String)request.getParameter("st_user_type"),"");
    if(user_type.equals("")){
       user_type = "PO";
    }
	/*
	P06-0000080 
	장바구니 필드추가 제어, 엑셀 다운로드시 컬럼 조절 
	-TYPE1: 윈체  수량길이 필드 추가
	-TYPE2: 대덕전자 
	-TYPE3: 넥센 택배사정보, 배송증빙 추가
	-TYPE11: 한컴라이프케어 관리번호 (회계단위^원각^코스트센터^계정^프로젝트코드) 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000080","COL01_DATA");
    //그룹기준 사업장 조회
    boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, sessionComCode);
    String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
    String group_mng_flag = "N";

    if(getCodeTGCM == true){
 	   group_mng_flag = "Y"; 
    }    
    
  	
  	//솔브레인 그룹 입고확정 사용자 조회
    boolean getCodeGRcf = CommonUtil.getCode3CheckReturn("GRCF", SessionUserId, sessionComCode);
  	
  	//솔브레인 그룹 마감확정 사용자 조회
    boolean getCodeDLcf = CommonUtil.getCode3CheckReturn("DLCF", SessionUserId, sessionComCode);
  	
  	
  	
  	
%> 

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){

	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	var today = kepGetNowTimeStr("YYYYMMDD","");
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToMonthAdd("1","M","noslash");
		to_date = today;
	}
	
	initSearchCondition("searchForm", "st_from_date", from_date);	//발주일 시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);		//발주일 종료일자
	
	initSearchCondition("searchForm", "st_ref_pr_no", "${st_ref_pr_no}");	// 관리번호	
	
	initSearchCondition("searchForm", "st_no_type", "${st_no_type}");				// 조회번호구분코드 (IV : 송장번호, PO발주번호)
	initSearchCondition("searchForm", "st_search_no", "${st_search_no}");			// 조회번호
	initSearchCondition("searchForm", "st_user_type", "${st_user_type}");			// user_type(PR : 요청자, PO : 발주자)
	initSearchCondition("searchForm", "st_po_user_id", "${st_po_user_id}");			// user_id(ALL : 전체, session_user_id)
	initSearchCondition("searchForm", "st_gr_status", "${st_gr_status}");			
	
	// 상세조회 팝업 조회조건
	initSearchCondition("searchForm", "st_search_buyer_item_no", "${st_search_buyer_item_no}");	// 품목코드
	initSearchCondition("searchForm", "st_search_desc_spec", "${st_search_desc_spec}");			// 품목명/규격
	initSearchCondition("searchForm", "st_search_agent", "${st_search_agent}");					// 협력사
	
	
	initSearchCondition("searchForm", "st_dept_type", "<%=dept_type%>");					// 협력사

	initSearchCondition("searchForm", "st_req_dept_name", "<%=req_dept_name%>");	// 요청부서명
	initSearchCondition("searchForm", "st_req_dept_code", "<%=req_dept_code%>");	// 요청부서코드
	initSearchCondition("searchForm", "st_acnt_cd", "<%=acnt_cd%>");	// 계정코드
	initSearchCondition("searchForm", "st_acnt_nm", "<%=acnt_nm%>");	// 계정명

	//kepSetCalender('st_from_date');
	//kepSetCalender('st_to_date');
	
	initSearchCondition("searchForm", "st_no_type2", "${st_no_type2}");	//품목코드, 품목명, 규격
	initSearchCondition("searchForm", "st_search_no2", "${st_search_no2}"); //품목코드, 품목명, 규격
	
<%
	if(!"KRSIEM0010".equals(sessionComCode)) { 
%>
		setUserList("load");
<%	} %>
}

function setUserList(type){

	var pr_user_fix = $("#st_pr_user_fix").val();
	var po_user_fix = $("#st_po_user_fix").val();
	$("#st_search_type").val(type);
	
	if("Y" != pr_user_fix && "Y" != po_user_fix){
		
	kepAjaxFormCall("/wmgr/getBuyerWmGrWarehousingRegUserList.do","searchForm","setUserList"); // 사용자 목록 콤보박스 위해서
    }
}

function getDepartmentCode(){
	var com_code = $("#st_com_code").val();
	openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
} 
//계정정보 팝업 호출.
function getAcntCode(){
	var st_buyer = $("#st_com_code").val();
	var st_gbn = "비용계정";
	var st_type = "Z014";
	var st_code =  "";
	var st_text =   "";
    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
} 
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
	var query   = "";
	var ref_no = value2;
	var st_row = value4;
	var tot_cnt  =  $("#display_item_cnt").val();
	if(value4=="dept"){
		$("#st_req_dept_code").val(value1);
		$("#st_req_dept_name").val(value2);
	} else if(value1 == 'Solb') {
		$("#st_ref_pr_no").val(value2);					
	} else if(value1 == 'SolbSave') {
		
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			var com_code = $("input[name='db_buyer']").eq(k).val();
			var gr_no		= $("input[name='db_gr_no']").eq(k).val();
			var gr_seq		= $("input[name='db_gr_seq']").eq(k).val();
			var iv_exist	= $("input[name='db_iv_exist']").eq(k).val();
			
			if(k == st_row) {
				query +=  com_code		+ "@@";				
				query +=  gr_no			+ "@@";
				query +=  gr_seq		+ "@@";		
				query +=  iv_exist		+ "@@";
				query +=  ref_no		+ "@@";	 // 변경되는 관리번호	
				query +=  "&||&" ;
				continue;
			}
			if(box.checked == true){
				query +=  com_code		+ "@@";				
				query +=  gr_no			+ "@@";
				query +=  gr_seq		+ "@@";
				query +=  iv_exist		+ "@@";
				query +=  ref_no		+ "@@";	 // 변경되는 관리번호	
				query +=  "&||&" ;
			}
		}
		
		document.searchForm.st_query.value  = query;
        
        kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingSolbRefNo.do","searchForm","refSave");
		
	} else{	
		if(value1 == "Z014"){
			$("#st_acnt_cd").val(value2);
			$("#st_acnt_nm").val(value3);
		}		
	}
}

function getNewDepartmentDisplayPop(st_dept){
	var com_code = $("#st_com_code").val();
	openSearchPopup("/coco/getCommonCoCoDepartmentDetailViewPop.do", "?openYn=Y&st_com_code="+com_code+"&st_dept="+st_dept, "410,143,no");
}  


var st;
//기능함수
function doAction(str, type) {
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	switch (str) {
		case "search":	 //조회
			
			kepSearch('1');
			break;
			
		case "reload":	//초기화

			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");		
			
			initSearchCondition("searchForm", "st_ref_pr_no", "");	// 관리번호			
			initSearchCondition("searchForm", "st_dept_type", "");
			initSearchCondition("searchForm", "st_req_dept_name", "");	// 요청부서명
			initSearchCondition("searchForm", "st_req_dept_code", "");	// 요청부서코드
			initSearchCondition("searchForm", "st_no_type", "");				// 조회번호구분코드 (IV : 송장번호, PO발주번호)
			initSearchCondition("searchForm", "st_search_no", "");			// 조회번호
			initSearchCondition("searchForm", "st_user_type", "");			// user_type(PR : 요청자, PO : 발주자)
			initSearchCondition("searchForm", "st_po_user_id", "");			// user_id(ALL : 전체, session_user_id)
			initSearchCondition("searchForm", "st_gr_status", "");			
			
			// 상세조회 팝업 조회조건
			initSearchCondition("searchForm", "st_search_buyer_item_no", "");	// 품목코드
			initSearchCondition("searchForm", "st_search_desc_spec", "");			// 품목명/규격
			initSearchCondition("searchForm", "st_search_agent", "");					// 협력사
			
			initSearchCondition("searchForm", "st_no_type2", "");			// 품목코드/품목명/규격
			initSearchCondition("searchForm", "st_search_no2", "");				// 품목코드/품목명/규격
			
			$("#st_excel_type").val("");
			$("#st_close_excel_type").val("");
			$('#st_total_cnt').val('0');
// 			kepSearch(-1); 
			jspTableClean("table_list");
			 
			break;
		
			
		case "grCancel":	 //입고취소
			setGrCancel();
			break;
			
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}			
			
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingSolbLisList.do";
			document.forms.searchForm.submit();	
			break;
			
		case "erpDown": // ERP다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}			
			
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingSolbErpList.do";
			document.forms.searchForm.submit();	
			break;
			
		
		case "grConfirm":	 //입고확정 및 취소
			grConfirm(type);
			break;
		
		case "dlConfirm":	 //마감확정 및 취소
			dlConfirm(type);
			break;
		
	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){ // 조회기간 제한 2018.04.26 by HSJ
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
	var st_ref_pr_no_plant = "";
	var st_ref_pr_no_cost = "";
	var st_ref_pr_no_account = "";
	var st_ref_pr_no = $("#st_ref_pr_no").val();
	if(st_ref_pr_no != "" && st_ref_pr_no != null ) {		
		var st_ref_pr_no_split = st_ref_pr_no.split('^');
		st_ref_pr_no_plant = st_ref_pr_no_split[0];
		st_ref_pr_no_cost = st_ref_pr_no_split[1];
		st_ref_pr_no_account = st_ref_pr_no_split[2];
	}	
	
	document.forms.searchForm.st_ref_pr_no_plant.value = st_ref_pr_no_plant;
	document.forms.searchForm.st_ref_pr_no_cost.value = st_ref_pr_no_cost;
	document.forms.searchForm.st_ref_pr_no_account.value = st_ref_pr_no_account;
	
	$("#st_excel_type").val("");
	$("#st_close_excel_type").val("");
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/wmgr/getBuyerWmGrWarehousingSolbLisList.do").submit();   
}

// 입고취소
function setGrCancel(){
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	
	if(cnt == 0){
		//입고 취소하실 목록을 선택해 주십시요.
		alert("<%=CommonLang.msg("MSG247")%>   ");
		return;
	}
	
    // 입고일 체크
    //var gr_flag = checkGrDate();
    //if(!gr_flag) return;
    
  	//var gr_date = $.datepicker.formatDate('yymmdd', $("#st_gr_date").datepicker("getDate"));
  	
  	var user_id  = $("#st_user_id").val();
  	
  	var close_date = document.searchForm.st_close_date.value;
  	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			
			var db_gr_confirm1 = $("input[name='db_gr_confirm1']").eq(k).val().trim(); // 입고확정자
			var db_gr_confirm2 = $("input[name='db_gr_confirm2']").eq(k).val().trim(); // 마감확정자
			
			if(db_gr_confirm1 != '' || db_gr_confirm2 != ''){
				// 번째 항목 입고확정된 건이므로 입고 취소 불가합니다.
				alert( (k+1) + " <%=CommonLang.msg("MSG584")%>");
				return;
			}
			
			var legacy_po_no = $("input[name='db_legacy_po_no']").eq(k).val();			
			if(legacy_po_no != '' || legacy_po_no != null) {
				if(legacy_po_no.substr(0, 1) == "4" ) {
					alert("<%=CommonLang.msg("MSG582")%>");
					return;
				}
			}
			
			var gr_date = $("input[name='db_gr_date']").eq(k).val();
			var close_flag = $("input[name='st_close_flag']").eq(k).val();
            var ar_bill_flag = $("input[name='st_ar_bill_flag']").eq(k).val();
            var ap_bill_flag = $("input[name='st_ap_bill_flag']").eq(k).val();
            var gr_lock_flag = $("input[name='db_gr_lock_flag']").eq(k).val();
            
            // 종결여부
            var clsd_flag = $("input[name='st_clsd_flag']").eq(k).val();
            
            //자동입고
			var db_auto_gr = $("input[name='db_auto_gr']").eq(k).val();
			if(db_auto_gr == "Y"){
				//번째 입고 자료는 자동입고 처리 건이므로 입고취소가 불가능 합니다.
				alert( (k+1) + " <%=CommonLang.msg("MSG248")%>");
				return;
			}
			if(ar_bill_flag == 'Y' || ap_bill_flag == 'Y'){
				//번째 입고 자료는 세금계산서 발행 완료 건으로 입고 취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.
				alert( (k+1) + " <%=CommonLang.msg("MSG249")%>");
				return;
			}
			if(eval(close_date) >= eval(gr_date)){
				//번째 입고자료는 마감일 이전이어서 입고취소 하실 수 없습니다.  \n\n운영자에게 문의하시기 바랍니다.  
				alert( (k+1) + " <%=CommonLang.msg("MSG250")%>");
				return;
			}
			if(close_flag=="Y") {
				//번째 입고자료는 이미 마감완료 되어 입고취소 하실 수 없습니다.\n\n자세한 사항은 운영자에게 문의하시기 바랍니다.
				alert((k+1)+" <%=CommonLang.msg("MSG251")%> ");
				return;
			}
			
			if(clsd_flag=="Y") {
				//번째 입고자료는 상태가 종결되어 입고취소 하실 수 없습니다.
				alert((k+1)+" <%=CommonLang.msg("MSG252")%>");
				return;
			}
			
			// 통제년월 vs 입력년월(위의 상태에 관한 분기들 먼저 체크하고 가장 마지막에 체크)
			if(gr_lock_flag == "Y"){
				// 월마감이 종료되어 입고취소 불가합니다.
				alert("<%=CommonLang.msg("MSG586")%>");
				return;
			}
			
			var com_code = $("input[name='db_buyer']").eq(k).val();
			var gr_no		= $("input[name='db_gr_no']").eq(k).val();
			var gr_seq		= $("input[name='db_gr_seq']").eq(k).val();
			var iv_exist	= $("input[name='db_iv_exist']").eq(k).val();
			var gr_item_qty	= $("input[name='db_gr_item_qty']").eq(k).val();
			
			// BUYER + USER_ID + GR_NO + GR_SEQ + PO_NO + PO_SEQ + IV_EXIST +INV_NO + INV_SEQ + GR_QTY
			query +=  com_code		+ "@@";
			query +=  user_id		+ "@@";
			query +=  gr_no			+ "@@";
			query +=  gr_seq		+ "@@";			
			query +=  iv_exist		+ "@@";			
			query +=  gr_item_qty	+ "@@";			
			query +=  "^||^" ;
		}
	}
	
	//console.log("query ==>>> " + query);
	//선택하신 품목을 입고 취소처리 하시겠습니까?
    if(!confirm(" <%=CommonLang.msg("MSG246")%> ")) {
        return;
    }else{
    	
        document.searchForm.st_query.value  = query;
        
        kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingSolbLisList.do","searchForm","btnSave");
        
    }
}

//팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
		
	case "buyerMpPoOrderDetailPop": // 주문번호
		openSearchPopup("/mppo/showBuyerMpPoOrderDetailPop.do", "?openYn=Y&COMPANY="+value1+"&REF_NO="+value2+"&RECV_FLAG="+value3, "1000,510,no");
		break;
				
	case "commonMpIvOrderDetailPop": // 발주번호
		openSearchPopup("/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do", "?buyer="+value1+"&po_no="+value2, "820,550,no");
		break;
		
	case "commonMpIvInvoiceDetailPop": // 송장번호
		if(value3.substring(0,2) == "IV") {
			var user_id = $("#st_user_id").val();
			openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIVPop.do", "?buyer="+value1+"&seller="+value2+"&inv_no="+value3+"&po_no="+value4+"&pur_id="+value6+"&user_id="+user_id, "820,550,no");
		} else {	
			openSearchPopup("/mpiv/getCommonMpIvInvoiceDetailIKPop.do", "?buyer="+value1+"&seller="+value2+"&inv_no="+value3+"&po_no="+value4+"&warehouse_code="+value5, "820,550,no");
		}
		
		break;	
		
	case "commonMpIvOdrreqDetailPop": // 요청번호
		openSearchPopup("/mpiv/showCommonMpIvOdrreqDetailPop.do", "?openYn=Y&COMPANY="+value3+"&PR_NO="+value1+"&RECV_FLAG="+value2, "800,600,no");
		break;
		
	case "agentDisplayPop": // 협력사
		getAgentDisplayPop(value1);
		break;
	case "buyerCatalogDisplayPop": // 품목코드팝업
		getBuyerCatalogDisplayPop(value1, value2, value3, value4);
		break;
		
	case "newDepartmentDisplayPop": // 요청부서팝업
		var com_code = $("#st_com_code").val();
		openSearchPopup("/coco/getCommonCoCoDepartmentDetailViewPop.do", "?openYn=Y&st_com_code="+com_code+"&st_dept="+value1, "410,143,no");
		break;	
		
	case "buyerMpPoDlvryDetailPop": // 거래명세서번호
		openSearchPopup("/mpiv/getCommonMpIvBuyerDlvryDetailInfoPop.do", "?buyer="+value1+"&inv_no="+value2, "800,500,no");
		break;
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	//var msg = response.Message;
	
	if(pMethod == "btnSave"){
		//입고 취소가 정상적으로 이루어 졌습니다.
		alert("<%=CommonLang.msg("MSG253")%> ");
		doAction("search");
	    //setQuery();   
	} else if(pMethod == "refSave"){
		//관리번호가 정상적으로 변경되었습니다.
		alert("<%=CommonLang.msg("MSG565")%> ");
		doAction("search");
	    //setQuery();   
	} else if(pMethod == "setUserList"){
		
		var userList = response.userList;
		var searchType = response.searchType;
		var poUserId = response.poUserId;
		
		var listbox = document.searchForm.st_po_user_id;
		
	    listbox.options.length = 0;
	    var option = new Array();

	    option[0] = new Option('전체','');
	    listbox.options[0] = option[0];

	    var userId = "";
	    var userName = "";
	    var seq = 0;
		for(var i = 0; i < userList.length; i++){
			
			seq = i+1;
			
			userId = userList[i].USER_ID;
			userName = userList[i].USER_NAME_LOC;
			
			option[seq] = new Option(userName, userId);
			
			if(userId == "${st_po_user_id}" && searchType == "load"){
				option[seq].selected = true;	
			}
			
			listbox.options[seq] = option[seq];
		}
	} else if(pMethod == "confirmSave") {
		//정상적으로 저장되었습니다.
		alert("<%=CommonLang.msg("MSG76")%> ");
		doAction("search");
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
	
	if(tot_cnt > 0){
		chkSumPrice();	
	}
}

//합계금액
function chkSumPrice(){
    var tot_cnt = $("#display_item_cnt").val();
    var sum_price = 0;
    
    if(eval(tot_cnt) < 2){
        var box = eval("document.contentForm.checkbox"+0);
        if(box.checked == true){
            sum_price = eval(sum_price) + eval(filterNum(document.contentForm.st_check_item_amt.value));
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.contentForm.checkbox" + k);
            if(box.checked == true){
                sum_price = eval(sum_price) + eval(filterNum(document.contentForm.st_check_item_amt[k].value));
            }
        }
    }
    document.searchForm.check_sum_price.value     = kepCommaNum(sum_price) + " <%=CommonLang.get("HTITLE660")%>";	//원
    document.searchForm.st_check_sum_price.value  = sum_price;
}

//check_box_name 으로 설정된 체크박스 중 체크 표시가 된 수량을 리턴함
function getCheckedRowCount(check_box_name){
    var cnt   = 0;
    for(var i=0;i<document.contentForm.elements.length;i++){
        if(document.contentForm.elements[i].name.indexOf(check_box_name)!=-1){
            if(document.contentForm.elements[i].checked){
                cnt++;
            }
        }
    }
    return cnt;
}

function getSolbRefPop() {
	var buyer  = $("#st_com_code").val();	
	
	openSearchPopup("/mpso/getBuyerMpSoRefPrNoInfoSolbPop.do", "?open=Y&st_buyer="+buyer, "500,250,no");
}


//관리번호 변경
function RefPrNoSolb(row, ref_no, buyer){	
    url = "/mpso/saveBuyerMpSoRefPrNoSolbPop.do";
    openSearchPopup(url,"?open=Y&row="+row+"&st_ref_no="+ref_no+"&st_buyer="+buyer, "700,210,no"); 
}

//입고확정 및 취소
function grConfirm(type){
	var st_type = type;
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	
	if(cnt == 0){
		//선택된 항목이 없습니다.
		alert("<%=CommonLang.msg("MSG78")%>");
		return;
	}
	
  	var user_id  = $("#st_user_id").val();
  	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){			
			var com_code 	= $("input[name='db_buyer']").eq(k).val();
			var gr_no		= $("input[name='db_gr_no']").eq(k).val();
			var gr_seq		= $("input[name='db_gr_seq']").eq(k).val();			
			var db_gr_confirm1 = $("input[name='db_gr_confirm1']").eq(k).val().trim(); // 입고확정자
			var db_gr_confirm2 = $("input[name='db_gr_confirm2']").eq(k).val().trim(); // 마감확정자
			
			if(st_type == 'complate') {
				if(db_gr_confirm1 != ''){
					// 이미 입고 확정된 건입니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG573")%>");
					return;
				}				
			} 
			
			if(st_type == 'cancle') {
				if(db_gr_confirm1 == ''){
					// 입고 확정이 안된 건입니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG571")%>");
					return;
				}
				if(db_gr_confirm2 != ''){
					// 마감 확정되어 입고 확정 취소할 수 없습니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG570")%>");
					return;
				}
			} 			
			
			// BUYER + USER_ID + GR_NO + GR_SEQ
			query +=  com_code		+ "@@";
			query +=  user_id		+ "@@";
			query +=  gr_no			+ "@@";
			query +=  gr_seq		+ "@@";	
			query +=  st_type		+ "@@";	
			query +=  "^||^" ;
		}
	}


	if(st_type == 'complate') { // 입고 확정
		if(!confirm(" <%=CommonLang.msg("MSG566")%> ")) {
			return;
		}
	} else { // 입고 확정 취소
		if(!confirm(" <%=CommonLang.msg("MSG567")%> ")) {
			return;
		}
	}
    
	
    document.searchForm.st_query.value  = query;
    
    kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingSolbGrConfirm.do","searchForm","confirmSave");
    
}

//마감 확정 및 취소
function dlConfirm(type){
	
	var st_type = type;
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	
	if(cnt == 0){
		//선택된 항목이 없습니다.
		alert("<%=CommonLang.msg("MSG78")%>");
		return;
	}
	
  	var user_id  = $("#st_user_id").val();
  	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){			
			var com_code 	= $("input[name='db_buyer']").eq(k).val();
			var gr_no		= $("input[name='db_gr_no']").eq(k).val();
			var gr_seq		= $("input[name='db_gr_seq']").eq(k).val();
			
			var db_gr_confirm1 = $("input[name='db_gr_confirm1']").eq(k).val().trim(); // 입고확정자
			var db_gr_confirm2 = $("input[name='db_gr_confirm2']").eq(k).val().trim(); // 마감확정자
			
			if(st_type == 'complate') {
				if(db_gr_confirm1 == ''){
					// 입고 확정이 안된 건 입니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG571")%>");
					return;
				}
				if(db_gr_confirm2 != ''){
					// 이미 마감 확정된 건입니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG574")%>");
					return;
				}
			}
			
			if(st_type == 'cancle') {				
				if(db_gr_confirm2 == ''){
					// 마감 확정이 안된 건입니다.
					alert( (k+1) + "번째 항목 "+ "<%=CommonLang.msg("MSG572")%>");
					return;
				}
			}
						
			// BUYER + USER_ID + GR_NO + GR_SEQ
			query +=  com_code		+ "@@";
			query +=  user_id		+ "@@";
			query +=  gr_no			+ "@@";
			query +=  gr_seq		+ "@@";	
			query +=  st_type		+ "@@";	
			query +=  "^||^" ;
		}
	}


	if(st_type == 'complate') { // 마감 확정
		if(!confirm(" <%=CommonLang.msg("MSG568")%> ")) {
			return;
		}
	} else { // 마감 확정 취소
		if(!confirm(" <%=CommonLang.msg("MSG569")%> ")) {
			return;
		}
	}
    
	
    document.searchForm.st_query.value  = query;
    
    kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingSolbDlConfirm.do","searchForm","confirmSave");
}




</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	
	<h3><%=CommonLang.get("HTITLE275")%><!-- 입고조회 --></h3>
	
	<!--버튼영역-->
     <div id="searchBtnA">		
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
     </div>
     <form name = "intiForm" id="intiForm" method = "get">
     <input type="hidden" name="user_id"  id="user_id"  value="${sessionInfo.userId}">
     <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
     </form>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.departmentName}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}">
			
		<input type="hidden" name="st_query" value ="">
		<input type="hidden" name="st_close_date" value ="">
		<input type="hidden" name="st_car_check" id="st_car_check" value="">
		
		<input type="hidden" name="st_row_cnt_yn" 	id="st_row_cnt_yn" 	value="<%=rowCntYn%>" />
		<input type="hidden" name="st_row_cnt" 		id="st_row_cnt" 	value="<%=rowCnt%>" />
		<input type="hidden" name="st_card_yn" 		id="st_card_yn" 	value="<%=cardYn%>" />
		<input type="hidden" name="st_dept_fix" 	id="st_dept_fix" 	value="<%=deptFix%>" />
		<input type="hidden" name="st_pr_user_fix" 	id="st_pr_user_fix"	value="<%=prUserFix%>" />
		<input type="hidden" name="st_po_user_fix" 	id="st_po_user_fix"	value="<%=poUserFix%>" />
		
		<input type="hidden" name="st_extr_report_btn" 	id="st_extr_report_btn"	value="<%=extrReportBtn%>" />
		<input type="hidden" name="st_extr_report_id" 	id="st_extr_report_id"	value="<%=extrReportId%>" />
		<input type="hidden" name="st_clsd_dnld_yn" 	id="st_clsd_dnld_yn"	value="<%=clsdDnldYn%>" />
		
		<input type="hidden" id="st_search_buyer_item_no" name="st_search_buyer_item_no" value="">
		<input type="hidden" id="st_search_desc_spec" name="st_search_desc_spec"     value="">
		<input type="hidden" id="st_search_agent" name="st_search_agent"         value="">
		
		<input type="hidden" name="st_search_type" 	id="st_search_type"	value="" />
		<input type="hidden" id="st_excel_type" name="st_excel_type"	value="" />
		<input type="hidden" id="st_close_excel_type" name="st_close_excel_type"	value="" />
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
				<colgroup>
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
					<col width="7%" />
					<col width="18%" />
				</colgroup>
				
				<tbody>
				<tr>				
					<td><%=CommonLang.get("HTITLE283")%><!-- 입고일 --><input type="hidden" id="st_check_date" name="st_check_date" value="GR"></td>				
					<td colspan="3">
						<input type="text"   name="st_from_date" style="width: 20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
			          	&nbsp;~&nbsp;
						<input type="text"   name="st_to_date" style="width: 20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
						
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>							
					</td>								
                    <td>                   
                   		<%=CommonLang.get("HTITLE18")%><!-- 관리번호 -->
                        <input type="hidden" id="st_legacy_po_no" name="st_legacy_po_no" value="">
	                    <input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no" value="">
	                    <input type="hidden" id="st_change_user_id" name="st_change_user_id" value="">
	                    <input type="hidden" name="st_acnt_cd" id="st_acnt_cd" value="">
                    </td>
                    <td>
				<%
					//SLOGIC-BEGIN(P06-0000029)
					if( p060000029.equals("TYPE33")){// 솔브레인 그룹 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>						
						<input type="hidden" id="st_ref_pr_no_plant" name="st_ref_pr_no_plant" value="">
						<input type="hidden" id="st_ref_pr_no_cost" name="st_ref_pr_no_cost" value="">
						<input type="hidden" id="st_ref_pr_no_account" name="st_ref_pr_no_account" value="">
						<a href="javascript:getSolbRefPop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						
				<%	} %>
					</td>
					<td style="text-align: right; padding-right: 10px;">
                        <%=CommonLang.get("HTITLE255")%> <!-- 상태 -->
					</td>
					<td>
                        <select id="st_gr_status" name="st_gr_status" width="60px;">
                        	<option value = "ALL" ><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
                        	<option value = "GS" ><%=CommonLang.get("HTITLE284")%><!-- 마감완료 --> </option>
                        	<option value = "GC" ><%=CommonLang.get("HTITLE201")%><!-- 입고완료 --></option>							
							<option value = "GP" ><%=CommonLang.get("HTITLE200")%><!-- 부분입고 --></option>							
						</select>
					</td>
				</tr>
				<tr>
					
					<td>
						<label for="b_code" class="hidden">요청부서/발주부서</label>
						<select id="st_dept_type" name="st_dept_type" style="height:20px;">
							<option value = "PR"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --> </option>
							<option value = "PO"><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></option>
							<%if(sessionBudget_flag.equals("Y")){ %>
								<option value = "BD"><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></option>
							<%}%>
						</select>
					</td>
					<td>
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
		            <% 
		                if("Y".equals(deptFix) && sessionUserType.equals("U")){
		                } else {
		            %>
				            <a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>        
		            <%
		                }
		            %>
					</td>
				    <td>
                        <select id="st_no_type" name="st_no_type" width="80px;">
                        	<option value = "PO" ><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></option>
							<option value = "IV"><%=CommonLang.get("HTITLE271")%><!-- 송장번호 --> </option>
							<option value = "PR"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --> </option>
						</select>
					</td>
					<td>
						<input type="text" id="st_search_no" name="st_search_no" size="24" value="" onKeyDown="kepEnter();">
					</td>
				<%  if("Y".equals(prUserFix)){ %>
					        <td>
				            <select id="st_user_type" name="st_user_type">
				                <option value="PR" selected><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></option>
				            </select>
				        </td>
				        <td>
				             <select id="st_po_user_id" name="st_po_user_id">
				               <option value="${sessionInfo.userId}" selected>${sessionInfo.userNameLoc}</option>
				            </select>
				        </td>
				<%  } else if("Y".equals(poUserFix)){ %>
				        <td>
				            <select id="st_user_type" name="st_user_type">
				                <option value="PO" selected><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></option>
				            </select>
				        </td>
				        <td>
				             <select id="st_po_user_id" name="st_po_user_id">
				               <option value="${sessionInfo.userId}" selected>${sessionInfo.userNameLoc}</option>
				            </select>
				        </td>
				<%  }else{ %>
				        <td>
				            <select id="st_user_type" name="st_user_type" onChange="setUserList('change')">
				                <option value="PO"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></option>
				                <option value="PR"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></option>
				            </select>
				        </td>
				        <td>
				            <select id="st_po_user_id" name="st_po_user_id">
				                <option value="" >---<%=CommonLang.get("HTITLE29")%><!-- 전체 -->----</option>
				                <!-- 
				                	추후 아래메소드가지고 select 만들기
				                	CommonUtil.getCodeComboQueryIdList 
				                -->
				           
				            </select>
				        </td>
				<%  }   %>				
				<td>
				</td>
				<td>
				</td>				
				</tr>
				<%if(sessionBudget_flag.equals("Y")&&group_mng_flag.equals("Y")){ %>
				<tr>
					<td><%=CommonLang.get("HTITLE386")%><!-- 계정코드 --></td>
					<td >
						<input type="text" class="input_type_text" name="st_acnt_nm" id="st_acnt_nm" style="width:55%;ime-mode:active" value="" READONLY>
							<a href="javascript:getAcntCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_acnt_cd','st_acnt_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>        
					</td>
					<td><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></td>
					<td > 
						<select name="st_com_code" id="st_com_code" style="width:90%;height:20px;" onchange="buyerChange()">
					      	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					    </select>
					 </td>
					<td>
						<select id="st_no_type2" name="st_no_type2" width="80px;">
	                        	<option value = "ITEMNO"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
								<option value = "ITEMNAME"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> </option>
								<option value = "SPECIFICATION"><%=CommonLang.get("HTITLE14")%><!-- 규격 --> </option>
						</select>
					</td>
					<td ><input type="text" id="st_search_no2" name="st_search_no2" size="24" value="" onKeyDown="kepEnter();"></td>
				</tr>
				<%}else if(sessionBudget_flag.equals("Y")&&group_mng_flag.equals("N")){%>
					<td><%=CommonLang.get("HTITLE386")%><!-- 계정코드 --></td>
					<td >
						<input type="text" class="input_type_text" name="st_acnt_nm" id="st_acnt_nm" style="width:55%;ime-mode:active" value="" READONLY>
							<a href="javascript:getAcntCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_acnt_cd','st_acnt_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>     
							<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">   
					</td>
					<td>
						<select id="st_no_type2" name="st_no_type2" width="80px;">
	                        	<option value = "ITEMNO"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
								<option value = "ITEMNAME"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> </option>
								<option value = "SPECIFICATION"><%=CommonLang.get("HTITLE14")%><!-- 규격 --> </option>
						</select>
					</td>
					<td ><input type="text" id="st_search_no2" name="st_search_no2" size="24" value="" onKeyDown="kepEnter();"></td>
					<td></td>
					<td ></td>				
				<%}else if(sessionBudget_flag.equals("N")&&group_mng_flag.equals("Y")){%>
					<td><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></td>
					<td >
						<select name="st_com_code" id="st_com_code" style="width:90%;height:20px;" onchange="buyerChange()">
					      	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					    </select> 
					</td>
					<td>
						<select id="st_no_type2" name="st_no_type2" width="80px;">
	                        	<option value = "ITEMNO"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
								<option value = "ITEMNAME"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> </option>
								<option value = "SPECIFICATION"><%=CommonLang.get("HTITLE14")%><!-- 규격 --> </option>
						</select>
					</td>
					<td ><input type="text" id="st_search_no2" name="st_search_no2" size="24" value="" onKeyDown="kepEnter();"></td>
					<td></td>
					<td ></td>
				<%}else{%>
					<td>
						<select id="st_no_type2" name="st_no_type2" width="80px;">
	                        	<option value = "ITEMNO"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
								<option value = "ITEMNAME"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> </option>
								<option value = "SPECIFICATION"><%=CommonLang.get("HTITLE14")%><!-- 규격 --> </option>
						</select>
					</td>
					<td >
						<input type="text" id="st_search_no2" name="st_search_no2" size="24" value="" onKeyDown="kepEnter();">     
						<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">   
					</td>
					<td></td>
					<td ></td>
					<td></td>
					<td ></td>
				<%}%>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %> >10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %> >20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %> >30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %> >40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %> >50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "70" <%if ("70".equals(onepagerow)) {%>selected<%} %> >70<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %> >100<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %> >200<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "300" <%if ("300".equals(onepagerow)) {%>selected<%} %> >300<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "500" <%if ("500".equals(onepagerow)) {%>selected<%} %> >500<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "1000" <%if ("1000".equals(onepagerow)) {%>selected<%} %> >1000<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
			</select>
      	</span>      	
      	<span class="fr">
      		<%=CommonLang.get("HTITLE172")%><!-- 총 금액 --> : 
			<input type="text" name="check_sum_price" value="원"  style="width:150px; text-align:right; background-color:#FFFFFF;font-weight:bold; font-size:9pt; border:#FFFFFF 1px solid;" READONLY>
			<input type="hidden" name="st_check_sum_price"  value="">
      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE594")%><!-- (기준 : 원) -->
      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
		</span>		
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>		
				<% if(!"Y".equals(cardYn)) {
						if(sessionBudget_flag.equals("Y")){
				%>
				      <col width="6%"/>
				      <col width="8%"/>
				      <col width="7%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="*"/>
				      <col width="5%"/>
				      <col width="5%"/>
				      <col width="5%"/>					
				      <col width="7%"/>
				      <col width="5%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				<%
					}else{
				%>
				      <col width="6%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="9%"/>
				      <col width="*"/>
				      <col width="5%"/>
				      <col width="5%"/>
					
				      <col width="6%"/>
				      <col width="9%"/>
				      <col width="6%"/>
				      <col width="10%"/>
					
				<%
					}
				%>
			<% } %>
	        </colgroup>
	        <thead>
		<% 
				if(sessionBudget_flag.equals("Y")){
		%>
				<tr>
					<th scope="col" rowspan="2">
						<a href="javascript:checkAll();" id="check_status"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></a>
					</th>
					<%if(group_mng_flag.equals("Y")){%>
						<th scope="col" ><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
					<%}else{%>
						<th scope="col"><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
					<%}%>
					<th scope="col"><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>				
					<th scope="col"><%=CommonLang.get("HTITLE280")%><!-- 총입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>					
					<th scope="col"><%=CommonLang.get("HTITLE419")%><!-- 예산부서 --></th>
				</tr>
				<tr>
					<%if(group_mng_flag.equals("Y")){%>
						<th scope="col" ><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
					<%}else{%>
						<th scope="col" ><%=CommonLang.get("HTITLE784")%><!-- 거래명세서번호 --></th>
					<%}%>
					<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE217")%><!-- 발주수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>				
					<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE674")%><!-- 입고자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>					
					<th scope="col"><%=CommonLang.get("HTITLE676")%><!-- 계정정보 --></th>
			<% }else{ %>
				<tr>
					<th scope="col" rowspan="4">
						<a href="javascript:checkAll();" id="check_status"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></a>
					</th>
					<%if(group_mng_flag.equals("Y")){%>
						<th scope="col" ><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
					<%}else{%>
						<th scope="col"><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
					<%}%>
					<th scope="col"><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
					
					<th scope="col"><%=CommonLang.get("HTITLE280")%><!-- 총입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
			
				</tr>
				<tr>
					<%if(group_mng_flag.equals("Y")){%>
						<th scope="col" ><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
					<%}else{%>
						<th scope="col" ><%=CommonLang.get("HTITLE784")%><!-- 거래명세서번호 --></th>
					<%}%>
					<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE217")%><!-- 발주수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>
					
					<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE674")%><!-- 입고자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				
			<% }%>		
			</tr>		
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				++page_display_cnt;
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 

					<tr style="height: 50px;" align="center" bgcolor="<%=tclass%>">
		            	<td rowspan="2">
		            		<input type="hidden" name="db_buyer"		value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" />
		            		<input type="hidden" name="db_gr_no"		value="<%=CommonUtil.nvl(rowData.get("GR_NO"))%>" />
		            		<input type="hidden" name="db_gr_seq"		value="<%=CommonUtil.nvl(rowData.get("GR_SEQ"))%>" />
		            		<input type="hidden" name="db_po_no"		value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>" />
		            		<input type="hidden" name="db_po_seq"		value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>" />
		            		<input type="hidden" name="db_iv_exist"		value="<%=CommonUtil.nvl(rowData.get("IV_EXIST"))%>" />
		            		<input type="hidden" name="db_inv_no"		value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>" />
		            		<input type="hidden" name="db_inv_seq" 		value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>" />
		            		<input type="hidden" name="db_gr_item_qty"	value="<%=CommonUtil.nvl(rowData.get("GR_ITEM_QTY"))%>" />
		            		
		            		<input type="hidden" name="db_gr_qty"		value="" />
		            		<input type="hidden" name="db_gr_date"		value="<%=CommonUtil.nvl(rowData.get("GR_DATE"))%>" />
		            		<input type="hidden" name="db_buyer_item_no"		value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" />
		            		
							<input type="hidden" name="scha" value="<%=CommonUtil.nvl(rowData.get("GR_NO"))+"@@"+CommonUtil.nvl(rowData.get("GR_SEQ"))%>">
							<input type="hidden" name="st_close_flag"   value="<%=CommonUtil.nvl(rowData.get("CLOSE_FLAG"))%>">
							<input type="hidden" name="st_ar_bill_flag" value="<%=CommonUtil.nvl(rowData.get("AR_BILL_FLAG"))%>">
							<input type="hidden" name="st_ap_bill_flag" value="<%=CommonUtil.nvl(rowData.get("AP_BILL_FLAG"))%>">
							
							<input type="hidden" name="st_clsd_flag"   value="<%=CommonUtil.nvl(rowData.get("CLSD_FLAG"))%>">
		            		<input type="hidden" name="db_auto_gr"		value="<%=CommonUtil.nvl(rowData.get("AUTO_GR_FLAG"))%>" />
		            		<input type="hidden" name="db_gr_confirm1"		value="<%=CommonUtil.nvl(rowData.get("CONFIRM_USER_ID"))%>" />
		            		<input type="hidden" name="db_gr_confirm2"		value="<%=CommonUtil.nvl(rowData.get("CONFIRM_USER_ID2"))%>" />
		            		<input type="hidden" name="db_legacy_po_no"		value="<%=CommonUtil.nvl(rowData.get("PCO_LEGACY_PO_NO"))%>" />		            		
		            		<input type="hidden" name="db_gr_lock_flag" value="<%=CommonUtil.nvl(rowData.get("GR_LOCK_FLAG"))%>"/>
		            		
			            	<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>" value="<%=j%>" onClick="javascript:chkSumPrice();">
			            	<% if( ! CommonUtil.nvl(rowData.get("CONFIRM_USER_ID")).trim().equals("") ) { %>
			            	<br><b>(입고확정)</b>
			            	<% } %>		            	
			            	<% if( ! CommonUtil.nvl(rowData.get("CONFIRM_USER_ID2")).trim().equals("") ) { %>
			            	<br><b>(마감확정)</b>
			            	<% } %>
		            	</td>
					<%if(group_mng_flag.equals("Y")){%>
		                <td class="left" title="고객사">
		                    <%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>
		                </td>
					<%}else{%>
		            	<td class="left" title="주문번호">
		            		<a class="hyperLink" href="javascript:doPop('buyerMpPoOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PX_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PX_NO"))%>
		                    </a>
		                </td>
					<%}%>
		                <td class="left" title="상태">
		                    <%=CommonUtil.nvl(rowData.get("GR_STATUS"))%>
		                </td>
						<td class="left" title="발주번호">
							<a class="hyperLink" href="javascript:doPop('commonMpIvOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PO_NO")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
		                    </a>
		                </td>
		                <td class="left" title="품목코드">
			                <a class="hyperLink" href="javascript:doPop('buyerCatalogDisplayPop','<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
		                    </a>
		                </td>
		                <td class="left" title="품목명">
		                    <%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
		                </td>
		                <td class="right" title="단위">
		                    <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
		                </td>
		                <td class="right" title="단가">
		                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
		                </td>
						
		                <td class="right" title="총입고수량">
		                    <%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
		                </td>
		                <td title="입고일">
		                    <%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%>
		                </td>
		                <td title="요청자">
		                    <%=CommonUtil.nvl(rowData.get("PR_USER_NAME"))%>
		                </td>
		                <td class="left" title="협력사">
			                <a class="hyperLink" href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_CODE"))%>');">
		                    	<%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%>
		                    </a>
		                </td>
					
						<% if(sessionBudget_flag.equals("Y")){%>
				                <td class="left" title="예산부서">
				                    <%=CommonUtil.nvl(rowData.get("BUDGET_DEPT"))%>
				                </td>
						<% }%>
					</tr>
					<tr style="height: 50px;" align="center" bgcolor="<%=tclass%>">
					<%if(group_mng_flag.equals("Y")){%>
		            	<td class="left" title="주문번호" >
		            		<a class="hyperLink" href="javascript:doPop('buyerMpPoOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PX_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PX_NO"))%>
		                    </a>
		                </td>		                
					<%}else{%>
						<td class="left" title="거래명세서번호">						
	                    	<a class="hyperLink" href="javascript:doPop('commonMpIvInvoiceDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("SELLER")%>', '<%=rowData.get("INV_NO")%>', '<%=rowData.get("PO_NO")%>', '<%=rowData.get("WAREHOUSE_CODE")%>', '<%=rowData.get("PURCHASER_ID")%>');">
	                    		<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
	                    	</a>	                   
		                </td>
					<%}%>
						<td title="발주일">
		                    <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
		                </td>
						<td class="left" class="left" title="요청번호">
							<a class="hyperLink" href="javascript:doPop('commonMpIvOdrreqDetailPop', '<%=rowData.get("PR_NO")%>', '<%=rowData.get("RECV_FLAG")%>', '<%=rowData.get("BUYER")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PR_NO"))%>
		                    </a>
		                </td>
		                <td class="left" class="left" title="관리번호" id="refGrNo<%=j%>">
		                	<a class="hyperLink" href="javascript:RefPrNoSolb('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("BUYER")%>');">			                
								<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</a>
		                </td>
		                <td class="left" title="규격">
		                    <%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
		                </td>
		                <td class="right" title="발주수량">
		                    <%=CommonUtil.formatNumber(rowData.get("PO_ITEM_QTY"),true,0,3)%>
		                </td>
		                <td class="right" title="금액">
		                    <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
		                    <input type="hidden" name="st_check_item_amt" value="<%=CommonUtil.nvl(rowData.get("ITEM_AMT"))%>" />
		                </td>
						
		                <td class="right" title="입고수량">
		                    <%=CommonUtil.formatNumber(rowData.get("GR_ITEM_QTY"),true,0,3)%>
		                </td>
		                <td title="발주자">
		                    <%=CommonUtil.nvl(rowData.get("PO_CREATOR"))%>
		                </td>
		                <td title="입고자">
		                    <%=CommonUtil.nvl(rowData.get("GR_ADD_USER_NAME"))%>
		                </td>
		                <td class="left" title="요청부서">
		                	<a class="hyperLink" href="javascript:getNewDepartmentDisplayPop('<%=CommonUtil.nvl(rowData.get("CHANGE_USER_DEPT"))%>');">
		                    	<%=CommonUtil.nvl(rowData.get("REQ_DEPT_NAME"))%>
		                    </a>
		                </td>
						
						<% if(sessionBudget_flag.equals("Y")){%>
				                <td class="left" title="계정코드">
				                    <%=CommonUtil.nvl(rowData.get("ACCOUNT_NAME"))%>
				                </td>
						<% }%>
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
			
			<div class="fr">				
				<%if(getCodeGRcf == true) { %>
					<span class="btn_04">
							<a href="javascript:doAction('grConfirm','complate');"><%=CommonLang.get("HTITLE971")%><!-- 확정 --></a>							
					</span>
					<span class="btn_04">
							<a href="javascript:doAction('grConfirm','cancle');"><%=CommonLang.get("HTITLE972")%><!-- 확정취소 --></a>							
					</span>					
				<% } %>	
				<%if(getCodeDLcf == true) { %>
					<span class="btn_04">
							<a href="javascript:doAction('dlConfirm','complate');"><%=CommonLang.get("HTITLE971")%><!-- 확정 --></a>							
					</span>
					<span class="btn_04">
							<a href="javascript:doAction('dlConfirm','cancle');"><%=CommonLang.get("HTITLE972")%><!-- 확정취소 --></a>							
					</span>					
				<% } %>						
					<span class="btn_02 mr04">
						<a href="javascript:doAction('grCancel');"><%=CommonLang.get("HTITLE279")%><!-- 입고취소 --></a>
					</span>
        			<span class="btn_04">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
					</span>
					<span class="btn_04">
						<a href="javascript:doAction('erpDown');"><%=CommonLang.get("HTITLE883")%><!-- ERP 다운로드 --></a>
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

<form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
