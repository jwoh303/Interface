<%--
**********************************************
* 메뉴 : 장바구니 > 주문/결제
* 화면 : 장바구니 > 주문/결제
* 기능 : 
* 프로그램 ID : BU0401004
* 담당자 : 최찬규
* 착수일 : 2026-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head> 
<%@ include file="../../common/include/head_v2.jspf"  %>
<link rel="stylesheet" type="text/css" href="/resources/css/month_popup.css" />
</head>
<style>
	.scroll-indicator {
  position: fixed;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  border-radius: 999px;
  font-size: 12px;
  pointer-events: none;
  opacity: 1;
  transition: opacity 0.2s ease;
  z-index: 999;
  white-space: nowrap;
}
.scroll-indicator.hidden {
  opacity: 0;
}
#orderBtn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과	 
	//선입고장바구니에서 넘오온건이면 선입고 발주 필수.
	String total_cnt = "0"; // 총 조회수 (필수)
	if (_gridList != null){
		total_cnt = String.valueOf(_gridList.size());
	}	
	
	
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
    
	double tot_price = 0;
	int tot_product_cnt = 0;
	String account_type = "";
	String bdgt_flag = "";
		
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
    
  	//SLOGIC-BEGIN(P06-0000036)
    String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
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
	
	//인수자명,인수자연락처 비고에 넣어주는 특수로직 -> 기존에는 인수자명(전화번/휴대전화번호호 였음)
	boolean p060000074 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000074");
	
	// 납기요청일 통제
	boolean p060000117 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000117");
	/* ***** 현재 페이지의 배송정보 수정을 위해서 추가 ***** */
	boolean p060000041 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000041"); // KRDAEW0080 KRDAEW0081 KRDAEW0082
	
	// 발주 알림 메세지
	String p060000118 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000118","COL01_DATA"); // 카테고리 코드
	String p060000118_p = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000118","COL02_DATA"); // 문구
	boolean po_alarm_flag = false;
	
	// 특이사항 명칭 변경
	Map<String, String> p060000122_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000122");
	String p060000122_col1 = CommonLang.get("HTITLE1225"); // 특이사항 명칭 변경 값 / default - 배송특이사항
	String p060000122_col2 = ""; // default value 값
    if (p060000122_map != null){
    	p060000122_col1 = CommonUtil.nvl(p060000122_map.get("COL01_DATA"),""); 
    	p060000122_col2 = CommonUtil.nvl(p060000122_map.get("COL02_DATA"),"");
    }
	
	
 	// 발주부서 명칭 변경
  	Map<String, String> p060000126_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000126");
  	String p060000126_col1 = CommonLang.get("HTITLE188"); // 발주부서 명칭 변경 값 / default - 발주부서
  	
     if (p060000126_map != null){
     	p060000126_col1 = CommonUtil.nvl(p060000126_map.get("COL01_DATA"),"");
     }
  	
     boolean p060000090 = false;
     //예산사용 고객사만 관리부서 통제 특수로직이 적용 됨.
     if(budget_flag.equals("Y")){
     	p060000090 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000090");
     }
     
     String imsi_po_remark = "";
     String emer_po_remark = "";
     Map<String, String> bca00001_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"BCA00001");
     if(bca00001_map != null) {
		imsi_po_remark = bca00001_map.get("COL01_DATA");
		emer_po_remark = bca00001_map.get("COL02_DATA");
	}
     
     
     ArrayList<String> dely_name_list = new ArrayList<String>();
     ArrayList<String> dely_text_list = new ArrayList<String>();
     ArrayList<Integer> cnt_list = new ArrayList<Integer>();
	    
     if( p060000100 == true){
   	    String dely_text_temp = "";
   	 	String dely_code_temp = "";
   	    int cnt_temp = 0;
   		if (_gridList != null){
   			if (_gridList.size()>0){
   				for(int i = 0; i<_gridList.size(); i++){
   					Map<String,String> rowItemData = _gridList.get(i);
   					if(!rowItemData.get("DELY_TO_LOCATION_TEXT").equals(dely_text_temp) || !rowItemData.get("DELY_TO_LOCATION").equals(dely_code_temp)){
   						if(i != 0){
   							cnt_list.add(cnt_temp);
   							cnt_temp = 1 ;
   						}else{
   							cnt_temp++;
   						}
   						dely_name_list.add(rowItemData.get("DELY_TO_LOCATION_NAME"));
   						dely_text_list.add(rowItemData.get("DELY_TO_LOCATION_TEXT"));
   						dely_text_temp = rowItemData.get("DELY_TO_LOCATION_TEXT");
   						dely_code_temp = rowItemData.get("DELY_TO_LOCATION");
   					}else{
   						cnt_temp++;
   					}
   					if(i == _gridList.size() -1){
   						cnt_list.add(cnt_temp);
   					}
   				}
   			}
   		} 
     }

