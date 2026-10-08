<%--
**********************************************
* 메뉴 : 장바구니 엑셀업로드
* 화면 : 장바구니 엑셀업로드
* 기능 : 장바구니 엑셀업로드
* 프로그램 ID : PG_02_B_000834_005
* 담당자 : 현명환
* 착수일 : 2015-06-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"200");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String sort_column           = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"ALL"); 
	String sort_flag           = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),"ASC"); 
	
	// 조회조건 E	
	
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	}  
	 String SessionUserId         = sessionInfo.getUserId();	 

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
	<h3>장바구니 엑셀업로드</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회" ><a href="javascript:doAction('search','');">조회</a></span> 
		<span class="btn_reset" title="초기화" ><a href="javascript:doAction('reload','');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">		
		<input type="hidden" name="st_sort_column"			value="<%=sort_column%>">
		<input type="hidden" name="st_sort_flag"			value="<%=sort_flag%>">

		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<input type="hidden" name="st_query" id="st_query" value="">
		<input type="hidden" name="st_query_cart" id="st_query_cart" value="">
		<input type="hidden" name="st_return_url" id="st_return_url" value="">		
	</form> 
 	<div id="searchBtnA02">
		<form method="post" action="/mpso/setExcelUp.do"  name="UploadForm" id="UploadForm" modelAttribute="uploadForm" enctype="multipart/form-data">
		<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<table  class="board_write"  summary="피일업로드" id="fileTable">
		<caption>엑셀업로드 올리기</caption>
		<colgroup>
			<col width="13%" />
			<col width="*" />
		</colgroup>
		<tbody> 
		  <tr>
				<td scope="row">
		 			<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" onchange="javascript:kepSearch(1);">
						<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
						<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
						<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
						<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option>
						<option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %>>200건</option>  
					</select>	
				</td>         
				<td scope="row">
				<input name="files" id="files" type="file"  class="input_type_text" onchange="setExcelUpValid()" />
				<a href="javascript:setExcelUp()"><img src="/resources/images/but_reg.gif" alt="등록" /></a>	
			</td>        
		</tr>   
		</table>    
		</form>
    </div>
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<table id="table_list" class="cont_t_list002" style="width:100%">
			<colgroup>
			  <col width="3%" />
			  <col width="10%" />
			  <col width="20%" />
			  <col width="*" />
			  <col width="15%" />
			  <col width="7%" />
	        </colgroup>
	        <thead>
			<tr>
               <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%> 
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onClick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
							<%} %>
				</th>
				<th scope="col"> 품목코드</th>
                <th scope="col" >품목명</th>
                <th scope="col">규격</th>
                <th scope="col">협력사</th>
                <th scope="col">수량</th>
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
					<td class="font1_black1"  class="center">
						<input type="checkbox"  class="input_noline" name="lnCheck<%=j%>">
					</td>                    
                    <td title="품목코드" class="left" >&nbsp;&nbsp;<%=rowData.get("BUYER_ITEM_NO")%></td>
                    <td title="품목명" class="left">&nbsp;<%=rowData.get("DESCRIPTION")%></td> 
                    <td title="규격" class="left">&nbsp;<%=rowData.get("SPECIFICATION")%></td>
                    <td title="협력사" class="left">&nbsp;<%=rowData.get("AGENT_NAME")%></td>
		          	<td class="right"  title="수량">
		          		<span class="Price"><%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%></span>		          		
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
				<span class="btn_04" title="등록양식" >
					<a href="javascript:doAction('excelDown','');">등록양식</a> 
				</span>	
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('remove','');">삭제</a> 
				</span>
				<span class="btn_04" title="장바구니" >
					<a href="javascript:doAction('order','');">장바구니</a> 
				</span>
            </div>
        </div> 
</form>
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/> 
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	 
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

// 최초 화면 함수 
function kep_onload_view(){
 
}
  

var st;

//기능함수
function doAction(str , gubun) {
		
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
		
	case "reload":	//초기화

		jspTableClean("table_list");
		break; 
		
	case "remove": // 장바구니 삭제
		delCartTmp();
		break;  
	
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  
	}
}
function delCartTmp(){
	   var chk_cnt = 0;
	    var cnt     = 0;
	    var query   = "";
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
	        if(!confirm("선택된 품목을 장바구니 업로드 항목에서 삭제하시겠습니까?")){
	            return;
	        }else{
		        if(eval(tot_cnt) < 2){
		            var box = eval("document.forms.contentForm.lnCheck0" ); 
		            if(box.checked == true){
		            	
		                var st_item_no = document.forms.contentForm.st_item_no.value;
						var st_contract_no     = document.forms.contentForm.st_contract_no.value;
						var st_contract_seq  = document.forms.contentForm.st_contract_seq.value;
		                
						query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty + "&&";
	
		            }
		        }else{
		            for(var i = 0; i <tot_cnt; i++){
		                var box = eval("document.forms.contentForm.lnCheck" + i);
	
			                if(box.checked == true){
			                    var st_item_no = document.forms.contentForm.st_item_no[i].value;
			    				var st_agent_code = document.forms.contentForm.st_agent_code[i].value;
			    				var st_contract_no     = document.forms.contentForm.st_contract_no[i].value;
			    				var st_contract_seq  = document.forms.contentForm.st_contract_seq[i].value;
			    				var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
			    				var st_description = document.forms.contentForm.st_description[i].value;
			    				var st_specification = document.forms.contentForm.st_specification[i].value;
			    				var st_unit_price = document.forms.contentForm.st_unit_price[i].value;
			    				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;  
			
			 
								 query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty;
								 query += "&&";
			                }
		               }
		          }
		    }
	    }
	
}
function setExcelUpValid() {
	if (IsExt($("#files").val())) { //파일명 체크
	    alert("해당 형식의 파일은 업로드할 수 없습니다.");
		return;
	  }
}
function IsExt(str) {
    var urltext = str.toLowerCase(); //받아온 파일명을 소문자로 변경한다.

    if (/xls$/.test(urltext)){
       return false; //해당 파일명에 xls라는 단어가 있음.
    } else {
      return true; //해당 파일명에 xls라는 단어가 없음.
    }
 }
function setExcelUp() {  		 
	if (isEmpty($("#files").val())==true){
		alert("업로드 대상이 없습니다. 확인 부탁드립니다.");
		return;
	}  	
	 
	$('#UploadForm').attr("action", "/mdcm/setMdCmExcelUp.do").submit(); 
}	


// 조회
function kepSearch(curPage){	
	document.forms.searchForm.target = "_self"; 
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmExcelCartPunchOutList.do").submit();   
}


/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	var sMsg = response.msg.MSG;  
	var confirm4 = $("#confirm4").val();
	
    if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "RsaveProcess")
        {
        	alert("나의상품으로 등록 되었습니다.   ");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());           	   
           }else{     
        	   
        	   $('#locationForm').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();    
        	 
           }
        	
       }else if(pMethod=="updatePrice"){
       
       }else {       
          alert("장바구니 정상적으로 삭제되었습니다.  ");
      	 // 처리후 재조회
      	 kepSearch($("#curPage").val());
       } 
        
      }else{
    	  
         if(pMethod == "RsaveProcess")
          {
            alert("품목코드 (" + sMsg + ") 은 이미 나의 상품에 저장된 항목입니다.  ");
          } 
         
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
         
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "RsaveProcess"){ 
		 alert("나의상품 담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "DsaveProcess"){ 
		 alert("장바구니 삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}  
	 
	
} 
 
</script>
</html>
