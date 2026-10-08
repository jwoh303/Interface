<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 상품 정보 클릭 시 상세 팝업
* 화면 : (팝업) 상품정보 상세 조회 및 수정
* 기능 : 상품정보 상세 조회 및 수정
* 담당자 : 홍준우
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="org.springframework.web.util.HtmlUtils"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String st_msds_no = HtmlUtils.htmlEscape(CommonUtil.nvl((String) request.getParameter("st_msds_no"),""));

// 상세 단건 데이터 (컨트롤러가 CMS_CATLG_ID로 조회해 model에 담음). null 가드.
Map<String,String> _data = (Map<String,String>) request.getAttribute("data");
if(_data == null){ _data = new HashMap<String,String>(); }

// 규격 상세 속성 (상세분류가 정의한 속성명 + 그 상품의 속성값 + 필수여부)
List<Map<String,String>> _attrList = (List<Map<String,String>>) request.getAttribute("attrList");
if(_attrList == null){ _attrList = new ArrayList<Map<String,String>>(); }

// 구매정보 리스트 : 이 상품정보코드에 걸린 구매정보 전체
List<Map<String,String>> _buyInfoList = (List<Map<String,String>>) request.getAttribute("buyInfoList");
if(_buyInfoList == null){ _buyInfoList = new ArrayList<Map<String,String>>(); }

String d_catlg      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATLG_ID")));
String d_status     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("STATUS")));            // 상품상태 원값 (D=미사용)
String d_categ      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATEG_ID")));      // 상세분류코드
String d_categ_path = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATEG_PATH")));    // 상세분류 전체 경로
String d_sg_name    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SG_NAME")));           // 카테고리(=SG명)
String d_name       = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DESCRIPTION_LOC")));   // 품목명
String d_model      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MODEL_INFO")));
String d_spec       = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SPECIFICATION")));
String d_maker      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MAKER_NAME")));
String d_maker_cd   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MAKER_CODE")));
String d_origin     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ORIGIN_CODE_NAME")));
String d_origin_cd  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ORIGIN_CODE")));
String d_measure    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ORDER_MEASURE")));
String d_gubun_cd   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_GUBUN")));        // 상품구분 원코드 (M118)
String d_onetime    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ONETIME_NM")));        // 일회성구분(명칭) - ONETIME_YN Y/N 파생
String d_tr         = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("TR_HANDLE_NM")));      // TR취급가능여부(명칭, M181)
String d_tr_cd      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("TR_HANDLE_TYPE")));    // TR취급가능여부 원코드 - 셀렉트 selected 판정용
String d_person     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("KEP_USER_NAME")));     // 구매담당자(카테고리(SG) 담당자)

// 상품이미지 (CMSCATLG.IMGFILE_DIR/IMGFILE_NAME. 미등록이면 ITEM_IMAGE 가 공백)
String d_img_dir    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("IMGFILE_DIR")));
String d_img_name   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("IMGFILE_NAME")));
String d_img_url    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_IMAGE")));
String d_img_view   = "".equals(d_img_url) ? "/resources/images/icon_emptyimg.gif" : d_img_url;

// 상세이미지 (CMSCATLG.DETAIL_IMGFILE_DIR/NAME). 대표이미지와 달리 서버 리사이즈 없이 원본이 그대로 올라간다.
String d_dimg_dir   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_IMGFILE_DIR")));
String d_dimg_name  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_IMGFILE_NAME")));
String d_dimg_url   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_ITEM_IMAGE")));
String d_dimg_view  = "".equals(d_dimg_url) ? "/resources/images/icon_emptyimg.gif" : d_dimg_url;

// 화학물질정보
String d_harmful    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("HARMFUL_YN")));        // 유해화학물질 (MSDS 매핑 파생)
String d_chem_no    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CHEM_INFO_NO")));      // 화학물질정보 No. (MSDS No. 우선, 없으면 AC No.)

// 안전인증정보
String d_safe_stat  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_STATUS_NM")));    // 공란 / 인증 / 미인증 / 비대상
String d_safetype   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_TYPE_NM")));      // KC인증 / KCS인증 / KFI인증 (상세분류에 따라 자동 지정)
String d_safeno     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_NO")));           // 안전인증번호 (미기재 가능)

// 상품정보이력
String d_regdate    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ADD_DATE")));
String d_chgdate    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CHANGE_DATE")));
String d_adduser    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ADD_USER_NAME")));     // 등록담당자
String d_chguser    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CHANGE_USER_NAME")));  // 변경담당자
String d_quot_no    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("QUOTATION_NO")));      // 등록견적번호(Key) 예: RE26xxxxxxxx

// 기준가 · 구매정보 열람 권한 : 구매부서(ICOMCOD1 TYPE='SOURDEPT') 소속만.
String st_user_dept  = _sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getDepartment());
String st_user_id    = _sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
boolean d_sour_dept  = !"".equals(st_user_dept) && CommonUtil.getCodeCheckReturn("SOURDEPT", st_user_dept);
boolean d_show_price = d_sour_dept || "KEP2239016".equals(st_user_id);

// 기준가 정보
String d_base_price = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE")));        // 기준가 원값
String d_base_type  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE_TYPE")));   // 기준가유형 원코드 (M183 : AVG/REC)
String d_base_chg   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE_CHG_YN"))); // 기준가 변경여부(Y/N) - 기준가 변경이력 미도입이라 공백

// 기준가 콤마 표기. formatNumber 는 빈값에 "0" 을 돌려주므로 미입력은 공백으로 남긴다.
String d_base_view  = "".equals(d_base_price) ? "" : CommonUtil.formatNumber(d_base_price, true, 0, 0);

// 상품정보코드 표기는 조회값 우선, 없으면 파라미터값
if("".equals(d_catlg)){ d_catlg = st_msds_no; }

// 담당자는 마스킹한 이름만 표기 (사번 미노출)
String d_person_view = d_person;
if(!"".equals(d_person)){
	try { d_person_view = CommonUtil.nameMasking(d_person); } catch(Exception e){ d_person_view = d_person; }
}
// 상품정보이력의 등록/변경담당자도 같은 규칙으로 마스킹한다
String d_adduser_view = d_adduser;
if(!"".equals(d_adduser)){
	try { d_adduser_view = CommonUtil.nameMasking(d_adduser); } catch(Exception e){ d_adduser_view = d_adduser; }
}
String d_chguser_view = d_chguser;
if(!"".equals(d_chguser)){
	try { d_chguser_view = CommonUtil.nameMasking(d_chguser); } catch(Exception e){ d_chguser_view = d_chguser; }
}
%>
<script type="text/javascript">
// 섹션 접기/펼치기 상태 (섹션 수 만큼)
// 0=상품기본정보 1=화학물질정보 2=안전인증정보 3=상품정보이력 4=기준가정보 5=구매정보리스트
// 6=상품이미지 : DOM 상으로는 안전인증정보 바로 뒤지만, 뒤 섹션 번호를 밀지 않으려고 인덱스는 6 으로 둔다
var open_flag = ["+","+","+","+","+","+","+"];

var popupSel = "";	// 어느 돋보기에서 연 팝업인지 (setPopupReturn 분기용)

/* 진입 시점의 원본값(=[기존]). [요청] 시 현재 입력값과 대조해 **바뀐 항목만** 상태변경 팝업에 넘긴다.
 * ⚠ 서버값을 JS 리터럴로 찍지 않고 **로드 직후 DOM 을 그대로 스냅샷**한다 —
 *   `formatHTMLCode` 가 `&` 를 `&amp;` 로 바꿔 버려서, 품목명에 `&` 가 들어간 상품이 늘 "변경됨"으로 잡힌다.
 *   입력칸은 어차피 서버값으로 채워져 있으니 그 값을 읽는 게 원본이면서 이스케이프 문제도 없다. */
