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
            <div class="subbannerimg"><img src="/resources/images/2016/SB07.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Overseas Corporation</p>
            	<p>Please, meet the service of KeP which provides competitive value.</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
                <ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li>MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li>Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li>Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li class="subtabOn">Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li>Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li >Distribution<br/>Center</li></a>
                </ul>
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_value">
                Since we established corporation in China, <br/>we present procurement service to 50 korean company and domestic company through<br/><br/><br/><br/>
                 <p class="subcontentTit" >present condition for base</p>
                 <div style="position:relative; height:800px; margin-top:0px; width:1080px;background:url(/resources/images/2016/img24.gif) no-repeat center top;border:1px solid #cdcdcd; ">
                    <p style="position:absolute; left:695px; top:270px; width:208px; height:208px; line-height:208px; font-size:12px; color:#fff; background:url(/resources/images/2016/m17.png) no-repeat; font-weight:bold">Yantai</p>
                    <p style="position:absolute; left:685px; top:420px; width:208px; height:208px; line-height:208px; font-size:12px; color:#fff; background:url(/resources/images/2016/m17.png) no-repeat;font-weight:bold">Suzhou</p>
                    <p style="position:absolute; left:840px; top:285px; width:50px; height:50px; line-height:50px; font-size:12px; color:#fff; border-radius:30px; background-color:#4b4948;z-index:1">Dalian</p>
                    <p style="position:absolute; left:804px; top:390px; width:50px; height:50px; line-height:50px; font-size:12px; color:#fff; border-radius:30px; background-color:#4b4948;z-index:1">Qingdao</p>
                    <p style="position:absolute; left:784px; top:435px; width:50px; height:50px; line-height:50px; font-size:12px; color:#fff; border-radius:30px; background-color:#4b4948;z-index:1">Nanjing</p>
                    <p style="position:absolute; left:830px; top:455px; width:50px; height:50px; line-height:50px; font-size:12px; color:#fff; border-radius:30px; background-color:#4b4948;z-index:1">Nantong</p>
                    <p style="position:absolute; left:820px; top:520px; width:50px; height:50px; line-height:50px; font-size:12px; color:#fff; border-radius:30px; background-color:#4b4948;z-index:1">영성</p>
                    <p style="position:absolute; left:100px; top:50px; line-height:45px "><img src="/resources/images/2016/m19.png" /> &nbsp;Corporate office</p>
                    <p style="position:absolute; left:320px; top:50px; line-height:45px  "><img src="/resources/images/2016/m18.png" /> &nbsp;Dispatching office</p>
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