%> 
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
    <%=CommonLang.get("HTITLE1424") %><!-- 주문/결제 -->
    <div class="CartGuide">
      <div class="CartGuideTxt_on"><p>1</p><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_on"><p>2</p><%=CommonLang.get("HTITLE1424") %><!-- 주문/결제 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_off"><p>3</p><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></div> 
    </div>
  </div>
 <form name = "contentForm" id="contentForm" method = "post">
 		<input type="hidden" name="cmd"						value="iPR">
		<input type="hidden" name="buyer"					value="<%=buyer%>">
		<input type="hidden" name="prNo"					value="">
		<input type="hidden" name="pxNo"					value="">
		<input type="hidden" name="userid" value="<%=userId%>">

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
		<input type="hidden" name="st_location_type" value="<%=st_location_type%>">
		<input type="hidden" name="recvFlag" value="">
		<input type="hidden" name="GW_NO" value=""> 
		<input type="hidden" name="st_gr_flag" value=""> 
		<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
		<input type="hidden" name="st_po_create_date" value="<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>">
		<input type="hidden" name="st_verif_num" value="<%=verif_num%>">
		<input type="hidden" name="st_recv_date" value="<%=st_recv_date%>">
		<input type="hidden" name="st_recv_date2" value="<%=st_recv_date2%>">
		<input type="hidden" name="st_user_name" value="<%=st_user_name%>">
		<input type="hidden" name="st_tel_no" value="<%=st_tel_no%>"> 
		<input type="hidden" name="st_fax_no" value="<%=st_fax_no%>"> 
		<input type="hidden" name="st_mobile_no" value="<%=st_mobile_no%>">
		<input type="hidden" name="st_email" value="<%=st_email%>">
		<input type="hidden" name="st_location_name" value="<%=st_location_name%>">
		<input type="hidden" name="st_location_code" value="<%=st_location_code%>">
		<input type="hidden" name="st_location_code_name" value="<%=st_location_code_name%>">
		
		<!-- 신용카드결제 변수 -->
		<input type="hidden" name="st_item_name"  value="">
		<input type="hidden" name="st_mg_note"		value=""> 
		<input type="hidden" name="st_ref_pr_no"		value=""> 
		<input type="hidden" name="card_cd"		value=""> 
		<input type="hidden" name="card_name"		value=""> 
		<input type="hidden" name="tno"		value=""> 
		<input type="hidden" name="amount"		value="">
		<!-- 신용카드결제 변수 -->
		
		
  <div class="CARTcontainer">
	<div class="CARTleft">
	<%if(!p060000100) {%> <!-- 품목별 배송지가 아닌 경우 , 데이터의 0번째 INDEX로 가져옴(다 똑같음) -->
      <!--배송정보 -->  
      <div class="CART_Addbox mt20">
        <div class="CART_AddboxTit"><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --> </div>
        <p class="Shipper"><%=_gridList.get(0).get("DELY_TO_LOCATION_NAME") %></p>
        <p class="DeliveryAdd mt10"><%=_gridList.get(0).get("DELY_TO_LOCATION_TEXT") %></p>
        <p class="DeliveryAdd mt10"><%=_gridList.get(0).get("RECV_USER_NAME") %> <span class="DeliveryAddBr">｜</span> <%=_gridList.get(0).get("RECV_USER_TEL") %>  <span class="DeliveryAddBr">｜</span> <span class="DeliveryDate"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></span> <%=_gridList.get(0).get("RD_DATE") %></p>
      </div>
      <div class="CART_Sort mt20">
        <p><%=CommonLang.get("HTITLE1222") %><!-- 주문품목 --> <span>(<%=total_cnt %>)</span></p> 
        <div class="Rrightlabel"><label class="CheckLargeLabel"><input type="checkbox" id="viewCheck" onchange="javascript:viewChange();"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE1431")%><!--간략보기--></label></div>
      </div>
      <div id="normalView">	
      <%
	      Map<String,String> rowData = null;
	      for(int j = 0; j<_gridList.size(); j++) {
				rowData = _gridList.get(j);
				
				tot_price += Double.parseDouble( rowData.get("TOT_SUM") );
				tot_product_cnt ++;
				account_type = rowData.get("ACCOUNT_TYPE");
				bdgt_flag    = rowData.get("BDGT_FLAG");
				
				if(p060000118.contains(rowData.get("CATEGORY_NO"))){ // 카테고리 코드가 포함되어 있으면 true
					po_alarm_flag = true;	
				}
      %>
	  <div class="CART_PDbox mt20" >
		<table class="CART_PDboxTable">
          <colgroup>
            <col width="440px" />
            <col width="280px" />
            <col width="220px" />
		  </colgroup>
		  <tr>
			<td>
					<% if(seq_flag.equals("Y")){ %>
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%><%=rowData.get("CART_SEQ")%>" />
					<% } else {  %> 
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%>" />
					<% } %>
					<input type="hidden" name="fromDate<%=j%>" id="fromDate<%=j%>" value="<%=rowData.get("RD_DATE_ORG")%>" />
              <div class="CART_PDboxPDimg">
<!--               <img src="/resources/imgs/img01.jpg" /> -->
              <img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'" />
              </div>
              <div class="CART_PDbox_CodeName ">
                <div class="Code"><%=rowData.get("BUYER_ITEM_NO") %></div><div class="Name"><%=rowData.get("DESCRIPTION_LOC")%></div>
                <dl class="CART_PDbox_Detail" >
                 <dt><%=CommonLang.get("HTITLE14") %><!-- 규격 --></dt><dd><%=rowData.get("SPECIFICATION")%></dd><br/>
                 <dt><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></dt><dd><%=rowData.get("MAKER_NAME")%> / <%=rowData.get("ORIGIN_NAME")%></dd><br/>
                 <dt><%=CommonLang.get("HTITLE52") %><!-- 단위 --></dt><dd><%=rowData.get("UNIT_MEASURE")%></dd>
			    </dl>
              </div> 
			</td>
			<td><div class="CART_PDPrice mt30"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></div><div class="CART_PDOrderNum mt30"><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%><%=rowData.get("UNIT_MEASURE")%></div></td>
			<td><dl class="CART_PDPriceAll mt30"><dt></dt><dd><span><%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></dd></dl>
		  		<dl class="CART_PDFileAdd mt15"><dt><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --></dt><dd><a href="javascript:fileDown('<%=j%>');"><%=CommonUtil.formatNumber(rowData.get("IMAGE_KEY_CNT"),true,0,3)%><%=CommonLang.get("HTITLE96")%><!-- 개 --></a></dd></dl>
		        <input type="hidden" name="imageKey<%=j%>" id="imageKey<%=j%>" value="<%=rowData.get("IMAGE_KEY")%>" />
		        <div class="CART_PDFileAddBigo mt10"><%=rowData.get("REMARK") %></div>
		  </tr>
		</table>
		<%if(budget_flag.equals("Y")) {%>
		<div class="CARTOrder_BudgetInfo mt20">
          <div class="tit"><%=CommonLang.get("HTITLE1434")%><!--예산정보--></div>
          <p><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></p>
          <%if(p060000090 == true) { %><!-- 관리부서 통제가 들어갈 경우 계정정보+관리부서로 보여 짐 -->
          <input class="" style="width:210px"  disabled="disabled"  name="" value="<%=rowData.get("MNG_DEPT_NM")%>" type="text" />
          <%}else{ %>
          <input class="" style="width:210px"  disabled="disabled"  name="" value="<%=rowData.get("ACCOUNT_NAME")%>" type="text" />
          <%} %>
          <p><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></p>
          <input class="" style="width:178px"  disabled="disabled"  name="" value="<%= rowData.get("BUDGET_DEPT_NAME")%>" type="text" />
          <p><%=CommonLang.get("HTITLE1435")%><!--예산잔액--></p>
          <%if(rowData.get("VIEW_FLAG").equals("N")){ %>
          <input class="" style="width:161px; text-align:right"  disabled="disabled"  name="" value="0" type="text" />
          <%}else{ %>
          <input class="" style="width:161px; text-align:right"  disabled="disabled"  name="" value="<%=CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" type="text" />
          <%} %>
        </div>
        <%} %>
      </div>
      <div class="BorderBottomSolid mt20"></div>
      <%} %>
      			<input type="hidden" name="nu_tot_price" id="nu_tot_price" value="<%=tot_price%>">
      			<input type="hidden" name="nu_tot_cnt" id="nu_tot_cnt" value="<%=tot_product_cnt%>">
				<input type="hidden" name="st_account_type" id="st_account_type" value="<%=account_type%>">
				<input type="hidden" name="st_bdgt_flag" id="st_bdgt_flag" value="<%=bdgt_flag%>">
      </div>
      
      <!-- 간략보기 -->
      	<table class="SimpleView" id="simpleView" width="960px" style="display:none; ">
          <tr>
            <th width="160px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
            <th width="200px"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
            <th width="230px"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
            <th width="130px"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
            <th width="100px"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
            <th width="140px"><%=CommonLang.get("HTITLE922")%><!-- 합계 --></th>
          </tr>
      <%
	      for(int j = 0; j<_gridList.size(); j++) {
				rowData = _gridList.get(j);
      %>
      
          <tr>
            <td align="center"><%=rowData.get("BUYER_ITEM_NO") %></td>
            <td align="left"><%=rowData.get("DESCRIPTION_LOC") %></td>
            <td align="left"><%=rowData.get("SPECIFICATION") %></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
          </tr>
      <%} %>
	  </table>
      
	 <%}else{ %>
	 	<!--배송지묶음 -->  
      <div class="CART_SortBig mt20">
        <p><%=CommonLang.get("HTITLE824")%><!-- 배송정보 --> <span>(<%=dely_name_list.size() %>)</span></p> 
        <div class="Rrightlabel"></div>
      </div>
      <%
      	int index = 0;
	    boolean startFlag = true; //첫 시작 flag
	    int index2 = 0;
	    boolean startFlag2 = true; //첫 시작 flag
      	for(int i = 0; i<dely_name_list.size(); i++){ %>
      	<div class="CART_Addbox mt20">
			<div class="DelAdd mb20">
	          <div><%=CommonLang.get("HTITLE583")%><!-- 배송지 --><%=i+1 %></div> 
	          <div><%=dely_name_list.get(i) %></div>
	          <div><%=dely_text_list.get(i) %></div>
	        </div>
			<div class="DelGoods"><%=CommonLang.get("HTITLE1222") %><!-- 주문품목 --> <span>(<%=cnt_list.get(i) %>)</span> <div class="Rrightlabel"><label class="CheckMediumLabel"><input type="checkbox" id="viewCheck<%=i %>" onchange="javascript:viewChange('<%=i%>');"><span class="CheckMediumCustom"></span><%=CommonLang.get("HTITLE1431")%><!--간략보기--></label></div></div>
      		<div id="normalView<%=i%>">	
      		<%
      		for(int j = index ; j<_gridList.size(); j++) {
      			Map<String,String> rowData = _gridList.get(j);
				
				if(!startFlag){
					Map<String,String> rowData2 = _gridList.get(j-1);
					if(!rowData.get("DELY_TO_LOCATION_TEXT").equals(rowData2.get("DELY_TO_LOCATION_TEXT")) || !rowData.get("DELY_TO_LOCATION").equals(rowData2.get("DELY_TO_LOCATION"))){
						startFlag = true;
						index = j;
						break;
					}
				}
				
				tot_price += Double.parseDouble( rowData.get("TOT_SUM") );
				tot_product_cnt ++;
				account_type = rowData.get("ACCOUNT_TYPE");
				bdgt_flag    = rowData.get("BDGT_FLAG");
				
				
				if(p060000118.contains(rowData.get("CATEGORY_NO"))){ // 카테고리 코드가 포함되어 있으면 true
					po_alarm_flag = true;	
				}
				
      		%>
		        <div class="CART_PDboxTableBg mb15">
				  <table class="CART_PDboxTable">
		            <colgroup>
		              <col width="425px" />
		              <col width="240px" />
		              <col width="210px" />
				    </colgroup>
				    <tr>
					  <td>
		                <div class="CART_PDboxPDimg">
<!-- 		                <img src="/resources/imgs/img02.jpg" /> -->
		                <img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'" />
		                </div>
		                <div class="CART_PDbox_CodeName ">
		                  <div class="Code"><%=rowData.get("BUYER_ITEM_NO") %></div><div class="Name"><%=rowData.get("DESCRIPTION_LOC") %></div>
		                  <dl class="CART_PDbox_Detail" >
		                   <dt><%=CommonLang.get("HTITLE14")%><!-- 규격 --></dt><dd><%=rowData.get("SPECIFICATION") %></dd><br/>
		                   <dt><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></dt><dd><%=rowData.get("MAKER_NAME") %> / <%=rowData.get("ORIGIN_NAME") %></dd><br/>
		                   <dt><%=CommonLang.get("HTITLE52")%><!-- 단위 --></dt><dd><%=rowData.get("UNIT_MEASURE") %></dd><br/>
		                   <dt><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></dt><dd><%=rowData.get("REF_PR_NO") %></dd>
					      </dl>
		                <div class="CART_PDbox_Date"><%=rowData.get("RECV_USER_NAME") %><span>｜</span><%=rowData.get("RECV_USER_TEL") %><span>｜</span>수령희망일 <%=rowData.get("RD_DATE") %></div
		                </div> 
					  </td>
					  <td style="vertical-align:middle"><div class="CART_PDPrice"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></div><div class="CART_PDOrderNum"><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%><%=rowData.get("UNIT_MEASURE") %></div></td>
					  <td style="vertical-align:middle"><dl class="CART_PDPriceAll "><dt></dt><dd><span><%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></dd></dl>
		              <dl class="CART_PDFileAdd mt15"><dt><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --></dt><dd><a href="javascript:fileDown('<%=j%>');"><%=CommonUtil.formatNumber(rowData.get("IMAGE_KEY_CNT"),true,0,3)%><%=CommonLang.get("HTITLE96")%><!-- 개 --></a></dd></dl>
		              <input type="hidden" name="imageKey<%=j%>" id="imageKey<%=j%>" value="<%=rowData.get("IMAGE_KEY")%>" />
		              <div class="CART_PDFileAddBigo mt10"><%=rowData.get("REMARK") %></div>
		 		    </tr>
				  </table>
				  <%if(budget_flag.equals("Y")) {%>
					<div class="CARTOrder_BudgetInfo mt20">
			          <div class="tit"><%=CommonLang.get("HTITLE1434")%><!--예산정보--></div>
			          <p><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></p>
			          <%if(p060000090 == true) { %><!-- 관리부서 통제가 들어갈 경우 계정정보+관리부서로 보여 짐 -->
			          <input class="" style="width:194px"  disabled="disabled"  name="" value="<%=rowData.get("MNG_DEPT_NM")%>" type="text" />
			          <%}else{ %>
			          <input class="" style="width:194px"  disabled="disabled"  name="" value="<%=rowData.get("ACCOUNT_NAME")%>" type="text" />
			          <%} %>
			          <p><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></p>
			          <input class="" style="width:160px"  disabled="disabled"  name="" value="<%= rowData.get("BUDGET_DEPT_NAME")%>" type="text" />
			          <p><%=CommonLang.get("HTITLE1435")%><!--예산잔액--></p>
			          <%if(rowData.get("VIEW_FLAG").equals("N")){ %>
			          <input class="" style="width:146px; text-align:right"  disabled="disabled"  name="" value="0" type="text" />
			          <%}else{ %>
			          <input class="" style="width:146px; text-align:right"  disabled="disabled"  name="" value="<%=CommonUtil.formatNumber(rowData.get("BDGT_BAL_AMT"), true, 0, 3)%>" type="text" />
			          <%} %>
			        </div>
			       <%} %>
			       
			       <% if(seq_flag.equals("Y")){ %>
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%><%=rowData.get("CART_SEQ")%>" />
					<% } else {  %> 
						<input type="hidden" name="BUYER_ITEM_NO_ARRRAY<%=j%>" id="BUYER_ITEM_NO_ARRRAY<%=j%>" value="<%=rowData.get("BUYER_ITEM_NO")%><%=rowData.get("CONTRACT_NO")%><%=rowData.get("CONTRACT_SEQ")%>" />
					<% } %>
					<input type="hidden" name="fromDate<%=j%>" id="fromDate<%=j%>" value="<%=rowData.get("RD_DATE_ORG")%>" />
		        </div>         
      		<%
      		startFlag = false;
      		} %>
      		</div>
      		
      		<!-- 간략보기 -->
      		<div class="SimpleViewScroll02" id="simpleView<%=i %>" style="display:none; ">
		      <table class="SimpleView"  width="1000px" >
		          <tr>
		            <th width="150px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
		            <th width="200px"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
		            <th width="250px"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE922")%><!-- 합계 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE827")%><!-- 인수자명 --></th>
		          </tr>
		      <%
			      for(int j = index2; j<_gridList.size(); j++) {
			    	  Map<String,String> rowData = _gridList.get(j);
						if(!startFlag2){
							Map<String,String> rowData2 = _gridList.get(j-1);
							if(!rowData.get("DELY_TO_LOCATION_TEXT").equals(rowData2.get("DELY_TO_LOCATION_TEXT")) || !rowData.get("DELY_TO_LOCATION").equals(rowData2.get("DELY_TO_LOCATION"))){
								startFlag2 = true;
								index2 = j;
								break;
							}
						}
		      %>
		      
		          <tr>
		            <td align="center"><%=rowData.get("BUYER_ITEM_NO") %></td>
		            <td align="left"><%=rowData.get("DESCRIPTION_LOC") %></td>
		            <td align="left"><%=rowData.get("SPECIFICATION") %></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
		          	<td align="center"><%=rowData.get("RECV_USER_NAME") %></td>
		          </tr>
		      <%
		      	startFlag2 = false;
			      } %>
			  </table>
			 </div>
		 </div>
      <%} %>
      		<input type="hidden" name="nu_tot_price" id="nu_tot_price" value="<%=tot_price%>">
      		<input type="hidden" name="nu_tot_cnt" id="nu_tot_cnt" value="<%=tot_product_cnt%>">
			<input type="hidden" name="st_account_type" id="st_account_type" value="<%=account_type%>">
			<input type="hidden" name="st_bdgt_flag" id="st_bdgt_flag" value="<%=bdgt_flag%>">
	 <%} %>
	 
	 <div class="h50"></div>
	</div>
	
	<div class="CARTright">
      <div class="OptionBoxLine"> <div class="OptionTit mt30 mb30 ml20 mr20"><%=CommonLang.get("HTITLE1430")%><!--선택품목--> <p class="OptionBoxLine_Num"><span><%=CommonUtil.formatNumber(tot_product_cnt,true,0,3)%></span><%=CommonLang.get("HTITLE96")%><!-- 개 --></p></div></div>
      <div class="OptionTit mt30 mb30 ml20 mr20" style=" height:80px;"><%=CommonLang.get("HTITLE1059")%><!-- 주문금액 --> <p class="OptionBoxLine_Pric mt10"><span><%=CommonUtil.formatNumber(tot_price,true,0,3)%></span><%=CommonLang.get("HTITLE660")%><!-- 원 --></p></div>
      <div class="Option_GrayBox mt15">
        <div class="font17px font700"><%=p060000126_col1 %></div>
        <div class="mt05"> <input class="input30" style="width:148px;"  name="st_purchase_dept_name" id="st_purchase_dept_name" value="<%=purchase_dept_name%>" type="text" readonly/>
         <%if (p060000041 != true) { %>
         	<button class="ButOutline_Small" onclick="javascript:setDeptCodeSearch('<%=buyer%>');return false;" ><%=CommonLang.get("HTITLE825") %><!-- 변경 --></button>
         <%} %>
         </div>
      	<input type="hidden" name="st_purchase_dept_code" id="st_purchase_dept_code" size="50" value="<%=purchase_dept_code%>">
      </div>
      <%if(!p060000048) {%>
      <div class="Option_GrayBox mt15">
        <div class="OptionTit_m"><label class="CheckMediumLabel"><input type="checkbox" name="imsi_po_create_date_check" id="imsi_po_create_date_check" onchange="javascript:checkFunc('imsi_po_create_date');"><span class="CheckMediumCustom"></span> </label> <%=CommonLang.get("HTITLE842")%><!-- 선입고 --></div>
        <div class="OptionTit_Date" id="imsi_po_create_date_div" style="display: none;"><%=CommonLang.get("HTITLE1432")%><!--선입고 날짜--></div>
        <div class="datepicker-wrap" id="imsi_po_create_date_div2" style="display: none"><div class="date-input" data-datepicker><input type="text" name="imsi_po_create_date" id="imsi_po_create_date" onchange="javascript:preGrDateSet();" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>" readonly /><span>1 </span></div></div>
        <div class="OptionTit_mtxt BorderTopSolid"><img src="/resources/imgs/Icon_Importance02.png" /> <%=CommonLang.msg("MSG898")%><!--선입고란--> <br/><%=CommonLang.msg("MSG899")%><!--시스템 발주 전에 미리 제품을 요청하여 입고를 받은 경우입니다.--></div>
      	<div class="TextField mt10" id="imsi_po_remark_div" style="display: none;">
          <textarea id="st_imsi_po_remark" name="st_imsi_po_remark" maxlength="400"  value="" placeholder="" style=" width:185px"><%=imsi_po_remark %></textarea>
          <div class="meta" aria-live="polite"></div>
        </div>
      </div>
      <%} %>
      <%if(!p060000047) {%>
      <div class="Option_GrayBox mt15">
        <div class="OptionTit_m"><label class="CheckMediumLabel"><input type="checkbox" name="emer_po_check" id="emer_po_check" onchange="javascript:checkFunc('emer_po');"><span class="CheckMediumCustom"></span> </label> <%=CommonLang.get("HTITLE1433")%><!--긴급발주요청--></div>
        <div class="OptionTit_mtxt BorderTopSolid"><img src="/resources/imgs/Icon_Importance02.png" /> <%=CommonLang.msg("MSG900")%><!--긴급발주--> <br/><%=CommonLang.msg("MSG901")%><!--급히 물건을 입고 받고자 긴급하게 요청하는 경우로 운영자에게 SMS 알림이 전달됩니다.--></div>
      	<div class="TextField mt10" id="emer_po_remark_div" style="display: none;">
          <textarea id="st_emer_po_remark" name="st_emer_po_remark" maxlength="400"  value="" placeholder="" style=" width:185px"><%=emer_po_remark %></textarea>
          <div class="meta" aria-live="polite"></div>
        </div>
      </div>
      <%} %>  
      <input type="hidden" name="st_doc_type_remark" value="">    
      <div class="Option_GrayBox mt15">
        <div class="OptionTit_m"><label class="CheckMediumLabel"><input type="checkbox" name="delivery_remark_check" id="delivery_remark_check" onchange="javascript:checkFunc('delivery_remark');"><span class="CheckMediumCustom"></span> </label><%=p060000122_col1 %></div>
        <div class="OptionTit_mtxt BorderTopSolid"><img src="/resources/imgs/Icon_Importance02.png" /><%=CommonLang.msg("MSG902")%><!--주문 품목의 배송 시 주의/요청사항을 기재하여 주세요.--></div>
        <div class="TextField mt10" id="delivery_remark_div" style="display: none;">
          <textarea id="st_remark" name="st_remark" maxlength="400"  value="" placeholder="" style=" width:185px"></textarea>
          <div class="meta" aria-live="polite"></div>
        </div>
          <input type="hidden" name="st_remark2" value="">
      </div>
      
      <div class="CARTBox" id="CART-Box">
      	<div class="scroll-indicator" id="scrollIndicator">
  			<span>아래까지 확인 후 주문 가능</span> ▼
		</div>
        <button class="ButPrimary_large mt15 mb08" onclick="javascript:order_submit('1');return false;" id="orderBtn"><%=CommonLang.get("HTITLE839")%><!-- 주문하기 --></button><br/>
        <button class="ButOutline_large mb20" onclick="javascript:order_cancle(); return false;"><%=CommonLang.get("HTITLE225")%><!-- 주문취소 --></button>
      </div><!-- CARTBox -->
    </div><!-- CARTright -->    
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
	<input type="hidden" id="pm_attach_yn" name="pm_attach_yn" value="N">
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

