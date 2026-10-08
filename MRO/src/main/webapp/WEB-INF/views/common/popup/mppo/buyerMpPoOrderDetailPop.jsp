<%--
**********************************************
* 메뉴 : 
* 화면 : 구매요청(발주) 상세조회
* 기능 : 구매요청 발주 보류 처리 시 생성된 발주번호 기준으로 발주정보 상세조회 하는 팝업
* 프로그램 ID : PG_06_B_018_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
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
List<Map<String,String>> _infoList =  (List<Map<String,String>>) request.getAttribute("info"); // 조회된결과   
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String COMPANY = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String REF_NO = CommonUtil.nvl((String) request.getParameter("REF_NO"),""); // 조회조건
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),""); // 조회조건
String PO_NO = CommonUtil.nvl((String) request.getParameter("PO_NO"),""); // 조회조건
String openYn = CommonUtil.nvl((String) request.getParameter("openYn"),""); // 조회조건 
if ("".equals(PO_NO)){
	if (_dataList == null || _dataList.size() == 0){
	}else{
		Map<String,String> rowData = _dataList.get(0);
		PO_NO = rowData.get("PO_NO");
	}
}

String SessionComCode = "";
String byca_comorg_code = ""; 
String buyer = ""; 
String user_dept              = ""; 
String userId = "";
String byca_comorg_level = "";
String dept_name = "";

if (sessionInfo != null){ 
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
}  

buyer = CommonUtil.nvl(COMPANY, SessionComCode);

//SLOGIC-BEGIN(P06-0000051)
String reportText= CommonLang.get("HTITLE510"); // "품의서출력" // default 버튼명
String reportid = "RD_06_S_003_12";  // default report id /kr/customer/sheet/px_print.jsp
Map<String, String> p060000051 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000051");   // com_code , 특수로직아이디
if (p060000051 != null){
	reportText= CommonUtil.nvl(p060000051.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid = CommonUtil.nvl(p060000051.get("COL02_DATA"),reportid); // 레포트아이디
} 
//SLOGIC-END
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
	<% if ("Y".equals(openYn)) { %>
  $('#buyerMpPoOrderDetailPop').attr("action", "/mppo/getBuyerMpPoOrderDetailPop.do").submit();    
  <%}%>
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}
 

function  attach_popup(img_key){	
	
	var type = "PR";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
//PG_06_B_018_02
function ItemAdd(){
	openSearchPopup("/mppo/getBuyerMpPoGoodsAddPop.do","?openYn=Y&st_px_no=&st_recv_flag=HI" , "1000,800,no"); 
}




function prnSheet() {	  

	var buyer         = "<%=buyer%>"; //필수항목
	var chgUserDept   = "<%=user_dept%>"; //필수항목
	var addUserID     = "<%=userId%>"; //필수항목
	var prNo          = "<%=REF_NO%>";
	var ref_no        = "";
	var add_date      = "<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>";
	var dept_name     = "<%=dept_name%>";
	var dept_code     = "<%=user_dept%>";
	var byca_comorg_level  = "<%=byca_comorg_level%>";
	var recv_flag     = "<%=RECV_FLAG%>";
	var PO_NO     = "<%=PO_NO%>";
	var fileName = "<%=reportid%>";
	//var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+chgUserDept+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]";  // 통합된 파라미터
	var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]["+PO_NO+"]";  // 통합된 파라미터
  	reportOpen(fileName,param);

  } 


 //-->
</script> 
<body onload="kepSearch()">
<form name="buyerMpPoOrderDetailPop" id="buyerMpPoOrderDetailPop" method=post >
<input type="hidden" name="REF_NO" id="REF_NO"  value="<%=REF_NO%>">
<input type="hidden" name="DOCU_NO" id="DOCU_NO"  value="<%=REF_NO%>">
<input type=hidden name="COMPANY" id="COMPANY"  value="<%=COMPANY%>">
<input type=hidden name="RECV_FLAG" id="RECV_FLAG"  value="<%=RECV_FLAG%>">
<input type=hidden name="PO_NO" id="PO_NO"  value="<%=PO_NO%>">
<%
if ("".equals(openYn)){
%>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:600px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE845") %><!-- 구매요청(발주) 상세조회 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
         <h3><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --> : <%=REF_NO %></h3> 
           	<!--grid-->
           	  <table  class="cont_t_list02"  style="width:100%">
                    <caption>구매요청(발주)  리스트</caption>
                    <colgroup>
                        <col width="*" />                   
                        <col width="20%" />                 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE846") %><!-- 적요 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE847") %><!-- 상금액 --></th>   
						</tr>
					</thead>
					<tr>
