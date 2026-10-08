<%--
**********************************************
* 메뉴 : 판촉물전용마켓 MAIN > 상세검색 팝업
* 화면 : 상세검색 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/promote.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<script type="text/javascript">
function doAction(type) {
	setSearchQuery();	
}

//상세검색
function setSearchQuery() {

	var item_no			= document.f1.st_detail_item_no.value;
	var maker_name		= document.f1.st_detail_maker_name.value;
	var description		= document.f1.st_detail_description.value;
	var specification	= document.f1.st_detail_specification.value;
	var min_user_price	= document.f1.st_detail_min_user_price.value;
	var max_user_price	= document.f1.st_detail_max_user_price.value;

	if(isEmpty(item_no)&&isEmpty(maker_name)&&isEmpty(description)&&isEmpty(specification)&&isEmpty(min_user_price)&&isEmpty(max_user_price)) {
		alert("상품코드, 제조사, 상품명, 상품규격, 가격대 중 최소한 하나의 검색어을 입력하여 주십시요.");
		return;
	}
	
	if(!isEmpty(max_user_price) && isEmpty(min_user_price)) {
		alert("가격대를 입력하여 주십시요.");
		document.forms[0].st_detail_min_user_price.focus();
		return;
	}
	
	opener.setPopupReturn(item_no, maker_name, description, specification, min_user_price, max_user_price);
	self.close();
}

//단가 및 배송기간 숫자 체크
function displayNumbering(type) {

    var min_user_price = filterNum(kepTrimStr(document.f1.st_detail_min_user_price_text.value));
    var max_user_price = filterNum(kepTrimStr(document.f1.st_detail_max_user_price_text.value));

    if(type=="MIN_USER_PRICE") {

        if(!kepIsNumberStr(min_user_price)) {
            document.f1.st_detail_min_user_price_text.value = "";
            document.f1.st_detail_min_user_price.value = "";
            return;
        }
		
		document.f1.st_detail_min_user_price.value         = min_user_price;
		document.f1.st_detail_min_user_price_text.value    = kepCommaNum(kepTrimStr(min_user_price));
    }

    if(type=="MAX_USER_PRICE") {
	
		if(!kepIsNumberStr(max_user_price)) {
            document.f1.st_detail_max_user_price_text.value = "";
            document.f1.st_detail_max_user_price.value = "";
            return;
        }
		
		document.f1.st_detail_max_user_price.value         = max_user_price;
		document.f1.st_detail_max_user_price_text.value    = kepCommaNum(kepTrimStr(max_user_price));
    }
}
</script>
</head>
<!-- 팝업창 : 480px _ 280px-->
<body>
<form id="f1" name="f1" onsubmit="return false;">
<div id="Popup">
	<div class="PopupTitle">제품 상세검색</div>
    <div class="PopupCenter">
       <table style="width:440px;">
            <colgroup>
                <col width="90px" />
                <col width="180px" />
                <col width="90px" />
                <col width="180px" />
            </colgroup>
            <tbody>
                <tr>
                    <th>상품코드</th>
                    <td ><input id="st_detail_item_no" name="st_detail_item_no" type="text" style="width:95%" maxlength="" onkeydown="javascript:kepEnter();"></td>
                    <th> 제조사 </th>
                    <td ><input id="st_detail_maker_name" name="st_detail_maker_name" type="text" style="width:95%" maxlength=""  onkeydown="javascript:kepEnter();"></td>
                </tr>
                <tr>
                    <th>상품명</th>
                    <td colspan="3"><input id="st_detail_description" name="st_detail_description" type="text" style="width:98%" maxlength=""  onkeydown="javascript:kepEnter();"></td>
                </tr>
                <tr>
                    <th>상품규격</th>
                    <td colspan="3"><input id="st_detail_specification" name="st_detail_specification" type="text" style="width:98%" maxlength=""  onkeydown="javascript:kepEnter();"></td>
                </tr>
                <tr>
                    <th>가격대</th>
                    <td colspan="3"><input id="st_detail_min_user_price_text" name="st_detail_min_user_price_text" type="text"  maxlength="" style="width:41%" onblur="displayNumbering('MIN_USER_PRICE');"> 원 ~
                      <input id="st_detail_max_user_price_text" name="st_detail_max_user_price_text" type="text" maxlength="" style="width:41%" onblur="displayNumbering('MAX_USER_PRICE');" > 원
                      <input id="st_detail_min_user_price" name="st_detail_min_user_price" type="hidden" maxlength="" size="14">
                      <input id="st_detail_max_user_price" name="st_detail_max_user_price" type="hidden" maxlength="" size="14"></td>
                </tr>
            </tbody>
        </table>    
    </div>
    <div class="Popupbtn" style=" width:460px"><a href="javascript:setSearchQuery();"><span class="btnBlack">검색</span></a>&nbsp;  <a href="javascript:self.close();"><span class="btnBlack">닫기</span></a> </div>
    
    
</div>
</form>
</body>
</html>

