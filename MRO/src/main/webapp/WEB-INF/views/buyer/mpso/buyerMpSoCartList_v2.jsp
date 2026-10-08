<%--
**********************************************
* 메뉴 : 장바구니
* 화면 : 장바구니
* 기능 : 장바구니
* 프로그램 ID : BU0401001
* 담당자 : 최찬규
* 착수일 : 2026-05-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
<link rel="stylesheet" type="text/css" href="/resources/css/month_popup.css" />
<script src="/resources/js/punchout.js"></script>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
 
	//선입고장바구니 체크 추가
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String req_date = "";
	String ds_lt = "";
	if(!total_cnt.equals("0")){
		req_date = _gridList.get(0).get("REQ_DATE");
		ds_lt = _gridList.get(0).get("DS_LT");
	}
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"30"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String pageString = "30,50,100,200,500,1000";
	if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
		onepagerow = "30";
	}
	
	//100이하면 100으로 고정
	if(Integer.parseInt(onepagerow) <= 100){
		onepagerow = "100";
	}
	
	// 조회조건 S
	String st_query_cart = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"ALL");   
	//홍대~~~~~~~~~~~~~~~~~~~
	String st_verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),"");    
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"c_date");    
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");    
	String st_check       = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH");    	
	String st_zip_code = CommonUtil.nvl((String) request.getParameter("st_zip_code"),_sessionInfo.getZipCode()); 
	String st_tel_no = CommonUtil.nvl((String) request.getParameter("st_tel_no"),_sessionInfo.getTel()); 
	String st_fax_no = CommonUtil.nvl((String) request.getParameter("st_fax_no"),_sessionInfo.getFax()); 
	String st_mobile_no = CommonUtil.nvl((String) request.getParameter("st_mobile_no"),_sessionInfo.getmPhone()); 
	String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),_sessionInfo.getUserNameLoc()); 
	String st_email = CommonUtil.nvl((String) request.getParameter("st_email"),_sessionInfo.getEmail()); 
	String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),_sessionInfo.getUserId());  
	String st_recv_date = CommonUtil.nvl((String) request.getParameter("st_recv_date"),""); 
	String st_recv_date2 = CommonUtil.nvl((String) request.getParameter("st_recv_date2"),""); 
	String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),""); 
	String st_location_code = CommonUtil.nvl((String) request.getParameter("st_location_code"),""); 
	String st_location_type = CommonUtil.nvl((String) request.getParameter("st_location_type"),""); 
	String st_location_name = CommonUtil.nvl((String) request.getParameter("st_location_name"),"");
	String st_location_code_name = CommonUtil.nvl((String) request.getParameter("st_location_code_name"),""); 
	String st_purchase_dept_name = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_name"),""); 
	String st_purchase_dept_code = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_code"),""); 	 				
	// 조회조건 E 
	String SessionComCode = "";
	String byca_comorg_code = ""; 
	String img_view_flag   = "";
	String buyer             = "";
	String user_dept              = "";
	String budget_flag       = "";     // 고객사 예산 사용여부
    String userRole           = "";  
    String userRole1 = "";
    String userRole2 = "";   
    String userId = "";
    String row_cnt = "";
    String mphone = "";
    String empno = "";
    String delyToLocationCode = "";
    String delyToLocationCodeName = "";
    String delyToLocationText = "";
    String userName = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		buyer  = SessionComCode;
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag()); 
		userRole = CommonUtil.nvl((String)sessionInfo.getRole()); 
		userId = CommonUtil.nvl((String)sessionInfo.getUserId());
		mphone =  CommonUtil.nvl((String)sessionInfo.getmPhone());
		empno =  CommonUtil.nvl((String)sessionInfo.getEmpNo());
		delyToLocationCode = CommonUtil.nvl((String)sessionInfo.getDelyToLocation());
		delyToLocationCodeName = CommonUtil.nvl((String)sessionInfo.getDelyToLocationCodeName());
		delyToLocationText = CommonUtil.nvl((String)sessionInfo.getDelyToLocationName());
		userName = CommonUtil.nvl((String)sessionInfo.getUserNameLoc());
	}  
	if (userRole !=null){
			if (userRole.length() == 2){
			    userRole1 = userRole.substring(0,1);
			    userRole2 = userRole.substring(1,2);
			}
	}
	
    String p060000029 = "";
    String p060000029_col03 = "";
    String p060000029_col04 = "";
    String p060000029_col05 = "";
    String p060000029_col06 = "";

    Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000029");
    /*
    	관리번호 팝업 기본값 설정
    	BNTSLGIMP.COL01_DATA ='TYPE25' 기본설정 값
    	1. 팝업명: 관리번호
    	2. 동작설명: 팝업이용하여 관리번호 입력하며, 필수값지정. 기본설정 활용. 
    	3. 데이터 저장형태: TEXT(CODE) 형태로 저장.
    	BNTSLGIMP.COL01_DATA ='TYPE100' 기본설정 값
    	1. 팝업명: 관리번호
    	2. 동작설명: 팝업이용하여 관리번호 입력하며, 필수값지정. 기본설정 활용. 
    	3. 데이터 저장형태: CODE 형태로 저장.
    */
    if (p060000029_map != null){
    	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결
    	p060000029_col03 = CommonUtil.nvl(p060000029_map.get("COL03_DATA"),""); // 관리번호 팝업 연결(form)
    	p060000029_col04 = CommonUtil.nvl(p060000029_map.get("COL04_DATA"),""); // 장바구니 표기 유형
    	p060000029_col05 = CommonUtil.nvl(p060000029_map.get("COL05_DATA"),"관리번호"); // 관리번호 대체할 명칭(COL04 = TYPE1 에서만 사용)
    	p060000029_col06 = CommonUtil.nvl(p060000029_map.get("COL06_DATA"),""); // TYPE41에서 사용(2026-09-08) 'Y'면 예산계정 무관 회사 단위 관리번호 무조건 필수(뉴라테온), 그 외는 예산계정(ICOMCOD2.TEXT4, Z014) 값으로 필수여부 제어. TEXT5는 "관리부서" 컬럼 표시용이라 재사용하지 않음
    }
    // 관리번호 일괄등록 버튼 라벨: TYPE41(5개사 전용)일 때만 BNTSLGIMP.COL05_DATA(회사별 등록값) 사용, 나머지는 기존 그대로 "관리번호"
    // TYPE41은 5개사만 가질 수 있는 전용 번호라 COL05_DATA를 읽어도 다른 회사로 새지 않음
    String p060000029_btnLabel = p060000029.equals("TYPE41") ? p060000029_col05 : CommonLang.get("HTITLE18");

    String p060000027 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027","COL05_DATA"); // KRGEST0001 KRHONG0020 KRSIEM0010
    //관리번호 메세지
    String p060000027_msg ="";
     Map<String, String> p060000027_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000027");
    if (p060000027_map != null){
    	p060000027_msg = CommonUtil.nvl(p060000027_map.get("COL04_DATA"),""); // 관리번호 표기
    }
    
    boolean p060000027_ref = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027"); // 관리번호 * 표시용
    boolean p060000029_ref = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000029"); // 관리번호 * 표시용
    boolean p060000081 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000081"); // 빙그레 전송버튼 생성
    boolean p060000084 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000084"); // 체크아웃버튼 생성
    String p060000084_type	= "";
    
    if (p060000084 == true) {
    	p060000084_type = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000084","COL01_DATA");
    }
    //MOQ를 이용하여 주문 통제
    boolean p060000077 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000077"); 
    //비고 텍스트 표기
    String p060000088_co1 = CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000088","COL01_DATA"),"");
    //주문배수를 이용하여 주문 통제
    boolean p060000089 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000089");    
    //장바구니 계정코드 관리부서로 통제
    boolean p060000090 = false;
    //예산사용 고객사만 관리부서 통제 특수로직이 적용 됨.
    if(budget_flag.equals("Y")){
    	p060000090 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000090");
    }
 	 //SLOGIC-BEGIN(P06-0000035)
    String reportText= CommonLang.get("HTITLE168"); // 품의서출력, default 버튼명 
    String reportid = "RD_06_B_001_17";  ///kr/customer/sheet/cart_print_t.jsp
    String reportFunction = "doAction('PrSheet')";  // default report 
    Map<String, String> p060000035 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000035");   // com_code , 특수로직아이디
    if (p060000035 != null){
    	reportText= CommonUtil.nvl(p060000035.get("COL01_DATA"),reportText); // 레포트 버튼명
    	reportid = CommonUtil.nvl(p060000035.get("COL02_DATA"),reportid); // 레포트아이디
    	reportFunction = CommonUtil.nvl(p060000035.get("COL04_DATA"),reportFunction); // 레포트 asis 함수
    }     
  	//출력물 추가 보여지도록 설정.
    Map<String, String> p060000073 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000073");
    String reportText2= ""; 
    String reportid2 = ""; 
    if(p060000073 != null){
    	reportText2 = CommonUtil.nvl(p060000073.get("COL01_DATA"),reportText2); // 레포트 버튼명
    	reportid2 = CommonUtil.nvl(p060000073.get("COL02_DATA"),reportid2);       // 레포트아이디    	
    }
    	 
    //SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
    String listQuery = "2";
    	
	//SLOGIC-BEGIN(P06-0000111) - 예산계정팝업 자동조회 미사용, 조회조건 필수 입력 2022.04.29 HSJ 
	boolean p060000111 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000111");
	
	String account_pop_search_set = "N";
	
	if(p060000111 == true){
		account_pop_search_set = "Y";
    }
	// 품목별 도착지 지정
	Map<String, String> p060000100_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000100");
	String p060000100 = ""; //품목별 도착지 설정 타입
	String p060000100_col2 = "";//수령자, 전화번호, 도착지 자동 설정: A
	if(p060000100_map != null){
		p060000100 = CommonUtil.nvl(p060000100_map.get("COL01_DATA"));
		p060000100_col2 = CommonUtil.nvl(p060000100_map.get("COL02_DATA"));
	}
	
	//인수자명,인수자연락처 비고에 넣어주는 특수로직 -> 기존에는 인수자명(전화번/휴대전화번호호 였음) -> 장바구니에선 인수자연락처에 db 핸드폰번호 가져옴
	boolean p060000074 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000074");

	// 주문통제 from/ too/ 메세지
	Map<String, String> p060000101 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000101");
    String p060000101_from= ""; 
    String p060000101_to = ""; 
    String p060000101_msg = "";
    SimpleDateFormat sdf = new SimpleDateFormat("dd");
    Date now = new Date();
    if(p060000101 != null){
    	p060000101_from = CommonUtil.nvl(p060000101.get("COL01_DATA"),p060000101_from); // 주문통제 from
    	p060000101_to = CommonUtil.nvl(p060000101.get("COL02_DATA"),p060000101_to);       // 주문통제 to
    	
        int int_dd = Integer.parseInt(sdf.format(now)); //현재 일
        int int_from = Integer.parseInt(p060000101_from);//통제시작일
        int int_to = Integer.parseInt(p060000101_to);//통제 종려일
        //통제 조건
        if(int_from <= int_dd && int_dd <= int_to){
        	p060000101_msg = CommonUtil.nvl(p060000101.get("COL03_DATA"),p060000101_msg);       // 주문통제 메세지    	
        	userRole2 = "-";//주문불가
        }
    }
    
 	// 장바구니 품목 비고 입력 시 체크된 품목 전체 적용
    boolean p060000120 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000120");
    
 	// 카테고리NO 별 주문통제
 	String p060000125 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000125","COL01_DATA"); // 권한특수로직
 	String p060000125_msg = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000125","IMP_NOTE"); // 주문통제 시 사용할 메시지
 	
 	// 카테고리NO 별 분기처리
 	String p060000129_col01 = "";
 	String p060000129_col02 = "";
 	Map<String, String> p060000129_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000129");// 이벤트 분기용 카테고리코드
 	if(p060000129_map != null){
	 	p060000129_col01 = CommonUtil.nvl(p060000129_map.get("COL01_DATA"), p060000129_col01);
	 	p060000129_col02 = CommonUtil.nvl(p060000129_map.get("COL02_DATA"), p060000129_col02);
 	}
 	
 	boolean SolbPlantYn = CommonUtil.getCodeCheckReturn("SOLB02", SessionComCode);
 	boolean SolbCostCenterYn = CommonUtil.getCodeCheckReturn("SOLB03", SessionComCode);
 	
	// 카테고리, 아이디 별 주문통제
 	// 주문통제 아이디 목록(P06-0000128 와 함께 쓰이면 특정 카테고리만 주문할 수 있는 사용자 목록이 될 수 있음)
  	String p060000127 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000127","COL01_DATA"); // 권한특수로직
 	// 주문통제 카테고리 목록(P06-0000127 와 함께 쓰이면 특정 카테고리만 주문할 수 있는 사용자 목록이 될 수 있음)
   	String p060000128 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000128","COL01_DATA"); // 권한특수로직
   	String p060000128_msg = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000128","IMP_NOTE"); // 주문통제 시 사용할 메시지
   	
 	// 넥센타이어 고정자산 계정목록
   	List<Map<String,String>> nexeAccountList = (List<Map<String,String>>) request.getAttribute("nexeAccountList");
   	List<String>  aclist = new ArrayList<String>();
   	
   	for(int i = 0; i < nexeAccountList.size(); i++ ) {
   		aclist.add(i,nexeAccountList.get(i).get("CODE"));   		
   	}
   	
   	boolean p060000133 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000133"); // 체크박스 자동체크 해제 특수로직
   	
   	//MSDS 체크여부 확인
   	String p060000137 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000137","COL01_DATA");
   	
   	// 주문하기 버튼 눌렀을 때, 계정 코스트센터, GL 일치하지 않는 경우 통제 
   	String p060000138 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000138","COL01_DATA");
   	
	// 품목별 구매사유 입력 특수로직(Y:필수, N, 공백:필수아님)
 	String pr_reason_yn = "";
 	Map<String, String> bca00002 = CommonUtil.getSpecialCheckReturnMap(buyer,"BCA00002");
 	if(bca00002 != null){
 		pr_reason_yn = CommonUtil.nvl(bca00002.get("COL01_DATA"), pr_reason_yn);
 	}
 	
 	// 품목별 구매사유 체크된 품목 전체 적용
    boolean bca00003 = CommonUtil.getSpecialCheckReturn(buyer,"BCA00003");
 	//시약 품목과 타 품목 같이 주문못하도록 통제
 	boolean bca00006 = CommonUtil.getSpecialCheckReturn(buyer,"BCA00006");
 	
 	//p060000083 배송지 수정 불가 SLOGIC
 	boolean p060000083= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000083");
 	
 	//인수자연락처에 휴대전화번호 기본셋팅
 	boolean bca00007 = CommonUtil.getSpecialCheckReturn(buyer,"BCA00007");
