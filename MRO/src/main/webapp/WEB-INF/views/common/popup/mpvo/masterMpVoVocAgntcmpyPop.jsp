<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 협력사
* 기능 : VOC 협력사 복수 선택 팝업
* 프로그램 ID : PG_90_C_900_20
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-23
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
%>

<script type="text/javascript">
// <!--

// 전체선택/해제
function checkAll(){
	var tot_cnt = $(".cont_t_list02 tbody tr").length;
	var check_status = document.forms[0].check_status.value;

    if(check_status == "선택"){
        for(var j = 1; j <= tot_cnt; j++){
            var box = eval("document.forms[0].checkbox" + j);
            var check_status = "해제";

            if(box.checked == false) box.checked = true;
			document.forms[0].check_status.value = check_status;
        }
    }else{
        for(var j = 1; j <= tot_cnt; j++){
            var box = eval("document.forms[0].checkbox" + j);
            var check_status = "선택";

            if(box.checked == true) box.checked = false;
            document.forms[0].check_status.value = check_status;
        }
    }
}

//체크박스 중 체크 표시가 된 수량을 리턴함
function getCheckedRowCount(){
    var cnt   = 0;
    var tot_cnt  = $(".cont_t_list02 tbody tr").length;

    if(eval(tot_cnt) == 0 ){
        cnt = 0;
    }else{
        if(eval(tot_cnt) < 2){
        var box = eval("document.forms[0].checkbox"+1);
            if(box.checked == true){
                cnt++;
            }
        }else{
            for(var k = 1; k <= tot_cnt; k++){
                var box = eval("document.forms[0].checkbox" + k);
                if(box.checked == true){
                    cnt++;
                }
            }
        }
    }
    return cnt;
}

function getMultiAgent() {

	var agent		= "";
	var agent_name	= "";
	var tot_cnt		= $(".cont_t_list02 tbody tr").length;
	var checked_count   = getCheckedRowCount();
	var initValue		= 1;

	if(checked_count<=0){
		alert(" 협력사를 선택하여 주십시요.   ");
		return;
	}

	if(eval(tot_cnt)<=1){
		var box = eval("document.forms[0].checkbox"+1);
		if(box.checked==true) {
			agent		= "('"+document.forms[0].st_sys_type.value+"', '"+document.forms[0].st_agent.value+"')";
			agent_name	= document.forms[0].st_agent_name.value;
		}
	}else{
		if(checked_count==1) {
			for(var j=1; j<=tot_cnt; j++) {
				var box = eval("document.forms[0].checkbox"+j);
				if(box.checked==true) {
					agent		= "('"+document.forms[0].st_sys_type[j-1].value+"', '"+document.forms[0].st_agent[j-1].value+"')";
					agent_name	= document.forms[0].st_agent_name[j-1].value;
				}
			}
		}else {
			for(var j=1; j<=tot_cnt; j++) {
				var box = eval("document.forms[0].checkbox"+j);
				if(box.checked==true) {
					if(initValue==1) {
						agent		+= "('"+document.forms[0].st_sys_type[j-1].value+"', '"+document.forms[0].st_agent[j-1].value+"')@";
						agent_name	= document.forms[0].st_agent_name[j-1].value+" 이외 "+(checked_count-1)+" 개 협력사";
					}
					if(initValue>1 && initValue<checked_count) {
						agent		+= "('"+document.forms[0].st_sys_type[j-1].value+"', '"+document.forms[0].st_agent[j-1].value+"')@";
					}
					if(initValue==checked_count) {
						agent		+= "('"+document.forms[0].st_sys_type[j-1].value+"', '"+document.forms[0].st_agent[j-1].value+"')";
					}
					initValue++;
				}
			
		}
		}
	}

	opener.setPopupReturn("", agent, agent_name);
	self.close();

}

function setReturn(sys_type, agent, agent_name){
	agent = "('"+sys_type+"', '"+agent+"')";
	opener.setPopupReturn("", agent, agent_name);
	this.close();
}
 //-->
</script> 
<body onload="">
<form name="masterMpVoVocCompanyPop" id="masterMpVoVocCompanyPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">VOC 협력사</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:378px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>VOC 협력사 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="25%" /> 
                        <col width="45%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" id="check_status" name="check_status" value="선택" onclick="javascript:checkAll();" /></th> 
                            <th scope="col">협력사코드</th>
                            <th scope="col">협력사명</th>
                            <th scope="col">VOC 발생건 수</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
							<input type="checkbox" id="checkbox" name="checkbox<%=j+1%>">
							<input type="hidden" id="st_agent<%=j+1%>" name="st_agent"		value="<%=_tmp.get("AGENT")%>">
							<input type="hidden" id="st_agent_name<%=j+1%>" name="st_agent_name"	value="<%=_tmp.get("AGENT_NAME")%>">
							<input type="hidden" id="st_sys_type<%=j+1%>" name="st_sys_type"		value="<%=_tmp.get("SYS_TYPE")%>">
						</td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("SYS_TYPE")%>','<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>')">
								<%=_tmp.get("AGENT")%>
							</a>
					   </td>
						<td class="left">
						  	<a href="javascript:setReturn('<%=_tmp.get("SYS_TYPE")%>','<%=_tmp.get("AGENT")%>','<%=_tmp.get("AGENT_NAME")%>')">
								<%=_tmp.get("AGENT_NAME")%>
							</a>
					   </td>
						<td><%=CommonUtil.nvl(_tmp.get("CNT"), "0")%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
        <div class="btnArea" style="margin-top: 10px;">
			<span class="fr">
				<span class="btn_02"><a href="javascript:getMultiAgent();" >확인</a></span>
			</span>                	
		</div>
    </div>        
</div>
</form> 
</body>
</html>
