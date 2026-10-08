<%--
**********************************************
* 메뉴 : 
* 화면 : 항목별 결과
* 기능 : 선택된 기간동안의 항목별 검사결과를 조회할 수 있다.그래프가2개
* 프로그램 ID : PG_07_M_006_01
* 담당자 : 손상민( 설계 : 김지현 )
* 착수일 : 2014-07-28
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
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태|상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "|",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사|협력사",	Type : "Text",	Width : 130,	EditLen : 110,Hidden:false, Edit : false, ToolTip:true},
	    			{Align : "Center",SaveName : "TOT_CNT",		Header : "총 감점\n점수|총 감점\n점수",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "APPEAR_VAL",		Header : "검사항목|외관",	Type : "AutoSum",	Format : "Integer", Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "APPEAR_VAL_CNT",		Header : "검사항목|외관",	Type : "Float",  Format:"${qtyFormat}",	 Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SIZE_VAL",		Header : "검사항목|사이즈",	Type : "AutoSum",	Format : "Integer", Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "SIZE_VAL_CNT",		Header : "검사항목|사이즈",	Type : "Float",  Format:"${qtyFormat}",	 Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MATTER_VAL",		Header : "검사항목|재질",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MATTER_VAL_CNT",		Header : "검사항목|재질",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "WEIGHT_VAL",		Header : "검사항목|중량",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "WEIGHT_VAL_CNT",		Header : "검사항목|중량",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "CAPACITY_VAL",		Header : "검사항목|용량",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "CAPACITY_VAL_CNT",		Header : "검사항목|용량",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DENSITY_VAL",		Header : "검사항목|두께",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DENSITY_VAL_CNT",		Header : "검사항목|두께",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "COMPRESSION_F",		Header : "검사항목|압축",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "COMPRESSION_F_CNT",		Header : "검사항목|압축",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DISRUPTION_F",		Header : "검사항목|파일강도",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "DISRUPTION_F_CNT",		Header : "검사항목|파일강도",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MOISTURE_F",		Header : "검사항목|수분",	Type : "AutoSum", Format : "Integer",	Width : 30, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MOISTURE_F_CNT",		Header : "검사항목|수분",	Type : "Float",  Format:"${qtyFormat}", 	Width : 30, EditLen : 110,	Edit : false, Hidden : false},

	    			
	    			{Align : "Center",SaveName : "RATE",		Header : "납기\n준수율|납기\n준수율",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RETRUN",		Header : "보류\n횟수|보류\n횟수",	Type : "Text",	Width : 80, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "AGENT",		Header : "협력사|협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	];
	
	
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:3};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");
// 	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsItemResultPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str, id) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
		    var term = $("#st_term").val();
		    var term_text = $("#st_term_text").val();
		     
		    if(term == "" || term_text == ""){
		        alert("해당 기간을 선택하여 주십시요");
		        return;
		    }
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsItemResultPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;

		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
			var param = {FileName:"항목별 결과.xls",Merge:1,SheetDesign:1,DownCols:"AGENT_NAME|APPEAR_VAL|SIZE_VAL|MATTER_VAL|WEIGHT_VAL|CAPACITY_VAL|DENSITY_VAL|COMPRESSION_F|DISRUPTION_F|MOISTURE_F|RATE|RETRUN|AGENT"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpds/excelMasterMpDsItemResultPop.do", param);
			$("#pageflag").val('1');
			break;
			
	}

}

