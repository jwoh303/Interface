<%--
**********************************************
* 메뉴 : wms>재고>조립부품>조립부품서생성
* 화면 : 조립 부품서
* 기능 : 조립품목 부품서 생성 팝업
* 프로그램 ID : PG_08_M_015_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-4
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
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var BUYER_ITEM_NO_list = "";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "CHECKED",	Header : "조립상품선택",	Type : "Radio",	Width : 100,	EditLen : 50,Hidden:false}, 
	    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden: false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "STC_SELLER_PRICE",		Header : "재고원가",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Left",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AVAIL_QTY",		Header : "현수량",	Type : "Float", Format:"Integer",		Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
		    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden: false, Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "st_assembly_qty",		Header : "부품수량 *",	Type : "Float", Format:"Integer",		Width : 100, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
		    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Left",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	];	
	initsheet2.Cfg = {MergeSheet2:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");
	
}


var st;
var mt;
//기능함수
function doAction(str) {

	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblCmpntsttmntCreationPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			mySheet2.RemoveAll();
			mySheet.RenderSheet(1);
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
		case "goBottom":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if(selectedGrid.length  == 0){
				alert("선택된 상품이 없습니다");
				return;
			}
			else
			{
				for(var i = 0 ; i <arrRow.length ; i++){
					BUYER_ITEM_NO_list  += mySheet.GetCellValue(arrRow[i], 'BUYER_ITEM_NO')+"@@";
				}
				$('#st_buyer_item_no_list').val(BUYER_ITEM_NO_list);
				kepSearch(document.searchCondition ,  mySheet2 , "/wmst/getMasterWmStAssmblCmpntsttmntCreationPopBot.do" , pagingMode );
			}
			break;
		case "goDel":
			var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");
			var arrRow2     = selectedGrid2.split("|");
			if(selectedGrid2.length  == 0){
				alert("선택된 상품이 없습니다");
				return;
			}
			for(var k=arrRow2.length-1; k>=0 ; k--){

				mySheet2.RowDelete(arrRow2[k], 0);
				BUYER_ITEM_NO_list = BUYER_ITEM_NO_list.replace(mySheet2.GetCellValue(arrRow2[k], 'BUYER_ITEM_NO')+"@@",'');
			}
			break;
		case "setBof":
			if(mySheet2.GetTotalRows() == 0 ){
				alert("부품 내역이 없습니다");
				return;
			}
			var selectedGrid = mySheet.FindCheckedRow("CHECKED");
			var arrRow     = selectedGrid.split("|");
			if(selectedGrid.length  == 0){
				alert("조립상품을 선택해 주세요");
				mySheet.SelectCell(1, 'CHECKED',1);
				return;
			}
			for(var i = 1 ; i <mySheet2.GetTotalRows()+1 ; i++){
				
				if(mySheet.GetCellValue(arrRow[0], 'BUYER_ITEM_NO') ==mySheet2.GetCellValue(i, 'BUYER_ITEM_NO') ){
					alert('선택하신 조립상품의 품목코드와 같은 품목코드가 존재 합니다..');
					mySheet2.SelectCell(i, 'BUYER_ITEM_NO',1);
					return;
				}
				
				if( 0==mySheet2.GetCellValue(i, 'st_assembly_qty') || ""==mySheet2.GetCellValue(i, 'st_assembly_qty')){
					alert("부품수량을 입력해주세요");
					mySheet2.SelectCell(i, 'st_assembly_qty',1);
					return;
				}

			}
			document.searchCondition.st_bom_id.value = mySheet.GetCellValue(arrRow[0], 'BUYER_ITEM_NO');
	 	 	kepSave(document.searchCondition ,  mySheet2 , "/wmst/saveMasterWmStAssmblCmpntsttmntCreationPopBot.do" , "BUYER_ITEM_NO"  );
			break;
	}

}

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if(code == 1){
		
		 alert("조립 부품서 등록을 완료 하였습니다.");
		 doAction('reload');
		 
	}else if(code == 2){
		
		alert("이미 등록된 조립상품 입니다.");
		return;
		
	}else{
	      alert("조립 부품서 등록을 실패 하였습니다.\n\n본사 기술연구소로 연락바랍니다.");
	      return;
	}
	
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
}


function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	

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



//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblCmpntsttmntCreationPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;

	return;
}


</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name=""st_user_id"" value="${sessionInfo.userId}">
    <input type="hidden" id="st_buyer_item_no_list"  name="st_buyer_item_no_list" value="">
    <input type="hidden" id="st_bom_id"  name="st_bom_id" value="">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">	
	
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">조립 부품서</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:528px;">
        	<!--버튼영역-->
            <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>

            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="8%" />
							<col width="25%" />
						</colgroup>
						
						<tbody>
				<tr>
					<th >표준코드</th >
					 <td ><input type="text" name="st_item_no" id="st_item_no"  style="width:80%"  onkeydown="kepEnter()"></td>
					 <th >재고유무</th>
					 <td style="width:80%">
						<input name="st_qty"  id="st_qty"  type="radio" value="ALL" checked> 전체 
						<input name="st_qty"  id="st_qty"  type="radio" value="Y">재고유 
						<input name="st_qty"  id="st_qty"  type="radio" value="N">재고무
					</td>
				</tr>
				<tr>
					<th>품목명</th>
					<td  ><input type="text" name="st_desc"  id="st_desc" style="width:80%"  onkeydown="kepEnter()"></td>
					<th>규격</th>
					<td colspan="3" ><input type="text" name="st_spec"  id="st_spec"  style="width:95%" onkeydown="kepEnter()"></td>
				</tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:150px">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "150px");
				</script>
			</div>
			<div id="pageindex"></div>		

 			<table align="center">
				<tr>
					<td height="50" >
  					<a href="javascript:doAction('goBottom');"><img src="/resources/images/arrow_move.gif" border="0"></a>&nbsp;&nbsp;&nbsp;
  					<a href="javascript:doAction('goDel');"><img src="/resources/images/arrow_cancel.gif"  border="0"></a>
					</td>
				</tr>
			</table>
 			<div style="border-top:2px solid #3c639c;height:150px">
				<script type="text/javascript">
					createIBSheet("mySheet2", "", "150px");
				</script>
			</div>
					<br/>	
			<span class="fr">
				<span class="btn_07 mr04"><a href="javascript:doAction('setBof');">조립부품서생성</a></span>		
			</span>				
		</div>

        
    </div>
</form> 
</body>
</html>
