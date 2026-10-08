<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../WEB-INF/views/common/include/head_v2.jspf" %>


</head>

<body>

<!-- IBSheet 컨테이너 -->
<div class="IBSheet" style="padding:10px; box-sizing: border-box;">
    <div class="ib-container">
        <script type="text/javascript">
            createIBSheet("orderSheet", "100%", "400px");
        </script>
    </div>
</div>

<script type="text/javascript">
    // 전역 변수
    var orderSheetWrapper = null;

    var orderColumns = [
        {Align:"Center", SaveName:"sStatus", Header:"상태", Type:"Status", Width:0, Edit:false, EditLen:0, Sort:0, Hidden:true},
        {Align:"Center", SaveName:"CHK", Header:"", Type:"CheckBox", Width:40, Edit:true, EditLen:0, Sort:0, Hidden:false},
        {Align:"Center", SaveName:"STATUS", Header:"진행상태", Type:"Text", Width:100, Edit:false, EditLen:50, Sort:1, Hidden:false , KeyField:1},
        {Align:"Center", SaveName:"CUSTOMER_NAME", Header:"고객사", Type:"Button", Width:100, Edit:false, EditLen:100, Sort:1, Hidden:false,ClassName:'Type01'},
        {Align:"Center", SaveName:"PO_NO", Header:"발주번호", Type:"Button", Width:150, Edit:false, EditLen:50, Sort:1, Hidden:false,ClassName :'Type02'},
        {Align:"Center", SaveName:"BTN_COLUMN1", Header:"첨부(1)", Type:"Button", Width:100, Edit:false, EditLen:0, Sort:0, Hidden:false,ClassName:'Type03'},
        {Align:"Center", SaveName:"BTN_COLUMN2", Header:"버튼2", Type:"Button", Width:100, Edit:false, EditLen:0, Sort:0, Hidden:false,ClassName:'Type04'},
        {Align:"Center", SaveName:"BTN_COLUMN3", Header:"버튼3", Type:"Button", Width:100, Edit:false, EditLen:0, Sort:0, Hidden:false,ClassName:'Type05'},
        {Align:"Center", SaveName:"PO_DATE_BTN", Header:"발주일", Type:"Combo", Width:100, Edit:true, EditLen:50, Sort:0, Hidden:false, ComboText:"수주접수|미등록|등록완료|첨부 (1)|완료", ComboCode:"수주접수|미등록|등록완료|첨부 (1)|완료"},
        {Align:"Center", SaveName:"IMAGE_COL", Header:"이미지", Type:"Image", Width:80, Edit:false, EditLen:0, Sort:0, Hidden:false},
        {Align:"Center", SaveName:"INVOICE_NO", Header:"거래명세서번호", Type:"Text", Width:150, Edit:true, EditLen:50, Sort:1, Hidden:false,KeyField:1},
        {Align:"Center", SaveName:"INPUT_FIELD", Header:"입력필드", Type:"Text", Width:150, Edit:true, EditLen:50, Sort:0, Hidden:false},
        {Align:"Center", SaveName:"ITEM_CODE", Header:"품목코드", Type:"Text", Width:200, Edit:false, EditLen:50, Sort:1, Rowspan:2, Colspan:2, Hidden:false},
        {Align:"Left",    SaveName:"ITEM_NAME", Header:"품목명", Type:"Text", Width:250, Edit:true, EditLen:200, Sort:1, Rowspan:2, Colspan:2, Hidden:false},
        {Align:"Left",    SaveName:"SPEC", Header:"규격", Type:"Text", Width:150, Edit:false, EditLen:100, Sort:1, Hidden:false},
        {Align:"Right",   SaveName:"UNIT_PRICE", Header:"제출단가", Type:"Int", Width:100, Edit:true, EditLen:10, Sort:1, Hidden:false, Format:"#,##0",FontColor: "#FF0000"},
        {Align:"Right",   SaveName:"QTY", Header:"수량", Type:"Int", Width:60, Edit:true, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"UNIT", Header:"단위", Type:"Text", Width:60, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"HOPE_DATE", Header:"수령희망일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"STD_DELIVERY_DATE", Header:"표준납품일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"DELIVERY_DATE", Header:"납품예정일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"DELAY_DAYS", Header:"*지연일수", Type:"Text", Width:120, Edit:false, EditLen:20, Sort:0, Hidden:false},
        {Align:"Center", SaveName:"ACTUAL_DELIVERY_DATE", Header:"납품일", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"DELIVERY_TYPE", Header:"배송유형", Type:"Text", Width:100, Edit:false, EditLen:20, Sort:1, Hidden:false},
        {Align:"Center", SaveName:"PRE_ARRIVAL", Header:"선입고여부", Type:"Date", Width:120, Edit:false, EditLen:10, Sort:1, Hidden:false},
        {Align:"Left", SaveName:"KEP_MANAGER", Header:"KeP담당자", Type:"Text", Width:200, Edit:false, EditLen:100, Sort:1, Hidden:false},
        {Align:"Left", SaveName:"REMARK", Header:"비고", Type:"Text", Width:120, Edit:true, EditLen:200, Sort:1, Hidden:false}
    ];

    // IBSheetWrapper 사용 (참조 파일과 동일)
    var mySheet = new IBSheetWrapper("orderSheet", "수주접수목록");
    mySheet.initialize(orderColumns);
    mySheet.SetHeaderRowHeight(40);
 mySheet.SetDataRowHeight(40);
    console.log('IBSheet 초기화 완료');

    // 샘플 데이터 로드
    loadOrderReceiptData();




    // 수주접수 샘플 데이터 로드
    function loadOrderReceiptData() {
        try {
            if (!window.orderSheet) {
                console.error('IBSheet가 초기화되지 않았습니다.');
                return;
            }

            // 기존 데이터 삭제
            window.orderSheet.RemoveAll();

            var sampleData = {
                data: [
                    {
                        CHK: 0,
                        STATUS: "수주접수대상",
                        CUSTOMER_NAME: "수주접수",
                        PO_NO: "PO25000045",
                        BTN_COLUMN1: "첨부(1)",
                        BTN_COLUMN2: "버튼2",
                        BTN_COLUMN3: "버튼3",
                        PO_DATE_BTN: "수주접수",
                        IMAGE_COL: "../resources/images/b_Manual004.gif",
                        INVOICE_NO: "IV2535455",
                        INPUT_FIELD: "입력값1",
                        ITEM_CODE: "IMG001",
                        ITEM_NAME: "스카치테이프 투명 24mm",
                        SPEC: "24mm x 50m",
                        UNIT_PRICE: 9000,
                        QTY: 4,
                        UNIT: "EA",
                        HOPE_DATE: "20250715",
                        STD_DELIVERY_DATE: "20250715",
                        DELIVERY_DATE: "20250715",
                        DELAY_DAYS: "-1일",
                        ACTUAL_DELIVERY_DATE: "20250715",
                        DELIVERY_TYPE: "택배",
                        PRE_ARRIVAL: "20250715",
                        KEP_MANAGER: "이이이(25-2585-5689)",
                        REMARK: "비고"
                    },
                    {
                        CHK: 0,
                        STATUS: "미등록",
                        CUSTOMER_NAME: "수주접수",
                        PO_NO: "PO25000046",
                        BTN_COLUMN1: "첨부(1)",
                        BTN_COLUMN2: "버튼2",
                        BTN_COLUMN3: "버튼3",
                        PO_DATE_BTN: "미등록",
                        IMAGE_COL: "../resources/images/b_img_printer.gif",
                        INVOICE_NO: "IV2535456",
                        INPUT_FIELD: "입력값2",
                        ITEM_CODE: "FEOWEJFJIWIFWF",
                        ITEM_NAME: "품목명",
                        SPEC: "스카치테이프",
                        UNIT_PRICE: 8500,
                        QTY: 2,
                        UNIT: "EA",
                        HOPE_DATE: "20250716",
                        STD_DELIVERY_DATE: "20250716",
                        DELIVERY_DATE: "20250716",
                        DELAY_DAYS: "-1일",
                        ACTUAL_DELIVERY_DATE: "20250716",
                        DELIVERY_TYPE: "택배",
                        PRE_ARRIVAL: "20250716",
                        KEP_MANAGER: "이이이(25-2585-5689)",
                        REMARK: "비고"
                    },
                    {
                        CHK: 0,
                        STATUS: "등록완료",
                        CUSTOMER_NAME: "수주접수",
                        PO_NO: "PO25000047",
                        BTN_COLUMN1: "첨부(1)",
                        BTN_COLUMN2: "단가선정",
                        BTN_COLUMN3: "버튼3",
                        PO_DATE_BTN: "등록완료",
                        IMAGE_COL: "../resources/images/b_img_t.jpg",
                        INVOICE_NO: "IV2535457",
                        INPUT_FIELD: "입력값3",
                        ITEM_CODE: "FEOWEJFJIWIFWF",
                        ITEM_NAME: "품목명품목명",
                        SPEC: "스카치테이프",
                        UNIT_PRICE: 12000,
                        QTY: 1,
                        UNIT: "EA",
                        HOPE_DATE: "20250717",
                        STD_DELIVERY_DATE: "20250717",
                        DELIVERY_DATE: "20250717",
                        DELAY_DAYS: "-1일",
                        ACTUAL_DELIVERY_DATE: "20250717",
                        DELIVERY_TYPE: "택배",
                        PRE_ARRIVAL: "20250717",
                        KEP_MANAGER: "이이이(25-2585-5689)",
                        REMARK: "비고"
                    },
                    {
                        CHK: 0,
                        STATUS: "첨부 (1)",
                        CUSTOMER_NAME: "수주접수",
                        PO_NO: "PO25000048",
                        BTN_COLUMN1: "첨부(1)",
                        BTN_COLUMN2: "단가선정",
                        BTN_COLUMN3: "버튼3",
                        PO_DATE_BTN: "첨부 (1)",
                        IMAGE_COL: "../resources/images/b_img_custservice.jpg",
                        INVOICE_NO: "IV2535458",
                        INPUT_FIELD: "입력값4",
                        ITEM_CODE: "FEOWEJFJIWIFWF",
                        ITEM_NAME: "품목명품목명",
                        SPEC: "스카치테이프",
                        UNIT_PRICE: 15000,
                        QTY: 5,
                        UNIT: "EA",
                        HOPE_DATE: "20250718",
                        STD_DELIVERY_DATE: "20250718",
                        DELIVERY_DATE: "20250718",
                        DELAY_DAYS: "-1일",
                        ACTUAL_DELIVERY_DATE: "20250718",
                        DELIVERY_TYPE: "택배",
                        PRE_ARRIVAL: "20250718",
                        KEP_MANAGER: "이이이(25-2585-5689)",
                        REMARK: "비고"
                    },
                    {
                        CHK: 0,
                        STATUS: "완료",
                        CUSTOMER_NAME: "ABC회사",
                        PO_NO: "PO25000049",
                        BTN_COLUMN1: "첨부(1)",
                        BTN_COLUMN2: "단가선정",
                        BTN_COLUMN3: "버튼3",
                        PO_DATE_BTN: "20250719",
                        IMAGE_COL: "../resources/images/PP0174.gif",
                        INVOICE_NO: "IV2535459",
                        INPUT_FIELD: "입력값5",
                        ITEM_CODE: "ABC123",
                        ITEM_NAME: "사무용품 세트",
                        SPEC: "표준형",
                        UNIT_PRICE: 25000,
                        QTY: 3,
                        UNIT: "SET",
                        HOPE_DATE: "20250719",
                        STD_DELIVERY_DATE: "20250719",
                        DELIVERY_DATE: "20250719",
                        DELAY_DAYS: "0일",
                        ACTUAL_DELIVERY_DATE: "20250719",
                        DELIVERY_TYPE: "택배",
                        PRE_ARRIVAL: "20250719",
                        KEP_MANAGER: "김김김(25-1234-5678)",
                        REMARK: "정상처리"
                    }
                ]
            };

            // 네이티브 IBSheet LoadSearchData 사용
            window.orderSheet.LoadSearchData(sampleData);

            console.log('샘플 데이터 로드 완료 - ' + sampleData.data.length + '건');

        } catch (error) {
            console.error('데이터 로드 오류:', error);
        }
    }

</script>

</body>
</html>