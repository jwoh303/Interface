<%--
**********************************************
* 메뉴 : 주문관리>장바구니>주문정보/배송정보
* 화면 : 주문정보/배송정보
* 기능 : 구매요청 전 최종 주문정보화 배송정보를 확인한다.
* 프로그램 ID : PG_06_B_008_00
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-06-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head> 
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과	 
	String pre_goods_count = (String)request.getAttribute("pre_goods_count"); //선입고발주 제외대상 업체 조회
	//선입고장바구니에서 넘오온건이면 선입고 발주 필수.
	String st_pre_gr_flag= (String) request.getAttribute("HdataPreGrFlag");
	String Hdata = "";
	Hdata = (String)request.getAttribute("Hdata"); // 홍익대학교-- 대학원 소속 체크	
	String total_cnt = "0"; // 총 조회수 (필수)
	if (_gridList != null){
		total_cnt = String.valueOf(_gridList.size());
	}	
	String st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");    
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
    String userName = "";
    String row_cnt = ""; 
    String person_author  = "";
    String empNo	= "";
    
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag());  // 20070704 이미지보기 우선여부
		buyer  = SessionComCode;
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag()); // 고객사 예산 사용여부 
		userRole = CommonUtil.nvl((String)sessionInfo.getRole()); 
		userId = CommonUtil.nvl((String)sessionInfo.getUserId());  
		userName = (String)sessionInfo.getUserNameLoc();
	    row_cnt =  CommonUtil.nvl((String)sessionInfo.getRowCnt());  //20070704 추가 페이지 기본 개수	    
	    person_author      =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());
	    empNo	= CommonUtil.nvl((String)sessionInfo.getEmpNo());
	}  
	
    if(st_image_status.equals(""))
    { 
        st_image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
    }
    
	//홍익대학교-- 대학원 소속 체크.

	String hongikType = "N";
	if(buyer.equals("KRHONG0020")) hongikType =Hdata;
	
    String verif_num				= CommonUtil.nvl((String) request.getParameter("st_verif_num"),"");
	String st_location_code			= CommonUtil.nvl((String) request.getParameter("st_location_code"),sessionInfo.getDelyToLocation());
    String st_location_type			= CommonUtil.nvl((String) request.getParameter("st_location_type"),"");
    String st_location_name			= CommonUtil.nvl((String) request.getParameter("st_location_name"),sessionInfo.getDelyToLocationName());
	String st_location_code_name	= CommonUtil.nvl((String) request.getParameter("st_location_code_name"), sessionInfo.getDelyToLocationCodeName());
    String st_tel_no				= CommonUtil.nvl((String) request.getParameter("st_tel_no"), sessionInfo.getTel());
    String st_fax_no				= CommonUtil.nvl((String) request.getParameter("st_fax_no"), sessionInfo.getFax());
    String st_mobile_no				= CommonUtil.nvl((String) request.getParameter("st_mobile_no"),sessionInfo.getmPhone());
    String st_user_name				= CommonUtil.nvl((String) request.getParameter("st_user_name"),sessionInfo.getUserNameLoc());
    String st_email					= CommonUtil.nvl((String) request.getParameter("st_email"),sessionInfo.getEmail());
    String st_query_cart			= CommonUtil.nvl((String) request.getParameter("st_query_cart"),"");
    String st_query_cart_date		= CommonUtil.nvl((String) request.getParameter("st_query_cart_date"),"");
    String st_query_cart_date_item	= CommonUtil.nvl((String) request.getParameter("st_query_cart_date_item"),"");
    String st_recv_date				= CommonUtil.nvl((String) request.getParameter("st_recv_date"),"");
    String st_recv_date2			= CommonUtil.nvl((String) request.getParameter("st_recv_date2"),"");
    String st_remark				= CommonUtil.nvl((String) request.getParameter("st_remark"),"");
    String purchase_dept_name		= CommonUtil.nvl((String) request.getParameter("st_purchase_dept_name"), sessionInfo.getPurchaseDeptName());
    String purchase_dept_code		= CommonUtil.nvl((String) request.getParameter("st_purchase_dept_code"),sessionInfo.getPurchaseDept());
    String st_check					= CommonUtil.nvl((String) request.getParameter("st_check"),"PAGE_SEARCH");        
    
    String seq_flag = "N";
    
    // 장바구니 파라미터로 SEQ 사용 여부 확인(구분자 &&로 넘김) 
    if (st_query_cart.indexOf("&&") > -1) {
    	seq_flag = "Y";
	}
    
	int rec_cnt =  0;
	String item_name = "";
	String contract_no = "";
	String contract_seq = ""; 
	if (_gridList != null){
		if (_gridList.size()>0){
			Map<String,String> rowItemData = _gridList.get(0); 
			if (rowItemData != null){
				
				contract_no = rowItemData.get("CONTRACT_NO");			
				contract_seq = rowItemData.get("CONTRACT_SEQ");			
				
				rec_cnt = _gridList.size();			
				if(rec_cnt > 1){	
					item_name =  rowItemData.get("DESCRIPTION_LOC") + " 외";	
				}else{	
					item_name =   rowItemData.get("DESCRIPTION_LOC");	
				}
			}
		}
	} 
	
	double tot_price = 0;
	String account_type = "";
	String bdgt_flag = "";
		
    boolean p060000034 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000034"); // KRDAEW0023 KRDAEW0043 KRDAEW0045
    boolean p060000032 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000032"); // KRCOWA0001 KRCOWA0005 KRCOWA0006
    boolean p060000043 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000043"); // KRCOLL0001 - PARKEJ
    boolean p060000044 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000044"); // KRKOLO0031 구매발주?? - 1199038
    boolean p060000045 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000045"); // KRDONG0107 KRDONG0128
    boolean p060000046 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000046"); // KRCONT0006 KRCONT0007
    boolean p060000047 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000047"); // KRMEGA0005
    boolean p060000048 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000048"); // KRDOOS0020
//    boolean p060000062 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000062"); // 주문시 고객사 결재시스템 호출 : 광동제약 (KRKWAB0001), 일진전기 예정
    
//    String p060000062_url	= CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000062","COL01_DATA", request));
//    String p060000062_yn	= CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000062","COL02_DATA", request));

	String p060000062_url	= "";
	String p060000062_yn	= "";
	String p060000062_type	= "";
	String p060000062_option	= "";
	String dongwha_url = "";
	boolean p060000062		= false;
	boolean p110000004		= false;
	boolean p110000004_type6	= false;
	boolean p110000004_type8	= false;
	boolean p110000004_type9	= false;
	boolean p110000004_type10	= false;
	boolean p110000004_type11	= false;
	boolean p110000004_type12	= false;
	boolean p110000004_type14	= false;
	boolean p110000004_type16	= false;
	/* KCTech */
	boolean p110000004_type17	= false;
	boolean p110000004_type20	= false;
	boolean p110000004_type22	= false;
	boolean p110000004_type23	= false;
	
    Map<String, String> p060000062_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000062");
    Map<String, String> p110000004_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P11-0000004");
    //신용카드, 계좌이체 결재수단 COL01_DATA=Y 결재 필수
    Map<String, String> p060000043_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000043");
    boolean p060000043_yn		= false;
    
    if (p060000062_map != null) {
    	p060000062_url	= CommonUtil.nvl(p060000062_map.get("COL01_DATA"));
    	p060000062_yn	= CommonUtil.nvl(p060000062_map.get("COL02_DATA"));
    	p060000062_type	= CommonUtil.nvl(p060000062_map.get("COL03_DATA"));
    	p060000062_option	= CommonUtil.nvl(p060000062_map.get("COL04_DATA"));
    	p060000062		= true;
    }
    
    if (p110000004_map != null) {
    	if ("TYPE03,TYPE04".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    	}
    	if ("TYPE06".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type6 = true;
    	}
    	if ("TYPE08".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type8 = true;
    	}
    	if ("TYPE09".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type9 = true;
    	    dongwha_url = CommonUtil.nvl(p110000004_map.get("COL02_DATA"));
    	}
    	if ("TYPE10".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type10 = true;
    	}
    	if ("TYPE11".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type11 = true;
    	}
    	if ("TYPE12".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type12 = true;
    	}
    	if ("TYPE14".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type14 = true;
    	}
    	if ("TYPE16".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type16 = true;
    	}
    	/* KCTech */
    	if ("TYPE17".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		p110000004 = true;
    		p110000004_type17 = true;
    	}
    	if ("TYPE20".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		//p110000004 = true;
    		p110000004_type20 = true;
    	}
    	if ("TYPE22".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		//p110000004 = true;
    		p110000004_type22 = true;
    	}
    	if ("TYPE23".indexOf(CommonUtil.nvl(p110000004_map.get("COL01_DATA"))) > -1 ) {
    		//p110000004 = true;
    		p110000004_type23 = true;
    	}
    }
    
    //결재수단 Y면 필수 결재
    if (p060000043_map != null) {
    	if ("Y".equals(CommonUtil.nvl(p060000043_map.get("COL01_DATA")))) {
    		p060000043_yn = true;
    	}
    }
    
  	//SLOGIC-BEGIN(P06-0000036)
    String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
    String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL04_DATA", request); // 권한별URL
    if (p060000036 == null){
    	p060000036 = defaultUrl;
    }else if ("".equals(p060000036)){
    	p060000036 = defaultUrl;
    }
    //SLOGIC-END
    
    boolean submitFlag = false;
    
    String st_server_flag	= CommonUtil.getDevRealLocalFlag(request);
    
	// 품목별 도착지 지정(TYPE 상관없이 공통)
	boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
	// 결재필수 여부 고객사 타입
	String p060000105 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000105","COL01_DATA", request);
	String pm_attach_yn = "N";//품의 첨부파일 필수여부 체크
	
	// 납기요청일 통제
	boolean p060000117 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000117");
	/* ***** 현재 페이지의 배송정보 수정을 위해서 추가 ***** */
	boolean p060000041 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000041"); // KRDAEW0080 KRDAEW0081 KRDAEW0082
	
	//SLOGIC-BEGIN(P06-0000075) - 고객사에 따른 도착지 선택 버튼 라벨명 변경
	String default_dely_location = CommonLang.get("HTITLE485");	//도착지 선택
	String p060000075 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000075","COL01_DATA", request); // KRDAED0079
	boolean p060000075_1 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000075"); // KRDAED0079
	if (p060000075 == null){
		p060000075 = default_dely_location;
	}else if ("".equals(p060000075)){
		p060000075 = default_dely_location;
	}
	
	//요청자 정보 비고 자동 셋팅.
	boolean p060000074 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000074");
	//p060000083 배송지 수정 불가 SLOGIC
	boolean p060000083= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000083");
	//배송정보 인수자명/ 주문자 명칭 변경
	boolean p060000095= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000095");
	//SLOGIC-END
	/* ******************************************** */
	
	// 발주 알림 메세지
	String p060000118 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000118","COL01_DATA"); // 카테고리 코드
	String p060000118_p = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000118","COL02_DATA"); // 문구
	boolean po_alarm_flag = false;
	
	// 특이사항 명칭 변경
	Map<String, String> p060000122_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000122");
	String p060000122_col1 = ""; // 특이사항 명칭 변경 값
	String p060000122_col2 = ""; // default value 값
    if (p060000122_map != null){
    	p060000122_col1 = CommonUtil.nvl(p060000122_map.get("COL01_DATA"),""); 
    	p060000122_col2 = CommonUtil.nvl(p060000122_map.get("COL02_DATA"),"");
    }
	
	
 	// 발주부서 명칭 변경
  	Map<String, String> p060000126_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000126");
  	String p060000126_col1 = ""; // 특이사항 명칭 변경 값
  	
     if (p060000126_map != null){
     	p060000126_col1 = CommonUtil.nvl(p060000126_map.get("COL01_DATA"),"");
     }

