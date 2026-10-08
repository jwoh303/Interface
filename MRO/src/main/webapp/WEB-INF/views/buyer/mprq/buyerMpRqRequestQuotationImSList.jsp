<%--
**********************************************
* 메뉴 : 신규상품 신청 > 임시저장조회
* 화면 : 임시저장조회
* 기능 : 임시저장조회
* 프로그램 ID : PG_02_B_000834_012
* 담당자 : 현명환
* 착수일 : 2015-03-18
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
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"50");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.    
	// 조회조건 S
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");    
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");    
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");    	
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"");   
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");   
	// 조회조건 E
	
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 	
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 //전사공구 주문가능
	 boolean getCode144 = CommonUtil.getCodeCheckReturn("M144",sessionInfo.getUserId());
	 
%> 

<body onLoad="kep_onload_view()">
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
	<h3>임시저장조회</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search','');">조회</a></span> 
		<span class="btn_reset" title="초기화"><a href="javascript:doAction('reload','');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<input type="hidden" name="st_buyer" id="st_buyer"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id"  value="${sessionInfo.userId}">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<div id="cont_searchA">	
			<table class="cont_t_list01" style="width:887px;">
				<tr><td>
	        		> 신규견적 임시저정건이 조회됩니다.
	          	</td></tr>
			</table>    
		</div>
		<div class="contList"> <span class="fl"> <img src="/resources/images/txt_no.gif" alt="정렬개수" />
		  <label for="b_no02" class="hidden">정렬개수선택</label>
		  <select name="onepagerow" onChange="javascript:kepSearch(1);">
		    <option  value = "5">5건</option>
		    <option  selected value = "50">50건</option>
		    <option  value = "100">100건</option>
		    <option  value = "200">200건</option>
		  </select>
		  </span>
	</div>
  	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list002" style="width:100%">
			  <colgroup>
            <col width="5%" />
            <col width="17%" />
            <col width="35%" />
            <col width="10%" />
            <col width="10%" />
            <col width="11%" />
            <col width="12%" />
			  </colgroup>
		        <thead>
					<tr >
						<th rowspan="2" > 
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%> 
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onClick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
<%}%>
						</th> 
						<th>품목코드</th>
						<th><font color="#FF6600">*</font>품목명</th>
						<th>실적단가</th>  
						<th>단위</th>
						<th><font color="#FF6600">*</font>품목구분</th>
						<th>년예상소요량</th>
					</tr>
					<tr >
						<th><font color="#FF6600">*</font>수량</th>
						<th><font color="#FF6600">*</font>규격</th>  
						<th><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;">회신요청일</font></a></th> 
						<th>첨부파일</th>
						<th colspan="2" style="text-decoration:underline;"><a href="javascript:remarkCopy();">비고</a></th>
					</tr> 
				</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
		<tr>
			<td colspan="15" align="center" height = "50"> 
			<span>조회된 데이타가 없습니다.</span>
			</td> 
		</tr>
