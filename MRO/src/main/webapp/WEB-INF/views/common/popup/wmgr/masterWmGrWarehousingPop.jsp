<%--
**********************************************
* 메뉴 : 
* 화면 : TR 입고 조회 및 삭제
* 기능 : TR입고 조회 및 삭제
* 프로그램 ID : PG_08_M_004_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-3
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

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}

String st_buyer = CommonUtil.nvl((String) request.getParameter("BUYER"),"");
String st_hub_yn = CommonUtil.nvl((String) request.getParameter("HUB_YN"),"N");

//입고라벨 미사용 대상 고객사(TR이어도 고객사 고유의 양식 사용)
String st_no_tag_check_yn = "N";
boolean st_no_tag_check = CommonUtil.getCodeCheckReturn("M204", st_buyer);
if(st_no_tag_check == true){
	st_no_tag_check_yn = "Y";
}else{
	st_no_tag_check_yn = "N";
}

//품목라벨 자체 사용 고객사(KEP 품목라벨은 중복되어 출력되지 않아야 함)
String st_no_itemTag_check_yn = "N";
boolean st_no_itemTag_check = CommonUtil.getCodeCheckReturn("M206", st_buyer);

if(st_no_itemTag_check == true){
	st_no_itemTag_check_yn = "Y";
}else{
	st_no_itemTag_check_yn = "N";
}

//고객사 고유 품목라벨 사용
String p070000034 = "";
Map<String, String> p070000034_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P07-0000034");

if (p070000034_map != null){
	p070000034 = CommonUtil.nvl(p070000034_map.get("COL01_DATA"),""); // 품목라벨 mrd
}

//일반 거래명세서 외 특수상황 출력 필요 고객사
String siv00001_TYPE = "";
String siv00001_RD1 = "";
String siv00001_RD2 = "";

Map<String, String> siv00001_map = CommonUtil.getSpecialCheckReturnMap(st_buyer, "SIV00001");
if (siv00001_map != null){
	siv00001_TYPE = CommonUtil.nvl(siv00001_map.get("COL01_DATA"),""); // 상황 TYPE
	siv00001_RD1 = CommonUtil.nvl(siv00001_map.get("COL02_DATA"),""); // 추가출력 mrd
	siv00001_RD2 = CommonUtil.nvl(siv00001_map.get("COL03_DATA"),""); // 추가출력 mrd
}
%>
<!doctype html>
<html>
<head>
<title>코리아 e 플랫폼</title>
<%@ include file="../../../common/include/head.jspf"  %> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Left",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",     Type:"Text",	Width : 90, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",      	Type : "Float",  Format:"${qtyFormat}",		Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "WMS_GR_QTY",		Header : "기입고수량",	Type : "Float",  Format:"${qtyFormat}",		Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AGENT_PRICE",		Header : "매입단가",Type : "Float",  Format:"${priceFormat}",		Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "AGENT_ITEM_AMT",		Header : "매입금액",	Type:"Int",	 Format:"#,##0",		Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가"  ,	Type : "Float",  Format:"${priceFormat}",		Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매출금액",	Type:"Int",	 Format:"#,##0",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BYIT_COMORG_CODE"},
	    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_NO"},
	    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_SEQ"},
	    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"비고", SaveName:"PO_REMARK"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");

	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrWarehousingPop.do" , pagingMode );
}

var st;
var mt;
//기능함수

function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrWarehousingPop.do" , pagingMode );
			break;
			
		case "del": // 입고삭제
<%if("Y".equals(st_hub_yn)){%>
			if(eval(document.searchCondition.WMS_GR_QTY.value) > 0){
			    alert("도착센터 입고 이후의 상태입니다.\n삭제하실 수 없습니다.");
			    return;
			}
			
			if(eval(document.searchCondition.HUB_IV_QTY.value) > 0){
			    alert("간선출고 상태입니다.\n간선출고 삭제를 먼저 진행해주세요.");
			    return;
			}
<%}else{%>
			if(eval(document.searchCondition.WMS_GR_QTY.value) == 0){
			    alert("센터 입고 전의 상태입니다.\n삭제하실 수 없습니다.");
			    return;
			}
			
			if(eval(document.searchCondition.WMS_IVK_QTY.value) > 0){
			    alert("출고지시 이후의 상태입니다.\n출고 삭제를 먼저 진행해주세요.");
			    return;
			}
<%}%>

		    if(!confirm("센터 입고를 삭제 하시겠습니까?(대상에 있는 모든 항목)")) {
		        return;
		    }else{
		    	kepSave(document.searchCondition, mySheet, "/wmgr/delMasterWmGrWarehousingPop.do", "BUYER_ITEM_NO" );
		    }
		    
			break;

		case "delHub": // 간선출고삭제
