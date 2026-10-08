<%--
**********************************************
* 메뉴 : 품목관리>거래품목
* 화면 : 거래품목조회
* 기능 : 
* 프로그램 ID : SU0301001
* 담당자 : 원지성
* 착수일 : 2025-10-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>
 <!-- IBSheet 래퍼 (IBSheet 로드 후에 와야 함) -->
<script src="/resources/js/common/IBSheetWrapper.js" type="text/javascript"></script>

<!-- HttpUtil (리뉴얼 - customerSelectPopup 의존성) -->
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>

<!-- PopupUtil (리뉴얼 - 범용 팝업 유틸리티) -->
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
String menuId = (String) request.getParameter("menuId");
if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
	for(int i = 0; i<myMenuListHeader.size(); i++){
		if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
			myMenuFlag = true;
			break;
		}
	}
}
%>
<body >
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader_sub_v2"/>
<c:param name="part" value="header_v2"/>
</c:import>
<c:import charEncoding="utf-8" url="/main/leftMenuData.do">
<c:param name="page" value="sellerLeft_v2"/>
</c:import>

<!-- 컨텐츠 -->
	<div class="containerBoxSub" >
      <div class="PDleft50"><!--padding-left:50px; 시작 -->    
		<div class="SubTit">
          <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star"></button>
     	<%} %> 거래 품목
          <div class="SummaryGuide">
      	    <ul>
        	  <li><img src="/resources/imgs/Icon_Home.png" /></li>
              <li>품목관리</li>
              <li>거래 품목</li>
            </ul>
          </div>
        </div>
        
        <div class="containerSub"><!--margin-right:50px; 설정 -->  
          <div class="Importance01"><img src="/resources/imgs/Icon_Importance.png" /> 고객사별 거래 품목 조회가 가능합니다. 이미지가 필요한 품목은 이미지/상제이미지 등록 후 
          <button class="ButOutline_Tiny" style="padding:0 6px; margin:0 3px 0 7px" >이미지등록요청</button>버튼을 눌러 요청해 주세요.</div> 
          <table class="SearchTable03" >
            <colgroup>
              <col width="100px" />
              <col width="300px" />
              <col width="220px" />
              <col width="290px" />
              <col width="100px" />
              <col width="270px" />
            </colgroup>         	
			<tr>
			  <th><span class="F6495F">*</span> 고객사</th>
              <td>
                <input type="hidden" id="st_buyer_code" name="st_buyer_code" value="">
                <form class="SearchBuyer" onSubmit="return false;" style="width:320px ">
                  <input type="text" placeholder="고객사 선택" id="st_buyer_name"  name="st_buyer_name" style=" width:85%; cursor: pointer;" readonly onclick="document.querySelector('.buyer-search-btn').click()">
                  <button type="button" class="buyer-search-btn"
                          data-target-input="st_buyer_name"
                          data-target-code="st_buyer_code">고객사검색버튼</button>
                </form>
			  </td>
              <th>이미지등록 요청현황</th>
              <td >
                <select name="imageStatus" class="Select" style="width:220px">
                  <option value="">전체</option>
                  <option value="X">미요청</option>
                  <option value="S">요청</option>
                  <option value="C">승인</option>
                  <option value="R">반려</option>
                </select>
			  </td>
              <th>제조사</th>
              <td><input class="input30" style="width:200px" name="manufacturer" type="text" /></td>
            </tr>
            <tr>
              <th><span class="FFFFFF">*</span> 품목코드</th>
              <td><input class="input30" style="width:300px" name="itemCode" type="text" /></td>
              <th>품목명</th>
              <td ><input class="input30" style="width:200px" name="itemName" type="text" /></td>
              <th>규격</th>
              <td><input class="input30" style="width:200px" name="specification" type="text" /></td>

            </tr>
          </table>
          <div class="SearchBtnBoxNoTab">
         	<button class="ButSmall_Outline" onclick="resetSearch()">초기화</button>
        	<button class="ButMSmallDarkGray" onclick="searchData()">조회</button>
          </div>
          <div class="ListBtnBox">
            <div class="left"></div>
            <div class="right"><button class="ButOutline_Medium" onclick="requestImageRegistration()">이미지등록요청</button></div>
          </div>

          <!--grid-->
          <div class="ib-container">
            <script type="text/javascript">
              createIBSheet("mySheet", "100%", "600px");
            </script>
          </div><!--IBSheet 끝 --> 
          <div class="h5"></div> 
   
          <div class="h30"></div>             
        </div><!-- containerSub 끝 --> 
             
      </div> <!--padding-left:50px; 끝 -->
    </div><!--containerBoxSub-->

<%@ include file="/WEB-INF/views/common/include/sellerFooter_sub_v2.jsp" %>

<script type="text/javascript">


