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
            <div class="subbannerimg"><img src="/resources/images/2016/SB14.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">인재상</p>
            	<p>진취적이고 역량 있는 인재를 모집합니다.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '04');"><li class="subtabOn">인재상</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '05');"><li >인사제도</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '06');"><li >채용정보</li></a>
                </ul>   
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            
            <p class="subcontentTit" >코리아e플랫폼 인재상</p>
            
            <div style="position:relative; height:700px;" >
                <table  class="recruittable05" style="margin-bottom:100px; ">
                     <colgroup>
                      <col width="50%" />
                      <col width="50%" />
                      </colgroup>
                    <tr>
                        <td height="320" style="border-right:solid 1px #cdcdcd; background-color:#dae2da" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:30px; margin-bottom:20px; padding-top:40px"><img src="/resources/images/2016/index_img11.png" style="margin-bottom:10px" /></br>주인의식</p> 
                            맡은 일은 스스로 책임지고</br> 끝까지 해내고자 하는 마음가짐
                         </div>
                        </td>
                        <td height="320" style="border-right:solid 1px #cdcdcd; background-color:#eadcdc" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:30px; margin-bottom:10px; padding-top:40px"><img src="/resources/images/2016/index_img09.png" style="margin-bottom:10px" /></br>도전과 열정</p> 
                        	끊임없는 도전과 노력으로 조직을 변화시키고</br> 회사의 발전을 도모함
                          </div>
                        </td>
                    </tr>
                    <tr>
                        <td style=" background-color:#d9d9e3" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:30px; margin-bottom:20px; padding-top:40px"><img src="/resources/images/2016/index_img10.png" style="margin-bottom:10px" /></br>소통과 협력</p> 
                            배려와 경청하는 마음자세로 성과창출 및 </br>동반성장을 이룰 수 있도록 노력함
                         </div>
                        </td>
                        <td style=" background-color:#e4e4e4" >
                         <div style="width:100%; height:320px;  background:url(/resources/images/2016/br07.gif) ;font-size:16px;">
                            <p style="color:#ee3212; font-weight:bold; font-size:30px; margin-bottom:20px; padding-top:40px"><img src="/resources/images/2016/index_img12.png" style="margin-bottom:10px" /></br>신뢰와 감동</p>
                             고객과의 상호 신뢰를 넘어 </br>고객감동을 이끌어 낼 수 있도록 노력함
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
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>

