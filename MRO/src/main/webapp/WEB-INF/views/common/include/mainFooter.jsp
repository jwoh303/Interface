<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String fsslurl = CommonUtil.getSslURL(request, "http"); 
%>
    <div id="footWrap">
    	<div id="footer">
            <ul class="article">
                <li class="first"><a href="#" onClick="poptype02('<%=fsslurl%>');"><img src="/resources/images/main/btn_foot02.gif" alt="개인정보처리방침" /></a></li>
                <li><a href="<%=fsslurl%>/mdam/showMasterMdAmMbrcmpyReg.do"><img src="/resources/images/main/btn_foot03.gif" alt="이용약관안내" /></a></li>
                <li><a href="#" onClick="poptype01('<%=fsslurl%>');"><img src="/resources/images/main/btn_foot04.gif" alt="이메일무단수집거부" /></a></li>
                <li><a href="https://www.tradesign.net/ra/koreab2b" target="_blank"><img src="/resources/images/main/btn_foot05.gif" alt="공동인증서발급안내" /></a></li>
            	<li><a href="http://ftc.go.kr/info/bizinfo/communicationView.jsp?apv_perm_no=2015322016230203012&area1=&area2=&currpage=1&searchKey=04&searchVal=1078185880&stdate=&enddate=" target="_blank"><img src="/resources/images/main/btn_foot06.gif" alt="사업자정보확인" /></a></li>
            	<li><a href="http://www.ekdp.com/ethics/main/main.asp"  target="_blank"><img src="/resources/images/main/btn_foot07.gif" alt="사이버 신문고 제보하기" /></a></li>
            </ul>
            <address>
            서울특별시 강남구 개포로 619 서울강남우체국빌딩 7층 코리아e플랫폼 / 대표이사:오승엽 / 사업자등록번호 107-81-85880</br>
            통신판매업신고번호 2007-서울서초-10658 / 전화 02.3016.8989 / 팩스 02.569.6724 
            </address>
                <div class="FamilySite"  style="float:right; padding-right:10px; margin-top:35px ">
                	<select name="FamilySite" id="FamilySite" onChange="window.open(this.options[this.selectedIndex].value,'_blank')" style="width:150px; height:30px; padding-left:5px ">
                        <option value="">FAMILY SITE</option>
                        <option value="http://www.kepchina.com/">KePChina</option>
                        <option value="http://safety.koreab2b.com/">건설MRO</option>
<!--                         <option value="http://safety.koreab2b.com/">C-mro</option> -->
                        <option value="http://kway.koreab2b.com/jsp/index.jsp?null">Kway</option>
                        <option value="http://auction.koreab2b.com/">KepAcution</option>
                    </select>
                </div>
<!--             <ul class="footCate">
            	<li><img src="/resources/images/main/img_footcate01.gif" alt="e-비즈니스대상"/></li>
                <li><img src="/resources/images/main/img_footcate02.gif" alt="e-biz브랜드혁신대상" /></li>
                <li><a href="https://sealinfo.verisign.com/splash?form_file=fdf/splash.fdf&dn=www.koreab2b.com&lang=ko" target="_blank"><img src="/resources/images/main/img_footcate03.gif" alt="" ></a></li>
            </ul> -->
        </div>
    </div>
