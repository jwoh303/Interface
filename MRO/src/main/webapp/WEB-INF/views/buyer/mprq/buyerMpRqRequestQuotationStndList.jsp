<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품견적의뢰
* 기능 : 고객사가 운영사에게 신규상품 견적의뢰를 한다
* 프로그램 ID : PG_04_B_003_00
* 담당자 : 김영미(설계:권우재)
* 생성일 : 2014-08-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String)request.getAttribute("gubun_msg"),""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String)request.getAttribute("item_cnt_no_msg"),""); // 등록후 결과
	String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
	String buyer =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String user_id = _sessionInfo.getUserId();
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
    String item_gubun_flag = "";
    item_gubun_flag="<select name='st_item_gubun_flag'><option value=ALL selected >-선택-</option><option value='O'>표준품</option><option value='T'>제작품</option></select>";
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
	String read_only =""; 
	String user_group = CommonUtil.nvl((String)_sessionInfo.getUserGroup(),""); //사용자견적권한
	if(buyer.equals("KRDOOS0020")){ 
		read_only = "readonly='readonly'";
	}
	//일진전기 특수로직.
	boolean p060000063 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000063");
	// 빙그레 특수로직
	String p060000068 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000068", "COL01_DATA");
	//카테고리 필수 특수로직.
	boolean p04404201 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4042-01");
	//요청단가 필수 특수로직.
	boolean p04405301 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4053-01");
	//제조사 필수 특수로직.
	boolean p04405401 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4054-01");
	//고객사 단위 사용 특수로직.
	boolean p04405501 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4055-01");
	//안전인증서 표기 여부
	boolean p04405701 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4057-01");
	//견적의뢰시 양식 다운로드
	String p060000103 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000103", "COL01_DATA");
	//품목 NO_CODE만 가능 특수로직.
	boolean p060000132 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000132");
	
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
<div id="container2">	
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE32")%></h3> <!-- 신규상품 견적의뢰 -->
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_pass_flag" id="st_pass_flag" value="">
			<!-- 비교견적서 변수-->
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE32")%></caption>	<!-- 신규상품 견적의뢰 -->
					<colgroup>
						<col width="8%" />
						<col width="12%" />
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup>
					
					<tbody>
					<tr >
						<td ><%=CommonLang.get("HTITLE40")%></td>	<!-- 의뢰자 -->
						<td ><label>: ${sessionInfo.userNameLoc}</label></td>
						<td ><%=CommonLang.get("HTITLE41")%></td>	<!-- 이메일 -->
						<td ><label>: ${sessionInfo.email}</label>
							<input type="hidden"  id="st_btoa_user_mail" name="st_btoa_user_mail"  style="width:80%" value="${sessionInfo.email}"></td>
						<td ><%=CommonLang.get("HTITLE42")%></td>	<!-- 연락처 -->
						<td ><label>: ${sessionInfo.tel}</label>
							<input type="hidden" id="st_btoa_user_tel" name="st_btoa_user_tel"  style="width:80%" value="${sessionInfo.tel}"></td>
						<td ><%=CommonLang.get("HTITLE43")%></td>	<!-- 팩스번호 -->
						<td ><label>: ${sessionInfo.fax}</label>
							<input type="hidden" id="st_btoa_user_fax" name="st_btoa_user_fax"  style="width:80%;" value="${sessionInfo.fax}"></td>
					</tr>
				</tbody>
			</table>
		</div>
  		
			※ <span><font color="blue"><b>C</b></font></span><%=CommonLang.get("HTITLE600")%><!-- : 클릭 행 복사 -->, <span><font color="blue"><b>D</b></font></span><%=CommonLang.get("HTITLE601")%><!-- : 클릭 행 삭제 -->
        <span class="fr">
        	<span class="btn_06 mr04"><a href="javascript:doPop('buyerMpRqCatalogRegYnPop');"><%=CommonLang.get("HTITLE33")%></a></span>	<!-- 카탈로그등록여부 -->
<%-- 					총건수 <%=total_cnt %> --%>
		</span>
 
	</form> 
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<input type="hidden" name="file_get_y" id="file_get_y"         value="">
	<input type="hidden" name="rowi" id="rowi"               value="">
	<table class="cont_t_list02" style="width:100%">
		<colgroup>
            <col width="3%" />
            <col width="4%" />
<%
	//
	if((p060000063 == true)) {
%>
            <col width="5%" />
<%
	}else{
%>
			<col width="9%" />
<%
	}
%>
<%
	//
	if((p060000063 == true)) {
%>
            <col width="*" />
<%
	}else{
%>
            <col width="18%" />
<%
	}
%>
            <col width="8%" />
            <col width="8%" />
            <col width="6%" />
            <col width="10%" />
            <col width="10%" />
            <col width="8%" />
            <col width="8%" />
            <col width="12%" />           
        </colgroup>
        <thead>
			<tr >
				<th rowspan="2" > 
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="checkAll();">
				</th> 
				<th rowspan="2" ><%=CommonLang.get("HTITLE44")%></th>	<!-- 번호 -->
<%
	//일진전기 견적 S-LOGIC
	if((p060000063 == true)) {
%>
            <th rowspan="2" >견적구분</th>		<!-- ? -->
<%
	}
%>
				<th><%=CommonLang.get("HTITLE12")%></th>	<!-- 품목코드 -->		
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE13")%></th>	<!-- 품목명 -->
				<th><%=CommonLang.get("HTITLE46")%></th>	<!-- 단가구분 -->
<%
	if((p04405301 == true)) {
%>
            	<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE50")%></th>	<!-- 요청단가 -->
<%
	}else{
%>
				<th><%=CommonLang.get("HTITLE50")%></th>	<!-- 요청단가 -->
<%
	}
%>
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE52")%></th>	<!-- 단위 -->
<%
	if((p04405401 == true)) {
%>				
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE15")%></th> <!-- 제조사 -->
				<th style="text-decoration:underline;"><a href="javascript:originNameCopy();"><%=CommonLang.get("HTITLE120")%></a></th> <!-- 원산지 -->
				
<%
	}else{
%>
				<th><%=CommonLang.get("HTITLE15")%></th> 
				<th style="text-decoration:underline;"><a href="javascript:originNameCopy();"><%=CommonLang.get("HTITLE120")%></a></th> <!-- 원산지 -->					
<%
	}
