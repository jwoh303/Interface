<%--
**********************************************
* 메뉴 : 협력사 일괄선정 > 협력사 선정
* 화면 : 협력사 선정
* 기능 : 
* 프로그램 ID : PG_04_M_007_08 
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-022
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "Radio",	Width : 30,	EditLen : 50}, 
		    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "공급사",	Type : "Text",	Width : 140,	EditLen : 110},
		    			{Align : "Center",SaveName : "AGENT",		Header : "공급사",	Type : "Text",	Width : 120,	EditLen : 110,Hidden:true},
		    			{Align : "Right",SaveName : "ITEM_CNT",		Header : "품목수",	Type : "Int",	 Format:"${qtyFormat}", Width : 80, EditLen : 110,	Edit : false},
		    			{Align : "Right",SaveName : "TOT_AMT",		Header : "합계금액",	Type:"Float",	 Format:"${priceFormat}", 	Width : 90, EditLen : 110,	Edit : false}
		];
		
		IBS_InitSheet2(mySheet, initsheet,pagingMode,0);
		mySheet.SetCountPosition(4);
		
		kepSearch(document.searchCondition ,  mySheet ,"/mprq/getSellerChoice4Pop.do", pagingMode );
		cntSearch();
	}
	
	function cntSearch()
	{
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mprq/getSellerChoice4CntPop.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { st_buyer: $("#st_buyer").val(),st_quotation_no: $("#st_quotation_no").val(),st_revision: $("#st_revision").val()},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	if (response.data.length > 0){
						$("#st_tot_cnt").val($.trim(eval("response.data[0].TOT_CNT")));
						$("#st_item_cnt").val($.trim(eval("response.data[0].ITEM_CNT")));
		    	 	}
			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }	
		 }); 
	}
	
	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
	
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

    	
		if (msg != "") {
			alert(msg);
		}
	}
	
	//확인
	function kepConfirm()
	{ 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		if (selectedGrid.length == 0) {
			alert("협력사를 선택하여 주십시요.");
			return;
		}
		var arrRow     = selectedGrid.split("|");	
	
	    var value1 = mySheet.GetCellValue(arrRow[0], "AGENT");
	    var value2 = mySheet.GetCellValue(arrRow[0], "AGENT_NAME");

	    opener.setPopupReturn(value1,value2);
	    this.close();
	}
	
</script>
<title>코리아 e 플랫폼</title>
</head>


<body onload="initPage();">

<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="${param.st_quotation_no}">	
	<input type="hidden" id="st_revision"  name="st_revision" value="${param.st_revision}">	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:300px;">
    	<div id="popHeader">
        	<h1 class="title">협력사선택 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="width:270px;position:absolute; right:0;">
				<span class="text11">※ 총 품목수 : <input type="text" id="st_tot_cnt" name="st_tot_cnt" class="input_type_text" value="" style="width:30px;border:0"> 
											    ※ 선정대상 품목수 : <input type="text" id="st_item_cnt" name="st_item_cnt" class="input_type_text" value="" style="width:30px;border:0">
				</span>
			</div>
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c" class="mt25">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "169px");
				</script>
			</div>
			<!--버튼영역-->
	        <div class="mr25 mt05" style="height:22px;">
				<span class="fr">
					<span class="btn_02"><a href="javascript:kepConfirm();">확인</a></span>
				</span>
	        </div>
		</div>
			
    </div>
    </form>
</body>
</html>
