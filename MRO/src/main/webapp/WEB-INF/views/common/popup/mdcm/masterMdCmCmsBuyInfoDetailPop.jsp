<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 구매정보코드 클릭 시 상세 팝업
* 화면 : (팝업) 구매정보 상세 조회 및 수정
* 기능 : 상품기본정보(탭 밖 고정) + 탭2개
*        - [상세정보] 구매정보/고객사 매핑정보/기준가정보/구매정보이력
*        - [기타정보] 안전인증정보/화학물질정보/상품이미지/상품정보이력
* 담당자 : 홍준우
* 착수일 : 2026-06-25 (개편 2026-08-06 · 탭 재편 2026-09-08 · 2026-09-11 · 2026-09-17)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="org.springframework.web.util.HtmlUtils"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String st_msds_no  = HtmlUtils.htmlEscape(CommonUtil.nvl((String) request.getParameter("st_msds_no"),""));
String st_buy_info = HtmlUtils.htmlEscape(CommonUtil.nvl((String) request.getParameter("st_buy_info"),""));

// 상세 단건 데이터 (컨트롤러가 TCODE로 조회해 model에 담음). null 가드.
Map<String,String> _data = (Map<String,String>) request.getAttribute("data");
if(_data == null){ _data = new HashMap<String,String>(); }

// 상품 기본정보
String d_catlg     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATLG_ID")));
String d_categ     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATEG_ID")));
String d_name      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DESCRIPTION_LOC")));
String d_spec      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SPECIFICATION")));
String d_maker     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MAKER_NAME")));
String d_origin    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ORIGIN_CODE_NAME")));
String d_measure   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ORDER_MEASURE")));
String d_model     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MODEL_INFO")));
String d_status    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("USE_STATUS")));   // 상품상태 (N=미사용)
// 구매정보 상세
String d_buyinfo   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_INFO_ID")));
String d_vendor    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("AGENT_NAME")));
String d_vendor_cd = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("AGENT_CODE")));
String d_vitemcd   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SELLER_ITEM_NO")));
String d_price     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("LIST_PRICE")));
String d_tax       = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("TAX_TYPE")));
String d_itemtype  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_MAKE_TYPE")));
String d_moq       = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("MOQ")));
String d_ordmul    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("PUR_UNIT_QTY")));
String d_leadtime  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("LEADTIME")));
String d_trade     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("PROCESS_TYPE")));
String d_delivery  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DELIVERY_COND")));   // 배송유형 슬롯(옛 배송조건)
String d_pvd       = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("PRICE_VALID_DATE")));
String d_pvd_end   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("PRICE_VALID_END_DATE")));
// 달력(datepicker) 표기는 yy/mm/dd — DB 는 VARCHAR2(8) YYYYMMDD 라 화면에서만 슬래시를 넣는다
String d_pvd_v     = (d_pvd.length()     == 8) ? d_pvd.substring(0,4)     + "/" + d_pvd.substring(4,6)     + "/" + d_pvd.substring(6,8)     : d_pvd;
String d_pvd_end_v = (d_pvd_end.length() == 8) ? d_pvd_end.substring(0,4) + "/" + d_pvd_end.substring(4,6) + "/" + d_pvd_end.substring(6,8) : d_pvd_end;
// 신규 항목 — 백킹 컬럼이 없어 전부 공백으로 나온다(목록 매퍼의 '' AS 와 같은 자리)
String d_supply    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SUPPLY_STATUS")));

String d_sg_name   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SG_NAME")));
String d_categ_path= HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CMS_CATEG_PATH")));
String d_gubun     = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_GUBUN_NM")));
String d_onetime   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ONETIME_NM")));
String d_tr        = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("TR_HANDLE_NM")));
String d_person    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("KEP_USER_NAME")));
String d_base      = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE")));
String d_base_type = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE_TYPE_NM")));
String d_base_chg  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BASE_PRICE_CHG_YN")));
String d_item_add  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_ADD_DATE")));
String d_item_chg  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_CHANGE_DATE")));
String d_item_addu = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_ADD_USER_NAME")));
String d_item_chgu = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_CHANGE_USER_NAME")));
String d_item_quot = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_QUOTATION_NO")));
String d_buy_add   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_ADD_DATE")));
String d_buy_chg   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_CHANGE_DATE")));
String d_buy_addu  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_ADD_USER_NAME")));
String d_buy_chgu  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_CHANGE_USER_NAME")));
String d_buy_quot  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_QUOTATION_NO")));
String d_safe_st   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_STATUS_NM")));
String d_safe_tp   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_TYPE_NM")));
String d_safe_no   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("SAFE_NO")));
String d_chem_no   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("CHEM_INFO_NO")));
String d_harmful   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("HARMFUL_YN")));

//상품이미지 (CMSCATLG.IMGFILE_DIR/IMGFILE_NAME. 미등록이면 ITEM_IMAGE 가 공백)
String d_img_dir    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("IMGFILE_DIR")));
String d_img_name   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("IMGFILE_NAME")));
String d_img_url    = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("ITEM_IMAGE")));
String d_img_view   = "".equals(d_img_url) ? "/resources/images/icon_emptyimg.gif" : d_img_url;

