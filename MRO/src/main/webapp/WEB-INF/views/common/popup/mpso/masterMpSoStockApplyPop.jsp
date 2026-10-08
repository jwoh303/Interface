<%--
**********************************************
* 메뉴 : 
* 화면 : 재고반영(재고생성)
* 기능 : 고객사와 협력사의 마감월이 상이 할 경우 재고데이터조정을 위한 화면
* 프로그램 ID : PG_06_M_002_04
* 담당자 : 개발1 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %> 
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
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
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 30,	EditLen : 50,Hidden:false}, 
	    			{Align : "Left",SaveName : "COM_NAME",		Header : "고객사",	Type : "Text",	Width : 145,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규 격",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "수 량",	Type : "Float",  Format:"${qtyFormat}",	Width : 35, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type:"Float",	Format:"${priceFormat}",Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AGENT_PRICE",		Header : "매입단가",	Type:"Float",	Format:"${priceFormat}",Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PRICE_SUM",		Header : "금 액", Type:"Float",	Format:"${priceFormat}",	Width : 60, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "GR_DATE",		Header : "입고일",	Type : "Date",	Width : 70,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "BUYER",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "PO_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "AGENT",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "GR_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "GR_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1}
	];
	initsheet.Cfg = {FrozenCol:0, ToolTip:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	var initsheet2 = {};
	initsheet2.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 30,	EditLen : 50,Hidden:true}, 
	    			{Align : "Left",SaveName : "COM_NAME",		Header : "고객사",	Type : "Text",	Width : 150,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 123, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 120, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SPECIFICATION",		Header : "규 격",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "수 량",	Type : "Float",  Format:"${qtyFormat}",	Width : 35, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type:"Float",	Format:"${priceFormat}",Width : 65, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AGENT_PRICE",		Header : "매입단가",	Type:"Float",	Format:"${priceFormat}",Width : 65, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PRICE_SUM",		Header : "금 액", Type:"Float",	Format:"${priceFormat}",	Width : 70, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "GR_DATE",		Header : "입고일",	Type : "Date",	Width : 70,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "BUYER",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "PO_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "GR_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "GR_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1},
	    			{Align : "Center",SaveName : "AGENT_CODE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:1}
	    			
	];
	initsheet2.Cfg = {FrozenCol:0, ToolTip:1};
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);

	// 제고반영일이 있을경우 셋팅
	kepSetCalenderYearMonth("st_stock_date");
	$("#st_stock_date").val( kepToMonthAdd("1","M").substring(0, 7));
	if("${param.st_stock_month}" != null && "${param.st_stock_month}" !=''){
		$("#st_stock_date").val("${param.st_stock_month}");
	}
	//재고반영일 기준(1:1차마감, 2:월말마감) 초기값이 존재할경우 셋팅
	if("${param.st_stock_check_flag}" !=null && "${param.st_stock_check_flag}" !=''){
		$("#st_stock_check_flag > option[value="+'${param.st_stock_check_flag}'+"]").attr("selected","true");
	}
	
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoStockApplyPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoStockApplyPop.do" , pagingMode );
			break;
		case "setGrStockV" : //재고반영
		//KEP2119043, KEP200499, KEP200116, KEP200012 사용자만 재고 생성 가능
	        var type = "";
	        if(document.forms.searchCondition.st_option[0].checked){
	              type = "TYPE_A";
	              document.forms.searchCondition.st_option[0].checked = "true";
            }else if(document.forms.searchCondition.st_option[1].checked){
	              type = "TYPE_B";
	              document.forms.searchCondition.st_option[1].checked = "true";
            }
	        document.forms.searchCondition.st_option_type.value = type;

			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if (selectedGrid == '' || arrRow.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}

		    var option_type = document.forms.searchCondition.st_option_type.value;
	        if(option_type == "")
	        {
	            alert("재고를 생성할 타입을 선택하여 주십시요.");
	            return;
	        }
	        kepSearch(document.searchCondition ,  mySheet2 , "/mpso/getMasterMpSoStockApplyPopDetail.do" , pagingMode );

	        break;
		case "setGrStockReg" : //재고생성
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			
			if(selectedGrid == '' || arrRow.length == 0){
				alert("재고반영 대상 항목이 없습니다."); return;
			}
			
			if ( !confirm('재고생성 하시겠습니까? ') )
				return;
			
			kepSave(document.searchCondition ,  mySheet2 , "/mpso/saveMasterMpSoStockApplyPopDetail.do", "SELECTED" );
	        break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}