%> 
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="UTF-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	
	<div class="btnArea">
	   <div class="fl">
		<h3><%=CommonLang.get("HTITLE835") %><!-- 주문정보 --></h3>
		</div>
		<div class="fr">	
			<span class="btn_reset" title="변경"><a href="javascript:order_info_modify();"><%=CommonLang.get("HTITLE836") %><!-- 품목변경 --></a> </span>
		</div>
	</div>
	 
	<!--조회영역-->
	<form name = "contentForm" id="contentForm" method = "post">
		<!--HIDDEN-->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
		<!-- 경동 결재관련 변수-->

		<input type="hidden" name="cmd"						value="iPR">
		<input type="hidden" name="buyer"					value="">
		<input type="hidden" name="prNo"					value="">
		<input type="hidden" name="pxNo"					value="">

		<!-- 경동 결재관련 변수-->
		<input type="hidden" name="st_check" value="<%=st_check%>">
		<input type="hidden" name="st_person_author" value="<%=person_author%>"> 
		<input type="hidden" name="st_buyer" value="<%=buyer%>">
		<input type="hidden" name="st_user_dept" value="<%=user_dept%>">
		<input type="hidden" name="st_byca_comorg_code" value="<%=byca_comorg_code%>">
		<input type="hidden" name="st_pr_no" value=""> 
		<input type="hidden" name="st_user_id" value="<%=userId%>">
		<input type="hidden" name="st_query_cart" id="st_query_cart" value="<%=st_query_cart%>">
		<input type="hidden" name="st_query_cart_date" id="st_query_cart_date" value="<%=st_query_cart_date%>"> 
		<input type="hidden" name="st_query_cart_date_item" id="st_query_cart_date_item" value="<%=st_query_cart_date_item%>"> 
		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=st_image_status%>"> 
		<input type="hidden" name="st_location_type" value="<%=st_location_type%>">
		<input type="hidden" name="recvFlag" value="">
		<input type="hidden" name="GW_NO" value=""> 
		<input type="hidden" name="st_gr_flag" value=""> 
		<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
		<input type="hidden" name="st_po_create_date" value="<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>">
		<input type="hidden" name="st_hongik_type" value="<%=hongikType%>">
		<input type="hidden" name="st_verif_num" value="<%=verif_num%>">
		
	<%if(p060000117 != true){ %>
		<input type="hidden" name="st_recv_date" value="<%=st_recv_date%>">
		<input type="hidden" name="st_recv_date2" value="<%=st_recv_date2%>">
		<input type="hidden" name="st_user_name" value="<%=st_user_name%>">
		<input type="hidden" name="st_tel_no" value="<%=st_tel_no%>"> 
		<input type="hidden" name="st_fax_no" value="<%=st_fax_no%>"> 
		<input type="hidden" name="st_mobile_no" value="<%=st_mobile_no%>">
		<input type="hidden" name="st_email" value="<%=st_email%>">
		<input type="hidden" name="st_purchase_dept_name" value="<%=purchase_dept_name%>"> 
		<input type="hidden" name="st_purchase_dept_code" value="<%=purchase_dept_code%>">
		<input type="hidden" name="st_location_name" value="<%=st_location_name%>">
		<input type="hidden" name="st_location_code" value="<%=st_location_code%>">
		<input type="hidden" name="st_location_code_name" value="<%=st_location_code_name%>">
		<input type="hidden" name="st_remark" value="<%=st_remark%>">
		<input type="hidden" name="st_remark2" value="">
	<%} %>
		
		<!-- 신용카드결제 변수 -->
		<input type="hidden" name="st_item_name"  value="<%=item_name%>">
		<input type="hidden" name="st_mg_note"		value=""> 
		<input type="hidden" name="st_ref_pr_no"		value=""> 
		<input type="hidden" name="card_cd"		value=""> 
		<input type="hidden" name="card_name"		value=""> 
		<input type="hidden" name="tno"		value=""> 
		<input type="hidden" name="amount"		value="">
		<!-- 신용카드결제 변수 -->
		<input type="hidden" name="st_pre_gr_flag"		value="<%=st_pre_gr_flag%>"> 
		
	  	<!--데이타그리드-->
		<div class="fl">
			<span class="btn_imghide">
			<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
			<a href="javascript:imageHideView();"  title="이미지보이기" ><%=CommonLang.get("HTITLE9") %><!-- 이미지보이기 --></a>
			<%  }else{   %>
			<a href="javascript:imageHideView();"  title="이미지감추기" ><%=CommonLang.get("HTITLE167") %><!-- 이미지감추기 --></a>
			<%  }   %>
			</span>
		</div>
			      
		<div class="fr">		
				      	
			<% if(p060000034 == true){ //SLOGIC-BEGIN(P06-0000034) %>
			<a href="javascript:category_list_pop()"><b><%=CommonLang.get("HTITLE172") %><!-- 총 금액 --> :</b></a>  
			<input type="text" name="check_sum_price" class="input_type_text" size="14" value="원"  style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right" READONLY>
			<input type="hidden" name="st_check_sum_price"  value=""> 
			<%  }else{  %>
			<%=CommonLang.get("HTITLE594") %><!-- (기준 : 원) --> 
			<%  } 	//SLOGIC-END%>
		  
		</div>
	  	<table class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="5%" />
				<col width="25%" />
			<%if(p060000117 == true){ %>
				<col width="9%" />
			<%} %>
				<col width="15%" />
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="5%" />
			</colgroup>
			<thead>
               <tr>
					<th scope="col">&nbsp;</th>
					<th scope="col"><%=CommonLang.get("HTITLE19") %><!-- 품목코드 / 품목명 / 규격 --></th>
				<%if(p060000117 == true){ %>
					<th scope="col">납기일</th>
				<%} %>
					<th scope="col"><%=CommonLang.get("HTITLE31") %><!-- 협력사/단위 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 -->/<%=CommonLang.get("HTITLE175") %><!-- 구매수량 --></th>
					<th scope="col">
				<% if(hongikType.equals("Y")){ %>					 
					<%=CommonLang.get("HTITLE629") %><!-- 구매액/대학원 학과 -->
				<% }else{ %>
					<%=CommonLang.get("HTITLE176") %><!-- 구매액 -->
				<% } %>   
				</th>
					<%if(p060000117 == true){ %>
                   		<th scope="col"><%=CommonLang.get("HTITLE959") %><!-- 표준납기일 --></th>
                   <%}else{ %>
                   		<th scope="col"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></th>
                   <%} %>
                   <th scope="col"><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>
                </tr>
			<%
			if (_gridList == null || rec_cnt == 0){
			%>
				<tr>
					<td colspan="7" align="center" height = "50"> 
						<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
					</td> 
				</tr>
			<% } else {
				submitFlag = true;
				Map<String,String> rowData = null;
				for (int j=0; j<rec_cnt; j++) {
					rowData = _gridList.get(j);
					String tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA"; 
					tot_price += Double.parseDouble( rowData.get("TOT_SUM") );
					account_type = rowData.get("ACCOUNT_TYPE");
					bdgt_flag    = rowData.get("BDGT_FLAG");
					
					String cart_account_type= CommonUtil.nvl(rowData.get("CART_ACCOUNT_TYPE")); //장바구니 계정코드
					//첨부파일 결재 필수 체크
					if(p060000105.equals("A001")){//TYPE =A001
						//계정코드 64로 시작할경우 결재 첨부 필수
						if(cart_account_type.length() > 1){
							String cart_account_type_2 = cart_account_type.substring(0,2);
							 if(cart_account_type_2.equals("64")){
								 pm_attach_yn = "Y";
							 }
						}
						//금액 500만원 이상일경우 결재 첨부필수
						 if(tot_price > 5000000){
							 pm_attach_yn = "Y";
						 }
					}
					
					// 특정 카테고리 코드 발주시 알람메시지 
					if(p060000118.contains(rowData.get("CATEGORY_NO"))){ // 카테고리 코드가 포함되어 있으면 true
						po_alarm_flag = true;	
					}
			%> 
				<tr bgcolor="<%=tclass%>">
                	<td  title="이미지" >
					<% if(st_image_status.equals("IMAGE_HIDDEN")){
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
						<img src="/resources/images/but_img_off.gif" border="0">
					<%     }else{ %>
						<a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
							<img src="/resources/images/but_img_on.gif" border="0">
						</a>
					<%     }
					   }else{
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){ 	%>
						<img src="/resources/images/noimage.gif" width="50" height="50" class="PDimg">
					<% 	}else{ %>
						<a href="javascript:getBigImage('<%=rowData.get("IMGFILE_DIR")%>','<%=rowData.get("IMGFILE_NAME")%>');">
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/"+rowData.get("IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="50" height="50" border="0">
						</a>

					<%  }
					   }
						String tmpTitle = "";
						if(hongikType.equals("Y")){
							tmpTitle = CommonLang.get("HTITLE629");	//"구매액/대학원 학과"
						}else{
							tmpTitle = CommonLang.get("HTITLE176");	//"구매액"
						}
					%>
                	</td>
                	
                	<td class="left" title="품목코드/품목명/규격">&nbsp; 
					<% if(seq_flag.equals("Y")){ %>
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%><%=rowData.get("CART_SEQ")%>" />
					<% } else {  %> 
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%>" />
					<% } %>
						<a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
							<b><font color="#5B5B5B"><%=rowData.get("BUYER_ITEM_NO")%></font></b>
						</a><br> &nbsp;&nbsp;<%=rowData.get("DESCRIPTION_LOC")%><%=rowData.get("SPECIFICATION")%>
					</td>
					
					<% if(p060000117 == true){ %>
					<td title="품목별 납기리드타임"><%=rowData.get("DELIVERY_LT")%> 일</td>
					<% } %>
					
					<td title="협력사/단위"><a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=(rowData.get("AGENT").equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : rowData.get("AGENT")%></a><br>
						<%=rowData.get("UNIT_MEASURE")%></td>
					
					<td class="right" title="단가/구매수량"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 -->
						<br><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%></td>
					
					<td class="right" title="<%=tmpTitle%>">
						<% if(hongikType.equals("Y")){%> 
							<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --> <%=rowData.get("HI_DEPT_NAME")%>
						<% }else{ %> 
							<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --> 
						<% } %>
					</td>
					
					<% if(true == p060000117){ %>
					<td title="표준납기일"><input type="text" class="input_type_text" name="recv_date_hope" id="fromDate<%=j%>" size="11" readOnly value="<%=CommonUtil.formatStrinigDate(rowData.get("DS_LT"))%>">
						<input type="hidden" id="ds_lt<%=j%>" value="<%=rowData.get("DS_LT")%>"></td>
					<% }else{ %>
					<td title="수령희망일"><input type="text" class="input_type_text" name="recv_date_hope" id="fromDate<%=j%>" style="width: 60%" size="10" readOnly value="<%=CommonUtil.formatStrinigDate(st_recv_date2)%>">
					</td>
					<% } %>
					
					<td title="파일"><input type="hidden" name="st_image_key" id="st_image_key" value="<%=rowData.get("IMAGE_KEY")%>">
					<% if(!rowData.get("IMAGE_KEY").equals("")) {%>
						<a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>');">
						<img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0">
						</a>
					<% }else { %>
						<a href="javascript:gridPopOpen('<%=j%>');"> 
						<img  src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0">
						</a>
					<% } %>
					</td>
			</tr>

			<%if(p060000100 == true){%>
			<tr bgcolor="<%=tclass%>">
				<td colspan="4" style="text-align: left;">
					<%=CommonLang.get("HTITLE485") %><!-- 도착지 --> : <%=rowData.get("DELY_TO_LOCATION_TEXT")%>
				</td>
				<td style="text-align: left;">
					<%=CommonLang.get("HTITLE943") %><!-- 수령자 --> : <%=rowData.get("RECV_USER_NAME")%>
				</td>
				<td colspan="2" style="text-align: left;">
					<%=CommonLang.get("HTITLE326") %><!-- 전화번호 --> : <%=rowData.get("RECV_USER_TEL")%> 
				</td>
			</tr>
			<%}%>
 		<%   }  //data 여러개일때를 위한  for %>   
		<% }  //data 여러 개일 때를 걸러내는 else %> 
              </thead>
            </table>
            <div class="fr">       
           		<%=CommonLang.get("HTITLE584") %><!-- 금액합계 --> : <%=CommonUtil.formatNumber(tot_price,true,0,3)%> <%=CommonLang.get("HTITLE660") %><!-- 원 -->     
				<input type="hidden" name="nu_tot_price" value="<%=tot_price%>">
				<input type="hidden" name="st_account_type" value="<%=account_type%>">
				<input type="hidden" name="st_bdgt_flag" value="<%=bdgt_flag%>">
            </div>
            <br><br>
