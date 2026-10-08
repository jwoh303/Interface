<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 카테고리 선택
* 기능 : 
* 프로그램 ID : PG_90_C_900_10
* 담당자 :  고영일 ( 설계 : 공통 )
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String buyer_name = (String) request.getAttribute("buyer_name");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  //  (조회조건)
String nu_i = CommonUtil.nvl((String) request.getParameter("nu_i"),"");
String st_flag = CommonUtil.nvl((String) request.getParameter("st_flag"),"");

String st_searh_name = CommonUtil.nvl((String) request.getParameter("st_searh_name"),"");
String st_catalog = CommonUtil.nvl((String) request.getParameter("st_catalog"),"");

%>

<script type="text/javascript">
var nodata = "<li>조회 내용이 없습니다.</li>";

$(document).ready(function(){
	kep_categori_clear();
	
   // 카테고리 조회 
	kep_getCategoriList("1","");
});

function kepSearch()
{  
	var st_searh_name = $("#st_searh_name").val();
	var st_catalog = $("#st_catalog").val();
	
	if(isEmpty(st_searh_name) && isEmpty(st_catalog)){
		reload();
	}else{
		searchAll(1);
		searchAll(2);
		searchAll(3);
		searchAll(4);
	}
}

/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(depth,std_categ_id) {  
		if(document.getElementById("st_result").checked == true){
			return;
		}
		var strTmp = "";
		var p_depth = eval(depth)+1; 
		var st_buyer = $("#st_buyer").val();
		var st_user_id = $("#st_user_id").val();
		
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/coco/getBuyerCategorySearch.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { st_buyer : st_buyer, st_depth : depth, st_categ_code : std_categ_id, st_user_id : st_user_id },
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
	 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
	 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
	 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
	 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
	 		    		
	 		    		if (D_CNT == "0"){
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}else{
	 		    				strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+"</li>";
	 		    			}
 		    			}else{
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
	 		    			} else { 
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}
	 		    		}
		 		      }	 		    //	class="selected"
	    		  }else{
	    			  strTmp = nodata;
	    		  }   	  
	    	 	

					$("#cateMenu"+depth).html(strTmp);

			      },
			 error:function( response ) {  		    	   
		    	 alert("오류발생하였습니다.");
			      }
	    });  
}

function searchAll(depth) {  
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_buyer = $("#st_buyer").val();
	var st_user_id = $("#st_user_id").val();
	var st_searh_name = $("#st_searh_name").val();
	var st_catalog = $("#st_catalog").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/coco/getBuyerCategorySearchReqValue.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_buyer : st_buyer, st_depth : depth, st_searh_name : st_searh_name, st_catalog : st_catalog, st_user_id : st_user_id },
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		
 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
 		    				strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}	
	 		    				    	
	    			}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_CNT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }	 		    //	class="selected"
    		  }else{
    			  strTmp = nodata;
    		  }   	  
//     		alert(" 1: "+strTmp);
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
    });  
}
var g_itiem_yn = "";
/*
 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
 */
function kep_sel_getItmeList(std_categ_id,categ_name,std_categ_path,std_sg_id,std_sg_name,categ_cnt){
	$("#st_product_yn").val("Y");
	$("#st_categ_id").val(std_categ_id);  // 카테고리번호
	$("#st_categ_name").val(categ_name);  // 카테고리명
	$("#st_category_path").val(std_categ_path);  // 카테고리경로
	$("#st_categ_cnt").val(categ_cnt);  // 카테고리경로
}

/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth,std_categ_id,categ_name,categ_path,categ_cnt) {
	$("#st_product_yn").val("N");
	kep_topmenunnavi(depth,std_categ_id,categ_name,categ_path,categ_cnt);
	kep_getCategoriList(depth,std_categ_id); // 분류 depth,카테고리아이디 
}

/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(depth,categ_id,categ_name,categ_path,categ_cnt){
		if (depth == 2){
		    $("#st_categ_id").val("");  // 카테고리번호
		    $("#st_categ_id").val("");  // 카테고리번호
		    $("#st_categ_name").val("");  // 카테고리명
		    $("#st_category_path").val(categ_path);  // 카테고리경로
			$("#cateMenu3").html(nodata);
			$("#cateMenu4").html(nodata);
		} else {
		    $("#st_categ_id").val(categ_id);  // 카테고리번호
		    $("#st_categ_name").val(categ_name);  // 카테고리명
			$("#st_category_path").val(categ_path);  // 카테고리경로
			$("#st_categ_cnt").val(categ_cnt);  // 카테고리경로
		}
}

/*
 * 카테고리 선택된 대상 초기화
 */