%>
<style>
	#calendarContainer{
		z-index:99999 !important;
	}
	.input-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
	.select-error { border: 2px solid #F6495F !important; background-color: #FFF5F5 !important; }
</style>

<%-- 첨부파일 필수 여부 - 조회 쿼리 내 ICOMCOD3 테이블에 TYPE이 ATCH로 (계약서번호, 항번, 품목코드) 등록되었는 지로 확인--%>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>

<!-- 메뉴 E -->
<!--내용 시작-->
<div class="CartPageTit">
    <%=CommonLang.get("HTITLE161") %><!-- 장바구니 -->
    <div class="CartGuide">
      <div class="CartGuideTxt_on"><p>1</p><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_off"><p>2</p><%=CommonLang.get("HTITLE1424") %><!-- 주문/결제 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_off"><p>3</p><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></div> 
    </div>
  </div>
 <form name = "searchForm" id="searchForm" method = "post">
 <!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer %>">    
		
		<input type="hidden" name="st_verif_num" id="st_verif_num" value="<%=st_verif_num %>" /> 
		<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 		<input type="hidden" name="st_check" id="st_check" value="<%=st_check %>">    
 		<input type="hidden" name="st_user_dept" id="st_user_dept" value="<%=user_dept %>">  
		<input type="hidden" name="st_listQuery" id="st_listQuery" value="<%=listQuery %>">
		<input type="hidden" name="st_sort_gubun" id="st_sort_gubun" value="<%=st_sort_gubun %>">
		
		<input type="hidden" name="st_item_no_in" id="st_item_no_in" value="">
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">		
		
		<input type="hidden" name="st_zip_code"       value="<%=st_zip_code%>">
		<input type="hidden" name="st_tel_no"         value="<%=st_tel_no%>">
		<input type="hidden" name="st_fax_no"         value="<%=st_fax_no%>">
		<input type="hidden" name="st_mobile_no"      value="<%=st_mobile_no%>">
		<input type="hidden" name="st_user_name"      value="<%=st_user_name%>">
		<input type="hidden" name="st_email"          value="<%=st_email%>">
		<input type="hidden" name="st_user_id"        value="<%=st_user_id%>">
		<input type="hidden" name="st_query_cart"     value="<%=st_query_cart%>">
		<input type="hidden" name="st_recv_date"      value="<%=st_recv_date%>">
		<input type="hidden" name="st_recv_date2"     value="<%=st_recv_date2%>">
		<input type="hidden" name="st_remark"         value="<%=st_remark%>">
		<input type="hidden" name="st_location_code"  value="<%=st_location_code%>">
		<input type="hidden" name="st_location_type"  value="<%=st_location_type%>">
		<input type="hidden" name="st_location_name"  value="<%=st_location_name%>">
		<input type="hidden" name="st_purchase_dept_name"  value="<%=st_purchase_dept_name%>">
		<input type="hidden" name="st_purchase_dept_code"  value="<%=st_purchase_dept_code%>">
		<input type="hidden" name="st_pre_gr_flag"  id="st_pre_gr_flag" value="N">
		
		<input type="hidden" name="st_check_sum_price" id="st_check_sum_price" value="">
    	<input type="hidden" name="st_check_sum_cnt" id="st_check_sum_cnt" value="">
</form>
<form name = "contentForm" id="contentForm" method = "post">
  <div class="CARTcontainer">
	<div class="CARTleft">
      <!--버튼 -->  
      <div class="CART_Button mt20">
      <%  if(budget_flag.equals("Y")){    %>
            	<%
				if (_gridList == null || _gridList.size() == 0){        
				}else{
				%>
				<button class="But_ExcelDown40" style="position:absolute; left:0; top:0;" 
           onclick="javascript:doAction('excelDownload'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
				<%} %>
		<%} %>
         <div class="Rright">
           <button class="But_ExcelDown40" onclick="javascript:doPop('excelUpload'); return false;"><%=CommonLang.get("HTITLE34") %><!-- 엑셀업로드 --></button>
           <% if(!reportText.equals("NONE")) {%>
				<button class="ButOutline_Medium" onclick="javascript:<%=reportFunction%>; return false;"><%=reportText%></button>
           <%} %>
           <%if(!reportText2.equals("")){ %>
           		<button class="ButOutline_Medium" onclick="javascript:doAction('PrSheet2'); return false;"><%=reportText2%></button>
           <%} %>
           <button class="ButDarkGray_Medium" onclick="javascript:doAction('SAVE'); return false;" ><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button>
         </div>
      </div>
      <%if (_gridList == null || _gridList.size() == 0){ %>
      	<!--상품없음 메세지 --> 
	      <div class="CART_NoPD BorderTopSolid pt80 mt20">
	        <img src="/resources/imgs/Icon_Warning01.png" />
	        <p class="mt20"><%=CommonLang.msg("MSG890")%><!--장바구니에 담긴 품목이 없습니다--></p> 
	        <p class="h80"></p>
	      </div>
      <%}else{ %>
      	<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
      	  <%if(p060000100.equals("")){%>
	      	<!--배송정보 -->  
		      <div class="CART_Addbox mt20" >
		        <div class="CART_AddboxTit"><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --> <p class="CART_AddboxTit_button"><button class="ButOutline_Small" onclick="javascript:getDeliveryToLocation('','<%=buyer%>');return false;"><%=CommonLang.get("HTITLE1359") %><!-- 배송지코드 --></button> 
		        <%if(p060000083 == false){%>
		        <button class="ButOutline_Small" onclick="javascript:getnewzipCode('','<%=buyer%>'); return false;" ><%=CommonLang.get("HTITLE1425")%><!--직접입력--></button>
		        <%} %>
		        </p></div>
		        <div class="CART_AddboxDetail_Row">
		         <input class="CART_Addbox_input" style="width:178px" name="dely_to_location_name" id="dely_to_location_name" value="<%=delyToLocationCodeName %>(<%=delyToLocationCode %>)" placeholder="<%=CommonLang.get("HTITLE1426")%>" type="text" readonly/><!-- 배송지명(코드) -->
		         <input class="CART_Addbox_input ml04" style="width:684px" name="dely_to_location_text" id="dely_to_location_text" value="<%=delyToLocationText %>" placeholder="<%=CommonLang.get("HTITLE1361")%>" type="text" readonly/> <!-- 배송지주소 --> 
		         <input class="CART_Addbox_input ml04" style="width:684px" name="dely_to_location_code" id="dely_to_location_code" value="<%=delyToLocationCode %>"type="hidden" readonly/>
				 <input type="hidden" name="dely_to_location_code_name" id="dely_to_location_code_name" value="<%=delyToLocationCodeName %>" >
				</div>
		        <div class="CART_AddboxDetail_Row">
		         <input class="CART_Addbox_input" style="width:178px" name="recv_user" id="recv_user" value="<%=userName %>" placeholder="<%=CommonLang.get("HTITLE1427")%>" type="text" /><!-- 인수자명(필수) -->
		         <%if(p060000074 == true) {%>
		         <input class="CART_Addbox_input ml04" style="width:374px" name="recv_user_phone" id="recv_user_phone" placeholder="<%=CommonLang.get("HTITLE1428")%>" value="<%=mphone %>" type="text" onkeyup="kepNumcheck3(this);" maxlength="20"/> <!-- 연락처(필수) 예: 010-0000-0000 -->
		         <%}else if(bca00007 == true) {%>
		         <input class="CART_Addbox_input ml04" style="width:374px" name="recv_user_phone" id="recv_user_phone" placeholder="<%=CommonLang.get("HTITLE1428")%>" value="<%=mphone %>" type="text" onkeyup="kepNumcheck3(this);" maxlength="20"/> <!-- 연락처(필수) 예: 010-0000-0000 -->
		         <%}else{ %>
		         <input class="CART_Addbox_input ml04" style="width:374px" name="recv_user_phone" id="recv_user_phone" placeholder="<%=CommonLang.get("HTITLE1428")%>" value="" type="text" onkeyup="kepNumcheck3(this);" maxlength="20"/> <!-- 연락처(필수) 예: 010-0000-0000 -->
		         <%} %>
		         	<div class="ReceiveDateTit">
		         		<%=CommonLang.get("HTITLE831") %><!-- 수령희망일 -->
		         	</div>
		         	<div class="datepicker-wrap" id="recv_date_div"><div class="date-input" data-datepicker><input type="text" id="recv_date_hope" name="recv_date_hope" value="<%=CommonUtil.formatStrinigDate(req_date)%>" readonly onchange="javascript:recvDateCheck('top');"/><span> </span></div></div>
				</div>
		        <div class="Importance mt10 mr20" ><img src="/resources/imgs/Icon_Importance03.png" /><%=CommonLang.msg("MSG891")%><!--휴대폰번호를 정확히 입력하셔야 배송현황을 안내 받을 수 있습니다.--></div>
		      </div>
	      <%} %>
	      <!--버튼 -->  
	      <div class="CART_Sort mt20 mb10"> 
	         <label class="CheckLargeLabel"><input type="checkbox" id="checkedAll" name="checkedAll" class="checkedAllClass" onclick="javascript:checkedAllBox('checkedAll');"><span class="CheckLargeCustom"></span></label>
	         <button class="ButOutline_Medium" onclick="javascript:doAction('setCartDelete'); return false;"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></button> 
	         <div class="Rright">
	         <%if(!p060000100.equals("")){%>
	           <span><%=CommonLang.get("HTITLE1429")%><!--일괄등록-->│</span>
	           <button class="ButOutline_Medium" onclick="javascript:doPop('get_delivery_to_location_all','<%=buyer %>'); return false;" ><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --></button>
	           <%if(!p060000029_col03.equals("FORM9") && !p060000029.equals("TYPE20")) {%> 
				<button class="ButOutline_Medium" onclick="javascript:doPop('ref_pr_no_all'); return false;"><%=p060000029_btnLabel%><!-- 관리번호 --></button>
	           <%} %>
	           <button class="ButOutline_Medium" onclick="javascript:recvDateOpen(); return false;"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></button>
	         <%}else{ %>
	         	<%if(!p060000029_col03.equals("FORM9") && !p060000029.equals("TYPE20")) {%>
	         		<span><%=CommonLang.get("HTITLE1429")%><!--일괄등록-->│</span>
					<button class="ButOutline_Medium" onclick="javascript:doPop('ref_pr_no_all'); return false;"><%=p060000029_btnLabel%><!-- 관리번호 --></button>
	           <%} %>
	         <%} %>
	         </div>
	      </div> 
      		<%
      		Map<String,String> rowData = null;
      		for (int j=0; j<_gridList.size(); j++) {
      			rowData = _gridList.get(j);
      			
      			String totSum = CommonUtil.nvl(rowData.get("TOT_SUM"), "0");
      			String bdgt_bal_amt = CommonUtil.nvl(rowData.get("BDGT_BAL_AMT"), "0");
      			
      			double db_totSum = Double.parseDouble(totSum);
      			double db_bdgt_bal_amt = Double.parseDouble(bdgt_bal_amt);
      			
      		%>
			  <div class="CART_PDbox mt20">
				<button class="CART_PDbox_CloseBtn" id="<%=j%>" onclick="return false;"></button>
				<table class="CART_PDboxTable" >
		          <colgroup>
		            <col width="40px" />
		            <col width="420px" />
		            <col width="300px" />
		            <col width="180px" />
				  </colgroup>
				  <tr>
				  	
					<td><label class="CheckLargeLabel"><input type="checkbox" name="lnCheck<%=j%>" id="lnCheck<%=j%>" onclick="chk_sum_price();"><span class="CheckLargeCustom"></span></label></td>
					<td>
		              <a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
		              <div class="CART_PDboxPDimg">
		              <%if(!CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N")) {%>
		              <div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
		              <%} %>
		              <%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")) {%>
		              <div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
		              <%} %>
		              <%if(!CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래")) {%>
		              <div class="OpacityBox"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></div>
		              <%} %>
<!-- 		              <p class="EcoFriendly">친환경</p> -->
<!-- 							<img src="/resources/imgs/img05.jpg" /> -->
		              <img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'" />
		              </div>
		              <div class="CART_PDbox_CodeName ">
		                <div class="Code"><%=rowData.get("BUYER_ITEM_NO")%></div><div class="Name"><%=rowData.get("DESCRIPTION_LOC")%></div>
		                <dl class="CART_PDbox_Detail" >
		                 <dt><%=CommonLang.get("HTITLE14") %><!-- 규격 --></dt><dd><%=rowData.get("SPECIFICATION")%></dd><br/>
		                 <dt><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></dt><dd><%=rowData.get("MAKER_NAME")%> / <%=rowData.get("ORIGIN_NAME")%></dd><br/>
		                 <dt><%=CommonLang.get("HTITLE52") %><!-- 단위 --></dt><dd><%=rowData.get("UNIT_MEASURE")%> <%if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y") && !CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")) {%> <%=CommonLang.get("HTITLE597") %><!-- (재 판매일 : --><%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)  <%} %></dd>
					    </dl>
		              </div>
		              </a>
		            </td>
		            <td>
					<% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
						<input class="CART_PDbox_input mt11" style="width:100px;text-align:right;"  name="st_order_price" id="st_order_price<%=j %>" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');return false;}" type="text" />
					<%}else{ %>
					<div class="CART_PDPrice mt30"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></div>
					<input type="hidden" name="st_order_price" id="st_order_price<%=j %>" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
					<%} %>
					<input type="hidden" name="st_fixed_price_flag" id="st_fixed_price_flag<%=j %>" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
					  <div class="CART_OrderNum mt20">
						<div class="NumInput mb05">
						  <button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
						  <input type="text" name="st_order_qty" id="st_order_qty<%=j %>" value="<%=rowData.get("CART_QTY")%>" onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("MIN_ORDER_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){ event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("MIN_ORDER_QTY")%>'); return false;}">
						  <button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
						</div><br/>
						<p class="NumTxt01"> <%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span><%=rowData.get("MIN_ORDER_QTY")%></span></p> 
						<p class="NumTxt02"> <%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span><%=rowData.get("PUR_UNIT_QTY")%></span></p>  
					  </div>
					 </td>
					<td><dl class="CART_PDPriceAll mt30"><dt></dt><dd><span id="st_sum_price_text<%=j%>"><%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></dd></dl></td>
	         </tr>
	         <tr>
		         <td></td>
		         <td colspan="2">
		            <input type="hidden" name="st_item_no" id="st_item_no<%=j %>" value="<%=rowData.get("BUYER_ITEM_NO")%>" >
                    <input type="hidden" name="st_contract_no"  id="st_contract_no<%=j %>"      value="<%=rowData.get("CONTRACT_NO")%>">
                    <input type="hidden" name="st_contract_seq" id="st_contract_seq<%=j %>"      value="<%=rowData.get("CONTRACT_SEQ")%>">
                    <input type="hidden" name="st_agent_code"   id="st_agent_code<%=j %>"      value="<%=rowData.get("AGENT_CODE")%>">
                    <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code<%=j %>"  value="<%=rowData.get("BYIT_COMORG_CODE")%>">
                    <input type="hidden" name="st_bdgt_flag"   id="st_bdgt_flag<%=j %>"       value="<%=rowData.get("BDGT_FLAG")%>">
                    <input type="hidden" name="st_product_close_flag" id="st_product_close_flag<%=j %>" value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
                    <input type="hidden" name="st_process_type"  id="st_process_type<%=j %>"        value="<%=rowData.get("PROCESS_TYPE")%>">
                    <input type="hidden" name="st_stock_item_flag"  id="st_stock_item_flag<%=j %>"     value="<%=rowData.get("STOCK_ITEM_FLAG")%>">
                    <input type="hidden" name="st_ref_pr_dept" id="st_ref_pr_dept<%=j %>" value="<%=rowData.get("HI_DEPT_CODE")%>">
 					<input type="hidden" name="st_yuhan_saperp_flag" id="st_yuhan_saperp_flag<%=j %>"			value="<%=rowData.get("YUHAN_SAPERP_FLAG")%>">
 					<input type="hidden" name="st_item_status_flag"	 id="st_item_status_flag<%=j %>"		value="<%=rowData.get("ITEM_STATUS_FLAG")%>">
 					<input type="hidden" name="st_mg_note_input" id="st_mg_note_input<%=j %>"			value="<%=rowData.get("MG_NOTE_INPUT")%>">
 					<input type="hidden" name="st_image_key"  id="st_image_key<%=j %>"           value="<%=rowData.get("IMAGE_KEY")%>">
 					<input type="hidden" name="st_seq"  id="st_seq<%=j %>"           value="<%=rowData.get("SEQ")%>">
 					<input type="hidden" name="st_item_mng_flag" id="st_item_mng_flag<%=j %>"	value="<%=rowData.get("ITEM_NO_MNG_FLAG")%>">
 					<input type="hidden" name="st_min_order_qty" id="st_min_order_qty<%=j %>"	value="<%=rowData.get("MIN_ORDER_QTY")%>">
 					<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty<%=j %>"	value="<%=rowData.get("PUR_UNIT_QTY")%>">
 					<input type="hidden" name="st_over_short_flag" id="st_over_short_flag<%=j %>" value="<%=rowData.get("OVER_SHORT_FLAG")%>">
 					<input type="hidden" name="st_stock_cnt" id="st_stock_cnt<%=j %>" value="<%=rowData.get("STOCK_CNT")%>">
 					<input type="hidden" name="st_atch_flag" id="st_atch_flag<%=j %>" value="<%=rowData.get("ATCH_FLAG")%>">
 					<input type="hidden" name="st_buyer_category_no" id="st_buyer_category_no<%=j %>" value="<%=rowData.get("BUYER_CATEGORY")%>">
 					<input type="hidden" name="st_urct2_yn"  id="st_urct2_yn<%=j %>" value="<%=rowData.get("URCT2_YN")%>">
					<input type="hidden" name="st_msds_yn"	id="st_msds_yn<%=j %>"			value="<%=rowData.get("MSDS_YN")%>">
					<input type="hidden" name="p060000029"  id="p060000029<%=j %>"    value="<%=p060000029%>">
					<input type="hidden" name="p060000029_col03"  id="p060000029_col03<%=j %>"    value="<%=p060000029_col03%>">
					<input type="hidden" name="st_size_qty" id="st_size_qty<%=j %>" value="">
                    <input type="hidden" name="st_size_len" id="st_size_len<%=j %>" value="">
                    
                    <input type="hidden" name="st_item_no_mng_detl" id="st_item_no_mng_detl<%=j %>" value="<%=rowData.get("ITEM_NO_MNG_DETL")%>">
                    <input type="hidden" name="st_namecard_rpt" id="st_namecard_rpt<%=j %>" value="<%=rowData.get("NAMECARD_RPT")%>">
					<%if("Y".equals(budget_flag)){%>
						<input type="hidden" name="st_budget_amt" id="st_budget_amt<%=j %>" value="<%=CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), false, 0, 0)%>">
	                    <input type="hidden" name="st_budget_dept" id="st_budget_dept<%=j %>" value="<%=rowData.get("BUDGET_DEPT_CODE")%>">
	                    <input type="hidden" name="st_account_type" id="st_account_type<%=j %>" value="<%=rowData.get("ACCOUNT_TYPE")%>">
	                    <input type="hidden" name="st_mg_code"  id="st_mg_code<%=j %>"     value="<%=rowData.get("MG_CODE")%>">
	                    <input type="hidden" name="st_mg_note"  id="st_mg_note<%=j %>"     value="<%=rowData.get("MG_NOTE")%>">
	                    <input type="hidden" name="st_mng_flag" id="st_mng_flag<%=j %>"  value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
	                    <input type="hidden" name="st_mng_dept_cd" id="st_mng_dept_cd<%=j %>" value="<%=rowData.get("MNG_DEPT_CD")%>">
	                    <input type="hidden" name="st_mgmt_no_req_yn" id="st_mgmt_no_req_yn<%=j %>" value="<%=rowData.get("MGMT_NO_REQ_YN")%>">
					<%}else{ %>
						<input type="hidden" name="st_account_type" id="st_account_type<%=j %>" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_budget_dept" id="st_budget_dept<%=j %>" value="">
                        <input type="hidden" name="st_mg_code"  id="st_mg_code<%=j %>"    value="<%=rowData.get("MG_CODE")%>">
                        <input type="hidden" name="st_mg_note"  id="st_mg_note<%=j %>"    value="<%=rowData.get("MG_NOTE")%>">
                        <input type="hidden" name="st_mng_flag" id="st_mng_flag<%=j %>" 	value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
                        <input type="hidden" name="st_mng_dept_cd" id="st_mng_dept_cd<%=j %>"  value="">
                        <input type="hidden" name="st_mgmt_no_req_yn" id="st_mgmt_no_req_yn<%=j %>" value="">
                        <input type="hidden" name="st_account_type_name" id="st_account_type_name<%=j %>" value="">
                        <input type="hidden" name="st_bdgt_bal_amt" id="st_bdgt_bal_amt<%=j %>" value="">
					<%} %>
		              
		              <!-- 관리번호 -->
		              <%if(p060000029.equals("TYPE4") || p060000029.equals("TYPE5") || p060000029.equals("TYPE7") || p060000029.equals("TYPE22")) { %>
		              	<a href="javascript:doPop('ref_pr_no','<%=j%>')"><input class="CART_PDbox_input mt15" style="width:365px;cursor: pointer;"   name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" readonly /></a>
		              
		              <%}else if(p060000029.equals("TYPE13") || p060000029.equals("TYPE14") || p060000029.equals("TYPE20") || p060000029.equals("TYPE23") || p060000029.equals("TYPE29") || p060000029.equals("TYPE30") || p060000029.equals("TYPE31") 
		            		  || p060000029.equals("TYPE32") || p060000029.equals("TYPE33") || p060000029.equals("TYPE35") || p060000029.equals("TYPE39") || p060000029.equals("TYPE40") || p060000029.equals("TYPE16") || p060000029.equals("TYPE26") || p060000029.equals("TYPE27")) {%>
		              	<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO")%>">
		              	<a href="javascript:doPop('ref_pr_no','<%=j%>')"><input class="CART_PDbox_input mt15" style="width:365px;cursor: pointer;"   name="st_ref_pr_no_text" id="st_ref_pr_no_text<%=j %>" value="<%=rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" readonly /></a>
		              
		              <%}else if(p060000029.equals("TYPE100")) { %>
		              	<a href="javascript:doPop('ref_pr_no','<%=j%>')"><input class="CART_PDbox_input mt15" style="width:365px;cursor: pointer;"   name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO").equals("")?rowData.get("DEFAULT_REF_PR_NO"):rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" readonly /></a>
		              
					  <%}else if(p060000029.equals("TYPE41")) { %>
		              	<a href="javascript:doPop('ref_pr_no','<%=j%>')"><input class="CART_PDbox_input mt15" style="width:365px;cursor: pointer;"   name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO").equals("")?rowData.get("DEFAULT_REF_PR_NO"):rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" readonly /></a>
		              
		              <%}else if(p060000029.equals("TYPE34")) { %>
		              	<%if(rowData.get("BUYER_CATEGORY").contains(p060000129_col01)){ // 카테고리가 전산인 경우 (ex. 999) %>
		              		<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO")%>">
		              		<a href="javascript:doPop('ref_pr_no','<%=j%>')"><input class="CART_PDbox_input mt15" style="width:365px;cursor: pointer;"   name="st_ref_pr_no_text" id="st_ref_pr_no_text<%=j %>" value="<%=rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" readonly /></a>
		              	<%}else{ %>
		              		<input type="hidden" name="st_ref_pr_no_text" value="<%=rowData.get("REF_PR_NO")%>">
		              		<input class="CART_PDbox_input mt15" style="width:365px"   name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" value="<%=rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" />
		              	<%} %>
		              
		              <%}else if(p060000029.equals("TYPE36")) { %>
		              	<select name="st_ref_pr_no"  id="st_ref_pr_no<%=j %>" class="CART_PDbox_Select mt15" style="width:387px;">
                             <%=CommonUtil.getCodeBComboList(buyer,"REF_PR_SEL","M014","ICOMCOD2",rowData.get("REF_PR_NO"),rowData.get("REF_PR_NO_TEXT")) %>
                        </select>
                        <input type="hidden" name="st_ref_pr_no_text" id="st_ref_pr_no_text<%=j %>" value="<%=rowData.get("REF_PR_NO")%>">
		              
		              <%}else if(p060000029.equals("TYPE37")) { %>
		              	<select name="st_ref_pr_no" id="st_ref_pr_no<%=j %>" class="CART_PDbox_Select mt15" style="width:387px;">
                            <%=CommonUtil.getTextValueComboList(buyer,"REF_PR_SEL","M014","ICOMCOD2","",rowData.get("REF_PR_NO")) %>
                        </select>
                        <input type="hidden" name="st_ref_pr_no_text" id="st_ref_pr_no_text<%=j %>" value="<%=rowData.get("REF_PR_NO")%>">
		              
		              <%}else{ %>
		              	<input class="CART_PDbox_input mt15" style="width:365px"   name="st_ref_pr_no" id="st_ref_pr_no<%=j %>"  value="<%=rowData.get("REF_PR_NO")%>" placeholder="<%=CommonLang.msg("MSG892")%>" type="text" />
		              <%} %>
		              
		              <!-- 품목별 비고 -->
		              <%if(rowData.get("ITEM_NO_MNG_FLAG").equals("NMCD")){ %>
		              	<input class="CART_PDbox_input mt15 ml05" style="width:306px;"  name="st_remark" id="st_remark<%=j %>" value="<%=rowData.get("REMARK")%>" placeholder="" type="text" readonly /> 
		              <%}else{ %>
		              	<input class="CART_PDbox_input mt15 ml05" style="width:306px;"  name="st_remark" id="st_remark<%=j %>" value="<%=rowData.get("REMARK")%>" onchange="javascript:changeData('remark',this.value);" placeholder="<%=CommonLang.msg("MSG893")%>" type="text" /> 
		              <%} %>
		              
		              <!-- 품목별 구매사유 -->
		              <%if(!pr_reason_yn.equals("")) { %>
					  	<input class="CART_PDbox_input mt05" style="width:698px"   name="st_pr_reason" id="st_pr_reason<%=j %>" value="<%=rowData.get("PR_REASON")%>" onchange="javascript:changeData('prReason',this.value);" placeholder="<%=CommonLang.msg("MSG894")%>" type="text" />
					  <%}else{ %>
					  	<input type="hidden" name="st_pr_reason" id="st_pr_reason<%=j %>"           value="<%=rowData.get("PR_REASON")%>">
					  <%} %>
		              
		              <%if("Y".equals(budget_flag)){%>
		              	<button class="ButOutline_Small" style="width:100px" onclick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>'); return false;"><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></button>
      					<div class="CART_PDbox_inputOutline mt05 ml05"  style="width:613px;" id="budgetDiv<%=j%>">
			  			  <%if(rowData.get("ACCOUNT_NAME").equals("")){%>
				           		<input class="CART_PDbox_input" style="width:158px"   name="st_account_type_name" id="st_account_type_name<%=j %>" value="" placeholder="" type="text" readonly/>
			  			  <%}else{ %>
			  			  	<%if(p060000090 == true) { %><!-- 관리부서 통제가 들어갈 경우 계정정보+관리부서로 보여 짐 -->
			  			  		<input class="CART_PDbox_input" style="width:158px"   name="st_account_type_name" id="st_account_type_name<%=j %>" value="<%=rowData.get("MNG_DEPT_NM")%>" placeholder="" type="text" readonly/>
			  			  	<%}else{ %>
			  			  		<input class="CART_PDbox_input" style="width:158px"   name="st_account_type_name" id="st_account_type_name<%=j %>" value="<%=rowData.get("ACCOUNT_NAME")%>" placeholder="" type="text" readonly/>
			  			  	<%} %>
			  			  <%} %>  
				           		<input class="CART_PDbox_input ml05" style="width:270px"   name="st_budget_dept_name" id="st_budget_dept_name<%=j %>"  value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"":rowData.get("BUDGET_DEPT_NAME")%>" placeholder="" type="text" readonly/> 
				           	<%if(rowData.get("VIEW_FLAG").equals("N")){ %>
				           		<input class="CART_PDbox_input ml05" style="width:100px"    name="st_bdgt_bal_amt" id="st_bdgt_bal_amt<%=j %>" value="0" type="text" readonly/> 
				           	<%}else{ %>
				           		<%if( db_totSum > db_bdgt_bal_amt ){ %>
					           		<input class="CART_PDbox_input ml05" style="width:100px; color:#ee3212;"    name="st_bdgt_bal_amt" id="st_bdgt_bal_amt<%=j %>" value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" type="text" readonly/> 
					           	<%}else{ %>
					           		<input class="CART_PDbox_input ml05" style="width:100px; color:#003694;"    name="st_bdgt_bal_amt" id="st_bdgt_bal_amt<%=j %>" value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" type="text" readonly/> 
					           	<%} %>
				           	<%} %>
				         </div>
		  			   <%} %>
					</td>
					<td align="right">
					<%if(rowData.get("IMAGE_KEY").equals("")) {%>
						<button name="st_file_upload_but" id="st_file_upload_but<%=j %>" class="ButOutline_Small mt15" onclick="javascript:attach_popup('','<%=j%>'); return false;" style="width:150px;" ><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --> <span id="st_file_upload_cnt<%=j%>"></span></button>
					<%}else{ %>
						<button name="st_file_upload_but" id="st_file_upload_but<%=j %>" class="ButQuaternary_Small mt15" onclick="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>','<%=j%>'); return false;" style="width:150px;"><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --> <span id="st_file_upload_cnt<%=j%>"><%=rowData.get("IMAGE_KEY_CNT")%></span></button>
					<%} %>
					<%if(rowData.get("ITEM_NO_MNG_FLAG").equals("NMCD")){ %>
						<%if(!rowData.get("REMARK").equals("")){ %>
							<button id="st_name_card_info<%=j %>" class="ButOutline_Small_on mt05" style="width:73px" onclick="javascript:getNameCardPop('<%=j%>', '<%=rowData.get("SEQ")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>'); return false;" ><%=CommonLang.get("HTITLE760") %><!-- 명함정보 --></button>
             				<button id="st_name_card_view<%=j %>" class="ButOutline_Small_on mt05" style="width:73px" onclick="javascript:nameCardView('<%=j%>', '<%=rowData.get("NAMECARD_RPT")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>'); return false;"><%=CommonLang.get("HTITLE735") %><!-- 명함시안 --></button>
						<%}else{ %>
							<button id="st_name_card_info<%=j %>" class="ButOutline_Small mt05" style="width:73px" onclick="javascript:getNameCardPop('<%=j%>', '<%=rowData.get("SEQ")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>'); return false;" ><%=CommonLang.get("HTITLE760") %><!-- 명함정보 --></button>
             				<button id="st_name_card_view<%=j %>" class="ButOutline_Small_off mt05" style="width:73px" onclick="javascript:nameCardView('<%=j%>', '<%=rowData.get("NAMECARD_RPT")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>'); return false;"><%=CommonLang.get("HTITLE735") %><!-- 명함시안 --></button>
						<%} %>
					<%} %>
					</td>
					<input type="hidden" name="st_sum_price" id="st_sum_price<%=j %>" value="<%=rowData.get("TOT_SUM")%>">
				  </tr>
				</table>
				<%if(p060000100.equals("TYPE1")||p060000100.equals("TYPE2")){%>
			        <!--배송정보 -->  
			        <div class="CART_AddboxSmall mt20">
			          <div class="CART_AddboxSmallTit"><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --> <p class="CART_AddboxSmallTit_button"><button class="ButOutline_Small" onclick="javascript:getDeliveryToLocation('<%=j %>','<%=buyer%>');return false;" ><%=CommonLang.get("HTITLE1359") %><!-- 배송지코드 --></button> 
			          <%if(p060000083 == false){%>
			          <button class="ButOutline_Small" onclick="javascript:getnewzipCode('<%=j%>','<%=buyer%>'); return false;"><%=CommonLang.get("HTITLE1425") %><!-- 직접입력 --></button>
			          <%} %>
			          </p></div>
			          <div class="CART_AddboxSmallDetail_Row">
			          <%if(p060000100_col2.equals("A") || p060000100_col2.equals("B")){%>
			          	  <%if(CommonUtil.nvl(rowData.get("DELY_TO_LOCATION_TEXT")).equals("")){ %>
					           <input class="CART_AddboxSmall_input" style="width:178px"   name="item_dely_to_location_name" id="item_dely_to_location_name<%=j %>" value="<%=rowData.get("USR_DELY_TO_LOCATION_NAME")%>" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1426")%>"/>
					           <input class="CART_AddboxSmall_input ml04" style="width:638px"  name="item_dely_to_location_text" id="item_dely_to_location_text<%=j %>" value="<%=rowData.get("USR_DELY_TO_LOCATION_TEXT")%>" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1361")%>"/>
					           <input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code<%=j %>" value="<%=rowData.get("USR_DELY_TO_LOCATION")%>" readOnly> 
			          	  <%}else{ %>
			          	  	   <input class="CART_AddboxSmall_input" style="width:178px"   name="item_dely_to_location_name" id="item_dely_to_location_name<%=j %>" value="<%=rowData.get("DELY_TO_LOCATION_NAME")%>" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1426")%>"/>
					           <input class="CART_AddboxSmall_input ml04" style="width:638px"  name="item_dely_to_location_text" id="item_dely_to_location_text<%=j %>" value="<%=rowData.get("DELY_TO_LOCATION_TEXT")%>" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1361")%>"/>
					           <input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code<%=j %>" value="<%=rowData.get("DELY_TO_LOCATION")%>" readOnly> 
			          	  <%} %>
				          </div>
				          <div class="CART_AddboxSmallDetail_Row">
				          <%if(CommonUtil.nvl(rowData.get("RECV_USER_NAME")).equals("")){ %>
					           <input class="CART_AddboxSmall_input" style="width:176px" name="item_recv_user" id="item_recv_user<%=j %>" value="<%=rowData.get("USR_USER_NAME_LOC")%>" placeholder="<%=CommonLang.get("HTITLE1427")%>" type="text" />
				          <%}else{ %>
				          	   <input class="CART_AddboxSmall_input" style="width:176px" name="item_recv_user" id="item_recv_user<%=j %>" value="<%=rowData.get("RECV_USER_NAME")%>" placeholder="<%=CommonLang.get("HTITLE1427")%>" type="text" />
				          <%} %>
				          <%if(CommonUtil.nvl(rowData.get("RECV_USER_TEL")).equals("")){ %>
					          	<%if(p060000100_col2.equals("A")){%><!-- 수령자, 전화번호, 도착지 값을 세션정보로 자동 셋팅 :A -->
						           <input class="CART_AddboxSmall_input ml04" style="width:330px" name="item_recv_user_phone" id="item_recv_user_phone<%=j %>" value="<%=rowData.get("USR_PHONE_NUMBER")%>" placeholder="<%=CommonLang.get("HTITLE1428")%>" maxlength="20" type="text" onkeyup="kepNumcheck3(this);" /> 
						        <%}else if(p060000100_col2.equals("B")){%><!-- 수령자, 휴대폰, 도착지 값을 세션정보로 자동 셋팅 :B -->
						           <input class="CART_AddboxSmall_input ml04" style="width:330px" name="item_recv_user_phone" id="item_recv_user_phone<%=j %>" value="<%=mphone %>" placeholder="<%=CommonLang.get("HTITLE1428")%>" type="text" maxlength="20" onkeyup="kepNumcheck3(this);" />
						        <%} %>
				          <%}else{ %>
				          	   <input class="CART_AddboxSmall_input ml04" style="width:330px" name="item_recv_user_phone" id="item_recv_user_phone<%=j %>" value="<%=rowData.get("RECV_USER_TEL")%>" placeholder="<%=CommonLang.get("HTITLE1428")%>" maxlength="20" type="text" onkeyup="kepNumcheck3(this);"/> 
				          <%} %>
				       <%}else{ %>
			          	  	   <input class="CART_AddboxSmall_input" style="width:178px"   name="item_dely_to_location_name" id="item_dely_to_location_name<%=j %>" value="" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1426")%>"/>
					           <input class="CART_AddboxSmall_input ml04" style="width:638px"  name="item_dely_to_location_text" id="item_dely_to_location_text<%=j %>" value="<%=rowData.get("DELY_TO_LOCATION_TEXT")%>" type="text" readonly placeholder="<%=CommonLang.get("HTITLE1361")%>"/>
					           <input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code<%=j %>" value="<%=rowData.get("DELY_TO_LOCATION")%>" readOnly> 
				          </div>
				          <div class="CART_AddboxSmallDetail_Row">
				          	   <input class="CART_AddboxSmall_input" style="width:176px" name="item_recv_user" id="item_recv_user<%=j %>" value="<%=rowData.get("RECV_USER_NAME")%>" placeholder="<%=CommonLang.get("HTITLE1427")%>" type="text" />
				          	   <input class="CART_AddboxSmall_input ml04" style="width:330px" name="item_recv_user_phone" id="item_recv_user_phone<%=j %>" value="<%=rowData.get("RECV_USER_TEL")%>" placeholder="<%=CommonLang.get("HTITLE1428")%>" maxlength="20" type="text" /> 
				       <%} %>
				       
				       	<div class="ReceiveDateTit"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></div>
			           	<div class="datepicker-wrap" id="item_recv_date_div<%=j%>"><div class="date-input" data-datepicker><input type="text" id="item_recv_date_hope<%=j %>" name="item_recv_date_hope" value="<%=CommonUtil.formatStrinigDate(req_date)%>" readonly onchange="javascript:recvDateCheck('item','<%=j %>');" /><span> </span></div></div>
			          </div>
			          <div class="Importance mt10 mr20"><img src="/resources/imgs/Icon_Importance03.png" /><%=CommonLang.msg("MSG891")%><!--휴대폰번호를 정확히 입력하셔야 배송현황을 안내 받을 수 있습니다.--></div>
			        </div>        
      			<%}%>
      			
			    </div>
      		<%} %>
      	<%} %>
      <script>
      // 모든 X 버튼 선택
      const closeButtons = document.querySelectorAll('.CART_PDbox_CloseBtn');
      closeButtons.forEach(function(button) {
        button.addEventListener('click', function(){
          const CART_PDbox = button.parentElement;
          var index = button.id;
          var st_item_no          = $("#st_item_no"+index).val();
          var st_contract_no      = $("#st_contract_no"+index).val();
          var st_contract_seq     = $("#st_contract_seq"+index).val();
          var st_agent_code       = $("#st_agent_code"+index).val();
          var st_byit_comorg_code = $("#st_byit_comorg_code"+index).val();
          var st_cart_seq			= $("#st_seq"+index).val();
			
		  var query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq;
          query += "&&";

  		  document.forms.processForm.next_status.value = "DELETE";
  		  document.forms.processForm.st_update.value = query; 
		  
          CART_PDbox.style.opacity = '0'; // 부드럽게 사라지는 효과
          setTimeout(function(){CART_PDbox.remove();kepAjaxFormCallNoBar("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE2");}, 300); // 0.3초 후 완전히 삭제
        });
      });
      </script>
  		<div class="Paging mt20">
			<%=CommonUtil.getPageSearchView("kepSearch",total_cnt, curPage ,onepagerow) %>
    	</div>
      <!--버튼 -->  
      <div class="CART_Sort mt15 BorderTopSolid pt10">
         <%if (_gridList != null && _gridList.size() != 0){ %>
         <label class="CheckLargeLabel"><input type="checkbox" id="checkedAll2" name="checkedAll" class="checkedAllClass" onclick="javascript:checkedAllBox('checkedAll2');"><span class="CheckLargeCustom"></span></label>
         <button class="ButOutline_Medium" onclick="javascript:doAction('setCartDelete'); return false;"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></button> 
         <div class="Rright">
			<%if(!p060000100.equals("")){%>
				<span><%=CommonLang.get("HTITLE1429")%><!--일괄등록-->│</span>
				<button class="ButOutline_Medium" onclick="javascript:doPop('get_delivery_to_location_all','<%=buyer %>'); return false;"><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --></button>
				<%if(!p060000029_col03.equals("FORM9") && !p060000029.equals("TYPE20")) {%> 
					<button class="ButOutline_Medium" onclick="javascript:doPop('ref_pr_no_all'); return false;" ><%=p060000029_btnLabel%><!-- 관리번호 --></button>
				<%} %>
				<button class="ButOutline_Medium" onclick="javascript:recvDateOpen(); return false;" ><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></button>
			<%}else{ %>
					<%if(!p060000029_col03.equals("FORM9") && !p060000029.equals("TYPE20")) {%>
						<span><%=CommonLang.get("HTITLE1429")%><!--일괄등록-->│</span>
						<button class="ButOutline_Medium" onclick="javascript:doPop('ref_pr_no_all'); return false;" ><%=p060000029_btnLabel%><!-- 관리번호 --></button>
					<%} %>
			<%} %>
         </div>
		<%} %>
      </div>
      <!--버튼 -->  
      <div class="CART_Button mt20">
      <%  if(budget_flag.equals("Y")){    %>
            	<%
				if (_gridList == null || _gridList.size() == 0){        
				}else{
				%>
				<button class="But_ExcelDown40" style="position:absolute; left:0; top:0;" 
           onclick="javascript:doAction('excelDownload'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
				<%} %>
		<%} %>
         <div class="Rright">
           <button class="But_ExcelDown40" onclick="javascript:doPop('excelUpload'); return false;"><%=CommonLang.get("HTITLE34") %><!-- 엑셀업로드 --></button>
           <% if(!reportText.equals("NONE")) {%>
				<button class="ButOutline_Medium" onclick="javascript:<%=reportFunction%>; return false;"><%=reportText%></button>
           <%} %>
           <%if(!reportText2.equals("")){ %>
           		<button class="ButOutline_Medium" onclick="javascript:doAction('PrSheet2'); return false;"><%=reportText2%></button>
           <%} %>
           <button class="ButDarkGray_Medium" onclick="javascript:doAction('SAVE'); return false;" ><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button>
         </div>
      </div>        
    </div><!-- CARTleft -->
    
    
    
    <div class="CARTright">
      <div class="OptionBoxLine"> <div class="OptionTit mt30 mb30 ml20 mr20"><%=CommonLang.get("HTITLE1430")%><!--선택품목--> <p class="OptionBoxLine_Num"><span id="st_check_sum_cnt_text"></span><%=CommonLang.get("HTITLE96")%><!-- 개 --></p></div></div>
      <div class="OptionTit mt30 mb30 ml20 mr20"><%=CommonLang.get("HTITLE1059")%><!-- 주문금액 --> <p class="OptionBoxLine_Pric mt10"><span id="st_check_sum_price_text"></span><%=CommonLang.get("HTITLE660")%><!-- 원 --></p></div>
      <div class="Option_GrayBox  mt50">
        <div class="OptionTit_m"><label class="CheckMediumLabel" id="st_agree_flag_label" tabindex="-1"><input type="checkbox" name="st_agree_flag" id="st_agree_flag"><span class="CheckMediumCustom"></span> </label> <%=CommonLang.msg("MSG895")%><!--연락처 공유에 동의합니다.--></div>
        <div class="OptionTit_mtxt BorderTopSolid"><img src="/resources/imgs/Icon_Importance02.png" /> <%=CommonLang.msg("MSG896")%><!--배송사에 인수자 연락처가 전달되며,--> <br/><span style="display:inline-block; margin-left:19px; letter-spacing:-0.4px"><%=CommonLang.msg("MSG897")%><!--안내문자 또는 유선안내에 사용됩니다.--></span></div>
      </div>
      <div class="CARTBox" id="CART-Box">
      <%if(p060000081 == true){%>
      	<button class="ButPrimary_large mt15 mb08" onclick="javascript:doAction('Transfer');return false;"><%=CommonLang.get("HTITLE235") %><!-- 전송 --></button><br/>
      <%}else if(p060000084 == true){%>
      	<button class="ButPrimary_large mt15 mb08" onclick="javascript:doAction('Checkout');return false; ">CHECK-OUT<!-- 체크아웃 --></button><br/>
      <%}else{ %>
      	<%if (userRole2.equals("+")) { %>
      		<button class="ButPrimary_large mt15 mb08" onclick="javascript:doAction('ORDER');return false;"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></button><br/>
        <%} %>
      <%} %>
      </div><!-- CARTBox -->
      <script>
		
	</script>
    </div><!-- CARTright -->
  </div>