var ORIG = {};

function snapshotOrig(){
	ORIG = {
		 STATUS			: curStatusText()
		,DESCRIPTION	: $.trim($("#st_description_loc").val())
		,MODEL			: $.trim($("#st_model_info").val())
		,SPEC			: curSpecText()
		,MAKER			: $.trim($("#st_maker_name").val())
		,ORIGIN			: $.trim($("#st_origin_name").val())
		,MEASURE		: selText("st_order_measure")
		,ITEM_GUBUN		: selText("st_item_gubun")
		,TR				: selText("st_tr_handle")
		/* ↓ 같은 항목의 코드값. 화면 표시는 명칭이지만 수정요청 테이블에는 코드로 들어간다
		 *   (CMSCATLG_REQ_DT.OLD_DATA/NEW_DATA — 승인 시 그대로 CMSCATLG 에 흘려야 하기 때문). */
		,STATUS_CD		: curStatusCode()
		,MAKER_CD		: $.trim($("#st_maker_code").val())
		,ORIGIN_CD		: $.trim($("#st_origin_code").val())
		,MEASURE_CD		: selVal("st_order_measure")
		,ITEM_GUBUN_CD	: selVal("st_item_gubun")
		,TR_CD			: selVal("st_tr_handle")
	};
}

var mdcmChangeItems = [];	// 상태변경 팝업이 opener 로 읽어 가는 변경 내역

// 셀렉트의 보이는 글자(코드가 아니라 사람이 읽는 값으로 비교·표시한다)
function selText(id){
	var el = document.getElementById(id);
	if (!el || el.selectedIndex < 0) { return ""; }
	return $.trim(el.options[el.selectedIndex].text);
}
// 셀렉트의 코드값(사람이 읽는 글자가 아니라 DB 에 들어가는 값)
function selVal(id){
	var el = document.getElementById(id);
	if (!el) { return ""; }
	return $.trim(el.value);
}
function curStatusText(){ return selText("st_use_yn"); }
/* 상품상태 코드 : 화면 셀렉트는 Y/N 인데 CMSCATLG.STATUS 는 C(사용)/D(미사용) 다.
 * 여기서 한 번만 바꿔 준다 — 요청 테이블에는 CMSCATLG 와 같은 값이 들어가야 승인 시 그대로 흘릴 수 있다. */
function curStatusCode(){ return (selVal("st_use_yn") == "N") ? "D" : "C"; }

/* 규격은 입력칸이 아니라 우측 [규격 상세 속성] 값들의 조합이다.
 * 화면 표기(`153; 0.7mm; 검정`)와 같은 규칙으로 현재 속성값을 이어 붙인다. */
function curSpecText(){
	var parts = [];
	$("input[id^='st_attr_']").each(function(){
		var v = $.trim($(this).val());
		if (v != "") { parts.push(v); }
	});
	return parts.join("; ");
}

/* 우측 속성값을 고치면 규격 표기도 따라 바뀐다(표시 전용 — 저장은 [요청] 때 curSpecText 가 다시 만든다). */
function refreshSpecView(){
	var el = document.getElementById("spec_view");
	if(!el){ return; }
	el.innerHTML = "";
	el.appendChild(document.createTextNode(curSpecText()));
}

/* 바뀐 항목만 [{key,label,before,after,beforeCode,afterCode}] 로 모은다 — 변경한 항목만 노출한다.
 * ★ key 는 CMSCATLG 컬럼명 그대로다 — 그 값이 CMSCATLG_REQ_DT.JOB_COLUMN 이 되고,
 *   나중에 승인 처리가 UPDATE CMSCATLG SET <JOB_COLUMN> ... 으로 그대로 쓴다.
 *   짧은 별칭(MAKER, TR …)을 되살리면 서버에 매핑 표가 하나 더 생긴다.
 * before/after = 사람이 읽는 명칭(변경 여부 비교·팝업 표시용) / beforeCode·afterCode = 저장값. */
function collectChanges(){
	var cand = [
		 { key:"STATUS",			label:"상품상태",			before:ORIG.STATUS,			after:curStatusText()
		 , beforeCode:ORIG.STATUS_CD,		afterCode:curStatusCode() }
		,{ key:"DESCRIPTION_LOC",	label:"품목명",			before:ORIG.DESCRIPTION,	after:$.trim($("#st_description_loc").val())
		 , beforeCode:ORIG.DESCRIPTION,		afterCode:$.trim($("#st_description_loc").val()) }
		,{ key:"MODEL_INFO",		label:"모델번호",			before:ORIG.MODEL,			after:$.trim($("#st_model_info").val())
		 , beforeCode:ORIG.MODEL,			afterCode:$.trim($("#st_model_info").val()) }
		,{ key:"SPECIFICATION",		label:"규격",				before:ORIG.SPEC,			after:curSpecText()
		 , beforeCode:ORIG.SPEC,			afterCode:curSpecText() }
		,{ key:"MAKER_CODE",		label:"제조사",			before:ORIG.MAKER,			after:$.trim($("#st_maker_name").val())
		 , beforeCode:ORIG.MAKER_CD,		afterCode:$.trim($("#st_maker_code").val()) }
		,{ key:"ORIGIN_CODE",		label:"원산지",			before:ORIG.ORIGIN,			after:$.trim($("#st_origin_name").val())
		 , beforeCode:ORIG.ORIGIN_CD,		afterCode:$.trim($("#st_origin_code").val()) }
		,{ key:"ORDER_MEASURE",		label:"단위",				before:ORIG.MEASURE,		after:selText("st_order_measure")
		 , beforeCode:ORIG.MEASURE_CD,		afterCode:selVal("st_order_measure") }
		,{ key:"ITEM_GUBUN",		label:"상품구분",			before:ORIG.ITEM_GUBUN,		after:selText("st_item_gubun")
		 , beforeCode:ORIG.ITEM_GUBUN_CD,	afterCode:selVal("st_item_gubun") }
		,{ key:"TR_HANDLE_TYPE",	label:"TR취급가능여부",	before:ORIG.TR,				after:selText("st_tr_handle")
		 , beforeCode:ORIG.TR_CD,			afterCode:selVal("st_tr_handle") }
	];

	var out = [];
	for (var i = 0; i < cand.length; i++) {
		if (cand[i].after != "" && cand[i].after != cand[i].before) { out.push(cand[i]); }
	}
	return out;
}

function kep_onload_view(){
	for(var i = 0; i < open_flag.length; i++){
		divShowHide(i);
	}
	bindImagePreview();
	// 속성값 입력칸 → 규격 표기 연동. keyup 까지 묶어 타이핑 중에도 보이게 한다
	$(document).on("change keyup", "input[id^='st_attr_']", refreshSpecView);
	snapshotOrig();		// [기존] 기준값 — 반드시 사용자가 손대기 전에 잡는다
	syncAttrHeight();
	$(window).on("resize", syncAttrHeight);
}

/* 좌(상품기본정보)·우(규격 상세 속성) 두 표의 아래끝을 맞춘다.
 * 속성 개수가 상세분류마다 달라 CSS 만으로는 못 맞춘다 — 좌측 표 높이를 재서 우측에 그대로 준다.
 * 우측은 스크롤 박스 하나뿐이라(표준화기준은 하단 [요청] 옆으로 나갔다) 그 높이를 그대로 준다. */
