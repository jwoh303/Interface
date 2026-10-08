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
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB11.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Recruitment</p>
            	<p>Seek advanced and competent personnel.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','03', '01');"><li>Qualification for Talented Person</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '02');"><li>Personnel Management System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '03');"><li class="subtabOn">Recruitment Information</li></a>
                </ul>     
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            KeP, the leader in MRO's purchasing business, <br/>is an enterprising and competent person to create a vision of <br/>"platform business leader." Recruitment of talent.<br/><br/><br/><br/>
            <p class="subcontentTit" >Recruitment procedure</p>
            <div class="recruiList" style="position:relative; margin-top:20px; margin-bottom:150px;z-index:1">
             <ul>
              <li style="width:162px;"><img src="/resources/images/2016/img04.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step1.<br/></span> Apply reception</p></li>
              <li style="width:10px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li style="width:162px;"><img src="/resources/images/2016/img05.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step2.<br/></span> Documentary type</p></li>
              <li style="width:10px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li style="width:162px;"><img src="/resources/images/2016/img06.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step3.<br/></span> 1st interview</p></li>
              <li style="width:10px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li style="width:162px;"><img src="/resources/images/2016/img06.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step4.<br/></span> 2nd interview</p></li>
              <li style="width:10px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li style="width:165px;"><img src="/resources/images/2016/img07.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step5.<br/></span> Health examination</p></li>
              <li style="width:10px;"><img src="/resources/images/2016/arrow12.png" /></li>
              <li style="width:162px;"><img src="/resources/images/2016/img07_.gif" /></br></br><p class="subcontentTxt02" style="line-height:20px"><span style="color:#ee3212">step6.<br/></span> Final qualifying</p></li>
             </ul>             
            </div>
            <p style="position:absolute; top:322px; left:0px; height:1px; background-color:#e5e5e5; width:1080px; z-index:0"></p>
            <p class="subcontentTit" >Apply at all times</p>
           	If you apply for the hope field, we will review you first. <br/><br/>
            <p class="recruitBtn" style="margin-bottom:40px;"><a href="/resources/excel/work/MAIN/KeP.docx">Download resume  </a></p>
            <table  class="recruittable" style="margin-bottom:100px;">
                 <colgroup>
                  <col width="30%" />
                  <col width="70%" />
                  </colgroup>
                <tr>
                    <th >Receipt Method</th>
                    <td align="left" >Online, e-mail only, e-mail : keprecruit@koreab2b.com </td>
                </tr>
                <tr>
                    <th >Submission document</th>
                    <td align="left" >
                        - A resume, A letter of self-introduction</br>
                        - Description form of career(experienced only)</br>
                    </td>
                </tr>
                <tr>
                    <th >Questions</th>
                    <td align="left" >Personnel development team recruiter(+82-2-3016-8994)</td>
                </tr>
            </table>
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