</form>  
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>	
	<input type="hidden" name="next_status" id="next_status"  value=""/> 
	<input type="hidden" name="st_update" id="st_update"  value=""/> 
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
	<input type="hidden" name="_sendUrl" id="_sendUrl" value="" />
	<input type="hidden" name="_punchoutOrderMessageXML" id="_punchoutOrderMessageXML" value="" />
	<input type="hidden" name="_pForm" id="_pForm" value="" />
	<input type="hidden" name="_pMethod" id="_pMethod" value="" />
	<input type="hidden" name="p060000100" id="p060000100" value="<%=p060000100%>" />
</form>

<form name="locationForm" id="locationForm" method="post">	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
	<input type="hidden" name="st_description" id="st_description" value="">
	<input type="hidden" name="st_specification" id="st_specification" value="">
	<input type="hidden" name="st_maker_name" id="st_maker_name" value="">			 
	<input type="hidden" name="st_verif_num" id="st_verif_num" value="<%=st_verif_num %>" /> 	
	<input type="hidden" name="st_zip_code"       value="<%=st_zip_code%>">
	<input type="hidden" name="st_tel_no"         value="<%=st_tel_no%>">
	<input type="hidden" name="st_fax_no"         value="<%=st_fax_no%>">
	<input type="hidden" name="st_mobile_no"      value="<%=st_mobile_no%>">
	<input type="hidden" name="st_user_name"      value="<%=st_user_name%>">
	<input type="hidden" name="st_email"          value="<%=st_email%>">
	<input type="hidden" name="st_user_id"        value="<%=st_user_id%>">
	<input type="hidden" name="st_query_cart"     value="<%=st_query_cart%>">
	<input type="hidden" name="st_recv_date"      value="<%=st_recv_date%>">
	<input type="hidden" name="st_recv_date2"     value="<%=st_recv_date2%>">
	<input type="hidden" name="st_remark"         value="<%=st_remark%>">
	<input type="hidden" name="st_location_code"  value="<%=st_location_code%>">
	<input type="hidden" name="st_location_type"  value="<%=st_location_type%>">
	<input type="hidden" name="st_location_code_name"  value="<%=st_location_code_name%>">
	<input type="hidden" name="st_location_name"  value="<%=st_location_name%>">
	<input type="hidden" name="st_purchase_dept_name"  value="<%=st_purchase_dept_name%>">
	<input type="hidden" name="st_purchase_dept_code"  value="<%=st_purchase_dept_code%>">