<%
if (_infoList == null || _infoList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="3" align="center" height = "50"> 
		            <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_infoList.size(); j++) {
	Map<String,String> rowData = _infoList.get(j);
if(rowData.get("AGENT").equals("")) {

%>

        <tr>
          <td height="25" class="right" colspan="3"><b><%=CommonLang.get("HTITLE172") %><!-- 총 금액 --></b> : <span style=" padding:3px; color:#F00; font-weight:bold"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%> <%=CommonLang.get("HTITLE660") %><!--  원 --></span></td>
        </tr>
<%
			}else {
%>

        <tr>
          <td class="left" title="적요">&nbsp;<%=rowData.get("DESCRIPTION")%></td>
          <td class="right" title="금액"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%> <%=CommonLang.get("HTITLE660") %><!--  원 -->&nbsp; </td>
        </tr>
<% 
		}
	}
}
%>     </table>				
<br> 
            <div class="scrollArea" style="height:180px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>구매요청(발주)  리스트</caption>
                    <colgroup>
                        <col width="10%" />                   
                        <col width="*" />                   
                        <col width="15%" />                   
                        <col width="7%" />                   
                        <col width="7%" />
                        <col width="7%" /> 
                        <col width="10%" /> 
                        <col width="10%" /> 
                        <col width="10%" />    
                        <col width="5%" />                    
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>   
							<th scope="col"><%=CommonLang.get("HTITLE142") %><!-- 수량/단위 --></th>   
							<th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>   
							<th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>  
							<th scope="col"><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --></th>  
							<th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>  
							
        <%

				String title1 =CommonLang.get("HTITLE18");	//"관리번호"
				if(COMPANY.equals("KRHYOS0026")){
					title1 =CommonLang.get("HTITLE135");	//"요청부서"
				}

			%>

        				<th scope="col" ><%=title1%></th>	
        				<th scope="col" ><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>										
                        </tr>              
                    </thead>
                    <tbody>
<%
double tot_price = 0;
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="10" align="center" height = "50"> 
		            <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
	tot_price += Double.parseDouble(rowData.get("PO_AMT"));
%>     
<tr>
		<td height="25" align="center" title="품목코드"><a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a></td>

          <td title="품목명" class="left"><%=rowData.get("DESCRIPTION")%></td>

          <td title="규격" class="left"><%=rowData.get("SPECIFICATION")%></td>

          <td class="right" title="수량/단위"><%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>/<%=rowData.get("UNIT_MEASURE")%></td>

          <td class="right" title="단가"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></td>

          <td class="right" title="금액"><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>

          <td class="center" title="납기요청일"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>

          <td title="협력사"><%=rowData.get("AGENT_NAME")%></td>

         <%

				String title1_val =rowData.get("REF_PR_NO");

			if(COMPANY.equals("KRHYOS0026")){

					title1_val = rowData.get("REQ_DEPT_NAME")+"/"+rowData.get("REQ_USER_NAME");

			%>

          <td class="center" title = "관리번호&nbsp;:&nbsp;<%=rowData.get("REF_PR_NO")%>"><%=title1_val%></td>

          <%

				}else{

			%>

	          <td class="center"><%=title1_val%></td>

          <%

				}

			
				String IMAGE_KEY = CommonUtil.nvl(rowData.get("IMAGE_KEY"));
			%>
                	<td title="파일">
                					<input type="hidden" name="st_image_key"            value="<%=IMAGE_KEY%>">
			<%
					 if(!"".equals(IMAGE_KEY)) {
			%>
				
						<a href="javascript:attach_popup('<%=IMAGE_KEY%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
								}else {
			%>
					 <img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
			<%
								}
			%>
                	
                	
                	</td>


<%}

%>
<tr>
<%

}%>                    
                    </tbody>
                </table> 
                        </div>      
                <table style="width:100%">			
			      <tr>			
			        <td>	<% if (!"NONE".equals(reportText)) { %>
			  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:prnSheet();"><%=reportText%></a></span>  
			  	</td>
			        <td align="right" height = "30" title="금액합계">
			        <b><font color="#990000"><%=CommonLang.get("HTITLE584") %><!-- 금액합계 --></font> : <font color="#006699"><%=CommonUtil.formatNumber(tot_price,true,0,3)%>&nbsp;<%=CommonLang.get("HTITLE660") %><!-- 원 --></font>&nbsp;</b>
			  		<%} %>
			        </td>			
			      </tr>			
			    </table>           
  
    </div>        

</div>
<%}%>
</form> 
</body>
</html>
