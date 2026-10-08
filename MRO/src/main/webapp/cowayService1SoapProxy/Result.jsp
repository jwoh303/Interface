<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.eclipse.jst.ws.util.JspUtils"%>
<% request.setCharacterEncoding("UTF-8"); %>
<HTML>
<HEAD>
<TITLE>Result</TITLE>
</HEAD>
<BODY>
<H1>Result</H1>

<jsp:useBean id="cowayService1SoapProxyid" scope="session" class="com.koreab2b.mro.webservice.coway.Service1SoapProxy" />

<%
String method = request.getParameter("method");
int methodID = 0;
if (method == null) methodID = -1;

if(methodID != -1) methodID = Integer.parseInt(method);
boolean gotMethod = false;

try {
switch (methodID){ 
case 2:
        gotMethod = true;
        java.lang.String getEndpoint2mtemp = cowayService1SoapProxyid.getEndpoint();
if(getEndpoint2mtemp == null){
%>
<%=getEndpoint2mtemp %>
<%
}else{
        String tempResultreturnp3 = JspUtils.markup(String.valueOf(getEndpoint2mtemp));
        %>
        <%= tempResultreturnp3 %>
        <%
}
break;
case 5:
        gotMethod = true;
        String endpoint_0id=  request.getParameter("endpoint8");
            java.lang.String endpoint_0idTemp = null;
        if(!endpoint_0id.equals("")){
         endpoint_0idTemp  = endpoint_0id;
        }
        cowayService1SoapProxyid.setEndpoint(endpoint_0idTemp);
break;
case 10:
        gotMethod = true;
        com.koreab2b.mro.webservice.coway.Service1Soap getService1Soap10mtemp = cowayService1SoapProxyid.getService1Soap();
if(getService1Soap10mtemp == null){
%>
<%=getService1Soap10mtemp %>
<%
}else{
        if(getService1Soap10mtemp!= null){
        String tempreturnp11 = getService1Soap10mtemp.toString();
        %>
        <%=tempreturnp11%>
        <%
        }}
break;
case 13:
        gotMethod = true;
        String emp_no_1id=  request.getParameter("emp_no16");
            java.lang.String emp_no_1idTemp = null;
        if(!emp_no_1id.equals("")){
         emp_no_1idTemp  = emp_no_1id;
        }
        String flag_2id=  request.getParameter("flag18");
            java.lang.String flag_2idTemp = null;
        if(!flag_2id.equals("")){
         flag_2idTemp  = flag_2id;
        }
        java.lang.String getPoint13mtemp = cowayService1SoapProxyid.getPoint(emp_no_1idTemp,flag_2idTemp);
if(getPoint13mtemp == null){
%>
<%=getPoint13mtemp %>
<%
}else{
        String tempResultreturnp14 = JspUtils.markup(String.valueOf(getPoint13mtemp));
        %>
        <%= tempResultreturnp14 %>
        <%
}
break;
case 20:
        gotMethod = true;
        String trans_no_3id=  request.getParameter("trans_no23");
            java.lang.String trans_no_3idTemp = null;
        if(!trans_no_3id.equals("")){
         trans_no_3idTemp  = trans_no_3id;
        }
        String id_4id=  request.getParameter("id25");
            java.lang.String id_4idTemp = null;
        if(!id_4id.equals("")){
         id_4idTemp  = id_4id;
        }
        String prodname_5id=  request.getParameter("prodname27");
            java.lang.String prodname_5idTemp = null;
        if(!prodname_5id.equals("")){
         prodname_5idTemp  = prodname_5id;
        }
        String useamount_6id=  request.getParameter("useamount29");
            java.lang.String useamount_6idTemp = null;
        if(!useamount_6id.equals("")){
         useamount_6idTemp  = useamount_6id;
        }
        String flag_7id=  request.getParameter("flag31");
            java.lang.String flag_7idTemp = null;
        if(!flag_7id.equals("")){
         flag_7idTemp  = flag_7id;
        }
        java.lang.String usePoint20mtemp = cowayService1SoapProxyid.usePoint(trans_no_3idTemp,id_4idTemp,prodname_5idTemp,useamount_6idTemp,flag_7idTemp);
if(usePoint20mtemp == null){
%>
<%=usePoint20mtemp %>
<%
}else{
        String tempResultreturnp21 = JspUtils.markup(String.valueOf(usePoint20mtemp));
        %>
        <%= tempResultreturnp21 %>
        <%
}
break;
case 33:
        gotMethod = true;
        String result_8id=  request.getParameter("result36");
            java.lang.String result_8idTemp = null;
        if(!result_8id.equals("")){
         result_8idTemp  = result_8id;
        }
        String trans_no_9id=  request.getParameter("trans_no38");
            java.lang.String trans_no_9idTemp = null;
        if(!trans_no_9id.equals("")){
         trans_no_9idTemp  = trans_no_9id;
        }
        String flag_10id=  request.getParameter("flag40");
            java.lang.String flag_10idTemp = null;
        if(!flag_10id.equals("")){
         flag_10idTemp  = flag_10id;
        }
        java.lang.String usePointOK33mtemp = cowayService1SoapProxyid.usePointOK(result_8idTemp,trans_no_9idTemp,flag_10idTemp);
if(usePointOK33mtemp == null){
%>
<%=usePointOK33mtemp %>
<%
}else{
        String tempResultreturnp34 = JspUtils.markup(String.valueOf(usePointOK33mtemp));
        %>
        <%= tempResultreturnp34 %>
        <%
}
break;
case 42:
        gotMethod = true;
        String trans_no_11id=  request.getParameter("trans_no45");
            java.lang.String trans_no_11idTemp = null;
        if(!trans_no_11id.equals("")){
         trans_no_11idTemp  = trans_no_11id;
        }
        String useamount_12id=  request.getParameter("useamount47");
            java.lang.String useamount_12idTemp = null;
        if(!useamount_12id.equals("")){
         useamount_12idTemp  = useamount_12id;
        }
        String id_13id=  request.getParameter("id49");
            java.lang.String id_13idTemp = null;
        if(!id_13id.equals("")){
         id_13idTemp  = id_13id;
        }
        String flag_14id=  request.getParameter("flag51");
            java.lang.String flag_14idTemp = null;
        if(!flag_14id.equals("")){
         flag_14idTemp  = flag_14id;
        }
        java.lang.String cancelPoint42mtemp = cowayService1SoapProxyid.cancelPoint(trans_no_11idTemp,useamount_12idTemp,id_13idTemp,flag_14idTemp);
if(cancelPoint42mtemp == null){
%>
<%=cancelPoint42mtemp %>
<%
}else{
        String tempResultreturnp43 = JspUtils.markup(String.valueOf(cancelPoint42mtemp));
        %>
        <%= tempResultreturnp43 %>
        <%
}
break;
case 53:
        gotMethod = true;
        String emp_no_15id=  request.getParameter("emp_no56");
            java.lang.String emp_no_15idTemp = null;
        if(!emp_no_15id.equals("")){
         emp_no_15idTemp  = emp_no_15id;
        }
        String flag_16id=  request.getParameter("flag58");
            java.lang.String flag_16idTemp = null;
        if(!flag_16id.equals("")){
         flag_16idTemp  = flag_16id;
        }
        java.lang.String getPointCW53mtemp = cowayService1SoapProxyid.getPointCW(emp_no_15idTemp,flag_16idTemp);
if(getPointCW53mtemp == null){
%>
<%=getPointCW53mtemp %>
<%
}else{
        String tempResultreturnp54 = JspUtils.markup(String.valueOf(getPointCW53mtemp));
        %>
        <%= tempResultreturnp54 %>
        <%
}
break;
case 60:
        gotMethod = true;
        String emp_no_17id=  request.getParameter("emp_no63");
            java.lang.String emp_no_17idTemp = null;
        if(!emp_no_17id.equals("")){
         emp_no_17idTemp  = emp_no_17id;
        }
        String use_point_18id=  request.getParameter("use_point65");
            java.lang.String use_point_18idTemp = null;
        if(!use_point_18id.equals("")){
         use_point_18idTemp  = use_point_18id;
        }
        String ac_sid_19id=  request.getParameter("ac_sid67");
            java.lang.String ac_sid_19idTemp = null;
        if(!ac_sid_19id.equals("")){
         ac_sid_19idTemp  = ac_sid_19id;
        }
        String ac_status_20id=  request.getParameter("ac_status69");
            java.lang.String ac_status_20idTemp = null;
        if(!ac_status_20id.equals("")){
         ac_status_20idTemp  = ac_status_20id;
        }
        String ac_add_rea_21id=  request.getParameter("ac_add_rea71");
            java.lang.String ac_add_rea_21idTemp = null;
        if(!ac_add_rea_21id.equals("")){
         ac_add_rea_21idTemp  = ac_add_rea_21id;
        }
        String wj_order_no_22id=  request.getParameter("wj_order_no73");
            java.lang.String wj_order_no_22idTemp = null;
        if(!wj_order_no_22id.equals("")){
         wj_order_no_22idTemp  = wj_order_no_22id;
        }
        String flag_23id=  request.getParameter("flag75");
            java.lang.String flag_23idTemp = null;
        if(!flag_23id.equals("")){
         flag_23idTemp  = flag_23id;
        }
        java.lang.String setPointCW60mtemp = cowayService1SoapProxyid.setPointCW(emp_no_17idTemp,use_point_18idTemp,ac_sid_19idTemp,ac_status_20idTemp,ac_add_rea_21idTemp,wj_order_no_22idTemp,flag_23idTemp);
if(setPointCW60mtemp == null){
%>
<%=setPointCW60mtemp %>
<%
}else{
        String tempResultreturnp61 = JspUtils.markup(String.valueOf(setPointCW60mtemp));
        %>
        <%= tempResultreturnp61 %>
        <%
}
break;
case 77:
        gotMethod = true;
        String request_id_24id=  request.getParameter("request_id80");
            java.lang.String request_id_24idTemp = null;
        if(!request_id_24id.equals("")){
         request_id_24idTemp  = request_id_24id;
        }
        String flag_25id=  request.getParameter("flag82");
            java.lang.String flag_25idTemp = null;
        if(!flag_25id.equals("")){
         flag_25idTemp  = flag_25id;
        }
        java.lang.String ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp = cowayService1SoapProxyid.ZMM_GSYS_REQ_STATUS_DISPLAY(request_id_24idTemp,flag_25idTemp);
if(ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp == null){
%>
<%=ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp %>
<%
}else{
        String tempResultreturnp78 = JspUtils.markup(String.valueOf(ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp));
        %>
        <%= tempResultreturnp78 %>
        <%
}
break;
case 84:
        gotMethod = true;
        String i_Afnam_26id=  request.getParameter("i_Afnam87");
            java.lang.String i_Afnam_26idTemp = null;
        if(!i_Afnam_26id.equals("")){
         i_Afnam_26idTemp  = i_Afnam_26id;
        }
        String i_Mblnr_27id=  request.getParameter("i_Mblnr89");
            java.lang.String i_Mblnr_27idTemp = null;
        if(!i_Mblnr_27id.equals("")){
         i_Mblnr_27idTemp  = i_Mblnr_27id;
        }
        String i_Status_28id=  request.getParameter("i_Status91");
            java.lang.String i_Status_28idTemp = null;
        if(!i_Status_28id.equals("")){
         i_Status_28idTemp  = i_Status_28id;
        }
        String xmlData_29id=  request.getParameter("xmlData93");
            java.lang.String xmlData_29idTemp = null;
        if(!xmlData_29id.equals("")){
         xmlData_29idTemp  = xmlData_29id;
        }
        String flag_30id=  request.getParameter("flag95");
            java.lang.String flag_30idTemp = null;
        if(!flag_30id.equals("")){
         flag_30idTemp  = flag_30id;
        }
        java.lang.String ZMM_GSYS_GIREQUEST_CHECK84mtemp = cowayService1SoapProxyid.ZMM_GSYS_GIREQUEST_CHECK(i_Afnam_26idTemp,i_Mblnr_27idTemp,i_Status_28idTemp,xmlData_29idTemp,flag_30idTemp);
if(ZMM_GSYS_GIREQUEST_CHECK84mtemp == null){
%>
<%=ZMM_GSYS_GIREQUEST_CHECK84mtemp %>
<%
}else{
        String tempResultreturnp85 = JspUtils.markup(String.valueOf(ZMM_GSYS_GIREQUEST_CHECK84mtemp));
        %>
        <%= tempResultreturnp85 %>
        <%
}
break;
case 97:
        gotMethod = true;
        String i_BUDAT_FROM_31id=  request.getParameter("i_BUDAT_FROM100");
            java.lang.String i_BUDAT_FROM_31idTemp = null;
        if(!i_BUDAT_FROM_31id.equals("")){
         i_BUDAT_FROM_31idTemp  = i_BUDAT_FROM_31id;
        }
        String i_BUDAT_TO_32id=  request.getParameter("i_BUDAT_TO102");
            java.lang.String i_BUDAT_TO_32idTemp = null;
        if(!i_BUDAT_TO_32id.equals("")){
         i_BUDAT_TO_32idTemp  = i_BUDAT_TO_32id;
        }
        String i_BUKRS_33id=  request.getParameter("i_BUKRS104");
            java.lang.String i_BUKRS_33idTemp = null;
        if(!i_BUKRS_33id.equals("")){
         i_BUKRS_33idTemp  = i_BUKRS_33id;
        }
        String i_ENAME_34id=  request.getParameter("i_ENAME106");
            java.lang.String i_ENAME_34idTemp = null;
        if(!i_ENAME_34id.equals("")){
         i_ENAME_34idTemp  = i_ENAME_34id;
        }
        String i_MBLNR_35id=  request.getParameter("i_MBLNR108");
            java.lang.String i_MBLNR_35idTemp = null;
        if(!i_MBLNR_35id.equals("")){
         i_MBLNR_35idTemp  = i_MBLNR_35id;
        }
        String i_ORGEH_36id=  request.getParameter("i_ORGEH110");
            java.lang.String i_ORGEH_36idTemp = null;
        if(!i_ORGEH_36id.equals("")){
         i_ORGEH_36idTemp  = i_ORGEH_36id;
        }
        String i_PERNR_37id=  request.getParameter("i_PERNR112");
            java.lang.String i_PERNR_37idTemp = null;
        if(!i_PERNR_37id.equals("")){
         i_PERNR_37idTemp  = i_PERNR_37id;
        }
        String i_STEXT_38id=  request.getParameter("i_STEXT114");
            java.lang.String i_STEXT_38idTemp = null;
        if(!i_STEXT_38id.equals("")){
         i_STEXT_38idTemp  = i_STEXT_38id;
        }
        String i_ZCODE_39id=  request.getParameter("i_ZCODE116");
            java.lang.String i_ZCODE_39idTemp = null;
        if(!i_ZCODE_39id.equals("")){
         i_ZCODE_39idTemp  = i_ZCODE_39id;
        }
        String flag_40id=  request.getParameter("flag118");
            java.lang.String flag_40idTemp = null;
        if(!flag_40id.equals("")){
         flag_40idTemp  = flag_40id;
        }
        java.lang.String ZMM_GSYS_REREQUEST_DISPLAY97mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_DISPLAY(i_BUDAT_FROM_31idTemp,i_BUDAT_TO_32idTemp,i_BUKRS_33idTemp,i_ENAME_34idTemp,i_MBLNR_35idTemp,i_ORGEH_36idTemp,i_PERNR_37idTemp,i_STEXT_38idTemp,i_ZCODE_39idTemp,flag_40idTemp);
if(ZMM_GSYS_REREQUEST_DISPLAY97mtemp == null){
%>
<%=ZMM_GSYS_REREQUEST_DISPLAY97mtemp %>
<%
}else{
        String tempResultreturnp98 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_DISPLAY97mtemp));
        %>
        <%= tempResultreturnp98 %>
        <%
}
break;
case 120:
        gotMethod = true;
        String i_Afnam_41id=  request.getParameter("i_Afnam123");
            java.lang.String i_Afnam_41idTemp = null;
        if(!i_Afnam_41id.equals("")){
         i_Afnam_41idTemp  = i_Afnam_41id;
        }
        String i_Remblnr_42id=  request.getParameter("i_Remblnr125");
            java.lang.String i_Remblnr_42idTemp = null;
        if(!i_Remblnr_42id.equals("")){
         i_Remblnr_42idTemp  = i_Remblnr_42id;
        }
        String i_Status_43id=  request.getParameter("i_Status127");
            java.lang.String i_Status_43idTemp = null;
        if(!i_Status_43id.equals("")){
         i_Status_43idTemp  = i_Status_43id;
        }
        String xmlData_44id=  request.getParameter("xmlData129");
            java.lang.String xmlData_44idTemp = null;
        if(!xmlData_44id.equals("")){
         xmlData_44idTemp  = xmlData_44id;
        }
        String flag_45id=  request.getParameter("flag131");
            java.lang.String flag_45idTemp = null;
        if(!flag_45id.equals("")){
         flag_45idTemp  = flag_45id;
        }
        java.lang.String ZMM_GSYS_REREQUEST_CHECK120mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_CHECK(i_Afnam_41idTemp,i_Remblnr_42idTemp,i_Status_43idTemp,xmlData_44idTemp,flag_45idTemp);