<%if("Y".equals(st_hub_yn)){%>
			if(eval(document.searchCondition.WMS_GR_QTY.value) > 0){
			    alert("도착센터 입고 이후의 상태입니다.\n삭제하실 수 없습니다.");
			    return;
			}
			
			if(eval(document.searchCondition.HUB_IV_QTY.value) == 0){
			    alert("간선출고 전의 상태입니다.\n삭제하실 수 없습니다.");
			    return;
			}
			
			if(!confirm("간선출고를 삭제 하시겠습니까?(대상에 있는 모든 항목)")) {
				return;
			}else{
				document.searchCondition.HUB_DEL_FLAG.value = "Y";
				
				kepSave(document.searchCondition, mySheet, "/wmgr/delMasterWmGrWarehousingPop.do", "BUYER_ITEM_NO" );
			}
<%}%>
			document.searchCondition.HUB_DEL_FLAG.value = "N";
			
			break;
			
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(code>0){
		//저장 성공시 재조회
		 alert("정상적으로 센터 입고 삭제 되었습니다.");
		 opener.doAction('search');
		 this.close();
	}else {
      alert("센터 입고 삭제가 실패 하였습니다.\n\n본사 기술연구소로 연락바랍니다.");
      return;
    }
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	if(mySheet.RowCount() <= 0) return;

	if (msg != "") {
		alert(msg);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if((column == 'BUYER_ITEM_NO') ){
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !=""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
		}
	}
	return;
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

//확인
function kepConfirm(){
	var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
	var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
	
	opener.setPopupReturn(value1,value2);
	this.close();
}

function sheetWin() {
	var st_no_tag_check_yn = "<%=st_no_tag_check_yn%>";
	if(st_no_tag_check_yn == "Y"){
		alert("해당 고객사는 입고라벨을 사용하지 않습니다.");
		return;
	}
	
	var buyer = "<%=st_buyer%>";
	var inv_no = $("#INV_NO").val();
	var rpt_url = "RD_06_S_001_170"; // 일반프린터
	var seller = "KRKORE0001";
	var ktag_box_qty = $("#st_gr_box_qty").val();
	var legacy_iv_serial = "";
	var tr_buyer = $("#st_warehouse_code").val();
	var print_gbn = "1";
	var legacy_po_no = "";
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
	var process_type = $("#PROCESS_TYPE").val();
	
	var dely_to_location_code = $("#DELY_TO_LOCATION_CODE").val();
	var cqdt_item_no = $("#CQDT_ITEM_NO").val();
	
	// TR 외에 입고라벨 출력 안함
	if(process_type == "2"){
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);	
	}
	
	// 고객사 전용 품목 TAG 추가 출력
	if("<%=st_no_itemTag_check_yn%>" == "Y"){
		rpt_url = "<%=p070000034%>";
		param = "["+inv_no+"]["+seller+"]["+buyer+"]";
		
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	}
	
	// 특수 상황에 RD파일 추가 출력 필요 고객사 START
	if("<%=siv00001_TYPE%>" != ""){
		if("<%=siv00001_TYPE%>" == "TYPE01"){ // 세스코
			if(dely_to_location_code == "DS431" && cqdt_item_no != ""){ // DS431 : 안성물류센터
				// 기본 박스라벨 출력
				rpt_url = "<%=siv00001_RD1%>";
    			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
    			
    			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    			
				if(cqdt_item_no != "X"){ // X가 아니면 품목바코드도 출력
					rpt_url = "<%=siv00001_RD2%>";
        			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
        			
        			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
				}
			}
		}
	}
	// 특수 상황에 RD파일 추가 출력 필요 고객사 END
	
	return;
}

