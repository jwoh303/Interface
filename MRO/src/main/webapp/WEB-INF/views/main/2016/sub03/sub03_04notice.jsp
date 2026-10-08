<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("dataList");

String total_cnt =  CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0");  // 조회된결과
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

String search_choice = CommonUtil.nvl((String) request.getParameter("search_choice"),"");
String search_word = CommonUtil.nvl((String) request.getParameter("search_word"),"");
%>
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
   	<form id="notice" name="notice" method="post"> 
   		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" id="onepagerow"  name="onepagerow" value="<%=onepagerow %>">     
		<input type="hidden" name="BID" id="BID" value="" />
		<input type="hidden" name="BTYPE" id="BTYPE" value="" />
    <div class="subcontentsArea">
    	<div class="subbanner" >
        	 
            <div class="subbannerimg"><img src="/resources/images/2016/SB14.jpg" /></div>
            <div class="subbannertxt" > 
            	<p class="sbtit">공지사항</p>
            	<p>작은 목소리에도 귀 기울이는 KeP!</p>
            </div>
            <div class="subbannerbg" ></div>
        </div>
        <div class="subtab">
        	<div class="subtabBg"></div>
            <div class="subtabList04">
            	<ul>
                    <a href="javascript:MovePage_2016('<%=httpurl%>','03', '01');"><li>FAQ</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '02');"><li>업무처리 프로세스</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','03', '03');"><li class="subtabOn">공지사항</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '01');"><li>신규협력사 가입안내</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '02');"><li>회원가입하기</li></a><a href="javascript:MovePage_2016('<%=httpurl%>','04', '03');"><li>계약서류 다운로드</li></a>
                </ul>  
            </div>
        </div>
		<div class="subcontent">
        	<div class="sub03_Nboard">
            코리아e플랫폼(주)의 산업용자재의 유통구조 개선 및 구매비용 절감을 통해 고객사의 경쟁력 확충에 기여하고 있으며 <br/>시장에서도 그 역할을 인정하고 있습니다. 보다 편리한 사이트 이용을 위해 신속한 소식과 새로운 정보를 전달해 드리겠습니다.
            <div class="Nboard">
                <table summary="공지사항에 대한 정보를 제공합니다." class="NboardTable">
                  <caption>공지사항</caption>
                  <colgroup>
                  <col width="100" />
                  <col width="630" />
                  <col width="150" />
                  <col width="100" />
                  <col width="100" />
                  </colgroup>
                  <thead>
                    <tr>
                      <th scope="col" class="first">번호</th>
                      <th scope="col">제목</th>
                      <th scope="col">작성자</th>
                      <th scope="col">게시일</th>
                      <th scope="col" class="last">조회수</th>
                    </tr>
                  </thead>
                  <tbody>
                      <%
				       if (_dataList == null || _dataList.size() == 0){
				       %>
				        	<tr>
		                        <td colspan="5" align="center" height = "50"> 
		                        현재 목록에 나와있는 자료가 없습니다.
		                        </td> 
		                    </tr>
				        <%
				        }else{
							for (int i=0; i<_dataList.size(); i++) {
								Map<String,String> rowData = _dataList.get(i);
						%> 
							<tr>
								<td><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(i+1) %></td>
								<td class="left"><a href="javascript:kepEditForm('<%=CommonUtil.bnvl( rowData.get("BID"))%>','<%=CommonUtil.bnvl( rowData.get("BTYPE"))%>')"><%=CommonUtil.bnvl( rowData.get("SUBJECT"))%></a></td>
								<td><%=String.valueOf(CommonUtil.nvl(rowData.get("REG_USER_NAME")))%></td>
								<td><%=CommonUtil.formatStrinigDate(rowData.get("REG_DATE"))%></td>
								<td><%=CommonUtil.formatNumber(String.valueOf(rowData.get("LCOUNT")),true,0,3)%></td>
							</tr>
						<%
			            	}
			        	}
			            %>
                  </tbody>
                </table> 
                <div class="NboardSearch">
                    <select name="search_choice" id="search_choice">
                       <option value="reg_user_name"  <%=search_choice.equals("reg_user_name")?"selected":""%>>작성자</option>
                       <option value="subject"  <%=search_choice.equals("subject")?"selected":""%>>제목</option>
                    </select>
                    <input type="text" name="search_word" id="search_word" value="<%=search_word%>"/>
                    <p class="bbt"><a href="javascript:kepSearch(1);">검색</a></p>
                
                </div>      
                 <!--페이징-->
                <div class="NboardPaging">
					    <%=CommonUtil.getMainPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
					    &nbsp;[ 총 <%=total_cnt %> 건 ] 
                </div>
            </div>
            </div>
        </div>
    </div>
    </form>
    <!--컨텐츠 끝-->
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
			<%@ include file="/WEB-INF/views/common/include/2016/mainFooter.jsp" %>
			<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	</div>
<script type="text/javascript">

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){ 

	document.forms.notice.curPage.value = curPage; 
	$('#notice').attr("action", "/main/2016/sub03/getSub03_04notice.do").submit(); 
}

/**
 * 상세폼이동
 */
function kepEditForm(bid,btype){ 
	
	document.forms.notice.BID.value = bid;
	document.forms.notice.BTYPE.value = btype;
	$('#notice').attr("action", "/main/2016/sub03/getSub03_04notice_view.do").submit();
}
</script>
</body>
</html>

