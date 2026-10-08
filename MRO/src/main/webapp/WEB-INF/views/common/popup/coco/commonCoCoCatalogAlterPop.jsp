<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 카탈로그 조회 팝업
* 기능 : 고객사 카탈로그 조회 팝업
* 프로그램 ID : PG_04_M_005_11
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
</head>

<script type="text/javascript">
// <!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Left",	Width:105,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드", FontColor:"#003694",	SaveName:"BUYER_ITEM_NO"}
					 ,{ Align:"Left",	Width:105,	Edit:false,	EditLen:100,	Type:"Text",	Header:"표준코드",	SaveName:"STDCATLG_ID"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:400,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:300,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					 ,{ Align:"Left",	Width:201,	Edit:false,	EditLen:300,	Type:"Text",	Header:"협력사",	FontColor:"#003694", SaveName:"AGENT_NAME"}
					 ,{ Align:"Left",	Width:134,	Edit:false,	EditLen:300,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME"}
					 ,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매출단가",	SaveName:"UNIT_PRICE"}
					,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매입단가",	SaveName:"LIST_PRICE"}
					,{ Align:"Left",	Width:57,	Edit:false,	EditLen:300,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:300,	Type:"Text",	Header:"적용구분",	SaveName:"BELOW_TEXT"}
					,{ Align:"Center",	Width:96,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Left",	Width:77,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Ymd", Header:"수정일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"MAPP_TEXT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BUYER"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BYIT_STATUS"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"STDCATLG_ID"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"STDCATEG_ID"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"PRODUCT_CLOSE_FLAG"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BELOW_COMORG_CODE"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CQDT_STATUS"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CONTRACT_NO"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"CQEP_CNT"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "AGENT_NAME");
}

//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = TrimCommon($("#st_buyer_code").val());

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			
	        if(buyer == ""){
	            alert("고객사를 선택해 주십시요.");
	            return;
	        }
	        //조건 한개라도 넣어야 조회 가능.
	        var st_categ_id = TrimCommon($("#st_categ_id").val());
	        var st_buyer_item_no = TrimCommon($("#st_buyer_item_no").val());
	        var st_description = TrimCommon($("#st_description").val());
	        var st_specification = TrimCommon($("#st_specification").val());
	        var st_maker_name = TrimCommon($("#st_maker_name").val());
	        
	        if(st_categ_id ==""&&st_buyer_item_no ==""&&st_description ==""&&st_specification ==""&&st_maker_name ==""){
	            alert("고객사 이외 한개 항목 이상의 검색조건을 입력 바랍니다.");
	            return;	        	
	        }
	
			//결과내 검색
			setQuerySearchInResult();
			//그룹카탈로그 조회 여부
			if(document.getElementById("searchInGroup").checked == true){
				 $("#st_group_type").val('Y');		
			}else{
				 $("#st_group_type").val('N');					
			}	
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogAlterList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			document.location.href = "/coco/showCommonCoCoCatalogAlterPop.do";

			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	
	for(var i=1; i<=totRow;i++){
		var cqepCnt = mySheet.GetCellValue(i,"CQEP_CNT");
		if(cqepCnt > 1){
			mySheet.SetCellFontColor(i,"UNIT_PRICE","#ed5e00");
			mySheet.SetCellFontBold(i, "UNIT_PRICE",1);
			mySheet.SetCellFontColor(i,"LIST_PRICE","#ed5e00");
			mySheet.SetCellFontBold(i, "LIST_PRICE",1);
			mySheet.SetDataLinkMouse("UNIT_PRICE", 1);
			mySheet.SetDataLinkMouse("LIST_PRICE", 1);
		}
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogAlterList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		
		case "agent_single": // 공급사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "agent_single";
			break;	
		
		case "commonCoCoBuyerCategoryChoicePop": 
			//SLOGIC-BEGIN(P03-3020-02) 
			// 고객사카테고리 선택
			var buyer_code = TrimCommon($("#st_buyer_code").val());
			popupSel = "commonCoCoBuyerCategoryChoicePop";
			
	        if(buyer_code == "")
	        {
	            alert("고객사를 선택해 주십시요.");
	            return;
	        }else {
				if( buyer_code == "KRKEPB0007" || buyer_code == "KRDDDD0001" || buyer_code == "KRHYUN0026" || buyer_code == "KRHYUN0033" || buyer_code == "KRKYUN0002" || buyer_code == "KRISUC0002" || buyer_code == "KRISUC0007")
				{
					popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
			    	openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do", "?st_buyer="+buyer_code, "400,500,no");
				}else if( buyer_code == "KRDOOD0001" || buyer_code == "KRDOOS0004" || buyer_code == "KRILJI0003" || buyer_code == "KRILJI0026" || buyer_code == "KRILJI0043" || buyer_code == "KRHSDE0003" || buyer_code == "KRDOOS0072"){
					openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", "?st_buyer="+buyer_code+"&st_flag=REG", "728,710,no");
		        }else {
					openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", "?st_buyer="+buyer_code+"&st_flag=REG", "728,710,no");
		        }
	        }
			break;
			//SLOGIC-END
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'UNIT_PRICE') { // 매출단가 선택
		setSysopCqepHistory(Row);
		
	} else if (column == 'LIST_PRICE') { // 매입단가 선택
		setSysopCqepHistory(Row);

	} else if(column == 'BUYER_ITEM_NO'){ // 품목코드 선택
		var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
		var buyer = $("#st_buyer_code").val();
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"988,768,no");
		
	}else if(column == 'AGENT_NAME'){ // 협력사 선택
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do","?com_code="+agent, "800,600,no");
	}
	
	return;
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
		$("#st_com_org_code").val(value3);

	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리	
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value4);

	}else if (popupSel == "commonCoCoBuyerCategoryChoiceTreePop") {	// 고객사카테고리 트리형
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value7);
	}

	grbRow="";	//초기화
}

