<%--
**********************************************
* 메뉴 : 정산>정산관리>마감현황
* 화면 : AR 상세내역 팝업
* 기능 : AR 번호별 입고 상세 내역 조회
* 프로그램 ID : BU0601001
* 담당자 :
* 착수일 : 2026-04-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>마감현황 상세내역</title>
<%@ include file="../../../common/include/head_pop.jspf" %>
<%
	String p_tax_bill_no = CommonUtil.nvl((String)request.getParameter("st_tax_bill_no"));
	String p_com_code = CommonUtil.nvl((String)request.getParameter("st_com_code"));
%>
<script type="text/javascript">
var popSheet = new ibsheetObject();

function kep_onload_view(){
	// IBSheet 초기화
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, CountPosition:3, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
	initsheet.Cols = [
		 {Align:"Center", SaveName:"sStatus",        Header:"상태",     Type:"Status", Width:50,  Edit:false, Hidden:true}
		,{Align:"Center", SaveName:"NO",              Header:"No",       Type:"Text",   Width:50,  Edit:false, Hidden:false}
		,{Align:"Center", SaveName:"PO_NO",           Header:"발주번호", Type:"Text",   Width:120, Edit:false, Hidden:false}
		,{Align:"Center", SaveName:"REF_PR_NO",       Header:"관리번호", Type:"Text",   Width:120, Edit:false, Hidden:false}
		,{Align:"Center", SaveName:"PO_CREATE_DATE",  Header:"발주일",   Type:"Text",   Width:100, Edit:false, Hidden:false}
		,{Align:"Center", SaveName:"GR_DATE",         Header:"입고일",   Type:"Text",   Width:100, Edit:false, Hidden:false}
		,{Align:"Left",   SaveName:"BUYER_ITEM_NO",   Header:"품목코드", Type:"Text",   Width:100, Edit:false, Hidden:false}
		,{Align:"Left",   SaveName:"DESCRIPTION",     Header:"품명",     Type:"Text",   Width:180, Edit:false, Hidden:false}
		,{Align:"Left",   SaveName:"SPECIFICATION",   Header:"규격",     Type:"Text",   Width:150, Edit:false, Hidden:false}
		,{Align:"Right",  SaveName:"GR_ITEM_QTY",     Header:"입고수량", Type:"Float",  Width:80,  Edit:false, Hidden:false}
		,{Align:"Right",  SaveName:"UNIT_PRICE",      Header:"입고단가", Type:"Float",  Width:100, Edit:false, Hidden:false, Format:"#,###"}
		,{Align:"Right",  SaveName:"ITEM_AMT",        Header:"입고금액", Type:"Float",  Width:100, Edit:false, Hidden:false, Format:"#,###"}
	];
	IBS_InitSheet(popSheet, initsheet, "N");
	popSheet.SetHighlightAfterSort(2);
	popSheet.SetHeaderBackColor("#f2f7ff");
	popSheet.SetTheme("DB", "DeepBlue");

	// 데이터 로드
	loadData();
}

function loadData(){
	var param = "st_tax_bill_no=<%=p_tax_bill_no%>&st_com_code=<%=p_com_code%>";
	jQuery.ajax({
		url: "/wmgr/getBuyerWmGrClosingArDetailPop_v2.do",
		type: "POST",
		data: param,
		dataType: "json",
		success: function(result) {
			// 상단 헤더 정보
			if(result.header){
				$("#disp_ar_no").text(result.header.AR_NO || "<%=p_tax_bill_no%>");
				$("#disp_manager_name").text(result.header.KEP_MANAGER_NAME || "-");
				$("#disp_manager_tel").text(result.header.KEP_MANAGER_TEL || "-");
			}
			// 그리드 데이터
			if(result.data){
				popSheet.LoadSearchData(result);
			}
		},
		error: function(xhr) {
			alert("조회 중 오류가 발생했습니다.");
		}
	});
}

function doExcelDown(){
	if(popSheet.RowCount() == 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	var nowDate = new Date().toISOString().slice(0,10).replace(/-/g,"");
	var param = {
		FileName: "마감현황_상세내역_" + nowDate,
		SheetName: "상세내역",
		DownHeader: 1,
		Merge: 0,
		SheetDesign: 0,
		HiddenColumn: 0,
		OnlyHeaderMerge: 1
	};
	popSheet.Down2Excel(param);
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="popWrapper">
	<div id="popHeader">
		<h1 class="title">마감현황 상세내역</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/btn_pop_close.gif" alt="닫기" /></a></p>
	</div>
	<div id="popContainer">
		<!-- 상단 정보 -->
		<table class="cont_t_list01" style="width:100%; margin-bottom:10px;">
			<colgroup>
				<col width="120px" />
				<col width="*" />
				<col width="120px" />
				<col width="*" />
				<col width="120px" />
				<col width="*" />
			</colgroup>
			<tr>
				<td style="font-weight:bold; background:#f2f7ff; text-align:center;">AR번호</td>
				<td id="disp_ar_no" style="padding-left:10px;"><%=p_tax_bill_no%></td>
				<td style="font-weight:bold; background:#f2f7ff; text-align:center;">KeP담당자명</td>
				<td id="disp_manager_name" style="padding-left:10px;">-</td>
				<td style="font-weight:bold; background:#f2f7ff; text-align:center;">담당자연락처</td>
				<td id="disp_manager_tel" style="padding-left:10px;">-</td>
			</tr>
		</table>
		<!-- 엑셀 버튼 -->
		<div style="text-align:right; margin-bottom:5px;">
			<span class="btn_excel"><a href="javascript:doExcelDown();">엑셀 다운로드</a></span>
		</div>
		<!-- IBSheet 그리드 -->
		<div>
			<script type="text/javascript">createIBSheet("popSheet", "", "100%");</script>
		</div>
	</div>
</div>
</body>
</html>
