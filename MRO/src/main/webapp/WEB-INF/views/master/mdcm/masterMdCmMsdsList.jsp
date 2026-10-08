<%--
**********************************************
* 메뉴 : 구매대행>상품관리>품질정보관리>MSDS 조회
* 화면 : MSDS 조회
* 기능 : MSDS 조회
* 프로그램 ID : 
* 담당자 :  최찬규
* 착수일 : 2020-03-26
**********************************************
--%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionUserId         = sessionInfo.getUserId();
	//수정, 삭제 버튼 권한
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("CM10",SessionUserId);
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"MSDS NO",	SaveName:"MSDS_NO",	FontColor:"#003694"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품명",		SaveName:"DESCRIPTION"  }
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION" }
		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제조사",		SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Date",	Header:"최종개정일",	SaveName:"LAST_REVISION_DATE"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제출번호",		SaveName:"MSDS_SUBMISSION_NUMBER"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"등록자",		SaveName:"ADD_USER_NM"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Date",	Header:"수정일",		SaveName:"CHANGE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"유해화학물질",	SaveName:"CMC_HARMFUL_YN"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO1",	SaveName:"CAS_NO_1"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO2",	SaveName:"CAS_NO_2"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO3",	SaveName:"CAS_NO_3"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO4",	SaveName:"CAS_NO_4"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO5",	SaveName:"CAS_NO_5"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO6",	SaveName:"CAS_NO_6"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO7",	SaveName:"CAS_NO_7"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO8",	SaveName:"CAS_NO_8"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO9",	SaveName:"CAS_NO_9"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO10",	SaveName:"CAS_NO_10"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO11",	SaveName:"CAS_NO_11"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO12",	SaveName:"CAS_NO_12"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO13",	SaveName:"CAS_NO_13"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO14",	SaveName:"CAS_NO_14"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO15",	SaveName:"CAS_NO_15"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO16",	SaveName:"CAS_NO_16"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO17",	SaveName:"CAS_NO_17"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO18",	SaveName:"CAS_NO_18"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO19",	SaveName:"CAS_NO_19"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO20",	SaveName:"CAS_NO_20"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet, "MSDS_NO");
	
}

// 기능함수
function doAction(str) {	
	
	var st_msds_no = TrimCommon($("#st_msds_no").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_submission_number = TrimCommon($("#st_submission_number").val());
	var st_cas_no = TrimCommon($("#st_cas_no").val());
	var st_maker_name = TrimCommon($("#st_maker_name").val());

	switch (str) {
	case "search":	 // 조회
		if(st_msds_no=="" &&st_description==""&&st_specification==""&&st_submission_number==""&&st_cas_no==""&&st_maker_name==""){ //값 입력 안하고 조회 누른 경우
			alert("조회조건을 입력해야 조회 가능합니다.");
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmMsdsList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_msds_no").val("");
		$("#st_description").val("");
		$("#st_specification").val("");
		$("#st_submission_number").val("");
		$("#st_cas_no").val("");
		$("#st_maker_name").val("");
		mySheet.RemoveAll();
		break;
	case "regMsds": //MSDS등록하기
		openSearchPopup("/coco/showCommonCoCoMsdsDetailRegPop.do","", "750,580,no"); //등록 팝업 호출
		break;
	case "excelDown": //엑셀다운로드
		if(st_msds_no=="" &&st_description==""&&st_specification==""&&st_submission_number==""&&st_cas_no==""&&st_maker_name==""){ //값 입력 안하고 엑셀다운로드 누른 경우
			alert("조건을 입력해야 다운로드 가능합니다.");
			return;
		}
		$("#pageflag").val('0');
		var param = {FileName:"MSDS리스트.xlsx"};
		kepDownExcel(document.searchCondition, mySheet , "/mdam/getMasterMdAmMsdsExcelList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {	
	return DATA;
}
//엑셀 다운로드 후 처리
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	if (msg != "") {
		alert(msg);
	}
	
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmMsdsList.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column == "MSDS_NO"){ // MSDS
		var st_msds_no = mySheet.GetCellValue(Row,"MSDS_NO");

		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+st_msds_no, "750,580,no");
	}
	return;
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>MSDS조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			
            	<table class="cont_t_list01" style="width:100%">
						<caption>MSDS 리스트</caption>
						<colgroup>
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
	                        <col width="25%" />
						</colgroup>
						<tbody>
							<tr>
								<th>MSDS NO</th>
								<td>
									<input type="text" class="input_type_text" id="st_msds_no" name="st_msds_no" style="width:80%;" value="" onkeydown="kepEnter()">
								</td>
								<th>품명</th>
								<td>
									<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" value="" onkeydown="kepEnter()">
								</td>	
								<th>규격</th>
								<td>
									<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:80%;" value="" onkeydown="kepEnter()">
								</td>
							</tr>
							<tr> 
								<td>MSDS 제출번호</td>
								<td>
									<input type="text" class="input_type_text"  name="st_submission_number" id="st_submission_number" style="width:80%;" value="" onKeyDown="kepEnter()"> 
								</td>
								<td>CAS NO</td>
								<td>
									<input type="text" class="input_type_text"  name="st_cas_no" id="st_cas_no" style="width:80%;" value="" onKeyDown="kepEnter()"> 
								</td>
								<td>제조사</td>
								<td>
									<input type="text" class="input_type_text"  name="st_maker_name" id="st_maker_name" style="width:80%;" value="" onKeyDown="kepEnter()"> 
								</td>
							</tr>
						</tbody>
					</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				<%if(getRoleYn == true){ %>
  				<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('regMsds');">MSDS등록하기</a></span>
  				</span>
  				<%}%>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
