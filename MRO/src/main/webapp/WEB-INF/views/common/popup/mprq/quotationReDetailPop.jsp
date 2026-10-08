<%--
**********************************************
* 메뉴 : 
* 화면 : 견적상세내역 조회
* 기능 : 견적번호 클릭시 해당견적번호에 대한 견적상세내역
* 프로그램 ID : PG_04_M_007_02
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-06-17
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
Map<String,String> _dataList1 = (Map<String,String>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)  
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)  
String viewflag = CommonUtil.nvl((String) request.getParameter("viewflag"),"");  //  (조회조건)
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_dept = _sessionInfo.getDepartment();

//SMART팀 확인( 견적담당자 전체 조회 시 견적이관 대상 SG 담당자 제외하고 조회 P04-4029-05 )
String st_smart_dept_yn = "";
boolean st_smart_dept = CommonUtil.getCodeCheckReturn("SMRTDEPT",st_user_dept);
if(st_smart_dept == true){
	st_smart_dept_yn = "Y";
}else{
	st_smart_dept_yn = "N";
}

Map<String,String> rowData = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1;
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	//SLOGIC-BEGIN(P04-4031-11)
	if ($('#st_buyer').val() == 'KRDOOD0001' || $('#st_buyer').val() == 'KRPOON0010' || $('#st_buyer').val() =='KRDOOS0009'){
		$('#prt1').show();
		$('#prt3').hide();
	} else if ($('#st_buyer').val() == 'KRHSDE0003'){
		$('#prt3').show();
		$('#prt1').hide();
	} else {
		$('#prt1').hide();
		$('#prt3').hide();
	}
	//SLOGIC-END
	if ('<%=viewflag%>' == 'HANDOUT'){
		$('#prt2').show();
	} else {
		$('#prt2').hide();
	}
	
	<%
	if (_dataList1==null || _dataList1.size()==0){
	%> 
		setQuery();
<%}%>
	
}

