<%--
**********************************************
* 메뉴 : 
* 화면 : 품목정비 요청 히스트토리 팝업
* 기능 : 품목정비 요청 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2017-02-23
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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
	    			, {Align : "Center",SaveName : "REVISION",		Header : "차수",	Type : "Text",	Width : 50,	EditLen : 110,Hidden:false, Edit : false}
	    			, {Align : "Center",SaveName : "STATUS_NM",		Header : "진행상태",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false}
	    			,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 품목명",	SaveName:"DESCRIPTION_LOC"}
	    			,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 규격",	SaveName:"SPECIFICATION"}
	    			,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 제조사",	SaveName:"MAKER_NAME"}
	    			,{ Align:"Left",	Width:90,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 원산지",	SaveName:"ORIGIN_NAME"}
	    			,{ Align:"Left",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 단위",	SaveName:"UNIT_MEASURE"}
	    			,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"보완요청 MSDS",	SaveName:"MSDS_YN"}
	    			,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,		Type:"Image",	Header:"이미지(협력사)",	SaveName:"IMGFILE_NAME_IMG", BackColor:"${optColor}"}
	    			,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Image",	Header:"협력사비고",	SaveName:"STOA_REMARK_IMG", BackColor:"${optColor}"}
	    			, {Align : "Center",SaveName : "ADD_DATE",		Header : "등록일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NAME"}
	    			, {Align : "Center",SaveName : "CHANGE_DATE",		Header : "수정일",	Type : "Date",	Width : 90,	EditLen : 110,Hidden:false, Edit : false}
	    			,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,		Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NAME"}
	    			,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"STOA_REMARK",	SaveName:"STOA_REMARK"}
	    			,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"IMGFILE_DIR",	SaveName:"IMGFILE_DIR"}
	    			,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	Hidden : true,	Type:"Text",	Header:"IMGFILE_NAME",	SaveName:"IMGFILE_NAME"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(3, diskOn);
	mySheet.SetImageList(2, diskOff);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getCmsComplementHistoryPop.do" , pagingMode );
}

var st;
var mt;

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	 if (column == "STOA_REMARK_IMG"){
			var remark = mySheet.GetCellValue(Row,"STOA_REMARK");
			if(remark == ""){
				alert("등록된 비고 내용이 없습니다.");
				return;
			}else{
				openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark='+remark , "500,220,no");	
			}
	}else if(column == "IMGFILE_NAME_IMG"){//운영사 품목 이미지
		var st_imgfile_dir = mySheet.GetCellValue(Row, "IMGFILE_DIR");
		var st_imgfile_name = mySheet.GetCellValue(Row, "IMGFILE_NAME");
		var mod_yn = "N"; //수정여부
		var st_type = "S"; //협력사일경우
		if(st_imgfile_name == ""){
			alert("품목 이미지가 없습니다.");
			return;
		}
		openSearchPopup("/common/addImagePop.do", '?st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
	}
	return;
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	<input type="hidden" id="st_req_no"  name="st_req_no" value="${param.st_req_no}">	

	<!-- 500*350 -->
	<div id="popWrapper" style="height:502px;">
    	<div id="popHeader">
        	<h1 class="title">품목정비 요청이력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <div id="popContainer">
			<!--팝업내용입니다-->
			<div id="a" style="height:15px;padding-top:4px;">
				<input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" readonly="readonly" style="width:90%;height:15px;font-color:#FF0000;border:0;color:orange; font-weight:bold;" value="" />
				</span> 
			</div>
	        <div id="a" class="mt10">
	        	<!--grid-->
	 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "300px");
					</script>
				</div>
			</div>
        </div>
    </div>
</form>
		
</body>
</html>
