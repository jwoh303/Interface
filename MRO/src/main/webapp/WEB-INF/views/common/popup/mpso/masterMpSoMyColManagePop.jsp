<%--
**********************************************
* 메뉴 : 
* 화면 : 나의 컬럼설정 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-10-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
String defualtCol = "1,0,1,1,0,1,0,1,1,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
String[] myColInfo = CommonUtil.StrToArray(CommonUtil.nvl((String) request.getAttribute("my_col_info"), defualtCol), ",");
int colInx = 0;
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<script>

function saveMyColInfo(){
	if(45 < $("input[name=st_chk_col]:checked").length){
		alert("컬럼선택을 총 "+$("input[name=st_chk_col]:checked").length+"개 선택 하셨습니다.\n컬럼선택은 최대 45개까지만 가능합니다.");
		return;
	}
	
	var myColInfo = $("input[name=st_chk_col]");
	var st_my_col = "";
	for(var inx = 0 ; inx < myColInfo.length ; inx++){
		if($(myColInfo[inx]).is(":checked")){
			st_my_col += ",1";
		} else {
			st_my_col += ",0";
		}
	}
	
	if(confirm("선택하신 컬럼 정보를 저장 하시겠습니까?")){
		var pData = { st_my_col : st_my_col.substring(1), st_user_id : $("#st_user_id").val()};
		kepAjaxCall("/mpso/saveMasterMpSoMyColManagePop.do",pData,"saveMyColInfo");
	}
	
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if ( pMethod == "saveMyColInfo" ) {
		var msg = response.msg.MSG;
		if(msg == "INSERT_OK"){
			opener.location.href = "/mpso/showMasterMpSoProgressDownLoad.do";
			alert("저장 되었습니다.");
			self.close();
			return;
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "saveMyColInfo"){ 
		 alert("컬럼 설정 저장에 실패하였습니다. 관리자에 문의 하여 주십시오."); 
	}
}

</script> 
<body>
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">컬럼설정</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<p><b>※ 필수(10개)를 포함하여 30개의 컬럼 선택을 권장합니다.(최대45개)</b></p>
        	<div style="height:427px;">
            	<!--왼쪽영역-->
           	    <div style="width:20%; height:330px; float:left; padding-right: 5px;">
           	    	<div class="wrap_tbl">
						<table class="t_masterMain05" style="width: 100%;">
							<colgroup>
								<col width="80%">
								<col width="*">
							</colgroup>
							<thead>
								<tr>
									<th class="BGblue">컬럼항목</th>
									<th class="BGgreen">선택</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">고객사</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">고객사코드</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">진행상태</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">협력사명</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">협력사코드</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주번호</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주항번</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주수량</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">IF발주번호</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">주문항번</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">생성일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주일</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주부서</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주자</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주자ID</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">품목코드</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
							</tbody>
						</table>
					</div>
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:19%; height:330px; float:left; padding-right: 5px;">
                	<div class="wrap_tbl">
						<table class="t_masterMain05" style="width: 100%;">
							<colgroup>
								<col width="80%">
								<col width="*">
							</colgroup>
							<thead>
								<tr>
									<th class="BGblue">컬럼항목</th>
									<th class="BGgreen">선택</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">품목명</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">규격</td>
									<td style="text-align : center; background-color: #CCCCCC;"><input type="checkbox" name="st_chk_col" value="1" disabled="disabled" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">제조사</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">단위</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">매출단가</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">매출금액</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">매입단가</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">매입금액</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">관리번호</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">납기요청일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">납품합의일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">협력사납품예정일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">KeP납품예정일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">납품일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">납품수량</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">확정일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
							</tbody>
						</table>
					</div>
                </div>
                <div style="width:20%; height:330px; float:left; padding-right: 5px;">
                	<div class="wrap_tbl">
						<table class="t_masterMain05" style="width: 100%;">
							<colgroup>
								<col width="80%">
								<col width="*">
							</colgroup>
							<thead>
								<tr>
									<th class="BGblue">컬럼항목</th>
									<th class="BGgreen">선택</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">확정수량</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">입고일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">입고수량</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">입고매출금액</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">입고매입금액</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카테고리ID</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카테고리명</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카테고리경로</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">표준카테고리ID</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">표준카테고리경로</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">요청부서</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">요청자</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">요청자ID</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">발주삭제사유</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">I/F관리번호</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">비고</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
							</tbody>
						</table>
					</div>
                </div>
                <!--오른쪽영역-->
                <div style="width:19%; height:330px; float:left; padding-right: 5px;">
					<div class="wrap_tbl">
						<table class="t_masterMain05" style="width: 100%;">
							<colgroup>
								<col width="80%">
								<col width="*">
							</colgroup>
							<thead>
								<tr>
									<th class="BGblue">컬럼항목</th>
									<th class="BGgreen">선택</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">거래유형</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">협력사사업자번호</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">실협력사코드</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">실협력사명</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">물류센터명</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">비고2</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">목표가</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">도착지</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">예산계정</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">요청번호(주문이력)</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">요청항번</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카드사용여부</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카드승인번호</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">계약서번호</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">계약서항번</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">카탈로그관리코드</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
							</tbody>
						</table>
					</div>
                </div>
                <!--//오른쪽영역-->
                <div style="width:19%; height:330px; float:left; padding-right: 5px;">
					<div class="wrap_tbl">
						<table class="t_masterMain05" style="width: 100%;">
							<colgroup>
								<col width="80%">
								<col width="*">
							</colgroup>
							<thead>
								<tr>
									<th class="BGblue">컬럼항목</th>
									<th class="BGgreen">선택</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">DS_REMARK</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>							
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">표준납기일</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">품목구분</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
								<tr>
									<td class="pr10" scope="row" style="text-align : left;">주문매출단가(수출)</td>
									<td style="text-align : center;"><input type="checkbox" name="st_chk_col" value="1" <%if("1".equals(myColInfo[colInx++])){ %>checked="checked" <%} %>/></td>
								</tr>
							</tbody>
						</table>
					</div>
                </div>
            </div>
        </div>
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:saveMyColInfo()">저장</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
