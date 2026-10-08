<%--
**********************************************
* 메뉴 : 
* 화면 : 표준계약서 작성 
* 기능 : 계약서 작성위한 표준계약서 양식 조회
* 프로그램 ID : PG_02_M_001_02
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-08-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<link rel="stylesheet" href="/resources/daumEditor/css/editor.css" type="text/css" />
<!-- 2011.01.12 benkey
계약관련 태크 입력 관계로 추가 	 //-->
<link rel="stylesheet" href="/resources/daumEditor/css/contract.css" type="text/css" />
<script src="/resources/daumEditor/js/editor.js" type="text/javascript" ></script>
<script src="/resources/daumEditor/js/editor_sample.js" type="text/javascript" ></script>
<!-- 2011.01.12 benkey
계약관련 태크 입력 관계로 추가
//-->
<script src="/resources/daumEditor/js/contract.js" type="text/javascript"></script>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _rowData = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 

String st_form_no = CommonUtil.nvl((String) request.getParameter("st_form_no"),"");  //  (조회조건)
String st_form_name = "";
String st_biz_type = "";
String st_company_type = "";
String st_form_type = "";
String st_description = "";
String st_form_content = "";
String st_use_yn = "";

if (_rowData != null) {
	st_form_name = CommonUtil.nvl(_rowData.get("FORM_NAME"));
	st_biz_type = CommonUtil.nvl(_rowData.get("BIZ_TYPE"));
	st_company_type = CommonUtil.nvl(_rowData.get("COMPANY_TYPE"));
	st_form_type = CommonUtil.nvl(_rowData.get("FORM_TYPE"));
	st_use_yn = CommonUtil.nvl(_rowData.get("FORM_TYPE"));
	st_description = CommonUtil.nvl(_rowData.get("DESCRIPTION"));
	st_form_content = CommonUtil.nvl(_rowData.get("FORM_CONTENT"));
}

%>
<script type="text/javascript">

function kep_onload_view() {
	/*-------- 에디터 로드 시작 ----------*/
	new Editor({
		txHost: '',														/* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
		txPath: '',														/* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
		txVersion: '5.4.0',												/* 수정필요없음. */
		txService: 'sample',											/* 수정필요없음. */
		txProject: 'sample',											/* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
		initializedId: "",												/* 대부분의 경우에 빈문자열 */
		wrapper: "tx_trex_container"+"",							/* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
		form: 'contentCondition'+"",									/* 등록하기 위한 Form 이름 */
		txIconPath: "/resources/daumEditor/images/icon/",		/*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
		txDecoPath: "/resources/daumEditor/images/deco/",	/*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
		canvas: {
			styles: {
				color: "#000000",										/* 기본 글자색 */
				fontFamily: "굴림",									/* 기본 글자체 */
				fontSize: "10pt",										/* 기본 글자크기 */
				backgroundColor: "#fff",							/*기본 배경색 */
				lineHeight: "1.5",										/*기본 줄간격 */
				padding: "8px"										/* 위지윅 영역의 여백 */
			}
		},
		sidebar: {
			attacher: {
				image: {
				},
				file: {
				}
			}
		},
		size: {
			contentWidth: 720										/* 지정된 본문영역의 넓이가 있을 경우에 설정 */
		}
	}).focusOnForm("tx_canvas_source");
	
	loadContent();
}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtStndrdContractPop.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			break;
		case "save": // 취소
			if (saveContent()) {
				kepAjaxFormCall("/mdct/saveMasterMdCtStndrdContractWritePop.do","contentCondition", str);
			}
			break;
	}
}