%>
				<th><%=CommonLang.get("HTITLE842")%></th>	<!-- 선입고 -->
				<th><%=CommonLang.get("HTITLE968")%></th>	<!-- 제작품 -->
				<th><%=CommonLang.get("HTITLE967")%>&nbsp;<img src="/resources/images/but_query.png" title="기재하신 협력사로 선정됩니다."></th>	<!-- 지정협력사 -->
				
				
			</tr>
			<tr >
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE45")%></th>	<!-- 수량 -->
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE14")%></th>	<!-- 규격 -->  
				<th><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;"><%=CommonLang.get("HTITLE51")%></font></a></th>	<!-- 회신요청일 -->
<%
if((p04404201 == true)) {
%>	
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></th>
 <%
}else{
 %>
 				<th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></th>
 <%
}
 %>
				<th><%=CommonLang.get("HTITLE119")%></th>	<!-- 첨부파일 -->
				<th colspan='2' style="text-decoration:underline;"><a href="javascript:remarkCopy();"><%=CommonLang.get("HTITLE122")%></a></th>	<!-- 비고 -->
				<th colspan='2'><%=CommonLang.get("HTITLE913")%></th>	<!-- 품목자료 -->				
				<th><%=CommonLang.get("HTITLE121")%>&nbsp;<img src="/resources/images/but_query.png" title="기재하신 협력사가 미선정될 수 있습니다.&#10;필수 지정을 희망하시는 경우 지정협력사 란에 기재 부탁드립니다."></th>	<!-- 기존협력사 -->								
			</tr> 
		</thead>
<!-- 		<tbody id="tblshow"> -->
             
<!--            		</tbody> -->
            </table>
            <table id="tblshow" class='cont_t_list022'></table>
		<!--페이징-->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
<%
	//견적의뢰 불가기능은 비활성화 USER_GROUP =Z
	if(!user_group.equals("Z")) {
%>
		<!--버튼영역-->
		<div class="btnArea">
        	<div class="fl">
<%
	//일진전기 견적 S-LOGIC
	if((p060000063 == false)) {
%>
				<span class="btn_03 mr04"><a href="javascript:doPop('excelUpload')"><%=CommonLang.get("HTITLE34")%></a></span>	<!-- 엑셀업로드 -->
				<span class="btn_04 mr04"><a href="/resources/excel/work/NEWSOURCING/BuyerMpRqExcelUploadPop.xls"><%=CommonLang.get("HTITLE35")%></a></span>	<!-- 양식다운로드 -->
<%
	}
%>
<%
	//신규견적의뢰 추가 양식 다운로드
	if((p060000103.equals("A001"))) {
%>
		<span class="btn_04 mr04"><a href="/resources/excel/work/NEWSOURCING/BuyerSourcingInstrunctions.xls"><%=CommonLang.get("HTITLE944")%></a></span>	<!-- 인쇄물제작사양서 -->
<%
	}
%>
				<span class="btn_02 mr04"><a href="javascript:doAction('add')"><%=CommonLang.get("HTITLE36")%></a></span>	<!-- 행추가 -->
				<span class="btn_02"><a href="javascript:doAction('del')"><%=CommonLang.get("HTITLE37")%></a></span>	<!-- 행삭제 -->
            </div>
            <div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE38")%></a>	<!-- 임시저장 -->
				</span>
				<span class="btn_04">
					<a href="javascript:doAction('reg');"><%=CommonLang.get("HTITLE39")%></a>	<!-- 견적의뢰 -->
				</span>	
            </div>
        </div>
<%
	}
%>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="gubun" id="gubun" value="" />
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

<script type="text/javascript">

var gridIndex = 0;  
var popupSel = "";
var btnEvent = "";
var g_Row          =  0;
var temp_yn = "N"; // 임시저장 여부

// 최초 화면 함수
function kep_onload_view(){
	addrows();
}	

function addrows(){
	var buyer = "<%=buyer%>";
	var days_3later = getWorkingDay();
	var days = days_3later.replace(/[/]/g,'');
	
<%	//고객사 단위 사용
	if((p04405501 == true)) {
%>
	var unit_measure    = "<select name='st_unit_measure' id=\"st_unit_measure\" style=\"width:65px\"><%= CommonUtil.getCodeBComboList(buyer,"NO","UNIT","ICOMCOD2","","TEXT1") %></select>";
<%
	}else{
%>	
	var unit_measure    = "<select name='st_unit_measure' id=\"st_unit_measure\" style=\"width:65px\"><%= CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo","") %></select>";
<%
	}
%>
	var req_price_type    = "<select name='st_req_price_type' id=\"st_req_price_type\"><%= CommonUtil.getCodeComboList("M150", "", "R", "", "", "") %></select>";
	//msds select box
	var st_msds_flag    = "<select name='st_msds_flag' id=\"st_msds_flag\"><%= CommonUtil.getCodeComboList("CA03", "", "R", "", "", "") %></select>";
	//선입고  select box
	var st_pre_gr_flag    = "<select name='st_pre_gr_flag' id=\"st_pre_gr_flag\"><%= CommonUtil.getCodeComboList("CA03", "", "R", "", "", "") %></select>";
	//제작품 select box
	var st_make_goods_flag    = "<select name='st_make_goods_flag' id=\"st_make_goods_flag\"><%= CommonUtil.getCodeComboList("CA03", "", "R", "", "", "") %></select>";
	// 안전인증서 select_box (체크박스로 사용하면 kep_common.js 에서 새로운 리스트로 받아들여 formData 전송 오류 24.04.11 HSJ)
	var st_safety_flag = "<select name='st_safety_flag' id=\"st_safety_flag\"><%= CommonUtil.getCodeComboList("CA03", "", "R", "", "", "") %></select>";
	
	var remark_data    = "<%=p060000068%>";
    var item_gubun_flag = "<%=item_gubun_flag%>";
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var idx         = rows.length;

	bFlag			= true;

    var vSeq = document.all['seqNo'];

    if(vSeq == null) {
          numkey =idx +1;
    }else {
        if(vSeq.length == null) {
           numkey =2;
         }else {
          numkey = vSeq.length+1;
         }
    }

    var newRow  = objrow.insertRow(idx);
    var td00 = newRow.insertCell();
    var td01 = newRow.insertCell();
    var td01_1 = newRow.insertCell();
    var td02 = newRow.insertCell();
    var td03 = newRow.insertCell();
    var td04 = newRow.insertCell();
    var td05 = newRow.insertCell();
    var td06 = newRow.insertCell();

    newRow.onmouseover = function() {objrow.clickedRowIndex=this.rowIndex;};

    td00.width = "3%";
    td00.innerHTML = "<table width='100%'><tr><td align='center'><input type='checkbox' name='InCheck' id='InCheck'"+numkey+"><input type='hidden' name='excel_up' id='excel_up' value='N'></td></tr><tr><td>&nbsp;</td></tr></table>";

    td01.width = "4%";
    td01.innerHTML = "<table border='0' width='100%'><tr><td align='center'><label id='seqNo'>"+numkey+"</label></td></tr><tr><td align='center'><a href=\"javascript:Del();\"><font color='blue'>D</font></a> | <a href=\"javascript:copy();\"><font color='blue'>C</font></a></td></tr></table>";