<form name="endForm" id="endForm" method="post">
	<input type="hidden"  name = "buyer"  value="<%=buyer%>"/>
	<input type="hidden"  name = "key_1"  value=""/>
	<input type="hidden"  name = "type"  value=""/>
	<input type="hidden"  name = "passYn"  value="N"/>
	<input type="hidden"  name = "st_gr_flag"  value=""/>
</form>

<!--내용 종료-->	
 <br>                

<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>
<script>
var disabledFlag = true;
const CARTBox = document.getElementById('CART-Box');
const footer = document.querySelector('.footer');
const CARTcontainer = document.querySelector('.CARTcontainer');
const CARTright = document.querySelector('.CARTright');
const indicator = document.getElementById('scrollIndicator');
const orderBtn = document.getElementById('orderBtn');

function updateScrollIndicator() {
	  const docHeight = document.documentElement.scrollHeight;
	  const viewportHeight = window.innerHeight;
	  const scrollY = window.scrollY;

	  const isAtBottom = scrollY + viewportHeight >= docHeight - 2;

	  const footerRect = footer.getBoundingClientRect();
	  const footerTop = footerRect.top + window.scrollY;
	  const viewportBottom = scrollY + viewportHeight;
	  const reachedFooter = viewportBottom >= footerTop;

	  if (!isAtBottom && !reachedFooter) {
	    if(disabledFlag){
		    indicator.classList.remove('hidden');
		    orderBtn.disabled = true;
	    }
	    const rightRect = CARTright.getBoundingClientRect();
	    const boxRect = CARTBox.getBoundingClientRect();
	    indicator.style.left = (rightRect.left + rightRect.width / 2 - 70) + "px";
	    indicator.style.top = (boxRect.top - 20) + "px";
	  } else {
	    indicator.classList.add('hidden');
	    orderBtn.disabled = false;
	    disabledFlag = false;
	  }
}
	