//상세이미지 (CMSCATLG.DETAIL_IMGFILE_DIR/NAME). 대표이미지와 달리 서버 리사이즈 없이 원본이 그대로 올라간다.
String d_dimg_dir   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_IMGFILE_DIR")));
String d_dimg_name  = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_IMGFILE_NAME")));
String d_dimg_url   = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("DETAIL_ITEM_IMAGE")));
String d_dimg_view  = "".equals(d_dimg_url) ? "/resources/images/icon_emptyimg.gif" : d_dimg_url;

List<Map<String,String>> _attrList = (List<Map<String,String>>) request.getAttribute("attrList");
if(_attrList == null){ _attrList = new ArrayList<Map<String,String>>(); }
List<Map<String,String>> _mapList = (List<Map<String,String>>) request.getAttribute("mapList");
if(_mapList == null){ _mapList = new ArrayList<Map<String,String>>(); }

// 기준가 매익율 = (기준가 - 매입단가) / 기준가 * 100
String d_base_rate = "";
try {
	double _bp = Double.parseDouble(d_base.replaceAll(",", ""));
	double _pp = Double.parseDouble(d_price.replaceAll(",", ""));
	if(_bp != 0){ d_base_rate = new java.text.DecimalFormat("0.0").format((_bp - _pp) / _bp * 100) + "%"; }
} catch(Exception e){ d_base_rate = ""; }

// 코드 표기는 조회값 우선, 없으면 파라미터값
if("".equals(d_catlg)){ d_catlg = st_msds_no; }
if("".equals(d_buyinfo)){ d_buyinfo = st_buy_info; }
// 화면 표기는 순번만 쓴다(상품정보코드는 바로 위 칸에 있다). 키·파라미터는 전체코드 그대로.
String d_buyinfo_seq = HtmlUtils.htmlEscape(CommonUtil.nvl(_data.get("BUY_INFO_SEQ")));
if("".equals(d_buyinfo_seq) && d_buyinfo.indexOf("-") > -1){ d_buyinfo_seq = d_buyinfo.substring(d_buyinfo.indexOf("-") + 1); }
if("".equals(d_buyinfo_seq)){ d_buyinfo_seq = d_buyinfo; }

// 공급상태 : 옛 4종(Y/N/C/E) → 2축 중 "가능/불가". 원본 값 체계가 미확정이라 N 계열만 불가로 접는다.
boolean isUnavail = "N".equals(d_supply) || "N".equals(d_status);
%>
<script type="text/javascript">
// 섹션 접기/펼치기 상태 (섹션 수 만큼)
// 0 상품기본정보(탭 밖 고정)
// [상세정보] 1 구매정보 / 2 고객사매핑정보 / 3 기준가정보 / 4 구매정보이력
// [기타정보] 5 안전인증정보 / 6 화학물질정보 / 7 상품이미지정보 / 8 상품정보이력
var open_flag = ["+","+","+","+","+","+","+","+","+"];

/* [기존] 기준값 — 반드시 사용자가 손대기 전에 잡는다.
 * ⚠ 서버값을 JS 리터럴로 굽지 않는다(formatHTMLCode 가 & 를 &amp; 로 바꿔 비교가 어긋난다).
 *   onload 시점의 DOM 값을 그대로 스냅샷한다. */
var ORIG = {};
var mdcmBuyChangeItems = [];	// 상태변경 팝업이 opener 로 읽어 간다
var mdcmBuyContext     = {};	// 결재 요청 화면이 표에 뿌릴 상품/협력사 컨텍스트

function kep_onload_view(){
	for(var i = 0; i < open_flag.length; i++){
		divShowHide(i);
	}
	showTab(1);
	snapshotOrig();
	syncAttrHeight();
	$(window).on("resize", syncAttrHeight);
	kepSetCalender("st_buy_open_date");
	kepSetCalender("st_buy_close_date");
}

