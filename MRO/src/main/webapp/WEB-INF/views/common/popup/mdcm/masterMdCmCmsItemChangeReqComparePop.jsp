<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 수정요청 > 요청번호 클릭
* 화면 : (팝업) 상품정보 수정요청 비교
* 기능 : 좌=기존 / 우=변경 2단 대조. 변경된 항목만 빨간 글자.
*        - 좌·우 두 벌은 **컨트롤러가 만들어 넘긴다**(before/after) — 여기서는 그리기만 한다.
*          바탕 = CMSCATLG 현재 상세(카테고리·상세분류·일회성구분·구매담당자처럼 변경 대상이 아닌 값)
*          + 요청 시점 스냅샷 + 변경항목의 OLD/NEW_DATA
*        - 속성표 : 좌는 현재 속성값, 우는 규격 변경요청이 있을 때 규격 문자열을 되쪼개 대응시킨다
*        - [표준화기준] 파일은 여전히 미수령
*        - [이전]/[다음] 은 목록에서 다중 체크 후 열었을 때만 나온다(opener.mdcmReqNoList)
* 담당자 : 홍준우
* 착수일 : 2026-09-04
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
	Map<String,String> _header = (Map<String,String>) request.getAttribute("header");
	if(_header == null){ _header = new HashMap<String,String>(); }

	Map<String,String> _before = (Map<String,String>) request.getAttribute("before");
	if(_before == null){ _before = new HashMap<String,String>(); }

	Map<String,String> _after = (Map<String,String>) request.getAttribute("after");
	if(_after == null){ _after = new HashMap<String,String>(); }

	List<Map<String,String>> _attrList = (List<Map<String,String>>) request.getAttribute("attrList");
	if(_attrList == null){ _attrList = new ArrayList<Map<String,String>>(); }

	List<String> _changed = (List<String>) request.getAttribute("changed");
	if(_changed == null){ _changed = new ArrayList<String>(); }

	String d_req_no     = CommonUtil.nvl(_header.get("REQ_NO"));
	String d_catlg      = CommonUtil.nvl(_header.get("CMS_CATLG_ID"));
	String d_req_user   = CommonUtil.nvl(_header.get("REQ_USER_NAME"));
	String d_req_dt     = CommonUtil.nvl(_header.get("REQ_DATETIME"));
	String d_status_nm  = CommonUtil.nvl(_header.get("REQ_STATUS_NM"));
	String d_status_cd  = CommonUtil.nvl(_header.get("REQ_STATUS"));
	String d_reject     = CommonUtil.nvl(_header.get("REJECT_REASON"));

	// 이미 처리된 건이면 승인·반려 버튼을 내지 않는다(서버도 REQ 상태만 받는다)
	boolean d_open = "REQ".equals(d_status_cd);

	/* 규격이 변경항목에 있으면, 변경된 규격 문자열을 되쪼개 속성값에 대응시킨다.
	   규격 조립 규칙이 "속성값을 '; ' 로 이어 붙인다"라 그 역이다.
	   ⚠ 조각 수와 속성 수가 어긋나면 대응이 밀리므로 그때는 덮지 않는다 — 좌·우를 같게 둔다. */
	String d_spec_after = CommonUtil.nvl(_after.get("SPECIFICATION"));
	List<String> _specParts = new ArrayList<String>();
	if(_changed.contains("SPECIFICATION") && !"".equals(d_spec_after)){
		String[] _raw = d_spec_after.split(";");
		for(int i = 0; i < _raw.length; i++){
			String _p = _raw[i] == null ? "" : _raw[i].trim();
			_specParts.add(_p);
		}
		// 끝에 붙는 빈 조각(규격 문자열 끝의 ';')은 버린다
		while(_specParts.size() > 0 && "".equals(_specParts.get(_specParts.size()-1))){
			_specParts.remove(_specParts.size()-1);
		}
	}
	// 값이 있는 속성만 규격에 들어가므로, 그 개수로 대응 가능 여부를 판정한다
	int _filledAttr = 0;
	for(int i = 0; i < _attrList.size(); i++){
		if(!"".equals(CommonUtil.nvl(_attrList.get(i).get("ATTR_VAL")))){ _filledAttr++; }
	}
	boolean _specMappable = (_specParts.size() > 0 && _specParts.size() == _filledAttr);

	// 담당자·요청자 이름은 마스킹해 표기한다(상세팝업과 같은 규약)
	String d_person_b = CommonUtil.nvl(_before.get("KEP_USER_NAME"));
	String d_person_a = CommonUtil.nvl(_after.get("KEP_USER_NAME"));
	try { if(!"".equals(d_person_b)){ d_person_b = CommonUtil.nameMasking(d_person_b); } } catch(Exception e){ }
	try { if(!"".equals(d_person_a)){ d_person_a = CommonUtil.nameMasking(d_person_a); } } catch(Exception e){ }