function kep_categori_clear(){
	$("#cateMenu1").html(nodata);
	$("#cateMenu2").html(nodata);
	$("#cateMenu3").html(nodata);
	$("#cateMenu4").html(nodata);
	
	$("#st_categ_id").val("");
	$("#st_categ_name").val("");
	$("#st_categ_cnt").val(""); 
	$("#st_category_path").val(""); 
	$("#st_result").removeAttr('checked');
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function reload(){
	$("#st_searh_name").val("");
	$("#st_catalog").val("");
	$("#st_product_yn").val("");
	kep_categori_clear();
	kep_getCategoriList("1","");
}

function setReturn() {
	
	var categ_code  = $("#st_categ_id").val();
    var categ_name  = $("#st_categ_name").val();
    var catalog_cnt = $("#st_categ_cnt").val();
    var categ_path  = $("#st_category_path").val();
    var nu_i        = $("#nu_i").val();
    //카테고리 품목이 아닐경우 체크
	if($("#st_product_yn").val() == "N"){
	      alert("품목군을 선택하여 주십시요.");
	      return;		
	}
    if(categ_code == ""||categ_code == null)
    {
      alert("품목군을 선택하여 주십시요.");
      return;
    }
     var confir = confirm("선택한 품목군으로 지정하시겠습니까?");
     if(confir == false)
     {
        return;
     }
     
	opener.setPopupReturn(categ_code, categ_name,catalog_cnt,categ_path,nu_i);
	this.close();
}
</script> 
<body onload="">
<form name="commonCoCoBuyerCategoryChoicePop" id="commonCoCoBuyerCategoryChoicePop" method=post >
	<input type="hidden"  id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
	<input type="hidden"  id="st_user_id" name="st_user_id" value="<%=st_user_id%>"/>
	<input type="hidden"  id="nu_i"  name="nu_i" value="<%=nu_i%>"/>
	<input type="hidden"  id="st_flag"  name="st_flag" value="<%=st_flag%>"/>
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title"><%=buyer_name%> 카테고리 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<div class="fl">
        		<input type="checkbox" id="st_result" name="st_result" />&nbsp;&nbsp;검색결과 고정
        	</div>
        	<div class="fr">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
				<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption><%=buyer_name%> 카테고리 선택  리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
                            <col width="10%" />
                            <col width="40%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>검색어</td>
							<td> 
								<input type=text name="st_searh_name" id="st_searh_name" size=20 value="<%=st_searh_name %>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td>카탈로그</td>						 
							<td> 
								<input type=text name="st_catalog" id="st_catalog" size=20 value="<%=st_catalog %>" onkeydown="kepEnter()" class="input_type_text"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>
           	<!--grid-->
           	<div class="mb05" style="height:305px">
            
                <div id="cateArea2" style=" height:245px;">
	            	<div id="cateE" style="width:167px; padding-right:2px;">
	                	<p class="cateTitle2"  style="width:165px;">대분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu" id="cateMenu1"> 
	                        </ul>
	                    </div>
	                </div>
	                
	              <div id="cateF" style="width:167px; padding-right:2px;">
	                	<p class="cateTitle2"  style="width:165px;">중분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu2"> 
	                        </ul>
	                  </div>
	                </div>
	                
	                <div id="cateG" style="width:167px; padding-right:2px;">
	                	<p class="cateTitle2"  style="width:165px;">소분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu3"> 
	                        </ul>
	                    </div>
	                </div>
	                
	                <div id="cateH" style="width:167px; padding-right:2px;">
	                	<p class="cateTitle2" style="width:165px;">최종분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu4"> 
	                        </ul>
	                    </div>
	                </div>
				</div>
			</div>
			<!-- btnArea -->
	   		<div>
	   			<font color="#003399">선택한 표준카테고리</font>&nbsp;
	   			<input type="hidden" id="st_categ_id" name="st_categ_id" style="width:460px;" value="" readonly="readonly" >
	   			<input type="hidden" id="st_categ_name" name="st_categ_name" style="width:460px;" value="" readonly="readonly" >
	   			<input type="hidden" id="st_categ_cnt" name="st_categ_cnt" style="width:460px;" value="" readonly="readonly" >
	   			<input type="hidden" id="st_product_yn" name="st_product_yn" style="width:460px;" value="" readonly="readonly" >
	   			<input type="text" class="input_type_text" id="st_category_path" name="st_category_path" style="width:460px;" value="" readonly="readonly" >
	   			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
	   			<br><font color="#FF5E00" class="b">※상품카테고리만 선택가능</font>
	   		</div>
	    </div>        
	</div>
</form> 
</body>
</html>
