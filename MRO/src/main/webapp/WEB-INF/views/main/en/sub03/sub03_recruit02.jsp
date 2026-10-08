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
            <div class="subbannerimg"><img src="/resources/images/2016/SB21.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Personnel Management System</p>
            	<p>Seek advanced and competent personnel.</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList03">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','03', '01');"><li>Qualification for Talented Person</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '02');"><li class="subtabOn">Personnel Management System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','03', '03');"><li >Recruitment Information</li></a>
                </ul>
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_recruit">
            <p class="subcontentTit" >Performance Based Culture</p>
            <div style="position:relative">
                <table  class="recruittable02" style="margin-bottom:150px;">
                     <colgroup>
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      </colgroup>
                    <tr>
                        <th height="120px" >Performance Management</br> System</th>
                        <th style="background:#eeeeee" >Personnel Evaluation</br>System</th>
                        <th >Basic Annual Salary </br>System</th>
                        <th style="background:#eeeeee">Incentive System</th>
                    </tr>
                    <tr>
                        <td style="vertical-align:top" >A performance management process that establishes a link between an employee's individual goal and the company's business objectives for the achievement of the company's vision and strategic execution</td>
                        <td style="background:#eeeeee;vertical-align:top" >Assessment of achievement based on individual and department performance objectives, check job competency, and utilize it in personnel management, such as compensation and placement, for transparency and fairness</td>
                        <td style="vertical-align:top">A basic annual salary system that is common to all employees based on performance</td>
                        <td style="background:#eeeeee;vertical-align:top" >Operate PS-PI-Business Combinations System as compensation system for all employees based on the company's performance and personal performance</td>
                    </tr>
                </table>                
                <p style="position:absolute; top:110px; left:115px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:390px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:660px"><img src="/resources/images/2016/br02.png" /></p>
                <p style="position:absolute; top:110px; left:930px"><img src="/resources/images/2016/br02.png" /></p>
            </div>
            <p class="subcontentTit" >Position System</p>
            <div style="position:relative;height:300px" >
                <table  class="recruittable03" style=" position:absolute;z-index:1">
                     <colgroup>
                      <col width="20%" />
                      <col width="20%" />
                      <col width="20%" />
                      <col width="20%" />
                      <col width="20%" />
                      </colgroup>
                    <tr>
                        <td height="180px" style="background:url(/resources/images/2016/m21.png) no-repeat center" >Associate</td>
                        <td style="background:#eeeeee;background:url(/resources/images/2016/m20.png) no-repeat center; line-height:20px" >Assistantt</br> Manager</td>
                        <td style="background:url(/resources/images/2016/m21.png) no-repeat center">Manager</td>
                        <td style="background:#eeeeee;background:url(/resources/images/2016/m20.png) no-repeat center; line-height:20px">Senior</br>Manager</td>
                        <td style="background:url(/resources/images/2016/m21.png) no-repeat center; line-height:20px">General</br>Manager</td>
                    </tr>
                </table>
                <p style="position:absolute; top:75px; left:193px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:75px; left:412px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:75px; left:628px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:75px; left:842px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:91px; left:0px; height:1px; background-color:#cdcdcd; width:1080px; z-index:0"></p>
                <p style="position:absolute; top:165px; left:60px; z-index:1; font-size:15px">※ Based On General Personnel</p>
            </div>
            <p class="subcontentTit" >Evaluation/Compensation</p>
            <div style="position:relative;background:url(/resources/images/2016/sub_bg01.jpg)">
                <table  class="recruittable04" style="margin-bottom:150px;">
                     <colgroup>
                      <col width="20%" />
                      <col width="20%" />
                      <col width="30%" />
                      <col width="30%" />
                      </colgroup>
                    <tr>
                        <th  rowspan="2" style=" background-color:#e5e5e5; border-right:1px solid #fff;border-top:3px solid #4b4948;border-bottom:1px solid #707070; color:#1b1b1b;background-image:url(/resources/images/2016/dot03.png);font-size:18px; padding:0 35px" >
                        The continuous growth of the company and its employees</th>
                        <th  rowspan="2" style="background:#FFF;border-top:3px solid #ee3212;border-bottom:1px solid #707070;font-size:18px; color:#ee3212; padding:0 35px" >Employee Satisfaction  and Motivation</th>
                        <td height="170px" style=" border-right:1px solid #707070;border-bottom:1px solid #707070; ;color:#FFF;line-height:22px;border-top:3px solid #4b4948; padding:0 35px">
                        Securing transparency and fairness through evaluation processes such as goal building, intermediate inspection, evaluation, and compensation reflection </td>
                        <td  style="border-bottom:1px solid #707070;color:#FFF;line-height:22px;border-top:3px solid #4b4948; padding:0 35px">
                        Accurate final evaluation of the performance process and results </td>
                    </tr>
                    <tr>
                        <td height="170px" style="border-right:1px solid #707070;color:#FFF;line-height:22px;border-bottom:1px solid #707070; padding:0 35px">Accumulated salary increase based on evaluation results (a structure where salary increases according to performance level and ability level) </td>
                        <td style="color:#FFF;line-height:22px;border-bottom:1px solid #707070; padding:0 35px"  >Performance bonus (PS) payment according to management performance by reflecting the final evaluation results in the promotion review, annual salary increase, and variable payment (PI)</td>
                    </tr>
                </table>                
                <p style="position:absolute; top:156px; left:195px; z-index:1"><img src="/resources/images/2016/arrow04.png" /></p>
                <p style="position:absolute; top:156px; left:410px; z-index:1"><img src="/resources/images/2016/arrow02.png" /></p>
            </div>
            <p class="subcontentTit" >Fostering Talented Person</p>
            <div style="position:relative;">
                <table  class="recruittable04" style="margin-bottom:150px">
                     <colgroup>
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      <col width="25%" />
                      </colgroup>
                    <tr>
                        <th height="70px" style="background:#ee3212;background-image:url(/resources/images/2016/dot03.png); border-right:1px solid #999898; color:#FFF">Core Value</th>
                        <th style="background:#707070;background-image:url(/resources/images/2016/dot03.png);border-right:1px solid #999898; color:#FFF" >Promoting Leaders</th>
                        <th style="background:#ee3212;background-image:url(/resources/images/2016/dot03.png);border-right:1px solid #999898; color:#FFF">Key Human Resources</th>
                        <th style="background:#707070;background-image:url(/resources/images/2016/dot03.png);color:#FFF">A Job Expert</th>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;line-height:22px" >Training process to strengthen sharing of key values within the company and develop basic skills for full-time employees </td>
                        <td style="background:#eeeeee;vertical-align:top;line-height:22px" >Developing knowledge and skills necessary to improve leadership and skills required for each tier of work </td>
                        <td style="vertical-align:top;line-height:22px">Maintaining and developing core competencies for continuous growth by organizing differentiated curriculum </td>
                        <td style="background:#eeeeee;vertical-align:top;line-height:22px" >E-learning and external education required to foster job expertise</td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top; text-align:left" >- Internalize Core Value </br>- Activating An Organization  </br>- Special Lecture On Change Innovation</td>
                        <td style="background:#eeeeee;vertical-align:top; text-align:left" >- Manager Leadership Process </br> - Performance Management Process  </br> - Consultative Selling skills</td>
                        <td style="vertical-align:top; text-align:left">- External MBA Consigned Process</td>
                        <td style="background:#eeeeee;vertical-align:top; text-align:left" >- PM Capacity improvement Process </br>- Negotiation Process  </br>  - Strategic Purchase Process</td>
                    </tr>
                </table>                
                <p style="position:absolute; top:200px; left:115px"><img src="/resources/images/2016/br01.png" /></p>
                <p style="position:absolute; top:200px; left:390px"><img src="/resources/images/2016/br03.png" /></p>
                <p style="position:absolute; top:200px; left:660px"><img src="/resources/images/2016/br01.png" /></p>
                <p style="position:absolute; top:200px; left:930px"><img src="/resources/images/2016/br03.png" /></p>
            </div>
            <p class="subcontentTit" >Benefits</p>
            <p style="position:relative;left:0px; height:2px; background-color:#4b4948; width:1080px; z-index:0"></p>
            <table  class="recruittable05" style="margin-bottom:100px;border-top:solid 3px #4b4948; ">
                 <colgroup>
                  <col width="20%" />
                  <col width="30%" />
                  <col width="50%" />
                  </colgroup>
                <tr>
                    <td style="border-right:1px solid #e5e5e5; text-align:center" ><img src="/resources/images/2016/index_img055.png" /></td>
                    <th style="border-right:1px solid #e5e5e5;" >Support For The Safety </br>Of lLiving</th>
                    <td style="text-align:left; padding-left:30px" >- Support For Children's Education</br>- Operation of Employee Association</br>- A House Loan</td>
                </tr>
                <tr>
                    <td style="border-right:1px solid #e5e5e5; text-align:center" ><img src="/resources/images/2016/index_img08.png" /></td>
                    <th style="border-right:1px solid #e5e5e5;" >Family friendship system</th>
                    <td style="text-align:left; padding-left:30px" >- Sending anniversary cake</br>- Implementation of Health Examination</br> - FamilyDay Enforcement</td>
                </tr>
                <tr>
                    <td style="border-right:1px solid #e5e5e5; text-align:center" ><img src="/resources/images/2016/index_img07.png" /></td>
                    <th style="border-right:1px solid #e5e5e5;" >Free time/Leisure support</th>
                    <td style="text-align:left; padding-left:30px" >- Support for in-house club activities</br> - Support for resorts and condominiums</br>- A trip abroad for outstanding employees</br>- A workshop/year-end party/foundation celebration</td>
                </tr>
                <tr>
                    <td style="border-right:1px solid #e5e5e5; text-align:center" ><img src="/resources/images/2016/index_img066.png" /></td>
                    <th style="border-right:1px solid #e5e5e5;" >Other Benefits</th>
                    <td style="text-align:left; padding-left:30px" > - Long-term worker reward</br>- Gift payment (National Holiday/foundation Day)</br>- Expenditure and Vacation for congratulations and condolences</td>
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

