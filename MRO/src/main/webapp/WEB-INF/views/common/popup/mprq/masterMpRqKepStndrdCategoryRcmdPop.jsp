<%--
**********************************************
* 메뉴 : 
* 화면 : KeP 표준카테고리 추천팝업 
* 기능 : 표준카테고리를 DQCAT을 이용, 선택한다
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2016-05-25
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
String st_desc = CommonUtil.nvl((String) request.getParameter("categ_desc_flow"),"");
String st_spec = CommonUtil.nvl((String) request.getParameter("categ_spec_flow"),"");
String st_maker = CommonUtil.nvl((String) request.getParameter("categ_maker_flow"),""); 
String st_model = CommonUtil.nvl((String) request.getParameter("categ_model_flow"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
	
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [  
		    			{Align : "Center",	SaveName : "NO",								Header : "순위",				Type : "Text",	Width : 50,		EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Left",		SaveName : "CATEG_PATH",					Header : "추천카테고리",	Type : "Text",	Width : 540,	EditLen : 110,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "ACCU_RATE",					Header : "정확도(%)",		Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	Hidden : false},
		    			{Align : "Center",	SaveName : "CMS_CATEG_ID",				Header : "카테고리ID",		Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "CATEG_NAME",					Header : "카테고리명",		Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "SG_ID",							Header : "SG_ID",				Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "SG_NAME",						Header : "SG_NAME",		Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		    			{Align : "Left",		SaveName : "CATEGORY_CHOICE_TYPE",	Header : "CHOICE_TYPE",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
		];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CATEG_PATH");
	
	var description = "<%=st_desc%>";
	var specification = "<%=st_spec%>";
	var maker = "<%=st_maker%>";
	var model = "<%=st_model%>";
	
	$('#categ_desc').val(unescape(description));
	$('#categ_spec').val(unescape(specification));
	$('#categ_maker').val(unescape(maker));
	$('#categ_model').val(unescape(model));
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회

			mySheet.RemoveAll();
		
			if(document.getElementById("chk_desc_flag").checked == true){
				$('#categ_desc_flag').val('true');
			}else{
				$('#categ_desc_flag').val('false');
			}
			
			if(document.getElementById("chk_spec_flag").checked == true){
				$('#categ_spec_flag').val('true');
			}else{
				$('#categ_spec_flag').val('false');
			}
			
			if(document.getElementById("chk_maker_flag").checked == true){
				$('#categ_maker_flag').val('true');
			}else{
				$('#categ_maker_flag').val('false');
			}
			
			kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			break;
			
		case "manual":
			window.open('','categ','scrollbars=no,width=721,height=670,resizable=no');
		    document.categForm.action = "/mprq/showMasterMpRqKepStndrdCategorySelPop.do";
		    document.categForm.target = "categ";
		    document.categForm.method = "post";
		    
		    document.categForm.submit();
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "DQCAT"){
		var totRow = $('#categ_target_count').val();
		
		// 순위별 값 세팅(ex response.categPath1 = 1순위, response.categPath5 = 5순위)
		for(var i=1; i<=totRow;i++){
			var categPath = "response.categPath"+i;
			var pr = "response.pr"+i;
			var cmsCategId = "response.cmsCategId"+i;
			var categName = "response.categName"+i;
			var sgId = "response.sgId"+i;
			var sgName = "response.sgName"+i;
			
			var text_categPath = eval(categPath);
			var text_pr = eval(pr);
			var text_cmsCategId = eval(cmsCategId);
			var text_categName = eval(categName);
			var text_sgId = eval(sgId);
			var text_sgName = eval(sgName);
			
			if(eval(categPath) != null){
				var rows = mySheet.DataInsert(-1);
			
				mySheet.SetCellValue(rows, "NO", i);
				mySheet.SetCellValue(rows, "CATEG_PATH", text_categPath);
				mySheet.SetCellValue(rows, "ACCU_RATE", text_pr);
				mySheet.SetCellValue(rows, "CMS_CATEG_ID", text_cmsCategId);
				mySheet.SetCellValue(rows, "CATEG_NAME", text_categName);
				mySheet.SetCellValue(rows, "SG_ID", text_sgId);
				mySheet.SetCellValue(rows, "SG_NAME", text_sgName);
				mySheet.SetCellValue(rows, "CATEGORY_CHOICE_TYPE", "DQCAT02");
			}else{
				alert("조회된 데이터가 없습니다.");
				return;
			}
		}
    }
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if(column == "CATEG_PATH" ){
		var rtn_sg_Id = mySheet.GetCellValue(Row,"SG_ID");
		var rtn_sg_name = mySheet.GetCellValue(Row,"SG_NAME");
		var rtn_categ_id = mySheet.GetCellValue(Row,"CMS_CATEG_ID");
		var rtn_categ_path = mySheet.GetCellValue(Row,"CATEG_PATH");
		var rtn_categ_name = mySheet.GetCellValue(Row,"CATEG_NAME");
		var rtn_choice_type = mySheet.GetCellValue(Row,"CATEGORY_CHOICE_TYPE");
		
		opener.setPopupReturn(
				rtn_sg_Id,
				rtn_sg_name,
				rtn_categ_id,
				rtn_categ_path,
				rtn_categ_name,
				rtn_choice_type
		);
		
		this.close();
	}
	return;
}
</script>

<body onload="kep_onload_view()">
<form name="categForm" id="categForm" method=post  onsubmit="return false;">
	<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="0">
	<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
    <input type="hidden" name="categ_model" id="categ_model" value="">
    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="false">
    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="false">
    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="false">
    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
    <input type="hidden" name="popup_type" id="popup_type" value="stdCategRcmd">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:704px;">
    	<div id="popHeader">
        	<h1 class="title">KeP표준 카테고리 추천 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	 <div class="fl">
				<span class="btn_04 mr04"><a href="javascript:doAction('manual');">직접선택</a></span>
        	 </div>
             <div class="fr">
             	☜ <font color="FF0000">직접선택</font> 버튼 클릭 시 카테고리 선택 팝업으로 이동
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>KeP표준 카테고리 선택 리스트</caption>
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
								<input type=text name="categ_desc" id="categ_desc" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
                            </td>
						    <td>규격</td>						 
							<td> 
								<input type=text name="categ_spec" id="categ_spec" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
						</tr>
						<tr>
							<td>제조사</td>						 
							<td> 
								<input type=text name="categ_maker" id="categ_maker" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="2">
							<input type="checkbox" class="Noborder" id="chk_desc_flag" name="chk_desc_flag" checked="checked"/>&nbsp;&nbsp;품목명
							<input type="checkbox" class="Noborder" id="chk_spec_flag" name="chk_spec_flag" checked="checked"/>&nbsp;&nbsp;규격
							<input type="checkbox" class="Noborder" id="chk_maker_flag" name="chk_maker_flag" checked="checked"/>&nbsp;&nbsp;제조사
							</span>
							</td>
							<td>
							<label>조회건수</label>
							</td>
							<td>
							<select name = "categ_target_count" id="categ_target_count" style="width:50px; height:20px">
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
					createIBSheet("mySheet", "", "133px");
				</script>
			</div>
			<div id="pageindex"></div>
			
			<!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fl text11">
					※ 선택할 <font color="FF0000">추천카테고리</font>를 클릭하시기 바랍니다.
				</span>
	        </div>
    </div>        
</div>
</form>
</body>
</html>