function selText(id){ var el = document.getElementById(id); return (el && el.selectedIndex >= 0) ? el.options[el.selectedIndex].text : ""; }
function selVal(id){ var el = document.getElementById(id); return el ? el.value : ""; }
function dateVal(id){ return kepTrim(id).replace(/\//gi, ""); }

function snapshotOrig(){
	ORIG = {
		 SUPPLY      : selText("st_supply_status")
		,SUPPLY_CD   : selVal("st_supply_status")
		,PRICE       : kepTrim("st_buy_price")
		,SELLER_ITEM : kepTrim("st_seller_item_no")
		,LEADTIME    : kepTrim("st_delivery_lt")
		,ITEM_TYPE   : selText("st_item_make_type")
		,ITEM_TYPE_CD: selVal("st_item_make_type")
		,TAX         : selText("st_tax_type")
		,TAX_CD      : selVal("st_tax_type")
		,OPEN_DATE   : dateVal("st_buy_open_date")
		,CLOSE_DATE  : dateVal("st_buy_close_date")
	};

	mdcmBuyContext = {
		 catlg    : kepTrim("st_msds_no")
		,buyInfo  : kepTrim("st_buy_info")
		,name     : $.trim($("#viewName").text())
		,model    : $.trim($("#viewModel").text())
		,spec     : $.trim($("#viewSpec").text())
		,maker    : $.trim($("#viewMaker").text())
		,measure  : $.trim($("#viewMeasure").text())
		,vendor   : $.trim($("#viewVendor").text())
		,vendorCode : "<%=d_vendor_cd%>"
	};
}

/* 변경 저장 팝업이 저장을 마치고 부른다. info = {pending, applied, date, user}
 *   pending : 결재를 타 아직 DB 에 반영되지 않은 항목 - 그 칸만 값을 되돌린다(승인 전에 반영된 것처럼 보이면 안 된다)
 *   applied : 실제로 반영된 항목 수 - 1건이라도 있으면 CMSPRICE 의 최종변경일·변경담당자도 같이 바뀐다
 * 기준값(ORIG)을 다시 잡지 않으면 [변경] 을 다시 눌렀을 때 같은 항목이 또 걸린다. */
function applySaved(info){
	info = info || {};
	var pending = info.pending || [];
	if ($.inArray("BUY_PRICE", pending) > -1) { $("#st_buy_price").val(ORIG.PRICE); }

	if (info.applied > 0) {
		if (info.date != null && info.date != "") { $("#viewBuyChgDate").text(info.date); }
		if (info.user != null && info.user != "") { $("#viewBuyChgUser").text(info.user); }
	}
	snapshotOrig();
}

/* 상세 팝업에서 실제로 바뀐 항목만 골라낸다 (상품 상세팝업 collectChanges 와 같은 규약).
 * key 는 CMSPRICE 컬럼명과 맞춘다 — 이력(JOB_COLUMN)·수정요청이 같은 어휘를 쓴다.
 * 공급상태만 key 를 STATUS 로 둔다(상태변경 팝업이 사유 드롭다운을 붙이는 기준). */
function collectChanges(){
	var cand = [
		 { key:"STATUS",         label:"공급상태",       before:ORIG.SUPPLY,      after:selText("st_supply_status")
		 , beforeCode:ORIG.SUPPLY_CD,    afterCode:selVal("st_supply_status") }
		,{ key:"BUY_PRICE",      label:"매입단가",       before:ORIG.PRICE,       after:kepTrim("st_buy_price")
		 , beforeCode:ORIG.PRICE,        afterCode:kepTrim("st_buy_price") }
		,{ key:"BUY_OPEN_DATE",  label:"유효기간 시작일", before:ORIG.OPEN_DATE,   after:dateVal("st_buy_open_date")
		 , beforeCode:ORIG.OPEN_DATE,    afterCode:dateVal("st_buy_open_date") }
		,{ key:"BUY_CLOSE_DATE", label:"유효기간 종료일", before:ORIG.CLOSE_DATE,  after:dateVal("st_buy_close_date")
		 , beforeCode:ORIG.CLOSE_DATE,   afterCode:dateVal("st_buy_close_date") }
		,{ key:"DELIVERY_LT",    label:"배송일수",       before:ORIG.LEADTIME,    after:kepTrim("st_delivery_lt")
		 , beforeCode:ORIG.LEADTIME,     afterCode:kepTrim("st_delivery_lt") }
		,{ key:"ITEM_MAKE_TYPE", label:"품목구분",       before:ORIG.ITEM_TYPE,   after:selText("st_item_make_type")
		 , beforeCode:ORIG.ITEM_TYPE_CD, afterCode:selVal("st_item_make_type") }
		,{ key:"TAX_TYPE",       label:"과세구분",       before:ORIG.TAX,         after:selText("st_tax_type")
		 , beforeCode:ORIG.TAX_CD,       afterCode:selVal("st_tax_type") }
		,{ key:"SELLER_ITEM_NO", label:"협력사품목코드",  before:ORIG.SELLER_ITEM, after:kepTrim("st_seller_item_no")
		 , beforeCode:ORIG.SELLER_ITEM,  afterCode:kepTrim("st_seller_item_no") }
	];

	var out = [];
	for (var i = 0; i < cand.length; i++) {
		if (cand[i].after != "" && cand[i].after != cand[i].before) { out.push(cand[i]); }
	}
	return out;
}

//파일선택 → 이미지 박스를 선택한 파일로 교체(클라이언트 미리보기 전용, 업로드 아님).
//슬롯이 대표(A)·상세(D) 둘이므로 미리보기 blob 도 슬롯별로 따로 들고 있는다.
var previewBlobUrl  = { A:"", D:"" };
var previewFileName = { A:"", D:"" };

function divShowHide(num){
	var con = document.getElementById("div"+num);
	if(!con) return;
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
	if(num == 0){ syncAttrHeight(); }
}

/* 좌(상품기본정보)·우(규격 상세 속성) 두 표의 아래끝을 맞춘다. */
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

// 탭 전환 (1 상세정보 / 2 기타정보)
function showTab(no){
	document.getElementById("tabBody1").style.display = (no == 1) ? "block" : "none";
	document.getElementById("tabBody2").style.display = (no == 2) ? "block" : "none";
	document.getElementById("tabBtn1").className = (no == 1) ? "tabBtn on" : "tabBtn";
	document.getElementById("tabBtn2").className = (no == 2) ? "tabBtn on" : "tabBtn";
}

//기능함수 (이번 단계는 화면 레이아웃 위주 - 저장 등 실제 로직은 후속)
// 고객사 매핑정보 그리드의 [품목코드] 셀 클릭 → 공용 카탈로그 상세 팝업
// (주문진행 다운로드 조회 화면의 [품목코드] 클릭과 같은 팝업·같은 4파라미터)
/* 매핑이관 팝업이 이관을 끝내고 부른다 — 옮겨간 고객사 행만 표에서 걷어낸다.
 * 표가 서버 렌더라 다시 그릴 수는 없지만, 이관은 "이 구매정보에서 빠지는" 변경이라 행 제거로 충분하다.
 * keys = ["고객사코드|계약번호|계약순번", ...] */
function removeMapRows(keys){
	if (!keys || keys.length == 0) { return; }

	var $tbody = $("#div2 table.cont_t_list06 tbody");
	for (var i = 0; i < keys.length; i++) {
		$tbody.find('tr[data-mapkey="' + keys[i] + '"]').remove();
	}

	if ($tbody.find("tr[data-mapkey]").length == 0) {
		$tbody.append($('<tr class="emptyRow">').append(
			$('<td class="center" colspan="8">').text("조회된 매핑 고객사가 없습니다.")));
	}
}

function doCustCatalog(buyerCode, buyerItemNo, contractNo, contractSeq){
	if(!buyerItemNo){ return; }
	openSearchPopup("/common/catalogDetailPop.do"
	               ,"?BUYER=" + buyerCode + "&BUYER_ITEM_NO=" + buyerItemNo
	                + "&CONTRACT_NO=" + contractNo + "&CONTRACT_SEQ=" + contractSeq
	               ,"800,290,no");
}

//확대보기. 고른 파일이 있으면 저장 전이라도 그 원본을, 없으면 등록된 S3 이미지를 열어준다.
//kind : A=대표이미지 / D=상세이미지
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

//슬롯별 DOM id 규약 — 대표는 기존 id 그대로, 상세는 뒤에 2 를 붙인다.
function imgIds(kind){
	var s = (kind == "D") ? "2" : "";
	return { file:"st_image_file"+s, view:"st_image_view"+s, nm:"st_image_file_nm"+s, url:"st_image_url"+s };
}

function doAction(str){
	switch(str){
		case "change": // [변경] - 수정 확정. 변경한 항목만 모아 상태변경 팝업으로 넘긴다
			// ⚠ 공급상태는 사유 선택, 나머지(매입단가·배송일수·품목구분·
			//    협력사품목코드·과세구분)는 텍스트 사유. 매입단가 인상만 결재로 간다.
			mdcmBuyChangeItems = collectChanges();
			if (mdcmBuyChangeItems.length == 0) {
				alert("변경된 항목이 없습니다.");
				return;
			}

			// 사유 목록 방향 : 가능→불가 = OUT / 불가→가능 = IN / 공급상태 미변경 = 공란
			var dir = "";
			var nowSupply = selText("st_supply_status");
			if (ORIG.SUPPLY != nowSupply) { dir = (nowSupply == "불가") ? "OUT" : "IN"; }

			// 상품상태가 미사용이면 [불가→가능] 은 막는다 - 팝업은 안내만 띄운다.
			// ⚠ 변경 내역은 URL 이 아니라 opener 로 넘긴다 — 한글을 encodeURI 하면 3배로 불어 URL 이 잘린다.
			openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoStatusChangePop.do"
			               ,"?st_catlg_id=" + mdcmBuyContext.catlg + "&st_buy_info=" + mdcmBuyContext.buyInfo
			                + "&st_reason_dir=" + dir
			                + "&st_blocked=<%= "N".equals(d_status) ? "Y" : "" %>"
			               ,"800,450,no");
			break;
		case "reload": // 변경 저장 팝업이 부르는 공통 갱신 규약 - 반영된 값으로 기준값을 다시 잡는다
			applySaved([]);
			break;
		case "mapMove": // [매핑이관] - 선택한 고객사 매핑을 다른 표준DB코드로 이관
			openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoMapMovePop.do"
			               ,"?st_catlg_id=" + mdcmBuyContext.catlg + "&st_buy_info=" + mdcmBuyContext.buyInfo
			               ,"1180,760,no");
			break;
		case "history": // 상품정보 변경이력 보기
			var st_catlg_id = document.getElementById("st_msds_no").value;
			openSearchPopup("/mdcm/showMasterMdCmCmsItemHistoryPop.do","?st_catlg_id="+st_catlg_id, "1303,356,no");
			break;
		case "buyHistory": // 구매정보 변경이력 보기
			var msds_no  = document.getElementById("st_msds_no").value;
			var buy_info = document.getElementById("st_buy_info").value;
			openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoHistoryPop.do","?st_msds_no="+msds_no+"&st_buy_info="+buy_info, "1133,356,no");
			break;
		case "basePriceHistory": // 기준가 변경이력 보기 (상품 s13 팝업 재사용 - 기준가는 상품 단위다)
			var catlg_id = document.getElementById("st_msds_no").value;
			openSearchPopup("/mdcm/showMasterMdCmCmsItemBasePriceHistoryPop.do","?st_catlg_id="+catlg_id, "823,356,no");
			break;
		case "standard": // 표준화기준
			alert("표준화기준 가이드는 후속 작업에서 연결됩니다.");
			break;
	}
}
</script>

