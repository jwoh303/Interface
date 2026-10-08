<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String BUYER = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");
String AREA_LIST = CommonUtil.nvl((String) request.getParameter("st_area_list"),"");
String MOD_YN = CommonUtil.nvl((String) request.getParameter("mod_yn"),"N");
String PLNAT_CODE = CommonUtil.nvl((String) request.getParameter("plant_code"),"");
String AREA_FLAG  = CommonUtil.nvl((String) request.getParameter("st_area_chk_flag"),"Y");
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");


String area_chk_flag = "N"; // 고객사 플랜트의 납품지역 필수 입력 FLAG
boolean p04404107 = CommonUtil.getSpecialCheckReturn(BUYER,"P04-4041-07");
//SLOGIC-BEGIN(P04-4041-07)
if(p04404107 == true){
	area_chk_flag = "Y";
}
//SLOGIC-END
%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>

<script type="text/javascript">
var select_all_yn = "N"; // 전체선택_전체해제_flag

function kep_onload_view(){
	var tot_cnt = document.getElementById("count").value;
	var area_list = "<%=AREA_LIST%>";
	var str_area_list = area_list.split("__");
	var tot_area_list = str_area_list.length-1;
	var mod_yn = "<%=MOD_YN%>";
	
	var CheckCount = 0;
	// 파라미터 선택된 값 체크하기
	for(var i=0; i<tot_area_list; i++){
		for(var j=0; j<tot_cnt; j++){
			var st_area_code = document.getElementById("st_area_code"+j).value;

			if(str_area_list[i] == st_area_code){
				document.getElementById("st_area_code"+j).checked = true;
				CheckCount++;
			}
		}
	}
	
	if(tot_cnt == CheckCount){ //납품지역이 모두 체크되어 있으면 전체도 체크
		document.getElementById("checkedAll").checked = true;
	}
	
	// 총 납품지역 개수 = 선택한 납품지역 개수(모두 선택)
	if(tot_cnt == tot_area_list){
		select_all_yn = "Y"; // 전체선택 됨
	}
	
	// 파라미터에 따라 수정여부 제어
	if(mod_yn == "N"){
		for(var j=0; j<tot_cnt; j++){
			document.getElementById("st_area_code"+j).disabled = true;
		}
	}else{ // 수정여부 Y일 때 선택값이 하나도 없을 때는 default 모두 체크
		if(tot_area_list == 0){
			for(var j=0; j<tot_cnt; j++){
				document.getElementById("st_area_code"+j).checked = true;
			}
			document.getElementById("checkedAll").checked = true;
			select_all_yn = "Y"; // 전체선택 됨
		}
	}
}

function selectArea(){  
	var tmpArea = "";
	var tmpAreaText = "";
	var form =  document.forms["deliAreaPop"];
	var tot_cnt = form.count.value;
	var chk_cnt = 0;
	var plant_code = "<%=PLNAT_CODE%>";
	var plant_err_chk = "Y";
	var area_chk_flag = "<%=area_chk_flag%>";
	var buyer_area_chk = "<%=AREA_FLAG%>";
	
	if (tot_cnt == 1){
		var box = eval("document.forms['deliAreaPop'].st_area_code0");
		if(box.checked == true){
			tmpArea = document.forms["deliAreaPop"].st_area_code0.value+"__";
			tmpAreaText = document.forms["deliAreaPop"].st_area_text0.innerText+",";
			chk_cnt++;
			
			if(plant_code == document.forms["deliAreaPop"].st_area_code0.value){
				plant_err_chk = "N";
			}
		}
	}else{
		for(var i = 0; i < tot_cnt; i++){
			var box = eval("document.forms['deliAreaPop'].st_area_code"+i);
			if(box.checked == true){
				tmpArea = tmpArea + document.getElementById("st_area_code"+i).value + "__";
				tmpAreaText = tmpAreaText + document.getElementById("st_area_text"+i).innerText + ",";
				chk_cnt++;
				
				if(plant_code == document.getElementById("st_area_code"+i).value){
					plant_err_chk = "N";
				}
			}
		}
	}
	//plant_code가 없을경우 체크하지 않음.
	if(plant_code != ""){
		//고객납품지역 체크 대상만 반영. 
		if(buyer_area_chk =="Y"){
			if(area_chk_flag == "Y" && plant_err_chk == "Y"){
// 				alert("해당 플랜트의 납품지역이 포함되어야 합니다.");
				var text = "해당 플랜트의 납품지역이 포함되어야 합니다.";
				var but1text = "확인";
				var but1func = "javascript:closePopText2(); return false;";
				var but1width = "120px";
				openLayerPopText2(text,but1text,but1func,but1width);

				return;	
			}				
		}		
	}
	tmpAreaText = tmpAreaText.slice(0,-1);
	setReturn(tmpArea,tmpAreaText, chk_cnt);
}

