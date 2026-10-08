<%--
**********************************************
* 메뉴 : 주문관리>장바구니 업로드
* 화면 : 장바구니 업로드
* 기능 : 기작성된 엑셀파일을 이용하여 장바구니에 일괄 업로드 하기 위한 화면
* 프로그램 ID : PG_06_B_013_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.    
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String com_code = sessionInfo.getComCode();
    String user_id  =  sessionInfo.getUserId();
	String dept_code  = sessionInfo.getDepartment();	
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000072");
	
	//SLOGIC-BEGIN(P06-0000080) - TYPE1: 수량/길이 이용 고객사(윈체), TYPE2: 예산/계정 이용 고객사(대덕전자) 
	String p060000080 =  CommonUtil.getSpecialCheckReturn(com_code,"P06-0000080","COL01_DATA");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
	
%> 
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE179") %><!-- 장바구니 업로드 --></h3> 
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="1" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_dept" value="<%=dept_code%>">
		<input type="hidden" id="st_cart_type"  name="st_cart_type" value="<%=p060000080%>">
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="st_query" id="st_query" value="" />
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
	  	<input type="hidden" id="st_cart_type"  name="st_cart_type" value="<%=p060000080%>">
	  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
			<%if(p060000080.equals("TYPE1")){%>
		        <col width="20px" />
		        <col width="20px" />
				<col width="120px" />
				<col width="80px" />
				<col width="100px" />
				<col width="140px" />
				<col width="80px" />
				<col width="40px" />
				<col width="40px" />
				<col width="40px" />
				<col width="120px" />
			<%}else if(p060000080.equals("TYPE2")){%>
				<col width="4%" />
		        <col width="4%" />
				<col width="12%" />
				<col width="12%" />
				<col width="15%" />
				<col width="6%" />
				<col width="14%" />
				<col width="14%" />
				<col width="*" />
			<%}else{%>
				<col width="30px" />
		        <col width="30px" />
				<col width="110px" />
				<col width="100px" />
				<col width="180px" />
				<col width="100px" />
				<col width="60px" />
				<col width="190px" />
			<%}%>
	        </colgroup>
	        <thead>
			<tr>     
				 <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>  
				 <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');">
                <%} %>
                 </th>
				<th scope="col"><%=CommonLang.get("HTITLE180") %><!-- No --></th>
			<%if(p060000080.equals("TYPE1")){%>
				<th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE639") %><!-- 길이 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE45") %><!-- 수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE640") %><!-- 총수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			<%}else if(p060000080.equals("TYPE2")){%>
				<th scope="col"><%=CommonLang.get("HTITLE179") %><!-- 자재그룹 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE45") %><!-- 수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE419") %><!-- 예산부서 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE428") %><!-- 계정 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			<%}else{%>
				<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE45") %><!-- 수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			<%}%>
			</tr>
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
			<%if(p060000080.equals("TYPE1")){%>
				<td colspan="11" align="center" height = "50"> 
			<%}else if(p060000080.equals("TYPE2")){%>
				<td colspan="9" align="center" height = "50">
			<%}else{%>
				<td colspan="8" align="center" height = "50"> 
			<%}%>
				<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
				</td> 
			</tr>