if(ZMM_GSYS_REREQUEST_CHECK120mtemp == null){
%>
<%=ZMM_GSYS_REREQUEST_CHECK120mtemp %>
<%
}else{
        String tempResultreturnp121 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_CHECK120mtemp));
        %>
        <%= tempResultreturnp121 %>
        <%
}
break;
case 133:
        gotMethod = true;
        String i_Bukrs_46id=  request.getParameter("i_Bukrs136");
            java.lang.String i_Bukrs_46idTemp = null;
        if(!i_Bukrs_46id.equals("")){
         i_Bukrs_46idTemp  = i_Bukrs_46id;
        }
        String i_Mblnr_47id=  request.getParameter("i_Mblnr138");
            java.lang.String i_Mblnr_47idTemp = null;
        if(!i_Mblnr_47id.equals("")){
         i_Mblnr_47idTemp  = i_Mblnr_47id;
        }
        String i_Orgeh_48id=  request.getParameter("i_Orgeh140");
            java.lang.String i_Orgeh_48idTemp = null;
        if(!i_Orgeh_48id.equals("")){
         i_Orgeh_48idTemp  = i_Orgeh_48id;
        }
        String i_Pernr_49id=  request.getParameter("i_Pernr142");
            java.lang.String i_Pernr_49idTemp = null;
        if(!i_Pernr_49id.equals("")){
         i_Pernr_49idTemp  = i_Pernr_49id;
        }
        String i_Matnr_50id=  request.getParameter("i_Matnr144");
            java.lang.String i_Matnr_50idTemp = null;
        if(!i_Matnr_50id.equals("")){
         i_Matnr_50idTemp  = i_Matnr_50id;
        }
        String flag_51id=  request.getParameter("flag146");
            java.lang.String flag_51idTemp = null;
        if(!flag_51id.equals("")){
         flag_51idTemp  = flag_51id;
        }
        java.lang.String ZMM_GSYS_REREQUEST_IV_CHECK133mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_IV_CHECK(i_Bukrs_46idTemp,i_Mblnr_47idTemp,i_Orgeh_48idTemp,i_Pernr_49idTemp,i_Matnr_50idTemp,flag_51idTemp);