</form>
 <form name="refPrNoForm" id="refPrNoForm" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=SessionComCode%>">
	<input type="hidden" name="st_ref_no" id="st_ref_no" value="">
	<input type="hidden" name="st_ref_no_text" id="st_ref_no_text" value="">
	<input type="hidden" name="st_type" id="st_type" value="">
	<input type="hidden" name="st_form" id="st_form" value="<%=p060000029_col03%>">
	<input type="hidden" name="st_pop_type" id="st_pop_type" value="<%=p060000029%>">
	<input type="hidden" name="st_gbn" id="st_gbn" value="">
	<input type="hidden" name="st_title" id="st_title" value="">
	<input type="hidden" name="open" id="open" value="Y">
	<input type="hidden" name="st_row" id="st_row" value="">
	<input type="hidden" name="st_remark" id="st_remark" value="">
	<input type="hidden" name="st_item_no" id="st_item_no" value="">
	<input type="hidden" name="st_cart_yn" id="st_cart_yn" value="Y">
	<input type="hidden" name="st_account_type" id="st_account_type" value="">
	<input type="hidden" name="glAccount_fill_flag_all" id="glAccount_fill_flag_all" value="">
</form>
 <form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>

<div class="DIVpopup-overlay popupOverlay" id="recvDateSelOverlay" style="display: none;"></div>
<div class="DIVpopup" id="recvDateSel" style="display: none;">
  <div class="wrapPopupAlert small-calendar">
    <div class="AlertTxtSmall" style="display: flex; flex-direction:column; align-items:center;">
    <div class="OptionTit_Date"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></div>
        <div class="datepicker-wrap" style=" width:150px; margin-right:8px"><div class="date-input" data-datepicker style=" width:140px;"><input type="text" id="imsi_recv_date" name="imsi_recv_date" placeholder="" readonly onchange="javascript:recvDateCheck('all');"/><span> </span></div></div>
    </div>
    <div class="h20"></div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:recvDateCancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:recvDateSel(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body> 
<script type="text/javascript">
var errorFlag = false;
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";
var but1funcAgree = "javascript:closePopText2(); focusAgreeFlag(); return false;";

function focusAgreeFlag(){
	var $label = $("#st_agree_flag_label");
	if($label.length == 0) return;

	var $mark = $label.find(".CheckMediumCustom");
	if($mark.length > 0){
		$mark.css({"outline":"2px solid #F6495F", "outline-offset":"2px"});
		setTimeout(function(){ $mark.css({"outline":"", "outline-offset":""}); }, 3000);
	}

	var el = $label.get(0);
	var rect = el.getBoundingClientRect();
	var needScroll = (rect.top < 0 || rect.bottom > window.innerHeight);

	function setFocus(){
		try { el.focus({preventScroll:true}); } catch(e) { el.focus(); }
	}

	if(needScroll){
		$("html, body").animate({
			scrollTop: $label.offset().top - (window.innerHeight / 2)
		}, 300, setFocus);
	}else{
		setFocus();
	}
}


const CARTBox = document.getElementById('CART-Box');
const footer = document.querySelector('.footer');
const CARTcontainer = document.querySelector('.CARTcontainer');
const CARTright = document.querySelector('.CARTright');

function updateCARTBoxPosition() {
  const rightRect = CARTright.getBoundingClientRect();
  const footerRect = footer.getBoundingClientRect();
  const viewportHeight = window.innerHeight;

  // .CARTright의 문서 좌표 기준 왼쪽 위치 계산
  const rightLeft = rightRect.left + window.scrollX;

  // footer가 화면에 들어왔는지 확인
  const footerTop = footerRect.top + window.scrollY;
  const viewportBottom = window.scrollY + viewportHeight;
  
  const offsetFromBottom = 40;

  if (viewportBottom >= footerTop) {
    // footer 진입 시 CARTcontainer 내부에 고정
    CARTBox.classList.remove('CartBottomBox-fixed');
    CARTBox.classList.add('CartBottomBox-absolute');
    CARTBox.style.CARTleft = ""; // fixed CARTleft 해제
    CARTBox.style.bottom = "";
  } else {
    // 일반 스크롤 시 화면 하단 고정
    CARTBox.classList.remove('CartBottomBox-absolute');
    CARTBox.classList.add('CartBottomBox-fixed');
    CARTBox.style.CARTleft = rightLeft+"px"; // 옵션박스의 왼쪽 라인 기준
    CARTBox.style.bottom = offsetFromBottom+"px";
  }
}

window.addEventListener('scroll', updateCARTBoxPosition);
window.addEventListener('resize', updateCARTBoxPosition);
updateCARTBoxPosition();

var popupSel = "";

var p060000029 = "<%=p060000029%>";
var p060000029_col06 = "<%=p060000029_col06%>";
var p060000027 = "<%=p060000027%>";
var p060000027_msg ="<%=p060000027_msg%>";
var p060000035 = "<%=p060000035%>";
var p060000077 = "<%=p060000077%>";
var p060000084_type	="<%=p060000084_type%>";
//주문배수 체크
var p060000089 = "<%=p060000089%>";
//관리부서로 인한 주문 통제
var p060000090 = "<%=p060000090%>";
// 품목별 도착지 지정
var p060000100 = "<%=p060000100%>";

//일진row
var iljin_row = "";
var gridIndex = 0;

// 최초 화면 함수 
function kep_onload_view(){	
	$("#contentForm").on("input change", "input", function() {
		clearError(this);
	});
}

var st;
//기능함수
function doAction(str) {	
	
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
		break;
 
	case "PrSheet":	  
		item_qty_update('PrSheet');
		break;

	case "PrSheet2":	//출력물  
		PrSheetView2();
		break;
		
	case "PrSheetViewSiem":	  
		PrSheetViewSiem();
		break;	
		
	case "SAVE":	  
		item_qty_update('SAVE');
		break;	
		
	case "setCartDelete":	  
		setCartDelete();
		break;	
		
	case "ORDER":	  
		item_qty_update('ORDER');
		break;		
		
	case "Transfer":
		item_qty_update('TRANS');
		break;
	
	case "Checkout":
		item_qty_update('CHECKOUT');
		break;
	case "excelDownload":
		excelDownload();
		break;
	}
}
function doPop(str,value1,value2,value3) {	
	popupSel = str;
	
	switch (str) {
	case "ref_pr_no":	 //관리번호 팝업
		var st_pop_type = document.forms.refPrNoForm.st_pop_type.value;
		var st_form = document.forms.refPrNoForm.st_form.value;
		
		document.forms.refPrNoForm.st_row.value = value1;
		document.forms.refPrNoForm.st_ref_no.value = $("#st_ref_pr_no"+value1).val();
		
		var st_width = "";
		var st_height = "";
		var st_gbn = "";
		var st_title = "";
		if(st_form == "FORM1"){
			if(st_pop_type == "TYPE4" || st_pop_type == "TYPE7"){
				st_gbn = "<%=CommonLang.get("HTITLE1260")%>"; //Cost Center 명
				st_title = "<%=CommonLang.get("HTITLE1259")%>"; //CostCenter
			}else if(st_pop_type == "TYPE5"){
				document.forms.refPrNoForm.st_type.value = "M014";
				st_title = "<%=CommonLang.get("HTITLE1436")%>";//하이트진로㈜ 이천공장 현장소모품 팀
				st_gbn = "<%=CommonLang.get("HTITLE1437")%>";//현장소모품팀
			}else if(st_pop_type == "TYPE41"){
				st_title = "<%=p060000029_col05%>";
				st_gbn = "<%=p060000029_col05%>";
			}else if(st_pop_type == "TYPE100" || st_pop_type == "TYPE13" || st_pop_type == "TYPE14" || st_pop_type == "TYPE23"){
				st_title = "<%=CommonLang.get("HTITLE18")%>";//관리번호
				st_gbn = "<%=CommonLang.get("HTITLE18")%>";//관리번호
			}else if(st_pop_type == "TYPE20"){
				st_title = "<%=CommonLang.get("HTITLE733")%>";//예산 상세계정
				st_gbn = "<%=CommonLang.get("HTITLE733")%>";//예산 상세계정
				var mng_flag = $("#st_mng_flag"+value1).val();
		    	if(mng_flag != "Y"){ // 판촉물 계정이 아닐 때
					// 판촉물 계정 선택 시 관리번호를 선택할 수 있습니다.
					var text = "<%=CommonLang.msg("MSG429")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
		    	}
			}else if(st_pop_type == "TYPE29"){
				st_title = "<%=CommonLang.get("HTITLE1438")%>";//G/L계정
				st_gbn = "<%=CommonLang.get("HTITLE1438")%>";//G/L계정
			}else if(st_pop_type == "TYPE30"){
				st_title = "<%=CommonLang.get("HTITLE1439")%>";//관리목록
				st_gbn = "<%=CommonLang.get("HTITLE1439")%>";//관리목록
			}else if(st_pop_type == "TYPE31"){
				st_title = "<%=CommonLang.get("HTITLE1440")%>";//코드 값
				st_gbn = "<%=CommonLang.get("HTITLE1440")%>";//코드 값
			}
			
			document.forms.refPrNoForm.st_type.value = "M014";
			st_width = "695";
			st_height = "500";
		}else if(st_form == "FORM2"){
			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "550";
			st_height = "430";
		}else if(st_form == "FORM3"){
			document.forms.refPrNoForm.st_item_no.value = $("#st_item_no"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "760";
			st_height = "420";
		}else if(st_form == "FORM4"){
			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "550";
			st_height = "300";
		}else if(st_form == "FORM5"){
			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "740";
			st_height = "480";
		}else if(st_form == "FORM6"){
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "580";
			st_height = "300";
		}else if(st_form == "FORM7"){
			st_title = "<%=CommonLang.get("HTITLE1264")%>"; //코스트센터/계정선택
			st_width = "550";
			st_height = "450";
		}else if(st_form == "FORM8"){
			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1345")%>"; //장바구니 정보 입력
			st_width = "570";
			st_height = "330";
		}else if(st_form == "FORM9"){
			var aclist = new Array(); 
			<%for(int i = 0; i < aclist.size(); i ++) {
				%>
				aclist.push('<%=aclist.get(i)%>');
			<%}
			%>
			
			var account_type = $("#st_account_type"+value1).val();
			var acCnt = 0;
			
			for(var i = 0; i < <%=aclist.size()%>; i++) {    	
		    	if(account_type == aclist[i]) {
		    		acCnt++;
		    	}
		    }
			if(acCnt > 0){
				document.forms.refPrNoForm.st_ref_no_text.value = $("#st_ref_pr_no_text"+value1).val();
				document.forms.refPrNoForm.st_account_type.value = $("#st_account_type"+value1).val();
				document.forms.refPrNoForm.st_type.value = "Z014";
				st_title = "<%=CommonLang.get("HTITLE1352")%>"; //고정자산번호 입력
				st_width = "600";
				st_height = "310";
			}else{
				return;
			}
		}else if(st_form == "FORM10"){
			st_title = "<%=CommonLang.get("HTITLE1347")%>"; //계정/코스트센터 선택
			st_width = "550";
			st_height = "300";
		}else if(st_form == "FORM11"){
			st_width = "695";
			st_height = "500";
		}else if(st_form == "FORM12"){
			st_title = "<%=CommonLang.get("HTITLE1348")%>"; //계정/코스트센터/계정지정범주 선택
			st_width = "565";
			st_height = "330";
		}
		
		document.forms.refPrNoForm.st_gbn.value = st_gbn;
		document.forms.refPrNoForm.st_title.value = st_title;
		
		openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm","showBuyerRefPrNoPop_v2","width="+st_width+",height="+st_height+",resizable=no,scrollbars=no");
		break;
	case "ref_pr_no_all":	 //관리번호 팝업 일괄
		//체크된 건 있는지 체크
		var tot_cnt  = $("#display_item_cnt").val();
		var chk_cnt = 0; 

	    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
	    	// 목록에 표시된 상품이 없습니다.     
	        var text = "<%=CommonLang.msg("MSG16") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
	        return;
	    }
		chk_cnt = getCheckedRowCount(tot_cnt); 
		if(chk_cnt == "0"){
	    	// 하나 이상의 상품이 선택되어야 합니다.   
	        var text = "<%=CommonLang.msg("MSG17") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
	        return;
		}
		
		var st_pop_type = document.forms.refPrNoForm.st_pop_type.value;
		var st_form = document.forms.refPrNoForm.st_form.value;
		
		var st_width = "";
		var st_height = "";
		var st_gbn = "";
		var st_title = "";
		
		if(st_form == "FORM1"){
			if(st_pop_type == "TYPE4" || st_pop_type == "TYPE7"){
				st_gbn = "<%=CommonLang.get("HTITLE1260")%>"; //Cost Center 명
				st_title = "<%=CommonLang.get("HTITLE1259")%>"; //CostCenter
			}else if(st_pop_type == "TYPE5"){
				document.forms.refPrNoForm.st_type.value = "M014";
				st_title = "<%=CommonLang.get("HTITLE1436")%>"; //하이트진로㈜ 이천공장 현장소모품 팀
				st_gbn = "<%=CommonLang.get("HTITLE1437")%>";//현장소모품팀
			}else if(st_pop_type == "TYPE41"){
				st_title = "<%=p060000029_col05%>";
				st_gbn = "<%=p060000029_col05%>";
			}else if(st_pop_type == "TYPE100" || st_pop_type == "TYPE13" || st_pop_type == "TYPE14" || st_pop_type == "TYPE23"){
				st_title = "<%=CommonLang.get("HTITLE18")%>"; //관리번호
				st_gbn = "<%=CommonLang.get("HTITLE18")%>"; //관리번호
			}else if(st_pop_type == "TYPE20"){
				st_title = "<%=CommonLang.get("HTITLE733")%>"; //예산 상세계정
				st_gbn = "<%=CommonLang.get("HTITLE733")%>"; //예산 상세계정
				for(var i = 0; i<tot_cnt; i++){
					if($("#lnCheck"+i).is(":checked")){
						var mng_flag = $("#st_mng_flag"+i).val();
						if(mng_flag != "Y"){ // 판촉물 계정이 아닐 때
							// 판촉물 계정 선택 시 관리번호를 선택할 수 있습니다.
							var text = "<%=CommonLang.msg("MSG429") %>  ";
					     	openLayerPopText2(text,but1text,but1func,but1width);
							return;
				    	}
					}
				}
			}else if(st_pop_type == "TYPE29"){
				st_title = "<%=CommonLang.get("HTITLE1438")%>";//G/L계정
				st_gbn = "<%=CommonLang.get("HTITLE1438")%>";//G/L계정
			}else if(st_pop_type == "TYPE30"){
				st_title = "<%=CommonLang.get("HTITLE1439")%>"; //관리목록
				st_gbn = "<%=CommonLang.get("HTITLE1439")%>"; //관리목록
			}else if(st_pop_type == "TYPE31"){
				st_title = "<%=CommonLang.get("HTITLE1440")%>";//코드 값
				st_gbn = "<%=CommonLang.get("HTITLE1440")%>";//코드 값
			}
			
			document.forms.refPrNoForm.st_type.value = "M014";
			st_width = "695";
			st_height = "500";
		}else if(st_form == "FORM2"){
// 			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "550";
			st_height = "430";
		}else if(st_form == "FORM3"){
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "760";
			st_height = "420";
			
			var start1 = false; //4로 시작하는지
			var start2 = false; //4로 시작하지 않는지
			for(var i = 0; i<tot_cnt; i++){
				if($("#lnCheck"+i).is(":checked")){
					var buyer_item_no_start = $("#st_item_no"+i).val().substring(0,1);
					if(buyer_item_no_start == "4"){
						start1 = true;
					}else{
						start2 = true;
					}
					
					if(start1 && start2){
						//동일한 유형의 품목코드만 선택해주시기 바랍니다.
<%-- 						var text = "<%=CommonLang.msg("MSG999")%>"; --%>
						var text = "동일한 유형의 품목코드만 선택해주시기 바랍니다.";
				     	openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}
			}
			if(buyer_item_no_start == "4"){ // 4로 시작하는 상품코드일 경우
				$("#glAccount_fill_flag_all").val("Y");
			}else{
				$("#glAccount_fill_flag_all").val("N");
			}
		}else if(st_form == "FORM4"){
// 			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "550";
			st_height = "300";
		}else if(st_form == "FORM5"){
// 			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "740";
			st_height = "480";
		}else if(st_form == "FORM6"){
			st_title = "<%=CommonLang.get("HTITLE1267")%>"; //MRO 구매품목 관리항목 등록
			st_width = "580";
			st_height = "300";
		}else if(st_form == "FORM7"){
			st_title = "<%=CommonLang.get("HTITLE1264")%>"; //코스트센터/계정선택
			st_width = "550";
			st_height = "450";
		}else if(st_form == "FORM8"){
// 			document.forms.refPrNoForm.st_remark.value = $("#st_remark"+value1).val();
			st_title = "<%=CommonLang.get("HTITLE1345")%>"; //장바구니 정보 입력
			st_width = "570";
			st_height = "330";
		}else if(st_form == "FORM9"){
			var aclist = new Array(); 
			<%for(int i = 0; i < aclist.size(); i ++) {
				%>
				aclist.push('<%=aclist.get(i)%>');
			<%}
			%>
			
			var acCnt = 0;
			
			for(var i = 0; i < <%=aclist.size()%>; i++) {
				for(var j = 0 ; j < tot_cnt; j++){
					if($("#lnCheck"+j).is(":checked")){
						var account_type = $("#st_account_type"+j).val();
						if(account_type == aclist[i]) {
				    		acCnt++;
				    	}
					}
				}
		    }
			
			if(acCnt > 0){
// 				document.forms.refPrNoForm.st_ref_no_text.value = $("#st_ref_pr_no_text"+value1).val();
// 				document.forms.refPrNoForm.st_account_type.value = $("#st_account_type"+value1).val();
				document.forms.refPrNoForm.st_type.value = "Z014";
				st_title = "<%=CommonLang.get("HTITLE1352")%>"; //고정자산번호 입력
				st_width = "600";
				st_height = "310";
			}else{
				return;
			}
		}else if(st_form == "FORM10"){
			st_title = "<%=CommonLang.get("HTITLE1347")%>"; //계정/코스트센터 선택
			st_width = "550";
			st_height = "300";
		}else if(st_form == "FORM11"){
			st_width = "695";
			st_height = "500";
		}else if(st_form == "FORM12"){
			st_title = "<%=CommonLang.get("HTITLE1348")%>"; //계정/코스트센터/계정지정범주 선택
			st_width = "565";
			st_height = "330";
		}else{ // 특수로직 아닌 것 + select박스인 type
			st_title = "<%=CommonLang.get("HTITLE1507")%>"; //관리번호 일괄 등록
			st_width = "440";
			st_height = "230";
		}
		
		document.forms.refPrNoForm.st_gbn.value = st_gbn;
		document.forms.refPrNoForm.st_title.value = st_title;
		
		openSearchPopupPost("/common/showBuyerRefPrNoPop_v2.do","refPrNoForm","showBuyerRefPrNoPop_v2","width="+st_width+",height="+st_height+",resizable=no,scrollbars=no");
		break;
		
	case "get_delivery_to_location_all":
		//체크된 건 있는지 체크
		var tot_cnt  = $("#display_item_cnt").val();
		var chk_cnt = 0; 

	    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
	    	// 목록에 표시된 상품이 없습니다.     
	        var text = "<%=CommonLang.msg("MSG16") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
	        return;
	    }
		chk_cnt = getCheckedRowCount(tot_cnt); 
		if(chk_cnt == "0"){
	    	// 하나 이상의 상품이 선택되어야 합니다.   
	        var text = "<%=CommonLang.msg("MSG17") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
	        return;
		}
		
		var com_code = value1;
		openSearchPopup("/common/delLocationTwoTabPop_v2.do", "?com_code="+com_code, "930,630,no");
		break;
		
	case "excelUpload":
		openSearchPopup("/mpso/showBuyerMpSoCartUploadPop_v2.do", "", "1400,610,no");
		break;
	}
}
/**
 * 출력물 추가
 */
