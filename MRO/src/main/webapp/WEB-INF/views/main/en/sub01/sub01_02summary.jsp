<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<script type="text/javascript">
</script>
</head>
<body> 
<form id="loginForm" name="loginForm" method="post">
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/en/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
   <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB03.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Overview</p>
            	<p>Platform Business Leader in B2B Market</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:EnMovePage('<%=httpurl%>','01', '02');"><li class="subtabOn">Overview</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '03');"><li>History</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '04');"><li>Vision</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '05');"><li>Directions</li></a>
                </ul>  
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
            	Korea E Platform is a B2B company which presents MRO procurement service with information technology and distribution infra.<br/>
                We present e-procurement and cost reduction through outsourcing to our customers.<br/>
                We present opportunity for our vendors to enter into new market.
            	
            	<br/><br/><br/><br/>
                
                <span style="font-size:45px; line-height:65px; height:60px; font-weight:bold; color:#ee3212">Korea e Platform Co.Ltd.</span><br/>
                <span style="font-size:20px; line-height:20px; height:30px; font-weight:bold">Korea e Platform Co.Ltd.</span><br/><br/>
                
                <div style="position:relative; background-image:url(/resources/images/2016/bg01_en.gif); width:820px; height:320px; margin:0 auto ; ">
                    <p class="summarysubcontentTit" style="position:absolute; width:230px; top:110px; left:42px" >Type of Business</p>
                    <p class="subcontentTxt02" 		style="position:absolute; width:230px; top:190px; left:42px" >Internet E-Commerce</p>
                    <p class="summarysubcontentTit" style="position:absolute; width:230px; top:95px; left:295px" >Date of <br/>Establishment</p>
                    <p class="subcontentTxt02" 		style="position:absolute; width:230px; top:190px; left:295px" >4th July, 2000</p>
                    <p class="summarysubcontentTit" style="position:absolute; width:230px; top:110px; left:548px" >Equity</p>
                    <p class="subcontentTxt02" 		style="position:absolute; width:230px; top:190px; left:548px" >43,703million won<br/>(in 2015)</p>
                </div>
                <div style="position:relative; margin-top:90px; margin-bottom:90px ">
                    <p class="subcontentTit" >Shareholder Company </p>
                    <p class="subcontentTxt02" >17 companies including Kwangdong Pharmacy, Hyundai Industrial Development, SK</p>
                    <br/><br/><br/><br/><br/><br/>
                    <p class="subcontentTit" >Contact</p>
                    <p class="subcontentTxt02" >Seoul Gangnam Post Office Bld 7th floor, Gaepo-Ro 619, Gangnam-Gu, Seoul-Si, Korea, Korea E Platform.<br/>
                    Tel : +82-2-3016-8989<br/>
                    Fax : +82-2-569-6724<br/>
                    E-mail : master@koreab2b.com</p>
                </div>
            </div>
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/en/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
	</form>
</body>
</html>