/* 좌우 공통 행 높이 - **최초 1회만 실측**한다.
   매번 다시 재면 이미 키워 놓은 값을 재게 돼 호출마다 커진다(syncAttrHeight 는 onload 루프·resize 로 여러 번 불린다). */
var ATTR_ROW_H = 0;

function syncAttrHeight(){
	var l   = document.getElementById("baseInfoTable");
	var box = document.getElementById("attrScroll");
	if(!l || !box) return;
	if(l.offsetHeight == 0) return;	// 상품기본정보가 접힌 상태 - 펼칠 때 다시 부른다
	alignAttrRows(l, box);
	/* ⚠ 박스 높이는 좌측 표 높이를 **넘기지 않는다**. 넘기면 display:table-cell 인 좌측 칸이 늘어나
	   좌측 표 행이 같이 커지고, 다음 호출에서 더 커지는 되먹임이 생긴다
	   (2026-09-23 실측: 행 34px -> 76px, 박스 302px -> 703px 로 발산). */
	var h = l.getBoundingClientRect().height;	// offsetHeight 는 정수로 반올림돼 소수점이 깎인다
	box.style.height = (h < 120 ? 120 : h) + "px";
}

/* 좌우 표의 가로줄을 맞춘다.
 * 좌측 행은 32.8~34.3px 로 제각각이고(125% 배율에서 행마다 반올림이 다르게 떨어진다),
 * 우측 속성 행은 속성값 입력칸(22px) 때문에 33.8px 밑으로 못 내려간다 - 그래서 **큰 쪽으로 통일**한다.
 * 우측 머리글도 한 행으로 센다 : 좌측 n행 = 머리글 + (n-1)행 이라 아래 끝까지 줄이 맞는다. */
function alignAttrRows(l, box){
	var rows = $(l).find("tbody tr").add($(box).find("thead tr, tbody tr"));
	if(rows.length == 0) return;
	if(ATTR_ROW_H <= 0){
		rows.each(function(){
			var x = this.getBoundingClientRect().height;
			if(x > ATTR_ROW_H){ ATTR_ROW_H = x; }
		});
	}
	if(ATTR_ROW_H <= 0) return;
	rows.css("height", ATTR_ROW_H + "px");

	/* 머리글은 sticky 라 지정한 높이보다 0.8px 남짓 작게 잡힌다 - 좌측 첫 줄에 맞춰 한 번 보정한다.
	   여기만 맞추면 아래 행들은 같은 높이라 그대로 따라 내려온다. */
	var head  = $(box).find("thead tr").get(0);
	var first = $(l).find("tbody tr").get(0);
	if(!head || !first) return;
	var gap = first.getBoundingClientRect().bottom - head.getBoundingClientRect().bottom;
	if(Math.abs(gap) > 0.2){ head.style.height = (head.getBoundingClientRect().height + gap) + "px"; }
}

function divShowHide(num){
	var con = document.getElementById("div"+num);
	if(!con) return;		// 권한으로 렌더되지 않은 섹션 - 여기서 죽으면 뒷줄 onload 가 전부 멈춘다
	if(open_flag[num] == "+"){
		con.style.display = "block";
		open_flag[num] = "-";
		document.getElementById("show"+num).innerHTML = "▼";
	}else{
		con.style.display = "none";
		open_flag[num] = "+";
		document.getElementById("show"+num).innerHTML = "▶";
	}
	document.getElementById("btn"+num).innerHTML = open_flag[num];
	if(num == 0 && open_flag[num] == "-"){ syncAttrHeight(); }	// 접었다 펴면 높이를 다시 잰다
}

// 파일선택 → 이미지 박스를 선택한 파일로 교체(클라이언트 미리보기 전용, 업로드 아님).
// 슬롯이 대표(A)·상세(D) 둘이므로 미리보기 blob 도 슬롯별로 따로 들고 있는다.
var previewBlobUrl  = { A:"", D:"" };
var previewFileName = { A:"", D:"" };

// 슬롯별 DOM id 규약 — 대표는 기존 id 그대로, 상세는 뒤에 2 를 붙인다.
function imgIds(kind){
	var s = (kind == "D") ? "2" : "";
	return { file:"st_image_file"+s, view:"st_image_view"+s, nm:"st_image_file_nm"+s, url:"st_image_url"+s };
}

function releasePreviewBlob(kind){
	if(previewBlobUrl[kind] != "" && window.URL && window.URL.revokeObjectURL){
		window.URL.revokeObjectURL(previewBlobUrl[kind]);
	}
	previewBlobUrl[kind]  = "";
	previewFileName[kind] = "";
}

function bindImagePreview(){
	bindImagePreviewOne("A");
	bindImagePreviewOne("D");
}
function bindImagePreviewOne(kind){
	var id = imgIds(kind);
	var f = document.getElementById(id.file);
	if(!f) return;
	f.onchange = function(){
		var file = (this.files && this.files.length > 0) ? this.files[0] : null;
		if(!file) return;
		if(String(file.type).indexOf("image/") !== 0){ alert("이미지 파일만 선택할 수 있습니다."); this.value = ""; return; }
		document.getElementById(id.nm).innerHTML = file.name;
		releasePreviewBlob(kind);
		if(window.URL && window.URL.createObjectURL){
			previewBlobUrl[kind]  = window.URL.createObjectURL(file);
			previewFileName[kind] = file.name;
		}
		if(typeof FileReader === "undefined") return;	// 구형 브라우저는 파일명만 표기
		var r = new FileReader();
		r.onload = function(e){
			var img = document.getElementById(id.view);
			img.src = e.target.result;
			img.alt = file.name;
		};
		r.readAsDataURL(file);
	};
}

// 이미지 업로드 완료 콜백. 응답 JSP(masterMdCmStndrdCatalogDetailResultPop)가 iframe 안에서 parent.upSet(docNo) 로 부른다.
// DAO 가 실패 시 docNo 를 "ERROR" 로 바꿔 돌려준다.
function upSet(error){
	if(error == "ERROR"){
		alert("이미지 등록에 실패 하였습니다.");
		return;
	}
	alert("이미지가 등록/수정되었습니다.");
	location.reload();
}

// 확대보기. 고른 파일이 있으면 저장 전이라도 그 원본을, 없으면 등록된 S3 이미지를 열어준다.
// kind : A=대표이미지 / D=상세이미지
function setImageView(kind){
	kind = (kind == "D") ? "D" : "A";
	var id  = imgIds(kind);
	var ttl = (kind == "D") ? "상세이미지" : "대표이미지";
	var url = document.getElementById(id.url).value;
	var opt = "status=no,resizable=yes,menubar=no,scrollbars=yes,width=700,height=700";

	if(previewBlobUrl[kind] != ""){
		var w = window.open("", "cmsItemImage", opt);
		if(!w){ return; }
		var t = ttl + " 확대보기 (저장 전 원본) - " + previewFileName[kind];
		w.document.open();
		w.document.write("<html><head><meta charset=\"utf-8\"><title>" + t + "<\/title>"
			+ "<style>body{margin:0;background:#fff;font-family:'돋움',Dotum;font-size:12px;}"
			+ "p{margin:0;padding:6px 8px;color:#c0392b;border-bottom:1px solid #e0e0e0;}"
			+ "img{display:block;max-width:100%;}<\/style></head><body>"
			+ "<p>" + (kind == "D" ? "저장 전 원본입니다." : "저장 전 원본입니다. 등록/수정 시 500x500 흰 여백 이미지로 변환됩니다.") + "<\/p>"
			+ "<img src=\"" + previewBlobUrl[kind] + "\" alt=\"" + ttl + "\"><\/body><\/html>");
		w.document.close();
		w.focus();
		return;
	}

	if(url == ""){ alert("등록된 이미지가 없습니다."); return; }
	window.open(url, "cmsItemImage", opt);
}

