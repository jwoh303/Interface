<%--
**********************************************
* 메뉴 : 구매대행>카탈로그>판촉물 전용 카탈로그 > 판촉물 On_Line견적 관리
* 화면 : 판촉물 On_Line견적 관리
* 기능 : 
* 프로그램 ID : PG_03_M_008_00
* 담당자 : 카탈개 ( 설계 : 권우재 )
* 착수일 : 2014-
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

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:67,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:99,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"의뢰번호",	SaveName:"RFQ_NO"}
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"의뢰일",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"처리일",	SaveName:"RECV_DATE"}
					,{ Align:"Center",	Width:245,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"의뢰사",	SaveName:"ADD_COMPANY"}  
					,{ Align:"Center",	Width:111,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"의뢰자",	SaveName:"ADD_USER_NAME"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상품코드",	SaveName:"ITEM_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"처리자",	SaveName:"RECV_USER_NAME"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "RFQ_NO");	//요청자
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmPromotionOnlineReqList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			
			kepReload('searchCondition');
			mySheet.RemoveAll();
			
			break;

	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
//조회 후처리
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
	


	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg) {
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmPromotionOnlineReqList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(Col);
	
	if (column == 'RFQ_NO') { // 요청자
		var ITEM_NO = mySheet.GetCellValue(Row,"ITEM_NO");
		var RFQ_NO = mySheet.GetCellValue(Row,"RFQ_NO");

		openSearchPopup("/mdcm/getMasterMdCmItemDetailInfoViewPop.do","?ITEM_NO="+ITEM_NO+"&RFQ_NO="+RFQ_NO,"988,768,yes");
		popupSel = "itemDetailInfoView";
		
	}
	return;
}
	
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>판촉물 On_Line견적 관리</h3>
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
			<!-- 화면 내 정의 -->
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>판촉물 On_Line견적 관리</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
				          <td class="bg1">
				            <table width="100%" border="0" cellspacing="1" cellpadding="1">
				              <tr>
				                <td>조회일자</td>
								<td colspan="3">
									<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
										<a href="javascript:kepCalendar('st_from_date')"></a>
									&nbsp;~&nbsp;
									<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
										<a href="javascript:kepCalendar('st_to_date')"></a>
										&nbsp;&nbsp;
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								</td>
				                <td height="25" width="74" class="title03">상품코드</td>
				                <td height="25" width="266" class="bg2" align="center">
				                  <input type="text" id="st_item_no" name="st_item_no" style="width:87%" value="" onKeyUp="kepToUpper('st_item_no')" onKeyDown="kepEnter()">
				                </td>
				              </tr>
				              <tr>
				                <th>의뢰사</th>
				                <td>
				                  <input type="text" id="st_add_company" name="st_add_company" style="width:87%;ime-mode:active" value="" onKeyDown="kepEnter()">
				                </td>
				                <th>의뢰자명</th>
				                <td>
				                  <input type="text" id="st_add_user_name" name="st_add_user_name" style="width:87%;ime-mode:active" value="" onKeyDown="kepEnter()">
				                </td>
				                <th>상태</th>
				                <td>
				                  <input type="radio" class="Noborder" id="st_status1" name="st_status" value=""  class="Noborder" checked="checked">전체&nbsp;
				                  <input type="radio" class="Noborder" id="st_status2" name="st_status" value="C" class="Noborder" >의뢰&nbsp;
				                  <input type="radio" class="Noborder" id="st_status3" name="st_status" value="R"  class="Noborder">처리
				                </td>
				              </tr>
				            </table>
				          </td>
				        </tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>10건</option>
					<option value="100">20건</option>
					<option value="500">30건</option>
					<option value="500">40건</option>
					<option value="500">50건</option>					
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
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
