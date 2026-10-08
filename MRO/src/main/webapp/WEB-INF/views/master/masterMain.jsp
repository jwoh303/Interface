<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
 
<% 
	// 공통
	/*
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("master_data"); // 조회된 결과
 
	Map<String,String> rowData = null;
	if (_gridList == null || _gridList.size() == 0){ 
	}else{
		rowData = _gridList.get(0);
	}		
	*/
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String st_muser_type = "";
	String st_buyer= "";
	String st_user_id = "";
	String st_password = "";
	String st_office_yn = "";
	if (sessionInfo != null){ 
		st_muser_type =  CommonUtil.nvl((String)sessionInfo.getUserType());  
		st_buyer =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		st_user_id =  CommonUtil.nvl((String)sessionInfo.getUserId());  
		st_password =  CommonUtil.nvl((String)sessionInfo.getDecode_password()); // 암호 디코드  운영사인대 고객사로 로그인 가능자 암호 디코드
		st_office_yn=  CommonUtil.nvl((String)sessionInfo.getOffice_yn());  // 운영사인대 고객사로 로그인 가능자
	}  
	
	
	
%> 
<script type="text/javascript">
 
function getKepbuyerGo()
{  
	<% if ("Y".equals(st_office_yn)) {%>
	goLoginSubmit();
	<%}else{%>
	alert("해당 메뉴에 권한이 없습니다.");
	<%}%>
}

function getUserAuthorityCheck(user_type)
{
    if(user_type == "J" || user_type == "W")
    {
        alert("해당 메뉴에 권한이 없습니다.");
        return false;
    }
    return true;
}
 



