<%--
**********************************************
* 메뉴 : 주문관리>장바구니
* 화면 : 장바구니
* 기능 : 상품목록에서 장바구니에 담은 상품들의 목록을 확인하고 구매요청수량을 입력한다.
* 프로그램 ID : PG_06_B_006_00
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-05-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script>
<script src="/resources/js/punchout.js"></script>  
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
 
	String Hdata_FLAG = (String) request.getAttribute("Hdata"); // 조회된 결과 
	//---------------------------------
	//홍익대학교--품의서 양식 설정
	// ex) SEDEPT
	// 2자리 캠퍼스 구분 SE : 서울, SJ : 세종
	// 4자리 부서 구분 GRAD : 대학원, COMP : 학부, DEPT : 행정부서 
	String hongikSheetType = "N";
	hongikSheetType = (String) request.getAttribute("HdataSheetType"); // 조회된 결과
	//선입고장바구니 체크 추가
	String st_pre_gr_flag= (String) request.getAttribute("HdataPreGrFlag");
	if("".equals(hongikSheetType))hongikSheetType = "SEDEPT";
	String comp = "";  
	String dept = "";  
	 if (!"".equals(hongikSheetType)){
		 if (hongikSheetType.length()>5){
			comp = hongikSheetType.substring(0,2);
			dept =  hongikSheetType.substring(2,6);
		 }
	 }
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10")); // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	// 조회조건 S
	String st_query_cart = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"ALL");   
	//홍대~~~~~~~~~~~~~~~~~~~
	String st_verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),"");    
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"c_date");    
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");    
	String st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");    
	String st_check       = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH");    	
	String st_zip_code = CommonUtil.nvl((String) request.getParameter("st_zip_code"),""); 
	String st_tel_no = CommonUtil.nvl((String) request.getParameter("st_tel_no"),""); 
	String st_fax_no = CommonUtil.nvl((String) request.getParameter("st_fax_no"),""); 
	String st_mobile_no = CommonUtil.nvl((String) request.getParameter("st_mobile_no"),""); 
	String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),""); 
	String st_email = CommonUtil.nvl((String) request.getParameter("st_email"),""); 
	String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  
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
	}  
	if (userRole !=null){
			if (userRole.length() == 2){
			    userRole1 = userRole.substring(0,1);
			    userRole2 = userRole.substring(1,2);
			}
	}
	
    if(st_image_status.equals(""))
    { 
        st_image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
    }
    String p060000029 = "";
    String p060000029_col04 = "";
    String p060000029_col05 = "";
    
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
    	p060000029_col04 = CommonUtil.nvl(p060000029_map.get("COL04_DATA"),""); // 장바구니 표기 유형
    	p060000029_col05 = CommonUtil.nvl(p060000029_map.get("COL05_DATA"),"관리번호"); // 관리번호 대체할 명칭(COL04 = TYPE1 에서만 사용)
    }
    
    String p060000027 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027","COL05_DATA"); // KRGEST0001 KRHONG0020 KRSIEM0010
    //관리번호 메세지
    String p060000027_msg ="";
     Map<String, String> p060000027_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000027");
    if (p060000027_map != null){
    	p060000027_msg = CommonUtil.nvl(p060000027_map.get("COL04_DATA"),""); // 관리번호 표기
    }
    
    boolean p060000027_ref = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027"); // 관리번호 * 표시용
    boolean p060000028 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000028"); // KRCHAN0058 KRCHAN0059 KRCHAN0060 KRDONG0708    
    boolean p060000029_ref = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000029"); // 관리번호 * 표시용
    boolean p060000034 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000034"); // KRDAEW0023 KRDAEW0043 KRDAEW0045
    boolean p060000033 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000033"); // KRKOLO0041    
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
    //SLOGIC-END
    	 
    //SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
    //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
    String account_mg_flag = "";
  //SLOGIC-BEGIN(P06-0000028)
    if(p060000028 == true){
        account_mg_flag = "Y";
    }else{
        account_mg_flag = "N";
    }
    //SLOGIC-END
    /*    
    장바구니 별도메뉴(프로그램)파일을 사용
	6010-01
	*/
    String listQuery = "2";
    if(buyer.equals("KRCOWA0001")||
    		buyer.equals("KRCOWA0002")||
    		buyer.equals("KRCOWA0003")||
    		buyer.equals("KRCOWA0004")||
    		buyer.equals("KRCOWA0005")||
    		buyer.equals("KRCOWA0006")||
    		buyer.equals("KRCOWA0007")||
    		buyer.equals("KRCOWA0008") ){
    	listQuery = "1";
    }
    	
    //---------------------------------
	//홍익대학교-- 대학원 소속 체크.
	String hongikType = "N";
	  //SLOGIC-BEGIN(P06-0000027)
	if(p060000027.equals("TYPE2")){ // KRHONG0020
	    hongikType = Hdata_FLAG;
	}
	 //SLOGIC-END

	/**
	 * KEPPROJECT
	 * @author cyh
	 * @programid  cyh00001 start
	 * @remark 발주정보 수정
	 * @date  20140423
	 */
	
		/*
			장바구니 필드추가 제어 
			-TYPE1: 윈체  수량길이 필드 추가
		*/
		String p060000080 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000080","COL01_DATA");
	    //SLOGIC-BEGIN TR일때 묶음배송 활성화 기능.
		String p060000087 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000087","COL01_DATA");
	    //SLOGIC-END
	
	//SLOGIC-BEGIN(P06-0000099) - 미리 지정된 고객사카테고리 별 예산계정만 조회되는 고객사리스트(휴온스 그룹) 2021.12.23 HSJ 
	boolean p060000099 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000099");
	
	String bdgt_categ_acnt_set = "N";
	
	if(p060000099 == true){
		bdgt_categ_acnt_set = "Y";
    }
	
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
    
	// 특수로직 세팅으로 조건 따라 기본 관리번호 값 설정(ex 협력사)
	Map<String, String> p060000104 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000104");
	String p060000104_type = "";
	String p060000104_agent = "";
    String p060000104_ref_pr_no = "";
    String p060000104_ref_pr_no_text = "";
    if(p060000104 != null){
    	p060000104_type = CommonUtil.nvl(p060000104.get("COL01_DATA"), p060000104_type);
    	p060000104_agent = CommonUtil.nvl(p060000104.get("COL02_DATA"), p060000104_agent);
    	p060000104_ref_pr_no = CommonUtil.nvl(p060000104.get("COL03_DATA"), p060000104_ref_pr_no);
    	p060000104_ref_pr_no_text = CommonUtil.nvl(p060000104.get("COL04_DATA"), p060000104_ref_pr_no_text);
    }
    
    // 배송정보 2단계까지만.. 표준납기일 이전 수정금지
    boolean p060000117 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000117");
    
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
 	
	// 장바구니 이벤트 화면 비갱신 특수로직
	String p060000131_col01 = "";
	Map<String, String> p060000131_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000131");
	if(p060000131_map != null){
		p060000131_col01 = CommonUtil.nvl(p060000131_map.get("COL01_DATA"), p060000131_col01);
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
%>
<%-- 첨부파일 필수 여부 - 조회 쿼리 내 ICOMCOD3 테이블에 TYPE이 ATCH로 (계약서번호, 항번, 품목코드) 등록되었는 지로 확인--%>
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
	if(st_pre_gr_flag.equals("Y")){
%>
		<h3><%=CommonLang.get("HTITLE762")%><!-- 선입고 장바구니 --></h3>
<%
	}else{
%>
		<h3><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --></h3>
<%
	}
%>
	<!--조회영역-->
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
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=st_image_status %>">
 		<input type="hidden" name="st_check" id="st_check" value="<%=st_check %>">    
 		<input type="hidden" name="st_user_dept" id="st_user_dept" value="<%=user_dept %>">  
		<input type="hidden" name="st_listQuery" id="st_listQuery" value="<%=listQuery %>">
		<input type="hidden" name="st_pre_gr_flag"  id="st_pre_gr_flag" value="<%=st_pre_gr_flag%>">
		
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
		
			
 		<div>
 		
 			<div id="cont_searchA" > 	
			<table class="cont_t_list01">
			<tr><td>	
 			<div style="height:20px; margin-bottom:6px; " >
            <!--배송정보 단계일때 이미지명 : b_img_carting02.gif / 주문완료 단계일때 이미지명 : b_img_carting03.gif-->
<%
//언어타입이 영어일 경우 이미지 변경
if(!h_get_session_user_lang.equals("EN")) {
%>
           		<p class="cart"><img src="/resources/images/b_img_carting01.gif" alt="장바구니단계" /></p>
<%}else{ %>
				<p class="cart"><img src="/resources/images/b_img_carting01_en.gif" alt="장바구니단계" /></p>
<% } %>
        		<span class="sTitle">
        			 <%
        			  if(!p060000101_msg.equals("")){  
        			 %>
        			 	<span class="text03"><%=p060000101_msg%></span>
        			 <%
        			  }else{
        			 %>
						<%=CommonLang.get("HTITLE171")%><!-- 내가 담은 품목명은 총  --><span class="text03"><%=total_cnt %></span><%=CommonLang.get("HTITLE623")%><!-- 건입니다. 품목명을 확인하시고 주문해 주세요. -->        			 
        			 <%
        			  }
        			 %>
        		</span>
          	</div>
          	</td></tr>
			</table>
			</div>

			<div class="contList">
            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" />
			      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" onchange="javascript:kepSearch(1);">  
						<option <%if ("10".equals(onepagerow)) {%>selected<%} %> value = "10">10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("15".equals(onepagerow)) {%>selected<%} %> value = "15">15<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("20".equals(onepagerow)) {%>selected<%} %> value = "20">20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("25".equals(onepagerow)) {%>selected<%} %> value = "25">25<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("50".equals(onepagerow)) {%>selected<%} %> value = "50">50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("100".equals(onepagerow)) {%>selected<%} %> value = "100">100<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("200".equals(onepagerow)) {%>selected<%} %> value = "200">200<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option <%if ("500".equals(onepagerow)) {%>selected<%} %> value = "500">500<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					</select>
		      	</span>
		      	<label for="b_no" class="hidden">등록일시선택</label>
					<select name="st_sort_gubun" id="st_sort_gubun" onchange="javascript:kepSearch(1);">
	                    <option value="c_date" <% if ("c_date".equals(st_sort_gubun)){ %> selected <%} %>><%=CommonLang.get("HTITLE17")%><!-- 등록일시 --></option>
	                    <option value="c_item" <% if ("c_item".equals(st_sort_gubun)){ %> selected <%} %>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
	                    <option value="c_prno" <% if ("c_prno".equals(st_sort_gubun)){ %> selected <%} %>><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></option>
	                </select>
<span class="contList_btn">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
<a href="javascript:imageHideView();"  title="이미지보이기" ><%=CommonLang.get("HTITLE9")%><!-- 이미지보이기 --></a>
<%  }else{   %>
<a href="javascript:imageHideView();"  title="이미지감추기" ><%=CommonLang.get("HTITLE167")%><!-- 이미지감추기 --></a>
<%  }   %> </span>
		      </div>
		      <div class="allPrice">
		      	<%=CommonLang.get("HTITLE640")%><!-- 총수량 --> : 
		      	<input type="text" name="check_sum_qty" id="check_sum_qty" class="allPrice_input" value="0" READONLY> &nbsp;
		      	<input type="hidden" name="st_check_sum_qty"  id="st_check_sum_qty"  value="">
			      <%  
			      //buyer = "KRDAEW0023";
			    //SLOGIC-BEGIN(P06-0000034)
			      if(p060000034 == true){  %>
           <a href="javaScript:category_list_pop()"><b><%=CommonLang.get("HTITLE172")%><!-- 총 금액 --></b></a><%  }else{  %><%=CommonLang.get("HTITLE624")%><!-- 총금액 --><%  } //SLOGIC-END      %>
				       : <input type="text" name="check_sum_price"   id="check_sum_price"  class="allPrice_input"  value="0"  READONLY>&nbsp;
            <input type="hidden" name="st_check_sum_price"  id="st_check_sum_price"  value=""> 
			 
              </div>
        </div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />

<%
if(p060000029_col04.equals("TYPE1")){ // 관리번호 분리표기(롯데푸드) SET 1
%>
		<table class="cont_t_list002" style="width:100%">
			<colgroup>
               <col width="3%" />
               <col width="10%" />
				<col width="20%" />
               <col width="*" />
               <col width="11%" />
<%
if("Y".equals(budget_flag)){ 
%>                              
               <col width="15%" />
<%} %>   
               <col width="10%" />            
               <col width="8%" />
               <col width="7%" />
               <col width="7%" />
           </colgroup>
           <thead>
               <tr>
                   <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>
                   <input type="checkbox" class="input_noline" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');chk_sum_price();">
<%} %>
                   </th>
                   <th scope="col"><a class="PDnameLink" href="javascript:setRefNoCopy();"><%=CommonLang.get("HTITLE18") %></a><!-- 관리번호 --></th>
                   <th scope="col" colspan="2"><%=CommonLang.get("HTITLE173") %><!-- 품목코드 / 품목명 / 규격 / 제조사 --></th>
                   <th scope="col"><%=CommonLang.get("HTITLE31") %><!-- 협력사 / 단위 --></th>
                   
<%

if("Y".equals(budget_flag)){
	if(p060000080.equals("TYPE2")){
%>
		<th scope="col"><%=CommonLang.get("HTITLE626") %><!-- GL계정 / 비용부서 / 예산잔액   --></th>
<%		
	}else{
%>		
		<th scope="col"><%=CommonLang.get("HTITLE627") %><!-- 계정명 / 예산부서 / 예산잔액   --></th>
<%
	}
}else{
%>                	
<%}   %>    
<%    
if(p060000080.equals("TYPE1")) {
%>
                   <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE628") %>길이 / 수량</th>
                   <th scope="col">
<%
}else{
%>      
                   <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE175") %><!-- 구매수량 --></th>
                   <th scope="col">	          	
<%}%>    
<%
if("Y".equals(hongikType)){
%>
<%=CommonLang.get("HTITLE629") %><!-- 구매액/대학원 학과 -->
<%
}
else if("TYPE1".equals(p060000027)){ // KRGEST0001
%>
<%=CommonLang.get("HTITLE630") %><!-- 구매액/계정과목 -->
<%
}else{
	if(p060000080.equals("TYPE1")) {
%>
	<%=CommonLang.get("HTITLE631") %><!-- 총수량 / 구매액 -->
<%
	}else{
%>      
	<%=CommonLang.get("HTITLE176") %><!-- 구매액 -->	          	
<%}%>
<%
}
%>
                           </th>
                           <th scope="col"><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --></th>
                           <%if (userRole2.equals("+")) { %>
                           <th><%=CommonLang.get("HTITLE178") %><!-- 선택 --></th>
                           <%} %>
               </tr>
           </thead>
           <tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
		<tr>
			<td colspan="16" align="center" height = "50"> 
			<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
			</td> 
		</tr>
<%
}else{

	
Map<String,String> rowData = null;
for (int j=0; j<_gridList.size(); j++) {
	rowData = _gridList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";


	String tmpText = rowData.get("REF_PR_NO");
	String totSum = CommonUtil.nvl(rowData.get("TOT_SUM"), "0");
	String bdgt_bal_amt = CommonUtil.nvl(rowData.get("BDGT_BAL_AMT"), "0");
	double db_totSum = Double.parseDouble(totSum);
	double db_bdgt_bal_amt = Double.parseDouble(bdgt_bal_amt);
	
	String m014Text  ="";
	String m015Text  ="";
	if(tmpText.length() == 10){
		m014Text = tmpText;
	}else if(tmpText.length() == 20){
		m014Text = tmpText.substring(0,10);
		m015Text = tmpText.substring(10);
	}
	
%> 
				<tr bgcolor="<%=tclass%>">
                    <td rowspan="2">
						<input type="checkbox" class="input_noline" name="lnCheck<%=j%>" onclick="chk_sum_price()">	 
					</td>
                    <td title="이미지" >
                    <div class="PDimg">
                    
<% if(st_image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%> 
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }
    }
%>		 
                    </div>
                    </td>
					<td class="left" title="품목코드/품목명/규격/제조사" colspan="2">&nbsp;<input type="hidden" name="st_description" value="<%=rowData.get("DESCRIPTION_LOC")%>">
					&nbsp;<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
					<%=rowData.get("DESCRIPTION_LOC")%><br>
					&nbsp;&nbsp;&nbsp;<%=rowData.get("SPECIFICATION")%> / <%=rowData.get("MAKER_NAME")%>
						
						 / MOQ:  <%=rowData.get("MIN_ORDER_QTY")%>
						
						 / 주문배수:  <%=rowData.get("PUR_UNIT_QTY")%>
						
						<% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp; <% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp; <% } else { %> <br>&nbsp;&nbsp;<font color="green"><%=CommonLang.get("HTITLE597") %><!-- (재 판매일 : --><%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>
				   </td>
				   <td align="center"  title="협력사/단위" >
							<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a><br><%=rowData.get("UNIT_MEASURE")%>

				   </td>
			
		
                <%
 
                    // ICOMCMPY.BUDGET_FLAG = 'Y' 예산 사용 고객사
                    if("Y".equals(budget_flag)){

                %>
				<td  title="계정명/예산부서/예산잔액" >
					  <!-- 계정명 , 예산부서 , 예산잔액 -->
					 <div style="cursor:pointer;">
                <%
						//E.BUDGET_FLAG ='Y'  B.ACCOUNT_TYPE = 'M' 
                        if(rowData.get("ACCOUNT_NAME").equals(""))

                        {

                %>                   

                                   <input type="text"   name="st_account_type_name"  value="선택"  style="width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"    READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">

                <%

                        }else{
                        	//관리부서 통제가 들어갈 경우 계정정보+관리부서로 보여 짐
                        	if(p060000090==true) {
                %>                  
                                    <input type="text"   name="st_account_type_name"  value="<%=rowData.get("MNG_DEPT_NM")%>"    style="line-height:1.5;width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"   READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">
				<%
                        	}else{
				%>                                    
									<input type="text"   name="st_account_type_name"  value="<%=rowData.get("ACCOUNT_NAME")%>"    style="line-height:1.5;width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"   READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">
                <%
                        	}

                        }

                %>
                        <input type="text" name="st_budget_dept_name"  value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"":rowData.get("BUDGET_DEPT_NAME")%>" style="line-height:1.5;width:65%;border:0;background-color:<%=tclass%>;color:#003694;" READONLY>
                <%if(rowData.get("VIEW_FLAG").equals("N")){ %>        
               			<input type="text" name="st_bdgt_bal_amt" value="0" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#003694;" READONLY >
				<%}else{
					if( db_totSum > db_bdgt_bal_amt ){%>                        
						<input type="text" name="st_bdgt_bal_amt"  value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#ee3212;" READONLY>
				<%	}else{%>
						<input type="text" name="st_bdgt_bal_amt"  value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#003694;" READONLY>
				<%	}
				  }%>	
						<input type="hidden" name="st_budget_amt" value="<%=CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), false, 0, 0)%>">
                        <input type="hidden" name="st_budget_dept" value="<%=rowData.get("BUDGET_DEPT_CODE")%>">
                        <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_mg_code"      value="<%=rowData.get("MG_CODE")%>">
                        <input type="hidden" name="st_mg_note"      value="<%=rowData.get("MG_NOTE")%>">
                        <input type="hidden" name="st_mng_flag"  value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
                        <input type="hidden" name="st_mng_dept_cd" value="<%=rowData.get("MNG_DEPT_CD")%>">
                        </div>
                  </td>
                <%
                    }else{  // ICOMCMPY.BUDGET_FLAG = 'N' 예산 미사용 고객사
                %>
                	
                        <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_budget_dept"  value="">
                        <input type="hidden" name="st_mg_code"      value="<%=rowData.get("MG_CODE")%>">
                        <input type="hidden" name="st_mg_note"      value="<%=rowData.get("MG_NOTE")%>">
                        <input type="hidden" name="st_mng_flag"  	value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
                        <input type="hidden" name="st_mng_dept_cd"  value="">
                        <input type="hidden" name="st_account_type_name"  value="">
                        <input type="hidden" name="st_bdgt_bal_amt"  value="">
                <%
                    }
                %>
                
                <td class="right"  title="단가/구매수량" >
                    <% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
                        <input type="text" name="st_order_price"    style="width:65%;text-align:right;"   value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');">
                    <% }else { %>
                       <span class="Price"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></span>
                        <input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
                    <% } %>
                    <input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
                     <br>
                     <%if(p060000080.equals("TYPE1") && CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")) { %>
                     	<input type="text" name="st_size_len"    id="line" style="width:30%;text-align:right;"  value="<%=rowData.get("SIZE_LEN")%>" onChange="javascript:price_size_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("SIZE_QTY")%>','<%=rowData.get("SIZE_LEN")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">/
                     	<input type="text" name="st_size_qty"    id="line" style="width:30%;text-align:right;"  value="<%=rowData.get("SIZE_QTY")%>" onChange="javascript:price_size_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("SIZE_QTY")%>','<%=rowData.get("SIZE_LEN")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                     <%}else{ %>
                     	<input type="text" name="st_order_qty"    id="line" style="width:65%;text-align:right;"  value="<%=rowData.get("CART_QTY")%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                     	<input type="hidden" name="st_size_qty" value="">
                     	<input type="hidden" name="st_size_len" value="">
                     <%} %>
         </td>
<!-- 홍익대학교-- 대학원 소속 체크. -->

 
<%

String tmpTitle = "";
//SLOGIC-BEGIN(P06-0000027)
if("Y".equals(hongikType)){ 
	tmpTitle = "구매액/대학원 학과"; 
}
else if("TYPE1".equals(p060000027)){ // KRGEST0001 
	tmpTitle = "구매액/계정과목";   
}else if("TYPE3".equals(p060000027)){ // KRKEPB0004 
		tmpTitle = "구매액/대학원 학과";   
	}else{ 
	tmpTitle = "구매액";  
}

%>

 
 
                <%
                    if("Y".equals(hongikType)){
                %>
                        <td align="right" title="<%=tmpTitle %>" >
                           <input type="text" class="Price" name="st_sum_price"   style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  READONLY>
                            <a href="javascript:getHongIkDeptCode('<%=j%>');">
                            <input type="text" name="st_ref_pr_dept_name" id="line"  style="width:65%;cursor:pointer;text-align:right;"  value="<%=rowData.get("HI_DEPT_NAME")%>" READONLY></a>  
                        </td>
                <% 
                    }else if(p060000027.equals("TYPE3")){//----------------------지멘스 KRKEPB0004
                %>
                         <td align="right"  title="<%=tmpTitle %>" >
                            <input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
                            <a href="javascript:getHongIkDeptCode('<%=j%>');">
                            <input type="text" name="st_ref_pr_dept_name"  id="line" style="width:65%;cursor:pointer;text-align:right;"  value="<%=rowData.get("HI_DEPT_NAME")%>" READONLY></a>
                        </td>
                <%
                    }else if(p060000027.equals("TYPE1")){ //KRGEST0001
                %>
                        <td align="right"  title="<%=tmpTitle %>" >
                            <input type="text" class="Price"  name="st_sum_price"   style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
                           <a href="javascript:getKRGEST0001('<%=j%>','M015','<%=m015Text%>');">
                            <input type="text" name="st_ref_pr_text2"    id="line" style="width:85%;cursor:pointer;text-align:right;" value="<%=m015Text%>"    readonly></a>
                        </td>
                <%
                }else{
                %>
	                <%if(p060000080.equals("TYPE1") && CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")) { %>
	
							<td class="right"  title="<%=tmpTitle %>" >
								<input type="text" class="Price" name="st_order_qty"  style="width:65%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=rowData.get("TOTAL_SIZE_QTY")%>"   READONLY><br>
								<input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
							</td>
	                <%}else{%>
							<td class="right"  title="<%=tmpTitle %>" >
								<input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
							</td>
	                <%}%>
               <%
                    }
                %>
                <td class="center"  title="파일첨부">
                <%
					if(!rowData.get("IMAGE_KEY").equals("")) {
                %>
					<span class="btn_quickbuy mb02"  title="파일추가" name="file_button"><a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>','<%=j%>');"><%=CommonLang.get("HTITLE632") %><!-- 파일추가 --></a></span>
                <%
					}else {
                %>
					<span class="btn_wishproduct mb02"  title="파일추가" name="file_button"><a href="javascript:gridPopOpen('<%=j%>');"> <%=CommonLang.get("HTITLE632") %><!-- 파일추가 --></a></span>
                <%
					}
                %>
                </td>
                <%if (userRole2.equals("+")) { %>
                <td><% if(p060000081 != true && p060000084 != true){ %>
					<span class="btn_quickbuy mb02"  title="바로주문"><a href="javascript:item_qty_updateSel('<%=j%>')"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></a></span><br>
			        <% } %>
					<span class="btn_wishproduct"  title="나의상품"><a href="javascript:setMyCatalogRegSel('<%=j%>')"><%=CommonLang.get("HTITLE593") %><!-- 나의상품 --></a></span></td> 
                    <%
                    }
                %>
                </tr>
                <tr bgcolor="<%=tclass%>">
                	<td class="center" title="관리번호" ><b><%=p060000029_col05%></b></td>
                	<td class="center" title="관리번호" >
	                    <input type="hidden" name="st_item_no"				value="<%=rowData.get("BUYER_ITEM_NO")%>" >
	                    <input type="hidden" name="st_contract_no"			value="<%=rowData.get("CONTRACT_NO")%>">
	                    <input type="hidden" name="st_contract_seq"			value="<%=rowData.get("CONTRACT_SEQ")%>">
	                    <input type="hidden" name="st_agent_code"			value="<%=rowData.get("AGENT_CODE")%>">
	                    <input type="hidden" name="st_byit_comorg_code"		value="<%=rowData.get("BYIT_COMORG_CODE")%>">
	                    <input type="hidden" name="st_bdgt_flag"			value="<%=rowData.get("BDGT_FLAG")%>">
	                    <input type="hidden" name="st_product_close_flag"	value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
	                    <input type="hidden" name="st_process_type"			value="<%=rowData.get("PROCESS_TYPE")%>">
	                    <input type="hidden" name="st_stock_item_flag"		value="<%=rowData.get("STOCK_ITEM_FLAG")%>">
	                    <input type="hidden" name="st_ref_pr_dept"			value="<%=rowData.get("HI_DEPT_CODE")%>">
	 					<input type="hidden" name="st_yuhan_saperp_flag"	value="<%=rowData.get("YUHAN_SAPERP_FLAG")%>">
	 					<input type="hidden" name="st_item_status_flag"		value="<%=rowData.get("ITEM_STATUS_FLAG")%>">
	 					<input type="hidden" name="st_mg_note_input"		value="<%=rowData.get("MG_NOTE_INPUT")%>">
	 					<input type="hidden" name="st_image_key"            value="<%=rowData.get("IMAGE_KEY")%>">
	 					<input type="hidden" name="st_seq"					value="<%=rowData.get("SEQ")%>">
	 					<input type="hidden" name="st_remark"				value="<%=rowData.get("REMARK")%>">
	 					<input type="hidden" name="st_item_mng_flag"		value="<%=rowData.get("ITEM_NO_MNG_FLAG")%>">
 						<input type="hidden" name="st_min_order_qty"		value="<%=rowData.get("MIN_ORDER_QTY")%>">
 						<input type="hidden" name="st_pur_unit_qty"			value="<%=rowData.get("PUR_UNIT_QTY")%>">
 						<input type="hidden" name="st_over_short_flag"		value="<%=rowData.get("OVER_SHORT_FLAG")%>">
 						<input type="hidden" name="st_stock_cnt" id="st_stock_cnt"	value="<%=rowData.get("STOCK_CNT")%>">
 						<input type="hidden" name="st_atch_flag"			value="<%=rowData.get("ATCH_FLAG")%>">
 						<input type="hidden" name="st_buyer_category_no"	value="<%=rowData.get("BUYER_CATEGORY")%>">
 						<input type="hidden" name="st_urct2_yn" 			value="<%=rowData.get("URCT2_YN")%>">
 						<input type="hidden" name="st_msds_yn"				value="<%=rowData.get("MSDS_YN")%>">
 						<input type="hidden" name="st_pr_reason"			value="<%=rowData.get("PR_REASON")%>">
 							
<!--  					//SLOGIC-BEGIN(P06-0000029)	 -->
                    <%if(p060000029.equals("TYPE16")) { // 롯데푸드 관리번호 명 관리%>
						<a href="javascript:getRefPrNo_lotte('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');">
						<%if(rowData.get("REF_PR_NO").length() > 0){%>
							<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                           <%}else{ %>
							<input type="hidden" name="st_ref_pr_no" value="">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
						<%} %>
					<%}else if(p060000029.equals("TYPE20")) { // 에스와이에스리테일 관리번호%>
						<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', 'T001');">
						<%if(rowData.get("REF_PR_NO").length() > 0){%>
						<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
						<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
						<%}else{ %>
							<iput type="hidden" name="st_ref_pr_no" value="">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
						<%} %>
					<%}else if(p060000029.equals("TYPE21")) { // 동원시스템즈 그룹 관리번호%>
						<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', 'T002');">
						<%if(rowData.get("REF_PR_NO").length() > 0){%>
							<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
						<%}else{ %>
							<input type="hidden" name="st_ref_pr_no" value="">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
						<%} %>
					<%}else if(p060000029.equals("TYPE22")) { // 동화산업 그룹 관리번호%>
						<a href="javascript:getDongHwa('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("BUYER_ITEM_NO")%>');">
						<input type="text" name="st_ref_pr_no"   style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>
					<%}else if(p060000029.equals("TYPE26")) { // 롯데후레쉬델리카 관리번호%>
						<a href="javascript:getRefPrNo_lotteFresh('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');">
						<%if(rowData.get("REF_PR_NO").length() > 0){%>
							<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
						<%}else{ %>
							<input type="hidden" name="st_ref_pr_no" value="">
							<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
						<%} %>
					<%} else {%>
						<input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;text-align:center;height:25px;" maxlength="200" value="<%=rowData.get("REF_PR_NO")%>">
						<%} 
            					//SLOGIC-END%>
					</td>
					
					<%if(p060000029.equals("TYPE26")) { // 롯데후레쉬델리카 관리번호명%>
						<td class="left" title="관리번호명" colspan="6">
							<a class="hyperLink"  id="st_ref_pr_no_name" name="st_ref_pr_no_name" href="javascript:getRefPrNo_lotteFresh('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');"><%=rowData.get("REF_PR_NO_TEXT")%></a>
					   </td>
					<%}else{ //롯데푸드 관리번호명%>
						<td class="left" title="관리번호명" colspan="6">
							<a class="hyperLink"  id="st_ref_pr_no_name" name="st_ref_pr_no_name" href="javascript:getRefPrNo_lotte('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');"><%=rowData.get("REF_PR_NO_TEXT")%></a>
					   </td>
					<%}%>
<%
if("Y".equals(budget_flag)){ 
%>                              
               <td></td>
<%} %> 					
                </tr>
<%
		}
