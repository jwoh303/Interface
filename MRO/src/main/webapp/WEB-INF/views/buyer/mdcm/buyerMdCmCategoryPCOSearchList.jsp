<%--
**********************************************
* 메뉴 : 상품검색>카테고리상품검색
* 화면 : 카테고리상품검색
* 기능 : 고객사 전용 또는 공통 상품카테고리를 조회할 수 있다.
* 프로그램 ID : PG_06_B_001_00
* 담당자 : 현명환
* 착수일 : 2015-04-01
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
	String SessionComCode="";
	String categroy_sh_flag    = CommonUtil.nvl((String) request.getParameter("categroy_sh_flag"),"");
	String st_categ_id    		   = CommonUtil.nvl((String) request.getParameter("st_categ_id"),"");
	String st_pid    			   = CommonUtil.nvl((String) request.getParameter("st_pid"),"");
	String st_categ_level    	   = CommonUtil.nvl((String) request.getParameter("st_categ_level"),"");
	String st_categ_type    	   = CommonUtil.nvl((String) request.getParameter("st_categ_type"),"");
	String st_categ_sys_code    = CommonUtil.nvl((String) request.getParameter("st_categ_sys_code"),"");
	String st_byca_comorg_code    = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");
	String st_search_text    = CommonUtil.nvl((String) request.getParameter("st_search_text"),"");
	if (_sessionInfo != null){
		usingCatalType =  CommonUtil.nvl((String)_sessionInfo.getUsingCatalType()); 	 // 사용카탈로그타입(1:전용 2:공통 3:둘다 , 재개발 A:전용 B:공통 C:둘다 , Z:전자입찰)
		bycaComorgCode =  CommonUtil.nvl((String)_sessionInfo.getBycaComorgCode()); 
		SessionComCode =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
	} 
	/*
	* 고객사에 따라 카탈로그 검색기준이 다름
	* A: 두산엔진 KRHSDE0003
	*/
	String p060000055 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000055","COL02_DATA"); // 검색조건변경
	
%>  

<body onLoad = "kep_onload_view();"> 
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	 <h3>카테고리상품검색</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>	 
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 	
	 <input type=hidden name="st_categ_id" id="st_categ_id"  value="<%=st_categ_id%>">
	 <input type=hidden name="st_pid" id="st_pid"  value="<%=st_pid%>">
	 <input type=hidden name="st_categ_level" id="st_categ_level"  value="<%=st_categ_level%>">
	 <input type=hidden name="st_categ_type" id="st_categ_type"  value="<%=st_categ_type%>">
	 <input type=hidden name="st_categ_sys_code" id="st_categ_sys_code"  value="<%=st_categ_sys_code%>">
	 <input type=hidden name="st_byca_comorg_code" id="st_byca_comorg_code"  value="<%=st_byca_comorg_code%>">
	 <input type=hidden name="st_sort_column" id="st_sort_column"  value="">
	 <input type=hidden name="st_categ_nm" id="st_categ_nm"  value="">
	 <input type=hidden name="st_s_logic" id="st_s_logic"  value="<%=p060000055%>">
</form>
	<form name="cenbody" id="cenbody">   