if(ZMM_GSYS_REREQUEST_IV_CHECK133mtemp == null){
%>
<%=ZMM_GSYS_REREQUEST_IV_CHECK133mtemp %>
<%
}else{
        String tempResultreturnp134 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_IV_CHECK133mtemp));
        %>
        <%= tempResultreturnp134 %>
        <%
}
break;
case 148:
        gotMethod = true;
        String i_Maktx_52id=  request.getParameter("i_Maktx151");
            java.lang.String i_Maktx_52idTemp = null;
        if(!i_Maktx_52id.equals("")){
         i_Maktx_52idTemp  = i_Maktx_52id;
        }
        String i_Matnr_53id=  request.getParameter("i_Matnr153");
            java.lang.String i_Matnr_53idTemp = null;
        if(!i_Matnr_53id.equals("")){
         i_Matnr_53idTemp  = i_Matnr_53id;
        }
        String i_Orgeh_54id=  request.getParameter("i_Orgeh155");
            java.lang.String i_Orgeh_54idTemp = null;
        if(!i_Orgeh_54id.equals("")){
         i_Orgeh_54idTemp  = i_Orgeh_54id;
        }
        String i_Zcode_55id=  request.getParameter("i_Zcode157");
            java.lang.String i_Zcode_55idTemp = null;
        if(!i_Zcode_55id.equals("")){
         i_Zcode_55idTemp  = i_Zcode_55id;
        }
        String flag_56id=  request.getParameter("flag159");
            java.lang.String flag_56idTemp = null;
        if(!flag_56id.equals("")){
         flag_56idTemp  = flag_56id;
        }
        java.lang.String ZMM_GSYS_GIREQUEST_DISPLAY148mtemp = cowayService1SoapProxyid.ZMM_GSYS_GIREQUEST_DISPLAY(i_Maktx_52idTemp,i_Matnr_53idTemp,i_Orgeh_54idTemp,i_Zcode_55idTemp,flag_56idTemp);