// SLOGIC-END
	}
}else{ // SET 2 롯데푸드 이외 화면 이후
%>
<table class="cont_t_list002" style="width:100%">
			<colgroup>
				<col width="3%" />
				<col width="7%" />
				<col width="12%" />
				<col width="*" />
            	<col width="11%" />
<%
if("Y".equals(budget_flag)){ 
%>                              
               	<col width="16%" />
               	<col width="7%" />            
               	<col width="10%" />
<%} else { %>
				<col width="10%" />            
               	<col width="8%" />
<%}%>    
               	
               	<col width="7%" />
               	<col width="7%" />
           </colgroup>
           <thead>
               <tr>
                   <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>
                   <input type="checkbox" class="input_noline" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');chk_sum_price();">
<%} %>
                   </th>
                   <th scope="col">&nbsp;</th>
                   <th scope="col"><a class="PDnameLink" href="javascript:setRefNoCopy();">
<!-- 일진전기 관리항목 -->
<%
//SLOGIC-BEGIN(P06-0000027)
if(p060000027.equals("TYPE2")) {
%>
<font color="#FF6600">*</font><%=CommonLang.get("HTITLE633") %><!-- 회계번호 -->
<%
}else if(p060000029.indexOf("TYPE11") > -1) {
%>
<font color="#FF6600">*</font><%=CommonLang.get("HTITLE634") %><!-- 관리항목 -->
<%
}else if(p060000027.indexOf("TYPE7") > -1) {
%>
<font color="#FF6600">*</font><%=CommonLang.get("HTITLE635") %><!-- 자재그룹 -->
<%
}else if(p060000027.indexOf("TYPE8") > -1) {
%>
<font color="#FF6600">*</font><%=CommonLang.get("HTITLE636") %><!-- 귀속부서 / 관장부서 -->
<br>
<%=CommonLang.get("HTITLE637") %><!-- 계정코드 / 세금코드 -->
<%
}else if(p060000027.indexOf("TYPE9") > -1) {
%>
<font color="#FF6600">*</font><%=CommonLang.get("HTITLE643") %><!-- 사용부서 -->
<%
}else if(p060000029.indexOf("TYPE35") > -1) {
	%>
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE976") %><!-- 고정자산번호 -->
	<%
} else if(p060000029.indexOf("TYPE36") > -1) {
	%>
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE982") %><!-- G/L번호 -->
	<%
} else if(p060000029.indexOf("TYPE37") > -1) {
	%>
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE984") %><!-- 예산계정코드 -->
	<%
} else if(p060000029.indexOf("TYPE39") > -1) {
	%>
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE1038") %><!-- 계정/코스트센터 -->
	<%
} else if(p060000029.indexOf("TYPE40") > -1) {
	%>
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE1038") %><!-- 계정/코스트센터 -->
	<%
}else if(byca_comorg_code.equals("KRAMORG001") && !SessionComCode.equals("KRAMOR0005")) {
	%>	
	<font color="#FF6600">*</font><%=CommonLang.get("HTITLE983") %><!-- WBS코드  -->
	<%
}else{
	%>
<% if(p060000027_ref || p060000029_ref) { %> 
 <font color="#FF6600">*</font>
 <% } %>
 <%=CommonLang.get("HTITLE18") %><!-- 관리번호 -->
<%
}
//SLOGIC-END
%>
</a>				</th>
                   <th scope="col"><%=CommonLang.get("HTITLE173") %><!-- 품목코드 / 품목명 / 규격 / 제조사 --></th>
                   <%if(true == p060000117){%>
                   		<th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><%=CommonLang.get("HTITLE52") %><!-- 단위 --> / <%=CommonLang.get("HTITLE964") %><!-- 납기일 --></th>
                   <%}else{ %>
                   		<th scope="col"><%=CommonLang.get("HTITLE31") %><!-- 협력사 / 단위 --></th>
                   <%} %>
<%

if("Y".equals(budget_flag)){
	if(p060000080.equals("TYPE2")){
%>
		<th scope="col"><font color="#FF6600">*</font><%=CommonLang.get("HTITLE626") %><!-- GL계정 / 비용부서 / 예산잔액   --></th>
<%		
	}else{
%>		
		<th scope="col"><font color="#FF6600">*</font><%=CommonLang.get("HTITLE627") %><!-- 계정명 / 예산부서 / 예산잔액   --></th>
<%
	}
}else{
%>                	
<%}   %>    
<%    
if(p060000080.equals("TYPE1")) {
%>
                   <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE628") %><!-- 길이 / 수량 --></th>
                   <th scope="col">
<%
}else{ 
	if("Y".equals(budget_flag)){ %>      
	                   <th scope="col"><%=CommonLang.get("HTITLE938") %><!-- MOQ --><br><%=CommonLang.get("HTITLE939") %><!-- 주문배수 --></th>
	                   <th scope="col">	                   	          	
	<%} else { %>
					   <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE175") %><!-- 구매수량 --></th>
	                   <th scope="col">	
	<% } 
} %>	    
<%
if("Y".equals(hongikType)){
%>
<%=CommonLang.get("HTITLE629") %><!-- 구매액/대학원 학과 -->
<%
}
else if("TYPE1".equals(p060000027)){ // KRGEST0001
%>
<%=CommonLang.get("HTITLE630") %><!-- 구매액/계정과목 -->
<%
}else{
	if(p060000080.equals("TYPE1")) {
%>
	<%=CommonLang.get("HTITLE631") %><!-- 총수량 / 구매액 -->
<%
	}else{
      	if("Y".equals(budget_flag)){ %>
      		<%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE175") %><!-- 구매수량 --><br><%=CommonLang.get("HTITLE176") %><!-- 구매액 -->
      	<% } else { %>
			<%=CommonLang.get("HTITLE176") %><!-- 구매액 -->	
		<% } %>		          	
<%}%>
<%
}
%>
						</th>
						<th scope="col">
							<%=CommonLang.get("HTITLE177") %><!-- 파일첨부 -->
					<%if(!pr_reason_yn.equals("")) { %>
							<br>
							<%=CommonLang.get("HTITLE1168") %><!-- 구매사유 -->
					<%}%>
						</th>
                           
					<%if (userRole2.equals("+")) { %>
						<th>
							<%=CommonLang.get("HTITLE783") %><!-- 품목비고-->
							<br>
							<%=CommonLang.get("HTITLE178") %><!-- 선택 -->
						</th>
					<%} %>
               </tr>
           </thead>
           <tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
		<tr>
			<td colspan="16" align="center" height = "50"> 
			<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
			</td> 
		</tr>
