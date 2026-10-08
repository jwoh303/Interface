<%--
**********************************************
인터페이스 협력사 크레텍 발주 정보 수정
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script src="/resources/js/kep_common.js"></script>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
		  { Align:"Center", Width:60,  Edit:false, EditLen:0,   Hidden:true,  Type:"Status",     Header:"상태값",         SaveName:"sStatus",         Sort:0 }
		  , { Align:"Center", Width:30,  Edit:true,  EditLen:30,  Hidden:true,  Type:"DummyCheck", Header:"",               SaveName:"SELECTED",        Sort:0 }
		  , { Align:"Center", Width:60,  Edit:false, EditLen:95,  Hidden:false, Type:"Image",      Header:"상태",           SaveName:"IF_FLAG",         Sort:0 }
		  , { Align:"Left",   Width:250, Edit:false, EditLen:95,  Hidden:false, Type:"Text",       Header:"전송결과",       SaveName:"IF_MSG",          Sort:0 }
		  , { Align:"Center", Width:120, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"공급사코드",     SaveName:"AGENT",           Sort:0 }
		  , { Align:"Center", Width:150, Edit:false, EditLen:95,  Hidden:false, Type:"Text",       Header:"고객사명",       SaveName:"BUYER_NAME",      Sort:0 }
		  , { Align:"Center", Width:120, Edit:false, EditLen:95,  Hidden:true,  Type:"Text",       Header:"고객사코드",     SaveName:"BUYER",           Sort:0 }
		  , { Align:"Center", Width:130, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"요청번호",       SaveName:"PR_NO",       BackColor:"${optColor}", FontColor:"#1e90ff",    Sort:0 }
		  , { Align:"Center", Width:90,  Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"요청항번",       SaveName:"PR_SEQ",          Sort:0 }
		  , { Align:"Center", Width:130, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"발주번호",       SaveName:"PO_NO",           Sort:0 }
		  , { Align:"Center", Width:90,  Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"발주항번",       SaveName:"PO_SEQ",          Sort:0 }
		  , { Align:"Center", Width:90,  Edit:false, EditLen:100, Hidden:false, Type:"Int",        Header:"재전송차수",     SaveName:"REVISION",        Sort:0 }
		  , { Align:"Center", Width:150, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"협력사발주번호", SaveName:"AGENT_PO_NO",     Sort:0 }
		  , { Align:"Center", Width:150, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"고객사발주번호", SaveName:"LEGACY_PO_NO",    Sort:0 }
		  , { Align:"Center", Width:110, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"고객사발주항번", SaveName:"LEGACY_PO_SEQ",   Sort:0 }
		  , { Align:"Center", Width:150, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"고객사품목코드", SaveName:"BUYER_ITEM_NO",   Sort:0 }
		  , { Align:"Center", Width:160, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"공급사품목코드", SaveName:"SELLER_ITEM_NO",  Sort:0 }
		  , { Align:"Right",  Width:180, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"품명",           SaveName:"DESCRIPTION",     Sort:0 }
		  , { Align:"Center", Width:180, Edit:false,  EditLen:100, Hidden:false, Type:"Text",       Header:"규격",           SaveName:"SPECIFICATION",   Sort:0 }
		  , { Align:"Right",  Width:70,  Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"단위",           SaveName:"UNIT_MEASURE",    Sort:0 }
		  , { Align:"Right",  Width:90,  Edit:false, EditLen:100, Hidden:false, Type:"Float",      Header:"발주수량",       SaveName:"ITEM_QTY",        Sort:0 }
		  , { Align:"Right",  Width:100, Edit:false, EditLen:100, Hidden:false, Type:"Float",      Header:"매입단가",       SaveName:"AGENT_PRICE",     Sort:0 }
		  , { Align:"Right",  Width:110, Edit:false, EditLen:100, Hidden:false, Type:"Float",      Header:"매입금액",       SaveName:"AGENT_ITEM_AMT",  Sort:0 }
		  , { Align:"Right",  Width:130, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"물류센터코드",   SaveName:"WAREHOUSE_CODE",  Sort:0 }
		  , { Align:"Right",  Width:150, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"생성일",         SaveName:"CREATE_DATE",     Sort:0 }
		  , { Align:"Right",  Width:150, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"전송일시",       SaveName:"IF_DATE",         Sort:0 }
		  , { Align:"Right",  Width:250, Edit:false, EditLen:100, Hidden:false, Type:"Text",       Header:"재전송사유",     SaveName:"DATA10",          Sort:0 }
		  , { Align:"Right",  Width:80,  Edit:false, EditLen:100, Hidden:true,  Type:"Text",       Header:"마지막차수",     SaveName:"LATEST_YN",       Sort:0 }
		  , { Align:"Right",  Width:80,  Edit:false, EditLen:100, Hidden:true,  Type:"Text",       Header:"주문상태",     SaveName:"ORDER_EXISTS_YN",       Sort:0 }
		  , { Align:"Right",  Width:80,  Edit:false, EditLen:100, Hidden:true,  Type:"Text",       Header:"납품상태",     SaveName:"DELIVERY_EXISTS_YN",       Sort:0 }
		  , { Align:"Center", Width:80,  Edit:false, EditLen:10,  Hidden:true,   Type:"Text",      Header:"원본전송상태",   SaveName:"IF_FLAG_RAW",              Sort:0}
		];

