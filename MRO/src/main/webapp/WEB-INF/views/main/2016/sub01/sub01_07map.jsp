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
 <script language="javascript"> 
function DisplayMenu(index) { 
      for (i=1; i<=9; i++) 
      if (index == i) { 
      thisMenu = eval("menu" + index + ".style"); 
      thisMenu.display = "block"; 
      } 
      else { 
      otherMenu = eval("menu" + i + ".style"); 
      otherMenu.display = "none"; 
      } 
      } 
</script> 
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f8351b36b3efadbdc48b032994eadc6a"></script>
   <!--컨텐츠-->
    <div class="subcontentsArea">
      <div class="subbanner" >
        <div class="subbannerimg"><img src="/resources/images/2016/SB04.jpg" /></div>
        <div class="subbannertxt" >
          <p class="sbtit">오시는길</p>
          <p>B2B시장의 플랫폼 비즈니스 리더</p>
        </div>
        <div class="subbannerbg" > </div>
      </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li>CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li>개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li>연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li>비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li>공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li class="subtabOn">오시는길</li></a>
                </ul>   
            </div>
        </div>
        <div class="subcontent">
			<iframe name="kepmap" id="kepmap" frameborder="0" framespacing="0" marginheight="0" marginwidth="0" scrolling="no" vspace="0"
             style="width:100%;   height:721px;   border-right:1px solid #cdcdcd;" src="/main/sub01/kep_map.do"></iframe>    
        </div>
    </div>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
</body>
</html>

