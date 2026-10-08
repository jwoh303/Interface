<%--
**********************************************
* 메뉴 : 입고관리>입고등록
* 화면 : 입고등록
* 기능 : 입고처리 대상(납품이 완료된 발주건)을 조회하여 입고처리 한다.
* 프로그램 ID : PG_07_B_001_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<%
	//공통
	@SuppressWarnings (value="unchecked")
	Map<String,String> _sLogicMap = (Map<String,String>)request.getAttribute("sLogicInfo"); // 특수로직 조회된 결과
	
	String rowCntYn 	= "";	// 그리드 행개수
	String rowCnt 		= "";	// 그리드 default 개수
	String cardYn 		= "";	// 신용카드 사용 고객사 여부
	String deptFix 		= "";	// 요청부서 
	String prUserFix 	= "";	// 요청자만 selectbox
	String poUserFix 	= "";	// 발주자만 selectbox
		
	// 최초 화면띄울때만 db조회, 이후 조회시에는 input 값으로 가지고다님.
	if(_sLogicMap != null){
		rowCntYn 	= CommonUtil.nvl(_sLogicMap.get("ROW_CNT_YN"));
		rowCnt 		= CommonUtil.nvl(String.valueOf(_sLogicMap.get("ROW_CNT")));
		cardYn 		= CommonUtil.nvl(_sLogicMap.get("CARD_YN"));
		deptFix 	= CommonUtil.nvl(_sLogicMap.get("DEPT_FIX"));
		prUserFix 	= CommonUtil.nvl(_sLogicMap.get("PR_USER_FIX")); 
		poUserFix 	= CommonUtil.nvl(_sLogicMap.get("PO_USER_FIX"));
	} else {
		
		rowCntYn 	= CommonUtil.nvl((String)request.getParameter("st_row_cnt_yn"));
		rowCnt 		= CommonUtil.nvl((String)request.getParameter("st_row_cnt"));
		cardYn 		= CommonUtil.nvl((String)request.getParameter("st_card_yn"));
		deptFix 	= CommonUtil.nvl((String)request.getParameter("st_dept_fix"));
		prUserFix 	= CommonUtil.nvl((String)request.getParameter("st_pr_user_fix")); 
		poUserFix 	= CommonUtil.nvl((String)request.getParameter("st_po_user_fix"));
		
	}
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String)request.getParameter("onepagerow"),"");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	String st_legacy_po_no = CommonUtil.nvl((String)request.getParameter("st_legacy_po_no"),"");  
	String st_ref_pr_no = CommonUtil.nvl((String)request.getParameter("st_ref_pr_no"),"");  
	String st_buyer_item_no = CommonUtil.nvl((String)request.getParameter("st_buyer_item_no"),""); 
	
	String sessionRowCnt = CommonUtil.nvl(_sessionInfo.getRowCnt(),"10");
	
	if(onepagerow.equals("")){
		//SLOGIC-BEGIN(P07-0000004) 그리드 default 행개수
		if("Y".equals(rowCntYn)){
			onepagerow = rowCnt;
		} else {
			onepagerow = sessionRowCnt;
		}
		//SLOGIC-END
	}
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
    
    String req_dept_code = CommonUtil.nvl((String)request.getParameter("st_req_dept_code"), "");
    String req_dept_name = CommonUtil.nvl((String)request.getParameter("st_req_dept_name"), "");
    
    String sessionComCode  = _sessionInfo.getComCode();
    String sessionUserType = _sessionInfo.getUserType();
    String sessionUserId   = _sessionInfo.getUserId();
	String sessionDeptCode = _sessionInfo.getDepartment();
    String sessionDeptName = _sessionInfo.getDepartmentName();
	/*
	프로그램ID: PG_02_B_000834_008
	수정자: 현명환
	수정일: 2015.03.06
	펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000052");     
    if(deptFix.equals("Y")){
    	if (sessionUserType.equals("U") && req_dept_code.equals("")){
    		req_dept_code = sessionDeptCode;
    		req_dept_name = sessionDeptName;
    	}
    }
    
    if(sessionUserId.equals("310052") && req_dept_code.equals("")){
    	req_dept_code = sessionDeptCode;
    	req_dept_name = sessionDeptName;
	}
	/*
	장바구니 필드추가 제어 
	-TYPE1: 윈체  수량길이 필드 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000080","COL01_DATA");

	// 롯데푸드 관리번호 팝업 연결
	String p060000029 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000029","COL01_DATA"); 
    //그룹기준 사업장 조회
    boolean getCodeTGCM =  CommonUtil.getCode3CheckReturn("TGCM", sessionUserId, sessionComCode);
    String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
    String group_mng_flag = "N";

    if(getCodeTGCM == true){
 	   group_mng_flag = "Y"; 
    }
    
    boolean p070000024 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000024");
    
    //엑셀다운로드 기능 통제
    boolean p170000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P17-0000001");
    
	//차파트너스 재고입고출고 기능
    boolean p070000025 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000025");
	
	//롯데칠성 입고 결재 상신 기능
	boolean p110000005 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P11-0000005");
	
	// 입고통제 from/ to/ 메세지
	Map<String, String> p060000108 = CommonUtil.getSpecialCheckReturnMap(sessionComCode,"P06-0000108");
    String p060000108_from= ""; 
    String p060000108_to = "";
    String p060000108_msg = "";
    SimpleDateFormat sdf = new SimpleDateFormat("dd");
    Date now = new Date();
    int int_dd = Integer.parseInt(sdf.format(now)); //현재 일
    int int_from = 0; //통제 시작일
    int int_to = 0; //통제 종료일

    if(p060000108 != null){
    	p060000108_from = CommonUtil.nvl(p060000108.get("COL01_DATA"),p060000108_from); // 입고통제 from
    	p060000108_to = CommonUtil.nvl(p060000108.get("COL02_DATA"),p060000108_to);       // 입고통제 to
    	p060000108_msg = CommonUtil.nvl(p060000108.get("COL03_DATA"),p060000108_msg);       // 입고통제 msg
        int_from = Integer.parseInt(p060000108_from);
        int_to = Integer.parseInt(p060000108_to);
    }
    
    // 기존 엑셀다운로드 외 추가 양식 위한 버튼 사용(램리서치 등) : COL01-버튼명, COL02-엑셀다운로드 양식종류
    boolean p060000086 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000086");
    String p060000086_btn_name =  CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000086","COL01_DATA");
    
    // 조회조건 배송완료 체크
    String st_di_yn = CommonUtil.nvl((String) request.getParameter("st_di_yn"),"N"); // 조회조건
    // 배송완료 체크 불가 고객사리스트
    boolean p070000030 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000030");
    
    // 솔브레인 고객사인지 체크(SRM 발주 입고 등록 제어를 위해)
    boolean st_solb_buyer = CommonUtil.getCodeCheckReturn("SOLB01",sessionComCode);
    
 	// 주문통제 특수로직
  	Map<String, String> p060000101 = CommonUtil.getSpecialCheckReturnMap(sessionComCode,"P06-0000101");
 	
 	String grRole = "";
    
	// 입고통제 from/ too/ 메세지
	// 입고통제 기능 P06-0000108 과 P06-0000139 차이점
	// P06-0000108는 주문통제 일자와 무관하게 입고 통제만 관리한다.  P06-0000139은 주문통제(P06-0000101)와 연결되어 주문통제의 날짜를 공유한다. 
 	Map<String, String> p060000139 = CommonUtil.getSpecialCheckReturnMap(sessionComCode,"P06-0000139");
     String p060000101_from= ""; 
     String p060000101_to = "";    
     
     if(p060000139 != null){
    	 p060000101_from = CommonUtil.nvl(p060000101.get("COL01_DATA"),p060000101_from); // 입고통제 from
    	 p060000101_to = CommonUtil.nvl(p060000101.get("COL02_DATA"),p060000101_to);       // 입고통제 to
    	 
    	 int int_day = Integer.parseInt(sdf.format(now)); //현재 일
         int int_from_day = Integer.parseInt(p060000101_from);//통제 시작일
         int int_to_day = Integer.parseInt(p060000101_to);//통제 종료일
    	 
    	 //통제 조건
         if(int_from_day <= int_day && int_day <= int_to_day){         	
        	 grRole = "-"; // 입고(취소) 불가
         } else {
        	 grRole = "+";
         }
     }
    
    
%>
<script type="text/javascript">
var popupSel = "";
var gridIndex = 0;

// 최초 화면 함수 
function kep_onload_view(){
	
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	var today = kepGetNowTimeStr("YYYYMMDD","");
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToMonthAdd("1","M","noslash");
		to_date = today;
	}
	
	//initSearchCondition("searchForm", "st_from_date", from_date);	//발주일 시작일자
	//initSearchCondition("searchForm", "st_to_date", to_date);		//발주일 종료일자
	
	//$("#st_from_date").val( kepToMonthAdd("1","M"));
	//$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			
	$("#st_from_date").val(kepDateSlashAdd(from_date));
	$("#st_to_date").val(kepDateSlashAdd(to_date));
	
	initSearchCondition("searchForm", "st_ref_pr_no", "${st_ref_pr_no}");	// 관리번호
	
	initSearchCondition("searchForm", "st_no_type", "${st_no_type}");				// 조회번호구분코드 (IV : 송장번호, PO발주번호)
	initSearchCondition("searchForm", "st_search_no", "${st_search_no}");			// 조회번호
	initSearchCondition("searchForm", "st_user_type", "${st_user_type}");			// user_type(PR : 요청자, PO : 발주자)
	initSearchCondition("searchForm", "st_po_user_id", "${st_po_user_id}");			// user_id(ALL : 전체, session_user_id)
	
	initSearchCondition("searchForm", "st_req_dept_name", "<%=req_dept_name%>");	// 요청부서명
	initSearchCondition("searchForm", "st_req_dept_code", "<%=req_dept_code%>");	// 요청부서코드	

	//initSearchCondition("searchForm", "st_gr_date", today);		//입고일자
	
	var gr_date = "${st_gr_date}";
	if(kepIsValueNull(gr_date)){
		
		gr_date = today;
	}

	$("#st_gr_date").val(kepDateSlashAdd(gr_date));
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	kepSetCalender("st_gr_date", "", "Y","");
	
	initSearchCondition("searchForm", "onepagerow", "<%=onepagerow%>");	//페이징단위
	
	// 조회조건 배송완료 체크
	var st_di_check = eval("document.forms.searchForm.st_di_check");
	if(<%=p070000030%> == true){
		st_di_check.checked = true;
		st_di_check.disabled = true;
		$("#st_di_yn").val("Y");
	}
	
	setUserList("load");
}


function setUserList(type){

	var pr_user_fix = $("#st_pr_user_fix").val();
	var po_user_fix = $("#st_po_user_fix").val();
	$("#st_search_type").val(type);
	
	if("Y" != pr_user_fix && "Y" != po_user_fix){
		
		kepAjaxFormCall("/wmgr/getBuyerWmGrWarehousingRegUserList.do","searchForm","setUserList");
		
		/*
        var user_type = document.forms[0].st_user_type.options[document.forms[0].st_user_type.selectedIndex].value;
        document.forms[0].method = "post";
        document.forms[0].action = "/kr/customer/warehousing/user_list.jsp?st_po_user_id=< %= //po_user_id%>&st_search_type="+type;
        document.forms[0].target = "iframe_work";
        document.forms[0].submit();
        */
    }
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	var tot_cnt  =  $("#display_item_cnt").val();
	
	if(popupSel == "getRefPrNo_lotte"){
		if(eval(tot_cnt) < 2){    	
			$("input[name='db_gr_ref_pr_no']").val(text);
			$("a[name='db_gr_ref_pr_no_text']").text(text);
	    }else{
	    	$("input[name='db_gr_ref_pr_no']").eq(gridIndex).val(text);
	    	$("a[name='db_gr_ref_pr_no_text']").eq(gridIndex).text(text);
	    }
	}else{
		$("#st_req_dept_code").val(code);
		$("#st_req_dept_name").val(text);	
	}
}