function updateCARTBoxPosition() {
  const rightRect = CARTright.getBoundingClientRect();
  const footerRect = footer.getBoundingClientRect();
  const viewportHeight = window.innerHeight;

  // .CARTright의 문서 좌표 기준 왼쪽 위치 계산
  const rightLeft = rightRect.left + window.scrollX;

  // footer가 화면에 들어왔는지 확인
  const footerTop = footerRect.top + window.scrollY;
  const viewportBottom = window.scrollY + viewportHeight;

  if (viewportBottom >= footerTop) {
    // footer 진입 시 CARTcontainer 내부에 고정
    CARTBox.classList.remove('CartBottomBox-fixed');
    CARTBox.classList.add('CartBottomBox-absolute');
    CARTBox.style.CARTleft = ""; // fixed CARTleft 해제
  } else {
    // 일반 스크롤 시 화면 하단 고정
    CARTBox.classList.remove('CartBottomBox-absolute');
    CARTBox.classList.add('CartBottomBox-fixed');
    CARTBox.style.CARTleft = rightLeft+"px"; // 옵션박스의 왼쪽 라인 기준
  }
  updateScrollIndicator();
}

window.addEventListener('scroll', updateCARTBoxPosition);
window.addEventListener('resize', updateCARTBoxPosition);
updateCARTBoxPosition();
</script>
 
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";


