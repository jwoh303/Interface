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
            <div class="subbannerimg"><img src="/resources/images/2016/SB09.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">건설MRO소개</p>
            	<p>차별화된 가치를 제공하는 KeP의 서비스를 만나 보세요 </p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList02">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','02', '01');"><li>MRO구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '02');"><li>부자재구매대행</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '03');"><li  class="subtabOn">건설MRO소개</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '04');"><li>해외법인</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '05');"><li>구매시스템</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','02', '06');"><li >물류센터</li></a>
                </ul> 
            </div>
        </div>
        <div class="subcontent">
            <div class="sub02_intergrated">
              전국 네트워크 협력사의 현장밀착 납품 서비스와 도매유통 사업기반의 가격 경쟁력을 통해<br/> 타 구매대행사에는 없는 차별화된 사업모델을 구축하였으며, <br/>이를 통해 건설 MRO 시장에서 가장 경쟁력 있는 서비스를 제공하고 있습니다. <br/><br/><br/><br/>
                <p class="subcontentTit" >건설MRO 사업모델</p>
                 <div class="CmroList"  style="position:relative; margin-top:20px; margin-bottom:60px;">
                    <ul>
                      <li style="width:395px; background:url(/resources/images/2016/img_j12.jpg) no-repeat top;  ">
                          <p  style="margin-top:210px; text-align:left; padding:20px 30px">
                          	<b style="color:#ee3212; font-size:18px; line-height:38px;">네트워크 협력사의 차별화된 납품서비스 </b><br/>
                            - 83개 네트워크 협력사가 전국 건설현장을 커버함<br/>
                            - 긴급발주 서비스 대응<br/>
                            - 현장 상황에 맞는 제작품 서비스<br/>
                            - 상시 재고 운영
                            </p>
                       </li>
                      <li style="width:330px; background:url(/resources/images/2016/img_j14.jpg) no-repeat top;">
                      	<p  style="margin-top:210px; text-align:center; padding:20px 30px">
                        <b style="color:#ee3212; font-size:18px; line-height:38px">가격 경쟁력</b><br/>
                        도매유통 사업을 통한 <br/>가격 경쟁력 확보</p></li>
                       
                       
                      <li style="width:330px; background:url(/resources/images/2016/img_j13.jpg) no-repeat top;">
                      	<p  style=" margin-top:210px;text-align:left; padding:20px 65px">
                          <b style="color:#ee3212; font-size:18px; line-height:38px">최적화된 조직 및 인프라</b><br/>
                            - 건설시장 전용 시스템 구축<br/>
                            - 건설 고객사 전담조직 운영<br/>
                            - 25,000여 품목 표준화</p></li>
                     </ul>
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