<%
}else{

	
Map<String,String> rowData = null;
for (int j=0; j<_gridList.size(); j++) {
	rowData = _gridList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";


	String tmpText = rowData.get("REF_PR_NO");
	String totSum = CommonUtil.nvl(rowData.get("TOT_SUM"), "0");
	String bdgt_bal_amt = CommonUtil.nvl(rowData.get("BDGT_BAL_AMT"), "0");
	
	double db_totSum = Double.parseDouble(totSum);
	double db_bdgt_bal_amt = Double.parseDouble(bdgt_bal_amt);
	
	String m014Text  ="";
	String m015Text  ="";
	if(tmpText.length() == 10){
		m014Text = tmpText;
	}else if(tmpText.length() == 20){
		m014Text = tmpText.substring(0,10);
		m015Text = tmpText.substring(10);
	}
	
%> 
				<tr bgcolor="<%=tclass%>">
<%if(p060000100.equals("TYPE1")||p060000100.equals("TYPE2")){%>
					<td rowSpan=2>
<%}else{%>					
					<td>
<%}%>					
						<input type="checkbox" class="input_noline" name="lnCheck<%=j%>" onclick="chk_sum_price()">	 
					</td>
                    <td title="이미지" >
                    <div class="PDimg">
                    
<% if(st_image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outitem'>품절</span>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outitem'>품절</span>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%> 
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outitem'>품절</span>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outitem'>품절</span>")%>
          <%=(!CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y") ? "" : "<span class='outitem'>단종</span>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<span class='outitem'>삭제</span>")%>
 
<%     }
    }
%>		 
                    </div>
                    </td>
					<td class="center" title="관리번호" >
                    <input type="hidden" name="st_item_no"            value="<%=rowData.get("BUYER_ITEM_NO")%>" >
                    <input type="hidden" name="st_contract_no"        value="<%=rowData.get("CONTRACT_NO")%>">
                    <input type="hidden" name="st_contract_seq"       value="<%=rowData.get("CONTRACT_SEQ")%>">
                    <input type="hidden" name="st_agent_code"         value="<%=rowData.get("AGENT_CODE")%>">
                    <input type="hidden" name="st_byit_comorg_code"   value="<%=rowData.get("BYIT_COMORG_CODE")%>">
                    <input type="hidden" name="st_bdgt_flag"          value="<%=rowData.get("BDGT_FLAG")%>">
                    <input type="hidden" name="st_product_close_flag" value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
                    <input type="hidden" name="st_process_type"         value="<%=rowData.get("PROCESS_TYPE")%>">
                    <input type="hidden" name="st_stock_item_flag"      value="<%=rowData.get("STOCK_ITEM_FLAG")%>">
                    <input type="hidden" name="st_ref_pr_dept" value="<%=rowData.get("HI_DEPT_CODE")%>">
 					<input type="hidden" name="st_yuhan_saperp_flag"			value="<%=rowData.get("YUHAN_SAPERP_FLAG")%>">
 					<input type="hidden" name="st_item_status_flag"			value="<%=rowData.get("ITEM_STATUS_FLAG")%>">
 					<input type="hidden" name="st_mg_note_input"			value="<%=rowData.get("MG_NOTE_INPUT")%>">
 					<input type="hidden" name="st_image_key"            value="<%=rowData.get("IMAGE_KEY")%>">
 					<input type="hidden" name="st_seq"            value="<%=rowData.get("SEQ")%>">
 					<input type="hidden" name="st_remark"            value="<%=rowData.get("REMARK")%>">
 					<input type="hidden" name="st_item_mng_flag"	value="<%=rowData.get("ITEM_NO_MNG_FLAG")%>">
 					<input type="hidden" name="st_min_order_qty"	value="<%=rowData.get("MIN_ORDER_QTY")%>">
 					<input type="hidden" name="st_pur_unit_qty"	value="<%=rowData.get("PUR_UNIT_QTY")%>">
 					<input type="hidden" name="st_over_short_flag" value="<%=rowData.get("OVER_SHORT_FLAG")%>">
 					<input type="hidden" name="st_stock_cnt" id="st_stock_cnt" value="<%=rowData.get("STOCK_CNT")%>">
 					<input type="hidden" name="st_atch_flag" id="st_atch_flag" value="<%=rowData.get("ATCH_FLAG")%>">
 					<input type="hidden" name="st_buyer_category_no" value="<%=rowData.get("BUYER_CATEGORY")%>">
 					<input type="hidden" name="st_urct2_yn" value="<%=rowData.get("URCT2_YN")%>">
					<input type="hidden" name="st_msds_yn"				value="<%=rowData.get("MSDS_YN")%>">
					<input type="hidden" name="st_pr_reason"            value="<%=rowData.get("PR_REASON")%>">
 						
                    <%
                  //SLOGIC-BEGIN(P06-0000029)
                    			if(p060000029.equals("TYPE2")) { //FAG의 경우 KRKEPB0006 KRFAGB0001 KRFAGB0002 KRFAGB0003 %>
                                    <a href="javascript:getKRFagKorea('<%=j%>','<%=rowData.get("REF_PR_NO")%>');"><input type="text" name="st_ref_pr_no"     id="line" style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>
                                <% }else if(p060000029.equals("TYPE3")) { //INA의 경우 KRSCHA0001%>
                                    <a href="javascript:getInaKorea('<%=j%>','<%=rowData.get("REF_PR_NO")%>');"><input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>

                                <% }else if(p060000029.equals("TYPE4")) { //경동보일러,경동정밀 경우
                                	// KRKDBO0003 KRKDPR0003 KRSEOJ0020 KRSEOJ0021 KRSEOJ0022 KRSEOJ0023 KRSEOJ0024 KRSEOJ0025                                                    
                                                    %>
                                    <a href="javascript:getKyungDong('<%=j%>','<%=rowData.get("REF_PR_NO")%>');"><input type="text" name="st_ref_pr_no"   id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>

                                <% }else if(p060000029.equals("TYPE5") ) { //동일방직 장항공장
                                // KRDONG0078 KRDONG0077 KRDONG0079 KRJINR0005 %>
                                    <a href="javascript:getDongIl('<%=j%>','<%=rowData.get("REF_PR_NO")%>');"><input type="text" name="st_ref_pr_no"   id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>

                                <% } else if(p060000029.equals("TYPE10")) { //두산인프라코어(주)이알피 경우 KRDHIM0004 %> 
                                                    <input type="text" name="st_ref_pr_no"    id="line"  value="<%=rowData.get("REF_PR_NO")%>">

                                <% } else if(p060000029.equals("TYPE6")) {
                                // KRHONG0020 KRCONT0006 KRCONT0007 KRCONT0008 KRCONT0009
                                %>
                                      <a href="javascript:getHongik('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <input type="text" name="st_ref_pr_no_text"     id="line" style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>
                                      <input type="hidden" name="st_ref_pr_no" id="line"  style="cursor:pointer;" value="<%=rowData.get("REF_PR_NO")%>" readonly>
                                <% } else if(p060000029.equals("TYPE11")) {
                                // 일진전기 관리항목 추가.
                                %>
                                      <a href="javascript:getILJI('<%=j%>','<%=rowData.get("MG_NOTE")%>');">
                                      <input type="text" name="st_ref_pr_no_text"     id="line" style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("ILJIN_REF_NO")%>" readonly></a>
                                      <input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                <%}else if(p060000029.equals("TYPE7")) {
                                // KRINKT0001  KRKOLO0018 %>
                                      <a href="javascript:getKRINKT0001('<%=j%>','<%=rowData.get("REF_PR_NO")%>');"><input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>
                                <%}else if(p060000029.equals("TYPE8")) { // KRGEST0001%>
                                      <input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      <a href="javascript:getKRGEST0001('<%=j%>','M014','<%=m014Text%>');">
                                      <input type="text" name="st_ref_prtext"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=m014Text%>" readonly></a>
                                <%}else if(p060000029.equals("TYPE12")) { // 지멘스 헬스케어(주) (KRSIEM0014)%>
                                      <input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      <a href="javascript:getKRSIEM0014('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                <%}else if(p060000029.equals("TYPE13")) { // 일진제강 관리번호 코드 관리%>
                                      <a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
                                <%}else if(p060000029.equals("TYPE14")) { // 대한제분 관리번호 명 관리%>
                                      <a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
								<%}else if(p060000029.equals("TYPE15")) { // 윈체(KRWINC0002, KRWINC0003) 관리번호 명 관리%>
                                      <a href="javascript:getRefPrNo_4cond('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											 <input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
								<%}else if(p060000029.equals("TYPE16")) { // 롯데푸드 관리번호 명 관리%>
                                      <a href="javascript:getRefPrNo_lotte('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											 <input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
								<%}else if(p060000029.equals("TYPE18")) { // 셀트리온(KRCELL0008, KRCELL0009,KRCELL0010) 관리번호 명 관리%>
                                      <a href="javascript:getCelltrion('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											 <input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
                                <%}else if(p060000029.equals("TYPE17")) { // 영풍%>
                                      <a href="javascript:getYpCostCenter('<%=j%>','<%=rowData.get("YP_COST_CENTER")%>');">
                                      <%if(rowData.get("YP_COST_CENTER").length() > 0){%>
                                      		<input type="hidden" name="st_yp_cost_center" value="<%=rowData.get("YP_COST_CENTER")%>">
                                      		<input type="text" name="st_yp_cost_center_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("YP_COST_CENTER_TEXT")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_yp_cost_center" value="">
											 <input type="text" name="st_yp_cost_center_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>
                                      <%} %>
                                      <br>
                                      <a href="javascript:getYpWbs('<%=j%>','<%=rowData.get("YP_WBS")%>');">
                                      <%if(rowData.get("YP_WBS").length() > 0){%>
                                      		<input type="hidden" name="st_yp_wbs" value="<%=rowData.get("YP_WBS")%>">
                                      		<input type="text" name="st_yp_wbs_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("YP_WBS_TEXT")%>"  readonly>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_yp_wbs" value="">
											 <input type="text" name="st_yp_wbs_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>
                                      <input type="hidden" name="st_ref_pr_no" value="">
								<%}else if(p060000029.equals("TYPE20")) { // 에스와이에스리테일 관리번호%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', 'T001');">
									<%if(rowData.get("REF_PR_NO").length() > 0){%>
										<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
										<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
									<%}else{ %>
										<input type="hidden" name="st_ref_pr_no" value="">
										<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
									<%} %>
								<%}else if(p060000029.equals("TYPE21")) { // 동원시스템즈 그룹 관리번호%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', 'T002');">
									<%if(rowData.get("REF_PR_NO").length() > 0){%>
										<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
										<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
									<%}else{ %>
										<input type="hidden" name="st_ref_pr_no" value="">
										<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
									<%} %>
								<%}else if(p060000029.equals("TYPE22")) { // 동화산업 그룹 관리번호%>
									<a href="javascript:getDongHwa('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("BUYER_ITEM_NO")%>');">
									<input type="text" name="st_ref_pr_no"   style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>" readonly></a>
								<%}else if(p060000029.equals("TYPE23")) { // SPC%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
										<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
										<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                <%}else if(p060000029.equals("TYPE24")) { // KG그룹%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                                      <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                      		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                      		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                      <%}else{ %>
                                      		 <input type="hidden" name="st_ref_pr_no" value="">
											<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                      <%} %>						
								<%}else if(p060000029.equals("TYPE25")) {%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', 'T002');">
									<%if(p060000104_type.equals("TYPE1")){ // P06-0000104 타입에 따른 기본 관리번호 세팅(TYPE1: 협력사조건), 표기법-관리번호명(관리번호) %>
										<%if(p060000104_agent.equals(rowData.get("AGENT_CODE"))){  %>
											<input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=p060000104_ref_pr_no_text%>(<%=p060000104_ref_pr_no%>)"  readonly>									
										<%}else{%>
											<input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly>
										<%}%>
									<%}else{%>
										<input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly>
									<%}%>
									</a>
								<%}else if(p060000029.equals("TYPE100")) {%>
									<a href="javascript:getRefprnoInfo('<%=j%>','<%=rowData.get("REF_PR_NO")%>', '');">
										<input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO").equals("")?rowData.get("DEFAULT_REF_PR_NO"):rowData.get("REF_PR_NO")%>"  readonly>
									</a>
								<%}else if(p060000029.equals("TYPE26")) { // 롯데후레쉬델리카 관리번호 명 관리%>
                                    <a href="javascript:getRefPrNo_lotteFresh('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');">
                                    <%if(rowData.get("REF_PR_NO").length() > 0){%>
                                    		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                                    		<input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value="<%=rowData.get("REF_PR_NO")%>"  readonly></a>
                                    <%}else{ %>
                                    		 <input type="hidden" name="st_ref_pr_no" value="">
									 <input type="text" name="st_ref_pr_no_text"    id="line"  style="width:80%;cursor:pointer;text-align:center;height:25px;" value=""  readonly></a>											                                      		
                                    <%} %>
								<%}else if(p060000029.equals("TYPE27")) { // 한컴라이프케어 관리번호%>
									<a href="javascript:getHancomLC('<%=j%>','<%=rowData.get("REF_PR_NO")%>','<%=rowData.get("REMARK")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE28")) { // 해비치호텔앤드리조트 주식회사(제주) 관리번호%>
									<a href="javascript:getRefPrNoHaev('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE29")) { // (주)케이씨텍 관리번호%>
									<a href="javascript:getRefPrNoKcte('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE30")) { // 주식회사 엔씨켐 관리번호%>
									<a href="javascript:getRefPrNoNc('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE31")) { // 금호석유화확 관리번호%>
									<a href="javascript:getRefPrNoKuG('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
								<%}else if(p060000029.equals("TYPE32")) { // 와이지원 관리번호%>
									<a href="javascript:getRefPrNoYG1('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                              		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                              		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE33")) { // 솔브레인그룹 관리번호%>
									<a href="javascript:getRefPrNoSolb('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE34")) { // 한샘 관리번호
                                	if(rowData.get("BUYER_CATEGORY").contains(p060000129_col01)){ // 카테고리가 전산인 경우 (ex. 999)
                                %>		
                               		<a href="javascript:getRefPrNoHans('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%
                                	}else{ // 전산 이외의 경우
                              	%>	
									<input type="hidden" name="st_ref_pr_no_text"    id="line"  style="width:80%;text-align:center;height:25px;" maxlength="200" value="<%=rowData.get("REF_PR_NO")%>">
									<input type="text" name="st_ref_pr_no" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>">
                              	<%	
                                	}
                                %>
									
                                <%}else if(p060000029.equals("TYPE35")) { // 넥센타이어 관리번호%>
									<a href="javascript:getRefPrNoNexe('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE36")) { // 아모레퍼시픽 연구소 관리번호%>									
                               		<select style="width: 90%;" name='st_ref_pr_no' id="st_ref_pr_no">
                               			<%=	CommonUtil.getCodeBComboList(buyer,"SEL","M014","ICOMCOD2",rowData.get("REF_PR_NO"),rowData.get("REF_PR_NO_TEXT")) %>
                               		</select>
                               		<input type="hidden" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="" readonly>
									</a>
                                <%}else if(p060000029.equals("TYPE37")) { // 중외제약 예산계정코드 %>									
                               		<select style="width: 90%;" name='st_ref_pr_no' id="st_ref_pr_no">
	                           			<%=	CommonUtil.getTextValueComboList(buyer,"SEL","M014","ICOMCOD2","",rowData.get("REF_PR_NO")) %>
	                           		</select>
	                           		<input type="hidden" name="st_ref_pr_no_text" id="line" style="width: 80%; cursor: pointer; text-align: center; height: 20px;"  value="" readonly>
									</a>
								<%}else if(p060000029.equals("TYPE39")) { // LB세미콘주식회사 계정/코스트센터%>
									<a href="javascript:getRefPrNoLbse('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 90%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                            	<%}else if(p060000029.equals("TYPE40")) { // (주)한솔홈데코 계정/코스트센터/계정지정범주 %>
									<a href="javascript:getRefPrNohahome('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
                               		<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_PR_NO")%>">
                               		<input type="text" name="st_ref_pr_no_text" id="line" style="width: 90%; cursor: pointer; text-align: center; height: 20px;"  value="<%=rowData.get("REF_PR_NO")%>" readonly>
									</a>
                            	<%}else {%>
                                    <input type="text" name="st_ref_pr_no"    id="line"  style="width:80%;text-align:center;height:25px;" maxlength="200" value="<%=rowData.get("REF_PR_NO")%>">
            					<%} 
            					//SLOGIC-END%>

 
					</td>
					<td class="left" title="품목코드/품목명/규격/제조사" >&nbsp;
						<input type="hidden" name="st_description" value="<%=rowData.get("DESCRIPTION_LOC")%>">
					&nbsp;<a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
					<%=rowData.get("DESCRIPTION_LOC")%><br>
					&nbsp;&nbsp;&nbsp;<%=rowData.get("SPECIFICATION")%> / <%=rowData.get("MAKER_NAME")%>
						
						
						 / MOQ:  <%=rowData.get("MIN_ORDER_QTY")%>
						
						 / 주문배수:  <%=rowData.get("PUR_UNIT_QTY")%>
						
						<%
							if(!rowData.get("STOCK_CNT").equals("")) {
						%>
						 / 재고:  <%=rowData.get("STOCK_CNT")%>
						<%
							}
						%>
						<% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp; <% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp; <% } else { %> <br>&nbsp;&nbsp;<font color="green"><%=CommonLang.get("HTITLE597") %><!-- (재 판매일 : --><%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>
				   </td>
   				   <%if(true == p060000117){%>
   				   		<td align="center"  title="협력사/단위/품목별 납기 리드타임" >
							<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a><br><%=rowData.get("UNIT_MEASURE")%> / <%=rowData.get("DELIVERY_LT")%> 일
				   		</td>
                   <%}else{%>
					   <td align="center"  title="협력사/단위" >
							<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a><br><%=rowData.get("UNIT_MEASURE")%>
					   </td>
				   <%}%>
			
		
                <%
 
                    // ICOMCMPY.BUDGET_FLAG = 'Y' 예산 사용 고객사
                    if("Y".equals(budget_flag)){

                %>
				<td  title="계정명/예산부서/예산잔액" >
					  <!-- 계정명 , 예산부서 , 예산잔액 -->
					 <div style="cursor:pointer;">
                <%
						//E.BUDGET_FLAG ='Y'  B.ACCOUNT_TYPE = 'M' 
                        if(rowData.get("ACCOUNT_NAME").equals(""))

                        {

                %>                   

                                   <input type="text"   name="st_account_type_name"  value="선택"  style="width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"    READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">

                <%

                        }else{
                        	//관리부서 통제가 들어갈 경우 계정정보+관리부서로 보여 짐
                        	if(p060000090==true) {
                %>                                    
                                    <input type="text"   name="st_account_type_name"  value="<%=rowData.get("MNG_DEPT_NM")%>"    style="line-height:1.5;width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"   READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">
				<%
                        	}else{
				%>     
									<input type="text"   name="st_account_type_name"  value="<%=rowData.get("ACCOUNT_NAME")%>"    style="line-height:1.5;width:65%;border:0;cursor:pointer;background-color:<%=tclass%>;color:#003694;"   READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>','<%=j%>','<%=rowData.get("BUYER_CATEGORY")%>');">
                <%
                        	}

                        }

                %>
                        <input type="text" name="st_budget_dept_name"  value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"":rowData.get("BUDGET_DEPT_NAME")%>" style="line-height:1.5;width:65%;border:0;background-color:<%=tclass%>;color:#003694;" READONLY>
                <%if(rowData.get("VIEW_FLAG").equals("N")){%>
                		<input type="text" name="st_bdgt_bal_amt" value="0" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#003694;" READONLY >
				<%}else{
					if( db_totSum > db_bdgt_bal_amt ){%>                        
						<input type="text" name="st_bdgt_bal_amt"  value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#ee3212;" READONLY>
				<%	}else{%>
						<input type="text" name="st_bdgt_bal_amt"  value="<%=rowData.get("BDGT_BAL_AMT").equals("")?"0":CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" style="font-weight:bold;width:65%;border:0;text-align:right;background-color:<%=tclass%>;color:#003694;" READONLY>
				<%	}
				  }%>	
						<input type="hidden" name="st_budget_amt" value="<%=CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), false, 0, 0)%>">
                        <input type="hidden" name="st_budget_dept" value="<%=rowData.get("BUDGET_DEPT_CODE")%>">
                        <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_mg_code"      value="<%=rowData.get("MG_CODE")%>">
                        <input type="hidden" name="st_mg_note"      value="<%=rowData.get("MG_NOTE")%>">
                        <input type="hidden" name="st_mng_flag"  value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
                        <input type="hidden" name="st_mng_dept_cd" value="<%=rowData.get("MNG_DEPT_CD")%>">
                        </div>
                  </td>
                <%
                    }else{  // ICOMCMPY.BUDGET_FLAG = 'N' 예산 미사용 고객사
                %>
                	
                        <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_budget_dept"  value="">
                        <input type="hidden" name="st_mg_code"      value="<%=rowData.get("MG_CODE")%>">
                        <input type="hidden" name="st_mg_note"      value="<%=rowData.get("MG_NOTE")%>">
                        <input type="hidden" name="st_mng_flag"  value="<%=CommonUtil.nvl(rowData.get("MNG_FLAG"))%>">
                        <input type="hidden" name="st_mng_dept_cd"  value="">
                        <input type="hidden" name="st_account_type_name"  value="">
                        <input type="hidden" name="st_bdgt_bal_amt"  value="">                        
                <%
                    }
                %>
              <%if("Y".equals(budget_flag)){ %> 
              	<td class="center"  title="MOQ/발주배수" >
                    <%=rowData.get("MIN_ORDER_QTY")%><br><%=rowData.get("PUR_UNIT_QTY")%>
         		</td>
              <% } else { %>
                <td class="right"  title="단가/구매수량" >
                    <% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
                        <input type="text" name="st_order_price"    style="width:65%;text-align:right;"   value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');">
                    <% }else { %>
                       <span class="Price"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></span>
                        <input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
                    <% } %>
                    <input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
                     <br>
                     <%if(p060000080.equals("TYPE1") && CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")) { %>
                     	<input type="text" name="st_size_len"    id="line" style="width:30%;text-align:right;"  value="<%=rowData.get("SIZE_LEN")%>" onChange="javascript:price_size_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("SIZE_QTY")%>','<%=rowData.get("SIZE_LEN")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">/
                     	<input type="text" name="st_size_qty"    id="line" style="width:30%;text-align:right;"  value="<%=rowData.get("SIZE_QTY")%>" onChange="javascript:price_size_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("SIZE_QTY")%>','<%=rowData.get("SIZE_LEN")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                     <%}else{ %>
                     	<input type="text" name="st_order_qty"    id="line" style="width:65%;text-align:right;"  value="<%=rowData.get("CART_QTY")%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                     	<input type="hidden" name="st_size_qty" value="">
                     	<input type="hidden" name="st_size_len" value="">
                     <%} %>
         		</td>
         	<% } %>
<!-- 홍익대학교-- 대학원 소속 체크. -->

 
<%

String tmpTitle = "";
//SLOGIC-BEGIN(P06-0000027)
if("Y".equals(hongikType)){ 
	tmpTitle = "구매액/대학원 학과"; 
}
else if("TYPE1".equals(p060000027)){ // KRGEST0001 
	tmpTitle = "구매액/계정과목";   
}else if("TYPE3".equals(p060000027)){ // KRKEPB0004 
		tmpTitle = "구매액/대학원 학과";   
	}else{ 
	tmpTitle = "구매액";  
}

%>

 
 
                <%
                    if("Y".equals(hongikType)){
                %>
                        <td align="right" title="<%=tmpTitle %>" >
                           <input type="text" class="Price" name="st_sum_price"   style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  READONLY>
                            <a href="javascript:getHongIkDeptCode('<%=j%>');">
                            <input type="text" name="st_ref_pr_dept_name" id="line"  style="width:65%;cursor:pointer;text-align:right;"  value="<%=rowData.get("HI_DEPT_NAME")%>" READONLY></a>  
                        </td>
                <% 
                    }else if(p060000027.equals("TYPE3")){//----------------------지멘스 KRKEPB0004
                %>
                         <td align="right"  title="<%=tmpTitle %>" >
                            <input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
                            <a href="javascript:getHongIkDeptCode('<%=j%>');">
                            <input type="text" name="st_ref_pr_dept_name"  id="line" style="width:65%;cursor:pointer;text-align:right;"  value="<%=rowData.get("HI_DEPT_NAME")%>" READONLY></a>
                        </td>
                <%
                    }else if(p060000027.equals("TYPE1")){ //KRGEST0001
                %>
                        <td align="right"  title="<%=tmpTitle %>" >
                            <input type="text" class="Price"  name="st_sum_price"   style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
                           <a href="javascript:getKRGEST0001('<%=j%>','M015','<%=m015Text%>');">
                            <input type="text" name="st_ref_pr_text2"    id="line" style="width:85%;cursor:pointer;text-align:right;" value="<%=m015Text%>"    readonly></a>
                        </td>
                <%
                }else{
                %>
	                <%if(p060000080.equals("TYPE1") && CommonUtil.nvl(rowData.get("SIZE_YN"),"").equals("Y")) { %>
	
							<td class="right"  title="<%=tmpTitle %>" >
								<input type="text" class="Price" name="st_order_qty"  style="width:65%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=rowData.get("TOTAL_SIZE_QTY")%>"   READONLY><br>
								<input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
							</td>
	                <%}else{%>
	                		<%if("Y".equals(budget_flag)){ %>
	                		<td class="right"  title="<%=tmpTitle %>" >
	                		<% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
                        		<input type="text" name="st_order_price"    style="width:65%;text-align:right;"   value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');">
                    		<% }else { %>
                    			<input type="text" class="Price" style="width:85%;border:0;text-align:right;background-color:<%=tclass%>" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>"   READONLY>
                       			<span class="Price"></span>
                        		<input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
                    		<% } %>
                   			<input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
	                		<input type="text" name="st_order_qty"    id="line" style="width:65%;text-align:right;"  value="<%=rowData.get("CART_QTY")%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                     		<input type="hidden" name="st_size_qty" value="">
                     		<input type="hidden" name="st_size_len" value="">
	                		<input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
	                		<%//묶음배송 사용. TR일 경우 묶음배송
									if(!p060000087.equals("") && CommonUtil.nvl(rowData.get("PROCESS_TYPE"),"").equals("2")) { 
								%>
										<br><input type="checkbox"  id="st_dely_bundle_chk<%=j%>"  name="st_dely_bundle_chk<%=j%>" class="input_noline"  title=""  value=""  <%=("Y".equals(rowData.get("DELY_BUNDLE_FLAG")))?"checked":"" %>> <%=p060000087 %>
								<% } %>
	                		<%} else { %>
							<td class="right"  title="<%=tmpTitle %>" >
								<input type="text" class="Price" name="st_sum_price"  style="width:85%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"   READONLY>
								<%//묶음배송 사용. TR일 경우 묶음배송
									if(!p060000087.equals("") && CommonUtil.nvl(rowData.get("PROCESS_TYPE"),"").equals("2")) { 
								%>
										<br><input type="checkbox"  id="st_dely_bundle_chk<%=j%>"  name="st_dely_bundle_chk<%=j%>" class="input_noline"  title=""  value=""  <%=("Y".equals(rowData.get("DELY_BUNDLE_FLAG")))?"checked":"" %>> <%=p060000087 %>
								<% } %>
							</td>
							<%} %>
	                <%}%>
               <%
                    }
                %>
                <td class="center"  title="파일첨부">
                <%if(rowData.get("ITEM_NO_MNG_FLAG").equals("NMCD")){ %> <!-- 에스와이에스리테일(KRSYSR0001) 지점 명함 품목코드이면, 솔라엣지 사무용품 (KRSOLA0011) 명함 품목코드-->
               		<span class="btn_wishproduct mb02"  title="명함정보"><a href="javascript:getNameCardPop('<%=j%>', '<%=rowData.get("SEQ")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>');"><%=CommonLang.get("HTITLE760") %><!-- 명함정보 --></a></span><br>
					<span class="btn_wishproduct mb02"  title="명함시안"><a href="javascript:nameCardView('<%=j%>', '<%=rowData.get("NAMECARD_RPT")%>', '<%=rowData.get("ITEM_NO_MNG_DETL")%>');"><%=CommonLang.get("HTITLE735") %><!-- 명함시안 --></a></span><br>
				<%}%>
                <%
					if(!rowData.get("IMAGE_KEY").equals("")) {
                %>
					<span class="btn_quickbuy mb02"  title="파일추가" name="file_button"><a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>','<%=j%>');"><%=CommonLang.get("HTITLE632") %><!-- 파일추가 --></a></span>
                <%
					}else {
                %>
					<span class="btn_wishproduct mb02"  title="파일추가" name="file_button"><a href="javascript:gridPopOpen('<%=j%>');"> <%=CommonLang.get("HTITLE632") %><!-- 파일추가 --></a></span>
                <%
					}
                %>
                <%if(!pr_reason_yn.equals("")) { %>
                	<%if(rowData.get("PR_REASON").equals("")) {%>
                		<span name="Image3" class="btn_wishproduct mb02"><a href="javascript:setPrReason(<%=j%>,'<%=rowData.get("SEQ")%>','<%=rowData.get("PR_REASON")%>');"><%=CommonLang.get("HTITLE1168") %><!-- 구매사유 --></a></span>
                	<%}else{%>
                		<span name="Image3" class="btn_quickbuy mb02"><a href="javascript:setPrReason(<%=j%>,'<%=rowData.get("SEQ")%>','<%=rowData.get("PR_REASON")%>');"><%=CommonLang.get("HTITLE1168") %><!-- 구매사유 --></a></span>
                	<%}%>
                <%}%>
                
                </td>
                <%if (userRole2.equals("+")) { %>
                <td>
                	<%if(!rowData.get("ITEM_NO_MNG_FLAG").equals("NMCD")){ %> <!-- 에스와이에스리테일(KRSYSR0001) 지점 명함 품목코드이 아니면 품목비고 표기 -->
                		<%if(p060000088_co1.equals("")){%>
		                	<%if(rowData.get("REMARK").equals("")) {%>		                		                		
		                		<span name="Image2" class="btn_wishproduct mb02"><a href="javascript:setPoRemark(<%=j%>,'<%=rowData.get("SEQ")%>','<%=rowData.get("REMARK")%>');"><%=CommonLang.get("HTITLE122") %></a></span><br>
		                	<%}else{%>		                		                		
		                		<span name="Image2" class="btn_quickbuy mb02"><a href="javascript:setPoRemark(<%=j%>,'<%=rowData.get("SEQ")%>','<%=rowData.get("REMARK")%>');"><%=CommonLang.get("HTITLE122") %></a></span><br>
		                	<%}%>
						<%}else{%>
								<span name="Image2" class="btn_wishproduct mb02"  title=""><a href="javascript:setPoRemark(<%=j%>,'<%=rowData.get("SEQ")%>','<%=rowData.get("REMARK")%>');"><%=p060000088_co1%></a></span><br>
						<%}%>
	                <%}%>
                <% if(p060000081 != true && p060000084 != true){ %>
					<span class="btn_quickbuy mb02"  title="바로주문"><a href="javascript:item_qty_updateSel('<%=j%>')"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></a></span><br>
			        <% } %>
					<span class="btn_wishproduct"  title="나의상품"><a href="javascript:setMyCatalogRegSel('<%=j%>')"><%=CommonLang.get("HTITLE593") %><!-- 나의상품 --></a></span></td> 
                    <%
                    }
                %>
                </tr>
                                
  		   <%if(p060000100.equals("TYPE1")||p060000100.equals("TYPE2")){%> <!-- TYPE1 : 수령자, 전화번호, 도착지, 배송이력  / TYPE2 : 우편번호 검색 추가-->
			                <tr bgcolor="<%=tclass%>">
			                	<td><%=CommonLang.get("HTITLE943") %><!-- 수령자 --> :</td>
			                	<td colspan="9" style="text-align:left;">
			                		<%if(p060000100_col2.equals("A")){%><!-- 수령자, 전화번호, 도착지 값을때 세션정보로 자동 셋팅 :A -->
			                			<%if(CommonUtil.nvl(rowData.get("RECV_USER_NAME")).equals("")){ %>
			                				<input type="text" name="item_recv_user" id="item_recv_user" style="width:7%" value="<%=rowData.get("USR_USER_NAME_LOC")%>">
			                			<%}else{ %>
			                				<input type="text" name="item_recv_user" id="item_recv_user" style="width:7%" value="<%=rowData.get("RECV_USER_NAME")%>">
			                			<%} %>
			                			&nbsp;, <%=CommonLang.get("HTITLE326") %><!-- 전화번호 --> :
			                			<%if(CommonUtil.nvl(rowData.get("RECV_USER_TEL")).equals("")){ %>
			                				<input type="text" name="item_recv_user_phone" id="item_recv_user_phone" style="width:10%" value="<%=rowData.get("USR_PHONE_NUMBER")%>">
			                			<%}else{ %>
			                				<input type="text" name="item_recv_user_phone" id="item_recv_user_phone" style="width:10%" value="<%=rowData.get("RECV_USER_TEL")%>">
			                			<%} %>
			                			&nbsp;, <%=CommonLang.get("HTITLE485") %><!-- 도착지 --> :
			                			<%if(CommonUtil.nvl(rowData.get("DELY_TO_LOCATION_TEXT")).equals("")){ %>
					                		<input type="text" name="item_dely_to_location_text" id="item_dely_to_location_text" style="width:45%; background-color:<%=tclass%>" value="<%=rowData.get("USR_DELY_TO_LOCATION_TEXT")%>" readOnly>
					                		<input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code" value="<%=rowData.get("USR_DELY_TO_LOCATION")%>" readOnly>
			                			<%}else{ %>
					                		<input type="text" name="item_dely_to_location_text" id="item_dely_to_location_text" style="width:45%; background-color:<%=tclass%>" value="<%=rowData.get("DELY_TO_LOCATION_TEXT")%>" readOnly>
					                		<input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code" value="<%=rowData.get("DELY_TO_LOCATION")%>" readOnly>
			                			<%} %>
			                		<%}else if(p060000100_col2.equals("B")){%><!-- 수령자, 휴대폰, 도착지 값을 세션정보로 자동 셋팅 :B -->
			                			<%if(CommonUtil.nvl(rowData.get("RECV_USER_NAME")).equals("")){ %>
			                				<input type="text" name="item_recv_user" id="item_recv_user" style="width:7%" value="<%=rowData.get("USR_USER_NAME_LOC")%>">
			                			<%}else{ %>
			                				<input type="text" name="item_recv_user" id="item_recv_user" style="width:7%" value="<%=rowData.get("RECV_USER_NAME")%>">
			                			<%} %>
			                			&nbsp;, <%=CommonLang.get("HTITLE828") %><!-- 휴대폰 --> :
			                			<%if(CommonUtil.nvl(rowData.get("RECV_USER_TEL")).equals("")){ %>
			                				<input type="text" name="item_recv_user_phone" id="item_recv_user_phone" style="width:10%" value="<%=mphone%>">
			                			<%}else{ %>
			                				<input type="text" name="item_recv_user_phone" id="item_recv_user_phone" style="width:10%" value="<%=rowData.get("RECV_USER_TEL")%>">
			                			<%} %>
			                				
			                			&nbsp;, <%=CommonLang.get("HTITLE485") %><!-- 도착지 --> :
			                			<%if(CommonUtil.nvl(rowData.get("DELY_TO_LOCATION_TEXT")).equals("")){ %>
					                		<input type="text" name="item_dely_to_location_text" id="item_dely_to_location_text" style="width:45%; background-color:<%=tclass%>" value="<%=rowData.get("USR_DELY_TO_LOCATION_TEXT")%>" readOnly>
					                		<input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code" value="<%=rowData.get("USR_DELY_TO_LOCATION")%>" readOnly>
			                			<%}else{ %>
					                		<input type="text" name="item_dely_to_location_text" id="item_dely_to_location_text" style="width:45%; background-color:<%=tclass%>" value="<%=rowData.get("DELY_TO_LOCATION_TEXT")%>" readOnly>
					                		<input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code" value="<%=rowData.get("DELY_TO_LOCATION")%>" readOnly>
			                			<%} %>
			                		<%}else{%>
				                		<input type="text" name="item_recv_user" id="item_recv_user" style="width:7%" value="<%=rowData.get("RECV_USER_NAME")%>">
				                		&nbsp;, <%=CommonLang.get("HTITLE326") %><!-- 전화번호 --> :
				                		<input type="text" name="item_recv_user_phone" id="item_recv_user_phone" style="width:10%" value="<%=rowData.get("RECV_USER_TEL")%>">
				                		&nbsp;, <%=CommonLang.get("HTITLE485") %><!-- 도착지 --> :
				                		<input type="text" name="item_dely_to_location_text" id="item_dely_to_location_text" style="width:45%; background-color:<%=tclass%>" value="<%=rowData.get("DELY_TO_LOCATION_TEXT")%>" readOnly>
				                		<input type="hidden" name="item_dely_to_location_code" id="item_dely_to_location_code" value="<%=rowData.get("DELY_TO_LOCATION")%>" readOnly>
			                		<%}%>
			                		<span class="btn_wishproduct mb02"  title="도착지"><a href="javascript:getDeliveryToLocation('<%=j%>','<%=buyer%>')"><%=CommonLang.get("HTITLE485") %><!-- 도착지 --></a></span>
			                		<span class="btn_wishproduct mb02"  title="배송이력"><a href="javascript:getOrderDelyToLocation('<%=j%>','<%=buyer%>')"><%=CommonLang.get("HTITLE942") %><!-- 배송이력 --></a></span>
			                		<%if(p060000100.equals("TYPE2")){%>
			                			<span class="btn_wishproduct mb02"  title="우편번호"><a href="javascript:getnewzipCode('<%=j%>','<%=buyer%>')"><%=CommonLang.get("HTITLE343") %><!-- 우편번호 --></a></span>
			                		<%}%>
			                	</td>
			                </tr>
			<%}%>                
<%
		} 
//SLOGIC-END
	}
}
%>
        
			</tbody>
		</table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %> <!-- [ 총  --><%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!--  건 ] --></span> 
		</p>  
        <%
		request.getSession().setAttribute("session_CART_CNT", total_cnt);
		%> 
		<script>	$('#top_cart_cnt').html("<%=total_cnt%>");</script>
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl">

				
			<% 
			//SLOGIC-BEGIN(P06-0000027)
			//SLOGIC-BEGIN(P06-0000034)
			//SLOGIC-BEGIN(P06-0000035)
			if(!(p060000034 == true)){  %> 
				
				<% if (!"NONE".equals(reportText)) {  
				%>
		  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:<%=reportFunction%>"><%=reportText%></a></span>  
		  		<%} %>		   
             
            <%  }  
			if(!reportText2.equals("")){
			%>
				<span class="btn_04 mr04"  title="<%=reportText2%>"><a href="javascript:doAction('PrSheet2')"><%=reportText2%></a></span>
			<%
			}
			//SLOGIC-END
			%>
            
            
            <%  if(budget_flag.equals("Y")){    %>
            	<%
				if (_gridList == null || _gridList.size() == 0){        
				}else{
				%>
					<span class="btn_04 mr04">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
					</span>
				<%} %>
			<%} %>			 
			</div>
			<div class="fr">            
			<%
			//SLOGIC-BEGIN(P06-0000027)
			if(p060000027.equals("TYPE2")) {  // KRHONG0020%>
               <span class="btn_02 mr04" title="품목명추가" ><a href="javascript:doAction('ItemAdd');"><%=CommonLang.get("HTITLE638") %><!-- 품목명추가 --></a></span>
            <%}
             //SLOGIC-END%>
            
    <!--   <span class="btn_05 mr04" title="품목명추가" > <a href="javascript:openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO=PR14000099','800,600,no');">구매요청상세임시팝업</a></span>   -->
            
				<span class="btn_02 mr04" title="저장" ><a href="javascript:doAction('SAVE');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a></span>
				<span class="btn_05 mr04" title="나의상품등록" ><a href="javascript:doAction('setMyCatalogReg');"><%=CommonLang.get("HTITLE10") %><!-- 나의상품등록 --></a></span>
				<span class="btn_02 mr04" title="삭제" ><a href="javascript:doAction('setCartDelete');"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a></span>
				<span class="btn_03 mr04"  title="상품검색" ><a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000"><%=CommonLang.get("HTITLE169") %><!-- 상품검색 --></a></span>
				
            	
	          		 <%	//SLOGIC-BEGIN(P06-0000081)
	          		 if(p060000081 == true){  	%>
					 <span class="btn_order" title="전송" ><a href="javascript:doAction('Transfer');"><%=CommonLang.get("HTITLE235") %><!-- 전송 --></a></span>
					 <% //SLOGIC-BEGIN(P06-0000084)
	          		 }else if(p060000084 == true) {
					 %>
					 <span class="btn_order" title="CHECKOUT" ><a href="javascript:doAction('Checkout');">CHECK-OUT<!-- 체크아웃 --></a></span>
					 <!--<span class="btn_order" title="CHECKOUTTEST2" ><a href="javascript:doAction('CheckoutTest2');">CHECKOUT_POP</a></span> -->
					 <%
					 }else if(userRole2.equals("+")) {
	                    if(st_query_cart.equals("ALL")){
	                    	if(p060000117 == true){ %>
						 		<span class="btn_order"  title="바로주문" ><a href="javascript:doAction('ORDER');"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></a></span> 
					<%		}else{ %>
						   		<span class="btn_order"  title="바로주문" ><a href="javascript:doAction('CART');"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></a></span> 
					<%  	}
	                    }else{                %>
						   <span class="btn_order"  title="바로주문" ><a href="javascript:doAction('ORDER');"><%=CommonLang.get("HTITLE170") %><!-- 바로주문 --></a></span> 
					<% }
					}
					%> 
					
            </div>
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
	<input type="hidden" name="st_pre_gr_flag" id="st_pre_gr_flag" value="<%=st_pre_gr_flag%>">	 
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
<script type="text/javascript">
var popupSel = "";

//예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
var account_mg_flag = "<%=account_mg_flag%>";


var p060000029 = "<%=p060000029%>";
var p060000027 = "<%=p060000027%>";
var p060000027_msg ="<%=p060000027_msg%>";
var p060000028 = "<%=p060000028%>";
var p060000034 = "<%=p060000034%>";
var p060000033 = "<%=p060000033%>";
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
		
	case "PrSheetView":	  
		PrSheetView();
		break;		
		
	case "PrSheetViewSiem":	  
		PrSheetViewSiem();
		break;	
		
	case "getBudgetList":	  
		getBudgetList();
		break;	
		 
	case "ItemAdd":	  
		ItemAdd();
		break;	
		
	case "SAVE":	  
		item_qty_update('SAVE');
		break;	
		
	case "setMyCatalogReg":	  
		setMyCatalogReg();
		break;	
		
	case "setCartDelete":	  
		setCartDelete();
		break;	
		
	case "CART":
		item_qty_update('CART');
		break;	 
		
	case "ORDER":	  
		item_qty_update('ORDER');
		break;		
		
	case "report":	  
		alert("리포트 미존재");
		break;			
	
	case "Transfer":
		item_qty_update('TRANS');
		break;
	
	case "Checkout":
		item_qty_update('CHECKOUT');
		break;
	
	case "excelDown":
		excelDown();
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
        alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{

        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0");
            var st_item_no   = document.forms.contentForm.st_item_no.value;
            var st_contract_no = document.forms.contentForm.st_contract_no.value;
            var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
            var st_seq = document.forms.contentForm.st_seq.value;

            if(box.checked == true){
            	if(dup_add_posb_yn == "Y"){
            		query = st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
            	}else{
            		query = st_item_no + st_contract_no  + st_contract_seq + "@@";
            	}
            }
        }else{
            for(var k = 0; k < tot_cnt; k++){
                var box = eval("document.forms.contentForm.lnCheck" + k);
                var st_item_no   = document.forms.contentForm.st_item_no[k].value;
                var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
                var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
                var st_seq = document.forms.contentForm.st_seq[k].value;

                if(box.checked == true){
                	if(dup_add_posb_yn == "Y"){
                		query += st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
                	}else{
                		query += st_item_no + st_contract_no  + st_contract_seq + "@@";
                	}
                }
            }
        }
    }//end else

    reportOpen("<%=reportid2%>","["+query+"]["+buyer+"]["+user_id+"]");     

}
/*
 * 나의상품담기
 */
