<%--
**********************************************
* 메뉴 : 
* 화면 : 운영사 > 영업관리 > 소재지 검색
* 기능 : 소재지 검색
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
<%@ include file="../../../common/include/head_pop.jspf"  %> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String irs_no =  CommonUtil.nvl((String) request.getParameter("irs_no"));
String user_id =  CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());

%>

<body>
	 <form name=companyAddressPop id=companyAddressPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="companyAddressPop">
	 <input type="hidden" name="irs_no" id="irs_no"  value="<%=irs_no%>">
	 <input type="hidden" name="code1" id="code1"  value="">
 	 <input type="hidden" name="text1" id="text1"  value="">
	 <input type="hidden" name="check_cnt" id="check_cnt"  value="">
	 <input type="hidden" name="st_user_id" id="st_user_id"  value="<%=user_id%>">
	 <input type="hidden" name="st_code2" id="st_code2"  value="">
	 <input type="hidden" name="st_add_text" id="st_add_text"  value="">		 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">소재지</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
                
                     
           	 <!--grid-->
           	 <div class="scrollArea" style="height:320px;">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>소재지</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="20%" />  
                        <col width="*" />  
                        <col width="10%" />  
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col"></th>
                        	<th>소재지</th>
                            <th scope="col">주소</th>
                            <th scope="col">검색</th>  
                        </tr>
                    </thead>
                    <tbody>
					<input type="hidden" name="address_cnt" id="address_cnt" value="<%=_dataList.size() %>" />
<%

for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
                        <input type="hidden" name="st_code1" id="st_code1" value="<%=rowData.get("CODE1")%>"/>
                        <input type="hidden" name="st_text1" id="st_text1" value="<%=rowData.get("TEXT1")%>"/>                        
	                        <td><input type="checkbox" class="input_noline" name="InCheck" id="InCheck" style="cursor: pointer; margin: 5px;" /></td><td><%=rowData.get("CODE2")%></td>
							<td id="st_text1_idx<%=j%>"><%=rowData.get("TEXT1")%></td>
							<td><a href="javascript:doPop('company_address', '<%=j%>');"><img src="/resources/images/btn_search03.gif"></a></td>
						</tr> 
<% } %> 
                             
                    </tbody>
                </table>                
             </div>
             <br>
             <div>
             	<span class="btn_02 mr04" style="float: right; padding-right: 5px;"><a href="javascript:doAction('save')">저장</a></span>
	             <span class="btn_02 mr04" style="float: right;"><a href="javascript:doAction('del')">삭제</a></span>
	         </div>
	         <br>
             <div style="margin-top: 5%;">
             		<table  class="cont_t_list02"  style="width:100%">
                    <caption>소재지</caption>
                    <colgroup>
                        <col width="25%" /> 
                        <col width="*%" />  
                        <col width="10%" />  
                        <col width="15%" />  
                    </colgroup>
                    <thead>
                        <tr>                        	
                        	<th>소재지</th>
                            <th scope="col">주소 검색</th>
                            <th scope="col"></th>
                            <th scope="col"></th>  
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
	                        <td><input type="text" id="st_code" Placeholder='소재지' style="height: 18px; width: 80%;" /></td>
	                        <td><input type="text" id="st_text" style="height: 18px;  margin-left: 5%; width: 100%;" /></td>
							<td><a href="javascript:doPop('company_address', 'add');"><img src="/resources/images/btn_search03.gif"></a></td>
							<td><span class="btn_02 mr04" style="margin-left: 15px;"><a href="javascript:doAction('add')">추가</a></span></td>
						</tr>                              
                    </tbody>
                </table> 
             	        
	             	 	
			</div>               
    </div>
    		
       		        
</div>
</form> 
</body>


<script type="text/javascript">
var btnEvent = "";
var idx = "";


//팝업함수호출
function doPop(str, row) {
	popupSel = str;
	idx = row;
	switch (str) {	 	
		case "company_address": //우편번호 검색			
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481");
			break;		
	}
}

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	var zipCode = zipNo.replace(/[^0-9]/gi, ''); // 우편번호	
	var address = roadAddrPart1 + " " + roadAddrPart2;
	var addressDt = addrDetail;
	
	if(idx == "add") {
		document.forms.companyAddressPop.st_text.value = address + addressDt;	
	} else {		
		document.forms.companyAddressPop.st_text1[idx].value = address + addressDt;
		document.getElementById('st_text1_idx'+idx).innerText = address + addressDt;			
	}	
}

