<%--
**********************************************
* 메뉴 : 
* 화면 : 반품조회 팝업
* 기능 : 반품 선택을 위한 발주번호 팝업
* 프로그램 ID : PG_08_M_019_03
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

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
<script src="/resources/js/common.js"></script>
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
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
	    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Type : "Text",	Width : 120,	EditLen : 110,Hidden:true, Edit : false},
	    			{Align : "Left",SaveName : "BUYER_NAME",		Header : "고객사명",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "STATUS_TEXT",		Header : "진행상태",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PO_SEQ",		Header : "발주순번",	Type:"Text",		Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "LEGACY_PO_NO",		Header : "IF발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "LEGACY_PO_SEQ",		Header : "IF발주순번",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Float", Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},	
	    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "PO_CREATE_DATE",		Header : "발주일",	Type:"Date",Format:"Ymd"	,Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납기요청일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},	    
	    			{Align : "Center",SaveName : "GR_DATE",		Header : "입고일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "INVOICE_DATE",		Header : "납품일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "DELIVERY_DATE",		Header : "배송일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type : "Float", Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "INVOICE_QTY",		Header : "납품수량",	Type : "Float", Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "DELIVERY_QTY",		Header : "배송수량",Type : "Float", Format:"${qtyFormat}",		Width : 100,	EditLen : 110,	Edit : false},	    
	    			{Align : "Left",SaveName : "SELLER",		Header : "협력사코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "SELLER_NAME",		Header : "협력사명",	Type : "Text",	Width : 120,	EditLen : 110,	Edit : false,Hidden:false},
	    			{Align : "Left",SaveName : "PROCESS_TYPE",		Header : "진행상태",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},	    	    		
	    			{Align : "Left",SaveName : "PROCESS_TYPE_NAME",		Header : "진행상태명",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:false},
	    			{Align : "Left",SaveName : "STATUS_BACK_CODE",		Header : "주문취소/반품/교환",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "STATUS_BACK_NAME",		Header : "주문취소/반품/교환",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false,Hidden:false},
	    			{Align : "Left",SaveName : "PROCESS_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "BUYER_DEPT_CODE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "BUYER_DEPT_NAME",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "BUYER_PERSON_NAME",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "BUYER_PERSON_TEL",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "B_REQ_DATE",		Header : "",	Type : "Date",Format:"Ymd", 	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "B_REQ_USER_ID",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "WMRE_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "WMRE_TYPE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "WMRE_QTY",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "B_REQ_REMARK",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "WAREHOUSE_CODE",		Header : "물류센터",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "WAREHOUSE_NAME",		Header : "물류센터",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:false},
	    			{Align : "Left",SaveName : "PR_ADD_USER_ID",		Header : "PR_ADD_USER_ID",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "PR_ADD_USER_NAME",		Header : "PR_ADD_USER_NAME",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "PR_ADD_USER_TEL",		Header : "PR_ADD_USER_TEL",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "PR_ADD_USER_DEPT",		Header : "PR_ADD_USER_DEPT",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "PR_ADD_USER_DEPT_NM",		Header : "PR_ADD_USER_DEPT_NM",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true},
	    			{Align : "Left",SaveName : "TOTAL_WMRE_QTY",		Header : "기반품수량",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");


	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	
   // kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			var st_po_no = document.forms.searchCondition.st_po_no.value;
			var st_buyer_item_no = document.forms.searchCondition.st_buyer_item_no.value;
			
			if(st_po_no == "" && st_buyer_item_no ==""){
				alert("발주번호 또는 품목코드 입력 바랍니다.");
				return;
			}
			kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnPop.do" , pagingMode );
			break;
		case "reload":
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
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

	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		if('1'==mySheet.GetCellValue(i,'STATUS_BACK_CODE')){
			mySheet.SetCellValue(i, 'STATUS_BACK_NAME', '주문취소');
		}
		else{
			mySheet.SetCellValue(i, 'STATUS_BACK_NAME', '반품/교환');
		}
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "PO_NO" ){ 
		var st_value1 = mySheet.GetCellValue(Row,'PO_NO') +'@@'+
		                    mySheet.GetCellValue(Row,'PO_SEQ') +'@@'+
		                    mySheet.GetCellValue(Row,'LEGACY_PO_NO') +'@@'+
		                    mySheet.GetCellValue(Row,'LEGACY_PO_SEQ') +'@@'+
		                    mySheet.GetCellValue(Row,'BUYER_ITEM_NO') +'@@'+
		                    mySheet.GetCellValue(Row,'DESCRIPTION') +'@@'+
		                    mySheet.GetCellValue(Row,'SPECIFICATION') +'@@'+
		                    mySheet.GetCellText(Row,'ITEM_QTY') +'@@'+
		                    mySheet.GetCellValue(Row,'UNIT_MEASURE') +'@@'+
		                    mySheet.GetCellValue(Row,'SELLER') +'@@'+
		                    mySheet.GetCellValue(Row,'PROCESS_TYPE') +'@@'+
		                    mySheet.GetCellValue(Row,'PROCESS_USER_NAME')+'@@'+
		                    mySheet.GetCellValue(Row,'PROCESS_TYPE_NAME') +'@@'+
		                    mySheet.GetCellValue(Row,'SELLER_NAME');
		var st_value2 = mySheet.GetCellValue(Row,'BUYER_DEPT_CODE') +'@@'+ //0
		 mySheet.GetCellValue(Row,'BUYER_DEPT_NAME') +'@@'+ //1
        mySheet.GetCellValue(Row,'BUYER_PERSON_NAME') +'@@'+ //2
        mySheet.GetCellValue(Row,'BUYER_PERSON_TEL') +'@@'+ //3
        mySheet.GetCellText(Row,'B_REQ_DATE') +'@@'+ //4
        mySheet.GetCellValue(Row,'B_REQ_USER_ID') +'@@'+ //5
        mySheet.GetCellValue(Row,'WMRE_NO') +'@@'+ //6
        mySheet.GetCellValue(Row,'WMRE_TYPE') +'@@'+ //7
        mySheet.GetCellValue(Row,'WMRE_QTY')+'@@'+ //8
        mySheet.GetCellValue(Row,'B_REQ_REMARK')+'@@'+ //9

        mySheet.GetCellValue(Row,'STATUS_BACK_CODE')+'@@'+ //10
        mySheet.GetCellValue(Row,'WAREHOUSE_CODE')+'@@'+ //11
		mySheet.GetCellValue(Row,'TOTAL_WMRE_QTY')+'@@'+ //12
		mySheet.GetCellValue(Row,'PR_ADD_USER_ID')+'@@'+ //13
		mySheet.GetCellValue(Row,'PR_ADD_USER_NAME')+'@@'+ //14
		mySheet.GetCellValue(Row,'PR_ADD_USER_TEL')+'@@'+ //15
		mySheet.GetCellValue(Row,'PR_ADD_USER_DEPT')+'@@'+ //16
		mySheet.GetCellValue(Row,'PR_ADD_USER_DEPT_NM');      //17
		
		//alert( mySheet.GetCellValue(Row,'STATUS_BACK_CODE'));
		opener.setPopupReturn(st_value1,st_value2);
		 this.close();
	}
	return;
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	grbRow="";	//초기화
}
</script> 

</head>
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"") %>">	
	<input type="hidden" name="st_com_code" id="st_com_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_com_code"),"") %>">

	<div id="popWrapper" style="height:485px;">
    	<div id="popHeader">
        	<h1 class="title">반품등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            <!--조회영역-->
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="35%" />
							<col width="10%" />
							<col width="45%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>발주일자</th>
							<td colspan="3" >
								<input type="text" class="al" name="st_from_date" id="st_from_date" readOnly style="width:10%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="al" name="st_to_date" id="st_to_date" readOnly style="width:10%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>																
							</td>
						</tr>
						<tr>
							<th>발주번호</th>
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text" title="" style="width:90%;"   onchange="fnCheckInputByte(this, 20);"  onkeyup="kepToUpper(id)"  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"/></td>
							<th>품목코드</th>
							<td><input type="text" name="st_buyer_item_no" id=""st_buyer_item_no"" class="input_type_text" title="" style="width:80%;"  onchange="fnCheckInputByte(this, 20);"  onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"/></td>
						</tr>							
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:255px">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "255px");
				</script>
							<div id="pageindex"></div>
			</div>
        <br/><br/>
		</div>	
        <!--버튼영역-->
        <br/><br/> <br/><br/><br/>
    </div>
            <br/><br/><br/>
</form> 
</body>
</html>
