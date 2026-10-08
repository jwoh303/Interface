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

	// 조회조건 E	
	
	String SessionComCode = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	}  

%> 

<script type="text/javascript">

 
function setReturnValueInfo(std_categ_nm, final_value2, category_id, inventory_gubun_flag){
    opener.setReturnValue2(std_categ_nm, final_value2, category_id, inventory_gubun_flag);
    parent.close();
}


</script> 
<body>
	 <form name=catalogDetailPop id=catalogDetailPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="categoryPunchOutDetailPop">
	 <input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	  
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">카탈로그 ITEM</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
              <!--팝업내용입니다-->
        <div id="popContainer" style="height:280px; min-height: 100px;">
        	 <div class="scrollArea" style="height:280px">	 
			<div id="cont_searchA">	
				<table class="cont_t_list01" style="width:350px;">
					<tr><td>
		        		> 카탈로그별 물성기준이 상이하므로 비재고자재 / 재고자재를 구분혀아 선택해 주십시요
		          	</td></tr>
				</table>    
			</div>
			<br>
            <table   style="width:100%;">
              <caption>카테고리 정보</caption>
                <colgroup>
                    <col width="50%" />
                    <col width="50%" />
                </colgroup>
                <tbody>
                    <tr style="height:60px">
                      <th scope="col"><a class="hyperLink"  href="javascript:getBuyerSourcingItemPop('<%=SessionComCode%>','E');"><img src="/resources/images/itemplus01.gif" alt="비재고" /></a></th>
                      <th scope="col"><a class="hyperLink"  href="javascript:getBuyerSourcingItemPop('<%=SessionComCode%>','I');"><img src="/resources/images/itemplus02.gif" alt="재고" /></a></th>
			  		</tr>
                </tbody>
            </table>
      	</div>
        
</div>           
    </div>
</form> 
</body>
</html>
