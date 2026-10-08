<%--
**********************************************
* 메뉴 : 주문관리>장바구니>배송정보
* 화면 : 배송정보
* 기능 : 배송정보를 입력한다.
* 프로그램 ID : PG_06_B_007_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-29
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
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String, String>> _data = (List<Map<String, String>>) request.getAttribute("data"); // 조회된결과 
	String toDate			  = CommonUtil.formatDateNoDateGubun(new Date(),1);
	String req_date = "";
    String buyer             = "";
    String zip_code          = "";
    String userID            = "";
    String userName          = "";
    String userDept          = ""; 
    String userTel           = "";
    String email             = "";
    String fax_no            = "";
    String mobile            = "";
    String byca_comorg_level = "";
    String byca_comorg_code  = "";
    String using_catal_type  = "";
    String location_code     = "";
    String location_code_name     = "";
    String location_name     = "";
    String purchaseDeptCode  = "";
    String purchaseDeptName  = "";

	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
      buyer             = sessionInfo.getComCode();      
      userID            = sessionInfo.getUserId();
      userName          = sessionInfo.getUserNameLoc();
      userDept          = sessionInfo.getDepartment(); 
      userTel           = sessionInfo.getTel();
      email             = sessionInfo.getEmail();
      fax_no            = sessionInfo.getFax();
      mobile            = sessionInfo.getmPhone();
      using_catal_type  = sessionInfo.getUsingCatalType();      
      zip_code          = sessionInfo.getZipCode();
      byca_comorg_level = sessionInfo.getBycaComorgLevel();
      byca_comorg_code  = sessionInfo.getBycaComorgCode();      
      location_code     = CommonUtil.nvl(sessionInfo.getDelyToLocation());
      location_code_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationCodeName());
      location_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationName());
      purchaseDeptCode  = sessionInfo.getPurchaseDept();
      purchaseDeptName  = sessionInfo.getPurchaseDeptName();
      
	}
    
	Map<String,String> rowData = null;  
	if (_data != null){
		if (_data.size() > 0){
		rowData = _data.get(0);
		//purchaseDeptCode  = rowData.get("");
		userName  = rowData.get("USER_NAME_LOC");
		userTel  = rowData.get("PHONE_NUMBER");
		fax_no  = rowData.get("FAX_NUMBER");
		mobile  = rowData.get("MOBILE_PHONE");
		email  = rowData.get("EMAIL");
		req_date  = rowData.get("REQ_DATE"); //  F_GET_RD_DATE('고객사코드')
		}
	}
    String order_dd          = CommonUtil.nvl((String) request.getParameter("order_dd"),"");
    String st_query_cart     = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"");
    String st_query_cart_date     = CommonUtil.nvl((String) request.getParameter("st_query_cart_date"),"");
    String st_query_cart_date_item     = CommonUtil.nvl((String) request.getParameter("st_query_cart_date_item"),"");
    String verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),""); 
    
    //선입고 장바구니 구분 FLAG 추가
    String st_pre_gr_flag = CommonUtil.nvl((String) request.getParameter("st_pre_gr_flag"),"N");
    
    // 부서조회(ICOMCOD2 C001)
    String deptYn = CommonUtil.nvl((String) request.getAttribute("deptYn"), "");
    
    boolean p060000040 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000040"); // KRKOLO0018
    boolean p060000041 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000041"); // KRDAEW0080 KRDAEW0081 KRDAEW0082
  //SLOGIC-BEGIN(P06-0000040)
	if(p060000040 == true){ // KRKOLO0018
		userTel ="";	
	}
	//SLOGIC-END
	
	
	//SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL01_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	
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
	// 품목별 도착지 지정(TYPE 상관없이 공통)
	boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
	
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
	
	//SLOGIC-END
