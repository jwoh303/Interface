<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산편성
* 화면 : 예산편성
* 기능 : 예산관리 부서별 예산을 편성/관리할 수 있는 화면이다.
* 프로그램 ID : PG_06_B_052_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%-- <%@ include file="../../common/include/head.jspf"%> --%>
<jsp:useBean id="toDay" class="java.util.Date" />

<!DOCTYPE html>

<HTML>
<HEAD>
<title>++ 거래명세서
	++++++++++++++++++++++++++++++++++++++++++</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- <LINK title="master style" href="/css/style.css" type="text/css" -->
<!-- 	rel="stylesheet"> -->
<!-- <script language="javascript" src="/js/menu.js"></script> -->
<style type="text/css">
 td {font-family:Verdana,돋움; font-family: "Verdana"; font-size: 11px;line-height: 17px;color: #4E4E4E;}
 .td2 {font-family:Verdana,돋움; font-family: "돋움"; font-size: 13px;line-height: 17px;color: #4E4E4E;}
 a:link {text-decoration:none; color:#4E4E4E}
 a:active {text-decoration:none}
 a:visited {text-decoration:none; color:#4E4E4E}
 a:hover  {text-decoration:none; color:#3270B0}
 input,select,textarea{ font-size:11px; color:#585858;}


 a.com:link    {font-family: "돋움, Verdana"; font-size: 9pt; color:#ED7500; text-decoration: none }
 a.com:visited {font-family: "돋움, Verdana"; font-size: 9pt; color:#814600; text-decoration: none }
 a.com:hover   {font-family: "돋움, Verdana"; font-size: 9pt; color:#D3D118; text-decoration: none }

 a.com01:link    {font-family: "돋움, Verdana"; font-size: 9pt; color:#00A272; text-decoration: none }
 a.com01:visited {font-family: "돋움, Verdana"; font-size: 9pt; color:#005044; text-decoration: none }
 a.com01:hover   {font-family: "돋움, Verdana"; font-size: 9pt; color:#1EE7C8; text-decoration: none }

  .small   {font-family: "돋움, Verdana"; font-size: 11px;}
  .small01 {font-family: "돋움, Verdana"; font-size: 11px; font-weight:bold;}
  .small02 {font-family: "돋움, Verdana"; font-family: "Verdana"; font-size: 10px; }

  .middle   {font-family: "돋움, Verdana"; font-size: 12px; font-weight:bold;}
  .middle01 {font-family: "돋움, Verdana"; font-size: 12px;}
  .middle02 {font-family: "돋움, Verdana"; font-size: 12px; font-weight:bold;}

  .big   {font-family: "돋움, Verdana"; font-size: 13px; font-weight:bold;}
  .big01 {font-family: "돋움, Verdana"; font-size: 13px;}
  .big02  {font-family: "돋움, Verdana"; font-size: 14px; font-weight:bold;}
  .big03  {font-family: "돋움, Verdana"; font-size: 15px; font-weight:bold;}
  .big04  {font-family: "돋움, Verdana"; font-size: 16px; font-weight:bold;}
  .big05  {font-family: "Verdana"; font-size: 18px; font-weight:bold;}
  .big06  {font-family: "Verdana"; font-size: 26px; font-weight:bold;}
  .big07   {font-family: "돋움, Verdana"; font-size: 13px; }

  .solid{ font-size:12px; border:1px ; border-style:solid;border-color:#C2C2C2; background:#FFFFFF;}
  .solid01{ font-size:12px; border:1px ; border-style:solid;border-color:#C1C1C1; background:#C1C1C1;}
  .solid001{ font-size:12px; border:1px ; border-style:solid;border-color:#C1C1C1; background:#C1C1C1;text-align:right}
  .solid02{ font-size:12px; border:1px ; border-style:solid;border-color:#E1BE55; background:#FFFAE9;}
  .solid03{ font-size:12px; border:1px ; border-style:solid;border-color:#75D7B9; background:#F0FFFA;}
  .solid04{ font-size:12px; border:1px ; border-style:solid;border-color:#F69AC0; background:#FFF0F6;}
  .solid05{ font-size:12px; border:1px ; border-style:solid;border-color:#68C7EF; background:#EAF9FF;}
  .solid06{ font-size:12px; border:1px ; border-style:solid;border-color:#7B96ED; background:#EAF2FF;}
  .solid07{ border-bottom: #ffffff 1px solid; border-left: #ffffff 1px solid; border-right: #ffffff 1px solid; border-top: #ffffff 1px solid;}
  .solid007{ border-bottom: #ffffff 1px solid; border-left: #ffffff 1px solid; border-right: #ffffff 1px solid; border-top: #ffffff 1px solid;;text-align:right}

  label {cursor:hand;}

 .space15 {padding-left:15px;}
 .space8 {padding-left:8px;}
 .space5 {padding-left:5px;}


.menutitle{cursor:pointer;}
.submenu{margin-bottom: 0.5em;}

.submit  { width:60; background-color:C36A33; border:1 solid #7D3200; font-family:돋움; font-size:10pt; color:white }
.submit01  { width:60; background-color:C3A694; border:1 solid #7C6A5E; font-family:돋움; font-size:10pt; color:white }
<----스크롤바------>
 <STYLE type="text/css">
<!--
BODY { SCROLLBAR-FACE-COLOR: #ffffff; SCROLLBAR-HIGHLIGHT-COLOR: #C5C5C5; SCROLLBAR-SHADOW-COLOR: #C5C5C5; SCROLLBAR-3DLIGHT-COLOR: #ffffff; SCROLLBAR-ARROW-COLOR: #C5C5C5; SCROLLBAR-TRACK-COLOR: #ffffff; SCROLLBAR-DARKSHADOW-COLOR: #ffffff }
-->








BODY {
	SCROLLBAR-FACE-COLOR: #aae8ff;
	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
	SCROLLBAR-SHADOW-COLOR: #acf6ff;
	SCROLLBAR-3DLIGHT-COLOR: #00d8ff;
	SCROLLBAR-ARROW-COLOR: #0ecbed;
	SCROLLBAR-TRACK-COLOR: #e1faff;
	SCROLLBAR-DARKSHADOW-COLOR: #00c6ea
}

TD {
	FONT-SIZE: 12px;
	COLOR: #000000;
	LINE-HEIGHT: 15px;
	FONT-FAMILY: 굴림, Verdana
}

A:link {
	COLOR: #6c6c6c;
	TEXT-DECORATION: none
}

A:active {
	TEXT-DECORATION: none
}

A:visited {
	COLOR: #9c9c9c;
	TEXT-DECORATION: none
}

A:hover {
	COLOR: #5674b9;
	TEXT-DECORATION: none
}

INPUT {
	FONT-SIZE: 12px;
	COLOR: #585858
}

SELECT {
	FONT-SIZE: 12px;
	COLOR: #585858
}

TEXTAREA {
	FONT-SIZE: 12px;
	COLOR: #585858
}
</style>
</HEAD>
<body text="#000000" bgColor="#ffffff" leftMargin="15" topMargin="10">
	<form name="Form1" method="post" id="Form1">
		<div>
			<input type="hidden" name="__VIEWSTATE" id="__VIEWSTATE"
				value="/wEPDwUKLTYwNDAzMzg5MA9kFgICAQ9kFhoCBg8PFgIeBFRleHQFAjAzZGQCBw8PFgIfAAUIMjAyOTI0MTBkZAIIDw8WAh8ABQFQZGQCCQ8PFgIfAAUBWWRkAgoPDxYCHwAFBDIwMDBkZAILDw8WAh4HVmlzaWJsZWhkZAIMDxYCHgtfIUl0ZW1Db3VudAIBFgJmD2QWAmYPFQMJ6rmA7IaM7Z2sCzAxMDc1NTE0MDE0AGQCDQ8WAh8CZmQCDg8WAh8CAgIWBGYPZBYCZg8VBzLshLjsnbzspojrj4Tqtawg6rCA67CpPGJyPijshLjsnbzspojrj4Tqtawg6rCA67CpKQExACTquYDshoztnawvMjAyOTI0MTAv6riw7KG0LzIwMTQtMDctMTIBTgAAZAIBD2QWAmYPFQce66+464uI7ZWE7YSwPGJyPijrr7jri4jtlYTthLApATIAJOq5gOyGjO2drC8yMDI5MjQxMC/quLDsobQvMjAxNC0wNy0xMgFOAABkAg8PFgIfAgIBFgJmD2QWAmYPFQIJ6rmA7IaM7Z2sAGQCEA8WAh8CAgEWAmYPZBYCZg8VAwAJ6rmA7IaM7Z2sGjIwMTUtMDQtMTcg7Jik7ZuEIDEwOjIzOjAyZAIRDw8WAh8BaGRkAhIPDxYCHwFoZGRkOx7TnjW0htpaTKjlNSbogiHLQOs=" />
		</div>

		<div>

			<input type="hidden" name="__VIEWSTATEGENERATOR"
				id="__VIEWSTATEGENERATOR" value="1EDE4859" />
		</div>


		<table cellSpacing="0" cellPadding="0" width="650" border="0">
<!-- 		<table style="border-spacing:0;border-spacing: 0;" width="650" > -->
			<tr bgColor="#ffffff">
				<td vAlign="top">
					<table cellSpacing="0" cellPadding="0" width="100%" border="0">
						<tr>
							<td align="center" height="35"><font style='font-family: "돋움, Verdana"; font-size: 15px; font-weight:bold;'>
								<u>거래명세서</u></font>
							</td>
						</tr>
					</table>
					
					<table cellSpacing="0" cellPadding="0" width="100%" border="0">
						<tr>
							<td bgColor="#cccccc">
								<table cellSpacing="1" cellPadding="0" width="100%" border="0">
									<tr>
										<td align="center" width="100" bgColor="#a9b2cb" height="22">
											<b><font color="#ffffff">조직명</font></b>
										</td>
										<td class="space8" bgColor="#ffffff">
											${deptData.HQ_DEPT_NAME }
										</td>
									</tr>
									<tr>
										<td align="center" width="100" bgColor="#a9b2cb" height="22">
											<b><font color="#ffffff">주 소</font></b>
										</td>
										<td class="space8" bgColor="#ffffff">
											${deptData.HQ_ADDRESS }
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<table cellSpacing="0" cellPadding="0" width="100%" border="0">
						<tr>
							<td bgColor="#cccccc">
								<table cellSpacing="0" cellPadding="0" width="100%" border="0">
									<tr>
										<td bgColor="#cccccc">
											<table cellSpacing="1" cellPadding="0" width="100%" border="0">
												<tr>
													<td align="center" width="100" bgColor="#6f7fac" height="91" rowSpan="3">
														<b><font color="#ffffff">조직장 정보</font></b>
													</td>
													<td align="center" width="80" bgColor="#a9b2cb" height="22">
														<b><font color="#ffffff">ID No</font></b>
													</td>
													<td class="space8" bgColor="#ffffff">
														${deptData.HQ_USER_ID }
													</td>
													<td align="center" width="80" bgColor="#a9b2cb">
														<b><font color="#ffffff">사무실전화</font></b>
													</td>
													<td class="space8" width="150" bgColor="#ffffff">
														${deptData.PHONE_NUMBER }
													</td>
												</tr>
												<tr>
													<td align="center" bgColor="#a9b2cb" height="22">
														<b><font color="#ffffff">성 명</font></b>
													</td>
													<td class="space8" bgColor="#ffffff">
														${deptData.HQ_NAME_LOC }
													</td>
													<td align="center" bgColor="#a9b2cb">
														<b><font color="#ffffff">핸드폰</font></b>
													</td>
													<td class="space8" bgColor="#ffffff">
														${deptData.MOBILE_PHONE }
													</td>
												</tr>
												<tr>
													<td align="center" bgColor="#a9b2cb" height="22">
														<b><font color="#ffffff">E-mail</font></b>
													</td>
													<td class="space8" bgColor="#ffffff" colSpan="3">
														${deptData.HQ_EMAIL }
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<br>
					<table cellSpacing="0" cellPadding="0" width="100%" border="0">
						<tr>
							<td align="right">
								<b>생성일 : <fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" /></b>
							</td>
						</tr>
					</table>
					<table cellSpacing="0" cellPadding="0" width="100%" border="0">
						<tr>
							<td bgColor="#cccccc">
								<table cellSpacing="1" cellPadding="0" width="100%" border="0">
									<tr bgColor="#a9b2cb">
										<td align="center" width="40" height="22">
											<b><font color="#ffffff">순번</font></b>
										</td>
										<td align="center" width="150" height="22">
											<b><font color="#ffffff">품명</font></b>
										</td>
										<td align="center" width="150" height="22">
											<b><font color="#ffffff">규격</font></b>
										</td>
										<td align="center" width="40">
											<b><font color="#ffffff">단위</font></b>
										</td>
										<td align="center" width="40">
											<b><font color="#ffffff">수량</font></b>
										</td>
										<td align="center" width="200">
											<b><font color="#ffffff">대상자/요청번호/품목코드</font></b>
										</td>
									</tr>
									<c:forEach items="${data}" var="_itemInfo" varStatus="status">
										<tr bgcolor="#ffffff" height="20">
											<td align="center">${_itemInfo.SEQ }</td>
											<td align="center">${_itemInfo.MAKTX }</td>
											<td align="center">${_itemInfo.SPECIFICATION }</td>
											<td align="center">${_itemInfo.MEINS }</td>
											<td align="center">${_itemInfo.GIMENGE }</td>
											<td align="center">${_itemInfo.DAESG_NM }
											/${_itemInfo.I_MBLNR }
											/${_itemInfo.MATNR }</td>
										</tr>
<!-- 										<tr bgcolor="#ffffff" height="20"> -->
<%-- 											<td align="center">${_itemInfo.SEQ }</td> --%>
<%-- 											<td align="center">${_itemInfo.s_item_nm }</td> --%>
<%-- 											<td align="center">${_itemInfo.s_stnd_nm }</td> --%>
<%-- 											<td align="center">${_itemInfo.UNIT_MEASURE }</td> --%>
<%-- 											<td align="center">${_itemInfo.RQMENGE }</td> --%>
<%-- 											<td align="center">${_itemInfo.REQ_USER_NAME } --%>
<%-- 											/${_itemInfo.REF_PR_NO } --%>
<%-- 											/${_itemInfo.BUYER_ITEM_NO }</td> --%>
<!-- 										</tr> -->
									</c:forEach>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<div style="margin-top: 10px;height:30px; margin-bottom:20px; text-align:right;">
			<span class="fr">
				<span style="display:inline-block; background:url(/resources/images/b_btn_02.gif) 0 0 no-repeat; width:70px; height:28px; text-align:center; font-family:'맑은 고딕'; padding-top:2px;"  title="출력">
					<a href="javascript:window.print();" style="display:inline-block; width:70px; height:28px; font-size:12px; color:#ffffff; font-weight:normal;">출력</a>
				</span>
			</span>
		</div>
	</form>
</body>
</HTML>