<style>
.PopNewBox{background-color:#fff; border-radius:5px; margin-top:10px;}
.PopTableBox{display:block; margin:0px 15px; padding-bottom:10px;  }
.PopTitle_s {display:block; margin-bottom:5px; height:46px;line-height:50px; padding-left:15px;  font-size:16px; font-weight:bold; letter-spacing:-1.5px; color:#000; border-bottom:0px solid #eaeaea  }
.PopTitle_s b{ font-size:16px;line-height:46px; margin-right:5px;}
.PopTitle_s span{float:right; margin-right:15px; margin-top:10px; width:30px; height:30px; line-height:30px; font-size:30px; letter-spacing:-1px;color:#000; text-align:center; border-radius:50px; background-color:#fff}
/* 탭 (상세정보 / 기타정보) */
.tabWrap{ margin:10px 0 0; font-size:0; }
.tabBtn{ display:inline-block; width:140px; height:36px; line-height:36px; text-align:center; font-size:14px; font-weight:bold;
         color:#666; background-color:#e9e9e9; border:1px solid #cdcdcd; border-bottom:2px solid #3c639c; cursor:pointer; }
.tabBtn.on{ color:#fff; background-color:#3c639c; border-color:#3c639c; }
/* 좌(폼) + 우(규격속성) 2단 배치 */
.baseInfoWrap{ display:table; width:100%; table-layout:fixed; }
.baseInfoLeft{ display:table-cell; width:74%; vertical-align:top; }
.baseInfoRight{ display:table-cell; width:26%; vertical-align:top; }
.chkGroup label{ margin-right:10px; white-space:nowrap; }
.chkGroup input{ vertical-align:middle; margin-right:3px; }
.reqMark{ color:#d00; }
/* cont_t_list06 기본 스타일은 border-top만 있어 좌/우/하단 외곽선이 없음 → 이 팝업 내 표는 외곽 테두리 보강 */
#popContainer .cont_t_list06{ border-collapse:collapse; border-left:1px solid #cdcdcd; border-right:1px solid #cdcdcd; border-bottom:1px solid #cdcdcd; }
#popContainer .cont_t_list06 th, #popContainer .cont_t_list06 td{ border-right:1px solid #e0e0e0; }
.attrBtnArea{ text-align:right; margin-bottom:5px; }
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
#popContainer .cont_t_list06 th{ padding:5px 8px; white-space:nowrap; }
#popContainer .cont_t_list06 td{ padding:5px 8px; line-height:22px; }
#popContainer .cont_t_list06 td select{ width:90%; }
#popContainer .cont_t_list06 td img{ vertical-align:middle; }
#popContainer .attrScroll{ overflow-y:auto; border:1px solid #cdcdcd; border-top:2px solid #6a6a6a;
                           border-left:2px solid #6a6a6a; box-sizing:border-box; }
#popContainer .baseInfoLeft .cont_t_list06{ border-right:0; }
#popContainer .attrScroll .cont_t_list06{ border:0; margin-bottom:0; }
#popContainer .attrScroll thead th{ position:-webkit-sticky; position:sticky; top:0; z-index:2;
                                    background:#eaeaea; box-shadow:inset 0 -1px 0 #cdcdcd; }
#popContainer .attrScroll th{ white-space:normal; word-break:keep-all; }
#popContainer a.mapLink:link, #popContainer a.mapLink:visited{ color:#0b5ed7; text-decoration:underline; cursor:pointer; }
#popContainer a.mapLink:hover{ color:#0b5ed7; text-decoration:underline; }
.imgBox{ display:block; width:100%; height:170px; line-height:0; font-size:0; text-align:center;
         border:1px solid #cdcdcd; background:#fff; overflow:hidden; }
.imgBox:before{ content:""; display:inline-block; width:0; height:100%; vertical-align:middle; }
.imgBox img{ max-width:100%; max-height:100%; vertical-align:middle; cursor:pointer; }
.imgZoom{ display:block; text-align:center; margin-top:4px; font-size:11px; }
.imgZoom img{ vertical-align:middle; margin-right:3px; }
.imgFileNm{ display:block; text-align:center; margin-top:3px; font-size:11px; color:#999;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
#popContainer .cont_t_list06 td.imgSlot{ vertical-align:top; padding:10px 8px; }
.imgSlot .imgBox{ height:220px; }
/* 변경 반영 규칙 안내 */
.ruleNote{ margin:6px 0 0; color:#555; font-size:12px; line-height:1.6; }
.ruleNote b{ color:#c0392b; }
.emptyRow td{ color:#bbb; }
</style>

<body onLoad="kep_onload_view()">
	<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_msds_no"  name="st_msds_no"  value="<%=st_msds_no%>">
		<input type="hidden" id="st_buy_info" name="st_buy_info" value="<%=st_buy_info%>">
	</form>

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">구매정보 상세 조회 및 수정</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<!--상품기본정보 (조회 전용) — 탭 밖 고정. 좌: 폼 / 우: 규격 상세 속성-->
			<div class="PopNewBox">
				<a href="javascript:divShowHide('0');"><div class="PopTitle_s"><b id="show0"></b> 상품기본정보 <span id="btn0"></span></div></a>
				<div id="div0" class="PopTableBox">
					<div class="baseInfoWrap">

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
										<td class="center"><%= "N".equals(d_status) ? "미사용" : "사용" %></td>
									</tr>
									<tr>
										<th scope="row" class="center">카테고리</th>
										<td class="left"><%=d_sg_name %></td>
										<th scope="row" class="center">상세분류코드</th>
										<td class="left"><%=d_categ %></td>
									</tr>
									<tr>
										<th scope="row" class="center">상세분류</th>
										<td class="left" colspan="3"><%=d_categ_path %></td>
									</tr>
									<tr>
										<th scope="row" class="center">품목명</th>
										<td class="left" id="viewName"><%=d_name %></td>
										<th scope="row" class="center">모델번호</th>
										<td class="left" id="viewModel"><%=d_model %></td>
									</tr>
									<tr>
										<th scope="row" class="center">규격</th>
										<td class="left" colspan="3" id="viewSpec"><%=d_spec %></td>
									</tr>
									<tr>
										<th scope="row" class="center">제조사</th>
										<td class="left" id="viewMaker"><%=d_maker %></td>
										<th scope="row" class="center">원산지</th>
										<td class="left"><%=d_origin %></td>
									</tr>
									<tr>
										<th scope="row" class="center">단위</th>
										<td class="left" id="viewMeasure"><%=d_measure %></td>
										<th scope="row" class="center">상품구분</th>
										<td class="left"><%=d_gubun %></td>
									</tr>
									<tr>
										<th scope="row" class="center">일회성구분</th>
										<td class="left"><%=d_onetime %></td>
										<th scope="row" class="center">구매담당자</th>
										<td class="left"><%=d_person %></td>
									</tr>
									<tr>
										<th scope="row" class="center">TR가능여부</th>
										<td class="left" colspan="3"><%=d_tr %></td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="baseInfoRight">
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
											<td class="center"><%=a_val %><%=a_unit %></td>
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

					<div class="btnArea mt05" style="text-align:right; padding-top:8px;">
						<span class="btn_02"><a href="javascript:doAction('standard');">표준화기준</a></span>
					</div>
				</div>
			</div>

			<!--탭-->
			<div class="tabWrap">
				<a href="javascript:showTab(1);"><span id="tabBtn1" class="tabBtn on">상세정보</span></a>
				<a href="javascript:showTab(2);"><span id="tabBtn2" class="tabBtn">기타정보</span></a>
			</div>

			<!--============================ 탭1 : 상세정보 ============================-->
			<div id="tabBody1">

				<!--구매정보-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('1');"><div class="PopTitle_s"><b id="show1"></b> 구매정보 <span id="btn1"></span></div></a>
					<div id="div1" class="PopTableBox">
						<table class="cont_t_list06" summary="구매정보" style="width:100%;">
							<caption>구매정보</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">구매정보코드</th>
									<td class="center"><%=d_buyinfo_seq %></td>
									<th scope="row" class="center">공급상태</th>
									<td class="center">
										<select id="st_supply_status" name="st_supply_status" style="width:142px;">
											<option value="AVAIL"   <%= isUnavail ? "" : "selected" %>>가능</option>
											<option value="UNAVAIL" <%= isUnavail ? "selected" : "" %>>불가</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="center">협력사</th>
									<td class="center" id="viewVendor"><%=d_vendor %></td>
									<th scope="row" class="center">매입단가<br>(VAT별도)</th>
									<td class="center"><input type="text" class="input_type_text" id="st_buy_price" name="st_buy_price" style="width:142px; text-align:right;" value="<%=d_price %>"></td>
								</tr>
								<tr>
									<th scope="row" class="center">최소주문수량</th>
									<td class="center"><%=d_moq %></td>
									<th scope="row" class="center">주문배수수량</th>
									<td class="center"><%=d_ordmul %></td>
								</tr>
								<tr>
									<th scope="row" class="center">거래유형</th>
									<td class="center"><%=d_trade %></td>
									<th scope="row" class="center">배송유형</th>
									<td class="center"><%=d_delivery %></td>
								</tr>
								<tr>
									<th scope="row" class="center">입고TR</th>
									<td class="center">&nbsp;</td>
									<th scope="row" class="center">배송일수</th>
									<td class="center"><input type="text" class="input_type_text" id="st_delivery_lt" name="st_delivery_lt" style="width:142px; text-align:right;" value="<%=d_leadtime %>"></td>
								</tr>
								<tr>
									<th scope="row" class="center">협력사품목코드</th>
									<td class="center"><input type="text" class="input_type_text" id="st_seller_item_no" name="st_seller_item_no" style="width:142px;" value="<%=d_vitemcd %>"></td>
									<th scope="row" class="center">품목구분</th>
									<td class="center">
										<!-- ST 표준품_내자 / SI 표준품_외자 / MK 주문제작품_내자 / MI 주문제작품_외자 -->
										<select id="st_item_make_type" name="st_item_make_type" style="width:142px;">
											<option value="">선택</option>
											<option value="ST" <%= "ST".equals(d_itemtype) ? "selected" : "" %>>표준품_내자</option>
											<option value="SI" <%= "SI".equals(d_itemtype) ? "selected" : "" %>>표준품_외자</option>
											<option value="MK" <%= "MK".equals(d_itemtype) ? "selected" : "" %>>주문제작품_내자</option>
											<option value="MI" <%= "MI".equals(d_itemtype) ? "selected" : "" %>>주문제작품_외자</option>
										</select>
									</td>
								</tr>
								<tr>
									<th scope="row" class="center">과세구분</th>
									<td class="center">
										<select id="st_tax_type" name="st_tax_type" style="width:142px;">
											<option value="">선택</option>
											<option value="11" <%= "11".equals(d_tax) ? "selected" : "" %>>과세</option>
											<option value="12" <%= "12".equals(d_tax) ? "selected" : "" %>>면세</option>
										</select>
									</td>
									<th scope="row" class="center">하도급여부</th>
									<td class="center">&nbsp;</td>
								</tr>
								<tr>
									<th scope="row" class="center">매입단가 시작일</th>
									<td class="center"><input type="text" class="input_type_text" id="st_buy_open_date" name="st_buy_open_date" readOnly style="width:90px; text-align:center;" value="<%=d_pvd_v %>">
										<a href="javascript:kepEraser('st_buy_open_date');"><img src="/resources/images/btn_eraser2.gif" alt="지우기"></a></td>
									<th scope="row" class="center">매입단가 종료일</th>
									<td class="center"><input type="text" class="input_type_text" id="st_buy_close_date" name="st_buy_close_date" readOnly style="width:90px; text-align:center;" value="<%=d_pvd_end_v %>">
										<a href="javascript:kepEraser('st_buy_close_date');"><img src="/resources/images/btn_eraser2.gif" alt="지우기"></a></td>
								</tr>
							</tbody>
						</table>						
						<div class="btnArea mt05" style="text-align:right;">
							<span class="btn_02"><a href="javascript:doAction('change');">변경</a></span>
						</div>
					</div>
				</div>

				<!--고객사 매핑정보-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('2');"><div class="PopTitle_s"><b id="show2"></b> 고객사 매핑정보 <span id="btn2"></span></div></a>
					<div id="div2" class="PopTableBox">
						<table class="cont_t_list06" summary="고객사 매핑정보" style="width:100%;">
							<caption>고객사 매핑정보</caption>
							<colgroup>
								<col width="13%" />
								<col width="17%" />
								<col width="13%" />
								<col width="17%" />
								<col width="12%" />
								<col width="9%" />
								<col width="9%" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" class="center">그룹사코드</th>
									<th scope="col" class="center">그룹사명</th>
									<th scope="col" class="center">고객사코드</th>
									<th scope="col" class="center">고객사명</th>
									<th scope="col" class="center">품목코드</th>
									<th scope="col" class="center">고객사<br>지정여부</th>
									<th scope="col" class="center">피베이스<br>여부</th>
									<th scope="col" class="center">피베이스율</th>
								</tr>
							</thead>
							<tbody>
<%
		if(_mapList.size() == 0){
%>
								<tr class="emptyRow"><td class="center" colspan="8">조회된 매핑 고객사가 없습니다.</td></tr>
<%
		}else{
			for(int i = 0; i < _mapList.size(); i++){
				Map<String,String> _m = _mapList.get(i);
				String m_gcode = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("GROUP_CODE")));
				String m_gname = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("GROUP_NAME")));
				String m_bcode = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("BUYER_CODE")));
				String m_bname = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("BUYER_NAME")));
				String m_item  = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("BUYER_ITEM_NO")));
				String m_csv   = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("CSV_YN")));
				String m_fee   = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("FEE_BASE_YN")));
				String m_rate  = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("FEE_BASE_RATE")));
				String m_cno   = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("CONTRACT_NO")));
				String m_cseq  = HtmlUtils.htmlEscape(CommonUtil.nvl(_m.get("CONTRACT_SEQ")));