<%
	//일진전기 견적구분 입력
	if((p060000063 == true)) {
%>
	td01_1.width = "5%";
	td01_1.innerHTML = "<table border='0' width='100%'><tr><td align='center'>"+item_gubun_flag+"</td></tr><tr><td>&nbsp;</td></tr></table>";
<%
	}
%>
	td02.width = "9%";
    td02.innerHTML = "<table border='0' width='100%'><tr><td align='center'><input type=\"text\" name='st_buyer_item_no' id='st_buyer_item_no' Placeholder='NO_CODE' class=\"bbb\" style=\"width:95%;\"></td></tr><tr><td align='center'><input type=\"hidden\" name='st_item_qty' id='st_item_qty' style=\"width:95%;\"><input type=\"text\" name='st_item_qty_text' id='st_item_qty_text' style=\"width:95%;text-align:right; padding-right:1px;\" onblur=\"displayNumbering('ITEM_QTY', "+numkey+");\"></td></tr></table>";
    <%
	//일진전기 견적구분 입력
	if((p060000063 == true)) {
%>
		td03.width = "10%";
<%
	}else{
%>
		td03.width = "18%";
<%
	}
%>
    td03.innerHTML = "<table border='0' width='100%'><tr><td align='center'><input type=\"text\" name='st_description' id='st_description' class=\"bbb\" maxlength=\"50\" style=\"width:97%;\"></td></tr><tr><td align='center'><input type=\"text\" name='st_specification' id='st_specification' maxlength=\"250\" class=\"bbb\" style=\"width:97%;\"></td></tr></table>";

    td04.width = "16%";
    td04.innerHTML = "<table border='0' width='100%'><tr><td width=\"50%\">"+req_price_type+"</td><td width=\"50%\"><input type=\"hidden\" name='st_buyer_target_price' id='st_buyer_target_price'><input type=\"text\" name='st_buyer_target_price_text' id='st_buyer_target_price_text' <%=read_only%> style=\"width:92%;text-align:right;padding-right:1px;\" onblur=\"displayNumbering('BUYER_TARGET_PRICE', "+numkey+");\"></td></tr><tr><td><input type=\"text\" name='st_btoa_end_date_text' id='st_btoa_end_date_text' style=\"width:96%;text-align:center;\" onclick=\"doPop('calendar',"+numkey+");\" readonly value=\""+days_3later+"\"><input type=\"hidden\" name='st_btoa_end_date' id='st_btoa_end_date' value=\""+days+"\"></td><td align='center' width=\"60%\"><input type=\"hidden\" name='st_category_code' id='st_category_code' style=\"width:95%;\"><input type=\"text\" name='st_category_name' id='st_category_name' style=\"width:55%;\" readonly><a href=\"javascript:doPop('category');\"><img src=\"/resources/images/btn_search03.gif\" alt=\"검색\"/></a></td></tr></table>";

    td05.width = "6%";
    td05.innerHTML = "<table border='0' width='100%'><tr><td align='center'>"+unit_measure+"</td></tr><tr><td align='center'><input type='hidden' name='st_image_key' id='st_image_key' value=''><a href=\"javascript:doPop('attach',this)\"><img src=\"/resources/images/disk_off.gif\" name=\"Image2\" width=\"14\" height=\"14\" border=\"0\"></a></td></tr></table>";
  	//SLOGIC-BEGIN(P04-4025-01)
        td06.width ="48%";
      //안전인증서 표기 여부
      <%
      if((p04405701 == true)) {
      %>    
      	td06.innerHTML = "<table border='0' width='100%'><tr><td width=\"23%\"><input type=\"text\" name='st_maker_name' id='st_maker_name' maxlength=\"40\" class=\"bbb\" style=\"width:95%;\"></td><td style=\"width: 23%;\" align='center'><input type=\"hidden\" name=\"st_origin_code\" id='st_origin_code' style=\"width:85%;\"><input type=\"text\" name=\"st_origin_name\" id='st_origin_name' maxlength=\"20\" style=\"width:85%;cursor:hand;\" readonly onclick=\"doPop('country');\"></td><td>"+st_pre_gr_flag+" 선입고 "+st_make_goods_flag+" 제작품</td><td width=\"16%\"><input type=\"text\" name='st_buyer_assign_agent_code' id='st_buyer_assign_agent_code' style=\"width:95%;\" class=\"bbb\" ></td></tr><tr><td colspan='2'><input type=\"text\" name='st_btoa_remark' id='st_btoa_remark' value=\""+remark_data+"\" maxlength=\"4000\" class=\"bbb\" style=\"width:95%; margin-right: 5%;\"></td><td>"+st_msds_flag+" MSDS " + st_safety_flag + " 안전인증서" + "</td><td width=\"18%\"><input type=\"text\" name='st_agent_name' id='st_agent_name' style=\"width:95%;\" class=\"bbb\" ></td></tr></table>";
      <%
      }else{
      %>
      	td06.innerHTML = "<table border='0' width='100%'><tr><td width=\"23%\"><input type=\"text\" name='st_maker_name' id='st_maker_name' maxlength=\"40\" class=\"bbb\" style=\"width:95%;\"></td><td style=\"width: 23%;\" align='center'><input type=\"hidden\" name=\"st_origin_code\" id='st_origin_code' style=\"width:85%;\"><input type=\"text\" name=\"st_origin_name\" id='st_origin_name' maxlength=\"20\" style=\"width:85%;cursor:hand;\" readonly onclick=\"doPop('country');\"></td><td>"+st_pre_gr_flag+" 선입고 "+st_make_goods_flag+" 제작품</td><td width=\"16%\"><input type=\"text\" name='st_buyer_assign_agent_code' id='st_buyer_assign_agent_code' style=\"width:95%;\" class=\"bbb\" ></td></tr><tr><td colspan='2'><input type=\"text\" name='st_btoa_remark' id='st_btoa_remark' value=\""+remark_data+"\" maxlength=\"4000\" class=\"bbb\" style=\"width:95%; margin-right: 5%;\"><input type=\"hidden\" name='st_safety_flag' id='st_safety_flag'></td><td>"+st_msds_flag+" MSDS</td><td width=\"18%\"><input type=\"text\" name='st_agent_name' id='st_agent_name' style=\"width:95%;\" class=\"bbb\" ></td></tr></table>";
      <%
      }
      %>

  	//SLOGIC-END
  	
}

