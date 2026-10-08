<%--
**********************************************
* 메뉴 : 회원사관리>사용자관리>사용자조회
* 화면 : 사용자조회
* 기능 : 협력사의 등록된 사용자 목록 조회하고 삭제한다
* 프로그램 ID : PG_01_A_003_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	// 조회조건 S
	String st_search_user_id = CommonUtil.nvl((String) request.getParameter("st_search_user_id"),"");						// 아이디
	String st_search_user_name = CommonUtil.nvl((String) request.getParameter("st_search_user_name"),"");			// 사용자명 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");		// 부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");	// 부서명
	
	// 조회조건 E
%> 
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){

}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch(1);
			break;
		case "reload":	//초기화
			kepReload("searchForm");
			$("#st_btoa_user_dept_code").val("");
// 			kepSearch(-1);
			jspTableClean("table_list");
			break;
		case "delete": // 삭제	
			if (checkData()) {
				kepAjaxFormCall("/mdct/deleteSellerMdCtUserSearchList.do","contentForm",str);
			}
			break;
		case "cartCheck": // 저장	
		var btnEvent = "del";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("이동 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mdct/saveSellerMdCtUserSearchList.do","processForm",btnEvent); 	
		}
		break;
	
	case "printPum": // 견적서 출력
		alert("견적서 출력");
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdct/getSellerMdCtUserSearchList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str, val) {
	popupSel = str;
	switch (str) {
		case "dept": // 요청부서
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+val+"&open=Y", "500,500,no");
			break;
		case "user": // 사용자정보
			openSearchPopup("/mdct/showSellerMdCtPrivateInfoPop.do", "?st_user_id=" + val, "800,450,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (sMsg == 'OK') {
		alert("사용자가 삭제되었습니다.");
	} else {
		alert("사용자 삭제에 실패하였습니다. \n\n담당자에게 전화해 주십시요.");
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

function checkData() {
	var cnt   = 0;
	var checkId = "";
	
	for (var i=0; i< $('input:checkbox[name=chkItem]').length;i++) {      
        if ($('input:checkbox[name=chkItem]').eq(i).is(':checked')) {
			cnt++;
			checkId = checkId + $('input:checkbox[name=chkItem]').eq(i).val() +  "|";
        }
    }

    if (cnt==0) {
        alert("삭제할 사용자를 선택하여 주십시요");
        return false;
    } else {
    	$("#st_checked_id").val(checkId);
    	if (!confirm("현재 선택한 사용자를 삭제하겠습니까?")) {
            return false;
        }
    }
    
    return true;
}
</script>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>사용자조회</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td>ID</td>
						<td>
								<input type="text" class="input_type_text" name="st_search_user_id" id="st_search_user_id" style="width:80%;" value="<%=st_search_user_id%>" onkeyup="kepToUpper('st_search_user_id')" onKeyDown="kepEnter()">
						</td>
						<td>사용자명</td>						
						<td>
								<input type="text" class="input_type_text" name="st_search_user_name" id="st_search_user_name" style="width:80%;" value="<%=st_search_user_name%>"  onKeyDown="kepEnter()">
						</td>
						<td>부서명</td>
						<td>
							<input type="text" class="input_type_text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:65%;ime-mode:active" value="<%=st_btoa_user_dept_name%>"  readonly />
							<input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>" />
							<a href="javascript:doPop('dept', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
			</select>
      	</span>      
       <span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
		<input type="hidden" name="st_checked_id" id="st_checked_id" value="" />

		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="4%" />
	            <col width="16%" />
	            <col width="14%" />
	            <col width="*" />
	            <col width="12%" />
	            <col width="18%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">선택</th>
                <th scope="col">ID</th>
                <th scope="col">이름</th>
                <th scope="col">부서</th>
                <th scope="col">전화번호</th>
                <th scope="col">이메일</th>
			</tr>
		</thead>
		<tbody>
 		<% if (_gridList == null || _gridList.size() == 0) { %>
			<tr>
				<td colspan="15" align="center" height = "50"> 
					<span>조회된 데이타가 없습니다.</span>
				</td> 
			</tr>
		<%
		} else {
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%>
			<tr class="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  align="center">
						<input type="checkbox" name="chkItem" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("USER_ID")))%>">
	                    <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
					</td>
                    <td class="center" title="ID"><a class="hyperLink" href="javascript:doPop('user','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("USER_ID")))%></a></td>
                    <td title="이름"><%=String.valueOf(CommonUtil.nvl(rowData.get("USER_NAME_LOC")))%></td>
                    <td class="left" title="부서"><%=String.valueOf(CommonUtil.nvl(rowData.get("DEPT_NAME")))%></td>
                    <td title="전화"><%=String.valueOf(CommonUtil.nvl(rowData.get("PHONE_NUMBER")))%></td>
                    <td title="이메일"><%=String.valueOf(CommonUtil.nvl(rowData.get("EMAIL")))%></td>
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('delete');">삭제</a>
				</span>	
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