var popupSel = "";
var dely_valid_flag = true;

// 최초 화면 함수 
function kep_onload_view(){	  
}

 
//조회
function kepSearch(curPage){ 
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderInfoList.do").submit();   
}
 
function order_cancle(){           ////////////////////  주문취소 후 장바구니 화면이동  //////////////////////////

        //주문을 취소하시겠습니까? \n\n 장바구니 화면으로 돌아갑니다.
        var text = " <%=CommonLang.msg("MSG453") %>   ";
    	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
    	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
     	var but1funcC = "javascript:go_cart(); return false;";
     	var but2funcC = "javascript:closePopText1(); return false;";
     	var but1widthC = "120px";
     	var but2widthC = "120px";
     	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
    	return;
}
function go_cart(){
	closePopText1();
	document.forms.contentForm.st_query_cart.value = "";
	$('#contentForm').attr("action", "<%=p060000036%>").submit();
}
function chk_user_tel_no(){
	var tel_no = document.forms.contentForm.st_tel_no.value;
	if (tel_no != null && tel_no.replace(/\s/g, "") != "") return true;

	var text = "<%=CommonLang.msg("MSG1000") %>";
	openLayerPopText2(text,but1text,but1func,but1width);
	return false;
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
	
	kepAjaxFormCall("/mpso/buyerAdminBdgtTempCheck.do","processForm","BUYER_ADMIN_BDGT_TEMP_CHECK"); 
}