<div class="btnArea">
	   <div class="fl">
	     <h3><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --></h3>
	   </div>
        	 
 		<div class="fr">
			<%if(budget_flag.equals("Y")){ %>
	 			<span class="btn_10 mr04" title="예산부서별주문금액">
					<a href="javascript:getBudegtOrderAmtPop()"><%=CommonLang.get("HTITLE882") %><!--예산부서별주문금액 --></a>
				</span>
			<%} %>
<%--  			<span class="btn_06 mr04" title="변경">
				<a href="javascript:dely_info_modify()"><%=CommonLang.get("HTITLE837") %><!-- 배송정보변경 --></a>
			</span>		 --%>
		</div>
        <table  class="cont_t_list06" style="width:99%;">
        <caption>제품상세보기 리스트</caption>
        <colgroup>
            <col width="100px" />
            <col width="*" />
            <col width="100px" />
            <col width="33%" />
        </colgroup>
        <tbody>
        <%if(p060000117 == true){ %>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
				<td colspan="3"><input type="text" name="st_purchase_dept_name" id="st_purchase_dept_name" class="input_type_text" title="" style="width: 370px;" value="<%=purchase_dept_name%>" readonly /> 
					<input type="hidden" name="st_purchase_dept_code" size="50" value="<%=purchase_dept_code%>"> 
					<span class="btn_gray_02" title="변경">
						<a href="javascript:setDeptCodeSearch('<%=buyer%>')"><%=CommonLang.get("HTITLE825") %><!-- 변경 --></a></span>
				</td>
			</tr>
			<% if(p060000100 == false){ %>
				<tr>
					<th rowspan="2"><%=CommonLang.get("HTITLE826") %><!-- 배송처 --></th>
					<td colspan="3">
						<span class="btn_gray_07" title="도착지">
							<a href="javascript:getDeliveryToLocation('<%=buyer%>')"><%=p060000075%></a>
						</span>
						<br /> 
						<input type="text" name="st_location_code" id="st_location_code" class="input_type_text" title="" style="width: 7%;" value="<%=st_location_code%>" readonly />
						<input type="text" name="st_location_code_name" class="input_type_text" title=""	style="width: 20%;" value="<%=st_location_code_name%>" readonly />
					</td>
				</tr>
				<tr>
					<td colspan="3">
					<%if(p060000083==false){%>
						<span class="btn_gray_05" title="우편번호">
							<a href="javascript:getnewzipCode();"><%=CommonLang.get("HTITLE791") %><!-- 우편번호 검색 --></a>
						</span>
						<br />
					<%}%>
						<input type="text" name="st_location_name" id="st_location_name" class="input_type_text" title="" style="width: 50%;" value="<%=st_location_name%>" readonly /> 
						(ex. <%=CommonLang.get("HTITLE343") %><!-- 우편번호 -->+<%=CommonLang.get("HTITLE346") %><!-- 상세주소 -->)
					</td>
				</tr>
				<tr>
					<th scope="row"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
					<td><label for="b_no02" class="hidden">전화번호선택</label>
					<input type="hidden" name="st_tel_no" id="st_tel_no" size="15" id="text" value="<%=st_tel_no%>"> 
						<select name="st_tel_no1" id="incolor" style="width: 50px; height: 20px;">
							<option value="02">02</option>
							<option value="031">031</option>
							<option value="032">032</option>
							<option value="033">033</option>
							<option value="041">041</option>
							<option value="042">042</option>
							<option value="043">043</option>
							<option value="044">044</option>
							<option value="051">051</option>
							<option value="052">052</option>
							<option value="053">053</option>
							<option value="054">054</option>
							<option value="055">055</option>
							<option value="061">061</option>
							<option value="062">062</option>
							<option value="063">063</option>
							<option value="064">064</option>
							<option value="070">070</option>
							<option value="0303">0303</option>
							<option value="0502">0502</option>
							<option value="0504">0504</option>
							<option value="0505">0505</option>
							<option value="0506">0506</option>
							<option value="0507">0507</option>
					</select>&nbsp;-&nbsp;
					<input type="text" name="st_tel_no2" id="st_tel_no2" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" />&nbsp;-&nbsp; 
					<input type="text" name="st_tel_no3" id="st_tel_no3" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" />
					</td>
					<th scope="row"><%=CommonLang.get("HTITLE43") %><!-- 팩스번호 --></th>
					<td>
						<label for="b_no02" class="hidden">팩스번호선택</label> 
						<input type="hidden" name="st_fax_no" size="15" id="st_fax_no" value="">
						<select name="st_fax_no1" id="st_fax_no1" style="width: 50px; height: 20px;">
							<option value="02">02</option>
							<option value="031">031</option>
							<option value="032">032</option>
							<option value="033">033</option>
							<option value="041">041</option>
							<option value="042">042</option>
							<option value="043">043</option>
							<option value="044">044</option>
							<option value="051">051</option>
							<option value="052">052</option>
							<option value="053">053</option>
							<option value="054">054</option>
							<option value="055">055</option>
							<option value="061">061</option>
							<option value="062">062</option>
							<option value="063">063</option>
							<option value="064">064</option>
							<option value="070">070</option>
							<option value="0303">0303</option>
							<option value="0504">0504</option>
							<option value="0505">0505</option>
							<option value="0506">0506</option>
							<option value="0507">0507</option>
					</select>&nbsp;-&nbsp;
					<input type="text" name="st_fax_no2" id="st_fax_no2" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" />&nbsp;-&nbsp;
					<input type="text" name="st_fax_no3" id="st_fax_no3" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" /></td>
				</tr>
				<tr>
					<th scope="row"><%=CommonLang.get("HTITLE827") %><!-- 인수자명 --></th>
					<td>
						<input type="text" name="st_user_name" id="st_user_name" class="input_type_text" title="" style="width: 100px;" value="<%=st_user_name%>"STYLE="ime-mode:active" /></td>
					<th scope="row"><%=CommonLang.get("HTITLE828") %><!-- 휴대폰 --></th>
					<td><label for="b_no02" class="hidden">휴대폰번호선택</label> <input type="hidden" name="st_mobile_no" size="6" id="text">
						<select name="st_mobile_no1" id="st_mobile_no1" style="width: 50px; height: 20px;">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
					</select>&nbsp;-&nbsp;
					<input type="text" name="st_mobile_no2" id="st_mobile_no2" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" />&nbsp;-&nbsp; 
					<input type="text" name="st_mobile_no3" id="st_mobile_no3" class="input_type_text" style="width: 40px; height: 15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);" /></td>
				</tr>
				<tr>
					<th scope="row"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
					<td colspan="3">
						<input type="text" name="st_email" id="st_email" class="input_type_text" title="" style="width: 200px;" value="<%=st_email%>" /> 
						<span class="btn_gray_03" title="정보반영"> <a href="javascript:CheckSubmit(2)"><%=CommonLang.get("HTITLE829") %><!-- 정보반영 --></a></span>
						<%=CommonLang.get("HTITLE830") %><!-- (내용을 개인정보에 반영합니다) -->
					</td>
				</tr>
			<%}else{ %>
				<input type="hidden" name="st_user_name" value="<%=st_user_name%>">
				<input type="hidden" name="st_tel_no" value="<%=st_tel_no%>"> 
				<input type="hidden" name="st_fax_no" value="<%=st_fax_no%>"> 
				<input type="hidden" name="st_mobile_no" value="<%=st_mobile_no%>">
				<input type="hidden" name="st_email" value="<%=st_email%>">
				<input type="hidden" name="st_location_name" value="<%=st_location_name%>">
				<input type="hidden" name="st_location_code" value="<%=st_location_code%>">
				<input type="hidden" name="st_location_code_name" value="<%=st_location_code_name%>">
				<input type="hidden" name="st_tel_no1" value="">
				<input type="hidden" name="st_tel_no2" value="">
				<input type="hidden" name="st_tel_no3" value="">
				<input type="hidden" name="st_fax_no1" value="">
				<input type="hidden" name="st_fax_no2" value="">
				<input type="hidden" name="st_fax_no3" value="">
				<input type="hidden" name="st_mobile_no1" value="">
				<input type="hidden" name="st_mobile_no2" value="">
				<input type="hidden" name="st_mobile_no3" value="">
			<%}%>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE832") %><!-- 특이사항 --></th>
				<td colspan="3"><input type="text" name="st_remark" id="st_remark" class="input_type_text" title="" style="width: 90%;" value="" placeholder="표준납기일 이전 수령 희망 시, 수령희망일 기재" /></td>
				<input type="hidden" name="st_remark2" id="st_remark2" class="input_type_text" title="" style="width: 90%;" value=""/>
			</tr>
			<% }else{ // p06_0000117이 true가 아닌 경우 %>
			<tr>
				<%	if(p060000126_map != null)  { %>
				<th scope="row"><%= p060000126_col1%><!-- 구매요청부서 --></th>
				<td colspan="3">&nbsp;<%=purchase_dept_name%>
				</td>
				<% } else { %>
				<th scope="row"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
				<td colspan="3">&nbsp;<%=purchase_dept_name%>
				</td>
				<% } %>
				
			</tr>
			<% if(p060000100 != true){ %>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE826") %><!-- 배송처 --></th>
				<td colspan="3">&nbsp;<%=st_location_name%>
				</td>
			</tr>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
				<td>&nbsp;<%=st_tel_no%></td>
				<th scope="row"><%=CommonLang.get("HTITLE43") %><!-- 팩스번호 --></th>
				<td>&nbsp;<%=st_fax_no%></td>
			</tr>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE827") %><!-- 인수자명 --></th>
				<td>&nbsp;<%=st_user_name%></td>
				<th scope="row"><%=CommonLang.get("HTITLE828") %><!-- 휴대폰 --></th>
				<td>&nbsp;<%=st_mobile_no%></td>
			</tr>
			<% } %>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
				<td colspan="3">&nbsp;<%=st_email%>
				</td>
			</tr>
			<tr>
			<%	if(p060000122_map != null)  { %>
				<th scope="row"><%=p060000122_col1%><!-- 특수로직 값 --></th>
				<td colspan="3">&nbsp;<%=st_remark%>
			<% } else {  %>
				<th scope="row"><%=CommonLang.get("HTITLE832") %><!-- 특이사항 --></th>
				<td colspan="3">&nbsp;<%=st_remark%>
			<% } %>
				</td>
			</tr>
		<% } %>
            </tbody>
          </table>
            
		<!-- 버튼영역 -->
		<div class="btnArea"></div>
		<div class="fr">
			<span class="btn_04" title="주문취소">
				<a href="javascript:order_cancle();"><%=CommonLang.get("HTITLE225") %><!-- 주문취소 --></a>
			</span>	
				
		<% //카드결제 가능 고객사만 보이게 하기 KRCOLL0001:서울대학교경영대학원
    	//SLOGIC-BEGIN(P06-0000043) p060000043_yn = true면 반드시 결재 해야하므로 카드결재여부 미표기
    	if(p060000043 == true &&p060000043_yn==false){ %>
      		<font color="#006699" ><b><%=CommonLang.get("HTITLE838") %><!-- 카드결제여부 --> :</b></font>
      		<input type="checkbox" name="card_yn">
		<% 	
	    } else {
	    %>
      		<input type="checkbox" name="card_yn" value="N" style="width:0px; height:0px; border:0px" DISABLED >
      <% } //SLOGIC-END %> 
		<% if (submitFlag == true) { %>    
			<span class="btn_04 mr04" title="주문하기">
			<% if (p060000117 == true) { %>
				<a href="javascript:confirm_submit('1')"><%=CommonLang.get("HTITLE839") %><!-- 주문하기 --></a>
			<% } else { %> 
				<a href="javascript:order_submit('1')"><%=CommonLang.get("HTITLE839") %><!-- 주문하기 --></a>
			<% } %>
			</span>					
		<%// KRKEPB0004
		if(buyer.equals("KRSUHJ0001")||buyer.equals("KRSEOJ0020")||buyer.equals("KRSEOJ0022")||buyer.equals("KRSEOJ0025")||buyer.equals("KRSEOJ0021")||buyer.equals("KRSEOJ0024")||buyer.equals("KRSEOJ0023")||buyer.equals("KRSEOJ0019")){			
		%>
			<span class="btn_04" title="품의서출력">
				<a href="javascript:DraftSentenceView();"><%=CommonLang.get("HTITLE704") %><!-- 품의서출력 --></a>
			</span>	
		<% }
		}
		%>					 
        </div>
        
        
       	<div class="fl">			
		<%// if(buyer.equals("KRCONT0006")||buyer.equals("KRCONT0007")){
		 //SLOGIC-BEGIN(P06-0000046)
		 //SLOGIC-BEGIN(P06-0000047)
		 //SLOGIC-BEGIN(P06-0000048)
		if (p060000046 == true) {
		%>
			<font color="#990000"><b><%=CommonLang.get("HTITLE840") %><!-- 긴급발주 --></b></font> : <input type="checkbox" name="cbx1" onClick = "setCheckBox1();">&nbsp;<%=CommonLang.get("HTITLE841") %><!-- 체크 시 운영자에게 SMS통보. -->
			<input type="checkbox" name="cbx" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" DISABLED>
			<input type="hidden" name="imsi_po_create_date" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>">

		<% }else if(!pre_goods_count.equals("0")){ %>
      		<div  style="display:none"><input type="checkbox" name="cbx" style="background-color:#FFFFFF;border:#FFFFFF 1px solid;" DISABLED></div> <%=CommonLang.get("HTITLE208") %><!-- 발주일 --> :
      			<input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>" class="input_type_text" readonly> &nbsp;&nbsp;&nbsp;&nbsp;
    			<br> 
		<!--
		 **************************************************************
		 * 작업자 : 최진수
		 * 작업일 : 2013-12-18
		 * 작업내용 : 메가스터디의 경우 긴급발주를 사용하지 않기 때문에
		              화면에 표시하지 않도록 추가함.
		 ************************************************************** -->
				<div  style="display:<%if(p060000047 == true) out.println("none");%>">
					<font color="#990000"><%=CommonLang.get("HTITLE840") %><b><!-- 긴급발주 --></b></font>
					 :<input type="checkbox" name="cbx1" onClick = "setCheckBox1();">&nbsp;<%=CommonLang.get("HTITLE841") %><!-- 체크 시 운영자에게 SMS통보. -->
				</div>
		<!-- 
		 ************************************************************** -->
			<% } else { %>
				<b><%=CommonLang.get("HTITLE842") %><!-- 선입고 --> :</b> 
			<% if(st_pre_gr_flag.equals("Y")){ %>
				<input type="checkbox" name="cbx" onClick = "setCheckBox();" disabled checked> &nbsp;&nbsp;<%=CommonLang.get("HTITLE934") %><!--선입고 받은 날짜 --> :
			<% }else{ %>
				<input type="checkbox" name="cbx" onClick = "setCheckBox();" <%=(p060000048 == true) ?"DISABLED":"" %> > &nbsp;&nbsp;<%=CommonLang.get("HTITLE934") %><!-- 선입고 받은 날짜 --> :
			<% } %>
				<input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>"  class="input_type_text" readonly>
				<span title="검색"> <a href="javascript:CalendarCheck('from')"><img src="/resources/images/btn_calendar.gif" border="0" alt="검색"></a>&nbsp;&nbsp;<font color="#990000"><%=CommonLang.msg("MSG540") %><!--※ 선입고: 시스템 발주 전에 미리 제품을 요청하여 입고를 받았음.--></font></span> &nbsp;&nbsp;&nbsp;&nbsp;<br>
				<span class="fl">
					<font color="#990000">
					<% //긴급발주 비활성화 기능.
					if (p060000047 == false) {
					%>
		      		<b><%=CommonLang.get("HTITLE840") %><!-- 긴급발주 --></b></font>
		      		 : <input type="checkbox" name="cbx1" onClick = "setCheckBox1();">&nbsp;<%=CommonLang.get("HTITLE841") %><!-- 체크 시 운영자에게 SMS통보. -->&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      		<font color="#990000"><%=CommonLang.msg("MSG541") %><!--  ※ 긴급발주: 급히 물건을 입고 받고자 긴급하게 요청 함.--><br></font>
					<%
					} else {
					%>
			   			<input type="hidden" name="cbx1">
					<%
					}
					%>
				</span>
			<% } //SLOGIC-END %>
		</div> 
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="account_type" id="account_type" value="" />
	<input type="hidden" name="end_price" id="end_price" value="" />
	<input type="hidden" name="tot_price" id="tot_price" value="" />
	<input type="hidden" name="recvFlag" id="recvFlag" value="" />  	
	<input type="hidden" name="st_query_cart" id="st_query_cart" value="" />  
	<input type="hidden" name="st_query_cart_date" value="" />
	<input type="hidden" name="st_query_cart_date_item"  value="" />    
	<input type="hidden" name="TYPE" id="TYPE" value="" />  
	<input type="hidden" name="COM_CODE" id="COM_CODE" value="" />
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
	<input type="hidden" id="appType" name="appType" value="">
	<input type="hidden" id="pm_attach_yn" name="pm_attach_yn" value="">
