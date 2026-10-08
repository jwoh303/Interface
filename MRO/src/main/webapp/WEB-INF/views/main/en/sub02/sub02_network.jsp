<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
            <div class="subbannerimg"><img src="/resources/images/2016/SB10.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">Recruitment Information</p>
            	<p>Please, meet the service of KeP which provides competitive value.</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:EnMovePage('<%=httpurl%>','02', '01');"><li>MRO Procurement <br/>Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '02');"><li>Subsidiary Materials<br/>Procurement Service</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '03');"><li>Construction MRO<br/>Introduction</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '04');"><li>Overseas<br/>Corporate</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '05');"><li>Procurement<br/>System</li></a><a href="javascript:EnMovePage('<%=httpurl%>','02', '06');"><li class="subtabOn">Distribution<br/>Center</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_network">
                We provide integrated delivery service to customer company handled by our own 7 logistics center located <br/>
                Ansan, Daejeon ,Gumi, Changwon, and Geoje. Through advanced logistics system, GR, storage, delivery, return/exchange, <br/> and lead time are managed thoroughly and on-time delivery is fulfilled by customer only delivery vehicle.<br/><br/><br/><br/>
                <p class="subcontentTit" >present condition of distribution base</p>
                <table  class="networkmaptable" style="position:relative; margin-bottom:120px; top:20px">
                    <colgroup>
                      <col width="100px" />
                      <col width="120px" />
                      <col width="120px" />
                      <col width="280px" />
                    </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; height:54px;border-right:1px solid #6c6b6b;background-image:url(/resources/images/2016/dot03.png); line-height:15px" >Distribution Center</th>
                        <th style="color:#fff; background:#4b4948">Contact</th>
                        <th style="color:#fff; background:#4b4948">fax</th>
                        <th style="color:#fff; background:#ee3212;background-image:url(/resources/images/2016/dot03.png)">address</th>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Ansan</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-031-432-8619<br/>+82-2-031-432-8620</td>
                        <td >+82-2-031-432-8612</td>
                        <td align="left" style="background:#eeeeee; padding:0 10px"  >Jungwangcheondong-Ro 10 bungil 26(Sunggok-Dong 778-3), Danwon-Gu, Ansan-Si, Gyeonggi-Do, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Suwon</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-031-895-8016 </td>
                        <td >+82-2-031-895-8099</td>
                        <td align="left" style="background:#eeeeee; padding:0 10px"  >Samsung-Ro 274(Woncheon-Dong 332-2), Yeongtong-Gu, Suwon-Si, Gyeonggi-Do, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Ansung</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-031-671-0781 </td>
                        <td >+82-2-031-671-0783 </td>
                        <td align="left" style="background:#eeeeee; padding:0 10px"  >Yangsung-Ro 453(Ihyun-Li 208-1), Yangsung-Myeon, Ansung-Si, Gyeonggi-Do, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Daejeon</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-042-542-1248</td>
                        <td >+82-2-042-545-1248</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >Daejungbuk-Ro 46(Daejung-Dong 304-1), Yusung-Gu, Daejeon-Si, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Gumi</td>
                        <td style="border-right:1px solid #cdcdcd; ">054-461-3611<br/>054-461-3612</td>
                        <td >+82-2-054-461-3613</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >Suchuldae-Ro 48(Gongdan-Dong 212), Gumi-Si, Gyunasangbuk-Do, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Changwon</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-055-270-6646</td>
                        <td >+82-2-055-270-6222</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >Muyeok-Ro 547(Palyong-Dong 4-53), Euchang-Gu, Changwon-Si, Gyungsangnam-Do, Korea</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:70px" >Geoje</td>
                        <td style="border-right:1px solid #cdcdcd; ">+82-2-055-682-4319</td>
                        <td >+82-2-055-682-4082</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >Dukpo 5 Gil 20(Dukpo-Dong 370-1), Geoje-Si, Gyungsangnam-Do, Korea</td>
                    </tr>                    
           	 	</table>
               <div style="position:absolute; height:550px;  width:460px;background:url(/resources/images/2016/m09.png) no-repeat center ; top:258px; left:620px;border:1px solid #cdcdcd; font-weight:bold ">
                    <p style="position:absolute; left:90px; top:90px;  width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Ansan</p>
                    <p style="position:absolute; left:135px; top:120px;  width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Suwon</p>
                    <p style="position:absolute; left:170px; top:160px;  width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Ansung</p>
                    <p style="position:absolute; left:150px; top:210px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Daejeon</p>
                    <p style="position:absolute; left:230px; top:240px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Gumi</p>
                    <p style="position:absolute; left:260px; top:310px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Changwon</p>
                    <p style="position:absolute; left:240px; top:380px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">Geoje</p>
               </div>
               <p class="subcontentTit" >Process</p>
               <div style="position:relative; height:650px; width:1080px;background-image:url(/resources/images/2016/img19_en.gif); margin-top:10px ">
                    <p style="position:absolute; left:230px; top:45px; line-height:18px; font-size:13px">Use Site<br/>Interface</p>
                    <p style="position:absolute; left:650px; top:65px; line-height:18px; font-size:13px">Interface</p>
                    <p style="position:absolute; left:115px; top:530px; line-height:18px; font-size:13px; color:#ee3212">Distribution Center delivers(Integration delivery)</p>
                    <p style="position:absolute; left:135px; top:415px; line-height:18px; font-size:13px; color:#ee3212">Vendor delivers directly</p >
                    <div class="networkList" style="position:absolute; left:40px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m07.png); line-height:25px; font-weight:bold"><p style="padding-top:57px">Each site of<br/> customer</p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Order</li>
                            <li ><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:15px; height:35px; padding:5px;background-color:#f6f6f6">Item Registration / <br/>Request Revision</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">Return Request</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">Goods Receipt</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:330px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m08.png); line-height:25px; font-weight:bold"><p style="padding-top:45px">Korea e <br/>Platform<br/>
                        <span style="font-size:14px; ">(Use Site)</span></p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">Order Receipt</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6 ">Request Delivery</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:15px; height:35px; padding:5px;background-color:#f6f6f6  ">Item Registration /<br/> Request Revision</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:15px; height:35px; padding:5px;background-color:#f6f6f6  ">Return Request <br/>Receipt</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:15px; height:35px; padding:5px;background-color:#f6f6f6 ">Return Request <br/>processed</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:615px; top:200px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m07.png); line-height:25px; font-weight:bold"><p style="padding-top:57px">Vendor<br/>
                        <span style="font-size:14px; ">(Use Site)</span></p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Order Receipt</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">Delivery</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Return processed</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:900px">
                        <div style=" width:144px; height:105px; color:#fff; background-image:url(/resources/images/2016/m08.png); line-height:25px; font-weight:bold; padding-top:61px">Distribution<br/> Center</div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Order Receipt</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">Request Delivery</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Return processed</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">Delivery</li>
                        </ul>
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