function setData(recvFlag)
{
	if (chk_user_tel_no() == false) return;

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
		
<%-- 		var p060000100 = "<%=p060000100%>"; --%>
// 		if(p060000100 != "true"){
<%-- 			var p060000074 = "<%=p060000074%>"; --%>
// 			if(p060000074 == "true"){
<%-- 				document.forms.contentForm.st_remark.value += "/"+"<%=_gridList.get(0).get("RECV_USER_NAME") %>" + "(" +"<%=_gridList.get(0).get("RECV_USER_TEL") %>"+")"; --%>
// 			}
// 		}

			
			
		document.forms.contentForm.st_remark.value = document.forms.contentForm.st_remark.value.replace(/\r?\n/g, ' ');
		<%-- remark중복되는거방지--%>
// 		document.forms.contentForm.st_remark.value += document.forms.contentForm.st_remark2.value; 

		kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ"); 
    }
}

function ServerCall(GW_NO,recvFlag){ 
	if($("#imsi_po_create_date_check").is(":checked")){// 선입고
		document.forms.contentForm.st_gr_flag.value = "S";
		document.forms.contentForm.st_doc_type_remark.value = $("#st_imsi_po_remark").val().replace(/\r?\n/g, '<br>');
	}else if($("#emer_po_check").is(":checked")){ //긴급발주
		 document.forms.contentForm.st_gr_flag.value = "F";
		 document.forms.contentForm.st_doc_type_remark.value = $("#st_emer_po_remark").val().replace(/\r?\n/g, '<br>');
	}else{
		document.forms.contentForm.st_gr_flag.value = "N";
	}
	
	document.forms.endForm.st_gr_flag.value = document.forms.contentForm.st_gr_flag.value

    document.forms.contentForm.GW_NO.value = GW_NO;
    document.forms.contentForm.recvFlag.value = recvFlag;
    var buyer = document.forms.contentForm.st_buyer.value;

    var limit = "<%=total_cnt%>";       
    set_cart_date(limit);
    
    //alert($("#st_query_cart_date").val());	
    
    kepAjaxFormCall("/mpso/buyerNewCreateOrder_v2.do","contentForm","BUYER_NEW_CREATE_ORDER");   
}

function setCheckEnd(FLAG,recvFlag){
	if(FLAG == "OK"){			
		setData(recvFlag);
	}
}

function kepApprovalReturn(ERR,GW_NO){
	document.forms.endForm.passYn.value = "Y";
	EndPassProcess(ERR,GW_NO); 
}

// 상신결과
function EndPassProcess(ERR,GW_NO){
	
    if(ERR=="true"){
        ServerCall(GW_NO,"GS");
    }
}