var st;
//기능함수
function doAction(str) {
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
			
			initSearchCondition("searchForm", "st_req_dept_name", "");	// 요청부서명
			initSearchCondition("searchForm", "st_req_dept_code", "");	// 요청부서코드
			initSearchCondition("searchForm", "st_no_type", "");				// 조회번호구분코드 (IV : 송장번호, PO발주번호)
			initSearchCondition("searchForm", "st_search_no", "");			// 조회번호
			initSearchCondition("searchForm", "st_user_type", "");			// user_type(PR : 요청자, PO : 발주자)
			initSearchCondition("searchForm", "st_po_user_id", "");			// user_id(ALL : 전체, session_user_id)
			
			//initSearchCondition("searchForm", "st_gr_date", kepGetNowTimeStr("YYYYMMDD",""));		//입고일자
			$("#st_gr_date").val(kepGetNowTimeStr("YYYYMMDD","/"));
			
			kepSetCalender("st_gr_date", "", "Y","");
			$('#st_total_cnt').val('0');
			jspTableClean("table_list");
			
			// 조회조건 배송완료 체크
			var st_di_check = eval("document.forms.searchForm.st_di_check");
			if(<%=p070000030%> == true){
				st_di_check.checked = true;
				st_di_check.disabled = true;
			}else{
				st_di_check.checked = false;
				st_di_check.disabled = false;
			}
			
			break;
	
		case "save":	 //입고
			setInsertGr();
			break;
			
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}
			//조회그룹으로 추가.
			var st_com_code =document.forms.searchForm.st_com_code.value;
			if(st_com_code.indexOf("GROUP") >=0){
				document.forms.searchForm.st_group_info.value = st_com_code; 
			}else{
				document.forms.searchForm.st_group_info.value = "";
			}
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingRegList.do";
			document.forms.searchForm.submit();
			break;
			
		case "excelPCODown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}
			//조회그룹으로 추가.
			var st_com_code =document.forms.searchForm.st_com_code.value;
			if(st_com_code.indexOf("GROUP") >=0){
				document.forms.searchForm.st_group_info.value = st_com_code; 
			}else{
				document.forms.searchForm.st_group_info.value = "";
			}
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingPCORegList.do";
			document.forms.searchForm.submit();
			break;
		
		case "GrAppSend" : //롯데칠성 입고 결재 상신	
		
			setAppListGr(); 
		  	break;
	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage;
	
	// 조회조건 배송완료 체크
	if(document.forms.searchForm.st_di_check.checked == true){
		$("#st_di_yn").val("Y");
	}else{
		$("#st_di_yn").val("N");
	}
	
	$('#searchForm').attr("action", "/wmgr/getBuyerWmGrWarehousingRegList.do").submit();   
}

