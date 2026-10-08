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
<script type="text/javascript"> 
 
</script> 
<body onload="setQuery()">
	 <form name=approvalSamplePop id=approvalSamplePop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalSamplePop">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper"> 
        <!--팝업내용입니다-->
        <div id="popContainer">  
          
            <div class="scrollArea" style="height:100px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                        <col width="20%" />                   
                        <col width="20%" />                   
                        <col width="20%" />                   
                        <col width="20%" />                   
                        <col width="20%" />                   
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">가</th> 
                            <th scope="col">나</th>
							<th scope="col">다</th>   
							<th scope="col">라</th>   
							<th scope="col">마</th>   
                        </tr>              
                    </thead>
                    <tbody> 
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr> 
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