function setCreate_Results(response){
	
    var result = response.msg.MSG;   
    var pr_type = result.substring(0,2);
	var person_author = document.forms.contentForm.st_person_author.value;	 

	if( pr_type != "PR" && pr_type != "PX" && true != <%=p060000062%> ){
		if(person_author == "PO"){
			//구매발주가 실패 하였습니다. 확인 후 다시 주문해 주십시요.
			var text = "<%=CommonLang.msg("MSG465")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}else {
			//구매요청이 실패 하였습니다. 확인 후 다시 주문해 주십시요.
			var text = "<%=CommonLang.msg("MSG466")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}

	var byca_comorg_code = document.forms.contentForm.st_byca_comorg_code.value;
	var buyer = document.forms.contentForm.st_buyer.value;

	// 2005/05/09 경동정밀 추가
	if ( true == <%=p060000062%>) {
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
		
	}

	document.forms.endForm.key_1.value = result;
	document.forms.endForm.type.value = document.forms.processForm.TYPE.value;
	//alert("결재상신 처리 되었습니다.");
	
	$('#endForm').attr("action", "/mpso/showBuyerMpSoOrderEnd_v2.do").submit();   
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
		$("#st_purchase_dept_name").val(value2);
		$("#st_purchase_dept_code").val(value1);
	}
}   

function setCreate_Benit_Results(response){

    var result = response.msg.MSG;        
    if(result == "OK"){
            //정상적으로 전송되었습니다.
            var text = "<%=CommonLang.msg("MSG159")%>";
			openLayerPopText2(text,but1text,"javascript:setCreate_Benit_end();return false;",but1width);
            //top.window.close();
    } else {
            //실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.
            var text = "<%=CommonLang.msg("MSG461")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
            return;
    }
}
function setCreate_Benit_end(){
	closePopText2();
	
	document.forms.contentForm.st_query_cart.value = "";
    $('#contentForm').attr("action", "/mpso/getBuyerMpSoCartList.do").submit();   
	
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
			//우편번호가 유효하지 않습니다.
			var text = "<%=CommonLang.msg("MSG450")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
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
		var text = "<%=CommonLang.msg("MSG451")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
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
			        var text = budget_dept_name +
		              "<br/>"+account_text+" <%=CommonLang.get("HTITLE694") %>    "+kepCommaNum(plan_amt)+"<%=CommonLang.get("HTITLE660") %> "+
		              "<br/>"+account_text+" <%=CommonLang.get("HTITLE843") %>    "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+"<%=CommonLang.get("HTITLE660") %> "+
		              "<br/>"+account_text+" <%=CommonLang.get("HTITLE844") %>    "+kepCommaNum(tot_price)+"<%=CommonLang.get("HTITLE660") %> "+
		              "<br/>"+"<%=CommonLang.msg("MSG384") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
			        return ;
			    } else if(flag == "예산미편성"){
			        //예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
			        var text = budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
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
	        var text = budget_dept_name +
            "<br/>"+account_text+" <%=CommonLang.get("HTITLE694") %>    "+kepCommaNum(plan_amt)+"<%=CommonLang.get("HTITLE660") %> "+
            "<br/>"+account_text+" <%=CommonLang.get("HTITLE843") %>    "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+"<%=CommonLang.get("HTITLE660") %> "+
            "<br/>"+account_text+" <%=CommonLang.get("HTITLE844") %>    "+kepCommaNum(tot_price)+"<%=CommonLang.get("HTITLE660") %> "+
            "<br/>"+"<%=CommonLang.msg("MSG384") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
	        //  parent.main.setCheckEnd('NO',recvFlag);
	        return ;
	    } else if(flag == "예산미편성"){
	        //예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
	        var text = budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
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
	    	//해당 주문은 이미 진행되었습니다.
	    	var text = "<%=CommonLang.msg("MSG462") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
	    	return;
	   	} 
		setCreate_Benit_Results(response);		
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 			
		
		var result = response.msg.MSG;
		if(result == "DUP"){
	    	//해당 주문은 이미 진행되었습니다.
	    	var text = "<%=CommonLang.msg("MSG462") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
	    	return;
		}else if(result == "OVER_STOCK"){
	    	//재고 초과 품목이 있어 주문이 불가능 합니다. 장바구니 화면에서 확인 바랍니다.
	    	var text = "<%=CommonLang.msg("MSG553") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
	    	return;
	   	} else if (result == "ERR") {
	   		var err_msg = "<%=CommonLang.msg("MSG463")%>";
	   		//주문에 실패했습니다.
	   		try {
	   			if ( true == <%=p110000004%> || true == <%=p110000004_type20%> || true == <%=p110000004_type22%> || true == <%=p110000004_type23%>) {
	   				err_msg = response.msg.ATTR1;
	   			}
	   		} catch (e) {}
			var text = err_msg;
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		setCreate_Results(response);
	}else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
		var checkpass = response.msg.CHECKPASS;   
		var pass_flag = response.msg.PASS_FLAG;   		
		var nu_tot_price = eval($("#nu_tot_price").val());
		var nu_tot_cnt = eval($("#nu_tot_cnt").val());
		var pm_attach_yn= document.forms.processForm.pm_attach_yn.value
		GoPass_v2(checkpass,pass_flag , nu_tot_price,"",pm_attach_yn,nu_tot_cnt);
	}
}

function GoPass_v2(checkpass,pass_flag , nu_tot_price,pass_buyer,pass_attach_yn,nu_tot_cnt){
	var type =  document.forms.processForm.TYPE.value;
	
	if(pass_flag == "G"){
        ServerCall("GROUPWARE","PS");
        return;
    }
	
	if(checkpass == "false" || checkpass == false) {        // 결재 처리를 하지 않는 경우

        if(type =="PR"){
            ServerCall("N","GA");
            return;
        }else {
            ServerCall("N","PC");
            return;
        }

    }else{
    	var buyer = document.forms.contentForm.st_buyer.value;
        if(pass_flag == "N"){
       	 	var text = "<%=CommonLang.msg("MSG802")%>";
       		var content = "<%=CommonLang.msg("MSG803")%>";
       		var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
       		var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; //  전자결재
       		var but3textC = "<%=CommonLang.get("HTITLE197")%>"; // 주문
       		var but1funcC = "javascript:closePopText3(); return false;";
       		var but2funcC = "javascript:executeReg('1','"+type+"','"+buyer+"','"+nu_tot_price+"','"+nu_tot_cnt+"'); return false";
       		var but3funcC = "javascript:executeReg('2','"+type+"','"+buyer+"','"+nu_tot_price+"','"+nu_tot_cnt+"'); return false";
       		var but1widthC = "120px";
       		var but2widthC = "150px";
       		var but3widthC = "150px";
       		openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
        }else{
	         openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=' + type + '&requesTemptYn=Y&DOCU_NO=&BIZ_DOCU_NO=&nu_tot_price='+nu_tot_price+'&nu_tot_cnt='+nu_tot_cnt+'&st_category_no='+'&st_buyer='+buyer+'&pass_attach_yn=' , "800,860,no");
        }
    }
}
function executeReg(flag,type,buyer,nu_tot_price,nu_tot_cnt){
	closePopText3();
	
	if(flag == "1"){ //전자결재
		openSearchPopup('/common/approval/buyerCommonApprovalPop.do','?DOC_TYPE=' + type + '&requesTemptYn=Y&DOCU_NO=&BIZ_DOCU_NO=&nu_tot_price='+nu_tot_price+'&nu_tot_cnt='+nu_tot_cnt+'&st_category_no='+'&st_buyer='+buyer+'&pass_attach_yn=' , "800,860,no");
	}else if(flag == "2"){ //바로 주문
		if(type =="PR"){
            ServerCall("N","GA");
            return;
        }else {
            ServerCall("N","PC");
            return;
        }
	}
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {

	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		//시스템 오류입니다. 관리자에게 전화하시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG227") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		//시스템 오류입니다. 관리자에게 전화하시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG227") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "BUYER_NEW_CREATE_BENIT"){ 
		//실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.
		var text = "<%=CommonLang.msg("MSG461") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG163") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG163") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "CHECKZIP"){
		dely_valid_flag = false;
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.   
		var text = "<%=CommonLang.msg("MSG163") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}else if ( pMethod == "BUYERDELIVERYINFO1"){
		//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG163") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
} 
<%-- 발주 부서 변경함수 --%>
function setDeptCodeSearch(buyer) {
		popupSel = "dept_buyer";
		openSearchPopup("/common/deptCodeAdminBuyerPop.do", "?com_code="+buyer, "560,420,no");	
}