function setMyCatalogReg(){
	saveProcess("R");
}

// 조회
function kepSearch(curPage){

	document.forms.searchForm.curPage.value = curPage; 
	//선입고 장바구니에 따라 조회 서비스가 달라짐.
	if(document.forms.searchForm.st_pre_gr_flag.value == "Y"){
		$('#searchForm').attr("action", "/mpso/getBuyerMpSoPreGrCartList.do").submit();
	}else{
		$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartList.do").submit();	
	}
	   
}

//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}
  
  
/*
 * 나의상품등록 R 
 */
function saveProcess(flag){    
	 
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0; 
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	// 목록에 표시된 상품이 없습니다.     
        alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);
    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	var order_qty     = document.forms.contentForm.st_order_qty.value; 
		        var st_item_no   = document.forms.contentForm.st_item_no.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
				var st_urct2_yn  = document.forms.contentForm.st_urct2_yn.value;
 
				//URCT2 여부 확인
				if(st_urct2_yn != "Y"){ 
					alert("<%=CommonLang.msg("MSG588")%>"); //주문할 수 없는 카테고리의 상품입니다.
					return;
				}
                if(!kepChkDecimal(order_qty,3)){
                	// 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    
                    alert( "<%=CommonLang.msg("MSG18")%>");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                } else{
					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
				}
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var order_qty     = document.forms.contentForm.st_order_qty[i].value; 
				var st_item_no   = document.forms.contentForm.st_item_no[i].value;
				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
				var st_urct2_yn  = document.forms.contentForm.st_urct2_yn[i].value;

                if(box.checked == true){
                    
                	//URCT2 여부 확인
                	if(st_urct2_yn != "Y"){ 
    					alert( (i+1)+"<%=CommonLang.msg("MSG587")%>"); // 번째 상품은 주문할 수 없는 카테고리의 상품입니다.
    					return;
    				}
                	
                    if(!kepChkDecimal(order_qty,3)){
                    	// 번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    
                        alert( (i+1)+"<%=CommonLang.msg("MSG20")%>");
                        document.forms.contentForm.st_order_qty[i].focus();
                        return;
                    }
                    else {
					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
					  query += "&&";
					}
                }
            }
        }
    }	 
     
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm(); 
}
 


function kep_showConfirm(){   
	//선택하신 상품을 나의 상품으로 등록하시겠습니까?
    if(!confirm("<%=CommonLang.msg("MSG365")%>")){
        return;
    }    
    runProcess();
}
 

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 장바구니 담기
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val(); 

	if (gubun == "CsaveProcess"){ // 장바구니 		
	}else if (gubun == "RsaveProcess"){ // 나의상품 		
	}  		 	
	document.forms.processForm.st_use_flag.value = "R"; 
	document.forms.processForm.st_query2.value = query;
	document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
	///kr/customer/categ_search/buyer_shoppingcart_new_reg.jsp
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
}
  
 
/**
 * 바로주문
 * 저장
 */
