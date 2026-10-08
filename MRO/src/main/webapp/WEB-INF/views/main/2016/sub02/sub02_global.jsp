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
            <div class="subbannerimg"><img src="/resources/images/2016/SB07.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">해외법인</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요 </p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li>MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li>부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li>건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li class="subtabOn">해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li>구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li >물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_value">
                2008년 중국법인을 설립한 이래, 국내에서의 사업경험을 기반으로<br/> 50여개 한국기업 및 현지기업을 대상으로 구매대행 서비스를 제공하고 있습니다. <br/><br/><br/><br/>
                 <p class="subcontentTit" >해외법인</p>
<style>
.MapRed   {width:70px;height:30px;line-height:30px;font-size:13px;color:#fff;background-color:#e8340c; border:10px;border-radius:50px;font-weight:bold; border:5px solid  rgba(0, 0, 0, 0.15);-moz- background-clip: padding-box;background-clip: padding-box;}
.MapRedAD {width:70px;height:30px;line-height:30px;font-size:12.5px;color:#fff;background-color:#e8340c; border:10px;border-radius:50px;font-weight:bold; border:5px solid  rgba(0, 0, 0, 0.15);-moz- background-clip: padding-box;background-clip: padding-box;}
.MapGray{width:37px;height:26px;line-height:26px;font-size:12px; color:#fff; background-color:#4b4948; border:10px;  border-radius:50px;z-index:1}
.MapReds {width:20px;height:20px;display:inline-block;vertical-align:middle;background-color:#e8340c; font-size:13px;border:10px;  border-radius:50px;font-weight:bold; border:6px solid  rgba(0, 0, 0,  0.15);-moz- background-clip: padding-box;background-clip: padding-box;}
.MapGrays{width:20px;height:20px;display:inline-block;vertical-align:middle;background-color:#4b4948; font-size:13px; border-radius:50px; font-weight:bold;}
</style>
                <table  class="recruittable06" style=" width:100%; border-top:2px solid #4b4948; margin-bottom:20px; margin-top:15px ">
                    <tr>
                        <th width="50%" height="80" bgcolor="#eeeeee" style="border-right:solid 1px #cdcdcd;" >China MRO</th>
                        <th width="50%" bgcolor="#eeeeee">Europe MRO</th>
                    </tr>
                    <tr>
                        <td height="110" style="border-right:solid 1px #cdcdcd; border-bottom:0px; text-align:left;  letter-spacing:-0.3px"  >
                         - 법인 설립 : 2008년<br />
                         - 서비스 지역 : 연태 , 청도 등 11개 지역<br />
                         - 고객사 : 삼성전기, 효성, LS기계 등 31개사<br />
                         - 중국 내 국내 기업 대상 MRO 서비스 확대 중
                        </td>
                        <td style="text-align:left;border-bottom:0px; vertical-align:top;letter-spacing:-0.3px"  >
                          - 법인 설립 : 2023년 7월<br />
                          - 서비스 도시 : 자테츠, 오스트라바, 이반차, 코마롬, 두너우바로시, 브론키<br />
                          - 고객사 : 넥센타이어, SK OH, 한국타이어, 삼성전자 <br />
                          - 체코, 헝가리, 폴란드 등 유럽권역 서비스 확대 예정
                        </td>
					</tr> 
                    <tr>
                        <td height="420px" style="position:relative; background:url(/resources/images/2016/n_map01.png) no-repeat; background-position:top left; border-right:solid 1px #cdcdcd; border-bottom:0px"  >
                        	<div style="position:absolute; top:0;">
                            	<div  style="display:inline-block; vertical-align:middle"><p class="MapReds"></p> &nbsp; 법인사무소</div>
                            	<div  style="display:inline-block; vertical-align:middle; margin-left:20px"><p class="MapGrays"  ></p> &nbsp; 파견사무소</div>
                            </div>
                            <p class="MapRed"  style="position:absolute; left:375px; top:185px;">연태</p>
                            <p class="MapRed"  style="position:absolute; left:345px; top:280px;">소주</p>
                            <p class="MapGray" style="position:absolute; left:420px; top:170px;">대련</p>
                            <p class="MapGray" style="position:absolute; left:425px; top:225px;">청도</p>
                            <p class="MapGray" style="position:absolute; left:390px; top:255px;">남경</p>
                            <p class="MapGray" style="position:absolute; left:420px; top:270px;">남통</p>
                            <p class="MapGray" style="position:absolute; left:400px; top:310px;">영성</p>
                        </td>
                        <td style=" position:relative; background:url(/resources/images/2016/n_map02.png) no-repeat; background-position:top center; border-bottom:0px"  >
                        	<div style="position:absolute; top:0;"><div style="display:inline-block; vertical-align:middle"><p class="MapReds"></p> &nbsp; 법인사무소</div></div>
                            <p class="MapRedAD"  style="position:absolute; left:300px; top:235px;">포츠난</p>
                            <p class="MapRedAD"  style="position:absolute; left:320px; top:295px;">부다페스트</p>
                            <p class="MapRedAD"  style="position:absolute; left:275px; top:267px;">프라하</p>
                        </td>
                        <tr>
                        	
                        	<td style="border-right:solid 1px #cdcdcd;">
                        	<a href="http://www.kepchina.cn/" target="_blank" ><p style="border-radius:50px; width:50%; padding:10px 0; margin:0 auto; background-color:#e8340c; color:#fff">China MRO 바로가기</p></a>
                        	</td>
                            <td style=""><a href="https://www.koreab2b-eu.com/" target="_blank" ><p style="border-radius:50px; width:50%; padding:10px 0; margin:0 auto; background-color:#e8340c; color:#fff">Europe MRO 바로가기</p></a></td>
						</tr> 
                 </table>                 
                  
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

