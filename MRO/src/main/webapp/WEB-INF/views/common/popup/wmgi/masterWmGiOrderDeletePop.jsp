<%--
**********************************************
* 메뉴 : 
* 화면 : 출고 >발주삭제
* 기능 : 출고 >발주삭제
* 프로그램 ID : PG_08_M_005_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-18
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

String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"");  //  (조회조건)
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)

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
		    			,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}
					    ,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태", SaveName:"STATUS_TEXT"} 
						
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호", SaveName:"GR_NO"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"송장번호", SaveName:"IK_NO"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"입고일자", SaveName:"GR_DATE"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"출고일자", SaveName:"INV_DATE"} 

						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"표준코드", SaveName:"STDCATLG_ID"} 
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드", SaveName:"BUYER_ITEM_NO"} 
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명", SaveName:"DESCRIPTION"} 
						,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격", SaveName:"SPECIFICATION"} 							
						
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",Header:"발주수량", SaveName:"PO_QTY"} 
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",Header:"입고수량", SaveName:"WMS_GR_QTY"} 
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float", Format:"${qtyFormat}",	Header:"출고수량", SaveName:"WMS_IVK_QTY"} 

						,{ Align:"Left",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위", SaveName:"UNIT_MEASURE"} 
						
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",Header:"출고단가", SaveName:"UNIT_PRICE"}
						,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type : "Float", Format:"${priceFormat}",Header:"출고금액", SaveName:"UNIT_AMT"}

						,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고", SaveName:"PO_REMARK"} 
						,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",Header:"비고", SaveName:"PO_REMARK_IMG"} 

						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BYIT_COMORG_CODE"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_NO"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"CONTRACT_SEQ"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"BUYER"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_NO"}
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PO_SEQ"}							
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"LIST_PRICE"}		
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"PROCESS_TYPE"}			
						,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"", SaveName:"STATUS"}				
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet2(mySheet, initsheet,pagingMode,7);

	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "PO_REMARK_IMG");
	mySheet.SetImageList(0, remarkOn);
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmGiOrderDeletePopList.do" , pagingMode );

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
		
	}else 	if(column=="PO_REMARK_IMG" )
	{
		var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
		openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
		popupSel = "remarkBtoA";
	
	}
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if(code =="1" )
	{
	      alert("정상적으로 물류센터 삭제가 되었습니다.");
	      opener.doAction('search');
	      window.close();
		
	}else {
	      alert("물류센터 삭제가 실패 하였습니다.\n\n본사 기술연구소로 연락바랍니다.\n");
	      return;
	    }
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"PO_REMARK")=="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}
		else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
	//	alert( mySheet.GetCellValue(i,"STATUS"));
		if("D" == mySheet.GetCellValue(i,"STATUS")){
			
			mySheet.SetCellEditable(i, "SELECTED", 0);
			mySheet.SetCellValue(i, "SELECTED", 1);
		}else{
			
			mySheet.SetCellEditable(i, "SELECTED", 0);
			
		}
	}

}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
	case "reload":
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;
	case "del":
	    var user_id ="${sessionInfo.userId}";
		  if(user_id != "KEP200013"){
				if(document.searchCondition.st_process_type.value != "2"){
					alert("거래유형이 재고/VMI 인 경우에는 삭제가 불가능합니다.  ");
					return;
				}
			}
		    if(!confirm("물류센터 삭제 하시겠습니까?")) {
		        return;
		    }else{
		    	kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmGiOrderDeletePop.do" , "SELECTED" );
		    }
		break;
	}
}
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "agent":
			
			 var com_code ="<%=rowData.get("AGENT")%>";
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,500,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;
	}
}

</script> 
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="user_id"  name="user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="com_code"  name="com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%= CommonUtil.nvl((String) request.getParameter("st_po_no"),"") %>">
	<input type="hidden" id="st_process_type"  name="st_process_type" value="<%=rowData.get("PROCESS_TYPE")%>">	
	<div id="popWrapper" style="height:495px;">
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
						<tr>
							<th>고객사</th>
							<td ><b><%=rowData.get("COM_NAME")%></b></td>
							<th >발주번호</th>
							<td  ><b><%=rowData.get("PO_NO")%><%="".equals(rowData.get("LEGACY_PO_NO"))?"":"(" +rowData.get("LEGACY_PO_NO")+")"%></b></td>
                  			<th >발주일</th>
					  		<td  ><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
						 </tr>
						 <tr>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
                  			<th >협력사</th>
					  		<td  ><u><a href="javascript:doPop('agent')"><%=rowData.get("AGENT_NAME")%></a></u><%="".equals(rowData.get("AGENT_TEL_NO"))?"":"(" +rowData.get("AGENT_TEL_NO")+")"%></td>
							<th >구분</th>
							<td  ><%=rowData.get("DOC_TEXT")%></td>
						 </tr>
						 <tr>
						 	 <th >요청자</th>
							<td ><%=rowData.get("ADD_USER_NAME")%><%="".equals(rowData.get("ADD_USER_TEL"))?"":"(" +rowData.get("ADD_USER_TEL")+")"%></td>
						 	<th >배송처</th>
							<td   colspan='5'><%=rowData.get("DELY_TO_LOCATION")%></td>
            </tr>						
						<tbody>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "250px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->
                <div class="btnArea mr25">
               <span class="fr">
				<span class="btn_04 mr04"><a href="javascript:doAction('del');">센터삭제</a></span>
			</span>
                </div>

        
    </div>
</form> 
</body>
</html>
