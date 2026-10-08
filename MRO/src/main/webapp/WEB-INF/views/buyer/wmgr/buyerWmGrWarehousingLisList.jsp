<%--
**********************************************
* 메뉴 : 입고관리>입고조회
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
    
    if(sessionComCode.equals("KRHONG0020")){
    	
    	if(req_dept_code.equals("")){
    		req_dept_code = sessionDeptCode;
    	}
    	
    	if(req_dept_name.equals("")){
    		req_dept_name = sessionDeptName;
    	}
    	
    	if(dept_type.equals("")){
    		dept_type = "PO";
    	}
    	
    } else {
    	if(dept_type.equals("")){
    		dept_type = "PR";
    	}
    }

    if(deptFix.equals("Y")){
    	if(sessionUserType.equals("U") && req_dept_code.equals("")){
    		req_dept_code = sessionDeptCode;
    		req_dept_name = sessionDeptName;
    	}
    }
    
    String p060000029 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000029","COL01_DATA");
    String p070000011 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000011","COL01_DATA"); // 엑셀다운로드 유형
    String p070000017 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000017","COL01_DATA");
    String p070000022 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000022","COL01_DATA"); // 거래명세서번호 링크 > 고객사 거래명세서 상세팝업 연결 
	/*
		프로그램ID: PG_02_B_000834_008
		수정자: 현명환
		수정일: 2015.03.06
		펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000052");     
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
    
    // 고객사 입고관리 화면 내 입고등록, 입고취소 버튼 숨김
    boolean p070000024 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000024");
    
    //엑셀다운로드 기능 통제
    boolean p170000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P17-0000001");
    
	//차파트너스 재고입고출고 기능
    boolean p070000025 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P07-0000025");
	
 	// 입고취소통제 from/ to/ 메세지
 	Map<String, String> p060000109 = CommonUtil.getSpecialCheckReturnMap(sessionComCode,"P06-0000109");
    String p060000109_from= "";
    String p060000109_to = "";
    String p060000109_msg = "";
    SimpleDateFormat sdf = new SimpleDateFormat("dd");
    Date now = new Date();
    int int_dd = Integer.parseInt(sdf.format(now)); //현재 일
    int int_from = 0; //통제 시작일
    int int_to = 0; //통제 종료일

    if(p060000109 != null){
     	p060000109_from = CommonUtil.nvl(p060000109.get("COL01_DATA"),p060000109_from); // 입고취소통제 from
     	p060000109_to = CommonUtil.nvl(p060000109.get("COL02_DATA"),p060000109_to);       // 입고취소통제 to
     	p060000109_msg = CommonUtil.nvl(p060000109.get("COL03_DATA"),p060000109_msg);       // 입고취소통제 msg
        int_from = Integer.parseInt(p060000109_from);
        int_to = Integer.parseInt(p060000109_to);
    }
    //SLOGIC-BEGIN(P06-0000098) 관리번호별 집계화면 활성화 기능
    boolean p060000098 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000098");
    
 // 주문통제 특수로직
   	Map<String, String> p060000101 = CommonUtil.getSpecialCheckReturnMap(sessionComCode,"P06-0000101");
  	
  	String grRole = "";
     
 	// 입고통제 from/ too/ 메세지
 	// 입고통제 기능 P06-0000109 과 P06-0000139 차이점
 	// P06-0000109는 주문통제 일자와 무관하게 입고 통제만 관리한다.  P06-0000139은 주문통제(P06-0000101)와 연결되어 주문통제의 날짜를 공유한다. 
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
	initSearchCondition("searchForm", "st_ref_pr_no_text", "${st_ref_pr_no_text}");
	
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
	if(value4=="dept"){
		$("#st_req_dept_code").val(value1);
		$("#st_req_dept_name").val(value2);
	}else{
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
			initSearchCondition("searchForm", "st_ref_pr_no_text", "");	// 관리번호
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
		
		case "detailSearch":	//상세조회
			doDetailSearchPop();
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
			
			if(type == "DEFAULT"){
				$("#st_excel_type").val("");
			}else{
				$("#st_excel_type").val(type);
			}
			
			
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingLisList.do";
			document.forms.searchForm.submit();
	// 		$('#searchForm').attr("action", "/wmgr/excelBuyerWmGrWarehousingRegList.do").submit();
			break;
			
		case "excelDownClose": // 마감다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}
			$("#st_close_excel_type").val("");
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingLisCloseList.do";
			document.forms.searchForm.submit();
			break;
			
		case "excelDownClose1": // 마감다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}
			$("#st_close_excel_type").val("TYPE2");
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingLisCloseList.do";
			document.forms.searchForm.submit();
			break;
			
		case "excelPCODown": // 마감다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
				//조회기간을 6개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG494")%>");
				return;
			}
			$("#st_excel_type").val("TYPE3");
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingLisList.do";
			document.forms.searchForm.submit();
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
	$('#searchForm').attr("action", "/wmgr/getBuyerWmGrWarehousingLisList.do").submit();   
}

// 입고취소
function setGrCancel(){
	
	var tot_cnt = $("#display_item_cnt").val();
	var query   = "";
	var cnt     = getCheckedRowCount("checkbox");
	
	var int_dd  = <%=int_dd%>;
	var int_from= <%=int_from%>;
	var int_to  = <%=int_to%>;
	
	if(cnt == 0){
		//입고 취소하실 목록을 선택해 주십시요.
		alert("<%=CommonLang.msg("MSG247")%>   ");
		return;
	}
	
	if((int_from <= int_dd) && (int_dd <= int_to)){
		//마감이 진행중인 관계로 입고취소가 불가능합니다. 코리아이플랫폼 담당자에게 연락 바랍니다.
		alert("<%=p060000109_msg%>");
		return;
	}
	
	var grRole = '<%=grRole%>';
	
	if(grRole == '-'){
		// 마감 기간으로 입고취소가 불가합니다. KEP담당자에게 문의 부탁드립니다.
		alert("<%=CommonLang.msg("MSG601")%>");
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
			var po_no		= $("input[name='db_po_no']").eq(k).val();
			var po_seq		= $("input[name='db_po_seq']").eq(k).val();
			var iv_exist	= $("input[name='db_iv_exist']").eq(k).val();
			var inv_no		= $("input[name='db_inv_no']").eq(k).val();
			var inv_seq		= $("input[name='db_inv_seq']").eq(k).val();
			var gr_item_qty	= $("input[name='db_gr_item_qty']").eq(k).val();
			var buyer_item_no = $("input[name='db_buyer_item_no']").eq(k).val();
			
			// BUYER + USER_ID + GR_NO + GR_SEQ + PO_NO + PO_SEQ + IV_EXIST +INV_NO + INV_SEQ + GR_QTY
			query +=  com_code		+ "@@";
			query +=  user_id		+ "@@";
			query +=  gr_no			+ "@@";
			query +=  gr_seq		+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  iv_exist		+ "@@";
			query +=  inv_no		+ "@@";
			query +=  inv_seq		+ "@@";
			query +=  gr_item_qty	+ "@@";
			query +=  buyer_item_no	+ "@@";
			query +=  "^||^" ;
		}
	}
	
	//console.log("query ==>>> " + query);
	//선택하신 품목을 입고 취소처리 하시겠습니까?
    if(!confirm(" <%=CommonLang.msg("MSG246")%> ")) {
        return;
    }else{
    	//차파트너스 인 경우
    	if(<%=p070000025 %> == true){
			document.searchForm.st_car_check.value = "true";
		}
        document.searchForm.st_query.value  = query;
        
        kepAjaxFormCall("/wmgr/saveBuyerWmGrWarehousingLisList.do","searchForm","btnSave");
        
    }
}

//팝업 함수호출
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
		
	case "cardBillPop": // 신용카드 매출전표
		var loc = 'https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no='+value1;
		var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");
		
		break;
	case "attach"://파일 첨부(등록)
		var type="IV";
		var viewType="R";
		var st_image_key_inv =  $("input[name=st_image_key_inv]").eq(value1).val();
		var st_image_key_sign =  $("input[name=st_image_key_sign]").eq(value1).val();
		var st_buyer =  "";
		var st_inv_no =  "";
		if(st_image_key_inv != ""){
			popupSel = "attach";
			openSearchPopupName('/common/imageFileUploadPop.do','?DOC_NO='+st_image_key_inv+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no','attach');// 파일첨부				
		}
		if(st_image_key_sign != ""){
			popupSel = "attachSign";
			openSearchPopupName('/common/imageFileUploadPop.do','?DOC_NO='+st_image_key_sign+'&TYPE='+type+'&viewType='+viewType+'&BUYER='+st_buyer+'&INVOICE='+st_inv_no,'500,430,no','attachSign');// 파일첨부				
		}
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

function cardBillPop(bill_no){
	var loc = 'https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no='+bill_no;
	var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");
}


//상세조회 팝업창
function doDetailSearchPop(){
	
	var url = "/wmgr/showBuyerWmGrWarehousingLisDetailSearch.do";
	var option = buildOption('500,240,no'); //width, height, scroll
	
	var win = window.open(url, "buyerWmGrWarehousingLisDetailSearch", option);
	//win.location.href = url;
	win.focus();
	
}

function setSearchDetail(buyer_item_no, desc_spec, agent) {
    document.searchForm.st_search_buyer_item_no.value = buyer_item_no;
    document.searchForm.st_search_desc_spec.value     = desc_spec;
    document.searchForm.st_search_agent.value         = agent;
    doAction('search');
}

//동부기술원 관련  PG_06_B_006_01
function getKRDONG0121() { 
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();

	openSearchPopup("/mpso/showBuyerMpSoBudgetItmPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,400,no");
}

function setDong0121(ref_no, row) {
	$("#st_ref_pr_no").val(ref_no);
}

//FAG 관련  PG_06_B_006_03
function getKRFagKorea() { 
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();
	
	openSearchPopup("/mpso/showBuyerMpSoFagkbcAccountPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,400,no");
}

function setKRFagKorea(ref_no, row){
	$("#st_ref_pr_no").val(ref_no);
}

//INA 관련 PG_06_B_006_04
function getInaKorea() {
	
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();
	
	openSearchPopup("/mpso/showBuyerMpSoConsmAccountPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,500,no");
}

function setInaKorea(ref_no, row) {
	$("#st_ref_pr_no").val(ref_no);
}

//경동보일러,경동정밀 관련 PG_06_B_006_05
function getKyungDong() {
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();
	
	openSearchPopup("/mpso/showBuyerMpSoKyongDongCostCenterPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,500,no");
}

function setKyungDong(ref_no, row){
	$("#st_ref_pr_no").val(ref_no);
}


//동일방직 하이트진로이천공장현장소모품팀 PG_06_B_006_06
function getDongIl() {
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();
	
	openSearchPopup("/mpso/showBuyerMpSoHiteJinroSiteConsmTeamPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,500,no");
}

function getHongik(){ 
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();

	openSearchPopup("/mpso/showBuyerMpSoHongikAccntngItemPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,500,no");
}

function setHongik(ref_no, row,ref_no_text){
	$("#st_ref_pr_no").val(ref_no);
	$("#st_ref_pr_no_text").val(ref_no_text);
}

//--코오롱글로벌CostCenter  PG_06_B_006_08
function getKRINKT0001(){
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();

	openSearchPopup("/mpso/showBuyerMpSoKolonGlobalCostCenterPop.do", "?open=Y&st_buyer="+buyer+"&st_ref_no="+ref_no, "500,500,no");
}

function setKRINKT0001(ref_no, row){
	$("#st_ref_pr_no").val(ref_no);
}

//(주)게스템프 카테크
function getKRGEST0001(){
	var buyer  = $("#st_com_code").val();
	var ref_no = $("#st_ref_pr_no").val();

	openSearchPopup("/mpso/showBuyerMpSoGuessTempCarTechCostCenterPop.do", "?open=Y&st_ref_no="+ref_no+"&st_type=M014&st_buyer="+buyer, "1000,500,no");
}

function setKRGEST0001(type, ref_no, row){	
	$("#st_ref_pr_no").val(ref_no);
	$("#st_ref_pr_no_text").val(ref_no);
}

//우송대학교 실습재료인계인수대장 출력
function WoosPracticeView(){
	
	var buyer 					= $("#st_com_code").val();
	var search_desc_spec 		= $("#st_search_desc_spec").val();
	var search_buyer_item_no	= $("#st_search_buyer_item_no").val();
	var fromDate 				= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 					= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var search_agent 			= $("#st_search_agent").val();
	var ref_pr_no 				= $("#st_ref_pr_no").val();
	var req_dept_code 			= $("#st_req_dept_code").val();
	var no_type 				= $("#st_no_type").val();
	var search_no 				= $("#st_search_no").val();
	var user_type 				= $("#st_user_type").val();
	var po_user_id 				= $("#st_po_user_id").val();
	var dept_type				= $("#st_dept_type").val();
	
	var param = "["+buyer+"]["+fromDate+"]["+toDate+"]["+search_no+"]["+no_type+"]["+ref_pr_no+"]["+po_user_id+"]["+user_type+"]["+req_dept_code+"]["+dept_type+"]["+search_buyer_item_no+"]["+search_desc_spec+"]["+search_agent+"]";
	reportPostOpen("RD_06_S_003_42", param);
	
}

// 마감실적조회
function grListPop(){
	
	var buyer 					= $("#st_com_code").val();
	var search_desc_spec 		= $("#st_search_desc_spec").val();
	var search_buyer_item_no	= $("#st_search_buyer_item_no").val();
	var fromDate 				= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 					= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var search_agent 			= $("#st_search_agent").val();
	var ref_pr_no 				= $("#st_ref_pr_no").val();
	var req_dept_code 			= $("#st_req_dept_code").val();
	var no_type 				= $("#st_no_type").val();
	var search_no 				= $("#st_search_no").val();
	var user_type 				= $("#st_user_type").val();
	var po_user_id 				= $("#st_po_user_id").val();
	var dept_type				= $("#st_dept_type").val();
	
	var param = "["+buyer+"]["+fromDate+"]["+toDate+"]["+search_no+"]["+no_type+"]["+ref_pr_no+"]["+po_user_id+"]["+user_type+"]["+req_dept_code+"]["+dept_type+"]["+search_buyer_item_no+"]["+search_desc_spec+"]["+search_agent+"]";
	//var param = "["+search_desc_spec+"]["+search_buyer_item_no+"]["+fromDate+"]["+toDate+"]["+search_agent+"]["+ref_pr_no+"]["+req_dept_code+"]["+no_type+"]["+search_no+"]["+user_type+"]["+po_user_id+"]["+buyer+"]["+dept_type+"]";
	
	reportPostOpen("RD_06_S_003_40", param);
}

// 출력
function SheetWin(){

    var fromDate	= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate		= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var buyer		= $("#st_com_code").val();
	var date_type  = "GR"; // 입고일자 조회
	var user_name	= $("#st_user_name").val();
	
	var param = "["+fromDate+"]["+toDate+"]["+date_type+"]["+buyer+"]["+user_name+"]";
	reportPostOpen("RD_06_S_003_43", param);
	
}

// FAG 마감거래명세서 선택된 값만 출력
function CloseGrSheetFAGSel(){
	
	var query		= "";
	var tot_cnt		= $("#display_item_cnt").val();
	var cnt			= getCheckedRowCount("checkbox");

	var buyer		= $("#st_com_code").val();
	//var buyer_name	= $("#st_com_name").val();
	var user_id		= $("#st_user_id").val();
	var user_name	= $("#st_user_name").val();

	var req_dept_code	= $("#st_req_dept_code").val();
	var fromDate	= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate		= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	
	if(cnt == 0){
		//거래명세서를 생성할 목록을 선택 하세요.
		alert(" <%=CommonLang.msg("MSG254")%> ");
		return;
	}
	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			
			query += $("input[name='scha']").eq(k).val();
			query += "@@";
			query += "||";

		}
	}
	var param = "["+req_dept_code+"]["+user_id+"]["+user_name+"]["+buyer+"]["+fromDate+"]["+toDate+"]["+query+"]";
	
	if(buyer=="KRLOTT0015" || buyer=="KRLOTT0095" ){ // 롯데푸드 파스퇴르
		reportPostOpen("RD_06_S_003_47", param);
	}else if(buyer=="KRHUON0001" || buyer=="KRSIEM0004" || buyer=="KRSIEM0014" || buyer=="KRSIEM0006"
			|| buyer=="KRHUME0001"|| buyer=="KRUONS0001"|| buyer=="KRBIOT0004" || buyer=="KRLAND0003" 
			|| buyer=="KRKG-E0006" || buyer=="KRWHAN0004" || buyer=="KRHANW0082" || buyer=="KRHANH0009"
			|| buyer=="KRHANH0008" || buyer=="KRHANW0087" || buyer=="KRHANW0088" || buyer=="KRHANW0089"
			|| buyer=="KRHANW0090" || buyer=="KRHANW0091" || buyer=="KRHANW0125" || "<%=p070000011%>" == "TYPE5"){ // 기본 마감거래명세서 양식과 동일(RD_06_S_003_39)
		reportPostOpen("RD_06_S_003_48", param);
	}else{
		reportPostOpen("RD_06_S_003_32", param);
	}
	
	
}

// 마감거래명세서 출력 FAG korea경우
function CloseGrSheetFAG(){
	
	var fromDate 		= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 			= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var req_dept_code 	= $("#st_req_dept_code").val();
	var buyer 			= $("#st_com_code").val();
	var ref_pr_no 		= $("#st_ref_pr_no").val();
	var po_no 			= $("#st_search_no").val();
	var po_user_id 		= $("#st_po_user_id").val();
	var user_id			= $("#st_user_id").val();
	var user_name		= $("#st_user_name").val();
	
	var param = "";
		
	if(buyer == "KRSCHA0001"){
		param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+user_id+"]["+user_name+"]";
		reportPostOpen("RD_06_S_003_34", param);
	} else {
		param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]";
		reportPostOpen("RD_06_S_003_33", param);
	}
}
//FAG 마감거래명세서 선택된 값만 출력(금액없음) TYPE8
function CloseGrSheetFAGNoAmtSel(){
	
	var query		= "";
	var tot_cnt		= $("#display_item_cnt").val();
	var cnt			= getCheckedRowCount("checkbox");
	var buyer		= $("#st_com_code").val();
	var user_id		= $("#st_user_id").val();
	var user_name	= $("#st_user_name").val();
	var req_dept_code	= $("#st_req_dept_code").val();
	var fromDate	= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate		= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	
	if(cnt == 0){
		//거래명세서를 생성할 목록을 선택 하세요.
		alert(" <%=CommonLang.msg("MSG254")%> ");
		return;
	}
	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			query += $("input[name='scha']").eq(k).val();
			query += "@@";
			query += "||";
		}
	}
	var param = "["+req_dept_code+"]["+user_id+"]["+user_name+"]["+buyer+"]["+fromDate+"]["+toDate+"]["+query+"]";
	reportPostOpen("RD_06_S_003_49", param);
}

function CloseGrSheetJinRo(){
	
	var query		= "";
	var tot_cnt		= $("#display_item_cnt").val();
	var cnt			= getCheckedRowCount("checkbox");

	var fromDate 		= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 			= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var req_dept_code 	= $("#st_req_dept_code").val();
	var buyer 			= $("#st_com_code").val();
	var ref_pr_no 		= $("#st_ref_pr_no").val();
	var po_no 			= $("#st_search_no").val();
	var po_user_id 		= $("#st_po_user_id").val();
	
	if(cnt == 0){
		//거래명세서를 생성할 목록을 선택 하세요.
		alert(" <%=CommonLang.msg("MSG254")%> ");
		return;
	}
	
	for(var k = 0; k < tot_cnt; k++){
		var box = eval("document.contentForm.checkbox"+k);
		if(box.checked == true){
			
			query += $("input[name='scha']").eq(k).val();
			query += "@@";
			query += "||";

		}
	}
	
	var rd_id = "RD_06_S_003_35";
	var param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+query+"]";
	
	if(buyer=="KRJINR0007"){
		rd_id = "RD_06_S_003_36";
	}
	
	reportPostOpen(rd_id, param);
	
	
	//rd_add_sql ==>> po_user_id
	 	//document.forms[0].action="/kr/customer/sheet/gr_prn_jin_mrd.jsp?st_fromDate="+fromDate+"&st_toDate="+toDate+"&st_req_dept_code="+req_dept_code+"&st_buyer="+buyer+"&st_ref_pr_no="+ref_pr_no+"&st_po_no="+po_no+"&st_po_user_id="+po_user_id;
}

function CloseGrSheet(){

	var fromDate 		= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 			= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var req_dept_code 	= $("#st_req_dept_code").val();
	var buyer 			= $("#st_com_code").val();
	var ref_pr_no 		= $("#st_ref_pr_no").val();
	var po_no 			= $("#st_search_no").val();
	var po_user_id 		= $("#st_po_user_id").val();
	var po_user_name 	= $("#st_user_name").val();
	var session_user_id	= $("#st_user_id").val();
	var dept_type		= $("#st_dept_type").val();
	var user_type		= $("#st_user_type").val();
	var st_acnt_cd		= $("#st_acnt_cd").val();
	
	var rd_id = "";
	var param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+po_user_name+"]["+session_user_id+"]["+dept_type+"]["+user_type+"]["+st_acnt_cd+"]";
	if(buyer == ""){
		//고객사 정보를 선택 바랍니다.
		alert("<%=CommonLang.msg("MSG255")%>");
		return;		
	}	
	if(buyer == "KRHITE0003" ||buyer == "KRHITE0004"||buyer == "KRHITE0005"||buyer == "KRHITE0006"){  // HITE
		rd_id = "RD_06_S_003_37";
	}else if(buyer=="KRMYUN0046"||buyer=="KRMYUN0047"||buyer=="KRMYUN0048"){ //명화
		rd_id = "RD_06_S_003_38";
	}else if(buyer=="KRCELL0004"){ // 셀트리온
		rd_id = "RD_06_S_001_104";
	}else if(buyer=="KRLOTT0006" || buyer=="KRLOTT0007" || buyer=="KRLOTT0008" || buyer=="KRLOTT0009" || buyer=="KRLOTT0010" || buyer=="KRLOTT0011" || buyer=="KRLOTT0012" || buyer=="KRLOTT0013" || buyer=="KRLOTT0014" || buyer=="KRLOTT0016"){
		rd_id = "RD_06_S_003_46";
	}else if(buyer=="KRLOTT0029"){	// 롯데푸드_영업용 소모품
		rd_id = "RD_06_S_001_137";
	}else if(buyer=="KRSYPA0001"){	// (주)삼양패키징 광혜원공장
		rd_id = "RD_06_S_003_51";	// 39번 기본에서 품목코드, I/F발주번호 추가 
	}else if(buyer=="KRCSK-0003"){	// 씨에스케이 전용
		rd_id = "RD_06_S_003_52";	// 공급받는자,공급자 보관용 연속 출력 
	}else if(buyer=="KRLOTT0053" || buyer=="KRLOTT0054" || buyer=="KRLOTT0055" || buyer=="KRLOTT0056"){	// 롯데후레시델리카 1호, 롯데후레시델리카 2호, 롯데후레시델리카 3호, 롯데후레시델리카 4호
		rd_id = "RD_06_S_001_154";
	}else if (buyer=="KRHANC0020"){ // 한컴라이프케어
		rd_id = "RD_06_S_003_53";
	}else{
		rd_id = "RD_06_S_003_39";
	}
	
	reportPostOpen(rd_id, param);
}
function CloseGrSheet1(){

	var fromDate 		= $.datepicker.formatDate('yymmdd', $("#st_from_date").datepicker("getDate"));
	var toDate 			= $.datepicker.formatDate('yymmdd', $("#st_to_date").datepicker("getDate"));
	var req_dept_code 	= $("#st_req_dept_code").val();
	var buyer 			= $("#st_com_code").val();
	var ref_pr_no 		= $("#st_ref_pr_no").val();
	var po_no 			= $("#st_search_no").val();
	var po_user_id 		= $("#st_po_user_id").val();
	var po_user_name 	= $("#st_user_name").val();
	var session_user_id	= $("#st_user_id").val();
	var dept_type		= $("#st_dept_type").val();
	var user_type		= $("#st_user_type").val();
	var st_acnt_cd		= $("#st_acnt_cd").val();
	
	var rd_id = "";
	var param = "["+fromDate+"]["+toDate+"]["+req_dept_code+"]["+buyer+"]["+ref_pr_no+"]["+po_no+"]["+po_user_id+"]["+po_user_name+"]["+session_user_id+"]["+dept_type+"]["+user_type+"]["+st_acnt_cd+"]";
	
	if(buyer=="KRCELL0004"){ // 셀트리온
		rd_id = "RD_06_S_001_107";
	}else{
		rd_id = "RD_06_S_003_39";
	}
	
	reportPostOpen(rd_id, param);
}
//관리번호별 팝업
function getRefTotal(){
	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
	
	if(st_group_mng_flag == "Y"){
		var select_buyer_code = document.forms.searchForm.st_com_code.value;
		buyer = select_buyer_code;
		
		if(select_buyer_code == ""){
			//고객사를 전체 아닌 값으로 선택하여야 합니다.
			alert("<%=CommonLang.msg("MSG239") %>");
			return;
		}
	}
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){ // 조회기간 제한 2018.04.26 by HSJ
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
	
	var st_com_code = $("#st_com_code").val();
	var st_from_date = $("#st_from_date").val();
	var st_to_date = $("#st_to_date").val();
			
		
	//post 팝업 파라미터 설정
	var st_form_name = "RefTotalListFormGr";
	var st_popup_url = "/wmgr/getBuyerWmGrRefTotalList.do";
	var st_popup_param = "st_coom_code@@"+st_com_code+"^||^"+"st_from_date@@"+st_from_date+"^||^"+"st_to_date@@"+st_to_date;
	var st_popup_option = "820,400,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);

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
	<h3><%=CommonLang.get("HTITLE671")%><!-- 입고현황 --></h3>
	<%}else{%>
	<h3><%=CommonLang.get("HTITLE275")%><!-- 입고조회 --></h3>
	<%}%>
	<!--버튼영역-->
     <div id="searchBtnA">
			<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 != true) {
		%>
     	<span class="btn_search"><a href="javascript:doAction('detailSearch');"><%=CommonLang.get("HTITLE276")%><!-- 상세조회 --></a></span>
     	<%} %> 
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
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
					<td>	<select id="st_check_date" name="st_check_date" style="height:20px;">
							<option  <%=(st_check_date.equals("GR")? "selected" : "")%>  value = "GR"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></option>
							<option  <%=(st_check_date.equals("PR")? "selected" : "")%>  value = "PR"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></option>
						</select>
					</td>
				<%}else{ %>
					<td><%=CommonLang.get("HTITLE283")%><!-- 입고일 --><input type="hidden" id="st_check_date" name="st_check_date" value="GR"></td>
				<%} %>
					<td colspan="3">
						<input type="text"   name="st_from_date" style="width: 20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
			          	&nbsp;~&nbsp;
						<input type="text"   name="st_to_date" style="width: 20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
						
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>							
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
                    <td>
                    <%
                    	if( sessionComCode.equals("KRHONG0020")){ %> 
                    		<%=CommonLang.get("HTITLE672")%> <!-- 회계항목 --> 
                    <%	
                    	}else{ 
                    %>
                    		<%=CommonLang.get("HTITLE18")%><!-- 관리번호 -->
                    <% 	
                    	} 
                    %>
	                    <input type="hidden" id="st_legacy_po_no" name="st_legacy_po_no" value="">
	                    <input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no" value="">
	                    <input type="hidden" id="st_change_user_id" name="st_change_user_id" value="">
	                    <input type="hidden" name="st_acnt_cd" id="st_acnt_cd" value="">
                    </td>
                    <td>
				<%
					//SLOGIC-BEGIN(P06-0000029)
					if( p060000029.equals("TYPE1")){//동부기술원의 경우 KRDONG0121 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getKRDONG0121();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						
				<%	} else if(p060000029.equals("TYPE2")){ //FAG의 경우 KRKEPB0006 KRFAGB0001 KRFAGB0002 KRFAGB0003 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getKRFagKorea();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					
				<%	} else if(p060000029.equals("TYPE3")){ //INA의 경우 KRSCHA0001 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getInaKorea();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					
				<%	} else if(p060000029.equals("TYPE4")){ //경동보일러,경동정밀 경우 KRKDBO0003 KRKDPR0003 KRSEOJ0020 KRSEOJ0021 KRSEOJ0022 KRSEOJ0023 KRSEOJ0024 KRSEOJ0025 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getKyungDong();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					
				<%	} else if(p060000029.equals("TYPE5")){ //동일방직 장항공장 KRDONG0078 KRDONG0077 KRDONG0079 KRJINR0005 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getDongIl();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					
				<%	} else if(p060000029.equals("TYPE10")){ //두산인프라코어(주)이알피 경우 KRDHIM0004 %> 
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:90%" value =""  onKeyDown="kepEnter();">
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
					
				<%	} else if(p060000029.equals("TYPE6")){ // KRHONG0020 KRCONT0006 KRCONT0007 KRCONT0008 KRCONT0009 %>
						<input type="text" id="st_ref_pr_no_text" name="st_ref_pr_no_text" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no" name="st_ref_pr_no" value="">
						<a href="javascript:getHongik();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						
				<%	} else if(p060000029.equals("TYPE7")){ // KRINKT0001  KRKOLO0018 %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
						<a href="javascript:getKRINKT0001();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						
				<%	} else if(p060000029.equals("TYPE8")){ // KRGEST0001 %>
						<input type="text" id="st_ref_pr_no_text" name="st_ref_pr_no_text" style="width:50%;ime-mode:active;" value="" readonly>
						<input type="hidden" id="st_ref_pr_no" name="st_ref_pr_no" value="">
						<a href="javascript:getKRGEST0001();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_ref_pr_no','st_ref_pr_no_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
				
				<%	} else { %>
						<input type="text" id="st_ref_pr_no" name="st_ref_pr_no" style="width:90%" value =""  onKeyDown="kepEnter();">
						<input type="hidden" id="st_ref_pr_no_text" name="st_ref_pr_no_text" value="">
				<%	
					}
					//SLOGIC-END
				%>
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
				<%
				}
				%>
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
      	<%if(grRole.equals("-") && grRole != null) { %>
      	<span class="text03">&nbsp;&nbsp;※ <%=CommonLang.msg("MSG601")%></span> <!-- 마감 기간으로 입고취소가 불가합니다. -->
      	<% } %> 
      	
      			<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
      	<span class="fr">
      		<%=CommonLang.get("HTITLE594")%><!-- (기준 : 원) -->
		</span>
		<%
		}else{
		%>
      	<span class="fr">
      		<%=CommonLang.get("HTITLE172")%><!-- 총 금액 --> : 
			<input type="text" name="check_sum_price" value="원"  style="width:150px; text-align:right; background-color:#FFFFFF;font-weight:bold; font-size:9pt; border:#FFFFFF 1px solid;" READONLY>
			<input type="hidden" name="st_check_sum_price"  value="">
      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE594")%><!-- (기준 : 원) -->
      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
		</span>
		<%
		}
		%>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
				  <col width="10%"/>
			      <col width="10%"/>
			      <col width="13%"/>
			      <col width="*"/>
			      <col width="8%"/>
			      <col width="8%"/>
			      <col width="12%"/>
		<%}else{ %>
				<% if(!"Y".equals(cardYn)) {
						if(sessionBudget_flag.equals("Y")){
				%>
				      <col width="3%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="*"/>
				      <col width="5%"/>
				      <col width="6%"/>
				      <col width="5%"/>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<col width="5%"/>
					<% } %>
				      <col width="5%"/>
				      <col width="6%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				<%
					}else{
				%>
				      <col width="3%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="8%"/>
				      <col width="9%"/>
				      <col width="*"/>
				      <col width="5%"/>
				      <col width="5%"/>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<col width="5%"/>
					<% } %>
				      <col width="6%"/>
				      <col width="9%"/>
				      <col width="6%"/>
				      <col width="10%"/>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
				      <col width="8%"/>
				      <% } %>
				<%
					}
				%>
			<% } else { %>
				  <col width="3%"/>
				  <col width="7%"/>
				  <col width="7%"/>
			      <col width="8%"/>
			      <col width="8%"/>
			      <col width="*"/>
			      <col width="5%"/>
			      <col width="5%"/>
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<col width="5%"/>
					<% } %>
			      <col width="6%"/>
			      <col width="6%"/>
			      <col width="6%"/>
			      <col width="11%"/>
			      <col width="10%"/>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
			      <col width="8%"/>
				<%
					}
				%>
			      
			<% }
			} %>
	        </colgroup>
	        <thead>
		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
			<tr>
				<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE587")%><!-- 구매요청일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE217")%><!-- 발주수량 --></th>
				<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
			</tr>
			<tr>
				<th scope="col"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE287")%><!-- 입고금액 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
		<%}else{ 
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
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE639")%><!-- 길이 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE280")%><!-- 총입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE673")%><!-- 택배사정보 --></th>
					<%    
					}
					%>
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
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE674")%><!-- 입고자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE675")%><!-- 배송증빙 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE676")%><!-- 계정정보 --></th>
			<% }else{ %>
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
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE639")%><!-- 길이 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE280")%><!-- 총입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE673")%><!-- 택배사정보 --></th>
				<% } %>
				<% if("Y".equals(cardYn)) { %>	
					<th scope="col"><%=CommonLang.get("HTITLE644")%><!-- 카드여부 --></th>
				<% } %>
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
					<%    
					if(p060000080.equals("TYPE1")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
					<%    
					}
					%>
					<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE674")%><!-- 입고자 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
					<%    
					if(p060000080.equals("TYPE3")) {
					%>
						<th scope="col"><%=CommonLang.get("HTITLE675")%><!-- 배송증빙 --></th>
					<% } %>
				<% if("Y".equals(cardYn)) { %>	
					<th scope="col"><%=CommonLang.get("HTITLE645")%><!-- 카드승인번호 --></th>
				<% } %>
			<% }%>
		<%}%>
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

		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
					<tr align="center" bgcolor="<%=tclass%>">
		            	<td  title="발주번호">
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
							<input type="hidden" name="db_gr_lock_flag" value="<%=CommonUtil.nvl(rowData.get("GR_LOCK_FLAG"))%>"/>
							<%=CommonUtil.nvl(rowData.get("PCO_LEGACY_PO_NO"))%>
		                </td>
						<td title="구매요청일">
							<%=CommonUtil.formatStrinigDate(rowData.get("PR_CHANGE_DATE"))%>
		                </td>
		                <td class="left" title="품목코드">
			                <a class="hyperLink" href="javascript:doPop('buyerCatalogDisplayPop','<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
		                    </a>
		                </td>
		                <td class="left" title="품목명">
		                    <%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
		                </td>		
		                <td class="right" title="단가">
		                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
		                </td>
		                <td class="right" title="발주수량">
		                    <%=CommonUtil.formatNumber(rowData.get("PO_ITEM_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
		                </td>
		                <td class="left" title="협력사" rowspan="2">
			                <a class="hyperLink" href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_CODE"))%>');">
		                    	<%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%>
		                    </a>
		                </td>
					</tr>
					<tr align="center" bgcolor="<%=tclass%>">
						<td title="요청번호">
		                    <%=CommonUtil.nvl(rowData.get("PCO_REF_PR_NO"))%>
		                </td>
						<td title="발주일">
		                    <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
		                </td>
						<td title="입고일">
		                    <%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%>
		                </td>
		                <td class="left" title="규격">
		                    <%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
		                </td>
		                <td class="right" title="입고금액">
		                    <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
		                </td>
		                <td class="right" title="입고수량">
		                    <%=CommonUtil.formatNumber(rowData.get("GR_ITEM_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
		                </td>
					</tr>
		<%}else{ %>
					<tr align="center" bgcolor="<%=tclass%>">
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
		            		<input type="hidden" name="db_gr_lock_flag" value="<%=CommonUtil.nvl(rowData.get("GR_LOCK_FLAG"))%>"/>
			            	<input type="checkbox" id="checkbox<%=j%>" name="checkbox<%=j%>" value="<%=j%>" onClick="javascript:chkSumPrice();">
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
						<%    
						if(p060000080.equals("TYPE1")) {
						%>
			                <td class="right" title="길이">
			                    <%=CommonUtil.formatNumber(rowData.get("SIZE_LEN"),true,0,3)%>
			                </td>
						<%    
						}
						%>
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
						<%    
							if(p060000080.equals("TYPE3")) {
						%>
			                <td class="left" title="택배사정보">
				                <%=CommonUtil.nvl(rowData.get("PARCEL_INFO"))%>
			                </td>
		                <% } %>
		                <% if("Y".equals(cardYn)) { %>	
							<td title="카드여부">
			                    <%=CommonUtil.nvl(rowData.get("CARD_USE_FLAG"))%>
			                </td>
						<% } %>
						<% if(sessionBudget_flag.equals("Y")){%>
				                <td class="left" title="예산부서">
				                    <%=CommonUtil.nvl(rowData.get("BUDGET_DEPT"))%>
				                </td>
						<% }%>
					</tr>
					<tr align="center" bgcolor="<%=tclass%>">
					<%if(group_mng_flag.equals("Y")){%>
		            	<td class="left" title="주문번호" >
		            		<a class="hyperLink" href="javascript:doPop('buyerMpPoOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PX_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("PX_NO"))%>
		                    </a>
		                </td>
		                </td>
					<%}else{%>
						<td class="left" title="거래명세서번호">
						<%if("TYPE1".equals(p070000022)){%>
		            		<a class="hyperLink" href="javascript:doPop('buyerMpPoDlvryDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("INV_NO")%>');">
		                    	<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
		                    </a>
	                    <%}else{%>
	                    	<a class="hyperLink" href="javascript:doPop('commonMpIvInvoiceDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("SELLER")%>', '<%=rowData.get("INV_NO")%>', '<%=rowData.get("PO_NO")%>', '<%=rowData.get("WAREHOUSE_CODE")%>', '<%=rowData.get("PURCHASER_ID")%>');">
	                    		<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
	                    	</a>
	                    <%}%>
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
		                <td class="left" class="left" title="관리번호">
			                <%	if(sessionComCode.equals("KRHONG0020")) { %>
			                    <%=CommonUtil.nvl(rowData.get("REF_PR_NO_TEXT"))%>
							<%	} else { %>
								<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							<%	} %>
							
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
						<%    
						if(p060000080.equals("TYPE1")) {
						%>
			                <td class="right" title="수량">
			                    <%=CommonUtil.formatNumber(rowData.get("SIZE_QTY"),true,0,3)%>
			                </td>
						<%    
						}
						%>
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
						<%    
						if(p060000080.equals("TYPE3")) {
						%>
			                <td align="center"  title="배송증빙">
				          		<input type="hidden" name="st_image_key_sign" id="st_image_key_sign" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_SIGN"))%>">
				          		<input type="hidden" name="st_image_key_inv" id="st_image_key_inv" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY_INV"))%>">
					          <%
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
			                </td>
		                <%}%>
		                <% if("Y".equals(cardYn)) { %>	
							<td title="카드승인번호">
								<a class="hyperLink" href="javascript:cardBillPop('<%=CommonUtil.nvl(rowData.get("CARD_CONFIRM_NO"))%>');">
			                    	<%=CommonUtil.nvl(rowData.get("CARD_CONFIRM_NO"))%>
			                    </a>
			                </td>
							<%}%>
						<% if(sessionBudget_flag.equals("Y")){%>
				                <td class="left" title="계정코드">
				                    <%=CommonUtil.nvl(rowData.get("ACCOUNT_NAME"))%>
				                </td>
						<% }%>
					</tr>
            <%			}
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
			<%if(p060000098 == true){%>
				<!-- 관리번호별 집계 기능 활성화 -->
				<div class="fl">
					<span class="btn_04 mr04">
						<a href="javascript:getRefTotal();"><%=CommonLang.get("HTITLE937") %><!-- 관리번호별 집계 --></a>
					</span>
				</div>

			<%}%>
			<%
			 //차파트너스인 경우
			if(p070000025 == true){ %>
			<div class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('excelDown', 'TYPE1');"><%=CommonLang.get("HTITLE35")%></a></span><!-- 양식다운로드 -->
			</div>
			<%} %>
			<div class="fr">
				<% if("TYPE11".equals(p070000011)) {	// 한컴라이프케어 erp 양식 다운로드 %>
					<span class="btn_04">
							<a href="javascript:doAction('excelDown', 'TYPE11_2');"><%=CommonLang.get("HTITLE962")%><!-- ERP다운로드 --></a>
					</span>
				<%}%>
				<% if(sessionComCode.equals("KRAMOR0003")||sessionComCode.equals("KRAMOR0004")||sessionComCode.equals("KRAMOS0006")||sessionComCode.equals("KRESPO0003")
						||sessionComCode.equals("KRETUD0002")||sessionComCode.equals("KRINNI0002")||sessionComCode.equals("KROSUL0002")||sessionComCode.equals("KRAMOR0005")){
				%>
					<span class="btn_04">
							<a href="javascript:doAction('excelDown', 'TYPE12');">마감데이터 다운로드</a>
					</span>
				<%} %>
				<% if("TYPE13".equals(p070000011)) {	// 깨끗한나라 ERP 양식 다운로드 %>
					<span class="btn_04">
							<a href="javascript:doAction('excelDown', 'TYPE13');"><%=CommonLang.get("HTITLE962")%><!-- ERP다운로드 --></a>
					</span>
				<%}%>
				<%
				//두산중공업 펀치아웃 
				//SLOGIC-BEGIN(P06-0000052)
				if(p060000052 == true) {
				%>
	        		<span class="btn_04">
						<a href="javascript:doAction('excelPCODown');"><%=CommonLang.get("HTITLE670")%><!-- 다운로드 --></a>
					</span>
				<%}else{ %>
					<%
						if(sessionComCode.equals("KRWOOS0062")){
					%>
							<!-- a href="javascript:WoosPracticeView()"><img src="/kr/customer/images_new/but_document_print.gif" alt="실습재료인계인수대장출력"></a -->
							<span class="btn_10 mr04">
								<a href="javascript:WoosPracticeView();"><%=CommonLang.get("HTITLE677")%><!-- 실습재료인계인수대장출력 --></a>
							</span>
					<%
						}
					%>
		            <%
		                if(sessionComCode.equals("KRHONG0020")||sessionComCode.equals("KRKEPB0004")){
					%>
							<!-- a href="javascript:grListPop()"><img src="/kr/customer/images_new/but_gr_performance_view.gif" alt="마감실적조회" ></a  -->
							<span class="btn_06 mr04">
								<a href="javascript:grListPop();"><%=CommonLang.get("HTITLE678")%><!-- 마감실적조회 --></a>
							</span>
					<%
						}
						if(sessionComCode.equals("KRDONG0109")){
					%>
							<!-- a href="javascript:SheetWin()"><img src="/kr/customer/images_new/but_print.gif"  alt="출력"></a -->
							<span class="btn_04 mr04">
								<a href="javascript:SheetWin();"><%=CommonLang.get("HTITLE679")%><!-- 출력 --></a>
							</span>
					<%
						}
					%>
					<%
						if(sessionComCode.equals("KRFAGB0001")||sessionComCode.equals("KRKOLO0023")||sessionComCode.equals("KRDOOS0006")||sessionComCode.equals("KRFAGB0002")
								||sessionComCode.equals("KRKOLO0006")||sessionComCode.equals("KRDHIM0003")||sessionComCode.equals("KRFAGB0003")||sessionComCode.equals("KRSCHA0001")){
					%>
							<!-- a href="javascript:CloseGrSheetFAGSel()"><img src="/kr/customer/images_new/but_gr_print_s.gif"  alt="마감거래명세서출력(선택)"></a -->
							<span class="btn_10 mr04">
								<a href="javascript:CloseGrSheetFAGSel();"><%=CommonLang.get("HTITLE680")%><!-- 마감거래명세서출력(선택) --></a>
							</span>
							
							<!-- a href="javascript:CloseGrSheetFAG()"><img src="/kr/customer/images_new/but_gr_print.gif" alt="마감거래명세서출력"></a -->
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheetFAG();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
					<%
						} else if(sessionComCode.equals("KRJINR0005")|| sessionComCode.equals("KRJINR0007")) {
					%>
							<!-- a href="javascript:CloseGrSheetJinRo()"><img src="/kr/customer/images_new/but_gr_print.gif" alt="마감거래명세서출력"></a -->
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheetJinRo();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
					<%
						} else if(sessionComCode.equals("KRCELL0004")) {
					%>
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheet();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
							<span class="btn_10 mr04">
								<a href="javascript:CloseGrSheet1();"><%=CommonLang.get("HTITLE278")%><!-- 마감거래명세서출력(예산) --></a>
							</span>
					<%
						} else if(sessionComCode.equals("KRDAAR0001") || sessionComCode.equals("KRHUON0001") || sessionComCode.equals("KRKG-E0006")) {
					%>
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheet();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
							<span class="btn_10 mr04">
								<a href="javascript:CloseGrSheetFAGSel();"><%=CommonLang.get("HTITLE680")%><!-- 마감거래명세서출력(선택) --></a>
							</span>
					<%
						} else if(sessionComCode.equals("KRLOTT0015") || sessionComCode.equals("KRSIEM0004") || sessionComCode.equals("KRSIEM0014") || sessionComCode.equals("KRSIEM0006")||
								sessionComCode.equals("KRHUME0001") || sessionComCode.equals("KRUONS0001") || sessionComCode.equals("KRBIOT0004") || sessionComCode.equals("KRLAND0003") ||
								sessionComCode.equals("KRWHAN0004") || sessionComCode.equals("KRLOTT0095") || sessionComCode.equals("KRHANW0082") || sessionComCode.equals("KRHANH0009") ||
								sessionComCode.equals("KRHANH0008") || sessionComCode.equals("KRHANW0087") || sessionComCode.equals("KRHANW0088") || sessionComCode.equals("KRHANW0089") ||
								sessionComCode.equals("KRHANW0090") || sessionComCode.equals("KRHANW0091") || sessionComCode.equals("KRHANW0125") || "TYPE5".equals(p070000011)) {
					%><!-- 선택 마감거래명세서 -->
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheetFAGSel();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
					<%
						} else if("TYPE8".equals(p070000011)){
					%>
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheetFAGNoAmtSel();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
					<%
						} else {
					%>
							<!-- a href="javascript:CloseGrSheet()"><img src="/kr/customer/images_new/but_gr_print.gif" alt="마감거래명세서출력"></a -->
							<span class="btn_08 mr04">
								<a href="javascript:CloseGrSheet();"><%=CommonLang.get("HTITLE277")%><!-- 마감거래명세서출력 --></a>
							</span>
					<%
						}
					%>
					<%
					//엑셀다운로드 기능 통제
					if(p170000001 == false){	
					%>					
							<%if(p070000024 == false){%>
								<span class="btn_02 mr04">
									<a href="javascript:doAction('grCancel');"><%=CommonLang.get("HTITLE279")%><!-- 입고취소 --></a>
								</span>
							<%}%>
	
							<% if(clsdDnldYn.equals("Y")) {
									if("TYPE2".equals(p070000017)){%>
										<span class="btn_04 mr04">
										<a href="javascript:doAction('excelDownClose1');"><%=CommonLang.get("HTITLE681")%><!-- 마감 다운로드 --></a>
										</span>
								<%}else{%>
										<span class="btn_04 mr04">
										<a href="javascript:doAction('excelDownClose');"><%=CommonLang.get("HTITLE681")%><!-- 마감 다운로드 --></a>
										</span>
								<% } %>
							<% } %>
							
							<% if("TYPE6".equals(p070000011)) {	// 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE6');"><%=CommonLang.get("HTITLE883")%><!-- ERP다운로드 --></a>
								</span>
							<%} if("TYPE10".equals(p070000011)) {	// 램리서치 (KRLAM-0001) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE10');"><%=CommonLang.get("HTITLE954")%><!-- ASN 다운로드 --></a>
								</span>
							<%} %>
													
							<% if("TYPE1".equals(p070000011)) { 	// KRSCHA0001 (/kr/customer/warehousing/gr_delete_exwdKRSCHA0001.jsp) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE1');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
								
							<% } else if("TYPE2".equals(p070000011)) {	// KRWOOS0062 (/kr/customer/warehousing/gr_delete_exwdKRWOOS0062.jsp) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE2');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
								
							<% } else if("TYPE4".equals(p070000011)) {	// 롯데푸드 11개 고객사 %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE4');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
								
							<% } else if("TYPE5".equals(p070000011)) {	// 셀트리온제약(KRCELL0008, KRCELL0009, KRCELL0010) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE5');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
							
							<% } else if("TYPE7".equals(p070000011)) {	// 한화에어로스페이스 외 3개(KRHANH0008, KRHANW0063, KRHANH0009, KRHANW0062) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE7');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
								
							<% } else if("TYPE9".equals(p070000011)) {	// 롯데후레쉬델리카 4개(KRLOTT0053, KRLOTT0054, KRLOTT0055, KRLOTT0056) %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE9');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
							<% } else if("TYPE11".equals(p070000011)) {	// 한컴라이프케어 %>
								<span class="btn_04">
									<a href="javascript:doAction('excelDown', 'TYPE11');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
								</span>
							
							<% } else {%> 
				        			<span class="btn_04">
										<a href="javascript:doAction('excelDown', 'DEFAULT');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
									</span>
							<% } %>
					<%
						}
					%>
			<%} %>
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