function getWorkingDay() {	
	var date = new Date();	
	if(date.getDay() == 3 || date.getDay() == 4 || date.getDay() == 5) { // 수목금
		date.setDate(date.getDate() + 5);
	}
	else if(date.getDay() == 6) { // 토
		date.setDate(date.getDate() + 4);
	} else { // 일월화
		date.setDate(date.getDate() + 3);
	}
	
	var year = date.getFullYear();
	var month = date.getMonth();
	month += 1;
	if(month <= 9) {
		month = "0" + month;
	}
	
	var day = date.getDate();
	if(day <= 9) {
		day = "0" + day;
	}
	
	var result = year + '/'+ month + '/'+ day;
	return result;
}

//각 해당 ROW 삭제
function Del(){
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
	bFlag			= true;

    if(tot_cnt <=1) {
    	//삭제할수 없습니다.
        alert("<%=CommonLang.msg("MSG35")%>");
        return;
    }

    objrow.deleteRow(objrow.clickedRowIndex);
    LabelSort();

}

//레이블 소팅
function LabelSort() {
    var vSeqNo = document.all['seqNo'];

    if(vSeqNo == null){

    }else if(vSeqNo.length == null) {
          vSeqNo.innerHTML =1;
    } else {
        for(var i=0; i<vSeqNo.length; i++) {
        	vSeqNo[i].innerHTML = i+1;
        }
    }
}

function displayNumbering(type, row) {
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
    var rowIndex = eval(row)-1;
    var imsi_target_qty = "";
    var imsi_buyer_target_price = "";
     if(eval(tot_cnt) < 2){
        imsi_target_qty             = kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));          // 수량 - 고정
        imsi_buyer_target_price     = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price.value           = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text.value      = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty.value             = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text.value        = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }else{
        imsi_target_qty             = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty_text[rowIndex].value));            // 수량 - 고정
        imsi_buyer_target_price     = kepTrimStr(kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[rowIndex].value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price[rowIndex].value         = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text[rowIndex].value        = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty[rowIndex].value           = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text[rowIndex].value      = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }
}
function btoaDateCopy() {
    var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_end_date_text  = "";
    var btoa_end_date       = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text.value;
            btoa_end_date   =  document.forms.contentForm.st_btoa_end_date.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text[j].value;
                btoa_end_date   =  document.forms.contentForm.st_btoa_end_date[j].value;
                break;
            }
        }
    }
    if(checked_count==0) {
    	//회신요청일을 복사할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG36")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_end_date[j].value         = btoa_end_date;
                document.forms.contentForm.st_btoa_end_date_text[j].value    = btoa_end_date_text;
            }else {
                document.forms.contentForm.st_btoa_end_date[j].value         = "";
                document.forms.contentForm.st_btoa_end_date_text[j].value    = "";
            }
        }
    }else {
    	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG37")%>");
        return;
    }
}

function remarkCopy() {
	var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_remark         = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_remark =  document.forms.contentForm.st_btoa_remark.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_remark =  document.forms.contentForm.st_btoa_remark[j].value;
                break;
            }
        }
    }

    if(checked_count==0) {
    	//복사할 비고를 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG38")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_remark[j].value           = btoa_remark;
            }else {
                document.forms.contentForm.st_btoa_remark[j].value           = "";
            }
        }
    }else {
    	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG37")%>");
        return;
    }
}

function originNameCopy() {
    var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var origin_name         = "";
    var origin_code         = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            origin_name =  document.forms.contentForm.st_origin_name.value;
            origin_code =  document.forms.contentForm.st_origin_code.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                origin_name =  document.forms.contentForm.st_origin_name[j].value;
                origin_code =  document.forms.contentForm.st_origin_code[j].value;
                break;
            }
        }
    }
    if(checked_count==0) {
    	//원산지를 복사할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG39")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_origin_code[j].value           = origin_code;
                document.forms.contentForm.st_origin_name[j].value   = origin_name;
            }else {
                document.forms.contentForm.st_origin_code[j].value           = "";
                document.forms.contentForm.st_origin_name[j].value   = "";
            }
        }
    }else {
    	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG37")%>");
        return;
    }
}
// 행복사
function copy(obj) {
    var objrow      = document.all['tblshow'];
	bFlag=true;
    addrows();
    
    var targetIndex = objrow.rows.length-1;
    if(objrow.rows.length > 1) {
        document.forms.contentForm.st_buyer_item_no[targetIndex].value           = document.forms.contentForm.st_buyer_item_no[objrow.clickedRowIndex].value;         // 품목코드
        document.forms.contentForm.st_item_qty[targetIndex].value           = document.forms.contentForm.st_item_qty[objrow.clickedRowIndex].value;         // 수량hidden
        document.forms.contentForm.st_item_qty_text[targetIndex].value           = document.forms.contentForm.st_item_qty_text[objrow.clickedRowIndex].value;         // 수량view
        document.forms.contentForm.st_description[targetIndex].value             = document.forms.contentForm.st_description[objrow.clickedRowIndex].value;           // 품명
        document.forms.contentForm.st_buyer_target_price[targetIndex].value     = document.forms.contentForm.st_buyer_target_price[objrow.clickedRowIndex].value;   // 실적단가hidden
        document.forms.contentForm.st_buyer_target_price_text[targetIndex].value     = document.forms.contentForm.st_buyer_target_price_text[objrow.clickedRowIndex].value;   // 실적단가view
        document.forms.contentForm.st_btoa_end_date[targetIndex].value           = document.forms.contentForm.st_btoa_end_date[objrow.clickedRowIndex].value;         // 회신요처일
        document.forms.contentForm.st_btoa_end_date_text[targetIndex].value      = document.forms.contentForm.st_btoa_end_date_text[objrow.clickedRowIndex].value;    // 회신요처일
        document.forms.contentForm.st_specification[targetIndex].value           = document.forms.contentForm.st_specification[objrow.clickedRowIndex].value;         // 규격
        document.forms.contentForm.st_unit_measure[targetIndex].value        = document.forms.contentForm.st_unit_measure[objrow.clickedRowIndex].value;          // 원산지
        document.forms.contentForm.st_maker_name[targetIndex].value          = document.forms.contentForm.st_maker_name[objrow.clickedRowIndex].value;            // 제조사
        document.forms.contentForm.st_origin_code[targetIndex].value         = document.forms.contentForm.st_origin_code[objrow.clickedRowIndex].value;           // 원산지
        document.forms.contentForm.st_agent_name[targetIndex].value          = document.forms.contentForm.st_agent_name[objrow.clickedRowIndex].value;            // 기존공급사
        document.forms.contentForm.st_btoa_remark[targetIndex].value         = document.forms.contentForm.st_btoa_remark[objrow.clickedRowIndex].value;           // 비고
        document.forms.contentForm.st_category_code[targetIndex].value         = document.forms.contentForm.st_category_code[objrow.clickedRowIndex].value;           // 카테고리
        document.forms.contentForm.st_category_name[targetIndex].value         = document.forms.contentForm.st_category_name[objrow.clickedRowIndex].value;           // 카테고리
    }
}