function PrSheetView2(){

    var buyer               = "<%=buyer%>";
    var user_id             = "<%=userId%>";
    var dup_add_posb_yn = "<%=dup_add_posb_yn%>";

    var tot_cnt  = $("#display_item_cnt").val();

    var chk_cnt = 0; 
    var query   = "";
    
    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//  목록에 표시된 상품이 없습니다.     
        var text = "<%=CommonLang.msg("MSG16") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        var text = "<%=CommonLang.msg("MSG17") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var st_item_no   = $("#st_item_no"+k).val();
            var st_contract_no = $("#st_contract_no"+k).val();
            var st_contract_seq = $("#st_contract_seq"+k).val();
            var st_seq = $("#st_seq"+k).val();

            if($("#lnCheck"+k).is(":checked")){
            	if(dup_add_posb_yn == "Y"){
            		query += st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
            	}else{
            		query += st_item_no + st_contract_no  + st_contract_seq + "@@";
            	}
            }
        }
    }//end else

    reportOpen("<%=reportid2%>","["+query+"]["+buyer+"]["+user_id+"]");     

}

// 조회
function kepSearch(curPage){

	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartList.do").submit();	
	   
}

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 장바구니 담기
 
 */
/**
 * 바로주문
 * 저장
 */
function item_qty_update(next_status){  // CART : 배송지 입력화면 이동,   ORDER : 주문최종 확인 화면 이동	

    var tot_cnt         = $("#display_item_cnt").val();
    var chk_cnt         = 0;
    var query           = ""; 
    var buyer           =  document.forms.searchForm.st_buyer.value;   

    var ck_ref_pr_dept  = "";	
	var p060000125 = "<%=p060000125%>";
	var p060000125_list = p060000125.split("@@");
    var budget_flag = "<%=budget_flag%>";
    
    var p060000127 = "<%=p060000127%>";
	var p060000127_list = p060000127.split("@@");
	var p060000128 = "<%=p060000128%>";
	var p060000128_list = p060000128.split("@@");
	
    //묶음배송일경우 여부 체크
    
    var Ccnt = 0; // 엘앤에프(KRLAND0003) 전용
    var nonCcnt = 0; // 엘앤에프(KRLAND0003) 전용

    // MSDS 품목 확인
    var p060000137  = "<%=p060000137%>";
    
    // 주문시 동일 계쩡 - 예산- 부서코드만 선택하도록 제한
    var p060000138 = "<%=p060000138%>";
    var ck_budget_dept = "";
    var ck_account_type = "";
    var ck_ref_pr_no = "";
    
    //시약 품목과 타 품목 같이 주문 못하도록 통제
    var bca00006 = "<%=bca00006%>";
    
    if(eval(tot_cnt) == 0)
    {
        //조회한 데이타가 없습니다.
        var text = "<%=CommonLang.msg("MSG69") %>";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);

    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.   
        var text = "<%=CommonLang.msg("MSG17") %>";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    
    if(next_status == "ORDER"){ //바로주문일 경우 체크
          if(!$("#st_agree_flag").is(":checked")){
          	//연락처 공유에 동의해주세요.
          	var text = "<%=CommonLang.msg("MSG885") %>";
         	openLayerPopText2(text,but1text,but1funcAgree,but1width);
          	return;
          }
    }

        var cNum = 0;
        var old_st_agent_code="";
        var diff_agent_status="false";
        

        for(var j = 0; j  <tot_cnt; j++){
 
            var st_item_no          = $("#st_item_no"+j).val();
            var st_order_qty        = kepTrimStr($("#st_order_qty"+j).val());
            var st_ref_pr_no        = $("#st_ref_pr_no"+j).val();            
            var st_contract_no      = $("#st_contract_no"+j).val();
            var st_contract_seq     = $("#st_contract_seq"+j).val();
            var st_fixed_price_flag = $("#st_fixed_price_flag"+j).val();
            var st_order_price      = $("#st_order_price"+j).val();
            var st_account_type     = $("#st_account_type"+j).val();
            var st_budget_dept      = $("#st_budget_dept"+j).val();
            var product_close_flag  = $("#st_product_close_flag"+j).val();
            var process_type        = $("#st_process_type"+j).val();
            var stock_item_flag     = $("#st_stock_item_flag"+j).val();
            var ref_pr_dept         = $("#st_ref_pr_dept"+j).val();
            var remark              = $("#st_remark"+j).val(); 
            var st_agent_code       = $("#st_agent_code"+j).val();
            var mg_code             = $("#st_mg_code"+j).val();
            var mg_note             = $("#st_mg_note"+j).val();
            var item_status_flag    = $("#st_item_status_flag"+j).val();
            var st_cart_seq			= $("#st_seq"+j).val();
            var st_size_qty      	= $("#st_size_qty"+j).val();
            var st_size_len      	= $("#st_size_len"+j).val();
            var st_mng_flag			= $("#st_mng_flag"+j).val();
            var item_mng_flag		= $("#st_item_mng_flag"+j).val();
            var st_min_order_qty	= $("#st_min_order_qty"+j).val();
            var st_dely_bundle_flag	= "N";//묶음배송 여부
            var st_pur_unit_qty		= $("#st_pur_unit_qty"+j).val(); //주문배수
            var st_mng_dept_cd 		= $("#st_mng_dept_cd"+j).val(); //관리부서
            var st_mgmt_no_req_yn	= $("#st_mgmt_no_req_yn"+j).val(); //종근당그룹 관리번호(프로젝트코드) 필수여부
            var st_account_type_name= $("#st_account_type_name"+j).val(); //계정정보
            var st_over_short_flag  = $("#st_over_short_flag"+j).val(); //품절여부
            var st_stock_cnt      	= $("#st_stock_cnt"+j).val(); //재고수량
            var st_atch_flag 		= $("#st_atch_flag"+j).val();
            var st_image_key		= $("#st_image_key"+j).val();
            var st_buyer_category_no = $("#st_buyer_category_no"+j).val();
            var st_urct2_yn			= $("#st_urct2_yn"+j).val();
            var st_budget_bal_amt	= $("#st_bdgt_bal_amt"+j).val();
            var st_msds_yn			= $("#st_msds_yn"+j).val();
            var st_pr_reason        = $("#st_pr_reason"+j).val();
            
            if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
            	var item_dely_to_location_text = $("#item_dely_to_location_text"+j).val();
            	var item_dely_to_location_code = $("#item_dely_to_location_code"+j).val();
            	var item_recv_user = $("#item_recv_user"+j).val();
            	var item_recv_user_phone = $("#item_recv_user_phone"+j).val();
            	var item_rd_date = $("#item_recv_date_hope"+j).val().replace(/[/]/gi,"");
            }else{
            	var item_dely_to_location_text = $("#dely_to_location_text").val();
            	var item_dely_to_location_code = $("#dely_to_location_code").val();
            	var item_recv_user = $("#recv_user").val();
            	var item_recv_user_phone = $("#recv_user_phone").val();
            	var item_rd_date = $("#recv_date_hope").val().replace(/[/]/gi,"");
            }
            
            if($("#lnCheck"+j).is(":checked")){ 
            	// 특정 카테고리 주문 통제 특수로직
                for(var i = 0; i < p060000125_list.length; i++) {
                	if(st_buyer_category_no == p060000125_list[i]) {
                		// 품목코드 + 설정된 메세지 출력
                		var text = st_item_no+ " <%=p060000125_msg%>";
                     	openLayerPopText2(text,but1text,but1func,but1width);
                		return;
                	}
                }
            	
             	// 특정 카테고리 & 특정 사용자 주문 통제 특수로직
             	for(var i = 0; i < p060000128_list.length; i++) { // 카테고리 체크
             		var order_posb_yn = "N";
             		if(st_buyer_category_no == p060000128_list[i]) {
	             		for(var k = 0; k < p060000127_list.length; k++) {
		                	if("<%=userId%>" == p060000127_list[k]) { // 세션 사용자 체크(허용)
		                		order_posb_yn = "Y";
		                	}
		                }
	             		
	             		if(order_posb_yn == "N"){ // 허용 사용자 목록에 없는 경우(원래값 유지되면)
	             			//각자 설정한 메세지로 출력
	                    	var text = "("+ st_item_no + ") " + "<%=p060000128_msg%>";
	                     	openLayerPopText2(text,but1text,but1func,but1width);
	                		return;
	             		}
             		}
             	}
             	
            	if(st_item_no.startsWith('C')) {  // 엘앤에프(KRLAND0003) 시약 품목 중복 발주 금지 용 (거래 종료 후 제거)
                	Ccnt++;            	
                } else {
                	nonCcnt++;
                }
            	//URCT2 여부 확인
            	if(st_urct2_yn != "Y"){
            		//주문할 수 없는 카테고리의 상품입니다.
            		var text = st_item_no + " <%=CommonLang.msg("MSG588")%>";
                 	openLayerPopText2(text,but1text,but1func,but1width);
    	        	return;
            	}
            	
            	// 첨부 필수 확인
        		if(st_atch_flag == "Y" && isEmpty(st_image_key)){
        			//품목은 첨부파일이 필수입니다.
        			var text = st_item_no+" <%=CommonLang.msg("MSG886")%>";
                 	openLayerPopText2(text,but1text,but1func,but1width);
	        		return;
	        	}
            	
                cNum++;
                if(cNum ==1 ){
                    ck_ref_pr_dept = ref_pr_dept;
                    
                    //p060000138 확인용
                    ck_ref_pr_no = st_ref_pr_no; //  G/L 번호 (용인연구소만)
                    ck_budget_dept = st_budget_dept;
                    ck_account_type = st_account_type;
                }
                
                // msds 품목인 경우 통제
                if(p060000137 == "TYPE1"){ // 개인정보에 사번 있는지 확인
                	var empno = "<%=empno%>";
                	if(st_msds_yn == "Y" && kepIsValueNull(empno.trim())){
                		//주문하시는 품목 중 MSDS 관리품목이 포함되어 있습니다.<br/>개인정보 화면에서 사번을 입력하신 후 다시 주문해 주세요
                		var text = "<%=CommonLang.msg("MSG887")%>";
                     	openLayerPopText2(text,but1text,but1func,but1width);
                		return;
                	}
                }
                
                
                // 주문 시 계정코드 - 예산부서 - 코스트센터 - 자금관리센터 - G/L번호 일치하는지 확인
                if(!isEmpty(p060000138)){
                	if(next_status == "ORDER"){
                		if(ck_budget_dept != st_budget_dept || ck_account_type != st_account_type){
                			//관리번호, 예산계정 정보가 모두 일치해야 합니다.
                			var text = "<%=CommonLang.msg("MSG888")%>";
                         	openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                		}
                		if(p060000138 == "TYPE2"){
                			if(ck_ref_pr_no != st_ref_pr_no){
                				//관리번호, 예산계정 정보가 모두 일치해야 합니다.
                    			var text = "<%=CommonLang.msg("MSG888")%>";
                             	openLayerPopText2(text,but1text,but1func,but1width);
                    			return;
                			}
                		}
                	}
                }
                
                if(old_st_agent_code != '' && old_st_agent_code != st_agent_code){
                    diff_agent_status = "true";
                }

                //관리부서가 다를 경우 주문 불가능.
                if(p060000090 == "true"){
                	//관리부서 공백 체크.
                    if(isEmpty(st_mng_dept_cd)){
                    	//예산계정의 관리부서 정보가 없어 주문이 불가능 합니다.
                    	var text = "<%=CommonLang.msg("MSG910")%>";
                     	openLayerPopText2(text,but1text,but1func,but1width);
                     	emptyError("#budgetDiv"+j);
                        return;
                    }
                	for(var k = 0; k < tot_cnt; k++){
                		if($("#lnCheck"+k).is(":checked")){
                			if(st_mng_dept_cd != $("#st_mng_dept_cd"+k).val()){
                            	//의 계정코드는 개별 신청하시기 바랍니다.
                            	var text = st_account_type_name+"<%=CommonLang.msg("MSG537")%>";
                             	openLayerPopText2(text,but1text,but1func,but1width);
                                return;                				
                			}	
                		}
                	}
                }
                old_st_agent_code=st_agent_code;

                if(product_close_flag == "Y"){
                	//번째 품목은 단종되었습니다.
                   var text = (j+1)+"<%=CommonLang.msg("MSG138")%>";
                   openLayerPopText2(text,but1text,but1func,but1width);
                   propCheckBox(j, false);
                   return;
                }
                if(item_status_flag == "삭제"){
                	//번째 품목은 삭제되었습니다.
                     var text = (j+1)+"<%=CommonLang.msg("MSG139")%>";
                   openLayerPopText2(text,but1text,but1func,but1width);
                    propCheckBox(j, false);
                    return;
                 }
            	if(st_over_short_flag == "Y"){
                	//번째 품목은 품절되었습니다.
                     var text = (j+1)+"<%=CommonLang.msg("MSG550")%>";
                   openLayerPopText2(text,but1text,but1func,but1width);
                    propCheckBox(j, false);
                    return;
                }
                if(process_type=="1" && stock_item_flag=="N"){
                	//재고 수량이 부족합니다. 재고 수량 확인 바랍니다.
                	 var text = "<%=CommonLang.msg("MSG551")%>";
                     openLayerPopText2(text,but1text,but1func,but1width);
                    propCheckBox(j, false);
                    return;
                }

                if(st_order_price == 0){
                	//발주단가를 KeP 담당자에게 확인하여 주시기 바랍니다.
                	 var text = "<%=CommonLang.msg("MSG589")%>";
                     openLayerPopText2(text,but1text,but1func,but1width);
                	return;
                }
                
                if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || kepIsValueNull(st_order_qty) || !kepChkDecimal(st_order_qty,3)){
                	//번째 품목의 발주수량(숫자)을 입력하여 주십시요.
                    var text = (j+1)+"<%=CommonLang.msg("MSG140")%>";
                    openLayerPopText2(text,but1text,but1func,but1width);
                	$("#st_order_qty"+j).focus();
                    return;
                }
                //재고관리 품목일 경우
                if(st_stock_cnt != ""){
                	if(Number(st_order_qty) > Number(st_stock_cnt)){
                		//재고 수량이 부족합니다. 재고 수량 확인 바랍니다.
                    	var text = "<%=CommonLang.msg("MSG551")%>";
                        openLayerPopText2(text,but1text,but1func,but1width);
                    	$("#st_order_qty"+j).focus();
                        return;
                        
                	}
                }
                //MOQ 주문 통제 특수로직 적용한 고객사 한정
                if(p060000077 == "true"){
	    			if(Number(st_order_qty) < Number(st_min_order_qty)){
	                    //최소주문수량에 맞게 수량을 설정해주세요.
	                	var text = "<%=CommonLang.msg("MSG611")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
	                	$("#st_order_qty"+j).focus();
	                    return;				
	    			}
                }
                //주문배수 주문 통제 특수로직 적용한 고객사 한정
                if(p060000089 == "true"){
                	var checkNum = st_order_qty%st_pur_unit_qty;
        			if(checkNum != 0 ){
                        //주문배수에 맞게 수량을 설정해주세요.
                    	var text = "<%=CommonLang.msg("MSG609")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                    	$("#st_order_qty"+j).focus();
                        return;				
        			}            	
                }
                
                //|| buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" 제거
                if(p060000027=="TYPE2") { // KRHONG0020
                    if(ck_ref_pr_dept != ref_pr_dept){
                    	//서로다른 대학원 학과를 입력 하셨습니다.대학원 학과란을 클릭하여 확인하여 주십시요.
                        var text = "<%=CommonLang.msg("MSG142")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.관리번호란을 클릭하여 선택하여 주십시요.
                    	var text = "<%=CommonLang.msg("MSG122")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                }else if(p060000027=="TYPE4") { // KRHYOS0055, KRHYOS0062, KRHYOS0063, KRHYOS0064, KRHYOS0065, KRHYOS0076
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	if(next_status != "PrSheet"){
                    		//관리번호가 입력되지 않았습니다.\n관리번호 란에 Cost center를 입력하여 주십시오.
                        	var text = "<%=CommonLang.msg("MSG124")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                            return;                		
                    	}
                    }
                
                }else if(p060000029 == "TYPE5"){
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.
                        var text = "<%=CommonLang.msg("MSG121")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                }else if(p060000029 == "TYPE20") { //에스와이에스리테일 관리번호 필수 체크
                	if(st_mng_flag == "Y"){ // 판촉물 계정 선택 시
                		if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    		//관리번호(상세계정) 입력 바랍니다.
                        	var text = "<%=CommonLang.msg("MSG943")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                            return;
                        }	
                	}
                	
                	if(item_mng_flag == "NMCD"){ // 명함 품목 시
                		remark = $("#st_remark"+j).val(); // 명함정보 저장용 비고 사용
                		
                		if(remark == "" || remark == "null" || remark == null || remark == " "){
                			// 명함정보를 입력하여 주시기 바랍니다.
                			var text = "<%=CommonLang.msg("MSG436")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                		}
                	}
                }else if(p060000029 == "TYPE22") { //동화그룹 관리번호 필수 체크
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        //관리번호가 선택되지 않았습니다. 관리번호란을 클릭하여 선택하여 주십시요.
                		var text = "<%=CommonLang.msg("MSG126")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                	if(st_item_no.substr(0,1) == "4"){ //4로 시작하는 품목코드 gl_account 존재 확인
                		var tmpArrp = st_ref_pr_no.split("%%");
                		var gl_account_val = tmpArrp[8];
                		if(gl_account_val == "" || gl_account_val == "null" || gl_account_val == null || gl_account_val == " "){
                			//4***** 품목코드는 G/L Account가 필수입력입니다.
                			var text = "<%=CommonLang.msg("MSG542")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                            return;
                		}
                	}
                }else if(p060000029 == "TYPE100" || p060000029=="TYPE27" || p060000029=="TYPE29" || p060000029=="TYPE30") {
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//관리번호가 선택되지 않았습니다. 관리번호란을 클릭하여 선택하여 주십시요.
                		var text = "<%=CommonLang.msg("MSG126")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                }else if(p060000029=="TYPE31") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호(WBS코드)가 선택되지 않았습니다. 관리번호란을 클릭하여 WBS코드를 선택하여 주십시요.
                        var text = "<%=CommonLang.msg("MSG559")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                }else if(p060000029=="TYPE32") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호(그룹웨어 품의 번호) 기재 바랍니다.
                        var text = "<%=CommonLang.msg("MSG944")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }
                }else if(p060000029=="TYPE33") {
                	var ref_pr_no_temp = st_ref_pr_no.split('^');
                	if(<%=SolbPlantYn%>) {            		
                		if(ref_pr_no_temp[0] == "" || ref_pr_no_temp[0] == null) {
                			//관리번호(플랜트/코스트센터/계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 입력하여 주십시오.
                			var text = "<%=CommonLang.msg("MSG564")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                		}            		
                	}
                    if(<%=SolbCostCenterYn%>) {
                    	if(ref_pr_no_temp[1] == "" || ref_pr_no_temp[1] == null) {
                    		//관리번호(플랜트/코스트센터/계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 입력하여 주십시오.
                			var text = "<%=CommonLang.msg("MSG564")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                		} 
                    }
                    if(ref_pr_no_temp[2] == "" || ref_pr_no_temp[2] == null) {
                    	//관리번호(플랜트/코스트센터/계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 입력하여 주십시오.
                    	var text = "<%=CommonLang.msg("MSG564")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
            			return;
                    }
                }else if(p060000029=="TYPE34") { // 한샘
                	if(st_buyer_category_no.indexOf("<%=p060000129_col01%>") != -1){ // 카테고리가 전산몰인경우 검증 로직 추가
                		var ref_pr_no_temp = st_ref_pr_no.split('^');
                        if(isEmpty(ref_pr_no_temp[0]) || isEmpty(ref_pr_no_temp[1]) || isEmpty(ref_pr_no_temp[2]) 
                        		|| isEmpty(ref_pr_no_temp[3]) || isEmpty(ref_pr_no_temp[4])) {
                        	//번째 관리항목이 등록되지 않았습니다. 관리번호란을 클릭하여 입력하여 주십시오.
                        	var text = (j+1) + "<%=CommonLang.msg("MSG151")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                        }
                        if(isEmpty(st_image_key)){ // 품의서 첨부 확인 처리
                        	// 번째 첨부파일이 빠져있습니다.
                        	var text = (j+1) + "<%=CommonLang.msg("MSG150")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                        if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	// 번째 카테고리에 맞는 예산 계정을 선택해주세요.
                        	var text = (j+1) + "<%=CommonLang.msg("MSG149")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                	}
                	if(st_buyer_category_no.substr(0, 3) == "<%=p060000129_col02%>"){ // 카테고리가 총무카테고리인 경우 검증 로직 추가
                		// 예산이 총무가 아닌경우
                        if(st_account_type.indexOf('-') == -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	// 번째 카테고리에 맞는 예산 계정을 선택해주세요.
                        	var text = (j+1) + "<%=CommonLang.msg("MSG149")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                   	}else{ // 카테고리가 총무가 아닌경우 총무 예산 사용 금지
    	               	// 예산이 총무인 아닌경우
                   		if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	// 번째 카테고리에 맞는 예산 계정을 선택해주세요.
                        	var text = (j+1) + "<%=CommonLang.msg("MSG149")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                   	}
                	if(item_mng_flag == "NMCD"){ // 명함 품목 시
                		remark = $("#st_remark"+j).val(); // 명함정보 저장용 비고 사용
                		if(remark == "" || remark == "null" || remark == null || remark == " "){
                			// 명함정보를 입력하여 주시기 바랍니다.
                			var text = "<%=CommonLang.msg("MSG436")%>";
    	                    openLayerPopText2(text,but1text,but1func,but1width);
                			return;
                		}
                	}
                }else if(p060000029 == "TYPE35") { // 넥센타이어
                	var aclist = new Array(); 
                	<%for(int i = 0; i < aclist.size(); i ++) {
                		%>
                		aclist.push('<%=aclist.get(i)%>');
                	<%}
                	%>
                	
                	for(var i = 0; i < <%=aclist.size()%>; i++) {    	
                    	if(st_account_type == aclist[i]) {
                    		if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    			// 관리번호(고정자산번호)를 선택해주세요
                    			var text = "<%=CommonLang.msg("MSG945")%>";
        	                    openLayerPopText2(text,but1text,but1func,but1width);
        	                    return;
        	                }
                    	}
                    }         	
                	
                } else if(p060000029 == "TYPE36") { // 아모레퍼시픽 연구소
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		// 관리번호(G/L번호)를 선택해주세요
                		var text = "<%=CommonLang.msg("MSG946")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }            	   	
                	
                }else if(p060000029 == "TYPE37") { // 중외제약
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		// 관리번호(예산계정코드)를 선택해주세요
                		var text = "<%=CommonLang.msg("MSG947")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
                        return;
                    }            	   	
                	
	            }else if(p060000029 == "TYPE39") { // LB세미콘주식회사
	            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	            		// 관리번호(계정/코스트센터)를 선택해주세요
	            		var text = "<%=CommonLang.msg("MSG948")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
	                    return;
	                }
	            }
	            else if(p060000029 == "TYPE40") { // (주)한솔홈데코
	            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	            		// 계정과목, 코스트센터, 계정지정범주를 모두 입력 해주세요
	            		var text = "<%=CommonLang.msg("MSG857")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
	                    return;
	                }
				}else if(p060000029 == "TYPE41"){ // 종근당 그룹 관리번호 필수 설정
					if(p060000029_col06 == "Y"){ // BNTSLGIMP.COL06_DATA='Y'(예: 뉴라테온) 회사는 예산계정 지정 없이 무조건 관리번호 필수
						if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
							// 관리번호가 선택되지 않았습니다. 관리번호란을 클릭하여 선택하여 주십시요.
							var text = "<%=CommonLang.msg("MSG126")%>";
							openLayerPopText2(text,but1text,but1func,but1width);
							return;
						}
					}else{ // 종근당 본사 등: 선택한 예산계정(TEXT4=MGMT_NO_REQ_YN)이 'Y'인 경우에만 관리번호 필수
						if(st_mgmt_no_req_yn == "Y"){
							if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
								// 관리번호가 선택되지 않았습니다. 관리번호란을 클릭하여 선택하여 주십시요.
								var text = "<%=CommonLang.msg("MSG126")%>";
								openLayerPopText2(text,but1text,but1func,but1width);
								return;
							}
						}
					}
				}
                else {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
                        st_ref_pr_no = " ";
                    }
                }
                

                if(budget_flag == "Y" && next_status =="ORDER"){
                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                    	// 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요
                        var text = (j+1) + "<%=CommonLang.msg("MSG152")%>";
	                    openLayerPopText2(text,but1text,but1func,but1width);
	                    emptyError("#budgetDiv"+j);
                        return;
                    }
                    
                    if(st_budget_bal_amt < 0){
                    	// 번째 예산이 초과되어 예산계정을 다시 선택해주세요
                    	 var text = (j+1) + "<%=CommonLang.msg("MSG595")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                    emptyError("#budgetDiv"+j);
                    	return;
                    }
                }
                
				// 품목별 도착지 지정 고객사
    			if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
    				// 도착지 필수 체크
    				if(item_dely_to_location_text == "" || item_dely_to_location_text == "null" || item_dely_to_location_text == null || item_dely_to_location_text == " "){
    					// 번째 품목의 배송지가 입력되지 않았습니다.
    					 var text = (j+1) + "<%=CommonLang.msg("MSG860")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                    emptyError("#item_dely_to_location_text"+j);
    					return;
    				}
    				// 인수자 필수 체크
    				if(item_recv_user == "" || item_recv_user == "null" || item_recv_user == null || item_recv_user == " "){
    					// 번째 품목의 인수자가 입력되지 않았습니다.
    					 var text = (j+1) + "<%=CommonLang.msg("MSG861")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                   emptyError("#item_recv_user"+j);
    					return;
    				}
    				// 전화번호 필수 체크
    				if(item_recv_user_phone == "" || item_recv_user_phone == "null" || item_recv_user_phone == null || item_recv_user_phone == " "){
    					// 번째 품목의 연락처가 입력되지 않았습니다.
    					var text = (j+1) + "<%=CommonLang.msg("MSG862")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                   emptyError("#item_recv_user_phone"+j);
    					return;
    				}
    				if(item_recv_user_phone.length < 9){
    					// 번째 연락처를 최소 9자 이상 입력해주세요
    					var text = (j+1) + "<%=CommonLang.msg("MSG956")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                   emptyError("#item_recv_user_phone"+j);
    					return;
    				}
    				//수령희망일 체크
    				if(item_rd_date == "" || item_rd_date == "null" || item_rd_date == null || item_rd_date == " "){
    					//번째 품목 수령희망일이 입력되지 않았습니다.
    					var text = (j+1) + "<%=CommonLang.msg("MSG907")%>";
 	                    openLayerPopText2(text,but1text,but1func,but1width);
 	                    emptyError("#item_recv_date_div"+j);
    					return;
    				}
    			}else{
    				if(next_status == "ORDER"){ //주문하기 눌렀을 때만 
    					var item_dely_to_location_text = $("#dely_to_location_text").val();
                    	var item_dely_to_location_code = $("#dely_to_location_code").val();
                    	var item_recv_user = $("#recv_user").val();
                    	var item_recv_user_phone = $("#recv_user_phone").val();
                    	var item_rd_date = $("#recv_date_hope").val().replace(/[/]/gi,"");
        				// 도착지 필수 체크
        				if(item_dely_to_location_text == "" || item_dely_to_location_text == "null" || item_dely_to_location_text == null || item_dely_to_location_text == " "){
        					//배송지가 입력되지 않았습니다.
        					var text = "<%=CommonLang.msg("MSG889")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                   emptyError("#dely_to_location_text");
        					return;
        				}
        				// 인수자 필수 체크
        				if(item_recv_user == "" || item_recv_user == "null" || item_recv_user == null || item_recv_user == " "){
        					//인수자가 입력되지 않았습니다.
        					var text = "<%=CommonLang.msg("MSG873")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                    emptyError("#recv_user");
        					return;
        				}
        				// 전화번호 필수 체크
        				if(item_recv_user_phone == "" || item_recv_user_phone == "null" || item_recv_user_phone == null || item_recv_user_phone == " "){
        					//연락처가 입력되지 않았습니다.
        					var text = "<%=CommonLang.msg("MSG874")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                    emptyError("#recv_user_phone");
        					return;
        				}
        				if(item_recv_user_phone.length < 9){
        					//연락처를 최소 9자 이상 입력해주세요
        					var text = "<%=CommonLang.msg("MSG957")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                    emptyError("#recv_user_phone");
        					return;
        				}
        				if(item_recv_user_phone == "" || item_recv_user_phone == "null" || item_recv_user_phone == null || item_recv_user_phone == " "){
        					//연락처가 입력되지 않았습니다.
        					var text = "<%=CommonLang.msg("MSG874")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                    emptyError("#recv_user_phone");
        					return;
        				}
        				//수령희망일 체크
        				if(item_rd_date == "" || item_rd_date == "null" || item_rd_date == null || item_rd_date == " "){
        					//수령희망일이 입력되지 않았습니다.
        					var text = "<%=CommonLang.msg("MSG908")%>";
     	                    openLayerPopText2(text,but1text,but1func,but1width);
     	                   emptyError("#recv_date_div");
        					return;
        				}
    				}
    			}
				
    			// 품목별 구매사유 입력 필수 고객사
   			<%if(pr_reason_yn.equals("Y")) { %>
   	            if(st_pr_reason == ""){
   	            	// 번째 구매사유를 입력해주세요.
   	            	var text = (j+1) + "<%=CommonLang.msg("MSG768")%>";
	                openLayerPopText2(text,but1text,but1func,but1width);
	                emptyError("#st_pr_reason"+j);
   	            	return;
   	            }
   			<%}%>
   				if(next_status == "TRANS"||next_status == "CHECKOUT"){
   	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
               		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq;
               		query += "|";
   				}
