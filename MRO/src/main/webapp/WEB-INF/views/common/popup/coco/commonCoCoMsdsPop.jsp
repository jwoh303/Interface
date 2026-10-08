<%--
**********************************************
* 메뉴 : 
* 화면 : MSDS 조회팝업
* 기능 : MSDS 조회팝업
* 프로그램 ID : 
* 담당자 :  현명환
* 착수일 : 2015-08-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String businessCond= "";
	if (_sessionInfo != null){ 	
		businessCond =  CommonUtil.nvl((String)_sessionInfo.getBusinessCond());  		
	}
	String p_buyer = CommonUtil.nvl((String) request.getParameter("p_buyer"),"");  //  (p_buyer)
	String p_quotation_no = CommonUtil.nvl((String) request.getParameter("p_quotation_no"),"");  //  (p_quotation_no)
	String p_quotation_seq = CommonUtil.nvl((String) request.getParameter("p_quotation_seq"),"");  //  (p_quotation_seq)
	String p_revision = CommonUtil.nvl((String) request.getParameter("p_revision"),"");  //  (p_revision)
	String p_buyer_item_no = CommonUtil.nvl((String) request.getParameter("p_buyer_item_no"),"");  //  (p_buyer_item_no)
	String p_description = "";  //  (st_description)
	String p_specification = "";  //  (st_specification)
	String p_maker_name = "";  //  (st_maker_name)
	String p_unit = "";  //  (st_unit)
	String p_origin = "";  //  (st_origin)
	String p_return = CommonUtil.nvl((String) request.getParameter("p_return"),"");  //  (p_return)
	
	boolean getRoleYn = CommonUtil.getCodeCheckReturn("CM10",_sessionInfo.getUserId());
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
						 { Align:"Center",	Width:30,	Edit:true,	EditLen:25,	Type:"Radio",	Header:"선택",			SaveName:"SELECTED"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:300,Type:"Text",	Header:"MSDS NO",		SaveName:"MSDS_NO",	FontColor:"#003694"}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:25,	Type:"Text",	Header:"유해",			SaveName:"CMC_HARMFUL_YN"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:300,Type:"Text",	Header:"MSDS 제출번호",	SaveName:"MSDS_SUBMISSION_NUMBER"}
						,{ Align:"Left",	Width:180,	Edit:false,	EditLen:300,Type:"Text",	Header:"품명",			SaveName:"DESCRIPTION"  }
						,{ Align:"Left",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",			SaveName:"SPECIFICATION" }
						,{ Align:"Left",	Width:90,	Edit:false,	EditLen:300,Type:"Text",	Header:"제조사",			SaveName:"MAKER_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Date",	Header:"최종개정일",		SaveName:"LAST_REVISION_DATE"}						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Date",	Header:"수정일",			SaveName:"CHANGE_DATE"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"등록자",			SaveName:"ADD_USER_NM"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO1",		SaveName:"CAS_NO_1"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO2",		SaveName:"CAS_NO_2"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO3",		SaveName:"CAS_NO_3"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO4",		SaveName:"CAS_NO_4"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO5",		SaveName:"CAS_NO_5"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO6",		SaveName:"CAS_NO_6"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO7",		SaveName:"CAS_NO_7"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO8",		SaveName:"CAS_NO_8"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO9",		SaveName:"CAS_NO_9"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO10",		SaveName:"CAS_NO_10"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO11",		SaveName:"CAS_NO_11"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO12",		SaveName:"CAS_NO_12"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO13",		SaveName:"CAS_NO_13"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO14",		SaveName:"CAS_NO_14"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO15",		SaveName:"CAS_NO_15"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO16",		SaveName:"CAS_NO_16"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO17",		SaveName:"CAS_NO_17"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO18",		SaveName:"CAS_NO_18"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO19",		SaveName:"CAS_NO_19"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"CAS NO20",		SaveName:"CAS_NO_20"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "MSDS_NO");
}