%>
<script type="text/javascript">
var REQ_NO   = "<%=d_req_no%>";
var IS_OPEN  = "<%=d_open ? "Y" : "N"%>";

/* 목록에서 다중 체크 후 열었으면 그 요청번호 배열이 opener 에 있다.
 * ⚠ URL 로 넘기지 않는다 — 건수가 많으면 URL 이 잘린다. */
var reqNoList = [];
var curIdx    = -1;

function kep_onload_view(){
	try { reqNoList = opener.mdcmReqNoList || []; } catch (e) { reqNoList = []; }

	for (var i = 0; i < reqNoList.length; i++) {
		if (("" + reqNoList[i]) == REQ_NO) { curIdx = i; break; }
	}

	// 여러 건을 열람 중일 때만 이전/다음을 낸다(설계 6p [4])
	if (reqNoList.length > 1 && curIdx >= 0) {
		$("#navArea").show();
		$("#navPos").text((curIdx + 1) + " / " + reqNoList.length);
		if (curIdx <= 0)                     { $("#btnPrev").hide(); }
		if (curIdx >= reqNoList.length - 1)  { $("#btnNext").hide(); }
	}
}

// 같은 팝업을 다른 요청번호로 다시 연다(창을 새로 띄우지 않는다)
function moveTo(step){
	var idx = curIdx + step;
	if (idx < 0 || idx >= reqNoList.length) { return; }
	location.href = "/mdcm/showMasterMdCmCmsItemChangeReqComparePop.do?st_req_no=" + reqNoList[idx];
}