<%
}else{
	for (int j=0; j<_gridList.size(); j++) {
		Map<String,String> rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td align="center"><input type="checkbox"  name="lnCheck<%=j%>" ></td>
					<td><%=(j+1)%></td><!-- No -->
				<%if(p060000080.equals("TYPE1")){%>
					<td class="left"><%=rowData.get("REF_NO")%></td><!-- 관리번호 -->
					<td class="left"><%=rowData.get("BUYER_ITEM_NO")%></td><!-- 품목코드 -->
					<td class="left"><%=rowData.get("DESCRIPTION_LOC")%></td><!-- 품목명 -->
					<td class="left"><%=rowData.get("SPECIFICATION")%></td><!-- 규격 -->
					<td class="left"><%=rowData.get("AGENT_NAME")%></td><!-- 협력사 -->
					<td class="data.right"  align="right"><%=rowData.get("SIZE_LEN")%>&nbsp;</td><!-- 길이 -->
					<td class="data.right"  align="right"><%=rowData.get("SIZE_QTY")%>&nbsp;</td><!-- 수량 -->
					<td class="data.right"  align="right"><%=rowData.get("CART_QTY")%>&nbsp;</td><!-- 총수량 -->
					<td class="left">&nbsp;<%=rowData.get("REMARK")%></td><!--비고-->
					<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_NO")%>">
					<input type="hidden" name="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
					<input type="hidden" name="st_contract_no" value="<%=rowData.get("CONTRACT_NO")%>">
					<input type="hidden" name="st_contract_seq" value="<%=rowData.get("CONTRACT_SEQ")%>">
					<input type="hidden" name="st_use_flag" value="<%=rowData.get("USE_FLAG")%>">
					<input type="hidden" name="st_seq" value="<%=rowData.get("SEQ")%>">
					<input type="hidden" name="st_remark" value="<%=rowData.get("REMARK")%>">
					<input type="hidden" name="st_size_qty" value="<%=rowData.get("SIZE_QTY")%>">
					<input type="hidden" name="st_size_len" value="<%=rowData.get("SIZE_LEN")%>">
					<input type="hidden" name="st_urct_yn" value="<%=rowData.get("URCT_YN")%>">
					<input type="hidden" name="st_bict_yn" value="<%=rowData.get("BICT_YN")%>">
					<input type="hidden" name="st_ref_pr_no_chk" value="<%=rowData.get("REF_PR_NO_CHK")%>">
				<%}else if(p060000080.equals("TYPE2")){%>
					<td class="left">
					<%if(!("").equals(rowData.get("REF_NO"))){%>
						<%=rowData.get("REF_NO")%> / <%=rowData.get("REF_NO_NAME")%>
					<%}%>
					</td><!-- 자재그룹 -->
					<td class="left"><%=rowData.get("BUYER_ITEM_NO")%></td><!-- 품목코드 -->
					<td class="left"><%=rowData.get("DESCRIPTION_LOC")%></td><!-- 품목명 -->
					<td class="data.right"  align="right"><%=rowData.get("CART_QTY")%>&nbsp;</td><!-- 수량 -->
					<td class="left">
					<%if(!("").equals(rowData.get("BUDGET_DEPT"))){%>
						<%=rowData.get("BUDGET_DEPT")%> / <%=rowData.get("BUDGET_DEPT_NAME")%>
					<%}%>
					</td><!-- 예산부서 -->
					<td class="left">
					<%if(!("").equals(rowData.get("ACCOUNT_TYPE"))){%>
						<%=rowData.get("ACCOUNT_TYPE")%> / <%=rowData.get("ACCOUNT_TYPE_NAME")%>
					<%}%>
					</td><!-- 계정 -->
					<td class="left">&nbsp;<%=rowData.get("REMARK")%></td><!--비고-->
					<input type="hidden" name="st_ref_pr_no" value="<%=rowData.get("REF_NO")%>">
					<input type="hidden" name="st_ref_pr_no_name" value="<%=rowData.get("REF_NO_NAME")%>">
					<input type="hidden" name="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
					<input type="hidden" name="st_contract_no" value="<%=rowData.get("CONTRACT_NO")%>">
					<input type="hidden" name="st_contract_seq" value="<%=rowData.get("CONTRACT_SEQ")%>">
					<input type="hidden" name="st_use_flag" value="<%=rowData.get("USE_FLAG")%>">
					<input type="hidden" name="st_seq" value="<%=rowData.get("SEQ")%>">
					<input type="hidden" name="st_budget_dept" value="<%=rowData.get("BUDGET_DEPT")%>">
					<input type="hidden" name="st_budget_dept_name" value="<%=rowData.get("BUDGET_DEPT_NAME")%>">
					<input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
					<input type="hidden" name="st_account_type_name" value="<%=rowData.get("ACCOUNT_TYPE_NAME")%>">
					<input type="hidden" name="st_remark" value="<%=rowData.get("REMARK")%>">
				<%}else{%>
					<td class="left"><%=rowData.get("BUYER_ITEM_NO")%></td><!-- 품목코드 -->
					<td class="left"><%=rowData.get("DESCRIPTION_LOC")%></td><!-- 품목명 -->
					<td class="left"><%=rowData.get("SPECIFICATION")%></td><!-- 규격 -->
					<td class="left"><%=rowData.get("AGENT_NAME")%></td><!-- 협력사 -->
					<td class="data.right"  align="right"><%=rowData.get("CART_QTY")%>&nbsp;</td><!-- 수량 --> 
					<td class="left">&nbsp;<%=rowData.get("REMARK")%></td><!--비고-->
					<input type="hidden" name="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
					<input type="hidden" name="st_contract_no" value="<%=rowData.get("CONTRACT_NO")%>">
					<input type="hidden" name="st_contract_seq" value="<%=rowData.get("CONTRACT_SEQ")%>">
					<input type="hidden" name="st_use_flag" value="<%=rowData.get("USE_FLAG")%>">
					<input type="hidden" name="st_seq" value="<%=rowData.get("SEQ")%>">
					<input type="hidden" name="st_remark" value="<%=rowData.get("REMARK")%>">
				<%}%>
				</tr>
<%
			} 
		}
