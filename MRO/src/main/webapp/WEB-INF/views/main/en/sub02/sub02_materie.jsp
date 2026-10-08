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
            <div class="subbannerimg"><img src="/resources/images/2016/SB06.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Subsidiary Materials Procurement Service</p>
            	<p>Please, meet the service of KeP which provides competitive value.</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li>MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li class="subtabOn">Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li>Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li>Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li>Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li >Distribution<br/>Center</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_Bmodel">
                Korea e Platform provides purchasing service based upon capability of buying expertise and sourcing infrastructure.<br/> 
                We also provide highly effective service of strategic purchasing and procurement by constructing systematic management of MRO products and specialized subsidiaries. <br/><br/><br/><br/>
                <p class="subcontentTit" >Subsidiary Materials Characteristic</p>
                "Subsidiary Materials are important materials which don't influence quality of item and are used for manufacturing item.<br/>
                The amount of subsidiary materials is high and quality management is important."<br/><br/>

                <table  class="Mro01table" style="margin-bottom:100px; width:500px">
                     <colgroup>
                      <col width="30%" />
                      <col width="35%" />
                      <col width="35%" />
                      </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; background-image:url(/resources/images/2016/dot04.png); height:56px;border-right:1px solid #6c6b6b;" >Classification</th>
                        <th style="color:#fff; background:#ee3212">Subsidiary Materials</th>
                        <th style="color:#fff; background:#4b4948">MRO</th>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee;line-height:19px">Subsidiary<br/>Materials</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">Minority</td>
                        <td >Majority</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >The number of<br/>suppliers</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">Little</td>
                        <td >Many</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Amount of PO</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">Many</td>
                        <td >Little</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee" >Importance</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">Not replaceable</td>
                        <td >Replaceable</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Procurement<br/>Cost</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">High</td>
                        <td >Low</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >PO Period</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212">Periodic</td>
                        <td >Not Periodic</td>
                    </tr>
                    <tr>
                        <th style=" border-right:1px solid #cdcdcd; background:#eeeeee; line-height:18px" >Management<br/>Factor</th>
                        <td style="border-right:1px solid #cdcdcd;color:#ee3212; line-height:18px">Quality Management /<br/>Price Management</td>
                        <td style="line-height:18px" >Delivery Management /<br/>Process Efficiency</td>
                    </tr>
           	 	</table>
                <table  style="position:absolute;top:322px; left:530px; width:545px; margin-bottom:80px;border:1px solid #cdcdcd; font-size:14px; ">
                     <tr>
                        <td colspan="3" width="15%" height="100px" style="border-right:1px solid #cdcdcd; background:#eeeeee" ><b style="color:#ee3212;font-size:18px;">Item</b><br/>
                        <p style="line-height:18px; font-weight:normal; font-size:15px; margin-top:5px">Palette, Rack, Wood, Corrugated Paper Box, Bag, Film for Packing</p></td>
                    </tr>
                    <tr>
                        <td width="15%" height="155px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD16.gif" /><br/>Palette</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #e5e5e5;;" ><img src="/resources/images/2016/PRD17.gif" /><br/>Rack</td>
                        <td width="15%" style="border-bottom:1px solid #e5e5e5;" ><img src="/resources/images/2016/PRD18.gif" /><br/>Wood</td>
                    </tr>
                    <tr>
                        <td width="15%" height="154px" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD19.gif" /><br/>Corrugated Paper Box</td>
                        <td width="15%" style="border-right:1px solid #e5e5e5;border-bottom:1px solid #cdcdcd;" ><img src="/resources/images/2016/PRD20.gif" /><br/>Bag</td>
                        <td width="15%"  style="border-bottom:1px solid #cdcdcd;"><img src="/resources/images/2016/PRD21.gif" /><br/>Film for Packing</td>
                    </tr>
           	 	</table>                
                <p class="subcontentTit" >Value we provide to customer</p>
                 <div class="materielList"  style="position:relative; margin-top:10px; margin-bottom:100px; height:320px; min-height:320px ">
                    <ul>
                      <li style="width:260px;">
                      	<p><img src="/resources/images/2016/img07.png" /></p>
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">We present Strategic <br/>Procurement Consulting.</p>
                            We present customized procurement solution which is suitable for customer through market analysis.
                        </div>
                      </li>
                      <li style="width:280px;">
                      	<img src="/resources/images/2016/img27.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">Cost Reduction</p>
                            "We reduce not only direct cost like purchase price, but also, indirect cost like salary, system development, maintenance, repair, and management cost.
                        </div>
                      </li>
                      <li style="width:265px;">
                      	<img src="/resources/images/2016/img28.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">Quality Management</p>
                            We run quality management through quality standare management, vendor inspection, quality test from external organization.
                        </div>
                      </li>
                      <li style="width:250px;">
                      	<img src="/resources/images/2016/img29.png" />
                      	<div style="background-color:#e1e1e1; background-image:url(/resources/images/2016/dot03.png); padding:35px 15px; height:120px">
                            <p style="color:#ee3212; font-size:18px; margin-bottom:10px; font-weight:bold">Delivery Management</p>
                            We present delivery service through organized delivery management system.
                        </div>
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