function mySheet2_OnLoadData(DATA) {
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

	for(var i=1; i<=mySheet.RowCount();i++){
		mySheet.SetCellValue(i,"SELECTED", "1");
		$("#st_gr_no").val(mySheet.GetCellValue(i,"GR_NO"));
		$("#st_gr_seq").val(mySheet.GetCellValue(i,"GR_SEQ"));
	}
}

function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet2.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}

	for(var i=1; i<=mySheet.RowCount();i++){
		mySheet2.SetCellValue(i,"SELECTED", "1");
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoStockApplyPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
			kepConfirm();
	}
	return;
}

function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
// 	mySheet2.LoadSearchData(makeB2BData('${data}'));
}

function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	opener.setPopupReturn("","");
	this.close();

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
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="${param.st_po_no}">
	<input type="hidden" id="st_po_seq"  name="st_po_seq" value="${param.st_po_seq}">
	<input type="hidden" id="st_gr_no"  name="st_gr_no" value="">
	<input type="hidden" id="st_gr_seq"  name="st_gr_seq" value="">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">
	<input type="hidden" id="st_byit_comorg_code"  name="st_byit_comorg_code" value="${param.st_byit_comorg_code}">
	
	<input type="hidden" id="st_option_type"  name="st_option_type" value="${param.st_option_type}">

	<div id="popWrapper" style="height:410px;">
    	<div id="popHeader">
        	<h1 class="title">재고반영(재고생성)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
<!--             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div> -->
            <!--조회영역-->
<!--         	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="50px" />
							<col width="18%" />
							<col width="50px" />
							<col width="*" />
							
						</colgroup>
						
						<tbody>
						<tr>
							<td>부서</td>
							<td>
                  <label for="b_team" class="hidden">부서선택</label>
					  			<select name="b_team" id="b_team">
                		<option>전체</option>
                		<option>건설사업팀</option>
                        <option>수도사업팀</option>
                    </select>
                </td>
							<td>고객사</td>
							<td><input type="text" name="input4" id="input4" class="input_type_text" title="" style="width:100px;" /> <a href="#"><img src="/resources/images/btn_search03.gif" alt="검색" /></a></td>
						  </tr>
					</tbody>
				</table>
            </div> -->
            
            <!--grid 1-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "100px");
				</script>
			</div>
<!-- 			<div id="pageindex"></div> -->
			<div>
            	<table class="cont_t_list01" style="width:100%">
					<tr  bgcolor="#ECECEC">
					    <td height="50" colspan="2" style="padding-left:6px">
					      <input type="radio" name="st_option" value="TYPE_A" id="check">
					      고객사의 입고일이 익월로 반영되어 있으나 협력사는 당월에 처리하여야 하는 경우<br>
					      <input type="radio" name="st_option" value="TYPE_B" id="check">
					      고객사의 입고일이 당월로 처리되었지만 마감일 기준에 따라 이월되는 경우 (특정 고객사에만 해당)</td>
					  </tr>
					  <tr>
					  	<td style="padding-left:12px"><font color="#FF6600">*</font>재고반영일
					  		<input type="text" class="input_type_text" name="st_stock_date" id="st_stock_date" readOnly style="width:100px; text-align:center;" value="">
					  		<select name="st_stock_check_flag" id="st_stock_check_flag" >
						        <option value="1">1차마감</option>
						        <option value="2" selected>월말마감</option>
						      </select>
					  		</td>
					  		<td>
				  				<span class="fr">
									<span class="btn_02 "><a href="javascript:doAction('setGrStockV')">재고반영</a></span>
								</span>
					  		</td>
					  </tr>
				</table>			
			</div>
			
            <!--grid 2-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet2", "", "100px");
				</script>
			</div>
			
	        <!--버튼영역-->
	        <div class="btnArea">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('setGrStockReg')">생성</a></span>
				</span>
	       </div>
		</div>	
        
    </div>
</form> 
</body>
</html>