function kepSearch() {  
	$('#contentCondition').attr("action", "/mdct/getMasterMdCtStndrdContractWritePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("표준계약서가 정상적으로 저장되었습니다..");
			setReturn("OK");
		} else if (msg == "ERR") {
			alert("표준계약서 저장에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else {
			alert(msg);
			return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

function loadContent() {
	/* 저장된 컨텐츠를 불러오기 위한 함수 호출 */
	Editor.modify({
		"content": $tx("tx_load_content") /* 내용 문자열, 주어진 필드(textarea) 엘리먼트 */ 
	});
}

function saveContent() {

	if (kepTrimStr($("#st_form_name").val()) == "") {
		alert("서식이름을 입력해주세요.");
		$("#st_form_name").focus();
		return false;
	}
	
	if (kepTrimStr($("#st_description").val()) == "") {
		alert("설명을 입력해주세요.");
		$("#st_description").focus();
		return false;
	}
	
	return validForm(Editor);
	//Editor.save();				// 이 함수를 호출하여 글을 등록하면 된다.
}

/**
* Editor.save()를 호출한 경우 데이터가 유효한지 검사하기 위해 부르는 콜백함수로 
* 상황에 맞게 수정하여 사용한다.
* 모든 데이터가 유효할 경우에 true를 리턴한다. 
* @function
* @param {Object} editor - 에디터에서 넘겨주는 editor 객체
* @returns {Boolean} 모든 데이터가 유효할 경우에 true
*/
function validForm(editor) { 

	/* 본문 내용이 입력되었는지 검사하는 부분 */
	var _validator = new Trex.Validator();
	var _content = editor.getContent();
	if(!_validator.exists(_content)) {
		alert('내용을 입력하세요');
		return false;
	}
	
	$("#st_form_content").val(_content);
	return true;
}

/**
* Editor.save()를 호출한 경우 데이터가 유효하면
* Form Summit을 위해 필드를 생성, 변경하기 위해 부르는 콜백함수로 
* 상황에 맞게 수정하여 사용한다.
* 정상적인 경우에 true를 리턴한다. 
* @function
* @param {Object} editor - 에디터에서 넘겨주는 editor 객체
* @returns {Boolean} 정상적인 경우에 true
*/
function setForm(editor) {
	var _formGen = editor.getForm();
	var _content = editor.getContent();
	_formGen.createField(
		tx.textarea({ 
			/* 본문 내용을 필드를 생성하여 값을 할당하는 부분 */
			'name': "tx_content", 
			'style': { 'display': "none" } 
		}, 
		_content)
	);

	return true;
}

</script>
</head> 
<body onload="kep_onload_view();">

<form  id="contentCondition" name="contentCondition" method=post>
<input type="hidden" id="st_form_no" name="st_form_no" value="<%=st_form_no%>" />
<input type="hidden" id="st_form_content" name="st_form_content" value="" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
		<div id="popHeader">
			<h1 class="title">표준계약서 작성 </h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<!--grid-->
			<div class="contArea" style="height:624px">
				<table  class="cont_t_list06" style="width:100%;">
					<caption>표준계약서 작성</caption>
					<colgroup>
						<col width="12%" />
						<col width="14%" />
						<col width="12%" />
						<col width="14%" />
						<col width="12%" />
						<col width="14%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">서식이름</th>
							<td colspan="7">
								<input type="text" class="input_type_text" name="st_form_name" id="st_form_name" style="width:90%" value="<%=st_form_name %>"  />
							</td>
						</tr>
						<tr>
							<th scope="row">사업구분</th>
							<td>
								<select id="st_biz_type" name="st_biz_type" style="width:90%">
									<option value="C001" <%=st_biz_type.equals("C001") ? "selected" : "" %>>구매대행</option>
									<option value="C002" <%=st_biz_type.equals("C002") ? "selected" : "" %>>유통</option>						
								</select>
							</td>
							<th scope="row">회원사유형</th>
							<td>
								<select id="st_company_type" name="st_company_type" style="width:90%">
									<option value="C002" <%=st_company_type.equals("C002") ? "selected" : "" %>>협력사</option>
									<option value="C001" <%=st_company_type.equals("C001") ? "selected" : "" %>>고객사</option>
								</select>
							</td>
							<th scope="row">서식분류</th>
							<td>
								<select id="st_form_type" name="st_form_type" style="width:90%">
									<option value="C" <%=st_form_type.equals("C") ? "selected" : "" %>>거래약정</option>
									<option value="E" <%=st_form_type.equals("E") ? "selected" : "" %>>기타</option>
									<option value="P" <%=st_form_type.equals("P") ? "selected" : "" %>>프로모션</option>
									<option value="S" <%=st_form_type.equals("S") ? "selected" : "" %>>시즌</option>
								</select>
							</td>
							<th scope="row">사용여부</th>
							<td>
								<select id="st_use_yn" name="st_use_yn" style="width:90%">
									<option value="Y" <%=st_use_yn.equals("Y") ? "selected" : "" %>>사용</option>
									<option value="N" <%=st_use_yn.equals("N") ? "selected" : "" %>>미사용</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">설명</th>
							<td colspan="7">
								<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:90%" value="<%=st_description%>"  />
							</td>
						</tr>
					</tbody>
				</table>
				
				<!-- 에디터 컨테이너 시작 -->
				<div id="tx_trex_container" class="tx-editor-container">
					<!-- 사이드바 -->
					<div id="tx_sidebar" class="tx-sidebar">
						<div class="tx-sidebar-boundary">
							<!-- 사이드바 / 첨부 -->
							<!-- 이미지 첨부 버튼 시작 -->
							<!--
							@decsription 
							<li></li> 단위로 위치를 이동할 수 있다. 
							-->
							<!--
							<ul class="tx-bar tx-bar-left tx-nav-attach">
								<li class="tx-list">
									<div unselectable="on" id="tx_image" class="tx-image tx-btn-trans">
										<a href="javascript:;" title="사진" class="tx-text">사진</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" id="tx_file" class="tx-file tx-btn-trans">
										<a href="javascript:;" title="파일" class="tx-text">파일</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" id="tx_media" class="tx-media tx-btn-trans">
										<a href="javascript:;" title="외부컨텐츠" class="tx-text">매핑정보</a>
									</div>
								</li>
								<li class="tx-list tx-list-extra">
									<div unselectable="on" class="tx-btn-nlrbg tx-extra">
										<a href="javascript:;" class="tx-icon" title="버튼 더보기">버튼 더보기</a>
									</div>
									<ul class="tx-extra-menu tx-menu" style="left:-48px;" unselectable="on">
									</ul>
								</li>
							</ul>
							-->
							
							<!-- 사이드바 / 우측영역 -->
							<ul class="tx-bar tx-bar-right tx-nav-opt">
								<li class="tx-list">
									<div unselectable="on" class="tx-switchtoggle" id="tx_switchertoggle">
										<a href="javascript:;" title="에디터 타입">에디터</a>
									</div>
								</li>
							</ul>
						</div>
					</div>
		
					<!-- 툴바 - 기본 시작 -->
					<!-- 
					@decsription
					툴바 버튼의 그룹핑의 변경이 필요할 때는 위치(왼쪽, 가운데, 오른쪽) 에 따라 <li> 아래의 <div>의 클래스명을 변경하면 된다.
					tx-btn-lbg: 왼쪽, tx-btn-bg: 가운데, tx-btn-rbg: 오른쪽, tx-btn-lrbg: 독립적인 그룹
		
					드롭다운 버튼의 크기를 변경하고자 할 경우에는 넓이에 따라 <li> 아래의 <div>의 클래스명을 변경하면 된다.
					tx-slt-70bg, tx-slt-59bg, tx-slt-42bg, tx-btn-43lrbg, tx-btn-52lrbg, tx-btn-57lrbg, tx-btn-71lrbg
					tx-btn-48lbg, tx-btn-48rbg, tx-btn-30lrbg, tx-btn-46lrbg, tx-btn-67lrbg, tx-btn-49lbg, tx-btn-58bg, tx-btn-46bg, tx-btn-49rbg
					-->  
					<div id="tx_toolbar_basic" class="tx-toolbar tx-toolbar-basic">
						<div class="tx-toolbar-boundary">
							<!-- 2011.01.12 benkey
							계약관련 태크 입력 관계로 추가
							//-->
							<!-- start -->
							<ul class="tx-bar tx-bar-left">
								<li class="tx-list">
									<div id="tx_contract" unselectable="on" class="tx-slt-70bg tx-contract">
										<a href="javascript:;" title="매핑정보">매핑정보</a>
									</div>
									<div id="tx_contract_menu" class="tx-contract-menu tx-menu" unselectable="on"></div>
								</li>
							</ul>
							<!-- end -->
		
							<ul class="tx-bar tx-bar-left">
								<li class="tx-list">
									<div id="tx_fontfamily" unselectable="on" class="tx-slt-70bg tx-fontfamily">
										<a href="javascript:;" title="글꼴">굴림</a>
									</div>
									<div id="tx_fontfamily_menu" class="tx-fontfamily-menu tx-menu" unselectable="on"></div>
								</li>
							</ul>
		
							<ul class="tx-bar tx-bar-left">
								<li class="tx-list">
									<div unselectable="on" class="tx-slt-42bg tx-fontsize" id="tx_fontsize">
										<a href="javascript:;" title="글자크기">9pt</a>
									</div>
									<div id="tx_fontsize_menu" class="tx-fontsize-menu tx-menu" unselectable="on"></div>
								</li>
							</ul>
							
							<ul class="tx-bar tx-bar-left tx-group-font"> 
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-bold" id="tx_bold">
										<a href="javascript:;" class="tx-icon" title="굵게 (Ctrl+B)">굵게</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-underline" id="tx_underline">
										<a href="javascript:;" class="tx-icon" title="밑줄 (Ctrl+U)">밑줄</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-italic" id="tx_italic">
										<a href="javascript:;" class="tx-icon" title="기울임 (Ctrl+I)">기울임</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-strike" id="tx_strike">
										<a href="javascript:;" class="tx-icon" title="취소선 (Ctrl+D)">취소선</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-slt-tbg 	tx-forecolor" style="background-color:#5c7fb0;" id="tx_forecolor">
										<a href="javascript:;" class="tx-icon" title="글자색">글자색</a>
										<a href="javascript:;" class="tx-arrow" title="글자색 선택">글자색 선택</a>
									</div>
									<div id="tx_forecolor_menu" class="tx-menu tx-forecolor-menu tx-colorpallete" unselectable="on"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-slt-brbg 	tx-backcolor" style="background-color:#5c7fb0;" id="tx_backcolor">
										<a href="javascript:;" class="tx-icon" title="글자 배경색">글자 배경색</a>
										<a href="javascript:;" class="tx-arrow" title="글자 배경색 선택">글자 배경색 선택</a>
									</div>
									<div id="tx_backcolor_menu" class="tx-menu tx-backcolor-menu tx-colorpallete" unselectable="on"></div>
								</li>
							</ul>
		
							<ul class="tx-bar tx-bar-left tx-group-align"> 
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-alignleft" id="tx_alignleft">
										<a href="javascript:;" class="tx-icon" title="왼쪽정렬 (Ctrl+,)">왼쪽정렬</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-aligncenter" id="tx_aligncenter">
										<a href="javascript:;" class="tx-icon" title="가운데정렬 (Ctrl+.)">가운데정렬</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-alignright" id="tx_alignright">
										<a href="javascript:;" class="tx-icon" title="오른쪽정렬 (Ctrl+/)">오른쪽정렬</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-rbg 	tx-alignfull" id="tx_alignfull">
										<a href="javascript:;" class="tx-icon" title="양쪽정렬">양쪽정렬</a>
									</div>
								</li>
							</ul>
		
							<ul class="tx-bar tx-bar-left tx-group-tab"> 
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-indent" id="tx_indent">
										<a href="javascript:;" title="들여쓰기 (Tab)" class="tx-icon">들여쓰기</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-rbg 	tx-outdent" id="tx_outdent">
										<a href="javascript:;" title="내어쓰기 (Shift+Tab)" class="tx-icon">내어쓰기</a>
									</div>
								</li>
							</ul>
		
							<ul class="tx-bar tx-bar-left tx-group-list">
								<li class="tx-list">
									<div unselectable="on" class="tx-slt-31lbg tx-lineheight" id="tx_lineheight">
										<a href="javascript:;" class="tx-icon" title="줄간격">줄간격</a>
										<a href="javascript:;" class="tx-arrow" title="줄간격">줄간격 선택</a>
									</div>
									<div id="tx_lineheight_menu" class="tx-lineheight-menu tx-menu" unselectable="on"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="tx-slt-31rbg tx-styledlist" id="tx_styledlist">
										<a href="javascript:;" class="tx-icon" title="리스트">리스트</a>
										<a href="javascript:;" class="tx-arrow" title="리스트">리스트 선택</a>
									</div>
									<div id="tx_styledlist_menu" class="tx-styledlist-menu tx-menu" unselectable="on"></div>
								</li>
							</ul>
							
							<ul class="tx-bar tx-bar-left tx-group-etc">
								<!--
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-emoticon" id="tx_emoticon">
										<a href="javascript:;" class="tx-icon" title="이모티콘">이모티콘</a>
									</div>
									<div id="tx_emoticon_menu" class="tx-emoticon-menu tx-menu" unselectable="on"></div>
								</li>
								//-->
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-link" id="tx_link">
										<a href="javascript:;" class="tx-icon" title="링크 (Ctrl+K)">링크</a>
									</div>
									<div id="tx_link_menu" class="tx-link-menu tx-menu"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-specialchar" id="tx_specialchar">
										<a href="javascript:;" class="tx-icon" title="특수문자">특수문자</a>
									</div>
									<div id="tx_specialchar_menu" class="tx-specialchar-menu tx-menu"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-table" id="tx_table">
										<a href="javascript:;" class="tx-icon" title="표만들기">표만들기</a>
									</div>
									<div id="tx_table_menu" class="tx-table-menu tx-menu" unselectable="on">
										<div class="tx-menu-inner">
											<div class="tx-menu-preview"></div>
											<div class="tx-menu-rowcol"></div>
											<div class="tx-menu-deco"></div>
											<div class="tx-menu-enter"></div>
										</div>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-rbg 	tx-horizontalrule" id="tx_horizontalrule">
										<a href="javascript:;" class="tx-icon" title="구분선">구분선</a>
									</div>
									<div id="tx_horizontalrule_menu" class="tx-horizontalrule-menu tx-menu" unselectable="on"></div>
								</li>
							</ul>
		
							<ul class="tx-bar tx-bar-left"> 
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-textbox" id="tx_textbox">
										<a href="javascript:;" class="tx-icon" title="글상자">글상자</a>
									</div>		
									<div id="tx_textbox_menu" class="tx-textbox-menu tx-menu"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-quote" id="tx_quote">
										<a href="javascript:;" class="tx-icon" title="인용구 (Ctrl+Q)">인용구</a>
									</div>
									<div id="tx_quote_menu" class="tx-quote-menu tx-menu" unselectable="on"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-bg 	tx-background" id="tx_background">
										<a href="javascript:;" class="tx-icon" title="배경색">배경색</a>
									</div>
									<div id="tx_background_menu" class="tx-menu tx-background-menu tx-colorpallete" unselectable="on"></div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-rbg 	tx-dictionary" id="tx_dictionary">
										<a href="javascript:;" class="tx-icon" title="사전">사전</a>
									</div>
								</li>
							</ul> 
		
							<ul class="tx-bar tx-bar-left tx-group-undo"> 
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-lbg 	tx-undo" id="tx_undo">
										<a href="javascript:;" class="tx-icon" title="실행취소 (Ctrl+Z)">실행취소</a>
									</div>
								</li>
								<li class="tx-list">
									<div unselectable="on" class="		 tx-btn-rbg 	tx-redo" id="tx_redo">
										<a href="javascript:;" class="tx-icon" title="다시실행 (Ctrl+Y)">다시실행</a>
									</div>
								</li>
							</ul> 
		
							<ul class="tx-bar tx-bar-right">
								<li class="tx-list">
									<div unselectable="on" class="tx-btn-nlrbg tx-advanced" id="tx_advanced">
										<a href="javascript:;" class="tx-icon" title="툴바 더보기">툴바 더보기</a>
									</div>
								</li>
							</ul>
						</div>
					</div>
			
					<!-- 툴바 - 기본 끝 -->
					<!-- 툴바 - 더보기 시작 -->
					<div id="tx_toolbar_advanced" class="tx-toolbar tx-toolbar-advanced">
						<div class="tx-toolbar-boundary">
							<ul class="tx-bar tx-bar-left tx-group-order">
							</ul>
							<ul class="tx-bar tx-bar-right">
								<li class="tx-list">
									<div unselectable="on" class="tx-btn-lrbg tx-fullscreen" id="tx_fullscreen">
										<a href="javascript:;" class="tx-icon" title="넓게쓰기 (Ctrl+M)">넓게쓰기</a>
									</div>
								</li>
							</ul>
						</div>
					</div>
					<!-- 툴바 - 더보기 끝 -->
					<!-- 편집영역 시작 -->
					<!-- 에디터 Start -->
					<div id="tx_canvas" class="tx-canvas">
						<div id="tx_loading" class="tx-loading">
							<div><img src="/resources/daumEditor/images/icon/loading2.png?rv=1.0.1" width="113" height="21" align="absmiddle"/></div>
						</div>
						<div id="tx_canvas_wysiwyg_holder" class="tx-holder" style="display:block;">
							<iframe id="tx_canvas_wysiwyg" name="tx_canvas_wysiwyg" allowtransparency="true" frameborder="0"></iframe>
						</div>
						<div class="tx-source-deco">
							<div id="tx_canvas_source_holder" class="tx-holder">
								<textarea id="tx_canvas_source" rows="70" cols="30"></textarea>
							</div>
						</div>
						<div id="tx_canvas_text_holder" class="tx-holder">
							<textarea id="tx_canvas_text" rows="70" cols="30"></textarea>
						</div>
					</div>
					
					<!-- 높이조절 Start -->
					<div class="tx-resize-bar">
						<div class="tx-resize-bar-bg"></div>
						<img src="/resources/daumEditor/images/icon/btn_drag01.gif" width="58" height="12" unselectable="on" alt="" />
					</div>
					<!--
					<div class="tx-side-bi" id="tx_side_bi">
						<div style="text-align: right;">
							<img hspace="4" height="14" width="78" align="absmiddle" src="/resources/daumEditor/images/icon/editor_bi.png?rv=1.0.1" />
						</div>
					</div>
					-->
					<!-- 편집영역 끝 -->
					<!-- 첨부박스 시작 -->
					<!-- 파일첨부박스 Start -->
					<div id="tx_attach_div" class="tx-attach-div">
						<div id="tx_attach_txt" class="tx-attach-txt">파일 첨부</div>
						<div id="tx_attach_box" class="tx-attach-box">
							<div class="tx-attach-box-inner">
								<div id="tx_attach_preview" class="tx-attach-preview"><p></p><img src="/resources/daumEditor/images/icon/pn_preview.gif" width="147" height="108" unselectable="on"/></div>
								<div class="tx-attach-main">
									<div id="tx_upload_progress" class="tx-upload-progress">
										<div>0%</div><p>파일을 업로드하는 중입니다.</p>
									</div>
									<ul class="tx-attach-top">
										<li id="tx_attach_delete" class="tx-attach-delete"><a>전체삭제</a></li>
										<li id="tx_attach_size" class="tx-attach-size">
											파일: <span id="tx_attach_up_size" class="tx-attach-size-up"></span>/<span id="tx_attach_max_size"></span>
										</li>
										<li id="tx_attach_tools" class="tx-attach-tools">
										</li>
									</ul>
									<ul id="tx_attach_list" class="tx-attach-list"></ul>
								</div>
							</div>
						</div>
					</div>
					<!-- 첨부박스 끝 -->
				</div>
				<!-- 에디터 컨테이너 끝 -->
				
				<!--버튼영역-->
				<div class="btnArea mt10 mb05">
					<span class="fl">
						<span class="btn_06 mr04"><a href="javascript:doAction('save'); ">표준계약서저장</a></span>
					</span>
				</div>
			</div>
		</div>        
	</div>
</form>
<textarea id="tx_load_content" name="tx_load_content" cols="0" rows="0" style="display:none;"><%=st_form_content %></textarea> 
</body>
</html>
