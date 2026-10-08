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
String st_user_id = _sessionInfo.getUserId();
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)
String st_popup_type = CommonUtil.nvl((String) request.getParameter("popup_type"),"");  //  (추천팝업 연결 제어용)
String st_categ_desc = CommonUtil.nvl((String) request.getParameter("categ_desc"),"");  //  (추천팝업 조회값)
String st_categ_spec = CommonUtil.nvl((String) request.getParameter("categ_spec"),"");  //  (추천팝업 조회값)
String st_categ_maker = CommonUtil.nvl((String) request.getParameter("categ_maker"),"");  //  (추천팝업 조회값)
String st_sour_dept_yn = CommonUtil.nvl((String) request.getParameter("st_sour_dept_yn"),"N");  //소싱부서 여부 소싱부서로 팝업을 열 경우 본인 SG만 조회 됨.
String st_sg_req_yn = CommonUtil.nvl((String) request.getParameter("st_sg_req_yn"),"N");  //SG 통제 여부
String st_sour_sg_id = CommonUtil.nvl((String) request.getParameter("st_sg_id"),"");  //SG_ID
%>

<body onload="kep_onload_view(); ">
<form name="masterMpRqKepStndrdCategorySelPop" id="masterMpRqKepStndrdCategorySelPop" method=post  onsubmit="return false;">
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="po_dept" id="po_dept"  value="<%=po_dept%>">
<input type="hidden" name="category_name1" id="category_name1"  />
<input type="hidden" name="category_name2" id="category_name2"  />
<input type="hidden" name="category_name3" id="category_name3"  />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">KeP표준 카테고리 선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	 <div class="fl">
        	 	<!--표준카테고리 추천 팝업에서 호출 시 보임-->
        	 	<%if(st_popup_type.equals("stdCategRcmd")){%>
						<span class="btn_04 mr04"><a href="javascript:doAction('recommand');">카테고리추천</a></span>
				<%}%>
				<input type="checkbox" id="st_result" name="st_result" style="margin-top: 5px"/></span>&nbsp;&nbsp;검색결과 고정
        	 </div>
             <div class="fr">
             	<%if(st_popup_type.equals("stdCategRcmd")){%>
					☜ <font color="FF0000">카테고리추천</font> 버튼 클릭 시 추천팝업으로 이동
				<%}%>
				
			<%  //사업팀 조회 및 초기화 삭제(다른 SG의 카테고리 선택 막기) - 조직개편 2025.08.18
				if(st_sour_dept_yn.equals("Y") || st_sg_req_yn.equals("N")){
			%>
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
				<span class="btn_reset"><a href="javaScript:reload();">초기화</a></span>
			<%
				}
			%>
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>KeP표준 카테고리 선택  리스트</caption>
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
						<%  //사업팀 조회 및 초기화 삭제(다른 SG의 카테고리 선택 막기) - 조직개편 2025.08.18
							if(st_sour_dept_yn.equals("Y") || st_sg_req_yn.equals("N")){
						%>
								<input type=text name="st_searh_name" id="st_searh_name" size=20 value="" onkeydown="kepEnter()" class="input_type_text">
						<%
							}else{
						%>
								<input type=text name="st_searh_name" id="st_searh_name" size=20 value="" class="input_type_text">
						<%
							}
						%>
                            </td>
						    <td>카탈로그</td>						 
							<td>
						<%  //사업팀 조회 및 초기화 삭제(다른 SG의 카테고리 선택 막기) - 조직개편 2025.08.18
							if(st_sour_dept_yn.equals("Y") || st_sg_req_yn.equals("N")){
						%>
								<input type=text name="st_catalog" id="st_catalog" size=20 value="" onkeydown="kepEnter()" class="input_type_text">
						<%
							}else{
						%>
								<input type=text name="st_catalog" id="st_catalog" size=20 value="" class="input_type_text">
						<%
							}
						%>
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="mb05" style="height:305px">
            
                <div id="cateArea2" style="width: 100%; height: 500px;">
	            	<div id="cateE">
	                	<p class="cateTitle2">대분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu" id="cateMenu1"> 
	                        </ul>
	                    </div>
	                </div>
	                
	              <div id="cateF">
	                	<p class="cateTitle2">중분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu2"> 
	                        </ul>
	                  </div>
	                </div>
	                
	                <div id="cateG">
	                	<p class="cateTitle2">소분류</p>
	                    <div id="cate02" style="height:245px;">
	                    	<ul class="cateMenu"  id="cateMenu3"> 
	                        </ul>
	                    </div>
	                </div>
	                
	                <div id="cateH">
	                	<p class="cateTitle2">최종분류</p>
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
   			<input type="hidden" id="st_sg_id" name="st_sg_id" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_sg_name" name="st_sg_name" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_id" name="st_categ_id" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_categ_name" name="st_categ_name" style="width:460px;" value="" readonly="readonly" >
   			<input type="hidden" id="st_choice_type" name="st_choice_type" style="width:50px;" value="OFFCATE" readonly="readonly" >
   			<input type="text" class="input_type_text" id="st_category_path" name="st_category_path" style="width:460px;" value="" readonly="readonly" >
   			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
   			<br><font color="#FF5E00" class="b">※상품카테고리만 선택가능</font>
   		</div>
   		<br/>
   		<div>
   		<input type="text" style="border: 1px solid #cdcdcd; background: #f4f4f4; width: 120px; height: 100px;
   			 text-align: center; font-size: 12px; font-weight: 600; vertical-align: middle;  line-height: 100px;"
   			   value="설명" readonly="readonly" >
   			<textarea style="width: 553px; height: 100px; font-size: 12px;" id="st_categ_descript" readonly="readonly"></textarea>   			
   		</div>
    </div>        
