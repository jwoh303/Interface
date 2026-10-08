<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 > 주문관리 > 반납품목 조회 및 등록
* 기능 : 반납기간 설정
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2015-11-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Calendar"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%> 
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>


<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _data = (List<Map<String,String>>) request.getAttribute("_data");

String st_rtn_year		= CommonUtil.nvl((String)request.getAttribute("st_rtn_year"), "");
String st_rtn_month		= CommonUtil.nvl((String)request.getAttribute("st_rtn_month"), "");
String st_rtn_from_date	= "";
String st_rtn_to_date	= "";
String st_po_from_date	= "";
String st_po_to_date	= "";

if ( _data.size() > 0) {
	st_rtn_year			= _data.get(0).get("CODE").substring(0, 4);
	st_rtn_month		= _data.get(0).get("CODE").substring(4, 6);
	st_rtn_from_date	= _data.get(0).get("TEXT1");
	st_rtn_to_date		= _data.get(0).get("TEXT2");
	st_po_from_date		= _data.get(0).get("TEXT3");
	st_po_to_date		= _data.get(0).get("TEXT4");
}

Calendar _calendar = Calendar.getInstance();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat( "yyyyMM", Locale.KOREA );
String _toDay = _formatter.format ( _currentDate ); // 현재일자
_calendar.setTime( _currentDate );

String yyyy  = _toDay.substring(0, 4);
%>
<script type="text/javascript">
<!--
var popupSel = "";

//최초 화면 함수 
function kep_onload_view() {
	kepSetCalender("st_rtn_from_date");
	kepSetCalender("st_rtn_to_date");
	kepSetCalender("st_po_from_date");
	kepSetCalender("st_po_to_date");
}
function kepSearch()
{ 

	document.forms.searchForm.target = "_self"; 
	$('#searchForm').attr("action", "/mpso/getBuyerCowayReturnPeriodPop.do").submit();
/*	
	document.forms[0].target = "_self";
	document.forms[0].method = "podt";
	document.forms[0].action = "/mpso/getBuyerCowayReturnPeriodPop.do";
	document.forms[0].submit();
*/	
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 저장	
			kepAjaxFormCall("/mpso/setBuyerCowayReturnPeriodPop.do","searchForm", str);
			break;
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
		case "zipcode": //우편번호 검색
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "zipcode": //우편번호 검색
			$("#st_zip_code").val(code);
			$("#st_address").val(text);
			break;
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("반납기간이 저장되었습니다.");
            opener.setPopupReturn();
        	this.close();
		} else if (msg == "ERR") {
			alert("수정중 오류가 발생했습니다.\n관리자에게 문의하시기 바랍니다.");
            return;
		} else {
			alert(msg);
			return;
		}
	}
}

function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	$("#st_zip_code").val(str_zipcode);
	$("#st_zip_key").val(str_zip_key);
	$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	$("#st_address_dt").val(str_buildingName);
}

 //-->
</script> 
<body onload="kep_onload_view()">
<form name="searchForm" id="searchForm" method="post" >	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">반납기간설정</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div >
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>LOG IN 정보</caption>
	                <colgroup>
	                    <col width="30px" />
	                    <col width="70%" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row" >반납월</th>
	                      	<td>
								<select id="st_rtn_year" name="st_rtn_year" onchange="javascript:kepSearch();">
<% 
	int nYear	= Integer.parseInt(yyyy);
	for ( ; nYear >= 2015 ; nYear -- ) {
%>
									<option value="<%=nYear%>" <% if(Integer.parseInt(st_rtn_year) == nYear) out.println("selected"); %>><%=nYear%></option>
<%	}	%>
								</select>
								년
								<select id="st_rtn_month" name="st_rtn_month" onchange="javascript:kepSearch();">
									<option value="01" <% if("01".equals(st_rtn_month)) out.println("selected"); %>>01</option>
									<option value="02" <% if("02".equals(st_rtn_month)) out.println("selected"); %>>02</option>
									<option value="03" <% if("03".equals(st_rtn_month)) out.println("selected"); %>>03</option>
									<option value="04" <% if("04".equals(st_rtn_month)) out.println("selected"); %>>04</option>
									<option value="05" <% if("05".equals(st_rtn_month)) out.println("selected"); %>>05</option>
									<option value="06" <% if("06".equals(st_rtn_month)) out.println("selected"); %>>06</option>
									<option value="07" <% if("07".equals(st_rtn_month)) out.println("selected"); %>>07</option>
									<option value="08" <% if("08".equals(st_rtn_month)) out.println("selected"); %>>08</option>
									<option value="09" <% if("09".equals(st_rtn_month)) out.println("selected"); %>>09</option>
									<option value="10" <% if("10".equals(st_rtn_month)) out.println("selected"); %>>10</option>
									<option value="11" <% if("11".equals(st_rtn_month)) out.println("selected"); %>>11</option>
									<option value="12" <% if("12".equals(st_rtn_month)) out.println("selected"); %>>12</option>
								</select>
								월
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" >반납등록 기간</th>
	                      	<td>
								<input type="text" size="11" id="st_rtn_from_date" name="st_rtn_from_date" value="<%= st_rtn_from_date%>" readonly="readonly" />
								 ~ 
								<input type="text" size="11" id="st_rtn_to_date" name="st_rtn_to_date" value="<%= st_rtn_to_date%>" readonly="readonly" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" >반납대상 발주일</th>
	                      	<td>
								<input type="text" size="11" id="st_po_from_date" name="st_po_from_date" value="<%= st_po_from_date%>" readonly="readonly" />
								 ~ 
								<input type="text" size="11" id="st_po_to_date" name="st_po_to_date" value="<%= st_po_to_date%>" readonly="readonly" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				</div>
				<!--버튼영역-->
				<div class="btnArea" style="padding-top: 15px;">
					<span class="fr">
						<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
					</span>	
				</p>
				</div>
			</div>
		</div>
	</div>     
 </form>
</body>
</html>