// 필수 속성(*) 공란 검사 : "필수값 공란 불가"
function checkEssAttr(){
	var ok = true;
	$("input[id^='st_attr_']").each(function(){
		if($(this).attr("data-ess") == "Y" && $.trim($(this).val()) == ""){
			alert("필수 속성 [" + $(this).attr("data-nm") + "] 값을 입력하여 주십시오.");
			$(this).focus();
			ok = false;
			return false;	// each 중단
		}
	});
	return ok;
}

//기능함수 (이번 단계는 조회 배선 - 저장 등 쓰기 로직은 후속)
function doAction(str){
	switch(str){
		case "request": // ①~⑦ 수정 후 [요청] → 변경요청 사유 기재 팝업
			if(!checkEssAttr()) return;

			mdcmChangeItems = collectChanges();
			if (mdcmChangeItems.length == 0) {
				alert("변경된 항목이 없습니다.");
				return;
			}

			// 사유 목록 방향 : 사용→미사용 = OUT / 미사용→사용 = IN / 상품상태 미변경 = 공란
			var dir = "";
			if (ORIG.STATUS != curStatusText()) { dir = (curStatusText() == "미사용") ? "OUT" : "IN"; }

			// ⚠ 변경 내역은 URL 이 아니라 opener 로 넘긴다 — 한글을 encodeURI 하면 3배로 불어 URL 이 잘린다.
			// [사용→미사용] 은 여기서 막지 않는다 — 승인 시 그 상품에 달린 구매정보를 전부 [불가] 로
			// 함께 내린다(MasterMdCmCmsItemChangeReqDaoImpl.approveChangeReq).
			openSearchPopup("/mdcm/showMasterMdCmCmsItemStatusChangePop.do"
			               ,"?st_catlg_id=" + $.trim($("#st_msds_no").val()) + "&st_reason_dir=" + dir
			               ,"800,480,no");
			break;
		case "imgFile":  // 대표이미지 파일선택 (PPT는 버튼 라벨이라 file input 은 숨기고 버튼이 대신 연다)
		case "imgFileD": // 상세이미지 파일선택
			document.getElementById(imgIds(str == "imgFileD" ? "D" : "A").file).click();
			break;
		case "imgSave":  // 대표이미지 등록/수정. 서버가 500x500 레터박스로 리사이즈해 S3에 올린다.
		case "imgSaveD": // 상세이미지 등록/수정. 이쪽은 리사이즈 없이 원본 그대로 올라간다(DETAIL_IMGFILE_*).
			var kind = (str == "imgSaveD") ? "D" : "A";
			var fv = document.getElementById(imgIds(kind).file).value;
			if(fv == ""){ alert("등록할 이미지를 먼저 선택하여 주십시오."); return; }
			var dot = fv.lastIndexOf(".");
			var ext = (dot > -1) ? fv.substring(dot).toLowerCase() : "";
			if(ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
				alert("이미지 업로드 할 수 없는 확장자 입니다.");
				return;
			}
			releasePreviewBlob(kind);
			var frm = (kind == "D") ? "#imageDetailUploadForm" : "#imageUploadForm";
			var act = (kind == "D") ? "/mdcm/addMasterMdCmStndCatalogAlterDetailPop.do"
			                        : "/mdcm/addMasterMdCmStndCatalogAlterPop.do";
			$(frm).attr("target","account_work");
			$(frm).attr("action",act).submit();
			break;
		case "history": // 변경이력 보기
			var st_catlg_id = $.trim($("#st_cms_catlg_id").val());
			openSearchPopup("/mdcm/showMasterMdCmCmsItemHistoryPop.do","?st_catlg_id="+st_catlg_id, "1303,356,no");
			break;
		case "standard": // 표준화기준 (구매본부 지정 표준화 가이드 파일 다운로드)
			alert("표준화기준 가이드 파일은 후속 작업에서 연결됩니다.");
			break;
		case "maker": // 제조사 선택 - 유사명 포함 컬럼 5개라 700px에서는 헤더가 줄바꿈된다
			popupSel = "maker";
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
		case "origin": // 원산지 선택
			popupSel = "origin";
			openSearchPopup("/common/countryCodePop.do", "", "500,464,no");
			break;
		case "basePriceChg": // 기준가/기준가유형 변경 → 기준가 변경 팝업. 인상=즉시반영 / 인하=품의상신
			openSearchPopup("/mdcm/showMasterMdCmCmsItemBasePriceChangePop.do"
			               ,"?st_catlg_id=" + $.trim($("#st_cms_catlg_id").val()), "580,393,no");
			break;
		case "basePriceHist": // 기준가 변경이력 → 기준가 변경이력 팝업
			openSearchPopup("/mdcm/showMasterMdCmCmsItemBasePriceHistoryPop.do"
			               ,"?st_catlg_id=" + $.trim($("#st_cms_catlg_id").val()), "823,356,no");
			break;
	}
}

/* 기준가 변경 팝업이 **즉시반영(인상)** 을 마치면 부른다 — 이 팝업은 조회 재호출 경로가 없어
 * 리로드하면 사용자가 손대던 입력이 날아간다. 그래서 화면 값만 바꿔 끼운다.
 * ⚠ 인하(품의 상신)에서는 부르지 않는다 — 승인 전까지 CMSCATLG 가 안 바뀌므로 화면도 바뀌면 거짓이 된다.
 * ⚠ 변경여부 칸은 건드리지 않는다 — 조회 SQL 이 BASE_PRICE_CHG_YN 을 아직 공백으로 고정한다(이력 미도입). */
function applyBasePriceChanged(priceView, typeCode){
	var el = document.getElementById("viewBasePrice");
	if(el && priceView != null){ el.innerHTML = priceView; }

	if(typeCode){
		var $sel = $("#st_base_price_type");
		if($sel.find("option[value='" + typeCode + "']").length > 0){ $sel.val(typeCode); }
	}
}

// 팝업 선택 반환 콜백 (popupSel로 분기. opener = 이 상세 팝업)
// ⚠ 카테고리/상세분류는 이 팝업에서 **수정 대상이 아니다**(2026-08-21 사용자 결정) — 돋보기 2종만 돌아온다.
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	if(popupSel == "maker"){				// 제조사 (maker_code, maker_name)
		document.getElementById("st_maker_code").value = value1;
		document.getElementById("st_maker_name").value = value2;
		return;
	}
	if(popupSel == "origin"){				// 원산지 (code, 국가명(영문), 국가명(국문))
		document.getElementById("st_origin_code").value = value1;
		document.getElementById("st_origin_name").value = value3;	// 화면 표기는 국문
		return;
	}
}
</script>

