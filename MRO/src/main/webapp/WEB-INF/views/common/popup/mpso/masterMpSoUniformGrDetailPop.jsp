<%--
**********************************************
* 메뉴 : 유니폼 진행관리 > 유니폼 생산입고수량 팝업
* 화면 : 유니폼 생산입고수량 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2020-04-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList_hd = (List<Map<String,String>>) request.getAttribute("data_hd"); // 조회된결과
List<Map<String,String>> _dataList_dt = (List<Map<String,String>>) request.getAttribute("data_dt"); // 조회된결과
String business_cond = _sessionInfo.getBusinessCond();
String buyer = CommonUtil.nvl((String) request.getParameter("buyer"), "");
String st_no = CommonUtil.nvl((String) request.getParameter("st_no"), "");
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"), "");
String st_dataList_dt_chk = "";
Map<String,String> rowData_hd = null;

if (_dataList_hd == null || _dataList_hd.size() == 0){	 
}else{	
	rowData_hd = _dataList_hd.get(0); 
}

if (_dataList_dt == null || _dataList_dt.size() == 0){
	st_dataList_dt_chk = "N";
}else{
	st_dataList_dt_chk = "Y";
}
%>

<script type="text/javascript">
function kep_onload(){
<%if("S".equals(business_cond)){%>
	<%if("Y".equals(st_dataList_dt_chk)){%>
		addRow();
	<%}%>
<%}%>
}

function setQuery(){
  $('#uniformGrPop').attr("action", "/mpso/getMasterMpSoUniformGrDetailPop.do").submit();
}

function setReturn(value1,value2,value3){ 
}

function Reg(){
	if(!checkCdQty())
		return;
	
	if(!confirm('입고수량을 등록하시겠습니까?'))
		return;
	
	kepAjaxFormCall("/mpso/saveMasterMpSoUniformGrDetailPop.do","uniformGrPop","save");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;
	
    if(sMsg == "UPDATE_OK"){
		if(pMethod == "save"){
			alert("정상적으로 등록되었습니다.");

			// 처리후 재조회
			opener.doAction('search');
			this.close();
       }
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response){
	if(pMethod == "save"){
		alert("등록 실패하였습니다. \n\n확인 후 다시 시도해 주시기 바랍니다.");
	}
}

function checkCdQty(){
    
    var item_qty = $("#item_qty").val();
    var gr_tot_qty = $("#gr_tot_qty").val();
    var gr_qty = $("#gr_qty").val();
    
    if(!gr_qty){
    	gr_qty = "0";
    }

    var posb_gr_qty = item_qty - gr_tot_qty;
    
    if( !isEmpty(gr_qty) && (!kepIsNumDash("gr_qty") || gr_qty == "0")){
    	alert("입고수량에 입력해 주십시요");
    	
    	$("#gr_qty").val("");
    	$("#gr_qty").focus();
    	
    	return false;
    }
    
    if(gr_qty > posb_gr_qty){
    	alert("입고수량은 생산요청수량을 초과할 수 없습니다.");
    	
    	$("#gr_qty").val("");
    	$("#gr_qty").focus();
    	
    	return false;
    }
    
    return true;
}

function addRow(){
	
	var trCnt = $("#tblData").children("tr").length;
	var seq = trCnt+1;
	
	var rowData	 = "<tr>";
	rowData		+= "	<td>"+seq+"</td>";
	rowData		+= "	<td></td>";
	rowData		+= "	<td>";
	rowData		+= "		<input type='text' name='gr_qty' id='gr_qty' class='input_type_text' value='' style='text-align:right;'>";
	rowData 	+= "	</td>";
	rowData 	+= "</tr>";
	
	$("#tblData").append(rowData);
}

</script>

<body onload="kep_onload();">
	 <form name="uniformGrPop" id="uniformGrPop" method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="uniformGrPop">
	 <input type="hidden" name="buyer" id="buyer"  value="<%=buyer%>">
	 <input type="hidden" name="st_no" id="st_no"  value="<%=st_no%>">
	 <input type="hidden" name="st_seq" id="st_seq"  value="<%=st_seq%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">유니폼 생산입고수량 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>유니폼 생산입고수량 조회</caption>
						<colgroup>
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
							<col width="25%" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE12") %> : <!-- 품목코드 --></td>
							<td><input type="hidden" name="buyer_item_no" id="buyer_item_no" class="input_type_text" value="<%=CommonUtil.nvl(rowData_hd.get("BUYER_ITEM_NO"))%>"/>
								<%=CommonUtil.nvl(rowData_hd.get("BUYER_ITEM_NO"))%>
							</td>
							
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>생산요청수량 : </td>	
							<td><input type="hidden" name="item_qty" id="item_qty" class="input_type_text" value="<%=CommonUtil.nvl(rowData_hd.get("ITEM_QTY"))%>"/>
								<%=CommonUtil.nvl(rowData_hd.get("ITEM_QTY"))%>
							</td>
                            
                            <td>생산입고수량 : </td>	
							<td><input type="hidden" name="gr_tot_qty" id="gr_tot_qty" class="input_type_text" value="<%=CommonUtil.nvl(rowData_hd.get("GR_QTY"))%>"/>
								<%=CommonUtil.nvl(rowData_hd.get("GR_QTY"))%>
							</td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:200px">
                <table id="table_list" class="cont_t_list02" style="width:100%">
                    <caption>유니폼 생산입고수량 조회</caption>
                    <colgroup>
                        <col width="14%" />
                        <col width="43%" />
                        <col width="43%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순번</th> 
                            <th scope="col">입고일</th> 
                            <th scope="col">입고수량</th>
                        </tr>
                    </thead>
                    <tbody id="tblData">
<%
if (_dataList_dt == null || _dataList_dt.size() == 0){
%>
	<%if(!"S".equals(business_cond) ){%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height="150px">
                        	<span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td>
                    </tr>
	<%}else{%>
					<tr>
						<td>1</td>
						<td></td>
						<td>
							<input type="text" name="gr_qty" id="gr_qty" class="input_type_text" value="" style="text-align:right;"/>
						</td>
					</tr>
	<%}%>           
<%}else{
for (int j=0; j<_dataList_dt.size(); j++) {
	Map<String,String> rowData = _dataList_dt.get(j);
%> 
					<tr>
						<td>
						 	<%=rowData.get("REVISION")%>
						</td>
						<td class="center">
							<%=rowData.get("GR_DATE")%>
						</td>
						<td class="right">
							<%=rowData.get("GR_QTY")%>
						</td>
					</tr>
	<%}%>
<%}%>
                    </tbody>
                </table>                  
        </div>
<%if("S".equals(business_cond) ){%>        
        <div class="btnArea">
			<span class="fr">
				<span class="btn_02 mr04 mb20"><a href="javascript:Reg()" >등록</a></span>
			</span>                	
		</div>
<%}%>		
    </div>        
</div>
</form> 
</body>
</html>
