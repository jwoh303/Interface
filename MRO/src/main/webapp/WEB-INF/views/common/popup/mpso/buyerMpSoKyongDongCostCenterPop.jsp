<%--
**********************************************
* 메뉴 : 
* 화면 : 경동CostCenter
* 기능 : 경동보일러 장바구니 관리번호 선택 팝업
* 프로그램 ID : PG_06_B_006_05
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-27
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
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");  //  (조회조건)
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)

String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String st_name = CommonUtil.nvl((String) request.getParameter("st_name"),"");  //  (조회조건)

String buyer_string = "";
String title = "";
 
if(st_buyer.equals("KRKEPB0004")) {
    buyer_string = "계정"; 
    title= "계정정보";
}else if(st_buyer.equals("KRSEOJ0022")){ 
	buyer_string = "계정";
	title= "서진산업"; 
}else {
    buyer_string = "Cost Cneter";
    title= "CostCenter";
}
%> 

<script type="text/javascript">
<!--

function kep_onload(){
	
	<% if ("Y".equals(open)){%>
	kepSearch();
	<%}%>  
}

function kepSearch()
{  
  $('#buyerMpSoKyongDongCostCenterPop').attr("action", "/mpso/getBuyerMpSoKyongDongCostCenterPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}
 
 //-->
</script> 
<body onload="kep_onload()">
<form name="buyerMpSoKyongDongCostCenterPop" id="buyerMpSoKyongDongCostCenterPop" method=post > 
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type=hidden name="st_ref_no" id="st_ref_no"  value="<%=st_ref_no%>">
<input type=hidden name="st_row" id="st_row"  value="<%=st_row%>"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title %></h1>
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
						<caption><%=title %> 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="35%" />
							<col width="5%" />
                            <col width="30%" />
                            <col width="*" /> 
						</colgroup>						
						<tbody>
						<tr>
							<td>코드</td>
							<td> 
								<input type=text name=st_code id="st_code" size=20 value="<%=st_code%>" onkeydown="kepEnter()" class="input_type_text" maxlength="10" onkeyup="kepToUpper('st_code')"> 
                            </td>
						    <td></td>						 
							<td><%=buyer_string%> 명</td>
							<td> 
								<input type=text name=st_name id="st_name" size=20 value="<%=st_name%>" onkeydown="kepEnter()" class="input_type_text" maxlength="25" style="ime-mode:active" > 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:338px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption><%=title %> 리스트</caption>
                    <colgroup> 
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드</th> 
                            <th scope="col"> <%=buyer_string%>명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "200">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
	
	String t_code = rowData.get("CODE");
	if(st_buyer.equals("KRKEPB0004")||st_buyer.equals("KRSEOJ0020")||st_buyer.equals("KRSEOJ0021")||st_buyer.equals("KRSEOJ0022")||
			st_buyer.equals("KRSEOJ0023")||st_buyer.equals("KRSEOJ0024")||st_buyer.equals("KRSEOJ0025")) { 
			t_code = rowData.get("TEXT1");
	}
	
%> 
                        <tr>
					      <td class="center"><a href="javascript:opener.setKyungDong('<%=t_code%>','<%=st_row%>'),window.close()"><%=rowData.get("CODE")%></a></td>
					      <td class="left"><a href="javascript:opener.setKyungDong('<%=t_code%>','<%=st_row%>'),window.close()"><%=rowData.get("TEXT1")%></a></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
		<div class="btnArea">
			<span class="btn_reset"><a href="javascript:opener.setKyungDong('','<%=st_row%>'),window.close()">초기화</a></span>  
		</div>   
    </div>        
</div>
</form> 
</body>
</html>