//    				else if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){ // 품목별 도착지 지정
//    	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
//                		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq + "@@" + st_dely_bundle_flag + "@@"
//                		+ item_dely_to_location_code + "@@" + item_dely_to_location_text + "@@" + item_recv_user + "@@" + item_recv_user_phone;
//                		query += "|";
//    				}
   				else{ //품목별배송지가 아닌 경우에도 입력한 배송정보로 icomcart update
   					query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
               		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq + "@@" + st_dely_bundle_flag + "@@"
               		+ item_dely_to_location_code + "@@" + item_dely_to_location_text + "@@" + item_recv_user + "@@" + item_recv_user_phone + "@@" + item_rd_date;
               		query += "|";
//    	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@"
//    	                + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq + "@@" + st_dely_bundle_flag;
//                		query += "|";
   				}
            }
        } // for 문 종료
        if(bca00006 == "true" && Ccnt != 0 &&  nonCcnt != 0) { // 엘앤에프 시약 품목(품목코드 C로 시작) 타 품목과 중복 발주 금지 로직(거래 종료 후 제거)
        	// C코드(시약류) 품목의 경우, 타 품목과 중복 발주 불가능하므로 발주 목록에서 제외 후 별도 발주 진행바랍니다.
        	var text = "<%=CommonLang.msg("MSG579")%>";
            openLayerPopText2(text,but1text,but1func,but1width);
        	return;
        } 
     
    if(next_status == 'TRANS'){
        /*
    	작 업 일 : 20160306
	      작 업 자 : 최철규
	      작업내역 : 빙그레 인터페이스 전송기능
	    */ 
        document.forms.processForm.next_status.value = next_status;
        document.forms.processForm.st_update.value = query;
        kepAjaxFormCall("/mpso/transferBuyerShoppingcartQtyUpdate.do","processForm","TRANS");
    }else if(next_status == 'CHECKOUT'){
    	/*
    	작 업 일 : 20160306
	      작 업 자 : 최철규
	      작업내역 : 체크아웃 기능
	    */ 
        document.forms.processForm.next_status.value = next_status;
        document.forms.processForm.st_update.value = query;
        
        if (p060000084_type == "TYPE01") {
            getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessage.do","processForm",next_status);	
        } else if (p060000084_type == "TYPE03") { // 셰플러코리아
        	getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessageFagb.do","processForm",next_status);
        } else if (p060000084_type == "TYPE05") { // 유한킴벌리
        	getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessageYHKB.do","processForm",next_status);
        }
    }else{
        document.forms.processForm.next_status.value = next_status;
        document.forms.processForm.st_update.value = query; 

    	kepAjaxFormCall("/mpso/saveBuyerShoppingcartSizeQtyUpdate.do","processForm",next_status); 
    }
}

/**
 * 삭제
 */