//기능함수
function doAction(str) {
	btnEvent = str;
	st = new Date();
	switch (str) {
	case "reg":
		temp_yn = "N";
		//kepAjaxFormCall("/mprq/getBuyerMpRqRequestQuotationItemCheck.do","processForm",btnEvent);
		checkForm();
		break;
	case "add":
		addrows();
		break;
	case "del":
		checkedDel();
		break;
	case "save":
		temp_yn = "Y";
		//kepAjaxFormCall("/mprq/getBuyerMpRqRequestQuotationItemCheck.do","processForm",btnEvent);
		checkForm();
		break;
	}
}


/**
 * FORM 을 초기화
 */
function reload(){
	$('#searchForm').attr("action", "/mprq/showBuyerMpRqRequestQuotationStnd.do").submit();   
}

//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
	case "calendar": // 달력
		g_Row = value1;
		gridIndex = value1;
		openSearchPopup('/common/calendarPop.do','','230,245,no');
		break;
	case "excelUpload": 
		openSearchPopup('/mprq/showBuyerMpRqExcelUploadPop.do','','900,700,no');
		break;
	case "country": // 원산지
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    document.forms.contentForm.rowi.value = objrow.clickedRowIndex;
	    
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no"); 
		break;
	case "buyerMpRqCatalogRegYnPop": // 카탈로그등록여부
		openSearchPopup("/mprq/showBuyerMpRqCatalogRegYnPop.do", "", "750,600,no"); 
		break;
	case "buyerMpRqUserRemarkPop": // 기초데이터입력
	    var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
		var idx			= objrow.clickedRowIndex;;
		var remark		= "";

	    document.forms.contentForm.file_get_y.value = idx; 
	    if(eval(tot_cnt)<=1) { 
	        remark = document.forms.contentForm.st_btoa_remark.value; 
	    }else {  
	        remark = document.forms.contentForm.st_btoa_remark[idx].value; 
	    } 
		openSearchPopup("/mprq/showBuyerMpRqUserRemarkPop.do", '?st_remark='+remark, "400,280,no"); 
		break;
		
	case "attach":
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt         = rows.length;
		var image_key = "";
	    if(eval(tot_cnt) < 2) {
	        image_key = document.forms.contentForm.st_image_key.value;
	    }else{
	        image_key = document.forms.contentForm.st_image_key[objrow.clickedRowIndex].value;
	    }
	    document.forms.contentForm.file_get_y.value = objrow.clickedRowIndex;

		var type="RFQ";
		var viewType="VI";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "category": // 카테고리
		var buyer = "<%=buyer%>";
		var user_id = "<%=user_id%>";
		
		var objrow      = document.all['tblshow'];
	    document.forms.contentForm.rowi.value = objrow.clickedRowIndex;
	    if (buyer=='KRDDDD0001' || buyer=='KRHYUN0026' || buyer=='KRHYUN0033' || buyer=='KRKYUN0002' ||	buyer=='KRISUC0002' || buyer=='KRISUC0007' ){
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do",'?st_buyer='+buyer,"400,500,no");			
		} else if (buyer=='KRDOOS0004' || buyer=='KRILJI0003' || buyer=='KRILJI0015' || buyer=='KRILJI0026' || 	buyer=='KRILJI0043' || buyer=='KRHSDE0003' ){	
			openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do",'?st_buyer='+buyer,'745,710,no');			
		} else if (buyer == 'KRDOOD0001'){ // 두산중공업 전용						
			openSearchPopup("/coco/showCommonCoCoBuyerCategoryChoiceDooPop.do",'?st_buyer='+buyer,"745,510,no");			
		} else {				
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer='+buyer+'&st_user_id='+user_id,"745,510,no");			
		}				
		break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "country") {
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    var rowi        = document.forms.contentForm.rowi.value;

	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.InCheck.checked        = true;
	        document.forms.contentForm.st_origin_name.value   = value;
	        document.forms.contentForm.st_origin_code.value   = code;
	    }else {
	        document.forms.contentForm.InCheck[rowi].checked      = true;
	        document.forms.contentForm.st_origin_name[rowi].value = value ;
	        document.forms.contentForm.st_origin_code[rowi].value = code ;
	    }
	    document.forms.contentForm.rowi.value="";
	} else if (popupSel == "buyerMpRqUserRemarkPop"){
		
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt         = rows.length;
	    
	    if(eval(tot_cnt)<=1) { 
	        document.forms.contentForm.st_btoa_remark.value  = code; 
	    }else { 
	        var pos = document.forms.contentForm.file_get_y.value; 
	        document.forms.contentForm.st_btoa_remark[pos].value = code; 
	    } 
	}else if (popupSel == "attach") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    var y       = document.forms.contentForm.file_get_y.value;
	    
	    if(eval(tot_cnt) < 2) {
	        document.forms.contentForm.st_image_key.value = code;
	    }else {
	        document.forms.contentForm.st_image_key[y].value = code;
	    }
	    if(code != ''){
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = code;
	            document.forms.contentForm.Image2.src = diskOn;
	        }else{
	            document.forms.contentForm.st_image_key[y].value = code;
	            document.forms.contentForm.Image2[y].src = diskOn;
	        }
	    }else{
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = "";
	            document.forms.contentForm.Image2.src = diskOff;
	        }else{
	            document.forms.contentForm.st_image_key[y].value = "";
	             document.forms.contentForm.Image2[y].src = diskOff;
	        }
	    }
		
	}else if (popupSel == "category") {
		var objrow      = document.all['tblshow'];
	    var rows        = objrow.rows;
	    var tot_cnt     = rows.length;
	    var rowi        = document.forms.contentForm.rowi.value;

	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.InCheck.checked        = true;
	        document.forms.contentForm.st_category_name.value   = text;
	        document.forms.contentForm.st_category_code.value   = code;
	    }else {
	        document.forms.contentForm.InCheck[rowi].checked      = true;
	        document.forms.contentForm.st_category_name[rowi].value = text;
	        document.forms.contentForm.st_category_code[rowi].value = code;
	    }
	    document.forms.contentForm.rowi.value="";
	}
}

