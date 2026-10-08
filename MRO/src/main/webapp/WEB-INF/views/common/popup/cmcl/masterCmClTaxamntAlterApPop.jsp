<%--
**********************************************
* 메뉴 : 마감공통팝업(매입용)
* 화면 : 세액변경 팝업 
* 기능 : 
* 프로그램 ID : PG_10_M_010_02
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String buyer		= request.getParameter("st_buyer");
	String taxBillNo    = request.getParameter("st_tax_bill_no");
	String siteType     = request.getParameter("st_site_type");
	String taxPrice	    = request.getParameter("st_taxPrice");
	String taxType	    = request.getParameter("st_tax_type_code");
	String suppPrice    = request.getParameter("st_supp_price");
	String user_id      = request.getParameter("st_user_id");

%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>세액 정보</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
   		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",		SaveName:"sStatus"}
   		,{ Align:"Center",	Width:60,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"부서코드",	SaveName:"DEPT_CODE"}
   		,{ Align:"right",	Width:60,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"최초세액총합",	SaveName:"INIT_TOT_TAX_PRICE"}
   		,{ Align:"Center",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KEP 부서",	SaveName:"DEPT_NAME"}
   		,{ Align:"right",	Width:146,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"공급가액",	SaveName:"SUPP_PRICE"}
   		,{ Align:"right",	Width:127,	Edit:true,	EditLen:13,	Hidden:false,	Type:"Float",		Header:"세액",		SaveName:"TAX_PRICE",	BackColor:"${optColor}"}
   	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClTaxamntAlterApPop.do" , pagingMode );
}

var st;
var mt;

//그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClTaxamntAlterApPop.do" , pagingMode );
			break;
			
		case "save": // 저장
			if ( !checkRow() )
				return;
			if ( !validationSave() )
				return;
			if ( !confirm('세액을 변경 하시겠습니까?') )
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClTaxamntAlterApPop.do", -1 );
			break;
	}

}

// 변경 여부 체크
function checkRow() {
	var check = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	
	if ( check ) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	
	return true;
}

// Valitation - 수정
function validationSave() {

	var totTaxPrice = <%=taxPrice%>;
	var totSumAmt	= <%=suppPrice%>;
	var initTotTaxPrice = 0;
	var sumTaxPrice =0;
	var sumAmt		=0;
	var taxType = "<%=taxType%>";
	
	for( var i = 1; i <= mySheet.RowCount(); i++ ) {
		initTotTaxPrice = Number(mySheet.GetCellValue(i, "INIT_TOT_TAX_PRICE"));
		sumTaxPrice = sumTaxPrice+Number(mySheet.GetCellValue(i, "TAX_PRICE"));
		sumAmt = sumAmt+Number(mySheet.GetCellValue(i, "SUPP_PRICE"));
	}
	if ( taxType == "21" ) {
		if ( !(initTotTaxPrice+10 >= sumTaxPrice && initTotTaxPrice-10 <= sumTaxPrice) ) {
			alert("세액의 변경은 본래 세액의 +-10원을 벗어 날수 없습니다"); 
			return false;
		}
	}
	if ( !(totSumAmt+10 >= sumAmt && totSumAmt-10 <= sumAmt) ) {
		alert("공급가액의 변경은 본래 공급가액의 +-10원을 벗어 날수 없습니다"); 
		return false;
	}
	
	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	var taxType = "<%=taxType%>";
	if ( taxType == "22" || taxType == "23" ) {
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			mySheet.SetCellValue(i, "TAX_PRICE", 0);
		}
		
		alert("세무구분이 영세,면세 매입이므로\n세액은 0원으로만 설정 가능합니다.\n\n확인을 눌러 저장해 주십시오.");
	}
}


// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		opener.doAction("search");
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	grbRow = Row;
	
	return;
}

//확인
function kepConfirm()
{ 
	 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
	 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
	 
	 opener.setPopupReturn(value1,value2);
	 
	 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_tax_bill_no" name="st_tax_bill_no"	value="<%=taxBillNo%>">
	<input type="hidden" id="st_buyer" name="st_buyer"	value="<%=buyer%>">
	<input type="hidden" id="st_site_type" name="st_site_type"	value="<%=siteType%>">
	<input type="hidden" id="st_tax_type_code" name="st_tax_type_code"	value="<%=taxType%>">
	
	<div id="popWrapper" style="height:330px;">
    	<div id="popHeader">
        	<h1 class="title">세액변경 팝업 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>조회</caption>
					<colgroup>
						<col width="150px" />
						<col width="150px" />
						<col width="*" />
					</colgroup>
					
					<tbody>
						<tr>
							<td>총 금액 : </td>
							<td style="width:20%; text-align:right;"><%=CommonUtil.formatNumber(suppPrice, true, 15, 2)%> 원</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>총 세액 : </td>
							<td style="width:20%; text-align:right;"><%=CommonUtil.formatNumber(taxPrice, true, 15, 2)%> 원</td>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "111px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save')"">확인</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