function item_qty_update(next_status){  // CART : 배송지 입력화면 이동,   ORDER : 주문최종 확인 화면 이동	

    var tot_cnt         = $("#display_item_cnt").val();
    var chk_cnt         = 0;
    var query           = ""; 
    var buyer           =  $("#st_buyer").val();   
    var ck_ref_pr_dept  = "";	
	var p060000125 = "<%=p060000125%>";
	var p060000125_list = p060000125.split("@@");
    var budget_flag = "<%=budget_flag%>";
    var hongik_flag = "<%=hongikType%>";
    
    var p060000127 = "<%=p060000127%>";
	var p060000127_list = p060000127.split("@@");
	var p060000128 = "<%=p060000128%>";
	var p060000128_list = p060000128.split("@@");
	
    //묶음배송일경우 여부 체크
    var p060000087 = "<%=p060000087%>";
    
    var Ccnt = 0; // 엘앤에프(KRLAND0003) 전용
    var nonCcnt = 0; // 엘앤에프(KRLAND0003) 전용

    // MSDS 품목 확인
    var p060000137  = "<%=p060000137%>";
    
    // 주문시 동일 계쩡 - 예산- 부서코드만 선택하도록 제한
    var p060000138 = "<%=p060000138%>";
    var ck_budget_dept = "";
    var ck_account_type = "";
    var ck_ref_pr_no = "";
    
    if(eval(tot_cnt) == 0)
    {
        alert("<%=CommonLang.msg("MSG69")%>");	//조회한 데이타가 없습니다.
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);

    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }

    // 조회 총 건수(1) 체크 시작
    if(eval(tot_cnt) < 2){
    	
    	var box = eval("document.forms.contentForm.lnCheck0" ); 
        var st_item_no              = document.forms.contentForm.st_item_no.value;
        var st_order_qty            = kepTrimStr(document.forms.contentForm.st_order_qty.value);
        var st_ref_pr_no            = document.forms.contentForm.st_ref_pr_no.value;
        
        var st_contract_no          = document.forms.contentForm.st_contract_no.value;
        var st_contract_seq         = document.forms.contentForm.st_contract_seq.value;
        var st_fixed_price_flag     = document.forms.contentForm.st_fixed_price_flag.value;
        var st_order_price          = document.forms.contentForm.st_order_price.value;
        var st_account_type         = document.forms.contentForm.st_account_type.value;
        var st_budget_dept          = document.forms.contentForm.st_budget_dept.value;
        var product_close_flag      = document.forms.contentForm.st_product_close_flag.value;
        var process_type            = document.forms.contentForm.st_process_type.value;
        var stock_item_flag         = document.forms.contentForm.st_stock_item_flag.value;
        var ref_pr_dept             = document.forms.contentForm.st_ref_pr_dept.value;
        var remark                  = document.forms.contentForm.st_remark.value;
        var mg_code                 = document.forms.contentForm.st_mg_code.value;
        var mg_note                 = document.forms.contentForm.st_mg_note.value;
        var item_status_flag        = document.forms.contentForm.st_item_status_flag.value;
        var st_cart_seq      		= document.forms.contentForm.st_seq.value;
        var st_size_qty				= document.forms.contentForm.st_size_qty.value;
        var st_size_len				= document.forms.contentForm.st_size_len.value;
        var st_mng_flag				= document.forms.contentForm.st_mng_flag.value;
        var item_mng_flag			= document.forms.contentForm.st_item_mng_flag.value;
        var st_min_order_qty		= document.forms.contentForm.st_min_order_qty.value;
        var st_pur_unit_qty			= document.forms.contentForm.st_pur_unit_qty.value; //주문배수
        var st_dely_bundle_flag		= "N";//묵음배송 여부
        var st_over_short_flag      = document.forms.contentForm.st_over_short_flag.value; //품절여부
		var st_stock_cnt			= document.forms.contentForm.st_stock_cnt.value; //재고수량
        var bundle_chk				= eval("document.forms.contentForm.st_dely_bundle_chk0" );
        var st_atch_flag 			= document.forms.contentForm.st_atch_flag.value;
        var st_image_key			= document.forms.contentForm.st_image_key.value;
        var st_buyer_category_no	= document.forms.contentForm.st_buyer_category_no.value;
        var st_urct2_yn				= document.forms.contentForm.st_urct2_yn.value;
        var st_budget_bal_amt		= document.forms.contentForm.st_bdgt_bal_amt.value;
        var st_msds_yn				= document.forms.contentForm.st_msds_yn.value;
        var st_pr_reason            = document.forms.contentForm.st_pr_reason.value;
        
        if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
        	var item_dely_to_location_text = document.forms.contentForm.item_dely_to_location_text.value;
        	var item_dely_to_location_code = document.forms.contentForm.item_dely_to_location_code.value;
        	var item_recv_user = document.forms.contentForm.item_recv_user.value;
        	var item_recv_user_phone = document.forms.contentForm.item_recv_user_phone.value;
        }
        
        if(box.checked == true){
        	// 특정 카테고리 주문 통제 특수로직
            for(var i = 0; i < p060000125_list.length; i++) {
            	if(st_buyer_category_no == p060000125_list[i]) {
            		// 품목코드 + 설정된 메세지 출력
            		alert(st_item_no+ " <%=p060000125_msg%>");
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
	                	alert("("+ st_item_no + ") " + "<%=p060000128_msg%>");
	            		return;
		            }
        		}
        	}
        	//URCT2 여부 확인
        	if(st_urct2_yn != "Y"){
        		alert(st_item_no + " <%=CommonLang.msg("MSG588")%>"); //주문할 수 없는 카테고리의 상품입니다.
	        	return;
        	}
        	
        	// 첨부 필수 확인
        	if(st_atch_flag == "Y" && isEmpty(st_image_key)){
        		alert(st_item_no + " 품목은 첨부파일이 필수입니다.");
	        	return;
	        }
        
            //묶음배송여부flag 
            if(p060000087 !="" && process_type=="2"){
                if(bundle_chk.checked== true){
        	    	//묶음배송은 두개 이상 품목 선택해야 가능 합니다.
                	alert("<%=CommonLang.msg("MSG438")%>");
                	return;
                }            	
            }

            // msds 품목인 경우 통제
            if(p060000137 == "TYPE1" || p060000137 == "TYPE2"){ // 개인정보에 사번 있는지 확인
            	if(st_msds_yn == "Y" && kepIsValueNull("<%=empno%>") ){
            		alert("주문하시는 품목 중  MSDS 관리품목이 있습니다.\n 개인정보에서 사번값을 입력하신 후 재접속 하여 재주문하시기 바랍니다.");
            		return;
            	}
            }
            
            if(p060000137 == "TYPE2"){ // 도착지 코드가 S로 시작하는지 확인, P06-0000100 적용 필수 (품목별 도착지)
            	if(st_msds_yn =="Y" && item_dely_to_location_code.indexOf('S') != 0){
            		alert("주문하시는 품목 중  MSDS 관리품목이 있습니다.\n MSDS 품목 수령 지정 도착지로 재선택하시어 진행바랍니다.\n(MSDS 도착지는 AP 관리대상이며 S로 시작하는 코드입니다.)");
            		return;
            	}
            }
            
        	if(product_close_flag == "Y"){
            	//해당 품목은 단종되었습니다.
                alert("<%=CommonLang.msg("MSG117")%>");
                propCheckBox(box, false);
                return;
            }
        	if(st_over_short_flag == "Y"){
            	//해당 품목은 품절되었습니다.
                alert("<%=CommonLang.msg("MSG549")%>");
                propCheckBox(box, false);
                return;
            }
            if(item_status_flag == "삭제"){
            	//해당 품목은 삭제되었습니다.
                alert("<%=CommonLang.msg("MSG118")%>");
                propCheckBox(box, false);
                return;
            }
            if(process_type=="1" && stock_item_flag=="N"){
            	//재고 수량이 부족합니다. 재고 수량 확인 바랍니다.
                alert("<%=CommonLang.msg("MSG551")%>");
                propCheckBox(box, false);
                return;
            }
            
            if(st_order_price == 0){
            	//발주단가를 KeP 담당자에게 확인하여 주시기 바랍니다.
            	alert("<%=CommonLang.msg("MSG589")%>");
            	return;
            }
            
            if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || kepIsValueNull(st_order_qty) || !kepChkDecimal(st_order_qty,3)){
                //품목의 발주수량(숫자)을 입력하여 주십시요.
            	alert("<%=CommonLang.msg("MSG120")%>");
                document.forms.contentForm.st_order_qty.focus();
                return;
            }
            //재고관리 품목일 경우
            if(st_stock_cnt != ""){
            	if(Number(st_order_qty) > Number(st_stock_cnt)){
            		//재고 수량이 부족합니다. 재고 수량 확인 바랍니다.
                	alert("<%=CommonLang.msg("MSG551")%>");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
            	}
            }
            //MOQ 주문 통제 특수로직 적용한 고객사 한정
            if(p060000077 == "true"){
    			if(Number(st_order_qty) < Number(st_min_order_qty)){
                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
                	alert("<%=CommonLang.msg("MSG437")%>");
                    document.forms.contentForm.st_order_qty.focus();
                    return;				
    			}            	
            }
            //주문배수 주문 통제 특수로직 적용한 고객사 한정
            if(p060000089 == "true"){
            	var checkNum = st_order_qty%st_pur_unit_qty;
    			if(checkNum != 0 ){
                    //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
                	alert("1"+"<%=CommonLang.msg("MSG533")%>");
                    document.forms.contentForm.st_order_qty.focus();
                    return;				
    			}            	
            }
            
            // || buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" 제거            
            if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRKDBO0003"
                || buyer == "KRKDPR0003" || buyer == "KRDOOS0013"|| buyer == "KRKOLO0018"|| buyer == "KRCONT0006" || buyer=="KRCONT0009"
                || buyer == "KRJINR0005" || buyer == "KRCONT0007")
            {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//관리번호(계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 계정을 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG121")%>");
                    return;
                }
            }else if(p060000027=="TYPE2") { // KRHONG0020
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG122")%>");
                    return;
                }
                if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
                	//대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG123")%>");
                    return;
                }

            }else if(p060000027=="TYPE4") { // KRHYOS0055, KRHYOS0062, KRHYOS0063, KRHYOS0064, KRHYOS0065, KRHYOS0076
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	if(next_status != "PrSheet"){
                		//관리번호가 입력되지 않았습니다.\n관리번호 란에 Cost center를 입력하여 주십시오.
                    	alert("<%=CommonLang.msg("MSG124")%>");
                        return;                		
                	}
                }
            
            }else if(p060000027=="TYPE10") { // KRSIEM0010
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
					if(next_status != "PrSheet"){
                		//관리번호가 입력되지 않았습니다. 관리번호 란에 PO번호(10자리)를 입력하여 주십시오.
                		alert("<%=CommonLang.msg("MSG407")%>");
                    	return;
                    }
                }

                if(!kepIsNumberStr(st_ref_pr_no) || st_ref_pr_no.length != 10){
                	if(next_status != "PrSheet"){
	                	// 관리번호란에 숫자 10자리를 입력하여 주시기 바랍니다.
    	            	alert("<%=CommonLang.msg("MSG408")%>");
        	        	return;
                	}
                }
            }else if(p060000027=="TYPE6") { 
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//관리번호 기입은 필수입니다.\n\n관리번호는 비용구분으로, 실 사용되는 사업부로 선택부탁드립니다.(N/A = 공통배부)
                	alert("<%=CommonLang.msg("MSG125")%>");
                    return;
                }
            }else if(p060000029=="TYPE15") { 
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000027=="TYPE1"  && (next_status == "CART" || next_status == "ORDER")) {
                var ref_pr_text             = document.forms.contentForm.st_ref_pr_text.value;
                var ref_pr_text2            = document.forms.contentForm.st_ref_pr_text2.value;
                if(ref_pr_text == "" || ref_pr_text == "null" || ref_pr_text == null || ref_pr_text == " "){
                	//관리번호가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
                if(ref_pr_text2 == "" || ref_pr_text2 == "null" || ref_pr_text2 == null || ref_pr_text2 == " "){
                	//계정항목이 선택되지 않았습니다.\n\n계정항목란을 클릭하여 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG127")%>");
                    return;
                }
            }else if(buyer=="KRSIEM0004" && (next_status == "CART" || next_status == "ORDER")) {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//관리번호가 입력되지 않았습니다.\n"+"관리번호를 입력하여 주십시요.
                    alert("<%=CommonLang.msg("MSG128")%>");
                    return;
                }
            }else if(buyer=="KRHYOS0026" && (next_status == "CART" || next_status == "ORDER")) {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//구체적인 사용용도와 실 사용자를 관리번호란에 입력 하셔야 합니다.
                    alert("<%=CommonLang.msg("MSG129")%>");
                    return;
                }
            }else if(p060000027=="TYPE7"){
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//자재그룹이 선택되지 않았습니다.\n자재그룹란을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG130")%>");
                    return;
                }
            }else if(p060000027=="TYPE8"){ // 롯데푸드
            	remark = document.forms.contentForm.st_remark.value; // 롯데푸드는 비고 사용
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//귀속부서/관장부서/계정코드/세금코드가 선택되지 않았습니다.\n귀속부서/관장부서/계정코드/세금코드 란을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG131")%>");
                    return;
                }
            }else if(p060000027=="TYPE11"){
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//품의서일때 메세지 제외처리
            		if(next_status != "PrSheet"){
                		//타입 메세지 가져오기
                    	alert(p060000027_msg);
                        return;            			
            		}
                }
            }else if(p060000029 == "TYPE11" && (buyer == "KRILJI0066" || buyer == "KRILJI0067")) { 
                if(mg_note == "" || mg_note == "null" || mg_note == null || mg_note == " "){
                	//관리항목이 선택되지 않았습니다.\n관리항목란을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG132")%>");
                    return;
                }
            }else if(p060000029 == "TYPE18") { //셀트리온 관리번호 필수 체크
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//관리항목이 선택되지 않았습니다.\n관리항목란을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG132")%>");
                    return;
                }
            }else if(p060000029 == "TYPE17") { // 영풍
            	var st_yp_cost_center		= document.forms.contentForm.st_yp_cost_center.value;
            	var st_yp_cost_center_text	= document.forms.contentForm.st_yp_cost_center_text.value;
                var st_yp_wbs				= document.forms.contentForm.st_yp_wbs.value;
                var st_yp_wbs_text			= document.forms.contentForm.st_yp_wbs_text.value;
                
                if(st_yp_cost_center == "" || st_yp_cost_center == "null" || st_yp_cost_center == null || st_yp_cost_center == " "){
                	//코스트센터가 선택되지 않았습니다.\n관리번호 상단을 클릭하여 선택하여 주십시요.
                	alert("<%=CommonLang.msg("MSG133")%>");
                    return;
                }
                mg_note = st_yp_cost_center + "^" + st_yp_cost_center_text + "^" + st_yp_wbs + "^" + st_yp_wbs_text;
                document.forms.contentForm.st_mg_note.value = st_yp_cost_center + "^" + st_yp_cost_center_text + "^" + st_yp_wbs + "^" + st_yp_wbs_text;
            }else if(p060000029 == "TYPE20") { //에스와이에스리테일 관리번호 필수 체크
            	if(st_mng_flag == "Y"){ // 판촉물 계정 선택 시
            		if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//상세계정 입력 바랍니다.
                    	alert("<%=CommonLang.msg("MSG428")%>");
                        return;
                    }	
            	}
            	
            	if(item_mng_flag == "NMCD"){ // 명함 품목 시
            		remark = document.forms.contentForm.st_remark.value; // 명함정보 저장용 비고 사용
            		
            		if(remark == "" || remark == "null" || remark == null || remark == " "){
            			alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
            			return;
            		}
            	}
            }else if(p060000029 == "TYPE21") { //테크팩솔루션 관리번호 필수 체크
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//관리번호(계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 계정을 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG121")%>");
                    return;
                }
            }else if(p060000029 == "TYPE22") { //동화그룹 관리번호 필수 체크
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            	if(st_item_no.substr(0,1) == "4"){ //4로 시작하는 품목코드 gl_account 존재 확인
            		var tmpArrp = st_ref_pr_no.split("%%");
            		var gl_account_val = tmpArrp[8];
            		if(gl_account_val == "" || gl_account_val == "null" || gl_account_val == null || gl_account_val == " "){
            			alert("<%=CommonLang.msg("MSG542")%>");
                        return;
            		}
            	}
            }else if(p060000029 == "TYPE24" ) { //KG그룹 관리번호 필수 체크
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE25") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE100") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE27") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE28") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE29") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE30") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("<%=CommonLang.msg("MSG126")%>");
                    return;
                }
            }else if(p060000029 == "TYPE31") {
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		//관리번호(WBS코드)가 선택되지 않았습니다. 관리번호란을 클릭하여 WBS코드를 선택하여 주십시요.
                    alert("<%=CommonLang.msg("MSG559")%>");
                    return;
                }
            }else if(p060000029 == "TYPE32") { // 와이지
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                	//그룹웨어 품의 번호 관리번호 기재 바랍니다.
                	alert("<%=CommonLang.msg("MSG562")%>");
                    return;
                }
            }else if(p060000029 == "TYPE33") { // 솔브레인
            	var ref_pr_no_temp = st_ref_pr_no.split('^');
            	if(<%=SolbPlantYn%>) {            		
            		if(ref_pr_no_temp[0] == "" || ref_pr_no_temp[0] == null) {
            			alert("<%=CommonLang.msg("MSG564")%>");
            			return;
            		}            		
            	}
                if(<%=SolbCostCenterYn%>) {
                	if(ref_pr_no_temp[1] == "" || ref_pr_no_temp[1] == null) {
            			alert("<%=CommonLang.msg("MSG564")%>");
            			return;
            		} 
                }
                if(ref_pr_no_temp[2] == "" || ref_pr_no_temp[2] == null) {
                	alert("<%=CommonLang.msg("MSG564")%>");
        			return;
                }
            }else if(p060000029 == "TYPE34") { // 한샘
            	if(st_buyer_category_no.indexOf("<%=p060000129_col01%>") != -1){ // 카테고리가 전산몰인경우 검증 로직 추가
            		var ref_pr_no_temp = st_ref_pr_no.split('^');
                    if(isEmpty(ref_pr_no_temp[0]) || isEmpty(ref_pr_no_temp[1]) || isEmpty(ref_pr_no_temp[2]) 
                    		|| isEmpty(ref_pr_no_temp[3]) || isEmpty(ref_pr_no_temp[4])) {
                    	alert("<%=CommonLang.msg("MSG151")%>");
            			return;
                    }
                    if(isEmpty(st_image_key)){ // 품의서 첨부 확인 처리
                    	alert("<%=CommonLang.msg("MSG150")%>"); // 번째 첨부파일이 빠져있습니다.
                    	return;
                    }
                    
                    if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                    	alert("<%=CommonLang.msg("MSG149")%>"); // 카테고리에 맞는 예산 계정을 선택해주세요.
                    	return;
                    }
            	}
            	if(st_buyer_category_no.substr(0, 3) == "<%=p060000129_col02%>"){ // 카테고리가 총무카테고리인 경우 검증 로직 추가
            		// 예산이 총무가 아닌경우
                    if(st_account_type.indexOf('-') == -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                    	alert("<%=CommonLang.msg("MSG149")%>"); // 카테고리에 맞는 예산 계정을 선택해주세요.
                    	return;
                    }
               	}else{ // 카테고리가 총무가 아닌경우 총무 예산 사용 금지
	               	// 예산이 총무인 아닌경우
               		if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                    	alert("<%=CommonLang.msg("MSG149")%>"); // 카테고리에 맞는 예산 계정을 선택해주세요.
                    	return;
                    }
               	}
            	if(item_mng_flag == "NMCD"){ // 명함 품목 시
            		remark = document.forms.contentForm.st_remark.value; // 명함정보 저장용 비고 사용
            		if(remark == "" || remark == "null" || remark == null || remark == " "){
            			alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
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
                			alert("<%=CommonLang.msg("MSG591")%>"); // 고정자산번호가 선택되지 않았습니다. 고정자산번호란을 클릭하여 입력하여 주십시오.
    	                    return;
    	                }
                	}
                }         	
            	
            }
            else if(p060000029 == "TYPE36") { // 아모레퍼시픽 연구소
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		// G/L번호를 선택하여 주십시오.
            		alert("<%=CommonLang.msg("MSG597")%>");
                    return;
                }            	   	
            	
            }
            else if(p060000029 == "TYPE37") { // 중외제약
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		// 예산계정코드를 선택하여 주십시오.
            		alert("<%=CommonLang.msg("MSG598")%>");
                    return;
                }            	   	
            	
            }
            else if(p060000029 == "TYPE39") { // LB세미콘주식회사
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		// 계정/코스트센터를 선택하여 입력하세요.
	            	alert("<%=CommonLang.msg("MSG613")%>");
                    return;
                }
            }
            else if(p060000029 == "TYPE40") { // 한솔홈데코
            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
            		// 계정/코스트센터를 선택하여 입력하세요.
	            	alert("<%=CommonLang.msg("MSG613")%>");
                    return;
                }
            }
            else {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
                    st_ref_pr_no = " ";
                }
            }

            if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                	//예산 적용 부서 및 계정을 선택해 주십시요
                    alert("<%=CommonLang.msg("MSG135")%>");
                    return;
                }
                
                if(st_budget_bal_amt < 0){
                	// 예산이 초과되어 예산계정을 다시 선택해주세요
                	alert("<%=CommonLang.msg("MSG594")%>");
                	return;
                }
            }

            //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
            if(account_mg_flag == "Y"){
                if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept) || isEmpty(mg_code)){
                    	//예산 적용 부서 및 계정, 관리항목을 선택해 주십시요
                        alert("<%=CommonLang.msg("MSG136")%>");
                        return;
                    }
                }
            }
            
            // 품목별 도착지 지정 고객사
			if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
				// 도착지 필수 체크
				if(item_dely_to_location_text == "" || item_dely_to_location_text == "null" || item_dely_to_location_text == null || item_dely_to_location_text == " "){
					// 도착지가 입력되지 않았습니다.
					alert("<%=CommonLang.msg("MSG327")%>");
					return;
				}
				// 수령자 필수 체크
				if(item_recv_user == "" || item_recv_user == "null" || item_recv_user == null || item_recv_user == " "){
					// 수령자가 입력되지 않았습니다.
					alert("<%=CommonLang.msg("MSG544")%>");
					return;
				}
				// 전화번호 필수 체크
				if(item_recv_user_phone == "" || item_recv_user_phone == "null" || item_recv_user_phone == null || item_recv_user_phone == " "){
					// 전화번호가 입력되지 않았습니다.
					alert("<%=CommonLang.msg("MSG324")%>");
					return;
				}
			}
            
            // 품목별 구매사유 입력 필수 고객사
		<%if(pr_reason_yn.equals("Y")) { %>
            if(st_pr_reason == ""){
            	// 구매사유를 입력해주세요.
            	alert("<%=CommonLang.msg("MSG767")%>");
            	return;
            }
		<%}%>

           	if(next_status == "TRANS"||next_status == "CHECKOUT"){
                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
           		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" +st_cart_seq;
           		query += "|";			
			}else if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){ // 품목별 도착지 지정
                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
           		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" +st_cart_seq + "@@" + st_dely_bundle_flag + "@@"
           		+ item_dely_to_location_code + "@@" + item_dely_to_location_text + "@@" + item_recv_user + "@@" + item_recv_user_phone;
           		query += "|";    					
			}else{
                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
           		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" +st_cart_seq + "@@" + st_dely_bundle_flag;
           		query += "|";		
			}
            
         }
	// 조회 총 건수(1) 체크 끝
	// 조회 총 건수(2 이상) 체크 시작
    }else{
        var cNum = 0;
        var old_st_agent_code="";
        var diff_agent_status="false";
        

        for(var j = 0; j  <tot_cnt; j++){
 
        	var box = eval("document.forms.contentForm.lnCheck" +j); 
            var st_item_no          = document.forms.contentForm.st_item_no[j].value;
            var st_order_qty        = kepTrimStr(document.forms.contentForm.st_order_qty[j].value);
            var st_ref_pr_no        = document.forms.contentForm.st_ref_pr_no[j].value;            
            var st_contract_no      = document.forms.contentForm.st_contract_no[j].value;
            var st_contract_seq     = document.forms.contentForm.st_contract_seq[j].value;
            var st_fixed_price_flag = document.forms.contentForm.st_fixed_price_flag[j].value;
            var st_order_price      = document.forms.contentForm.st_order_price[j].value;
            var st_account_type     = document.forms.contentForm.st_account_type[j].value;
            var st_budget_dept      = document.forms.contentForm.st_budget_dept[j].value;
            var product_close_flag  = document.forms.contentForm.st_product_close_flag[j].value;
            var process_type        = document.forms.contentForm.st_process_type[j].value;
            var stock_item_flag     = document.forms.contentForm.st_stock_item_flag[j].value;
            var ref_pr_dept         = document.forms.contentForm.st_ref_pr_dept[j].value;
            var remark              = document.forms.contentForm.st_remark[j].value; 
            var st_agent_code       = document.forms.contentForm.st_agent_code[j].value;
            var mg_code             = document.forms.contentForm.st_mg_code[j].value;
            var mg_note             = document.forms.contentForm.st_mg_note[j].value;
            var item_status_flag    = document.forms.contentForm.st_item_status_flag[j].value;
            var st_cart_seq			= document.forms.contentForm.st_seq[j].value;
            var st_size_qty      	= document.forms.contentForm.st_size_qty[j].value;
            var st_size_len      	= document.forms.contentForm.st_size_len[j].value;
            var st_mng_flag			= document.forms.contentForm.st_mng_flag[j].value;
            var item_mng_flag		= document.forms.contentForm.st_item_mng_flag[j].value;
            var st_min_order_qty	= document.forms.contentForm.st_min_order_qty[j].value;
            var st_dely_bundle_flag	= "N";//묶음배송 여부
            var st_pur_unit_qty		= document.forms.contentForm.st_pur_unit_qty[j].value; //주문배수
            var st_mng_dept_cd 		= document.forms.contentForm.st_mng_dept_cd[j].value; //관리부서
            var st_account_type_name= document.forms.contentForm.st_account_type_name[j].value; //계정정보
            var st_over_short_flag  = document.forms.contentForm.st_over_short_flag[j].value; //품절여부
            var st_stock_cnt      	= document.forms.contentForm.st_stock_cnt[j].value; //재고수량
            var bundle_chk 			= eval("document.forms.contentForm.st_dely_bundle_chk"+j );
            var st_atch_flag 		= document.forms.contentForm.st_atch_flag[j].value;
            var st_image_key		= document.forms.contentForm.st_image_key[j].value;
            var st_buyer_category_no			= document.forms.contentForm.st_buyer_category_no[j].value;
            var st_urct2_yn			= document.forms.contentForm.st_urct2_yn[j].value;
            var st_budget_bal_amt	= document.forms.contentForm.st_bdgt_bal_amt[j].value;
            var st_msds_yn			= document.forms.contentForm.st_msds_yn[j].value;
            var st_pr_reason        = document.forms.contentForm.st_pr_reason[j].value;
            
            if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
            	var item_dely_to_location_text = document.forms.contentForm.item_dely_to_location_text[j].value;
            	var item_dely_to_location_code = document.forms.contentForm.item_dely_to_location_code[j].value;
            	var item_recv_user = document.forms.contentForm.item_recv_user[j].value;
            	var item_recv_user_phone = document.forms.contentForm.item_recv_user_phone[j].value;
            }
            
            if(box.checked == true){
            	// 특정 카테고리 주문 통제 특수로직
                for(var i = 0; i < p060000125_list.length; i++) {
                	if(st_buyer_category_no == p060000125_list[i]) {
                		// 품목코드 + 설정된 메세지 출력
                		alert(st_item_no+ " <%=p060000125_msg%>");
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
	                    	alert("("+ st_item_no + ") " + "<%=p060000128_msg%>");
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
            		alert(st_item_no + " <%=CommonLang.msg("MSG588")%>"); //주문할 수 없는 카테고리의 상품입니다.
    	        	return;
            	}
            	
            	// 첨부 필수 확인
        		if(st_atch_flag == "Y" && isEmpty(st_image_key)){
        			alert(st_item_no + " 품목은 첨부파일이 필수입니다.");
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
                
                //묶음배송여부flag 
                if(p060000087 !="" && process_type=="2"){
                    if(bundle_chk.checked== true){
                    	var bd_cnt = 0;
                	    for(var k = 0; k < tot_cnt; k++){
	               	         var bundle_chk2 = eval("document.forms.contentForm.st_dely_bundle_chk" + k);
	               	         if(bundle_chk2.checked == true){
	               	        	bd_cnt++;
	               	         }
               	    	}
                	    if(bd_cnt < 2){
                	    	//묶음배송은 두개 이상 품목 선택해야 가능 합니다.
                        	alert("<%=CommonLang.msg("MSG438")%>");
                        	return;
                	    }else{
                	    	st_dely_bundle_flag = "Y"	
                	    }
                    	
                    }             	
                }
                
                // msds 품목인 경우 통제
                if(p060000137 == "TYPE1" || p060000137 == "TYPE2"){ // 개인정보에 사번 있는지 확인
                	var empno = "<%=empno%>";
                	if(st_msds_yn == "Y" && kepIsValueNull(empno.trim())){
                		alert("주문하시는 품목 중  MSDS 관리품목이 있습니다.\n개인정보에서 사번 값을 입력하신 후 재접속하여 재주문하시기 바랍니다.");
                		return;
                	}
                }
                
                if(p060000137 == "TYPE2"){ // 도착지 코드가 S로 시작하는지 확인, P06-0000100 적용 필수 (품목별 도착지)
                	if(st_msds_yn =="Y" && item_dely_to_location_code.indexOf("S") != 0){
                		alert("주문하시는 품목 중  MSDS 관리품목이 있습니다.\nMSDS 품목 수령 지정 도착지로 재선택하시어 진행바랍니다.\n(MSDS 도착지는 AP 관리대상이며 S로 시작하는 코드입니다.)");
                		return;
                	}
                }
                
                // 주문 시 계정코드 - 예산부서 - 코스트센터 - 자금관리센터 - G/L번호 일치하는지 확인
                if(!isEmpty(p060000138)){
                	if(next_status == "CART" || next_status == "ORDER"){
                		if(ck_budget_dept != st_budget_dept || ck_account_type != st_account_type){
                			alert("SAP 마감/정산 시 하나의 주문번호에 선택 항목의 코스트센터, 예산계정 등의 정보가 모두 일치해야 합니다.\n선택한 항목들 간의 정보가 다르므로, 동일한 정보만 선택해주세요.");
                			return;
                		}
                		if(p060000138 == "TYPE2"){
                			if(ck_ref_pr_no != st_ref_pr_no){
                				alert("SAP 마감/정산 시 하나의 주문번호에 선택 항목의 코스트센터, 예산계정 등의 정보가 모두 일치해야 합니다.\n선택한 항목들 간의 정보가 다르므로, 동일한 정보만 선택해주세요.");
                    			return;
                			}
                		}
                	}
                }
                
                if(old_st_agent_code != '' && old_st_agent_code != st_agent_code){
                    diff_agent_status = "true";
                }

                if(p060000033 == "true"){
                    if(next_status == 'CART' || next_status == 'ORDER'){
                        if(diff_agent_status == 'true'){
                        	//☞코오롱생명과학(주) 요청으로, \n 공급업체가 여러개일 경우 \n 발주 진행을 할 수 없습니다.
                            alert("<%=CommonLang.msg("MSG137")%>");
                            return;
                        }
                    }
                }
                //관리부서가 다를 경우 주문 불가능.
                if(p060000090 == "true"){
                	//관리부서 공백 체크.
                    if(isEmpty(st_mng_dept_cd)){
                    	//관리부서 정보가 없어 주문이 불가능 합니다.
                    	alert("<%=CommonLang.msg("MSG536")%>");
                        return;
                    }
                	for(var k = 0; k < tot_cnt; k++){
                		var checkbox = eval("document.forms.contentForm.lnCheck" +k);
                		if(checkbox.checked == true){
                			if(st_mng_dept_cd != document.forms.contentForm.st_mng_dept_cd[k].value){
                            	//의 계정코드는 개별 신청하시기 바랍니다.
                            	alert(st_account_type_name+"<%=CommonLang.msg("MSG537")%>");
                                return;                				
                			}	
                		}
                	}
                }
                old_st_agent_code=st_agent_code;

                if(product_close_flag == "Y"){
                	//번째 품목은 단종되었습니다.
                   alert( (j+1)+"<%=CommonLang.msg("MSG138")%>");
                   propCheckBox(box, false);
                   return;
                }
                if(item_status_flag == "삭제"){
                	//번째 품목은 삭제되었습니다.
                    alert( (j+1)+"<%=CommonLang.msg("MSG139")%>");
                    propCheckBox(box, false);
                    return;
                 }
            	if(st_over_short_flag == "Y"){
                	//번째 품목은 품절되었습니다.
                    alert( (j+1)+"<%=CommonLang.msg("MSG550")%>");
                    propCheckBox(box, false);
                    return;
                }
                if(process_type=="1" && stock_item_flag=="N"){
                	//해당 품목은 재고품목 입니다.\n\n품목상태가 올바르지 않습니다.\n\n담당자에게 확인 바랍니다.
                alert("<%=CommonLang.msg("MSG119")%>");
                    propCheckBox(box, false);
                    return;
                }

                if(st_order_price == 0){
                	//번째 행의 발주단가를 KeP 담당자에게 확인하여 주시기 바랍니다.
                	alert( (j+1)+"<%=CommonLang.msg("MSG590")%>");
                	return;
                }
                
                if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || kepIsValueNull(st_order_qty) || !kepChkDecimal(st_order_qty,3)){
                	//번째 품목의 발주수량(숫자)을 입력하여 주십시요.
                    alert(  (j+1)+"<%=CommonLang.msg("MSG140")%>");
                    document.forms.contentForm.st_order_qty[j].focus();
                    return;
                }
                //재고관리 품목일 경우
                if(st_stock_cnt != ""){
                	if(Number(st_order_qty) > Number(st_stock_cnt)){
                		//번째 재고 수량이 부족합니다. 재고 수량 확인 바랍니다.
                    	alert((j+1)+"<%=CommonLang.msg("MSG552")%>");
                        document.forms.contentForm.st_order_qty[j].focus();
                        return;
                        
                	}
                }
                //MOQ 주문 통제 특수로직 적용한 고객사 한정
                if(p060000077 == "true"){
	    			if(Number(st_order_qty) < Number(st_min_order_qty)){
	                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
	                	alert("<%=CommonLang.msg("MSG437")%>");
	                    document.forms.contentForm.st_order_qty[j].focus();
	                    return;				
	    			}
                }
                //주문배수 주문 통제 특수로직 적용한 고객사 한정
                if(p060000089 == "true"){
                	var checkNum = st_order_qty%st_pur_unit_qty;
        			if(checkNum != 0 ){
                        //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
                    	alert(  (j+1)+"<%=CommonLang.msg("MSG533")%>");
                        document.forms.contentForm.st_order_qty[j].focus();
                        return;				
        			}            	
                }
                
                //|| buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" 제거
                if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRKDBO0003"
                    || buyer == "KRKDPR0003" || buyer == "KRDOOS0013"|| buyer == "KRKOLO0018"|| buyer == "KRCONT0006" || buyer=="KRCONT0009"
                    || buyer == "KRJINR0005" || buyer == "KRCONT0007")
                {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//번째 관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.
                        alert( (j+1)+"<%=CommonLang.msg("MSG141")%>");
                        return;
                    }
                }else if(p060000027=="TYPE2") { // KRHONG0020
                    if(ck_ref_pr_dept != ref_pr_dept){
                    	//서로다른 대학원 학과를 입력 하셨습니다.\n\n대학원 학과란을 클릭하여 확인하여 주십시요.
                        alert("<%=CommonLang.msg("MSG142")%>");
                        return;
                    }
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG122")%>");
                        return;
                    }
                    if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
                    	//대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.
                        alert("<%=CommonLang.msg("MSG123")%>");
                        return;
                    }
                }else if(p060000027=="TYPE4") { // KRHYOS0055, KRHYOS0062, KRHYOS0063, KRHYOS0064, KRHYOS0065, KRHYOS0076
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	if(next_status != "PrSheet"){
                    		//관리번호가 입력되지 않았습니다.\n관리번호 란에 Cost center를 입력하여 주십시오.
                        	alert("<%=CommonLang.msg("MSG124")%>");
                            return;                		
                    	}
                    }
                
                }else if(p060000027=="TYPE10") { // KRSIEM0010
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	if(next_status != "PrSheet"){
                    		//관리번호가 입력되지 않았습니다. 관리번호 란에 PO번호(10자리)를 입력하여 주십시오.
                        	alert("<%=CommonLang.msg("MSG407")%>");
                        	return;
                        }
                    }

                	if(!kepIsNumberStr(st_ref_pr_no) || st_ref_pr_no.length != 10){
						if(next_status != "PrSheet"){
                    		// 번째 관리번호란에 숫자 10자리를 입력하여 주시기 바랍니다.
	                    	alert((j+1)+"<%=CommonLang.msg("MSG409")%>");
	                    	return;
	                    }
                    }
                }else if(p060000027=="TYPE6") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호 기입은 필수입니다.\n\n관리번호는 비용구분으로, 실 사용되는 사업부로 선택부탁드립니다.(N/A = 공통배부)
                    	alert("<%=CommonLang.msg("MSG125")%>");
                        return;
                    }
                }else if(p060000027=="TYPE11"){
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//품의서일때 메세지 제외처리
                		if(next_status != "PrSheet"){
                    		//타입 메세지 가져오기
                        	alert(p060000027_msg);
                            return;            			
                		}
                    }
                }else if(p060000029=="TYPE15") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000027=="TYPE1" && (next_status == "CART" || next_status == "ORDER")) { // KRGEST0001
                    var ref_pr_text             = document.forms.contentForm.st_ref_pr_text[j].value;
                    var ref_pr_text2            = document.forms.contentForm.st_ref_pr_text2[j].value;
                    if(ref_pr_text == "" || ref_pr_text == "null" || ref_pr_text == null || ref_pr_text == " "){
                    	//번째 관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                        alert(  (j+1)+"<%=CommonLang.msg("MSG144")%>");
                        return;
                    }
                    if(ref_pr_text2 == "" || ref_pr_text2 == "null" || ref_pr_text2 == null || ref_pr_text2 == " "){
                    	//번째 계정항목이 선택되지 않았습니다.\n\n계정항목란을 클릭하여 선택하여 주십시요.
                        alert( (j+1)+"<%=CommonLang.msg("MSG145")%>");
                        return;
                    }
                }else if(buyer=="KRSIEM0004" && (next_status == "CART" || next_status == "ORDER")) {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//번째 관리번호가 입력되지 않았습니다.\n"+"관리번호를 입력하여 주십시요.
                        alert( (j+1)+"<%=CommonLang.msg("MSG146")%>");
                        return;
                    }
                }else if(buyer=="KRHYOS0026" && (next_status == "CART" || next_status == "ORDER")) {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//구체적인 사용용도와 실 사용자를 관리번호란에 입력 하셔야 합니다.
                        alert( (j+1)+"<%=CommonLang.msg("MSG147")%>");
                        return;
                    }
                }else if(p060000027=="TYPE7"){
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//자재그룹이 선택되지 않았습니다.\n자재그룹란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG130")%>");
                        return;
                    }
                }else if(p060000027=="TYPE8"){ // 롯데푸드
                	remark = document.forms.contentForm.st_remark[j].value; // 롯데푸드는 비고 사용
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//귀속부서/관장부서/계정코드/세금코드가 선택되지 않았습니다.\n귀속부서/관장부서/계정코드/세금코드 란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG131")%>");
                        return;
                    }
                }else if(p060000029 == "TYPE11" && (buyer == "KRILJI0066" || buyer == "KRILJI0067")) { 
                    if(mg_note == "" || mg_note == "null" || mg_note == null || mg_note == " "){
                    	//관리항목이 선택되지 않았습니다.\n관리항목란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG132")%>");
                        return;
                    }
                }else if(p060000029 == "TYPE18") { //셀트리온 관리번호 필수 체크
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//관리항목이 선택되지 않았습니다.\n관리항목란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG132")%>");
                        return;
                    }
                }else if(p060000029 == "TYPE17") { // 영풍
                	var st_yp_cost_center		= document.forms.contentForm.st_yp_cost_center[j].value;
                	var st_yp_cost_center_text	= document.forms.contentForm.st_yp_cost_center_text[j].value;
                    var st_yp_wbs				= document.forms.contentForm.st_yp_wbs[j].value;
                    var st_yp_wbs_text			= document.forms.contentForm.st_yp_wbs_text[j].value;
                     
                    if(st_yp_cost_center == "" || st_yp_cost_center == "null" || st_yp_cost_center == null || st_yp_cost_center == " "){
                    	//코스트센터가 선택되지 않았습니다.\n관리번호 상단을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG133")%>");
                        return;
                    }
                    mg_note = st_yp_cost_center + "^" + st_yp_cost_center_text + "^" + st_yp_wbs + "^" + st_yp_wbs_text;
                    document.forms.contentForm.st_mg_note[j].value = st_yp_cost_center + "^" + st_yp_cost_center_text + "^" + st_yp_wbs + "^" + st_yp_wbs_text;
                }else if(p060000029 == "TYPE20") { //에스와이에스리테일 관리번호 필수 체크
                	if(st_mng_flag == "Y"){ // 판촉물 계정 선택 시
                		if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    		//상세계정 입력 바랍니다.
                        	alert("<%=CommonLang.msg("MSG428")%>");
                            return;
                        }	
                	}
                	
                	if(item_mng_flag == "NMCD"){ // 명함 품목 시
                		remark = document.forms.contentForm.st_remark[j].value; // 명함정보 저장용 비고 사용
                		
                		if(remark == "" || remark == "null" || remark == null || remark == " "){
                			alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
                			return;
                		}
                	}
                }else if(p060000029 == "TYPE21") { //테크팩솔루션 관리번호 필수 체크
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		//관리번호(계정)가 선택되지 않았습니다. 관리번호란을 클릭하여 계정을 선택하여 주십시요.
                        alert("<%=CommonLang.msg("MSG121")%>");
                        return;
                    }
                }
                else if(p060000029 == "TYPE22") { //동화그룹 관리번호 필수 체크
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                	if(st_item_no.substr(0,1) == "4"){ //4로 시작하는 품목코드 gl_account 존재 확인
                		var tmpArrp = st_ref_pr_no.split("%%");
                		var gl_account_val = tmpArrp[8];
                		if(gl_account_val == "" || gl_account_val == "null" || gl_account_val == null || gl_account_val == " "){
                			alert("<%=CommonLang.msg("MSG542")%>");
                            return;
                		}
                	}
                }else if(p060000029 == "TYPE24") { //KG그룹 관리번호 필수 체크
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029 == "TYPE25") {
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029 == "TYPE100") {
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029=="TYPE27") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029=="TYPE28") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029=="TYPE29") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029=="TYPE30") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호가 선택되지 않았습니다.\n관리번호란을 클릭하여 선택하여 주십시요.
                    	alert("<%=CommonLang.msg("MSG126")%>");
                        return;
                    }
                }else if(p060000029=="TYPE31") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//관리번호(WBS코드)가 선택되지 않았습니다. 관리번호란을 클릭하여 WBS코드를 선택하여 주십시요.
                        alert("<%=CommonLang.msg("MSG559")%>");
                        return;
                    }
                }else if(p060000029=="TYPE32") { 
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    	//그룹웨어 품의 번호 관리번호 기재 바랍니다.
                        alert("<%=CommonLang.msg("MSG562")%>");
                        return;
                    }
                }else if(p060000029=="TYPE33") {
                	var ref_pr_no_temp = st_ref_pr_no.split('^');
                	if(<%=SolbPlantYn%>) {            		
                		if(ref_pr_no_temp[0] == "" || ref_pr_no_temp[0] == null) {
                			alert("<%=CommonLang.msg("MSG564")%>");
                			return;
                		}            		
                	}
                    if(<%=SolbCostCenterYn%>) {
                    	if(ref_pr_no_temp[1] == "" || ref_pr_no_temp[1] == null) {
                			alert("<%=CommonLang.msg("MSG564")%>");
                			return;
                		} 
                    }
                    if(ref_pr_no_temp[2] == "" || ref_pr_no_temp[2] == null) {
                    	alert("<%=CommonLang.msg("MSG564")%>");
            			return;
                    }
                }else if(p060000029=="TYPE34") { // 한샘
                	if(st_buyer_category_no.indexOf("<%=p060000129_col01%>") != -1){ // 카테고리가 전산몰인경우 검증 로직 추가
                		var ref_pr_no_temp = st_ref_pr_no.split('^');
                        if(isEmpty(ref_pr_no_temp[0]) || isEmpty(ref_pr_no_temp[1]) || isEmpty(ref_pr_no_temp[2]) 
                        		|| isEmpty(ref_pr_no_temp[3]) || isEmpty(ref_pr_no_temp[4])) {
                        	alert((j+1) + "행 <%=CommonLang.msg("MSG151")%>");
                			return;
                        }
                        if(isEmpty(st_image_key)){ // 품의서 첨부 확인 처리
                        	alert((j+1) + "행 <%=CommonLang.msg("MSG150")%>"); // 번째 첨부파일이 빠져있습니다.
                        	return;
                        }
                        if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	alert((j+1) + "행 <%=CommonLang.msg("MSG149")%>"); // 카테고리에 맞는 예산 계정을 선택해주세요.
                        	return;
                        }
                	}
                	if(st_buyer_category_no.substr(0, 3) == "<%=p060000129_col02%>"){ // 카테고리가 총무카테고리인 경우 검증 로직 추가
                		// 예산이 총무가 아닌경우
                        if(st_account_type.indexOf('-') == -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	alert((j+1) + "행 <%=CommonLang.msg("MSG149")%>");// 카테고리에 맞는 예산 계정을 선택해주세요.
                        	return;
                        }
                   	}else{ // 카테고리가 총무가 아닌경우 총무 예산 사용 금지
    	               	// 예산이 총무인 아닌경우
                   		if(st_account_type.indexOf('-') != -1){ // 한샘 총무 예산계정 (A) "-" 기준으로 총무 구분 2025-05-08
                        	alert((j+1) + "행 <%=CommonLang.msg("MSG149")%>"); // 카테고리에 맞는 예산 계정을 선택해주세요.
                        	return;
                        }
                   	}
                	if(item_mng_flag == "NMCD"){ // 명함 품목 시
                		remark = document.forms.contentForm.st_remark[j].value; // 명함정보 저장용 비고 사용
                		if(remark == "" || remark == "null" || remark == null || remark == " "){
                			alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
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
                    			alert("<%=CommonLang.msg("MSG591")%>"); // 고정자산번호가 선택되지 않았습니다. 고정자산번호란을 클릭하여 입력하여 주십시오.
        	                    return;
        	                }
                    	}
                    }         	
                	
                } else if(p060000029 == "TYPE36") { // 아모레퍼시픽 연구소
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		// G/L번호를 선택하여 주십시오.
                		alert("<%=CommonLang.msg("MSG597")%>");
                        return;
                    }            	   	
                	
                }else if(p060000029 == "TYPE37") { // 중외제약
                	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                		// 예산계정코드를 선택하여 주십시오.
                		alert("<%=CommonLang.msg("MSG598")%>");
                        return;
                    }            	   	
                	
	            }else if(p060000029 == "TYPE39") { // LB세미콘주식회사
	            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	            		// 계정/코스트센터를 선택하여 입력하세요.
	            		alert("<%=CommonLang.msg("MSG613")%>");
	                    return;
	                }
	            }
	            else if(p060000029 == "TYPE40") { // 한솔홈데코
	            	if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	            		// 계정/코스트센터를 선택하여 입력하세요.
	            		alert("<%=CommonLang.msg("MSG613")%>");
	                    return;
	                }
	            }
                else {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
                        st_ref_pr_no = " ";
                    }
                }

                if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                    	// 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요
                        alert(  (j+1) + "<%=CommonLang.msg("MSG152")%>");
                        return;
                    }
                    
                    if(st_budget_bal_amt < 0){
                    	// 번째 예산이 초과되어 예산계정을 다시 선택해주세요
                    	alert( (j+1) + "<%=CommonLang.msg("MSG595")%>");
                    	return;
                    }
                }
                //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
                if(account_mg_flag == "Y"){
                    if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                        if(isEmpty(st_account_type) || isEmpty(st_budget_dept) || isEmpty(mg_code)){
                        	// 번째 예산 적용 부서 및 계정, 관리항목을 선택해 주십시요
                            alert(  (j+1) + "<%=CommonLang.msg("MSG153")%>");
                            return;
                        }
                    }
                }
                
				// 품목별 도착지 지정 고객사
    			if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){
    				// 도착지 필수 체크
    				if(item_dely_to_location_text == "" || item_dely_to_location_text == "null" || item_dely_to_location_text == null || item_dely_to_location_text == " "){
    					// 도착지가 입력되지 않았습니다.
    					alert((j+1) + "번 품목의 " + "<%=CommonLang.msg("MSG327")%>");
    					return;
    				}
    				// 수령자 필수 체크
    				if(item_recv_user == "" || item_recv_user == "null" || item_recv_user == null || item_recv_user == " "){
    					// 수령자가 입력되지 않았습니다.
    					alert((j+1) + "번 품목의 " + "<%=CommonLang.msg("MSG544")%>");
    					return;
    				}
    				// 전화번호 필수 체크
    				if(item_recv_user_phone == "" || item_recv_user_phone == "null" || item_recv_user_phone == null || item_recv_user_phone == " "){
    					// 전화번호가 입력되지 않았습니다.
    					alert((j+1) + "번 품목의 " + "<%=CommonLang.msg("MSG324")%>");
    					return;
    				}
    			}
				
    			// 품목별 구매사유 입력 필수 고객사
   			<%if(pr_reason_yn.equals("Y")) { %>
   	            if(st_pr_reason == ""){
   	            	// 번째 구매사유를 입력해주세요.
   	            	alert((j+1) + "<%=CommonLang.msg("MSG768")%>");
   	            	return;
   	            }
   			<%}%>
				
   				if(next_status == "TRANS"||next_status == "CHECKOUT"){
   	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
               		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq;
               		query += "|";
   				}else if(p060000100 == "TYPE1"||p060000100 == "TYPE2"){ // 품목별 도착지 지정
   	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
               		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq + "@@" + st_dely_bundle_flag + "@@"
               		+ item_dely_to_location_code + "@@" + item_dely_to_location_text + "@@" + item_recv_user + "@@" + item_recv_user_phone;
               		query += "|";
   				}else{
   	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" 
               		+ st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+mg_code+ "@@"+mg_note + "@@" + st_size_qty + "@@" + st_size_len + "@@" + st_pr_reason + "@@" + st_cart_seq + "@@" + st_dely_bundle_flag;
               		query += "|";
   				}                
            }
        } // for 문 종료
        if(buyer == 'KRLAND0003' && Ccnt != 0 &&  nonCcnt != 0) { // 엘앤에프 시약 품목(품목코드 C로 시작) 타 품목과 중복 발주 금지 로직(거래 종료 후 제거)
        	alert("<%=CommonLang.msg("MSG579")%>"); // C코드(시약류) 품목의 경우, 타 품목과 중복 발주 불가능하므로 발주 목록에서 제외 후 별도 발주 진행바랍니다.
        	return;
        } 
    }
	// 조회 총 건수(2 이상) 체크 끝
     
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
        } else if (p060000084_type == "TYPE02") {
            kepAjaxFormCall("/mpso/setPunchoutUcube.do","processForm",next_status);
        } else if (p060000084_type == "TYPE03") { // 셰플러코리아
        	getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessageFagb.do","processForm",next_status);
        } else if (p060000084_type == "TYPE04") { // 필립모리스
        	getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessagePMK.do","processForm",next_status);
        } else if (p060000084_type == "TYPE05") { // 유한킴벌리
        	getPunchoutOrderMessageFromCart("/mpso/getPunchoutOrderMessageYHKB.do","processForm",next_status);
        }
    }else{
        document.forms.processForm.next_status.value = next_status;
        document.forms.processForm.st_update.value = query; 

    	kepAjaxFormCall("/mpso/saveBuyerShoppingcartSizeQtyUpdate.do","processForm",next_status); 
    }
}

