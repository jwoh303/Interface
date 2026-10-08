<%--
**********************************************
* 메뉴 : 판촉물전용마켓
* 화면 : 판촉물전용마켓 Footer
* 기능 : 
* 프로그램 ID : 
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String sslurl = CommonUtil.getSslURL(request, "http"); 
%>
    <div class="h50"></div>   
    <div id="footWrap">
    	<div id="footer">
            <ul class="article">
                <li class="first"><a href="#" onClick="poptype02('<%=sslurl%>');"><img src="/resources/images/promote/btn_foot02.gif" alt="개인정보처리방침" /></a></li>
                <li><a href="#" onClick="poptype01('<%=sslurl%>');"><img src="/resources/images/promote/btn_foot04.gif" alt="이메일무단수집거부" /></a></li>
                <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank"><img src="/resources/images/promote/btn_foot05.gif" alt="공동인증서발급안내" /></a></li>
            	<li><a href="http://ftc.go.kr/info/bizinfo/communicationView.jsp?apv_perm_no=2015322016230203012&area1=&area2=&currpage=1&searchKey=04&searchVal=1078185880&stdate=&enddate=" target="_blank"><img src="/resources/images/promote/btn_foot06.gif" alt="사업자정보확인" /></a></li>
            </ul>
            <address><img src="/resources/images/promote/icn_addr.gif" alt="서울특별시 서초구 강남대로 331 광일빌딩 13.14.15.19층   전화:02.3016.8989   팩스:02.569.6724  대표이사:이우석   사업자등록번호:107-81-85880   통신판매업신고번호:2007-서울서초-10658  COPYRIGHT(C) 2011 korea e platform  ALL RIGHT RESERVED" usemap="#Map" border="0" />
            <map name="Map">
              <area shape="rect" coords="172,27,242,39" href="#">
            </map>
            </address>
            <ul class="footCate">
            	<li><img src="/resources/images/promote/img_footcate01.gif" alt="e-비즈니스대상"/></li>
                <li><img src="/resources/images/promote/img_footcate02.gif" alt="e-biz브랜드혁신대상" /></li>
                <li><a href="https://sealinfo.verisign.com/splash?form_file=fdf/splash.fdf&dn=www.koreab2b.com&lang=ko" target="_blank"><img src="/resources/images/promote/img_footcate03.gif" alt="" ></a></li>
            </ul>
        </div>
    </div>
