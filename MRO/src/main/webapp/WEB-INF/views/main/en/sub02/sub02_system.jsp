<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/en/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB08.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Procurement System</p>
            	<p>Please meet the service of KeP which provides competitive value</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li>MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li>Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li>Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li>Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li class="subtabOn">Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li>Distribution<br/>Center</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_supply">
                We support procurement work stably through diverse system which reflects customer's demand.  <br/><br/><br/>
                <p class="subcontentTit" >Procurement Agency System</p>
                <div style=" position:relative; width:1080px; height:650px;background:url(/resources/images/2016/img22_en.gif) no-repeat; font-size:14px" >
                	<p  style="position:absolute; left:458px;top:390px;  color:#fff; font-size:25px; font-weight:bold; line-height:25px; letter-spacing:-1px">Procurement<br/>Agency System</p>
                	<p  style="position:absolute; border:1px solid #d2d2d2; left:390px;top:135px; padding:5px 30px;background-color:#eee">Auction</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:470px;top:50px; padding:5px 30px;background-color:#eee">Mobile System</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:600px;top:120px; padding:5px 30px;background-color:#eee">Order Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:110px;top:220px; padding:5px 30px;background-color:#eee">WMS (Warehouse Management System)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:120px;top:350px; padding:5px 30px;background-color:#eee">Customer/Supplier Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:95px;top:490px; padding:5px 30px;background-color:#eee">DMS (Decision Support System)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:390px;top:560px; padding:5px 30px;background-color:#eee">SRM (Supplier Relationship Management)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:680px;top:480px; padding:5px 30px;background-color:#eee">Sourcing Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:720px;top:350px; padding:5px 30px;background-color:#eee">VOC (Voice Of Customer)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:675px;top:220px; padding:5px 30px;background-color:#eee">CMS (Catalogue Management System)</p>
                </div>
                <div style="position:relative; margin:0 auto; height:330px;color:#fff; font-size:15px; text-align:center; line-height:22px ">
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:0px; height:80px;text-align:center;color:#ee3212" >
                    <b class="subcontentTxt03" style="line-height:80px;">Stability</b></p>
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:360px; height:80px;text-align:center;color:#ee3212" > 
                   <b class="subcontentTxt03" style="line-height:80px;">Usability</b> </p>
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:720px; height:80px;text-align:center;color:#ee3212" >
                     <b class="subcontentTxt03" style="line-height:80px;">Flexibility</b></p>
                    <p style="position:absolute; width:350px; left:0px; top:195px; height:20px; font-size:13px; color:#333; text-align:left" >※ ISMS : Information Security Management System  </p>
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; border:1px solid #e5e5e5; width:350px; left:0px; top:81px; height:110px;" >
                    <br/> 이중화 구성 및 Backup 시스템 구축을 통해 <br/>안정적인 운영을 지원하며,ISMS 인증 획득을 통해<br/> 보안체계도 강화하였습니다.<br/> </p>
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; width:352px; left:360px;top:81px; height:110px;" >
                    <br/>We increase customer's convenience through <br/>diverse function and support system which<br/> are needed in procurement</p>
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; width:352px; left:720px;top:81px; height:110px;" >
                    <br/>We reflect customer's needs through our <br/>own  IT team, and we support system conne-<br/>ction suitable for customer's circumstance.</p>
				</div>
                <p class="subcontentTit" >system connection</p>
                It's possible to make system suitable for customer's system circumstance with diverse system development experience,<br/>
                and we support customer to develop system through specialized connection system.<br/><br/>
                <div class="recruiList" style="position:relative; margin-top:30px; ">
                 <ul>
                  <li style="width:150px;background:url(/resources/images/2016/m16.png) no-repeat;"><p style="font-weight:bold; padding-top:40px; width:150px; height:152px; font-size:22px; color:#fff; background-image:url(/resources/images/2016/dot03.png)">
                  system<br/>connection<br/>procedure</p></li>
                  <li style="width:50px;"><img src="/resources/images/2016/img16.gif" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:16px; color:#fff;background-image:url(/resources/images/2016/dot03.png); line-height:18px">
                  <br/><br/><br/>customer<br/>system check</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:16px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:18px">
                  <br/><br/> transmission<br/>method / <br/>layout<br/>colsultation</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:16px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:18px">
                  <br/><br/><br/>program<br/>development</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:16px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:18px">
                  <br/><br/><br/>B2Bi Adapter<br/>installation</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:16px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:18px">
                  <br/><br/><br/>test and<br/>supplemen-<br/>tation</p></li>                  
                 </ul>
                </div>
                <div class="SystemList"  style="position:relative; height:150px; min-height:150px; margin-bottom:150px; ">
                    <ul>
                      <li style="width:170px; background-color:#ee3212; background-image:url(/resources/images/2016/dot03.png)" >
                      	<p style="font-weight:bold; font-size:22px; color:#fff; line-height:30px; text-align:center;height:222px "><br/><br/>system <br/>connection<br/>example</p></li>
                      <li style="width:295px">
                          <p style="font-size:30px; font-weight:bold; padding:30px">SAP R3</p>
                          <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px; height:100px">
                          Kolon,  Schaeffler Korea,<br/>Daewoo Shipbuilding & Marine <br/>Engineering, Coway,<br/>Hyosung Heavy Industries, <br/>Korea Aerospace Industries</p></li>
                      <li style="width:295px">
                          <p style="font-size:30px; font-weight:bold; padding:30px">Oracle ERP</p>
                          <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px; height:100px">Iljin Electric, Changsung, Binggrae,<br/>Hite Jinro, Hankuk Paper</p></li>
                      <li style="width:295px;">
                          <p style="font-size:30px; font-weight:bold; padding:30px">Legacy</p>
                          <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px; height:100px">Samyang Corporation,<br/>Ilshin Spinning, Kyungbang,<br/>Yudo, S&T Heavy Industries,
                          <br/>Hwaseung Networks</p></li>
                     </ul>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
    <!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
    <%@ include file="/WEB-INF/views/common/include/en/mainFooter.jsp" %>
    <!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>

