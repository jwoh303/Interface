<%--
**********************************************
* 메뉴 : 
* 화면 : 배송처 선택
* 기능 : 
* 프로그램 ID : PG_07_M_900_16
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-06-19
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
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  			//  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#commonMpIvDlvryChoicePop').attr("action", "/mpiv/getCommonMpIvDlvryChoicePop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(){
	var st_dely_location = $("input[name=st_dely_location]:checked").val();
	if(isEmpty(st_dely_location) || $("input[name=st_dely_location]:checked").length == 0){
		alert("배송처를 선택하여 주십시오.");
		return;
	}
	
	if(st_dely_location == "ETC" && isEmpty($("input[name=st_etc_dely_location_text]").val())){
		alert("배송처를 입력하여 주십시오.");
		$("input[name=st_etc_dely_location_text]").focus();
		return;
	}
	
	if(st_dely_location == "ETC"){
		st_dely_location = $("input[name=st_etc_dely_location_text]").val();
	}
	
	opener.setPopupReturn(st_dely_location);
	this.close();
}
//-->
</script> 
<body onload="">
<form name="commonMpIvDlvryChoicePop" id="commonMpIvDlvryChoicePop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">배송처 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>배송처 선택 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="18%" />
							<col width="9%" />
							<col width="15%" />
							<col width="10%" />
                            <col width="10%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>요청공장</td>
							<td>
								<select id="st_buyer_code" name="st_buyer_code"  style="width:150px">
									<option value="ALL" selected>전체</option>
									<option value="KRDONG0110" <%if(st_buyer_code.equals("KRDONG0110")) {out.println("selected=\"selected\"");}%>>동부한농(주)인천공장</option>
									<option value="KRDONG0107" <%if(st_buyer_code.equals("KRDONG0107")) {out.println("selected=\"selected\"");}%>>동부한농(주)구미공장</option>
									<option value="KRDONG0128" <%if(st_buyer_code.equals("KRDONG0128")) {out.println("selected=\"selected\"");}%>>동부정밀(주)전주공장</option>
									<option value="KRDONG0732" <%if(st_buyer_code.equals("KRDONG0732")) {out.println("selected=\"selected\"");}%>>동부팜한농 (주) 안성공장</option>
								</select>
                            </td>
						    <td></td>						 
							<td  class="right"> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:320px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>배송처 선택 리스트</caption>
                    <colgroup>
                        <col width="100%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">배송처</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td class="left">
							<input type="radio" name="st_dely_location" id="radio" value="<%=_tmp.get("TEXT2")%>" onclick="document.forms[0].st_etc_dely_location_text.value='';" style="margin-left: 10px; margin-right: 5px;" ><%=_tmp.get("TEXT2")%>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                    <tfoot>
                    	<tr>
                    		<td class="left"><input type="radio" name="st_dely_location" id="radio" value="ETC" style="margin-left: 10px; margin-right: 5px;" >기타<input type="text" name="st_etc_dely_location_text" style="width:83%; margin-left: 10px;" value="" ></td>
                    	</tr>
                    </tfoot>
                </table>
        	</div>
        	<div class="btnArea ac" style="margin-bottom:0px; margin-top: 5px;"> 
			     <span class="fr btn_02"><a href="javascript:setReturn();">확인</a></span> 
			</div>
	    </div>        
	</div>
</form> 
</body>
</html>
