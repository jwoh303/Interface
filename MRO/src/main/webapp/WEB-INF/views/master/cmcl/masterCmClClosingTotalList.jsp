<%--
**********************************************
* 메뉴 : 마감현황>회계수불>마감집계표
* 화면 : 마감집계표
* 기능 : 
* 프로그램 ID : PG_10_M_013_00
* 담당자 : 최명진[추후 담당자 제조운영1팀 예정자 홍석규] ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String _stFromDate = CommonUtil.nvl(request.getParameter("st_from_date"));
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var st_from_date = "<%=_stFromDate%>";
	
	// 조회조건 일자 초기화
	kepSetCalenderYearMonth("st_from_date");
	
	// 조회조건 일자 설정
	if ( st_from_date == '' ) {
		$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/') );
	} else {
		$("#st_from_date").val( st_from_date );
	}
}
	
var st;
var mt;

// 기능함수
function doAction(str, index, dept) {
	st = new Date();
	
	if ( str == "save" ) {
		document.forms.contentCondition.sel_yyyymm.value 		= document.forms.contentCondition.st_yyyymm[index].value;
		document.forms.contentCondition.sel_dept_code.value 	= document.forms.contentCondition.st_dept_code[index].value;
		document.forms.contentCondition.sel_type.value 			= document.forms.contentCondition.st_type[index].value;
		document.forms.contentCondition.sel_j_amt.value 			= document.forms.contentCondition.st_j_amt[index].value;
		document.forms.contentCondition.sel_remark.value 		= document.forms.contentCondition.st_remark[index].value;
	}

	switch (str) {
		case "search": // 조회
			$('#searchCondition').attr("action", "/cmcl/getMasterCmClClosingTotalList.do").submit();
// 			document.forms.searchCondition.method = "post";
// 			document.forms.searchCondition.action = "/cmcl/getMasterCmClClosingTotalList.do";
// 			document.forms.searchCondition.submit();
			break;
	
		case "save": // 저장
			if (!confirm('조정원가를 수정하시겠습니까?'))
				return;
			kepAjaxFormCall("/cmcl/saveMasterCmClClosingTotalList.do","contentCondition", str);
			break;
	
		case "excelDown": // 엑셀다운로드
			document.forms.searchCondition.action = "/cmcl/excelMasterCmClClosingTotalList.do";
			document.forms.searchCondition.submit();
			break;
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var MSG = response.msg;

	if ( pMethod == "save" ) {
		if ( MSG == "OK" ) {
			alert("정상적으로 처리 완료 되었습니다");
			doAction("search", "", "");
		}
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	if ( pMethod == "save" ){
		alert("처리하던중 오류가 발생하였습니다.\n\n담당자에게 연락 바랍니다.");
	}
}

// 공백 및 제로 리턴
function SZReturn(str, type) {
	var strp = "";
	var cnt = kepTrimStr(str).length;
	if ( cnt == 0 ) {
		if ( type == "num" ) {
			strp = "0";
		} else {
			strp = " ";
		}
	} else {
    	strp = str;
	}

	return strp;
}

// 입력값의 공백을 잘라준다.
function SPTrim(str) {
	var strp = "";
	var cnt = str.length;

	for ( var i = 0; i < cnt; i++ ) {
		if ( str.charAt(i) != " ") {
			strp+=str.charAt(i);
		}
	}

	return strp;
}

// 금액 변경 체크 및 설정
function displayPrice(mode, index) {

	var j_amt = SZReturn( kepTrimStr( kepFilterNum( SPTrim( document.forms.contentCondition.st_j_amt_text[index].value ) ) ), "num" );
	var w_amt = SZReturn (kepTrimStr( kepFilterNum( SPTrim( document.forms.contentCondition.st_w_amt_text[index].value ) ) ), "num" );
	var item_amt = SZReturn( kepTrimStr( kepFilterNum( SPTrim( document.forms.contentCondition.st_item_amt_text[index].value ) ) ), "num" );
	
	if ( mode == "J_AMT" ) {

		if ( j_amt != "" && kepIsNumberString(j_amt) == true && j_amt >= 0 ) {
			document.forms.contentCondition.st_j_amt[index].value		= kepTrimStr(j_amt);
			document.forms.contentCondition.st_j_amt_text[index].value	= kepCommaNum(kepTrimStr(j_amt));
		} else {
			alert("조정금액을 정확히 숫자형식으로 입력 바랍니다.");
			document.forms.contentCondition.st_j_amt_text[index].value = "";
			document.forms.contentCondition.st_j_amt_text[index].focus();
			document.forms.contentCondition.st_j_amt_text[index].select();
		}

	} else if ( mode == "W_AMT" ) {

		if ( w_amt != "" && kepIsNumberString(w_amt) == true && j_amt >= 0 ) {
			document.forms.contentCondition.st_w_amt[index].value		= kepTrimStr(w_amt);
			document.forms.contentCondition.st_w_amt_text[index].value	= kepCommaNum(LRTrim(w_amt));
		} else {
			alert("수불출고원가를 정확히 숫자형식으로 입력 바랍니다.");
			document.forms.contentCondition.st_w_amt_text[index].value = "";
			document.forms.contentCondition.st_j_amt_text[index].focus();
			document.forms.contentCondition.st_j_amt_text[index].select();
		}

	} else if ( mode == "ITEM_AMT" ) {

		if ( item_amt != "" && kepIsNumberString(item_amt) == true && j_amt >= 0 ) {
			document.forms.contentCondition.st_item_amt[index].value		= kepTrimStr(item_amt);
			document.forms.contentCondition.st_item_amt_text[index].value	= kepCommaNum(LRTrim(item_amt));
		} else {
			alert("매출금액을 정확히 숫자형식으로 입력 바랍니다.");
			document.forms.contentCondition.st_item_amt_text[index].value = "";
			document.forms.contentCondition.st_j_amt_text[index].focus();
			document.forms.contentCondition.st_j_amt_text[index].select();
		}
		 
	}
}
	
// 팝업함수호출
function doPop(str, index) {
	popupSel = str;
	grbIndex = index;
	document.forms.contentCondition.sel_remark.value = document.forms.contentCondition.st_remark[index].value;
	
	switch (str) {
		case "remark_input": // 비고 입력
// 			kepOpenPopup('masterCmClRemarkPop');
			openSearchPopup("/cmcl/showMasterCmClRemarkPop.do", "", "500,260,no");
			break;
	}
}
	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value) {
	
	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "remark_input" ) { // 비고 입력
		if ( kepTrimStr(value) != "" ) {
			document.forms.contentCondition.st_remark[grbIndex].value = kepTrimStr(value);
			document.forms.contentCondition.Image2[grbIndex].src = "/resources/images/but_img_on.gif";
		} else {
			document.forms.contentCondition.st_remark[grbIndex].value = kepTrimStr(value);
			document.forms.contentCondition.Image2[grbIndex].src = "/resources/images/but_img_off.gif";
		}
	}
	
	grbIndex = "";
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
    <div id="searchBtnA"  >
		<h3>마감집계표</h3>
	    <span class="btn_search"><a href="javascript:doAction('search','','')">조회</a></span> 
  	</div>
  	
    <!--조회영역-->
	<form id="searchCondition" name="searchCondition" method = "post">
	<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		<input type="hidden" id="st_dept_code_session" name="st_dept_code_session"  value="${sessionInfo.department}">
	
          	<table  class="cont_t_list01" >
			<caption>마감집계표</caption>
			<colgroup>
				<col width="8%" />
				<col width="92%" />
			</colgroup>
				
			<tbody>
				<tr>
					<th><font color="#FF6600">*</font>조회월</th>
					<td>
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
					</td>
				</tr>
			</tbody>
		</table>
   	</div>
   	</form>
	
	<!--grid header-->
	<table  class="cont_t_list02"  style="width:100%; margin-bottom:0px;">
        <caption>마감집계표</caption>
        <colgroup>
            <col width="12%" />
            <col width="5%" />
            <col width="15%" />
            <col width="14%" />
            <col width="15%" />
            <col width="14%" />
            <col width="15%" />
        </colgroup>
        <thead>
            <tr>
                <th rowspan="2" scope="col">팀명</th>
                <th rowspan="2" scope="col">구분</th>
                <th rowspan="2" scope="col">매출</th>
                <th colspan="2" scope="col">매출원가</th>
                <th rowspan="2" scope="col">매출원가(①+②)</th>
                <th rowspan="2" scope="col">③비고</th>
                <th rowspan="2" scope="col">수정</th>
        	</tr>
                <th scope="col">①수불출고원가</th>
                <th scope="col">②조정원가</th>
        	<tr>
        	</tr>
        </thead>
	</table>

	<!--grid body-->
	<form id="contentCondition" name="contentCondition" method="post" onsubmit="return false" >
	<!--HIDDEN-->
	<!-- 공통 -->
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<!-- 화면 내 정의 -->
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_dept_code_session" name="st_dept_code_session"  value="${sessionInfo.department}">
	<input type="hidden" id="sel_yyyymm" name="sel_yyyymm" value="">
	<input type="hidden" id="sel_dept_code" name="sel_dept_code" value="">
	<input type="hidden" id="sel_type" name="sel_type" value="">
	<input type="hidden" id="sel_j_amt" name="sel_j_amt" value="">
	<input type="hidden" id="sel_remark" name="sel_remark" value="">
	<div style="min-height:394; height:394px; padding-bottom:10px; margin-bottom:10px; overflow-y:auto;">
    <table  class="cont_t_list02" style="width:100%; border-top:0px solid #6a98b5">
        <caption>마감집계표</caption>
        <colgroup>
            <col width="12%" />
            <col width="8%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%" />
            <col width="15%" />
            <col width="20%" />
        </colgroup>
        <tbody>
<%
String tclass = "";

double origin_amt = 0;	// 매출원가

double tot_item_amt = 0;	// 총 매출 금액
double tot_w_amt = 0;	// 총 수불출고원가 금액
double tot_j_amt = 0;	// 총 조정원가 금액
double tot_origin_amt = 0;	// 총 매출원가

double tot_m_item_amt_sum = 0;
double tot_j_item_amt_sum = 0;
double tot_mj_item_amt_sum = 0;

double tot_m_w_amt_sum = 0;
double tot_j_w_amt_sum = 0;
double tot_mj_w_amt_sum = 0;

double tot_m_j_amt = 0;
double tot_j_j_amt = 0;
double tot_mj_j_amt = 0;

double tot_m_origin_amt = 0;
double tot_j_origin_amt = 0;
double tot_mj_origin_amt = 0;

int display_tot_cnt = 0;

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된 결과
// Vector v_data = getB2BBuyerSalesDeadLineSpecTable(from_date);

if ( _dataList != null && _dataList.size()>=1 ) {
	for ( int x=0; x<_dataList.size(); x++) {
		Map<String,String> _rowData = _dataList.get(x);
// 		Object[] rtobj = (Object[])v_data.elementAt(x);

		if ((x%2) == 1) tclass = "#FFFFFF";
		else tclass = "F0F0F0";

		origin_amt = Double.parseDouble(_rowData.get("W_AMT")) + Double.parseDouble(_rowData.get("J_AMT"));
		tot_item_amt += Double.parseDouble(_rowData.get("ITEM_AMT"));
		tot_w_amt += Double.parseDouble(_rowData.get("W_AMT"));
		tot_j_amt += Double.parseDouble(_rowData.get("J_AMT"));
		tot_origin_amt += Double.parseDouble(_rowData.get("W_AMT")) + Double.parseDouble(_rowData.get("J_AMT"));
		display_tot_cnt++;

		if ( _rowData.get("TYPE").equals("M") ) {
			
			tot_m_item_amt_sum += Double.parseDouble(_rowData.get("ITEM_AMT"));
			tot_m_w_amt_sum += Double.parseDouble(_rowData.get("W_AMT"));
			tot_m_j_amt += Double.parseDouble(_rowData.get("J_AMT"));

			tot_m_origin_amt += tot_origin_amt;

		} else if ( _rowData.get("TYPE").equals("J") ) {

			tot_j_item_amt_sum += Double.parseDouble(_rowData.get("ITEM_AMT"));
			tot_j_w_amt_sum += Double.parseDouble(_rowData.get("W_AMT"));
			tot_j_j_amt += Double.parseDouble(_rowData.get("J_AMT"));

			tot_j_origin_amt += tot_origin_amt;
		}

		tot_mj_item_amt_sum = tot_m_item_amt_sum + tot_j_item_amt_sum;
		tot_mj_w_amt_sum = tot_m_w_amt_sum + tot_j_w_amt_sum;
		tot_mj_j_amt = tot_m_j_amt + tot_j_j_amt;

		tot_mj_origin_amt = tot_m_origin_amt + tot_j_origin_amt;
%>
			<input type="hidden" name="st_yyyymm" value="<%=_rowData.get("YYYYMM")%>">
			<input type="hidden" name="st_dept_code" value="<%=_rowData.get("DEPT_CODE")%>">
			<input type="hidden" name="st_type" value="<%=_rowData.get("TYPE")%>">
            <tr>
<%
		if ( x%2 == 0 ) {
%>
                <td rowspan="3"><b><%=_rowData.get("DEPT_NAME")%></b></td>
<%
		}
%>
                <td><%=_rowData.get("TYPE_TEXT")%></td>
                <td>
<%
		if ( "005".equals( "${sessionInfo.department}" ) ) {
%>
					<input type="text" id="st_item_amt_text" name="st_item_amt_text" style="text-align:right; padding-right:5px; width:80%;" value="<%=CommonUtil.formatNumber(_rowData.get("ITEM_AMT"), true, 15, 3)%>" onBlur="displayPrice('ITEM_AMT', <%=x%>)";>
<%
		} else {
%>
					<input type="text" id="st_item_amt_text" name="st_item_amt_text" style="text-align:right; padding-right:5px; width:80%;" value="<%=CommonUtil.formatNumber(_rowData.get("ITEM_AMT"), true, 15, 3)%>" readonly>
<%
		}
%>
					<input type="hidden" id="st_item_amt" name="st_item_amt" value="<%=_rowData.get("ITEM_AMT")%>">
                </td>
                <td>
<%
		if ( "005".equals( "${sessionInfo.department}" ) ) {
%>
					<input type="text" id="st_w_amt_text" name="st_w_amt_text" style="text-align:right; padding-right:5px; width:80%;" value="<%=CommonUtil.formatNumber(_rowData.get("W_AMT"), true, 15, 3)%>" onBlur="displayPrice('W_AMT', <%=x%>)";>
<%
		} else {
%>
					<input type="text" id="st_w_amt_text" name="st_w_amt_text" style="text-align:right; padding-right:5px; width:80%;" value="<%=CommonUtil.formatNumber(_rowData.get("W_AMT"), true, 15, 3)%>" readonly>
<%
		}
%>
					<input type="hidden" id="st_w_amt" name="st_w_amt" value="<%=_rowData.get("W_AMT")%>">
                </td>
                <td>
					<input type="text" id="st_j_amt_text" name="st_j_amt_text" style="text-align:right; padding-right:5px; width:80%;" value="<%=CommonUtil.formatNumber(_rowData.get("J_AMT"), true, 15, 3)%>" onBlur="displayPrice('J_AMT', <%=x%>);">
					<input type="hidden" id="st_j_amt" name="st_j_amt" value="<%=_rowData.get("J_AMT")%>">
                </td>
                <td class="right pr05"><%=CommonUtil.formatNumber(origin_amt, true, 15, 3)%></td>
                <td>
                	<a href="javascript:doPop('remark_input',<%=x%>);">
<%
		if ( "".equals( _rowData.get("REMARK").trim() ) ) {
%>
						<img name="Image2" src="/resources/images/but_img_off.gif" border="0">
<%
		} else {
%>
						<img name="Image2" src="/resources/images/but_img_on.gif" border="0">
<%
		}
%>
					</a>
					<input type="hidden" id="st_remark" name="st_remark" value="<%=_rowData.get("REMARK")%>">
                </td>
                <td>
                	<span class="btn_02"><a href="javascript:doAction('save',<%=x%>, '<%=_rowData.get("DEPT_CODE")%>');">수정</a></span>
                </td>
            </tr>
<%
		if ( x%2 == 1 ) {
%>
			<tr>
				<td><b>소계</b></td>
				<td class="right pr15"><b><%=CommonUtil.formatNumber(tot_item_amt, true, 15, 3)%></b></td>
				<td class="right pr15"><b><%=CommonUtil.formatNumber(tot_w_amt, true, 15, 3)%></b></td>
				<td class="right pr15"><b><%=CommonUtil.formatNumber(tot_j_amt, true, 15, 3)%></b></td>
				<td class="right pr05"><b><%=CommonUtil.formatNumber(tot_origin_amt, true, 15, 3)%></b></td>
				<td colspan="2">&nbsp;</td>
			</tr>
<%
			tot_item_amt = 0;
			tot_w_amt = 0;
			tot_j_amt = 0;
			tot_origin_amt = 0;
		}
	}
}
%>
			<input type="hidden" name="display_tot_cnt" value="<%=display_tot_cnt%>">
			<tr>
	            <td rowspan="3"><b>합계</b></td>
	            <td>MRO</td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_m_item_amt_sum, true, 15, 3)%></td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_m_w_amt_sum, true, 15, 3)%></td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_m_j_amt, true, 15, 3)%></td>
	            <td class="right pr05"><%=CommonUtil.formatNumber(tot_m_w_amt_sum+tot_m_j_amt, true, 15, 3)%></td>
	            <td colspan="2">&nbsp;</td>
          	</tr>
	        <tr>
	            <td>재고</td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_j_item_amt_sum, true, 15, 3)%></td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_j_w_amt_sum, true, 15, 3)%></td>
	            <td class="right pr15"><%=CommonUtil.formatNumber(tot_j_j_amt, true, 15, 3)%></td>
	            <td class="right pr05"><%=CommonUtil.formatNumber(tot_j_w_amt_sum+tot_j_j_amt, true, 15, 3)%></td>
	            <td colspan="2">&nbsp;</td>
          	</tr>
          	<tr>
	            <td><b>소계</b></td>
	            <td class="right pr15"><b><%=CommonUtil.formatNumber(tot_mj_item_amt_sum, true, 15, 3)%></b></td>
	            <td class="right pr15"><b><%=CommonUtil.formatNumber(tot_mj_w_amt_sum, true, 15, 3)%></b></td>
	            <td class="right pr15"><b><%=CommonUtil.formatNumber(tot_mj_j_amt, true, 15, 3)%></b></td>
	            <td class="right pr05"><b><%=CommonUtil.formatNumber(tot_mj_w_amt_sum+tot_mj_j_amt, true, 15, 3)%></b></td>
	            <td colspan="2">&nbsp;</td>
        	</tr>
        </tbody>
    </table>
    </div>
    </form>
    
	<!--버튼영역-->
    <div class="btnArea">
    	<span class="fl">
			<span class="btn_05 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>
	</div>
    
<!--내용 종료-->
</body>
</html>
