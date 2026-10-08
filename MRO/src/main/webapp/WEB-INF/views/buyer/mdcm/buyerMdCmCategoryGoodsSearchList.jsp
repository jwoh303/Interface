<%--
**********************************************
* 메뉴 : 상품검색>카테고리상품검색
* 화면 : 카테고리상품검색
* 기능 : 고객사 전용 또는 공통 상품카테고리를 조회할 수 있다.
* 프로그램 ID : PG_06_B_001_00
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-05-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
</head>
<%
	String usingCatalType = "";
	String bycaComorgCode = "";
	String userID = "";		
	if (_sessionInfo != null){
		usingCatalType =  CommonUtil.nvl((String)_sessionInfo.getUsingCatalType()); 	 // 사용카탈로그타입(1:전용 2:공통 3:둘다 , 재개발 A:전용 B:공통 C:둘다 , Z:전자입찰)
		bycaComorgCode =  CommonUtil.nvl((String)_sessionInfo.getBycaComorgCode());
		userID =  CommonUtil.nvl((String)_sessionInfo.getUserId());
	}
%>  

<body onLoad = "kep_onload_view();"> 
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	 <h3><%=CommonLang.get("HTITLE1")%></h3><!-- 카테고리상품검색 -->
	 	<% if(bycaComorgCode.equals("KRKOLO0031")) { %>
    <b><%=CommonLang.msg("MSG345")%></b> <!-- ※ 찾는 상품이 없을시 인사총무팀(02-2120-7898)으로 연락바랍니다. -->
<%} %>    
	 <h4  id="topmenunnavi"></h4> 
	<form name="cenbody" id="cenbody">   
<input type="hidden" name="byca_comorg_code" id="byca_comorg_code"  value="<%=bycaComorgCode%>" />
<input type="hidden" name="category_name1" id="category_name1"  />
<input type="hidden" name="category_name2" id="category_name2"  />
<input type="hidden" name="category_name3" id="category_name3"  />
<input type="hidden" name="tmp_categ_text" id="tmp_categ_text" value="${param.tmp_categ_text}" />
            <div id="cateArea">
            	<div id="cateA">
                	<p class="cateTitleA"><%=CommonLang.get("HTITLE2")%></p> <!-- 대분류 -->
                    <div id="cate01">
                    	<ul class="cateMenu" id="cateMenu1"> 
                        </ul>
                    </div>
                </div>
                
              <div id="cateB">
                	<p class="cateTitleB"><%=CommonLang.get("HTITLE3")%></p> <!-- 중분류 -->
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu2"> 
                        </ul>
                  </div>
                </div>
                
                <div id="cateC">
                	<p class="cateTitleC"><%=CommonLang.get("HTITLE4")%></p> <!-- 소분류 -->
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu3"> 
                        </ul>
                    </div>
                </div>
                
                <div id="cateD">
                	<p class="cateTitleD"><%=CommonLang.get("HTITLE5")%></p> <!-- 최종분류 -->
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu4"> 
                        </ul>
                    </div>
                </div>
            </div>
</form>
	</div>
	

<!--내용 종료-->	                 
<br>
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript"> 

var popupSel = "";
// 조회 내용이 없습니다.
var nodata = "<li><%=CommonLang.msg("MSG346")%></li>";

// 선택한 카테고리 정보 저장용
var categ_2_text = "";
var categ_3_text = "";
var categ_4_text = "";
var categ_front_text = "";
var categ_rear_text = "";
var categ_tot_text = "";
var categ_name_text = "";

