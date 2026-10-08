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
            <div class="subbannerimg"><img src="/resources/images/2016/SB05.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">MRO Procurement Service</p>
            	<p>Please, meet the service of KeP which provides competitive value.</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li class="subtabOn">MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li>Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li>Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li>Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li>Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li >Distribution<br/>Center</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_Bmodel">
                We, Korea e Platform presents MRO Procurement Service through procurement specialty<br/> and sourcing infra to many company which represent Korea.<br/><br/><br/><br/>
                <p class="subcontentTit" >MRO Feature</p>
                "MRO is an abbreviation of Maintenance, Repair, and Operation <br/>and means expendable material except raw materials and large facilities.<br/>
                MRO is difficult to manage, because, there are a lot of vendors and price is low."<br/><br/>
                <table  class="Mro01table" style="margin-bottom:80px; width:500px">
                     <colgroup>
                      <col width="30%" />
                      <col width="35%" />
                      <col width="35%" />
                      </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; background-image:url(/resources/images/2016/dot04.png); height:58px;border-right:1px solid #6c6b6b;" >Classification</th>
                        <th style="color:#fff; background:#ee3212">MRO</th>
                        <th style="color:#fff; background:#4b4948">Subsidiary<br/>Materials</th>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >The number of<br/>suppliers</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Majority</td>
                        <td >Minority</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >The number of<br/>items</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Many</td>
                        <td >Little</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Amount of PO</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Little</td>
                        <td >Many</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Importance</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Replaceable</td>
                        <td >Not replaceable</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Procurement<br/>Cost</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Low</td>
                        <td >High</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >PO Period</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212" >Not Periodic</td>
                        <td >Periodic</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Management<br/>Factor</th>
                        <td style=" border-right:1px solid #cdcdcd;color:#ee3212; line-height:18px" >Delivery Management /<br/>Process Efficiency</td>
                        <td style="line-height:18px" >Quality Management /<br/>Price Management</td>
                    </tr>
           	 	</table>
                <table  style="position:absolute;top:322px; left:530px; width:545px; margin-bottom:80px;border:1px solid #cdcdcd; font-size:13px; ">
                     <tr>
                        <td colspan="5" width="15%" height="100px" style="border-right:1px solid #cdcdcd; background:#eeeeee" ><b style="color:#ee3212;font-size:18px;">MRO Item</b><br/>
                            <p style="line-height:18px; font-weight:normal; font-size:14px; margin-top:5px;">Machine Tools, Welding Machine, Hydraulic Machine, Cutting Tools, <br/>
                            Measuring Tools, Piping Materials, Pump, Gasket, Bolt/Nut, Motor,<br/>Bearing, Office Furniture, Household Items, Safety Supplies, Office Supplies</p>
                        </td>
                    </tr>
                    <tr>
                        <td width="15%" height="110px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;line-height:18px" ><img src="/resources/images/2016/PRD15.gif" /><br/>Machine<br/>Tools</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;line-height:18px" ><img src="/resources/images/2016/PRD14.gif" /><br/>Welding<br/>Machine</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;line-height:18px" ><img src="/resources/images/2016/PRD13.gif" /><br/>Hydraulic<br/>Machine</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;line-height:18px" ><img src="/resources/images/2016/PRD12.gif" /><br/>Cutting<br/>Tools</td>
                        <td width="15%" style="border-bottom:1px solid #e5e5e5;line-height:18px" ><img src="/resources/images/2016/PRD11.gif" /><br/>Measuring<br/>Tools</td>
                    </tr>
                    <tr>
                        <td width="15%" height="100px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD10.gif" /><br/>Piping Materials</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD09.gif" /><br/>Pump</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD08.gif" /><br/>Gasket</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD07.gif" /><br/>Bolt/Nut</td>
                        <td width="15%" style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD06.gif" /><br/>Motor</td>
                    </tr>
                  <tr>
                        <td width="15%" height="100px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD05.gif" /><br/>Bearing</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD04.gif" /><br/>Office Furniture</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD02.gif" /><br/>Household Items</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD03.gif" /><br/>Safety Supplies</td>
                        <td width="15%"  style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD01.gif" /><br/>Office Supplies</td>
                    </tr>
           	 	</table>                
                <p class="subcontentTit" >Value we provide to customer</p>
                <div class="valueList"  style="position:relative; margin-top:20px; margin-bottom:110px; ">
                   <ul>
                      <li style="width:350px; background:url(/resources/images/2016/img_j01.jpg) no-repeat top; "><p  style="margin-top:240px; padding:0 30px">
                      	<b style="color:#ee3212; font-size:18px; line-height:24px">Cost Reduction on point of<br/>view with TCO</b><br/><br/>
                        "We reduce not only direct cost like purchase price, but also, indirect cost like salary, system development, maintenance, repair, and management cost.</p>
                      </li>
                      <li style="width:350px; background:url(/resources/images/2016/img_j03.jpg) no-repeat top;"><p  style="margin-top:240px; padding:0 30px">
                          <b style="color:#ee3212; font-size:18px; line-height:24px">Secure Procurement<br/>Transparency</b><br/><br/>
                           Transparent procurement management is possible through fair and transparent process and e-Sourcing system.</p>
                       </li>
                      <li style="width:355px; background:url(/resources/images/2016/img_j02.jpg) no-repeat top;"><p  style=" margin-top:240px; padding:0 28px"><b style="color:#ee3212; font-size:18px; line-height:38px">Process Efficiency</b><br/>
                        Simplify complicated tasks such as vendor management, RFQ, and closing and shorten lead time through systematic delivery management. Also work-efficiency is increased by integrated delivery service.</p>
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

