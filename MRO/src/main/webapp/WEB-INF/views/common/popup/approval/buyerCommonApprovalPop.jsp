<%--
**********************************************
* 메뉴 :  
* 화면 : 상신
* 기능 : 상신
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _list = (List<Map<String,String>>) request.getAttribute("approvalLine"); // 조회된결과
List<Map<String,String>> _cateapprlist = (List<Map<String,String>>) request.getAttribute("cateapprovalLine"); // 카테고리담당자
List<Map<String,String>> _buyerapprlist = (List<Map<String,String>>) request.getAttribute("buyerapprovalLine"); // 카테고리담당자
@SuppressWarnings (value="unchecked")
Map<String, Object> ht = (Map<String, Object>) request.getAttribute("data"); // 조회된결과   
String biz_url = CommonUtil.nvl((String)ht.get("biz_url"),"");  // 공통테이블이서 가지고온 각업무별 url
String action_base = CommonUtil.nvl((String)ht.get("action_base"),"");  // 공통테이블이서 가지고온 각업무별 action url
String biz_jsp = CommonUtil.nvl((String)ht.get("biz_jsp"),""); // 공통테이블이서 가지고온 각업무별 jsp 파일명
String curDate = CommonUtil.nvl((String)ht.get("curDate"),"");

String st_cont = CommonUtil.nvl((String)request.getAttribute("st_cont"),"");
		st_cont = st_cont.replaceAll("&lt;br&gt;", "\n");
String st_title = CommonUtil.nvl((String)request.getAttribute("st_title"),"");


String usernm = "";
String COMPANY = "";
String userType = "";
String userDepartment = "";
String userId = "";
if (_sessionInfo != null){ 
	usernm =  CommonUtil.nvl((String)_sessionInfo.getUserNameLoc()); 
	COMPANY =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
	userType    = CommonUtil.nvl((String)_sessionInfo.getUserType());
	userDepartment    = CommonUtil.nvl((String)_sessionInfo.getDepartment());
	userId = CommonUtil.nvl((String)_sessionInfo.getUserId());
	
} 
//p060000059 결재지정/변경 버튼 비활성화 SLOGIC
boolean p060000059= CommonUtil.getSpecialCheckReturn(COMPANY,"P06-0000059");

String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"");    
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");    
String BIZ_DOCU_NO = CommonUtil.nvl((String) request.getParameter("BIZ_DOCU_NO"),"");    
String requesTemptYn = CommonUtil.nvl((String) request.getParameter("requesTemptYn"),"");    
//COMPANY = CommonUtil.nvl((String) request.getParameter("st_buyer"),(String)_sessionInfo.getComCode());
String PARAM1 = CommonUtil.nvl((String) request.getParameter("PARAM1"),"");    
String PARAM2 = CommonUtil.nvl((String) request.getParameter("PARAM2"),"");    
String PARAM3 = CommonUtil.nvl((String) request.getParameter("PARAM3"),"");    
String gubun = CommonUtil.nvl((String) request.getParameter("gubun"),"N");    

// 일진전기 주문시 결재창에 금액 및 결재정보 보여줌
String tot_price = CommonUtil.nvl((String) request.getParameter("nu_tot_price"),"");     

String category_no = CommonUtil.nvl((String) request.getParameter("st_category_no"),"");     
//KRKORE0001 운영사 결재선 체크
String apprId = CommonUtil.getCode3RoleReturn("APPR", userDepartment, COMPANY, "CODE2");
//첨부파일 필수 여부
String pass_attach_yn = CommonUtil.nvl((String) request.getParameter("pass_attach_yn"),"");
StringBuffer sb = new StringBuffer(); 
if ("NG".equals(DOC_TYPE) || "NS".equals(DOC_TYPE)){
	//NG	견적의뢰
	//NS	소상합의
/* 불필요 로직 제거.현
	sb.append("신상품 등록을 신청하고자 하오니, 결재 바랍니다.	\n");
	sb.append("1.  품목유형 : 	\n");
	sb.append("2.  품  명 : 	\n");
	sb.append("3.  규  격 : 	\n");
	sb.append("4.  제조사 : 	\n");
	sb.append("5.  신상품 등록 사유 : 	\n");
	sb.append("6.  기  타 :	\n");
*/
	
} else if ("SO".equals(DOC_TYPE) && !"nego".equals(gubun)){
//SO	신규소싱
	sb.append("① 개선방안 : 	\n");        
	sb.append("② 개선일정 : 	\n");        
	sb.append("③ 발생사유 : 	\n");        
	sb.append("④ 단기개선 가능여부 표기 : 	\n");        

}