// 	initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);
	
	// 하이퍼링크 설정
	//setLinkCol(mySheet, "BUYER_ITEM_NO");		//품목코드
		
	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	if(searchYn == "Y"|| processYN == "Y"){
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	$("#st_status").val("ALL");
	$("#job_kind").val("");
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !ValidationCheck() )
				return;
			current_page = -1;
			$("#job_kind").val("search");
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfCretecPoList.do" , pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

	}
}

//실행조건 체크
function ValidationCheck() {
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}
	if ( kepTrim("st_pr_no") == '' ) {
		alert("요청번호를 입력해 주세요.");
		return false;
	}
	if ( kepTrim("st_pr_seq") == '' ) {
		alert("요청항번을 입력해 주세요.");
		return false;
	}
	return true;
}	

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		if ( $("#job_kind").val() == "delete" ) {
			$("#st_cancel_remark").val("");
		}
		if ( $("#job_kind").val() == "upload" && code == 0 ) {
			mySheet.RemoveAll();
			return;
		}
		// 저장 성공시 재조회
		doAction("search");
	} 
}

// 조회
function pageSearch(param) {
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfCretecPoList.do?page="+current_page , pagingMode);
}

function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( column == 'PR_NO' ) { // 품목코드
		var latest	= mySheet.GetCellValue(Row, "LATEST_YN");
		var orderYn	= mySheet.GetCellValue(Row, "ORDER_EXISTS_YN");
		var deliYn	= mySheet.GetCellValue(Row, "DELIVERY_EXISTS_YN");
		var ifFlag  = mySheet.GetCellValue(Row,"IF_FLAG_RAW");

		if(ifFlag=="N"){
			alert("전송 대기 중인 건은 상세 조회할 수 없습니다.");
			return;
		}
		if (latest == "N" ) {
			alert("최신 차수만 상세 조회할 수 있습니다.");
			return;
		}
		if (orderYn != "Y" ) {
			alert("삭제되었거나 존재하지 않는 주문으로 상세 조회할 수 없습니다.");
			return;
		}
		if (deliYn == "Y" ) {
			alert("납품서가 생성된 주문은 상세 조회할 수 없습니다.");
			return;
		}
		var agent=mySheet.GetCellValue(Row,"AGENT");
		var buyer=mySheet.GetCellValue(Row,"BUYER");
		var poNo=mySheet.GetCellValue(Row,"PO_NO");
		var poSeq=mySheet.GetCellValue(Row,"PO_SEQ");
		var prNo=mySheet.GetCellValue(Row,"PR_NO");
		var prSeq=mySheet.GetCellValue(Row,"PR_SEQ");
		var revision=mySheet.GetCellValue(Row,"REVISION");

		var params="?st_agent="+encodeURIComponent(agent)
			+"&st_buyer="+encodeURIComponent(buyer)
			+"&st_po_no="+encodeURIComponent(poNo)
			+"&st_po_seq="+encodeURIComponent(poSeq)
			+"&st_pr_no="+encodeURIComponent(prNo)
			+"&st_pr_seq="+encodeURIComponent(prSeq)
			+"&st_revision="+encodeURIComponent(revision);

		
		popupSel = "MpIfCretecPoListPop";
		openSearchPopup("/mpif/showMpIfCretecPoListPop.do", params, "900,830,no");
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	//grbRow = Row; //현재 Row를 전역변수에 셋팅
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
}

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "buyer_single":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no"); 
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9){
// 	alert(value1 + ":" + value2 + ":" + value3 + ":" + value4 + ":" + value5);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if( popupSel == "buyer_single"){
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	
	grbRow="";	//초기화
}
</script>

</head>
<body onload="kep_onload_view()">
<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>협력사 크레텍 인터페이스 관리</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>
	
	 <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">

           	<table  class="cont_t_list01">
				<caption>협력사 크레텍 인터페이스 관리</caption>
				<colgroup>
					<col width="8%" />
					<col width="30%" />
					<col width="13%" />
					<col width="15%" />
					<col width="8%" />
					<col width="10%" />
				</colgroup>
				<tbody>
					<tr>
						<th><font color="#FF6600">* </font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('buyer_single','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="#FF6600">* </font>요청번호(주문번호)</th>
						<td>
							<input type="text" class="input_type_text" id="st_pr_no" name="st_pr_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th><font color="#FF6600">* </font>요청항번</th>
						<td>
							<input type="text" class="input_type_text" id="st_pr_seq" name="st_pr_seq" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fl">
			<font color="blue">※ 고객사, 요청번호, 요청항번 입력 시 발주 이력을 조회할 수 있습니다.</font>
		</span>
		<br/><br/>
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
        	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="10" selected>10건</option>
				<option value="20">20건</option>
				<option value="30">30건</option>
				<option value="40">40건</option>
				<option value="50">50건</option>
			</select>
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;정상&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;오류건&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;전송대기&nbsp;&nbsp;
			<img src="/resources/images/icon_prif_delete.gif" style="padding-top:3px;"/>&nbsp;재전송 처리&nbsp;&nbsp;
		</span>
		<br>
	</form>
	
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
		<table style="width:100%;">
			<tr>
				<td colspan="2" height="25" align="left">
					&nbsp;<font><b>※ 최신 차수만 상세 조회할 수 있으며, 전송 대기 중이거나 삭제된 주문은 조회할 수 없습니다.</b></font>
		        </td>
			</tr>
		   <!--  <tr>
		        <td height="25" align="right" valign="middle">
		  			<span class="btn_02 mr04"><a href="javascript:doAction('save');">재전송</a></span>
		        </td>
		    </tr> -->
		</table>
	</div>
	<!--내용 종료-->
</body>
</html>