//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && str !="regMsds" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var st_msds_no = TrimCommon($("#st_msds_no").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_submission_number = TrimCommon($("#st_submission_number").val());
	var st_cas_no = TrimCommon($("#st_cas_no").val());
	var st_maker_name = TrimCommon($("#st_maker_name").val());
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			
	        if(st_msds_no == "" && st_description ==""&& st_submission_number ==""&& st_cas_no ==""&& st_specification =="" && st_maker_name=="")
	        {
	            alert("조회조건을 입력해야 조회 가능합니다.");
	            return;
	        }

			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMsdsList.do" , "" );
			break;
		
		case "reload":	// 초기화
			document.location.href = "/coco/showCommonCoCoMsdsPop.do";
			break;
		case "regMsds":	// MSDS등록하기 팝업 호출
			var p_description = TrimCommon($("#st_description").val());
			var p_specification = TrimCommon($("#st_specification").val());
			var p_maker_name = TrimCommon($("#st_maker_name").val());
			
			openSearchPopup("/coco/showCommonCoCoMsdsDetailRegPop.do","?p_description="+p_description+"&p_specification="+p_specification+"&p_maker_name="+p_maker_name+"&p_unit="+p_unit+"&p_origin="+p_origin, "750,580,no");
			break;
		case "msDs":	// 매핑
			var checkRows = mySheet.FindCheckedRow("SELECTED");
			var arrRow = checkRows.split("|");
			if (checkRows == '' || arrRow.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			//물질관리 시스템일경우
			if($("#p_return").val()=="CHEMICAL"){
				var msdsNo = mySheet.GetCellValue(arrRow, "MSDS_NO");
				var harmful_yn = mySheet.GetCellValue(arrRow, "CMC_HARMFUL_YN");
				
				opener.setPopupReturn(msdsNo, harmful_yn);
				this.close();				
			}else{
				var p_quotation_no = TrimCommon($("#p_quotation_no").val());
				var p_quotation_seq = TrimCommon($("#p_quotation_seq").val());
				var p_revision = TrimCommon($("#p_revision").val());
				var p_return = TrimCommon($("#p_return").val());
				if(p_return=="R"){
					$("#p_return").val("R");
				}else{
					$("#p_return").val("C");
				}
				if(p_quotation_no =="" & p_quotation_seq=="" & p_revision==""){
					//BYIT 매핑
					kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMsdsByitMapping.do" , "SELECTED"  );				
				}else{
					//견적 매핑
					kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMsdsMapping.do" , "SELECTED"  );	
				}				
			}
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
		alert("매핑 완료되었습니다.");
		//저장 성공시 재조회
		opener.opener_searchData();
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == 'MSDS_NO'){ // MSDS
		var st_msds_no = mySheet.GetCellValue(Row,"MSDS_NO");
		var businessCond = "<%=businessCond%>";
		var st_btn_yn =  "";
		//협력사일경우 수정 불가.
		if(businessCond =="S"){
			st_btn_yn =  "N";
		}else{
			st_btn_yn =  "Y";
		}
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+st_msds_no+"&st_btn_yn="+st_btn_yn, "750,580,no");
	}
	
	return;
}
	

 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">MSDS 매핑 조회 </h1>
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
				<input type="hidden" id="p_description" name="p_description"  value="<%=p_description%>">
				<input type="hidden" id="p_specification" name="p_specification"  value="<%=p_specification%>">
				<input type="hidden" id="p_maker_name" name="p_maker_name"  value="<%=p_maker_name%>">
				<input type="hidden" id="p_buyer" name="p_buyer"  value="<%=p_buyer %>">
				<input type="hidden" id="p_quotation_no" name="p_quotation_no"  value="<%=p_quotation_no%>">
				<input type="hidden" id="p_quotation_seq" name="p_quotation_seq"  value="<%=p_quotation_seq%>">
				<input type="hidden" id="p_revision" name="p_revision"  value="<%=p_revision%>">
				<input type="hidden" id="p_revision" name="p_buyer_item_no"  value="<%=p_buyer_item_no%>">
				<input type="hidden" id="p_unit" name="p_unit"  value="<%=p_unit%>">
				<input type="hidden" id="p_origin" name="p_origin"  value="<%=p_origin%>">
				<input type="hidden" id="p_return" name="p_return"  value="<%=p_return%>">
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
								<th>MSDS NO</th>
								<td>
									<input type="text" class="input_type_text" id="st_msds_no" name="st_msds_no" style="width:80%;" value="" onkeydown="kepEnter()">
								</td>
								<th>품명</th>
								<td>
									<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" value="<%=p_description%>" onkeydown="kepEnter()">
								</td>	
								<th>규격</th>
								<td>
									<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:80%;" value="<%=p_specification%>" onkeydown="kepEnter()">
								</td>
							</tr>
							<tr> 
								<td>제출번호</td>
								<td>
									<input type="text" class="input_type_text"  name="st_submission_number" id="st_submission_number" style="width:80%;" value="" onKeyDown="kepEnter()"> 
								</td>
								<td>CAS NO</td>
								<td>
									<input type="text" class="input_type_text"  name="st_cas_no" id="st_cas_no" style="width:80%;" value="" onKeyDown="kepEnter()"> 
								</td>
								<td>제조사</td>
								<td>
									<input type="text" class="input_type_text"  name="st_maker_name" id="st_maker_name" style="width:80%;" value="" onKeyDown="kepEnter()"> 
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
  	          	<%if(getRoleYn== true){ %>
  	          		<span class="btn_05 mr04"><a href="javascript:doAction('regMsds');">MSDS등록하기</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('msDs');">매핑하기</a></span>
  				<%}%>
  				</span>
  			 </div>
        	</div>
    	</div>
	</div>
</body>
</html>
