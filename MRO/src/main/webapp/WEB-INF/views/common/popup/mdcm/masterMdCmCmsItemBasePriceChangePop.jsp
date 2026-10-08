<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 상세 팝업 > 기준가 [변경]
* 화면 : (팝업) 기준가 변경
* 기능 : 기준가·기준가유형 변경
*        - [기존] 기준가·유형 / [변경] 기준가·유형·변경사유
*        - 인상 : 즉시 시스템 반영
*        - 인하 : 품의 상신 + 결재 팝업(DOC_TYPE=BP)
* 담당자 : 홍준우
* 착수일 : 2026-09-04
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String st_catlg_id = CommonUtil.nvl((String) request.getParameter("st_catlg_id"),"");

Map<String,String> _data = (Map<String,String>) request.getAttribute("data");
if(_data == null){ _data = new HashMap<String,String>(); }

String d_catlg     = CommonUtil.nvl(_data.get("CMS_CATLG_ID"));
if("".equals(d_catlg)){ d_catlg = st_catlg_id; }
String d_name      = CommonUtil.nvl(_data.get("DESCRIPTION_LOC"));
String d_price     = CommonUtil.nvl(_data.get("BASE_PRICE"));       // 숫자문자열 (콤마 없음)
String d_price_vw  = CommonUtil.nvl(_data.get("BASE_PRICE_VIEW"));  // 콤마 표기
String d_type      = CommonUtil.nvl(_data.get("BASE_PRICE_TYPE"));
String d_type_nm   = CommonUtil.nvl(_data.get("BASE_PRICE_TYPE_NM"));
%>
<script type="text/javascript">
var OLD_PRICE = "<%=d_price%>";		// 기존 기준가(숫자문자열). 인상/인하 판정 기준

//콤마 제거한 숫자문자열
function numOnly(v){ return String(v).replace(/[^0-9.\-]/g, ""); }