function setPopupCalendar(year,month,day){
    var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var btoa_end_date   = year.toString()+month.toString()+day.toString();
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    if(parseInt(btoa_end_date) < parseInt(nowDate)) {
    	//회신요청일은 현재일 이후여야 합니다.
        alert("<%=CommonLang.msg("MSG40")%>");
        return;
    }
    if(eval(tot_cnt)<=1)  {
        document.forms.contentForm.InCheck.checked=true;
        document.forms.contentForm.st_btoa_end_date_text.value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date.value = btoa_end_date;
    }
    else {
        document.forms.contentForm.InCheck[g_Row-1].checked=true;
        document.forms.contentForm.st_btoa_end_date_text[g_Row-1].value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date[g_Row-1].value = btoa_end_date;
    }
}

//체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
//재귀함수
var changed_i=0;
var changed_tot_cnt     = 0;

function checkedDel() {
 changed_i=0;
 var vSeqNo              = document.all['seqNo'];
 var objrow              = document.all['tblshow'];
 var rows                = objrow.rows;
 changed_tot_cnt     = rows.length;
 var checked_count       = 0;

 if(changed_tot_cnt==1) {
     if(document.forms.contentForm.InCheck.checked==true) checked_count=1;
 }else {
     for(var j=0; j<changed_tot_cnt; j++) {
         if(document.forms.contentForm.InCheck[j].checked==true) checked_count++;
     }
 }
 if(checked_count==0 && changed_i==0) {
     LabelSort();
     return;
 }
 if(checked_count == changed_tot_cnt || changed_tot_cnt==1 || checked_count==0) {
     //모든 데이타를 삭제할수는 없습니다.
	 alert("<%=CommonLang.msg("MSG41")%>");
     return;
 }else {
		if(bFlag) {
			//삭제하시겠습니까?
			if(confirm("<%=CommonLang.msg("MSG42")%>")) {
				bFlag=false;
				for(; changed_i<changed_tot_cnt; changed_i++) {
					if(document.forms.contentForm.InCheck[changed_i].checked==true) {
						objrow.deleteRow(changed_i);
						changed_tot_cnt=0;
						checkedDel();
					}
				}
			}
		}else {
			for(; changed_i<changed_tot_cnt; changed_i++) {
				if(document.forms.contentForm.InCheck[changed_i].checked==true) {
					objrow.deleteRow(changed_i);
					changed_tot_cnt=0;
					checkedDel();
				}
			}
		}
 }
 LabelSort();
}
//전체선택/해제

function checkAll() {
    var objrow      = document.all['tblshow'];
    var rows        = objrow.rows;
    var tot_cnt     = rows.length;
//     var check_status = document.forms.contentForm.check_status.value;
    if(document.forms.contentForm.check_status.checked == true) {
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
//             var check_status = "해제";
            if(box.checked == false) box.checked = true;
//             document.forms.contentForm.check_status.value = check_status;
        }else {
            for(var j = 0; j < tot_cnt; j++) {
            	var box = document.forms.contentForm.InCheck[j];
//                 var check_status = "해제";
                if(box.checked == false) box.checked = true;
//                 document.forms.contentForm.check_status.value = check_status;
            }
        }
    }else{
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
//             var check_status = "선택";
            if(box.checked == true) box.checked = false;
//             document.forms.contentForm.check_status.value = check_status;
        }else {
            for(var j = 0; j < tot_cnt; j++){
                var box = document.forms.contentForm.InCheck[j];
//                 var check_status = "선택";
                if(box.checked == true) box.checked = false;
//                 document.forms.contentForm.check_status.value = check_status;
            }
        }
    }
}

