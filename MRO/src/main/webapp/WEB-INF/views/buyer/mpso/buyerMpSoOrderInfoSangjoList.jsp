<%--
**********************************************
* 메뉴 : 주문관리>장바구니>주문정보/배송정보 (코웨이 상조)
* 화면 : 주문정보/배송정보
* 기능 : 코웨이 상조용 화면
* 프로그램 ID :  PG_06_B_010_06
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-06-18
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
    //String budget_falg = "";
    String row_cnt = ""; 
    String person_author  = "";    
    String purchaseDeptName = "";
    String purchaseDeptCode = "";    
    String userID = "";
    String userName = "";
    
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
	    row_cnt =  CommonUtil.nvl((String)sessionInfo.getRowCnt());  //20070704 추가 페이지 기본 개수	    
	    person_author      =  CommonUtil.nvl((String)sessionInfo.getPersonAuthor());  	    
	    purchaseDeptName  = CommonUtil.nvl((String)sessionInfo.getPurchaseDeptName());  
	    purchaseDeptCode  = CommonUtil.nvl((String)sessionInfo.getPurchaseDept());  	    
	    userID            = sessionInfo.getUserId(); 
	    userName          = sessionInfo.getUserNameLoc();
	    
	}  
	String curDate =  CommonUtil.formatDateNoDateGubun(new Date(),1);
	String year				=  curDate.substring(0,4);
	String month			=  curDate.substring(4,6);
	String day				=  curDate.substring(6,8); 	
    if(st_image_status.equals(""))
    { 
        st_image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN";
    }   
	
	
    String verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),""); 
    String st_fax_no          = CommonUtil.nvl((String) request.getParameter("st_fax_no"),"");
    String st_email           = CommonUtil.nvl((String) request.getParameter("st_email"),"");
    String st_query_cart      = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"");
    String st_query_cart_date      = CommonUtil.nvl((String) request.getParameter("st_query_cart_date"),"");
	String st_check           = CommonUtil.nvl((String) request.getParameter("st_check"),"");    
    
	int rec_cnt =  0;
	String item_name = "";
	String contract_no = "";
	String contract_seq = "";
	
	String category_no = "";
	String cate_appr = "";
	String cate_chk = "";
	String cate_msg = "관계";
	String cate_msg2 = "인수자";

	if (_gridList != null){
		if (_gridList.size()>0){
			Map<String,String> rowItemData = _gridList.get(0);
			
			if (rowItemData != null){
				
				contract_no = rowItemData.get("CONTRACT_NO");			
				contract_seq = rowItemData.get("CONTRACT_SEQ");			
				//동일한 카테고리끼리만 주문할 수 있으므로 모두 동일한 카테고리가 검색됨.
				category_no = rowItemData.get("CATEGORY_NO");			
				cate_appr = rowItemData.get("CATE_APPR");			
				if(!"0".equals(cate_appr)){
					cate_chk = "Y";
					cate_msg = "신규여부";
					cate_msg2 = "사용자";
				}

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
	String hongikType = "N";
	
    boolean p060000034 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000034"); // KRDAEW0023 KRDAEW0043 KRDAEW0045
    boolean p060000032 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000032"); // KRCOWA0001 KRCOWA0005 KRCOWA0006    
    boolean p060000041 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000041"); // KRDAEW0080 KRDAEW0081 KRDAEW0082
    
    boolean submitFlag = false;
    
%>  
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
<div class="btnArea">
   <div class="fl">
	<h3>주문정보</h3>
	</div>
	   <div class="fr">	
	<span class="btn_reset" title="변경"><a href="javascript:order_info_modify();">품목변경</a> </span>
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
		<input type="hidden" name="st_check"               value="<%=st_check%>">
		<input type="hidden" name="st_person_author"       value="<%=person_author%>">
		<input type="hidden" name="st_buyer"               value="<%=buyer%>">
		<input type="hidden" name="st_user_dept"           value="<%=user_dept%>"> 
		<input type="hidden" name="st_byca_comorg_code"    value="<%=byca_comorg_code%>">
		<input type="hidden" name="st_pr_no"               value="">
		<input type="hidden" name="st_recv_date2"          value="<%=curDate%>">
		<input type="hidden" name="st_tel_no"              value="">
		<input type="hidden" name="st_fax_no"              value="<%=st_fax_no%>">
		<input type="hidden" name="st_email"               value="<%=st_email%>">
		<input type="hidden" name="st_query_cart"          value="<%=st_query_cart%>">
		<input type="hidden" name="st_query_cart_date"          value="<%=st_query_cart_date%>">
		<input type="hidden" name="st_image_status"   id="st_image_status"      value="<%=st_image_status%>"> 
		<input type="hidden" name="recvFlag"  value="">
		<input type="hidden" name="GW_NO"  value="">
		<input type="hidden" name="st_gr_flag"  value="">
		<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
		<input type="hidden" name="st_po_create_date" value="<%=curDate%>">
		<input type="hidden" name="st_hongik_type" value="<%=hongikType%>">
		<input type="hidden" name="st_verif_num"  value="<%=verif_num%>">
		<!-- 신용카드결제 변수 -->
		<input type="hidden" name="st_item_name"  value="<%=item_name%>">
		<input type="hidden" name="st_mg_note"		value=""> 
		
		<input type="hidden" name="card_cd"		value=""> 
		<input type="hidden" name="card_name"		value=""> 
		<input type="hidden" name="tno"		value=""> 
		<input type="hidden" name="amount"		value=""> 		
	  	<!--데이타그리드-->
	  	<div class="fl">
	  	  <span class="btn_imghide">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
<a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
<%  }else{   %>
<a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
<%  }   %>
</span>
		      </div>
		      <div class="fr">		      
		      
<%//SLOGIC-BEGIN(P06-0000034)
if(p060000034 == true){  %>
<a href="javascript:category_list_pop()"><b>총 금액</b></a>  
<%  }else{  %>
(기준 : 원) 
<%  }  
//SLOGIC-END%>
  
  
              </div>
	  	<table class="cont_t_list02" style="width:100%">
			<colgroup>
               <col width="10%" />
               <col width="30%" />
               <col width="20%" />
               <col width="10%" />
               <col width="15%" />
               <col width="5%" />
           </colgroup>
           <thead>
               <tr>
                   <th scope="col">&nbsp;</th>
                   <th scope="col">품목코드 / 품목명 / 규격</th>
                   <th scope="col">협력사/단위</th>
                   <th scope="col">단가/구매수량</th>
                   <th scope="col">
<%
if(hongikType.equals("Y")){
%>					 
구매액/대학원 학과
<%
}else{
%>
구매액

<%
}
%>   
				</th>
                   <th scope="col">첨부</th>
                </tr>
<%
if (_gridList == null || _gridList.size() == 0){
%>
	<tr>
		<td colspan="6" align="center" height = "50"> 
		<span>조회된 데이타가 없습니다.</span>
		</td> 
	</tr>
<%
}else{
submitFlag = true;	
Map<String,String> rowData = null;
for (int j=0; j<_gridList.size(); j++) {
rowData = _gridList.get(j);
String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA"; 


  tot_price += Double.parseDouble(rowData.get("TOT_SUM"));
   account_type = rowData.get("ACCOUNT_TYPE");
   bdgt_flag    = rowData.get("BDGT_FLAG");
		
		

%> 
                <tr bgcolor="<%=tclass%>">
                	<td  title="이미지" >
<% if(st_image_status.equals("IMAGE_HIDDEN")){
	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){

%>
				<img src="/resources/images/but_img_off.gif" border="0">

<%     }else{ %>
				<a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
				<img src="/resources/images/but_img_on.gif" border="0"></a>

<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
				<img src="/resources/images/noimage.gif" width="50" height="50" class="PDimg">

<%     }else{ %>
				<a href="javascript:getBigImage('<%=rowData.get("IMGFILE_DIR")%>','<%=rowData.get("IMGFILE_NAME")%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/"+rowData.get("IMGFILE_NAME")%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="50" height="50" border="0"></a>

<%     }
}
String tmpTitle = "";
if(hongikType.equals("Y")){
tmpTitle = "구매액/대학원 학과";
}else{
tmpTitle = "구매액";
}
%>
				           	
                	</td>
                	<td class="left" title="품목코드/품목명/규격" >&nbsp;
                	<a class="hyperLink"   href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
                	<b><font color="#5B5B5B"><%=rowData.get("BUYER_ITEM_NO")%></font></b></a><br>
                	&nbsp;&nbsp;<%=rowData.get("DESCRIPTION_LOC")%><%=rowData.get("SPECIFICATION")%>                	
                	</td>
                	<td  title="협력사/단위" >
                	<a class="hyperLink"   href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=(rowData.get("AGENT").equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : rowData.get("AGENT")%></a><br>
                	<%=rowData.get("UNIT_MEASURE")%>                	
                	</td>
                	<td class="right"  title="단가/구매수량" ><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%> 원<br>
                	<%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%></td>
                	<td class="right" title="<%=tmpTitle%>">
                	
		<%
            if(hongikType.equals("Y")){
        %>
					 <%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%> 원 
					 <%=rowData.get("HI_DEPT_NAME")%> 

        <%
            }else{
        %>
						<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%> 원 					

       <%
            }
        %>                   	
                	</td>
                	<td title="파일">
                	<input type="hidden" name="st_image_key"     id="st_image_key"       value="<%=rowData.get("IMAGE_KEY")%>">
			<%
					 if(!rowData.get("IMAGE_KEY").equals("")) {
			%>
				
					<a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
								}else {
			%>
					<a href="javascript:gridPopOpen('<%=j%>');"> <img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
								}
			%>
                	
                	
                	</td>
                </tr>
                
<%}
}%>
  </thead>
</table>
	<div class="fr">       
	금액합계 : <%=CommonUtil.formatNumber(tot_price,true,0,3)%> 원     
	
	  <input type="hidden" name="nu_tot_price" value="<%=tot_price%>">
	  <input type="hidden" name="st_account_type" value="<%=account_type%>">
	  <input type="hidden" name="st_bdgt_flag" value="<%=bdgt_flag%>">
	</div>
	<br>
	
	<h3>배송정보</h3>
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
				<th colspan="4" scope="row">신청자</th> 
			</tr>          
			<tr>
				<th scope="row">주문일자</th>
				<td>&nbsp;<%=year%>년 <%=month%>월 <%=day%>일</td>
				<th scope="row">발주부서</th>
				<td>&nbsp;<input type="text" name="st_purchase_dept_name"  class="input_type_text" style="width:60%" value="<%=purchaseDeptName%>" onFocus="this.blur()">
		<input type="hidden" name="st_purchase_dept_code" value="<%=purchaseDeptCode%>">
		<span class="btn_gray_02"  title="변경" > <a href="javascript:setDeptCodeSearch('<%=buyer%>')">변경</a></span></td>           
	</tr>  
	<tr>
	  <th>부서명(지국)</th>
	  <td >&nbsp;<%=purchaseDeptName%></td>
	  <th>주문자</th>
	  <td >&nbsp;<%=userName%></td>
	</tr>    
	<tr>
	  <th colspan="4">담당자</th> 
	</tr>
	<tr>
		<th><%=cate_msg2%>명</th>
		<td >
			<input type="text" name="st_user_id"  class="input_type_text" style="width:20%" value=""> 
			<span class="btn_gray_02"  title="변경" > <a href="javascript:getUserSelect('<%=buyer%>')">변경</a></span>			 
			<input type="text" name="st_user_name"  class="input_type_text" style="width:20%" value="" readonly>
		</td>
		<th><%=cate_msg%></th>
		<td >
			<select name="st_ref_pr_no"> 
			  <%= ("Y".equals(cate_chk)?CommonUtil.getCodeComboQueryIdList("buyer.mpso.getCod2M040DDLB","SEL"):CommonUtil.getCodeComboQueryIdList("buyer.mpso.getCod2M039DDLB","SEL"))	 %>
			</select>
		</td>
	</tr>
	<tr>
		<th>부서명</th>
		<td >
			<input type="text" name="st_dept_code"  class="input_type_text" style="width:20%" value="">
			<input type="text" name="st_dept_name"  class="input_type_text" style="width:40%" value="" readonly>
		</td>
		<th>연락처</th>
		<td ><input type="hidden" name="st_mobile_no" size="6" id="text">
		<select name="st_mobile_no1" id="incolor">
		  <option value="010">010</option>
		  <option value="011">011</option>
		  <option value="016">016</option>
		  <option value="017">017</option>
		  <option value="018">018</option>
		  <option value="019">019</option>
		</select>
		-
		<input type="text" name="st_mobile_no2" class="input_type_text"  size="8"  maxlength="4" onkeyup="kepNumcheck(this);">
		-
		<input type="text" name="st_mobile_no3" class="input_type_text"  size="8"  maxlength="4" onkeyup="kepNumcheck(this);">
	</tr>
	<tr>
		<th>배송일</th>
		<td  colspan="3">
			<input type="text" name="st_recv_date_text" size="10"  class="input_type_text"  maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>" readonly> 
			<a href="javascript:Calendar_Open()"><img src="/resources/images/btn_calendar.gif" border="0" alt="검색"></a>
			<input type="hidden" name="st_recv_date" size="12" value="<%=curDate%>">
		</td>
	</tr>
    <tr>
      <th>배송처</th>
      <td  colspan="3"><input type="text"   name="st_location_name" size="113"  class="input_type_text" value=""> <input type="hidden" name="st_location_code" size="113" value="">&nbsp;&nbsp;(ex. 우편번호+상세주소)</td>
	</tr>
    <tr>
      <th>&nbsp;&nbsp;</th>
      <td  colspan="3">
      <!-- <span class="btn_gray_04"  title="우편번호검색" > <a href="javascript:getzipCode()">우편번호검색</a></span> (ex. 지정되지 않은 도착지일 경우 사용) -->
      <span class="btn_gray_04"  title="우편번호검색" > <a href="javascript:getnewzipCode()">우편번호검색</a></span> (ex. 지정되지 않은 도착지일 경우 사용) 
      <span class="btn_gray_04"  title="도착지선택" > <a href="javascript:getDeliveryToLocation('<%=buyer%>')">도착지선택</a></span> (ex. 지정된 도착지를 선택)
      </td>
    </tr>
    <tr>
      <th>특이사항</th>
      <td colspan="3"><input type="text" name="st_remark" size="130"  class="input_type_text" value=""></td>
    </tr>
</tbody>
</table>
	<table>
	  <tr>
		<td align="left" style="display:none;">
		  <input type="checkbox" name="cbx" onClick = "setCheckBox();">
		  <input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = "<%=CommonUtil.formatStrinigDate(new Date(),1)%>" readonly>
		  <input type="checkbox" name="cbx1" onClick = "setCheckBox1();">
		</td> 
	  </tr>
	</table>      
		<!-- 버튼영역 -->
<% if (submitFlag == true) { %>		
		<div class="btnArea">   
        <div class="fr">    
				<span class="btn_04 mr04" title="주문하기">
					<a href="javascript:order_submit('1')">주문하기</a>
				</span>		 				
				<span class="btn_04 mr04" title="주문취소">
					<a href="javascript:order_cancle()">주문취소</a>
				</span>		
            </div>
        </div>
<%}%>        
        <input type="checkbox" name="card_yn" value="N" style="width:0px; height:0px; border:0px" DISABLED >
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="account_type" id="account_type" value="" />
	<input type="hidden" name="end_price" id="end_price" value="" />
	<input type="hidden" name="tot_price" id="tot_price" value="" />
	<input type="hidden" name="recvFlag" id="recvFlag" value="" />  
	
	<input type="hidden" name="st_query_cart" id="st_query_cart" value="" />  
	<input type="hidden" name="st_query_cart_date" id="st_query_cart_date" value="" />  
	<input type="hidden" name="TYPE" id="TYPE" value="" />  
	<input type="hidden" name="COM_CODE" id="COM_CODE" value="" />
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
	<input type="hidden" name="st_category_no"		value="<%=category_no%>"> 		
 
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
}
 

function setDeptCodeSearch(buyer) {
	<%
	//SLOGIC-BEGIN(P06-0000041)
	if (p060000041 == true) { %>
	alert("발주부서를 변경 할수 없습니다.\n\n관리자에게 문의 바랍니다.");
	<% } else { %>
	var userId = "<%=userID%>";
	if(userId!="HYEYOUN00") {			
		popupSel = "dept_buyer";
		openSearchPopup("/common/deptCodeAdminBuyerPop.do", "?com_code="+buyer+"&open=Y", "500,500,no");
	}
	<%}
	//SLOGIC-END%> 
}
/* 
//ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function getzipCode(){
	popupSel = "zipcode";
	openSearchPopup("/common/zipCodeSearchPop.do","?1=1"  , "500,666,no"); 
}
 */

function getnewzipCode(){
	popupSel = "newzipcode";
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");		
}

function getDeliveryToLocation(com_code)
{
	popupSel = "location";
	openSearchPopup("/common/delLocationPop.do", "?com_code="+com_code+"&open=Y", "500,500,no");
}

//인수자명
function getUserSelect(buyer){
	popupSel = "user";
	openSearchPopup('/common/misUserSelectAllPop.do', "?open=Y&com_code="+buyer , "500,500,no"); 
}
	 	
function setPopupReturn(value1, value2, value3, value4, value5 ,value6, value7, value8, value9){

	if (popupSel == "dept_buyer"){
	    document.forms.contentForm.st_purchase_dept_name.value = value2;
	    document.forms.contentForm.st_purchase_dept_code.value = value1;
	}else if (popupSel == "location"){
	    document.forms.contentForm.st_location_name.value = value2;
	    document.forms.contentForm.st_location_code.value = value1; 
	}else if (popupSel == "user"){
		document.forms.contentForm.st_user_id.value = value1; 
		document.forms.contentForm.st_user_name.value = value2; 
		document.forms.contentForm.st_dept_code.value = value3; 
		document.forms.contentForm.st_dept_name.value = value4; 
		
		var no_1 = "";
		var no_2 = "";
		var no_3 = "";
		 
		if(value9!="")
		{
			var tot_lenth     = value9.length;
			var no_1_cnt      = value9.indexOf("-");
				no_1          = value9.substr(0,no_1_cnt);   //통신사번호
			var no_2_cnt_temp = value9.substr(no_1_cnt+1,tot_lenth); // 3016-8964 
			var no_2_cnt      = no_2_cnt_temp.indexOf("-");  //4 
				no_2          = no_2_cnt_temp.substr(0,no_2_cnt);   //국번
				no_3          = no_2_cnt_temp.substr(no_2_cnt+1,4); //뒷자리번호
			document.forms.contentForm.st_mobile_no.value  = value9;
			document.forms.contentForm.st_mobile_no1.value  = no_1;
			document.forms.contentForm.st_mobile_no2.value  = no_2;
			document.forms.contentForm.st_mobile_no3.value  = no_3;
			document.forms.contentForm.st_tel_no.value  = value9;
		}
		
		
	}else	if (popupSel == "attach"){
   		$("input[name=st_image_key]").eq(gridIndex).val(value1); 
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
	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderInfoSangjoList.do").submit();   
}
 
function order_cancle(){           ////////////////////  주문취소 후 장바구니 화면이동  //////////////////////////

    if(!confirm(" 주문을 취소하시겠습니까? \n\n 장바구니 화면으로 돌아갑니다.   ")){
        return;
    }  
    document.forms.contentForm.st_query_cart.value = "";
    $('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit();   

}

function dely_info_modify(){        ////////////////////    배송 정보 변경     //////////////////////////

    $('#contentForm').attr("action", "<%=h_sslurl2%>/mpso/getBuyerMpSoDlvryInfoCowayList.do").submit();   
}

function order_info_modify(){       ////////////////////    주문 정보 변경     //////////////////////////

    $('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit(); 
}


function order_submit(recvFlag){           ////////////////////  주문접수  후  DB INSERT  ////////////////////////// 

    	var person_author = document.forms.contentForm.st_person_author.value; 
    	
   	  	var user_id			= TrimCommon(document.forms.contentForm.st_user_id.value);
   	    var user_name       = TrimCommon(document.forms.contentForm.st_user_name.value);
   		var dept_code		= TrimCommon(document.forms.contentForm.st_dept_code.value);
   	    var ref_pr_no       = TrimCommon(document.forms.contentForm.st_ref_pr_no.value);
   		var purchase_dept_name  = TrimCommon(document.forms.contentForm.st_purchase_dept_name.value);
   	    if(purchase_dept_name == "") {
   	       alert("발주부서는 필수 입력 사항입니다.");
   	       document.forms.contentForm.st_purchase_dept_name.focus();
   		   return;
   		}
   		if(user_name == "") {
   	       alert("<%=cate_msg2%>" + "명은 필수 입력 사항입니다.");
   	       document.forms.contentForm.st_user_id.focus();
   		   return;
   		}
   		if(ref_pr_no == "") {
   	       alert("<%=cate_msg%>" + "는 필수 입력 사항입니다.");
   	       document.forms.contentForm.st_ref_pr_no.focus();
   		   return;
   		}
   		var mobile2 = document.forms.contentForm.st_mobile_no2.value;
   		var mobile3 = document.forms.contentForm.st_mobile_no3.value;
   	    if(mobile2 == "") {
   	       alert("연락처를 입력 바랍니다.");
   	        document.forms.contentForm.st_mobile_no2.focus();
   		   return;
   		}
   	     if(mobile3 == "") {
   	       alert("연락처를 입력 바랍니다.");
   	        document.forms.contentForm.st_mobile_no3.focus();
   		   return;
   		}
   	    var mobile_phone        = document.forms.contentForm.st_mobile_no1.value +"-"+ mobile2 +"-"+ mobile3;
   		document.forms.contentForm.st_mobile_no.value = mobile_phone;
   		document.forms.contentForm.st_tel_no.value  = mobile_phone;
   	    var recv_date    = document.forms.contentForm.st_recv_date.value;
   	    var toDate   = "<%=curDate%>";
   	    if(recv_date < toDate){
   	        alert("배송일은 현재일 이후로 선택하셔야 합니다.");
   	        document.forms.contentForm.st_recv_date.focus();
   	        return;
   	    }
   	    var location_name       = TrimCommon(document.forms.contentForm.st_location_name.value);
   	    if(location_name == "") {
   	       alert("배송처는 필수 입력 사항입니다.");
   	       document.forms.contentForm.st_location_name.focus();
   		   return;
   		}
    	    
    	var mg_note = user_id+"&"+ref_pr_no+"&"+dept_code+"&"+mobile_phone+"&";
    	document.forms.contentForm.st_mg_note.value = mg_note; // 상조용품
        // 배송처 앞부분 우편번호 자릿수 및 공백 체크(6, 7, 8 번째 공백)
        var chkZipCode = location_name.substring(0,5);
    	var chkSpace = location_name.substring(5,6);
		// 우편번호5자리 일 경우 유효성체크 안함.
		if((kepIsNumberString(chkZipCode)  == true) && (chkSpace == " ")){
			confirm_Submit2();
		}else{
			//5자리가 아닐경우
			kepAjaxFormCall("/mpso/checkZipCode.do","contentForm","CHECKZIP");	
		}
    	 
}



function confirm_Submit2(){
	var recvFlag = "1";
	var person_author = document.forms.contentForm.st_person_author.value;
	if(person_author == "PO"){
		if(recvFlag == '1' && !confirm("구매발주 하시겠습니까?  ")) return;
	}else {
		if(recvFlag == '1' && !confirm("구매요청 하시겠습니까?  ")) return;
	}

	var buyer         = document.forms.contentForm.st_buyer.value;
    var userDept      = document.forms.contentForm.st_user_dept.value;
    var ACCOUNT_TYPE  = document.forms.contentForm.st_account_type.value;
    var tot_price     = eval(document.forms.contentForm.nu_tot_price.value);
    var bdgt_flag     = document.forms.contentForm.st_bdgt_flag.value;  

	var budget_flag = "<%=budget_flag%>";

	//if(bdgt_flag == "Y")

	if(budget_flag == "Y")
	{
		doCheckAMT(buyer,userDept,ACCOUNT_TYPE,tot_price,tot_price,recvFlag);

	}else {
		setData(recvFlag);
	} 
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
	kepAjaxFormCall("/mpso/coway_cowayBuyerAdminBdgtTempCheck.do","processForm","COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}else{%>
	kepAjaxFormCall("/mpso/buyerAdminBdgtTempCheck.do","processForm","BUYER_ADMIN_BDGT_TEMP_CHECK"); 
	<%}
	//SLOGIC-END%>
	/*
	//코웨이일경우 예산 체크
	if(buyer == "KRCOWA0001" ||buyer == "KRCOWA0005" ||buyer == "KRCOWA0006"  ){
		goUrl  = "/kr/coway_buyer/proxybuy/bdgt/coway_buyer_admin_bdgt_temp_check.jsp?";
	}else{
		goUrl  = "/kr/coway_buyer/proxybuy/bdgt/buyer_admin_bdgt_temp_check.jsp?";
	}
	*/

   //goUrl  +="st_buyer=" + buyer+"&st_user_dept="+user_dept+"&st_account_type="+account_type+"&nu_tot_price="+tot_price+"&nu_end_price="+end_price+"&recvFlag="+recvFlag;
}



function setData(recvFlag){
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
		 kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ"); 
		 
		 
		//window.open( url , "work" , "width=500,height=500,toolbar=no,location=no,scrollbars=no,resizable=no,menubar=no,status=no");

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
 
    kepAjaxFormCall("/mpso/buyerNewCreateOrder.do","contentForm","BUYER_NEW_CREATE_ORDER");    
/*
  /kr/coway_buyer/shopping_cart/buyer_new_create_order.jsp
*/


}



function setCheckBox(){

      if(document.forms.contentForm.cbx.checked == true){
            if(confirm("작성하신 주문을 선입고 하시겠습니까?\n\n선입고시 발주일을 변경하실 수 있습니다.")){
               if(document.forms.contentForm.cbx1.checked == true){
                   alert("선입고 선택 시 긴급발주 선택을 하실 수 없습니다.");
                   document.forms.contentForm.cbx1.checked = false;
                   return;
               }
                   return;
            }else{
                   document.forms.contentForm.cbx.checked = false;
                   return;
            }
      }else if(document.forms.contentForm.cbx.checked == false){
             document.forms.contentForm.imsi_po_create_date.value = document.forms.contentForm.ToDateTemp.value;
             return;
      }
}



function setCheckBox1()
{
   if(document.forms.contentForm.cbx.checked == true){
       alert("선입고 선택 시 긴급발주 선택을 하실 수 없습니다.");
       document.forms.contentForm.cbx.checked = false;
       return;
   }

} 

function Calendar_Open(){
	 kepCalendarOpenPopup();
}

function setPopupCalendar(year,month,day){ 
	
      document.forms.contentForm.st_recv_date_text.value=year+"/"+month+"/"+day+"";
      document.forms.contentForm.st_recv_date.value=year+""+month+""+day+"";
      document.forms.contentForm.st_recv_date2.value=year+""+month+""+day+"";    
}


function setCheckEnd(FLAG,recvFlag){
     if(FLAG == "OK"){			
           setData(recvFlag);
     }
}


function ServerCallByCard(GW_NO,recvFlag){

alert('ServerCallByCard실 발주 호출');
return;
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
    kepAjaxFormCall("/mpso/buyerNewCreateOrder.do","contentForm","BUYER_NEW_CREATE_ORDER");    
    
    /*
/kr/coway_buyer/shopping_cart/buyer_new_create_order.jsp
    */

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
 

function setCreate_Results(response){

    var result = response.msg.MSG;   
    var pr_type = result.substring(0,2);
	var person_author = document.forms.contentForm.st_person_author.value;
	 

	if(pr_type != "PR" && pr_type != "PX"){
		if(person_author == "PO"){
			alert("구매발주가 실패 하였습니다. 확인 후 다시 주문해 주십시요.");
			return;
		}else {
			alert("구매요청이 실패 하였습니다. 확인 후 다시 주문해 주십시요.");
			return;
		}
	}  
	//alert("결재상신 처리 되었습니다.");
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
  //var loc = "/kr/customer/sheet/cart_print_seoj.jsp?buyer="+buyer+"&user_id="+user_id+"&contract_no="+contract_no+"&contract_seq="+contract_seq;
  //window.open(loc,"DraftSentenceView","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");

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
   

function setCreate_Benit_Results(response){

    var result = response.msg.MSG;   
    
    if(result == "OK"){
        alert("정상적으로 전송되었습니다.");
        document.forms.contentForm.st_query_cart.value = "";
        $('#contentForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do?leftMenu=N").submit();   
        //top.window.close();
	}  else {
	        alert("실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.");
	        return;
	}
}

 


/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){

	//alert("pMethod " +pMethod);
	
	var flag = "";
	var budget_dept_name = "";
	var account_text = "";
	var plan_amt = "";
	var result_amt = "";
	var temp_amt = "";
	var tot_price = "";
 
	   		 
	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"  || pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		
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

	        alert(budget_dept_name +
	              "\n\n"+account_text+" 예산   "+kepCommaNum(plan_amt)+" 원"+
	              "\n\n"+account_text+" 구매가능 예산   "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+" 원"+
	              "\n\n"+account_text+" 구매금액   "+kepCommaNum(tot_price)+" 원"+
	              "\n\n예산이 초과되어 구매할 수 없습니다.");
	        //  parent.main.setCheckEnd('NO',recvFlag);
	        return ;
	    } else if(flag == "예산미편성"){
	        alert(budget_dept_name + " "+account_text+ " 예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.");
	        return;
	    } else {
	    	  setCheckEnd('OK',recvFlag,end_price);
	    }	
		
		
	}else if (pMethod == "BUYER_NEW_CREATE_BENIT"){ 		
		
	   var result = response.msg.MSG;        
	    if(result == "DUP"){
	           alert("해당 주문은 이미 진행되었습니다.");
	           return;
	   	}
		    
		setCreate_Benit_Results(response);		
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 	
	
	   var result = response.msg.MSG;        
	    if(result == "DUP"){
	           alert("해당 주문은 이미 진행되었습니다.");
	           return;
	   	}
	    
		setCreate_Results(response);
		
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 		
		//setResult(response);
	}else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
		var checkpass = response.msg.CHECKPASS;   
		var pass_flag = response.msg.PASS_FLAG;   		
		GoPass(checkpass,pass_flag,"");
	} else if (pMethod == "CHECKZIP"){
		   var result = response.msg.MSG;        
			if (result == "N"){ 
				alert('우편번호가 유효하지 않습니다.');	
				document.forms.contentForm.st_location_name.focus();	 
		}else{
			confirm_Submit2();
		}
	}
 
    
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {

	if (pMethod == "COWAY_BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("시스템 오류입니다. 관리자에게 전화하시기 바랍니다.");
	}else if (pMethod == "BUYER_ADMIN_BDGT_TEMP_CHECK"){ 
		alert("시스템 오류입니다. 관리자에게 전화하시기 바랍니다.");
	}else if (pMethod == "BUYER_NEW_CREATE_BENIT"){ 
		alert("실패하였습니다  \n\n코리아이플랫폼 기술연구소로 문의 바랍니다.");
	}else if (pMethod == "BUYER_NEW_CREATE_ORDER"){ 
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "ADMIN_BUYER_MASTER_PR_CREATE_MAIL_REG"){ 
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
} 


//총금액  PG_06_B_006_50
function category_list_pop(){
    var byca_comorg_code   = "<%=byca_comorg_code%>";
    var user_id            = "<%=userId%>";    
    openSearchPopup("/mpso/getCategoryListSelectPop.do","?byca_comorg_code="+byca_comorg_code+"&user_id="+user_id, "500,500,no"); 

}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
</script>
</html>
