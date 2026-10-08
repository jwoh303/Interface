<%--
**********************************************
* 메뉴 : 
* 화면 : 거래고객사선택 
* 기능 : 
* 프로그램 ID : PG_03_A_003_01
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-11
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
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
%>

<script type="text/javascript">

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function SelectCompany(){  
	var tot_cnt = document.forms.sellerMpClTranBuyerChoicePop.count.value;

	var tmptmp1 = "";
	var tmptmp2 = "";
	if (tot_cnt == 1){
		var box = eval("document.forms.sellerMpClTranBuyerChoicePop.checkbox0");
		if(box.checked == true){
			var tmp = $("input[name=buyerList]").eq(0).val() ; 
			var arrKey = tmp.split("@");
			tmptmp1 = tmptmp1 + arrKey[0]+"@";
			tmptmp2 = tmptmp2 + arrKey[1]+"@";
		}
	} else {
		for(var i = 0; i < tot_cnt; i++){
			var box = eval("document.forms.sellerMpClTranBuyerChoicePop.checkbox" + i);
			if(box.checked == true){
				var tmp = $("input[name=buyerList]").eq(i).val() ; 
				var arrKey = tmp.split("@");
				tmptmp1 = tmptmp1 + arrKey[0]+"@";
				tmptmp2 = tmptmp2 + arrKey[1]+"@";
			}
		}
	}
	setReturn(tmptmp1,tmptmp2);
}
</script> 
<body onload="">
<form name="sellerMpClTranBuyerChoicePop" id="sellerMpClTranBuyerChoicePop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">거래고객사선택 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:415px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>거래고객사선택  리스트</caption>
                    <colgroup>
                    	<col width="10%" />
                        <col width="70%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">
                        		<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.sellerMpClTranBuyerChoicePop.count.value,document.forms.sellerMpClTranBuyerChoicePop.check_status,'document.forms.sellerMpClTranBuyerChoicePop.checkbox');">
                        	</th>
                            <th scope="col">고객사명</th> 
                            <th scope="col">등록 품목 건수</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
					<input type="hidden" name="count" id="count"  value="0">
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
						<td><input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>">
						<input type="hidden" name="buyerList" id="buyerList" value="<%=CommonUtil.nvl(_tmp.get("BUYER"))+"@"+CommonUtil.nvl(_tmp.get("BUYER_NAME"))%>">
						</td>
						<td class="left">
							<%=_tmp.get("BUYER_NAME")%>
						</td>
						<td class="right">
							<%=CommonUtil.formatNumber(_tmp.get("CNT"),true,0,3)%>
						</td>
					</tr>
	<%}%>
					<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
<%}%>                               
                    </tbody>
                </table>
        </div>
        <br>
        <div class="btnArea">
<%
if(_dataList == null || _dataList.size() == 0){ 
}else{
%> 
			<span class="fr">
				<span class="btn_02 mr04 mb20"><a href="javascript:SelectCompany()" >확인</a></span>
			</span>                	
<%}%> 
		</div>
    </div>        
</div>
</form> 
</body>
</html>
