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
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  

// List< String > _list = new ArrayList< String >( );
// _list = CommonUtil.getStringArrary((String) _dataList1.get("st_status"),",");
// if(_list.size() > 0){
// 	_dataList1.put("st_status_all", _list);
// } 


String st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
String st_to_date            = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
String st_date_type         = CommonUtil.nvl((String) request.getParameter("st_date_type"),"");
String st_status              = CommonUtil.nvl((String) request.getParameter("st_status"),"");
String st_buyer_code       = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
String st_buyer_name      = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");
String st_agent_code       = CommonUtil.nvl((String) request.getParameter("st_agent_code"),"");
String st_agent_name      = CommonUtil.nvl((String) request.getParameter("st_agent_name"),"");
String st_buyer_item_no   = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_po_dept_name   = CommonUtil.nvl((String) request.getParameter("st_po_dept_name"),"");
String st_po_dept_code    = CommonUtil.nvl((String) request.getParameter("st_po_dept_code"),"");
String st_req_dept_name  = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");
String st_req_dept_code   = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),"");
String st_if_po_no           = CommonUtil.nvl((String) request.getParameter("st_if_po_no"),"");
String st_po_no              = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
String st_ref_no              = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");
String st_sql_temp          = CommonUtil.nvl((String) request.getParameter("st_sql_temp"),"");
String st_status_text        = CommonUtil.nvl((String) request.getParameter("st_status_text"),"");
String st_status_all          = CommonUtil.nvl((String) request.getParameter("st_status"),"");

if ("".equals(st_date_type)){
	st_date_type = "PO";
}

String st_temp_date = "";
if(st_date_type.equals("PO")){
	  st_temp_date = "발주일";
}else if(st_date_type.equals("GR")){
	  st_temp_date = "입고일";
}else if(st_date_type.equals("RD")){
	st_temp_date = "요청일";
}

if ("".equals(st_status_text)){
	st_status_text = "전체";
}

if ("".equals(st_buyer_code)){
	st_sql_temp          = "BU";
}else {
	st_sql_temp          = "AG";
}

String temp_temp = "";
String temp_date = "";
String temp_buyer = "";
String temp_seller = "";
String temp_agent = "";
String temp_from_item = "";
String temp_status_ing = "";
String temp_purchasing_type = "";

double po_tot_price = 0;
double po_temp_tot_price = 0;
double gr_tot_price = 0;
double gr_temp_tot_price = 0;
double re_gr_tot_price = 0;
double re_gr_temp_tot_price = 0;

double tot_price_list_po = 0;
double tot_price_list_gr = 0;
double temp_tot_po_list_price = 0;
double temp_tot_gr_list_price = 0;

%>
<script type="text/javascript">
<!--

 //-->