if ("".equals(st_cont)){
	st_cont = sb.toString();
}

String cateappr_id = "";
String cateappr_name = "";
if ("".equals(category_no) || _cateapprlist == null || _cateapprlist.size() == 0){ 
}else{
	for (int j=0; j<_cateapprlist.size(); j++) {
		Map<String,String> rowData1 = _cateapprlist.get(j);
		if(j > 0){
			cateappr_id += ',';
			cateappr_name += ',';			
		}
		cateappr_id += CommonUtil.nvl(rowData1.get("CATEAPPR_ID"));
		cateappr_name += CommonUtil.nvl(rowData1.get("CATEAPPR_NAME"));
	}
}
//SLOGIC-BEGIN(P11-0000007)
String _approvalUrl = "/common/popup/approval/approvalHumanEditPop.do";	// 결재경로 팝업 원 소스
Map<String, String> p110000007_map	= CommonUtil.getSpecialCheckReturnMap(COMPANY,"P11-0000007");
if (p110000007_map != null) {
	_approvalUrl = p110000007_map.get("COL01_DATA");
}
//SLOGIC-END

//p060000135 결재선 내 필수 포함 부서 /사용자 체크 여부   
Map<String, String> p060000135_map = CommonUtil.getSpecialCheckReturnMap(COMPANY,"P06-0000135");
String _alertMsg = "";
String buyerappr_id = "";
String buyerappr_name = "";
String buyerappr_type = "";
Boolean p060000135 = false;
if (p060000135_map != null) {
	p060000135 = true;
	_alertMsg = p060000135_map.get("COL01_DATA");
	buyerappr_type = p060000135_map.get("COL02_DATA"); 
	if (_buyerapprlist != null && _buyerapprlist.size() != 0){ 
		for (int j = 0; j < _buyerapprlist.size(); j++) {
			Map<String,String> rowData1 = _buyerapprlist.get(j);
			if(j > 0){
				buyerappr_id += ',';
				buyerappr_name += ',';			
			}
			buyerappr_id += CommonUtil.nvl(rowData1.get("BUYERAPPR_ID"));
			buyerappr_name += CommonUtil.nvl(rowData1.get("BUYERAPPR_NAME"));
		}
	}
}
%>
<script type="text/javascript"> 
function kep_onload_view(){ 
 
	goAppPathChange(); // 기본결재선 바로 지정
}