%>
			</tbody>
		</table> 
<%if(_gridList != null && _gridList.size() > 0){%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%}%>
</form>
		<br>
		<form method="post" action="/mpso/setExcelUp.do"  name="UploadForm" id="UploadForm"      modelAttribute="uploadForm" enctype="multipart/form-data">      
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" id="cart_type"  name="cart_type" value="<%=p060000080%>">
			<table  class="board_write" summary="파일업로드" id="fileTable">
				<caption><%=CommonLang.get("HTITLE641") %><!-- 장바구니 올리기 --></caption>
				<colgroup>
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td scope="row">
							<input name="files" id="files" type="file"  class="input_type_text" onchange="setExcelUpValid()" />
						</td>
					</tr>
			</table>
		</form>
		<br>
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fl" style="text-align: left">
				<font style="font-weight:bold; color:red;"><%=CommonLang.get("HTITLE181") %><!-- ※ 품목코드가 숫자로만 구성된 경우, 문자인식을 위하여 엑셀양식 내 품목코드를 선택 후,  --></font><br>
				<font style="font-weight:bold; color:red;"><%=CommonLang.get("HTITLE642") %><!-- [데이터] 탭 - [텍스트나누기] 진행 - 3단계 중 열 데이터 서식 [텍스트] 로 필히 작업하여 주시기 바랍니다. --></font>
			</div> 
        	<div class="fr"> 
				<span class="btn_03 mr04">
			<%if(p060000080.equals("TYPE1")){%>
				<a href="/resources/excel/cart_template_type1.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a>
			<%}else if(p060000080.equals("TYPE2")){%>
				<a href="/resources/excel/cart_template_type2.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a>
			<%}else{%>
				<a href="/resources/excel/cart_template.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a>
			<%}%>
				</span>
				<span class="btn_03 mr04">
					<a href="javascript:doAction('setExcelUp');"><%=CommonLang.get("HTITLE34") %><!-- 엑셀업로드 --></a>
				</span>
				<span class="btn_03 mr04">
					<a href="javascript:doAction('setCartAddDel');"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a>
				</span>
				<span class="btn_03 mr04">
					<a href="javascript:doAction('setCartAddReg');"><%=CommonLang.get("HTITLE11") %><!-- 장바구니담기 --></a>
				</span>
											
			</div> 
        </div> 
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
	<% if ("".equals(curPage)) { %>
	doAction("search");
	<%}%>
}

var st;
//기능함수
function doAction(str) {
		
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
		break;  
	case "setExcelUp":  
		setExcelUp();
		break;
	case "setCartAddDel":  
		setCartAddDel();
		break;
	case "setCartAddReg":  
		setCartAddReg();
		break;	  
	}	
}

// 조회
function kepSearch(curPage){

	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartUploadList.do").submit();   
}
    