function popup_dev(_sendUrl,_punchoutOrderMessageXML,_pForm,_pMethod) {
	 	var form = document.forms.processForm;
	 	form._sendUrl.value = _sendUrl;
	 	form._punchoutOrderMessageXML.value = _punchoutOrderMessageXML;
	 	form._pForm.value = _pForm;
	 	form._pMethod.value = _pMethod;
	 	form.action	= "/resources/html/main/notice/popup_sgs_test.jsp";
	 	form.method 	= "post";
	 	form.target	= "_blank";
	 	form.submit();
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
        alert("<%=CommonLang.msg("MSG69")%>");
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);

    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{
/**
 * KEPPROJECT
 * @author 최진수
 * @programid CJS00002 start
 * @remark KRHONG0020 일 경우 setCartDelete() 에서 전체 삭제에 대한 확인을 한다.
 * @date 2014-04-04
 */

        var buyer       =  $("#st_buyer").val(); 
        allDelFlag      = "N";

        if( tot_cnt == chk_cnt ) allDelFlag = "Y";

        if(buyer == "KRHONG0020" && allDelFlag == "Y") {
            chk_str = "<%=CommonLang.msg("MSG529")%>";	//전체품목을 삭제할 경우 주문내역 화면으로 이동합니다.\n삭제하시겠습니까?
        }
        else {
            chk_str = "<%=CommonLang.msg("MSG530")%>";	//선택된 상품을 장바구니에서 삭제하시겠습니까?
        }

        ok = confirm(chk_str);
/* @programid CJS00002 end */
        if(ok){
            if(eval(tot_cnt) < 2){
                var box = eval("document.forms.contentForm.lnCheck0");
                var st_item_no          = document.forms.contentForm.st_item_no.value;
                var st_contract_no      = document.forms.contentForm.st_contract_no.value;
                var st_contract_seq     = document.forms.contentForm.st_contract_seq.value;
                var st_agent_code       = document.forms.contentForm.st_agent_code.value;
                var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
                var st_cart_seq				= document.forms.contentForm.st_seq.value;

                if(box.checked == true){
                    query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" + "@@" + st_cart_seq + "&&";
                }
            }else{
                for(var j = 0; j < tot_cnt; j++){
                    var box = eval("document.forms.contentForm.lnCheck" + j);
                    var st_item_no          = document.forms.contentForm.st_item_no[j].value;
                    var st_contract_no      = document.forms.contentForm.st_contract_no[j].value;
                    var st_contract_seq     = document.forms.contentForm.st_contract_seq[j].value;
                    var st_agent_code       = document.forms.contentForm.st_agent_code[j].value;
                    var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[j].value;
                    var st_cart_seq				= document.forms.contentForm.st_seq[j].value;

                    if(box.checked == true){
                        query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq;
                        query += "&&";
                    }
                }
            }            
            
            document.forms.processForm.next_status.value = "DELETE";
            document.forms.processForm.st_update.value = query; 
        	kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE"); 

        }else{
             return;
        }
    }
}

/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.lnCheck0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.lnCheck" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}

//선택 품목 총 합계금액, 수량
function chk_sum_price(){
    var maxRow = $("#display_item_cnt").val();
    var sum_price = 0;
    var sum_qty = 0;

    if(eval(maxRow) < 2){
    	var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
            sum_price = eval(sum_price) + eval(kepFilterNum(document.forms.contentForm.st_sum_price.value));
            sum_qty = eval(sum_qty) + eval(kepFilterNum(document.forms.contentForm.st_order_qty.value));
        }
    }else{
	    for(var j = 0; j < maxRow; j++){
	         var box = eval("document.forms.contentForm.lnCheck" + j);
            if(box.checked == true){
                sum_price = eval(sum_price) + eval(kepFilterNum(document.forms.contentForm.st_sum_price[j].value));
                sum_qty = eval(sum_qty) + eval(kepFilterNum(document.forms.contentForm.st_order_qty[j].value));
            }
        }
    }
    document.forms.searchForm.check_sum_price.value     = kepCommaNum(sum_price) + " <%=CommonLang.get("HTITLE660")%>";	//원
    document.forms.searchForm.st_check_sum_price.value  = sum_price;
    
    document.forms.searchForm.check_sum_qty.value     = kepCommaNum(sum_qty);
    document.forms.searchForm.st_check_sum_qty.value  = sum_qty;
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
        alert("<%=CommonLang.msg("MSG16")%>");
        return;
    }

    chk_cnt = getCheckedRowCount(tot_cnt);    
    if(chk_cnt == "0"){
    	// 하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17")%>");
        return;
    }else{

        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0");
            var st_item_no   = document.forms.contentForm.st_item_no.value;
            var st_contract_no = document.forms.contentForm.st_contract_no.value;
            var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
            var st_seq = document.forms.contentForm.st_seq.value;
            if(box.checked == true){
            	if(dup_add_posb_yn == "Y"){
            		query = st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
            	}else{
            		query = st_item_no + st_contract_no  + st_contract_seq + "@@";
            	}
            }
        }else{
            for(var k = 0; k < tot_cnt; k++){
                var box = eval("document.forms.contentForm.lnCheck" + k);
                var st_item_no   = document.forms.contentForm.st_item_no[k].value;
                var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
                var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
                var st_seq = document.forms.contentForm.st_seq[k].value;
                if(box.checked == true){
                	if(dup_add_posb_yn == "Y"){
                		query += st_item_no + st_contract_no  + st_contract_seq + st_seq + "^Y^" + "@@";
                	}else{
                		query += st_item_no + st_contract_no  + st_contract_seq + "@@";
                	}
                }
            }
        }
    }//end else
/* 품의서 출력 제한 START */
    	if(chk_cnt > 50){
    		//품의서는 최대 50건씩 출력 가능합니다.\n정렬개수를 조정하여 페이지당 출력해주시기 바랍니다.
    		alert("<%=CommonLang.msg("MSG154")%>");
    		return;
    	}else{
    		reportOpen("<%=reportid%>","["+query+"]["+buyer+"]["+user_id+"]");
    	}
/* 품의서 출력 제한 END */
}

//코오롱 전산기기 견적제안서
function rd_onload(query) { 
}
//홍익대학교 물품구입 신청서.
function PrSheetView(){
    var userId = "<%=userId%>";
    var userComCode = "<%=buyer%>";
    var userDept = "<%=user_dept%>";
    var verif_num = "<%=st_verif_num%>";
    
	var user_comp= "<%=comp%>";
	var user_dept = "<%=dept%>"; 
	var loc = "";  

	if(user_comp == "SE"){
		if(user_dept == "GRAD"){
			loc = "RD_06_B_001_01"; // "/kr/epro/buy/sheet/pum_hongik_1.mrd";
		}else if(user_dept == "COMP"){
			loc = "RD_06_B_001_02"; // "/kr/epro/buy/sheet/pum_hongik_6.mrd";
		}else if(user_dept == "DEPT"){
			loc = "RD_06_B_001_03"; // "/kr/epro/buy/sheet/pum_hongik_2.mrd";
		}else if(user_dept == "INST"){
			loc = "RD_06_B_001_07"; // 추가 HSJ 2018.03.28
		}else if(user_dept == "INDU"){
			loc = "RD_06_B_001_22"; // 추가 KYH 2019.12.20
		}else if(user_dept == "CAMP"){
			loc = "RD_06_B_001_24"; // 추가 CCK 2020.09.28
		}else if(user_dept == "GRAS"){
			loc = "RD_06_B_001_25"; // 추가 CCK 2020.10.22
		}else if(user_dept == "DEPS"){
			loc = "RD_06_B_001_26"; // 추가 CCK 2020.10.22
		}else if(user_dept == "COMS"){
			loc = "RD_06_B_001_27"; // 추가 CCK 2020.10.22
		}else if(user_dept == "INSS"){
			loc = "RD_06_B_001_28"; // 추가 CCK 2020.10.22
		}else if(user_dept == "TP01"){
			loc = "RD_06_B_001_29"; // 추가 HSJ 2020.12.29
		}
	}else if (user_comp == "SJ"){
		if(user_dept == "GRAD"){
			loc = "RD_06_B_001_04"; // "/kr/epro/buy/sheet/pum_hongik_4.mrd";
		}else if(user_dept == "COMP"){
			loc = "RD_06_B_001_05"; // "/kr/epro/buy/sheet/pum_hongik_3.mrd";
		}else if(user_dept == "DEPT"){
			loc = "RD_06_B_001_06"; // "/kr/epro/buy/sheet/pum_hongik_5.mrd";
		}else if(user_dept == "INST"){
			loc = "RD_06_B_001_08"; // 추가 KYH 2019.12.06
		}else if(user_dept == "INDU"){
			loc = "RD_06_B_001_23"; // 추가 KYH 2019.12.20
		}
	} 
    reportPostOpen(loc,"[]["+userComCode+"]["+userId+"]["+userDept+"]["+verif_num+"]");
}

function PrSheetViewSiem(){
    var userId = "<%=userId%>";
    var userComCode = "<%=buyer%>";    
    reportOpen("<%=reportid%>","[]["+userComCode+"]["+userId+"]");  
}

function price_update(cart_qty, y_num, buy_price,orgin_cart_qty){
    var tot_cnt  = $("#display_item_cnt").val();
    var budget_flag = "<%=budget_flag%>";
    if(eval(tot_cnt) < 2){

         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
         }else{
             var sum_price = kepGetRound((cart_qty * buy_price),3);
             document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
             if(budget_flag == "Y"){
//             	 var bdgt_bal_amt = document.forms.contentForm.st_budget_amt.value;
//             	 if(eval(sum_price) > eval(bdgt_bal_amt)){
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
//수량 길이 변경시 총수량 
function price_size_update(value, y_num, buy_price,orgin_size_qty,orgin_len_qty){

    var tot_cnt  = $("#display_item_cnt").val();
    var st_size_len = "";
    var st_size_qty  = "";
    var sum_price = "";
    var sum_qty = "";
    if(eval(tot_cnt) < 2){
         if(value == "null" || value == "" || value == null){
         }else{
             st_size_len =  document.forms.contentForm.st_size_len.value;
             st_size_qty =  document.forms.contentForm.st_size_qty.value;
             sum_price = kepGetRound((st_size_qty*st_size_len * buy_price),3);
             sum_qty = kepGetRound((st_size_qty*st_size_len),3);
             document.forms.contentForm.st_order_qty.value = sum_qty;
             document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
         }

    }else{
         if(value == "null" || value == "" || value == null){
         }else{
             st_size_len =  document.forms.contentForm.st_size_len[y_num].value;
             st_size_qty =  document.forms.contentForm.st_size_qty[y_num].value;
             sum_price = kepGetRound((st_size_qty*st_size_len * buy_price),3);
             sum_qty = kepGetRound((st_size_qty*st_size_len),3);
             document.forms.contentForm.st_order_qty[y_num].value = sum_qty;
             document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(sum_price);
         }
    }
    chk_sum_price(); // 선택 품목 총 합계금액
}

function price_update_P(y_num, buy_price,orgin_cart_qty){
	alert("1");
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
function setRefNoCopy() {	
    var tot_cnt  = $("#display_item_cnt").val();
    var cnt = 0;
    var ref_no = "";    
	var yuhan_saperp_flag = "";
	var tmp_saperp_flag = "";
	var st_ref_pr_no_text = "";
	var st_ref_pr_no = "";
	var st_mg_note = "";
	var st_remark = "";
	var st_yp_cost_center = "";
	var st_yp_wbs = "";
	var mg_note = "";
	var st_ref_pr_no_name = "";
	
	var type11= "<%=p060000029%>";
	
	if(type11 != "TYPE20"){ // 에스와이에스리테일(KRSYSR0001) 은 관리번호 복사 기능 사용 X
	    if(eval(tot_cnt) < 2){
	       return;
	    }else{
	        for(var k = 0; k < tot_cnt; k++){
	            var box = eval("document.forms.contentForm.lnCheck" + k);
	            if(box.checked == true){
	              if(cnt < 1)
	              {
	                 	ref_no = document.forms.contentForm.st_ref_pr_no[k].value;	                 	
	                 	//일진전기 복사
	                 	if(type11 == "TYPE11"||type11 == "TYPE13"){
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 		st_mg_note  = document.forms.contentForm.st_mg_note[k].value;
	                 	}
	                 	// 관리번호명 복사
	                 	else if(type11 == "TYPE15" || type11 == "TYPE14"){
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	}
	                 	// 관리번호명, 비고 복사
	                 	else if(type11 == "TYPE16" || type11 == "TYPE26"){
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 		st_ref_pr_no_name = $("a[name='st_ref_pr_no_name']").eq(k).text();
	                 		st_remark = document.forms.contentForm.st_remark[k].value;
	                 	}
	                	// 관리번호명, 비고 복사
	                 	else if(type11 == "TYPE17"){ // 영풍
	                 		st_yp_cost_center = document.forms.contentForm.st_yp_cost_center[k].value;
	                 		st_yp_cost_center_text = document.forms.contentForm.st_yp_cost_center_text[k].value;
	                 		st_yp_wbs = document.forms.contentForm.st_yp_wbs[k].value;
	                 		st_yp_wbs_text = document.forms.contentForm.st_yp_wbs_text[k].value;
	                 	}
	                 	// 관리번호코드, 관리번호명 복사
	                 	else if(type11 == "TYPE24"){ // KG
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	}else if(type11 == "TYPE27"){ // 한컴라이프케어
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	}else if(type11 == "TYPE31"){ // 금호석유화학(KRKUMHG001)
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	}else if(type11 == "TYPE33"){ // 솔브레인 그룹
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	} else if(type11 == "TYPE34"){ // 한샘
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 		st_ref_pr_no_text = document.forms.contentForm.st_ref_pr_no_text[k].value;
	                 	} 
	                 	else{
	                 		st_ref_pr_no = document.forms.contentForm.st_ref_pr_no[k].value;
	                 	}
	                 	
	                cnt++;
	              }else {
	            	  
	                    document.forms.contentForm.st_ref_pr_no[k].value = ref_no;	            		
	                 	//일진전기 복사
	                 	if(type11 == "TYPE11"||type11 == "TYPE13"){
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 		document.forms.contentForm.st_mg_note[k].value = st_mg_note;
	                 	}
	                 	// 관리번호명 복사
	                 	else if(type11 == "TYPE15" || type11 == "TYPE14"){
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 	}
	                 	// 관리번호명, 비고 복사
	                 	else if(type11 == "TYPE16" || type11 == "TYPE26"){
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 		$("a[name='st_ref_pr_no_name']").eq(k).text(st_ref_pr_no_name);
	                 		document.forms.contentForm.st_remark[k].value = st_remark;
	                 	}
	                 	// 관리번호명, 비고 복사
	                 	else if(type11 == "TYPE17"){ // 영풍
	                 		document.forms.contentForm.st_yp_cost_center[k].value = st_yp_cost_center;
	                 		document.forms.contentForm.st_yp_cost_center_text[k].value = st_yp_cost_center_text;
	                 		document.forms.contentForm.st_yp_wbs_text[k].value = st_yp_wbs_text;
	                 		document.forms.contentForm.st_yp_wbs[k].value = st_yp_wbs;
	                 	}
	                 	// 관리번호코드, 관리번호명 복사
	                 	else if(type11 == "TYPE24"){ // KG
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 	}
	                 	else if(type11 == "TYPE27"){ // 한컴라이프케어 
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 	}else if(type11 == "TYPE31"){ // 금호석유화학(KRKUMHG001)
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 	}else if(type11 == "TYPE33"){ // 솔브레인 그룹
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = st_ref_pr_no_text;
	                 	}else if(type11 == "TYPE34"){ // 한샘
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 		document.forms.contentForm.st_ref_pr_no_text[k].value = isEmpty(st_ref_pr_no_text)?st_ref_pr_no:st_ref_pr_no_text;
	                 	}
	                 	else{
	                 		document.forms.contentForm.st_ref_pr_no[k].value = st_ref_pr_no;
	                 	}
					}
	            }
	        }
	    }
	}
}

//PG_06_B_018_02
function ItemAdd(){
	openSearchPopup("/mppo/getBuyerMpPoGoodsAddPop.do","?openYn=Y&st_px_no=<%=st_verif_num%>&st_recv_flag=HI" , "1000,800,no"); 
}

//총금액  PG_06_B_006_50
function category_list_pop(){
    var byca_comorg_code   = "<%=byca_comorg_code%>";
    var user_id            = "<%=userId%>";    
    openSearchPopup("/mpso/getCategoryListSelectPop.do","?byca_comorg_code="+byca_comorg_code+"&user_id="+user_id, "500,500,no"); 
}

//예산내역 조회 PG_06_B_006_60
function getBudgetList(){    
	openSearchPopup("/mpso/showBuyerMpSoBudgetListPop.do","", "1000,500,no"); 
}

// 예산계정 선택 팝업
function getBdgtAccountPop(com_code,dept_code,row,categ)
{ 
    var tot_cnt  = $("#display_item_cnt").val();        
    var order_qty = "";
    var order_price = "";
    var description = "";
    var box = "";
    gridIndex = row;
    var bdgt_categ_acnt_set = "<%=bdgt_categ_acnt_set%>";
    var account_pop_search_set = "<%=account_pop_search_set%>";
    
    if(eval(tot_cnt) < 2){
        box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
        order_qty = document.forms.contentForm.st_order_qty.value;
        order_price = document.forms.contentForm.st_order_price.value;
        description = document.forms.contentForm.st_description.value;
    }else{
        box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        order_qty = document.forms.contentForm.st_order_qty[row].value;
        order_price = document.forms.contentForm.st_order_price[row].value;
        description = document.forms.contentForm.st_description[row].value;
    }
    
    chk_sum_price(); 
    var cart_sum_price =$("#st_check_sum_price").val(); 
 
    var val = "";
    //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
    if(account_mg_flag == "Y"){  // PG_06_B_006_41
    	openSearchPopup("/mpso/showBuyerMpSoAccountSel1Pop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_order_qty="+order_qty+"&st_order_price="+order_price+"&st_description="+description, "500,650,no"); 
    }else if(bdgt_categ_acnt_set == "Y"){ // 카테고리에 해당하는 예산만 조회
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_categ="+categ+"&st_categ_acnt_set=Y", "750,515,no");
    }else if(account_pop_search_set == "Y"){ // 자동조회 미사용, 조회조건 필수 입력
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=N&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_search_set=Y", "750,515,no");
    }else if(p060000029 == "TYPE34"){
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price+"&st_account_flg="+categ.substr(0, 1), "750,555,no");
    }else{ // PG_06_B_006_40 buyerMpSoAccountSelPop
    	openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price, "750,555,no"); 
    } 
    return;
}

//예산계정 설정
function setBdgtAccount(account_type , account_name, dept_code , dept_name, mg_code, mg_note, bdgt_bal, mng_dept_cd, mng_dept_nm){
    var tot_cnt  = $("#display_item_cnt").val();
    var bdgt_categ_acnt_set = "<%=bdgt_categ_acnt_set%>";
    
    if(eval(tot_cnt) < 2){
    	//관리부서 통제일 경우 계정정보+ 관리부서 같이 보여짐
    	if(p060000090 =="true"){
    		document.forms.contentForm.st_account_type_name.value= account_name+"("+mng_dept_nm+")";	
    	}else{
    		document.forms.contentForm.st_account_type_name.value= account_name;
    	}
    	//관리부서 코드 셋팅
    	document.forms.contentForm.st_mng_dept_cd.value     = mng_dept_cd;
        document.forms.contentForm.st_account_type.value     = account_type;
        document.forms.contentForm.st_budget_dept_name.value = dept_name;
        document.forms.contentForm.st_budget_dept.value      = dept_code;
        
        //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
        if(account_mg_flag == "Y"){
            document.forms.contentForm.st_mg_code.value          = mg_code;
            document.forms.contentForm.st_mg_note.value          = mg_note;
            
            document.forms.contentForm.st_bdgt_bal_amt.value      = kepNumComma2(bdgt_bal);
            document.forms.contentForm.st_budget_amt.value      = bdgt_bal;
            
            document.forms.contentForm.st_bdgt_bal_amt.style.color = '#003694';
        }else{
        	document.forms.contentForm.st_bdgt_bal_amt.value      = kepNumComma2(mg_code);
            document.forms.contentForm.st_budget_amt.value      = mg_code;
            document.forms.contentForm.st_mng_flag.value      = mg_note;
            
        	document.forms.contentForm.st_bdgt_bal_amt.style.color = '#003694';
        }
        
        if(p060000029 == "TYPE20"){ // 에스와이에스리테일(KRSYSR0001) 일 때 예산부서 변경 시 예산 상세계정(관리번호) 초기화
        	document.forms.contentForm.st_ref_pr_no_text.value = "";
	    	document.forms.contentForm.st_ref_pr_no.value = "";
        } else if(p060000029 == "TYPE35") { // 넥센타이어 예산 계정 변경 시 고정자산번호 초기화
	        document.forms.contentForm.st_ref_pr_no_text.value = "";
	    	document.forms.contentForm.st_ref_pr_no.value = "";
        }
    }else{
		if(bdgt_categ_acnt_set == "N"){
	        for(var k =0; k < tot_cnt; k++){
	            var box = eval("document.forms.contentForm.lnCheck" + k);
	             
	            if(box.checked == true){
	            	//관리부서 통제일 경우 계정정보+ 관리부서 같이 보여짐
	            	if(p060000090 =="true"){
	            		document.forms.contentForm.st_account_type_name[k].value = account_name+"("+mng_dept_nm+")";	
	            	}else{
	            		document.forms.contentForm.st_account_type_name[k].value   = account_name;
	            	}
	            	//관리부서 코드 셋팅
	            	document.forms.contentForm.st_mng_dept_cd[k].value     = mng_dept_cd;
	                document.forms.contentForm.st_account_type[k].value        = account_type;
	                document.forms.contentForm.st_budget_dept_name[k].value    = dept_name;
	                document.forms.contentForm.st_budget_dept[k].value         = dept_code;
	                
	                //예산계정별 관리항목 관리 고객사 (KRDONG0708, KRCHAN0060, KRCHAN0058, KRCHAN0059 => account_mg_flag = "Y")
	                if(account_mg_flag == "Y"){
	                    document.forms.contentForm.st_mg_code[k].value             = mg_code;
	                    document.forms.contentForm.st_mg_note[k].value             = mg_note;
	
	                    document.forms.contentForm.st_bdgt_bal_amt[k].value      = kepNumComma2(bdgt_bal);
	                    document.forms.contentForm.st_budget_amt[k].value      = bdgt_bal;
	                    
	                    document.forms.contentForm.st_bdgt_bal_amt[k].style.color = '#003694';
	
	                }else{
	                	document.forms.contentForm.st_bdgt_bal_amt[k].value      = kepNumComma2(mg_code);
	                    document.forms.contentForm.st_budget_amt[k].value      = mg_code;
	                    document.forms.contentForm.st_mng_flag[k].value         = mg_note;
	                    
	                	document.forms.contentForm.st_bdgt_bal_amt[k].style.color = '#003694';
	                }
	                
	                if(p060000029 == "TYPE20"){ // 에스와이에스리테일(KRSYSR0001) 일 때 예산부서 변경 시 예산 상세계정(관리번호) 초기화
	                	document.forms.contentForm.st_ref_pr_no_text[k].value = "";
	    		    	document.forms.contentForm.st_ref_pr_no[k].value = "";
	                }else if(p060000029 == "TYPE35") { // 넥센타이어 예산 계정 변경 시 고정자산번호 초기화
	                	document.forms.contentForm.st_ref_pr_no_text[k].value = "";
	    		    	document.forms.contentForm.st_ref_pr_no[k].value = "";
	                }
	            }
	        }
		}else{
			document.forms.contentForm.st_account_type_name[gridIndex].value	= account_name;
			document.forms.contentForm.st_mng_dept_cd[gridIndex].value			= mng_dept_cd;
            document.forms.contentForm.st_account_type[gridIndex].value			= account_type;
            document.forms.contentForm.st_budget_dept_name[gridIndex].value		= dept_name;
            document.forms.contentForm.st_budget_dept[gridIndex].value			= dept_code;
            document.forms.contentForm.st_bdgt_bal_amt[gridIndex].value			= kepNumComma2(mg_code);
            document.forms.contentForm.st_budget_amt[gridIndex].value			= mg_code;
            document.forms.contentForm.st_mng_flag[gridIndex].value				= mg_note;
        	document.forms.contentForm.st_bdgt_bal_amt[gridIndex].style.color	= '#003694';
		}
    }
}

//홍익대학교-- 대학원 소속 체크. PG_06_B_006_30
function getHongIkDeptCode(row){ 
    var buyer                = "<%=buyer%>";
    var user_id             = "<%=userId%>";
    var tot_cnt  =$("#display_item_cnt").val();
    if(eval(tot_cnt) < 2)  {
        var box = eval("document.forms.contentForm.lnCheck0");
        propCheckBox(box, true);
    } else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
    }
    openSearchPopup("/mpso/showBuyerMpSoGraduateDetailDeptCodePop.do","?open=Y&st_buyer=" + buyer+"&st_row="+row+"&st_user_id="+user_id, "500,500,no"); 
}

function setHongIkDeptCode(dept_code,dept_name, row){
    var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2)  {
      document.forms.contentForm.st_ref_pr_dept.value = dept_code;
      document.forms.contentForm.st_ref_pr_dept_name.value = dept_name;
      var box = eval("document.forms.contentForm.lnCheck0");
      propCheckBox(box, true);
    } else{
      for(var x=0; x<eval(tot_cnt); x++) {
          var box = eval("document.forms.contentForm.lnCheck" + x);
          if(box.checked==true) {
              document.forms.contentForm.st_ref_pr_dept[x].value = dept_code;
              document.forms.contentForm.st_ref_pr_dept_name[x].value = dept_name;
          }
      }
    }
  }
  
