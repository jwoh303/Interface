<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서 상세조회 고객사용
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-10-05
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _infoMap = (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String p_buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");
	String p_inv_no = CommonUtil.nvl((String) request.getParameter("inv_no"),"");
%>

<script type="text/javascript">

function btnSheet(){

	var inv_no   = "<%=p_inv_no%>";
	var buyer  = "<%=p_buyer%>";
	var seller = "KRKORE0001";

	var param =  "["+inv_no+"]["+seller+"]["+buyer+"]";
	var fileName = "RD_06_S_001_110";
	
	reportOpen(fileName,param);
	
	return;	
}

</script> 
</head>
<body>
<form name="commonMpIvDlvryDetailPop" id="commonMpIvDlvryDetailPop" method=post >
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">


	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:556px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE786") %><!-- 거래명세서 상세조회 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 발주 상세내용 -->
        	<table style="width:100%;">
			    <tr>
			        <td colspan="2">
			           <table  class="board_write" summary="거래명세서 상세조회">
			                <tr height="25">
			                    <th width="20%"><%=CommonLang.get("HTITLE784") %><!-- 거래명세서번호 --></th>
			                    <td width="30%"><%=_infoMap.get("INV_NO")%></td>
			                    <th width="20%" height="25"><%=CommonLang.get("HTITLE785") %><!-- 납품일 --></th>
			                    <td width="30%"><%=_infoMap.get("INV_DATE")%></td>
			                </tr>
			            </table>
			        </td>
			    </tr>
			</table>
            <br>
			<!--grid-->
			<div class="scrollArea" style="height:300px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>거래명세서 상세조회 리스트</caption>
						<colgroup>
						<col width="25%" />
						<col width="*" />
						<col width="15%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE13") %> / <%=CommonLang.get("HTITLE15") %><!-- 품목명/제조사 --></th> 
							<th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE217") %> / <%=CommonLang.get("HTITLE52") %><!-- 발주수량/단위 --></th>
						</tr>
						<tr> 
							<th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE264") %><!-- 납품수량 --></th>
						</tr>
					</thead>
					<tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
	               		<tr bgcolor="#FFFFFF">
	                        <td colspan="4" align="center" height = "200">
	                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
	                        </td> 
	                    </tr>
				<%
					} else {
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";	
				%> 
						<tr bgcolor="<%=tclass%>">
							<td class="left">
								<%=_tmp.get("REF_PR_NO")%>
							</td>
							<td class="left">
							 	<%=_tmp.get("DESCRIPTION")%> / <%=_tmp.get("MAKER_NAME")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("UNIT_PRICE"),true,0,3)%>
							</td>
							<td>
							 	<%=CommonUtil.formatNumber(_tmp.get("ITEM_QTY"),true,0,3)%> / <%=_tmp.get("UNIT_MEASURE")%>
							</td>
						</tr>
						<tr bgcolor="<%=tclass%>">
							<td>
								<%=_tmp.get("BUYER_ITEM_NO")%>
							</td>
							<td class="left">
								<%=_tmp.get("SPECIFICATION")%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("ITEM_AMT"),true,0,3)%>
							</td>
							<td class="right">
							 	<%=CommonUtil.formatNumber(_tmp.get("INV_QTY"),true,0,3)%>
							</td>
						</tr>
						<tr bgcolor="<%=tclass%>">
							<td class="left" colspan="4">
								<b><%=CommonLang.get("HTITLE788") %></b><!-- 발주비고 --> : <%=_tmp.get("REMARK")%>
							</td>
						</tr>
						<tr bgcolor="<%=tclass%>">
							<td class="left" colspan="4">
								<b><%=CommonLang.get("HTITLE789") %></b><!-- 납품장소 --> : <%=_tmp.get("DELY_TO_LOCATION")%>
							</td>
						</tr>
				<%
						}
					}
				%>                               
					</tbody>
				</table>
	        </div>
	        <br>
	        <div style="height:25px">
		        <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:5px;">
					<tr> 
						<td align="left" width="100px">
							<!-- 발주서인쇄 버튼 -->
							<div class="btnArea">
								<div class="fl">
									<span class="btn_04">
										<a href="javascript:btnSheet();"><%=CommonLang.get("HTITLE787") %><!-- 거래명세서 출력 --></a>
									</span>	
					            </div>
					        </div>
						</td>
					</tr>
				</table>
			</div>
		</div>        
	</div>
</form> 
</body>
</html>