</div>
</form>
<form name="categForm" id="categForm" method="post" action ="">
	<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="60">
	<input type="hidden" name="categ_target_count" id="categ_target_count" value="1">
	<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
    <input type="hidden" name="categ_desc_flow" id="categ_desc_flow" value="<%=st_categ_desc%>">
    <input type="hidden" name="categ_spec_flow" id="categ_spec_flow" value="<%=st_categ_spec%>">
    <input type="hidden" name="categ_maker_flow" id="categ_maker_flow" value="<%=st_categ_maker%>">
    <input type="hidden" name="categ_model_flow" id="categ_model_flow" value="">
    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="true">
    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="true">
    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="true">
    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
    <input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
    <input type="hidden" name="st_sour_dept_yn" id="st_sour_dept_yn" value="<%=st_sour_dept_yn%>">
    <input type="hidden" name="st_sg_req_yn" id="st_sg_req_yn" value="<%=st_sg_req_yn%>">
    <input type="hidden" name="st_sour_sg_id" id="st_sour_sg_id" value="<%=st_sour_sg_id%>">
</form> 
</body>

<script type="text/javascript">
var nodata = "<li>조회 내용이 없습니다.</li>";

function kep_onload_view(){
	kep_categori_clear();
	
   // 카테고리 조회 
	kep_getCategoriList("1","");
}

function kepSearch()
{  
	searchAll1(1);
	searchAll2(2);
	searchAll3(3);
	searchAll4(4);
      
}

function searchAll1(depth) {  
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_searh_name = $("#st_searh_name").val();
	var st_catalog = $("#st_catalog").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,param4:st_catalog,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME")); 
 		    		var D_CATEG_DESCRIPT = $.trim(eval("response.data["+i+"].DESCRIPT"));
 		    		
 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}	    	
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else {
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
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
	var st_catalog = $("#st_catalog").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,param4:st_catalog,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));
 		    		var D_CATEG_DESCRIPT = $.trim(eval("response.data["+i+"].DESCRIPT"));
 		    		
 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{ 		    				
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			} 		    			
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 		    				
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
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
function searchAll3(depth) {
	
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_searh_name = $("#st_searh_name").val();
	var st_catalog = $("#st_catalog").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,param4:st_catalog,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));
 		    		var D_CATEG_DESCRIPT = $.trim(eval("response.data["+i+"].DESCRIPT"));
 		    		
 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){ 		    				
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{ 		    				
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
		    		}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 		    				
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }	 		    //	class="selected"
    		  }else{
    			  strTmp = nodata;
    		  }   	  
//     		alert(" 3: "+strTmp);
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
    });  
}
function searchAll4(depth) {  
	var strTmp = "";
	var p_depth = eval(depth)+1; 
	var st_searh_name = $("#st_searh_name").val();
	var st_catalog = $("#st_catalog").val();
	var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
	var st_user_id  = $("#st_user_id").val();
	var st_sour_sg_id  = $("#st_sour_sg_id").val();
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/getCategorySelPop.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { param2: depth,param3: st_searh_name,param4:st_catalog,st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
    	 	if (response.data.length > 0){
 		    	  for (var i=0; i<response.data.length; i++){ 
 		    		  
 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID")); 
 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));
 		    		var D_CATEG_DESCRIPT = $.trim(eval("response.data["+i+"].DESCRIPT"));
 		    		
 		    		if (D_CNT == "0"){
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}else{ 		    				
	 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
 		    			}
	    			}else{
 		    			if (D_CATEG_TYPE == "ITM"){
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
 		    			} else { 		    				
 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
 		    			}
 		    		}
	 		      }	 		    //	class="selected"
    		  }else{
    			  strTmp = nodata;
    		  }   	  
//     		alert(" 4: "+strTmp);
				$("#cateMenu"+depth).html(strTmp);
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
    });  
}

function reload(){
	kepReload('masterMpRqKepStndrdCategorySelPop');
	kep_categori_clear();
	kep_getCategoriList("1","");
	document.getElementById("st_result").checked = false;
}			


function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn()
{ 
	if ($("#st_sg_id").val() == ""){
		alert("상품 카테고리만 선택 가능합니다");
		return;
	}
	opener.setPopupReturn($("#st_sg_id").val()
			  						,$("#st_sg_name").val()
			  						,$("#st_categ_id").val()
			  						,$("#st_category_path").val()
			  						,$("#st_categ_name").val()
			  						,$("#st_choice_type").val()
			  						);
	this.close();
}

