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
<%@ include file="../../common/include/head_pop.jspf"  %>

<script type="text/javascript">
var select_all_yn = "N"; // 전체선택_전체해제_flag

function kep_onload_view(){
	var tot_cnt = document.getElementById("count").value;
	var area_list = "<%=AREA_LIST%>";
	var str_area_list = area_list.split("__");
	var tot_area_list = str_area_list.length-1;
	var mod_yn = "<%=MOD_YN%>";
	
	// 파라미터 선택된 값 체크하기
	for(var i=0; i<tot_area_list; i++){
		for(var j=0; j<tot_cnt; j++){
			var st_area_code = document.getElementById("st_area_code"+j).value;

			if(str_area_list[i] == st_area_code){
				document.getElementById("st_area_code"+j).checked = true;
			}
		}
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
			select_all_yn = "Y"; // 전체선택 됨
		}
	}
}

function selectArea(){  
	var tmpArea = "";
	var form =  document.forms[0];
	var tot_cnt = form.count.value;
	var chk_cnt = 0;
	var plant_code = "<%=PLNAT_CODE%>";
	var plant_err_chk = "Y";
	var area_chk_flag = "<%=area_chk_flag%>";
	var buyer_area_chk = "<%=AREA_FLAG%>";
	
	if (tot_cnt == 1){
		var box = eval("document.forms.deliAreaPop.st_area_code0");
		if(box.checked == true){
			tmpArea = document.forms.deliAreaPop.st_area_code0.value+"__";
			chk_cnt++;
			
			if(plant_code == document.forms.deliAreaPop.st_area_code0.value){
				plant_err_chk = "N";
			}
		}
	}else{
		for(var i = 0; i < tot_cnt; i++){
			var box = eval("document.forms.deliAreaPop.st_area_code"+i);
			if(box.checked == true){
				tmpArea = tmpArea + document.getElementById("st_area_code"+i).value + "__";
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
				alert("해당 플랜트의 납품지역이 포함되어야 합니다.");
				return;	
			}				
		}		
	}
	setReturn(tmpArea, chk_cnt);
}

function selectAllArea(){  
	var tot_cnt = document.getElementById("count").value;
	
	if(select_all_yn == "Y"){
		for(var j=0; j<tot_cnt; j++){
			document.getElementById("st_area_code"+j).checked = false;
		}
		
		select_all_yn = "N";
	}else{
		for(var j=0; j<tot_cnt; j++){
			document.getElementById("st_area_code"+j).checked = true;
		}
		
		select_all_yn = "Y";
	}
}

function setReturn(value1,value2,value3,value4,value5){
  opener.setPopupReturn(value1,value2,value3,value4,value5);
  this.close();
}

</script>
</head>

<body onload="kep_onload_view();">
	 <form name="deliAreaPop" id="deliAreaPop" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deliAreaPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:100%; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">납품지역 리스트</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div  class="scrollArea" style="height:150px"> 
            	<!--grid-->
                <table style="width:100%">
                    <caption>검색 리스트</caption>
						<colgroup>
						    <col width="33%" /> 
						    <col width="33%" />
						    <col width="33%" /> 
						</colgroup>
                    <thead>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               			<tr bgcolor="#FFFFFF">
							<td colspan="3" align="center" height = "195">
							<span class="font1">조회된 데이타가 없습니다.</span>
            	            </td> 
        	            </tr>
<%}else{%>
						<tr>
<%
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>
							<td style="text-align:left;" height="30px"><input id="st_area_code<%=j%>" name="st_area_code<%=j%>" type="checkbox" value="<%=CommonUtil.nvl(rowData.get("CODE2"))%>" style="vertical-align:middle"> <%=CommonUtil.nvl(rowData.get("TEXT1"))%></td>
	<%if((j > 0) && ((j+1)%3 == 0)){%>
						</tr>
						<tr>
	<%}%>
<%}%>
						</tr>
					</tbody>

					<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>">
<%}%>
				</table>
			</div>
			
			<br>
			
			<div class="btnArea">
				<span class="fr">
<%
if (MOD_YN.equals("Y")){
%>
				<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
				<span class="btn_04"><a href="javascript:selectAllArea()">전체선택</a></span>
				<span class="btn_02"><a href="javascript:selectArea()">확인</a></span>
<%}%>
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
