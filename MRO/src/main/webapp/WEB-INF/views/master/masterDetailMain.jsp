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
	if (sessionInfo != null){ 
		st_muser_type =  CommonUtil.nvl((String)sessionInfo.getUserType());  
	}  
	
	
	
%> 
<script type="text/javascript">
 
function getKepbuyerGo()
{
 
    alert("해당 사용자 아이디로 고객사 로그인 해주세요."); 
 
    //document.forms.contentForm.action = "/kr/buyer/main/home/buyer_home.jsp";
    //document.forms.contentForm.submit();
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
<body>
<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="masterHeader"/>
<c:param name="part" value="masterHeader"/>
<c:param name="upperId" value="${param.upperId}"/>
</c:import>
<!--내용 시작-->	      
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
                <div class="wrap_tbl">
                    <table class="t_masterMain01" summary="달성률">
                    	<colgroup>
                        	<col width="114px">
                            <col width="86px">
                            <col width="86px">
                            <col width="91px">
                            <col width="85px">
                            <col width="85px">
                            <col width="90px">
                            <col width="85px">
                            <col width="85px">
                            <col width="90px">
                            <col width="85px">
                            <col width="85px">
                            <col width="90px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="bigtit">2014 KeP 팀실적</th>
                                <th colspan="3" class="bigtit">6월 매출</th>
                                <th colspan="3" class="bigtit">6월 직접영업이익</th>
                                <th colspan="3" class="bigtit">2분기 매출누계</th>
                                <th colspan="3" class="bigtit">2분기 직접영업이익 누계</th>
                            </tr>
                            <tr>
                                <th class="fontblue">구매대행 사업본부</th>
                                <th>계획</th>
                                <th>실적</th>
                                <th>달성율</th>
                                <th>계획</th>
                                <th>실적</th>
                                <th>달성율</th>
                                <th>계획</th>
                                <th>실적</th>
                                <th>달성율</th>
                                <th>계획</th>
                                <th>실적</th>
                                <th>달성율</th>
                            </tr>
                        <thead>
                        <tbody>
                        	<tr>
                            	<th class="row" scope="row">수도권사업팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">중서부사업팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">서비스Biz사업팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">건설사업팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">남부사업1팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">남부사업2팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr>
                            	<th class="row" scope="row">대구_경북사업팀</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        	<tr class="last">
                            	<th class="row" scope="row">계</th>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_blue">96%</p></td>
                            	<td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_red">96%</p></td>
                                <td>12,000</td>
                            	<td>12,000</td>
                            	<td><p class="ball_yellow">96%</p></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
        	</div>
            <div id="bottom_div"> 
                <div class="link_div">			            
                    <ul>
                        <li><a href="javascript:getMasterMdAmProxyMainWorkProcess();"><img src="/resources/images/m_link_img11.gif" alt="나의주요업무처리 - 나의주요업무처리를 한 눈에 보실 수 있습니다." /></a></li> 
                        <li><a href="javascript:openSearchPopup('/common/misUserSelectAllPop2.do','','500,500,no')"><img src="/resources/images/m_link_img1.gif" alt="고객사 바로가기 - 고객사 업무화면 이용안내를 한 눈에 보실 수 있습니다." /></a></li>
                        <li><a href="javascript:getKepbuyerGo();"><img src="/resources/images/m_link_img2.gif" alt="사무용품 신청 - 코리아 e 플랫폼에 관한 모든 정보를 알 수 있습니다." /></a></li>
                        <li><a href="/resources/excel/work/MAIN/information_policy.zip"><img src="/resources/images/m_link_img3.gif" alt="정보보호정책 지침서 - Maker에 관한 자세한 정보를 한 눈에 보실 수 있습니다." /></a></li>
                    </ul>
                </div>
            </div>
            <div id="middle_div">
                <div class="sub_table_div sub_table_div_first">
                    <div class="sub_table_summ ">
                        <div><img src="/resources/images/m_sub_tit.gif" alt="신규품목매익률 (단위:백만원)" /></div >
                        <p><a href="javascript:alert('준비중')"><img src="/resources/images/m_btn_more.gif" alt="더보기" /></a></p>
                    </div>
                    <div class="tbl_wrap">
                        <table class="t_masterMain02" summary="신규품목매입률" style="width:563px">
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
                                    <th class="greenBg" rowspan="2">팀명</th>
                                    <th class="greenBg" rowspan="2">목표<br/>매익률</th>
                                    <th class="greenBg" colspan="3">누적(2011.01~06)</th> 
                                    <th class="greenBg" colspan="3">월(2011.06)</th>
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
                                    <th>수도권사업팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr> 
                                <tr>
                                    <th>중서부사업팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr> 
                                <tr>
                                    <th>서비스Biz사업팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr> 
                                <tr>
                                    <th>남부사업1팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr> 
                                <tr>
                                    <th>남부사업2팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr>
                                <tr>
                                    <th>대구_경북사업팀</th>
                                    <td class="first">5.32%</td>
                                    <td>4,467</td>
                                    <td>228</td>
                                    <td>5.1%</td>
                                    <td>553</td>
                                    <td>28</td>
                                    <td class="last">4.99%</td>                        	
                                </tr>                       
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="sub_table_div sub_table_div2">
                    <div class="sub_table_summ ">
                        <div ><img src="/resources/images/m_sub_tbl_tit2.gif" alt="노마진역마진 (단위:백만원)" /></div >
                        <p><a href="javascript:alert('준비중')"><img src="/resources/images/m_btn_more.gif" alt="더보기" /></a></p>
                    </div>
                    <div class="tbl_wrap">
                        <table class="t_masterMain03" summary="신규품목매입률" style="width:563px">
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
                                    <th class="greenBg" rowspan="2">팀명</th>
                                    <th class="greenBg" colspan="2">전체</th> 
                                    <th class="greenBg" colspan="2">노마진</th> 
                                    <th class="greenBg" colspan="3">역마진</th>
                                </tr> 
                                <tr class="second_head">
                                    <th class="grayBg">품목수</th>
                                    <th class="grayBg">매익률</th>
                                    <th class="grayBg">품목수</th>
                                    <th class="grayBg">매익률</th>
                                    <th class="grayBg">품목수</th>
                                    <th class="grayBg">매출비중</th>
                                    <th class="grayBg">역매익액</th>
                                </tr> 
                            </thead>
                            <tbody>
                                <tr>
                                    <th>수도권사업팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>                        	
                                </tr> 
                                <tr>
                                    <th>중서부사업팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>                               	
                                </tr>
                                <tr>
                                    <th>서비스Biz사업팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>                               	
                                </tr>
                                <tr>
                                    <th>남부사업1팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>                              	
                                </tr>
                                <tr>
                                    <th>남부사업2팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>           
                                </tr>
                                <tr>
                                    <th>대구_경북사업팀</th>
                                    <td class="first">11,773</td>
                                    <td class="td2">3.27%</td>
                                    <td>562</td>
                                    <td>5.34%</td>
                                    <td>123</td>
                                    <td>-0.15%</td>
                                    <td class="last">-16</td>         
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
