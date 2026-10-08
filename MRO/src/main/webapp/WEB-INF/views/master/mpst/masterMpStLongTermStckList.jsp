<%--
**********************************************
* 메뉴 : 재고현황 모니터링 > 재고현황관리 > 재고현황 요약
* 화면 : 재고현황 요약
* 기능 :
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 김승우 )
* 착수일 : 2015-11-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	              	 { Align:"Center",	Width:100,	Edit:false,	EditLen:70,		Hidden:false,	Type:"Text",		Header:"구분|본부",		SaveName:"DIVISION_NAME",	ColMerge:1}
	              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"구분|사업팀코드",	SaveName:"TEAM_CODE",		ColMerge:0}
	              	,{ Align:"Center",	Width:110,	Edit:false,	EditLen:110,	Hidden:false,	Type:"Text",		Header:"구분|사업팀",	SaveName:"TEAM_NAME",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"정상재고|불변",	SaveName:"NORMAL_A",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"정상재고|가변",	SaveName:"NORMAL_B",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"정상재고|계",	SaveName:"NORMAL_AB",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"장기재고|불변",	SaveName:"LONG_A",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"장기재고|가변",	SaveName:"LONG_B",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"장기재고|계",	SaveName:"LONG_AB",			ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"불용재고|불변",	SaveName:"FAULTY_A",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"불용재고|가변",	SaveName:"FAULTY_B",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"불용재고|계",	SaveName:"FAULTY_AB",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"합계|불변",		SaveName:"TOT_AMT_A",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"합계|가변",		SaveName:"TOT_AMT_B",		ColMerge:0}
					,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"합계|계",		SaveName:"TOT_AMT_AB",		ColMerge:0}
];
	
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:0};
	
	var cfg = {MergeSheet:msHeaderOnly+msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(0);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "NORMAL_A");
	setLinkCol(mySheet, "NORMAL_B");
	setLinkCol(mySheet, "NORMAL_AB");
	setLinkCol(mySheet, "LONG_A");
	setLinkCol(mySheet, "LONG_B");
	setLinkCol(mySheet, "LONG_AB");
	setLinkCol(mySheet, "FAULTY_A");
	setLinkCol(mySheet, "FAULTY_B");
	setLinkCol(mySheet, "FAULTY_AB");
	setLinkCol(mySheet, "TOT_AMT_A");
	setLinkCol(mySheet, "TOT_AMT_B");
	setLinkCol(mySheet, "TOT_AMT_AB");
}