function selectAllArea(){  
	var tot_cnt = document.getElementById("count").value;
	
	if(select_all_yn == "Y"){
		for(var j=0; j<tot_cnt; j++){
			document.getElementById("st_area_code"+j).checked = false;
			document.getElementById("checkedAll").checked = false;
		}
		
		select_all_yn = "N";
	}else{
		for(var j=0; j<tot_cnt; j++){
			document.getElementById("st_area_code"+j).checked = true;
			document.getElementById("checkedAll").checked = true;
		}
		
		select_all_yn = "Y";
	}
}

function setReturn(value1,value2,value3,value4,value5){
//   opener.setPopupReturn(value1,value2,value3,value4,value5);
	parent.setPopupReturn(value1,value2,value3,value4,value5);
  	parent.closePop();
}

</script>
</head>

<body onload="kep_onload_view();">
	 <form name="deliAreaPop" id="deliAreaPop" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deliAreaPop"> 
	 
	 <div class="wrapPopup">
  <div class="PopupTit">납품가능지역<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h10"></div>
  <div class="Popup_DeliveryAreaBOX" >
    <div class="Popup_DeliveryAreaAll"><label class="CheckLargeLabel">
    <%if(viewType.equals("R")) {%>
    <input type="checkbox" id="checkedAll" name="checkedAll" onclick="return false;">
    <%}else{ %>
    <input type="checkbox" id="checkedAll" name="checkedAll" onclick="javascript:selectAllArea();">
    <%} %>
    <span class="CheckLargeCustom"></span> 전체</label></div>
    <div class="Popup_DeliveryArea">
    <ul>
<%    for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>
<%if(viewType.equals("R")) {%>
	<li><label class="CheckLargeLabel" id="st_area_text<%=j%>"><input type="checkbox" id="st_area_code<%=j%>" name="st_area_code" value="<%=CommonUtil.nvl(rowData.get("CODE2"))%>" onclick="return false;"><span class="CheckLargeCustom"></span> <%=CommonUtil.nvl(rowData.get("TEXT1"))%></label></li>
<%}else{ %>
	<li><label class="CheckLargeLabel" id="st_area_text<%=j%>"><input type="checkbox" id="st_area_code<%=j%>" name="st_area_code" value="<%=CommonUtil.nvl(rowData.get("CODE2"))%>"><span class="CheckLargeCustom"></span> <%=CommonUtil.nvl(rowData.get("TEXT1"))%></label></li>
<%} %>
	<%if((j > 0) && ((j+1)%3 == 0)){%>
						</ul>
						<ul>
	<%}%>
<%}%>
	</ul>
    </div>
    <input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">
  </div>
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style=" width:400px;">
  <%if(!viewType.equals("R")) {%>
    <button class="ButPrimary_large" onclick="javascript:selectArea(); return false;">확인</button>
    <%} %>
  </div>  
</div>
</form> 
</body>
</html>
