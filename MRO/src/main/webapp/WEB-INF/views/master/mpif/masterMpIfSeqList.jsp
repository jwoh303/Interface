<%--
**********************************************
* 메뉴 : I/F 관리>대우조선>차수조회
* 화면 : 차수조회
* 기능 : 
* 프로그램 ID : PG_11_M_004_03
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",			SaveName:"sStatus"}
					,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"차수",			SaveName:"LEGACY_IV_SERIAL"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"송장번호",		SaveName:"INV_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"발주번호",		SaveName:"LEGACY_PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"행번",			SaveName:"LEGACY_PO_SEQ"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"발주",			SaveName:"ITEM_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"입고",			SaveName:"GR_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"납품",			SaveName:"INV_QTY"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"납폼유형",		SaveName:"PROCESS_TYPE"}
					,{ Align:"Left",	Width:260,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"협력사명",		SaveName:"AGENT"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"송장일",			SaveName:"INVOICE_DATE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"상태",			SaveName:"STATUS"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주생성일",	SaveName:"PO_CREATE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"납기요청일",	SaveName:"RD_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주번호",		SaveName:"PO_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"발주순번",		SaveName:"PO_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"송장수량",		SaveName:"IV_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"변경일",			SaveName:"CHANGE_DATE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"변경시간",		SaveName:"CHANGE_TIME"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"뱅송일",			SaveName:"DELIVERY_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"배송수량",		SaveName:"DELIVERY_QTY"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();

	switch (str) {
		case "search":	 // 조회
			if (kepTrimStr($("#st_legacy_iv_serial").val()) == "") {
				alert("관리번호를 입력해 주십시오!");
				$("#st_legacy_iv_serial").focus();
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfSeqList.do" , pagingMode );
			break;
	
		case "reload":	// 초기화
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
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfSeqList.do?page="+current_page , pagingMode );
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>차수조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>차수조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td><font color="red"><b>*</b></font> 관리번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_legacy_iv_serial" name="st_legacy_iv_serial" style="width:80%;" value="" onkeyup="kepToUpper('st_legacy_iv_serial')" onkeydown="kepEnter()"> 
							</td>
							<td>발주번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_legacy_po_no" name="st_legacy_po_no" style="width:80%;" value="" onkeyup="kepToUpper('st_legacy_po_no')" onkeydown="kepEnter()">
							</td>
							<td>발주행번</td>
							<td>
								<input type="text" class="input_type_text" id="st_legacy_po_seq" name="st_legacy_po_seq" style="width:80%;" value="" onkeydown="kepEnter()">
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
  				<span class="fr">
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