//(주)게스템프 카테크 
function getKRGEST0001(row,type,ref_no){
	var buyer  =  "<%=buyer%>";
	var tot_cnt  = $("#display_item_cnt").val();
	var url = "";
	if(type == "M015"){
	    if(eval(tot_cnt) < 2){
	        var le_ref_no = document.forms.contentForm.st_ref_pr_no.value;
	        if(kepTrimStr(le_ref_no) == ""){
	        	//관리번호를 먼저 선택후 계정과목 선택 바랍니다.
	            alert("<%=CommonLang.msg("MSG156")%>");
	            return;
	        }
	    }else{
	        var le_ref_no = document.forms.contentForm.st_ref_pr_no[row].value;
	       //alert("=>"+TrimCommon(le_ref_no)+"<=");
	        if(kepTrimStr(le_ref_no) == ""){
	        	//관리번호를 먼저 선택후 계정과목 선택 바랍니다.
	            alert("<%=CommonLang.msg("MSG156")%>");
	            return;
	        }
	    }
	}
	
	if(kepTrimStr(ref_no) == ""){
	  if(eval(tot_cnt) < 2)
	    ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
	  else
	    ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
	} 
	
	if(type == "M015"){ //PG_06_B_006_20
		url = "/mpso/showBuyerMpSoPartInfoPop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_type="+type+"&st_buyer="+buyer, "800,600,no"); 
	   // adr = "/kr/customer/shopping_cart/refno_krgest0001.jsp";
	}else{  //  PG_06_B_006_09
		url = "/mpso/showBuyerMpSoGuessTempCarTechCostCenterPop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_type="+type+"&st_buyer="+buyer, "1000,500,no"); 
	 //   adr = "/kr/customer/shopping_cart/refno_krgest0001_m014.jsp";
	}
}
//지멘스 헬스케어(주) (KRSIEM0014) 관리항목 팝업
function getKRSIEM0014(row,ref_no){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "CostCenter";
		var st_type = "C005";
		var st_code =  document.forms.contentForm.st_ref_pr_no.value;
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "CostCenter";
		var st_type = "C005";
		var st_code =  document.forms.contentForm.st_ref_pr_no[row].value;
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}
//관리번호 일진제강
function getRefprnoInfo(row,ref_no, title_type){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    var st_gbn = "관리번호";
    if(title_type == "T001"){ // 에스와이에스리테일(KRSYSR0001)
    	var mng_flag = "";
    	st_gbn = "예산 상세계정";
    
    	if(eval(tot_cnt) < 2){
    		mng_flag = document.forms.contentForm.st_mng_flag.value;
    	}else{
    		mng_flag = document.forms.contentForm.st_mng_flag[row].value;
    	}
    	if(mng_flag != "Y"){ // 판촉물 계정이 아닐 때
			alert("<%=CommonLang.msg("MSG429")%>"); // 판촉물 계정 선택 시 관리번호를 선택할 수 있습니다.
			return;
		}
    }else if(title_type == "T002"){
    	st_gbn = "관리계정";
    }
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//관리번호 조회조건 4개 팝업
function getRefPrNo_4cond(row, ref_no){
	var buyer  =  "<%=buyer%>";
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	var url = "";
	var cond1_text = "업체구분";
	var cond2_text = "입고거래처";
	var cond3_text = "발주사";
	var cond4_text = "현장";
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.forms.contentForm.lnCheck0");
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no.value;
		url = "/mpso/showBuyerMpSoRefPrNoInfoPop4cond.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&cond1="+cond1_text+"&cond2="+cond2_text+"&cond3="+cond3_text+"&cond4="+cond4_text, "600,180,no");
			
	}else{
		var box = eval("document.forms.contentForm.lnCheck" + row);
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no[row].value;
		
		url = "/mpso/showBuyerMpSoRefPrNoInfoPop4cond.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&cond1="+cond1_text+"&cond2="+cond2_text+"&cond3="+cond3_text+"&cond4="+cond4_text, "600,180,no");
    }
}

//관리번호 팝업 - 롯데푸드
function getRefPrNo_lotte(row, ref_no, remark){
	var buyer  =  "<%=buyer%>";
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	var url = "";
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.forms.contentForm.lnCheck0");
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no.value;
		remark = document.forms.contentForm.st_remark.value;
		url = "/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "600,280,no");
			
	}else{
		var box = eval("document.forms.contentForm.lnCheck" + row);
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no[row].value;
		remark = document.forms.contentForm.st_remark[row].value;
		url = "/mpso/getBuyerMpSoRefPrNoInfoLott1Pop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "600,280,no");
    }
}

//관리번호 팝업 - 롯데후레시델리카
function getRefPrNo_lotteFresh(row, ref_no, remark){
	var buyer  =  "<%=buyer%>";
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	var url = "";
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.forms.contentForm.lnCheck0");
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no.value;
		remark = document.forms.contentForm.st_remark.value;
		url = "/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "600,170,no");
			
	}else{
		var box = eval("document.forms.contentForm.lnCheck" + row);
		propCheckBox(box, true);
		ref_no =  document.forms.contentForm.st_ref_pr_no[row].value;
		remark = document.forms.contentForm.st_remark[row].value;
		url = "/mpso/getBuyerMpSoRefPrNoInfoLottFresh1Pop.do";
		openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "600,170,no");
    }
}

