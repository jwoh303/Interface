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
            <div class="subbannerimg"><img src="/resources/images/2016/SB09.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Construction MRO Introduction</p>
            	<p>Please, meet the service of KeP which provides competitive value.</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li>MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li>Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li  class="subtabOn">Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li>Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li>Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li >Distribution<br/>Center</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_intergrated">
            "We present the most competitive service in construction MRO market through whole country vendor network <br/>and price competitiveness which is based on whole distribution business."<br/><br/><br/><br/>
             <p class="subcontentTit" >Construction MRO Business Model</p>
             <div class="CmroList"  style="position:relative; margin-top:20px; margin-bottom:60px;">
                <ul>
                  <li style="width:1070px; background:url(/resources/images/2016/img_j12.jpg) no-repeat;background-position: -65px 0px; height:200px; margin-bottom:20px   ">
                      <p  style="margin-top:20px; margin-left:400px; text-align:left; padding:20px 30px">
                        <b style="color:#ee3212; font-size:18px; line-height:38px;">Competitive Delivery Service of Network Vendors </b><br/>
                        - 83 Network Vendors cover all of construction site of whole contry<br/>
                        - Urgent PO service<br/>
                        - Manufactured product service suitable for workplace<br/>
                        - Ordinary Inventory Management
                        </p>
                  </li>
                  <li style="width:1070px; background:url(/resources/images/2016/img_j14.jpg) no-repeat top left; height:200px; margin-bottom:20px   ">
                    <p  style="margin-top:20px; margin-left:400px; text-align:left; padding:20px 30px">
                    <b style="color:#ee3212; font-size:18px; line-height:38px">Price Competitiveness</b><br/>
                    through whole distribution business <br/>Secure Price Competitiveness</p></li>
                  <li style="width:1070px; background:url(/resources/images/2016/img_j13.jpg) no-repeat top left; height:200px; margin-bottom:20px   ">
                    <p  style=" margin-top:20px;margin-left:400px; text-align:left; padding:20px 30px">
                      <b style="color:#ee3212; font-size:18px; line-height:38px">Optimized Organization and Infra</b><br/>
                       - Build system for construction market<br/>
                       - Manage organization for construstion customer<br/>
                       - 25,000 items standardized
                     </p>
                   </li>                     
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