function sheetTagListWin4() {
	var buyer = "<%=st_buyer%>";
	var ik_no = $("#INV_NO").val();
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = "1";
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "RD_06_X_002_19"; // 일반프린터
	
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
	
    reportOpen(fileName, param);
	return;
}

function sheetTagListWin12() {
	var buyer = "<%=st_buyer%>";
	var ik_no = $("#INV_NO").val();
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = "1";
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "RD_06_X_002_21"; // 일반프린터
	
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
	
    reportOpen(fileName, param);
	return;
}
</script>
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="BUYER"  name="BUYER" value="<%=CommonUtil.nvl((String) request.getParameter("BUYER"),"") %>">
	<input type="hidden" id="PO_NO"  name="PO_NO" value="<%=CommonUtil.nvl((String) request.getParameter("PO_NO"),"") %>">
	<input type="hidden" id="INV_NO"  name="INV_NO" value="<%=CommonUtil.nvl((String) request.getParameter("INV_NO"),"") %>">
	<input type="hidden" id="WMS_IVK_QTY"  name="WMS_IVK_QTY" value="<%=CommonUtil.nvl(rowData.get("WMS_IVK_QTY"))%>">
	<input type="hidden" id="WMS_GR_QTY"  name="WMS_GR_QTY" value="<%=CommonUtil.nvl(rowData.get("WMS_GR_QTY")) %>">
	<input type="hidden" id="AGENT"  name="AGENT" value="<%=CommonUtil.nvl(rowData.get("AGENT")) %>">
	<input type="hidden" id="HUB_YN"  name="HUB_YN" value="<%=st_hub_yn%>">
	<input type="hidden" id="HUB_IV_QTY"  name="HUB_IV_QTY" value="<%=CommonUtil.nvl(rowData.get("HUB_IV_QTY"))%>">
	<input type="hidden" id="HUB_GR_QTY"  name="HUB_GR_QTY" value="<%=CommonUtil.nvl(rowData.get("HUB_GR_QTY")) %>">
	<input type="hidden" id="HUB_DEL_FLAG"  name="HUB_DEL_FLAG" value="N">
	<input type="hidden" id="PROCESS_TYPE"  name="PROCESS_TYPE" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE")) %>">
	<input type="hidden" id="DELY_TO_LOCATION_CODE"  name="DELY_TO_LOCATION_CODE" value="<%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION_CODE"))%>">
	<input type="hidden" id="CQDT_ITEM_NO"  name="CQDT_ITEM_NO" value="<%=CommonUtil.nvl(rowData.get("CQDT_ITEM_NO"))%>">
	
	<div id="popWrapper" >
    	<div id="popHeader">
<c:if test="${param.workType eq 'MP' }">
        	<h1 class="title">TR입고 조회</h1>
</c:if>        	
<c:if test="${param.workType ne 'MP' }">
        	<h1 class="title">TR 입고 조회 및 삭제</h1>
</c:if>        	
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:420px">
        	<!--버튼영역-->
            <!--조회영역-->
           	<table class="cont_t_list06" style="width:100%">
				<caption>조회</caption>
				<colgroup>
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="18%" />
					<col width="10%" />
					<col width="17%" />
				</colgroup>
				
				<tbody>
					<tr>
						<th>고객사</th>
						<td><B><%=CommonUtil.nvl(rowData.get("COM_NAME")) %></B></td>
	                			<th >발주번호</th>
				  		<td><%=CommonUtil.nvl(rowData.get("PO_NO")) %><br><%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO")).equals("")?"":"(" +CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))+")" %></td>
						<th>발주일</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE")) %></td>
					 </tr>
					 <tr>
						<th>납품요청일</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
	                			<th >입고번호</th>
				  		<td><B><%=CommonUtil.nvl(rowData.get("INV_NO"))%></B></td>
						<th>구분</th>
						<td><%=CommonUtil.nvl(rowData.get("DOC_TEXT"))%></td>
					 </tr>
					 <tr>
						<th>입고일</th>
						<td><%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE_RE"))%></td>
						<th>협력사</th>
						<td colspan="3"><u><a href="javascript:doPop('buyer_multi')"><%=CommonUtil.nvl(rowData.get("AGENT_NAME")) %></a></u><%=CommonUtil.nvl(rowData.get("AGENT_TEL_NO")).equals("")?"":"(" +CommonUtil.nvl(rowData.get("AGENT_TEL_NO"))+")"%></td>
					 </tr>
					 <tr>
						<th>요청자</th>
						<td><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME")) %><%=CommonUtil.nvl(rowData.get("ADD_USER_TEL")).equals("")?"":"(" +CommonUtil.nvl(rowData.get("ADD_USER_TEL"))+")"%></td>
						<th>배송처</th>
						<td colspan="3"><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
					 </tr>
				</tbody>
			</table>
            <br/>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<br/>
			<!--버튼영역-->