function doPop(str,value1, value2, value3, value4, value5) {
	popupSel = str;
	
	switch (str) {
		case "commonCoCoTermChoicePop": // 기간선택
			var termType = $("#st_term_type").val();
			if(termType == 'ALL'){
				alert("기간 구분을 먼저 선택하십시오.");
				return;
			}else if(termType == 'Y'){
				termType = "year";
			}else if(termType == 'H'){
				termType = "half";
			}else if(termType == 'Q'){
				termType = "quarter";
			}else{
				termType = "month";
			}
	        
			openSearchPopup("/coco/showCommonCoCoTermChoicePop.do", "?st_row=text&st_gubun_code="+termType, "500,300,no");
			break;
			
		case "masterMpDsQualityCmplnOccurFactorDeductPop" : // 항목별 감점표
			openSearchPopup('/mpds/showMasterMpDsQualityCmplnOccurFactorDeductPop.do','','650,480,no');
			break;
			
		case "setGraphView1" : //그래프 (PIE)
		case "setGraphView2" : //그래프 (BAR)
		    if($("#st_term").val() == "" || $("#st_term_text").val() == ""){
		        alert("해당 기간을 선택하여 주십시요");
		        return;
		    }
		
			var fileName = "RD_06_S_001_86_dummy"; // 리포트파일 이름
			var st_com_code = $("#st_com_code").val();
			var st_from_date = $("#st_from_date").val();
			var st_to_date =$("#st_to_date").val();
			
			if(str == "setGraphView2"){
				fileName = "RD_06_S_001_87_dummy"; // 리포트파일 이름
			}
// 			alert(st_com_code+"::"+st_from_date+"::"+st_to_date);
			var param = "["+st_com_code+"]["+st_from_date+"]["+st_to_date+"]";// 파라미터
			reportOpen(fileName,param);
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

	var tot_sum = 0;

	for( var i = 2; i <= mySheet.RowCount()+1; i++ ) {
		tot_sum += mySheet.GetCellValue(i, "APPEAR_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "SIZE_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "MATTER_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "WEIGHT_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "CAPACITY_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "DENSITY_VAL_CNT");
		tot_sum += mySheet.GetCellValue(i, "COMPRESSION_F_CNT");
		tot_sum += mySheet.GetCellValue(i, "DISRUPTION_F_CNT");
		tot_sum += mySheet.GetCellValue(i, "MOISTURE_F_CNT");
		
		mySheet.SetCellValue(i, "TOT_CNT", tot_sum);
		tot_sum=0;
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
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsItemResultPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "AGENT_NAME" ){ 
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent,'800,550,no');
		
	}
	return;
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
//  	alert(value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	if(popupSel == "commonCoCoTermChoicePop"){
		$("#st_term").val(value1);
		$("#st_term_text").val(value5);
		$("#st_from_date").val(value2);
		$("#st_to_date").val(value3);
	}
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
	<input type="hidden" id="st_com_code"  name="st_com_code" value="${param.st_buyer_code}">
	
	<div id="popWrapper" style="height:434px;">
    	<div id="popHeader">
        	<h1 class="title">항목별 결과</h1>
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
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="15%" />
							<col width="30%" />
							<col width="*" />
						</colgroup>
						<tbody>
						<tr>
				      		<th>기간</th>
					       <td>
						       	<select id = "st_term_type" name = "st_term_type"  onchange="javascript:kepClear('st_term_text')">
						       		<option value = "ALL" selected>전체</option>
						            <option value = "Y">년</option>
						            <option value = "H">반기</option>
						            <option value = "Q">분기</option>
						            <option value = "M" >월</option>
						        </select>
					       </td>
					       <td>
						        <input type="text"  id="st_term_text" name="st_term_text"  style="width:80%" value="" readonly>
						        <input type="hidden" id="st_term" name="st_term"  value="" readonly><a href="javascript:doPop('commonCoCoTermChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
								<input type="hidden" id="st_from_date"  name="st_from_date" value="">
								<input type="hidden" id="st_to_date"  name="st_to_date"   value="">
					       </td>
					       <td></td>
						  </tr>
					</tbody>
				</table>
            </div>

			<table style="width:100%;">
				<tr>
					<td align="left">
						<span class="btn_05"><a href="javascript:doPop('masterMpDsQualityCmplnOccurFactorDeductPop');">항목별 감점표</a></span>
					</td>
		   		</tr>
			</table>
			            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "205px");
				</script>
			</div>
			<div id="pageindex"></div>
	        <!--버튼영역-->
	        <div class="btnArea mr25">
  				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀 다운로드</a></span>
  				</span>
	        
				<span class="fr">
					<span class="btn_05 mr04"><a href="javascript:doPop('setGraphView1');">그래프 보기(PIE)</a></span>
					<span class="btn_05 "><a href="javascript:doPop('setGraphView2');">그래프 보기(BAR)</a></span>
				</span>
	       </div>
		</div>	
    </div>
</form> 
</body>
</html>