//기능함수
function doAction(str) {
	btnEvent = str;
	st = new Date();
	switch (str) {
	case "save":
		save_Addr();
		break;
	case "del":
		delrows();
		break;
	case "add":
		add_Addr();
		break;	
	}
}

//각 해당 ROW 삭제
function delrows(){
	var tot_cnt  = $("#address_cnt").val();
    var checked_count       = 0;
    var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
    var st_code1 = [];
    
    if(tot_cnt==1) {
        if(document.forms.companyAddressPop.InCheck.checked==true) checked_count = 1;
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.companyAddressPop.InCheck[j].checked==true) { 
                checked_count++;
            }
        }
    }
    if(checked_count==0) {
    	alert("삭제할 대상을 선택해주세요.");        
        return;
    }    
	if(tot_cnt <= 1) {
		if(eval("document.forms.companyAddressPop.InCheck").checked==true) {
			st_code1.push(document.forms.companyAddressPop.st_code1.value);
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.companyAddressPop.InCheck[i].checked==true) {
				st_code1.push(document.forms.companyAddressPop.st_code1[i].value);
			}
		}
	}
	document.forms.companyAddressPop.code1.value  = st_code1;
	document.forms.companyAddressPop.check_cnt.value  = checked_count;
	
	if(confirm("삭제 하시겠습니까?")) {
		kepAjaxFormCall("/mdcd/delCompanyAddressPop.do","companyAddressPop",btnEvent);	
	}
		
}

// 전체 저장
function save_Addr(){
	var tot_cnt  = $("#address_cnt").val();
    
    var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
    var st_code1 = [];
    var st_text1 = [];
    
   
	if(tot_cnt <= 1) {
		st_code1.push(document.forms.companyAddressPop.st_code1.value);
		st_text1.push(document.forms.companyAddressPop.st_text1.value);
		
	} else {
		for(var i =0; i < tot_cnt; i++) {
			st_code1.push(document.forms.companyAddressPop.st_code1[i].value);
			if(i == (tot_cnt -1)) {
				st_text1.push(document.forms.companyAddressPop.st_text1[i].value);
			} else {
				st_text1.push(document.forms.companyAddressPop.st_text1[i].value + '@@');
			}						
		}
	}
	document.forms.companyAddressPop.code1.value  = st_code1;
	document.forms.companyAddressPop.text1.value  = st_text1;	
	
	if(confirm("저장 하시겠습니까?")) {
		kepAjaxFormCall("/mdcd/saveCompanyAddressPop.do","companyAddressPop",btnEvent);	
	}
		
}

// 소재지 추가
function add_Addr(){
	var tot_cnt  = $("#address_cnt").val();
	var add_code = document.forms.companyAddressPop.st_code.value;
	var add_text = document.forms.companyAddressPop.st_text.value;
	
	if(add_code == '' || add_code == null) {
		alert('추가할 소재지명 입력 바랍니다.')
		return;
	}
	
	if(add_text == '' || add_text == null) {
		alert('추가할 소재지의 주소 입력 바랍니다.')
		return;
	}
	
	document.forms.companyAddressPop.st_code2.value  = add_code;
	document.forms.companyAddressPop.st_add_text.value  = add_text;
	
	if(confirm("추가 하시겠습니까?")) {
		kepAjaxFormCall("/mdcd/addCompanyAddressPop.do","companyAddressPop",btnEvent);	
	}
		
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (pMethod == "del"){
		alert(msg);
		reload();		
	}
	if (pMethod == "save"){
		alert(msg);
		reload();		
	}
	if (pMethod == "add"){
		alert(msg);
		reload();		
	}
};
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다. 관리자에게 문의바랍니다.");
	
}; 

/**
 * FORM 을 초기화
 */
function reload(){
	location.reload();   
}


</script> 

</html>