<input type="hidden" name="byca_comorg_code" id="byca_comorg_code"  value="<%=bycaComorgCode%>" />
<input type="hidden" name="category_name1" id="category_name1"  />
<input type="hidden" name="category_name2" id="category_name2"  />
<input type="hidden" name="category_name3" id="category_name3"  />
<input type="hidden" name="category_name4" id="category_name4"  />
<input type="hidden" name="categroy_sh_flag" value="<%=categroy_sh_flag%>">
		<div id="cont_searchA" >
            <table class="cont_t_list01">
				<caption>조회</caption>
                <colgroup>
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
   				</colgroup>				
				<tbody>
				<tr>
                    <th><select name = "st_search_type" class="TitSelect">
					            <option value="STD_CATEG_NM" <%="STD_NM".equals(request.getParameter("categroy_sh_flag"))?"selected":""%>>표준품명</option>
					            <option value="SYS_CATEG_NM" <%="SYS_NM".equals(request.getParameter("categroy_sh_flag"))?"selected":""%>>카테고리명</option>
                        </select>
                    </th>
					<td><input type="text"  class="input_type_text"   name="st_search_text" style="width:87%" value="<%=st_search_text%>"  onKeyDown="return searchEnter(event)" /></td>
					<td></td>
					<td></td>
                </tr>
				</tbody>
			</table>
			</div>
			<h4  id="topmenunnavi"></h4> 
            <div id="cateArea">
            	<div id="cateA">
                	<p class="cateTitleA">대분류</p>
                    <div id="cate01">
                    	<ul class="cateMenu" id="cateMenu2"> 
                        </ul>
                    </div>
                </div>
                
              <div id="cateB">
                	<p class="cateTitleB">중분류</p>
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu3"> 
                        </ul>
                  </div>
                </div>
                
                <div id="cateC">
                	<p class="cateTitleC">소분류</p>
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu4"> 
                        </ul>
                    </div>
                </div>
                
                <div id="cateD">
                <%if(p060000055.equals("A")){ %>
                	<p class="cateTitleD">표준품명</p>
                <%}else{%>
                	<p class="cateTitleD">최종분류</p>
                <%}%>
                    <div id="cate01">
                    	<ul class="cateMenu"  id="cateMenu5"> 
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
var nodata = "<li>조회 내용이 없습니다.</li>";

//최초 화면 함수 
function kep_onload_view(){  
   kep_categori_clear();
    var categ_id   =document.locationForm.st_categ_id.value;
    var slog =document.locationForm.st_s_logic.value;
	var stg_id = categ_id;
	var s_stg_id = ""; 
	if(slog =="A"){
		s_stg_id = "9";
	}
	if(categ_id == ""){
		stg_id ="R";
	}
	
	
	var byca_comorg_code =  $("#byca_comorg_code").val();

   kep_topmenunnavi(stg_id);
   if(slog =="A"){
	   kep_getCategoriList(byca_comorg_code,"2",s_stg_id);
   }else{
   		kep_getCategoriList(byca_comorg_code,"2","R");
	}
   
   if(document.locationForm.st_categ_sys_code.value != ""){
	 
	   var st_pid   =document.locationForm.st_pid.value;
	   var categ_level =document.locationForm.st_categ_level.value;
	   if(slog =="A"){
		   kep_getCategoriList(byca_comorg_code,"2",s_stg_id);
	   }else{
	   		kep_getCategoriList(byca_comorg_code,"2","R");
		}
	   if(categ_level >2){
	   		kep_getCategoriList(byca_comorg_code,"3",st_pid);
   		}else{
   			kep_getCategoriList(byca_comorg_code,"3",categ_id);
   		}
	   kep_getCategoriList(byca_comorg_code,"4",categ_id);
	   kep_getCategoriList(byca_comorg_code,"5",categ_id);
	  
   }
}
/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(stg_id){
	
	var D_STD_CATEG_NM =  "";

	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getStdCategoriList.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: {param2: stg_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
   	 	if (response.data.length > 0){
		    	  for (var i=0; i<response.data.length; i++){ 
		    		  if(i==response.data.length-1){
		    			D_STD_CATEG_NM += $.trim(eval("response.data["+i+"].CATEG_NAME"));
		    	  	  }else{
		    	  		D_STD_CATEG_NM += $.trim(eval("response.data["+i+"].CATEG_NAME"))+" > ";  
		    	  	  }
	 		      }	 
   		  }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
   });  

    $("#topmenunnavi").text("전체 >"+D_STD_CATEG_NM);
}

/**
 * 조회조건 항목을 엔터키를 누를때 조회 실행
 */
