<%--
**********************************************
* 메뉴 : 
* 화면 : KeP 표준카탈로그 추천팝업 
* 기능 : 표준카탈로그를 DQCAT을 이용, 선택한다
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2017-07-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String st_desc = CommonUtil.nvl((String) request.getParameter("catlg_desc_flow"),"");
String st_spec = CommonUtil.nvl((String) request.getParameter("catlg_spec_flow"),"");
String st_maker = CommonUtil.nvl((String) request.getParameter("catlg_maker_flow"),""); 
String st_model = CommonUtil.nvl((String) request.getParameter("catlg_model_flow"),"");
String st_opener_row = CommonUtil.nvl((String) request.getParameter("catlg_row_num"),"");

String st_buyer = CommonUtil.nvl((String) request.getParameter("catlg_buyer"),"");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("catlg_quotation_no"),"");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("catlg_quotation_seq"),"");
String st_revision = CommonUtil.nvl((String) request.getParameter("catlg_revision"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("catlg_type"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var opener_row_no = "<%=st_opener_row%>";
var st_type = "<%=st_type%>";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [  
		    			{Align : "Center",	SaveName : "NO",								Header : "순위",					Type : "Text",		Width : 40,		EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "IMG",								Header : "이미지",				Type : "Image",	Width : 70,		ImgWidth: 60,	Edit:false},
		    			{Align : "Center",	SaveName : "CMS_CATLG_ID",				Header : "표준카탈로그코드",	Type : "Text",		Width : 110,	EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Left",		SaveName : "DESCRIPTION",					Header : "품명(표준)",			Type : "Text",		Width : 130,	EditLen : 110,	Edit : false,	Hidden : false,	Wrap:1},
		    			{Align : "Left",		SaveName : "SPECIFICATION",				Header : "규격(표준)",			Type : "Text",		Width : 160,	EditLen : 110,	Edit : false,	Hidden : false,	Wrap:1},
		    			{Align : "Left",		SaveName : "MAKER_NAME",					Header : "제조사(표준)",		Type : "Text",		Width : 120,	EditLen : 110,	Edit : false,	Hidden : false,	Wrap:1},
		    			{Align : "Center",	SaveName : "UNIT_MEASURE",				Header : "단위(표준)",			Type : "Text",		Width : 70,		EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "ITEM_GUBUN",					Header : "품목구분(표준)",		Type : "Text",		Width : 100,	EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Left",		SaveName : "ORIGIN_NAME",					Header : "원산지(표준)",		Type : "Text",		Width : 90,		EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "ACCU_RATE",					Header : "정확도(%)",			Type : "Text",		Width : 70,		EditLen : 100,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "CATALOG_CHOICE_TYPE",	Header : "CHOICE_TYPE",		Type : "Text",		Width : 60,		EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "IMG_DIR",							Header : "이미지경로",			Type : "Text",		Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "IMG_NAME",						Header : "이미지파일명",		Type : "Text",		Width : 80,		EditLen : 110,	Edit : false,	Hidden : true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "IMG");
	
	var description = "<%=st_desc%>";
	var specification = "<%=st_spec%>";
	var maker = "<%=st_maker%>";
	var model = "<%=st_model%>";
	
	$('#catlg_desc').val(unescape(description));
	$('#catlg_spec').val(unescape(specification));
	$('#catlg_maker').val(unescape(maker));
	$('#catlg_model').val(unescape(model));
	$('#opener_row_no').val(unescape(opener_row_no));
	
	if($('#catlg_maker').val() == ""){
		document.getElementById("chk_maker_flag").checked = false;
	}
	
	if($('#catlg_model').val() == ""){
		document.getElementById("chk_model_flag").checked = false;
	}
	
	doAction('search');
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회

			mySheet.RemoveAll();
		
			if(document.getElementById("chk_desc_flag").checked == true){
				$('#catlg_desc_flag').val('true');
			}else{
				$('#catlg_desc_flag').val('false');
			}
			
			if(document.getElementById("chk_spec_flag").checked == true){
				$('#catlg_spec_flag').val('true');
			}else{
				$('#catlg_spec_flag').val('false');
			}
			
			if(document.getElementById("chk_maker_flag").checked == true){
				$('#catlg_maker_flag').val('true');
			}else{
				$('#catlg_maker_flag').val('false');
			}
			
			if(document.getElementById("chk_model_flag").checked == true){
				$('#catlg_model_flag').val('true');
			}else{
				$('#catlg_model_flag').val('false');
			}
			
			kepAjaxFormCall("/mprq/searchCatlgAutoSetting.do","catlgForm","DQCAT");
			break;
			
		case "manual":
		    opener.setPopupReturn(
					"manual",
					opener_row_no
			);
			
			this.close();
			
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "DQCAT"){
		var totRow = $('#catlg_target_count').val();
		
		// 순위별 값 세팅(ex response.cmsCatlgId1 = 1순위, response.cmsCatlgId5 = 5순위)
		for(var i=1; i<=totRow;i++){
			var cmsCatlgId = "response.cmsCatlgId"+i;
			var pr = "response.pr"+i;
			var desc = "response.desc"+i;
			var spec = "response.spec"+i;
			var makerName = "response.makerName"+i;
			var originName = "response.originName"+i;
			var unitMeasure = "response.unitMeasure"+i;
			var itemGubun = "response.itemGubun"+i;
			var imgfileDir = "response.imgfileDir"+i;
			var imgfileName = "response.imgfileName"+i;
			
			var text_cmsCatlgId = eval(cmsCatlgId);
			var text_pr = eval(pr);
			var text_desc = eval(desc);
			var text_spec = eval(spec);
			var text_makerName = eval(makerName);
			var text_originName = eval(originName);
			var text_unitMeasure = eval(unitMeasure);
			var text_itemGubun = eval(itemGubun);
			var text_img_dir = eval(imgfileDir);
			var text_img_name = eval(imgfileName);
			var text_img = text_img_dir + "/"+text_img_name;
			
			if(eval(cmsCatlgId) != null){
				var rows = mySheet.DataInsert(-1);
			
				mySheet.SetCellValue(rows, "NO", i);
				if(text_img == "/"){ // 이미지가 없는 경우 "/" 로 return 됨
					mySheet.SetCellValue(rows, "IMG", "/resources/images/icon_emptyimg.gif");
				}else{
					mySheet.SetCellValue(rows, "IMG", "/item_image/" + text_img);
				}
				mySheet.SetCellValue(rows, "CMS_CATLG_ID", text_cmsCatlgId);
				mySheet.SetCellValue(rows, "DESCRIPTION", text_desc);
				mySheet.SetCellValue(rows, "SPECIFICATION", text_spec);
				mySheet.SetCellValue(rows, "MAKER_NAME", text_makerName);
				mySheet.SetCellValue(rows, "UNIT_MEASURE", text_unitMeasure);
				mySheet.SetCellValue(rows, "ITEM_GUBUN", text_itemGubun);
				mySheet.SetCellValue(rows, "ORIGIN_NAME", text_originName);
				mySheet.SetCellValue(rows, "ACCU_RATE", text_pr);
				mySheet.SetCellValue(rows, "CATALOG_CHOICE_TYPE", "DQCAT02");
				mySheet.SetCellValue(rows, "IMG_DIR", text_img_dir);
				mySheet.SetCellValue(rows, "IMG_NAME", text_img_name);
			}else{
				alert("조회된 데이터가 없습니다.");
				return;
			}
		}
    }else if(pMethod == "SAVE"){
    	var rtn_cms_catlg_id = mySheet.GetCellValue(grbRow,"CMS_CATLG_ID");
		var rtn_choice_type = mySheet.GetCellValue(grbRow,"CATALOG_CHOICE_TYPE");
		
		opener.setPopupReturn(
				rtn_cms_catlg_id,
				opener_row_no,
				rtn_choice_type
		);
		
		this.close();
    }
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	if(column == "CMS_CATLG_ID" ){
		if(st_type == "RQDT"){
			var cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
			var img_dir = mySheet.GetCellValue(Row,"IMG_DIR");
			var img_name = mySheet.GetCellValue(Row,"IMG_NAME");
			
			document.forms.catlgForm.st_cms_catalgid.value = cms_catlg_id;
			document.forms.catlgForm.st_imgfile_dir.value = img_dir;
			document.forms.catlgForm.st_imgfile_name.value = img_name;
			
			kepAjaxFormCall("/mprq/saveMasterMpRqStndCatalgListPop.do","catlgForm","SAVE");
		}else{
			var rtn_cms_catlg_id = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
			var rtn_choice_type = mySheet.GetCellValue(Row,"CATALOG_CHOICE_TYPE");
			
			opener.setPopupReturn(
					rtn_cms_catlg_id,
					opener_row_no,
					rtn_choice_type
			);
			
			this.close();
		}
	}else if (column == "IMG"){
		var strImg = mySheet.GetCellValue(Row,"IMG");
		if(strImg == "/resources/images/icon_emptyimg.gif"){
			alert("등록된 이미지가 없습니다.");
			return;
		}else{
			window.open('<%= CommonUtil.getURL(request) %>'+strImg,'IMG','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=510,height=510');	
		}
	}
	return;
}
</script>

<body onload="kep_onload_view()">
<form name="catlgForm" id="catlgForm" method=post  onsubmit="return false;">
	<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	<input type="hidden" name="catlg_target_rate" id="catlg_target_rate" value="0">
	<input type="hidden" name="catlg_row_no" id="catlg_row_no" value="">
    <input type="hidden" name="catlg_desc_flag" id="catlg_desc_flag" value="false">
    <input type="hidden" name="catlg_spec_flag" id="catlg_spec_flag" value="false">
    <input type="hidden" name="catlg_maker_flag" id="catlg_maker_flag" value="false">
    <input type="hidden" name="catlg_model_flag" id="catlg_model_flag" value="false">
    <input type="hidden" name="popup_type" id="popup_type" value="stdCatlgRcmd">
    <input type="hidden" name="opner_row_no" id="opener_row_no" value="">
    
    <input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">
    <input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>">
    <input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>">
    <input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>">
    
    <input type="hidden" name="st_cms_catalgid" id="st_cms_catalgid" value="">
    <input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir" value="">
    <input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="">
    <input type="hidden" name="CATALOG_CHOICE_TYPE" id="CATALOG_CHOICE_TYPE" value="DQCAT02">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:704px;">
    	<div id="popHeader">
        	<h1 class="title">KeP표준 카탈로그 추천 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	 <div class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('manual');">직접선택</a></span>
        	 </div>
             <div class="fr">
             	☜ <font color="FF0000">직접선택</font> 버튼 클릭 시 표준카탈로그 조회 팝업으로 이동
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>KeP표준 카탈로그 선택 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
                            <col width="10%" />
                            <col width="40%" />
						</colgroup>
						<tbody>
						<tr>
							<td>품목명</td>
							<td> 
								<input type=text name="catlg_desc" id="catlg_desc" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
                            </td>
						    <td>규격</td>						 
							<td> 
								<input type=text name="catlg_spec" id="catlg_spec" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
						</tr>
						<tr>
							<td>제조사</td>						 
							<td> 
								<input type=text name="catlg_maker" id="catlg_maker" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
							<td>모델명</td>
							<td>
								<input type=text name="catlg_model" id="catlg_model" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();">
							</td>
						</tr>
						<tr>
							<td colspan="2">
							<input type="checkbox" class="Noborder" id="chk_desc_flag" name="chk_desc_flag" checked="checked"/>&nbsp;&nbsp;품목명
							<input type="checkbox" class="Noborder" id="chk_spec_flag" name="chk_spec_flag" checked="checked"/>&nbsp;&nbsp;규격
							<input type="checkbox" class="Noborder" id="chk_maker_flag" name="chk_maker_flag" checked="checked"/>&nbsp;&nbsp;제조사
							<input type="checkbox" class="Noborder" id="chk_model_flag" name="chk_model_flag" checked="checked"/>&nbsp;&nbsp;모델명
							</span>
							</td>
							<td>
							<label>조회건수</label>
							</td>
							<td>
							<select name = "catlg_target_count" id="catlg_target_count" style="width:50px; height:20px">
						      		<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5" selected="selected">5</option>
							</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>       
                 
           	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "354px");
				</script>
			</div>
			<div id="pageindex"></div>
			
			<!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fl text11">
					※ 선택할 <font color="FF0000">표준카탈로그코드</font>를 클릭하시기 바랍니다.
				</span>
	        </div>
    </div>        
</div>
</form>
</body>
</html>
