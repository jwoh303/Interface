<%--
**********************************************
* 메뉴 : 
* 화면 : 배송차량조회
* 기능 : 배송차량정보를 확인하고 선택할 수 있는 팝업(협력사에서)
* 프로그램 ID : 
* 담당자 :  ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	int page_display_cnt = 0;
%>

<script type="text/javascript">

function doAction(str) {
	switch (str) {
	case "save":	 // 저장
		checkForm();
		break;
	}
}

function checkForm(){
	var frm = document.commonMpIvDlvryCarPop;
	var disp_cnt = frm.display_item_cnt.value;

	var row = "-1";
	var car_query ="";

	var c_code = "";
	var c_car_number = "";
	var c_user_name = "";
	var c_phone_num = "";

	if(disp_cnt==1){ 
		if(isEmpty(frm.car_number.value)){
			alert("차량번호를 반드시 입력하세요.");
			frm.car_number.focus();
			return ;
		}
		
		if(isEmpty(frm.user_name.value)){
			alert("담당자를 반드시 입력하세요.");
			frm.user_name.focus();
			return;
		}
		
		if(isEmpty(frm.phone_num.value)){
			alert("전화번호를 반드시 입력하세요.");
			frm.phone_num.focus();
			return;
		}
		
		c_code = frm.st_code.value;
		c_car_number = frm.car_number.value;
		c_user_name = frm.user_name.value;
		c_phone_num = frm.phone_num.value;
		
	}else if(disp_cnt > 1){
		for(var i =0; i<disp_cnt; i++){
			var checkRow = eval("frm.st_check_row["+i+"]");
			if(checkRow.checked){
				row = checkRow.value;
			} 
		}
		
		if(row == "-1"){
			alert("선택된 항목이 없습니다.");
			return ;
		}
		
		if(isEmpty(frm.car_number[row].value)){
			alert("차량번호를 반드시 입력하세요.");
			frm.car_number[row].focus();
			return ;
		}
		
		
		if(isEmpty(frm.user_name[row].value)){
			alert("담당자를 반드시 입력하세요.");
			frm.user_name[row].focus();
			return;
		}
		
		if(isEmpty(frm.phone_num[row].value)){
			alert("전화번호를 반드시 입력하세요.");
			frm.phone_num[row].focus();
			return;
		}
		
		c_code = frm.st_code[row].value;
		c_car_number = frm.car_number[row].value;
		c_user_name =  frm.user_name[row].value;
		c_phone_num = frm.phone_num[row].value;
	}

	if(!confirm("저장 하시겠습니까?")){
		return;
	}

	frm.st_car_code.value = c_code;
	frm.st_car_number.value = c_car_number;
	frm.st_user_name.value = c_user_name;
	frm.st_phone_num.value = c_phone_num;
	
	car_query = c_code+"@@"+c_car_number+"@@"+c_user_name+"@@"+c_phone_num+"@@";

	frm.st_car_info.value = car_query;
	
	// 배송차량 팝업에서 차량번호, 담당자, 전화번호 수정하고 저장 시 해당데이터 UPDATE
	kepAjaxFormCall("/mpiv/saveCommonMpIvDlvryCarPop.do","commonMpIvDlvryCarPop","btnSave");
	
	
	/*
	frm.target = "work";
	frm.action = "/kr/buyer/admin/admin_code_delivery_car_modify_reg.jsp";
	frm.method = "post";
	frm.submit();
	*/
	
	//setReturn();
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	var msg = response.Message;
	
	if(pMethod == "btnSave"){
		if(kepIsValueNull(msg)){
			setReturn();	
		} else {
			alert(msg);
			return;
		}
		
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}


//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}


function setReturn() {
	opener.setCarInfo($("#st_car_info").val());
	window.close();
}

</script>
</head>
 
<body>
<form name="commonMpIvDlvryCarPop" id="commonMpIvDlvryCarPop" method="post" >

	<input type="hidden" name="st_flag"   value="update">
	<input type="hidden" name="st_type"   value="CA01">
	<input type="hidden" name="st_com_code"   value="${sessionInfo.comCode}">
    <input type="hidden" name="st_car_code"   value="">
    <input type="hidden" name="st_car_number"   value="">
    <input type="hidden" name="st_user_name"   value="">
    <input type="hidden" name="st_phone_num"   value="">
    <input type="hidden" id="st_car_info" name="st_car_info"   value="">
    
    
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:394px;">
    	<div id="popHeader">
        	<h1 class="title">배송차량 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<br>     
           	<!--grid-->
            <div class="scrollArea" style="height:258px;">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>배송차량 조회 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="15%" />
                        <col width="30%" />
                        <col width="20%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">선택</th> 
                            <th scope="col">코드</th> 
                            <th scope="col">차량번호</th>
                            <th scope="col">담당자</th>
                            <th scope="col">전화번호</th> 
                        </tr>
                    </thead>
                    <tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="5" align="center" height = "50">
	                        	<span class="font1">조회된 데이타가 없습니다.</span>
	                        </td> 
	                    </tr>
				<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							page_display_cnt++;
							Map<String,String> _tmp = _dataList.get(j);
				%> 
						<tr>
	                        <td>
								<input type="radio" name="st_check_row" value = "<%=j%>">
							</td> 
							<td>
								<%=CommonUtil.nvl(_tmp.get("CODE"))%>
								<input type="hidden" name="st_code" value="<%=CommonUtil.nvl(_tmp.get("CODE"))%>">
							</td>
							<td>
								<input type="text" name="car_number" size="18" value="<%=CommonUtil.nvl(_tmp.get("CAR_NUMBER"))%>" class="input_type_text">
							</td>
							<td>
								<input type="text" name="user_name" size="14" value="<%=CommonUtil.nvl(_tmp.get("USER_NAME"))%>" class="input_type_text">
							</td>
							<td>
								<input type="text" name="phone_num" size="18" value="<%=CommonUtil.nvl(_tmp.get("PHONE_NUM"))%>" class="input_type_text">
							</td>
	                    </tr>
				<% 	
						}
					}
				%>
                    </tbody>
                </table>                  
				<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">            
        </div>
        <br>
        <div id="searchBtnA02">
			<span class=btn_04><a href="javascript:doAction('save');">저장</a></span>  
		</div>   
	</div>        
</div>
</form> 
</body>
</html>