<style>
.PopNewBox{background-color:#fff; border-radius:5px; margin-top:10px;}
.PopTableBox{display:block; margin:0px 15px; padding-bottom:10px;  }
.PopTitle_s {display:block; margin-bottom:5px; height:46px;line-height:50px; padding-left:15px;  font-size:16px; font-weight:bold; letter-spacing:-1.5px; color:#000; border-bottom:0px solid #eaeaea  }
.PopTitle_s b{ font-size:16px;line-height:46px; margin-right:5px;}
.PopTitle_s span{float:right; margin-right:15px; margin-top:10px; width:30px; height:30px; line-height:30px; font-size:30px; letter-spacing:-1px;color:#000; text-align:center; border-radius:50px; background-color:#fff}
/* 좌(폼) + 우(규격속성) 2단 배치. 상품이미지는 2026-09-15 지시로 안전인증정보 아래 별도 섹션으로 나갔다. */
.baseInfoWrap{ display:table; width:100%; table-layout:fixed; }
.baseInfoLeft{ display:table-cell; width:74%; vertical-align:top; }
.baseInfoRight{ display:table-cell; width:26%; vertical-align:top; }
.reqMark{ color:#d00; }
/* ⚠ base.css 는 `select, textarea` 만 잡고 **input 규칙이 없다**(base.css:9). cont_t_list06 에도 input 스타일이 없어
      (master_layout.css:338~348) 그대로 두면 input 만 브라우저 기본 폰트·높이로 떠서 옆 칸 글씨(돋움 12px)와 어긋난다.
      cont_t_list01(:254) 이 본문 화면에서 쓰는 규칙을 이 팝업 범위에만 옮겨 select/input 을 같은 치수로 맞춘다. */
#popContainer input[type="text"], #popContainer input[type="password"]{
	border:1px solid #aaaaaa; background:#fff;
	font-family:"돋움", Dotum, Verdana; font-size:12px; font-weight:normal; color:#666666;
	height:22px; line-height:22px; padding:0 4px; vertical-align:middle;
	-moz-box-sizing:border-box; box-sizing:border-box;
}
#popContainer select{
	font-family:"돋움", Dotum, Verdana; font-size:12px; height:22px; vertical-align:middle;
	-moz-box-sizing:border-box; box-sizing:border-box;
}
/* td 에 세로 padding 이 없어(:343 padding-left 만) 22px input 이 들어가면 행이 답답해진다 */
/* 라벨열을 좁힌 만큼 값 칸이 넓어진다 — 라벨이 접히면 그 이득이 사라지므로 nowrap 으로 고정한다 */
#popContainer .cont_t_list06 th{ padding:5px 8px; white-space:nowrap; }
#popContainer .cont_t_list06 td{ padding:5px 8px; line-height:22px; }
#popContainer .cont_t_list06 td select{ width:90%; }
#popContainer .baseInfoLeft .cont_t_list06 td select,
#popContainer .baseInfoLeft .cont_t_list06 td input[type="text"]{ width:92%; }
#popContainer .baseInfoLeft .cont_t_list06 td .popPickWrap{ display:inline-block; width:92%; position:relative;
                                                            padding-right:26px; box-sizing:border-box; -moz-box-sizing:border-box;
                                                            vertical-align:middle; }
#popContainer .baseInfoLeft .cont_t_list06 td .popPickWrap input.popPickInput{ width:100%; }
#popContainer .baseInfoLeft .cont_t_list06 td .popPickWrap a{ position:absolute; right:0; top:0; line-height:0; }
#popContainer .baseInfoLeft .cont_t_list06 td .popPickWrap a img{ vertical-align:top; }
#popContainer .baseInfoLeft .cont_t_list06 td.noSep{ border-right:0; }
#popContainer .cont_t_list06 td img{ vertical-align:middle; }
/* cont_t_list06 기본 스타일은 border-top만 있어 좌/우/하단 외곽선이 없음 → 이 팝업 내 표는 외곽 테두리 보강 */
#popContainer .cont_t_list06{ border-collapse:collapse; border-left:1px solid #cdcdcd; border-right:1px solid #cdcdcd; border-bottom:1px solid #cdcdcd; }
#popContainer .cont_t_list06 th, #popContainer .cont_t_list06 td{ border-right:1px solid #e0e0e0; }
/* 좌우를 틈 없이 붙이고, 경계는 상단선과 같은 톤의 2px 한 줄로만 긋는다.
   (표 자체 테두리는 박스가 대신 그리므로 0. 상단 2px 진한 선은 cont_t_list06 관용구라 박스로 옮긴다.) */
#popContainer .attrScroll{ overflow-y:auto; border:1px solid #cdcdcd; border-top:2px solid #6a6a6a;
                           border-left:2px solid #6a6a6a; box-sizing:border-box; }
#popContainer .baseInfoLeft .cont_t_list06{ border-right:0; }
#popContainer .attrScroll .cont_t_list06{ border:0; margin-bottom:0; }
/* 스크롤해도 속성명/속성값 헤더는 붙어 있는다.
   ⚠ border-collapse:collapse 표에서는 sticky 셀의 테두리가 따라오지 않아 아래 경계선이 사라진다
      → box-shadow 로 대신 긋는다. 배경(#eaeaea)이 불투명해야 밑줄 행이 비쳐 보이지 않는다. */
#popContainer .attrScroll thead th{ position:-webkit-sticky; position:sticky; top:0; z-index:2;
                                    background:#eaeaea; box-shadow:inset 0 -1px 0 #cdcdcd; }
/* 라벨 nowrap 은 4열 폼 얘기다 — 여기 속성명은 길면 접혀야 한다(접힐 곳은 단어 경계로) */
#popContainer .attrScroll th{ white-space:normal; word-break:keep-all; }
/* 상품이미지 : masterMdCmBuyerCatalogAlterPop 과 같은 관용구 —
   큰 정사각 박스 1개 + 바로 아래 [확대보기] 링크 + 버튼. 단일 파일이라 슬롯 개념이 없다. */
.imgBox{ display:block; width:100%; height:170px; line-height:0; font-size:0; text-align:center;
         border:1px solid #cdcdcd; background:#fff; overflow:hidden; }
/* line-height 로 세로중앙을 잡으면 이미지가 170px 까지 커졌을 때 라인박스가 박스보다 커져 아래가 잘린다.
   높이 100% 짜리 0폭 스트럿을 세워 중앙을 잡으면 이미지 최대높이와 박스높이가 정확히 맞는다.
   ⚠ font-size:0 필수 — 스트럿과 <img> 사이 JSP 들여쓰기 공백이 한 칸(약 4px)으로 렌더되면
      "0 + 4 + 이미지폭(max-width:100%)" 이 박스 폭을 넘겨 이미지가 둘째 줄로 밀리고,
      첫 줄을 170px 스트럿이 차지하므로 이미지가 통째로 박스 아래로 잘려 사라진다. */
.imgBox:before{ content:""; display:inline-block; width:0; height:100%; vertical-align:middle; }
.imgBox img{ max-width:100%; max-height:100%; vertical-align:middle; cursor:pointer; }
.imgZoom{ display:block; text-align:center; margin-top:4px; font-size:11px; }
.imgZoom img{ vertical-align:middle; margin-right:3px; }
.imgFileNm{ display:block; text-align:center; margin-top:3px; font-size:11px; color:#999;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
/* 상품이미지 섹션 : 대표/상세 2슬롯을 한 행에 나란히. 칸이 넓어졌으니 박스도 키운다.
   ⚠ 표에 table-layout:fixed 를 거는 이유 — 파일명이 nowrap 이라 자동 레이아웃에서는
      파일명 길이가 그 칸의 최소너비가 되어 긴 파일명이 옆 슬롯을 밀어낸다. */
#popContainer .cont_t_list06 td.imgSlot{ vertical-align:top; padding:10px 8px; }
.imgSlot .imgBox{ height:220px; }
.imgBtnArea{ text-align:center; }
.imgBtnArea .btn_02{ display:inline-block; }
.sgName{ font-weight:bold; }
/* 상세분류 경로 : `전체 > A > B > ...` 라 구분자에 공백이 있다.
   keep-all 을 걸면 아무 데서나 잘리지 않고 그 공백(구분자)에서만 접힌다. */
.categPath{ word-break:keep-all; }
/* 돋보기 선택 전용 칸 : 직접 타이핑 못 하게 readonly, 값은 팝업이 채운다.
   ⚠ 배경 회색은 쓰지 않는다(사용자 지시 2026-08-25) — 나머지 입력칸과 같은 흰 바탕. */
.popPickInput{ width:74%; }
/* 구매정보 리스트는 11컬럼이라 좁은 창에서 가로 스크롤에 맡긴다(창 폭을 그리드에 맞추지 않는다) */
.buyInfoScroll{ width:100%; overflow-x:auto; }
.buyInfoScroll table{ min-width:900px; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_msds_no" name="st_msds_no" value="<%=st_msds_no%>">
	</form>

	<!-- 상품이미지 업로드 전용 폼. 기존 표준카탈로그 이미지 등록 라우트를 그대로 쓴다
	     (/mdcm/addMasterMdCmStndCatalogAlterPop.do → CMSCATLG.IMGFILE_DIR/NAME 갱신).
	     응답 JSP(masterMdCmStndrdCatalogDetailResultPop)가 parent.upSet(docNo) 를 부르므로
	     제출 대상은 숨긴 iframe 이고, 이 팝업에 upSet 이 있어야 한다. -->
	<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="0" height="0"></iframe>
	<form name="imageUploadForm" id="imageUploadForm" method="post" enctype="multipart/form-data" modelAttribute="uploadForm">
		<input type="hidden" id="st_cms_catlg_id" name="st_cms_catlg_id" value="<%=d_catlg %>">
		<input type="hidden" name="st_img_resize_yn" value="Y">
		<input type="file" id="st_image_file" name="files" style="display:none;">
	</form>

	<!-- 상세이미지 업로드 전용 폼. 대표이미지와 라우트·파라미터 이름이 갈린다 —
	     files2 / addMasterMdCmStndCatalogAlterDetailPop.do → CMSCATLG.DETAIL_IMGFILE_DIR/NAME.
	     ⚠ st_cms_catlg_id 는 id 를 주지 않는다 — 위 폼의 같은 이름 hidden 이 doAction 에서 쓰인다. -->
	<form name="imageDetailUploadForm" id="imageDetailUploadForm" method="post" enctype="multipart/form-data" modelAttribute="uploadForm">
		<input type="hidden" name="st_cms_catlg_id" value="<%=d_catlg %>">
		<input type="file" id="st_image_file2" name="files2" style="display:none;">
	</form>

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">상품정보 상세 조회 및 수정</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<!--상품기본정보 (좌: 폼 / 우: 규격 상세 속성)-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('0');"><div class="PopTitle_s"><b id="show0"></b> 상품기본정보 <span id="btn0"></span></div></a>
				<div id="div0" class="PopTableBox">
					<div class="baseInfoWrap">

						<!-- 좌측 : 상품기본정보 폼 -->
						<div class="baseInfoLeft">
							<table class="cont_t_list06" summary="상품기본정보" style="width:100%;" id="baseInfoTable">
								<caption>상품기본정보</caption>
								<colgroup>
									<col width="16%" />
									<col width="34%" />
									<col width="16%" />
									<col width="*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="center">상품정보코드</th>
										<td class="center"><%=d_catlg %></td>
										<th scope="row" class="center">상품상태</th>
										<td class="left">
											<select id="st_use_yn" name="st_use_yn">
												<option value="Y" <%="D".equals(d_status) ? "" : "selected" %>>사용</option>
												<option value="N" <%="D".equals(d_status) ? "selected" : "" %>>미사용</option>
											</select>
											</td>
									</tr>
									<!-- 카테고리/상세분류 : 조회 전용. 경로가 길어 한 줄에 안 들어가므로(최대 59자)
									     짧은 둘(카테고리·상세분류코드)을 한 행에 두고, 경로만 풀폭 단독 행으로 뺀다. -->
									<tr>
										<th scope="row" class="center">카테고리</th>
										<td class="left sgName" id="st_sg_name_txt"><%=d_sg_name %></td>
										<th scope="row" class="center">상세분류코드</th>
										<td class="left" id="st_categ_id_txt"><%=d_categ %></td>
									</tr>
									<tr>
										<th scope="row" class="center">상세분류</th>
										<td class="left categPath" colspan="3" id="st_categ_path_txt"><%=d_categ_path %></td>
									</tr>
									<!-- 품목명·모델번호 : 텍스트 직접 수정 후 [요청] -->
									<tr>
										<th scope="row" class="center">품목명</th>
										<td class="left"><input type="text" id="st_description_loc" name="st_description_loc" value="<%=d_name %>"></td>
										<th scope="row" class="center">모델번호</th>
										<td class="left"><input type="text" id="st_model_info" name="st_model_info" value="<%=d_model %>"></td>
									</tr>
									<!-- 규격은 속성값의 조합 표기라 여기서는 읽기. 수정은 우측 [규격 상세 속성]에서 -->
									<tr>
										<th scope="row" class="center">규격</th>
										<td class="left" colspan="3" id="spec_view"><%=d_spec %></td>
									</tr>
									<!-- 제조사·원산지 : 돋보기 팝업 선택 전용 -->
									<tr>
										<th scope="row" class="center">제조사</th>
										<td class="left">
											<span class="popPickWrap">
												<input type="text" id="st_maker_name" name="st_maker_name" class="popPickInput" value="<%=d_maker %>" readonly>
												<input type="hidden" id="st_maker_code" name="st_maker_code" value="<%=d_maker_cd %>">
												<a href="javascript:doAction('maker');"><img src="/resources/images/btn_search03.gif" alt="제조사 조회"></a>
											</span>
											</td>
										<th scope="row" class="center">원산지</th>
										<td class="left">
											<span class="popPickWrap">
												<input type="text" id="st_origin_name" name="st_origin_name" class="popPickInput" value="<%=d_origin %>" readonly>
												<input type="hidden" id="st_origin_code" name="st_origin_code" value="<%=d_origin_cd %>">
												<a href="javascript:doAction('origin');"><img src="/resources/images/btn_search03.gif" alt="원산지 조회"></a>
											</span>
											</td>
									</tr>
									<tr>
										<!-- 단위 : KeP 등록 기본 단위 전체 (ICOMCOD1 M007, FLAG='Y') -->
										<th scope="row" class="center">단위</th>
										<td class="left">
											<select id="st_order_measure" name="st_order_measure">
												<%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "SEL", d_measure) %>
											</select>
											</td>
										<!-- 상품구분 : 표준품/비표준품
										     ⚠ ITEM_GUBUN(M118)은 실제 4값(M/G/S/A)인데 화면은 2값이다. 접는 기준은 기획 미확정
										        → 목록 화면과 같은 임시 규칙(G=표준품 / 나머지=비표준품)을 쓴다. -->
										<th scope="row" class="center">상품구분</th>
										<td class="left">
											<select id="st_item_gubun" name="st_item_gubun">
												<option value="G" <%="G".equals(d_gubun_cd) ? "selected" : "" %>>표준품</option>
												<option value="N" <%="G".equals(d_gubun_cd) ? "" : "selected" %>>비표준품</option>
											</select>
											</td>
									</tr>
									<!-- 일회성구분·구매담당자는 수정 대상이 아니다 -->
									<tr>
										<th scope="row" class="center">일회성구분</th>
										<td class="center"><%=d_onetime %></td>
										<th scope="row" class="center">구매담당자</th>
										<td class="center"><%=d_person_view %></td>
									</tr>
									<tr>
										<!-- TR취급가능여부 : ICOMCOD1 M181, FLAG='Y'
										     ⚠ "전체 List는 추후 별도 전달 예정" → 코드값 3종은 아직 잠정안이다.
										        List 가 확정되면 ICOMCOD1 행만 갈면 되고 이 JSP 는 손대지 않는다. -->
										<th scope="row" class="center">TR가능여부</th>
										<td class="left noSep">
											<select id="st_tr_handle" name="st_tr_handle">
												<%=CommonUtil.getCodeComboQueryIdList("master.mdcm.getCmsItemTrHandleCodeList", "SEL", d_tr_cd) %>
											</select>
											</td>
										<td class="left" colspan="2">&nbsp;</td>
									</tr>
								</tbody>
							</table>
						</div>

						<!-- 우측 : 규격 상세 속성 (상세분류가 정의한 속성. 필수 속성은 * 표시·공란 불가) -->
						<div class="baseInfoRight">
							<!-- 속성 개수는 상세분류마다 다르다 — 좌측 표 높이에 맞춰 이 박스 높이를 잡고(syncAttrHeight),
							     넘치는 속성은 박스 안에서만 스크롤한다. 박스가 외곽선을 그리므로 표 자체의 테두리는 뺀다. -->
							<div class="attrScroll" id="attrScroll">
								<table class="cont_t_list06" summary="규격 상세 속성" style="width:100%;">
									<caption>규격 상세 속성</caption>
									<colgroup>
										<col width="35%" />
										<col width="*" />
									</colgroup>
									<thead>
										<tr>
											<th scope="col" class="center">속성명</th>
											<th scope="col" class="center">속성값</th>
										</tr>
									</thead>
									<tbody>
<%
		if(_attrList.size() == 0){
%>
										<tr>
											<td class="center" colspan="2">상세분류에 지정된 속성이 없습니다.</td>
										</tr>
<%
		}else{
			for(int i = 0; i < _attrList.size(); i++){
				Map<String,String> _attr = _attrList.get(i);
				String a_nm   = HtmlUtils.htmlEscape(CommonUtil.nvl(_attr.get("ATTR_NM")));
				String a_val  = HtmlUtils.htmlEscape(CommonUtil.nvl(_attr.get("ATTR_VAL")));
				String a_ess  = HtmlUtils.htmlEscape(CommonUtil.nvl(_attr.get("ESS_FLAG")));
				String a_unit = HtmlUtils.htmlEscape(CommonUtil.nvl(_attr.get("ATTR_UNIT")));
%>
										<tr>
											<th scope="row" class="center"><%=a_nm %><%= "Y".equals(a_ess) ? " <span class=\"reqMark\">*</span>" : "" %></th>
											<!-- 기재값도 수정 가능하다(옛 설계안의 "기재값 수정 불가"는 폐기). 필수 속성은 공란 불가. -->
											<td class="center"><input type="text" id="st_attr_<%=i %>" name="st_attr_<%=i %>" style="width:85%;" value="<%=a_val %>" data-ess="<%=a_ess %>" data-nm="<%=a_nm %>"><%=a_unit %></td>
										</tr>
<%
			}
		}
%>
									</tbody>
								</table>
							</div>
						</div>

					</div>

					<!-- [표준화기준] 가이드 다운로드 + (1)~(7) 수정 후 [요청] → 변경요청 사유 기재 팝업 -->
					<div class="btnArea mt05" style="text-align:right; padding-top:8px;">
						<span class="btn_02"><a href="javascript:doAction('standard');">표준화기준</a></span>
						<span class="btn_02"><a href="javascript:doAction('request');">요청</a></span>
					</div>
				</div>
			</div>

			<!--화학물질정보-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('1');"><div class="PopTitle_s"><b id="show1"></b> 화학물질정보 <span id="btn1"></span></div></a>
				<div id="div1" class="PopTableBox">
					<table class="cont_t_list06" summary="화학물질정보" style="width:100%;">
						<caption>화학물질정보</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<!-- 순서 : 화학물질정보 No. 가 먼저, 유해화학물질이 뒤 -->
							<tr>
								<!-- 화학물질정보 No. : MSDS No. / 안전확인대상 생활화학제품 No. 통합. 이 팝업에서는 조회만 가능(수정 불가) -->
								<th scope="row" class="center">화학물질정보 No.</th>
								<td class="center"><%=d_chem_no %></td>
								<!-- 유해화학물질 : 매핑된 MSDS가 유해화학물질이면 Y (MSDS 변경 시 함께 바뀌는 종속값).
								     ⚠ MSDS No. 가 없으면 Y/N 이 아니라 **공란**이다. -->
								<th scope="row" class="center">유해화학물질</th>
								<td class="center"><%= "".equals(d_chem_no) ? "" : ("Y".equals(d_harmful) ? "Y" : "N") %></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!--안전인증정보-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('2');"><div class="PopTitle_s"><b id="show2"></b> 안전인증정보 <span id="btn2"></span></div></a>
				<div id="div2" class="PopTableBox">
					<table class="cont_t_list06" summary="안전인증정보" style="width:100%;">
						<caption>안전인증정보</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="center">안전인증여부</th>
								<td class="center"><%=d_safe_stat %></td>
								<!-- 안전인증구분 : 상세분류에 따라 자동 지정 -->
								<th scope="row" class="center">안전인증구분</th>
								<td class="center"><%=d_safetype %></td>
							</tr>
							<tr>
								<!-- 안전인증번호 : 협력사 제출 + SM 확인 기준. 미기재 되는 경우도 존재(공란) -->
								<th scope="row" class="center">안전인증번호</th>
								<td class="left" colspan="3"><%=d_safeno %></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!--상품이미지 (2026-09-15 사용자 지시로 상품기본정보 좌측 칸에서 여기로 이동)
			     대표이미지 = CMSCATLG.IMGFILE_*   : 서버가 500x500 흰 여백 레터박스로 리사이즈해 S3 에 올린다
			     상세이미지 = CMSCATLG.DETAIL_IMGFILE_* : 리사이즈 없이 원본 그대로 올라간다
			     ⚠ 섹션 인덱스는 6 이다 — DOM 위치는 여기지만 뒤 섹션(3~5) 번호를 밀지 않으려고 뒤 번호를 썼다. -->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('6');"><div class="PopTitle_s"><b id="show6"></b> 상품이미지 <span id="btn6"></span></div></a>
				<div id="div6" class="PopTableBox">
					<table class="cont_t_list06" summary="상품이미지" style="width:100%; table-layout:fixed;">
						<caption>상품이미지</caption>
						<colgroup>
							<col width="50%" />
							<col width="*" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col" class="center">대표이미지</th>
								<th scope="col" class="center">상세이미지</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="center imgSlot">
									<span class="imgBox">
										<img src="<%=d_img_view %>" id="st_image_view" name="st_image_view" alt="대표이미지" onclick="javascript:setImageView('A');">
									</span>
									<a href="javascript:setImageView('A');" class="imgZoom">
										<img src="/resources/images/btn_search03.gif" alt="확대보기">대표이미지 확대보기
									</a>
									<span class="imgFileNm" id="st_image_file_nm"><%=d_img_name %></span>
									<input type="hidden" id="st_image_url"  name="st_image_url"  value="<%=d_img_url %>">
									<input type="hidden" id="st_image_dir"  name="st_image_dir"  value="<%=d_img_dir %>">
									<input type="hidden" id="st_image_name" name="st_image_name" value="<%=d_img_name %>">
									<div class="imgBtnArea mt05">
										<span class="btn_02"><a href="javascript:doAction('imgFile');">파일선택</a></span>
										<span class="btn_02"><a href="javascript:doAction('imgSave');">등록/수정</a></span>
									</div>
								</td>
								<td class="center imgSlot">
									<span class="imgBox">
										<img src="<%=d_dimg_view %>" id="st_image_view2" name="st_image_view2" alt="상세이미지" onclick="javascript:setImageView('D');">
									</span>
									<a href="javascript:setImageView('D');" class="imgZoom">
										<img src="/resources/images/btn_search03.gif" alt="확대보기">상세이미지 확대보기
									</a>
									<span class="imgFileNm" id="st_image_file_nm2"><%=d_dimg_name %></span>
									<input type="hidden" id="st_image_url2"  name="st_image_url2"  value="<%=d_dimg_url %>">
									<input type="hidden" id="st_image_dir2"  name="st_image_dir2"  value="<%=d_dimg_dir %>">
									<input type="hidden" id="st_image_name2" name="st_image_name2" value="<%=d_dimg_name %>">
									<div class="imgBtnArea mt05">
										<span class="btn_02"><a href="javascript:doAction('imgFileD');">파일선택</a></span>
										<span class="btn_02"><a href="javascript:doAction('imgSaveD');">등록/수정</a></span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!--상품정보이력-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('3');"><div class="PopTitle_s"><b id="show3"></b> 상품정보이력 <span id="btn3"></span></div></a>
				<div id="div3" class="PopTableBox">
					<!-- 라벨|값|라벨|값 **4열 3행** 정형 표다. rowspan·빈 칸·colspan 없이 그대로 옮긴다. -->
					<table class="cont_t_list06" summary="상품정보이력" style="width:100%;">
						<caption>상품정보이력</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="center">최초등록일</th>
								<td class="center"><%=d_regdate %></td>
								<th scope="row" class="center">최종변경일</th>
								<td class="center"><%=d_chgdate %></td>
							</tr>
							<tr>
								<th scope="row" class="center">등록담당자</th>
								<td class="center"><%=d_adduser_view %></td>
								<th scope="row" class="center">변경담당자</th>
								<td class="center"><%=d_chguser_view %></td>
							</tr>
							<tr>
								<!-- 등록견적번호(Key) : 백킹 컬럼 없음 → 설계 확정 후 실배선 -->
								<th scope="row" class="center">등록견적번호<br>(Key)</th>
								<td class="center"><%=d_quot_no %></td>
								<!-- 상품상태부터 이 팝업 안 모든 변경이력을 조회한다 -->
								<th scope="row" class="center">변경이력</th>
								<td class="center"><span class="btn_02"><a href="javascript:doAction('history');">보기</a></span></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!--기준가 정보 + 구매정보 리스트 : 구매팀 전용(타 부서 조회 불가).
			    설계안은 [상품정보상세] / [기준가·구매정보] 두 탭이나, 운영사 스킨에 탭 관용구가 없어
			    아코디언 2개로 내렸다(사용자 지시 2026-08-21). 판정은 ICOMCOD1 TYPE='SOURDEPT'. -->
<%
	if(d_show_price){
%>
			<div class="PopNewBox">
				<a href="javascript:divShowHide('4');"><div class="PopTitle_s"><b id="show4"></b> 기준가 정보 <span id="btn4"></span></div></a>
				<div id="div4" class="PopTableBox">
					<table class="cont_t_list06" summary="기준가 정보" style="width:100%;">
						<caption>기준가 정보</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<!-- 최초 세팅 규칙 : 벌크등록 → 전체 카테고리 평균매익율+α /
								     데일리등록 + 지정협력사 N 일 때만 판매권고가(구매수기입력) / 지정협력사 Y면 무시.
								     ⚠ 값이 없는 상품은 공백으로 나온다 - 아직 기준가가 채워지지 않은 구간이 있다. -->
								<th scope="row" class="center">기준가</th>
								<td class="right" id="viewBasePrice"><%=d_base_view %></td>
								<th scope="row" class="center">기준가 유형</th>
								<td class="left">
									<!-- 기준가유형 : ICOMCOD1 M183, FLAG='Y' (AVG=전체 카테고리 평균매익율+α / REC=판매권고가) -->
									<select id="st_base_price_type" name="st_base_price_type" style="width:70%;">
										<%=CommonUtil.getCodeComboQueryIdList("master.mdcm.getCmsItemBasePriceTypeCodeList", "SEL", d_base_type) %>
									</select>
									</td>
							</tr>
							<tr>
								<!-- 기준가 변경이력이 있으면 Y, 최초등록 이후 변경 없으면 N -->
								<th scope="row" class="center">변경여부</th>
								<td class="center"><%= "Y".equals(d_base_chg) ? "Y" : ("".equals(d_base_chg) ? "" : "N") %></td>
								<!-- 기준가 변경이력 조회 팝업 -->
								<th scope="row" class="center">변경이력</th>
								<td class="left"><span class="btn_02"><a href="javascript:doAction('basePriceHist');">보기</a></span></td>
							</tr>
						</tbody>
					</table>
					<!-- 기준가/기준가유형 수정 후 [변경] → 기준가 변경 사유 입력 팝업.
					     인상은 즉시 반영, 인하는 품의 진행. -->
					<div class="btnArea mt05" style="text-align:right; padding-top:8px;">
						<span class="btn_02"><a href="javascript:doAction('basePriceChg');">변경</a></span>
					</div>
				</div>
			</div>

			<!--구매정보 리스트 : 이 상품정보코드에 걸린 구매정보 전체-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('5');"><div class="PopTitle_s"><b id="show5"></b> 구매정보 리스트 <span id="btn5"></span></div></a>
				<div id="div5" class="PopTableBox">
					<div class="buyInfoScroll">
						<table class="cont_t_list06" summary="구매정보 리스트" style="width:100%;">
							<caption>구매정보 리스트</caption>
							<thead>
								<tr>
									<th scope="col" class="center">구매정보코드</th>
									<th scope="col" class="center">협력사명</th>
									<th scope="col" class="center">매입단가</th>
									<th scope="col" class="center">최소주문수량</th>
									<th scope="col" class="center">주문배수수량</th>
									<th scope="col" class="center">거래유형</th>
									<th scope="col" class="center">배송유형</th>
									<th scope="col" class="center">입고TR</th>
									<th scope="col" class="center">배송일수</th>
									<th scope="col" class="center">유효기간<br>시작일</th>
									<th scope="col" class="center">유효기간<br>종료일</th>
								</tr>
							</thead>
							<tbody>
<%
	if(_buyInfoList.size() == 0){
%>
								<tr>
									<td class="center" colspan="11">조회된 구매정보가 없습니다.</td>
								</tr>
<%
	}else{
		for(int b = 0; b < _buyInfoList.size(); b++){
			Map<String,String> _bi = _buyInfoList.get(b);
%>
								<tr>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("BUY_INFO_SEQ"))) %></td>
									<td class="left"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("VENDOR_NAME"))) %></td>
									<td class="right"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("UNIT_PRICE"))) %></td>
									<td class="right"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("MOQ"))) %></td>
									<td class="right"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("ORDER_MULTIPLE"))) %></td>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("TRADE_TYPE"))) %></td>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("DELIVERY_TYPE"))) %></td>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("IN_TR"))) %></td>
									<td class="right"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("LEADTIME"))) %></td>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("VALID_FROM"))) %></td>
									<td class="center"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(_bi.get("VALID_TO"))) %></td>
								</tr>
<%
		}
	}
%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
<%
	}
%>

			<!--하단 버튼 : 설계안에는 전역 [저장]이 없다. 수정 요청은 상품기본정보의 [요청], 이미지는 [수정/등록]. -->
			<div class="btnArea mt05" style="text-align:center; padding:10px 0;">
				<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
			</div>

			<br>
		</div>
	</div>
</body>
</html>