function setQuery()
{ 
  $('#quotationReDetailPop').attr("action", "/mprq/quotationReDetailPop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
//팝업함수호출
function doPop(str, value1) {
	switch (str) {
		case "attach":
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R"; // 보기전용
			openSearchPopup("/common/fileUploadPop.do",'?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,"500,430,no");// 파일첨부
			
			break;
		
		case "negoHistory":
			var buyer = $("#st_buyer").val();
			var quotation_no = $("#st_quotation_no").val();
			var revision = $("#st_revision").val();
			
			popupSel = "buyerMpRqQuotationNegoHistoryPop";
			openSearchPopup("/mprq/getBuyerMpRqQuotationNegoHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+value1+'&st_revision='+revision, "900,300,no");
			
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//처리할필요는 없고 함수만 존재
}

function doAction(str) {
	switch (str) {
	case "print":
		var param = "";
		var fileName = "";
		if ($('#st_ref_no').val() == "RFQ") {
			param =  "["+$('#st_quotation_no').val()+"]["+$('#st_revision').val()+"]["+$('#st_buyer').val()+"]";
			fileName = "RD_04_M_005_02";
		} else {
			param =  "["+$('#st_quotation_no').val()+"]["+$('#st_buyer').val()+"]";
			fileName = "RD_04_M_005_03";
		}
			reportOpen(fileName,param);
		break;
	case "allPrint":
// 		견적접수 및 제출에서 호출 시에만 버튼 보임 //부모창에서 호출 모드에 따라 활성/비활성화 됨. 버튼을 클릭하면 공급사선정 팝업이 호출됨
// 		AS-IS : var loc = "/kr/new_sourcing/master/result_master_quotation_handout_sourcing_write.jsp
		var buyer = $('#st_buyer').val();
		var quotation_no = $('#st_quotation_no').val();
		var revision = $('#st_revision').val();
		popupSel = "masterMpRqSellerChoice2Pop";
		openSearchPopup("/mprq/showMasterMpRqSellerChoice2Pop.do","?st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_revision="+revision,"1100,600,no");
		break;
	case "quotation_hsde": // 오프라인 견적서 제출
		var param =  "["+$('#st_quotation_no').val()+"]["+$('#st_revision').val()+"]["+$('#st_buyer').val()+"]";
		var fileName = "RD_04_M_005_04";
		reportOpen(fileName,param);
		break;
	case "RePrint": // 오프라인 견적서 제출
		var buyer = $('#st_buyer').val();
		var quotation_no = $('#st_quotation_no').val();
		var quotation_seq = $('#st_quotation_seq').val();
		var revision = $('#st_revision').val();
		var agent = $('#st_agent').val();
		if(kepIsValueNull(agent)){
			alert("견적서가 발행되지 않은 품목입니다.");
			return;
		}
		var openflag = "N";
		 if(buyer == "KRHITE0006") {
			 openflag = "Y";
	    }else {
	    	openflag = "N";
	    }
		var fileName = "";
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+openflag+"]";
		if(buyer == 'KRFAGB0001' || buyer == 'KRFAGB0002' || buyer =='KRFAGB0003' || buyer == 'KRDONG0099' || buyer=="KRSCHA0001" || buyer=="KRSCHA0013") {
			fileName = "RD_04_B_004_01";//"RD_04_M_004_00";
			var url = "/coco/showReportViewer.do";
			
			if(buyer == 'KRFAGB0002' || buyer =='KRFAGB0003' || buyer=="KRSCHA0001" || buyer=="KRSCHA0013" || buyer == 'KRFAGB0001'){
				var param1 =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+openflag+"]";
				param1 = encodeURI(param1);
				window.open(url + "" + "?fileName=RD_04_M_004_11&param="+param1, "","width=770,height=800,resizable=YES");
			}
	    }else if(buyer == 'KRILJI0009' || buyer=="KRDAIN0003" || buyer=="KRILSH0001" || buyer=="KRILSH0002" || buyer=="KRILSH0003" || buyer=="KRILSH0004" || buyer=="KRILSI0004" || buyer == 'KRDHIM0003' || buyer=='KRKOOG0001'|| buyer=="KRHWAS0031"|| buyer=="KRSSAN0025"|| buyer=="KRSSAN0028" || buyer=="KRSEOJ0022" || buyer=="KRSEOJ0023" || buyer=="KRSEOJ0024" ) {
	    	fileName = "RD_04_B_004_05";//"RD_04_M_004_01";
	    }else if(buyer == 'KRSNTD0001'){
	    	fileName = "RD_04_M_004_07";
		}else if(buyer == 'KRYUHA0013'){
	    	fileName = "RD_04_M_001_05";	    	
	    	param =  "["+"${sessionInfo.userId}"+"]["+buyer+"]["+quotation_no+"]";
		}else {
	    	fileName = "RD_04_M_004_03";
	    } 
		reportOpen(fileName,param);
		
		break;
	case "close":
		parent.doAction('search');
		self.close();
		break;
	}
}
 //-->
</script> 
<body onload="kep_onload_view()">
	<form name="quotationReDetailPop" id="quotationReDetailPop" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_quotation_no" id="st_quotation_no" size=20 value="<%=st_quotation_no%>" >
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" size=20 value="<%=st_quotation_seq%>" >
	<input type="hidden" name="st_revision" id="st_revision" size=20 value="<%=st_revision%>" >
	<input type="hidden" name="st_agent" id="st_agent" size=20 value="<%=st_agent%>" >
	<input type="hidden" name="viewflag" id="viewflag" size=20 value="<%=viewflag%>" >
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 	
	<!--최소 가로길이 400px-->
	<div id="popWrapper" style="height:502px;">
    	<div id="popHeader">
        	<h1 class="title">견적 상세내역 정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:425px;">
            <!--데이타그리드-->
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th>고객사</th>
                      <td><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>&nbsp;(의뢰일 : <%=CommonUtil.formatStrinigDate(rowData.get("BTOA_DATE"))%>)</td>
                      <th>의뢰번호</th>
                      <td><%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%></td>
                      <th>의뢰부서</th>
                      <td><%=CommonUtil.nvl(rowData.get("BTOA_USER_DEPT"))%></td>
                    </tr>
                    <tr>
                      <th>의뢰자</th>
                      <td><%=CommonUtil.nvl(rowData.get("BTOA_USER_NAME"))%></td>
                      <th>이메일</th>
                      <td><%=CommonUtil.nvl(rowData.get("BTOA_USER_MAIL"))%></td>
                      <th>전화번호</th>
                      <td><%=CommonUtil.nvl(rowData.get("BTOA_USER_TEL"))%>
                      	<input type="hidden" id="st_ref_no" name="st_ref_no" value="<%=CommonUtil.nvl(rowData.get("REF_NO"))%>">
                      </td>
                    </tr>
                </tbody>
            </table>
            
            <!--grid-->
            <div class="scrollArea" style="height:320px">
	            <table  class="cont_t_list02" style="width:100%;">
	                <caption>상세내역</caption>
	                <colgroup>
	                    <col width="6%" />
	                    <col width="12%" />
	                    <col width="*%" />
	                    <col width="4%" />
	                    <col width="8%" />
	                    <col width="9%" />
	                    <col width="8%" />
	                    <col width="10%" />
	                    <col width="11%" />
	                    <col width="4%" />
	                    <col width="9%" />
	                </colgroup>
	                <thead>
	                    <tr>
	                        <th scope="col" class="center">차수<br>순번</th>
	                        <th scope="col" class="center">품목코드<br>진행상태</th>
	                        <th scope="col" class="center">품목명<br>규격</th>
	                        <th scope="col" class="center">수량<br>단위</th>
	                        <th scope="col" class="center">제조사<br>원산지</th>
	                        <th scope="col" class="center">기존협력사<br>요청단가</th>
	                        <th scope="col" class="center">합의담당자<br>목표단가</th>
	                        <th scope="col" class="center">고객사비고</th>
	                        <th scope="col" class="center">견적취소자<br>견적취소사유</th>
	                        <th scope="col" class="center">첨부<br>구분</th>
	                        <th scope="col" class="center">SG명<br>SG담당자(DSM)</th>
	                    </tr>
	                </thead>
	                <tbody>
	<% 
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _tmp2 = _dataList2.get(j);
	%>                 
	                    <tr>
	                        <td class="center">
		                        <%
		                    	if(!("").equals(CommonUtil.nvl(_tmp2.get("NEGO_COUNT")))){
		                    	%>
		                    		<a class="hyperLink b" href="javascript:doPop('negoHistory','<%=CommonUtil.nvl( _tmp2.get("QUOTATION_SEQ"))%>')"><b><%=CommonUtil.nvl(String.valueOf(_tmp2.get("REVISION")))%></b></a>	
								<%
		                    	} else{
		                    	%>
			                    	<%=CommonUtil.nvl(String.valueOf(_tmp2.get("REVISION")))%>
		                    	<%
		                    	}
		                    	%>
	                        	<br>
	                        	<%=String.valueOf(_tmp2.get("QUOTATION_SEQ"))%>
	                        </td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%><br>
	                        	<%=CommonUtil.nvl(_tmp2.get("SOURCING_STATUS"))%>
	                        </td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("DESCRIPTION"))%><br>
	                        	<%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%>
	                        </td>
	                        <td>
	                        	<p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></p>
	                        	<p style="text-align:center;"><%=CommonUtil.nvl(_tmp2.get("UNIT_MEASURE"))%></p>
	                        </td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("MAKER_NAME"))%><br>
	                        	<p style="text-align:center;"><%=CommonUtil.nvl(_tmp2.get("ORIGIN_NAME"))%></p>
	                        </td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("BTOA_AGENT_NAME"))%><br>
	                        	<p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("BUYER_TARGET_PRICE"),true,0,3)%></p>
	                        </td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("CONFIRM_USER_ID"))%><br>
	                        	<p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("ADMIN_TARGET_PRICE"),true,0,3)%></p>
	                        </td>
	                        <td><%=CommonUtil.nvl(_tmp2.get("BTOA_REMARK"))%></td>
	                        <td>
	                        	<%=CommonUtil.nvl(_tmp2.get("CANCEL_USER_NAME"))%>
	                        	<br><%=CommonUtil.nvl(_tmp2.get("CANCEL_REMARK"))%>
	                        </td>
	                        <td class="center">
								<%
								if (("").equals(CommonUtil.nvl(_tmp2.get("IMAGE_KEY")))) { 
								%>
									<img name = "image_key_img" src="/resources/images/disk_off.gif" border="0"/><br><%=CommonUtil.nvl(_tmp2.get("ITEM_TYPE"))%>
								<%
									}else{
								%>         
									<a class="hyperLink" href="javascript:doPop('attach','<%=CommonUtil.nvl( _tmp2.get("IMAGE_KEY"))%>')"><img name = "image_key_img" src="/resources/images/disk_on.gif" border="0"></a>
									<br><%=CommonUtil.nvl(_tmp2.get("ITEM_TYPE"))%>    
								<%
									}
								%>
	                        </td>
	                        <td><%=CommonUtil.nvl(_tmp2.get("SG_NAME"))%><br>
	                        <%if(_tmp2.get("SG_ID") != null) {                        	
	                         %>(<%=CommonUtil.nvl(_tmp2.get("SG_ID"))%>) 	
	                         <% } %>
	                        <br>
	                        <%=CommonUtil.nvl(_tmp2.get("SG_MNG_NM"))%>
	                        
	                        </td>
	                    </tr>
	<% } %>
	                </tbody>
	            </table>
	    	</div>
	    	<!--버튼영역-->
        	<div style="margin-top:10px;margin-bottom:5px;height:20px;">
				<span class="fl">
					<span class="btn_08 mr04" id="prt1"><a href="javascript:doAction('print')">두산중공업 견적의뢰서</a></span>
					<span class="btn_07 mr04" id="prt3"><a href="javascript:doAction('quotation_hsde')">오프라인견적서출력</a></span>

<!-- 과거 조직효율화 시작부터 기준에 맞지 않음. 조직개편에서도 잘못 사용될 수 있어서 화면이 열려있어서 화면 막음 2025.08.18 -->
<% if(st_smart_dept_yn.equals("Y")){%>
					<span class="btn_05" id="prt2"><a href="javascript:doAction('allPrint');">협력사일괄선정</a></span>
<%}%>
<!-- 필요하게 되면 현 기준에 맞게 사용할 수 있도록 설계 다시 해야 함 -->

				</span>
				<span class="fr">
					<span class="btn_05"><a href="javascript:doAction('RePrint');">견적서출력</a></span>
				</span>
	        </div>
        </div>
    	
    </div>
<%}%>    
</form> 
</body>
</html>