</form>
<form name="whaninForm" action="">
	<input type="hidden"  name = "EMP_NO" id = "EMP_NO" value=""/>
	<input type="hidden"  name = "FORM_KEY" id = "FORM_KEY" value=""/>
	<input type="hidden" 	name = "EXTRA" id = "EXTRA" value="">
</form>

<form name="ExternForm" action="">
	<input type="hidden"  name = "Extern_BUYER" id = "Extern_BUYER" value=""/>
	<input type="hidden"  name = "Extern_PR_NO" id = "Extern_PR_NO" value=""/>
	<input type="hidden"  name="Extern_TOT_PRICE" value="<%=CommonUtil.formatNumber(tot_price,true,0,3)%>">
</form>
</div>
<!--내용 종료-->	
 <br>                
</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body> 
<script type="text/javascript">
 
var popupSel = "";
var dely_valid_flag = true;

// 최초 화면 함수 
function kep_onload_view(){	  
<%  if (p060000117 == true) { %>
	tel_no_distinct(0);
	mobile_distinct(0);
	fax_no_distinct(0);
<%	if (_gridList != null && _gridList.size() != 0){ 
		for (int j=0; j<_gridList.size(); j++) {     %>
			kepNoSetCalender("fromDate<%=j%>","","","Y","<%=j%>","")
<%		}
	}
} else {
	if (_gridList != null || _gridList.size() != 0){ %>
		kep_listkepSetCalender2("fromDate" , <%=rec_cnt%> );
<%	}
} %>
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


//조회
function kepSearch(curPage){ 
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderInfoList.do").submit();   
}
 
function order_cancle(){           ////////////////////  주문취소 후 장바구니 화면이동  //////////////////////////

    document.forms.contentForm.st_query_cart.value = ""; 
    //선입고장바구니 여부에 따란 return값 상이
    if(document.forms.contentForm.st_pre_gr_flag.value == "Y"){
        //주문을 취소하시겠습니까? \n\n 선입고 장바구니 화면으로 돌아갑니다.
    	if(!confirm(" <%=CommonLang.msg("MSG452") %>   ")){
            return;
        }
    	$('#contentForm').attr("action", "<%=h_sslurl%>"+"/mpso/getBuyerMpSoPreGrCartList.do?upperId=b00000000000&leftMenu=N").submit();
    }else{
        //주문을 취소하시겠습니까? \n\n 장바구니 화면으로 돌아갑니다.
    	if(!confirm(" <%=CommonLang.msg("MSG453") %>   ")){
            return;
        }
    	$('#contentForm').attr("action", "<%=p060000036%>").submit();	
    }
}


function dely_info_modify(){        ////////////////////    배송 정보 변경     //////////////////////////

    $('#contentForm').attr("action", "<%=h_sslurl2%>/mpso/getBuyerMpSoDlvryInfo.do").submit();   
}



function order_info_modify(){       ////////////////////    주문 정보 변경     //////////////////////////
	document.forms.contentForm.st_query_cart.value = "";

	$('#contentForm').attr("action", "<%=p060000036%>").submit();    
     

}

function set_cart_date(limit){
	
	if (limit == 0) return;
	
	var str = "";
	for (var i=0; i<eval(limit); i++){ 
		str = str + $("#BUYER_ITEM_NO_ARRRAY"+i).val() + "|" +  $("#fromDate"+i).val().replace(/[/]/gi,"") + "@@"; 
	}
	$("#st_query_cart_date").val(str);	
}
 
function doCheckAMT(buyer,user_dept,account_type,end_price,tot_price,recvFlag){
	
	document.forms.processForm.buyer.value = buyer;
	document.forms.processForm.account_type.value = account_type;
	document.forms.processForm.end_price.value = end_price;
	document.forms.processForm.tot_price.value = tot_price;
	document.forms.processForm.recvFlag.value = recvFlag; 	
	
	
	document.forms.processForm.st_query_cart.value = document.forms.contentForm.st_query_cart.value; 	
	document.forms.processForm.st_query_cart_date.value = document.forms.contentForm.st_query_cart_date.value; 	
	
	//코웨이일경우 예산 체크
	<%
	//SLOGIC-BEGIN(P06-0000032)
	if (p060000032 == true){ %>
	kepAjaxFormCall("/mpso/cowayBuyerAdminBdgtTempCheck.do","processForm","COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}else{%>
	kepAjaxFormCall("/mpso/buyerAdminBdgtTempCheck.do","processForm","BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}
	//SLOGIC-END%>
}

function setData(recvFlag)
{
	var person_author = document.forms.contentForm.st_person_author.value;

    if (recvFlag=="3"){
		ServerCall("N","GA");
    }
    else{
		if(person_author == "PO") {
			document.forms.processForm.TYPE.value = "PX";	 
		}else { 
			document.forms.processForm.TYPE.value = "PR";	 
		}
		document.forms.processForm.COM_CODE.value = "<%=buyer%>"; 	
		document.forms.processForm.pm_attach_yn.value = "<%=pm_attach_yn%>";
		<%-- remark중복되는거방지--%>
		document.forms.contentForm.st_remark.value += document.forms.contentForm.st_remark2.value; 

		kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ"); 
    }
}

function ServerCall(GW_NO,recvFlag){ 

    if(document.forms.contentForm.cbx.checked == true){ // 선입고 여부  Y(선입고) , N(발주)
        document.forms.contentForm.st_gr_flag.value = "S";
    }else if(document.forms.contentForm.cbx1.checked == true){
        document.forms.contentForm.st_gr_flag.value = "F"; // 선입고 여부  Y(선입고) , N(발주)
    }else{
		document.forms.contentForm.st_gr_flag.value = "N"; // 선입고 여부  Y(선입고) , N(발주)
    }

    document.forms.contentForm.GW_NO.value = GW_NO;
    document.forms.contentForm.recvFlag.value = recvFlag;
    var buyer = document.forms.contentForm.st_buyer.value;

    var limit = "<%=rec_cnt%>";       
    set_cart_date(limit);
    
    //alert($("#st_query_cart_date").val());	
    
<% //SLOGIC-BEGIN(P06-0000044)
if (p060000044 == true){%>
    //코오롱 베니트(주)는 주문 버튼 클릭 시 그룹웨어로 전송 됩니다.\n\n그룹웨어의 상품가져오기의 최대지연시간은 10분입니다.
    alert("<%=CommonLang.msg("MSG457") %>");   
    kepAjaxFormCall("/mpso/buyerNewCreateBenit.do","contentForm","BUYER_NEW_CREATE_BENIT");   // 구매발주?
<%}else if( "Y".equals(p060000062_yn)) {%>
    kepAjaxFormCall("/mpso/buyerNewCreateGroupware.do","contentForm","BUYER_NEW_CREATE_GROUPWARE");
<%}else{%>
    kepAjaxFormCall("/mpso/buyerNewCreateOrder.do","contentForm","BUYER_NEW_CREATE_ORDER");   
<%} //SLOGIC-END%>    
}

function setCheckBox(){
    if(document.forms.contentForm.cbx.checked == true){
        //작성하신 주문을 선입고 하시겠습니까?\n\n선입고시 발주일을 변경하실 수 있습니다.
    	if(confirm("<%=CommonLang.msg("MSG458") %>")){
            if(document.forms.contentForm.cbx1.checked == true){
                //선입고 선택 시 긴급발주 선택을 하실 수 없습니다.
            	alert("<%=CommonLang.msg("MSG459") %>");
                document.forms.contentForm.cbx1.checked = false;
            }
        }else{
            document.forms.contentForm.cbx.checked = false;
        }
    }else if(document.forms.contentForm.cbx.checked == false){
        document.forms.contentForm.imsi_po_create_date.value = document.forms.contentForm.ToDateTemp.value;
    }
}

function setCheckBox1()
{
   if(document.forms.contentForm.cbx.checked == true){
       //선입고 선택 시 긴급발주 선택을 하실 수 없습니다.
	   alert("<%=CommonLang.msg("MSG459") %>");
       document.forms.contentForm.cbx.checked = false;
   }
}

function CalendarCheck(check){	 
    if(document.forms.contentForm.cbx.checked == false){
        //선입고의 경우에만 발주일을 변경하실 수 있습니다.
    	alert("<%=CommonLang.msg("MSG460") %>");
    }else{
	    date_check = check;
	    kepCalendarOpenPopup();
    }
}

function setPopupCalendar(year,month,day){
	document.forms.contentForm.imsi_po_create_date.value=year+"/"+month+"/"+day+"";
	document.forms.contentForm.st_po_create_date.value=year+""+month+""+day+"";    
}

function setCheckEnd(FLAG,recvFlag){
	if(FLAG == "OK"){			
		setData(recvFlag);
	}
}

function kepApprovalReturn(ERR,GW_NO){ 
	EndPassProcess(ERR,GW_NO); 
}

// 상신결과
function EndPassProcess(ERR,GW_NO){
	
//	alert("GW_NO "+GW_NO);
    if(ERR=="true"){
        ServerCall(GW_NO,"GS");
    }
}

function setDongMail(pr_no){
    var buyer = document.forms.contentForm.st_buyer.value;
    document.forms.contentForm.st_pr_no.value = pr_no;
    kepAjaxFormCall("/mpso/adminBuyerMasterPrCreateMailReg.do","contentForm","ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG");   
}

function setCreate_Results(response){
	
    var result = response.msg.MSG;   
    var pr_type = result.substring(0,2);
	var person_author = document.forms.contentForm.st_person_author.value;	 

	if( pr_type != "PR" && pr_type != "PX" && true != <%=p060000062%> ){
		if(person_author == "PO"){
			//구매발주가 실패 하였습니다. 확인 후 다시 주문해 주십시요.
			alert("<%=CommonLang.msg("MSG465") %>");
			return;
		}else {
			//구매요청이 실패 하였습니다. 확인 후 다시 주문해 주십시요.
			alert("<%=CommonLang.msg("MSG466") %>");
			return;
		}
	}

	var byca_comorg_code = document.forms.contentForm.st_byca_comorg_code.value;
	var buyer = document.forms.contentForm.st_buyer.value;

	// 2005/05/09 경동정밀 추가
	if(buyer == "KRBOIL0002" || buyer == "KRKDBO0001" || buyer == "KRKDBO0002" || buyer == "KRKDPR0001" ){
		//그룹웨어로 결재 전송이 완료 되었습니다.
		alert("<%=CommonLang.msg("MSG464") %>");
	} else if ( true == <%=p060000062%>) {
		var empNo	= "<%=empNo%>";
		var url 	= "<%=p060000062_url%>";
		var type	= "<%=p060000062_type%>";
		var popup_option	= "<%=p060000062_option%>";
		
		if (type == "MODAL") {
			window.showModalDialog(url, "AppPop", "dialogHeight:400;dialogWidth:600;resizable:yes");	
		} else if (type == "NORMAL") {
			
			if (popup_option != "") {
				window.open(url, "AppPop", popup_option);
			} else {
				window.open(url, "AppPop");	
			}
		}
		
	} else if ( true == <%=p110000004%> ) {
		
		if(true == <%=p110000004_type6%> ){
			/* 환인제약 */
			var post_url = response.msg.ATTR1;
			/*url : /mpso/getWhaninPop.do?pr_no=pr19000001&buyer=KRWHAN0001&legacy_user_id=218023*/
			//window.open(url,"WhaninPop");
			
			var url_cv = post_url.replace(/\^/gi,":");
			url_cv = url_cv.replace(/&quot;/gi,"\"");
			
			document.forms.whaninForm.action="https://"+url_cv;
			document.forms.whaninForm.target="_blank";
			document.forms.whaninForm.method="post";
			document.forms.whaninForm.submit();
		}
		else if (true == <%=p110000004_type8%> ){
			/*한림 제약 */
			var post_url = response.msg.ATTR1;
			var url_cv = post_url.replace(/\^/gi,":");
			
			document.forms.whaninForm.action="https://"+url_cv;
			document.forms.whaninForm.target="_blank";
			document.forms.whaninForm.method="post";
			document.forms.whaninForm.submit();
			
			}
		else if (true == <%=p110000004_type9%> ){
			/*동화 산업 */
			var post_url = response.msg.ATTR1;
			var url_cv = post_url.replace(/\^/gi,":");
			
			document.forms.whaninForm.action = "<%=dongwha_url%>"+url_cv;
			document.forms.whaninForm.target="_blank";
			document.forms.whaninForm.method="post";
			document.forms.whaninForm.submit();
			
			}
		else if (true == <%=p110000004_type10%> ){
			/*큐라티스 */

	 	 var qura_buyer = response.msg.ATTR1;
	 	 var qura_pr_no = response.msg.ATTR2;
	 	 
	     document.forms.ExternForm.Extern_BUYER.value = qura_buyer;
	     document.forms.ExternForm.Extern_PR_NO.value = qura_pr_no;

	 	 document.forms.ExternForm.action = "/mpso/QuratisGetContents.do";
		 document.forms.ExternForm.target = "_blank";
		 document.forms.ExternForm.method = "post";
		 document.forms.ExternForm.submit();

		}
		else if (true == <%=p110000004_type11%> ){
			/*홍익대학교 */
		 var hongik_buyer = response.msg.ATTR1;
	 	 var hongik_pr_no = response.msg.ATTR2;
	 	 
	     document.forms.ExternForm.Extern_BUYER.value = hongik_buyer;
	     document.forms.ExternForm.Extern_PR_NO.value = hongik_pr_no;
	     
	 	 document.forms.ExternForm.action = "/mpso/HongikGetContents.do";
		 document.forms.ExternForm.target = "_blank";
		 document.forms.ExternForm.method = "post";
		 document.forms.ExternForm.submit();

		}
		else if (true == <%=p110000004_type12%> ){
			/*lnf */
			var post_url = response.msg.ATTR1;
			var url_cv = post_url.replace(/\^/gi,":");
			
			//document.forms.whaninForm.action="https://"+url_cv;
			//document.forms.whaninForm.target="_blank";
			//document.forms.whaninForm.method="get";
			//document.forms.whaninForm.submit();
			
			window.open("https://"+url_cv);
			
		} 
		else if ( true == <%=p110000004_type14%> ) {
			/* 큐라티스-bizbox 개발용. 개발 후 소스 수정 필요.*/
		 	var qura_buyer = response.msg.ATTR1;
		 	var qura_pr_no = response.msg.ATTR2;
		 	
		    document.forms.ExternForm.Extern_BUYER.value = qura_buyer;
		    document.forms.ExternForm.Extern_PR_NO.value = qura_pr_no;

		 	document.forms.ExternForm.action = "/mpso/QuratisGetContents_bizbox.do";
			document.forms.ExternForm.target = "_blank";
			document.forms.ExternForm.method = "post";
			document.forms.ExternForm.submit();
		} else if ( true == <%=p110000004_type16%> ) {
			/* 한컴 라이프 케어 */
			var get_url = response.msg.ATTR1;
			var url_cv = get_url.replace(/\^/gi,":");
			
			//document.forms.whaninForm.action="https://"+url_cv;
			//document.forms.whaninForm.target="_blank";
			//document.forms.whaninForm.method="get";
			//document.forms.whaninForm.submit();
			
			window.open("https://"+url_cv);
			
		} else if ( true == <%=p110000004_type17%> ) {
			/* KCTech */
			var get_url = response.msg.ATTR1;
			var url_cv = get_url.replace(/\^/gi,":");
			//document.forms.whaninForm.action="https://"+url_cv;
			//document.forms.whaninForm.target="_blank";
			//document.forms.whaninForm.method="get";
			//document.forms.whaninForm.submit();
			
 			window.open("https://"+url_cv);
			
		}
		
		else{
			var url	= "http://"+response.msg.ATTR2;
			window.open(url, "AppPop");
		}
		
	}else if( buyer == "KRKDBO0003" || buyer == "KRKDPR0003" || buyer == "KRKYOU0009" || buyer == "KRKYUN0053" ) {
		
		return ; // 사용안하는 buyer
		alert("<%=CommonLang.msg("MSG401") %> "+result+" <%=CommonLang.msg("MSG385") %>");	//정상적으로 주문되었습니다. 주문번호는 입니다.

		document.forms.contentForm.buyer.value = document.forms.contentForm.st_buyer.value;
		document.forms.contentForm.pxNo.value = result;

		document.forms.contentForm.target="work";
		document.forms.contentForm.method="post";
		document.forms.contentForm.action="/InterfaceForKoreaB2B/InputCtl"; // ????????
		document.forms.contentForm.submit();
		
	} 

	//SLOGIC-BEGIN(P06-0000045)
<% if (p060000045 == true) { %>
	if(pr_type == "PR"){
		setDongMail(result); //동부한농의 경우 메일링 관련.....
	}
<%}//SLOGIC-END%>
	
	//alert("결재상신 처리 되었습니다.");
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderProgressList.do").submit();   
}


function setResult(response){	
	var outflag = response.msg.MSG;   		
    if(outflag == "true"){
          alert("<%=CommonLang.msg("MSG402") %>");	//메일 발송이 정상적으로 되었습니다.
    }else{
          alert("<%=CommonLang.msg("MSG403") %>");	//메일 발송이 실패하였습니다.
    }

    //alert("메일 발송 후 주문 성공 -> 주문진행현황");
    //alert("구매 완료 되었습니다.");
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderProgressList.do").submit();   
}

function DraftSentenceView()
{
  var f = document.forms.contentForm;
  var buyer = "<%=buyer%>";
  var user_id = "<%=userId%>";
  var contract_no = '<%=contract_no%>';
  var contract_seq = '<%=contract_seq%>';
  reportOpen("RD_06_S_001_99","["+buyer+"]["+user_id+"]["+contract_no+"]["+contract_seq+"]");
}

function  attach_popup(img_key){		
	var type = "PR";
	var viewType = "R";	 
	kepFileUploadOpenPopup(img_key,type,viewType);  
}


/**
 * 첨부파일 구현
 */
var gridIndex = 0;
function gridPopOpen(obj1){ 
 gridIndex = obj1;
 popupSel = "attach";
 attach_popup("");
}
  
function setPopupReturn(value1, value2, value3){ 	
	if (popupSel == "attach"){
   		$("input[name=st_image_key]").eq(gridIndex).val(value1); 
	} else if (popupSel == "dept_buyer"){
	    document.forms.contentForm.st_purchase_dept_name.value = value2;
	    document.forms.contentForm.st_purchase_dept_code.value = value1;
	}else if (popupSel == "location"){
		document.forms.contentForm.st_location_code.value = value1;
		document.forms.contentForm.st_location_name.value = value2;
	    document.forms.contentForm.st_location_code_name.value = value3;
	}
}   

function setCreate_Benit_Results(response){

    var result = response.msg.MSG;        
    if(result == "OK"){
            alert("<%=CommonLang.msg("MSG159") %>");	//정상적으로 전송되었습니다.
            document.forms.contentForm.st_query_cart.value = "";
            $('#contentForm').attr("action", "/mpso/getBuyerMpSoCartList.do?leftMenu=N").submit();   
            //top.window.close();
    } else {
            alert("<%=CommonLang.msg("MSG461") %>");	//실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.
            return;
    }
}


/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var flag = "";
	var budget_dept_name = "";
	var account_text = "";
	var plan_amt = "";
	var result_amt = "";
	var temp_amt = "";
	var tot_price = "";	
	
	if (pMethod == "CHECKZIP"){
		if (response.msg.MSG != "Y"){ 
			console.log(kepGetNowTimeStr("YYYYMMDDHHMI", "/") + " : N");	
			alert('<%=CommonLang.msg("MSG450")%>');	//우편번호가 유효하지 않습니다.
			document.forms.contentForm.st_location_name.focus();	 
			dely_valid_flag = false;
			return ;
		}else{
			console.log(kepGetNowTimeStr("YYYYMMDDHHMI", "/") + " : Y");			
			dely_valid_flag = true;
			order_submit('1');
		}
	}else if (pMethod == "BUYERDELIVERYINFO1"){
		dely_valid_flag = true;
		// 기본 배송정보가 수정되었습니다.
		alert("<%=CommonLang.msg("MSG451")%>   ");
 	}
	else if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"  || pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){
		
/* 변경 시작 */
		var recvFlag =  document.forms.processForm.recvFlag.value;
		
		if (response.data.length > 0){
			for(var i=0; i<response.data.length; i++){
				flag = $.trim(eval("response.data[i].BUYER_CHECK"));
				budget_dept_name = $.trim(eval("response.data[i].BUDGET_DEPT_NAME"));
				account_text = $.trim(eval("response.data[i].ACCOUNT_TYPE_TEXT"));
				plan_amt = $.trim(eval("response.data[i].MPAMT"));
				result_amt = $.trim(eval("response.data[i].RESULT_AMT"));
				temp_amt = $.trim(eval("response.data[i].TEMP_AMT"));
				tot_price = $.trim(eval("response.data[i].TOT_AMT"));
				
				if(flag == "예산초과"){
					//예산	원	구매가능 예산		원	구매금액	원	예산이 초과되어 구매할 수 없습니다.
			        alert(budget_dept_name +
			              "\n\n"+account_text+"<%=CommonLang.get("HTITLE694") %>    "+kepCommaNum(plan_amt)+"<%=CommonLang.get("HTITLE660") %> "+
			              "\n\n"+account_text+"<%=CommonLang.get("HTITLE843") %>    "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+"<%=CommonLang.get("HTITLE660") %> "+
			              "\n\n"+account_text+"<%=CommonLang.get("HTITLE844") %>    "+kepCommaNum(tot_price)+"<%=CommonLang.get("HTITLE660") %> "+
			              "\n\n<%=CommonLang.msg("MSG384") %>");
			        //  parent.main.setCheckEnd('NO',recvFlag);
			        return ;
			    } else if(flag == "예산미편성"){
			        alert(budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>");	//예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
			        return;
			    }
			}
		}else{
		}

		setCheckEnd('OK',recvFlag);
/* 변경 종료 */

// 기존 시작 
/*
		if (response.data.length > 0){
			flag = $.trim(eval("response.data[0].BUYER_CHECK"));
			budget_dept_name = $.trim(eval("response.data[0].BUDGET_DEPT_NAME"));
			account_text = $.trim(eval("response.data[0].ACCOUNT_TYPE_TEXT"));
			plan_amt = $.trim(eval("response.data[0].MPAMT"));
			result_amt = $.trim(eval("response.data[0].RESULT_AMT"));
			temp_amt = $.trim(eval("response.data[0].TEMP_AMT"));
			tot_price = $.trim(eval("response.data[0].TOT_AMT"));
		}
		var recvFlag =  document.forms.processForm.recvFlag.value;
		var end_price =  document.forms.processForm.end_price.value; 		
		
	    if(flag == "예산초과"){
			//예산	원	구매가능 예산		원	구매금액	원	예산이 초과되어 구매할 수 없습니다.
	        alert(budget_dept_name +
	              "\n\n"+account_text+"<%=CommonLang.get("HTITLE694") %>    "+kepCommaNum(plan_amt)+"<%=CommonLang.get("HTITLE660") %> "+
	              "\n\n"+account_text+"<%=CommonLang.get("HTITLE843") %>    "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+"<%=CommonLang.get("HTITLE660") %> "+
	              "\n\n"+account_text+"<%=CommonLang.get("HTITLE844") %>    "+kepCommaNum(tot_price)+"<%=CommonLang.get("HTITLE660") %> "+
	              "\n\n<%=CommonLang.msg("MSG384") %>");
	        //  parent.main.setCheckEnd('NO',recvFlag);
	        return ;
	    } else if(flag == "예산미편성"){
	        alert(budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>");	//예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
	        return;
	    } else {
	    	//처리될까봐 주석으로 해놓음 복원시 아래 주석 해제 필요
	    	//setCheckEnd('OK',recvFlag,end_price);
	    }
*/
//기존 종료
	}else if (pMethod == "BUYER_NEW_CREATE_BENIT"){ 		
		
	   	var result = response.msg.MSG;        
	    if(result == "DUP"){
	    	alert("<%=CommonLang.msg("MSG462") %>");	//해당 주문은 이미 진행되었습니다.
	    	return;
	   	} 
		setCreate_Benit_Results(response);		
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 			
		
		var result = response.msg.MSG;
		if(result == "DUP"){
	    	alert("<%=CommonLang.msg("MSG462") %>");	//해당 주문은 이미 진행되었습니다.
	    	return;
		}else if(result == "OVER_STOCK"){
	    	alert("<%=CommonLang.msg("MSG553") %>");	//재고 초과 품목이 있어 주문이 불가능 합니다. 장바구니 화면에서 확인 바랍니다.
	    	return;
	   	} else if (result == "ERR") {
	   		var err_msg = "<%=CommonLang.msg("MSG463")%>";
	   		//주문에 실패했습니다.
	   		try {
	   			if ( true == <%=p110000004%> || true == <%=p110000004_type20%> || true == <%=p110000004_type22%> || true == <%=p110000004_type23%>) {
	   				err_msg = response.msg.ATTR1;
	   			}
	   		} catch (e) {}
			alert(err_msg);
			return;
		}
		setCreate_Results(response);
	}else if (pMethod == "BUYER_NEW_CREATE_GROUPWARE"){

		var result	= response.msg.MSG;  
		var doc_no	= response.msg.DOC_NO;  
		
		//alert("doc_no : " + doc_no);
	    if(result == "DUP"){
			alert("<%=CommonLang.msg("MSG462") %>");	//해당 주문은 이미 진행되었습니다.
			return;
	   	}
		setCreate_Results(response);
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 		
		setResult(response);
	}else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
		var checkpass = response.msg.CHECKPASS;   
		var pass_flag = response.msg.PASS_FLAG;   		
		var nu_tot_price = eval(document.forms.contentForm.nu_tot_price.value);
		var pm_attach_yn= document.forms.processForm.pm_attach_yn.value
		GoPass(checkpass,pass_flag , nu_tot_price,"",pm_attach_yn);
	}
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {

	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("<%=CommonLang.msg("MSG227") %>");	//시스템 오류입니다. 관리자에게 전화하시기 바랍니다.
	}else if (pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("<%=CommonLang.msg("MSG227") %>");	//시스템 오류입니다. 관리자에게 전화하시기 바랍니다.
	}else if (pMethod == "BUYER_NEW_CREATE_BENIT"){ 
		alert("<%=CommonLang.msg("MSG461") %>");	//실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 
		alert("<%=CommonLang.msg("MSG163") %>  "); //오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 
		alert("<%=CommonLang.msg("MSG163") %>  "); //오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
	}else if (pMethod == "CHECKZIP"){
		dely_valid_flag = false;
		alert("<%=CommonLang.msg("MSG163") %>"); //오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.   
	}else if ( pMethod == "BUYERDELIVERYINFO1"){
		alert("<%=CommonLang.msg("MSG163") %>"); //오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
	}
} 

//총금액  PG_06_B_006_50
function category_list_pop(){
    var byca_comorg_code   = "<%=byca_comorg_code%>";
    var user_id            = "<%=userId%>";    
    openSearchPopup("/mpso/getCategoryListSelectPop.do","?byca_comorg_code="+byca_comorg_code+"&user_id="+user_id , "500,500,no"); 
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

//예산부서별 팝업
function getBudegtOrderAmtPop(){
	
	var total_row = "<%=rec_cnt%>";
	if (total_row == 0) return;
	var st_buyer = "<%=SessionComCode%>";
	var st_user_id = "<%=userId%>";
	var str = "";
	for (var i=0; i<eval(total_row); i++){ 
		str = str + $("#BUYER_ITEM_NO_ARRRAY"+i).val() + "@@"; 
	}
	openSearchPopup("/common/getBudegtOrderAmtPop.do","?st_query_cart="+str+"&st_buyer="+st_buyer+"&st_userid="+st_user_id,"400,250,no");
}

<%-- 이하 ~ p060000117 적용시 사용되는 함수들 --%>
function calenderChange(dateText, num){
	var input_date = dateText.replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	var ds_lt = $("#ds_lt"+num).val();
	if(input_date < ds_lt) {
		alert("표준납기일 이전 수령 희망 시, 특이사항에 수령희망일 기재하시기 바랍니다.");
		$("#fromDate"+num).val(kepDateSlashAdd(ds_lt));
	}
}

<%-- ***** 전화번호, 핸드폰 번호, FAX 정보 함수들 ***** --%>
function tel_no_distinct(set){
    var tel_no        = "<%=st_tel_no%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!=""){

		var tot_lenth     = tel_no.length;
		var no_1_cnt      = tel_no.indexOf("-");
			no_1          = tel_no.substr(0,no_1_cnt);   //지역번호
		var no_2_cnt_temp = tel_no.substr(no_1_cnt+1,tot_lenth); // 3016-8964
		var no_2_cnt      = no_2_cnt_temp.indexOf("-");  //4
			no_2          = no_2_cnt_temp.substr(0,no_2_cnt);   //국번
			no_3          = no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호

		document.forms.contentForm.st_tel_no2.value  = no_2;
		document.forms.contentForm.st_tel_no3.value  = no_3;
		document.forms.contentForm.st_tel_no1.value  = no_1;
   }
}

function mobile_distinct(set){ 
    var tel_no        = "<%=st_mobile_no%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!="")   { 
		var tot_lenth     = tel_no.length;
		var no_1_cnt      = tel_no.indexOf("-");
		    no_1          = tel_no.substr(0,no_1_cnt);   //지역번호
		var no_2_cnt_temp = tel_no.substr(no_1_cnt+1,tot_lenth); // 3016-8964
		var no_2_cnt      = no_2_cnt_temp.indexOf("-");  //4
		    no_2          = no_2_cnt_temp.substr(0,no_2_cnt);   //국번
		    no_3 = no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호

		document.forms.contentForm.st_mobile_no2.value  = no_2;
		document.forms.contentForm.st_mobile_no3.value  = no_3;
		document.forms.contentForm.st_mobile_no1.value  = no_1;
		
		<%if(userId.equals(st_user_name)){%>
			document.forms.contentForm.st_mobile_no2.value  = "";
			document.forms.contentForm.st_mobile_no3.value  = "";
			document.forms.contentForm.st_mobile_no1.value  = "";
		<%}%>		
				
   }
}

function fax_no_distinct(set){
    var tel_no        = "<%=st_fax_no%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!="")   {
		var tot_lenth     = tel_no.length;
		var no_1_cnt      = tel_no.indexOf("-");
			no_1          = tel_no.substr(0,no_1_cnt);   //지역번호
		var no_2_cnt_temp = tel_no.substr(no_1_cnt+1,tot_lenth); // 3016-8964
		var no_2_cnt      = no_2_cnt_temp.indexOf("-");  //4
		    no_2          = no_2_cnt_temp.substr(0,no_2_cnt);   //국번
		    no_3 = no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호
		document.forms.contentForm.st_fax_no2.value  = no_2;
		document.forms.contentForm.st_fax_no3.value  = no_3;
		document.forms.contentForm.st_fax_no1.value  = no_1;
   }
}
<%-- ******************************************* --%>

