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
            <div class="subbannerimg"><img src="/resources/images/2016/SB14.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Qualification for Talented Person</p>
            	<p>Seek advanced and competent personnel.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','03', '01');"><li class="subtabOn">Qualification for Talented Person</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '02');"><li >Personnel Management System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '03');"><li >Recruitment Information</li></a>
                </ul> 
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            <p class="subcontentTit" >Qualification for Talented Person of Korea E Platform</p>
            <div style="position:relative; height:700px;" >
                <table  class="recruittable05" style="margin-bottom:100px; ">
                     <colgroup>
                      <col width="50%" />
                      <col width="50%" />
                      </colgroup>
                    <tr>
                        <td height="320" style="border-right:solid 1px #cdcdcd; background-color:#dae2da" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px; padding:0 20px">
                            <p style="color:#ee3212; font-weight:bold; font-size:25px; margin-bottom:10px; padding-top:40px"><img src="/resources/images/2016/index_img11.png" style="margin-bottom:10px" /></br>The Sense Of Ownership</p> 
                            A willingness to take responsibility <br/>for one's work and carry it through
                         </div>
                        </td>
                        <td style=" background-color:#d9d9e3" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:25px; margin-bottom:10px; padding-top:40px"><img src="/resources/images/2016/index_img09.png" style="margin-bottom:10px" /></br>Challenge And Passion</p> 
                        	Changing the organization and promoting the development of <br/> the company through constant challenges and efforts
                          </div>
                        </td>
                        
                    </tr>
                    <tr>
                        <td height="320" style="border-right:solid 1px #cdcdcd; background-color:#eadcdc" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:25px; margin-bottom:10px; padding-top:40px"><img src="/resources/images/2016/index_img10.png" style="margin-bottom:10px" /></br>Communication And Cooperation</p> 
                            Efforts are made to generate performance and</br>achieve shared growth with consideration and attention
                         </div>
                        </td>
                        <td style=" background-color:#e4e4e4" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:25px; margin-bottom:10px; padding-top:40px"><img src="/resources/images/2016/index_img12.png" style="margin-bottom:10px" /></br>Trust And satisfaction</p>
                             Efforts to drive satisfaction of customer beyond mutual trust
                         </div>
                        </td>
                    </tr>
                </table>                
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