<%
}else{
Map<String,String> rowData = null;
for (int j=0; j<_gridList.size(); j++) {
	rowData = _gridList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
	
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  class="center" rowspan="2">						
						<input type="hidden" name="st_quotation_no"  value="<%=rowData.get("QUOTATION_NO")%>">
						<input class="input_noline"  type="checkbox" id="lnCheck<%=j%>"  name="lnCheck<%=j%>" >												
			            <input type="hidden" name="st_quotation_seq" value="<%=rowData.get("QUOTATION_SEQ")%>">
			            <input type="hidden" name="st_revision"      value="<%=rowData.get("REVISION")%>">
			            <input type="hidden" name="st_item_type"     value="<%=rowData.get("ITEM_TYPE")%>">
			            <input type="hidden" name="st_year_qty"      value="<%=rowData.get("YEAR_QTY")%>">
			            <input type="hidden" name="st_category_id"   value="<%=rowData.get("CATEGORY_NO")%>">
			            <input type="hidden" name="st_btoa_end_date"   value="<%=rowData.get("BTOA_END_DATE")%>">
			            <input type="hidden" name="st_buyer"         value="<%=rowData.get("BUYER")%>">
			            <input type="hidden" name="st_user_id"       value="${sessionInfo.userId}">
			            <input type="hidden" name="st_image_key"     value="">
					</td>
					<td title="품목코드">										
			            <input type="text" name="st_buyer_item_no" style="width:95%;" id="line" class = "input_type_text"   onChange="javascript:this.value=this.value.toUpperCase();"  value="<%=rowData.get("BUYER_ITEM_NO")%>">   
					</td>
                    <td title="품목명"  class="left">
                    	<%=rowData.get("DESCRIPTION")%>
                    </td> 
					<td class="right"  title="실적단가" >
						<span class="Price"><%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%></span>
					</td>
		          	<td class="center"   title="단위" >
		          		<select name="st_unit_measure" id="st_unit_measure"><%= CommonUtil.getCodeBComboList("KRDOOD0001","SEL","C013","ICOMCOD2",rowData.get("UNIT_MEASURE"),"TEXT1") %></select>
		            </td>
			          <td class="center"  title="품목구분">
			          	<select name="st_item_gubun_flag" id="st_item_gubun_flag"><%= CommonUtil.getCodeBComboList("KRDOOD0001","SEL","C014","ICOMCOD2",rowData.get("ITEM_TYPE"),"TEXT1") %></select>
            		</td>
			          <td class="center"  title="년예상소요량">
			          	<input type="text" name="st_year_qty_text" style="width:95%;text-align:right;" id="line" class = "input_type_text"   value="<%=rowData.get("YEAR_QTY")%>"> 
            		</td>
				</tr> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="center"   title="수량" >
						<input type="text" name="st_item_qty"   style="width:95%;text-align:right;"  id="line" class = "input_type_text"   value="<%=rowData.get("ITEM_QTY")%>">         
					</td>
					<td class="center"   title="규격" >
						<input type="text" name="st_specification"   style="width:95%;"  id="line" class = "input_type_text"   value="<%=rowData.get("SPECIFICATION")%>">         
					</td>
					<td class="center"   title="회신요청일" >
						<input type="text" name="st_btoa_end_date_text"   style="width:95%;text-align:center;"  id="line" class = "input_type_text"   value="<%=CommonUtil.formatStrinigDate(rowData.get("BTOA_END_DATE"))%>" onclick="doPop('calendar','<%=j%>');"  readonly>         
					</td>
					<td title="첨부" >
                      <%
                       if(!rowData.get("IMAGE_KEY").equals("")) {
                       %>
                     	 	<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>
                      <%}else { %>
                        	 <img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
                     <%}%>
                     </td>
					<td class="center"   title="비고"  colspan="2">
						<input type="text" name="st_btoa_remark"   style="width:95%;"  id="line" class = "st_btoa_remark"   value="<%=rowData.get("BTOA_REMARK")%>">         
					</td>
				</tr>
<%
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
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('deleteRqdt');">삭제</a> 
				</span>	
				<span class="btn_04" title="견적의뢰" >
					<a href="javascript:doAction('reg');">견적의뢰</a>
				</span>					
            </div>
        </div>
</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
 <h4  id="confirmMsg"></h4>  
	<!-- 버튼영역 -->
	<div class="btnArea"> 
		<div class="fr">
			<span class="btn_04">
				<a href="javascript:kep_confrim_search();">계속검색</a>
			</span>	
			<span class="btn_04">
				<a href="javascript:kep_confirm_location();">이동</a>
			</span>	
			<span class="btn_04">
				<a href="javascript:kep_confirm_cancel();">취소</a>
			</span>					
		</div>
	</div>        
</div>
<script type="text/javascript">
var popupSel = "";
var g_Row          =  0;
var btnEvent = "";
// 최초 화면 함수 
function kep_onload_view(){
 
}
//전체선택/해제

function checkAll() {

    var tot_cnt      = $("#display_item_cnt").val();
    if(document.forms.contentForm.check_status.checked == true) {
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.lnCheck;
            if(box.checked == false) box.checked = true;
        }else {
            for(var j = 0; j < tot_cnt; j++) {
            	var box = document.forms.contentForm.lnCheck[j];
                if(box.checked == false) box.checked = true;
            }
        }
    }else{
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.lnCheck;
            if(box.checked == true) box.checked = false;
        }else {
            for(var j = 0; j < tot_cnt; j++){
                var box = document.forms.contentForm.lnCheck[j];
                if(box.checked == true) box.checked = false;
            }
        }
    }
}
//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
	case "calendar": // 달력
		g_Row = value1;
		gridIndex = value1;
		openSearchPopup('/common/calendarPop.do','','130,240,no');
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
	}
}
/**
 * 저장
 */
