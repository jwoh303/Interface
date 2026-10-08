<%--
**********************************************
* 메뉴 : 주문관리>주문내역(홍익대용)
* 화면 : 주문내역(홍익대용)
* 기능 : 홍익대전용 주문조회내역 화면
* 프로그램 ID : PG_06_B_012_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-09
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
</head>
<%
	// 공통
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과	 
	String Hdata_FLAG = (String) request.getAttribute("Hdata"); // 조회된 결과
	
	//---------------------------------
	//홍익대학교--품의서 양식 설정
	// ex) SEDEPT
	// 2자리 캠퍼스 구분 SE : 서울, SJ : 세종
	// 4자리 부서 구분 GRAD : 대학원, COMP : 학부, DEPT : 행정부서 
	String hongikSheetType = "N";
	hongikSheetType = (String) request.getAttribute("HdataSheetType"); // 조회된 결과 
	if("".equals(hongikSheetType))hongikSheetType = "SEDEPT";
	String comp = "";  
	String dept = ""; 
	 if (!"".equals(hongikSheetType)){
		 if (hongikSheetType.length()>5){
			comp = hongikSheetType.substring(0,2);
			dept =  hongikSheetType.substring(2,6);
		 }
	 }
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수) 
	String onepagerow = "1000";  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다. 
	String openYn = CommonUtil.nvl((String) request.getParameter("openYn"),"Y"); 	
	String SessionComCode = "";
	String byca_comorg_code = ""; 
	String img_view_flag   = "";
	String buyer             = "";
	String user_dept              = "";
	String budget_flag       = "";     // 고객사 예산 사용여부
    String userRole           = "";  
    String userRole1 = "";  
    String userRole2 = "";   
    String userId = ""; 
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		buyer  = SessionComCode;
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag()); 
		userRole = CommonUtil.nvl((String)sessionInfo.getRole()); 
		userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	}  
	
	
	 String p060000027 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027","COL05_DATA"); // KRGEST0001 KRHONG0020 KRKEPB0004
    //---------------------------------
	//홍익대학교-- 대학원 소속 체크.
	String hongikType = "N";
	String h_dept ="학과" ;	    
	//SLOGIC-BEGIN(P06-0000027)
	if(p060000027.equals("TYPE2")){ // KRHONG0020
	    hongikType = Hdata_FLAG;
	}
	//SLOGIC-END
	if("Y".equals(hongikType))h_dept ="대학원 학과" ;
%> 
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3>주문내역(홍익대용)</h3> 
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
		<input type="hidden" name="openYn" id="openYn" value="<%=openYn %>" />
		
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_buyer"				value="<%=buyer%>">   
		<input type="hidden" name="st_user_dept"				value="<%=user_dept%>">   
		<input type="hidden" name="st_verif_num"       value="">   
		<input type="hidden" name="st_listQuery"       value="2">   
		<input type="hidden" name="curPage"       value="1">   
		<input type="hidden" name="st_query_cart"       value="ALL">   
		
		
		
	 
 	</form> 
 <form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>
   	
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 --> 
	  	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	  			
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="20%" />
	            <col width="20%" />
	            <col width="20%" />
	            <col width="20%" />
	            <col width="20%" /> 
	        </colgroup>
	        <thead>
			<tr> 
                <th scope="col">확인번호</th>
                <th scope="col">품목정보</th>
                <th scope="col">회계항목</th>
                <th scope="col"><%=h_dept%></th>
                <th scope="col">총금액</th>
			</tr>
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
		<tr>
			<td colspan="15" align="center" height = "50"> 
			<span>조회된 데이타가 없습니다.</span>
			</td> 
		</tr>
