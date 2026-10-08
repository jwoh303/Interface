<%--
**********************************************
* 메뉴 : 표준DB관리 > 상품정보 조회 및 관리
* 화면 : 구매담당자(본사 사용자) 조회
* 기능 : ICOMLUSR COM_CODE='KRKORE0001' 중 구매부서(ICOMCOD1 TYPE='SOURDEPT') 소속만 조회한다.
*        단 구매본부(130)·구매기획팀(138)은 제외 — 팀명 드롭다운(commonPopup.masterMdCmCmsItemMngrDeptCombo)과 동일 조건.
*        팀명 드롭다운 + 이름(2글자 이상) 검색. 단일 선택이라 체크박스 없이 이름/사번 클릭으로 반환한다.
*        반환 키는 USER_ID (목록 조회조건이 ICOMCOD1 C013.TEXT1 과 대조하므로 사번이 아니라 USER_ID다).
*        표시되는 이름은 CommonUtil.nameMasking 으로 가운데를 가린다(반환 표시값도 동일).
* 프로그램 ID :
* 담당자 :
* 착수일 :
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
<%@ include file="../../common/include/head_pop.jspf"  %>
<style type="text/css">
/* 조회조건 표(cont_t_list01)는 input 규칙만 있고 select 규칙이 없어 높이·폰트가 어긋난다 */
#popContainer select{ font-family:"돋움", Dotum, Verdana; font-size:12px; height:22px; vertical-align:middle;
                      -moz-box-sizing:border-box; box-sizing:border-box; }
</style>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String kep_dept      = CommonUtil.nvl((String) request.getParameter("kep_dept"),"");       // (조회조건) 팀명
String kep_user_name = CommonUtil.nvl((String) request.getParameter("kep_user_name"),"");  // (조회조건) 이름
%>
<script type="text/javascript">
function setQuery()
{
	var _dept = $("#kep_dept").val();
	var _name = $.trim($("#kep_user_name").val());

	if (_dept == "" && _name == ""){
		alert("팀명을 선택하거나 이름을 입력하세요.");
		return;
	}
	if (_name != "" && _name.length < 2){
		alert("이름은 2글자 이상 입력하세요.");
		return;
	}
	$("#kep_user_name").val(_name);
	$('#masterMdCmCmsItemMngrSelPop').attr("action", "/common/commonList.do").submit();
}

function deptChanged()
{
	var _name = $.trim($("#kep_user_name").val());
	if (_name != "" && _name.length < 2){ return; }
	if ($("#kep_dept").val() == "" && _name == ""){ return; }
	$("#kep_user_name").val(_name);
	$('#masterMdCmCmsItemMngrSelPop').attr("action", "/common/commonList.do").submit();
}

function setReset()
{
	$("#kep_dept").val("");
	$("#kep_user_name").val("");
}

function kepEnter() {
	if (event.keyCode == 13) {
		setQuery();
	}
}

function setReturn(value1,value2)	// USER_ID, 담당자명(마스킹)
{
	opener.setPopupReturn(value1,value2);
	this.close();
}
</script>
<body>
	<form name=masterMdCmCmsItemMngrSelPop id=masterMdCmCmsItemMngrSelPop method=post >
	<input type="hidden" name="codeGubun" id="codeGubun"  value="masterMdCmCmsItemMngrSelPop">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
		<div id="popHeader">
			<h1 class="title">구매담당자 조회</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>
				<span class="btn_reset"><a href="javascript:setReset();">초기화</a></span>
			</div>
			<!--조회영역-->
			<div id="cont_searchA">
				<table  class="cont_t_list01"  style="width:100%">
					<caption>구매담당자 조회</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tbody>
					<tr>
						<td>팀명</td>
						<td>
							<select name="kep_dept" id="kep_dept" style="width:95%;" onchange="deptChanged();"><%=CommonUtil.getCodeComboQueryIdList("commonPopup.masterMdCmCmsItemMngrDeptCombo","ALL",kep_dept)%></select>
						</td>
						<td>이름</td>
						<td>
							<input type=text name="kep_user_name" id="kep_user_name" style="width:95%;" value="<%=kep_user_name%>" onkeydown="kepEnter()" class="input_type_text">
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<!--grid-->
			<div class="scrollArea" style="height:295px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>구매담당자 리스트</caption>
					<colgroup>
						<col width="45%" />
						<col width="25%" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">팀명</th>
							<th scope="col">이름</th>
							<th scope="col">사번</th>
						</tr>
					</thead>
					<tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
					<tr bgcolor="#FFFFFF">
						<td colspan="3" align="center" height = "250">
						<span class="font1">조회된 데이타가 없습니다.</span>
						</td>
					</tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
	String _userId   = CommonUtil.nvl(rowData.get("KEP_USER_ID"),"");
	String _userName = CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("KEP_USER_NAME"),""));	// 가운데 마스킹
	String _deptName = CommonUtil.nvl(rowData.get("KEP_DEPT_NAME"),"");
	String _userNo   = CommonUtil.nvl(rowData.get("KEP_USER_NO"),"");
	String _link     = "javascript:setReturn('" + _userId + "','" + _userName + "')";
%>
					<tr>
						<td><%=_deptName%></td>
						<td>	<a class="hyperLink"  href="<%=_link%>"><%=_userName%></a></td>
						<td>	<a class="hyperLink"  href="<%=_link%>"><%=_userNo%></a></td>
					</tr>
<% }
}%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	</form>
</body>
</html>
