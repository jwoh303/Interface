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
<script type="text/javascript">
$(function () {	
	tab('#historytab',0);	
});
function tab(e, num){
    var menu = $(e).children();
    var con = $(e+'_con').children();
    var select = $(menu).eq(num);
    var i = num;

    select.addClass('on');
    con.eq(num).show();

    menu.click(function(){
        if(select!==null){
            select.removeClass("on");
            con.eq(i).hide();
        }

        select = $(this);	
        i = $(this).index();

        select.addClass('on');
        con.eq(i).show();
    });
}
</script>
    <!--컨텐츠-->
    <div class="subcontentsArea">
    	<div class="subbanner" >
            <div class="subbannerimg"><img src="/resources/images/2016/SB23.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">연혁</p>
            	<p>B2B시장의 플랫폼 비즈니스 리더</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:MovePage_2016('<%=httpurl%>','01', '01');"><li>CEO메시지</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '02');"><li>개요</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '03');"><li class="subtabOn">연혁</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '04');"><li>비전</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '06');"><li>공고</li></a><a href="http://www.ekdp.com/ethics/main/main.asp" target="_blank"><li>윤리경영</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','01', '05');"><li>오시는길</li></a>
                </ul>   
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
            	코리아e플랫폼은 B2B벤처기업으로 출발하여,<br/>
                자체그룹물량으로 성장한 타 MRO기업과는 달리 경쟁력을 통해 독자적으로 성장해 나가고 있습니다.<br/><br/><br/>
            
                <ul class="historytab" id="historytab">
                  <li class="on" style="width:215px;">2021 ~ 2024</li>
                  <li style="width:216px;">2020 ~ 2016</li>
                  <li style="width:216px;">2015 ~ 2011</li>
                  <li style="width:216px;">2010 ~ 2006</li>
                  <li style="width:216px;">2005 ~ 2000</li>
                </ul>
                <div class="historytab_con" id="historytab_con">
                  <div >
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="216px">2024</th>
                          <td >솔브레인 MRO 사업자 선정<br/>와이지원 MRO 사업자 선정<br/>케이씨텍 MRO 사업자 선정<br/>HY MRO 사업자 선정<br/>OB맥주 판촉물 MRO 사업자 선정<br/>HK이노엔 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th width="216px">2023</th>
                          <td >넥센타이어 체코법인 MRO 사업자 선정<br/>KeP 체코법인 설립<br/>금호석유화학 MRO 사업자 선정<br/>롯데알미늄 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th width="216px">2022</th>
                          <td >한화 MRO 사업자 선정<br/>스타벅스코리아 MRO 사업자 선정<br/>중앙대학교 MRO 사업자 선정<br/>롯데칠성음료 판촉물 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th width="216px">2021</th>
                          <td >KG그룹 MRO 사업자 선정<br/>넥센타이어 MRO 사업자 선정<br/>남양유업 MRO 사업자 선정<br/>SPC그룹 MRO 사업자 선정<br/>전사 시스템 클라우드 전환 완료</td>
                        </tr>
                    </table>
                  </div> 
                  <div >
                  	<table  width="100%" class="historytable" >
                        <tr>
                          <th width="216px" >2020</th>
                          <td >동화그룹 MRO 사업자 선정 <br/>대림산업 MRO 사업자 선정 <br/>비전2024 선포</td>
                        </tr>
                        <tr>
                          <th >2019</th>
                          <td >에스원 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2018</th>
                          <td >SYS리테일(전자랜드) MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2017</th>
                          <td >삼성전기 MRO 사업자 선정 <br/>롯데제과 MRO 사업자 선정 <br/>삼성전자 MRO 사업자 선정</td>
                        </tr>
                    </table>
                  </div>                   
                  <div>
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="216px">2015</th>
                          <td >본사 소재지 이전 (서울강남우체국 7층) <br/>삼양사 MRO 사업자 선정 <br/>대주주 변경 (코오롱 → 광동제약)</td>
                        </tr>
                        <tr>
                          <th  >2014</th>
                          <td >유한킴벌리 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2013</th>
                          <td >코웨이 MRO 사업자 선정 <br/>GS건설 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2012</th>
                          <td >효성중공업 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2011</th>
                          <td >대전물류센터 신설</td>
                        </tr>
                    </table>                   
                  </div>
                  <div>
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="216px">2009</th>
                          <td >S&T중공업 MRO 사업자 선정 </td>
                        </tr>
                        <tr>
                          <th  >2008</th>
                          <td >e-Biz 브랜드 혁신 대상 수상 (한국경제) <br/>구미물류센터 신설</td>
                        </tr>
                        
                        <tr>
                          <th >2007</th>
                          <td >거제물류센터 신설</td>
                        </tr>
                        <tr>
                          <th >2006</th>
                          <td >코오롱계열사 편입</td>
                        </tr>

                    </table>      
                  </div>
                  <div>
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="216px">2005</th>
                          <td >하이트진로 MRO 사업자 선정 <br/>셰플러코리아 MRO 사업자 선정 </td>
                        </tr>
                        <tr>
                          <th  >2003</th>
                          <td >창원물류센터 신설</td>
                        </tr>
                        
                        <tr>
                          <th >2002</th>
                          <td >대우조선해양 MRO 사업자 선정</td>
                        </tr>
                        <tr>
                          <th >2000</th>
                          <td >코리아이플랫폼㈜ 설립</td>
                        </tr>
                    </table>      
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