/*
 * 카테고리 목록조회
 */
function kep_sel_getCategoriList(depth,std_categ_id,categ_name,categ_path) {  
	
	kep_topmenunnavi(depth,std_categ_id,categ_path);
	kep_getCategoriList(depth,std_categ_id); // 분류 depth,카테고리아이디 
}

/*
 * 카테고리 를 이용한 화면 이동 삼품목록으로 이동
 */
function kep_sel_getItmeList(std_categ_id,categ_name,std_categ_path,std_sg_id,std_sg_name, std_categ_descript){	
	$("#st_categ_id").val(std_categ_id);  // 카테고리번호
	$("#st_category_path").val(std_categ_path);  // 카테고리경로
	$("#st_sg_id").val(std_sg_id);  // SG_ID
	$("#st_sg_name").val(std_sg_name);  // SG_NAME
	$("#st_categ_name").val(categ_name);  // 카테고리명	
	$("textarea#st_categ_descript").text(std_categ_descript);  // 비고란
	 
}
/*
 * 카테고리 보인후 선택된 대상 출력
 */
function kep_topmenunnavi(depth,categ_id,categ_path){
	
	    $("#st_sg_id").val("");  // SG_ID
		$("#st_sg_name").val("");  // SG_NAME
	if (depth == 2){
	    $("#st_categ_id").val("");  // 카테고리번호
		$("#st_category_path").val("");  // 카테고리경로
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
	} else {
	    $("#st_categ_id").val(categ_id);  // 카테고리번호
		$("#st_category_path").val(categ_path);  // 카테고리경로
	}
}

/*
 * 카테고리 보인후 화면 출력
 */
function kep_getCategoriList(depth,std_categ_id) {
		$("textarea#st_categ_descript").text("");
		if(document.getElementById("st_result").checked == true){
			return;
		}
		var strTmp = "";
		var p_depth = eval(depth)+1; 
		var st_sour_dept_yn  = $("#st_sour_dept_yn").val();
		var st_user_id  = $("#st_user_id").val();
		var st_sour_sg_id  = $("#st_sour_sg_id").val();
		
		$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: "/mprq/getMasterMpRqKepStndrdCategorySelPop.do",
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: { param2: depth,param3: std_categ_id, st_sour_dept_yn:st_sour_dept_yn,st_user_id:st_user_id,st_sour_sg_id:st_sour_sg_id},
		     async : false,
		     success:function( response ) {  		    	  
		    	 	 		    	  
	    	 	if (response.data.length > 0){
	 		    	  for (var i=0; i<response.data.length; i++){ 
	 		    		  
	 		    		var D_CMS_CATEG_ID = $.trim(eval("response.data["+i+"].CMS_CATEG_ID")); 
	 		    		var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
	 		    		var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH")); 
	 		    		var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
	 		    		var D_CNT = $.trim(eval("response.data["+i+"].CNT")); 
	 		    		var D_SG_ID = $.trim(eval("response.data["+i+"].SG_ID")); 
	 		    		var D_SG_NAME = $.trim(eval("response.data["+i+"].SG_NAME"));
	 		    		var D_CATEG_DESCRIPT = $.trim(eval("response.data["+i+"].DESCRIPT"));	 		    		
	 		    		if (D_CNT == "0"){	 		    			
	 		    			if (D_CATEG_TYPE == "ITM"){
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
	 		    			}else{		    				
	 		    				
		 		    			strTmp += "<li><a onClick=\"this.style.color=\'blue\'\" onBlur=\"this.style.color=\'#003C76\'\" href=\"javascript:kep_sel_getCategoriList(\'"+p_depth+"\',\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+"</li>";
	 		    			}	 		    			
 		    			}else{ 		    				
	 		    			if (D_CATEG_TYPE == "ITM"){	 		    				
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\',\'"+D_SG_ID+"\',\'"+D_SG_NAME+"\',\'"+D_CATEG_DESCRIPT+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";	 			 	
	 		    			} else {	 		    					 		    				
	 		    				strTmp += "<li><a href=\"javascript:kep_sel_getItmeList(\'"+D_CMS_CATEG_ID+"\',\'"+D_CATEG_NAME+"\',\'"+D_CATEG_PATH+"\')\">"+D_CATEG_NAME+" ("+D_CNT+")</li>";
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
		$("#cateMenu3").html(nodata);
		$("#cateMenu4").html(nodata);
}

//기능함수
function doAction(str) {
	switch (str) {
		case "recommand":
			window.open('','categ','scrollbars=no,width=728,height=510,resizable=no');
		    document.categForm.action = "/mprq/showMasterMpRqKepStndrdCategoryRcmdPop.do";
		    document.categForm.target = "categ";
		    document.categForm.method = "post";
		    
		    document.categForm.submit();
			break;
	}
}
</script> 
</html>