//최초 화면 함수 
function kep_onload_view(){  

   kep_categori_clear();
   var check_comorg_code = $("#byca_comorg_code").val();

   <% if(usingCatalType.equals("C")) { %>
   if(check_comorg_code == "KRCOMMG001") {
   //  $("#topmenun").html("<a href='javascript:kep_setCatalogCommg()'>전용카탈로그</a>");
   }else {
  //   $("#topmenun").html("<a href='javascript:kep_setCatalogCommg()'>공통카탈로그</a>");
   } 
   <%}else{%>
	// $("#topmenun").html("전용카탈로그");
   <%}%>

   // 카테고리 조회 
   byca_comorg_code =  $("#byca_comorg_code").val(); 
   kep_getCategoriList(byca_comorg_code,"1","");
   
	var tmp_categ_text = unescape($("#tmp_categ_text").val());
   	var depth = new Array();
   	var depth_categ_id = new Array();
   	var depth_categ_name = new Array();
   	
   	// 상품검색 화면에서 이전화면 클릭한 경우
   	if(tmp_categ_text != ""){
   		var menuTmpArr = tmp_categ_text.split("@", -1);

   		for(var i=0; i<menuTmpArr.length; i++){
   			var valTmpArr = menuTmpArr[i].split("^");
   			depth[i] = valTmpArr[0]; // 분류 구분
   			depth_categ_id[i] = valTmpArr[1]; // 카테고리ID
   			depth_categ_name[i] = valTmpArr[2]; // 카테고리명

   			categ_2_text = menuTmpArr[0] + "@";
   			categ_3_text = menuTmpArr[1] + "@";
   			categ_4_text = menuTmpArr[2] + "@";
   			categ_front_text = categ_2_text + categ_3_text + categ_4_text;
   			
   			kep_topmenunnavi(depth[i], depth_categ_name[i]);
   			kep_getCategoriList(byca_comorg_code, depth[i], depth_categ_id[i]);
   		}
   	}
}

/*
 * 카테고리 공통/전용 보이기/숨기기
 */
function kep_setCatalogCommg()
{
   var check_comorg_code = $("#byca_comorg_code").val();

   if(check_comorg_code == "KRCOMMG001") {
     $("#byca_comorg_code").val("<%=bycaComorgCode%>");
  //   $("#topmenun").html("<a href='javascript:kep_setCatalogCommg()'>공통카탈로그</a>");
   }else {
    $("#byca_comorg_code").val("KRCOMMG001"); 
 //    $("#topmenun").html("<a href='javascript:kep_setCatalogCommg()'>전용카탈로그</a>");
   }

   byca_comorg_code =  $("#byca_comorg_code").val(); 
	// 전체
   kep_topmenunnavi(1,"<%=CommonLang.get("HTITLE1")%>");	

   // 카테고리 조회
   kep_getCategoriList(byca_comorg_code,"1","");
}

/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth,std_categ_id,categ_name) {  
	$("#tmp_categ_text").val("");
	var byca_comorg_code =  $("#byca_comorg_code").val();  

	if(depth == 2){
		categ_2_text = depth + "^" + std_categ_id + "^" + categ_name + "@";
		categ_3_text = "";
		categ_4_text = "";
	}else if(depth == 3){
		categ_3_text = depth + "^" + std_categ_id + "^" + categ_name + "@";
		categ_4_text = "";
	}else if(depth == 4){
		categ_4_text = depth + "^" + std_categ_id + "^" + categ_name + "@";
	}
	
	categ_front_text = categ_2_text + categ_3_text + categ_4_text;
	
	kep_topmenunnavi(depth,categ_name);
	kep_getCategoriList(byca_comorg_code,depth,std_categ_id); // 고객사,분류 depth,카테고리아이디 
}

/*
 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
 */
