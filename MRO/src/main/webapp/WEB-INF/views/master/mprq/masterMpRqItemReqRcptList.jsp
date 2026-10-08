<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 신규상품규격확인
* 기능 : 고객사의 견적의뢰를 조회하거나 피드백 하는 기능(예)
* 프로그램 ID : PG_04_M_002_00
* 담당자 : 김영미 (설계 : 권우재)
* 생성일 : 2014-05-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
%>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function initPage() {
		var initsheet = {};
		
		initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,	Edit : true}, 
		    			{Align : "Center",SaveName : "RFQ_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 80,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "FEEDBACK_FLAG",		Header : "진행상태",	Type : "Text",	Width : 70,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "RFQ_USER_ID",		Header : "요청자아이디",	Hidden:true, Type : "Text",	Width : 100, EditLen : 110,	Edit : false,	Hidden:1},
		    			{Align : "Center",SaveName : "ITEM_STATUS",		Header : "상품상태",	Type : "Text",	Width : 70,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "RAV_NO",		Header : "접수번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 70,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			
		    			{Align : "Center",SaveName : "KEP_BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "KEP_DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "KEP_SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 70,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_MAKER_CODE",		Header : "제조사코드(Hidden)",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden:true},
		    			{Align : "Center",SaveName : "KEP_MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지코드(Hidden)",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden:true},
		    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지명(Hidden)",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden:true},
		    			{Align : "Center",SaveName : "KEP_KEP_REMARK",		Header : "비고",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:true},
		    			{Align : "Center",SaveName : "KEP_KEP_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false, Hidden:true},

		    			{Align : "Center",SaveName : "BUYER_REMARK",		Header : "비고",	Type : "Text",	Width : 100,	EditLen : 110,	Hidden:true},
		    			{Align : "Center",SaveName : "BUYER_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "IMAGE_KEY",		Header : "첨부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:true},		    			
		    			{Align : "Center",SaveName : "IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false},		    			

		    			{Align : "Center",SaveName : "BUYER",		Header : "고객사",	Hidden:true, Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "RAV_SEQ",		Header : "검증차수", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "STATUS",		Header : "상태", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_RAV_SEQ",		Header : "KEP_RAV_SEQ", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_ITEM_STATUS",		Header : "KEP_ITEM_STATUS", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "FEEDBACK_FLAG",		Header : "FEEDBACK_FLAG", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "CONTRACT_NO", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "CONTRACT_SEQ", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_USER_ID",		Header : "KEP_USER_ID", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_PHONE_NUMBER",		Header : "KEP_PHONE_NUMBER", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
		];
		
		IBS_InitSheet2(mySheet, initsheet,pagingMode,8);

		mySheet.SetCellBackColor(0,"KEP_BUYER_ITEM_NO","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_DESCRIPTION","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_SPECIFICATION","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_UNIT_MEASURE","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_MAKER_NAME","#FFE400");
		
		//비고이미지설정
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(0, remarkOff);
		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		
		//하이퍼링크 설정
		setLinkCol(mySheet, "BUYER_REMARK_IMG");
		setLinkCol(mySheet, "IMAGE_KEY_IMG");
		
		var searchYn = "<%=searchYn%>";
		
		$("#st_buyer_code").val("<%=buyerCode%>");
		$("#st_buyer_name").val("<%=buyerName%>");
		
		if(searchYn == "Y"){
			doAction("search");
		}
	}
	
	
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
		case "search":
// 			IBS_SaveName(document.searchCondition,mySheet);
			
			current_page = -1;
		//	IBS_SaveName(mySheet);
			//조회조건 묶기
			//조회
			kepSearch(document.searchCondition,  mySheet , "/mprq/masterMpRqItemReqRcpt.do" , pagingMode );

			break;
		case "reload": 
			kepReload('searchCondition');
			$('#st_buyer_code').val("");
			$('#st_btoa_user_id').val("");
			mySheet.RemoveAll();
			break;
		case "del":		//삭제
		
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if (mySheet.RowCount() == 0){
				alert("품목이 없습니다.");
			}
			if (selectedGrid.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			} else {
				if (!confirm('선택한 품목을 삭제 하시겠습니까?'))
					return;
				kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqItemReqRcpt.do" , "SELECTED" );
			}
			break;
		case "downexcel":
			/* IBS_SaveName(document.searchCondition, mySheet);
			var param = {
				URL : "/sysop_order_progress_management_po_mainExcel.do",
				ExtendParamMethod : "POST",
				WordWrap : false,
				FileName : "발주진행관리.xlsx",
				SheetName : "발주진행관리",
				ExtendParam : FormQueryString(document.searchCondition)
			};
			mySheet.DirectDown2Excel(param); */
			break;
		}

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

		if(current_page==-1){
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		}else{
			makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
		}
		
        
	}
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		if (msg != "") {
			alert(msg);
		}
			//저장 성공시 재조회
			doAction('search');
	}
	function mySheet_OnReadyExcelDown(frm) {
		frm.removeAttribute("encoding");
		frm.removeAttribute("enctype");
		frm.submit();
	}
	
	//페이지 인덱스 눌렀을 경우 조회
	function pageSearch(param){
		//조회
		current_page = param.page;
		kepSearch(document.searchCondition ,  mySheet , "/mprq/masterMpRqItemReqRcpt.do?page="+current_page , pagingMode );
	}

	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row;		//현재 Row를 전역변수에 셋팅
		
 		if (column == "BUYER_REMARK_IMG" ){ 
			popupSel = "remark";
			var btoaRemark = mySheet.GetCellValue(Row, "BUYER_REMARK");
			var atobRemark = mySheet.GetCellValue(Row, "KEP_KEP_REMARK");
			var viewType="R";
			openSearchPopup("/common/remarkPop.do", '?st_btoa_remark='+btoaRemark+'&st_atob_remark='+atobRemark+'&viewType='+viewType, "500,310,no");
		} else if(column == "IMAGE_KEY_IMG"){
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R";
			var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
		return;
	}
	
	
	//팝업함수호출(조회조건)
	function doPop(str) {
		var url = "";
		var title = "";
		popupSel = str;
		
		switch (str) {
			case "buyer_single":
				openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
				break;
			case "user":
				if($("#st_buyer_code").val() == "") {
					alert("고객사를 선택해 주십시요.");
					break;
				}				
				openSearchPopup("/common/misUserSelectAllPop.do", '?open=Y&com_code='+$("#st_buyer_code").val(), "500,500,no");
				break;
		}
		
	}

	
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(value1, value2){
		//팝업 조회후 해당 항목에 값을 셋팅
		if (popupSel == "buyer_single") {	// 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
			
		}else if(popupSel == "user") {	//요청자
			$("#st_btoa_user_id").val(value1);
			$("#st_btoa_user_name").val(value2);

		}else if(popupSel == "remark") {	//고객사 비고
 			mySheet.SetCellValue(grbRow, 'KEP_KEP_REMARK', value2);
 			mySheet.SetCellValue(grbRow, 'KEP_KEP_REMARK_IMG', (value2!="")? remarkOn : remarkOff);
		
		}else{
			
		}
		
		grbRow="";	//초기화
		
   }
	
	