<%if(!st_hub_yn.equals("Y")){%>
			<span class="fl">
				<span class="btn_02 mr04"><a href="javascript:sheetWin();" style="text-align:center;cursor:hand">입고라벨</a></span>
				<span class ="btn_10_blue" style="width:115px; color:#FFF">
					박스수량 :
					<select id="st_gr_box_qty" name="st_gr_box_qty" style="width:40px; margin-top:3px">
						<option value="1" >1</option>
						<option value="2" >2</option>
						<option value="3" >3</option>
						<option value="4" >4</option>
						<option value="5" >5</option>
						<option value="6" >6</option>
						<option value="7" >7</option>
						<option value="8" >8</option>
						<option value="9" >9</option>
						<option value="10" >10</option>
						<option value="11" >11</option>
						<option value="12" >12</option>
						<option value="13" >13</option>
						<option value="14" >14</option>
						<option value="15" >15</option>
						<option value="16" >16</option>
						<option value="17" >17</option>
						<option value="18" >18</option>
						<option value="19" >19</option>
						<option value="20" >20</option>
						<option value="21" >21</option>
						<option value="22" >22</option>
						<option value="23" >23</option>
						<option value="24" >24</option>
						<option value="25" >25</option>
						<option value="26" >26</option>
						<option value="27" >27</option>
						<option value="28" >28</option>
						<option value="29" >29</option>
						<option value="30" >30</option>
						<option value="31" >31</option>
						<option value="32" >32</option>
						<option value="33" >33</option>
						<option value="34" >34</option>
						<option value="35" >35</option>
						<option value="36" >36</option>
						<option value="37" >37</option>
						<option value="38" >38</option>
						<option value="39" >39</option>
						<option value="40" >40</option>
						<option value="41" >41</option>
						<option value="42" >42</option>
						<option value="43" >43</option>
						<option value="44" >44</option>
						<option value="45" >45</option>
						<option value="46" >46</option>
						<option value="47" >47</option>
						<option value="48" >48</option>
						<option value="49" >49</option>
						<option value="50" >50</option>
                   </select>
				</span>
				<span class="btn_05 mr04"><a href="javascript:sheetTagListWin4();" style="text-align:center;cursor:hand">품목라벨(4칸)</a></span>
				<span class="btn_05 mr04"><a href="javascript:sheetTagListWin12();" style="text-align:center;cursor:hand">품목라벨(12칸)</a></span>
			</span>
<%}%>

			<span class="fr">
			<%if("W".equals(CommonUtil.nvl((String) request.getParameter("STATUS"),"") ) || "W".equals(CommonUtil.nvl((String) request.getParameter("st_type"),"") )) {  %>
				<span class="btn_02 mr04"><a href="javascript:doAction('del');">입고삭제</a></span>
			<%}%>
			
			<%if("Y".equals(st_hub_yn) && "0".equals(CommonUtil.nvl(rowData.get("WMS_GR_QTY"))) && !"0".equals(CommonUtil.nvl(rowData.get("HUB_IV_QTY")))){%>
				<span class="btn_04 mr04"><a href="javascript:doAction('delHub');">간선출고삭제</a></span>
			<%}%>
			</span>
			<br/>
		</div>	
    </div>
</form> 
</body>
</html>