function setCartAddDel(){

	var tot_cnt     =  $("#display_item_cnt").val();
	var query     =  "";
	var chCnt = getCheckedRowCount(tot_cnt);
 
	 if(chCnt == "0"){
		 	// 하나 이상의 상품이 선택되어야 합니다.   
	        alert("<%=CommonLang.msg("MSG17") %>");
	        return;
	    }else{
	        if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0" ); 
	            if(box.checked == true){
	            	var st_seq     = document.forms.contentForm.st_seq.value;  	 
					query =st_seq + "@@";
					
	            }
	        }else{
	            for(var i = 0; i <tot_cnt; i++){
	                var box = eval("document.forms.contentForm.lnCheck" + i);
	                var st_seq     = document.forms.contentForm.st_seq[i].value;  
	                if(box.checked == true){
						  query += st_seq + "@@"; 					
	                }
	            }
	        }
	    }	 
	document.forms.contentForm.st_query.value = query;
	//삭제하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG368") %>")) {
		//document.forms.contentForm.action="/kr/customer/shopping_cart/buyer_shoppingcart_exupload_del_reg.jsp";

		kepAjaxFormCall("/mpso/setCartAddDel.do","contentForm","BUYER_SHOPPINGCART_EXUPLOAD_DEL_REG"); 
	}
}

function setCartAddReg(){
	var query     =  "";
	var tot_cnt     =  $("#display_item_cnt").val();
	var chCnt = getCheckedRowCount(tot_cnt);
	var dup_add_posb_yn = "<%=dup_add_posb_yn%>";
	var p060000080 = "<%=p060000080%>";
	
	if(chCnt == 0 ){
		//선택된 내역이 없습니다.
		alert("<%=CommonLang.msg("MSG164") %>");
		return;
	} 

	if(tot_cnt > 1){

		for(var i = 0; i < tot_cnt; i++){
			var box = eval("document.forms.contentForm.lnCheck" + i);
			
			if(box.checked == true){
				if(p060000080 == "TYPE1"){
					if(document.forms.contentForm.st_urct_yn[i].value == "N"){
						// 행은 허용 검색 카테고리의 품목이 아닙니다.
						alert(eval(i+1) + " <%=CommonLang.msg("MSG165") %>");
						return;
					}else{
						if(document.forms.contentForm.st_bict_yn[i].value == "Y" && document.forms.contentForm.st_size_len[i].value == ""){
							// 행은 수량, 길이 필수입력 품목입니다.
							alert(eval(i+1) + " <%=CommonLang.msg("MSG166") %>");
							return;
						}else if(document.forms.contentForm.st_bict_yn[i].value == "N" && document.forms.contentForm.st_size_len[i].value != ""){
							// 행은 길이 입력불가 품목입니다.
							alert(eval(i+1) + " <%=CommonLang.msg("MSG167") %>");
							return;
						}
					}
				}else if(p060000080 == "TYPE2"){
					if(document.forms.contentForm.st_ref_pr_no_name[i].value == '코드없음' || document.forms.contentForm.st_budget_dept_name[i].value == '코드없음' || document.forms.contentForm.st_account_type_name[i].value == '코드없음'){
						//자재그룹 / 예산부서 / 계정을 확인하여 주시기 바랍니다. : Line No.
						alert("<%=CommonLang.msg("MSG168") %>"+ eval(i+1));
						return;
					}
				}
				
				if(document.forms.contentForm.st_remark[i].value != ''){
					if((document.forms.contentForm.st_remark[i].value == "Excel데이타 중복품목 존재" || document.forms.contentForm.st_remark[i].value == "장바구니에 대상품목 기존재") && dup_add_posb_yn == "Y" ){
					}else{
						//은 장바구니 등록 할수 없습니다. : Line No.
						alert(document.forms.contentForm.st_remark[i].value+"<%=CommonLang.msg("MSG169") %>"+ eval(i+1));
						return;
					}
			 	}
			}
		}
	}else{
		var box = eval("document.forms.contentForm.lnCheck0" );
		if(box.checked == true){
			if(p060000080 == "TYPE1"){
				if(document.forms.contentForm.st_urct_yn.value == "N"){
					//해당 건은 허용 검색 카테고리의 품목이 아닙니다.
					alert("<%=CommonLang.msg("MSG170") %>");
					return;
				}else{
					if(document.forms.contentForm.st_bict_yn.value == "Y" && document.forms.contentForm.st_size_len.value == ""){
						//해당 건은 수량, 길이 필수입력 품목입니다.
						alert("<%=CommonLang.msg("MSG171") %>");
						return;
					}else if(document.forms.contentForm.st_bict_yn.value == "N" && document.forms.contentForm.st_size_len.value != ""){
						//해당 건은 길이 입력불가 품목입니다.
						alert("<%=CommonLang.msg("MSG172") %>");
						return;
					}
				}
			}
			 
			if(document.forms.contentForm.st_remark.value != ''){
				if((document.forms.contentForm.st_remark.value == "Excel데이타 중복품목 존재" || document.forms.contentForm.st_remark.value == "장바구니에 대상품목 기존재") && dup_add_posb_yn == "Y" ){
				}else{
					//은 장바구니 등록 할수 없습니다. : Line No 1.
					alert(document.forms.contentForm.st_remark.value+"<%=CommonLang.msg("MSG173") %>");
					return;
				}
			}
		 }
	}
	
	 if(chCnt == "0"){
		 	// 하나 이상의 상품이 선택되어야 합니다.
	        alert("<%=CommonLang.msg("MSG17") %>");
	        return;
	    }else{
	        if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0"); 
	            if(box.checked == true){
	            	var st_seq = document.forms.contentForm.st_seq.value;  	 
					query =st_seq + "@@";
					
	            }
	        }else{
	            for(var i = 0; i <tot_cnt; i++){
	                var box = eval("document.forms.contentForm.lnCheck" + i);
	                var st_seq = document.forms.contentForm.st_seq[i].value;  
	                if(box.checked == true){
						  query += st_seq + "@@"; 					
	                }
	            }
	        }
	    }	 

	document.forms.contentForm.st_query.value = query;
	//장바구니 등록 하시겠습니까？
	if(confirm("<%=CommonLang.msg("MSG367") %>")){
		//document.forms.contentForm.action="/kr/customer/shopping_cart/buyer_shoppingcart_exupload_transcart_reg.jsp";

		kepAjaxFormCall("/mpso/setCartAddReg.do","contentForm","BUYER_SHOPPINGCART_EXUPLOAD_TRANSCART_REG"); 
	}
}

