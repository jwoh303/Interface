<%--
**********************************************
* 메뉴 : 
* 화면 : 배송확정
* 기능 : 배송확정 처리 
* 프로그램 ID : PG_08_M_007_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-17
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
String st_ik_no = CommonUtil.nvl((String) request.getParameter("st_ik_no"),"");  //  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
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
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
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
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "LEGACY_NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "PROCESS_TEXT",		Header : "구분",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PO_QTY",		Header : "발주수량",	Type : "Float",  Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "INV_QTY",		Header : "출고수량",Type : "Float",  Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "출고단가",Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "UNIT_AMT",		Header : "출고금액",	Type : "Float", Format:"${priceFormat}", Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Left",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:false},
	    			{Align : "Left",SaveName : "BYIT_COMORG_CODE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "CONTRACT_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "CONTRACT_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "BUYER",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "IK_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "AUTO_GR_FLAG",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			];
	initsheet.Cfg = {FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	kepSetCalender("st_delivery_date");
	$("#st_delivery_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_backDate").val( kepToDateAdd(7,"M","noslash"));
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlInvoiceNoPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlInvoiceNoPop.do" , pagingMode );
			break;
		case "save": // 저장

		    var delivery_company = document.searchCondition.st_delivery_company.value;
		    var delivery_no =document.searchCondition.st_delivery_no.value;
		    if((delivery_company != "JIKNAB" && delivery_company != "CENTER")) 
	        {
		           if( delivery_no == "" )
		           {
		              alert("운송장 번호를 입력하여 주십시요.");
		              document.searchCondition.st_delivery_no.focus();
		              return;
		           }
		      }
			var delivery_date = (document.searchCondition.st_delivery_date.value).replace(/[/]/gi,"");
			

			var backDate = document.searchCondition.st_backDate.value;

			if(eval(delivery_date) <=eval(backDate)){
				alert("현재일에서 7일 이전으로 배송확정 하실수 없습니다");
				return;
			}
		    if(!confirm("배송확정을 하시겠습니까?")) {
		        return;
		    }else{
				kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmDlInvoiceNoPop.do" , "IK_NO" );
		    }		
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (code == 1) {
	      alert("정상적으로 배송확정 되었습니다.");
			//저장 성공시 재조회

			opener.doAction('search');
		    window.close();
	}else{
	      alert("배송확정이 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
	      return;
	}
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlInvoiceNoPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	 if(column == 'BUYER_ITEM_NO')
		{
			if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !="")
			{
				var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
				var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
				var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
				var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
				openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
			}
		}
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
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=st_warehouse_code %>">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%= CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">	
	<input type="hidden" id="st_ik_no"  name="st_ik_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_ik_no"),"")  %>">		
	<input type="hidden" id="st_backDate" name="st_backDate"  value="">	
		
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">배송확정</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="70px" />
							<col width="18%" />
							<col width="50px" />
							<col width="30%" />
							<col width="50px" />
							<col width="18%" />
						</colgroup>
						<tbody>
						<tr>
						<th scope="col">고객사</th> 
						<td class="left"><%=CommonUtil.nvl(_rowData.get("BUYER_NAME")) %></td> 
						<th scope="col">송장번호</th> 
						<td class="left"><b><%=CommonUtil.nvl(_rowData.get("IK_NO")) %></b></td> 
						<th scope="col">출고일</th> 
						<td class="left"><%=CommonUtil.formatStrinigDate(_rowData.get("IK_DATE")) %></td> 
						  </tr>
					    <tr>
						<th scope="col">납품요청일</th> 
						<td class="left"><%=CommonUtil.formatStrinigDate(_rowData.get("RD_DATE")) %></td> 
						<th scope="col">발주일</th> 
						<td class="left"><%=CommonUtil.formatStrinigDate(_rowData.get("PO_CREATE_DATE")) %></td> 
						<th scope="col">요청자</th> 
						<td class="left">김발주 (02-9999-8888)</td> 
						  </tr>
					    <tr>
						<th scope="col">배송처</th> 
						<td class="left" colspan="5"><%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %></td>
					</tbody>
				</table>

            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->

        <div class="btnArea mr25">
   	          	<span class="fl">
      				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select  name='st_delivery_company' id='st_delivery_company'>  				
								<%= CommonUtil.getCodeComboQueryIdList("common.getDeliveryCompany","NO","st_delivery_company") %>
  					</select>
  					 <input type="text" name="st_delivery_no"  id="st_delivery_no" style="width:150px" value="">
  				</span>       
   				<span class="fr">
  					<span class="text11">배송확정일 : </span>
  					<input type="text" class="input_type_text" name="st_delivery_date" id="st_delivery_date" readOnly style="width:80px; text-align:center;" value="" onChange="javascript:getDayList()">
					<a href="javascript:kepCalendar('st_dlvry_date')"></a>
  					<span class="btn_02"><a href="javascript:doAction('save');">배송확정</a></span>
  				</span>   
       </div>
  
    </div>
</form> 
</body>
</html>