</script>
<title>신규상품 규격확인뢰</title>
</head>


<body onload="initPage()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
       		<h3>신규상품 규격확인</h3>
			<span class="btn_search"><a href="javaScript:doAction('search');">조회</a></span>
			<span class="btn_reset"><a href="javaScript:doAction('reload');">초기화</a></span>
   		</div>
            <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
            <div id="cont_searchA">
 			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag"  name="pageflag" value="1">
            	<table  class="cont_t_list01" >
						<caption>신규상품 규격확인</caption>
						<colgroup>
							<col width="12%" />
							<col width="21%" />
							<col width="12%" />
							<col width="21%" />
							<col width="12%" />
							<col width="21%" />
						</colgroup>
						
						<tbody>
						<tr>
								<th>고객사</th>
								<td>			 
									<input type="hidden" id="st_buyer_code" name="st_buyer_code" style="width:55%" value="">
									<input type="text" id="st_buyer_name"  name="st_buyer_name" style="width:55%" value="" readonly onclick="doPop('buyer_multi')">
									<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                            </td>
							    <th>요청자</th>
								<td>
										<input type="hidden" id="st_btoa_user_id" name="st_btoa_user_id" style="width:55%" value="">
										<input type="text" id="st_btoa_user_name"  name="st_btoa_user_name" style="width:55%" value="" readonly>
										<a href="javascript:doPop('user');"><img src="/resources/images/btn_search03.gif"></a>
										<a href="javascript:kepEraser('st_btoa_user_id','st_btoa_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                            </td>
							    <th>접수번호</th>
								<td>
										<input type="text" id="st_ser_rav_no"  name="st_ser_rav_no" style="width:87%" value="" onkeyup="kepToUpper('st_ser_rav_no')" onkeydown="kepEnter()">
	                            </td>
                            </tr>
                            <tr>
	 						    <th>품목명</th>
								<td><input type="text" id="st_se_description"  name="st_se_description" style="width:87%;" value="" onkeydown="kepEnter()"></td>	
								<th>상태조회</th>
								<td>
									<select id="st_fb_flag" name="st_fb_flag" style="width:90%;height:20px;">
										<option value="" selected="selected">전체</option>
										<option value="Y" >확인</option>
										<option value="N" >미확인</option>
									</select>
								</td>
								<th></th><td></td>
					</tbody>
				</table>
				
            </div>
            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
                	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select id="onepagerow" name="onepagerow" style="width: 70px;" >
						<option value="10" selected>10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
					</select></span>
					<br>
		</form>
					
       	<!--grid-->
		<div style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		<!--버튼영역-->
              <p class="btnArea"> 
			<span class="fr btn_02"><a href="javaScript:doAction('del');">삭제</a></span>
		 </p>
<!--내용 종료-->	                 
</body>
</html>