// 입고
function setInsertGr(){
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	var int_dd  = <%=int_dd%>;
	var int_from= <%=int_from%>;
	var int_to  = <%=int_to%>;
	
	
	if(cnt == 0){
		//입고 대상을 선택해 주십시요.
		alert(" <%=CommonLang.msg("MSG240")%>   ");
		return;
	}
    
	if((int_from <= int_dd) && (int_dd <= int_to)){
		//매월 00일~말일은 입고등록 기간이 아닙니다. 익월 1일부터 입고등록이 가능합니다.
		alert("<%=p060000108_msg%>");
		return;
	}
	
	var grRole = '<%=grRole%>';
	
	if(grRole == '-'){
		// 마감 기간으로 입고가 불가합니다. KEP담당자에게 문의 부탁드립니다.
		alert("<%=CommonLang.msg("MSG600")%>");
		return;		
	}
	
    // 입고일 체크
    var gr_flag = checkGrDate();
    if(!gr_flag) return;
    
  	var gr_date = $.datepicker.formatDate('yymmdd', $("#st_gr_date").datepicker("getDate"));
  	var user_id  = $("#st_user_id").val();
  	
  	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			var buyer		= $("input[name='db_buyer']").eq(k).val();
			var seller		= $("input[name='db_seller']").eq(k).val();
			var po_no		= $("input[name='db_po_no']").eq(k).val();
			var po_seq		= $("input[name='db_po_seq']").eq(k).val();
			var inv_no		= $("input[name='db_inv_no']").eq(k).val();
			var inv_seq		= $("input[name='db_inv_seq']").eq(k).val();
			var agent		= $("input[name='db_agent']").eq(k).val();
			var agent_price	= $("input[name='db_agent_price']").eq(k).val();
			var gr_qty		= $("input[name='db_gr_qty']").eq(k).val();
			var gr_ref_pr_no = $("input[name='db_gr_ref_pr_no']").eq(k).val();
			var db_auto_gr = $("input[name='db_auto_gr']").eq(k).val();
			var buyer_item_no = $("input[name='db_buyer_item_no']").eq(k).val();
			var legacy_po_no = $("input[name='db_legacy_po_no']").eq(k).val();
			var gr_lock_month = $("input[name='db_gr_lock_month']").eq(k).val();
			
			// 통제년월 vs 입력년월
			if(gr_lock_month >= gr_date.substr(0,6)){
				// 월마감이 종료되어 해당 월로 입고 불가합니다.
				alert("<%=CommonLang.msg("MSG585")%>");
				return;
			}
			
			if(<%=st_solb_buyer%>) { // 솔브레인 SRM 인터페이스 발주 입고 등록 못하도록 변경( PODT.LEGACY_PO_NO 4로 시작할 때)
				if(legacy_po_no != '' || legacy_po_no != null) {
					if(legacy_po_no.substr(0, 1) == "4" ) {
						alert("<%=CommonLang.msg("MSG581")%>");						
						return;
					}
				}
			}
			
			document.forms.searchForm.st_com_code.value = buyer;
			if(db_auto_gr == "Y"){
				//자동입고 처리가 되므로 입고처리가 불가능 합니다.
				alert("<%=CommonLang.msg("MSG241")%>");
				return;
			}
			query +=  buyer			+ "@@";
			query +=  seller		+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  user_id		+ "@@";
			query +=  agent			+ "@@";
			query +=  agent_price	+ "@@";
			query +=  gr_date		+ "@@";
			query +=  gr_qty		+ "@@";
			query +=  gr_ref_pr_no	+ "@@";
			query +=  buyer_item_no + "@@";
			query +=  "&&" ;
		}
	}
	//console.log( query );
	//선택하신 품목을 입고 처리 하시겠습니까?
    if(!confirm("입고일자 "+$("#st_gr_date").val()+" 입고일자로 입고처리하시겠습니까?")) {
        return;
    }else{
    	//차파트너스 인 경우
    	if(<%=p070000025 %> == true){
			document.searchForm.st_car_check.value = "true";
		}
    	
        document.searchForm.st_query.value  = query;
        /*
        document.forms[0].st_query.value  = query;
        document.forms[0].target = "work";
        document.forms[0].method = "post";
        document.forms[0].action = "/kr/customer/warehousing/gr_cre_insert.jsp";
        document.forms[0].submit();
        */
        kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingRegList.do","searchForm","btnSave");
    }
	
}

