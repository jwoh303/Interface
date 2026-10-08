<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>


<script src="/resources/js/common.js"></script>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var masterKey1 = "";
function kep_onload_view() {
	// 년도 세팅
	var date = new Date();
	var selYear = date.getFullYear();
	getYears(selYear);	
	
	// 월 세팅
	getMonth("fromMonth");
	getMonth("toMonth");
	
	var initsheet = {};

	// 시트 및 헤더 머지, 전체 데이터를 기준으로 머지
	initsheet.Cfg = {MergeSheet:7, PrevColumnMergeMode:0, FrozenCol:7};
	initsheet.HeaderMode = {Sort:1};
	initsheet.Cols = [
		{SaveName:"DEPT_NM", 						Header:"부서명|부서명",			Type:"Text",		Edit:false,	Width:130,			Align:"Center"},
   		{SaveName:"D_BUYER_NM", 					Header:"고객사|고객사",			Type:"Text",		Edit:false,	Width:200,			Align:"Center"},
   		{SaveName:"SALE_GUBUN", 					Header:"매출구분|매출구분",		Type:"Text",		Edit:false,	Width:80,			Align:"Center"},
   		{SaveName:"TYPE_GUBUN", 					Header:"구분|구분",				Type:"Text",		Edit:false,	Width:80,			Align:"Center"},
   		{SaveName:"A_AMT", 							Header:"누계|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT", 							Header:"누계|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE", 						Header:"누계|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT01", 						Header:"1월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT01", 						Header:"1월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE01", 						Header:"1월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT02", 						Header:"2월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT02", 						Header:"2월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE02", 						Header:"2월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT03", 						Header:"3월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT03", 						Header:"3월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE03", 						Header:"3월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT04", 						Header:"4월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT04", 						Header:"4월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE04", 						Header:"4월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT05", 						Header:"5월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT05", 						Header:"5월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE05", 						Header:"5월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT06", 						Header:"6월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT06", 						Header:"6월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE06", 						Header:"6월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT07", 						Header:"7월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT07", 						Header:"7월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE07", 						Header:"7월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT08", 						Header:"8월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT08", 						Header:"8월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE08", 						Header:"8월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT09", 						Header:"9월|계획",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT09", 						Header:"9월|실적",				Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE09", 						Header:"9월|달성률(%)",			Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT10", 						Header:"10월|계획",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT10", 						Header:"10월|실적",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE10", 						Header:"10월|달성률(%)",		Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT11", 						Header:"11월|계획",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT11", 						Header:"11월|실적",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE11", 						Header:"11월|달성률(%)",		Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"A_AMT12", 						Header:"12월|계획",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"B_AMT12", 						Header:"12월|실적",			Type:"Float",		Edit:false,	Width:100,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"C_RATE12", 						Header:"12월|달성률(%)",		Type:"Float",		Edit:false,	Width:70,			Align:"Right", Format:"#,##0.##"},
   		{SaveName:"D_BUYER", 						Header:"고객사코드|고객사코드",		Type:"Text",		Edit:false,	Width:130,			Align:"Center",		Hidden:true},
   		{SaveName:"GUBUN_CODE", 					Header:"구분코드|구분코드",		Type:"Text",		Edit:false,	Width:130,			Align:"Center",		Hidden:true},
   		{SaveName:"LEVEL_NO", 						Header:"범위|범위",				Type:"Text",		Edit:false,	Width:130,			Align:"Center",		Hidden:true}
   		
   		
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	
	kepAjaxCommonQueryIdCombo('st_user_dept','master.mpst.getAllDeptList','ALL', 'ALL'); 
	
	//var info = [ {StdCol:"D_BUYER_NM",SumCols:"A_AMT|B_AMT",CaptionCol:1 }, {StdCol:"SALE_GUBUN",SumCols:"A_AMT|B_AMT",CaptionCol:1 }, {StdCol:"TYPE_GUBUN", SumCols:"A_AMT|B_AMT", ShowCumulate:1, CaptionCol:2, OtherColText:"0=%s;1=%s"}  ]; 
	
	/*
	mySheet.ShowSubSum([
	    {"StdCol":0},
	    {"StdCol":1},
		{"StdCol":2,
		 "SumCols":"3|4|6|7|9|10|12|13|15|16|18|19|21|22|24|25|27|28|30|31|33|34|36|37",
		 "Sort":0,
		 "CaptionCol":2,
		 "OtherColText":"0=%s;1=%s",
		 "Position":"bottomAll"}
	]);
	*/
	
	//mySheet.ShowSubSum(info);
	
}


function getYears(getY) {
	$("#year option").remove();
	
	var enY = Number(getY)-5;
	for(var i=getY; i>=enY; i--) {
		if(i==getY) {
			$("#year").append("<option value='"+i+"' selected>"+i+" 년" + "</option>");
		}else {
			$("#year").append("<option value='"+i+"'>"+i+" 년" + "</option>");	
		}		
	}
}

function getMonth(setbox) {
	$("#"+setbox + " option").remove();
	
	for(var i=1; i<=12; i++) {
		if(String(i).length == '1') {
			if(setbox == 'fromMonth' && i==1) {
				$("#"+setbox).append("<option value='"+"0"+i+"' selected>"+"0"+i+" 월"+"</option>");
			}else {
				$("#"+setbox).append("<option value='"+"0"+i+"'>"+"0"+i+" 월"+"</option>");
			}
		}else {
			if(setbox == 'toMonth' && i==12) {
				$("#"+setbox).append("<option value='"+i+"' selected>"+i+" 월"+"</option>");	
			}else {
				$("#"+setbox).append("<option value='"+i+"'>"+i+" 월"+"</option>");
			}
			
		}
	}
}

//기능함수
function doAction(str) {
	switch (str) {
	case "search":	// 조회
		var fromMonth = $("#fromMonth option:selected").val();
		var toMonth = $("#toMonth option:selected").val();
		
		if(Number(fromMonth) > Number(toMonth)) {
			alert("시작월을 종료월보다 더 크게 할 수 없습니다.");
			return;
		}
	
		doSearch();	
		break;
	case "reload":	// 초기화
		kepReload('searchForm');
		mySheet.RemoveAll();
		
		// 부서 세팅
		$("#dept option:eq(0)").attr("selected", "selected");
		
		// 년도 세팅
		var date = new Date();
		var selYear = date.getFullYear();
		getYears(selYear);	
		
		// 월 세팅
		getMonth("fromMonth");
		getMonth("toMonth");
		
		break;
		
	case "excelDown": // 엑셀다운로드
		excelDown();
		break;
	}
	
}

function doSearch(){
	stdDate = new Date();
	mySheet.RemoveAll();	
	kepSearch(document.searchForm, mySheet, "/mpst/getMasterPerformanceList.do", pagingMode);
	
}

function excelDown() {
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	var param = {FileName:'실적_'+nowTime, SheetName:'실적', Merge:1,SheetDesign:1};
	mySheet.Down2Excel(param);
}

//IBSHEET 로딩 후 처리 함수
function mySheet_OnSearchEnd(code, msg, stCode) {
	// 로딩창 해제
	loader_obj("N");
	
	var rowCnt = 0;
	var priceSum = 0;
	
	rowCnt = mySheet.RowCount();
	
	for(var i=0;i<=rowCnt+1;i++) {
		// if(mySheet.GetCellValue(i, "SALE_GUBUN") == "계") {
			// mySheet.SetRowBackColor(i, "#F0EC79"); 속도문제로 주석 처리
		// }
		if(mySheet.GetCellValue(i, "SALE_GUBUN") == "누계") {
			mySheet.SetRowBackColor(i, "#F7C6B9");
		}
		
		mySheet.SetCellFontBold(i,"SALE_GUBUN", true);
	}
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod, response) {	
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod, response) {
}

function getDept() {	
	var year = document.getElementById('year').value;
	kepAjaxCommonQueryIdSearchCombo('st_user_dept','master.mpst.getAllDeptList', year, 'ALL', 'ALL');
}

</script>
</head>
<body onload="kep_onload_view();" style="overflow-x:hidden; overflow-y:scroll;">
		<div id="searchBtnA"  >
			<h3>경영실적통계</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>
    <!--조회영역-->      
      	<form name="searchForm" id="searchForm" method="post">
      	<div id="cont_searchA">      	
      	<input type="hidden" name="s_SAVENAME"/> 		
			<input type="hidden" id="customerCodeDtl" name="customerCodeDtl"  value="" />
            <table  class="cont_t_list01" >
            <caption>경영실적통계</caption>
                <colgroup>
                    <col width="2%" />
				    <col width="10%" />
				    <col width="5%" />
				    <col width="20%" />
				    <col width="5%" />
				    <col width="15%" />
				    <col width="*" />                                        
                </colgroup>
                <tbody>
               <tr>      
                    <th style="width: 5px;">년</th>
                    <td ><select onchange="getDept()"  name="year" id="year" style="width:70%;" >
                    </select></td>
                    <th style="text-align: right; padding-right: 5px;">월</th>
                    <td ><select id="fromMonth" name="fromMonth" style="width:30%" >
                    </select> ~ <select id="toMonth" name="toMonth" style="width:30%" >
                    </select></td>                    
                    <th style="text-align: right; padding-right: 5px;">부서</th>
               		<td><select id="st_user_dept" name="st_user_dept" >               			 
               		</select></td>  
               		<td></td>
                </tr>
                </tbody>
            </table>
        </div>
        </form>
        
        <div class="ListBoxScroll" style="height:550px;" >
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "550px");
			</script>
    	</div>
    	
    	<div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  			 </div>
    	
	</div><!-- 컨텐츠 Contents 끝-->
</div>

</body>
</html>