function goAppPathChange(){ 	   
	kepAjaxPopFormCall("/common/approval/getMultiPassLine.do","buyerCommonApprovalPop","goAppPathChange","Y"); 
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxPopSuccess(pMethod , response){  
	if (pMethod == "goAppPathChange"){
		 var to = response.msg.to;
		 var cc = response.msg.cc;
		 var ag = response.msg.ag;
		 var name_list = response.msg.name_list;
		 var toContent = response.msg.toContent;  
		// alert(toContent);
		 $("#to").val(to);
		 $("#cc").val(cc);
		 $("#ag").val(ag);
		 $("#kto").html(name_list);  
		 $("#toContent").val(toContent);  
	}  
	
	 $("#DOCU_TITLE").focus();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxPopError(pMethod , response) { 
	if (pMethod == "goAppPathChange"){
		 alert("결재선 선택이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} 
	 $("#DOCU_TITLE").focus();
} 

function approvalLine(){
	var option = "?toContent="+ $("#toContent").val();
	openSearchPopup('<%=_approvalUrl%>',option, "1000,470,no");	// 특수로직(P11-0000007) 추가. 고객사별 결재경로 선택 팝업을 변경할 수 있다. 
}

function  attach_popup(){	
	var type = "<%=DOC_TYPE%>";
	var viewType = "C";
	var img_key = $("#st_image_key").val(); 	   	 
	kepFileUploadOpenPopup(img_key,type,viewType);
}

function setPopupReturn(value1,value2){ 	 
   	$("#st_image_key").val(value1); 	   	
   	
   	//alert(value2);
   	$("#diskimg").attr("src","/resources/images/disk_"+value2+".gif"); 
   	
   	//alert(	$("#st_image_key").val());
}   

function nosubmit() { 
}

function captureReturnKey(e) {   
	if(e.keyCode==13 && e.srcElement.type != 'textarea')   
	return false;   
}   

	
</script> 
<body onload="kep_onload_view()">
<%
/*
	SELECT              
		    A.*
		    , TO_CHAR(SYSDATE,'YYYY/MM/DD HH:MM')   as CURDATE
			FROM ICOMCOD1     A
			WHERE 1=1   
		 	AND A.TYPE = 'APPR'
		 	*/%>
<form name="buyerCommonApprovalPop" id="buyerCommonApprovalPop" method="post"   onkeydown="return captureReturnKey(event)">  
<input type=hidden name="COMPANY" value="<%=COMPANY%>">
<input type=hidden name="DOC_TYPE" value="<%=DOC_TYPE%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="EXTIF_TP" value="<%=DOC_TYPE%>">  <!--  상신일경우에는 수정 필요 --> 
<input type=hidden name="to" id="to" value="">
<input type=hidden name="cc" id="cc"  value="">
<input type=hidden name="ag" id="ag"  value=""> 
<input type=hidden name="st_image_key" id="st_image_key"  value=""> 
<input type=hidden name="toContent" id="toContent"  value=""> 
<input type=hidden name="DOCU_KN" value="1">  <!--  상신일경우에는 수정 필요 문서종류(1:결재문서) -->
<input type=hidden name="requesTemptYn" value="<%=requesTemptYn%>"> <!--  Y 임시테이블이용 N 임시테이블미이용 -->
<input type=hidden name="BIZ_DOCU_NO" value="<%=BIZ_DOCU_NO%>"> <!--  업무키를 사용한다 -->
<input type=hidden name="PARAM1" value="<%=PARAM1%>">
<input type=hidden name="PARAM2" value="<%=PARAM2%>">
<input type=hidden name="PARAM3" value="<%=PARAM3%>">
<input type=hidden name="st_category_no" value="<%=category_no%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">상신</h1>
            <p class="popClose"><a id="btn_close" href="javascript:popClose()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
      	</div>
	<!--팝업내용입니다-->
	<div id="popContainer">
	<h4 class="b">[ 결재/참조자 정보 ]</h4>	
	<table  class="board_write" summary="결재/참조자 대한 정보입력">
		<caption>결재/참조자</caption>
			<colgroup>
				<col width="17%" /> 
				<col width="*" />
			</colgroup>
		<tbody> 
		 <tr>
          <th  scope="row">결재선 선택</th>
          <td  scope="row">
          <select name="APP_PATH" id="APP_PATH" onChange="goAppPathChange()">
              <option value="">-------결재선 선택-------</option>  
<%
if (_list == null || _list.size() == 0){ 
}else{
	for (int j=0; j<_list.size(); j++) {
		Map<String,String> rowData = _list.get(j);
%> 
<option value="<%=CommonUtil.nvl(rowData.get("APP_PATH"))%>"  <% if ("Y".equals(rowData.get("DEFAULT_FLAG"))) { %> selected <%} %>><%=CommonUtil.nvl(rowData.get("SUBJECT"))%></option> 
<% }
}%>
            </select>

            </td>
            <% if ( !"".equals(tot_price) ) { %>
            <td><b>총금액&nbsp;<%=CommonUtil.formatNumber(tot_price,true,0,3)%> 원
			<input type="hidden" name="nu_tot_price" value="<%=tot_price%>"></b>
			</td>
			<%} %>
		</tr> 
    	  <tr>
			<th scope="row">결재/참조자</th>
			<td scope="row" >
			<div id="kto" class="scrollArea" style="height:90px"></div>  
            </td>
		  </tr> 
    	</tbody>
    </table>      
	<table  class="board_write" summary="결재/참조자 대한 정보입력">
		<caption>결재/참조자</caption>
			<colgroup>
				<col width="17%" />
				<col width="20%" />
				<col width="17%" />
				<col width="20%" />				
				<col width="17%" />
				<col width="*" />
			</colgroup>
		<tbody> 
    	  <tr>
			<th scope="row">결재제목</th>
			<td scope="row"  colspan="5">&nbsp;<input type="text"   class="input_type_text"  name="DOCU_TITLE" id="DOCU_TITLE" style="width:600px" value="<%=st_title%>" onkeydown="if(event.keyCode == 13) JavaScript:nosubmit();"></input></td>
		  </tr> 
    	  <tr>
			<th scope="row">기안자</th>
			<td scope="row" >&nbsp;<%=usernm%></td>
			<th scope="row">기안일시</th>
			<td scope="row" >&nbsp;<%=curDate%></td>			
			<th scope="row">첨부파일</th>
			<td scope="row">&nbsp;
				<a href="javascript:attach_popup();"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			
			</td>
		  </tr> 		  
    	  <tr>
			<th scope="row">내용</th>
			<td scope="row"  colspan="5">
			<textarea name="DOCU_CONT"  id="DOCU_CONT" style="width:580px; height:120px" onkeyup="fnCheckInputByte(this, 1000);" onchange="fnCheckInputByte(this, 1000);" ><%=st_cont%></textarea></td>
		  </tr>    		  
    	</tbody>
    </table> 
    <!--버튼영역-->   
 <div class="btnArea" align="right">   
     <%if(p060000059==true&&userType.equals("U")){
     %>
	<%}else{ %>
 			<span class="btn_04 mr04"  title="결재지정/변경"><a href="javascript:approvalLine()">결재지정/변경</a></span>
	<%} %>
 		<span class="btn_04 mr04"  title="상신"><a href="javascript:approvalProcess('request')">결재상신</a></span>   <!-- 상신구현시 참조하여 구현 -->   
</div>     
    
    </div> 
</div>       
</form>  
</body>
<script type="text/javascript">

/**
 * FORM 을 넘기는 임시용
 * FORM 전체를 넘길는 submit 활용
 */
function approvalProcess(pMethod) {  	 

	var url = "";
	
	var cateappr_id = "<%=cateappr_id%>";
	var cateappr_name = "<%=cateappr_name%>";
	var to = document.forms.buyerCommonApprovalPop.to.value;
	var id_param = cateappr_id.split(",");
	var tmp_id_param = "";
	var name_param = cateappr_name.split(",");
	var doc_type = document.forms.buyerCommonApprovalPop.DOC_TYPE.value;
	var chk_to = to.split(",");
	//결재리스트에 카테고리결재담당자 포함하는지 체크
	for(j = 0; j < id_param.length; j++){
		tmp_id_param = id_param[j];
		if(to.indexOf(tmp_id_param) == -1){
			alert("결재선에 카테고리결재담당자 ["+name_param[j]+"("+id_param[j]+")"+"]를 필수로 지정해야 합니다.");
			return;
		}
	}

	
	var st_company = document.forms.buyerCommonApprovalPop.COMPANY.value;
	var st_process_flag = "N";
	var apprId = "<%=apprId%>";
	var st_userId = "<%=userId%>";
	if(st_company == "KRKORE0001"){
		if(apprId ==""){
			alert("해당팀 체크 할 결재자정보가 없습니다.");
			return;			
		}
		if(apprId == "NO_APPR"){
			st_process_flag  = "Y";
		}else{
			for(var z=0; z<chk_to.length; z++){
				//각부장 결재선 체크
				if(chk_to[z] ==apprId){
					st_process_flag = "Y";
				}else if(st_userId == "KEP2129068"){
					if(chk_to[z] == "KEP2119072"){
						st_process_flag = "Y";	
					}
				}
			}			
		}
	
		if(st_process_flag == "N"){
			//사업팀장 예외처리.
			if(st_userId != "KEP200027"){
					alert("품의 상신시 각 부서 팀장님 결재가 필요합니다.");
					return;				
			}
			
		}
	}
	
	if (pMethod == "approval"){
		
		$("#PASS_KN").val("1"); // 결재
		if (confirm("결재 진행하시겠습니까?")==false) return;
		/*
		if (kepIsEmpty("PASS_ADD")==true){
			alert("결재자의견 입력하세요.");
			$("#PASS_ADD").focus();
			return;
		} 			
		*/
		url = "<%=action_base%>Approval.do";
	}else if (pMethod == "reject"){
		if (confirm("반려 진행하시겠습니까?")==false) return;
		$("#PASS_KN").val("3"); 
		url =  "<%=action_base%>Approval.do";
	}else if (pMethod == "cancel"){
		if (confirm("취소 진행하시겠습니까?")==false) return;
		$("#PASS_KN").val("4"); 
		url = "<%=action_base%>Cancel.do";
	} else if (pMethod == "modify"){
		if (confirm("수정 진행하시겠습니까?")==false) return;
		$("#PASS_KN").val(""); 
		url = "/common/approval/updateContent.do";
	} else if (pMethod == "request"){
		if (kepIsEmpty("to")==true){
			alert("결재자/참조자 입력하세요."); 
			return;
		} 			
		if (kepIsEmpty("DOCU_TITLE")==true){
			alert("결재제목 입력하세요.");
			$("#DOCU_TITLE").focus();
			return;
		} 				
		//첨부파일 필수여부 체크
		var pass_attach_yn = "<%=pass_attach_yn%>";
		if(pass_attach_yn =="Y"){
			if($("#st_image_key").val() ==""){
				alert("첨부파일이 필수 결재건 입니다\n파일첨부 후 결재상신 바랍니다.");
				return;
			}
		}
		
		// 결재 또는 합의에 부서 또는 사용자가 필수 포함되어있는지 확인
		if(<%=p060000135%>){
			var doc_type = document.forms.buyerCommonApprovalPop.DOC_TYPE.value;
			if("<%=buyerappr_type%>" == "TYPE1"){ // 솔브레인 그룹사 (구매발주 시) 
				if(doc_type=="PX"){
					var buyerappr_id = "<%=buyerappr_id%>";
					var buyerappr_name = "<%=buyerappr_name%>";
					var id_param = buyerappr_id.split(",");
	
					var to = document.forms.buyerCommonApprovalPop.to.value;
					var cc = document.forms.buyerCommonApprovalPop.cc.value;
					var chk_to = to.split(",");
					var chk_cc = cc.split(",");
	
					var chk_flag = '0';
					for(j = 0; j < id_param.length; j++){
						if(to.indexOf(id_param[j]) >= 0 && cc.indexOf(id_param[j]) < 0){
							chk_flag= '1';
							break;
						}
					}
					
					if(chk_flag == '0'){
						alert("<%=_alertMsg%>");
						return;
					}
				}
			}
			
		}
		
		if (confirm("결재상신 진행하시겠습니까?")==false) return; 
		url = "<%=action_base%>Request.do";

	} 
	
	
	kepAjaxFormCall(url,"buyerCommonApprovalPop",pMethod); 
}

window.onbeforeunload = function() {
	var type = "<%=DOC_TYPE%>";
	if (type == "OE"){
			opener.location.reload();	
			self.close();
	}
}; 

function popClose(){
	var type = "<%=DOC_TYPE%>";
	if (type == "OE"){
		opener.location.reload();
		self.close();
	} else {
		self.close();
	}
}

function addEvent(elem, event, fn) {
    if (elem.addEventListener) {
        elem.addEventListener(event, fn, true);
    } else {
        elem.attachEvent("on" + event, fn);
    }
}

//a click, form submet window.onbeforeunload 호출 초기화
var notUseBeforeunloadObj = document.getElementsByTagName("a");
for(var i=0; i < notUseBeforeunloadObj.length; i++){
	
	   addEvent(notUseBeforeunloadObj[i], "click", function(){window.onbeforeunload = "";});
	   addEvent(notUseBeforeunloadObj[i], "keypress", function(){window.onbeforeunload = "";});
  }
	  
  notUseBeforeunloadObj = document.getElementsByTagName("form");
  for(var i=0; i < notUseBeforeunloadObj.length; i++){
   addEvent(notUseBeforeunloadObj[i], "submit", function(){window.onbeforeunload = "";});
   
  }


function setPopupApprovalReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4,tmptmp5) {
	//alert(tmptmp1);
	//alert(tmptmp2);
	//alert(tmptmp3);
	$("#to").val(tmptmp1); // 결재
	$("#cc").val(tmptmp2); // 참조
	$("#ag").val(tmptmp5); // 합의
	$("#kto").html(tmptmp3); // 내용
	
	$("#toContent").val(tmptmp4); // 내용
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){

	if (pMethod == "approval"){
		alert("결재가 성공적으로 이루어 졌습니다. ");		  
	}else if (pMethod == "reject"){
		alert("반려가 성공적으로 이루어 졌습니다. ");
	}else if (pMethod == "cancel"){
		alert("상신취소가 성공적으로 이루어 졌습니다. ");
	} else if (pMethod == "modify"){
		alert("수정이 성공적으로 이루어 졌습니다. ");
	} else if (pMethod == "request"){
		alert("결재상신이 성공적으로 이루어 졌습니다. ");
		var DOCU_NO = response.msg.DOCU_NO;
		opener.kepApprovalReturn("true",DOCU_NO);
	} 
	//opener.kepSearch("");
	self.close();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "approval"){
		alert("결재가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "return"){
		alert("반려가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "cancel"){
		alert("상신취소가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "modify"){
		alert("수정이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "request"){
		alert("결재상신이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} 
} 
</script>
</html>