// 견적의뢰
function checkForm() {
	var objrow              = document.all['tblshow'];
    var rows                = objrow.rows;
    var tot_cnt             = rows.length;
    var checked_count       = 0;
    var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
	
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) checked_count = 1;
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
            }
        }
    }
    if(checked_count==0) {
    	//견적의뢰할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG43")%>");
        return;
    }
    
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm.InCheck").checked==true) {
			var buyer_item_no					= document.forms.contentForm.st_buyer_item_no.value;         // 품목코드
			var itemCodeEl = document.forms.contentForm.st_buyer_item_no;
			itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
			buyer_item_no = itemCodeEl.value;
			if(kepHasHangul(buyer_item_no)) {
				itemCodeEl.focus();
				var text = "품목코드에는 한글을 사용할 수 없습니다.";
				alert(text);
				return;
			}
			if(buyer_item_no == '' || buyer_item_no == null) {
				buyer_item_no  = 'NO_CODE';	
			}			
			var item_qty								= document.forms.contentForm.st_item_qty.value;              // 수량
			var item_qty_text					= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));              // 수량
			var description							= document.forms.contentForm.st_description.value;           // 품목명
			var buyer_target_price			= document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
			var buyer_target_price_text	= kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));    // 실적단가
			var btoa_end_date					= document.forms.contentForm.st_btoa_end_date.value;         // 회신요처일
			var specification						= document.forms.contentForm.st_specification.value;         // 규격
            
			var image_key						= document.forms.contentForm.st_image_key.value;              // 첨부파일 이미지 키
			var btoa_remark					= document.forms.contentForm.st_btoa_remark.value;           // 비고
			var make_goods					= document.forms.contentForm.st_make_goods_flag.value;
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				alert("<%=CommonLang.msg("MSG40")%>");
				return;
			}
		<%
			//일진전기 견적 S-LOGIC 품목구분 관련 내용 추가.
			if((p060000063 == true)) {
		%>
				var item_gubun_flag      = document.forms.contentForm.st_item_gubun_flag.value;       // 품목구분
		        if(item_gubun_flag == "ALL"){
		        	 //견적구분정보를 선택해 주시기 바랍니다.   
		        	alert("<%=CommonLang.msg("MSG44")%>");
		        	document.forms.contentForm.st_item_gubun_flag.focus();
		        	return;
		        }
	            if(item_gubun_flag == "T"){
	            	  if(kepIsValueNull(image_key)){
	            		  // 제작품의 경우 도면이나 이미지를 반드시 첨부 하셔야 합니다.  
	            	  	   alert("<%=CommonLang.msg("MSG45")%>");
	            	  	   return;
	            	  }
	            }
	            if(kepIsValueNull(btoa_remark)){
	            	// 비고(제조사)를 입력하여 주십시오. 
         	  	   alert("<%=CommonLang.msg("MSG46")%>");
         	  		document.forms.contentForm.st_btoa_remark.focus();
        	  	   return;	            	
	            }
		<%
			}
		%>
			// NO_CODE로만 진행하도록 통제
			<%if(p060000132 == true) { %>
					if(buyer_item_no != 'NO_CODE') {
						alert("<%=CommonLang.msg("MSG592")%>");
						return;
					}
			<% } %>
		
			var unit_measure					= document.forms.contentForm.st_unit_measure.value;          // 단위
			var maker_name					= document.forms.contentForm.st_maker_name.value;            // 제조사
			var origin_code					= document.forms.contentForm.st_origin_code.value;           // 원산지
			var agent_name					= document.forms.contentForm.st_agent_name.value;            // 기존협력사
			
			if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
				//수량을 정수형으로 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG555")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}
			if(item_qty_text == '0') {
				//수량에 1 이상의 숫자를 입력해 주십시요
				alert("<%=CommonLang.msg("MSG192")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}
			

			var category_code      = document.forms.contentForm.st_category_code.value;       // 카테고리
			var category_name      = document.forms.contentForm.st_category_name.value;       // 카테고리
			<%
			// 롯데알미늄 카테고리 필수값 체크
			if((p04404201 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(category_name))) {
					//카테고리 필수값 체크
					alert("<%=CommonLang.msg("MSG489")%>");
					return;
				}
			<%
			}
			%>
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				//품명을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG48")%>");
				document.forms.contentForm.st_description.focus();
				return;
			}
			
			buyer_target_price = buyer_target_price_text;
			<%
			// 요청단가 필수값 체크
			if((p04405301 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					alert("<%=CommonLang.msg("MSG495")%>");	//요청단가를 입력하여 주십시오.
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
			<%
			}
			%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
				if(!kepIsNumChkStr(buyer_target_price_text, 3)) {
					//실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					alert("<%=CommonLang.msg("MSG49")%>");
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
			}else {
				buyer_target_price = 0;
			}

			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				//규격을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG50")%>");
				document.forms.contentForm.st_specification.focus();
				return;
			}

			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				alert("<%=CommonLang.msg("MSG51")%>");
				return;
			}
			<%
			//일진전기 견적 S-LOGIC 품목구분 관련 내용 추가.
			if((p060000063 == true)) {
		%>
		        if(item_gubun_flag == "T"){
		        	//제작품 :
		      	  document.forms.contentForm.st_btoa_remark.value = "<%=CommonLang.msg("MSG354")%>"+btoa_remark;
		      }else{
		    	  //표준품 :
		      	document.forms.contentForm.st_btoa_remark.value = "<%=CommonLang.msg("MSG355")%>"+btoa_remark;	
		      }
		<%
			}
		%>
		<%
		//MSDS, 안전인증서 선택여부 셋팅
		if((p04405701 == true)) {
		}else{
		%>
			//안전인증서 체크로직이 없으므로 무조건 N처리
			document.forms.contentForm.st_safety_flag.value ="N";
		<%
		}
		%>
		
		<%
		// 제조사 필수값 체크
		if((p04405401 == true)) {
		%>
			if(kepIsValueNull(kepTrimStr(maker_name))) {
				alert("<%=CommonLang.msg("MSG496")%>");	//제조사를 입력하여 주십시오.
				document.forms.contentForm.st_maker_name.focus();
				return;
			}
		<%
		}
		%>	
		
		if(make_goods == "Y"){
			document.forms.contentForm.st_btoa_remark.value = "제작품, " +btoa_remark;
		}
		
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {

			if(document.forms.contentForm.InCheck[i].checked==true) {
				var buyer_item_no					= document.forms.contentForm.st_buyer_item_no[i].value;                          // 품목코드
				var itemCodeEl = document.forms.contentForm.st_buyer_item_no[i];
				itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
				buyer_item_no = itemCodeEl.value;
				if(kepHasHangul(buyer_item_no)) {
					itemCodeEl.focus();
					var text = (i+1)+"번째 행의 품목코드에는 한글을 사용할 수 없습니다.";
					alert(text);
					return;
				}
				if(buyer_item_no == '' || buyer_item_no == null) {
					buyer_item_no  = 'NO_CODE';	
				}
				for(var j = i+1; j < tot_cnt; j++) { // 품목코드 중복 체크
					if(document.forms.contentForm.InCheck[j].checked==true) {
						var tmp_buyer_item_no = document.forms.contentForm.st_buyer_item_no[j].value;
						if(tmp_buyer_item_no.toUpperCase() != "NO_CODE") {							
						
							if(buyer_item_no != "" && tmp_buyer_item_no != "") {
								if(buyer_item_no == tmp_buyer_item_no) {
									alert("동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.")
									return;
								}
							}							
						}							
					}
				}
				var item_qty								= document.forms.contentForm.st_item_qty[i].value;                               // 수량
				var item_qty_text					= kepFilterNum(document.forms.contentForm.st_item_qty_text[i].value);               // 수량
				var description							= document.forms.contentForm.st_description[i].value;                            // 품목명
				var buyer_target_price			= document.forms.contentForm.st_buyer_target_price[i].value;                     // 실적단가
				var buyer_target_price_text	= kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[i].value);     // 실적단가
				var btoa_end_date					= document.forms.contentForm.st_btoa_end_date[i].value;                          // 회신요처일
				var specification						= document.forms.contentForm.st_specification[i].value;                          // 규격
				var btoa_remark						= document.forms.contentForm.st_btoa_remark[i].value;        // 비고
				var image_key							= document.forms.contentForm.st_image_key[i].value;           // 첨부파일 이미지 키
	            
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//회신요청일은 현재일 이후여야 합니다.
					alert("<%=CommonLang.msg("MSG40")%>");
					return;
				}
				var unit_measure						= document.forms.contentForm.st_unit_measure[i].value;           // 단위
				
				var maker_name						= document.forms.contentForm.st_maker_name[i].value;         // 제조사
				var origin_code						= document.forms.contentForm.st_origin_code[i].value;        // 원산지
				var agent_name						= document.forms.contentForm.st_agent_name[i].value;         // 기존협력사
				var make_goods					= document.forms.contentForm.st_make_goods_flag[i].value;

				<%
				//일진전기 견적 S-LOGIC 품목구분 관련 내용 추가.
				if((p060000063 == true)) {
			%>
					var item_gubun_flag      = document.forms.contentForm.st_item_gubun_flag[i].value;       // 품목구분
			        if(item_gubun_flag == "ALL"){
			        	// 견적구분정보를 선택해 주시기 바랍니다.   
			        	alert("<%=CommonLang.msg("MSG44")%>");
			        	document.forms.contentForm.st_item_gubun_flag[i].focus();
			        	return;
			        }
		            if(item_gubun_flag == "T"){
		            	  if(kepIsValueNull(image_key)){
		            		  // 제작품의 경우 도면이나 이미지를 반드시 첨부 하셔야 합니다.  
		            	  	   alert("<%=CommonLang.msg("MSG45")%>");
		            	  	   return;
		            	  }
		            }
		            if(kepIsValueNull(btoa_remark)){
		            	// 비고(제조사)를 입력하여 주십시오. 
		         	  	   alert("<%=CommonLang.msg("MSG46")%>");
		         	  		document.forms.contentForm.st_btoa_remark[i].focus();
		        	  	   return;	            	
			            }
			<%
				}
			%>
				// NO_CODE로만 진행하도록 통제
				<%if(p060000132 == true) { %>
						if(buyer_item_no != 'NO_CODE') {
							alert("<%=CommonLang.msg("MSG592")%>");
							return;
						}
				<% } %>
			
				if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG556")%>");
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}
				if(item_qty_text == '0') {
					//수량에 1 이상의 숫자를 입력해 주십시요
					alert("<%=CommonLang.msg("MSG192")%>");
					document.forms.contentForm.st_item_qty[i].value ="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}

				var category_code      = document.forms.contentForm.st_category_code[i].value;       // 카테고리
				var category_name      = document.forms.contentForm.st_category_name[i].value;       // 카테고리
				<%
				// 롯데알미늄 카테고리 필수값 체크
				if((p04404201 == true)) {
				%>
					// 카테고리 필수값 체크
					if(kepIsValueNull(kepTrimStr(category_name))) {
						//카테고리를 선택하세요
						alert("<%=CommonLang.msg("MSG489")%>");
						return;
					}
				<%
				}
				%>
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					//번째 행의 품명을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG54")%>");
					document.forms.contentForm.st_description[i].focus();
					return;
				}

				buyer_target_price = buyer_target_price_text;
				<%
				// 요청단가 필수값 체크
				if((p04405301 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						alert((i+1)+"<%=CommonLang.msg("MSG501")%>");	//번째 행의 요청단가를 입력하여 주십시오.
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
				<%
				}
				%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						//번째 행의 실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						alert((i+1)+"<%=CommonLang.msg("MSG55")%>");
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}

				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					//번째 행의 규격을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG56")%>");
					document.forms.contentForm.st_specification[i].focus();
					return;
				}

				// 등록요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오..
					alert((i+1)+"<%=CommonLang.msg("MSG57")%>");
					return;
				}
				<%
				//일진전기 견적 S-LOGIC 품목구분 관련 내용 추가.
				if((p060000063 == true)) {
			%>
			        if(item_gubun_flag == "T"){
			        	//제작품 : 
			      	  document.forms.contentForm.st_btoa_remark[i].value = "<%=CommonLang.msg("MSG354")%>"+btoa_remark;
			      }else{
			    	  //표준품 : 
			      	document.forms.contentForm.st_btoa_remark[i].value = "<%=CommonLang.msg("MSG355")%>"+btoa_remark;
			      }
			<%
				}
			%>
			<%
			//MSDS, 안전인증서 선택여부 셋팅
			if((p04405701 == true)) {
			}else{
			%>
				//안전인증서 체크로직이 없으므로 무조건 N처리
				document.forms.contentForm.st_safety_flag[i].value ="N";
			<%
			}
			%>
			<%
			// 제조사 필수값 체크
			if((p04405401 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					alert((i+1)+"<%=CommonLang.msg("MSG502")%>");	//번째 행의 제조사를 입력하여 주십시오.
					document.forms.contentForm.st_maker_name[i].focus();
					return;
				}
			<%
			}
			%>

				if(make_goods == "Y"){
					if(document.forms.contentForm.st_btoa_remark[i].value.substring(0,4) != "제작품,") {						
						document.forms.contentForm.st_btoa_remark[i].value = "제작품, " +btoa_remark;
					}				
				}
			}
		}
	}

	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		$("#processForm").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
		$("#process").html(formArr[1]);
		$("#process").find("#check_status").remove();
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		alert("<%=CommonLang.msg("MSG13")%>");
		return;
	}
	
	if(temp_yn == "Y"){ // 임시저장
		//임시저장한 데이터는 견적임시저장조회 화면에서 확인 가능합니다. \n저장하시겠습니까?
		if (confirm("<%=CommonLang.msg("MSG58")%>")){
			temp_yn = "N";
			kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationTemp.do","processForm",btnEvent);
		}
	}else{ // 결재
		kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationStnd.do","processForm",btnEvent);
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
			var type = "NG"; // 견적의뢰
			var buyer = "<%=buyer%>";
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		} else if (passFlag == "C"){
			//전자 결재 처리 하시겠습니까? \n\n바로 견적의뢰 하시려면 취소버튼을 눌러 주십시오.
			if (!confirm("<%=CommonLang.msg("MSG356")%>")){
				// 바로생성	
				btnEvent = "noPassReq";
				kepAjaxFormCall("/mprq/saveNoPassReq.do","processForm",btnEvent); 
			} else {
				// 결재 연결
				btnEvent = "passReq";
				kepAjaxFormCall("/mprq/savePassReq.do","processForm",btnEvent); 
			}
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				//견적번호 생성 되었습니다.
				alert(msg+" "+"<%=CommonLang.msg("MSG507")%>");
			}
			reload();
		}
	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			//견적번호 생성 되었습니다.
			alert(msg+" "+"<%=CommonLang.msg("MSG507")%>");
		}
		reload();
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=buyer%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	} else if(pMethod == "save"){
		//정상적으로 임시저장되었습니다.
		alert("<%=CommonLang.msg("MSG59")%>");
	}
};
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.
	alert("<%=CommonLang.msg("MSG60")%>");
	
} 
function kepApprovalReturn(flag,docu_no){
	reload();
}

</script>
</html>
