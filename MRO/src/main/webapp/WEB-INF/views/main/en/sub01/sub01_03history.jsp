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
            	<p class="sbtit">History</p>
            	<p>Platform Business Leader in B2B Market</p>
            </div>
            <div class="subbannerbg" > </div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList01">
            	<ul>
            		<a href="javascript:EnMovePage('<%=httpurl%>','01', '02');"><li>Overview</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '03');"><li class="subtabOn">History</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '04');"><li>Vision</li></a><a href="javascript:EnMovePage('<%=httpurl%>','01', '05');"><li>Directions</li></a>
                </ul>  
            </div>
        </div>
        <div class="subcontent">
            <div class="sub01_01summary">
            	Korea E Platform started B2B venture company and has developed autonomously. <br/>
                We are different from another MRO procurement companies which have developed with their own supply.<br/><br/><br/>
                <ul class="historytab" id="historytab">
                  <li class="on" style="width:269px;">2018 ~ 2015</li>
                  <li style="width:270px;">2014 ~ 2010</li>
                  <li style="width:270px;">2009 ~ 2005</li>
                  <li style="width:270px;">2004 ~ 2000</li>
                </ul>
                <div class="historytab_con" id="historytab_con">
                  <div >
                  	<table  width="100%" class="historytable" >
                  		<tr>
                          <th width="270px" >2017</th>
                          <td >MRO procurement win-win agreement(Win-Win Growth Committee)<br />Suwon Distribution Center open<br />Suwon Office open</td>
						</tr>
                    	<tr>
                          <th width="270px" >2016</th>
                          <td >IT material Distribution Service open<br />Ansung Distribution Center open<br />Ansan Distribution Center open</td>
                        </tr>
                        <tr>
                          <th width="270px" >2015</th>
                          <td >Incorporated into Kwangdong Phamarcy Group Subsidiary<br/>Established Vision 2020<br/>Daejeon Distribution Center open<br/>Kolon Safety Shoes New item Release</td>
                        </tr>
                    </table>
                  </div> 
                  <div >
                  	<table  width="100%" class="historytable" >
                        <tr>
                          <th width="270px" >2012</th>
                          <td >Subsidiary Materials Procurement Service open</td>
                        </tr>
                        <tr>
                          <th >2011</th>
                          <td >Daejeon Office open</td>
                        </tr>
                        <tr>
                          <th >2010</th>
                          <td >Established Vision 2015</td>
                        </tr>
                    </table>
                  </div>                   
                  <div>
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="270px" >2008</th>
                          <td >Open overseas corporate in china <br/>Gumi Distribution Center open<br/>Won e-Biz Brand Innovation Grand Prize(Hankook Economy)</td>
                        </tr>
                        <tr>
                          <th >2007</th>
                          <td >Geoje Distribution Center open</td>
                        </tr>
                        <tr>
                          <th >2006</th>
                          <td >Incorporated into Kolon Group Subsidiary</td>
                        </tr>
                        <tr>
                          <th >2005</th>
                          <td >Ansan Distribution Center open</td>
                        </tr>
                    </table>                  
                  </div>
                  <div>
                  	<table  width="100%" class="historytable" >
                    	<tr>
                          <th width="270px" >2004</th>
                          <td >Safety Distribution Mall open(safety.koreab2b.com)</td>
                        </tr>
                        <tr>
                          <th >2003</th>
                          <td >Changwon Distribution Center open</td>
                        </tr>
                        <tr>
                          <th >2002</th>
                          <td >Won 6th e-Business Grand Prize(Prime Minister)</td>
                        </tr>
                        <tr>
                          <th >2000</th>
                          <td >Company Establishment <br/> E-Marketplace Sales open</td>
                        </tr>
                    </table>     
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

