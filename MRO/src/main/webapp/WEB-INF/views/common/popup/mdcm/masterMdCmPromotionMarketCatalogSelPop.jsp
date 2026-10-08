<%--
**********************************************
* 메뉴 : 
* 화면 : KeP표준 카테고리 선택 
* 기능 : 표준카테고리를 조회, 선택한다
* 프로그램 ID : PG_04_M_003_01
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-05-19
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
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
%>

<body onload="kep_onload_view(); ">
<form name="masterMdCmPromotionMarketCatalogSelPop" id="masterMdCmPromotionMarketCatalogSelPop" method=post  onsubmit="return false;">
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
<input type="hidden" name="category_name1" id="category_name1"  />
<input type="hidden" name="category_name2" id="category_name2"  />
<input type="hidden" name="category_name3" id="category_name3"  />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">판촉물 전용마켓 카테고리 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	 <div class="fr">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
				<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>판촉물 전용마켓 카테고리 선택 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<td>검색어</td>
							<td> 
								<input type=text name="st_searh_name" id="st_searh_name" size="25" value="" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="mb05" style="height:305px">
                <div id="cateArea2">
	            	<div id="cateE" style="width:170px;">
	                	<p class="cateTitle2" style="width:170px;">대분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu" id="cateMenu1"> 
	                        </ul>
	                    </div>
	                </div>
	                
	              <div id="cateF" style="width:170px;">
	                	<p class="cateTitle2" style="width:170px;">최종분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu2"> 
	                        </ul>
	                  </div>
	                </div>
            </div>
                             
        </div>
   		<!-- btnArea -->
   		<div>
   			<font color="#003399">선택한 카테고리</font>&nbsp;
   			<input type="text"  id="st_categ_path" name="st_categ_path" class="input_type_text" style="width:260px;" value="" readonly="readonly" >
   			&nbsp;&nbsp;&nbsp;<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
   			
   			<input type="hidden" id="st_categ_id" name="st_categ_id" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_name" name="st_categ_name" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_cnt" name="st_categ_cnt" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_type" name="st_categ_type" style="width:460px;" value="" readonly="readonly" >
   			<br><font color="#FF5E00" class="b">※상품카테고리만 선택가능</font>
   		</div>
    </div>        
</div>
</form> 
</body>

<script type="text/javascript">
var nodata = "<li>조회 내용이 없습니다.</li>";

function kep_onload_view(){
	kep_categori_clear();
	
   // 카테고리 조회 
	kep_getCategoriList("1","");
}

function kepSearch(){  
	searchAll1(1);
	searchAll2(2);
}

function searchAll1(depth) {  
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_searh_name = $("#st_searh_name").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2:depth, param3:st_searh_name},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		//var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		//var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME")); 
 		    		
 		    		if (D_CNT == "0"){
	 		    			strTmp += "<li><a href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";	    	
 		    			
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
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
function searchAll2(depth) {  
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_searh_name = $("#st_searh_name").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2:depth, param3:st_searh_name},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		//var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		//var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME")); 
 		    		
 		    		if (D_CNT == "0"){
	 		    			strTmp += "<li><a href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";	    	
 		    			
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }	 		    //	class="selected"
    		  }else{
    			  strTmp = nodata;
    		  }   	  
//     		alert(" 2: "+strTmp);
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
    });  
}

function reload(){
	kepReload('masterMdCmPromotionMarketCatalogSelPop');
	kep_categori_clear();
	kep_getCategoriList("1","");
}			


function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn()
{ 
	if ($("#st_categ_id").val() == ""){
		alert("품목군을 선택하여 주십시요.");
		return;
	}
	
	if(confirm("선택한 품목군으로 지정하시겠습니까?")){
		opener.setPopupReturn($("#st_categ_id").val(), $("#st_categ_type").val(), $("#st_categ_path").val());
		this.close();
	}
}

/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth, std_categ_id, categ_type, categ_path) {  
	
	kep_topmenunnavi(depth,std_categ_id,categ_path);
	kep_getCategoriList(depth,std_categ_id); // 분류 depth,카테고리아이디
	
	kep_sel_getItmeList(std_categ_id, categ_type, categ_path);
}

/*
 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
 */
function kep_sel_getItmeList(std_categ_id, categ_type, std_categ_path){
	
	$("#st_categ_id").val(std_categ_id);  // 카테고리번호
	$("#st_categ_type").val(categ_type);  // 카테고리경로
	$("#st_categ_path").val(std_categ_path);  // SG_ID
	
	 
}
/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(depth,categ_id,categ_path){
	
	if (depth == 2){
	    $("#st_categ_id").val("");  // 카테고리번호
		$("#st_category_path").val("");  // 카테고리경로
	} else {
	    $("#st_categ_id").val(categ_id);  // 카테고리번호
		$("#st_category_path").val(categ_path);  // 카테고리경로
	}
}

/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(depth,std_categ_id) {  
		var strTmp = "";
		var p_depth = eval(depth)+1; 
		
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mdcm/getMasterMdCmPromotionMarketCatalogSelPop.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param2: depth,param3: std_categ_id},
		     async : false,
		     success:function( response ) {
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
	 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
	 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
	 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
	 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
	 		    		//var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
	 		    		//var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME")); 
	 		    		
	 		    		if (D_CNT == "0"){
		 		    			strTmp += "<li><a href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";	    	
	 		    			
 		    			}else{
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
	 		    			} else { 
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_STD_CATEG_ID+"\',\'"+D_CATEG_TYPE+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}
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
		$("#cateMenu1").html(nodata);
		$("#cateMenu2").html(nodata);
}
</script> 
</html>
