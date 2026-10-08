<%--
**********************************************
* 메뉴 : 
* 화면 : 발주대기구매요청 상세
* 기능 : PO가 생성되지 않은 경우 등의 PR의 구매요청 상세정보를 보기위한 팝업
* 프로그램 ID : PG_06_M_001_01
* 담당자 : 개발1 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String pr_no = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"");  //  (조회조건)

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 



<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};

	initsheet.Cols = [ 
	                  
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
						 ,{ Align:"Center",	Width:40,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",	SaveName:"SELECTED"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드|품목코드", SaveName:"BUYER_ITEM_NO"}

						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사\n검사|협력사\n검사", SaveName:"AGENT_ERROR"} 
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매출단가\n검사|매출단가\n검사", SaveName:"UNIT_ERROR"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"매입단가\n검사|매입단가\n검사", SaveName:"LIST_ERROR"}
						 ,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사|주문", SaveName:"AGENT"}
						 ,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사|주문", SaveName:"AGENT_NAME" , KeyField:true,BackColor:"${notnullColor}"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사|계약", SaveName:"C_AGENT"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사|계약", SaveName:"C_AGENT_NAME"}
						 ,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", Header:"매출단가|주문", SaveName:"UNIT_PRICE", KeyField:true,BackColor:"${notnullColor}"}
						 ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"매출단가|계약", SaveName:"C_UNIT_PRICE" }
						 ,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매입단가|주문", SaveName:"LIST_PRICE",KeyField:true, BackColor:"${notnullColor}"}
						 ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}", 	Header:"매입단가|계약", SaveName:"C_LIST_PRICE"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약서|번호", SaveName:"CONTRACT_NO"}
						 ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계약서|항번", SaveName:"CONTRACT_SEQ"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청번호|요청번호", SaveName:"PR_NO"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청번호|요청번호", SaveName:"PR_SEQ"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"주문번호|주문번호", SaveName:"REF_NO"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"접수일|접수일", SaveName:"PASS_DATE"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목코드|품목코드", SaveName:"BYIT_COMORG_CODE"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:3};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "AGENT_NAME");
	
	
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderStandbyOrderReqDetailPop.do" , pagingMode );

} 
// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderStandbyOrderReqDetailPop.do" , pagingMode );
			break;
	
		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderStandbyOrderReqDetailList.do" , "SELECTED" );
			break;
	}
}
		
		
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	grbRow = Row;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == "BUYER_ITEM_NO" ){ 
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ,'800,255,no');
		}
	}else if(column == "AGENT_NAME"){ 	//협력사 선택
		
		var param = "?BUSINESS_COND=S&MULTI=N";
	
		var AGENT_ERROR = mySheet.GetCellValue(Row, "AGENT_ERROR");
		if(AGENT_ERROR == "공급사오류"){
			param += "&credit_status=Y";
		}
		
		openSearchPopup('/common/icomcmpyPop.do',param,'500,466,no');
		popupSel = "agent";
	}
	
	
}
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			 var com_code = document.searchCondition.AGENT.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code,'800,600,no'); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;
	}
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
// 	if(code>0){
		//저장 성공시 재조회
		doAction('search');
// 	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){

	if (popupSel == "agent") {	// 협력사
		mySheet.SetCellValue(grbRow, 'AGENT', value1);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value2);
	}
	
	grbRow="";	//초기화
}


</script> 
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=buyer %>">
	<input type="hidden" id="st_pr_no"  name="st_pr_no" value="<%=pr_no %>">
	<div id="popWrapper" style="height:464px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 발주 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%"">
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>고객사</th>
							<td ><b><%=CommonUtil.nvl(rowData.get("BUYER_NM")) %></b></td>
							<th >요청번호</th>
							<td  ><b><%=rowData.get("PR_NO")%></td>
							<th >주문번호</th>
							<td  ><b><%=rowData.get("REF_NO")%></td>
						 </tr>
						 <tr>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%></td>
							<th >발주자</th>
							<td  ><%=rowData.get("PURCHASER")%></td>
							<th >발주부서</th>
							<td  ><%=rowData.get("PURCH_DEPT")%></td>
						 </tr>
						 <tr>
							<th>제목</th>
							<td colspan="5"><%=rowData.get("PR_SUBJECT")%></td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
	
					createIBSheet("mySheet", "", "250px");

				</script>
			</div>
  			<!--버튼영역-->
               <div class="btnArea">
  	          		<div class="fl al">
  	          		<span class="al">
  							※ 계약정보를 변경하고자 하는경우,<br> 
							[상품관리 > 고객사카탈로그 관리 > 카탈로그 조회 및 수정(팝업: 고객사 카탈로그 수정)] 에서 변경하실 수 있습니다.
  					</span>
  					</div>
  					<div class="fr">
	  					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
  					</div>
  			 </div>

		</div>	


        
    </div>
</form> 
</body>
</html>
