<%--
**********************************************
* 메뉴 : 
* 화면 : 납품시 공지 팝업
* 기능 : 배송차량정보를 확인하고 선택할 수 있는 팝업(협력사에서)
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
</head>
<%
	@SuppressWarnings (value="unchecked")
	String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>

<script type="text/javascript">
function setReturn() {
<%if("TYPE90".equals(st_type)){%>
	var box = eval("document.forms['commonMpIvDlvryNoticePop'].st_type90_checkbox");
	if(box.checked == false){
		alert("위 내용을 확인하신 후 체크를 먼저 해주세요.");
		return;
	}
	
	kepAjaxPopFormCall("/mpiv/updateCommonMpIvDlvryNoticePop.do","commonMpIvDlvryNoticePop","save");
<%}else{%>
	window.close();
	opener.setDlvryNotice();	
<%}%>
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod, response) {
	if(pMethod == "save"){
		opener.setDlvryNotice2();
		this.close();
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod, response) {
	alert("처리 하던중 오류가 발생하였습니다.");
}

</script>
<body style="overflow:hidden">
<form name="commonMpIvDlvryNoticePop" id="commonMpIvDlvryNoticePop" method="post" >
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup" >
  <div class="PopupTit">물류센터 TR납품 방식 변경 안내<span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_GrayBox mt15" style="line-height:20px" >
    ㆍ입고번호(IV번호)별 박스 소포장 후 입고라벨 부착 (납품명세서 동봉 불필요)<br/>
    ㆍ합포장시, 외부 박스에 [합포장] 수기 기재 (내부 박스 수량대로 입고라벨 부착)<br/>
    ㆍ품목별 라벨 부착을 요구하는 고객사 납품건도 입고라벨 함께 부착<br/>
    ㆍ삼성그룹은 기존 납품방식 유지 (납품명세서 5장, 품목 라벨, 물품명세표 부착) <br/> 
  </div> 
  <div class="TRChangeBox">
    <a class="TRChangeLink" href="#" onclick="window.open('../../../../resources/html/main/notice/LogisticsCenter_Guide_manual.pdf', '_blank', 'width=800,height=450');" />협력사 TR납품 매뉴얼<p>다운로드 열기</p></a> 
    <a class="TRChangeLink" href="#" onclick="window.open('../../../../resources/html/main/notice/LogisticsCenter_Guide_manual.mp4', '_blank', 'width=800,height=450');" />협력사 TR납품 포장 방식 <p>동영상 보기</p></a> 
  </div>
  <div class="PopupTxt mt10" style=" text-align:center; line-height:21px;" > 
    <label class="CheckMediumLabel mt15" style="vertical-align:bottom; padding:0px; margin:0px;line-height:21px" ><input id="st_type90_checkbox" name="st_type90_checkbox" type="checkbox" ><span class="CheckMediumCustom"></span> </label>  
    위 내용을 확인하였으며, 정해진 TR 납품 방식을 준수하겠습니다. <br/> 
    확인 후 거래명세서를 생성하시겠습니까?
  </div>  
  <div class="PopupListBtnBox_Center mt30"  >
    <button class="ButQuaternary_large" onclick="javascript:self.close();" >취소</button>
    <button class="ButPrimary_large" onclick="javascript:setReturn(); return false;">확인</button>
  </div> 
</div><!-- warp 끝-->
</form> 
</body>
</html>