%> 

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
	<h3><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --></h3>
	<!--조회영역-->
	<form name = "contentForm" id="contentForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
		<input type="hidden" name="st_nextdate"    value="">

		<input type="hidden" name="st_buyer"     id="st_buyer"   value="">
		<input type="hidden" name="st_user_id"  id="st_user_id"    value="">
		<input type="hidden" name="st_query_cart" id="st_query_cart"  value="<%=st_query_cart%>">
		<input type="hidden" name="st_recv_date"   id="st_recv_date" value="">
		<input type="hidden" name="st_recv_date2" id="st_recv_date2"  value="">
		<input type="hidden" name="st_page"  id="st_page" value="">
		<input type="hidden" name="st_check"  id="st_check" value="">
		<input type="hidden" name="st_verif_num" id="st_verif_num"   value="<%=verif_num%>">
		<input type="hidden" name="st_pre_gr_flag" id="st_pre_gr_flag"   value="<%=st_pre_gr_flag%>">
		<input type="hidden" name="st_query_cart_date" id="st_query_cart_date"  value="<%=st_query_cart_date%>">
		<input type="hidden" name="st_query_cart_date_item" id="st_query_cart_date_item"  value="<%=st_query_cart_date_item%>">		
		<!-- 화면 내 정의 -->
		<div style="height:20px; margin-bottom:6px; " >
            <!--배송정보 단계일때 이미지명 : b_img_carting02.gif / 주문완료 단계일때 이미지명 : b_img_carting03.gif-->
<%
//언어타입이 영어일 경우 이미지 변경
if(!h_get_session_user_lang.equals("EN")) {
%>
        	<p class="cart"><img src="/resources/images/b_img_carting02.gif" alt="장바구니단계" /></p>
<%}else{ %>
			<p class="cart"><img src="/resources/images/b_img_carting02_en.gif" alt="장바구니단계" /></p>
<% } %>        	
        </div>	
 
	  	<!--데이타그리드-->
        <table  class="cont_t_list06" style="width:99%;">
        <caption>제품상세보기 리스트</caption>
        <colgroup>
            <col width="100px" />
            <col width="*" />
            <col width="100px" />
            <col width="33%" />
        </colgroup>
        <tbody>
            <tr>
            <%	if(p060000126_map != null)  { %>
           		<th scope="row"><%= p060000126_col1%><!-- 구매요청부서 --></th>
            <%	} else { %>
           		 <th scope="row"><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
            <%  } %>
                
                <td colspan="3"> 
                	<input type="text" name="st_purchase_dept_name" id="st_purchase_dept_name" class="input_type_text" title="" style="width:370px;" value="<%=purchaseDeptName%>"  readonly/> 
                	<input type="hidden" name="st_purchase_dept_code" size="50" value="<%=purchaseDeptCode%>">
                	<span class="btn_gray_02"  title="변경" > <a href="javascript:setDeptCodeSearch('<%=buyer%>')"><%=CommonLang.get("HTITLE825") %><!-- 변경 --></a></span>
                </td>
            </tr>
            