//콤마 표기
function comma(v){
	var s = numOnly(v);
	if(s == ""){ return ""; }
	var p = s.split(".");
	p[0] = p[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return p.join(".");
}

/* 변경 기준가 입력 시 : 콤마 표기 + 결재 안내 문구 노출
 * 인하 -> 품의 상신 / 인상 -> 즉시 반영. 어느 쪽인지가 [적용] 동작을 가른다.
 * 안내 문구는 결재를 타는 인하에만 띄운다(2026-09-15 사용자 결정). */
function onPriceInput(){
	var el = document.getElementById("st_new_price");
	el.value = comma(el.value);
	showGuide();
}

function curUpDown(){
	var oldP = parseFloat(numOnly(OLD_PRICE));
	var newP = parseFloat(numOnly(document.getElementById("st_new_price").value));
	if(isNaN(oldP) || isNaN(newP)){ return ""; }
	if(newP < oldP){ return "DOWN"; }
	if(newP > oldP){ return "UP"; }
	return "SAME";
}

function showGuide(){
	var dir = curUpDown();
	var msg = "";
	if(dir == "DOWN"){ msg = "※ 기준가 인하 건으로 품의가 상신됩니다."; }
	$("#guideMsg").text(msg);
}

//기능함수
function doAction(str){
	switch(str){
		case "apply": // 적용
			if(!checkSubmit()){ return; }
			doSave();
			break;
		case "close":
			self.close();
			break;
	}
}

function checkSubmit(){
	var newP = numOnly($("#st_new_price").val());
	var typeChanged = $("#st_new_type").val() != $("#st_old_type").val();
	if(newP == "" && !(typeChanged && numOnly(OLD_PRICE) != "")){
		alert("변경할 기준가를 입력해 주세요.");
		return false;
	}
	if(newP != "" && parseFloat(newP) <= 0){
		alert("기준가는 0보다 커야 합니다.");
		return false;
	}
	if($("#st_new_type").val() == ""){
		alert("변경 기준가 유형을 선택해 주세요.");
		return false;
	}
	var dir = (newP == "") ? "SAME" : curUpDown();
	if(dir == "SAME" && !typeChanged){
		alert("변경된 내용이 없습니다.");
		return false;
	}
	/* ⚠ 변경사유는 필수로 걸지 않는다 - 사유 List(ICOMCOD1 M184)가 아직 미적재라
	 *   필수로 막으면 화면 자체를 쓸 수 없다. List 를 받으면 이 주석을 지우고 아래 검사를 살린다.
	 * if($("#st_reason_code").val() == ""){ alert("변경사유를 선택해 주세요."); return false; } */

	var msg = (dir == "DOWN") ? "기준가 인하 건으로 품의가 상신됩니다.\n\n적용하시겠습니까?"
			: (dir == "SAME") ? "기준가유형만 변경되어 즉시 시스템에 반영됩니다.\n\n적용하시겠습니까?"
			: "기준가 인상 건으로 즉시 시스템에 반영됩니다.\n\n적용하시겠습니까?";
	return confirm(msg);
}

function doSave(){
	$("#st_new_price_raw").val(numOnly($("#st_new_price").val()) || numOnly(OLD_PRICE));
	$("#st_new_type_nm").val($("#st_new_type option:selected").text());

	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsItemBasePrice.do"
		,data		: $("#contentForm").serialize()
		,dataType	: "json"
		,success	: function(res){
			loader_obj("N");

			// 서버가 실패하면 ExceptionController 가 HTTP 200 + {Message:"시스템 처리 중…"} 로 응답한다.
			// 성공 응답에만 Result.Code 가 있으므로 그것으로 가른다 —
			// 이 검사가 없으면 에러문이 그대로 PM_NO 로 쓰여 결재 KEY_1 에 박힌다(ORA-12899).
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("기준가 변경 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}

			var pm_no = (res && res.Message) ? res.Message : "";

			if(pm_no != ""){
				openApproval(pm_no);
			}else{
				alert("기준가가 반영되었습니다.");
				reflectToOpener();
				self.close();
			}
		}
		,error		: function(){
			loader_obj("N");
			alert("기준가 변경 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 결재 팝업 호출. S/R 신규요청(masterMdSrSrNewReqList)의 품의상신과 같은 계약이다 —
 * DOC_TYPE 은 ICOMCOD1 TYPE='APPR' 의 코드, BIZ_DOCU_NO 는 방금 채번한 PM_NO,
 * PARAM1 = 회사코드, PARAM2 = 상신자(서버가 KEY_2/KEY_3 로 옮긴다). */
function openApproval(pm_no){
	var t = "기준가 인하 품의 - " + $.trim($("#st_catlg_id").val());
	openSearchPopup("/common/approval/buyerCommonApprovalPop.do"
		, '?DOC_TYPE=BP&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO=' + pm_no
		+ '&PARAM1=' + $.trim($("#st_com_code").val())
		+ '&PARAM2=' + $.trim($("#st_login_id").val())
		+ '&st_title=' + t
		+ '&st_cont='
		, "1000,500,no");
}

/* 결재 팝업이 상신을 마치면 이 함수를 부른다(공통 계약). */
function kepApprovalReturn(flag, docu_no){
	alert("품의가 상신되었습니다.");
	reloadOpener();
	self.close();
}

/* 즉시반영(인상) 후 상세 팝업에 바뀐 값을 꽂는다 — 상세 팝업은 조회 재호출 경로가 없어
 * 리로드가 안 되고, 그래서 저장이 안 된 것처럼 보였다(2026-09-15).
 * ⚠ 인하는 부르지 않는다. 품의 승인 전까지 CMSCATLG 가 안 바뀌므로 화면만 바뀌면 거짓이 된다. */
function reflectToOpener(){
	try {
		if(opener && !opener.closed && typeof opener.applyBasePriceChanged == "function"){
			opener.applyBasePriceChanged(comma($("#st_new_price_raw").val())
			                            ,$.trim($("#st_new_type").val()));
			return;
		}
	} catch(e) { }
	reloadOpener();
}

function reloadOpener(){
	try {
		if(opener && !opener.closed && typeof opener.doAction == "function"){
			opener.doAction("reload");
		}
	} catch(e) { }
}

function kep_onload_view(){
	showGuide();
}
</script>

<style>
.PopGuide{ display:block; margin:8px 0; color:#c00; font-size:13px; font-weight:bold; min-height:18px; }
</style>

<body onLoad="kep_onload_view()">
	<form name="contentForm" id="contentForm" method="post">
		<input type="hidden" id="st_catlg_id"     name="st_catlg_id"     value="<%=d_catlg%>">
		<input type="hidden" id="st_old_price"    name="st_old_price"    value="<%=d_price%>">
		<input type="hidden" id="st_old_type"     name="st_old_type"     value="<%=d_type%>">
		<input type="hidden" id="st_new_price_raw" name="st_new_price"   value="">
		<input type="hidden" id="st_new_type_nm"  name="st_new_type_nm"  value="">
		<input type="hidden" id="st_gubun"        name="st_gubun"        value="BP">
		<input type="hidden" id="st_subject"      name="st_subject"      value="기준가 인하 품의 - <%=d_catlg%>">
		<input type="hidden" id="st_remark"       name="st_remark"       value="">
		<input type="hidden" id="st_com_code"     name="st_com_code_view" value="<%=_sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getComCode())%>">
		<input type="hidden" id="st_login_id"     name="st_login_id"     value="<%=_sessionInfo == null ? "" : CommonUtil.nvl(_sessionInfo.getUserId())%>">

	<div id="popWrapper" style="width:560px;">
		<div id="popHeader">
			<h1 class="title">기준가 변경</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer" style="background-color:#f5f5f5">

			<span class="PopGuide" style="color:#444; font-weight:normal;">
				※ 변경 내용 확인 후 사유를 입력해주세요.
			</span>

			<div style="background-color:#fff; border-radius:5px; padding:12px;">

				<!--기존-->
				<table class="cont_t_list06" summary="기존 기준가" style="width:100%;">
					<caption>기존</caption>
					<colgroup>
						<col width="30%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="center">기존 기준가</th>
							<td class="right"><%=d_price_vw%></td>
						</tr>
						<tr>
							<th scope="row" class="center">기존 기준가유형</th>
							<td class="left"><%=d_type_nm%></td>
						</tr>
					</tbody>
				</table>

				<br>

				<!--변경-->
				<table class="cont_t_list06" summary="변경 기준가" style="width:100%;">
					<caption>변경</caption>
					<colgroup>
						<col width="30%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="center">변경 기준가</th>
							<td class="left">
								<input type="text" id="st_new_price" style="width:60%; text-align:right;"
								       maxlength="15" onkeyup="onPriceInput();" onblur="onPriceInput();">
							</td>
						</tr>
						<tr>
							<th scope="row" class="center">변경 기준가유형</th>
							<td class="left">
								<!-- 기준가유형 : ICOMCOD1 M183, FLAG='Y' -->
								<select id="st_new_type" name="st_new_type" style="width:80%;">
									<%=CommonUtil.getCodeComboQueryIdList("master.mdcm.getCmsItemBasePriceTypeCodeList", "SEL", d_type) %>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row" class="center">변경사유</th>
							<td class="left">
								<!-- 기준가 변경사유 : ICOMCOD1 M184.
								     ⚠ 사유 List 가 "구매팀 취합 후 전달 예정"이라 지금은 0건 -> [선택] 만 뜬다.
								        코드행만 적재하면 이 셀렉트는 그대로 채워진다(JSP 수정 불필요). -->
								<select id="st_reason_code" name="st_reason_code" style="width:80%;">
									<%=CommonUtil.getCodeComboQueryIdList("master.mdcm.getCmsItemBasePriceReasonCodeList", "SEL", "") %>
								</select>
							</td>
						</tr>
					</tbody>
				</table>

				<span class="PopGuide" id="guideMsg"></span>
			</div>

			<!--하단 버튼-->
			<div class="btnArea mt05" style="text-align:center; padding:10px 0;">
				<span class="btn_02 mr04"><a href="javascript:doAction('apply');">적용</a></span>
				<span class="btn_02"><a href="javascript:doAction('close');">닫기</a></span>
			</div>
			<br>
		</div>
	</div>
	</form>
</body>
</html>
