<%--
**********************************************
* 메뉴 : 
* 화면 :  물류센터 안내 이미지 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
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

<%@ include file="../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
  <style>
    .wrapPopup .PopupTit{font-size:30px;margin-bottom:15px;}
    .logisticsTB{ border:0px}
    .logisticsTB td{ vertical-align:top ;}
    .logisticsTB td:nth-child(2){ text-align:right ; }
    .logisticsTB td:nth-child(2) img{ width: 480px; border-radius: 10px;}
    .center-item {padding:15px 0;border-bottom:1px solid #e5e5e5; }
    .center-item:first-child{border-top:1px solid #e5e5e5; }
    .center-item h3 {font-size: 18px;font-weight: 700; letter-spacing: 0rem;color:#24252b;margin-bottom:3px;}
    .center-item ul {list-style:none;}
    .center-item li {font-size: 16px;font-weight:300;line-height:22px;letter-spacing:-0.5px; color:#666;}
    .center-item li:first-child{color:#24252b;font-weight:500;}
    .center-item strong {display:inline-block;font-weight:300;  }
  </style>
<div class="wrapPopup">
  <div class="PopupTit">물류센터안내<span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="logisticsTB" width="1050px" >  
  	<tr>      
      <td width="530px" >
        <div class="center-item">
          <h3>중앙HUB</h3>
          <ul>
            <li>경기도 군포시 번영로 82-22 군포복합물류터미널 I동 1층 동관(도크 6~8) (※알파벳 I동임)</li>
            <li><strong>T.</strong> 031-8061-8051~3  &nbsp;&nbsp; <strong>F.</strong> 031-462-8612</li>
          </ul>
        </div>
        <div class="center-item">
          <h3>대전센터</h3>
          <ul>
            <li>충북 청주시 서원구 현도면 선동리 116-5</li>
            <li><strong>T.</strong> 043-264-1248  &nbsp;&nbsp;  <strong>F.</strong> 043-263-1248</li>
          </ul>
        </div>
        <div class="center-item">
          <h3>구미센터</h3>
          <ul>
            <li>경북 칠곡군 석적읍 중지리 12-1</li>
            <li><strong>T.</strong> 054-972-5616  &nbsp;&nbsp;  <strong>F.</strong> 054-972-5618</li>
          </ul>
        </div>
        <div class="center-item">
          <h3>창원센터</h3>
          <ul>
            <li>경남 창원시 의창구 팔용동 39-8</li>
            <li><strong>T.</strong> 055-270-6227~9  &nbsp;&nbsp; <strong>F.</strong> 055-270-6222</li>
          </ul>
        </div>
        <div class="center-item">
          <h3>광주센터</h3>
          <ul>
            <li>광주광역시 광산구 하남산단 10번로 48 (에이치로지스)</li>
            <li><strong>T.</strong> 062-955-8502  &nbsp;&nbsp; <strong>F.</strong> 062-955-8503</li>
          </ul>
        </div>   
        <div class="center-item">
          <h3>수출검수</h3>
          <ul>
            <li>경북 구미시 산동읍 봉산리 226번지 코리아e플랫폼 수출검수센터</li>
            <li><strong>T.</strong> 054-977-0244  &nbsp;&nbsp; <strong>F.</strong> 070-4369-6219</li>
          </ul>
        </div>
      </td>
      <td width="520px" ><img src="/resources/imgs/logistics.jpg" /></td>
    </tr>
  </table>
  </div><!-- warp 끝-->


 
</body>
</html>