function doApprove(){
	if (!confirm("이 요청을 승인합니다. 승인 시 상품정보에 즉시 반영됩니다. 진행할까요?")) { return; }

	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/saveMasterMdCmCmsItemChangeReqApprove.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		traditional: true,
		data: { st_req_no: [REQ_NO] },
		success: function( response ) {
			alert(response.Message);
			refreshOpener();
			if (response.Result && response.Result.Code == 1) { self.close(); }
		},
		error: function( response ) {
			alert("승인 처리에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
}

// 반려사유 팝업을 띄운다. 그 팝업은 opener(=이 창)의 submitReject 를 부른다.
function doReject(){
	openSearchPopup("/mdcm/showMasterMdCmCmsItemChangeReqRejectPop.do", "?st_req_cnt=1", "520,300,no");
}

/* 반려사유 팝업의 [확인] 콜백. 목록 화면에도 같은 이름의 함수가 있다 —
 * 반려 팝업은 자기 opener 만 부르므로 어디서 열렸든 맞는 쪽이 호출된다. */
function submitReject(reason){
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/saveMasterMdCmCmsItemChangeReqReject.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		traditional: true,
		data: { st_req_no: [REQ_NO], st_reject_reason: reason },
		success: function( response ) {
			alert(response.Message);
			refreshOpener();
			if (response.Result && response.Result.Code == 1) { self.close(); }
		},
		error: function( response ) {
			alert("반려 처리에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
}

function refreshOpener(){
	try { opener.refreshAfterProc(); } catch (e) { }
}

// 표준화기준 파일은 아직 받지 못했다(설계 7p [5])
function doStandardGuide(){
	alert("표준화 가이드 파일은 아직 전달받지 못했습니다.");
}
</script>

<style>
.cmpWrap{ width:100%; }
.cmpWrap > table{ width:100%; table-layout:fixed; border-collapse:collapse; }
.cmpWrap > table > tbody > tr > td{ vertical-align:top; padding:0 6px; }
.paneTitle{ display:block; font-size:13px; font-weight:bold; color:#1f3864; margin:4px 0 6px; }
.chg{ color:#c0392b; font-weight:bold; }
.reqMark{ color:#c0392b; }
.infoBar{ display:block; font-size:12px; color:#444; margin:6px 2px 10px; }
.infoBar strong{ color:#1f3864; }
.rejBox{ display:block; font-size:12px; color:#c0392b; margin:0 2px 8px; }
.navPos{ display:inline-block; font-size:12px; color:#444; padding:0 8px; line-height:24px; vertical-align:middle; }
/* 카테고리/상세분류는 값이 3개라 중첩표로 넣는다 — 바깥 표가 4열(라벨|값|라벨|값) 구조라
   td 를 직접 늘리면 표 전체가 깨진다 */
table.categInner{ width:100%; border:0; border-collapse:collapse; }
table.categInner td{ border:0; padding:0 4px 0 0; }
</style>

<body onload="kep_onload_view();">
	<div id="popWrapper" style="width:1460px;">
		<div id="popHeader">
			<h1 class="title">상품정보 수정요청</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

			<span class="infoBar">
				요청번호 <strong><%=d_req_no %></strong> &nbsp;|&nbsp;
				상품정보코드 <strong><%=d_catlg %></strong> &nbsp;|&nbsp;
				요청자 <%=d_req_user %> &nbsp;|&nbsp;
				요청일시 <%=d_req_dt %> &nbsp;|&nbsp;
				진행상태 <strong><%=d_status_nm %></strong>
			</span>
<% if(!"".equals(d_reject)){ %>
			<span class="rejBox">반려사유 : <%=d_reject %></span>
<% } %>

			<div class="cmpWrap">
			<table>
				<tbody>
					<tr>
						<!-- ================= 좌 : 기존 ================= -->
						<td width="50%">
							<span class="paneTitle">기존</span>
							<!-- 좌·우는 같은 마크업을 두 번 쓴다. 반복문으로 돌리면 스크립틀릿이
							     마크업을 가로질러 읽기 어려워지므로 일부러 펼쳐 뒀다 —
							     ⚠ 한쪽 행을 고치면 반대쪽 같은 행도 함께 고칠 것 -->
							<table class="cont_t_list02" summary="상품정보" style="width:100%">
								<caption>상품정보(기존)</caption>
								<colgroup>
									<col width="18%" /><col width="32%" /><col width="18%" /><col width="32%" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="center">상품정보코드</th>
										<td class="center"><%=CommonUtil.nvl(_before.get("CMS_CATLG_ID")) %></td>
										<th scope="row" class="center">상품상태</th>
										<td class="center<%=_changed.contains("STATUS") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("STATUS_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">카테고리/<br>상세분류</th>
										<td class="left" colspan="3">
											<table class="categInner">
												<tr>
													<td width="22%"><%=CommonUtil.nvl(_before.get("SG_NAME")) %></td>
													<td width="58%"><%=CommonUtil.nvl(_before.get("CMS_CATEG_PATH")) %></td>
													<td width="20%"><%=CommonUtil.nvl(_before.get("CMS_CATEG_ID")) %></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<th scope="row" class="center">품목명</th>
										<td class="left<%=_changed.contains("DESCRIPTION_LOC") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("DESCRIPTION_LOC")) %></td>
										<th scope="row" class="center">모델번호</th>
										<td class="center<%=_changed.contains("MODEL_INFO") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("MODEL_INFO")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">제조사</th>
										<td class="left<%=_changed.contains("MAKER_CODE") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("MAKER_NAME")) %></td>
										<th scope="row" class="center">원산지</th>
										<td class="center<%=_changed.contains("ORIGIN_CODE") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("ORIGIN_CODE_NAME")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">단위</th>
										<td class="center<%=_changed.contains("ORDER_MEASURE") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("ORDER_MEASURE")) %></td>
										<th scope="row" class="center">상품구분</th>
										<td class="center<%=_changed.contains("ITEM_GUBUN") ? " chg" : "" %>"><%=CommonUtil.nvl(_before.get("ITEM_GUBUN_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">일회성구분</th>
										<td class="center"><%=CommonUtil.nvl(_before.get("ONETIME_NM")) %></td>
										<th scope="row" class="center">구매담당자</th>
										<td class="center"><%=d_person_b %></td>
									</tr>
									<tr>
										<th scope="row" class="center">TR취급가능<br>여부</th>
										<td class="center<%=_changed.contains("TR_HANDLE_TYPE") ? " chg" : "" %>" colspan="3"><%=CommonUtil.nvl(_before.get("TR_HANDLE_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">규격</th>
										<td class="left<%=_changed.contains("SPECIFICATION") ? " chg" : "" %>" colspan="3"><%=CommonUtil.nvl(_before.get("SPECIFICATION")) %></td>
									</tr>
								</tbody>
							</table>

							<br>
							<table class="cont_t_list02" summary="규격 상세 속성" style="width:100%">
								<caption>규격 상세 속성(기존)</caption>
								<colgroup>
									<col width="36%" /><col width="64%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">속성명</th>
										<th scope="col">속성값</th>
									</tr>
								</thead>
								<tbody>
<%
	for(int i = 0; i < _attrList.size(); i++){
		Map<String,String> _attr = _attrList.get(i);
		String a_nm   = CommonUtil.nvl(_attr.get("ATTR_NM"));
		String a_val  = CommonUtil.nvl(_attr.get("ATTR_VAL"));
		String a_ess  = CommonUtil.nvl(_attr.get("ESS_FLAG"));
		String a_unit = CommonUtil.nvl(_attr.get("ATTR_UNIT"));
		if("".equals(a_nm)){ continue; }
%>
									<tr>
										<th scope="row" class="center"><%=a_nm %><%= "Y".equals(a_ess) ? " <span class=\"reqMark\">*</span>" : "" %></th>
										<td class="center"><%=a_val %><%=a_unit %></td>
									</tr>
<%
	}
	if(_attrList.size() == 0){
%>
									<tr><td class="center" colspan="2">등록된 속성이 없습니다.</td></tr>
<%
	}
%>
								</tbody>
							</table>
						</td>

						<!-- ================= 우 : 변경 ================= -->
						<td width="50%">
							<span class="paneTitle">변경</span>
							<span class="fr" style="margin:0 0 4px;">
								<span class="btn_05"><a href="javascript:doStandardGuide();">표준화기준</a></span>
							</span>
							<table class="cont_t_list02" summary="상품정보" style="width:100%">
								<caption>상품정보(변경)</caption>
								<colgroup>
									<col width="18%" /><col width="32%" /><col width="18%" /><col width="32%" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="center">상품정보코드</th>
										<td class="center"><%=CommonUtil.nvl(_after.get("CMS_CATLG_ID")) %></td>
										<th scope="row" class="center">상품상태</th>
										<td class="center<%=_changed.contains("STATUS") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("STATUS_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">카테고리/<br>상세분류</th>
										<td class="left" colspan="3">
											<table class="categInner">
												<tr>
													<td width="22%"><%=CommonUtil.nvl(_after.get("SG_NAME")) %></td>
													<td width="58%"><%=CommonUtil.nvl(_after.get("CMS_CATEG_PATH")) %></td>
													<td width="20%"><%=CommonUtil.nvl(_after.get("CMS_CATEG_ID")) %></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<th scope="row" class="center">품목명</th>
										<td class="left<%=_changed.contains("DESCRIPTION_LOC") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("DESCRIPTION_LOC")) %></td>
										<th scope="row" class="center">모델번호</th>
										<td class="center<%=_changed.contains("MODEL_INFO") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("MODEL_INFO")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">제조사</th>
										<td class="left<%=_changed.contains("MAKER_CODE") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("MAKER_NAME")) %></td>
										<th scope="row" class="center">원산지</th>
										<td class="center<%=_changed.contains("ORIGIN_CODE") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("ORIGIN_CODE_NAME")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">단위</th>
										<td class="center<%=_changed.contains("ORDER_MEASURE") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("ORDER_MEASURE")) %></td>
										<th scope="row" class="center">상품구분</th>
										<td class="center<%=_changed.contains("ITEM_GUBUN") ? " chg" : "" %>"><%=CommonUtil.nvl(_after.get("ITEM_GUBUN_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">일회성구분</th>
										<td class="center"><%=CommonUtil.nvl(_after.get("ONETIME_NM")) %></td>
										<th scope="row" class="center">구매담당자</th>
										<td class="center"><%=d_person_a %></td>
									</tr>
									<tr>
										<th scope="row" class="center">TR취급가능<br>여부</th>
										<td class="center<%=_changed.contains("TR_HANDLE_TYPE") ? " chg" : "" %>" colspan="3"><%=CommonUtil.nvl(_after.get("TR_HANDLE_NM")) %></td>
									</tr>
									<tr>
										<th scope="row" class="center">규격</th>
										<td class="left<%=_changed.contains("SPECIFICATION") ? " chg" : "" %>" colspan="3"><%=CommonUtil.nvl(_after.get("SPECIFICATION")) %></td>
									</tr>
								</tbody>
							</table>

							<br>
							<table class="cont_t_list02" summary="규격 상세 속성" style="width:100%">
								<caption>규격 상세 속성(변경)</caption>
								<colgroup>
									<col width="36%" /><col width="64%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">속성명</th>
										<th scope="col">속성값</th>
									</tr>
								</thead>
								<tbody>
<%
	// 규격 변경요청이 있고 조각 수가 맞을 때만 속성값을 갈아 끼운다.
	// 값이 있는 속성만 규격에 들어가므로, 값이 있는 것들만 순서대로 대응시킨다.
	int _pi = 0;
	for(int i = 0; i < _attrList.size(); i++){
		Map<String,String> _attr = _attrList.get(i);
		String a_nm   = CommonUtil.nvl(_attr.get("ATTR_NM"));
		String a_val  = CommonUtil.nvl(_attr.get("ATTR_VAL"));
		String a_ess  = CommonUtil.nvl(_attr.get("ESS_FLAG"));
		String a_unit = CommonUtil.nvl(_attr.get("ATTR_UNIT"));
		if("".equals(a_nm)){ continue; }

		String a_new = a_val;
		boolean a_chg = false;
		if(_specMappable && !"".equals(a_val)){
			if(_pi < _specParts.size()){
				a_new = _specParts.get(_pi);
				a_chg = !a_new.equals(a_val);
			}
			_pi++;
		}
%>
									<tr>
										<th scope="row" class="center"><%=a_nm %><%= "Y".equals(a_ess) ? " <span class=\"reqMark\">*</span>" : "" %></th>
										<td class="center<%=a_chg ? " chg" : "" %>"><%=a_new %><%=a_unit %></td>
									</tr>
<%
	}
	if(_attrList.size() == 0){
%>
									<tr><td class="center" colspan="2">등록된 속성이 없습니다.</td></tr>
<%
	}
%>
								</tbody>
							</table>
<% if(_changed.contains("SPECIFICATION") && !_specMappable){ %>
							<span class="rejBox">규격 조각 수가 속성 수와 맞지 않아 속성값에는 반영해 표시하지 못했습니다. 위 [규격] 행을 확인해 주세요.</span>
<% } %>
						</td>
					</tr>
				</tbody>
			</table>
			</div>

			<div class="btnArea mt05" style="padding:12px 0 6px;">
				<span class="fl" id="navArea" style="display:none;">
					<span class="btn_05 mr04" id="btnPrev"><a href="javascript:moveTo(-1);">이전</a></span>
					<span class="navPos" id="navPos"></span>
					<span class="btn_05" id="btnNext"><a href="javascript:moveTo(1);">다음</a></span>
				</span>
				<span class="fr">
<% if(d_open){ %>
					<span class="btn_02 mr04"><a href="javascript:doApprove();">승인</a></span>
					<span class="btn_02 mr04"><a href="javascript:doReject();">반려</a></span>
<% } %>
					<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
				</span>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
