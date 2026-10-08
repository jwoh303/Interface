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

Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}
%>
</head>
<body> 
	<div class="wrap" >
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<%@ include file="/WEB-INF/views/common/include/2016/mainHeader.jsp" %>
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
    <!--컨텐츠-->
  	<form id="notice" name="notice" method="post"> 
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
               <table summary="공지사항에 대한 정보를 제공합니다." class="NboardView">
                  <caption>
                  공지사항
                  </caption>
                  <colgroup>
                  <col width="108" />
                  <col width="140" />
                  <col width="125" />
                  <col width="121" />
                  <col width="104" />
                  <col width="100" />
                  </colgroup>
                  <thead>
                    <tr>
                      <th scope="row" >제목</th>	
                      <td scope="col" colspan="5"><%=CommonUtil.nvl(rowData.get("SUBJECT"))%></td>
                    </tr>
                    <tr>
                          <th scope="row" >작성자</th>
                          <td ><%=CommonUtil.nvl(rowData.get("REG_USER_NAME"))%></td>
                          <th >게시일</th>
                          <td ><%=CommonUtil.formatStrinigDate(rowData.get("REG_DATE"))%></td>
                          <th >조회수</th>
                          <td ><%=CommonUtil.formatNumber(rowData.get("LCOUNT"),true,0,3)%></td>
                    </tr>
                  </thead>
                  <tbody>
                       <tr>
                         <td colspan="6" >
                         <%=rowData.get("CONTEXT")%>
                         </td>
                       </tr>
                       <tr>
                         <th scope="row">이전글</th>
                         <td colspan="4" ><a href="javascript:kepEditForm('<%=CommonUtil.nvl( rowData.get("P_BID"))%>','<%=CommonUtil.nvl( rowData.get("P_BTYPE"))%>')"><%=CommonUtil.nvl(rowData.get("P_SUBJECT"))%></a></td>
                         <td ><%=CommonUtil.formatStrinigDate(rowData.get("P_REG_DATE"))%></td>
                       </tr>
                       <tr>
                         <th scope="row">다음글</th>
                         <td colspan="4" ><a href="javascript:kepEditForm('<%=CommonUtil.nvl( rowData.get("N_BID"))%>','<%=CommonUtil.nvl( rowData.get("N_BTYPE"))%>')"><%=CommonUtil.nvl(rowData.get("N_SUBJECT"))%></a></td>
                         <td ><%=CommonUtil.formatStrinigDate(rowData.get("N_REG_DATE"))%></td>
                       </tr>
                  </tbody>
                </table>
                <div class="NboardBtn"><a href="/main/2016/sub03/getSub03_04notice.do">목록</a></div>
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

