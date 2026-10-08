<%--
**********************************************
* 메뉴 : 입고관리>입고조회_상세조회
* 화면 : 입고조회
* 기능 : 조회조건을 추가로 입력할수있다.
* 프로그램 ID : 
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
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
 

<script type="text/javascript">

// 초기값 설정
function init() {
	
	var buyer_item_no = opener.document.searchForm.st_search_buyer_item_no.value;
	var desc_spec = opener.document.searchForm.st_search_desc_spec.value;
	var agent = opener.document.searchForm.st_search_agent.value;
	
	if(!isEmpty(buyer_item_no)) {
		document.searchForm.st_buyer_item_no.value = opener.document.searchForm.st_search_buyer_item_no.value;
	}

	if(!isEmpty(desc_spec)) {
		document.searchForm.st_desc_spec.value = opener.document.searchForm.st_search_desc_spec.value;
	}

	if(!isEmpty(agent)) {
		document.searchForm.st_agent.value = opener.document.searchForm.st_search_agent.value;
	}
}


function setSearchQuery() {

	var buyer_item_no = document.searchForm.st_buyer_item_no.value;
	var desc_spec	= document.searchForm.st_desc_spec.value;
	var agent		= document.searchForm.st_agent.value;

	opener.setSearchDetail(buyer_item_no, desc_spec, agent);
	self.close();

}

</script> 
</head>
<body onLoad="init();">
<form name="searchForm" id="searchForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">상세검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <table  class="board_write" summary="구매요청 상세조회">
	            <caption>구매요청 상세조회 정보</caption>
				<colgroup>
					<col width="30%" />
					<col width="70%" />
				</colgroup>
				<tbody>  
					<tr>
						<th scope="row">품목코드</th>
						<td scope="row" >
							<input name="st_buyer_item_no" type="text" style="width:95%;">
						</td>
					</tr>
					<tr>
						<th scope="row">품목명/규격</th>
						<td scope="row" >
							<input name="st_desc_spec" type="text" style="width:95%;">
						</td>
					</tr>
					<tr>
						<th scope="row">협력사</th>
						<td scope="row" >
							<input name="st_agent" type="text" style="width:95%;">
						</td>
					</tr>
				</tbody>
			</table>
			<!--버튼영역-->
			<div style="height:40px">
		        <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:15px;">
					<tr> 
						<td align="left" width="100px">
							<!-- 발주서인쇄 버튼 -->
							<div class="btnArea">
								<div class="fr">
									<span class="btn_04">
										<a href="javascript:setSearchQuery();">검색</a>
									</span>	
					            </div>
					        </div>
						</td>
					</tr>
				</table>
			</div>
    	</div>  
	</div>
</form> 
</body>
</html>