//조회조건 (결과내검색)
function setQuerySearchInResult() {
	// 결과 내 검색 로직 추가
	if($("#searchInResult").is(":checked")){ // 체크를 한 경우
		//===============품명==================//
		if($("#st_description_field").val()=="ALL") {
			$("#st_description_field").val("");
		}
		
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description_field").val()+$("#st_description").val()+"/");
		}

		//===============규격==================//
		if($("#st_specification_field").val()=="ALL") {
			$("#st_specification_field").val("");
		}
		
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification_field").val()+$("#st_specification").val()+"/");
		}

		//===============제조사==================//
		if($("#st_maker_name_field").val()=="ALL") {
			$("#st_maker_name_field").val("");
		}
		
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name_field").val()+$("#st_maker_name").val()+"/");
		}
	}else{ // 체크를 하지 않은 경우
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description").val() +"/");
		}else {
			$("#st_description_field").val("ALL");
		}
	
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification").val() +"/");
		}else {
			$("#st_specification_field").val("ALL");
		}
		
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name").val() +"/");
		}else {
			$("#st_maker_name_field").val("ALL");
		}
	}
}

//단가변경이력 팝업
function setSysopCqepHistory(Row){ 
	var buyer = mySheet.GetCellValue(Row,"BUYER");
	var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
	var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
	var cqepCnt = mySheet.GetCellValue(Row,"CQEP_CNT");
	if(cqepCnt > 1){
		openSearchPopup("/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do","?st_buyer="+buyer+"&st_contract_no="+contractNo+"&st_contract_seq="+contractSeq, "840,250,no");
	}
}
 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 카탈로그 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
             	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" name="st_group_type"  id="st_group_type" value ="">
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>고객사 카탈로그  리스트</caption>
						<colgroup>
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
	                        <col width="25%" />
						</colgroup>
						<tbody>
							<tr>
								<th><font color="red"><b>*</b></font>고객사&nbsp;</th>
								<td>
									<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:51%" value="" readonly>
									<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
									<input type="hidden" name="st_com_org_code" id="st_com_org_code" value="">
									<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>카테고리</th>
								<td>
									<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:51%" readonly>
									<input type="hidden" name="st_categ_id" id="st_categ_id" style="width:80%">
									<a href="javascript:doPop('commonCoCoBuyerCategoryChoicePop');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>	
								<th>품목코드</th>
								<td>
									<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
								</td>
							</tr>
							<tr> 
								<td>품목명</td>
								<td>
									<input type="text" class="input_type_text"  name="st_description" id="st_description" style="width:60%;" value="" onKeyDown="kepEnter()">
									<input type="hidden" id="st_description_field" name="st_description_field" value=""> 
								</td>
								<td>규격</td>
								<td>
									<input type="text" class="input_type_text"  name="st_specification" id="st_specification" style="width:60%;" value="" onKeyDown="kepEnter()">
									<input type="hidden" id="st_specification_field"  name="st_specification_field" value=""> 
								</td>
								<td>제조사</td>
								<td>
									<input type="text" class="input_type_text"  name="st_maker_name" id="st_maker_name" style="width:60%;" value="" onKeyDown="kepEnter()">
									<input type="hidden" id="st_maker_name_field"  name="st_maker_name_field" value=""> 
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
					&nbsp;&nbsp;<input type="checkbox" id="searchInGroup" name="searchInGroup">그룹카탈로그 조회
					&nbsp;&nbsp;<input type="checkbox" id="searchInResult" name="searchInResult">결과 내 검색
				</span>
            </form>
            <br/>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "354px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
        	</div>
    	</div>
	</div>
</body>
</html>
