<%--
**********************************************
* 메뉴 : 종자화면 조회조건
* 화면 : 동부포장지 도안관리(종자구분)
* 기능 : 관리되는 도안목록을 확인하기 위한 팝업
* 프로그램 ID : PG_07_M_002_05
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
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
// List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String item_code = CommonUtil.nvl((String) request.getParameter("st_item_code"),"");  //  (조회조건)
%>

<script type="text/javascript">
function kepSearch()
{  
  $('#masterMpDsSeedKindPop').attr("action", "/mpds/getMasterMpDsSeedKindPop.do").submit();    
}

function kepConfirm(){
	var item_code;
	var item_name;

	if(document.forms[0].수박.checked == true ) {
			item_code = "A01";
			item_name = "수박";
	}else if(document.forms[0].참외.checked == true){
			item_code = "A02";
			item_name = "참외";
	}else if(document.forms[0].대목.checked == true){
			item_code = "A03";
			item_name = "대목";
	}else if(document.forms[0].토마토.checked == true){
			item_code = "A04";
			item_name = "토마토";
	}else if(document.forms[0].파프리카.checked == true){
			item_code = "A05";
			item_name = "파프리카";
	}else if(document.forms[0].고추.checked == true){
			item_code = "B01";
			item_name = "고추";
	}else if(document.forms[0].가지.checked == true){
			item_code = "B02";
			item_name = "가지";
	}else if(document.forms[0].오이.checked == true){
			item_code = "B03";
			item_name = "오이";
	}else if(document.forms[0].호박.checked == true){
			item_code = "B04";
			item_name = "호박";
	}else if(document.forms[0].옥수수.checked == true){
			item_code = "B05";
			item_name = "옥수수";
	}else if(document.forms[0].시너지.checked == true){
			item_code = "B06";
			item_name = "시너지";
	}else if(document.forms[0].양파.checked == true){
			item_code = "C01";
			item_name = "양파";
	}else if(document.forms[0].파.checked == true){
			item_code = "C02";
			item_name = "파";
	}else if(document.forms[0].당근.checked == true){
			item_code = "C03";
			item_name = "당근";
	}else if(document.forms[0].시금치.checked == true){
			item_code = "C04";
			item_name = "시금치";
	}else if(document.forms[0].멜론.checked == true){
			item_code = "C05";
			item_name = "멜론";
	}else if(document.forms[0].상추.checked == true){
			item_code = "C06";
			item_name = "상추";
	}else if(document.forms[0].기타.checked == true){
			item_code = "C07";
			item_name = "기타";
	}else if(document.forms[0].무.checked == true){
			item_code = "D01";
			item_name = "무";
	}else if(document.forms[0].배추.checked == true){
			item_code = "D02";
			item_name = "배추";
	}else if(document.forms[0].양배추.checked == true){
			item_code = "D03";
			item_name = "양배추";
	}else if(document.forms[0].브로콜리.checked == true){
			item_code = "D04";
			item_name = "브로콜리";
	}

	opener.setPopupReturn(item_code , item_name );
    this.close();
}


function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

</script> 
<body onload="">
<form name="masterMpDsSeedKindPop" id="masterMpDsSeedKindPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:324px;">
    	<div id="popHeader">
        	<h1 class="title">종자 등록</h1>
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
						  <td height="25" style="text-align: left;width: 25%" >
							<input type="radio" class="Noborder"  name="item_no"  id = "수박" style="border:0px" <%= (item_code.equals("A01") ?  "checked" : "")%> >수박&nbsp;
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "고추" style="border:0px" <%= (item_code.equals("B01") ?  "checked" : "")%>  >고추&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "양파" style="border:0px" <%= (item_code.equals("C01") ?  "checked" : "")%> >양파&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "무" style="border:0px" <%= (item_code.equals("D01") ?  "checked" : "")%>  >무&nbsp
						  </td>
					    </tr>
					    <tr bgcolor="#FFFFFF" >
						  <td height="25" style="text-align: left;width: 25%" >
							<input type="radio" class="Noborder"  name="item_no"  id = "참외" style="border:0px" <%= (item_code.equals("A02") ?  "checked" : "")%> >참외&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "가지" style="border:0px" <%= (item_code.equals("B02") ?  "checked" : "")%>  >가지&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "파" style="border:0px" <%= (item_code.equals("C02") ?  "checked" : "")%>  >파&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "배추" style="border:0px" <%= (item_code.equals("D02") ?  "checked" : "")%> >배추&nbsp
						  </td>
					    </tr>
		
					    <tr bgcolor="#FFFFFF" >
						  <td height="25" style="text-align: left;width: 25%" >
							<input type="radio" class="Noborder"  name="item_no"  id = "대목" style="border:0px" <%= (item_code.equals("A03") ?  "checked" : "")%> >대목&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "오이" style="border:0px" <%= (item_code.equals("B03") ?  "checked" : "")%> >오이&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "당근" style="border:0px"  <%= (item_code.equals("C03") ?  "checked" : "")%> >당근&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "양배추" style="border:0px" <%= (item_code.equals("D03") ?  "checked" : "")%> >양배추&nbsp
						  </td>
					    </tr>
					    <tr bgcolor="#FFFFFF" >
						  <td height="25" style="text-align: left;width: 25%" >
							<input type="radio" class="Noborder"  name="item_no"  id = "토마토" style="border:0px" <%= (item_code.equals("A04") ?  "checked" : "")%> >토마토&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "호박" style="border:0px" <%= (item_code.equals("B04") ?  "checked" : "")%> >호박&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "시금치" style="border:0px" <%= (item_code.equals("C04") ?  "checked" : "")%> >시금치&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "브로콜리" style="border:0px" <%= (item_code.equals("D04") ?  "checked" : "")%> >브로콜리&nbsp
						  </td>
					    </tr>
		
					    <tr bgcolor="#FFFFFF" >
						  <td height="25" style="text-align: left;width: 25%" >
							<input type="radio" class="Noborder"  name="item_no"  id = "파프리카" style="border:0px" <%= (item_code.equals("A05") ?  "checked" : "")%> >파프리카&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "옥수수" style="border:0px" <%= (item_code.equals("B05") ?  "checked" : "")%>  >옥수수&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "멜론" style="border:0px" <%= (item_code.equals("C05") ?  "checked" : "")%>  >멜론&nbsp
						  </td>
						   <td height="25" style="text-align: left;width: 25%" >
						  <input type="radio" class="Noborder"  name="item_no"  id = "기타" style="border:0px" <%= (item_code.equals("C07") ?  "checked" : "")%>  >기타&nbsp
						  </td>
					    </tr>
		
						    <tr bgcolor="#FFFFFF" >
						  <td height="25" style="text-align: left;width: 25%" >
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "시너지" style="border:0px" <%= (item_code.equals("B06") ?  "checked" : "")%>  >시너지&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
						    <input type="radio" class="Noborder"  name="item_no"  id = "상추" style="border:0px" <%= (item_code.equals("C06") ?  "checked" : "")%>  >상추&nbsp
						  </td>
						  <td height="25" style="text-align: left;width: 25%" >
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