function searchEnter(event) {	
	if (event.keyCode == 13) { 
		doAction('search');
		return false;
	}
}
function setCategoryInput(categ_name, categ_id, flag, flag2)
{ 
	document.cenbody.categroy_sh_flag.value =flag2;
	document.locationForm.st_categ_id.value = categ_id;
	document.locationForm.st_categ_nm.value = categ_name;

	/*if(flag == "NM"){
		document.cenbody.st_search_text.value = categ_name;
  	}else{
  		document.cenbody.st_search_text.value = categ_id;
   }*/
	kep_sel_getItmeList(categ_id,categ_name);
}
var st;
//기능함수
function doAction(str , gubun) {	
	
	switch (str) {
	case "search":	 //조회
	
		var buyer       =  document.forms.cenbody.byca_comorg_code.value;
	    var searchText = document.forms.cenbody.st_search_text.value;
	    var s_logic = document.locationForm.st_s_logic.value;
	    var s_cate_no = "";
	    if(searchText==""){
	        alert(" 검색어가 입력되지 않았습니다.    ");
	        return;
	    }
	    if(s_logic =="A"){
	    	s_cate_no ="9";
	    }else{
	    	s_cate_no ="R";
	    }
	  var search_gubun =document.forms.cenbody.st_search_type.value;
		if(search_gubun == "STD_CATEG_NM"){
			getBuyerSourcingStdDescPop(buyer,searchText,s_cate_no);
		}else if(search_gubun == "SYS_CATEG_NM"){
			getBuyerSourcingCtgNmPop(buyer,searchText,s_cate_no);
		}
		break;
		
	case "reload":	//초기화
		document.forms.searchForm.st_buyer_item_no.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specification.value = "";
		document.forms.searchForm.st_maker_name.value = "";
		
		jspTableClean("table_list");
		break; 
		
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  		
  
	}
}
/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth,std_categ_id,categ_name) {  
	
   var byca_comorg_code =  $("#byca_comorg_code").val();  
   
   kep_topmenunnavi(std_categ_id);
   kep_getCategoriList(byca_comorg_code,depth,std_categ_id); // 고객사,분류 depth,카테고리아이디 
}

/*
 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
 */
function kep_sel_getItmeList(std_categ_id,categ_name){

		document.forms.locationForm.st_categ_id.value = std_categ_id;		
		$('#locationForm').attr("action", "/mdcm/getBuyerMdCmPCODLisList.do").submit(); 
 }

// 고객사,분류 depth,카테고리아이디
/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(com_code,depth,std_categ_id) {  
		var strTmp = "";
		var p_depth = eval(depth)+1;
		var to_data = "0";
		var from_data = "0";
		var sub_std_categ_id = "";
		if (depth == 2){
			from_data = "3";
			to_data = "1";
			$("#cateMenu3").html(nodata);
			$("#cateMenu4").html(nodata);
			$("#cateMenu5").html(nodata);
		}else if (depth == 3){
			from_data = "5";
			to_data = "2";
			$("#cateMenu4").html(nodata);
			$("#cateMenu5").html(nodata);
		}else if (depth == 4){
			from_data = "8";
			to_data = "2";
			$("#cateMenu5").html(nodata);
		}else if (depth == 5){
			from_data = "11";
			to_data = "4";
			
		}
		var slogic = document.locationForm.st_s_logic.value;

		if(slogic == ""  || slogic == null){
			sub_std_categ_id = "R";
		}
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getCategoryPCOList.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param1: com_code,param2: depth,param3: std_categ_id,param5: from_data,param6: to_data,param7: sub_std_categ_id},
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
	 		    			strTmp += "<li><a class=\"catelink\"\"  href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\')\">"+D_CATEG_NAME+" "+D_CNT+"</li>";	 			 	
	 		    		}
		 		      }	 		    //	class="selected"
	    		  }else{
	    			  strTmp = nodata;
	    		  }   	  
	    		
	    	 //	alert(strTmp);
					$("#cateMenu"+depth).html(strTmp);
			

			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
}
/*
 * 카테고리 선택된 대상 초기화
 */
function kep_categori_clear(){
		$("#cateMenu2").html(nodata);
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
		$("#cateMenu5").html(nodata);
}


</script>
</html>