<%-- 발주 부서 변경함수 --%>
function setDeptCodeSearch(buyer) {
	<%//SLOGIC-BEGIN(P06-0000041)
	if (p060000041 == true) { %>
		//발주부서를 변경 할수 없습니다.\n\n관리자에게 문의 바랍니다.
		alert("<%=CommonLang.msg("MSG449") %>");
	<% } else { %>
	var userId = "<%=userId%>";
	if(userId!="HYEYOUN00") {			
		popupSel = "dept_buyer";
		openSearchPopup("/common/deptCodeAdminBuyerPop.do", "?com_code="+buyer+"&open=Y", "500,500,no");	
	}
	<% } //SLOGIC-END %> 
}

<%--  배송정보 유효성 확인 --%>
function confirm_submit(value){    
	dely_valid_flag = true;
    var purchase_dept_name  = kepTrimStr(document.forms.contentForm.st_purchase_dept_name.value);
    var location_name       = kepTrimStr(document.forms.contentForm.st_location_name.value);
    var user_name       = kepTrimStr(document.forms.contentForm.st_user_name.value);
    var location_code       = kepTrimStr(document.forms.contentForm.st_location_code.value);
    
    // 배송처 앞부분 우편번호 자릿수 및 공백 체크(6, 7, 8 번째 공백)
    var chkZipCode = location_name.substring(0,5);
	var chkSpace6 = location_name.substring(5,6);
	var chkSpace7 = location_name.substring(6,7);
	var chkSpace8 = location_name.substring(7,8);
		
    if(purchase_dept_name == "") {
    	//발주부서는 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG440") %>");
       dely_valid_flag = false;
	   return; 
	}

<%if(p060000100 != true){%>
    if(location_name == "") {
    	//배송처는 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG441") %>");
       dely_valid_flag = false;
	   return;
	}

	if(user_name == "") {
		//인수자명은 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG442") %>");
       dely_valid_flag = false;
	   return;
	}
<%}%>

	var p060000075 = "<%=p060000075%>";
	var p060000075_1 = "<%=p060000075_1%>";
	if(p060000075_1 == "true"){
		if(kepTrimStr(location_code) == ""){
			// 선택은 필수 입력 사항입니다.
			alert(p060000075 + "<%=CommonLang.msg("MSG443") %>");
			dely_valid_flag = false;
			return;
		}
	}
	
	
    var st_query_cart = "<%=st_query_cart%>";
    var tel_no        = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no        = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile        = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;    

<%if(p060000100 != true){ %>
   if(kepTrimStr(document.forms.contentForm.st_tel_no2.value)=="" || kepTrimStr(document.forms.contentForm.st_tel_no3.value)=="" ) {
      alert("<%=CommonLang.msg("MSG445") %>"); //전화번호를 입력해 주십시요
      document.forms.contentForm.st_tel_no3.focus();
      dely_valid_flag = false;
      return;
   }

	var p060000074 = "<%=p060000074%>";
	if(p060000074 == "true"){
		if(kepTrimStr(mobile) == ""){
			//휴대폰번호를 입력해 주십시요
			alert("<%=CommonLang.msg("MSG446") %>");
			dely_valid_flag = false;
			return;
		}else{
			document.forms.contentForm.st_remark2.value ="/"+user_name+"("+tel_no+" / "+mobile+")";	
		}
	}
	
	// 배송처 길이체크(최소 우편번호 '-' 포함 7자리 이상, 짧으면 확인 메시지)
	if(location_name.length > 7){
		// 우편번호 숫자 5자리 + 공백
		if((kepIsNumberString(chkZipCode)  == true) && (chkSpace6 == " ")){
// 			confirm_Submit2();
			order_submit(value);
		}
	   	// 아니면 우편번호 유효성 체크(우편번호 '-' 포함 7자리 + 공백체크)
		else if(chkSpace8 != " "){
			if(chkSpace6 == " "){
				kepAjaxFormCall("/mpso/checkZipCode.do","contentForm","CHECKZIP");
			}else if(chkSpace7 == " "){
				kepAjaxFormCall("/mpso/checkZipCode.do","contentForm","CHECKZIP");
			}else{
				//우편번호와 배송주소지 사이에 공백이 필요합니다.
				alert("<%=CommonLang.msg("MSG447") %>");
				dely_valid_flag = false;
				return;
			}
		}
	   	// 우편번호 숫자 7자리 '-' 포함
		else{
			kepAjaxFormCall("/mpso/checkZipCode.do","contentForm","CHECKZIP");
		}	
	}else{
		//배송처를 확인하여 주십시오.
		alert("<%=CommonLang.msg("MSG448") %>");
		dely_valid_flag = false;
		document.forms.contentForm.st_location_name.focus();
		return;
	}
<% } else { %>
	dely_valid_flag = true;
// 	confirm_Submit2();
	order_submit(value);
<% } %>
}