var catalogColumns = [
    {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"CHK", Header:"", Type:"CheckBox", Width:50, Edit:true, EditLen:0, Sort:0, Hidden:false},
    {Align:"Center", SaveName:"NO", Header:"NO", Type:"Seq", Width:50, Edit:false, EditLen:10, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"PRODUCT_IMAGE", Header:"이미지", Type:"Image", Width:100, Edit:false, EditLen:0, Sort:0, ImgWidth:25, ImgHeight:25, Hidden:false, Cursor:"Pointer"},
    {Align:"Center", SaveName:"DETAIL_IMAGE", Header:"상세이미지", Type:"Image", Width:100, Edit:false, EditLen:0, Sort:0, ImgWidth:25, ImgHeight:25, Hidden:false, Cursor:"Pointer"},
    {Align:"Center", SaveName:"BUYER_CODE", Header:"고객사코드", Type:"Text", Width:0, Edit:false, EditLen:20, Sort:0, Hidden:true},
    {Align:"Left", SaveName:"BUYER_NAME", Header:"고객사", Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"ITEM_CODE", Header:"품목코드", Type:"Text", FontColor:"#3a72c7",Width:120, Edit:false, EditLen:50, Sort:1, Hidden:false, Cursor:"Pointer"},
    {Align:"Left", SaveName:"ITEM_NAME", Header:"품목명", Type:"Text", Width:250, Edit:false, EditLen:200, Sort:1, Hidden:false},
    {Align:"Left", SaveName:"SPECIFICATION", Header:"규격", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"UNIT", Header:"단위", Type:"Text", Width:80, Edit:false, EditLen:20, Sort:1, Hidden:false},
    {Align:"Right", SaveName:"CONTRACT_PRICE", Header:"계약단가", Type:"Int", Width:120, Edit:false, EditLen:15, Sort:1, Hidden:false, Format:"#,###"},
    {Align:"Left", SaveName:"MANUFACTURER", Header:"제조사", Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"ORIGIN", Header:"원산지", Type:"Text", Width:100, Edit:false, EditLen:50, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"IMAGE_STATUS_CODE", Header:"이미지상태코드", Type:"Text", Width:0, Edit:false, EditLen:10, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"IMAGE_STATUS", Header:"이미지등록\n요청현황", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},
    {Align:"Center", SaveName:"IMAGE_REGISTER", Header:"이미지\n등록", Type:"Button", Width:80, Edit:true, EditLen:0, Sort:0, Hidden:false, Value:"등록", ClassName:"Type03" ,BackColor:"#ffffdc"},

    {Align:"Center", SaveName:"DETAIL_REGISTER", Header:"상세이미지\n등록", Type:"Button", Width:90, Edit:true, EditLen:0, Sort:0, Hidden:false, Value:"등록", ClassName:"Type03" ,BackColor:"#ffffdc"},

    {Align:"Center", SaveName:"REG_DATE", Header:"등록일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},
    {Align:"Center", SaveName:"MOD_DATE", Header:"수정일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false, Format:"yyyy/MM/dd"},

    // 추가 정보 (숨김 컬럼 - 팝업용)
    {Align:"Left", SaveName:"CATEGORY_TEXT", Header:"카테고리명", Type:"Text", Width:0, Edit:false, EditLen:1000, Sort:0, Hidden:true},
    {Align:"Left", SaveName:"DOC_NO", Header:"문서번호", Type:"Text", Width:0, Edit:false, EditLen:40, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"MSDS_YN", Header:"MSDS여부", Type:"Text", Width:0, Edit:false, EditLen:1, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"MSDS_ATTACH_YN", Header:"MSDS첨부여부", Type:"Text", Width:0, Edit:false, EditLen:1, Sort:0, Hidden:true},
    {Align:"Center", SaveName:"DELIVERY_LT", Header:"조달일수", Type:"Text", Width:0, Edit:false, EditLen:16, Sort:0, Hidden:true},
    {Align:"Left", SaveName:"MSDS_NO", Header:"MSDS번호", Type:"Text", Width:0, Edit:false, EditLen:40, Sort:0, Hidden:true}
];

// ========================================
// IBSheetWrapper 초기화 (리뉴얼)
// ========================================
var catalogSheet = new IBSheetWrapper("mySheet", "거래품목");
catalogSheet.initialize(catalogColumns);

// ✅ 총 건수 표시 비활성화 (이 화면에서만)
var sheet = catalogSheet.getSheet();
if (sheet && sheet.SetConfig) {
    sheet.SetConfig({ CountPosition: 0 });  // 0 = 표시 안 함
}

// ========================================
// 무한 스크롤 설정 (리뉴얼)
// ========================================
var PAGE_SIZE = 50;  // 페이지당 로드 건수
var infiniteScrollBound = false;  // 스크롤 이벤트 바인딩 여부

// ========================================
// 체크박스 동기화 이벤트 (헤더 ↔ 개별)
// ========================================
// 개별 체크박스 클릭 시 헤더 체크박스 동기화
catalogSheet.setOnChange(function(row, col, value) {
    var sheet = this.getSheet();
    var colName = sheet.ColSaveName(col);

    // CHK 컬럼 변경 시에만 동작
    if (colName === 'CHK') {
        syncHeaderCheckbox();
    }
});

// 헤더 체크박스와 개별 체크박스 동기화 함수
function syncHeaderCheckbox() {
    var sheet = catalogSheet.getSheet();
    var totalRows = sheet.RowCount();

    if (totalRows === 0) return;

    // 모든 행의 체크 상태 확인
    var allChecked = true;
    for (var i = 1; i <= totalRows; i++) {
        if (sheet.GetCellValue(i, "CHK") !== "1") {
            allChecked = false;
            break;
        }
    }

    // 헤더 체크박스 상태 업데이트
    // IBSheet에서는 헤더 체크박스가 자동으로 동기화되지 않으므로
    // 하나라도 해제되면 전체 해제로 간주
    if (!allChecked) {
        // 모든 체크가 안된 경우 헤더도 해제 (시각적 효과)
        sheet.SetHeaderCheck(0, "CHK", 0);
    }
}

// ========================================
// 버튼 클릭 이벤트 (리뉴얼 - setOnClick 사용)
// ========================================

// 이미지(PRODUCT_IMAGE) 클릭 - 크게 보기
catalogSheet.setOnClick('PRODUCT_IMAGE', function(row, col, value) {
    var imageUrl = this.getCellValue(row, 'PRODUCT_IMAGE');
    var itemName = this.getCellValue(row, 'ITEM_NAME');

    // 이미지 뷰어 팝업 열기
    PopupUtil.callback(function(api) {
        api.showImage(imageUrl, '대표 이미지 - ' + itemName);
    }).show(PopupUtil.POPUP_URLS.IMAGE_VIEWER);
});

// 상세이미지(DETAIL_IMAGE) 클릭 - 크게 보기
catalogSheet.setOnClick('DETAIL_IMAGE', function(row, col, value) {
    var imageUrl = this.getCellValue(row, 'DETAIL_IMAGE');
    var itemName = this.getCellValue(row, 'ITEM_NAME');

    // 이미지 뷰어 팝업 열기
    PopupUtil.callback(function(api) {
        api.showImage(imageUrl, '상세 이미지 - ' + itemName);
    }).show(PopupUtil.POPUP_URLS.IMAGE_VIEWER);
});

// 이미지 등록 버튼 클릭
catalogSheet.setOnClick('IMAGE_REGISTER', function(row, col, value) {
    var itemCode = this.getCellValue(row, 'ITEM_CODE');
    var itemName = this.getCellValue(row, 'ITEM_NAME');
    var IMAGE_STATUS_CODE = this.getCellValue(row, 'IMAGE_STATUS_CODE');

    if(IMAGE_STATUS_CODE !='X'){
        PopupUtil.callback(function(api) {
            api.setMessage("이미 등록이 요청된 품목입니다");
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
        return;
    }

    // ✅ 행 번호 기반 저장소 키 생성
    var storageKey = itemCode + "_" + row;

    // 이미지 첨부 팝업 열기 (드래그앤드롭 방식)
    PopupUtil.callback(function(api) {
        // 기존 첨부 파일 로드 (서버 전송 전)
        if (api.loadExistingFile) {
            var existingFile = null;
            if (tempImageStorage[storageKey] && tempImageStorage[storageKey].product) {
                existingFile = {
                    file: tempImageStorage[storageKey].product,
                    name: tempImageStorage[storageKey].productName || tempImageStorage[storageKey].product.name
                };
            }
            api.loadExistingFile(existingFile, itemCode, 'PRODUCT');
        }

        // 확인 버튼 클릭 시 콜백
        api.onConfirm(function(uploadedFiles) {
            // 업로드된 파일이 있으면 tempImageStorage에 저장
            if (uploadedFiles && uploadedFiles.length > 0) {
                var fileInfo = uploadedFiles[0]; // 첫 번째 파일만 사용 (이미지는 1개)
                var file = fileInfo.file;
                var fileName = fileInfo.name;

                // ✅ 행 번호 기반 저장소에 저장
                tempImageStorage[storageKey] = {
                    product: file,
                    productName: fileName,
                    rowIndex: row,
                    itemCode: itemCode
                };

                // 버튼 텍스트 변경
                var nativeSheet = catalogSheet.getSheet();
                nativeSheet.SetCellText(row, col, "첨부(1)");
            }
        });
    }).show(PopupUtil.POPUP_URLS.IMAGE_REGISTER);
});

// 상세이미지 등록 버튼 클릭
catalogSheet.setOnClick('DETAIL_REGISTER', function(row, col, value) {
    var itemCode = this.getCellValue(row, 'ITEM_CODE');
    var itemName = this.getCellValue(row, 'ITEM_NAME');
    var IMAGE_STATUS_CODE = this.getCellValue(row, 'IMAGE_STATUS_CODE');

    if(IMAGE_STATUS_CODE !='X'){
        PopupUtil.callback(function(api) {
            api.setMessage("이미 등록이 요청된 품목입니다");
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
        return;
    }

    // ✅ 행 번호 기반 저장소 키 생성
    var storageKey = itemCode + "_" + row;

    // 이미지 첨부 팝업 열기 (드래그앤드롭 방식)
    PopupUtil.callback(function(api) {
        // 기존 첨부 파일 로드 (서버 전송 전)
        if (api.loadExistingFile) {
            var existingFile = null;
            if (tempImageStorage[storageKey] && tempImageStorage[storageKey].detail) {
                existingFile = {
                    file: tempImageStorage[storageKey].detail,
                    name: tempImageStorage[storageKey].detailName || tempImageStorage[storageKey].detail.name
                };
            }
            api.loadExistingFile(existingFile, itemCode, 'DETAIL');
        }

        // 확인 버튼 클릭 시 콜백
        api.onConfirm(function(uploadedFiles) {
            // 업로드된 파일이 있으면 tempImageStorage에 저장
            if (uploadedFiles && uploadedFiles.length > 0) {
                var fileInfo = uploadedFiles[0]; // 첫 번째 파일만 사용 (이미지는 1개)
                var file = fileInfo.file;
                var fileName = fileInfo.name;

                // ✅ 행 번호 기반 저장소에 저장 (기존 데이터 유지)
                if (!tempImageStorage[storageKey]) {
                    tempImageStorage[storageKey] = {
                        rowIndex: row,
                        itemCode: itemCode
                    };
                }

                tempImageStorage[storageKey].detail = file;
                tempImageStorage[storageKey].detailName = fileName;

                // 버튼 텍스트 변경
                var nativeSheet = catalogSheet.getSheet();
                nativeSheet.SetCellText(row, col, "첨부(1)");
            }
        });
    }).show(PopupUtil.POPUP_URLS.IMAGE_REGISTER);
});

// ========================================
// 품목코드 클릭 이벤트
// ========================================
catalogSheet.setOnClick('ITEM_CODE', function(row, col, value) {
    var itemCode = this.getCellValue(row, 'ITEM_CODE');
    var itemName = this.getCellValue(row, 'ITEM_NAME');
    var buyerName = this.getCellValue(row, 'BUYER_NAME');
    var specification = this.getCellValue(row, 'SPECIFICATION');
    var manufacturer = this.getCellValue(row, 'MANUFACTURER');
    var contractPrice = this.getCellValue(row, 'CONTRACT_PRICE');
    var origin = this.getCellValue(row, 'ORIGIN');
    var unit = this.getCellValue(row, 'UNIT');
    var productImage = this.getCellValue(row, 'PRODUCT_IMAGE');

    // 추가 정보 (숨김 컬럼에서 가져오기)
    var categoryText = this.getCellValue(row, 'CATEGORY_TEXT');
    var docNo = this.getCellValue(row, 'DOC_NO');
    var msdsYn = this.getCellValue(row, 'MSDS_YN');
    var msdsAttachYn = this.getCellValue(row, 'MSDS_ATTACH_YN');
    var msdsNo = this.getCellValue(row, 'MSDS_NO');
    var deliveryLt = this.getCellValue(row, 'DELIVERY_LT');

    // 품목정보 팝업 열기
    PopupUtil.callback(function(api) {
        // 품목 데이터 객체 생성
        var itemData = {
            itemCode: itemCode,
            itemName: itemName,
            specification: specification,
            category: categoryText || '-',
            manufacturer: manufacturer,
            origin: origin,
            unit: unit,
            deliveryDays: deliveryLt || null,
            price: contractPrice,
            imageUrl: productImage,  // null이면 팝업에서 투명 이미지 표시
            attachment: docNo ? { count: 1, docNo: docNo } : null,
            msds: (msdsYn === 'Y' || msdsAttachYn === 'Y') && msdsNo ? { count: 1, docNo: msdsNo } : null
        };

        // 데이터 바인딩
        api.bindItemData(itemData);

    }).show(PopupUtil.POPUP_URLS.ITEM_INFO);
});

// ========================================
// 클라이언트 임시 이미지 저장소
// ========================================
// ✅ 수정: 행 번호 기반 저장소 (itemCode_rowIndex)
// 구조: { "itemCode_rowIndex": { product: File, detail: File, rowIndex: number, itemCode: string } }
var tempImageStorage = {};

/**
 * ✅ 행 번호와 함께 체크된 행 데이터를 반환하는 헬퍼 함수
 * @returns {Array} 체크된 행 데이터 배열 (각 객체에 _rowIndex 필드 추가)
 */
function getCheckedRowsWithIndex() {
    var sheet = catalogSheet.getSheet();
    var result = [];

    // 체크된 행 인덱스 가져오기 ("|" 구분)
    var checkedRowIndexes = sheet.FindCheckedRow("CHK");

    if (!checkedRowIndexes || checkedRowIndexes === "") {
        return [];
    }

    // 인덱스 배열로 변환
    var rowIndexArray = checkedRowIndexes.split("|");

    // 각 행의 데이터와 인덱스를 함께 저장
    for (var i = 0; i < rowIndexArray.length; i++) {
        var rowIndex = parseInt(rowIndexArray[i], 10);
        var rowData = sheet.GetRowData(rowIndex);
        rowData._rowIndex = rowIndex;  // ✅ 행 번호 추가
        result.push(rowData);
    }

    return result;
}

/**
 * 이미지 등록 요청 (리뉴얼 - IBSheet 표준 메서드 사용)
 * 클라이언트에 임시 저장된 이미지를 서버로 전송
 *
 * 원본 로직 기준 데이터 구조:
 * st_query2 = "BUYER@@BUYER_ITEM_NO@@FILE_NO@@FILE_DIR@@FILE_NO2@@FILE_DIR2|BUYER@@BUYER_ITEM_NO..."
 */
function requestImageRegistration() {
    var nativeSheet = catalogSheet.getSheet();

    // ✅ 행 번호가 포함된 체크된 행 데이터 가져오기
    var checkedRows = getCheckedRowsWithIndex();

    // 1. 선택된 품목이 있는지 확인 (레거시: 401-403라인)
    if (checkedRows.length === 0) {
 	   PopupUtil.callback(function(api) {
          	api.setMessage("선택한 품목이 없습니다.");
          }).show(PopupUtil.POPUP_URLS.CONFIRM);
        return false;
    }

    // 2. 선택된 품목별로 validation 체크 (레거시 로직과 동일)
    for (var i = 0; i < checkedRows.length; i++) {
        var row = checkedRows[i];
        var itemCode = row.ITEM_CODE;
        var rowIndex = row._rowIndex;  // ✅ 행 번호 추출
        var storageKey = itemCode + "_" + rowIndex;  // ✅ 저장소 키 생성
        var imageData = tempImageStorage[storageKey];  // ✅ 행 번호 기반 조회

        // 2-2. 이미지 등록 상태 확인 (레거시: 419-422, 441-444라인)
        if (row.IMAGE_STATUS_CODE === "S") {


            // PopupUtil.callback 패턴 사용
            PopupUtil.callback(function(api) {
            	api.setMessage('이미지 등록이 요청된 품목입니다.');
            }).show(PopupUtil.POPUP_URLS.CONFIRM);


            return false;
        }

        // 2-1. 이미지 필수 체크 (수정됨)
        // 레거시 조건: if (fileName == "" && fileName2=="")
        // 기존: 상품이미지(FILE_NO, FILE_DIR)는 필수, 상세이미지는 선택
        // ✅ 수정: 대표 이미지 또는 상세 이미지 중 하나라도 있으면 저장 가능
        if (!imageData || (!imageData.product && !imageData.detail)) {



     	   PopupUtil.callback(function(api) {
              	api.setMessage("대표 이미지 또는 상세 이미지 중 최소 하나는 첨부해야 합니다. (품목코드: " + itemCode + ", 행: " + rowIndex + ")");
              }).show(PopupUtil.POPUP_URLS.CONFIRM);

            return false;
        }


    }

    // 3. 이미지 파일들을 먼저 서버에 업로드
    uploadImagesFirst(checkedRows);
}

/**
 * 1단계: 이미지 파일들을 먼저 서버에 업로드
 * 원본 로직: saveSellerMpClCatalogImgFile.do, saveSellerMpClCatalogDetailImgFile.do로 개별 업로드
 * ✅ 수정: 행 번호 기반 저장소 키 사용
 */
var uploadedFileInfo = {}; // ✅ 수정: { "itemCode_rowIndex": { fileNo: '', fileDir: '', fileNo2: '', fileDir2: '' } }
var uploadCounter = 0;
var totalUploadCount = 0;

function uploadImagesFirst(items) {
    uploadedFileInfo = {};
    uploadCounter = 0;
    totalUploadCount = 0;

    // 업로드할 총 파일 수 계산
    for (var i = 0; i < items.length; i++) {
        var row = items[i];
        var itemCode = row.ITEM_CODE;
        var rowIndex = row._rowIndex;  // ✅ 행 번호 추출
        var storageKey = itemCode + "_" + rowIndex;  // ✅ 저장소 키 생성
        var imageData = tempImageStorage[storageKey];  // ✅ 행 번호 기반 조회

        if (imageData) {
            if (imageData.product) totalUploadCount++;
            if (imageData.detail) totalUploadCount++;
        }
    }

    // 각 이미지 파일을 순차적으로 업로드
    for (var i = 0; i < items.length; i++) {
        var row = items[i];
        var itemCode = row.ITEM_CODE;
        var rowIndex = row._rowIndex;  // ✅ 행 번호 추출
        var storageKey = itemCode + "_" + rowIndex;  // ✅ 저장소 키 생성
        var buyerCode = row.BUYER_CODE; // 원본 로직에서는 BUYER 필드
        var imageData = tempImageStorage[storageKey];  // ✅ 행 번호 기반 조회

        // ✅ 수정: 저장소 키 기반으로 uploadedFileInfo 생성
        if (!uploadedFileInfo[storageKey]) {
            uploadedFileInfo[storageKey] = {
                buyer: buyerCode,
                itemCode: itemCode,
                rowIndex: rowIndex,
                fileNo: '',
                fileDir: '',
                fileNo2: '',
                fileDir2: ''
            };
        }

        if (imageData) {
            // 상품 이미지 업로드
            if (imageData.product) {
                uploadSingleImage(imageData.product, 'product', storageKey, items);
            }

            // 상세 이미지 업로드
            if (imageData.detail) {
                uploadSingleImage(imageData.detail, 'detail', storageKey, items);
            }
        }
    }
}

/**
 * 개별 이미지 파일 업로드 (원본 로직과 동일하게 개별 업로드)
 * ✅ 수정: storageKey (itemCode_rowIndex) 사용
 */
function uploadSingleImage(file, imageType, storageKey, allItems) {
    var formData = new FormData();

    if (imageType === 'product') {
        formData.append('files', file);
    } else {
        formData.append('files2', file);
    }

    var uploadUrl = imageType === 'product'
        ? '/mpcl/saveSellerMpClCatalogImgFile_v2.do'
        : '/mpcl/saveSellerMpClCatalogDetailImgFile_v2.do';

    HttpUtil.postFormData(uploadUrl, formData, {
        showLoader: true,
        showDefaultAlert: false
    }).then(function(response) {
        // 응답 형식: "FILE_DIR@@FILE_NO" (예: "ITEM_IMAGE/202510TEMP@@KRDOWO00051760576569037.png")
        // response.data가 객체이므로 response.data.msg로 접근
        var msg = response.data && response.data.msg ? response.data.msg : null;

        if (msg) {
            var parts = msg.split('@@');

            if (parts.length === 2) {
                // ✅ 수정: storageKey 기반으로 저장
                if (imageType === 'product') {
                    uploadedFileInfo[storageKey].fileDir = parts[0];  // FILE_DIR (ITEM_IMAGE/202510TEMP)
                    uploadedFileInfo[storageKey].fileNo = parts[1];   // FILE_NO (파일명.확장자)
                } else {
                    uploadedFileInfo[storageKey].fileDir2 = parts[0]; // FILE_DIR2
                    uploadedFileInfo[storageKey].fileNo2 = parts[1];  // FILE_NO2
                }
            }
        }

        uploadCounter++;

        // 모든 파일 업로드 완료 시 2단계 진행
        if (uploadCounter === totalUploadCount) {
            sendImageRegistrationRequest(allItems);
        }
    }).catch(function(error) {
        console.error("[이미지 파일 업로드 실패]", error);
        alert("이미지 파일 업로드에 실패하였습니다.\n" + (error.userMessage || error.message || '알 수 없는 오류'));
    });
}

/**
 * 2단계: 원본 로직과 동일한 형식으로 이미지 등록 요청
 * 데이터 구조: st_query2 = "BUYER@@BUYER_ITEM_NO@@FILE_NO@@FILE_DIR@@FILE_NO2@@FILE_DIR2|..."
 * ✅ 수정: storageKey (itemCode_rowIndex) 기반으로 데이터 조회
 */
function sendImageRegistrationRequest(items) {
    var queryParts = [];

    for (var i = 0; i < items.length; i++) {
        var row = items[i];
        var itemCode = row.ITEM_CODE;
        var rowIndex = row._rowIndex;  // ✅ 행 번호 추출
        var storageKey = itemCode + "_" + rowIndex;  // ✅ 저장소 키 생성
        var fileInfo = uploadedFileInfo[storageKey];  // ✅ 행 번호 기반 조회

        if (fileInfo) {
            
            // BUYER@@BUYER_ITEM_NO@@FILE_NO@@FILE_DIR@@FILE_NO2@@FILE_DIR2
            var queryPart = [
                fileInfo.buyer || '',
                itemCode || '',
                fileInfo.fileNo || '',
                fileInfo.fileDir || '',
                fileInfo.fileNo2 || '',
                fileInfo.fileDir2 || ''
            ].join('@@');

            queryParts.push(queryPart);
        }
    }

    var st_query2 = queryParts.join('|');

    // FormData 생성 (원본 로직: processForm 사용)
    var formData = new FormData();
    formData.append('st_query2', st_query2);

    // 서버로 전송
    HttpUtil.postFormData('/mpcl/saveSellerMpClCatalogImg.do', formData, {
        showLoader: true,
        showDefaultAlert: false
    }).then(function(response) {
        // PopupUtil.callback 패턴 사용
        PopupUtil.callback(function(api) {
        	api.setMessage('이미지 등록요청이 완료 되었습니다.');
        }).show(PopupUtil.POPUP_URLS.CONFIRM);



        // 업로드 성공 후 임시 저장소 초기화
        for (var i = 0; i < items.length; i++) {
            var itemCode = items[i].ITEM_CODE;
            delete tempImageStorage[itemCode];
        }

        // 리스트 새로고침
        searchData();
    }).catch(function(error) {
        console.error("[이미지 등록 요청 실패]", error);
        
        
        PopupUtil.callback(function(api) {
        	api.setMessage("이미지 등록요청에 실패하였습니다.\n" + (error.userMessage || error.message || '알 수 없는 오류'));
        }).show(PopupUtil.POPUP_URLS.CONFIRM);
        

    });
}

/**
 * 데이터 조회 (리뉴얼 - catalogSheet 사용)
 */
function searchData() {
    var buyerCode = document.getElementById("st_buyer_code") ? document.getElementById("st_buyer_code").value : "";
    var imageStatus = document.querySelector('select[name="imageStatus"]') ? document.querySelector('select[name="imageStatus"]').value : "";
    var itemCode = document.querySelector('input[name="itemCode"]') ? document.querySelector('input[name="itemCode"]').value : "";
    var manufacturer = document.querySelector('input[name="manufacturer"]') ? document.querySelector('input[name="manufacturer"]').value : "";
    var itemName = document.querySelector('input[name="itemName"]') ? document.querySelector('input[name="itemName"]').value : "";
    var specification = document.querySelector('input[name="specification"]') ? document.querySelector('input[name="specification"]').value : "";

    // 고객사 필수 체크
    if (buyerCode === "") {

        PopupUtil.callback(function(api) {
        	api.setMessage("고객사를 선택해 주십시오.");
        }).show(PopupUtil.POPUP_URLS.CONFIRM);

        return false;
    }

    // 검색 파라미터 구성 (리뉴얼)
    var searchParams = "buyerCode=" + encodeURIComponent(buyerCode) +
                      "&imageStatus=" + encodeURIComponent(imageStatus) +
                      "&itemCode=" + encodeURIComponent(itemCode) +
                      "&manufacturer=" + encodeURIComponent(manufacturer) +
                      "&itemName=" + encodeURIComponent(itemName) +
                      "&specification=" + encodeURIComponent(specification);

    // ========================================
    // 무한 스크롤 방식 조회 (리뉴얼)
    // ========================================
    // 시트 초기화 및 페이징 상태 설정
    catalogSheet.removeAll();
    catalogSheet.initPaging("/mpcl/getSellerMpClCatalogListData_v2.do", searchParams, PAGE_SIZE);

    // CountFormat 설정 (총 건수 표시 - 무한 스크롤용)
    var sheet = catalogSheet.getSheet();
    if (sheet && sheet.SetCountFormat) {
        sheet.SetCountFormat(" 총  TOTALROWS 건");
    }

    // 페이지 로드 콜백 설정
    catalogSheet.onPageLoaded = function(pageIndex, loadedCount, hasMore) {
        console.log('[무한스크롤] 페이지 ' + pageIndex + ' 로드 완료: ' + loadedCount + '건, 더보기: ' + hasMore);
    };

    // 로딩 화면 표시
    showIBSheetLoading("mySheet", "데이터 조회중...");

    // 첫 페이지 로드
    catalogSheet.loadNextPage().then(function() {
        // 로딩 화면 숨김
        hideIBSheetLoading("mySheet");
        // 무한 스크롤 이벤트 설정
        setupInfiniteScroll();
    }).catch(function() {
        // 에러 시에도 로딩 화면 숨김
        hideIBSheetLoading("mySheet");
    });
}

/**
 * 초기화 (리뉴얼 - catalogSheet 사용)
 */
function resetSearch() {
    // 입력 필드 초기화
    if (document.getElementById("st_buyer_code")) document.getElementById("st_buyer_code").value = "";
    if (document.getElementById("st_buyer_name")) document.getElementById("st_buyer_name").value = "";
    if (document.querySelector('select[name="imageStatus"]')) document.querySelector('select[name="imageStatus"]').selectedIndex = 0;
    if (document.querySelector('input[name="itemCode"]')) document.querySelector('input[name="itemCode"]').value = "";
    if (document.querySelector('input[name="manufacturer"]')) document.querySelector('input[name="manufacturer"]').value = "";
    if (document.querySelector('input[name="itemName"]')) document.querySelector('input[name="itemName"]').value = "";
    if (document.querySelector('input[name="specification"]')) document.querySelector('input[name="specification"]').value = "";

    // 무한 스크롤 정리 (리뉴얼)
    cleanupInfiniteScroll();

    // 시트 데이터 초기화 (리뉴얼)
    if (catalogSheet) {
        catalogSheet.removeAll();
    }
}

// ========================================
// 무한 스크롤 관련 함수 (리뉴얼)
// ========================================

/**
 * Debounce 유틸리티
 * @param {Function} func - 실행할 함수
 * @param {number} wait - 대기 시간 (ms)
 * @returns {Function} 디바운스된 함수
 */
function debounce(func, wait) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            func.apply(context, args);
        }, wait);
    };
}

/**
 * 무한 스크롤 설정
 * IBSheet7 OnVScroll 이벤트 활성화
 */
function setupInfiniteScroll() {
    if (infiniteScrollBound) return;

    var sheet = catalogSheet.getSheet();
    if (!sheet) return;

    infiniteScrollBound = true;
    console.log('[무한스크롤] 이벤트 설정 완료 (OnVScroll 사용)');
}

/**
 * IBSheet7 세로 스크롤 이벤트 핸들러 (전역 함수)
 * 주의: 함수명은 실제 IBSheet 오브젝트 ID를 따라야 함 (mySheet)
 * @param {Long} vpos - 현재 세로 스크롤 값
 * @param {Long} oldvpos - 이전 세로 스크롤 값
 * @param {Boolean} isTop - 세로 스크롤이 최상단에 위치했는지 여부
 * @param {Boolean} isBottom - 세로 스크롤이 최하단에 위치했는지 여부
 */
function mySheet_OnVScroll(vpos, oldvpos, isTop, isBottom) {
    // 최하단 도달 시에만 처리
    if (!isBottom) return;

    // 로딩 중이거나 더 이상 데이터가 없으면 무시
    if (!catalogSheet || !catalogSheet.hasMoreData()) return;
    if (catalogSheet.isLoading()) return;

    console.log('[무한스크롤] 최하단 도달 - 추가 데이터 로드 시작...');

    // 로딩 화면 표시
    showIBSheetLoading("mySheet", "추가 데이터 로드중...");

    catalogSheet.loadNextPage().then(function(hasMore) {
        // 로딩 화면 숨김
        hideIBSheetLoading("mySheet");
        console.log('[무한스크롤] 로드 완료, 더보기: ' + hasMore);
    }).catch(function() {
        // 에러 시에도 로딩 화면 숨김
        hideIBSheetLoading("mySheet");
    });
}

/**
 * 무한 스크롤 정리
 * 검색 초기화 시 호출
 */
function cleanupInfiniteScroll() {
    // 페이징 상태 초기화
    if (catalogSheet) {
        catalogSheet.resetPaging();
    }
    infiniteScrollBound = false;
}

// ========================================
// 고객사 선택 팝업 (리뉴얼 - PopupUtil + 서버 데이터 연동)
// ========================================
$(document).ready(function() {
    // Enter key event handlers for search inputs
    $('input[name="itemCode"]').on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });

    $('input[name="manufacturer"]').on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });

    $('input[name="itemName"]').on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });

    $('input[name="specification"]').on("keypress", function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            searchData();
        }
    });

    // 고객사 검색 버튼 클릭 이벤트 (클래스 기반)
    $(document).on('click', '.buyer-search-btn', function(e) {
        e.preventDefault();
        $(this).blur();  // 버튼 포커스 제거 (팝업에서 Enter/Space 키 입력 시 재클릭 방지)

        var targetInputId = $(this).data('target-input');
        var targetCodeId = $(this).data('target-code');



        // ========================================
        // 신규 거래고객사 선택 팝업 (PopupUtil.showTranBuyerChoice)
        // ========================================
        // ----------------------------------------
        // [기존] 단일 선택 모드 (라디오 버튼)
        // ----------------------------------------
    /*      PopupUtil.showTranBuyerChoice(function(popup) {
             popup.setAllowMultiple(false)  // 단일 선택 모드
                  .onConfirm(function(selectedCustomers) {
                      if (selectedCustomers && selectedCustomers.length > 0) {
                          var customer = selectedCustomers[0];
        
                          // 입력 필드에 값 설정
                          $('#' + targetInputId).val(customer.name);
                          $('#' + targetCodeId).val(customer.code);
        
                          console.log('[거래품목] 거래고객사 선택 완료:', customer);
                      }
        
                      console.log('[거래품목] body 스크롤 복원 (확인)');
                  })
                  .onCancel(function() {
                      console.log('[거래품목] 거래고객사 선택이 취소되었습니다.');
        
                      console.log('[거래품목] body 스크롤 복원 (취소)');
                  });
         }); */

        // ----------------------------------------
        // [신규] 다중 선택 모드 (체크박스)
        // ----------------------------------------
        PopupUtil.showTranBuyerChoice(function(popup) {
            popup.setAllowMultiple(true)  // 다중 선택 모드 (체크박스)
                 .onConfirm(function(selectedCustomers) {
                     if (selectedCustomers && selectedCustomers.length > 0) {
                         var displayName;
                         var codes = selectedCustomers.map(function(c) { return c.code; }).join(',');

                         if (selectedCustomers.length === 1) {
                             // 단일 선택: 이름만 표시
                             displayName = selectedCustomers[0].name;
                         } else {
                             // 다중 선택: "첫번째 이름 외 N개" 형식
                             displayName = selectedCustomers[0].name + ' 외 ' + (selectedCustomers.length - 1) + '개';
                         }

                         // 입력 필드에 값 설정
                         $('#' + targetInputId).val(displayName);
                         $('#' + targetCodeId).val(codes);
                     }
                 });
        }); 
    });
});

</script> 



</html>
