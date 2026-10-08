<%--
**********************************************
* 메뉴 : 
* 화면 : 카탈로그 고객사선택 
* 기능 : 고객사 선택 팝업 - 그룹,사업장 구분
* 프로그램 ID : PG_03_M_001_01
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-10
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
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)  
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)  
String status_flag = CommonUtil.nvl((String) request.getParameter("status_flag"),""); 
String temp_flag = CommonUtil.nvl((String) request.getParameter("temp_flag"),"");
%>

<script type="text/javascript">
<!--
function popupOnload(){
	var status_flag = document.forms[0].status_flag.value;
	if(status_flag!='N'){
		setQuery();
	}
}

function setQuery()
{   
	var TForm = document.forms[0];
    var st_buyer_name = TForm.st_buyer_name.value.toUpperCase();
    TForm.st_buyer_name.value = st_buyer_name;
    if(TForm.st_buyer_code.value == "" && TForm.st_buyer_name.value == ""){
		TForm.temp_flag.value = "DEF";
    }else {
		TForm.temp_flag.value = "QUERY";
    }
    
	document.masterMdCmCatalogBuyerChoicePop.status_flag.value = "N";
	
	$('#masterMdCmCatalogBuyerChoicePop').attr("action", "/mdcm/getMasterMdCmCatalogBuyerChoicePop.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function setReturn(value1,value2,value3,value4,value5)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5);
  this.close();
}

function setViewGroup()
{ 
	var buyer_code = document.forms[0].st_buyer_code.value;
    var buyer_name = document.forms[0].st_buyer_name.value;
    
    //그룹보기 팝업
	openSearchPopup("/mdcm/showMasterMdCmGroupViewPop.do", '?st_buyer_code='+buyer_code+'&st_buyer_name='+buyer_name, "640,500,no");
}

function doPop(value1, value2)
{ 	
	if(value1 == "그룹"){
		alert("그룹코드는 고객사정보를 제공하지 않습니다.");
		return;
	}else{
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+value2, "800,600,no");
	}
}

 //-->
</script> 
<body onload="popupOnload();">
<form name="masterMdCmCatalogBuyerChoicePop" id="masterMdCmCatalogBuyerChoicePop" method=post >
<input type = "hidden" name = "status_flag" value = "<%=status_flag%>">
<input type = "hidden" name = "temp_flag" value = "<%=temp_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:560px;">
    	<div id="popHeader">
        	<h1 class="title">카탈로그 고객사선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>카탈로그 고객사선택  리스트</caption>
						<colgroup>
							<col width="100px" />
							<col width="20%" />
							<col width="10px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<th>고객사코드</th>
							<td> 
								<input type=text name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code %>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td></td>						 
							<td  class="right">
								<span class="btn_02"><a href="javascript:setViewGroup();">그룹보기</a></span> 
							</td>
						</tr>					 
						<tr>
							<th>고객사명</th>
							<td> 
								<input type=text name="st_buyer_name" id="st_buyer_name"  value="<%=st_buyer_name %>"  style="ime-mode:active" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:310px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>카탈로그 고객사선택  리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="23%" /> 
                        <col width="43%" />
                        <col width="15%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">구분</th> 
                            <th scope="col">고객사코드</th> 
                            <th scope="col">고객사명</th> 
                            <th scope="col">진행건수</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
							<%=_tmp.get("BYCA_COMORG_LEVEL")%>
						</td>
						<td class="left" >
						  	<a href="javascript:doPop('<%=_tmp.get("BYCA_COMORG_LEVEL")%>', '<%=_tmp.get("BYCA_COMORG_CODE")%>')">
							<font color="blue"><%=_tmp.get("BYCA_COMORG_CODE")%></font></a>
					   </td>
						<td class="left">
							<a href="javascript:setReturn('<%=_tmp.get("BYCA_COMORG_LEVEL")%>','<%=_tmp.get("BYCA_COMORG_CODE")%>','<%=_tmp.get("COMORG_NAME")%>','<%=_tmp.get("TYPE")%>','<%=_tmp.get("COM_CODE")%>','<%=_tmp.get("WAREHOUSE_CODE")%>')">
							<font color="blue"><%=CommonUtil.nvl(_tmp.get("COMORG_NAME"))%></font></a>
						</td>
						<td>
							<%=_tmp.get("ICOMBYIT_ADD_CNT")%>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
        </div>
        <br>
        ※ 고객사코드 클릭시 상세정보, 고객사명 클릭시 선택.
    </div>        
</div>
</form> 
</body>
</html>
