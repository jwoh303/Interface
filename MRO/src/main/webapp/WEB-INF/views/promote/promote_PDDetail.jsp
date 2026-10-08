<%--
**********************************************
* 메뉴 : 판촉물전용마켓 > 상품상세
* 화면 : 판촉물전용마켓 상품상세
* 기능 : 
* 프로그램 ID : 
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<title>코리아 e 플랫폼</title>
<script type="text/javascript">
function toggleBtn(){
	if ( $("#orderRequest").css("display") == "none" ){
		$("#orderRequest").show();
	}else{
		$("#orderRequest").hide();
	}
} 

function goPromoteAgentCatalogList() {
	history.back();
}

//판촉물 견적서 저장
function setApproval() {

    if(isEmpty(document.f1.st_add_company.value)) {
        alert("의뢰회사명을 입력하여 주십시요.");
        document.f1.st_add_company.focus();
        return;
    }

    if(isEmpty(document.f1.st_add_user_name.value)) {
        alert("견적의뢰자명을 입력하여 주십시요.");
        document.f1.st_add_user_name.focus();
        return;
    }

    if(isEmpty(document.f1.st_add_tel_no.value)) {
        alert("연락처를 입력하여 주십시요.");
        document.f1.st_add_tel_no.focus();
        return;
    }

    if(isEmpty(document.f1.st_add_email.value)) {
        alert("이메일을 입력하여 주십시요.");
        document.f1.st_add_email.focus();
        return;
    }

    if(isEmpty(document.f1.st_item_qty_text.value)) {
        alert("견적의뢰 수량 입력하여 주십시요.");
        document.f1.st_item_qty_text.focus();
        return;
    }

    if(confirm("해당판촉물에 대한 견적의뢰 하시겠습니까?")) {

        kepAjaxFormCall("/promote/saveItemApproval.do","f1","ITEMAPPROVAL");

    }
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.rtnMsg;
	
	if (msg != ""){
		alert(msg);
	}
	
	resetOrder();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("판촉물 견적의뢰를 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
	resetOrder();
} 

//데이타(숫자) 체크
function displayNumbering() {

    var item_qty = filterNum(TrimCommon(document.f1.st_item_qty_text.value));    // 제안수량
    var item_qty_text = "";

    if(!IsNumber1(item_qty)) {
        alert("제안수량을 숫자(0~9) 형태로 입력하여 주십시요.");
        document.f1.st_item_qty_text.value = "";
        document.f1.st_item_qty.value = "";
        return;
    }

    if(item_qty!="") {

        item_qty_text = kepCommaNum(TrimCommon(item_qty));

        document.f1.st_item_qty.value         = item_qty;
        document.f1.st_item_qty_text.value    = item_qty_text;

    }
}

function resetOrder(){ 
	$("#st_add_company").val("");
	$("#st_add_user_name").val("");
	$("#st_add_tel_no").val("");
	$("#st_add_email").val("");
	$("#st_item_qty").val("");
	$("#st_item_qty_text").val("");
	$("#st_add_remark").val("");
	toggleBtn();
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("searchItem"); // 상품목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> categPath = (List<Map<String,String>>) request.getAttribute("categPath"); // 카테고리PATH

String this_categ_list = "";
String other_categ_list = "";

String std_categ_id = CommonUtil.nvl((String) request.getParameter("st_std_categ_id"),"");
String std_pid = CommonUtil.nvl((String) request.getParameter("st_pid"),"");

if (categPath != null && categPath.size() > 0){
	for(int ca_i=0; ca_i<categPath.size(); ca_i++) {
		Map<String,String> rowCateg = categPath.get(ca_i);
		
		if(ca_i==0) {
			this_categ_list= rowCateg.get("CATEG_NAME")+" > ";
			continue;
		}
		
		if(std_categ_id.equals(rowCateg.get("STD_CATEG_ID"))) {
			this_categ_list+=rowCateg.get("CATEG_NAME");
		}
		
		other_categ_list+= "<a href=\"javascript:setKeyCategory('"+std_pid+"', '"+rowCateg.get("STD_CATEG_ID")+"')\" >"+rowCateg.get("CATEG_NAME")+"</a>";
		
		if((ca_i+1)!=categPath.size()){
			other_categ_list+= " | ";
		}
		
	}
}

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}

%>
<body>
<div id="wrapper">
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:import charEncoding="utf-8" url="/promote/promoteHeader.do" />
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<div id="container">
		<div class="Category">
            <h4><%=this_categ_list %></h4>
            <%=other_categ_list %> 
        </div>

<% if (rowData != null) {  %>        
        <div class="h30"></div>
        <h2>상품상세보기</h2>
        <div class="GiftDetails">
            <div class="DetailsImg" ><img src="<%=rowData.get("IMG_NAME")%>" alt="상품" /></div>
            <div class="DetailsTxt">
            	<table width="450">
                <colgroup>
                    <col width="150px" />
                    <col width="300px" />
                </colgroup>
                <tbody>
                	<tr>
                        <th>상품코드</th>
                        <td><span class="FontBlue"><b><%=rowData.get("ITEM_NO")%></b></span></td>
                    </tr>
                    <tr>
                        <th>현재상품상태</th>
                        <td><%=rowData.get("ITEM_STATUS")%></td>
                    </tr>
                    <tr>
                        <th>상품명</th>
                        <td><%=rowData.get("DESCRIPTION")%></td>
                    </tr>
                    <tr>
                        <th>상품규격</th>
                        <td><%=rowData.get("SPECIFICATION")%></td>
                    </tr>
                    <tr>
                        <th>제조사</th>
                        <td><%=rowData.get("MAKER_NAME")%></td>
                    </tr>
                    <tr>
                        <th>모델명</th>
                        <td><%=rowData.get("MAKER_PART_NO")%></td>
                    </tr>
                    <tr>
                        <th>배송기간</th>
                        <td> 최소(<%=rowData.get("MIN_DELIVERY_LT")%>)일~최대(<%=rowData.get("MAX_DELIVERY_LT")%>)일</td>
                    </tr>
                    <tr>
                        <th>단가</th>
                        <td><span class="FontRed"><%=CommonUtil.formatNumber(rowData.get("USER_PRICE"),true,0,3)%> (VAT 포함)</span></td>
                    </tr>
                </tbody>
                </table>
            </div>
        </div>
        <div class="h50"></div>
        <h2>구매문의</h2>
        <div class="ContactUs">
           - 박용진 과장 (TEL : 02-3016-7244 / E-MAIL : <a href="mailto:pyjhsm@koreab2b.com">pyjhsm@koreab2b.com</a>)<br>
           - 유선걸 대리 (TEL : 02-3016-7248 / E-MAIL : <a href="mailto:jsjeon@koreab2b.com">jsjeon@koreab2b.com</a>)<br><br>
           - "본 제품은 기업(법인) 대상 구매만 가능하며, 개인 거래 불가능 한 점 양해 바랍니다."
         	<div class="btnArea">
            	<!-- a href="javascript:toggleBtn();"><spans class="btnBlue">견적의뢰</span></a>&nbsp;   -->
            	<a href="javascript:goPromoteAgentCatalogList();"><spans class="btnBlue">목록으로</span></a> </div>
        </div>
        <div class="h50"></div>
<% if(!rowData.get("REMARK").equals("")){ %>  
        <h2>상품상세</h2>
        <div class="GiftDetailsTxt">
        <%=rowData.get("REMARK")%>
        </div>
<%} %>
<% if(!rowData.get("DETAIL_IMG_NAME").equals("/item_image//")){ %>
        <div style="clear:both; width:980px; margin-bottom:20px">
                <div ><img src="<%=rowData.get("DETAIL_IMG_NAME")%>" onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name = "image2" ></div>
          </div>
   <%} %>
        <!-- 숨김메뉴 -->
        <form id="f1"  name="f1" method="post">
        <input type="hidden" id="st_item_no" name="st_item_no" value="<%=rowData.get("ITEM_NO")%>" />
        <input type="hidden" id="st_item_qty" name="st_item_qty" />
        <div id="orderRequest" style="display:none">
	        <div class="h50"></div> 
	        <h2>견적의뢰</h2>
	        <div class="ContactUsBox">
	           <table width="850">
	                <colgroup>
	                    <col width="130px" />
	                    <col width="300px" />
	                    <col width="130px" />
	                    <col width="300px" />
	                </colgroup>
	                <tbody>
	                	<tr>
	                        <th>의뢰회사명</th>
	                        <td><input type="text" id="st_add_company"  name="st_add_company" ></td>
	                        <th>의뢰자</th>
	                        <td><input type="text" id="st_add_user_name" name="st_add_user_name" ></td>
	                    </tr>
	                    <tr>
	                        <th>연락처</th>
	                        <td><input type="text" id="st_add_tel_no" name="st_add_tel_no" ></td>
	                        <th>E-Mail</th>
	                        <td><input type="text" id="st_add_email" name="st_add_email" ></td>
	                    </tr>
	                    <tr>
	                        <th>상품코드</th>
	                        <td><span class="FontBlue"><b><%=rowData.get("ITEM_NO")%></b></span></td>
	                        <th>의뢰수량</th>
	                        <td><input type="text" id="st_item_qty_text" name="st_item_qty_text"  onblur="displayNumbering();"></td>
	                    </tr>
	                    <tr>
	                        <th>인쇄옵션 및</br> 추가사항</th>
	                        <td colspan="3"><textarea id="st_add_remark" name="st_add_remark" cols="90" rows="7"></textarea></td>
	                    </tr>
	                   
	                </tbody>
	            </table>
	            <div class="ContactUsBoxBtn"><a href="javascript:setApproval();"><span >견적의뢰</span></a></div>
	        </div>
        </div>
        </form>
<% }%>        

    </div>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/promote/include/promoteFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
</body>
</html>