<%if(p060000100 == true){%>
            <input type="hidden" name="st_location_code" id="st_location_code" class="input_type_text" title="" style="width:7%;" value="<%=location_code%>" readonly/>
            <input type="hidden" name="st_location_code_name" id="st_location_code_name" class="input_type_text" title="" style="width:20%;" value="<%=location_code_name%>" readonly/>
            <input type="hidden" name="st_location_name" id="st_location_name" class="input_type_text" title="" style="width:50%;" value="<%=location_name%>" readonly/>
            <input type="hidden" name="st_tel_no" id="st_tel_no" size="15" id="text" value="">
            <input type="hidden" name="st_tel_no1" id="st_tel_no1" size="15" id="text" value="">
            <input type="hidden" name="st_tel_no2" id="st_tel_no2" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/>
			<input type="hidden" name="st_tel_no3" id="st_tel_no3" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4"  onkeyup="kepNumcheck(this);"/>
            <input type="hidden" name="st_fax_no" size="15" id="st_fax_no" value= "">
            <input type="hidden" name="st_fax_no1" size="15" id="st_fax_no1" value= "">
            <input type="hidden" name="st_fax_no2" id="st_fax_no2" class="input_type_text" style="width:40px;height:15px;" value=""  maxlength="4" onkeyup="kepNumcheck(this);"/>
			<input type="hidden" name="st_fax_no3" id="st_fax_no3" class="input_type_text" style="width:40px;height:15px;" value=""  maxlength="4" onkeyup="kepNumcheck(this);"/>
            <input type="hidden" name="st_user_name" id="st_user_name" class="input_type_text" title="" style="width:100px;" value="<%=userName%>" STYLE = "ime-mode:active"/>
            <input type="hidden" name="st_mobile_no" size="6" id="text">
            <input type="hidden" name="st_mobile_no1" size="6" id="text">
			<input type="hidden" name="st_mobile_no2" id="st_mobile_no2" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/>
			<input type="hidden" name="st_mobile_no3" id="st_mobile_no3" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/> 
<%}else{%>
			<tr>
                <th rowspan="2"><%=CommonLang.get("HTITLE826") %><!-- 배송처 --></th>
                <td colspan="3">
                	<span class="btn_gray_07"  title="도착지" ><a href="javascript:getDeliveryToLocation('<%=buyer%>')"><%=p060000075%></a></span>
              		<br/>
					<input type="text" name="st_location_code" id="st_location_code" class="input_type_text" title="" style="width:7%;" value="<%=location_code%>" readonly/>
              		<input type="text" name="st_location_code_name" id="st_location_code_name" class="input_type_text" title="" style="width:20%;" value="<%=location_code_name%>" readonly/>
                </td>
            </tr>
            <tr>
              	<td colspan="3">
                <%if(p060000083==true){%>
                		<input type="text" name="st_location_name" id="st_location_name" class="input_type_text" title="" style="width:50%;" value="<%=location_name%>" readonly/>
                <%}else{ %>
                        <%-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:getzipCode();"><%=CommonLang.get("HTITLE791") %><!-- 우편번호 검색 --></a></span>	<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 --> --%>
                        <span class="btn_gray_05"  title="우편번호" ><a href="javascript:getnewzipCode();"><%=CommonLang.get("HTITLE791") %><!-- 우편번호 검색 --></a></span>
              			<br/>
	                    <input type="text" name="st_location_name" id="st_location_name" class="input_type_text" title="" style="width:50%;" value="<%=location_name%>" readonly/>
				<%} %>
              		
                	(ex. <%=CommonLang.get("HTITLE343") %><!-- 우편번호 -->+<%=CommonLang.get("HTITLE346") %><!-- 상세주소 -->)
              	</td>
            </tr>
            <tr>
                <th scope="row"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
                <td>
                	<label for="b_no02" class="hidden">전화번호선택</label>
					<input type="hidden" name="st_tel_no" id="st_tel_no" size="15" id="text" value="">
                	<select name="st_tel_no1" id="incolor" style="width:50px;height:20px;">
						<option value="02"  >02</option>
						  <option value="031" >031</option>
						  <option value="032" >032</option>
						  <option value="033" >033</option>
						  <option value="041" >041</option>
						  <option value="042" >042</option>
						  <option value="043" >043</option>
						  <option value="044" >044</option>
						  <option value="051" >051</option>
						  <option value="052" >052</option>
						  <option value="053" >053</option>
						  <option value="054" >054</option>
						  <option value="055" >055</option>
						  <option value="061" >061</option>
						  <option value="062" >062</option>
						  <option value="063" >063</option>
						  <option value="064" >064</option>
						  <option value="070" >070</option>
						  <option value="0303">0303</option>
						  <option value="0502">0502</option>
						  <option value="0504">0504</option>
						  <option value="0505">0505</option>
						  <option value="0506">0506</option>
						  <option value="0507">0507</option>
                	</select>&nbsp;-&nbsp;
                	 <input type="text" name="st_tel_no2" id="st_tel_no2" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/>&nbsp;-&nbsp;
                	 <input type="text" name="st_tel_no3" id="st_tel_no3" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4"  onkeyup="kepNumcheck(this);"/> 
                </td>
                <th scope="row"><%=CommonLang.get("HTITLE43") %><!-- 팩스번호 --></th>
                <td>
                	<label for="b_no02" class="hidden">팩스번호선택</label>
					<input type="hidden" name="st_fax_no" size="15" id="st_fax_no" value= "">
                	<select name="st_fax_no1" id="st_fax_no1"  style="width:50px;height:20px;">
					  <option value="02"  >02</option>
					  <option value="031" >031</option>
					  <option value="032" >032</option>
					  <option value="033" >033</option>
					  <option value="041" >041</option>
					  <option value="042" >042</option>
					  <option value="043" >043</option>
					  <option value="044" >044</option>
					  <option value="051" >051</option>
					  <option value="052" >052</option>
					  <option value="053" >053</option>
					  <option value="054" >054</option>
					  <option value="055" >055</option>
					  <option value="061" >061</option>
					  <option value="062" >062</option>
					  <option value="063" >063</option>
					  <option value="064" >064</option>
					  <option value="070" >070</option>
					  <option value="0303" >0303</option>
					  <option value="0504" >0504</option>
					  <option value="0505" >0505</option>
					  <option value="0506" >0506</option>
					  <option value="0507" >0507</option>
                	</select>&nbsp;-&nbsp;
                	 <input type="text" name="st_fax_no2" id="st_fax_no2" class="input_type_text" style="width:40px;height:15px;" value=""  maxlength="4" onkeyup="kepNumcheck(this);"/>&nbsp;-&nbsp;
                	 <input type="text" name="st_fax_no3" id="st_fax_no3" class="input_type_text" style="width:40px;height:15px;" value=""  maxlength="4" onkeyup="kepNumcheck(this);"/> 
                </td>
            </tr>
            <tr>
            <%if(p060000095==true){%>
            	<th scope="row"><%=CommonLang.get("HTITLE935") %><!-- 주문자 --></th>
            <%}else{%>
            	<th scope="row"><%=CommonLang.get("HTITLE827") %><!-- 인수자명 --></th>
            <%}%>
                <td>
<%

String uName = userName;
//SLOGIC-BEGIN(P06-0000040)
if(p060000040 == true){ // KRKOLO0018
uName ="";				
}else if(userID.equals(userName)){
	uName ="";
}
//SLOGIC-END
%>
               	<input type="text" name="st_user_name" id="st_user_name" class="input_type_text" title="" style="width:100px;" value="<%=uName%>" STYLE = "ime-mode:active"/>
                </td>
                <th scope="row"><%=CommonLang.get("HTITLE828") %><!-- 휴대폰 --></th>
                <td>
                	<label for="b_no02" class="hidden">휴대폰번호선택</label>
					<input type="hidden" name="st_mobile_no" size="6" id="text">
                	<select name="st_mobile_no1" id="st_mobile_no1"  style="width:50px;height:20px;">
				  <option value="010">010</option>
				  <option value="011">011</option>
				  <option value="016">016</option>
				  <option value="017">017</option>
				  <option value="018">018</option>
				  <option value="019">019</option>
                	</select>&nbsp;-&nbsp;
                	 <input type="text" name="st_mobile_no2" id="st_mobile_no2" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/>&nbsp;-&nbsp;
                	 <input type="text" name="st_mobile_no3" id="st_mobile_no3" class="input_type_text" style="width:40px;height:15px;" value="" maxlength="4" onkeyup="kepNumcheck(this);"/> 
                </td>
            </tr>
<%}%>
            
            
            <tr>
                <th scope="row"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
              	<td>
              		<input type="text" name="st_email" id="st_email" class="input_type_text" title="" style="width:200px;" value="<%=email%>" />
              		<span class="btn_gray_03" title="정보반영"> <a href="javascript:CheckSubmit(1)"><%=CommonLang.get("HTITLE829") %><!-- 정보반영 --></a></span>
              		<%=CommonLang.get("HTITLE830") %><!-- (내용을 개인정보에 반영합니다) -->
              	</td>
              	<th scope="row"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></th>
              	<td>
              		<input type="text" class="input_type_text" name="recv_date_hope" id="fromDate" size="10" style="width:80px;" readOnly  value="<%=CommonUtil.formatStrinigDate(req_date)%>">
                	<!-- <span class="btn_gray_06" title="수령희망일입력"> <a href="javascript:recv_date_register()">수령희망일 입력</a></span> 
                	 <span class="btn_gray_10" title="수령희망일초기화"> <a href="javascript:recv_date_reset()">수령희망일 입력 초기화</a></span>-->
              	</td>
            </tr>
            <tr>
            <%	if(p060000122_map != null)  { %>
            		<th scope="row"><font color="#FF6600">*</font> <%=p060000122_col1%><!-- 구매목적 --></th>
                  	<td colspan="3"><input type="text" name="st_remark" id="st_remark" class="input_type_text" title="" style="width:90%;" value="" /></td>
            <%  } else { %>
             		<th scope="row"><%=CommonLang.get("HTITLE832") %><!-- 특이사항 --></th>
                  	<td colspan="3"><input type="text" name="st_remark" id="st_remark" class="input_type_text" title="" style="width:90%;" value="" /></td>
            <%  } %>
            </tr>
        </tbody>
    </table>		
	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<span class="btn_02 mr04"  title="주문취소" ><a href="javascript:order_cancle();"><%=CommonLang.get("HTITLE225") %><!-- 주문취소 --></a></span>	
			<span class="btn_02 mr10"  title="계속" ><a href="javascript:CheckSubmit(2);"><%=CommonLang.get("HTITLE833") %><!-- 계속 --></a></span>	
		</div>
	</div>
