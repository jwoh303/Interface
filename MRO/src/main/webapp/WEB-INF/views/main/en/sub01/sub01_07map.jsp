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
   <!--컨텐츠-->
	<div class="subcontentsArea">
        <div class="subbanner" >
        	<div class="subbannerimg"><img src="/resources/images/2016/SB04.jpg" /></div>
            <div class="subbannertxt" >
              <p class="sbtit">Directions</p>
              <p>Platform Business Leader in B2B Market</p>
            </div>
        	<div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:EnMovePage('<%=httpurl%>','01', '02');"><li>Overview</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '03');"><li>History</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '04');"><li>Vision</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '05');"><li class="subtabOn">Directions</li></a>
                </ul>
            </div>
        </div>
        <div class="subcontent">
        	<div class="sub01_01map">
                <div id="menu1" style="display:block;  position:absolute; top:0;  z-index:9; letter-spacing:0px">
                 <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                   <tr height="75px" bgcolor="#FFFFFF">
                    <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212" >Seoul<br/>Headquarter</td>
                    <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                    <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Gumi<br/><span style="font-size:13px">Office / logistics </span></td>
                    <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                    <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics </span></td>
                    <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Suwon<br/><span style="font-size:13px">Office / logistics </span></td>
                    <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ansung <br/><span style="font-size:13px">logistics</span></td>
                    <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                    <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ulsan<br/><span style="font-size:13px">Office</span></td>
                   </tr>
                   <tr>
                    <td colspan=9 height="400px" bgcolor="#ffffff" style="font-weight:normal" > 
                    <br/><br/>
                    <p class="subcontentTit" >Seoul Headquarter</p> 
                    Seoul Gangnam Post Office Bld 7th floor, Gaepo-Ro 619, Gangnam-Gu, Seoul-Si, Korea <br/>Tel : +82-2-3016-8989 / Fax : +82-2-569-6724. +82-2-569-9408 <br/> E-Mail : master@koreab2b.com<br/><br/>
                   <a href="https://www.google.co.kr/maps/search/Seoul+Gangnam+Post+Office+Bld+7th+floor,+Gaepo-Ro+619,+Gangnam-Gu,+Seoul-Si/@37.4935315,127.0759056,17z/data=!3m1!4b1?hl=en" target="_blank" >
                    <div id="map01" style="width:1080px;height:400px; background:url(/resources/images/2016/map01_Seoul.jpg) no-repeat center"></div></a>
                    </td>
                   </tr>
                 </table>
                </div>
                <div id="menu2" style="display:block; position:absolute; top:0; z-index:8; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                     <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;"" >Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff;line-height:20px; color:#ee3212">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                      <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                        <p class="subcontentTit" >Changwon Office / logistics</p>
                        Muyeok-Ro 547(Palyong-Dong 4-53), Euchang-Gu, Changwon-Si, Gyungsangnam-Do, Korea<br/>Office Tel : +82-55-270-6227~8 / logistics Tel : +82-55-270-6646 / Fax : +82-55-270-6222<br/> E-Mail : mastercw@koreab2b.com<br/><br/>
                       <a href="https://www.google.co.kr/maps/search/Muyeok-Ro+547(Palyong-Dong+4-53),+Euchang-Gu,+Changwon-Si,+Gyungsangnam-Do,+Korea/@35.2270027,128.6359481,16z?hl=en" target="_blank" >
                <div id="map02" style="width:1080px;height:400px; background:url(/resources/images/2016/map02_Changwon.jpg) no-repeat center"></div></a>
                       </td>
                    </tr>
                  </table>
                </div>
                <div id="menu3" style="display:block; position:absolute; top:0; z-index:7; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212">Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                      <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                        <p class="subcontentTit" >Gumi Office / logistics</p> Kolon Gumi Factory, Suchuldae-Ro 48(Gongdan-Dong 212), Gumi-Si, Gyunasangbuk-Do, Korea <br/>Tel : +82-54-461-3611~2 / Fax : +82-54-461-3613 / E-Mail : kchee@koreab2b.com<br/><br/>
                        <a href="https://www.google.co.kr/maps/search/Kolon+Gumi+Factory,+Suchuldae-Ro+48(Gongdan-Dong+212),+Gumi-Si,+Gyunasangbuk-Do,+Korea+/@36.0870893,128.3714687,16z?hl=en" target="_blank" >
                <div id="map03" style="width:1080px;height:400px; background:url(/resources/images/2016/map03_Gumi.jpg) no-repeat center"></div></a>
                       </td>
                    </tr>
                  </table>
                </div>
                <div id="menu4" style="display:block;position:absolute; top:0; z-index:6; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                     <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212">Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                       <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                       <p class="subcontentTit" >Geoje Office / logistics</p> Dukpo 5 Gil 20(Dukpo-Dong 370-1), Geoje-Si, Gyungsangnam-Do, Korea<br/>Tel : +82-55-682-4318~9 / Fax : +82-55-682-4082 / E-Mail : mastergj@koreab2b.com<br/><br/>
 <a href="https://www.google.co.kr/maps/search/Dukpo+5+Gil+20(Dukpo-Dong+370-1),+Geoje-Si,+Gyungsangnam-Do,+Korea/@34.9121488,128.7070928,17z/data=!3m1!4b1?hl=en" target="_blank" >
                <div id="map04" style="width:1080px;height:400px; background:url(/resources/images/2016/map04_Geoje.jpg) no-repeat center"></div></a>
                       </td>
                    </tr>
                  </table>
                </div> 
                <div id="menu5" style="display:block;position:absolute; top:0; z-index:5; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #ee3212;border-bottom:1px solid #fff;border-left:1px solid #ee3212;line-height:20px;color:#ee3212">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand;border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png);background-color:#e5e5e5;">Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                       <td colspan=9 height="400px" bgcolor="#ffffff" style="font-weight:normal" > <br/>
                        <style>
                            #DaejeonMap {width:1080px;margin:0 auto;text-align:center;}
                            .tab {list-style: none;margin: 0;padding: 0;overflow: hidden;}
                            .tab li {float: left;border:1px solid #cdcdcd;border-radius:50px; font-size:20px; height:30px; line-height:30px; padding:10px 25px; margin:20px 2px }
                            .tab li a {display:inline-block;color:#000;text-align: center; font-size: 20px;}
                            .tabcontent {display: none; background-color:#fff;color:#000;}
                             li.current{  background-color:#eeeeee; font-weight:bold;}
                            .tabcontent.current {display: block;}						
                        </style>
                        <div id="DaejeonMap">
                            <ul class="tab" style="margin-left:350px">
                                <li class="current" data-tab="tab1"><a href="#">Daejeon Office</a></li>
                                <li data-tab="tab2"><a href="#">Daejeon logistics</a></li>
                            </ul>
        <div id="tab1" class="tabcontent current" >5th floor, Yetsintanjin-Ro 2, Dong-Gu, Daejeon-Si, Korea<br/>Tel : +82-42-632-8922 / Fax : +82-42-632-8926 / E-Mail : masterdj@koreab2b.com <br/><br/>
            <a href="https://www.google.co.kr/maps/place/2+Yetsintanjin-ro,+Samseong-dong,+Dong-gu,+Daejeon/@36.3412232,127.4218675,16z/data=!4m5!3m4!1s0x356548e26e5cf00f:0xecdfffb831a231a1!8m2!3d36.3412232!4d127.4262449?hl=en" target="_blank" >
            <div style="width:1080px;height:400px; background:url(/resources/images/2016/map05_DaejeonOffice.jpg) no-repeat center"></div></a>
        </div>
        <div id="tab2" class="tabcontent">Daejungbuk-Ro 46(Daejung-Dong 304-1), Yusung-Gu, Daejeon-Si, Korea <br/>Tel : +82-42-542-1248 / Fax : +82-42-545-1248 <br/><br/>                           
            <a href="https://www.google.co.kr/maps/place/90+Seokbong-ro+58beon-gil,+Seokbong-dong,+Daedeok-gu,+Daejeon/@36.4434636,127.425794,17z/data=!3m1!4b1!4m5!3m4!1s0x3565371e582f3503:0x142031ae8680d48!8m2!3d36.4434636!4d127.4279827?hl=en" target="_blank" >
            <div style="width:1080px;height:400px; background:url(/resources/images/2016/map05_Daejeonlogistics.jpg) no-repeat center"></div></a>
        </div>
                        </div>
                        <script>
                            $(function() {
                                $('ul.tab li').click(function() {
                                    var activeTab = $(this).attr('data-tab');
                                    $('ul.tab li').removeClass('current');
                                    $('.tabcontent').removeClass('current');
                                    $(this).addClass('current');
                                    $('#' + activeTab).addClass('current');
                                })
                            });
                        </script>                   
                       </td>
                    </tr>
                  </table>
                </div> 
                <div id="menu6" style="display:block;position:absolute; top:0; z-index:6; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff;border-left:1px solid #ee3212; line-height:20px; color:#ee3212" >Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                       <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                       <p class="subcontentTit" >Suwon Office / logistics</p> Samsung-Ro 274(Woncheon-Dong 332-2), Yeongtong-Gu, Suwon-Si, Gyeonggi-Do, Korea<br/>Tel : +82-31-895-8016 / Fax : +82-31-895-8099 / E-Mail : k201701@kmc.co.kr<br/><br/>
                         <a href="https://www.google.co.kr/maps/search/Samsung-Ro+274(Woncheon-Dong+332-2),+Yeongtong-Gu,+Suwon-Si,+Gyeonggi-Do,+Korea/@37.2659836,127.0633348,17z?hl=en" target="_blank" >
                <div id="map06" style="width:1080px;height:400px; background:url(/resources/images/2016/map06_Suwon.jpg) no-repeat center"></div></a>
                       </td>
                    </tr>
                  </table>
                </div> 
                <div id="menu7" style="display:block;position:absolute; top:0; z-index:6; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212" >Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                       <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                       <p class="subcontentTit" >Ansung Office / logistics</p> Yangsung-Ro 453(Ihyun-Li 208-1), Yangsung-Myeon, Ansung-Si, Gyeonggi-Do, Korea<br/>Tel : +82-31-671-0781 / Fax : +82-31-671-0783 / E-Mail : koo3851@sebang.com<br/><br/>
                       <a href="https://www.google.co.kr/maps/place/453+Yangseong-ro,+Yangseong-myeon,+Anseong,+Gyeonggi-do/@37.0931616,127.211018,16z/data=!4m5!3m4!1s0x357b4987f61030b7:0xa99fc2666ca0bec3!8m2!3d37.0936237!4d127.211533?hl=en" target="_blank" >
                <div id="map07" style="width:1080px;height:400px; background:url(/resources/images/2016/map07_Ansung.jpg) no-repeat center"></div></a>
                       </td>
                    </tr>
                  </table>
                </div> 
                <div id="menu8" style="display:block;position:absolute; top:0; z-index:4; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95" style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff; border-left:1px solid #ee3212; line-height:20px; color:#ee3212">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                      <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                        <p class="subcontentTit" >Ansan logistics</p> Jungwangcheondong-Ro 10 bungil 26(Sunggok-Dong 778-3), Danwon-Gu, Ansan-Si, Gyeonggi-Do, Korea<br/>Tel : +82-31-432-8619~20 / Fax : +82-31-432-8612 / E-Mail : helloxa@koreab2b.com<br/><br/>
                         <a href="https://www.google.co.kr/maps/place/778-4+Seonggok-dong,+Danwon-gu,+Ansan-si,+Gyeonggi-do/@37.3143728,126.7259996,16z/data=!4m5!3m4!1s0x357b73d83caacbc9:0xbf9837f3039c187d!8m2!3d37.3132294!4d126.7273944?hl=en" target="_blank" >
                <div id="map08" style="width:1080px;height:400px; background:url(/resources/images/2016/map08_Ansan.jpg) no-repeat center"></div></a>
                      </td>
                    </tr>
                  </table>
                </div>     
                <div id="menu9" style="display:block;position:absolute; top:0; z-index:3; letter-spacing:0px">
                  <table border="0" cellpadding="0" cellspacing="0" width="100%" style="text-align:center; font-size:16px; margin:0 auto;font-weight:bold; border:1px solid #cdcdcd;" >
                    <tr height="75px" bgcolor="#FFFFFF">
                      <td onClick="DisplayMenu(1)" width="120" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Seoul<br/>Headquarter</td>
                      <td onClick="DisplayMenu(2)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Changwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(3)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Gumi<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(4)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Geoje<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(5)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Daejeon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(6)" width="135" style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Suwon<br/><span style="font-size:13px">Office / logistics</span></td>
                      <td onClick="DisplayMenu(7)" width="95"  style="cursor:hand; border:1px solid #cdcdcd; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;" >Ansung<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(8)" width="95"  style="cursor:hand; border:1px solid #cdcdcd; border-right:1px solid #ee3212; line-height:20px; background:url(/resources/images/2016/dot07.png); background-color:#e5e5e5;">Ansan<br/><span style="font-size:13px">logistics</span></td>
                      <td onClick="DisplayMenu(9)" width="95" style="cursor:hand; border:1px solid #ee3212; border-bottom:1px solid #fff; border-left:1px solid #ee3212;line-height:20px; color:#ee3212" >Ulsan<br/><span style="font-size:13px">Office</span></td>
                    </tr>
                    <tr>
                      <td colspan=9 height="400px" bgcolor="#FFFFFF" style="font-weight:normal" > <br/><br/>
                        <p class="subcontentTit" >Ulsan Office</p> 1st floor, Hwahap-Ro 134 bungil 3, Nam-Gu, Ulsan-Si, Korea<br/>Tel : +82-52-265-8955 / Fax : +82-52-265-6230 / E-Mail : masterws@koreab2b.com <br/><br/>
                        <a href="https://www.google.co.kr/maps/place/3+Hwahap-ro134beon-gil,+Samsan-dong,+Nam-gu,+Ulsan/@35.5369849,129.3415118,17z/data=!4m5!3m4!1s0x3567cd41daee8d79:0xe04605358f16d953!8m2!3d35.5368016!4d129.3408359?hl=en" target="_blank" >
                <div id="map09" style="width:1080px;height:400px; background:url(/resources/images/2016/map09_Ulsan.jpg) no-repeat center"></div></a>
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