</script> 
<body>
<form name=agent_info_display_pop id=agent_info_display_pop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="agentInfoDisplayPop"> 
	 
	 <input type="hidden" name="st_date_type"         value="<%=st_date_type%>">
	 <input type="hidden" name="st_status"              value="<%=st_status%>">
	 <input type="hidden" name="st_buyer_code"       value="<%=st_buyer_code%>">
	 <input type="hidden" name="st_buyer_name"      value="<%=st_buyer_name%>">
	 <input type="hidden" name="st_agent_code"       value="<%=st_agent_code%>">
	 <input type="hidden" name="st_agent_name"      value="<%=st_agent_name%>">
	 <input type="hidden" name="st_buyer_item_no"   value="<%=st_buyer_item_no%>">
	 <input type="hidden" name="st_po_dept_name"   value="<%=st_po_dept_name%>">
	 <input type="hidden" name="st_po_dept_code"    value="<%=st_po_dept_code%>">
	 <input type="hidden" name="st_req_dept_name"  value="<%=st_req_dept_name%>">
	 <input type="hidden" name="st_req_dept_code"   value="<%=st_req_dept_code%>">
	 <input type="hidden" name="st_if_po_no"           value="<%=st_if_po_no%>">
	 <input type="hidden" name="st_po_no"              value="<%=st_po_no%>">
	 <input type="hidden" name="st_ref_no"              value="<%=st_ref_no%>">
	 <input type="hidden" name="st_sql_temp"          value="<%=st_sql_temp%>">
	 <input type="hidden" name="st_from_date"        value="<%=st_from_date%>">
	 <input type="hidden" name="st_to_date"            value="<%=st_to_date%>">
	 <input type="hidden" name="st_status_text"        value="<%=st_status_text%>">
	 	  
	 	  	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:565px;">
    	<div id="popHeader">
        	<h1 class="title">거래내역 집계</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:500px;">
		<h2>거래내역집계</h2>

		<table  class="cont_t_list06 mb15" summary="거래내역집계" style="width:100%;">
			<caption>caption</caption>
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tbody>
	    	<tr> 
	    		<th scope="row"><%=st_temp_date%></th>
				<td scope="row"><%=st_from_date%> &nbsp;~&nbsp; <%=st_to_date%></td>
	    		<th scope="row">진행상태</th>
				<td scope="row"><%=st_status_text%></td>
			</tr>
			<tr>
				<th scope="row">고객사</th>
				<td scope="row"><%=st_buyer_name%></td>
				<th scope="row">협력사</th>
				<td scope="row"><%=st_agent_name%></td>
			  </tr>
			  <tr>
				<th scope="row">품목코드</th>
				<td scope="row"><%=st_buyer_item_no%></td>
				<th scope="row">관리번호</th>
				<td scope="row"><%=st_ref_no%></td>
			  </tr>
			  <tr>
				<th scope="row">발주부서</th>
				<td scope="row"><%=st_po_dept_name%></td>
				<th scope="row">요청부서</th>
				<td scope="row"><%=st_req_dept_name%></td>
			  </tr>
			  <tr>
				<th scope="row">발주번호</th>
				<td scope="row"><%=st_po_no%></td>
				<th scope="row">IF발주번호</th>
				<td scope="row" ><%=st_if_po_no%></td>
			  </tr> 
	        </tbody>
	   </table> 

			<!--grid-->
			<div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>거래내역집계</caption>
                    <colgroup>
                        <col width="25%" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="15%" />  
                        <col width="15%" />    
                    </colgroup>		   
                    <thead> 
                        <tr>         
<%            if(st_sql_temp.equals("AG"))  {                   %>
                            <th scope="col">협력사</th>  
<%            }else if(st_sql_temp.equals("BU")){              %>
                            <th scope="col">고객사</th>                            
<%            }                                                           %>                        
                            <th scope="col">발주금액</th>   
                            <th scope="col">입고금액</th>   
                            <th scope="col">미입고금액</th>   
                            <th scope="col">매입금액(발주)</th>   
                            <th scope="col">매입금액(입고)</th>
                        </tr>
                    </thead>
                    <tbody>
<% 