</form>

<form name="processForm" id="processForm" method="post">	  
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){ 
	tel_no_distinct(0);
	mobile_distinct(0);
	fax_no_distinct(0);
	<% if (_data != null){  %>
	kepSetCalender("fromDate"); 
	<%}%>
}  

function tel_no_distinct(set){

    var tel_no        = "<%=userTel%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!="")
   {

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
    var tel_no        = "<%=mobile%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!="")
   { 
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
<%if(userID.equals(userName)){%>
	document.forms.contentForm.st_mobile_no2.value  = "";
	document.forms.contentForm.st_mobile_no3.value  = "";
	document.forms.contentForm.st_mobile_no1.value  = "";
<%}%>		
		
   }
}

function fax_no_distinct(set){

    var tel_no        = "<%=fax_no%>";
	var no_1 = "";
	var no_2 = "";
	var no_3 = ""; 
   if(kepTrimStr(tel_no)!="")
   {
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


function order_cancle(){	

    $("#st_query_cart").val("");    
    //선입고장바구니 여부에 따란 return값 상이
    if(document.forms.contentForm.st_pre_gr_flag.value == "Y"){
    	$('#contentForm').attr("action", "<%=h_sslurl%>"+"/mpso/getBuyerMpSoPreGrCartList.do?upperId=b00000000000&leftMenu=N").submit();
    }else{
    	$('#contentForm').attr("action", "<%=h_sslurl%><%=p060000036%>").submit();
    }
              
}

function confirm_submit(){    /////////////////////   배송정보 확인 및 주문 화면 이동     ////////////////////////////////////////

    var purchase_dept_name  = kepTrimStr(document.forms.contentForm.st_purchase_dept_name.value);
    var location_name       = kepTrimStr(document.forms.contentForm.st_location_name.value);
    var user_name       = kepTrimStr(document.forms.contentForm.st_user_name.value);
    var location_code       = kepTrimStr(document.forms.contentForm.st_location_code.value);
    var remark				= document.forms.contentForm.st_remark.value;
    // 배송처 앞부분 우편번호 자릿수 및 공백 체크(6, 7, 8 번째 공백)
    var chkZipCode = location_name.substring(0,5);
	var chkSpace6 = location_name.substring(5,6);
	var chkSpace7 = location_name.substring(6,7);
	var chkSpace8 = location_name.substring(7,8);

    if(purchase_dept_name == "") {
    	//발주부서는 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG440") %>");
	   return;
	}

<%if (p060000122_map != null){ %>
	if(remark == "") {
		// 특수로직으로 가져온 변경 명칭은 필수 입력 사항
		alert("<%=p060000122_col1%>은(는) 필수 입력 사항입니다.");
		return;
	}
<%}%>

<%if(p060000100 != true){%>
    if(location_name == "") {
    	//배송처는 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG441") %>");
	   return;
	}

	if(user_name == "") {
		//인수자명은 필수 입력 사항입니다.
       alert("<%=CommonLang.msg("MSG442") %>");
	   return;
	}
<%}%>

	var p060000075 = "<%=p060000075%>";
	var p060000075_1 = "<%=p060000075_1%>";
	if(p060000075_1 == "true"){
		if(kepTrimStr(location_code) == ""){
			// 선택은 필수 입력 사항입니다.
			alert(p060000075 + "<%=CommonLang.msg("MSG443") %>");
			return;
		}
	}
	
	var toDate   = "<%=toDate%>";

    var st_query_cart = "<%=st_query_cart%>";
    var recv_date2    = $("#fromDate").val().replace(/[/]/gi,"");
    var recv_date     = recv_date2.substring(0,4) +"년  "+ recv_date2.substring(4,6) +"월  "+ recv_date2.substring(6,8) +"일"; 
    var tel_no        = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no        = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile        = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;    
     
    if(recv_date2 < toDate){
    	// 수령희망일은 현재일 이후로 선택하셔야 합니다.
        alert("<%=CommonLang.msg("MSG444") %> ");
        document.forms.contentForm.fromDate.focus();
        return;
    }

<%if(p060000100 != true){%>
   if(kepTrimStr(document.forms.contentForm.st_tel_no2.value)=="" || kepTrimStr(document.forms.contentForm.st_tel_no3.value)=="" )
   {
		//전화번호를 입력해 주십시요
      alert("<%=CommonLang.msg("MSG445") %>");
      document.forms.contentForm.st_tel_no3.focus();
      return;
   }

	var p060000074 = "<%=p060000074%>";
	if(p060000074 == "true"){
		if(kepTrimStr(mobile) == ""){
			//휴대폰번호를 입력해 주십시요
			alert("<%=CommonLang.msg("MSG446") %>");
			return;
		}else{
			document.forms.contentForm.st_remark.value +="/"+user_name+"("+tel_no+" / "+mobile+")";	
		}
	}
	
	// 배송처 길이체크(최소 우편번호 '-' 포함 7자리 이상, 짧으면 확인 메시지)
	if(location_name.length > 7){
		// 우편번호 숫자 5자리 + 공백
		if((kepIsNumberString(chkZipCode)  == true) && (chkSpace6 == " ")){
			confirm_Submit2();
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
			}
		}
	   	// 우편번호 숫자 7자리 '-' 포함
		else{
			kepAjaxFormCall("/mpso/checkZipCode.do","contentForm","CHECKZIP");
		}	
	}else{
		//배송처를 확인하여 주십시오.
		alert("<%=CommonLang.msg("MSG448") %>");
		document.forms.contentForm.st_location_name.focus();
	}
<%}else{%>
	confirm_Submit2();
<%}%>
}

function confirm_Submit2(){
	var st_deptYn = "<%=deptYn%>";	
	if(st_deptYn == 'N') {
		alert("부서코드 확인이 필요합니다. 관리자에게 문의 바랍니다.");
		return;
	}
	var st_query_cart = "<%=st_query_cart%>";
	var recv_date2    = $("#fromDate").val().replace(/[/]/gi,"");;
	var recv_date     = recv_date2.substring(0,4) +"년  "+ recv_date2.substring(4,6) +"월  "+ recv_date2.substring(6,8) +"일";
    var tel_no        = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no        = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile        = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;
	document.forms.contentForm.st_query_cart.value  = st_query_cart;
    document.forms.contentForm.st_tel_no.value      = tel_no;
    document.forms.contentForm.st_fax_no.value      = fax_no;
    document.forms.contentForm.st_mobile_no.value   = mobile;
    document.forms.contentForm.st_recv_date.value   = recv_date;
    document.forms.contentForm.st_recv_date2.value  = recv_date2;
    //PG_06_B_008_00
    $('#contentForm').attr("action", "<%=h_sslurl%>/mpso/getBuyerMpSoOrderInfoList.do").submit();    
    //document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_list.jsp"; 
}



function setDeptCodeSearch(buyer) {

	<%//SLOGIC-BEGIN(P06-0000041)
	if (p060000041 == true) { %>
	//발주부서를 변경 할수 없습니다.\n\n관리자에게 문의 바랍니다.
	alert("<%=CommonLang.msg("MSG449") %>");
	<% } else { %>
	var userId = "<%=userID%>";
	if(userId!="HYEYOUN00") {			
		popupSel = "dept_buyer";
		openSearchPopup("/common/deptCodeAdminBuyerPop.do", "?com_code="+buyer+"&open=Y", "500,500,no");	
	}
	<%}
	//SLOGIC-END
	%> 
}
/* 
//ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function getzipCode(){
	popupSel = "zipcode";
	openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");		
}
 */

function getnewzipCode(){
	popupSel = "newzipcode";
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");		
}

function getDeliveryToLocation(com_code){
	popupSel = "location";
	openSearchPopup("/common/delLocationPop.do", "?com_code="+com_code+"&open=Y", "500,500,no");
}

function recv_date_register() {
	popupSel = "buyerMpSoRecvDateRegisterPop";
	openSearchPopup("/mpso/getBuyerMpSoRecvDateRegisterPop.do", "?st_query_cart=<%=st_query_cart%>", "800,400,no");
}

function setRecvDateRegister(value1,value2){
	$("#st_query_cart_date").val(value1);
	$("#st_query_cart_date_item").val(value2);
}

function recv_date_reset() {
	$("#st_query_cart_date").val("");
	$("#st_query_cart_date_item").val("");
}




function setPopupReturn(value1, value2, value3){
	if (popupSel == "dept_buyer"){
	    document.forms.contentForm.st_purchase_dept_name.value = value2;
	    document.forms.contentForm.st_purchase_dept_code.value = value1;
	}else if (popupSel == "location"){
		document.forms.contentForm.st_location_code.value = value1;
		document.forms.contentForm.st_location_name.value = value2;
	    document.forms.contentForm.st_location_code_name.value = value3;
	}
}
//ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_si, str_gu, str_do, str_bd, str_bdnm, str_dong)
{ 
    document.forms.contentForm.st_location_name.value = str_zipcode+"  " +str_si+" "+str_gu+" "+str_do+" "+str_bd;
    document.forms.contentForm.st_location_name.focus();
}


function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	document.forms.contentForm.st_location_name.value = zipNo.replace(/[^0-9]/gi, '') + "  " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail;
    document.forms.contentForm.st_location_name.focus();
}


function CheckSubmit(value){    /////////////////////   기본 배송정보 입력     ////////////////////////////////////////

    var purchase_dept_code = document.forms.contentForm.st_purchase_dept_code.value;
    var location_code      = document.forms.contentForm.st_location_code.value;
    var tel_no             = document.forms.contentForm.st_tel_no1.value +"-"+ document.forms.contentForm.st_tel_no2.value +"-"+ document.forms.contentForm.st_tel_no3.value;
    var fax_no             = document.forms.contentForm.st_fax_no1.value +"-"+ document.forms.contentForm.st_fax_no2.value +"-"+ document.forms.contentForm.st_fax_no3.value;
    var mobile             = document.forms.contentForm.st_mobile_no1.value +"-"+ document.forms.contentForm.st_mobile_no2.value +"-"+ document.forms.contentForm.st_mobile_no3.value;
    var user_name          = document.forms.contentForm.st_user_name.value;
    var email              = document.forms.contentForm.st_email.value;
    document.forms.contentForm.st_location_code.value = location_code;
    document.forms.contentForm.st_purchase_dept_code.value = purchase_dept_code;
    document.forms.contentForm.st_tel_no.value        = tel_no;
    document.forms.contentForm.st_fax_no.value        = fax_no;
    document.forms.contentForm.st_mobile_no.value     = mobile;
    document.forms.contentForm.st_email.value         = email;
    document.forms.contentForm.st_user_id.value       = "<%=userID%>";
    document.forms.contentForm.st_buyer.value         = "<%=buyer%>";
	if (value == 1){
		kepAjaxFormCall("/mpso/buyerDeliveryInfo.do","contentForm","BUYERDELIVERYINFO"+value); 
	}else{
		confirm_submit();
	}
	
    //document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_info_update.jsp";


}


/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){

var sMsg = response.msg.MSG;    
 
	if (pMethod == "CHECKZIP"){
		if (sMsg == "N"){ 
				//우편번호가 유효하지 않습니다.
				alert('<%=CommonLang.msg("MSG450") %>');	
				document.forms.contentForm.st_location_name.focus();	 
		}else{
			confirm_Submit2();
		}
	}else if (pMethod == "BUYERDELIVERYINFO1"){
		// 기본 배송정보가 수정되었습니다.
		alert("<%=CommonLang.msg("MSG451") %>   ");
	}else if (pMethod == "BUYERDELIVERYINFO2"){
		confirm_submit();
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
	alert("<%=CommonLang.msg("MSG163") %>"); 
} 

</script>
</html>
