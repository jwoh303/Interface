<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 선택 -기존,신규협력사검색
* 기능 : 협력사 선택 팝업-기존, 신규 협력사 검색
* 프로그램 ID : PG_03_M_002_02
* 담당자 : 카탈개 ( 설계 : 권우재 )
* 착수일 : 2014-
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
String flag = CommonUtil.nvl((String) request.getParameter("st_flag"),"");
String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");
String category_no = CommonUtil.nvl((String) request.getParameter("st_category_no"),"");

String st_agent_code = CommonUtil.nvl((String) request.getParameter("st_agent_code"),"");  //  (조회조건)
String st_agent_name = CommonUtil.nvl((String) request.getParameter("st_agent_name"),"");  //  (조회조건)
String status_flag = CommonUtil.nvl((String) request.getParameter("status_flag"),"");
String credit_status = CommonUtil.nvl((String) request.getParameter("credit_status"),"");
%>

<script type="text/javascript">
<!--
function popupOnload(){
	var status_flag = $("#status_flag").val();
	if(status_flag!='N'){
		kepSearch('DEF');
	}
}

function kepSearch(tempFlag)
{  
	$("#temp_flag").val(tempFlag);
	
	var agent_code = $("#st_agent_code").val();
    var agent_name = $("#st_agent_name").val();
    var tempFlag = $("#temp_flag").val();
	if((tempFlag=="OLD" ||  tempFlag=="NEW") && agent_code == "" && agent_name == ""){
		alert("협력사코드 또는 협력사명을 입력하여야 조회 가능합니다.");
		return;
	}
	
	if(tempFlag=="DEF"){
		$("#st_agent_code").val("");
		$("#st_agent_name").val("");
	}
	
	//onload시 최초 1회만 조회하도록.
	$("#status_flag").val("N");
	$('#masterMdCmSellerCmpyChoicePop').attr("action", "/mdcm/getMasterMdCmSellerCmpyChoicePop.do").submit();    
}

function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2,value3);
  this.close();
}

function doPop(value1)
{ 	
	openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+value1, "800,600,no");
}
 //-->
</script> 
<body onload="popupOnload()">
<form name="masterMdCmSellerCmpyChoicePop" id="masterMdCmSellerCmpyChoicePop" method=post >
<input type="hidden" id="st_flag" name="st_flag" value = "<%=flag%>">
<input type="hidden" id="st_buyer" name="st_buyer" value = "<%=buyer%>">
<input type="hidden" id="st_agent" name="st_agent" value = "<%=agent%>">
<input type="hidden" id="st_category_no" name="st_category_no" value = "<%=category_no%>">
<input type="hidden" id="temp_flag" name="temp_flag" value = "">
<input type=hidden id="status_flag"  name="status_flag" value="<%=status_flag%>"> 
<input type=hidden id="credit_status"  name="credit_status" value="<%=credit_status%>"> 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:530px;">
    	<div id="popHeader">
        	<h1 class="title">협력사 선택 -기존,신규협력사검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_07"><a href="javascript:kepSearch('OLD');">기존협력사 검색</a></span>
            	<span class="btn_07"><a href="javascript:kepSearch('NEW');">신규협력사 검색</a></span>
            	<span class="btn_03"><a href="javascript:kepSearch('DEF');">초기화</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>협력사 선택 -기존,신규협력사검색 리스트</caption>
						<colgroup>
							<col width="100px" />
							<col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<th>협력사코드</th>
							<td> 
								<input type=text name=st_agent_code id="st_agent_code" size=20 value="<%=st_agent_code%>"  class="input_type_text"> 
                            </td>
						</tr>
						<tr>
							<th>협력사명</th>
							<td> 
								<input type=text name=st_agent_name id="st_agent_name" style="ime-mode:active" size="40" value="<%=st_agent_name%>"  class="input_type_text"> 
                            </td>
						</tr>						 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:350px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>협력사 선택 -기존,신규협력사검색 리스트</caption>
                    <colgroup>
                        <col width="15%" />
                        <col width="22%" />
                        <col width="18%" /> 
                        <col width="13%" /> 
                        <col width="32%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">협력사코드</th> 
                            <th scope="col">협력사명</th>
                            <th scope="col">사업자등록번호</th> 
                            <th scope="col">업태</th> 
                            <th scope="col">종목</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td class="left">
						 	<a href="javascript:doPop('<%=_tmp.get("AGENT")%>')">
							<font color="blue"><%=_tmp.get("AGENT")%></font></a>
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("AGENT")%>','<%=_tmp.get("COM_NAME_LOC")%>','<%=_tmp.get("LOGISTICS_CENTER_CNT")%>')">
							<font color="blue"><%=_tmp.get("COM_NAME_LOC")%></font></a>
					   </td>
						<td>
							<%=_tmp.get("IRS_NO")%>
						</td>
						<td class="left">
							<%=_tmp.get("INDUSTRY_TYPE")%>
						</td>
						<td class="left">
							<%=_tmp.get("BUSINESS_ITEMS")%>
						</td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
                ※ 협력사코드 클릭시 협력사 상세정보, 협력사명 클릭시 선택.                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
