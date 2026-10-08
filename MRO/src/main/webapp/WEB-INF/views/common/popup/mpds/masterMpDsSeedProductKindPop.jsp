<%--
**********************************************
* 메뉴 : 종자화면 조회조건
* 화면 : 동부포장지 도안관리(종자구분)
* 기능 : 관리되는 도안목록을 확인하기 위한 팝업
* 프로그램 ID : PG_07_M_002_05
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
String st_froduct_flag = CommonUtil.nvl((String) request.getParameter("st_product_flag"),"");  //  (조회조건)

%>

<script type="text/javascript">

function kepConfirm(){
	var st_product_flag = $("#st_product_flag").val();
	opener.setPopupReturn(st_product_flag ,"");
    this.close();
}



</script> 
<body onload="">
<form name="masterMpDsSeedKindPop" id="masterMpDsSeedKindPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:204px;">
    	<div id="popHeader">
        	<h1 class="title">제품 구분</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
<!--              <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>  -->  
            <!--조회영역-->
<%--             <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>발주생성 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>검색어</td>
							<td> 
								<input type=text name=st_req_dept_name id="st_req_dept_name" size=20 value="<%=st_req_dept_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>  --%>           
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
<!--                     <caption>발주생성 리스트</caption> -->
<!--                     <colgroup> -->
<!--                         <col width="20%" />  -->
<!--                         <col width="30%" />  -->
<!--                         <col width="*" />  -->
<!--                     </colgroup> -->
<!--                     <thead> -->
<!--                         <tr> -->
<!--                             <th scope="col">부서코드</th>  -->
<!--                             <th scope="col">요약 부서명</th>  -->
<!--                             <th scope="col">상세 부서명</th>  -->
<!--                         </tr> -->
<!--                     </thead> -->
                    <tbody>

						<tr bgcolor="#FFFFFF" >
							<td>
								<input type="hidden" id="st_product_flag"  name="st_product_flag"  value="<%=st_froduct_flag%>">
								<input type="radio" name="pf" value="H1"  <%=("H1".equals(st_froduct_flag) ? "checked" : "")%> onclick="kepRadioSet('st_product_flag', this)">흥농
								<input type="radio" name="pf" value="H2"  <%=("H2".equals(st_froduct_flag) ? "checked" : "")%> onclick="kepRadioSet('st_product_flag', this)">한농
								<input type="radio" name="pf" value="D1"  <%=("D1".equals(st_froduct_flag) ? "checked" : "")%> onclick="kepRadioSet('st_product_flag', this)">대농&nbsp;&nbsp;
							</td>
					    </tr>
                    </tbody>
                </table>
				<!--버튼영역-->
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
					<!-- <span class="btn_02"><a href="javaScript:window.close();">닫기</a></span> -->
				</span>                                  
        </div>
    </div>
</div>
</form> 

</body>
</html>
