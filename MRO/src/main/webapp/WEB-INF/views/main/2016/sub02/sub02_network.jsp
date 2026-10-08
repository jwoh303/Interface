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
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
     <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB10.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">물류센터</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li>MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li>부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li>건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li>해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li>구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li class="subtabOn">물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_network">
                중앙HUB, 대전, 구미, 창원, 광주 등 전국에 분포한 5개의 물류센터를 통해 고객사에 통합배송 서비스를 제공하고 있습니다.<br/>
                선진화된 물류정보시스템을 통해 입고, 보관, 출고, 반품/교환 및 납기관리까지 전체 프로세스를 체계적으로 관리하고 있으며,<br/> 고객사 전용 배송차량을 운영하여 적기 배송을 실현하고 있습니다. <br/><br/><br/><br/>
                
                <p class="subcontentTit" >물류거점현황</p>
               <table  class="networkmaptable" style="position:relative; margin-bottom:120px; top:20px">
                    <colgroup>
                      <col width="80px" />
                      <col width="140px" />
                      <col width="120px" />
                      <col width="260px" />
                    </colgroup>
                    <tr>
                        <th style="color:#fff; background:#4b4948; height:54px;border-right:1px solid #6c6b6b;background-image:url(img_2016/dot03.png)" >센터</th>
                        <th style="color:#fff; background:#4b4948">연락처</th>
                        <th style="color:#fff; background:#4b4948; border-left:1px solid #666">팩스</th>
                        <th style="color:#fff; background:#ee3212;background-image:url(img_2016/dot03.png)">주소</th>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:98px" >중앙HUB</td>
                        <td style="border-right:1px solid #cdcdcd; ">031-8061-8051~3  </td>
                        <td >031-462-8612</td>
                        <td align="left" style="background:#eeeeee; padding:0 10px"  >경기도 군포시 번영로 82-22 군포복합물류터미널 I동 1층 동관(도크 6~8)</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:98px" >대전</td>
                        <td style="border-right:1px solid #cdcdcd; ">043-264-1248 </td>
                        <td >043-263-1248 </td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >충북 청주시 서원구 현도면 선동리 116-5 </td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:99px" >구미</td>
                        <td style="border-right:1px solid #cdcdcd; ">054-972-5616</td>
                        <td >054-972-5618</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >경북 칠곡군 석적읍 중지리 12-1</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:99px" >창원</td>
                        <td style="border-right:1px solid #cdcdcd; ">055-270-6227~9</td>
                        <td >055-270-6222</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >경남 창원시 의창구 팔용동 39-8</td>
                    </tr>
                    <tr>
                        <td style=" border-right:1px solid #cdcdcd; background:#eeeeee; font-weight:bold; height:98px" >광주</td>
                        <td style="border-right:1px solid #cdcdcd; ">062-955-8502</td>
                        <td >062-955-8503</td>
                        <td align="left" style="background:#eeeeee;padding:0 10px" >광주광역시 광산구 하남산단 10번로 48<br/>(에이치로지스)</td>
                    </tr>
           	 	</table>
               <div style="position:absolute; height:550px;  width:460px;background:url(/resources/images/2016/m09.png) no-repeat center ; top:258px; left:600px;border:1px solid #cdcdcd; font-weight:bold ">
                <p style="position:absolute; left:120px; top:120px;  width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">중앙HUB</p>
                <p style="position:absolute; left:150px; top:200px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">대전</p>
                <p style="position:absolute; left:230px; top:240px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">구미</p>
                <p style="position:absolute; left:260px; top:310px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">창원</p>
                <p style="position:absolute; left:100px; top:320px; width:92px; height:91px; line-height:91px; font-size:15px; color:#fff; background:url(/resources/images/2016/m10.png) no-repeat;">광주</p>

                <!--p style="position:absolute; left:20px; top:200px; "><img src="/resources/images/2016/img_j09.jpg" /></p>
                <p style="position:absolute; left:700px; top:300px; "><img src="/resources/images/2016/img_j10.jpg" /></p>
                <p style="position:absolute; left:770px; top:0px; "><img src="/resources/images/2016/img_j11.jpg" /></p-->
               </div>
               
                
                <p class="subcontentTit" >프로세스</p>
                <div style="position:relative; height:580px; width:1080px;background-image:url(/resources/images/2016/img19.gif); margin-top:10px ">
                    <p style="position:absolute; left:230px; top:45px; line-height:18px; font-size:13px">사이트이용<br/>인터페이스</p>
                    <p style="position:absolute; left:650px; top:65px; line-height:18px; font-size:13px">인터페이스</p>
                    <p style="position:absolute; left:115px; top:530px; line-height:18px; font-size:13px; color:#ee3212">물류센터 배송(통합배송)</p>
                    <p style="position:absolute; left:135px; top:415px; line-height:18px; font-size:13px; color:#ee3212">공급사 직납</p >
                    <div class="networkList" style="position:absolute; left:40px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m07.png); line-height:25px; font-weight:bold"><p style="padding-top:57px">고객사 각<br/>사업장</p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">주문</li>
                            <li ><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">제품등록/수정요청</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">반품요청</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">입고</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:330px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m08.png); line-height:25px; font-weight:bold"><p style="padding-top:57px">코리아e플랫폼<br/><span style="font-size:14px; ">(사이트이용)</span></p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">주문접수</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6 ">납품지시</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">제품등록/수정요청</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">반품요청접수</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">반품요청처리</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:615px; top:200px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m07.png); line-height:25px; font-weight:bold"><p style="padding-top:57px">공급사<br/><span style="font-size:14px; ">(사이트이용)</span></p></div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">주문접수</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">납품</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">반품처리</li>
                        </ul>
                    </div>
                    <div class="networkList" style="position:absolute; left:900px">
                        <div style=" width:144px; height:166px; color:#fff; background-image:url(/resources/images/2016/m08.png); line-height:166px; font-weight:bold">물류센터</div>
                        <ul>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">주문접수</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px;background-color:#f6f6f6  ">배송지시</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">반품처리</li>
                            <li><img src="/resources/images/2016/arrow09.png" /></li>
                            <li style="border:1px solid #cdcdcd;line-height:30px; height:30px; background-color:#f6f6f6 ">납품</li>
                        </ul>
                    </div>
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

