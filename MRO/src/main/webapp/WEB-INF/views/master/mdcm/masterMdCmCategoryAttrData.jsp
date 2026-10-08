<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%
List<Map<String,String>> _dataList;

int recCnt = (Integer)request.getAttribute("count");

Map<String,String> _pMap = (Map<String,String>)request.getAttribute("pMap");

int loopCnt = (recCnt/3)+1;
%>
<!-- HIDDEN -->
<table  class="cont_t_list01" > 
				<colgroup> 
				<col width="90px" /> 
				<col width="25%" /> 
				<col width="90px" /> 
				<col width="25%" /> 
				<col width="90px" /> 
				<col width="25%" /> 
				</colgroup> 
				<tbody> 
				<tr visible="false">
					<th></th>
					<td></td>
					<th></th>
					<td></td>
					<th></th>
					<td></td>
				</tr>
<%
	for (int i=0; i<loopCnt; i++){
%>
				<tr>
<%
		for (int j=1; j<=3; j++){
			int z = (3*i)+j;
			
			if(z > recCnt){
				break;
			}
			
			_dataList = (List<Map<String,String>>) request.getAttribute("data"+z);
			Map<String,String> _rowData = null;
			
			int recCnt2 =  _dataList.size() != 0 ? _dataList.size() : 0;
			if (_dataList != null && recCnt2!= 0){
%>
				<th><%=_dataList.get(0).get("ATTB_NM")%></th>
				<td>
					<select id="property_search<%=z%>"  name="property_search<%=z%>"  style="width:160px;" <%if(recCnt2 > 1){ %>onChange="fn_categ_subPro('<%=z%>');" <%}%>>
					<option value='' >--선택</option>
<%
				if(recCnt2 == 1){
%>					
					<option value='<%=_dataList.get(0).get("ATTB_CODE") %>' selected><%=_dataList.get(0).get("ATTB_CODE") %></option>
<%				
				}else{
				for( int a =0 ; a < recCnt2; a++){
					_rowData = _dataList.get(a);
%>
					<option value='<%=_rowData.get("ATTB_CODE") %>'   ><%=_rowData.get("ATTB_CODE") %></option>
<%
				}
				}
%>
					</select>
				</td>
<%
			}
		}
%>
			</tr>
<%
	}
%>
</tbody>
</table>