function kep_sel_getItmeList(depth,std_categ_id,categ_name){
	//alert(std_categ_id + " " +categ_name);
	/*
	var categ_code =  std_categ_id; 
	var buyer =  $("#byca_comorg_code").val(); 
	var byca_comorg_code =  $("#byca_comorg_code").val(); 
	
	$("#buyerCategItemListLocation_categ_code").val(categ_code);  // 카테고리번호
	$("#buyerCategItemListLocation_byca_comorg_code").val(byca_comorg_code);  
	$("#quickCategoriArea").hide();
	
	 $('#buyerCategItemListLocation').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();    
	 */

	if(depth == 2){
		categ_2_text = "";
		categ_rear_text = "@3^^@4^^@5^^";
	}else if(depth == 3){
		categ_3_text = "";
		categ_rear_text = "@4^^@5^^";
	}else if(depth == 4){
		categ_4_text = "";
		categ_rear_text = "@5^^";
	}
	 
	categ_tot_text = categ_2_text + categ_3_text + categ_4_text + depth + "^" + std_categ_id + "^" + categ_name + categ_rear_text;
	
	document.searchDiForm.st_tmp_categ_text.value = escape(categ_tot_text); // 상품 검색결과 화면으로 전송 특수문자 및 한글 때문에 escape
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.onepagerow.value = "10";
	document.searchDiForm.curPage.value = "1";
	document.searchDiForm.st_image_status.value = "";
	document.searchDiForm.groupCategoryText.value = "";
	document.searchDiForm.groupMakerName.value = "";
	document.searchDiForm.searchSort.value = "";
	document.searchDiForm.st_sort_change.value = "";	 
	document.searchDiForm.searchTarget.value = "CATEG_NAME";	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = std_categ_id;	 
	document.searchDiForm.searchTerm.value = categ_name;
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
 
}
/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(depth,categ_name){
	if(depth==1){		   
		$("#category_name1").val("");
	   	$("#category_name2").val("");
	   	$("#category_name3").val("");
	}else if(depth==2){
		if(categ_name != ""){
			$("#category_name1").val(categ_name);	
		}
	   	$("#category_name2").val("");
	   	$("#category_name3").val("");
	}else if(depth==3){
		if(categ_name != ""){
			$("#category_name2").val(" >"+categ_name);   
		}
	   	$("#category_name3").val("");
	}else if(depth==4){
		if(categ_name != ""){
			$("#category_name3").val(" >"+categ_name);	  
		}
	}
   
   $("#topmenunnavi").text("전체 >"+$("#category_name1").val() +  $("#category_name2").val() +  $("#category_name3").val());
}

// 고객사,분류 depth,카테고리아이디
/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(com_code,depth,std_categ_id) {  
	
		var strTmp = "";
		var p_depth = eval(depth)+1; 
		var strUserId = "<%=userID%>";
		if (depth == 1){
			$("#cateMenu2").html(nodata);
			$("#cateMenu3").html(nodata);
			$("#cateMenu4").html(nodata);
		}else if (depth == 2){ 
			$("#cateMenu3").html(nodata);
			$("#cateMenu4").html(nodata);
		}else if (depth == 3){  
			$("#cateMenu4").html(nodata);
		}
	 
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getCategoriList.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: com_code,param2: depth,param3: std_categ_id,param5: strUserId},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
	 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME_REAL")); 
	 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
	 		    		var D_CATEG_SYS_CODE = $.trim(eval("response.data["+i+"].CATEG_SYS_CODE")); 
	 		    		var D_PID = $.trim(eval("response.data["+i+"].PID")); 
	 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
	 		    		
	 		    		if (D_CNT == ""){
	 		    			strTmp += "<li><a class=\"catelink\"\"  href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\')\">"+D_CATEG_NAME+" "+D_CNT+"</li>";	    	
	 		    		}else{
	 		    			strTmp += "<li><a class=\"catelink\"\"  href=\"javascript:kep_sel_getItmeList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\')\">"+D_CATEG_NAME+" "+D_CNT+"</li>";	 			 	
	 		    		}
		 		      }	 		    //	class="selected"
	    		  }else{
	    			  strTmp = nodata;
	    		  }   	  
	    	 	
	    	 //	alert(strTmp);
					$("#cateMenu"+depth).html(strTmp);

			      },
			 error:function( response ) {  		    	   
		    	 alert("<%=CommonLang.msg("MSG15")%>"); //오류발생하였습니다.
			      }
	    });  
}
/*
 * 카테고리 선택된 대상 초기화
 */
function kep_categori_clear(){
		$("#cateMenu1").html(nodata);
		$("#cateMenu2").html(nodata);
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
}


</script>
</html>