<%--   ////////////////////  주문접수  후  DB INSERT  ////////////////////////// --%>
function order_submit(recvFlag){         
	<%if(po_alarm_flag) { // 특정  고객사에서 특정 카테고리 품목을 구매하려 하는 경우%> 
		var text = "<%=p060000118_p%>";
		openLayerPopText2(text,but1text,"javascript:order_submit_continue('"+recvFlag+"')",but1width);
		return;
	<% } %> 

	if($("#st_purchase_dept_code").val() == "" || $("#st_purchase_dept_name").val() == ""){
		//발주부서는 필수 입력 사항입니다.
	    var text = "<%=CommonLang.msg("MSG440") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	<%if (p060000122_map != null){ %>
	if($("#st_remark").val() == "") {
		//p060000122_col1 은(는) 필수 입력 사항입니다.
		var text = "<%=p060000122_col1%>"+"<%=CommonLang.msg("MSG995") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	<%}%>
	
	if($("#imsi_po_create_date_check").is(":checked")){
		if($("#imsi_po_create_date").val() == ""){
			//선입고 날짜를 선택하세요
			var text = "<%=CommonLang.msg("MSG906") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
	var person_author = document.forms.contentForm.st_person_author.value;
	var text = "";
	if(person_author == "PO"){
	     //구매발주 하시겠습니까?
		text = "<%=CommonLang.msg("MSG454") %>";
	}else {
	    //구매요청 하시겠습니까?
	    text = "<%=CommonLang.msg("MSG455") %>";
	}
	
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
 	var but1funcC = "javascript:order_submit_fin('"+recvFlag+"'); return false;";
 	var but2funcC = "javascript:closePopText1(); return false;";
 	var but1widthC = "120px";
 	var but2widthC = "120px";
 	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
 	return;
}
function order_submit_continue(recvFlag){         
	closePopText2();
	
	var person_author = document.forms.contentForm.st_person_author.value;
	var text = "";
	if(person_author == "PO"){
	     //구매발주 하시겠습니까?
		text = "<%=CommonLang.msg("MSG454") %>";
	}else {
	    //구매요청 하시겠습니까?
	    text = "<%=CommonLang.msg("MSG455") %>";
	}
	
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
 	var but1funcC = "javascript:order_submit_fin('"+recvFlag+"'); return false;";
 	var but2funcC = "javascript:closePopText1(); return false;";
 	var but1widthC = "120px";
 	var but2widthC = "120px";
 	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
 	return;
}
function order_submit_fin(recvFlag){
	closePopText1();
	//상단으로 이동
	window.scrollTo({
	    top: 0,
	    behavior: 'smooth'
	  });
	
	var buyer         = document.forms.contentForm.st_buyer.value;
	var userDept      = document.forms.contentForm.st_user_dept.value;
	var ACCOUNT_TYPE  = $("#st_account_type").val();
	var tot_price     = eval($("#nu_tot_price").val());
	var bdgt_flag     = $("#st_bdgt_flag").val();
	
	var budget_flag = "<%=budget_flag%>";
	
	if(budget_flag == "Y") {
	    doCheckAMT(buyer,userDept,ACCOUNT_TYPE,tot_price,tot_price,recvFlag);
	}else {
	   	setData(recvFlag);
	}
}

function checkFunc(flag){
	if(flag == "imsi_po_create_date"){
		if($("#imsi_po_create_date_check").is(":checked")){
			$("#imsi_po_create_date_div").show();
			$("#imsi_po_create_date_div2").show();
			$("#imsi_po_remark_div").show();
			
			if($("#emer_po_check").is(":checked")){
				$("#emer_po_check").prop("checked",false);
				$("#emer_po_remark_div").hide();
				$("#st_emer_po_remark").val("<%=emer_po_remark%>");
			}
		}else{
			$("#imsi_po_create_date_div").hide();
			$("#imsi_po_create_date_div2").hide();
			$("#imsi_po_create_date").val(document.forms.contentForm.ToDateTemp.value);
			$("#imsi_po_remark_div").hide();
			$("#st_imsi_po_remark").val("<%=imsi_po_remark%>");
		}
	}else if(flag == "emer_po"){
		if($("#emer_po_check").is(":checked")){
			$("#emer_po_remark_div").show();
			
			if($("#imsi_po_create_date_check").is(":checked")){
				$("#imsi_po_create_date_check").prop("checked",false);
				$("#imsi_po_create_date_div").hide();
				$("#imsi_po_create_date_div2").hide();
				$("#imsi_po_create_date").val(document.forms.contentForm.ToDateTemp.value);
				$("#imsi_po_remark_div").hide();
				$("#st_imsi_po_remark").val("<%=imsi_po_remark%>");
			}
		}else{
			$("#emer_po_remark_div").hide();
			$("#st_emer_po_remark").val("<%=emer_po_remark%>");
		}
	}else if(flag == "delivery_remark"){
		if($("#delivery_remark_check").is(":checked")){
			$("#delivery_remark_div").show();
			$("#st_remark").val("");
		}else{
			$("#delivery_remark_div").hide();
			$("#st_remark").val("");
		}
	}
}

function viewChange(index){
	var p060000100 = "<%=p060000100%>";
	if(p060000100 == "true"){ //품목별 배송지인 경우
		if($("#viewCheck"+index).is(":checked")){
			$("#simpleView"+index).show();
			$("#normalView"+index).hide();
		}else{
			$("#simpleView"+index).hide();
			$("#normalView"+index).show();
		}
	}else{
		if($("#viewCheck").is(":checked")){
			$("#simpleView").show();
			$("#normalView").hide();
		}else{
			$("#simpleView").hide();
			$("#normalView").show();
		}
	}
	
}

function preGrDateSet(){
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	var preGrDate = $("#imsi_po_create_date").val().replace(/[/]/gi,"");
	
	if(preGrDate > cur_date){
		//오늘 날짜 이전으로 선택해주세요
		var text = "<%=CommonLang.msg("MSG958")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#imsi_po_create_date").val("");
		return;
	}
	document.forms.contentForm.st_po_create_date.value = $("#imsi_po_create_date").val().replace(/[/]/gi,"");
}

function fileDown(index){
	var img_key = $("#imageKey"+index).val();
	if(img_key == "" || img_key == null){
		return;
	}
	var type = "PR";
	var viewType = "R";
	
	var src = '/common/fileUploadPop_v2.do?DOC_NO='+img_key+'&viewType='+viewType+'&TYPE='+type;
	openLayerPop(src,"600px","510px");
}
</script>
</html>