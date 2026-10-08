<%--
**********************************************
* 메뉴 : 카탈로그 매핑관리 > 카테고리별 속성
* 화면 : 카테고리속성
* 기능 : 카테고리별 속성 확인
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2017-02-22
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
String st_cms_categ_id = CommonUtil.nvl((String) request.getParameter("cms_categ_id"),"");
%>
<script>
var popupSel = "";
var grbRow;
var flag = "N";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	kepSearch();
}

var st;
var mt;
function kepSearch()
{
	var strTmp = "";
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getMasterMdCmCategoriAttb.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_cms_categ_id: $("#st_cms_categ_id").val()},
	     async : false,
	     success:function( response ) {  		    	  
		    		var D_CATEG_NAME = $.trim(eval("response.data[0].CATEG_NAME")); 
		    		$("#st_category_name").val(D_CATEG_NAME);
	    		
		    		var cmsAttrCnt = $.trim(eval("response.data[0].CMSATTRCNT"));// 속성개수
		    		$("#st_cms_cnt").val(cmsAttrCnt);
		    		var lineCnt = $.trim(eval("response.data[0].LINECNT")); // 라인수
		    		var blankFlag = $.trim(eval("response.data[0].BLANKFLAG")); // 빈칸 처리여부 : 속성개수가 홀수 일 경우 빈칸 처리한다.
					var idx1 = 0;
		    		var idx2 = 0;
		    		for( var idx = 0 ; idx < lineCnt ; idx++ ) {
		    			idx1=idx2+1;
		    			idx2=idx1+1;
		    			
						$("#st_name"+idx1).val($.trim(eval("response.data[0].ATTB"+idx1+"_NM")));
						$("#st_name"+idx2).val($.trim(eval("response.data[0].ATTB"+idx2+"_NM")));
						$("#st_flag"+idx1).val($.trim(eval("response.data[0].ATTB"+idx1+"_FLAG")));
						$("#st_flag"+idx2).val($.trim(eval("response.data[0].ATTB"+idx2+"_FLAG")));
						
	    				strTmp += "<tr>";
		    				strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx1+"_NM"))+"</th>";
							strTmp += "<td>";
							strTmp += "필수여부: "+$.trim(eval("response.data[0].ATTB"+idx1+"_FLAG"));
							strTmp += "</td>";
							  
							
							
						if (idx2 > cmsAttrCnt && blankFlag == "Y"){
							strTmp += "<td></td><td></td>";
						}  else {
							strTmp += "<th scope=\"row\">"+$.trim(eval("response.data[0].ATTB"+idx2+"_NM"))+"</th>";
							strTmp += "<td>";
							strTmp += "필수여부: "+$.trim(eval("response.data[0].ATTB"+idx2+"_FLAG"));
							strTmp += "</td>";
						}
							
							strTmp += "</tr>";
		    		}
		    		$("#stnd_table").append(strTmp);
		    		
					var idx3 = 0;
		    		var idx4 = 0;
		    		for( var idx = 0 ; idx < lineCnt ; idx++ ) {
		    			idx3=idx4+1;
		    			idx4=idx3+1; 

						$("#std_attb"+idx3+"_nm").val( $("#st_attb"+idx3+"_nm").val());
						$("#std_attb"+idx4+"_nm").val( $("#st_attb"+idx4+"_nm").val());
			 
		    		}
		    		
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }	
	 }); 
}


</script> 
<body onload="kep_onload_view();">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name = "searchCondition" id="searchCondition" method = "post" modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_cms_categ_id"  name="st_cms_categ_id" value="<%=st_cms_categ_id%>">
	<div id="popWrapper" style="height:240px;">
    	<div id="popHeader">
        	<h1 class="title">카테고리별 속성</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:262px;">
        	<div  class="scrollArea" style="height:238px;">
           	<table class="cont_t_list06" style="width:100%" id="stnd_table">
				<caption>카테고리별 속성</caption>
				<colgroup>
					<col width="28%" />
					<col width="22%" />
					<col width="28%" />
					<col width="22%" />
				</colgroup>						
				<tbody>
				<tr>
				</tr>
				</tbody>
			</table>
			</div>
		</div>	
        
    </div>
</form> 
</body>
</html>