</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<body>
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="euc-kr" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="masterMainHeader"/>
</c:import>
<form name="contentForm" id="contentForm" method="post">
<input type = "hidden" name="st_muser_type" id="st_muser_type" value = "<%=st_muser_type%>">
</form>

    <!--컨첸츠-->
    <div id="admin_home">
        <div id="main_table_div">
            <div class="main_table_summ">
                <p>
                    <span>달성률 : </span>
                    <img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> 100% 이상      
                    <img src="/resources/images/m_ball_yellow.gif" alt="ball_yellow" style="vertical-align:middle" /> 85%~100% 미만      
                    <img src="/resources/images/m_ball_red.gif" alt="ball_red" style="vertical-align:middle" /> 85% 미만  [단위 : 백만원]
                </p>
            </div>
            <table class="NewDateTable" >
                <colgroup>
                    <col width="160px" />
                    <col width="80px" />
                    <col width="80px" />
                    <col width="90px" />
                    <col width="80px" />
                    <col width="80px" />
                    <col width="90px" />
                    <col width="80px" />
                    <col width="80px" />
                    <col width="90px" />
                    <col width="80px" />
                    <col width="80px" />
                    <col width="90px" />
                </colgroup>                
                <thead>
                    <tr>
                        <th class="NewDateTableTitT">KeP 2026년</th>
                        <th colspan="3" class="NewDateTableTit" >8월 매출</th>
                        <th colspan="3" class="NewDateTableTit" >8월 영업이익</th>
                        <th colspan="3" class="NewDateTableTit" >3분기 매출누계</th>
                        <th colspan="3" class="NewDateTableTit" >3분기 영업이익 누계</th>
                    </tr>
                    <tr>
                        <th class="NewDateTableTitS"> 팀</th>
                        <th class="NewDateTableTitS">계획</th>
                        <th class="NewDateTableTitS">실적</th>
                        <th class="NewDateTableTitS">달성율</th>
                        <th class="NewDateTableTitS">계획</th>
                        <th class="NewDateTableTitS">실적</th>
                        <th class="NewDateTableTitS">달성율</th>
                        <th class="NewDateTableTitS">계획</th>
                        <th class="NewDateTableTitS">실적</th>
                        <th class="NewDateTableTitS">달성율</th>
                        <th class="NewDateTableTitS">계획</th>
                        <th class="NewDateTableTitS">실적</th>
                        <th class="NewDateTableTitS">달성율</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th class="TeamTit">중부사업팀</th>
                        <td>8,872</td>
                        <td>9,778</td>
                        <td><p class="ball_blue">110%</p></td>
                        <td>147</td>
                        <td>174</td>
                        <td><p class="ball_blue">118%</p></td>
                        <td>18,178</td>
                        <td>21,229</td>
                        <td><p class="ball_blue">117%</p></td>
                        <td>307</td>
                        <td>373</td>
                        <td><p class="ball_blue">122%</p></td>
                    </tr>
                    <tr>
                        <th class="TeamTit">남부사업팀</th>
                        <td>10,895</td>
                        <td>11,444</td>
                        <td><p class="ball_blue">105%</p></td>
                        <td>51</td>
                        <td>41</td>
                        <td><p class="ball_red">80%</p></td>
                        <td>22,929</td>
                        <td>24,724</td>
                        <td><p class="ball_blue">108%</p></td>
                        <td>136</td>
                        <td>89</td>
                        <td><p class="ball_red">66%</p></td>
                    </tr>
                    <tr>
                        <th class="TeamTit">SMART팀</th>
                        <td>6,316</td>
                        <td>6,680</td>
                        <td><p class="ball_blue">106%</p></td>
                        <td>-33</td>
                        <td>-29</td>
                        <td>-</td>
                        <td>12,830</td>
                        <td>13,651</td>
                        <td><p class="ball_blue">106%</p></td>
                        <td>-55</td>
                        <td>-37</td>
                        <td>-</td>
                    </tr>                    
                    <!--tr>
                        <th class="TeamTit">워크웨어사업그룹</th>
                        <td></td>
                        <td>3</td>
                        <td><p class="ball_red">0%</p></td>
                        <td>-13</td>
                        <td>-14</td>
                        <td>-</td>
                        <td></td>
                        <td>3</td>
                        <td><p class="ball_red">0%</p></td>
                        <td>-13</td>
                        <td>-14</td>
                        <td>-</td>
                    </tr-->
                    <tr>
                        <th class="NewDateSumTit">MRO사업본부</th>
                        <td class="NewDateSum">26,083</td>
                        <td class="NewDateSum">27,904</td>
                        <td class="NewDateSum"><p class="ball_blue">107%</p></td>
                        <td class="NewDateSum">151</td>
                        <td class="NewDateSum">164</td>
                        <td class="NewDateSum"><p class="ball_blue">109%</p></td>
                        <td class="NewDateSum">54,006</td>
                        <td class="NewDateSum">59,614</td>
                        <td class="NewDateSum"><p class="ball_blue">110%</p></td>
                        <td class="NewDateSum">365</td>
                        <td class="NewDateSum">400</td>
                        <td class="NewDateSum"><p class="ball_blue">110%</p></td>
                    </tr>

                    <tr>
                        <th class="TeamTit">Bio Lab사업팀</th>
                        <td>4,903</td>
                        <td>4,408</td>
                        <td><p class="ball_yellow">90%</p></td>
                        <td>83</td>
                        <td>-24</td>
                        <td>-</td>
                        <td>10,188</td>
                        <td>8,809</td>
                        <td><p class="ball_yellow">86%</p></td>
                        <td>178</td>
                        <td>-96</td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <th height="32" class="TeamTit">특판. IT사업그룹</th>
                        <td>2,717</td>
                        <td>4,961</td>
                        <td><p class="ball_blue">183%</p></td>
                        <td>9</td>
                        <td>49</td>
                        <td><p class="ball_blue">513%</p></td>
                        <td>5,355</td>
                        <td>7,699</td>
                        <td><p class="ball_blue">144%</p></td>
                        <td>67</td>
                        <td>172</td>
                        <td><p class="ball_blue">257%</p></td>
                    </tr>
                    <tr>
                        <th class="TeamTit">특판. 판촉사업그룹</th>
                        <td>1,744</td>
                        <td>1,838</td>
                        <td><p class="ball_blue">105%</p></td>
                        <td>-23</td>
                        <td>-10</td>
                        <td>-</td>
                        <td>4,029</td>
                        <td>3,583</td>
                        <td><p class="ball_yellow">89%</p></td>
                        <td>-32</td>
                        <td>-28</td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <th class="TeamTit">특판. 산업유통그룹</th>
                        <td>1,391</td>
                        <td>1,372</td>
                        <td><p class="ball_yellow">99%</p></td>
                        <td>11</td>
                        <td>-8</td>
                        <td>-</td>
                        <td>2,900</td>
                        <td>2,777</td>
                        <td><p class="ball_yellow">96%</p></td>
                        <td>29</td>
                        <td>-5</td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <th class="TeamTit" >수도권사업팀</th>
                        <td>7,312</td>
                        <td>5,732</td>
                        <td><p class="ball_red">78%</p></td>
                        <td>-61</td>
                        <td>-60</td>
                        <td>-</td>
                        <td>14,904</td>
                        <td>11,698</td>
                        <td><p class="ball_red">78%</p></td>
                        <td>-122</td>
                        <td>-114</td>
                        <td>-</td>
                    </tr>
                    <tr>
                        <th class="TeamTit">건설사업팀</th>
                        <td>3,324</td>
                        <td>3,497</td>
                        <td><p class="ball_blue">105%</p></td>
                        <td>78</td>
                        <td>97</td>
                        <td><p class="ball_blue">124%</p></td>
                        <td>6,830</td>
                        <td>7,386</td>
                        <td><p class="ball_blue">108%</p></td>
                        <td>162</td>
                        <td>191</td>
                        <td><p class="ball_blue">118%</p></td>
                    </tr>
                    <tr>
                      <th class="NewDateSumTit">전략사업본부</th>
                      <td class="NewDateSum">21,391</td>
                      <td class="NewDateSum">21,808</td>
                      <td class="NewDateSum"><p class="ball_blue">102%</p></td>
                      <td class="NewDateSum">99</td>
                      <td class="NewDateSum">44</td>
                      <td class="NewDateSum"><p class="ball_red">45%</p></td>
                      <td class="NewDateSum">44,206</td>
                      <td class="NewDateSum">41,951</td>
                      <td class="NewDateSum"><p class="ball_yellow">95%</p></td>
                      <td class="NewDateSum">282</td>
                      <td class="NewDateSum">121</td>
                      <td class="NewDateSum"><p class="ball_red">43%</p></td>
                    </tr>
                    <tr>
                        <th class="SumAllTit">전사 계</th>
                        <td class="SumAll">47,475</td>
                        <td class="SumAll">49,712</td>
                        <td class="SumAll"><p class="ball_blue">105%</p></td>
                        <td class="SumAll">250</td>
                        <td class="SumAll">208</td>
                        <td class="SumAll"><p class="ball_red">83%</p></td>
                        <td class="SumAll">98,212</td>
                        <td class="SumAll">101,564</td>
                        <td class="SumAll"><p class="ball_blue">103%</p></td>
                        <td class="SumAll">647</td>
                        <td class="SumAll">521</td>
                        <td class="SumAll"><p class="ball_red">81%</p></td>
                    </tr>
                </tbody>
            </table>         
		</div>
        <div id="bottom_div"> 
            <div class="link_div">			            
                <ul>
                    <li><a href="javascript:getMasterMdAmProxyMainWorkProcess();"><img src="/resources/images/m_link_img11.gif" alt="나의주요업무처리 - 나의주요업무처리를 한 눈에 보실 수 있습니다." /></a></li> 
                    <li><a href="javascript:openSearchPopup('/common/misUserSelectAllPop2.do','','500,500,no')"><img src="/resources/images/m_link_img1.gif" alt="고객사 바로가기 - 고객사 업무화면 이용안내를 한 눈에 보실 수 있습니다." /></a></li>
                    <li><a href="javascript:getKepbuyerGo();"><img src="/resources/images/m_link_img2.gif" alt="사무용품 신청 - 코리아 e 플랫폼에 관한 모든 정보를 알 수 있습니다." /></a></li>
                    <li><a href="/resources/excel/work/MAIN/information_policy.zip"><img src="/resources/images/m_link_img3.gif" alt="정보보호정책 지침서 - Maker에 관한 자세한 정보를 한 눈에 보실 수 있습니다." /></a></li>
                    <li><a href="javascript:openSearchPopup('/common/textConverterPop.do','','550,380,no')"><img src="/resources/images/m_link_img9.gif" alt="텍스트 변환기 - 텍스트 대/소문자를 변환할 수 있습니다." /></a></li>
                </ul>
            </div>
        </div>
        <div id="middle_div">
            <div class="sub_table_div sub_table_div_first">
                <div class="sub_table_summ ">
                    <div><img src="/resources/images/m_sub_tit.gif" alt="신규품목매익률 (단위:백만원)" /></div>
                </div>
                <div class="tbl_wrap">
                    <!--신규품목매입률-->
                    <table class="ProfitRate" summary="신규품목매입률" width="563px">
                        <caption>신규품목매입률</caption>
                        <colgroup>
                            <col width="108px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="AllBg" rowspan="2">팀명</th>
                                <th class="AllBg" rowspan="2">목표<br/>매익률</th>
                                <th class="greenBg" colspan="3">누적(2026.01~08)</th> 
                                <th class="greenBg" colspan="3">월(2026.08)</th>
                            </tr> 
                            <tr class="second_head">
                                <th class="grayBg">매출금액</th>
                                <th class="grayBg">매익금액</th>
                                <th class="grayBg">매익률</th>
                                <th class="grayBg">매출금액</th>
                                <th class="grayBg">매익금액</th>
                                <th class="grayBg">매익률</th>
                            </tr> 
                        </thead>
                        <tbody>

                            <tr>
                                <th height="25">중부사업팀</th>
                                <td class="first"><p>2.46%</p></td>
                                <td>6,366</td>
                                <td>276</td>
                                <td>4.33%</td>
                                <td>704</td>
                                <td>33</td>
                                <td class="last">4.72%</td>                        	
                            </tr> 
                            <tr>
                                <th height="25">남부사업팀</th>
                                <td class="first">1.67%</td>
                                <td>4,575</td>
                                <td>174</td>
                                <td>3.81%</td>
                                <td>338</td>
                                <td>14</td>
                                <td class="last">4.06%</td>                        	
                            </tr>
                            <tr>
                              <th height="25">SMART팀</th>
                              <td class="first">3.25%</td>
                              <td>1,528</td>
                              <td>44</td>
                              <td>2.85%</td>
                              <td><p>168</p></td>
                              <td>3</td>
                              <td class="last">1.78%</td>
                            </tr>
                             <tr>
                              <th height="25">Bio Lab사업팀</th>
                              <td class="first">2.51%</td>
                              <td>1,846</td>
                              <td>82</td>
                              <td>4.43%</td>
                              <td>303</td>
                              <td>9</td>
                              <td class="last">2.95%</td>
                            </tr>                           
                            <tr>
                              <th height="25">특판. 판촉사업그룹</th>
                                <td class="first">1%</td>
                                <td>4,794</td>
                                <td>281</td>
                                <td>5.87%</td>
                                <td>602</td>
                                <td>19</td>
                                <td class="last">3.17%</td>                        	
                            </tr>
                            <tr>
                              <th height="25">특판. IT사업그룹</th>
                              <td class="first">0.5%</td>
                              <td>2,201</td>
                              <td>84</td>
                              <td>3.81%</td>
                              <td>282</td>
                              <td>12</td>
                              <td class="last">4.25%</td>
                            </tr>
                            <tr>
                                <th height="25">수도권사업팀</th>
                                <td class="first"><p>2.55%</p></td>
                                <td>3,288</td>
                                <td>133</td>
                                <td>4.05%</td>
                                <td>282</td>
                                <td>15</td>
                                <td class="last">5.3%</td>                         	
                            </tr>                             
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="sub_table_div sub_table_div2">
                <div class="sub_table_summ ">
                    <div ><img src="/resources/images/m_sub_tbl_tit2.gif" alt="노마진역마진 (단위:백만원)" /></div >
                </div>
                <div class="tbl_wrap">
                    <!--노마진역마진-->
                    <table class="Margin" summary="노마진역마진" width="563px">
                        <caption>노마진역마진</caption>
                        <colgroup>
                            <col width="108px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                            <col width="65px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="AllBg" rowspan="2">팀명</th>
                                <th class="greenBg" colspan="2">전체</th> 
                                <th class="greenBg" colspan="2">노마진</th> 
                                <th class="greenBg" colspan="3">역마진</th>
                            </tr> 
                            <tr class="second_head">
                                <th height="34" class="grayBg">품목수</th>
                                <th class="grayBg">매익률</th>
                                <th class="grayBg">품목수</th>
                                <th class="grayBg">매출비중</th>
                                <th class="grayBg">품목수</th>
                                <th class="grayBg">매출비중</th>
                                <th class="grayBg">역매익액</th>
                            </tr> 
                        </thead>
                        <tbody>

                            <tr>
                                <th height="25">중부사업팀</th>
                                <td class="first">11,183</td>
                                <td class="td2">4.62%</td>
                                <td>224</td>
                                <td>4.21%</td>
                                <td>841</td>
                                <td>2.43%</td>
                                <td class="last">-18</td>                               	
                            </tr>
                            <tr>
                                <th height="25">남부사업팀</th>
                                <td class="first">15,242</td>
                                <td class="td2">3.63%</td>
                                <td>1,146</td>
                                <td>17.93%</td>
                                <td>1,825</td>
                                <td>4.66%</td>
                                <td class="last">-73</td>                              	
                            </tr>
                            <tr>
                                <th height="25">SMART팀</th>
                                <td class="first">4,229</td>
                                <td class="td2">1.74%</td>
                                <td>19</td>
                                <td>0.11%</td>
                                <td>246</td>
                                <td>7.33%</td>
                                <td class="last">-5</td>           
                            </tr>
                            <tr>
                              <th height="25">Bio Lab사업팀</th>
                              <td class="first">9,503</td>
                              <td class="td2">3.95%</td>
                              <td>304</td>
                              <td>4.55%</td>
                              <td>1,181</td>
                              <td>13.01%</td>
                              <td class="last">-49</td>
                            </tr>                            
                            <tr>
                                <th height="25">특판. 판촉사업그룹</th>
                                <td class="first">779</td>
                                <td class="td2">4.87%</td>
                                <td>31</td>
                                <td>9.88%</td>
                                <td>84</td>
                                <td>0.21%</td>
                                <td class="last">0</td>         
                            </tr>
                            <tr>
                              <th height="25">특판. IT사업그룹</th>
                              <td class="first">276</td>
                              <td class="td2">2.5%</td>
                              <td>8</td>
                              <td>36.29%</td>
                              <td>5</td>
                              <td>0.05%</td>
                              <td class="last">0</td>
                            </tr>  
                            <tr>
                                <th height="25">수도권사업팀</th>
                                <td class="first">14,603</td>
                                <td class="td2">3.49%</td>
                                <td>894</td>
                                <td>17.13%</td>
                                <td>1,747</td>
                                <td>6.35%</td>
                                <td class="last">-27</td>                        	
                            </tr>                             
                        </tbody>
                    </table>
                 </div>
            </div>                  
        </div>       
    </div>
    
  
<!--내용 종료-->	       
<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>    
</div>
	
</body>
</html>			