for (int j=0; j<_dataList1.size(); j++) {
	
	int z = 0;
	int k = 0;
	z = _dataList1.size();
	k = z-1;
	String aaa = "";
	
	Map<String,String> _tmp2 = _dataList1.get(j);	
	
	if(j == k){
	    aaa = "xxx";
    }else {
    	Map<String,String> _tmp3 = _dataList1.get(j+1);	
        aaa = CommonUtil.nvl(_tmp3.get("COM_NAME"));
    }
	
    po_temp_tot_price      += Double.parseDouble(CommonUtil.nvl(_tmp2.get("발주금액"))); // PO소계
    gr_temp_tot_price       += Double.parseDouble(CommonUtil.nvl(_tmp2.get("입고금액"))); // GR소계
    re_gr_temp_tot_price   += Double.parseDouble(CommonUtil.nvl(_tmp2.get("미입고금액"))); // 미GR소계
    temp_tot_po_list_price += Double.parseDouble(CommonUtil.nvl(_tmp2.get("AGENT발주금액"))); // 매입소계(발주)
    temp_tot_gr_list_price  += Double.parseDouble(CommonUtil.nvl(_tmp2.get("AGENT입고금액"))); // 매입소계(입고) 
%>  
         
                        <tr>
						   
<%            if(st_sql_temp.equals("AG"))  {                   %>
                            <td class="center"><%=CommonUtil.nvl(_tmp2.get("COM_NAME"))%></td>
<%            }else if(st_sql_temp.equals("BU")){              %>
                            <td class="center"><%=CommonUtil.nvl(_tmp2.get("COM_NAME2"))%></td>                            
<%            }                                                           %>    						    
						   <td><p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("발주금액"),true,0,3)%></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("입고금액"),true,0,3)%></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("미입고금액"),true,0,3)%></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("AGENT발주금액"),true,0,3)%></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><%=CommonUtil.formatNumber(_tmp2.get("AGENT입고금액"),true,0,3)%></p></td>						   	    
						</tr>
 <%              if(!CommonUtil.nvl(_tmp2.get("COM_NAME2")).equals(aaa)) {            %>						
						<tr>
						   <td class="center"><font color="blue"><b>소&nbsp;&nbsp;계</b></font></td> 
						   <td><p style="text-align:right;padding-right:5px;"><font color="blue"><b><%=CommonUtil.formatNumber(po_temp_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="blue"><b><%=CommonUtil.formatNumber(gr_temp_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="blue"><b><%=CommonUtil.formatNumber(re_gr_temp_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="blue"><b><%=CommonUtil.formatNumber(temp_tot_po_list_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="blue"><b><%=CommonUtil.formatNumber(temp_tot_gr_list_price,true,0,3)%></b></font></p></td>						   	    
						</tr>     
 <%
						 aaa = "";
						 po_temp_tot_price = 0;
						 gr_temp_tot_price = 0;
						 re_gr_temp_tot_price = 0;
						 temp_tot_po_list_price = 0;
						 temp_tot_gr_list_price = 0;
					
                    }
 
                     po_tot_price      += Double.parseDouble(CommonUtil.nvl(_tmp2.get("발주금액"))); // PO 총 합계
					 gr_tot_price       += Double.parseDouble(CommonUtil.nvl(_tmp2.get("입고금액"))); // GR 총 합계
					 re_gr_tot_price   += Double.parseDouble(CommonUtil.nvl(_tmp2.get("미입고금액"))); // 미GR 총 합계
					 tot_price_list_po += Double.parseDouble(CommonUtil.nvl(_tmp2.get("AGENT발주금액"))); // 매입 총 합계(발주)
					 tot_price_list_gr  += Double.parseDouble(CommonUtil.nvl(_tmp2.get("AGENT입고금액"))); // 매입 총 합계(입고)
				
      }
%>              
                        <tr>
						   <td class="center"><font color="red"><b>합&nbsp;&nbsp;계</b></font></td> 
						   <td><p style="text-align:right;padding-right:5px;"><font color="red"><b><%=CommonUtil.formatNumber(po_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="red"><b><%=CommonUtil.formatNumber(gr_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="red"><b><%=CommonUtil.formatNumber(re_gr_tot_price,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="red"><b><%=CommonUtil.formatNumber(tot_price_list_po,true,0,3)%></b></font></p></td>
						   <td><p style="text-align:right;padding-right:5px;"><font color="red"><b><%=CommonUtil.formatNumber(tot_price_list_gr,true,0,3)%></b></font></p></td>						   	    
						</tr>               
                    </tbody>
                </table>  
             </div>	
        </div>
    </div>         
    <div class="btnArea" style="margin-bottom:0px;"> 
                <span class="btn_03"><a href="javascript:print();">출력</a></span>
                <span class="btn_03"><a href="javascript:self.close()">닫기</a></span>
                <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    </div>                    
</form> 
</body>
</html>
