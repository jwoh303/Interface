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
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB08.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">구매시스템</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li>MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li>부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li>건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li>해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li class="subtabOn">구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li>물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_supply">
                고객 요구를 반영한 다양한 시스템을 통해 고객사의 구매 업무를 안정적으로 지원합니다.  <br/><br/><br/>
                <p class="subcontentTit" >구매대행 시스템</p>
                <div style=" position:relative; width:1080px; height:650px;background:url(/resources/images/2016/img22.gif) no-repeat; font-size:14px" >
                	<p  style="position:absolute; left:442px;top:390px;  color:#fff; font-size:30px; font-weight:bold; line-height:40px">구매대행시스템</p>
                	<p  style="position:absolute; border:1px solid #d2d2d2; left:470px;top:90px; padding:5px 30px;background-color:#eee">Mobile System</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:455px;top:560px; padding:5px 30px;background-color:#eee">Order Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:110px;top:160px; padding:5px 30px;background-color:#eee">WMS (Warehouse Management System)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:120px;top:330px; padding:5px 30px;background-color:#eee">Customer/Supplier Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:95px; top:470px; padding:5px 30px;background-color:#eee">DMS (Decision Support System)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:730px;top:470px; padding:5px 30px;background-color:#eee">Sourcing Management</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:720px;top:330px; padding:5px 30px;background-color:#eee">VOC (Voice Of Customer)</p>
                    <p  style="position:absolute; border:1px solid #d2d2d2; left:675px;top:160px; padding:5px 30px;background-color:#eee">CMS (Catalogue Management System)</p>
                </div>
				<div style="position:relative; margin:0 auto; height:330px;color:#fff; font-size:15px; text-align:center; line-height:22px ">
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:0px; height:80px;text-align:center;color:#ee3212" >
                    <b class="subcontentTxt03" style="line-height:80px;">Stability (안정성)</b></p>
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:360px; height:80px;text-align:center;color:#ee3212" > 
                   <b class="subcontentTxt03" style="line-height:80px;">Usability(편리성)</b> </p>
                    <p style="position:absolute; background-color:#eee; border:1px solid #e5e5e5; border-top:2px solid #ee3212;width:350px;left:720px; height:80px;text-align:center;color:#ee3212" >
                     <b class="subcontentTxt03" style="line-height:80px;">Flexibility(유연성)</b></p>
                     
                    <p style="position:absolute; width:350px; left:0px; top:195px; height:20px; font-size:13px; color:#333; text-align:left" >※ ISMS : Information Security Management System  </p>
                    
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; border:1px solid #e5e5e5; width:350px; left:0px; top:81px; height:110px;" >
                    <br/> 이중화 구성 및 Backup 시스템 구축을 통해 <br/>안정적인 운영을 지원하며,ISMS 인증 획득을 통해<br/> 보안체계도 강화하였습니다.<br/> </p>
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; width:352px; left:360px;top:81px; height:110px;" >
                    <br/>구매에 필요한 다양한 기능 및 지원 시스템을 통해 <br/> 고객의 편리성을 증대합니다.</p>
                    <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#4c4d4f; width:352px; left:720px;top:81px; height:110px;" >
                    <br/>자체 IT 조직 운영을 통해 고객 요구를<br/>  최대한 반영하고 있으며, 고객사 환경에 적합한 <br/> 시스템 연계 구축을 신속히 지원합니다.<br/> </p>
				</div>
                <p class="subcontentTit" >시스템연계</p>
                다양한 구축 경험을 바탕으로 고객사 시스템 환경에 적합한 연계 구축이 가능하며,<br/>전문 연계시스템 사용을 통해 고객사에서도 편리하게 구축할 수 있도록 지원합니다. <br/><br/>

                <div class="recruiList" style="position:relative; margin-top:30px; ">
                 <ul>
                  <li style="width:150px;background:url(/resources/images/2016/m16.png) no-repeat;"><p style="font-weight:bold; padding-top:60px; width:150px; height:152px; font-size:22px; color:#fff; background-image:url(/resources/images/2016/dot03.png)">시스템연계 <br/>절차</p></li>
                  <li style="width:50px;"><img src="/resources/images/2016/img16.gif" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:18px; color:#fff;background-image:url(/resources/images/2016/dot03.png); line-height:25px"><br/><br/>고객사 시스템 <br/>파악</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:18px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:23px"><br/><br/>전송방식/<br/>레이아웃 <br/>협의</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:18px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:25px"><br/><br/>프로그램 <br/>개발</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:18px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:25px"><br/><br/>테스트 및 <br/>보완</p></li>
                  <li style="width:30px;"><img src="/resources/images/2016/arrow11.png" /></li>
                  <li style="width:140px;background:url(/resources/images/2016/img23.gif) no-repeat center;"><p style="font-weight:bold;height:148px;font-size:18px; color:#fff;background-image:url(/resources/images/2016/dot03.png);line-height:25px"><br/><br/>오픈 및 <br/>모니터링</p></li>                  
                 </ul>
                </div>
                <div class="SystemList"  style="position:relative; height:150px; min-height:150px; margin-bottom:150px; ">
                    <ul>
                      <li style="width:170px; background-color:#ee3212; background-image:url(/resources/images/2016/dot03.png)" >
                      	<p style="font-weight:bold; font-size:22px; color:#fff; line-height:30px; padding:70px 20px  ">시스템연계  <br/>사례</p>
                      </li>
                      <li style="width:295px">
                        <p style="font-size:30px; font-weight:bold; padding:15px 30px 8px 30px; line-height:26px ">ERP <br/><span style="font-size:15px">(SAP R3, Oracle, 기타)</span></p>
                        <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px 10px">
                        한화에어로스페이스, 효성중공업, <br/>넥센타이어, 롯데알미늄, 금호석유화학,<br/>유한킴벌리, 동화기업, 빙그레,<br/> 하이트 진로, 애경케미칼, 한샘 등</p>
                      </li>
                      <li style="width:295px">
                        <p style="font-size:30px; font-weight:bold; padding:30px">e-Procurement</p>
                        <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px 20px 40px 20px">삼성전자, 남양유업, SK마이크로윅스, <br/> SK피유코어, 한국에스지에스, <br/> 셰플러코리아, HK이노엔, OB맥주 등</p>
                      </li>
                      <li style="width:295px">
                        <p style="font-size:30px; font-weight:bold; padding:30px">Legacy</p>
                        <p style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:20px 20px 40px 20px">삼양사, 한림제약, 조선호텔, 솔브레인, <br/> 롯데푸드, 한컴라이프케어, <br/> 에스앤티 모티브 등</p>
                      </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>