function setExcelUp(){
	if (isEmpty($("#files").val())==true){
		//업로드 대상이 없습니다. 확인 부탁드립니다.
		alert("<%=CommonLang.msg("MSG175") %>");
		return false;
	}
	 
	$('#UploadForm').attr("action", "/mpso/setExcelUp.do").submit();
}	

function IsExt(str){
    var urltext = str.toLowerCase(); //받아온 파일명을 소문자로 변경한다.
    if(/xls$/.test(urltext)||/xlsx$/.test(urltext)){
       return false; //해당 파일명에 xls라는 단어가 있음.
    }else{
      return true; //해당 파일명에 xls라는 단어가 없음.
    }
 }

function setExcelUpValid(){
if (IsExt($("#files").val())) { //파일명 체크
	//해당 형식의 파일은 업로드할 수 없습니다.
    alert("<%=CommonLang.msg("MSG176") %>");
    doAction("search");
  }
}


function getCheckedRowCount(tot_cnt){
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.lnCheck0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.lnCheck" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){	
      if(pMethod == "BUYER_SHOPPINGCART_EXUPLOAD_TRANSCART_REG"){  
    	  //장바구니에 등록되었습니다.
    	  alert("<%=CommonLang.msg("MSG177") %>");
       	// 처리후 재조회
       	kepSearch($("#curPage").val());       
      }else if(pMethod == "BUYER_SHOPPINGCART_EXUPLOAD_DEL_REG"){  
    	  //삭제되었습니다.
    	  alert("<%=CommonLang.msg("MSG178") %>");
       	// 처리후 재조회
       	kepSearch($("#curPage").val());       
      } 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "BUYER_SHOPPINGCART_EXUPLOAD_TRANSCART_REG"){
		//장바구니 등록중 오류가 발생 하였습니다.\n\n관리자에게 문의해 주세요
		alert("<%=CommonLang.msg("MSG179") %>");
	} else if (pMethod == "BUYER_SHOPPINGCART_EXUPLOAD_DEL_REG"){
		//삭제중 오류가 발생 하였습니다.\n\n관리자에게 문의해 주세요
		alert("<%=CommonLang.msg("MSG180") %>");
	}
}
</script>
</html>