<%-- 데이터에 문제 없을 때 넘어가는 함수 --%>
function confirm_Submit2(){

	var st_query_cart = "<%=st_query_cart%>";
    var tel_no        = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no        = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile        = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;
	document.forms.contentForm.st_query_cart.value  = st_query_cart;
    document.forms.contentForm.st_tel_no.value      = tel_no;
    document.forms.contentForm.st_fax_no.value      = fax_no;
    document.forms.contentForm.st_mobile_no.value   = mobile;
    
// 배송정보에서 수령희망일을 체크하지 않을 때 -> toDate, fromDate 모두 안 생김 
<%--     <%if(p060000117 != true){%> --%>
//	 	var recv_date2    = $("#fromDate").val().replace(/[/]/gi,"");;
//	 	var recv_date     = recv_date2.substring(0,4) +"년  "+ recv_date2.substring(4,6) +"월  "+ recv_date2.substring(6,8) +"일";
//	     document.forms.contentForm.st_recv_date.value   = recv_date;
//	     document.forms.contentForm.st_recv_date2.value  = recv_date2;
	<%-- 	<% } %> --%>

    //** PG_06_B_008_00 **//
    $('#contentForm').attr("action", "<%=h_sslurl%>/mpso/getBuyerMpSoOrderInfoList.do").submit();    
    //document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_list.jsp"; 
}

