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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB02.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Vision</p>
            	<p>Platform Business Leader in B2B Market</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:EnMovePage('<%=httpurl%>','01', '02');"><li>Overview</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '03');"><li>History</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '04');"><li class="subtabOn">Vision</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '05');"><li>Directions</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
                <div style="position:relative; margin-bottom:90px ">
                    <p class="subcontentTit" >Mission</p>
                    <p style="color:#ee3212; font-weight:bold;font-size:34px;line-height:45px;letter-spacing:-1px" >We support competitivenss of <br/> our customers through new value.</p>
                    <br/>
                    <br/><br/><br/><br/>
                    <p class="subcontentTit" >Vision</p>
                    <p style=" font-weight:bold; font-size:34px; height:235px; line-height:45px; color:#ee3212; letter-spacing:-1px" >Platform Business Leader in B2B Market<br/>
                    <img src="/resources/images/2016/img03.gif" /><br/><br/> </p>
                    <p class="subcontentTxt01" >We keep doing our role as Platform Business Leader to provide value to the<br/>
                      customers through Procurement Specialty, Standardized Item Information, IT/Distribution Infra.</p>
                    <br/><br/><br/><br/><br/>
                	<p class="subcontentTit" >Core Capablity</p>
                    <table  class="tableCoreCapablity">
                        <tr>
                            <th width="35%" >Competitive Procurement Speciality</th>
                            <td width="65%" align="left" >
                                To get item knowledge, supply chain management, cost competitiveness which are over customer's expectation,
                                we analyze the market of manufacturing and distribution, secure excellent vendor pool, and use diverse procurement method on TCO(Total Cost of Ownership).</td>
                        </tr>
                        <tr>
                            <th >Efficient Management Leadership</th>
                            <td align="left" >
                                To make low cost, high efficiency, and expandable platform business, we enhance business efficiency through IT management, and systematize business model like coustruction distribution model.
                            </td>
                        </tr>
                        <tr>
                            <th >Strong Customer Partnership</th>
                            <td align="left" >
                                Despite market fluctuation expansion and keen market competition, we contribute customer's satisfaction and expand service range to maintain long term relationship with customers.
                            </td>
                        </tr>
                        <tr>
                            <th >Information Standardization</th>
                            <td align="left" >
                            	To use diverse information of business management effectively, we standardize catalog, supply chain management, and contract information and capitalize predictable information through analysis of delivery.
                            </td>
                        </tr>
                    </table>
                    <br/><br/><br/><br/><br/>
                	<p class="subcontentTit" >Core Value</p>
                    <div style="position:relative; margin:0 auto; height:450px;color:#fff; font-size:15px;text-align:center; line-height:22px ">
                        <p style="position:absolute;background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:270px; height:150px;text-align:center; line-height:18px;" > <br/><br/> 
                        <img src="/resources/images/2016/img01.png" /></p>
                        <p style="position:absolute;background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:540px; height:150px;text-align:center; line-height:20px" > <br/><br/> 
                        <img src="/resources/images/2016/img02.png" /></p>
                        <p style="position:absolute;background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:0px; height:150px;text-align:center; line-height:20px" > <br/><br/> 
                        <img src="/resources/images/2016/img03.png" /></p>
                        <p style="position:absolute;background-color:#eeeeee; border:1px solid #e5e5e5; border-top:2px solid #4b4948; width:263px; left:810px; height:150px;text-align:center; line-height:20px" > <br/><br/> 
                        <img src="/resources/images/2016/img04.png" /></p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:265px;left:0px;top:151px;height:300px;" ><br/><br/>
                        <span class="CoreValueTxt03">Sense of Ownership <br/>for Responsibility</span><br/> <br/>
                        Sympathy for Vision and <br/>Awareness for My Role<br/><br/> 
                        Active Thinking and <br/>Leading Attitude</p>
                        <p style="position:absolute;background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:263px; left:270px;top:151px; height:300px; border:1px solid #e5e5e5; " ><br/><br/>
                        <span class="CoreValueTxt03">Endless Challenge <br/>and Passion</b></span> <br/> <br/>
                        Endless Attempt for <br/> Goal Achievement<br/><br/>  
                        Ehthusiastic Heart<br/> for me and company</p>
                        <p style="position:absolute; background:url(/resources/images/2016/dot03.png); background-color:#ee3212; width:265px; left:540px;top:151px; height:300px;" ><br/><br/>
                        <span class="CoreValueTxt03">Communication and <br/>Cooperation within the <br/>company and outside<br/> the company</b></span> <br/> <br/>
                        Consideration and Listening <br/> courteously for other party<br/><br/>  
                        Creation of Outcome through <br/> internal and external cooperation</p>
                        <p style="position:absolute;background:url(/resources/images/2016/dot03.png);background-color:#ee3212;width:265px;left:810px;top:151px; height:300px;" > <br/><br/>
                        <span class="CoreValueTxt03">Trust and Impression <br/>for Customer</b></span> <br/> <br/>
                        Continuous Provision <br/> of Customer Value<br/> <br/> 
                        Suggest Solution<br/>  more than expected</p>
                    </div>
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