<%
}else{
Map<String,String> rowData = null;
total_cnt = String.valueOf(_gridList.size());
for (int j=0; j<_gridList.size(); j++) {
	rowData = _gridList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
	
%> 
				<tr   bgcolor="<%=tclass%>">
                <td class="center" >
					 <%=rowData.get("VERIF_NUM")%>
                </td>
					<%
						String item_list =""; 
						if(rowData.get("ORDER_QTY").equals("0")){
							item_list = rowData.get("DESCRIPTION");
						}else{
							item_list = rowData.get("DESCRIPTION") +"외 "+rowData.get("ORDER_QTY") +"종.";
							
						}
					%>
                <td class="left"><a class="hyperLink"  href="javascript:getCart('<%=rowData.get("VERIF_NUM")%>');"><%=item_list%></a>
                </td>
                <td class="center"> <%=rowData.get("REF_PR_TEXT")%></td>
                <td class="left"> <%=rowData.get("DEPT")%></td>
                <td class="right"> <%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>&nbsp;</td>
				</tr>
<%
		} 
	}
%>
           		</tbody>
            </table> 
</form>
         <%
		request.getSession().setAttribute("session_CART_CNT", total_cnt);
		%> 
<script>	$('#top_cart_cnt').html("<%=total_cnt%>");</script>		
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
 
}

//조회
function kepSearch(curPage){	  
	document.forms.searchForm.openYn.value = "N"; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoOrderDetailHongikList.do").submit();   
}

//홍익대학교 물품구입 신청서.
function PrSheetView(verif_num){
	var userId = "<%=userId%>";
	var userComCode = "<%=buyer%>";
	var userDept = "<%=user_dept%>";   
	
	var user_comp= "<%=comp%>";
	var user_dept = "<%=dept%>"; 
	var loc = "";  

	if(user_comp == "SE"){
		if(user_dept == "GRAD"){
			loc = "RD_06_B_001_01"; // "/kr/epro/buy/sheet/pum_hongik_1.mrd";
		}else if(user_dept == "COMP"){
			loc = "RD_06_B_001_02"; // "/kr/epro/buy/sheet/pum_hongik_6.mrd";
		}else if(user_dept == "DEPT"){
			loc = "RD_06_B_001_03"; // "/kr/epro/buy/sheet/pum_hongik_2.mrd";
		}else if(user_dept == "INST"){
			loc = "RD_06_B_001_07"; // 추가 HSJ 2018.03.28
		}else if(user_dept == "INDU"){
			loc = "RD_06_B_001_22"; // 추가 KYH 2019.12.20
		}else if(user_dept == "CAMP"){
			loc = "RD_06_B_001_24"; // 추가 CCK 2020.09.28
		}else if(user_dept == "GRAS"){
			loc = "RD_06_B_001_25"; // 추가 CCK 2020.10.22
		}else if(user_dept == "DEPS"){
			loc = "RD_06_B_001_26"; // 추가 CCK 2020.10.22
		}else if(user_dept == "COMS"){
			loc = "RD_06_B_001_27"; // 추가 CCK 2020.10.22
		}else if(user_dept == "INSS"){
			loc = "RD_06_B_001_28"; // 추가 CCK 2020.10.22
		}else if(user_dept == "TP01"){
			loc = "RD_06_B_001_29"; // 추가 HSJ 2020.12.29
		}
	}else if (user_comp == "SJ"){
		if(user_dept == "GRAD"){
			loc = "RD_06_B_001_04"; // "/kr/epro/buy/sheet/pum_hongik_4.mrd";
		}else if(user_dept == "COMP"){
			loc = "RD_06_B_001_05"; // "/kr/epro/buy/sheet/pum_hongik_3.mrd";
		}else if(user_dept == "DEPT"){
			loc = "RD_06_B_001_06"; // "/kr/epro/buy/sheet/pum_hongik_5.mrd";
		}else if(user_dept == "INST"){
			loc = "RD_06_B_001_08"; // 추가 KYH 2019.12.06
		}else if(user_dept == "INDU"){
			loc = "RD_06_B_001_23"; // 추가 KYH 2019.12.20
		}
	} 	 
	reportPostOpen(loc,"[]["+userComCode+"]["+userId+"]["+userDept+"]["+verif_num+"]");	
	//window.open("/kr/epro/buy/sheet/pum_hongik_sheet.jsp?st_buyer="+userComCode+"&st_user_id="+userId+"&st_user_dept="+userDept+"&st_verif_num="+verif_num,"PrSheetWin","width=1000,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
}


function getCart(verif_num){ 	
    document.forms.searchForm.st_verif_num.value =verif_num; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartList.do").submit();   
}
 
  
</script>
</html>
