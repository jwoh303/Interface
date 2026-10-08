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
<% 
String file_dir = CommonUtil.nvl((String) request.getParameter("file_dir"),"");  //  (조회조건
String file_name = CommonUtil.nvl((String) request.getParameter("file_name"),"");  //  (조회조건 )
  

%> 
<body>
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">이미지 보기</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 			<img src="<%=CommonUtil.realImgS3UploadPath+"/"+file_dir+"/"+file_name%>"   onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  width="100%"  border="0" onclick="self.close();">
        </div>
    </div>
</body>
</html>