//롯데칠성 입고 결재 상신
function setAppListGr(){
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	
	if(cnt == 0){
		//입고 대상을 선택해 주십시요.
		alert(" <%=CommonLang.msg("MSG240")%>   ");
		return;
	}
    
    // 입고일 체크
    var gr_flag = checkGrDate();
    if(!gr_flag) return;
    
  	var gr_date = $.datepicker.formatDate('yymmdd', $("#st_gr_date").datepicker("getDate"));
  	var user_id  = $("#st_user_id").val();
  	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			var buyer		= $("input[name='db_buyer']").eq(k).val();
			var po_no		= $("input[name='db_po_no']").eq(k).val();
			var po_seq		= $("input[name='db_po_seq']").eq(k).val();
			var inv_no		= $("input[name='db_inv_no']").eq(k).val();
			var inv_seq		= $("input[name='db_inv_seq']").eq(k).val();
			
			var buyer_item_no = $("input[name='db_buyer_item_no']").eq(k).val();
			document.forms.searchForm.st_com_code.value = buyer;
			
			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  user_id		+ "@@";
			query +=  buyer_item_no + "@@";
			query +=  gr_date		+ "@@";
			query +=  "&&" ;
		}
	}
	//console.log( query );
	//선택하신 품목을 입고 처리 하시겠습니까?
    if(!confirm("<%=CommonLang.msg("MSG245")%>  ")) {
        return;
    }else{
    	//롯데칠성일 경우
    	if(<%=p110000005 %> == true){
		
        document.searchForm.st_query.value  = query;
        
        kepAjaxFormCall("/wmgr/getBuyerWmGrWarehousingRegGrAppSendList.do","searchForm","AppGrSend");
        
    	}
    }
	
}

