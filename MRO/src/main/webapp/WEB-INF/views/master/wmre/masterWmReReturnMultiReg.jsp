<%--
**********************************************
* 메뉴 : 반품>반품관리>반품일괄등록
* 화면 : 반품일괄등록
* 기능 : 
* 프로그램 ID : PG_08_M_019_00
* 담당자 : 최철규 ( 설계 : 김상근 )
* 착수일 : 2017-02-13
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
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var wmreTypeGbn = KepSheetComboData("WM01","SEL");
    var w1GbnInfo = {ComboCode: wmreTypeGbn.ComboCode, ComboText: wmreTypeGbn.ComboText};
    
    var wmreType2Gbn = KepSheetComboData("WM02","SEL");
    var w2GbnInfo = {ComboCode: wmreType2Gbn.ComboCode, ComboText: wmreType2Gbn.ComboText};
    
    var wmreType3Gbn = KepSheetComboData("WM04","SEL");
    var w3GbnInfo = {ComboCode: wmreType3Gbn.ComboCode, ComboText: wmreType3Gbn.ComboText};
    
    var processGbn = KepSheetTotalComboData("M034","SEL","ICOMCOD1","CODE","TEXT2");
    var prcGbnInfo = {ComboCode: processGbn.ComboCode, ComboText: processGbn.ComboText};
    
    var deliveryGbn = KepSheetComboData("CA02","SEL");
    var delvGbnInfo = {ComboCode: deliveryGbn.ComboCode, ComboText: deliveryGbn.ComboText};
    
	var initsheet = {};
	initsheet.Cols = [
		  { Align:"Center",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선택",					SaveName:"SELECTED"}
		 ,{ Align:"Left",			Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"고객사명",			SaveName:"BUYER_NAME"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객사코드",		SaveName:"BUYER_CODE"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"발주번호",			SaveName:"PO_NO"}
		 ,{ Align:"Center",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"발주항번",			SaveName:"PO_SEQ"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"I/F발주번호",		SaveName:"LEGACY_PO_NO"}
		 ,{ Align:"Center",		Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"I/F발주항번",		SaveName:"LEGACY_PO_SEQ"}
		 ,{ Align:"Left",			Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
		 ,{ Align:"Left",			Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"품목명",				SaveName:"DESCRIPTION"}
		 ,{ Align:"Left",			Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"규격",					SaveName:"SPECIFICATION"}
		 ,{ Align:"Center",		Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"단위",					SaveName:"UNIT_MEASURE"}
		 ,{ Align:"Left",			Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"협력사",				SaveName:"SELLER_NAME"}
		 ,{ Align:"Left",			Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"협력사코드",		SaveName:"SELLER"}
		 ,{ Align:"Center",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",			Header:"거래유형",			SaveName:"PROCESS_TYPE"}
		 ,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"물류센터",			SaveName:"WAREHOUSE_CODE"}
		 ,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"고객요청부서",		SaveName:"BUYER_DEPT_CODE"}
		 ,{ Align:"Left",			Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객요청부서명",	SaveName:"BUYER_DEPT_NAME"}
		 ,{ Align:"Left",			Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객요청자",		SaveName:"BUYER_USER_NAME"}
		 ,{ Align:"Left",			Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객연락처",		SaveName:"BUYER_USER_TEL"}
		 ,{ Align:"Center",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"요청일",				SaveName:"B_REQ_DATE"}
		 ,{ Align:"Left",			Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"요청사유",			SaveName:"B_REQ_REMARK"}
		 ,{ Align:"Right",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주수량",			SaveName:"ITEM_QTY",				Format:"${qtyFormat}"}
		 ,{ Align:"Right",		Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"기반품수량",		SaveName:"TOTAL_WMRE_QTY",	Format:"${qtyFormat}"}
		 ,{ Align:"Right",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"요청수량",			SaveName:"WMRE_QTY",			Format:"${qtyFormat}"}
	 	 ,{ Align:"Left",			Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",			Header:"요청구분",			SaveName:"WMRE_TYPE"}
		 ,{ Align:"Center",		Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"반품접수일자",		SaveName:"M_REC_DATE"}
		 ,{ Align:"Left",			Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"반품접수비고",		SaveName:"M_REC_REMARK"}
	 	 ,{ Align:"Left",			Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",			Header:"귀책대상",			SaveName:"WMRE_TYPE2"}
	 	 ,{ Align:"Left",			Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",			Header:"귀책사유",			SaveName:"WMRE_TYPE3"}
 		 ,{ Align:"Left",			Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"귀책상세사유",		SaveName:"WMRE_TYPE_DETAIL"}
 		 ,{ Align:"Left",			Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"수주접수이력",		SaveName:"STATUS_BACK_CODE"}
 		 ,{ Align:"Left",			Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"PODT_STATUS",	SaveName:"PODT_STATUS"}
 		 ,{ Align:"Left",			Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"POHD_STATUS",	SaveName:"POHD_STATUS"}
 		 ,{ Align:"Left",			Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"PRDT_STATUS",	SaveName:"PRDT_STATUS"}
 		 ,{ Align:"Center",			Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",					Header:"물품수령여부",		SaveName:"DELIVERY_FLAG"}
	];

	mySheet.SetImageList(5, areaOn);
	mySheet.SetImageList(4, areaOff);

	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	mySheet.SetColProperty("WMRE_TYPE", w1GbnInfo);
	mySheet.SetColProperty("WMRE_TYPE2", w2GbnInfo);
	mySheet.SetColProperty("WMRE_TYPE3", w3GbnInfo);
	mySheet.SetColProperty("PROCESS_TYPE", prcGbnInfo);
	mySheet.SetColProperty("DELIVERY_FLAG", delvGbnInfo);
}
	
// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && selectedGrid.length == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = TrimCommon($("#st_buyer_code").val());

	switch (str) {
	case "search":	 // 조회 
        if(buyer == ""){
            alert("고객사를 선택해 주십시요.");
            return;
        }
	
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/wmre/getMasterWmReReturnMultiRegList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_buyer_code").val(""); 
		$("#st_buyer_name").val(""); 
		$("#st_com_org_code").val(""); 
		mySheet.RemoveAll();
		break;
		
	case "del":	// 삭제 
	    if (confirm("선택된 내역을 삭제하시겠습니까?")==false) return;
	
		kepSave(document.searchCondition ,  mySheet , "/wmre/deleteBntTrxlMasterWmreReturnMultiUplolad.do" , "SELECTED" );
		break;		
		
	case "excelUpload":	// 엑셀업로드
        if(buyer == ""){
            alert("고객사를 선택해 주십시요.");
            return;
        }
	
		var params = {
			Mode : "HeaderMatch"
		};
		
		mySheet.LoadExcel(params); 
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/WMRE/masterReturnMultiExcel.xlsx";
		break;
		
	case "submit":	// 반품등록
        if(buyer == ""){
            alert("고객사를 선택해 주십시요.");
            return;
        }
		
    	var arrRow  = selectedGrid.split("|");
    	
    	for(var i = 0; i < arrRow.length; i++){
    		var selectedRow = arrRow[i];

    		// 상태 체크
    		if(mySheet.GetCellValue(selectedRow,"PRDT_STATUS") == "D" || mySheet.GetCellValue(selectedRow,"PODT_STATUS") == "D" || mySheet.GetCellValue(selectedRow,"POHD_STATUS") == "D"){
    			alert(selectedRow+"번째 행 삭제된 주문/발주는 등록이 불가합니다.");
    			return;
    		}
    		
			// 요청일 체크
			if(mySheet.GetCellValue(selectedRow,"B_REQ_DATE") == ""){
				alert(selectedRow+"번째 행 요청일 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "B_REQ_DATE");
				return;
			}
			
			// 요청구분 체크
			if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE") == ""){
				alert(selectedRow+"번째 행 요청구분 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "WMRE_TYPE");
				return;
			}
			
			// 접수일자 체크
			if(mySheet.GetCellValue(selectedRow,"M_REC_DATE") == ""){
				alert(selectedRow+"번째 행 접수일자 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "M_REC_DATE");
				return;
			}
			
			// 귀책대상 체크
			if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE2") == ""){
				alert(selectedRow+"번째 행 귀책대상 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "WMRE_TYPE2");
				return;
			}
			
			// 귀책사유 체크
			if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE3") == ""){
				alert(selectedRow+"번째 행 귀책사유 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "WMRE_TYPE3");
				return;
			}
			
			// 귀책상세사유 체크
			if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE_DETAIL") == ""){
				alert(selectedRow+"번째 행 귀책상세사유 항목이 비었습니다.");
				mySheet.SelectCell(selectedRow, "WMRE_TYPE_DETAIL");
				return;
			}
			
			// 물품수령여부 체크
			if(mySheet.GetCellValue(selectedRow,"DELIVERY_FLAG") == "" || mySheet.GetCellValue(selectedRow,"DELIVERY_FLAG") == " "){
				alert(selectedRow+"번째 행 물품수령여부 항목을 확인해주시기 바랍니다.");
				mySheet.SelectCell(selectedRow, "DELIVERY_FLAG");
				return;
			}
			
			// 귀책 대상 - 귀책 사유 체크
			var wmre_type3 = mySheet.GetCellValue(selectedRow,"WMRE_TYPE3");
			
			if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE2") == "01"){
				if(wmre_type3 != "01" && wmre_type3 != "02" && wmre_type3 != "03" && wmre_type3 != "04" && wmre_type3 != "05"  && wmre_type3 != "17"){
					alert(selectedRow+"번째 행 귀책사유 항목을 확인해주세요.(엑셀양식-코드표 탭 참고)");
					mySheet.SelectCell(selectedRow, "WMRE_TYPE3");
					return;
				}
			}else if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE2") == "02"){
				if(wmre_type3 != "06" && wmre_type3 != "07" && wmre_type3 != "08" && wmre_type3 != "09" && wmre_type3 != "10" && wmre_type3 != "11"&& wmre_type3 != "15"&& wmre_type3 != "16"){
					alert(selectedRow+"번째 행 귀책사유 항목을 확인해주세요.(엑셀양식-코드표 탭 참고)");
					mySheet.SelectCell(selectedRow, "WMRE_TYPE3");
					return;
				}
			}else if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE2") == "03"){
				if(wmre_type3 != "12" && wmre_type3 != "13"){
					alert(selectedRow+"번째 행 귀책사유 항목을 확인해주세요.(엑셀양식-코드표 탭 참고)");
					mySheet.SelectCell(selectedRow, "WMRE_TYPE3");
					return;
				}
			}else if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE2") == "04"){
				if(wmre_type3 != "14"){
					alert(selectedRow+"번째 행 귀책사유 항목을 확인해주세요.(엑셀양식-코드표 탭 참고)");
					mySheet.SelectCell(selectedRow, "WMRE_TYPE3");
					return;
				}
			}
			
			// 요청구분(주문취소 vs 반품) 여부 체크
			if(mySheet.GetCellValue(selectedRow,"STATUS_BACK_CODE") != "0"){
				if(mySheet.GetCellValue(selectedRow,"WMRE_TYPE") == "09"){
					alert(selectedRow+"번째 행 요청구분을 확인하여 주시기 바랍니다. (수주접수 이력 있음)");
					mySheet.SelectCell(selectedRow, "WMRE_TYPE");
					return;
				}
			}
			
			// 수량 체크
			var QTY = mySheet.GetCellValue(selectedRow,"ITEM_QTY") - mySheet.GetCellValue(selectedRow,"WMRE_QTY");

			if(QTY < 0){
				alert(selectedRow+"번째 행 발주수량보다 반품수량이 많습니다.");
				mySheet.SelectCell(selectedRow, "WMRE_QTY");
				return;
			}
		}
		
	    if (confirm("반품 일괄등록 하시겠습니까?")==false) return;
		
		kepSave(document.searchCondition, mySheet, "/wmre/saveMasterWmReReturnMultiRegList.do", "SELECTED");
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}

function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if (2001 < mySheet.RowCount() + 1) {
		alert("2000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	
	setSaveGridtoDB();
}

function setSaveGridtoDB(){	
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i =1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }
    
	kepSave(document.searchCondition,  mySheet, "/wmre/uploadExcelMasterWmReReturnMultiRegList.do", "SELECTED");
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != ""){
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode){
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	doAction('search');
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P"; 
	kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnMultiRegList.do?page=1" , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;  
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2); 
	} 
}
</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>반품 일괄 등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">
			
            	<table  class="cont_t_list01" >
					<caption>반품 일괄 등록</caption>
					<colgroup>
						<col width="10%" />
						<col width="90%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:20%" value="" onclick="doPop('buyer_single');" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
      	
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div> 
		
		<p class="paging" id="pageindex"></p>
  			
  		<!--버튼영역-->
		<div class="btnArea02">
			<span class="fl">
				<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
				<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀양식</a></span>
  				<b>※&nbsp;<font color="red">업로드 시 엑셀양식을 다운 받은 후 고객사 단위로 등록하시기 바랍니다.</font></b>
  			</span>
  	        
  	        <span class="fr">
  				<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  				<span class="btn_04 mr04"><a href="javascript:doAction('submit');">반품등록</a></span>
  			</span>  				
		</div>
<!--내용 종료-->	                 
</body>
</html>
