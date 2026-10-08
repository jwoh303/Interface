<%--
**********************************************
* 메뉴 : 상품관리>표준 카탈로그 관리>CMS매핑
* 화면 : CMS매핑
* 기능 : 
* 프로그램 ID : PG_03_M_005_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-04
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
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					 ,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:110,	Type:"Text",	Header:"순번",	SaveName:"SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"} 
					,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사_품목코드",	SaveName:"BUYER_ITEM_NO"} 
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사_품목명",	SaveName:"BUYER_DESC"} 
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사_규격",	SaveName:"BUYER_SPEC"} 
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사_제조사코드",	SaveName:"BUYER_MAKER_CODE"} 
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"고객사_제조사명",	SaveName:"BUYER_MAKER_NAME"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"고객사_원산지",	SaveName:"BUYER_ORIGIN_CODE"}
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID"} 
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STD_FLAG"} 
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"표준카탈로그품명",	SaveName:"CMS_DESC"} 
					,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"표준카탈로그규격",	SaveName:"CMS_SPEC"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"표준카탈로그제조사명",	SaveName:"CMS_MAKER_NAME"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"표준카탈로그제조사코드",	SaveName:"CMS_MAKER_CODE"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"표준카탈로그원산지",	SaveName:"CMS_ORIGIN_CODE"} 
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"표준카탈로그담당자ID",	SaveName:"USER_ID"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"참조매핑여부",	SaveName:"REFER_MAPPING_FLAG"}  	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:6};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

}
	
	

// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var maxRow = mySheet.RowCount();

	// 선택된 항목 유무 체크
	if (str =="del" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		//kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCmsMapppingList.do" , pagingMode );
		//kepSearch()
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mdcm/getMasterMdCmCmsMapppingList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;

	case "save": // 저장
	
		for(var i=1;i<=maxRow;i++){
			if(mySheet.GetCellValue(i,"BUYER_DESC") ==""){
				alert("고객사 코드 미존재건입니다. \n\n다시 확인 바랍니다.");
				return;
			}

			if(mySheet.GetCellValue(i,"STD_FLAG") ==""){
				alert("CMS코드 미존재건입니다. \n\n다시 확인 바랍니다.");
				return;
			}			

/* 			if(mySheet.GetCellValue(i,"STD_FLAG")  !="Y" && mySheet.GetCellValue(i,"STD_FLAG") !="PASS" && mySheet.GetCellValue(i,"STD_FLAG") !="TALK"){
				alert("CMS코드 상태가 미표준화 상태입니다. \n\n다시 확인바랍니다.");
				return;
			} */
		}
		
		var wms_check_flag = $("#wms_check_flag").val();
		if( wms_check_flag == "N"){
			alert("WMS 관련 검증을 해주셔야 합니다.");
			return;
		}
		
		if (!confirm('CMS 카탈로그 맵핑 하시겠습니까?')){
			return;
		}else{
			kepAjaxFormCall("/mdcm/saveMasterMdCmCmsMapppingList.do","searchCondition","CMSMAPPINGSAVE");
		}
		
		break; 

	case "excelDown": // 엑셀다운로드
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		var param = {FileName:"CMS매핑.xls",Merge:1,SheetDesign:1,DownCols:"SEQ|BUYER|BUYER_ITEM_NO|BUYER_DESC|BUYER_SPEC|BUYER_MAKER_CODE|BUYER_MAKER_NAME|BUYER_ORIGIN_CODE|CMS_CATLG_ID|STD_FLAG|CMS_DESC|CMS_SPEC|CMS_MAKER_NAME|CMS_MAKER_CODE|CMS_ORIGIN_CODE|USER_ID|REFER_MAPPING_FLAG"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmCmsMapppingList.do", param);

		break;
		
	case "del":	//삭제
	
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
		
		if (!confirm("선택된 내역을 삭제 하시겠습니까?  ")) {
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCmsMapppingList.do" , "SELECTED" );	
		}		
		
		break;	
		
	case "loadExcel": // 파일 업로드
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1|2||||||3|||||||4|5"};
		mySheet.LoadExcel(params);
	  	
		break;
	}
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
	if(!checkedSession(stCode)){return;}	

   	
	
	$("#wms_check_flag").val("N");
	if (msg != "") {
		alert(msg);
	}
	

}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	$("#wms_check_flag").val("N");
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCmsMapppingList.do" , "SELECTED" );
}


// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMdCmWmsCheckPop": // WMS검증
			
			openSearchPopup("/mdcm/getMasterMdCmWmsCheckPop.do", '?st_site='+$("#st_site option:selected").val(), "900,450,no");
			
			break;
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMdCmWmsCheckPop") {	// WMS검증
		$("#wms_check_flag").val(value1);
	}
 	
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준카탈로그매핑</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="wms_check_flag" name="wms_check_flag" value="N">
			
            	<table  class="cont_t_list01" >
					<caption>표준카탈로그매핑</caption> 
					<colgroup> 
						<col width="10%" /> 
						<col width="25%" />
						<col width="25%" />
                        <col width="*" />
					</colgroup>
					<tbody>
						<tr> 
							<td>사이트 선택</td>
							<td>
								<select id="st_site" name="st_site">
									<option value="KA" selected>KOREAB2B</option>
									<!--  <option value="KM">KEPMRO</option>
									<option value="SA">건설MRO</option>-->
								</select>
							</td>
							<td></td>
							<td></td>
						</tr> 
					</tbody>
				</table>
            </div>
            
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
               <div class="btnArea">
				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">일괄업로드</a></span>
  					<span class="btn_04"><a href="/resources/excel/work/CATALOG/masterMdCmCmsMappping.xls">등록양식</a></span>
  				</span>

  	          	<span class="fr">
  					<span class="btn_04 mr04" style="display:none"><a href="javascript:doAction('excelDown');">다운로드</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doPop('masterMdCmWmsCheckPop');">WMS검증</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_05"><a href="javascript:doAction('save');"> 표준카탈로그매핑</a></span>
  				</span> 
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