// 팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
	case "dept": // 요청부서
		var com_code = $("#st_com_code").val();
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
		break;
		
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
		
	case "cardBillPop": // 신용카드 매출전표
		var loc = "https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no="+value1;
		var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");
		
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

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	//var msg = response.Message;

	//console.log("pMethod ==>>> " + pMethod);
	//console.log("response ==>>> " + JSON.stringify(response));
	
	if(pMethod == "btnSave"){
		//입고가 정상적으로 이루어 졌습니다.
		alert("<%=CommonLang.msg("MSG242")%> ");
		doAction("search");
	    //setQuery();   
	} else if(pMethod == "setUserList"){
		
		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
			return;
		<%
		}
		%>
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
	} else if (pMethod == "AppGrSend"){
		
		var post_url = response.APP.callback;
		var post_chk = response.APP.chk;
		var post_msg = response.APP.msg;
		
		if (post_chk == "OK"){
			window.open(post_url);
		} else {
			alert(post_msg);
		}
		
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
	
	       if(!checkboxSelect(box, j)){
				break;
	       }
	       
	       if(box.checked == false) box.checked = true;
	       
	       $("#check_status").html(check_status);
	   }
	}else{
	   for(var j = 0; j < tot_cnt; j++){
	       var box = eval("document.contentForm.checkbox" + j);
	       var check_status = "<%=CommonLang.get("HTITLE29")%>";	/* 전체 */
	
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

function checkboxSelect(checkbox, seq){
	
	var comCode = $("#st_com_code").val();
	var userId  = $("#st_user_id").val();
	
	var pouserId = $("input[name='pouser_id']").eq(seq).val();
	
	//console.log("pouserId ==>> " + pouserId);
	
	if(comCode == "KRSEAC0002"){
		if(pouserId != userId){
			//발주자가 본인이 아닐 시 입고등록 불가능합니다.
			alert("<%=CommonLang.msg("MSG243")%>");
			checkbox.checked   = false;
			return false;
		}
	}
	
	chkSumPrice();
	
	return true;
	
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


function checkGrDate(){
	var buyer_name      = $("#st_com_name").val();
    var to_day          = kepGetNowTimeStr('YYYYMMDD','');   // 현재날짜
    
	var gr_date = $.datepicker.formatDate('yymmdd', $("#st_gr_date").datepicker("getDate"));	// 선택한 입고날짜
	var p060000108 = "<%=p060000108%>";
	if (p060000108 != "null"){
		// 입고일 validation (오늘월 초일 ~ 무한)
		var valid_chk_date = kepToMonthAdd("0","M","noslash").substr(0,6)+"01";
	} else{
		// 입고일 validation (오늘월-1개월 초일 ~ 무한)
		var valid_chk_date = kepToMonthAdd("1","M","noslash").substr(0,6)+"01";
	}
	if(eval(gr_date) < eval(valid_chk_date)){
		//입고일은 이후로 입력 가능합니다. \n입고일을 다시 입력해 주시기 바랍니다.
		alert( "<%=CommonLang.msg("MSG244")%> " + kepDateSlashAdd(valid_chk_date)+" <%=CommonLang.msg("MSG386")%>");
		return false;
	}
	
    
    //var close_date = "";
    //var start_gr_date = "";
    //var close_date      = document.searchForm.st_close_date.value; 	// 해당 구매사의 마감일
    //var start_gr_date   = kepToMonthAdd("1","M","noslash");                  	// 해당 구매사의 마감일 + 1 일
    
    //gr_date = gr_date.replace(/[/]/gi,"");
/*    
	if(parseInt(gr_date) > parseInt(to_day)){
          //alert(" 입력 가능한 입고일자는 마감일 이후부터 금일까지 입니다. \n\n "+ start_gr_date +" ~ " + to_day + " 사이의 입고일을 선택해 주십시요");
          alert(" 입력 가능한 입고일자는 마감일 이후부터 금일까지 입니다. \n\n "+ start_gr_date.substr(0,4) +"년"+ start_gr_date.substr(4,2) +"월" + start_gr_date.substr(6,2) +"일 ~ " + to_day.substr(0,4) +"년"+ to_day.substr(4,2) +"월" + to_day.substr(6,2) + "일 사이의 입고일을 선택해 주십시요");
          return false;
    }
    
    if(parseInt(close_date) >= parseInt(gr_date)){
         alert(" 입력하신 입고일은 "+buyer_name+" 의 마감일보다 이전 날짜입니다. \n\n 마감일 이후로 다시 입력하시기 바랍니다. \n\n 최종 마감일은 "+ close_date.substr(0,4) +"년 "+ close_date.substr(4,2) +"월 " + close_date.substr(6,2) +"일 입니다." );
         return false;
    }
*/
    //document.forms[0].st_gr_date.value = gr_date;
    
    return true;
}

function calenderChange(gr_date, op){
	checkGrDate();
	return;
}

//관리번호 팝업 - 롯데푸드
function getRefPrNo_lotte(row, ref_no, type){
	var buyer  =  $("#st_com_code").val();
	var tot_cnt  = $("#display_item_cnt").val();
	var url = "";
	gridIndex = row;
	popupSel = "getRefPrNo_lotte";
	
	if(type =="TYPE16"){
		if(eval(tot_cnt) < 2){
			ref_no = $("input[name='db_gr_ref_pr_no']").val();
			url = "/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do";
			openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&no_remark=Y", "600,250,no");
		}else{
			ref_no = $("input[name='db_gr_ref_pr_no']").eq(row).val();
			url = "/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do";
			openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&no_remark=Y", "600,250,no");
	    }		
	}else if(type =="TYPE26"){
		if(eval(tot_cnt) < 2){
			ref_no = $("input[name='db_gr_ref_pr_no']").val();
			url = "/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do";
			openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer, "600,170,no");
				
		}else{
			ref_no = $("input[name='db_gr_ref_pr_no']").eq(row).val();
			url = "/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do";
			openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer, "600,170,no");
	    }
	}

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
	<%
	//두산중공업 펀치아웃 
	//SLOGIC-BEGIN(P06-0000052)
	if(p060000052 == true) {
	%>
		<h3><%=CommonLang.get("HTITLE669")%><!-- 입고대상현황 --></h3>
	<%}else{%>
		<h3><%=CommonLang.get("HTITLE269")%><!-- 입고등록 --></h3>
	<%}%>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">
		
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_close_date"   value ="">
		
		<input type="hidden" name="st_doc_type" id="st_doc_type" value="GR">
		<input type="hidden" name="st_car_check" id="st_car_check" value="">
		<input type="hidden" name="st_query" value ="">
			
		<input type="hidden" name="st_row_cnt_yn" 	id="st_row_cnt_yn" 	value="<%=rowCntYn%>" />
		<input type="hidden" name="st_row_cnt" 		id="st_row_cnt" 	value="<%=rowCnt%>" />
		<input type="hidden" name="st_card_yn" 		id="st_card_yn" 	value="<%=cardYn%>" />
		<input type="hidden" name="st_dept_fix" 	id="st_dept_fix" 	value="<%=deptFix%>" />
		<input type="hidden" name="st_pr_user_fix" 	id="st_pr_user_fix"	value="<%=prUserFix%>" />
		<input type="hidden" name="st_po_user_fix" 	id="st_po_user_fix"	value="<%=poUserFix%>" />
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_search_type" 	id="st_search_type"	value="" />
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<input type="hidden" name="st_di_yn"  id="st_di_yn" value="<%=st_di_yn%>">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
				<colgroup>
				    <col width="90px" />
				    <col width="230px" />
				    <col width="100px" />
				    <col width="180px" />
				    <col width="80px" />
				    <col width="160px" />
				    <col width="170px" />
				</colgroup>
				
				<tbody>
					<tr>
						<td><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></td>
						<td colspan="3">
							<input type="text"   name="st_from_date" style="width: 100px; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
				          	&nbsp;~&nbsp;
							<input type="text"   name="st_to_date" style="width: 100px; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
							
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>
							
							&nbsp;&nbsp;&nbsp;
							
							<input type="checkbox"  class="Noborder" name="st_di_check" id="st_di_check" <%=st_di_yn.equals("Y")?"checked":"" %>>&nbsp;배송완료</th>
						</td>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
					<td></td>
					<td></td>
                   </tr>
                   <tr> 
					<td><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></td>
					<td>
						<input type="text" id="st_legacy_po_no" name="st_legacy_po_no" style="width:90%" value ="<%=(st_legacy_po_no.equals("ALL") ? "" : st_legacy_po_no)%>"  onKeyDown="kepEnter();">				                  
						<input type="hidden" id="st_req_dept_name" name="st_req_dept_name" value="">
						<input type="hidden" id="st_req_dept_code" name="st_req_dept_code" value="">
						<input type="hidden" id="st_no_type" name="st_no_type" value="">
						<input type="hidden" id="st_search_no" name="st_search_no" value="">
						<input type="hidden" id="st_user_type" name="st_user_type" value="">
						<input type="hidden" id="st_po_user_id" name="st_po_user_id" value="">

						<input type="hidden" id="st_change_user_id" name="st_change_user_id" value="${sessionInfo.userId}">
					</td>
				     <td><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></td>				     
                    <td>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:90%" value ="<%=(st_ref_pr_no.equals("ALL") ? "" : st_ref_pr_no)%>"  onKeyDown="kepEnter();">
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
                    </td>
					<td><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></td>
					<td>
						<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:90%" value ="<%=(st_buyer_item_no.equals("ALL") ? "" : st_buyer_item_no)%>"  onKeyDown="kepEnter();">
					</td>
				<%
				}else{
				%>		
						<td><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></td>
						<td>
		                    <input type="hidden" id="st_legacy_po_no" name="st_legacy_po_no" value="">
		                    <input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no" value="">
		                    <input type="hidden" id="st_change_user_id" name="st_change_user_id" value="">
							<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:80%" value =""  onKeyDown="kepEnter();">
						</td>
					</tr>
					<tr>
						<td><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></td>
						<td>
							<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
			            <% 
			                if(("Y".equals(deptFix) && "U".equals(sessionUserType)) || "KRHONG0020".equals(sessionComCode)){
			                } else {
			            %>
				            <a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>        
			            <%
			                }
			            %>
						</td>
						<td>
							<select id="st_no_type" name="st_no_type" width="80px;">
								<option value = "IV"><%=CommonLang.get("HTITLE271")%><!-- 송장번호 --> </option>
								<option value = "PO"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></option>
								<option value = "DESC"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
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
				            </select></td>
				        <td>
				            <select id="st_po_user_id" name="st_po_user_id" >
				                <option value="" >---<%=CommonLang.get("HTITLE29")%><!-- 전체 -->----</option>
				                <!-- 
				                	추후 아래메소드가지고 select 만들기
				                	CommonUtil.getCodeComboQueryIdList 
				                -->
				           
				            </select>
				        </td>
				<%  }   %>
				<%
				}
				%>				
				    </tr>
				<%if(group_mng_flag.equals("Y")){ %>
				<tr>
					<td><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></td>
					<td>
						<select name="st_com_code" id="st_com_code" style="width:90%;height:20px;" onchange="buyerChange()">
					      	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					    </select> 
					</td>
					<td>
					</td>										
				</tr>
				<%}else{ %>
						<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
				<%} %>
				</tbody>
			</table>
		</div> 		
 		<span class="fl"> 	
       
 			<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
      		<select name="onepagerow">
				<option value = "10" >10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" >20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" >30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" >40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" >50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "70" >70<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "100" >100<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "200" >200<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "300" >300<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "500" >500<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
			<%
			//두산중공업 펀치아웃 
			//SLOGIC-BEGIN(P06-0000052)
			if(!p060000052 == true) {
			%>
				<img src="/resources/images/date_txt.gif" alt="입고일자" style="padding-top:3px;"/>
				<input type="text" name="st_gr_date" size="11" id="st_gr_date" class="input_type_text"  value="" readonly>
			<%} %>			
      	</span>
      	<%if(grRole.equals("-") && grRole != null) { %>
      	<span class="text03">&nbsp;&nbsp;※ <%=CommonLang.msg("MSG600")%></span> <!-- 마감 기간으로 입고가 불가합니다. -->
      	<% } %> 
      	     
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
 	
		<table id="table_list"  class="cont_t_list02" style="width:100%;">
			<colgroup>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
						  <col width="7%"/>
					      <col width="8%"/>
					      <col width="11%"/>
					      <col width="*"/>
					      <col width="8%"/>
					      <col width="8%"/>
					      <col width="6%"/>
					      <col width="6%"/>
					      <col width="11%"/>
					      <col width="9%"/>
					      <col width="4%"/>
				<%}else{%>
					<% if(!"Y".equals(cardYn)) { %>
					      <col width="3%"/>
					      <col width="8%"/>
					      <col width="8%"/>
					      <col width="12%"/>
					      <col width="*"/>
					      <col width="7%"/>
					      <col width="6%"/>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<col width="8%"/>
					<% } %>
					      <col width="7%"/>
					      <col width="7%"/>
					      <col width="9%"/>
					      <col width="4%"/>
					<% } else { %>
						  <col width="3%"/>
						  <col width="7%"/>
					      <col width="8%"/>
					      <col width="8%"/>
					      <col width="*"/>
					      <col width="8%"/>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<col width="6%"/>
					<% } %>
					      <col width="8%"/>
					      <col width="6%"/>
					      <col width="6%"/>
					      <col width="11%"/>
					      <col width="9%"/>
					      <col width="4%"/>
					<% } %>
				<%}%>
	        </colgroup>
	        <thead>
				<tr>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(!p060000052 == true) {
				%>
					<th scope="col" rowspan="2">
						<a href="javascript:checkAll();" id="check_status"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></a>
					</th>
			<% } %>
			<%if(group_mng_flag.equals("Y")){ %>
					<th scope="col" ><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
			<%}else{ %>
					<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
			<%} %>
					<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE217")%><!-- 발주수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
					<th scope="col"><%=CommonLang.get("HTITLE639")%><!-- 길이 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE263")%><!-- 송장수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE274")%><!-- 입고가능수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
					<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
				<% if("Y".equals(cardYn)) { %>	
					<th scope="col"><%=CommonLang.get("HTITLE644")%><!-- 카드여부 --></th>
				<% } %>
				</tr>
				<tr>
				<%if(group_mng_flag.equals("Y")){ %>
					<th scope="col"><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
				<%} %>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
					<th scope="col"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
				<%}else{%>
					<th scope="col"><%=CommonLang.get("HTITLE271")%><!-- 송장번호 --></th>
				<%}%>
					<th scope="col"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
					<th scope="col"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE273")%><!-- 기입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				<% if("Y".equals(cardYn)) { %>	
					<th scope="col"><%=CommonLang.get("HTITLE645")%><!-- 카드승인번호 --></th>
				<% } %>
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
	            <tr align="center" bgcolor="<%=tclass%>">
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(!p060000052 == true) {
				%>				
	            	<td rowspan="2" style="border-bottom:0px;">	            		
		            	<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>" value="<%=j%>" onClick="javascript:checkboxSelect(this, <%=j%>);">
	            	</td>
	            	<%if(group_mng_flag.equals("Y")){ %>
	            		<td class="left" title="고객사" >
	            	<%}else{ %>
	            		<td class="left" title="주문번호" rowspan="2">
	            	<%}%>
	            <%}else{ %>
	            		<td class="left" title="주문번호" rowspan="2">
		            		<input type="hidden" name="checkbox<%=j%>" 	value="<%=j%>" />

	            <%} %>		            
	            		<input type="hidden" name="db_buyer"		value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" />
	            		<input type="hidden" name="db_buyer_item_no"		value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" />
	            		<input type="hidden" name="db_seller"		value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>" />
	            		<input type="hidden" name="db_po_no"		value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>" />
	            		<input type="hidden" name="db_po_seq"		value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>" />
	            		<input type="hidden" name="db_inv_no"		value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>" />
	            		<input type="hidden" name="db_inv_seq"		value="<%=CommonUtil.nvl(rowData.get("INV_SEQ"))%>" />
	            		<input type="hidden" name="db_agent" 		value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>" />
	            		<input type="hidden" name="db_agent_price"	value="<%=CommonUtil.nvl(rowData.get("AGENT_PRICE"))%>" />
	            		<input type="hidden" name="db_gr_qty"		value="<%=CommonUtil.nvl(rowData.get("AVAIL_GR_QTY"))%>" />
	            		<input type="hidden" name="db_auto_gr"		value="<%=CommonUtil.nvl(rowData.get("AUTO_GR_FLAG"))%>" />
	            		<input type="hidden" name="db_legacy_po_no"		value="<%=CommonUtil.nvl(rowData.get("PCO_LEGACY_PO_NO"))%>" />
	            		<!--
			            	// SM00007  2014.05.12장민기 
							// 작업요청자:김연희(서비스비즈사업팀) 
							// 요청내역 : 씨클라우드호텔(KRSEAC0002) 입고실적등록 화면에서 발주자가 본인인 경우만 실적등록할 수 있도록 개선 요청
						-->
	            		<input type="hidden" name="pouser_id" value ="<%=CommonUtil.nvl(rowData.get("PURCHASER_ID"))%>" />
	            		<input type="hidden" name="available_gr_qty" value="<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>" />
	            		<input type="hidden" name="input_gr_qty" value="<%=CommonUtil.nvl(rowData.get("INV_QTY"))%>" />
	            		<input type="hidden" name="db_gr_lock_month" value="<%=CommonUtil.nvl(rowData.get("GR_LOCK_MONTH"))%>"/>
	            		<%if(group_mng_flag.equals("Y")){ %>
		            		<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>
	                    <%}else{ %>
		            		<a class="hyperLink" href="javascript:doPop('buyerMpPoOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PX_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PX_NO"))%>  
		                    	<% if(!p060000052 == true) { if(CommonUtil.nvl(rowData.get("SND_CHK")).equals("S")){%>
		                    		 <p>( <%=CommonLang.get("HTITLE941")%> ) </p><!-- 상신중 -->
		                    		 <% } else if (CommonUtil.nvl(rowData.get("SND_CHK")).equals("T")){ %>
		                    		 <p>( <%=CommonLang.get("HTITLE195")%> ) </p><!-- 주문결재중-->
		                    	<% }} %>
		                    </a>
	                    <%} %>
	                </td>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>				
					<td class="left" title="발주번호">						
	                    <%=CommonUtil.nvl(rowData.get("PCO_LEGACY_PO_NO"))%>
	                </td>
				<%}else{%>
					<td class="left" title="발주번호">
						<a class="hyperLink" href="javascript:doPop('commonMpIvOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PO_NO")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
	                    </a>
	                </td>
				<%}%>
	                <td class="left" title="품목코드">
		                <a class="hyperLink" href="javascript:doPop('buyerCatalogDisplayPop','<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
	                    </a>
	                </td>
	                <td class="left" title="품목명">
	                    <%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
	                </td>
	                <td class="right" title="발주수량">
	                    <%=CommonUtil.formatNumber(rowData.get("PO_QTY"),true,0,3)%> <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
	                </td>
	                <td class="right" title="단가">
	                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
	                </td>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
		                <td class="right" title="길이">
		                    <%=CommonUtil.formatNumber(rowData.get("SIZE_LEN"),true,0,3)%>
		                </td>
					<%    
					}
					%>					
	                <td class="right" title="송장수량">
	                    <%=CommonUtil.formatNumber(rowData.get("INV_QTY"),true,0,3)%>
	                </td>
	                <td class="right" title="입고가능수량">
	                    <%=CommonUtil.formatNumber(rowData.get("AVAIL_GR_QTY"),true,0,3)%>
	                </td>
	                <td class="left" title="협력사">
		                <a class="hyperLink" href="javascript:doPop('agentDisplayPop','<%=rowData.get("AGENT_CODE")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%>
	                    </a>
	                </td>
	                <td class="center" title="요청자" rowspan="2">
	                	<%=CommonUtil.nvl(rowData.get("PR_USER_NAME"))%>
	                </td>
	                <% if("Y".equals(cardYn)) { %>	
						<td title="카드여부">
		                    <%=CommonUtil.nvl(rowData.get("CARD_USE_FLAG"))%>
		                </td>
					<% } %>
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
				<%if(group_mng_flag.equals("Y")){ %>
					<td class="left" class="left" title="요청번호">
	            		<a class="hyperLink" href="javascript:doPop('buyerMpPoOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PX_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PX_NO"))%>
	                    </a>
		             </td>
				<%} %>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
					<td class="left" class="left" title="요청번호">
	                    <%=CommonUtil.nvl(rowData.get("PCO_REF_PR_NO"))%>
	                </td>
				<%}else{%>
					<td class="left" class="left" title="송장번호">
						<a class="hyperLink" href="javascript:doPop('commonMpIvInvoiceDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("SELLER")%>', '<%=rowData.get("INV_NO")%>', '<%=rowData.get("PO_NO")%>', '<%=rowData.get("WAREHOUSE_CODE")%>', '<%=rowData.get("PURCHASER_ID")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
	                    </a>
	          		<input type="hidden" name="st_image_key_sign" id="st_image_key_sign" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_SIGN"))%>">
	          		<input type="hidden" name="st_image_key_inv" id="st_image_key_inv" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_INV"))%>">
					<%    
					if(p060000080.equals("TYPE3")) {
		          		if(!"".equals(rowData.get("IMAGE_KEY_INV"))||!"".equals(rowData.get("IMAGE_KEY_SIGN"))) {
		          %>
						<a href="javascript:doPop('attach',<%=j%>);"><img src="/resources/images/disk_on.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
		          <%
			          	}else{
		          %>
						<img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0">
		          <%
			          	}
		          		
		          %> 	
						<%=rowData.get("PARCEL_INFO")%>
		          <%
		          	}
		          %>
	                </td>
				<%}%>
				<%if(p060000029.equals("TYPE16")){%>
					<td class="left" class="left" title="관리번호">
						<a class="hyperLink"  id="db_gr_ref_pr_no_text" name="db_gr_ref_pr_no_text" href="javascript:getRefPrNo_lotte('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=p060000029%>');">
	                    	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
	                    </a>
	                    <input type="hidden" name="db_gr_ref_pr_no"	 value="<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>" />
	                </td>
				<%}else if(p060000029.equals("TYPE26")){%>
					<td class="left" class="left" title="관리번호">
						<a class="hyperLink"  id="db_gr_ref_pr_no_text" name="db_gr_ref_pr_no_text" href="javascript:getRefPrNo_lotte('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=p060000029%>');">
	                    	<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
	                    </a>
	                    <input type="hidden" name="db_gr_ref_pr_no"	 value="<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>" />
	                </td>
				<%}else{%>
					<td class="left" class="left" title="관리번호">
						<input type="hidden" name="db_gr_ref_pr_no"		value="<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>" />
	                    <%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
	                </td>
				<%}%>
	                <td class="left" title="규격">
	                    <%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
	                </td>
	                <td title="발주일">
	                    <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
	                </td>
	                <td class="right" title="금액">
	                    <%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%>
	                    <input type="hidden" name="st_check_item_amt" value="<%=CommonUtil.nvl(rowData.get("PO_AMT"))%>" />
	                </td>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
		                <td class="right" title="수량">
		                    <%=CommonUtil.formatNumber(rowData.get("SIZE_QTY"),true,0,3)%>
		                </td>
					<%    
					}
					%>		
	                <td class="right" title="기입고수량">
	                    <%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
	                </td>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>		
	                <td title="요청자">
	                    <%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%>
	                </td>
				<%}else{%>
	                <td title="발주자">
	                    <%=CommonUtil.nvl(rowData.get("PO_CREATOR"))%>
	                </td>
				<%}%>
	                <td class="left" title="요청부서">
	                	<a class="hyperLink" href="javascript:doPop('newDepartmentDisplayPop','<%=rowData.get("REQ_DEPT")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("REQ_DEPT_NAME"))%>
	                    </a>
	                </td>
	                <% if("Y".equals(cardYn)) { %>	
						<td title="카드승인번호">
							<a class="hyperLink" href="javascript:doPop('cardBillPop','<%=CommonUtil.nvl(rowData.get("CARD_CONFIRM_NO"))%>');">
		                    	<%=CommonUtil.nvl(rowData.get("CARD_CONFIRM_NO"))%>
		                    </a>
		                </td>
					<% } %>
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
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {					
				%>
					<div class="fr">
						<span class="btn_04">
							<a href="javascript:doAction('excelPCODown');"><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></a>
						</span>	
		            </div>	
		            
				<% //롯데칠성 입고 결재 상신
				} else if(p110000005){%>
				  	<div class="fr">
						<span class="btn_04">
							<a href="javascript:doAction('GrAppSend');"><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></a>
						</span>	
		            </div>	
				
				<% }else{ %>
		        	<div class="fl">
		        		<%
		        		//엑셀다운로드 기능 통제
		        		if(p170000001 == false){
		        		%>
		        			<span class="btn_04 mr04">
								<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
							</span>
						<%
						}
		        		%>
		        		
		        		<%    
						if(p060000086) { // 램리서치 엑셀 다운로드 양식 별도
						%>
							<span class="btn_04 mr04">
								<a href="javascript:doAction('excelDown');"><%=p060000086_btn_name%><!-- 특수로직 내 버튼명 --></a>
							</span>
						<%}%>
					</div>
					<%if(p070000024 == false){%>
					<div class="fr">
						<span class="btn_04">
							<a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE270")%><!-- 입고 --></a>
						</span>	
		            </div>
		            <%}%>
				<%} %>
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
