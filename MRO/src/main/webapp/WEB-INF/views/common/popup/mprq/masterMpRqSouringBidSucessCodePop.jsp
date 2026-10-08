<%--
**********************************************
* 메뉴 : 
* 화면 : 업체선정사유
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-03
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
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:true}, 
		    			{Align : "Center",SaveName : "CODE",		Header : "사유코드",	Type : "Text",	Width : 120,	EditLen : 110},
		    			{Align : "Left",SaveName : "TEXT1",		Header : "사유내역",	Type : "Text",	Width : 330, EditLen : 110,	Edit : false}
		];
		
		IBS_InitSheet(mySheet, initsheet,pagingMode);

		//하이퍼링크 설정
		setLinkCol(mySheet, "CODE");
		
		kepSearch(document.searchCondition ,  mySheet ,"/mprq/getBidSucessCodePop.do", pagingMode );
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
	
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		
		grbRow = Row;
		
		if (column == "CODE" ){ 
 			kepConfirm();
		}
		return;
	}
	
	//확인
   function kepConfirm()
   { 
     var value1 = mySheet.GetCellValue(grbRow, "CODE");
     var value2 = mySheet.GetCellValue(grbRow, "TEXT1");
     var value3 = "";
     
     if (value1=="BS08") {// 기타 
     	if (kepIsValueNull($('#bid_success_reason').val())){
     		alert("선정사유가 기타이면 비고를 입력 해야합니다.");
			return;
     	}
     	var remark_len	= kepGetByteLength('bid_success_reason');
     	if(remark_len > 200) {
     		alert("비고는 200Bytes까지 입력가능합니다.");
     	}
     	value3 = $('#bid_success_reason').val();
     }
     opener.setBidSuccessCode(value1,value2,value3);
     this.close();
   }
	
   function checkRemarkLength(check_length) {
		var remark_len	= kepGetByteLength('bid_success_reason');

		if(remark_len > check_length) {
	
			if(event.keyCode != '8') {

				alert(check_length + " 바이트까지 입력이 가능합니다.");

				var remark	= $('#bid_success_reason').val();

				$('#bid_success_reason').val(remark.substring(0, remark.length - 1));

			}

		}

		$('#bytes_chk').val(kepGetByteLength('bid_success_reason'));
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
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:300x;">
    	<div id="popHeader">
        	<h1 class="title">업체 선정 사유</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>

        <!--팝업내용입니다-->
        <div id="popContainer">

	       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "180px");
					</script>
			</div>
			<table class="cont_t_list05">
				<tr>
					<th style="width:119px;">비고<br>
						<input type="text" name="bytes_chk" id="bytes_chk" style="width:25px;text-align:right; border: solid 0px #bfd0e4;background-color: #bfd0e4;font-family: 돋움;font-weight: bold" readonly >/200
					</th>
					<td>
						<textarea name="bid_success_reason" id="bid_success_reason" style="width:100%; overflow:auto; border-color:white; border-width:0; ime-mode:active;"  rows="5" onKeyUp="checkRemarkLength(200);"></textarea>		
					</td>
				</tr>
			</table>
        </div>
    </div>
    </form>
</body>
</html>