if(ZMM_GSYS_GIREQUEST_DISPLAY148mtemp == null){
%>
<%=ZMM_GSYS_GIREQUEST_DISPLAY148mtemp %>
<%
}else{
        String tempResultreturnp149 = JspUtils.markup(String.valueOf(ZMM_GSYS_GIREQUEST_DISPLAY148mtemp));
        %>
        <%= tempResultreturnp149 %>
        <%
}
break;
case 161:
        gotMethod = true;
        String flag_57id=  request.getParameter("flag164");
            java.lang.String flag_57idTemp = null;
        if(!flag_57id.equals("")){
         flag_57idTemp  = flag_57id;
        }
        java.lang.String ZMM_GSYS_ZCODE_DISPLAY161mtemp = cowayService1SoapProxyid.ZMM_GSYS_ZCODE_DISPLAY(flag_57idTemp);
if(ZMM_GSYS_ZCODE_DISPLAY161mtemp == null){
%>
<%=ZMM_GSYS_ZCODE_DISPLAY161mtemp %>
<%
}else{
        String tempResultreturnp162 = JspUtils.markup(String.valueOf(ZMM_GSYS_ZCODE_DISPLAY161mtemp));
        %>
        <%= tempResultreturnp162 %>
        <%
}
break;
case 166:
        gotMethod = true;
        String xmlData1_58id=  request.getParameter("xmlData1169");
            java.lang.String xmlData1_58idTemp = null;
        if(!xmlData1_58id.equals("")){
         xmlData1_58idTemp  = xmlData1_58id;
        }
        java.lang.String fnc166mtemp = cowayService1SoapProxyid.fnc(xmlData1_58idTemp);
if(fnc166mtemp == null){
%>
<%=fnc166mtemp %>
<%
}else{
        String tempResultreturnp167 = JspUtils.markup(String.valueOf(fnc166mtemp));
        %>
        <%= tempResultreturnp167 %>
        <%
}
break;
}
} catch (Exception e) { 
%>
Exception: <%= JspUtils.markup(e.toString()) %>
Message: <%= JspUtils.markup(e.getMessage()) %>
<%
return;
}
if(!gotMethod){
%>
result: N/A
<%
}
%>
</BODY>
</HTML>
