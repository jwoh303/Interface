<%--
**********************************************
* 메뉴 : 고객사 > 주문관리 > 월간리포트
* 화면 : 월간리포트
* 기능 :
* 프로그램 ID : 
* 담당자 : HSJ ( 설계 : HSJ )
* 착수일 : 2023-07-17
**********************************************
--%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String year = CommonUtil.formatDate(new Date(), CommonUtil.YYYYMMDD).substring(0,4);

String st_user_id = _sessionInfo.getUserId();
String buyer = _sessionInfo.getComCode();
%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<style type="text/css">
	table.ui-datepicker-calendar { display:none; }
</style>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var img_print ="/resources/images/icon_print.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
						 { Align:"Left",	Width:240,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"리포트그룹명",	SaveName:"GROUP_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"1월",		SaveName:"IMG_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"REPORT_NO_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"CLOSE_MONTH_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"CLOSE_MONTH_M1_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"CLOSE_MONTH_M12_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"TR_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"TRDT_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"CONTRACT_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"PD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"BUYER_CA_PD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"RD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"BUYER_CA_RD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"DE_CD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"DE_WD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"RE_CD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"RE_WD_YN_01"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"EVALUATION_YN_01"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"2월",		SaveName:"IMG_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"REPORT_NO_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"CLOSE_MONTH_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"CLOSE_MONTH_M1_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"CLOSE_MONTH_M12_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"TR_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"TRDT_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"CONTRACT_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"PD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"BUYER_CA_PD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"RD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"BUYER_CA_RD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"DE_CD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"DE_WD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"RE_CD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"RE_WD_YN_02"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"2월",		SaveName:"EVALUATION_YN_02"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"3월",		SaveName:"IMG_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"REPORT_NO_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"CLOSE_MONTH_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"CLOSE_MONTH_M1_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"CLOSE_MONTH_M12_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"TR_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"TRDT_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"CONTRACT_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"PD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"BUYER_CA_PD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"RD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"BUYER_CA_RD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"DE_CD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"DE_WD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"RE_CD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"RE_WD_YN_03"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"3월",		SaveName:"EVALUATION_YN_03"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"4월",		SaveName:"IMG_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"REPORT_NO_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"CLOSE_MONTH_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"CLOSE_MONTH_M1_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"CLOSE_MONTH_M12_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"TR_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"TRDT_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"CONTRACT_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"PD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"BUYER_CA_PD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"RD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"BUYER_CA_RD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"DE_CD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"DE_WD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"RE_CD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"RE_WD_YN_04"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"4월",		SaveName:"EVALUATION_YN_04"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"5월",		SaveName:"IMG_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"REPORT_NO_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"CLOSE_MONTH_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"CLOSE_MONTH_M1_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"CLOSE_MONTH_M12_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"TR_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"TRDT_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"CONTRACT_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"PD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"BUYER_CA_PD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"RD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"BUYER_CA_RD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"DE_CD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"DE_WD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"RE_CD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"RE_WD_YN_05"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"5월",		SaveName:"EVALUATION_YN_05"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"6월",		SaveName:"IMG_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"REPORT_NO_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"CLOSE_MONTH_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"CLOSE_MONTH_M1_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"CLOSE_MONTH_M12_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"TR_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"TRDT_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"CONTRACT_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"PD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"BUYER_CA_PD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"RD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"BUYER_CA_RD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"DE_CD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"DE_WD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"RE_CD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"RE_WD_YN_06"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"6월",		SaveName:"EVALUATION_YN_06"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"7월",		SaveName:"IMG_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"REPORT_NO_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"CLOSE_MONTH_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"CLOSE_MONTH_M1_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"CLOSE_MONTH_M12_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"TR_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"TRDT_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"CONTRACT_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"PD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"BUYER_CA_PD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"RD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"BUYER_CA_RD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"DE_CD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"DE_WD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"RE_CD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"RE_WD_YN_07"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"7월",		SaveName:"EVALUATION_YN_07"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"8월",		SaveName:"IMG_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"REPORT_NO_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"CLOSE_MONTH_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"CLOSE_MONTH_M1_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"CLOSE_MONTH_M12_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"TR_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"TRDT_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"CONTRACT_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"PD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"BUYER_CA_PD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"RD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"BUYER_CA_RD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"DE_CD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"DE_WD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"RE_CD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"RE_WD_YN_08"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"8월",		SaveName:"EVALUATION_YN_08"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"9월",		SaveName:"IMG_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"REPORT_NO_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"CLOSE_MONTH_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"CLOSE_MONTH_M1_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"CLOSE_MONTH_M12_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"TR_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"TRDT_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"CONTRACT_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"PD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"BUYER_CA_PD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"RD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"BUYER_CA_RD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"DE_CD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"DE_WD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"RE_CD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"RE_WD_YN_09"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"9월",		SaveName:"EVALUATION_YN_09"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"10월",		SaveName:"IMG_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"REPORT_NO_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"CLOSE_MONTH_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"CLOSE_MONTH_M1_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"CLOSE_MONTH_M12_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"TR_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"TRDT_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"CONTRACT_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"PD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"BUYER_CA_PD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"RD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"BUYER_CA_RD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"DE_CD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"DE_WD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"RE_CD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"RE_WD_YN_10"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"10월",		SaveName:"EVALUATION_YN_10"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"11월",		SaveName:"IMG_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"REPORT_NO_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"CLOSE_MONTH_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"CLOSE_MONTH_M1_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"CLOSE_MONTH_M12_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"TR_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"TRDT_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"CONTRACT_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"PD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"BUYER_CA_PD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"RD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"BUYER_CA_RD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"DE_CD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"DE_WD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"RE_CD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"RE_WD_YN_11"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"11월",		SaveName:"EVALUATION_YN_11"}
						
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"12월",		SaveName:"IMG_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"REPORT_NO_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"1월",		SaveName:"GROUP_CODE_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"CLOSE_MONTH_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"CLOSE_MONTH_M1_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"CLOSE_MONTH_M12_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"TR_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"TRDT_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"CONTRACT_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"PD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"BUYER_CA_PD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"RD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"BUYER_CA_RD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"DE_CD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"DE_WD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"RE_CD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"RE_WD_YN_12"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"12월",		SaveName:"EVALUATION_YN_12"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	setLinkCol(mySheet, "IMG_01");
	setLinkCol(mySheet, "IMG_02");
	setLinkCol(mySheet, "IMG_03");
	setLinkCol(mySheet, "IMG_04");
	setLinkCol(mySheet, "IMG_05");
	setLinkCol(mySheet, "IMG_06");
	setLinkCol(mySheet, "IMG_07");
	setLinkCol(mySheet, "IMG_08");
	setLinkCol(mySheet, "IMG_09");
	setLinkCol(mySheet, "IMG_10");
	setLinkCol(mySheet, "IMG_11");
	setLinkCol(mySheet, "IMG_12");
	
	mySheet.SetImageList(1, img_print);
	
	kepAjaxCommonQueryIdSearchTwoCombo('st_from_year','yearCodeList','04','','SEL', '<%=year%>');
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
			if(isEmpty($("#st_from_year").val())){
				alert("<%=CommonLang.msg("MSG302")%>");	//기준년도를 선택하세요.
				$("#st_from_year").focus();
				return;
			}
	
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getBuyerMpSoMonthReportList.do" , pagingMode );
		break;
		
	case "kep_reload":	 //초기화
		kepReload('searchCondition');
	
		document.forms.searchCondition.st_from_year.value = "<%=year%>";
		
		mySheet.RemoveAll();
		break; 
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_report_no = "";
	var st_group_code = "";
	var st_close_month = "";
	var st_close_month_M1 = "";
	var st_close_month_M12 = "";
	var st_tr_yn = ""; // 거래현황
	var st_trdt_yn = ""; // 거래현황상세
	var st_new_contract_yn = ""; // 계약_신규품목현황
	var st_pd_yn = ""; // 품목별현황_SG
	var st_buyer_ca_pd_yn = ""; // 품목별현황_카테고리
	var st_rd_yn = ""; // 절감현황_SG
	var st_buyer_ca_rd_yn = ""; // 절감현황_카테고리
	var st_de_cd_yn = ""; // 납기관리_CD
	var st_de_wd_yn = ""; // 납기관리_WD
	var st_re_cd_yn = ""; // 견적관리_CD
	var st_re_wd_yn = ""; // 견적관리_WD
	var st_evaluation_yn = ""; // 총평
	
	if(column == "IMG_01") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_01");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_01");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_01");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_01");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_01");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_01"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_01"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_01"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_01"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_01"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_01"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_01"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_01"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_01"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_01"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_01"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_01"); // 총평
	}else if(column == "IMG_02") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_02");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_02");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_02");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_02");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_02");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_02"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_02"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_02"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_02"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_02"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_02"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_02"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_02"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_02"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_02"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_02"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_02"); // 총평
	}else if(column == "IMG_03") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_03");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_03");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_03");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_03");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_03");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_03"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_03"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_03"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_03"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_03"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_03"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_03"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_03"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_03"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_03"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_03"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_03"); // 총평
	}else if(column == "IMG_04") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_04");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_04");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_04");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_04");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_04");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_04"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_04"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_04"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_04"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_04"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_04"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_04"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_04"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_04"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_04"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_04"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_04"); // 총평
	}else if(column == "IMG_05") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_05");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_05");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_05");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_05");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_05");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_05"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_05"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_05"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_05"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_05"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_05"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_05"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_05"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_05"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_05"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_05"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_05"); // 총평
	}else if(column == "IMG_06") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_06");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_06");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_06");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_06");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_06");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_06"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_06"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_06"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_06"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_06"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_06"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_06"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_06"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_06"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_06"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_06"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_06"); // 총평
	}else if(column == "IMG_07") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_07");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_07");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_07");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_07");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_07");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_07"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_07"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_07"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_07"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_07"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_07"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_07"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_07"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_07"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_07"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_07"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_07"); // 총평
	}else if(column == "IMG_08") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_08");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_08");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_08");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_08");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_08");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_08"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_08"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_08"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_08"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_08"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_08"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_08"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_08"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_08"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_08"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_08"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_08"); // 총평
	}else if(column == "IMG_09") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_09");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_09");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_09");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_09");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_09");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_09"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_09"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_09"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_09"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_09"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_09"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_09"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_09"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_09"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_09"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_09"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_09"); // 총평
	}else if(column == "IMG_10") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_10");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_10");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_10");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_10");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_10");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_10"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_10"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_10"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_10"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_10"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_10"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_10"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_10"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_10"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_10"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_10"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_10"); // 총평
	}else if(column == "IMG_11") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_11");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_11");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_11");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_11");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_11");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_11"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_11"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_11"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_11"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_11"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_11"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_11"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_11"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_11"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_11"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_11"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_11"); // 총평
	}else if(column == "IMG_12") {
		st_report_no = mySheet.GetCellValue(Row,"REPORT_NO_12");
		st_group_code = mySheet.GetCellValue(Row,"GROUP_CODE_12");
		st_close_month = mySheet.GetCellValue(Row,"CLOSE_MONTH_12");
		st_close_month_M1 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M1_12");
		st_close_month_M12 = mySheet.GetCellValue(Row,"CLOSE_MONTH_M12_12");
		st_tr_yn = mySheet.GetCellValue(Row,"TR_YN_12"); // 거래현황
		st_trdt_yn = mySheet.GetCellValue(Row,"TRDT_YN_12"); // 거래현황상세
		st_new_contract_yn = mySheet.GetCellValue(Row,"CONTRACT_YN_12"); // 계약_신규품목현황
		st_pd_yn = mySheet.GetCellValue(Row,"PD_YN_12"); // 품목별현황_SG
		st_buyer_ca_pd_yn = mySheet.GetCellValue(Row,"BUYER_CA_PD_YN_12"); // 품목별현황_카테고리
		st_rd_yn = mySheet.GetCellValue(Row,"RD_YN_12"); // 절감현황_SG
		st_buyer_ca_rd_yn = mySheet.GetCellValue(Row,"BUYER_CA_RD_YN_12"); // 절감현황_카테고리
		st_de_cd_yn = mySheet.GetCellValue(Row,"DE_CD_YN_12"); // 납기관리_CD
		st_de_wd_yn = mySheet.GetCellValue(Row,"DE_WD_YN_12"); // 납기관리_WD
		st_re_cd_yn = mySheet.GetCellValue(Row,"RE_CD_YN_12"); // 견적관리_CD
		st_re_wd_yn = mySheet.GetCellValue(Row,"RE_WD_YN_12"); // 견적관리_WD
		st_evaluation_yn = mySheet.GetCellValue(Row,"EVALUATION_YN_12"); // 총평
	}
	
	if (st_report_no == ""){
		alert("작성된 리포트가 없습니다.");
		return;
	}
	
	var param = "";
	param = "["+st_report_no+"]["+st_group_code+"]["+st_close_month+"]["+st_close_month_M1+"]["+st_close_month_M12+"]["+st_tr_yn+"]["+st_trdt_yn+"]["+st_new_contract_yn+"]["+st_pd_yn+"]["+st_buyer_ca_pd_yn+"]["+st_rd_yn+"]["+st_buyer_ca_rd_yn+"]["+st_de_cd_yn+"]["+st_de_wd_yn+"]["+st_re_cd_yn+"]["+st_re_wd_yn+"]["+st_evaluation_yn+"]";
	
	//alert(param);
	
	var params = [];
	var url = "/coco/showChartViewer.do";
	params.push({ key: "fileName", value: "CT_01_B_001_01" });
	params.push({ key: "param", value: param });
	params.push({ key: "download_flag", value: "B" }); // 고객사 출력용 PDF 다운만 가능
	
	OpenReportPost(url, "POP", params);
	return;
}