function setCartDelete(){
 
    var tot_cnt     =  $("#display_item_cnt").val();
    var chk_cnt     = 0;
    var query       = "";    
    
    if(eval(tot_cnt) == 0)
    {
    	//조회한 데이타가 없습니다.
        var text = "<%=CommonLang.msg("MSG69")%>";
        openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);

    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.   
        var text = "<%=CommonLang.msg("MSG17")%>";
        openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{
    	//선택된 상품을 장바구니에서 삭제하시겠습니까?
    	var text = "<%=CommonLang.msg("MSG530")%>"; 
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:setCartDeleteEnd(); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
     	return;
    }
}
function setCartDeleteEnd(){
	closePopText1();
	var tot_cnt     =  $("#display_item_cnt").val();
	var query = "";
	for(var i = 0 ; i<tot_cnt; i++){
		if($("#lnCheck"+i).is(":checked")){
			var st_item_no          = $("#st_item_no"+i).val();
            var st_contract_no      = $("#st_contract_no"+i).val();
            var st_contract_seq     = $("#st_contract_seq"+i).val();
            var st_agent_code       = $("#st_agent_code"+i).val();
            var st_byit_comorg_code = $("#st_byit_comorg_code"+i).val();
            var st_cart_seq			= $("#st_seq"+i).val();
			
			query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq;
            query += "&&";
		}
	}

    document.forms.processForm.next_status.value = "DELETE";
    document.forms.processForm.st_update.value = query; 
	kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE"); 
}

/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	var chk_cnt = 0;
    for(var j = 0; j < tot_cnt; j++){
    	if($("#lnCheck"+j).is(":checked")){
    		chk_cnt++;
    	}
    }
	return chk_cnt;
}

//선택 품목 총 합계금액, 수량
function chk_sum_price(){
    var maxRow = $("#display_item_cnt").val();
    var sum_price = 0;
    var sum_qty = 0;
    var sum_cnt = 0;

    for(var j = 0; j < maxRow; j++){
    	if($("#lnCheck"+j).is(":checked")){
    		sum_price = eval(sum_price) + eval(kepFilterNum($("#st_sum_price"+j).val()));
			sum_qty = sum_qty + kepFilterNum($("#st_order_qty"+j).val());
			sum_cnt ++;
    	}
    }
    
    $("#st_check_sum_price").val(sum_price);
    $("#st_check_sum_price_text").html(kepCommaNum(sum_price));
    $("#st_check_sum_cnt").val(sum_cnt);
    $("#st_check_sum_cnt_text").html(kepCommaNum(sum_cnt));
}

/**
 * 팝업호출
 */
function cartPrSheet(){
    var buyer               = "<%=buyer%>";
    var user_id             = "<%=userId%>";
    var dup_add_posb_yn = "<%=dup_add_posb_yn%>";

    var tot_cnt  = $("#display_item_cnt").val();

    var chk_cnt = 0; 
    var query   = "";

    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	// 목록에 표시된 상품이 없습니다.     
        var text = "<%=CommonLang.msg("MSG16")%>";
        openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        var text = "<%=CommonLang.msg("MSG17")%>";
        openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{

        for(var k = 0; k < tot_cnt; k++){
            var st_item_no   = $("#st_item_no"+k).val();
            var st_contract_no = $("#st_contract_no"+k).val();
            var st_contract_seq = $("#st_contract_seq"+k).val();
            var st_seq = $("#st_seq"+k).val();
            
            if($("#lnCheck"+k).is(":checked")){
            	if(dup_add_posb_yn == "Y"){
            		query += st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
            	}else{
            		query += st_item_no + st_contract_no  + st_contract_seq + "@@";
            	}
            }
        }
    }//end else
/* 품의서 출력 제한 START */
    	if(chk_cnt > 50){
    		//품의서는 최대 50건씩 출력 가능합니다.\n정렬개수를 조정하여 페이지당 출력해주시기 바랍니다.
    		var text = "<%=CommonLang.msg("MSG154")%>";
            openLayerPopText2(text,but1text,but1func,but1width);
    		return;
    	}else{
    		reportOpen("<%=reportid%>","["+query+"]["+buyer+"]["+user_id+"]");
    	}
/* 품의서 출력 제한 END */
}

function PrSheetViewSiem(){
    var userId = "<%=userId%>";
    var userComCode = "<%=buyer%>";    
    reportOpen("<%=reportid%>","[]["+userComCode+"]["+userId+"]");  
}

function price_update_P(y_num, buy_price,orgin_cart_qty){
    var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
         var cart_qty = document.forms.contentForm.st_order_qty.value;
         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
         }else{
             var sum_price = kepGetRound((cart_qty * buy_price),3);
             document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
             if(budget_flag == "Y"){
//             	 var bdgt_bal_amt = document.forms.contentForm.st_budget_amt.value;
//                  if(eval(sum_price) > eval(bdgt_bal_amt)){
//                 	 document.forms.contentForm.st_bdgt_bal_amt.style.color = '#ee3212';
//                  }else{
//                 	 document.forms.contentForm.st_bdgt_bal_amt.style.color = '#003694';
//                  }
            	 document.forms.contentForm.st_bdgt_bal_amt.value = 0;
				 document.forms.contentForm.st_budget_dept_name.value = "";
				 document.forms.contentForm.st_budget_dept.value = "";
            	 document.forms.contentForm.st_account_type_name.value = "선택";
            	 document.forms.contentForm.st_account_type.value = "";
            	 
             }
         }
    }else{
         var cart_qty = document.forms.contentForm.st_order_qty[y_num].value;
         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
         }else{
             var sum_price = kepGetRound((cart_qty * buy_price),3);
             document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(sum_price);
             if(budget_flag == "Y"){
//             	 var bdgt_bal_amt = document.forms.contentForm.st_budget_amt[y_num].value;
//                  if(eval(sum_price) > eval(bdgt_bal_amt)){
//                 	 document.forms.contentForm.st_bdgt_bal_amt[y_num].style.color = '#ee3212';
//                  }else{
//                 	 document.forms.contentForm.st_bdgt_bal_amt[y_num].style.color = '#003694';
//                  }
				 document.forms.contentForm.st_bdgt_bal_amt[y_num].value = 0;
				 document.forms.contentForm.st_budget_dept_name[y_num].value = "";
				 document.forms.contentForm.st_budget_dept[y_num].value = "";
            	 document.forms.contentForm.st_account_type_name[y_num].value = "선택";
            	 document.forms.contentForm.st_account_type.value = "";
             }
         }
    }
    chk_sum_price(); // 선택 품목 총 합계금액
}

/*
 * 관리번호 세팅
 */


// 예산계정 선택 팝업
function getBdgtAccountPop(com_code,dept_code,row,categ)
{ 
    var tot_cnt  = $("#display_item_cnt").val();        
    var order_qty = "";
    var order_price = "";
    var description = "";
    var box = "";
    gridIndex = row;
    var account_pop_search_set = "<%=account_pop_search_set%>";
    
    propCheckBox(row, true);
    order_qty = $("#st_order_qty"+row).val();
    order_price = $("#st_order_price"+row).val();
    description = $("#st_description"+row).val();
    
    chk_sum_price(); 
    var cart_sum_price =$("#st_check_sum_price").val(); 
 
    var val = "";
    if(account_pop_search_set == "Y"){ // 자동조회 미사용, 조회조건 필수 입력
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=N&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_search_set=Y", "850,690,no");
    }else if(p060000029 == "TYPE34"){
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_account_flg="+categ.substr(0, 1), "850,640,no");
    }else{ // PG_06_B_006_40 buyerMpSoAccountSelPop
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price, "850,640,no"); 
    } 
    return;
}

//예산계정 설정
function setBdgtAccount(account_type , account_name, dept_code , dept_name, mg_code, mg_note, bdgt_bal, mng_dept_cd, mng_dept_nm, mgmt_no_req_yn){
   	 	var tot_cnt  = $("#display_item_cnt").val();
    
        for(var k =0; k < tot_cnt; k++){
        	if($("#lnCheck"+k).is(":checked")){
        		if(p060000090 =="true"){
            		$("#st_account_type_name"+k).val(account_name+"("+mng_dept_nm+")");	
            	}else{
            		$("#st_account_type_name"+k).val(account_name);
            	}
        		
        		$("#st_mng_dept_cd"+k).val(mng_dept_cd);
        		$("#st_mgmt_no_req_yn"+k).val(mgmt_no_req_yn);
        		$("#st_account_type"+k).val(account_type);
        		$("#st_budget_dept_name"+k).val(dept_name);
        		$("#st_budget_dept"+k).val(dept_code);
        		
        		$("#st_bdgt_bal_amt"+k).val(kepNumComma2(mg_code));
        		$("#st_budget_amt"+k).val(mg_code);
        		$("#st_mng_flag"+k).val(mg_note);
        		$("#st_bdgt_bal_amt"+k).css("color","#003694");
        		
        		
        		if(p060000029 == "TYPE20" || p060000029 == "TYPE35"){ // 에스와이에스리테일(KRSYSR0001) 일 때 예산부서 변경 시 예산 상세계정(관리번호) 초기화,넥센타이어 예산 계정 변경 시 고정자산번호 초기화
    		    	$("#st_ref_pr_no_text"+k).val("");
    		    	$("#st_ref_pr_no"+k).val("");
                }
        		
        		clearError("#budgetDiv"+k);
        	}
        }
}

// 팝업 콜백함수
function setPopupReturn(type,value1,value2,value3,value4){
    var tot_cnt  =  $("#display_item_cnt").val();
	if (popupSel == "attach"){
		$("#st_image_key"+gridIndex).val(type);
		if(value1 > 0){
			saveAttach(gridIndex,value1);
		}else{
			$("#st_file_upload_but"+gridIndex).attr("class","ButOutline_Small mt15");
		    $("#st_file_upload_cnt"+gridIndex).html("");
		}
   		
	}else if(popupSel == "namecard_info"){
		if(type != ""){
			$("#st_remark"+gridIndex).val(type);
			$("#st_name_card_info"+gridIndex).attr("class","ButOutline_Small_on mt05");
			$("#st_name_card_view"+gridIndex).attr("class","ButOutline_Small_on mt05");
			nameCardView(gridIndex,$("#st_namecard_rpt"+gridIndex).val(),$("#st_item_no_mng_detl"+gridIndex).val());
		}
	}else if(popupSel == "get_delivery_to_location_all"){ //배송지 일괄등록
		for(var i = 0; i < tot_cnt; i++){
			if($("#lnCheck"+i).is(":checked")){
				if(type != ""){
					$("#item_dely_to_location_text"+i).val(value1).trigger("change");
					$("#item_dely_to_location_name"+i).val(value2+"("+type+")");
					$("#item_dely_to_location_code"+i).val(type);
				}
				if(value3 != ""){ //인수자명
					$("#item_recv_user"+i).val(value3);
				}
				if(value4 != ""){ //인수자연락처
					$("#item_recv_user_phone"+i).val(value4);
				}
			}
		}
	}else if (popupSel == "locationTop"){
		$("#dely_to_location_text").val(value1).trigger("change");
		$("#dely_to_location_name").val(value2+"("+type+")");
		$("#dely_to_location_code_name").val(value2);
		$("#dely_to_location_code").val(type);
	}else if (popupSel == "location"){
		$("#item_dely_to_location_text"+gridIndex).val(value1).trigger("change");
		$("#item_dely_to_location_name"+gridIndex).val(value2+"("+type+")");
		$("#item_dely_to_location_code"+gridIndex).val(type);
		
		for(var k = 0 ; k<tot_cnt; k++){
			if($("#lnCheck"+k).is(":checked")){
				$("#item_dely_to_location_text"+k).val(value1).trigger("change");
				$("#item_dely_to_location_name"+k).val(value2+"("+type+")");
				$("#item_dely_to_location_code"+k).val(type);
				$("#item_recv_user"+k).val($("#item_recv_user"+gridIndex).val()).trigger("change");
				$("#item_recv_user_phone"+k).val($("#item_recv_user_phone"+gridIndex).val()).trigger("change");
				$("#item_recv_date_hope"+k).val($("#item_recv_date_hope"+gridIndex).val());
			}
		}
	}else if(popupSel == "ref_pr_no"){ // 관리번호 팝업
		var p060000029 = "<%=p060000029%>";
    	//type = index , value1 = code , value2 = text
    	//TYPE14일경우 
    	if(p060000029  == "TYPE14" || p060000029  == "TYPE23"){
    		$("#st_ref_pr_no_text"+type).val(value2);
    		$("#st_ref_pr_no"+type).val(value2);
    	}else if(p060000029  == "TYPE16" || p060000029  == "TYPE26" || p060000029  == "TYPE27"){
    		$("#st_ref_pr_no_text"+type).val(value1);
    		$("#st_ref_pr_no"+type).val(value1);
    		$("#st_remark"+type).val(value2);
    	}else if(p060000029  == "TYPE20"){
    		$("#st_ref_pr_no_text"+type).val(value1+"("+value2+")");
    		$("#st_ref_pr_no"+type).val(value1+"("+value2+")");
    	}else if(p060000029  == "TYPE100" ){
    		$("#st_ref_pr_no"+type).val(value1);
		}else if(p060000029  == "TYPE41"){
    		$("#st_ref_pr_no"+type).val(value1);
    	}else if(p060000029 == "TYPE22"){
    		$("#st_ref_pr_no"+type).val(value1);
    		$("#st_mg_note"+type).val(value1);
    	}else if (p060000029  == "TYPE35"){
    		$("#st_ref_pr_no_text"+type).val(value2);
    		$("#st_ref_pr_no"+type).val(value1);
    	}else{
    		$("#st_ref_pr_no_text"+type).val(value1);
    		$("#st_ref_pr_no"+type).val(value1);
    	}
	}else if(popupSel == "ref_pr_no_all"){ // 관리번호 일괄 팝업
		var p060000029 = "<%=p060000029%>";
    	//type = index , value1 = code , value2 = text
    	//TYPE14일경우 
    	if(p060000029  == "TYPE14" || p060000029  == "TYPE23"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no_text"+i).val(value2);
    	    		$("#st_ref_pr_no"+i).val(value2);
    			}
    		}
    	}else if(p060000029  == "TYPE16" || p060000029  == "TYPE26" || p060000029  == "TYPE27"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no_text"+i).val(value1);
    	    		$("#st_ref_pr_no"+i).val(value1);
    	    		$("#st_remark"+i).val(value2);
    			}
    		}
    	}
//     	else if(p060000029  == "TYPE20"){
//     		for(var i = 0; i < tot_cnt; i++){
//     			if($("#lnCheck"+i).is(":checked")){
//     				$("#st_ref_pr_no_text"+i).val(value1+"("+value2+")");
//     	    		$("#st_ref_pr_no"+i).val(value1+"("+value2+")");
//     			}
//     		}
    		
//     	}
    	else if(p060000029  == "TYPE100"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no"+i).val(value1);
    			}
    		}

		}else if(p060000029  == "TYPE41"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no"+i).val(value1);
    			}
    		}

    	}else if(p060000029 == "TYPE22"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no"+i).val(value1);
    	    		$("#st_mg_note"+i).val(value1);
    			}
    		}
    		
    	}else if (p060000029  == "TYPE35"){
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no_text"+i).val(value2);
    	    		$("#st_ref_pr_no"+i).val(value1);
    			}
    		}
    	}else{
    		for(var i = 0; i < tot_cnt; i++){
    			if($("#lnCheck"+i).is(":checked")){
    				$("#st_ref_pr_no_text"+i).val(value1);
    	    		$("#st_ref_pr_no"+i).val(value1);
    			}
    		}
    		
    	}
	}
}
//우편번호 검색 콜백
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	if(popupSel == "newzipCodeTop"){
		$("#dely_to_location_code").val("");
		$("#dely_to_location_name").val("");
		$("#dely_to_location_code_name").val("");
		$("#dely_to_location_text").val(zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail).trigger("change");
	}else if(popupSel == "newzipCode"){
		$("#item_dely_to_location_code"+gridIndex).val("");
		$("#item_dely_to_location_name"+gridIndex).val("");
		$("#item_dely_to_location_text"+gridIndex).val(zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail).trigger("change");
	}
}
//파일정보 저장
 function saveAttach(g_row,cnt){
	
    var st_cstmr_id             = "<%=buyer%>"                                  // 고객사
    var st_user_id              = "<%=userId%>"                                 // 고객사 
    var query                   = "";
    var tot_cnt     =  $("#display_item_cnt").val();
    var st_item_no       = "";
    var st_contract_no   = "";
    var st_contract_seq  = "";
    
	st_item_no = $("#st_item_no"+g_row).val();
	st_contract_no = $("#st_contract_no"+g_row).val();
	st_contract_seq = $("#st_contract_seq"+g_row).val();
	image_key = $("#st_image_key"+g_row).val();
	st_seq = $("#st_seq"+g_row).val();
	
    if(isEmpty(TrimCommon(image_key))) image_key="";
    query +=  image_key             + "@@";
    query +=  st_cstmr_id               + "@@";
    query +=  st_user_id                + "@@";
    query +=  st_contract_no                + "@@";
    query +=  st_contract_seq               + "@@";
    query +=  st_item_no                + "@@";
    query +=  st_seq						+ "@@";
    
    document.forms.processForm.st_query2.value = query;
    
    $("#st_file_upload_but"+g_row).attr("class","ButQuaternary_Small mt15");
    $("#st_file_upload_cnt"+g_row).html(cnt);
    
    kepAjaxFormCall("/mpso/getBuyerShoppingcartListAttachUpdate.do","processForm","FILE");  
    
 }