<%-- 주문 정보 변경 --%>
function order_info_modify(){ 
	document.forms.contentForm.st_query_cart.value = "";
	$('#contentForm').attr("action", "<%=p060000036%>").submit();    
}

<%--   ////////////////////  주문접수  후  DB INSERT  ////////////////////////// --%>
function order_submit(recvFlag){         
	<%if(po_alarm_flag) { // 특정  고객사에서 특정 카테고리 품목을 구매하려 하는 경우%> 
		alert("<%=p060000118_p%>");
	<% } %> 

	
	var card_yn = document.forms.contentForm.card_yn.checked;
 	<%
   	//카트결재 필수 조건 체크.
   	if (p060000043_yn == true){ %>
   		card_yn = true;
   	<%}%>
    if(!card_yn) { //아래 if절은 기존과 동일///swf

		var person_author = document.forms.contentForm.st_person_author.value;
		if(person_author == "PO"){
		     //구매발주 하시겠습니까?
			if(recvFlag == '1' && !confirm("<%=CommonLang.msg("MSG454") %>  ")) 
		    	return;
		}else {
		    //구매요청 하시겠습니까?
			if(recvFlag == '1' && !confirm("<%=CommonLang.msg("MSG455") %>  ")) 
		          	return;
		}
		
		var buyer         = document.forms.contentForm.st_buyer.value;
		var userDept      = document.forms.contentForm.st_user_dept.value;
		var ACCOUNT_TYPE  = document.forms.contentForm.st_account_type.value;
		var tot_price     = eval(document.forms.contentForm.nu_tot_price.value);
		var bdgt_flag     = document.forms.contentForm.st_bdgt_flag.value;
		
		var budget_flag = "<%=budget_flag%>";
		
		if(budget_flag == "Y") {
		    doCheckAMT(buyer,userDept,ACCOUNT_TYPE,tot_price,tot_price,recvFlag);
		}else {
		   	setData(recvFlag);
		}
    } else {

        var person_author = document.forms.contentForm.st_person_author.value;
        var buyer         = document.forms.contentForm.st_buyer.value;
        if(buyer != "KRKEPB0004" && buyer !="KRSAMS0154")
        if(person_author != "PO"){
            //발주권한자만 카드결재를 진행할 수 있습니다
        	alert('<%=CommonLang.msg("MSG456") %>');
            return;
        }

        var userDept      = document.forms.contentForm.st_user_dept.value;
        var ACCOUNT_TYPE  = document.forms.contentForm.st_account_type.value;
        var tot_price     = eval(document.forms.contentForm.nu_tot_price.value);
        var bdgt_flag     = document.forms.contentForm.st_bdgt_flag.value;
        var budget_flag = "<%=budget_flag%>";

        if(budget_flag == "Y") {
        	
            doCheckAMT(buyer,userDept,ACCOUNT_TYPE,tot_price,tot_price,recvFlag);

        } else {
        	
            var person_author = document.forms.contentForm.st_person_author.value;
            recvFlag ="3";//swf
            if (recvFlag=="3") {
                var GW_NO = "N";
                var recvFlag = "GA";
                if(document.forms.contentForm.cbx.checked == true){
                    document.forms.contentForm.st_gr_flag.value = "S";
                }else if(document.forms.contentForm.cbx1.checked == true){
                    document.forms.contentForm.st_gr_flag.value = "F";
                }else{
                    document.forms.contentForm.st_gr_flag.value = "N";
                }

                document.forms.contentForm.GW_NO.value = GW_NO;
                document.forms.contentForm.recvFlag.value = recvFlag;
                var buyer = document.forms.contentForm.st_buyer.value;

                var limit = "<%=rec_cnt%>";
                set_cart_date(limit);

                $('#contentForm').attr("action", "/module/kcp/sample/chk_plugin.jsp").submit();
            }
        }
    }
}