function myChart_init(){
	var maxRow = mySheet.RowCount();
	var sumRow = maxRow - 1;
	var rateRow = maxRow;
	var LongRateRow = maxRow + 1;
	
	// 차트에 사용할 데이터
	var normalSum	= mySheet.GetCellValue(sumRow,"NORMAL_AB");
	var longSum		= mySheet.GetCellValue(sumRow,"LONG_AB");
	var faultySum		= mySheet.GetCellValue(sumRow,"FAULTY_AB");
	
	var longASum		= mySheet.GetCellValue(sumRow,"LONG_A");
	var longBSum		= mySheet.GetCellValue(sumRow,"LONG_B");
	
	var count			= "";
	var rate				= "";
	
	var normalRate	= mySheet.GetCellValue(rateRow,"NORMAL_AB");
	var longRate		= mySheet.GetCellValue(rateRow,"LONG_AB");
	var faultyRate		= mySheet.GetCellValue(rateRow,"FAULTY_AB");
	
	var longARate		= mySheet.GetCellValue(LongRateRow,"LONG_A");
	var longBRate		= mySheet.GetCellValue(LongRateRow,"LONG_B");
	
	// 데이터 조회결과 ',' 제거 후 숫자형 변환(차트에서 숫자형 필요)
	var normalSum_num	= Number(normalSum.replace(/,/gi, ""));
	var longSum_num		= Number(longSum.replace(/,/gi, ""));
	var faultySum_num		= Number(faultySum.replace(/,/gi, ""));
	var longASum_num		= Number(longASum.replace(/,/gi, ""));
	var longBSum_num		= Number(longBSum.replace(/,/gi, ""));
	
	myChart.SetOptions({
		Chart:{
			Type:"pie",
			Options3d:{
				Enabled : true,
				Alpha : 75
			}
		},
		Title:{
			Text:"재고 합계현황",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:true,
			Shadow:true,
			Formatter:function(){
				if(this.point.name == "정상재고"){
					count	= normalSum;
					rate	= normalRate;
				}else if(this.point.name == "장기재고"){
					count	= longSum;
					rate	= longRate;
				}else if(this.point.name == "불용재고"){
					count	= faultySum;
					rate	= faultyRate;
				}
				return '<span style="color: #4572A7;background-color:#FDFDFD">' +  this.point.name + '</span><br/>' + count + '<br/>' + rate;
			},
			Style:{
				Color:"#000000",
				FontSize:"12px",
				FontWeight:"bold"
			}
		},
		plotOptions:{
			Pie:{
				Center : ["50%", "40%"],
				StartAngle : 30,
				Depth : 40,
				Size : 300,
				dataLabels: {
	                enabled: true,
	                //distance: -50,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포이트명: 포인트값)
	                	if(this.point.name == "정상재고"){
	                		count	= normalSum;
	    					rate	= normalRate;
	    				}else if(this.point.name == "장기재고"){
	    					count	= longSum;
	    					rate	= longRate;
	    				}else if(this.point.name == "불용재고"){
	    					count	= faultySum;
	    					rate	= faultyRate;
	    				}
	                	return count + '<br/>' + rate;
	                }
	            }
			}
		},
		series: [{
            data: [
                ["정상재고", normalSum_num],
                ["장기재고", longSum_num],
                ["불용재고", faultySum_num]
            ],
            showInLegend: true 
        }],
        legend: {
            align: 'center',
            verticalAlign: 'bottom',
            layout: 'horizontal'
        },
	});
	
	myChart1.SetOptions({
		Chart:{
			Type:"pie",
			Options3d:{
				Enabled : true,
				Alpha : 75
			}
		},
		Title:{
			Text:"장기재고 현황",
			Style:{
				Color:"#15498B",
				FontFamily:"Dotum",
				FontWeight:"bold"
			}
		},
		ToolTip:{
			Enabled:true,
			Shadow:true,
			Formatter:function(){
				if(this.point.name == "장기재고 불변"){
					count	= longASum;
					rate	= longARate;
				}else if(this.point.name == "장기재고 가변"){
					count	= longBSum;
					rate	= longBRate;
				}
				return '<span style="color: #4572A7;background-color:#FDFDFD">' +  this.point.name + '</span><br/>' + count + '<br/>' + rate;
			},
			Style:{
				Color:"#000000",
				FontSize:"12px",
				FontWeight:"bold"
			}
		},
		plotOptions:{
			Pie:{
				Center : ["50%", "40%"],
				StartAngle:60,
				Depth : 40,
				Size : 300,
				dataLabels: {
	                enabled: true,
	                //distance: -50,				//파이 영역위에 레이블 표시
	                formatter:function(){			//레이블 표시 방식 (시리즈 색상: 시리즈명 /n 포이트명: 포인트값)
	                	if(this.point.name == "장기재고 불변"){
	    					count	= longASum;
	    					rate	= longARate;
	    				}else if(this.point.name == "장기재고 가변"){
	    					count	= longBSum;
	    					rate	= longBRate;
	    				}
	                	return count + '<br/>' + rate;  
	                }
	            }
			}
		},
		series: [{
            data: [
                ["장기재고 불변", longASum_num],
                ["장기재고 가변", longBSum_num]
            ],
            showInLegend: true 
        }],
        legend: {
            align: 'center',
            verticalAlign: 'bottom',
            layout: 'horizontal'
        },
	});
	
	/* 아이비리더스 가이드(Pie 차트 버그) - 범례 클릭 사용하지 않기 위함(버그로 인한 의미없는 그리기 호출하기) */
	myChart.Draw(function(){
		myChart.SetPlotOptions({
			Pie:{
				animation:true
			}
		},1);
		setTimeout(function(){ myChart.Draw(); } , 10);
	});
	
	myChart1.Draw(function(){
		myChart1.SetPlotOptions({
			Pie:{
				animation:true
			}
		},1);
		setTimeout(function(){ myChart1.Draw(); } , 10);
	});
	
	myChart.Draw();
	myChart1.Draw();
}
// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		//kepSearch()
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mpst/getMasterMpStLongTermStckList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		myChart.RemoveAll();
		myChart1.RemoveAll();
		break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_dept = mySheet.GetCellValue(Row,"TEAM_CODE");
	
	if ( Row  < 1)
		return;
	
	// 컬럼에 따른 팝업 조회 파라미터 세팅
	if(st_dept != null && st_dept != ""){
		if(column == 'NORMAL_A'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"A"+"&st_long_term_type="+"N", "1080, 550, no");
		}else if(column == 'NORMAL_B'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"B"+"&st_long_term_type="+"N", "1080, 550, no");
		}else if(column == 'NORMAL_AB'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"ALL"+"&st_long_term_type="+"N", "1080, 550, no");
		}else if(column == 'LONG_A'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"A"+"&st_long_term_type="+"L", "1080, 550, no");
		}else if(column == 'LONG_B'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"B"+"&st_long_term_type="+"L", "1080, 550, no");
		}else if(column == 'LONG_AB'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"ALL"+"&st_long_term_type="+"L", "1080, 550, no");
		}else if(column == 'FAULTY_A'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"A"+"&st_long_term_type="+"F", "1080, 550, no");
		}else if(column == 'FAULTY_B'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"B"+"&st_long_term_type="+"F", "1080, 550, no");
		}else if(column == 'FAULTY_AB'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"ALL"+"&st_long_term_type="+"F", "1080, 550, no");
		}else if(column == 'TOT_AMT_A'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"A"+"&st_long_term_type="+"ALL", "1080, 550, no");
		}else if(column == 'TOT_AMT_B'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"B"+"&st_long_term_type="+"ALL", "1080, 550, no");
		}else if(column == 'TOT_AMT_AB'){
			openSearchPopup("/mpst/showMasterMpStLongTermStckDetailPop.do","?st_dept="+st_dept+"&st_group_type="+"ALL"+"&st_long_term_type="+"ALL", "1080, 550, no");
		}		
	}
	
	return;
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
} 
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
	
	// 조회 데이터를 기반으로 차트 그리기
	myChart_init();
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

