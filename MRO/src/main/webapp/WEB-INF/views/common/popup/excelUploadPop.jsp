<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<script type="text/javascript">
 
		
	function kepUpload() {  		 
		$('#UploadForm').attr("action", "/common/excelFileUpload.do").submit(); 
	}	
	
	
</script> 
<body onload="kepOnload(); ">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:194px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">Excel Upload 샘플</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">              
		<form method="post" action="/common/excelFileUpload.do"  name="UploadForm" id="UploadForm"      modelAttribute="uploadForm" enctype="multipart/form-data">      
					
					<table  class="board_write" summary="피일업로드" id="fileTable">
					<caption>Excel 올리기샘플</caption>
					<colgroup> 
						<col width="*" />
					</colgroup>
					<tbody> 
			    	  <tr> 
							<td scope="row">
							<input name="files" type="file"  class="input_type_text" />
							</td>        
						</tr>   
					</table>    				
					</form> 
						 <!--버튼영역-->
            <div class="btnArea">
                <!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
                <span class="btn_04 mr04"><a href="javascript:kepUpload()">Upload</a></span>  
            </div>
            
		</div>
    </div>          
</body>
</html>