$(window).resize(function() { // 화면 리사이즈시 다시검사....
	var winWidth = $(window).width();
	//alert(winWidth);
	if (winWidth < 1200) {
		$(".divGridArea").css("width", "995px");
	} else  {
		$(".divGridArea").css("width", "97%");		
	}  
});
</script>
</head>

<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<form name = "searchCondition" method = "post">
	<div id="ContArea" class="divGridArea" style="min-height: 430px;">
	<h3><%=CommonLang.get("HTITLE961") %><!-- 월간리포트 --></h3>
    <div id="searchBtnA">
		<!--버튼영역-->
        	<span class="btn_search"><a href="javascript:doAction('search')"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
        	<span class="btn_reset" title="초기화"><a href="javascript:doAction('kep_reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
   		</div>        	
        <!--조회영역-->
			<div id="cont_searchA" class="divGridArea">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="onepagerow" name="onepagerow" value="100">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
    
            	<table  class="cont_t_list01" style="width:100%;">
					<caption><%=CommonLang.get("HTITLE961") %><!-- 월간리포트 --></caption>
					<colgroup>
						<col width="5%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE402") %><!-- 기준년도 --></td>
							<td>
								<select id="st_from_year" name="st_from_year" style="width:100px;height:20px"></select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "120px");
			</script>
		</div>
		<font color="red">※ 리포트 데이터는 매월 10일에 자동 집계되며 담당자 내용 확인 후 표시됩니다.</font>
<!--내용 종료-->	
		</div>
	</form>
	</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
</body>
</html>