%>
								<tr data-mapkey="<%=m_bcode %>|<%=m_cno %>|<%=m_cseq %>">
									<td class="center"><%=m_gcode %></td>
									<td class="left"><%=m_gname %></td>
									<td class="center"><%=m_bcode %></td>
									<td class="left"><%=m_bname %></td>
									<td class="center"><a class="mapLink" href="javascript:doCustCatalog('<%=m_bcode %>','<%=m_item %>','<%=m_cno %>','<%=m_cseq %>');"><%=m_item %></a></td>
									<td class="center"><%=m_csv %></td>
									<td class="center"><%=m_fee %></td>
									<td class="center"><%= "".equals(m_rate) ? "" : m_rate + "%" %></td>
								</tr>
<%
			}
		}
%>
							</tbody>
						</table>
						<p class="ruleNote">
							※ [품목코드]를 클릭하면 해당 고객사의 카탈로그를 조회합니다.<br>
							※ <b>고객사지정여부가 'Y'인 항목은 동일한 협력사인 경우에만</b> 매핑이관이 가능합니다.<br>
							※ [매핑이관]은 이관할 건이 1건일 때 사용합니다(동일 상품코드 내 다른 구매정보코드로 이관).
						</p>
						<div class="btnArea mt05" style="text-align:right;">
							<span class="btn_02"><a href="javascript:doAction('mapMove');">매핑이관</a></span>
						</div>
					</div>
				</div>

				<!--기준가정보-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('3');"><div class="PopTitle_s"><b id="show3"></b> 기준가정보 <span id="btn3"></span></div></a>
					<div id="div3" class="PopTableBox">
						<table class="cont_t_list06" summary="기준가정보" style="width:100%;">
							<caption>기준가정보</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">기준가</th>
									<td class="center"><%=d_base %></td>
									<th scope="row" class="center">기준가 매익율</th>
									<td class="center"><%=d_base_rate %></td>
								</tr>
								<tr>
									<th scope="row" class="center">기준가 유형</th>
									<td class="center"><%=d_base_type %></td>
									<th scope="row" class="center">유형별 매익율</th>
									<td class="center">&nbsp;</td>
								</tr>
								<tr>
									<th scope="row" class="center">변경여부</th>
									<td class="center"><%=d_base_chg %></td>
									<th scope="row" class="center">변경이력</th>
									<td class="center"><span class="btn_02"><a href="javascript:doAction('basePriceHistory');">보기</a></span></td>
								</tr>
							</tbody>
						</table>
						<p class="ruleNote">※ 기준가 매익율 = (기준가 - 매입단가) ÷ 기준가 × 100 · 기준가는 <b>상품정보코드 단위</b>로 관리됩니다.</p>
					</div>
				</div>

				<!--구매정보이력-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('4');"><div class="PopTitle_s"><b id="show4"></b> 구매정보이력 <span id="btn4"></span></div></a>
					<div id="div4" class="PopTableBox">
						<table class="cont_t_list06" summary="구매정보이력" style="width:100%;">
							<caption>구매정보이력</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">최초등록일</th>
									<td class="center"><%=d_buy_add %></td>
									<th scope="row" class="center">최종변경일</th>
									<td class="center" id="viewBuyChgDate"><%=d_buy_chg %></td>
								</tr>
								<tr>
									<th scope="row" class="center">등록담당자</th>
									<td class="center"><%=d_buy_addu %></td>
									<th scope="row" class="center">변경담당자</th>
									<td class="center" id="viewBuyChgUser"><%=d_buy_chgu %></td>
								</tr>
								<tr>
									<th scope="row" class="center">등록견적번호<br>(Key)</th>
									<td class="left"><%=d_buy_quot %></td>
									<th scope="row" class="center">변경이력</th>
									<td class="center"><span class="btn_02"><a href="javascript:doAction('buyHistory');">보기</a></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!--============================ 탭2 : 기타정보 ============================-->
			<div id="tabBody2" style="display:none;">

				<!--안전인증정보-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('5');"><div class="PopTitle_s"><b id="show5"></b> 안전인증정보 <span id="btn5"></span></div></a>
					<div id="div5" class="PopTableBox">
						<table class="cont_t_list06" summary="안전인증정보" style="width:100%;">
							<caption>안전인증정보</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">안전인증여부</th>
									<td class="center"><%=d_safe_st %></td>
									<th scope="row" class="center">안전인증구분</th>
									<td class="center"><%=d_safe_tp %></td>
								</tr>
								<tr>
									<th scope="row" class="center">안전인증번호</th>
									<td class="left" colspan="3"><%=d_safe_no %></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<!--화학물질정보-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('6');"><div class="PopTitle_s"><b id="show6"></b> 화학물질정보 <span id="btn6"></span></div></a>
					<div id="div6" class="PopTableBox">
						<table class="cont_t_list06" summary="화학물질정보" style="width:100%;">
							<caption>화학물질정보</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">화학물질정보 No.</th>
									<td class="center"><%=d_chem_no %></td>
									<th scope="row" class="center">유해화학물질</th>
									<td class="center"><%=d_harmful %></td>
								</tr>
								<tr>
									<th scope="row" class="center">보관조건</th>
									<td class="center">&nbsp;</td>
									<th scope="row" class="center">온도</th>
									<td class="center">&nbsp;</td>
								</tr>
							</tbody>
						</table>						
					</div>
				</div>

				<!--상품 이미지 정보-->
				<div class="PopNewBox">
				<a href="javascript:divShowHide('7');"><div class="PopTitle_s"><b id="show7"></b> 상품이미지 <span id="btn7"></span></div></a>
				<div id="div7" class="PopTableBox">
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
									
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

				<!--상품정보이력-->
				<div class="PopNewBox">
					<a href="javascript:divShowHide('8');"><div class="PopTitle_s"><b id="show8"></b> 상품정보이력 <span id="btn8"></span></div></a>
					<div id="div8" class="PopTableBox">
						<table class="cont_t_list06" summary="상품정보이력" style="width:100%;">
							<caption>상품정보이력</caption>
							<colgroup>
								<col width="16%" />
								<col width="34%" />
								<col width="16%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="center">최초등록일</th>
									<td class="center"><%=d_item_add %></td>
									<th scope="row" class="center">최종변경일</th>
									<td class="center"><%=d_item_chg %></td>
								</tr>
								<tr>
									<th scope="row" class="center">등록담당자</th>
									<td class="center"><%=d_item_addu %></td>
									<th scope="row" class="center">변경담당자</th>
									<td class="center"><%=d_item_chgu %></td>
								</tr>
								<tr>
									<th scope="row" class="center">등록견적번호<br>(Key)</th>
									<td class="left"><%=d_item_quot %></td>
									<th scope="row" class="center">변경이력</th>
									<td class="center"><span class="btn_02"><a href="javascript:doAction('history');">보기</a></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<!--하단 버튼-->
			<div class="btnArea mt05" style="text-align:center; padding:10px 0;">
				<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
