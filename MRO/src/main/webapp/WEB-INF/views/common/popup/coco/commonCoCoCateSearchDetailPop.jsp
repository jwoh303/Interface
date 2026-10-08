<%--
**********************************************
* 메뉴 : 
* 화면 : 상품 상세검색
* 기능 : 
* 프로그램 ID :  
* 담당자 : CEJ ( 설계 : 공통 )
* 착수일 : 2014-09-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<% 
 

%>

<script type="text/javascript">
<!--
function kep_onload_view() { 
}
 
//기능함수
function doAction(str) { 
	
	switch (str) { 
			
		case "search": // 조회 
		
			var st_description = $("#st_description").val();
			var st_specification = $("#st_specification").val();
			var st_maker = $("#st_maker").val();
			var st_categoty_name = $("#st_categoty_name").val();
			if (st_description == "" && st_specification == "" && st_maker == "" && st_categoty_name == ""   ){
				alert("검색할 조건을 입력하세요.");
				return;
			}
		
			 opener.setDetailSearch(st_description , st_specification , st_maker , st_categoty_name);
			 self.close();

			break;
	}
}

 //-->
</script> 
<body onload="kep_onload_view()">
<form name="commonCoCoCateSearchDetailPop" id="commonCoCoCateSearchDetailPop" method=post >  

	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE729") %><!-- 상품 상세검색 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
      <div id="contArea">
				<table  class="cont_t_list06"  style="width:100%">
					<caption>상품 상세검색</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" /> 
						<col width="*" />
					</colgroup>
					<tbody>  
						<tr>		  
							<th scope="col" ><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
							<td class="left">  <input type="text" id="st_description" name="st_description" style="width:80%;" class="input_type_text"  value="" /></td> 			
							<th scope="col" ><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
							<td class="left">  <input type="text" id="st_specification" name="st_specification" style="width:80%;" class="input_type_text"  value="" /></td> 												
						</tr> 
						<tr>		  
							<th scope="col" ><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th>
							<td class="left">  <input type="text" id="st_maker" name="st_maker" style="width:80%;" class="input_type_text"  value="" /></td> 			
							<th scope="col" ><%=CommonLang.get("HTITLE510") %><!-- 카테고리 --></th>
							<td class="left">  <input type="text" id="st_categoty_name" name="st_categoty_name" style="width:80%;" class="input_type_text"  value="" /></td> 												
						</tr> 		 
					</tbody>
				</table> 
				<div class="btnArea mt10 mb05">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE511") %><!-- 검색 --></a></span>
					</span>
				</div>
        </div>
        </div>        
</div>
</form> 
</body>
</html>