function saveReq(){
	var tot_cnt  = $("#display_item_cnt").val();
	var getCode144 = <%=getCode144%>;
	var chk_cnt = 0;
	var query = "";
	var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
	 
   if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
       alert(" 목록에 표시된 상품이 없습니다.     ");
       return;
   }
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
   if(chk_cnt == "0"){
       alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
       return;
   }else{
       if(eval(tot_cnt) < 2){
           var box = eval("document.forms.contentForm.lnCheck0" ); 
           if(box.checked == true){
                var st_buyer = document.forms.contentForm.st_buyer.value;
				var st_quotation_no = document.forms.contentForm.st_quotation_no.value;
				var st_quotation_seq     = document.forms.contentForm.st_quotation_seq.value;
				var item_qty                = document.forms.contentForm.st_item_qty.value;              // 수량
				var specification           = document.forms.contentForm.st_specification.value;         // 규격
				var btoa_end_date           = document.forms.contentForm.st_btoa_end_date.value;         // 회신요처일
				var buyer_item_no        = document.forms.contentForm.st_buyer_item_no.value;
				var unit_measure         = document.forms.contentForm.st_unit_measure.value;          // 단위
				var item_gubun_flag         = document.forms.contentForm.st_item_gubun_flag.value;       // 품목구분
				var year_qty_text           = kepFilterNum(kepTrimStr(document.forms.contentForm.st_year_qty_text.value));              // 년예상소요량
				var btoa_remark          = document.forms.contentForm.st_btoa_remark.value;           // 비고
				var category_id          = document.forms.contentForm.st_category_id.value;
				var st_user_id          = document.forms.contentForm.st_user_id.value;
				var category_id_msg      = category_id.substr(0,6);
				var green_flag    = "N";
	            
	            if(parseInt(btoa_end_date) < parseInt(nowDate)) {
	                alert("회신요청일은 현재일 이후여야 합니다.");
	                return;
	            }
	            if(category_id_msg == "R-G-03"){
	            	if(getCode144 != true){
	            	    alert("법정 안전보호구 카테고리는 산업안전보호법의 규정에 따르기 위해 아래 담당자만 가능 합니다.  \n\n  원자력 BG : 조진용 사원(7449)  \n\n  주단 BG : 정영재 대리(7260)  \n\n  터빈/발전 BG : 황규원 사원(7294)  \n\n  보일러 BG : 전상우 대리(7293)  \n\n  전사/관리부분 : 이태용 대리(7915), 허녕 대리(7921)   ");
	            	    return; 
	            	}
	        	}else if (category_id_msg == "R-A-04"){
            	    alert("작업공구류 견적시 TTMS에서 08코드 먼저 생성 후 해당코드로 견적의뢰 하시기 바랍니다.");
            	    return;
	        	}
	            if(item_gubun_flag == "T"){
            	  if(kepIsValueNull(year_qty_text)){
            	  	 alert(" 단가계약요청품목의 경우 년간예상소요량을 입력하셔야 합니다.  ");
            	     return;
            	  }
	            }else{
			       year_qty_text = 0;
			    }
	            if(kepIsValueNull(item_gubun_flag)){
	            	alert(" 품목구분정보를 선택해 주시기 바랍니다.   ");
	            	return;
	            }
	            if(kepIsValueNull(unit_measure)){
	            	alert(" 단위를 선택해 주십시오.   ");
	            	return;
	            }
	            if(!kepIsNumChkStr(item_qty, 3)) {
	                alert("수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.  ");
	                document.contentForm.st_item_qty.value ="";
	                return;
	            }
				// 규격 체크
	            if(kepIsValueNull(kepTrimStr(specification))) {
	                alert("규격을 입력하여 주십시오.");
	                return;
	            }
	            // 회신요청일 체크
	            if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	                alert("회신요청일을 입력하여 주십시오..");
	                return;
	            }
	            document.forms.contentForm.st_specification.value = FilterString(specification);
	            document.forms.contentForm.st_btoa_remark.value   = FilterString(btoa_remark);

				
				query = st_buyer + "@@" + st_quotation_no + "@@" + st_quotation_seq + "@@"+ st_user_id+"@@"+item_qty+"@@"+ specification+"@@"+btoa_end_date+"@@"+buyer_item_no+"@@"
							+unit_measure+"@@"+item_gubun_flag+"@@"+year_qty_text+"@@"+btoa_remark+ "@@"+green_flag+"@@"+st_user_id+"&&";
           }
       }else{
           for(var i = 0; i <tot_cnt; i++){
               var box = eval("document.forms.contentForm.lnCheck" + i);

	                if(box.checked == true){
	                	var st_buyer = document.forms.contentForm.st_buyer[i].value;
	    				var st_quotation_no = document.forms.contentForm.st_quotation_no[i].value;
	    				var st_quotation_seq     = document.forms.contentForm.st_quotation_seq[i].value;
	    				var item_qty                = document.forms.contentForm.st_item_qty[i].value;              // 수량
	    				var specification           = document.forms.contentForm.st_specification[i].value;         // 규격
	    				var btoa_end_date           = document.forms.contentForm.st_btoa_end_date[i].value;         // 회신요처일
	    				var buyer_item_no        = document.forms.contentForm.st_buyer_item_no[i].value;
	    				var unit_measure         = document.forms.contentForm.st_unit_measure[i].value;          // 단위
	    				var item_gubun_flag         = document.forms.contentForm.st_item_gubun_flag[i].value;       // 품목구분
	    				var year_qty_text           = kepFilterNum(kepTrimStr(document.forms.contentForm.st_year_qty_text[i].value));              // 년예상소요량
	    				var btoa_remark          = document.forms.contentForm.st_btoa_remark[i].value;           // 비고
	    				var category_id          = document.forms.contentForm.st_category_id[i].value;
	    				var st_user_id          = document.forms.contentForm.st_user_id[i].value;
	    				var category_id_msg      = category_id.substr(0,6);
	    				var green_flag    = "N";
	    	            
	    	            if(parseInt(btoa_end_date) < parseInt(nowDate)) {
	    	                alert("회신요청일은 현재일 이후여야 합니다.");
	    	                return;
	    	            }
	    	            if(category_id_msg == "R-G-03"){
	    	            	if(getCode144 != true){
	    	            	    alert("법정 안전보호구 카테고리는 산업안전보호법의 규정에 따르기 위해 아래 담당자만 가능 합니다.  \n\n  원자력 BG : 조진용 사원(7449)  \n\n  주단 BG : 정영재 대리(7260)  \n\n  터빈/발전 BG : 황규원 사원(7294)  \n\n  보일러 BG : 전상우 대리(7293)  \n\n  전사/관리부분 : 이태용 대리(7915), 허녕 대리(7921)   ");
	    	            	    return; 
	    	            	}
	    	        	}else if (category_id_msg == "R-A-04"){
	                	    alert("작업공구류 견적시 TTMS에서 08코드 먼저 생성 후 해당코드로 견적의뢰 하시기 바랍니다.");
	                	    return;
	    	        	}
	    	            if(item_gubun_flag == "T"){
	                	  if(kepIsValueNull(year_qty_text)){
	                	  	 alert(" 단가계약요청품목의 경우 년간예상소요량을 입력하셔야 합니다.  ");
	                	     return;
	                	  }
	    	            }else{
	    			       year_qty_text = 0;
	    			    }
	    	            if(kepIsValueNull(item_gubun_flag)){
	    	            	alert(" 품목구분정보를 선택해 주시기 바랍니다.   ");
	    	            	return;
	    	            }
	    	            if(kepIsValueNull(unit_measure)){
	    	            	alert(" 단위를 선택해 주십시오.   ");
	    	            	return;
	    	            }
	    	            if(!kepIsNumChkStr(item_qty, 3)) {
	    	                alert("수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.  ");
	    	                document.contentForm.st_item_qty.value ="";
	    	                return;
	    	            }
	    				// 규격 체크
	    	            if(kepIsValueNull(kepTrimStr(specification))) {
	    	                alert("규격을 입력하여 주십시오.");
	    	                return;
	    	            }
	    	            // 회신요청일 체크
	    	            if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	    	                alert("회신요청일을 입력하여 주십시오..");
	    	                return;
	    	            }
	    	            document.forms.contentForm.st_specification.value = FilterString(specification);
	    	            document.forms.contentForm.st_btoa_remark.value   = FilterString(btoa_remark);

	    				
	    				query += st_buyer + "@@" + st_quotation_no + "@@" + st_quotation_seq + "@@"+ st_user_id+"@@"+item_qty+"@@"+ specification+"@@"+btoa_end_date+"@@"+buyer_item_no+"@@"
	    				+unit_measure+"@@"+item_gubun_flag+"@@"+year_qty_text+"@@"+btoa_remark+ "@@"+green_flag+"@@"+st_user_id+"&&";
	                }
              }
       }
       document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mprq/saveBuyerMpRqTempQuotationReqPCO.do","processForm",btnEvent);
   }
   
}
function deleteRqdt(){
	var tot_cnt  = $("#display_item_cnt").val();
	 var chk_cnt = 0;
	 var query = "";
	 
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
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
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
                var st_buyer = document.forms.contentForm.st_buyer.value;
				var st_quotation_no = document.forms.contentForm.st_quotation_no.value;
				var st_quotation_seq     = document.forms.contentForm.st_quotation_seq.value;
				var st_revision  = document.forms.contentForm.st_revision.value;
				query = st_buyer + "@@" + st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision+ "&&";
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);

	                if(box.checked == true){
	                    var st_buyer = document.forms.contentForm.st_buyer[i].value;
	    				var st_quotation_no = document.forms.contentForm.st_quotation_no[i].value;
	    				var st_quotation_seq     = document.forms.contentForm.st_quotation_seq[i].value;
	    				var st_revision  = document.forms.contentForm.st_revision[i].value;
	    				query += st_buyer + "@@" + st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision+ "&&";
	                }
               }
        }
        document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mprq/deleteBuyerMpRqTempQuotationPCO.do","processForm",btnEvent);
    }
}
function setPopupCalendar(year,month,day){
	
    var tot_cnt             =  $("#display_item_cnt").val(); 
    var btoa_end_date   = year.toString()+month.toString()+day.toString();
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    if(parseInt(btoa_end_date) < parseInt(nowDate)) {
        alert("회신요청일은 현재일 이후여야 합니다.");
        return;
    }
    if(eval(tot_cnt)<=1)  {
        document.forms.contentForm.st_btoa_end_date_text.value =year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date.value = btoa_end_date;
    }
    else {
        document.forms.contentForm.st_btoa_end_date_text[g_Row].value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date[g_Row].value = btoa_end_date;
    }
}
var st;
//기능함수
function doAction(str , gubun) {	
	btnEvent =str;
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화

		jspTableClean("table_list");
		break; 
		
	case "reg": //등록
		saveReq();
		break;
	
	case "deleteRqdt": // 삭제
		deleteRqdt();
		break;  		
  
	}
}


// 조회
function kepSearch(curPage){
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqTempQuotationPCO.do").submit();   
} 


/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var msg = response.msg.MSG;   
		if (msg != ""){
			alert(msg);
		}
    	 // 처리후 재조회
    	 kepSearch($("#curPage").val());
	}else if(pMethod == "deleteRqdt"){
		var msg = response.msg.MSG;   
		if (msg != ""){
			alert(msg);
		}
    	 // 처리후 재조회
    	 kepSearch($("#curPage").val());
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "deleteRqdt"){ 
		 alert("삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "reg"){ 
		 alert("견적의뢰 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}  
	 
	
} 
 

</script>
</html>