function lnCheckFalse(){
	var tot_cnt  =$("#display_item_cnt").val();
    if(eval(tot_cnt) < 2)     { 
        var box = eval("document.forms.contentForm.lnCheck0");
        propCheckBox(box, false);
      } else{
        for(var x=0; x<eval(tot_cnt); x++) {
            var box = eval("document.forms.contentForm.lnCheck" + x);
            propCheckBox(box, false);
        } 
      }
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg.MSG;   
	var tot_cnt  = $("#display_item_cnt").val();
	var query = "";
	 
    if (sMsg == "UPDATE_OK") { // asis setQtyUpdateResults -- 저장,바로주문
    	  if(pMethod == "ORDER"){
	       	   for(var j = 0; j<tot_cnt; j++){
	       		   if($("#lnCheck"+j).is(":checked")){
	       			   var st_item_no = $("#st_item_no"+j).val();
	       			   var st_contract_no = $("#st_contract_no"+j).val();
	       			   var st_contract_seq = $("#st_contract_seq"+j).val();
	       			   var st_seq = $("#st_seq"+j).val();
	       			   
	       			   query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_seq +"@@";
	       		   }
	       	   }

              var recv_date  = document.forms.searchForm.st_recv_date.value;
              var zip_code   = document.forms.searchForm.st_zip_code.value;
              var tel_no     = document.forms.searchForm.st_tel_no.value;
              var fax_no     = document.forms.searchForm.st_fax_no.value;
              var mobile     = document.forms.searchForm.st_mobile_no.value;

              document.forms.locationForm.st_query_cart.value = query;
              document.forms.locationForm.st_zip_code.value   = zip_code;
              document.forms.locationForm.st_tel_no.value     = tel_no;
              document.forms.locationForm.st_fax_no.value     = fax_no;
              document.forms.locationForm.st_mobile_no.value  = mobile;
              document.forms.locationForm.st_recv_date.value  = recv_date;
              
              if(p060000100 == ""){
	              document.forms.locationForm.st_location_code_name.value  = document.forms.contentForm.dely_to_location_code_name.value;
	              document.forms.locationForm.st_location_name.value  = document.forms.contentForm.dely_to_location_text.value;
	              document.forms.locationForm.st_location_code.value  = document.forms.contentForm.dely_to_location_code.value;
              
              }
              
              document.forms.locationForm.st_query_cart.value = query;  
              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;  
              
              // 질문
             // document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_list.jsp";     
             //alert("buyer_delivery_list 로 이동"); 
             //PG_06_B_008_00
              $('#locationForm').attr("action", "/mpso/getBuyerMpSoOrderInfoList.do").submit();   
              
           }else if(pMethod == "PrSheet") {
				cartPrSheet();//***********************              
           }else if(pMethod == "SAVE") {
        	   // 정상적으로 저장되었습니다.
               var text = "<%=CommonLang.msg("MSG76")%>";
               openLayerPopText2(text,but1text,but1funcSearch,but1width);
          	 
           }else if(pMethod == "DELETE") { // asis setResulte -- 삭제
        	   // 정상적으로 삭제되었습니다.   
        	   var text = "<%=CommonLang.msg("MSG75")%>";
               openLayerPopText2(text,but1text,but1funcSearch,but1width);
           }else if(pMethod == "DELETE2") {
        	   
           }else if(pMethod == "TRANS") {
        		// 정상적으로 전송되었습니다.
               var text = "<%=CommonLang.msg("MSG159")%>";
               openLayerPopText2(text,but1text,but1funcSearch,but1width);
           }else if(pMethod == "CHECKOUT" || pMethod == "CHECKOUTTEST") {
        		// 정상적으로 전송되었습니다.
        	   var text = "<%=CommonLang.msg("MSG159")%>";
               openLayerPopText2(text,but1text,but1funcSearch,but1width);
           }
      } else {
    	  if(pMethod == "FILE"){
    		 //  화면을 갱신하지 않음
    	  }else{ // 기존처리
    		  if(pMethod == "RsaveProcess")
              {
            	 //품목코드 () 은 이미 나의 상품으로 저장된 항목입니다.  
            	 var text = "<%=CommonLang.msg("MSG352")%>" + sMsg + "<%=CommonLang.msg("MSG353")%>";
                 openLayerPopText2(text,but1text,but1func,but1width);
              } else {
            	// 처리후 재조회
              	 kepSearch($("#curPage").val());
              }
             
    	  }
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "DELETE"){ 
		//삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 var text = "<%=CommonLang.msg("MSG162")%>"
         openLayerPopText2(text,but1text,but1func,but1width);
	} else if (pMethod == "SAVE" || pMethod == "ORDER"){ 
		//장바구니에서 바로주문 오류 시 메세지 전송
		 var text = response.Message
         openLayerPopText2(text,but1text,but1func,but1width);
	} else{	    
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 var text = "<%=CommonLang.msg("MSG163")%>"
         openLayerPopText2(text,but1text,but1func,but1width);
	}
} 

function  attach_popup(img_key,index){
	popupSel = "attach";
	gridIndex = index;
	
	var type = "PR";
	var viewType = "C";
	var img_key = $("#st_image_key"+index).val();
	var src = '/common/fileUploadPop_v2.do?DOC_NO='+img_key+'&viewType='+viewType+'&TYPE='+type;
	openLayerPop(src,"600px","510px");
}

// 에스와이에스리테일(KRSYSR0001), 솔라엣지 사무용품(KRSOLA0011) 명함 정보 입력 팝업
function getNameCardPop(obj1, seq, type){
	gridIndex = obj1;
	popupSel = "namecard_info";
	var remark = $("#st_remark"+obj1).val();
	var remark_arr = remark.split(";");
	var param_seq = 0; // 텍스트값 전달용(팝업에서 콤보박스 값 찾기 위함)
	var param_text = "";
	
	if(type == "BRAN"){ // 영업점
		popupUrl = "/mpso/getBuyerMpSoNameCardPop.do";
		param_seq = 4; // (0부터시작) 5번째 파라미터 정보 필요(직위)
		option = "865,640,no";
	}else if(type == "HAAC"){ // 클린킹_가정에어컨
		popupUrl = "/mpso/getBuyerMpSoNameCardCkAcPop.do";
		param_seq = 2; // (0부터시작) 3번째 파라미터 정보 필요(물류센터명)
		option = "865,290,no";
	}else if(type == "HDQT" || type == "HOLD"){ // 본사_홀딩스
		popupUrl = "/mpso/getBuyerMpSoNameCardHdQtPop.do";
		option = "870,520,no";
	}else if(type == "BRMG"){ // 영업점 점장
		popupUrl = "/mpso/getBuyerMpSoNameCardBrMgPop.do";
		param_seq = 4; // (0부터시작) 5번째 파라미터 정보 필요(직위)
		option = "945,805,no";
	}else if(type == "HANS_9" || type == "HANS_10"){ // 한샘 신규조직(도무스/넥서스)
		// 아래 includes("HANS") 분기보다 반드시 먼저 걸려야 한다(같은 팝업이지만 화면/필드수가 다름).
		// 매장/주소/직급은 팝업이 REMARK를 직접 읽어 복원하므로 param_seq 불필요.
		popupUrl = "/mpso/getBuyerMpSoNameCardHansPop.do";
		option = "900,520,no";
	}else if(type.includes("HANS") || type == "HAND"){ // 한샘
		popupUrl = "/mpso/getBuyerMpSoNameCardHansPop.do";
		param_seq = 8;
		option = "870,420,no";
	}else if(type == "LSAT"){ // LS오토모티브(국영문 양면 명함)
		popupUrl = "/mpso/getBuyerMpSoNameCardLsatPop.do";
		option = "870,540,no"; // 근무지/층수는 팝업 자체에서 REMARK를 읽어 복원하므로 param_seq 불필요
	}

	if(param_seq != 0){
		for(var i=0; i<remark_arr.length; i++){
			if(i == param_seq){ // 콤보박스 텍스트값 팝업으로 전달
				param_text = remark_arr[i];
			}
		}	
	}
	
	openSearchPopup(popupUrl,"?st_seq="+seq+"&param_text="+param_text+"&st_type="+type, option);
}

//에스와이에스리테일(KRSYSR0001), 솔라엣지 사무용품(KRSOLA0011) 명함 시안
function nameCardView(obj1, rpt, type){
	
	var st_remark = $("#st_remark"+obj1).val();
	var remark_arr = st_remark.split(";");
	
	var param = "";
	var arr_length = 0;
	
	var param1 = "";
	var param2 =  "";
	var param3 =  "";
	var param4 = "";
	var param5 = "";
	var param6 = "";
	var param7 = "";
	var param8 = "";
	var param9 = "";
	var param10 = "";
	var param11 = "";
	var param12 = "";
	var param13 = "";
	var param14 = "";
	var param15 = "";
	var param16 = "";
	var param17 = "";
	var param18 = "";
	var param19 = "";
	var param20 = "";
	var param21 = "";
	var param22 = "";
	var param23 = "";
	var param24 = "";
	var param25 = "";
	var param26 = "";
	
	if(type == "BRAN"){ // 지점 명함
		arr_length = 13;
	}else if(type == "HAAC"){ // 가정에어컨
		arr_length = 5;
	}else if(type == "HDQT" || type == "HOLD"){ // 본사_홀딩스
		arr_length = 12;
	}else if(type == "BRMG"){ // 영업점 점장
		arr_length = 26;
	}else if(type == "HANS_9" || type == "HANS_10"){ // 한샘 신규조직(도무스/넥서스)
		// 아래 includes("HANS")(9필드)보다 반드시 먼저 걸려야 한다.
		// 도무스(매장명 있음/영문주소 없음)와 넥서스(매장명 없음/영문주소 있음)는 실제 필드 구성은
		// 서로 다르지만 개수는 둘 다 10개다. 필드 순서/개수는 buyerMpSoNameCardHansPop_v2.jsp의
		// getOrgRemarkFields()(view_option 정의 순서) 규약과 같이 관리할 것.
		arr_length = 10;
	}else if(type.includes("HANS") || type == "HAND"){ // 한샘, 한샘_개발
		arr_length = 9;
	}else if(type == "LSAT"){ // 시연고객사(국영문 양면 명함)
		arr_length = 15;
	}

	if(remark_arr.length == arr_length){
		for(var i=0; i<remark_arr.length; i++){
			if(i == 0){
				param1 = remark_arr[i];
			}else if(i == 1){
				param2 = remark_arr[i];
			}else if(i == 2){
				param3 = remark_arr[i];
			}else if(i == 3){
				param4 = remark_arr[i];
			}else if(i == 4){
				param5 = remark_arr[i];
			}else if(i == 5){
				param6 = remark_arr[i];
			}else if(i == 6){
				param7 = remark_arr[i];
			}else if(i == 7){
				param8 = remark_arr[i];
			}else if(i == 8){
				param9 = remark_arr[i];
			}else if(i == 9){
				param10 = remark_arr[i];
			}else if(i == 10){
				param11 = remark_arr[i];
			}else if(i == 11){
				param12 = remark_arr[i];
			}else if(i == 12){
				param13 = remark_arr[i];
			}else if(i == 13){
				param14 = remark_arr[i];
			}else if(i == 14){
				param15 = remark_arr[i];
			}else if(i == 15){
				param16 = remark_arr[i];
			}else if(i == 16){
				param17 = remark_arr[i];
			}else if(i == 17){
				param18 = remark_arr[i];
			}else if(i == 18){
				param19 = remark_arr[i];
			}else if(i == 19){
				param20 = remark_arr[i];
			}else if(i == 20){
				param21 = remark_arr[i];
			}else if(i == 21){
				param22 = remark_arr[i];
			}else if(i == 22){
				param23 = remark_arr[i];
			}else if(i == 23){
				param24 = remark_arr[i];
			}else if(i == 24){
				param25 = remark_arr[i];
			}else if(i == 25){
				param26 = remark_arr[i];
			}
		}
	}else if(remark_arr.length == 1){
		// 명함정보를 입력하여 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG436")%>"
        openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else{
		// 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG435")%>"
        openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	param = "["+param1+"]["+param2+"]["+param3+"]["+param4+"]["+param5+"]["+param6+"]["+param7+"]["+param8+"]["+param9+"]["+param10+"]["+param11+"]["+param12+"]["+param13+"]["+param14+"]["+param15+"]["+param16+"]["+param17+"]["+param18+"]["+param19+"]["+param20+"]["+param21+"]["+param22+"]["+param23+"]["+param24+"]["+param25+"]["+param26+"]";	

	// 새로운 post 방식 테스트 한승준(앞으로 이렇게 사용하도록 권장)
	var params = [];
	var url = "/coco/showReportViewer.do";
	params.push({ key: "fileName", value: rpt });
	params.push({ key: "param", value: param });
	OpenReportPost(url, "POP", params);
}

function getDeliveryToLocation(row, com_code){
	if(row == ""){
		popupSel = "locationTop";
	}else{
		popupSel = "location";
	}
	gridIndex = row;
	openSearchPopup("/common/delLocationTwoTabPop_v2.do", "?com_code="+com_code, "930,510,no");
}

function getnewzipCode(row, com_code){
	if(row == ""){
		popupSel = "newzipCodeTop";
	}else{
		popupSel = "newzipCode";
	}
	gridIndex = row;
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
}
// 체크박스 체크 함수
function propCheckBox(row,changeFlg){
	var tot_cnt = $("#display_item_cnt").val();
	
	//리뉴얼에서 해당 특수로직 제거
<%-- 	var p060000133 = "<%=p060000133%>"; --%>
// 	if(p060000133 == "true"){ 
// 		var p060000133_alert_flg = true;
// 		for(var i = 0; i < tot_cnt; i++){
// 			if($("#lnCheck"+i).is(":checked")){
// 				p060000133_alert_flg = false;
// 			}
// 		}
// 		if(p060000133_alert_flg && tot_cnt != "1"){
// 			//변경 대상의 체크박스를 선택해주세요.
<%-- 			var text = "<%=CommonLang.msg("MSG593")%>" --%>
// 	        openLayerPopText2(text,but1text,but1func,but1width);
// 		}
// 	}else{ // 장바구니 자동 체크해제 대상이 아니라면 자동 체크
		$("#lnCheck"+row).prop("checked",changeFlg);
// 	}
}

//주문수량 기능 g_gbn P: 주문수량 1 플러스/ M: 주문수량 1마이너스, pur_unit_qty : 주문배수
function getOrderQty(order_qty, y_num, unit_price, g_gbn, pur_unit_qty){
	var tot_cnt  = $("#display_item_cnt").val();
	var st_order_qty = ""; //주문수량
	var st_tobe_order = "";//변경후 주문수량
	var st_sum_price = "";//합계 금액

	st_order_qty = $("#st_order_qty"+y_num).val();
	if(g_gbn == "P"){
		st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
	}else if(g_gbn == "M"){
		st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
		if(st_tobe_order < 1){
     		//품목의 주문수량(숫자)을 입력하여 주십시요.
      		var text = "<%=CommonLang.msg("MSG120") %>  ";
	     	openLayerPopText2(text,but1text,but1func,but1width);
	      	return;
		}
	}
	$("#st_order_qty"+y_num).val(st_tobe_order);
	st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
	$("#st_sum_price"+y_num).val(st_sum_price);
    $("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
    
    var budget_flag = "<%=budget_flag%>";
    if(budget_flag == "Y"){
    	$("#st_bdgt_bal_amt"+y_num).val(0);
    	$("#st_budget_dept_name"+y_num).val("");
    	$("#st_budget_dept"+y_num).val("");
    	$("#st_account_type_name"+y_num).val("");
    	$("#st_account_type"+y_num).val("");
	}
    
    chk_sum_price();
}
function getPriceUpdate(order_qty, y_num, unit_price,min_order_qty){
    var tot_cnt  = $("#display_item_cnt").val();
    var st_sum_price = "";
    var st_order_qty = "";
    var type = $("#st_list_type").val();
	
    st_order_qty = $("#st_order_qty"+y_num).val();
	if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
		//품목의 주문수량(숫자)을 입력하여 주십시요.
		var text = "<%=CommonLang.msg("MSG120") %>  ";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_order_qty"+y_num).val(min_order_qty);
		$("#st_order_qty"+y_num).focus();
		st_sum_price = kepGetRound((min_order_qty * unit_price),3);
		$("#st_sum_price"+y_num).val(st_sum_price);
		$("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
	}else{
		st_sum_price = kepGetRound((order_qty * unit_price),3);
		$("#st_sum_price"+y_num).val(st_sum_price);
		$("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
		
		var budget_flag = "<%=budget_flag%>";
	    if(budget_flag == "Y"){
	    	$("#st_bdgt_bal_amt"+y_num).val(0);
	    	$("#st_budget_dept_name"+y_num).val("");
	    	$("#st_budget_dept"+y_num).val("");
	    	$("#st_account_type_name"+y_num).val("");
	    	$("#st_account_type"+y_num).val("");
		}
	}
	
	chk_sum_price();
}
function checkedAllBox(id){
	var tot_cnt  = $("#display_item_cnt").val();
	var checkStatus = $("#"+id).is(":checked");
	$(".checkedAllClass").prop("checked", checkStatus);
	for(var i = 0; i<tot_cnt; i++){
		$("#lnCheck"+i).prop("checked",checkStatus);
	}
	
	chk_sum_price();
}
function recvDateCheck(flag,index){
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	if(flag == "all"){ //일괄 수령희망일
		var recv_date_id = "imsi_recv_date";
	}else if(flag == "item"){ //품목별 수령희망일
		var recv_date_id = "item_recv_date_hope"+index;
		var recv_date_div_id = "item_recv_date_div"+index;
	}else if(flag == "top"){ //기본
		var recv_date_id = "recv_date_hope";
		var recv_date_div_id = "recv_date_div";
	}
	
	var recv_date = $("#"+recv_date_id).val().replace(/[/]/gi,"");
	if(recv_date < cur_date){
		//오늘 날짜 이후로 선택해주세요
		var text = "<%=CommonLang.msg("MSG791")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#"+recv_date_id).val("");
		return;
	}
	clearError("#"+recv_date_div_id);
}
function recvDateOpen(){
	var tot_cnt  = $("#display_item_cnt").val();
	var chk_cnt = 0; 

    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	// 목록에 표시된 상품이 없습니다.     
        var text = "<%=CommonLang.msg("MSG16") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
	chk_cnt = getCheckedRowCount(tot_cnt); 
	if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        var text = "<%=CommonLang.msg("MSG17") %>  ";
     	openLayerPopText2(text,but1text,but1func,but1width);
        return;
	}
	
	$("#recvDateSelOverlay").show();
	$("#recvDateSel").show();
}
function recvDateCancel(){
	$("#imsi_recv_date").val("");
	$("#recvDateSelOverlay").hide();
	$("#recvDateSel").hide();
}
function recvDateSel(){
	var tot_cnt  = $("#display_item_cnt").val();
	var recv_date = $("#imsi_recv_date").val();
	if(recv_date == ""){
		//수령희망일을 입력해주세요.
		var text = "<%=CommonLang.msg("MSG797") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	$("#recvDateSelOverlay").hide();
	$("#recvDateSel").hide();
	
	for(var i = 0; i<tot_cnt; i++){
		if($("#lnCheck"+i).is(":checked")){
			$("#item_recv_date_hope"+i).val(recv_date);
		}
	}
}

function changeData(flag,value){ //구매사유,비고 입력 시 체크한 것들 같이 변경
	var tot_cnt = $("#display_item_cnt").val();
	
	for(var i = 0 ; i<tot_cnt; i++){
		if($("#lnCheck"+i).is(":checked")){
			if(flag == "prReason"){ //구매사유
				<%if(bca00003 == true){%>
					$("#st_pr_reason"+i).val(value);
				<%}%>
			}else if(flag == "remark"){ //비고
				<%if(p060000120 == true){%>
					$("#st_remark"+i).val(value);
				<%}%>
			}
		}
	}
}

function thisPopClose(){
	closePopText2();
	
	kepSearch($("#curPage").val()); 
	
}

function emptyError(el){
	if(errorFlag){
		return;
	}
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.addClass("input-error");
	if($el.is("div")){
		var currentWidth = $el.width();
		$el.width(currentWidth-2);
	}
	if ($el.length > 0 && $el[0].getBoundingClientRect) {
		var rect = $el[0].getBoundingClientRect();
		if (rect.top < 0 || rect.top > window.innerHeight) {
			$('html, body').animate({
				scrollTop: $el.offset().top - (window.innerHeight / 2)
			}, 300);
		}
	}
	errorFlag = true;
}
function clearError(el) {
	var $el = (el instanceof jQuery) ? el : $(el);
	$el.removeClass("input-error select-error");
	if($el.is("div")){
		var currentWidth = $el.width();
		if(errorFlag)
			$el.width(currentWidth+2);
	}
	errorFlag = false;
	
}

function getBuyerCatalogDisplayPop_v2(BUYER,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ){
	var src = "/common/catalogDetailPop.do?open=Y&BUYER="+BUYER+"&BUYER_ITEM_NO="+escape(BUYER_ITEM_NO)+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ+"&popupCheck=N";
	openLayerPop(src,"650px","600px");
}

function excelDownload(){
	document.forms.searchForm.action = "/mpso/excelBuyerMpSoCartList.do";
	document.forms.searchForm.submit();
}
</script>
</html>