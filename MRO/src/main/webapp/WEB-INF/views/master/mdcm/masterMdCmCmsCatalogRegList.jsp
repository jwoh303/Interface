<%--
**********************************************
* 메뉴 : 상품관리>표준 카탈로그 관리>CMS카탈로그 등록
* 화면 : CMS카탈로그 등록
* 기능 : 
* 프로그램 ID : PG_03_M_006_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-08
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

var manageDept = KepSheetComboQueryIdData('getKepDeptList','SEL','');	// IBSHEET : 담당부서

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:110,	Type:"Text",	Header:"순서",	SaveName:"SEQ"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:10,	Type:"Text",	Header:"CMS카탈로그ID",	SaveName:"CMS_CATLG_ID"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:20,	Type:"Text",	Header:"CMS카테고리ID",	SaveName:"CMS_CATEG_ID" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:200,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:25,	Type:"Text",	Header:"표준품목명",	SaveName:"DESCRIPTION_LOC" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:25,	Type:"Text",	Header:"표준품목명(영문)",	SaveName:"DESCRIPTION_ENG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"대표규격",	SaveName:"REP_SEPCIFICATION" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:200,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:10,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:20,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME" ,BackColor:"${optColor}"} 
					,{ Align:"Left",	Width:50,	Edit:true,	EditLen:2,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_CODE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:50,	Edit:true,	EditLen:4,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성1",	SaveName:"ATTB1_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성2",	SaveName:"ATTB2_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성3",	SaveName:"ATTB3_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성4",	SaveName:"ATTB4_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성5",	SaveName:"ATTB5_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성6",	SaveName:"ATTB6_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성7",	SaveName:"ATTB7_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성8",	SaveName:"ATTB8_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성9",	SaveName:"ATTB9_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성10",	SaveName:"ATTB10_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성11",	SaveName:"ATTB11_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성12",	SaveName:"ATTB12_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성13",	SaveName:"ATTB13_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성14",	SaveName:"ATTB14_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성15",	SaveName:"ATTB15_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성16",	SaveName:"ATTB16_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성17",	SaveName:"ATTB17_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성18",	SaveName:"ATTB18_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성19",	SaveName:"ATTB19_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:150,	Type:"Text",	Header:"속성20",	SaveName:"ATTB20_NM" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:8,	Type:"Text",	Header:"조달일수",	SaveName:"DELIVERY_LT" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:2,	Type:"Text",	Header:"상품구분",	SaveName:"ITEM_GUBUN" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:2,	Type:"Text",	Header:"자재그룹",	SaveName:"ITEM_GROUP" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:2,	Type:"Text",	Header:"등록유형",	SaveName:"ONOFF_TYPE" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:2,	Type:"Text",	Header:"표준화여부",	SaveName:"STD_FLAG" ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:120,	Edit:true,	EditLen:200,	Type:"Text",	Header:"REMARK",	SaveName:"REMARK" ,BackColor:"${optColor}"}
					,{ Align:"Right",	Width:120,	Edit:true,	EditLen:17,	Type:"Float",	Format:"${priceFormat}",	Header:"표준단가",	SaveName:"CMS_PRICE" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:120,	Edit:true,	EditLen:120,	Type:"Combo",	Header:"팀코드",	SaveName:"KEP_DEPT" ,BackColor:"${optColor}", ComboText:manageDept.ComboText, 	ComboCode:manageDept.ComboCode}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:80,	Type:"Text",	Header:"그룹유형",	SaveName:"STOCK_GROUP_TYPE" ,BackColor:"${optColor}"}
					];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:1,ColMove:0,ColResize:1,HeaderCheck:1};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

}
	
	

// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	var maxRow = mySheet.RowCount();
	// 선택된 항목 유무 체크
	if ((str =="del" || str =="save") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		//kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCmsCatalogRegList.do" , pagingMode );
		//kepSearch()
		IBS_SaveName(document.searchCondition,mySheet);
		//조회조건 묶기
		var param = FormQueryStringEnc2(document.searchCondition);
		//조회
		mySheet.DoSearch("/mdcm/getMasterMdCmCmsCatalogRegList.do", param);
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;

	case "save": // 저장

		for(var i=0; i<arrRow.length; i++){

			if(mySheet.GetCellValue(arrRow[i],"CMS_CATLG_ID") != ""){
				alert("이미 등록된 상품 입니다");
				return;
			}
			
			if(mySheet.GetCellValue(arrRow[i],"CMS_CATEG_ID") == ""){
				alert("표준카테고리를 입력 해주세요");
				return;
			}
			
			if(mySheet.GetCellValue(arrRow[i],"STATUS") != "C"){
				alert("상태값을 C로 입력 해주세요");
				return;
			}
			
			if(mySheet.GetCellValue(arrRow[i],"DESCRIPTION_LOC")==""){
				alert("품명을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"REP_SEPCIFICATION")==""){
				alert("대표규격을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"SPECIFICATION")==""){
				alert("전체규격을 입력 해주세요");
				return;
			}	

			if(mySheet.GetCellValue(arrRow[i],"MAKER_CODE")==""){
				alert("제조사코드를 입력 해주세요");
				return;
			}	

			if(mySheet.GetCellValue(arrRow[i],"MAKER_NAME")==""){
				alert("제조사명을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"ORIGIN_CODE")==""){
				alert("원산지를 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"ORDER_MEASURE")==""){
				alert("단위를 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"ITEM_GUBUN")==""){
				alert("상품구분을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"ITEM_GROUP")==""){
				alert("자재구분을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"ONOFF_TYPE")==""){
				alert("등록유형을 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"STD_FLAG")==""){
				alert("표준화여부를 입력 해주세요");
				return;
			}

			if(mySheet.GetCellValue(arrRow[i],"STD_FLAG")==""){
				alert("표준화여부를 입력 해주세요");
				return;
			}
		}
		
		if (!confirm('CMS 카탈로그 등록 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMdCmCmsCatalogRegList.do" , "SELECTED" );
		}
		
		break; 

	case "excelDown": // 엑셀다운로드
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.  ");
			return;
		}
		
		var param = {FileName:"CMS카탈로그등록.xls",Merge:1,SheetDesign:1,DownCols:"SEQ|CMS_CATLG_ID|CMS_CATEG_ID|STATUS|DESCRIPTION_LOC|DESCRIPTION_ENG|REP_SEPCIFICATION|SPECIFICATION|MAKER_CODE|MAKER_NAME|ORIGIN_CODE|ORDER_MEASURE|ATTB1_NM|ATTB2_NM|ATTB3_NM|ATTB4_NM|ATTB5_NM|ATTB6_NM|ATTB7_NM|ATTB8_NM|ATTB9_NM|ATTB10_NM|ATTB11_NM|ATTB12_NM|ATTB13_NM|ATTB14_NM|ATTB15_NM|ATTB16_NM|ATTB17_NM|ATTB18_NM|ATTB19_NM|ATTB20_NM|DELIVERY_LT|ITEM_GUBUN|ITEM_GROUP|ONOFF_TYPE|STD_FLAG|REMARK|CMS_PRICE|TEAM_CODE|GROUP_TYPE"};
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmCmsCatalogRegList.do", param);

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
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterMdCmCmsCatalogRegList.do" , "SELECTED" );	
		}		
		
		break;	
		
	case "loadExcel": // 파일 업로드
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42"};
		mySheet.LoadExcel(params);
	  	
		break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {

	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
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

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();
	if(maxRow == 0){
		  return;
	}
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mdcm/batchMasterMdCmCmsCatalogRegList.do" , "SELECTED" );
}


	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>CMS카탈로그 등록</h3>
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
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
               <div class="btnArea">
				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">File Upload</a></span>
  					<span class="btn_04"><a href="/resources/excel/work/CATALOG/masterMdCmCmsCatalogReg.xls">등록양식</a></span>
  				</span>

  	          	<span class="fr">
  					<span class="btn_04 mr04" style="display:none"><a href="javascript:doAction('excelDown');">다운로드</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  					<span class="btn_02"><a href="javascript:doAction('save');">생성</a></span>
  				</span> 
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