function getDeliveryToLocation(com_code){
	popupSel = "location";
	openSearchPopup("/common/delLocationPop.do", "?com_code="+com_code+"&open=Y", "500,500,no");
}

function getnewzipCode(){
	popupSel = "newzipcode";
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");		
}

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	document.forms.contentForm.st_location_name.value = zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail;
    document.forms.contentForm.st_location_name.focus();
}

<%-- /////////////////////   기본 배송정보 입력     //////////////////////////////////////// --%>
function CheckSubmit(value){    
    var purchase_dept_code = document.forms.contentForm.st_purchase_dept_code.value;
    var location_code      = document.forms.contentForm.st_location_code.value;
    var tel_no             = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no             = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile             = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;
    var user_name          = document.forms.contentForm.st_user_name.value;
    var email              = document.forms.contentForm.st_email.value;
    document.forms.contentForm.st_tel_no.value        = tel_no;
    document.forms.contentForm.st_fax_no.value        = fax_no;
    document.forms.contentForm.st_mobile_no.value     = mobile;
    document.forms.contentForm.st_email.value         = email;
    
    if(value == '2'){ //  정보 반영시 확인
	    document.forms.contentForm.st_purchase_dept_code.value = purchase_dept_code;
    	document.forms.contentForm.st_location_code.value = location_code;
	    document.forms.contentForm.st_user_id.value       = "<%=userId%>";
    	document.forms.contentForm.st_buyer.value         = "<%=buyer%>";
    	confirm_submit(value);
    	if (dely_valid_flag){
			kepAjaxFormCall("/mpso/buyerDeliveryInfo.do","contentForm","BUYERDELIVERYINFO"+value); 
   		}
    }
    //document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_info_update.jsp";


}
</script>
</html>