// 관리항목 팝업 - 한컴 라이프 케어
function getHancomLC(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
		remark = kepTrimStr(document.forms.contentForm.st_remark.value);
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
        remark = kepTrimStr(document.forms.contentForm.st_remark[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoHancomLCPop.do";
    openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "800,325,no"); 
}

//관리항목 팝업 - 해비치호텔앤드리조트 주식회사(제주)
function getRefPrNoHaev(row,ref_no){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    var st_gbn = "파트";    
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//관리항목 팝업 - (주)케이씨텍
function getRefPrNoKcte(row,ref_no){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    var st_gbn = "G/L계정";    
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//관리항목 팝업 - 주식회사 엔씨켐
function getRefPrNoNc(row,ref_no){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    var st_gbn = "관리목록";    
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//관리항목 팝업 - 금호석유화학(KRKUMHG001)
function getRefPrNoKuG(row,ref_no){
    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    var st_gbn = "코드 값";    
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_type = "M014";
		var st_code =  "";
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?open=Y&st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//관리항목 팝업 - 와이지원(KRYG-10003,KRYG-10004,KRYG-10005,KRYG-10006)
function getRefPrNoYG1(row,ref_no){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoYG1Pop.do";
    openSearchPopup(url,"?open=Y&st_row=" + row+"&st_ref_no="+ref_no+"&st_buyer="+buyer, "500,210,no"); 
}

//관리항목 팝업 - 솔브레인 그룹
function getRefPrNoSolb(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
       	remark = kepTrimStr(document.forms.contentForm.st_remark.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
        remark = kepTrimStr(document.forms.contentForm.st_remark[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoSolbPop.do";
    openSearchPopup(url,"?open=Y&st_cart_yn=Y" +"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "700,210,no"); 
}

//관리항목 팝업 - 한샘
function getRefPrNoHans(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
       	remark = kepTrimStr(document.forms.contentForm.st_remark.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
        remark = kepTrimStr(document.forms.contentForm.st_remark[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoHansPop.do";
    openSearchPopup(url,"?open=Y&st_cart_yn=Y" +"&st_ref_no="+ref_no+"&st_buyer="+buyer+"&st_remark="+remark, "500,220,no"); 
}
//관리항목 팝업 - 넥센타이어
function getRefPrNoNexe(row, ref_pr_no){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
	var aclist = new Array(); 
	<%for(int i = 0; i < aclist.size(); i ++) {
		%>
		aclist.push('<%=aclist.get(i)%>');
	<%}
	%>
	var account_type = "";
	var acCnt = 0;
	var ref_pr_no_text = "";
    if(eval(tot_cnt) < 2) {
        ref_pr_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
        ref_pr_no_text = kepTrimStr(document.forms.contentForm.st_ref_pr_no_text.value);
       	account_type = kepTrimStr(document.forms.contentForm.st_account_type.value);
    }else{
    	ref_pr_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
        ref_pr_no_text = kepTrimStr(document.forms.contentForm.st_ref_pr_no_text[row].value);
        account_type = kepTrimStr(document.forms.contentForm.st_account_type[row].value);
    }
    for(var i = 0; i < <%=aclist.size()%>; i++) {    	
    	if(account_type == aclist[i]) {
    		acCnt++;
    	}
    }
    
   	if(acCnt > 0) {   	   
   	    url = "/mpso/getBuyerMpSoRefPrNoInfoNexePop.do";
   	    openSearchPopup(url,"?ref_pr_no=" +ref_pr_no+"&ref_pr_no_text="+ref_pr_no_text+"&st_account_type="+account_type+"&st_buyer="+buyer, "500,300,no"); 
   	}
    
}
// 팝업 콜백함수
function setPopupReturn(type,value1,value2,value3){
    var tot_cnt  =  $("#display_item_cnt").val();
	if (popupSel == "attach"){
		//$("input[name=st_image_key]").eq(gridIndex).val(type);
	    if(eval(tot_cnt) < 2){    	
	    	document.forms.contentForm.st_image_key.value = type;
	    }else{
	    	document.forms.contentForm.st_image_key[gridIndex].value = type;
	    }
   		saveAttach(gridIndex);
	}else if(popupSel == "namecard_info"){
		if(eval(tot_cnt) < 2){    	
	    	document.forms.contentForm.st_remark.value = type;
	    }else{
	    	document.forms.contentForm.st_remark[gridIndex].value = type;
	    }
	}else if (popupSel == "location"){
		if(eval(tot_cnt) < 2){    	
			document.forms.contentForm.item_dely_to_location_code.value = type;
			document.forms.contentForm.item_dely_to_location_text.value = value1;
	    }else{
	    	document.forms.contentForm.item_dely_to_location_code[gridIndex].value = type;
			document.forms.contentForm.item_dely_to_location_text[gridIndex].value = value1;
			for(var k=0; k<tot_cnt; k++){
	    		var box = eval("document.forms.contentForm.lnCheck" + k);
	    		if(box.checked == true){
	    			document.forms.contentForm.item_dely_to_location_code[k].value = type;
    		    	document.forms.contentForm.item_dely_to_location_text[k].value = value1;
    		    	
    		    	document.forms.contentForm.item_recv_user[k].value = document.forms.contentForm.item_recv_user[gridIndex].value;
    		    	document.forms.contentForm.item_recv_user_phone[k].value = document.forms.contentForm.item_recv_user_phone[gridIndex].value;
	    		}
	    	}
	    }
	}else if (popupSel == "orderLocation"){
		if(eval(tot_cnt) < 2){    	
			document.forms.contentForm.item_dely_to_location_code.value = type;
			document.forms.contentForm.item_dely_to_location_text.value = value1;
	    }else{
	    	document.forms.contentForm.item_dely_to_location_code[gridIndex].value = type;
			document.forms.contentForm.item_dely_to_location_text[gridIndex].value = value1;
			for(var k=0; k<tot_cnt; k++){
	    		var box = eval("document.forms.contentForm.lnCheck" + k);
	    		if(box.checked == true){
	    			document.forms.contentForm.item_dely_to_location_code[k].value = type;
    		    	document.forms.contentForm.item_dely_to_location_text[k].value = value1;
    		    	
    		    	document.forms.contentForm.item_recv_user[k].value = document.forms.contentForm.item_recv_user[gridIndex].value;
    		    	document.forms.contentForm.item_recv_user_phone[k].value = document.forms.contentForm.item_recv_user_phone[gridIndex].value;
	    		}
	    	}
	    }
	}else{ // 관리번호 팝업
		var p060000029 = "<%=p060000029%>";
	    if(eval(tot_cnt) < 2){    	
	    	if(p060000029  == "TYPE14" || p060000029  == "TYPE18" || p060000029  == "TYPE19" || p060000029  == "TYPE23" || p060000029  == "TYPE24"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value2;
		    	document.forms.contentForm.st_ref_pr_no.value = value2;
	    	}else if(p060000029  == "TYPE16"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
		    	document.forms.contentForm.st_remark.value = value2;
		    	$("a[name='st_ref_pr_no_name']").text(value3);
	    	}else if(p060000029  == "TYPE17"){
	    		if(popupSel == "yp_cost_center"){
	    			document.forms.contentForm.st_yp_cost_center.value = value1;
			    	document.forms.contentForm.st_yp_cost_center_text.value = value2;
	    		}else if(popupSel == "yp_wbs"){
	    			document.forms.contentForm.st_yp_wbs.value = value1;
			    	document.forms.contentForm.st_yp_wbs_text.value = value2;
	    		}
	    	}else if(p060000029  == "TYPE20"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1+"("+value2+")";
	    		document.forms.contentForm.st_ref_pr_no.value = value1+"("+value2+")";
	    	}else if(p060000029  == "TYPE21"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value2+"("+value1+")";
	    		document.forms.contentForm.st_ref_pr_no.value = value2+"("+value1+")";
	    	}else if(p060000029  == "TYPE25"){
	    		document.forms.contentForm.st_ref_pr_no.value = value2+"("+value1+")";
	    	}else if(p060000029  == "TYPE100"){
	    		document.forms.contentForm.st_ref_pr_no.value = value1;
	    	}else if(p060000029  == "TYPE26"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
		    	document.forms.contentForm.st_remark.value = value2;
		    	$("a[name='st_ref_pr_no_name']").text(value3);
	    	}else if (p060000029  == "TYPE27"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
		    	document.forms.contentForm.st_remark.value = value2;
		    	changeIcon(k); <%-- 비고에 값이 있으면 비고 돋보기 아이콘 변경 --%> 
	    	}else if (p060000029  == "TYPE28"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1+"^"+value2;
		    	document.forms.contentForm.st_ref_pr_no.value = value1+"^"+value2;	
	    	}else if (p060000029  == "TYPE29"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;	
	    	}else if (p060000029  == "TYPE30"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;	
	    	}else if (p060000029  == "TYPE35"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value2;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
	    	}else if (p060000029  == "TYPE39"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
	    	}else if (p060000029  == "TYPE40"){
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
	    	}else{
	    		document.forms.contentForm.st_ref_pr_no_text.value = value1;
		    	document.forms.contentForm.st_ref_pr_no.value = value1;
	    	}
	    }else{
	    	//TYPE14일경우 
	    	if(p060000029  == "TYPE14" || p060000029  == "TYPE18" || p060000029  == "TYPE19" || p060000029  == "TYPE23" || p060000029  == "TYPE24"){
		    	document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value2;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value2;	    		
	    	}else if(p060000029  == "TYPE16"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
		    	document.forms.contentForm.st_remark[iljin_row].value = value2;
		    	$("a[name='st_ref_pr_no_name']").eq(iljin_row).text(value3);
	    	}else if(p060000029  == "TYPE17"){
	    		if(popupSel == "yp_cost_center"){
	    			document.forms.contentForm.st_yp_cost_center[iljin_row].value = value1;
			    	document.forms.contentForm.st_yp_cost_center_text[iljin_row].value = value2;
	    		}else if(popupSel == "yp_wbs"){
	    			document.forms.contentForm.st_yp_wbs[iljin_row].value = value1;
			    	document.forms.contentForm.st_yp_wbs_text[iljin_row].value = value2;
	    		}
	    	}else if(p060000029  == "TYPE20"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1+"("+value2+")";
	    		document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1+"("+value2+")";
	    	}else if(p060000029  == "TYPE21"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value2+"("+value1+")";
	    		document.forms.contentForm.st_ref_pr_no[iljin_row].value = value2+"("+value1+")";
	    	}else if(p060000029  == "TYPE25"){
	    		document.forms.contentForm.st_ref_pr_no[iljin_row].value = value2+"("+value1+")";
	    	}else if(p060000029  == "TYPE100"){
	    		document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
	    	}else if(p060000029  == "TYPE26"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
		    	document.forms.contentForm.st_remark[iljin_row].value = value2;
		    	$("a[name='st_ref_pr_no_name']").eq(iljin_row).text(value3);
	    	}else if (p060000029  == "TYPE27"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
		    	document.forms.contentForm.st_remark[iljin_row].value = value2;
	    	}else if (p060000029  == "TYPE28"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1+"^"+value2;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1+"^"+value2;		    	
	    	}else if (p060000029  == "TYPE29"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;		    	
	    	}else if (p060000029  == "TYPE30"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;		    	
	    	}else if (p060000029  == "TYPE35"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value2;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
	    	}else if (p060000029  == "TYPE39"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
	    	}else if (p060000029  == "TYPE40"){
	    		document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;
	    	}else{
		    	document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
		    	document.forms.contentForm.st_ref_pr_no[iljin_row].value = value1;	    	
	    	}
	    	
	    	if(p060000029  != "TYPE20"){ // 에스와이에스리테일(KRSYSR0001)은 사용 X
		    	// 체크 선택한 항목들 관리번호는 같이 세팅 2017.05.11 HSJ
		    	for(var k=0; k<tot_cnt; k++){
		    		var box = eval("document.forms.contentForm.lnCheck" + k);
		    		if(box.checked == true){
		    			//TYPE14일경우 
		    	    	if(p060000029  == "TYPE14" || p060000029  == "TYPE18" || p060000029  == "TYPE19" || p060000029  == "TYPE23"){
		    		    	document.forms.contentForm.st_ref_pr_no_text[k].value = value2;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value2;	    		
		    	    	}else if(p060000029  == "TYPE16"){
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;
		    		    	document.forms.contentForm.st_remark[k].value = value2;
		    		    	$("a[name='st_ref_pr_no_name']").eq(k).text(value3);
		    	    	}else if(p060000029  == "TYPE17"){
		    	    		if(popupSel == "yp_cost_center"){
		    	    			document.forms.contentForm.st_yp_cost_center[k].value = value1;
			    		    	document.forms.contentForm.st_yp_cost_center_text[k].value = value2;
		    	    		}else if(popupSel == "yp_wbs"){
		    	    			document.forms.contentForm.st_yp_wbs[k].value = value1;
			    		    	document.forms.contentForm.st_yp_wbs_text[k].value = value2;
		    	    		}
		    	    	}else if(p060000029  == "TYPE26"){
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;
		    		    	document.forms.contentForm.st_remark[k].value = value2;
		    		    	$("a[name='st_ref_pr_no_name']").eq(k).text(value3);
		    	    	}else if(p060000029  == "TYPE27"){
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;
		    		    	document.forms.contentForm.st_remark[k].value = value2;
		    		    	changeIcon(k); <%-- 비고에 값이 있으면 비고 돋보기 아이콘 변경 --%> 
		    	    	}else if(p060000029  == "TYPE28"){
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1+"^"+value2;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1+"^"+value2;		    		    	
		    	    	}else if(p060000029  == "TYPE33"){
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;		    		    	
		    	    	}else if(p060000029  == "TYPE34"){ // 한샘
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;		    		    	
		    	    	}else if(p060000029  == "TYPE39"){ // LB세미콘주식회사
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;
		    	    	}else if(p060000029  == "TYPE40"){ // (주)한솔홈데코
		    	    		document.forms.contentForm.st_ref_pr_no_text[k].value = value1;
		    		    	document.forms.contentForm.st_ref_pr_no[k].value = value1;
		    	    	}
		    		}
		    	}
	    	}
	    }
	}
}
//우편번호 검색 콜백
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	var tot_cnt  =  $("#display_item_cnt").val();
	if(eval(tot_cnt) < 2){    	
		document.forms.contentForm.item_dely_to_location_code.value = "";
		document.forms.contentForm.item_dely_to_location_text.value = zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail;
    }else{
    	document.forms.contentForm.item_dely_to_location_code[gridIndex].value = "";
		document.forms.contentForm.item_dely_to_location_text[gridIndex].value = zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail;
		for(var k=0; k<tot_cnt; k++){
    		var box = eval("document.forms.contentForm.lnCheck" + k);
    		if(box.checked == true){
    			document.forms.contentForm.item_dely_to_location_code[k].value = "";
		    	document.forms.contentForm.item_dely_to_location_text[k].value = document.forms.contentForm.item_dely_to_location_text[gridIndex].value;
		    	
		    	document.forms.contentForm.item_recv_user[k].value = document.forms.contentForm.item_recv_user[gridIndex].value;
		    	document.forms.contentForm.item_recv_user_phone[k].value = document.forms.contentForm.item_recv_user_phone[gridIndex].value;
    		}
    	}
    }
}
//셀트리온 관리항목 팝업
function getCelltrion(row,ref_no){

    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "관리번호";
		var st_type = "M014";
		var st_code =  "";
		var st_text = document.forms.contentForm.st_ref_pr_no.value;		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,500,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "관리번호";
		var st_type = "M014";
		var st_code =  "";
		var st_text = document.forms.contentForm.st_ref_pr_no[row].value;
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,500,no");
    }
}
//넥센 관리항목 팝업
function getNexe(row,ref_no){

    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "관리번호";
		var st_type = "M014";
		var st_code =  "";
		var st_text = document.forms.contentForm.st_ref_pr_no.value;		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,500,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "관리번호";
		var st_type = "M014";
		var st_code =  "";
		var st_text = document.forms.contentForm.st_ref_pr_no[row].value;
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,500,no");
    }
}
//파일정보 저장
 function saveAttach(g_row){
	
	//alert("g_row " +g_row);
	var refresh_flg = "<%=p060000131_col01%>";
    var st_cstmr_id             = "<%=buyer%>"                                  // 고객사
    var st_user_id              = "<%=userId%>"                                 // 고객사 
    var query                   = "";
    var tot_cnt     =  $("#display_item_cnt").val();
    var st_item_no       = "";
    var st_contract_no   = "";
    var st_contract_seq  = "";
    var imaget_btn_ele   = "";
    if(tot_cnt<=1) {
        st_item_no = document.forms.contentForm.st_item_no.value;
        st_contract_no = document.forms.contentForm.st_contract_no.value;
        st_contract_seq = document.forms.contentForm.st_contract_seq.value;
        image_key = document.forms.contentForm.st_image_key.value;
        st_seq = document.forms.contentForm.st_seq.value;
        imaget_btn_ele = document.getElementsByName('file_button');
    }else {
        st_item_no = document.forms.contentForm.st_item_no[g_row].value;
        st_contract_no = document.forms.contentForm.st_contract_no[g_row].value;
        st_contract_seq = document.forms.contentForm.st_contract_seq[g_row].value;
        image_key = document.forms.contentForm.st_image_key[g_row].value;
        st_seq = document.forms.contentForm.st_seq[g_row].value;
        imaget_btn_ele = document.getElementsByName('file_button')[g_row];
    }
    if(isEmpty(TrimCommon(image_key))) image_key="";
    query +=  image_key             + "@@";
    query +=  st_cstmr_id               + "@@";
    query +=  st_user_id                + "@@";
    query +=  st_contract_no                + "@@";
    query +=  st_contract_seq               + "@@";
    query +=  st_item_no                + "@@";
    query +=  st_seq						+ "@@";
    document.forms.processForm.st_query2.value = query;
    if(refresh_flg == "FILE" && !isEmpty(image_key) && image_key != ''){
    	imaget_btn_ele.className = 'btn_quickbuy mb02'; // 색상 넣기
    	imaget_btn_ele.getElementsByTagName('a')[0].href = "javascript:attach_popup('" + image_key + "','" + g_row + "')"; // a태그 변경
    }
    kepAjaxFormCall("/mpso/getBuyerShoppingcartListAttachUpdate.do","processForm","FILE");  
    
 }
function setDong0121(ref_no, row){
	var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
      document.forms.contentForm.st_ref_pr_no.value = ref_no;
    }else{
      document.forms.contentForm.st_ref_pr_no[row].value = ref_no;
    }
}  


//FAG 관련  PG_06_B_006_03
function getKRFagKorea(row,ref_no)
{ 
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
   if(ref_no == "")
   {
	   if(eval(tot_cnt) < 2){
		 ref_no = document.forms.contentForm.st_ref_pr_no.value;
	   }else{
		 ref_no = document.forms.contentForm.st_ref_pr_no[row].value;
	   }
   }
   
   openSearchPopup("/mpso/showBuyerMpSoFagkbcAccountPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,400,no"); 
	
}

function setKRFagKorea(ref_no, row){

	
	var tot_cnt  = $("#display_item_cnt").val();

    if(eval(tot_cnt) < 2){
      document.forms.contentForm.st_ref_pr_no.value = ref_no;
     var box = eval("document.forms.contentForm.lnCheck0" );
         propCheckBox(box, true);
    }else{
      document.forms.contentForm.st_ref_pr_no[row].value = ref_no;
     var box = eval("document.forms.contentForm.lnCheck" +row);
         propCheckBox(box, true);
    }
}



//INA 관련 PG_06_B_006_04
function getInaKorea(row,ref_no)
{
  	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();	
      if(ref_no == "")
      {
        if(eval(tot_cnt) < 2)
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);

        else
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
      }

      openSearchPopup("/mpso/showBuyerMpSoConsmAccountPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,500,no"); 
}

function setInaKorea(ref_no, row)
{
  var tot_cnt  = $("#display_item_cnt").val();   
  if(eval(tot_cnt) < 2)
  {
    document.forms.contentForm.st_ref_pr_no.value = ref_no;
    var box = eval("document.forms.contentForm.lnCheck0" );
    propCheckBox(box, true);
  }

  else
  {
    document.forms.contentForm.st_ref_pr_no[row].value = ref_no;
    var box = eval("document.forms.contentForm.lnCheck" + row);
    propCheckBox(box, true);
  }
}

//경동보일러,경동정밀 관련 PG_06_B_006_05
function getKyungDong(row,ref_no)
{

	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
      if(ref_no == "")
      {
        if(eval(tot_cnt) < 2)
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);

        else
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
      }

      openSearchPopup("/mpso/showBuyerMpSoKyongDongCostCenterPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,530,no"); 
}

function setKyungDong(ref_no, row){
	var tot_cnt  = $("#display_item_cnt").val();
    var box = eval("document.forms.contentForm.lnCheck" +row);
    propCheckBox(box, true);


    if(eval(tot_cnt) < 2){
        document.forms.contentForm.st_ref_pr_no.value = ref_no;
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" + k);
            if(box.checked == true){
                document.forms.contentForm.st_ref_pr_no[k].value   = ref_no;
            }
        }
    }
}

//동일방직 하이트진로이천공장현장소모품팀 PG_06_B_006_06
function getDongIl(row,ref_no)
{
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
      if(ref_no == "")
      {
        if(eval(tot_cnt) < 2)
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);

        else
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
      }
      openSearchPopup("/mpso/showBuyerMpSoHiteJinroSiteConsmTeamPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,500,no"); 
}


//--홍익대 회계항목 설정 PG_06_B_006_07
function getHongik(row,ref_no){ 

	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	
	if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    
    openSearchPopup("/mpso/showBuyerMpSoHongikAccntngItemPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,200,no"); 
}

function setHongik(ref_no, row,ref_no_text)  {
	var tot_cnt  = $("#display_item_cnt").val();

   var box = eval("document.forms.contentForm.lnCheck" + row);
   propCheckBox(box, true);

    //alert(tot_cnt);
    if(eval(tot_cnt) < 2)     {
      document.forms.contentForm.st_ref_pr_no_text.value = ref_no_text;
      document.forms.contentForm.st_ref_pr_no.value = ref_no;
      var box = eval("document.forms.contentForm.lnCheck0");
      propCheckBox(box, true);
    } else{
      for(var x=0; x<eval(tot_cnt); x++) {
          var box = eval("document.forms.contentForm.lnCheck" + x);
          if(box.checked==true) {
              document.forms.contentForm.st_ref_pr_no_text[x].value = ref_no_text;
              document.forms.contentForm.st_ref_pr_no[x].value = ref_no;
          }
      } 
    }
  }

//--코오롱글로벌CostCenter  PG_06_B_006_08
function getKRINKT0001(row,ref_no)
{ 
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
      if(ref_no == "")
      {
        if(eval(tot_cnt) < 2)
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);

        else
          ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
      }
      openSearchPopup("/mpso/showBuyerMpSoKolonGlobalCostCenterPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no, "500,500,no"); 
      
    //  window.open('/kr/customer/shopping_cart/refno_krinkt0001.jsp?st_buyer='+buyer+"&st_row="+row+"&st_ref_no="+ref_no, 'getKyungDong', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}
function setKRINKT0001(ref_no, row)
{
	var tot_cnt  = $("#display_item_cnt").val();

  if(eval(tot_cnt) < 2)
  {
    document.forms.contentForm.st_ref_pr_no.value = ref_no;
    var box = eval("document.forms.contentForm.lnCheck0" );
    propCheckBox(box, true);
  }

  else
  {
    document.forms.contentForm.st_ref_pr_no[row].value = ref_no;
    var box = eval("document.forms.contentForm.lnCheck" + row);
    propCheckBox(box, true);
  }
}


/*
작 업 일 : 20131206
작 업 자 : 최윤희
작업내역 : 유한킴벌리 관리항목 등록
*/
//유한킴벌리  장바구니 관리번호 선택 팝업 PG_06_B_006_10
function getYuHan(row,ref_no){
 

   	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();	
    var item_no = "";
    var order_qty = "";
    var contract_no = "";
    var contract_seq = "";
    var mg_note = "";
    var yuhan_saperp_flag = "";
    var mg_note_input = "";
    
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
        item_no = document.forms.contentForm.st_item_no.value;
        order_qty = document.forms.contentForm.st_order_qty.value;
        contract_no = document.forms.contentForm.st_contract_no.value;
        contract_seq = document.forms.contentForm.st_contract_seq.value;
        mg_note = document.forms.contentForm.st_mg_note.value;        
        yuhan_saperp_flag = document.forms.contentForm.st_yuhan_saperp_flag.value;
        mg_note_input = document.forms.contentForm.st_mg_note_input.value;
        
		if(yuhan_saperp_flag == ""){
			//SAP ERP 전송대상 품목이 아닙니다.
			alert("<%=CommonLang.msg("MSG157")%>");
			return;
		}
		/*
        if (item_no_YuHanCheck(item_no)==false) {
        	propCheckBox(box, false);
        	return;
        }
        */
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        
        yuhan_saperp_flag = kepTrimStr(document.forms.contentForm.st_yuhan_saperp_flag[row].value);
		if(yuhan_saperp_flag == ""){
			//SAP ERP 전송대상 품목이 아닙니다.
			alert("<%=CommonLang.msg("MSG157")%>");
			return;
		}
		
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
        item_no = document.forms.contentForm.st_item_no[row].value;
        order_qty = document.forms.contentForm.st_order_qty[row].value;
        contract_no = document.forms.contentForm.st_contract_no[row].value;
        contract_seq = document.forms.contentForm.st_contract_seq[row].value;
        mg_note = document.forms.contentForm.st_mg_note[row].value;
        mg_note_input = document.forms.contentForm.st_mg_note_input[row].value;
    }
    
    openSearchPopup("/mpso/getBuyerMpSoYuHanKimChonPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no+"&st_item_no="+item_no+"&st_order_qty="+order_qty+"&st_contract_no="+contract_no+"&st_contract_seq="+contract_seq+"&st_mg_note="+mg_note+"&st_yuhan_saperp_flag="+yuhan_saperp_flag+"&st_mg_note_input="+mg_note_input, "800,550,no"); 
    
}
//작업자 : cck 동화그룹 관리번호팝업
function getDongHwa(row,ref_no,item_no){
   	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();

    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    } 
    openSearchPopup("/mpso/getBuyerMpSoDongHwaPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no+"&st_item_no="+item_no, "800,250,no");   
}
/*
작 업 자 : 현
작업내역 : 일진전기 관리항목추가
*/
function getILJI(row,mg_note){
	var tot_cnt  = $("#display_item_cnt").val();
    var mg_note = "";
    var st_item_no	= "";
    iljin_row = row;
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
        mg_note = document.forms.contentForm.st_mg_note.value;
        st_item_no	= document.forms.contentForm.st_item_no.value;
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
        mg_note = document.forms.contentForm.st_mg_note[row].value;
        st_item_no	= document.forms.contentForm.st_item_no[row].value;
    }
     var st_group = "";
	 var st_delivery_code = "";
	 var st_center = "";
	 var st_acount = "";
	 var st_acount_nm = "";
	 var st_tax = "";
	 var st_tax_nm = "";
	 var st_project = "";
	 var st_project_nm = "";
	 var st_task = "";
	 var st_requester = "";
	 var st_requester_nm = "";
    if(kepTrimStr(mg_note) != ""){
        var mg_arr = mg_note.split("^");   
        st_group = mg_arr[0];
    	st_center = mg_arr[2];       
    	st_acount = mg_arr[3];       
    	st_acount_nm = mg_arr[4];     
    	st_project = mg_arr[5];      
    	st_project_nm = mg_arr[6];  
    	st_task = mg_arr[7];
    	st_requester = mg_arr[8];
    	st_requester_nm = mg_arr[9];
	}

    openSearchPopup("/mpso/getBuyerMpSoILJINchoPop.do","?st_group="+st_group+"&st_delivery_code="+st_delivery_code+"&st_center="+st_center+"&st_acount="+st_acount+"&st_acount_nm="+st_acount_nm+"&st_tax="+st_tax+"&st_tax_nm="+st_tax_nm+"&st_project="+st_project+"&st_project_nm="+st_project_nm+"&st_task="+st_task+"&st_item_no="+st_item_no+"&st_requester="+st_requester+"&st_requester_nm="+ st_requester_nm, "800,250,no"); 
}
/*
작 업 자 : 현
작업내역 : 일진전기 관리항목 셋팅
*/
function setMgnoteReturn(value1, value2){
	var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
    	document.forms.contentForm.st_ref_pr_no_text.value = value1;
        document.forms.contentForm.st_mg_note.value = value2;        
    }else{
        document.forms.contentForm.st_ref_pr_no_text[iljin_row].value = value1;
        document.forms.contentForm.st_mg_note[iljin_row].value = value2;
    }	
}

/*
작 업 자 : HSJ
작업내역 : 영풍 관리번호 코스트센터, WBS 셋팅
*/
function getYpCostCenter(row,ref_no){

    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    popupSel = "yp_cost_center";
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "코스트센터";
		var st_type = "C020";
		var st_code = document.forms.contentForm.st_yp_cost_center.value;
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "코스트센터";
		var st_type = "C020";
		var st_code = document.forms.contentForm.st_yp_cost_center[row].value;
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

function getYpWbs(row,ref_no){

    var tot_cnt  =  $("#display_item_cnt").val();
    iljin_row = row;
    popupSel = "yp_wbs";
    
    if(eval(tot_cnt) < 2){    	 
       var box = eval("document.forms.contentForm.lnCheck0");
       propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "WBS";
		var st_type = "C021";
		var st_code = document.forms.contentForm.st_yp_wbs.value;
		var st_text = "";		
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
		var st_buyer = "<%=buyer%>";
		var st_gbn = "WBS";
		var st_type = "C021";
		var st_code = document.forms.contentForm.st_yp_wbs[row].value;
		var st_text = "";
	    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
    }
}

//예산계정 코스트센터 팝업 - 깨끗한나라
function getRefPrNoKleannara(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoKleannaraPop.do";
    openSearchPopup(url,"?st_ref_no="+ref_no+"&st_buyer="+buyer, "700,210,no"); 
}

//계정 코스트센터 팝업 - LB세미콘주식회사
function getRefPrNoLbse(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfoLbsePop.do";
    openSearchPopup(url,"?st_ref_no="+ref_no+"&st_buyer="+buyer, "700,210,no"); 
}

//계정 코스트센터 계정지정범주 팝업 - (주)한솔홈데코
function getRefPrNohahome(row, ref_no, remark){
	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	iljin_row = row;
	
    if(eval(tot_cnt) < 2){
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    url = "/mpso/getBuyerMpSoRefPrNoInfohahomePop.do";
    openSearchPopup(url,"?st_ref_no="+ref_no+"&st_buyer="+buyer, "700,210,no"); 
}

function item_no_YuHanCheck(item_no){
	//alert(item_no.substring(0,1)); 
	var first = item_no.substring(0,1);
	if (first == "1"){
		return true;
	}else{
		//주문 대상이 아닙니다. 확인부탁드립니다.
		alert("<%=CommonLang.msg("MSG158")%>");
		return false;
	}
}

function setRefInfo(row, ref_no, mg_note){
    var tot_cnt  =$("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
        document.forms.contentForm.st_ref_pr_no.value = ref_no;
        document.forms.contentForm.st_mg_note.value = mg_note;
        var box = eval("document.forms.contentForm.lnCheck0" );
        propCheckBox(box, true);
    }else{
        document.forms.contentForm.st_ref_pr_no[row].value = ref_no;
        document.forms.contentForm.st_mg_note[row].value = mg_note;
        var box = eval("document.forms.contentForm.lnCheck" + row);
        propCheckBox(box, true);
    }
}

function item_qty_updateSel(row){
	lnCheckFalse(); // 전체 선택박스 해제
	
	var st_urct2_yn = ""; //URCT2 여부 확인
	
	var tot_cnt  =$("#display_item_cnt").val();
	if(eval(tot_cnt) < 2){
		st_urct2_yn = document.forms.contentForm.st_urct2_yn.value;
    }else{
    	st_urct2_yn = document.forms.contentForm.st_urct2_yn[row].value;
    }
	
	if(st_urct2_yn != "Y"){
		alert("<%=CommonLang.msg("MSG588")%>"); //주문할 수 없는 카테고리의 상품입니다.
		return;
	}
	
    var box = eval("document.forms.contentForm.lnCheck" + row);
    propCheckBox(box, true);    
	<% 
	if(p060000117 == true){
	%>
		doAction('ORDER');
	<%
	}else{
		if(userRole2.equals("+")) {
	 		if(st_query_cart.equals("ALL")){
	%>
				doAction('CART');
	<%  	}else{          %>
				doAction('ORDER');
	<%      }
		}
	}
	%>  
}
 
function setMyCatalogRegSel(row){	
	lnCheckFalse(); // 전체 선택박스 해제
	var st_urct2_yn = ""; //URCT2 여부 확인
	
	var tot_cnt  =$("#display_item_cnt").val();
	if(eval(tot_cnt) < 2){
		st_urct2_yn = document.forms.contentForm.st_urct2_yn.value;
    }else{
    	st_urct2_yn = document.forms.contentForm.st_urct2_yn[row].value;
    }
	
	if(st_urct2_yn != "Y"){
		alert("<%=CommonLang.msg("MSG588")%>"); //주문할 수 없는 카테고리의 상품입니다.
		return;
	}
	
    var box = eval("document.forms.contentForm.lnCheck" + row);
    propCheckBox(box, true);    
    doAction('setMyCatalogReg'); 
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
	 
    if(sMsg == "CREATE_OK"){ // asis = setCartResult_Refresh
    	
       if(pMethod == "RsaveProcess")  // 나의상품 등록
       { 
    	   //나의상품으로 등록 되었습니다.   
    	   alert("<%=CommonLang.msg("MSG23")%>");            
       } 
        
    }else if (sMsg == "UPDATE_OK") { // asis setQtyUpdateResults -- 저장,바로주문
    	  if(pMethod == "CART"){
              if(eval(tot_cnt) < 2){
                  var box = eval("document.forms.contentForm.lnCheck0");
                  var st_item_no   = document.forms.contentForm.st_item_no.value;
                  var st_contract_no = document.forms.contentForm.st_contract_no.value;
                  var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
				  var st_seq = document.forms.contentForm.st_seq.value;

                  if(box.checked == true){
                	  query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_seq +"@@";
                  }
              }else{

                  for(var j = 0; j < tot_cnt; j++){
                      var box = eval("document.forms.contentForm.lnCheck" + j);
                      var st_item_no   = document.forms.contentForm.st_item_no[j].value;
                      var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
                      var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
                      var st_seq = document.forms.contentForm.st_seq[j].value;

                      if(box.checked == true){ 
                    	  query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_seq + "@@";
                      }
                  }//END FOR
              }//END IF

               
              document.forms.locationForm.st_query_cart.value = query;  
              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;
              //선입고 장바구니 구분 추가. st_pre_gr_flag ="Y"면 선입고 장바구니
              document.forms.locationForm.st_pre_gr_flag.value = document.forms.searchForm.st_pre_gr_flag.value;
              // 질문 -- 배송정보
              //PG_06_B_007_00
              $('#locationForm').attr("action", "/mpso/getBuyerMpSoDlvryInfo.do").submit();   

           }else if(pMethod == "ORDER"){
               if(eval(tot_cnt) < 2){
                    var box = eval("document.forms.contentForm.lnCheck0");
                    var st_item_no   = document.forms.contentForm.st_item_no.value;
                    var st_contract_no = document.forms.contentForm.st_contract_no.value;
                    var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
                    var st_seq = document.forms.contentForm.st_seq.value;
					
                    if(box.checked == true){
                    	query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_seq + "@@";
                    }
               }else{
                    for(var j = 0; j < tot_cnt; j++){
                       var box = eval("document.forms.contentForm.lnCheck" + j);
                       var st_item_no   = document.forms.contentForm.st_item_no[j].value;
                       var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
                       var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
                       var st_seq = document.forms.contentForm.st_seq[j].value;
						
                       if(box.checked == true){
                    	   query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_seq +"@@";
                       }
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
              
              
              document.forms.locationForm.st_query_cart.value = query;  
              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;  
              
              // 질문
             // document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_list.jsp";     
             //alert("buyer_delivery_list 로 이동"); 
             //PG_06_B_008_00
              $('#locationForm').attr("action", "<%=h_sslurl%>/mpso/getBuyerMpSoOrderInfoList.do").submit();   
              
           }else if(pMethod == "PrSheet") {
				cartPrSheet();//***********************              
           }else if(pMethod == "SAVE") {
        	   // 정상적으로 저장되었습니다.
               alert("<%=CommonLang.msg("MSG76")%>");
             	 // 처리후 재조회
             	 kepSearch($("#curPage").val()); 
          	 
           }else if(pMethod == "DELETE") { // asis setResulte -- 삭제
        	   // 정상적으로 삭제되었습니다.   
        	   alert("<%=CommonLang.msg("MSG75")%>");
        	   var chk_cnt = getCheckedRowCount(tot_cnt);
        	   if( tot_cnt == chk_cnt ) allDelFlag = "Y";
        	    var buyer       = $("#st_buyer").val();  
        	    if(buyer == "KRHONG0020" && allDelFlag == "Y"){
              	$('#locationForm').attr("action", "/mpso/getBuyerMpSoOrderDetailHongikList.do").submit();    
        	    }else{
             	 // 처리후 재조회
             	 kepSearch($("#curPage").val()); 
        	    }
           }else if(pMethod == "TRANS") {
        		// 정상적으로 전송되었습니다.
               alert("<%=CommonLang.msg("MSG159")%>");
               // 처리후 재조회
               kepSearch($("#curPage").val()); 
           }else if(pMethod == "CHECKOUT" || pMethod == "CHECKOUTTEST") {
        		// 정상적으로 전송되었습니다.
               alert("<%=CommonLang.msg("MSG159")%>");
               // 처리후 재조회
               kepSearch($("#curPage").val()); 
           }
      } else {
    	  if(pMethod == "FILE" && pMethod == "<%=p060000131_col01%>"){ // 화면 비갱신 특수로직 처리 p06-0000131
    		 //  화면을 갱신하지 않음
    	  }else{ // 기존처리
    		  if(pMethod == "RsaveProcess")
              {
            	 //품목코드 () 은 이미 나의 상품으로 저장된 항목입니다.  
            	 alert("<%=CommonLang.msg("MSG352")%>" + sMsg + "<%=CommonLang.msg("MSG353")%>");
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
	
	if (pMethod == "RsaveProcess"){ 
		//나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG27")%>"); 
	} else if (pMethod == "DELETE"){ 
		//삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG162")%>"); 
	} else if (pMethod == "CART" || pMethod == "SAVE"){ 
		//장바구니에서 바로주문 오류 시 메세지 전송
		 alert(response.Message);
	} else{	    
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 alert("<%=CommonLang.msg("MSG163")%>"); 
	}
} 

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function  attach_popup(img_key,obj1){		
	var type = "PR"; ///////////// ??????????
	var viewType = "C";
	gridIndex = obj1;
	popupSel = "attach";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

/**
 * 첨부파일 구현
 */
function gridPopOpen(obj1){ 
 gridIndex = obj1;
 popupSel = "attach";
 attach_popup($("input[name=st_image_key]").eq(gridIndex).val(), gridIndex);
}

// 에스와이에스리테일(KRSYSR0001), 솔라엣지 사무용품(KRSOLA0011) 명함 정보 입력 팝업
function getNameCardPop(obj1, seq, type){
	gridIndex = obj1;
	popupSel = "namecard_info";
	var remark = $("form[name=contentForm]").find("input[name=st_remark]").eq(obj1).val();
	var remark_arr = remark.split(";");
	var param_seq = 0; // 텍스트값 전달용(팝업에서 콤보박스 값 찾기 위함)
	var param_text = "";
	
	if(type == "BRAN"){ // 영업점
		popupUrl = "/mpso/getBuyerMpSoNameCardPop.do";
		param_seq = 4; // (0부터시작) 5번째 파라미터 정보 필요(직위)
		option = "650,450,no";
	}else if(type == "CLNK" || type == "HAAC"){ // 클린킹_가정에어컨
		popupUrl = "/mpso/getBuyerMpSoNameCardCkAcPop.do";
		param_seq = 2; // (0부터시작) 3번째 파라미터 정보 필요(물류센터명)
		option = "650,200,no";
	}else if(type == "HDQT" || type == "HOLD"){ // 본사_홀딩스
		popupUrl = "/mpso/getBuyerMpSoNameCardHdQtPop.do";
		option = "650,350,no";
	}else if(type == "HMDT"){ // 홈닥터
		popupUrl = "/mpso/getBuyerMpSoNameCardHmDtPop.do";
		option = "650,350,no";
	}else if(type == "BRMG"){ // 영업점 점장
		popupUrl = "/mpso/getBuyerMpSoNameCardBrMgPop.do";
		param_seq = 4; // (0부터시작) 5번째 파라미터 정보 필요(직위)
		option = "650,680,no";
	}else if(type == "SOLA"){ // 솔라엣지 사무용품
		popupUrl = "/mpso/getBuyerMpSoNameCardSolaPop.do";
		param_seq = 8;
		option = "800,280,no";
	}else if(type.includes("HANS") || type == "HAND"){ // 한샘
		popupUrl = "/mpso/getBuyerMpSoNameCardHansPop.do";
		param_seq = 8;
		option = "800,280,no";
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
	var st_remark = $("form[name=contentForm]").find("input[name=st_remark]").eq(obj1).val();
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
	}else if(type == "CLNK"){ // 클린킹
		arr_length = 4;
	}else if(type == "HAAC"){ // 가정에어컨
		arr_length = 5;
	}else if(type == "HDQT" || type == "HOLD"){ // 본사_홀딩스
		arr_length = 12;
	}else if(type == "HMDT"){
		arr_length = 10;
	}else if(type == "BRMG"){ // 영업점 점장
		arr_length = 26;
	}else if(type == "SOLA"){ // 솔라엣지 부르기용
		arr_length = 9;
	}else if(type.includes("HANS") || type == "HAND"){ // 한샘, 한샘_개발
		arr_length = 9;
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
		alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
		return;
	}else{
		alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
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

// 비고 팝업
function setPoRemark(row, seq, remark) {
	
	var tot_cnt = $("#display_item_cnt").val();
	var pr_remark = '';
	gridIndex = row;
	
	if(eval(tot_cnt) < 2){
		pr_remark = document.forms.contentForm.st_remark.value;
	}else{
		pr_remark = document.forms.contentForm.st_remark[row].value;
    }
	openSearchPopup('/mppo/showBuyerMpPoOrderPrRemarkInsPop.do','?pr_remark='+pr_remark , "500,250,no");
}

// 비고 저장
function checkOnePr(remark) {
	var tot_cnt = $("#display_item_cnt").val();
	var y_position  = gridIndex;
	
	<% 
	if(p060000120 == true){
	%>
		// 체크한 것 비고 복사
		for(var k = 0; k < tot_cnt; k++){
	            var box = eval("document.forms.contentForm.lnCheck" + k);
	            if(tot_cnt > 1) {
	    			document.forms.contentForm.st_remark[y_position].value = remark;
	    			changeIcon(y_position);
	    	        
	    	    }else {
	    			document.forms.contentForm.st_remark.value = remark;
	    			changeIcon(y_position);
	    	    }
	            if(box.checked == true){
	            	document.forms.contentForm.st_remark[k].value = remark;
	   			    changeIcon(k); 
	            }
		}
		//
	<%} else {%>	
	    if(tot_cnt > 1) {
			document.forms.contentForm.st_remark[y_position].value = remark;
			changeIcon(y_position);
	        
	    }else {
			document.forms.contentForm.st_remark.value = remark;
			changeIcon(y_position);
	    }
	<%} %>
}

// 비고에 따른 아이콘 변경
function changeIcon(y_position){
	var tot_cnt  = $("#display_item_cnt").val();
	if(tot_cnt > 1) {
		var pr_remark = document.forms.contentForm.st_remark[y_position].value;
		if(TrimCommon(pr_remark)){
			document.getElementsByName('Image2')[y_position].className = "btn_quickbuy mb02";
		}else{
			document.getElementsByName('Image2')[y_position].className = "btn_wishproduct mb02";
		}
    }else {
		var pr_remark = document.forms.contentForm.st_remark.value;
		if(TrimCommon(pr_remark)){
			document.getElementsByName('Image2')[y_position].className = "btn_quickbuy mb02";
		}else{
			document.getElementsByName('Image2')[y_position].className = "btn_wishproduct mb02";
		}
    }   
}

// 구매사유 팝업
function setPrReason(row, seq, remark) {
	var tot_cnt = $("#display_item_cnt").val();
	var pr_reason = '';
	gridIndex = row;
	
	if(eval(tot_cnt) < 2){
		pr_reason = document.forms.contentForm.st_pr_reason.value;
	}else{
		pr_reason = document.forms.contentForm.st_pr_reason[row].value;
    }
	openSearchPopup('/mppo/showBuyerMpPoOrderPrReasonPop.do','?pr_reason='+pr_reason , "500,200,no");
}

// 구매사유 저장
function checkOnePrReason(reason) {
	var tot_cnt = $("#display_item_cnt").val();
	var y_position  = gridIndex;
	
<%if(bca00003 == true){%>
	// 체크한 것 비고 복사
	for(var k=0; k<tot_cnt; k++){
		var box = eval("document.forms.contentForm.lnCheck" + k);
			if(tot_cnt > 1){
				document.forms.contentForm.st_pr_reason[y_position].value = reason;
				changeIconReason(y_position);
			}else{
				document.forms.contentForm.st_pr_reason.value = reason;
				changeIconReason(y_position);
			}
			
			if(box.checked == true){
				document.forms.contentForm.st_pr_reason[k].value = reason;
				changeIconReason(k);
			}
		}
	//
<%}else{%>
	if(tot_cnt > 1) {
		document.forms.contentForm.st_pr_reason[y_position].value = reason;
		changeIconReason(y_position);
	}else{
		document.forms.contentForm.st_pr_reason.value = reason;
		changeIconReason(y_position);
	}
<%}%>
}

// 구매사유에 따른 아이콘 변경
function changeIconReason(y_position){
	var tot_cnt  = $("#display_item_cnt").val();
	if(tot_cnt > 1) {
		var pr_reason = document.forms.contentForm.st_pr_reason[y_position].value;
		if(TrimCommon(pr_reason)){
			document.getElementsByName('Image3')[y_position].className = "btn_quickbuy mb02";
		}else{
			document.getElementsByName('Image3')[y_position].className = "btn_wishproduct mb02";
		}
    }else {
		var pr_reason = document.forms.contentForm.st_pr_reason.value;
		if(TrimCommon(pr_reason)){
			document.getElementsByName('Image3')[y_position].className = "btn_quickbuy mb02";
		}else{
			document.getElementsByName('Image3')[y_position].className = "btn_wishproduct mb02";
		}
    }
}

function getDeliveryToLocation(row, com_code){
	popupSel = "location";
	gridIndex = row;
	openSearchPopup("/common/delLocationPop.do", "?com_code="+com_code+"&open=Y", "800,500,no");
}

function getOrderDelyToLocation(row, com_code){
	popupSel = "orderLocation";
	gridIndex = row;
	openSearchPopup("/common/orderDelLocationPop.do", "?com_code="+com_code+"&open=Y", "800,500,no");
}
function getnewzipCode(row, com_code){
	popupSel = "newzipCode";
	gridIndex = row;
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");
}

function excelDown(){
	document.forms.searchForm.action = "/mpso/excelBuyerMpSoCartList.do";
	document.forms.searchForm.submit();
}

// 체크박스 체크 함수
function propCheckBox(ele, changeFlg){
	var p060000133 = "<%=p060000133%>";
	if(p060000133 == "true"){ 
		var p060000133_alert_flg = true;
		var inputs = document.querySelectorAll('input[name^="lnCheck"]'); // 장바구니 체크박스의 element_name [lnCheck%] 기준
		for(var i = 0; i < inputs.length; i++){
			if(inputs[i].checked){
				p060000133_alert_flg = false;
			}
		}
		if(p060000133_alert_flg && inputs.length != 1){
			alert("<%=CommonLang.msg("MSG593")%>");
		}
	}else{ // 장바구니 자동 체크해제 대상이 아니라면 자동 체크
		ele.checked = changeFlg;
	}
}
</script>
</html>