<%--
**********************************************
* 메뉴 : 
* 화면 : 재고보충 발주 조회 및 삭제
* 기능 : 재고보충 발주 조회 및 삭제
* 프로그램 ID : PG_08_M_005_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-5
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

String PO_NO = CommonUtil.nvl((String) request.getParameter("PO_NO"),"");  //  (조회조건)
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건)

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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};

	initsheet.Cols = [ 
	                  
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						 ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"STDCATLG_ID"} 
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BUYER_ITEM_NO"} 
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호", SaveName:"CONTRACT_NO"} 
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번", SaveName:"CONTRACT_SEQ"} 
							,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION"} 
							,{ Align:"Left",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주수량", SaveName:"ITEM_QTY"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",Format:"#,##0",	Header:"매입단가", SaveName:"AGENT_PRICE"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",Format:"#,##0",Header:"매입금액", SaveName:"AGENT_ITEM_AMT"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Float",Format:"#,##0",	Header:"매출단가", SaveName:"UNIT_PRICE"} 
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Int",Format:"#,##0",	Header:"매출금액", SaveName:"ITEM_AMT"} 
							,{ Align:"Left",	Width:220,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"비고", SaveName:"PO_REMARK"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"SCM비고",	SaveName:"SCM_REMARK_IMG"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"DOC_TYPE"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BYIT_COMORG_CODE"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_SEQ"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BUYER"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_NO"}
							,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"SCM_REMARK"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "SCM_REMARK_IMG");
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrTrOrderManagerPop.do" , pagingMode );

} 
var st;
var mt;
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == "BUYER_ITEM_NO" ){ 
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
		{
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}

		
	}
	else if (column == 'SCM_REMARK_IMG') { // SCM비고
	
		//http://130.100.101.21:7004/kr/sysop/proxbuy/scm/sysop_proxbuy_scm_scmremark.jsp?ds_seq=&po_no=PO14000001&po_seq=000002&buyer=KRILJI0001
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_WMS_YN=Y", "520,500,no");
		
	}
	
	
}
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			 var com_code = document.searchCondition.AGENT.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
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
	
	for(i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i, 'SCM_REMARK') == ""){
			mySheet.SetCellValue(i, 'SCM_REMARK_IMG', remarkOff);
		}
		else{
			mySheet.SetCellValue(i, 'SCM_REMARK_IMG', remarkOn);
		}
		

	}
}


</script> 
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_PO_NO"  name="st_PO_NO" value="<%=PO_NO %>">
	<input type="hidden" id="st_BUYER"  name="st_BUYER" value="<%=BUYER %>">
	<input type="hidden" id="AGENT"  name="AGENT" value="<%=CommonUtil.nvl(rowData.get("AGENT")) %>">	
	<div id="popWrapper"  style="width:100%"  >
    	<div id="popHeader">
        	<h1 class="title">고객사 발주 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="height:100%">
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
							<td ><b><%=CommonUtil.nvl(rowData.get("COM_NAME")) %></b></td>
							<th >발주번호</th>
							<td  ><b><%=rowData.get("PO_NO")%><%="".equals(rowData.get("LEGACY_PO_NO"))? "" : "("+rowData.get("LEGACY_PO_NO")+")"%></td>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
						 </tr>
						 <tr>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
                  			<th >센터예정일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE_RE"))%></td>
							<th >구분</th>
							<td  ><%=rowData.get("STATUS_TEXT")%>(<%=rowData.get("DOC_TEXT")%>)</td>
						 </tr>
						 <tr>
						 	 <th >요청자</th>
							<td ><%=rowData.get("ADD_USER_NAME")%><%="".equals(rowData.get("ADD_USER_TEL"))? "" : "("+rowData.get("ADD_USER_TEL")+")"%></td>
							<th >협력사</th>
							<td   colspan='3'><u><a href="javascript:doPop('buyer_multi')"><%=rowData.get("AGENT_NAME")%></a></u><%="".equals(rowData.get("AGENT_TEL_NO"))? "" : "("+rowData.get("AGENT_TEL_NO")+")"%></td>
						 </tr>
						 <tr>
						 	<th >배송처</th>
							<td   colspan='5'><%=rowData.get("DELY_TO_LOCATION")%></td>
						 </tr>
						 	<th >비고</th>
							<td   colspan='5'><%=rowData.get("PO_REMARK")%></td>
						 <tr>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:255px">
				<script type="text/javascript">
	
					createIBSheet("mySheet", "", "255px");

				</script>
			</div><br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