/* 아이비리더스 가이드(Pie 차트 버그) - 범례 클릭 사용하지 않기 위함 */
function myChart_OnLegendItemClick(Index, Name) {
    return false;
}
function myChart1_OnLegendItemClick(Index, Name) {
    return false;
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}

</script>
</head>
<body onload="kep_onload_view(); doAction('search');">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고현황 요약</h3>
			(단위 : 천원)
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
        	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>  
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
		</form>

      	<!--grid-->
      	<div class="ib_product" style="border-top:2px solid #3c639c">
	      	<script type="text/javascript">
	      	createIBSheet("mySheet", "100%", "300px");
			</script>
		</div>

		<b>-불변 그룹 : 체류 경과기간에 관계없이 판매 가능한 제품 그룹</b>
		<br>
		<b>-가변 그룹 : 체류 기간에 따라 품질이상이 발생할 수 있는 제품 그룹</b>
		<br>
		
		<div style="width:100%;height:300px;">
			<div style="width:572px;height:100%;float:left">
				<div class="ib_products">
					<script type="text/javascript">
						createIBChart("myChart", "572px", "280px");
	                </script>
           		</div>
			</div>
			<div  style="width:572px;height:100%;float:left">
           		<div class="ib_products">
	                <script type="text/javascript">
						createIBChart("myChart1", "572px", "280px");
	                </script>
				</div>
			</div>
        </div>
<!--내용 종료-->	                 
</body>
</html>
