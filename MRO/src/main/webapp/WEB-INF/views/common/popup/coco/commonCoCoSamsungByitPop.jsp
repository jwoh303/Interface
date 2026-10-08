<%--
**********************************************
* 메뉴 : 
* 화면 : 삼성전기용카탈로그 조회
* 기능 : 삼성전기용카탈로그 조회
* 프로그램 ID : 
* 담당자 :  현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	String p_buyer = CommonUtil.nvl((String) request.getParameter("p_buyer"),"");  //  (st_buyer_code)
	String p_quotation_no = CommonUtil.nvl((String) request.getParameter("p_quotation_no"),"");  //  (p_quotation_no)
	String p_quotation_seq = CommonUtil.nvl((String) request.getParameter("p_quotation_seq"),"");  //  (p_quotation_seq)
	String p_revision = CommonUtil.nvl((String) request.getParameter("p_revision"),"");  //  (p_revision)
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
	var productGbn = KepSheetComboData("M132","SPACE");
    var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
    var diskOn = "/resources/images/disk_on.gif";
	var initsheet = {};
	initsheet.Cols = [
					{Align : "Center", SaveName :"SELECTED",     Header:"선택",				Type : "Radio",     Width : 30,      Edit : true}
					 ,{ Align:"Left",	Width:105,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드", FontColor:"#003694",	SaveName:"BUYER_ITEM_NO"}
					 ,{ Align:"Left",	Width:105,	Edit:false,	EditLen:100,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"STDCATLG_ID"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:400,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:300,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					 ,{ Align:"Left",	Width:236,	Edit:false,	EditLen:300,	Type:"Text",	Header:"KeP표준화규격",	SaveName:"REFINE_NOTE"}
					 ,{ Align:"Left",	Width:80,	Edit:false,	EditLen:300,	Type:"Text",	Header:"표준화담당자",	SaveName:"REFINE_USER_NM"}
					 ,{ Align:"Right",	Width:60,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"납품가능협력사",	SaveName:"BTOA_MNG_CNT"}
					 ,{ Align:"Left",	Width:201,	Edit:false,	EditLen:300,	Type:"Text",	Header:"협력사",	FontColor:"#003694", SaveName:"AGENT_NAME"}
					 ,{ Align:"Left",	Width:134,	Edit:false,	EditLen:300,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME"}
					 ,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매출단가",	SaveName:"UNIT_PRICE"}
					,{ Align:"Right",	Width:86,	Edit:false,	EditLen:300,	Type:"Float",	Format:"${priceFormat}", Header:"매입단가",	SaveName:"LIST_PRICE"}
					,{ Align:"Left",	Width:57,	Edit:false,	EditLen:300,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Left",	Width:105,	Edit:false,	EditLen:300,	Type:"Text",	Header:"적용구분",	SaveName:"BELOW_TEXT"}
					,{ Align:"Right",	Width:90,	Edit:false,	EditLen:300,	Type:"Text",	Header:"표준납기일",	SaveName:"DELIVERY_LT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,  Type:"Combo", Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE"}
					,{ Align:"Center",	Width:96,	Edit:false,	EditLen:300,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}
					,{ Align:"Left",	Width:77,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Ymd", Header:"등록일",	SaveName:"ADD_DATE"}
					,{ Align:"Left",	Width:77,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Ymd", Header:"수정일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Left",	Width:77,	Edit:false,	EditLen:300,	Type:"Text",	Format:"Ymd", Header:"단가유효일",	SaveName:"TO_DATE"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"모델번호",	SaveName:"MAKER_PART_NO", ColMerge:1,Sort:0}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"SG담당자",	SaveName:"SOUR_MNG", ColMerge:1,Sort:0}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"MAPP_TEXT"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BUYER"}
					,{ Align:"Left",	Width:0,	Hidden:true, Type:"Text",	Header:"",	SaveName:"BYIT_STATUS"}
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
	mySheet.SetCountPosition(4);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	//비고이미지설정
	mySheet.SetImageList(1, diskOn);
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getSgKepUserList','ALL2','');
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_sg_user_id','getSsgKepUserList','ALL2','');
}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && str !="regMsds" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	var st_buyer_item_no = TrimCommon($("#st_buyer_item_no").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			
	        if(st_description ==""&& st_buyer_item_no ==""&&  st_specification =="")
	        {
	            alert("품목코드, 품목명, 규격, 제조사 중 하나의 조건을 추가해야 조회 가능합니다..");
	            return;
	        }

			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdcmByitList.do" , "" );
			break;
		
		case "reload":	// 초기화
			document.location.href = "/coco/showCommonCoCoSamsungByitPop.do";
			break;
		case "save":	//저장하기
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			if (checkRows == '' || arrRow.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterItemNoMapping.do" , "SELECTED"  );
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
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	if(code==0){
		alert("선택한 품목코드로 변경 되었습니다.");
		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var st_buyer_item_no = "";
		var st_cms_catlg_id = "";
		for (var i=0; i<arrRow.length; i++){
			st_buyer_item_no = mySheet.GetCellValue(arrRow[i],"BUYER_ITEM_NO");
			st_cms_catlg_id = mySheet.GetCellValue(arrRow[i],"STDCATLG_ID");
		}
		opener.setPopupReturn(st_buyer_item_no,st_cms_catlg_id);
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	return;
}
	

 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">카탈로그 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
             	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    	<!--span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span  -->
            </div>
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=p_buyer%>">
				<input type="hidden" id="p_quotation_no" name="p_quotation_no"  value="<%=p_quotation_no%>">
				<input type="hidden" id="p_quotation_seq" name="p_quotation_seq"  value="<%=p_quotation_seq%>">
				<input type="hidden" id="p_revision" name="p_revision"  value="<%=p_revision%>">
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>고객사 카탈로그</caption>
						<colgroup>
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
							<col width="23%" />
						</colgroup>
					<tbody>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%"  value="" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_description_field" name="st_description_field" value=""> 
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_specification_field"  name="st_specification_field" value=""> 
							</td>
						</tr>
						<tr>
							<th>제조사</th>
							<td>
								<input type="text"   class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:87%" value="" onKeyDown="kepEnter()">
								<input type="hidden" id="st_maker_name_field"  name="st_maker_name_field" value=""> 
							</td>
							<th>전략SG담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px"></select>
							</td>
							<th></th>
							<td>
							</td>
						</tr>
					</tbody>
					</table>
	            </div>
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
  			<!--버튼영역-->
               <div class="btnArea02" >
  	          	<span class="fr">
  					<span class="btn_05 mr04"><a href="javascript:doAction('save');">품목코드변경</a></span>
  				</span>
  			 </div>
        	</div>
    	</div>
	</div>
</body>
</html>
