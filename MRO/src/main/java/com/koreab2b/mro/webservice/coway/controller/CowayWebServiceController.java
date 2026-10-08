/**
 * Service1.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.koreab2b.mro.webservice.coway.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.eclipse.jst.ws.util.JspUtils;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.coway.Service1SoapProxy;

@Controller("cowayWebServiceController")
public class CowayWebServiceController {

	/**
	 * Coway point webservice REAL/TEST
	 */
	@Value("#{webServiceProps['resource.webService.cls']}")
	private String webServiceCon;

	@Value("#{webServiceProps['resource.webService.clsDev']}")
	private String webServiceConDev;

	@Autowired
	private Service1SoapProxy cowayService1SoapProxyid;

	@ResponseBody
	@RequestMapping(value = "/webservice/getCowayWebService.do", method = { RequestMethod.POST, RequestMethod.GET })
	public Map<String, Object> getBuyerMpSoCartCowayList(ModelMap pModel, HttpServletRequest req,
			HttpServletResponse res, @RequestParam Map<String, String> pMap) throws IOException {
		StringBuffer sb = new StringBuffer();
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		String method = req.getParameter("method");
		int methodID = 0;
		if (method == null)
			methodID = -1;
		if (methodID != -1)
			methodID = Integer.parseInt(method);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String emp_no_1id = req.getParameter("emp_no16");
		if (emp_no_1id == null)
			emp_no_1id = _sessionInfo.getUserId();
		emp_no_1id = emp_no_1id.substring(2);
		String path = webServiceCon;

		String devRealLocalFlag = "0";
		devRealLocalFlag = CommonUtil.getDevRealLocalFlag(req);
		if ("2".equals(devRealLocalFlag))
			path = webServiceCon;
		else
			path = webServiceConDev;

		String tempResultreturnp14 = "";
		String val = "";
		String[] sp = null;
		String pointValue = "";

		try {
			String getPoint13mtemp = cowayService1SoapProxyid.getPoint(emp_no_1id, path);
			if (getPoint13mtemp == null) {
				sb.append(getPoint13mtemp);
				sb.append("\n");
			} else {
				tempResultreturnp14 = JspUtils.markup(String.valueOf(getPoint13mtemp));
				val = tempResultreturnp14;
				sp = val.split(":");
				if (sp.length > 0) {
					if (sp[0].equals("OK")) {
						pointValue = sp[1];
					} else {
						pointValue = "0";
					}
				}
			}
		} catch (Exception e) {
			sb.append("포인트서버의 접속이 원활하지 않습니다.\n");
			sb.append("새로 고침후 다시 진행하시기 바랍니다. ");
			pointValue = "-1";
//			sb.append("Exception:");
//			sb.append("\n");
//			sb.append(JspUtils.markup(e.toString()));
//			sb.append("\n");
//			sb.append("Message:");
//			sb.append("\n");
//			sb.append(JspUtils.markup(e.getMessage()));
//			pointValue = "0";
		}

		sb.append("<b>");
		sb.append("&nbsp;&nbsp;&nbsp;Point : ");
		sb.append("<input type=\"text\" value=\"");
		sb.append(pointValue);
		sb.append("\" class=\"input.ccc\" size=\"10\" value=\"원\" style=\"background-color: #FFFFFF; font-weight: bold; font-size: 9pt; text-align:right; border: #FFFFFF 1px solid;\" placeholder=\"");
		sb.append(val);
		sb.append("\" READONLY />");
		sb.append("원");
		sb.append("</b>");
		_response.put("msg", _msg);
		_response.put("page", sb);
		_response.put("rntMessage", val);
		_response.put("pointValue", pointValue);
		return _response;
	}

	/**
	 * 
	 * @param req
	 * @param Integer.parseInt(method)
	 * @return
	 */
	public String cowayWebserviceCall(HttpServletRequest req, int methodID) {
		String rtn = "";
		boolean gotMethod = false;
		try {
			switch (methodID) {
			case 2:
				gotMethod = true;
				String getEndpoint2mtemp = cowayService1SoapProxyid.getEndpoint();
				if (getEndpoint2mtemp == null) {

					rtn = getEndpoint2mtemp;

				} else {
					String tempResultreturnp3 = JspUtils.markup(String.valueOf(getEndpoint2mtemp));
					rtn = tempResultreturnp3;
				}
				break;
			case 5:
				gotMethod = true;
				String endpoint_0id = req.getParameter("endpoint8");
				String endpoint_0idTemp = null;
				if (!endpoint_0id.equals("")) {
					endpoint_0idTemp = endpoint_0id;
				}
				cowayService1SoapProxyid.setEndpoint(endpoint_0idTemp);
				break;
			case 10:
				gotMethod = true;
				com.koreab2b.mro.webservice.coway.Service1Soap getService1Soap10mtemp = cowayService1SoapProxyid
						.getService1Soap();
				if (getService1Soap10mtemp == null) {
					rtn = String.valueOf(getService1Soap10mtemp);
				} else {
					if (getService1Soap10mtemp != null) {
						String tempreturnp11 = getService1Soap10mtemp.toString();
						rtn = tempreturnp11;
					}
				}
				break;
			case 13:
				gotMethod = true;
				String emp_no_1id = req.getParameter("emp_no16");
				String emp_no_1idTemp = null;
				if (!emp_no_1id.equals("")) {
					emp_no_1idTemp = emp_no_1id;
				}
				String flag_2id = req.getParameter("flag18");
				String flag_2idTemp = null;
				if (!flag_2id.equals("")) {
					flag_2idTemp = flag_2id;
				}
				String getPoint13mtemp = cowayService1SoapProxyid.getPoint(emp_no_1idTemp, flag_2idTemp);
				if (getPoint13mtemp == null) {
					rtn = getPoint13mtemp;
				} else {
					String tempResultreturnp14 = JspUtils.markup(String.valueOf(getPoint13mtemp));
					rtn = tempResultreturnp14;
				}
				break;
			case 20:
				gotMethod = true;
				String trans_no_3id = req.getParameter("trans_no23");
				String trans_no_3idTemp = null;
				if (!trans_no_3id.equals("")) {
					trans_no_3idTemp = trans_no_3id;
				}
				String id_4id = req.getParameter("id25");
				String id_4idTemp = null;
				if (!id_4id.equals("")) {
					id_4idTemp = id_4id;
				}
				String prodname_5id = req.getParameter("prodname27");
				String prodname_5idTemp = null;
				if (!prodname_5id.equals("")) {
					prodname_5idTemp = prodname_5id;
				}
				String useamount_6id = req.getParameter("useamount29");
				String useamount_6idTemp = null;
				if (!useamount_6id.equals("")) {
					useamount_6idTemp = useamount_6id;
				}
				String flag_7id = req.getParameter("flag31");
				String flag_7idTemp = null;
				if (!flag_7id.equals("")) {
					flag_7idTemp = flag_7id;
				}
				String usePoint20mtemp = cowayService1SoapProxyid.usePoint(trans_no_3idTemp, id_4idTemp,
						prodname_5idTemp, useamount_6idTemp, flag_7idTemp);
				if (usePoint20mtemp == null) {
					rtn = usePoint20mtemp;
				} else {
					String tempResultreturnp21 = JspUtils.markup(String.valueOf(usePoint20mtemp));
					rtn = tempResultreturnp21;
				}
				break;
			case 33:
				gotMethod = true;
				String result_8id = req.getParameter("result36");
				String result_8idTemp = null;
				if (!result_8id.equals("")) {
					result_8idTemp = result_8id;
				}
				String trans_no_9id = req.getParameter("trans_no38");
				String trans_no_9idTemp = null;
				if (!trans_no_9id.equals("")) {
					trans_no_9idTemp = trans_no_9id;
				}
				String flag_10id = req.getParameter("flag40");
				String flag_10idTemp = null;
				if (!flag_10id.equals("")) {
					flag_10idTemp = flag_10id;
				}
				String usePointOK33mtemp = cowayService1SoapProxyid.usePointOK(result_8idTemp, trans_no_9idTemp,
						flag_10idTemp);
				if (usePointOK33mtemp == null) {
					rtn = usePointOK33mtemp;
				} else {
					String tempResultreturnp34 = JspUtils.markup(String.valueOf(usePointOK33mtemp));
					rtn = tempResultreturnp34;
				}
				break;
			case 42:
				gotMethod = true;
				String trans_no_11id = req.getParameter("trans_no45");
				String trans_no_11idTemp = null;
				if (!trans_no_11id.equals("")) {
					trans_no_11idTemp = trans_no_11id;
				}
				String useamount_12id = req.getParameter("useamount47");
				String useamount_12idTemp = null;
				if (!useamount_12id.equals("")) {
					useamount_12idTemp = useamount_12id;
				}
				String id_13id = req.getParameter("id49");
				String id_13idTemp = null;
				if (!id_13id.equals("")) {
					id_13idTemp = id_13id;
				}
				String flag_14id = req.getParameter("flag51");
				String flag_14idTemp = null;
				if (!flag_14id.equals("")) {
					flag_14idTemp = flag_14id;
				}
				String cancelPoint42mtemp = cowayService1SoapProxyid.cancelPoint(trans_no_11idTemp,
						useamount_12idTemp, id_13idTemp, flag_14idTemp);
				if (cancelPoint42mtemp == null) {
					rtn = cancelPoint42mtemp;
				} else {
					String tempResultreturnp43 = JspUtils.markup(String.valueOf(cancelPoint42mtemp));
					rtn = tempResultreturnp43;
				}
				break;
			case 53:
				gotMethod = true;
				String emp_no_15id = req.getParameter("emp_no56");
				String emp_no_15idTemp = null;
				if (!emp_no_15id.equals("")) {
					emp_no_15idTemp = emp_no_15id;
				}
				String flag_16id = req.getParameter("flag58");
				String flag_16idTemp = null;
				if (!flag_16id.equals("")) {
					flag_16idTemp = flag_16id;
				}
				String getPointCW53mtemp = cowayService1SoapProxyid.getPointCW(emp_no_15idTemp, flag_16idTemp);
				if (getPointCW53mtemp == null) {
					rtn = getPointCW53mtemp;
				} else {
					String tempResultreturnp54 = JspUtils.markup(String.valueOf(getPointCW53mtemp));
					rtn = tempResultreturnp54;
				}
				break;
			case 60:
				gotMethod = true;
				String emp_no_17id = req.getParameter("emp_no63");
				String emp_no_17idTemp = null;
				if (!emp_no_17id.equals("")) {
					emp_no_17idTemp = emp_no_17id;
				}
				String use_point_18id = req.getParameter("use_point65");
				String use_point_18idTemp = null;
				if (!use_point_18id.equals("")) {
					use_point_18idTemp = use_point_18id;
				}
				String ac_sid_19id = req.getParameter("ac_sid67");
				String ac_sid_19idTemp = null;
				if (!ac_sid_19id.equals("")) {
					ac_sid_19idTemp = ac_sid_19id;
				}
				String ac_status_20id = req.getParameter("ac_status69");
				String ac_status_20idTemp = null;
				if (!ac_status_20id.equals("")) {
					ac_status_20idTemp = ac_status_20id;
				}
				String ac_add_rea_21id = req.getParameter("ac_add_rea71");
				String ac_add_rea_21idTemp = null;
				if (!ac_add_rea_21id.equals("")) {
					ac_add_rea_21idTemp = ac_add_rea_21id;
				}
				String wj_order_no_22id = req.getParameter("wj_order_no73");
				String wj_order_no_22idTemp = null;
				if (!wj_order_no_22id.equals("")) {
					wj_order_no_22idTemp = wj_order_no_22id;
				}
				String flag_23id = req.getParameter("flag75");
				String flag_23idTemp = null;
				if (!flag_23id.equals("")) {
					flag_23idTemp = flag_23id;
				}
				String setPointCW60mtemp = cowayService1SoapProxyid.setPointCW(emp_no_17idTemp, use_point_18idTemp,
						ac_sid_19idTemp, ac_status_20idTemp, ac_add_rea_21idTemp, wj_order_no_22idTemp, flag_23idTemp);
				if (setPointCW60mtemp == null) {
					rtn = setPointCW60mtemp;
				} else {
					String tempResultreturnp61 = JspUtils.markup(String.valueOf(setPointCW60mtemp));
					rtn = tempResultreturnp61;
				}
				break;
			case 77:
				gotMethod = true;
				String req_id_24id = req.getParameter("req_id80");
				String req_id_24idTemp = null;
				if (!req_id_24id.equals("")) {
					req_id_24idTemp = req_id_24id;
				}
				String flag_25id = req.getParameter("flag82");
				String flag_25idTemp = null;
				if (!flag_25id.equals("")) {
					flag_25idTemp = flag_25id;
				}
				String ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp = cowayService1SoapProxyid.ZMM_GSYS_REQ_STATUS_DISPLAY(
						req_id_24idTemp, flag_25idTemp);
				if (ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp == null) {
					rtn = ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp;
				} else {
					String tempResultreturnp78 = JspUtils.markup(String.valueOf(ZMM_GSYS_REQ_STATUS_DISPLAY77mtemp));

					rtn = tempResultreturnp78;
				}
				break;
			case 84:
				gotMethod = true;
				String i_Afnam_26id = req.getParameter("i_Afnam87");
				String i_Afnam_26idTemp = null;
				if (!i_Afnam_26id.equals("")) {
					i_Afnam_26idTemp = i_Afnam_26id;
				}
				String i_Mblnr_27id = req.getParameter("i_Mblnr89");
				String i_Mblnr_27idTemp = null;
				if (!i_Mblnr_27id.equals("")) {
					i_Mblnr_27idTemp = i_Mblnr_27id;
				}
				String i_Status_28id = req.getParameter("i_Status91");
				String i_Status_28idTemp = null;
				if (!i_Status_28id.equals("")) {
					i_Status_28idTemp = i_Status_28id;
				}
				String xmlData_29id = req.getParameter("xmlData93");
				String xmlData_29idTemp = null;
				if (!xmlData_29id.equals("")) {
					xmlData_29idTemp = xmlData_29id;
				}
				String flag_30id = req.getParameter("flag95");
				String flag_30idTemp = null;
				if (!flag_30id.equals("")) {
					flag_30idTemp = flag_30id;
				}
				String ZMM_GSYS_GIREQUEST_CHECK84mtemp = cowayService1SoapProxyid.ZMM_GSYS_GIREQUEST_CHECK(
						i_Afnam_26idTemp, i_Mblnr_27idTemp, i_Status_28idTemp, xmlData_29idTemp, flag_30idTemp);
				if (ZMM_GSYS_GIREQUEST_CHECK84mtemp == null) {
					rtn = ZMM_GSYS_GIREQUEST_CHECK84mtemp;
				} else {
					String tempResultreturnp85 = JspUtils.markup(String.valueOf(ZMM_GSYS_GIREQUEST_CHECK84mtemp));
					rtn = tempResultreturnp85;
				}
				break;
			case 97:
				gotMethod = true;
				String i_BUDAT_FROM_31id = req.getParameter("i_BUDAT_FROM100");
				String i_BUDAT_FROM_31idTemp = null;
				if (!i_BUDAT_FROM_31id.equals("")) {
					i_BUDAT_FROM_31idTemp = i_BUDAT_FROM_31id;
				}
				String i_BUDAT_TO_32id = req.getParameter("i_BUDAT_TO102");
				String i_BUDAT_TO_32idTemp = null;
				if (!i_BUDAT_TO_32id.equals("")) {
					i_BUDAT_TO_32idTemp = i_BUDAT_TO_32id;
				}
				String i_BUKRS_33id = req.getParameter("i_BUKRS104");
				String i_BUKRS_33idTemp = null;
				if (!i_BUKRS_33id.equals("")) {
					i_BUKRS_33idTemp = i_BUKRS_33id;
				}
				String i_ENAME_34id = req.getParameter("i_ENAME106");
				String i_ENAME_34idTemp = null;
				if (!i_ENAME_34id.equals("")) {
					i_ENAME_34idTemp = i_ENAME_34id;
				}
				String i_MBLNR_35id = req.getParameter("i_MBLNR108");
				String i_MBLNR_35idTemp = null;
				if (!i_MBLNR_35id.equals("")) {
					i_MBLNR_35idTemp = i_MBLNR_35id;
				}
				String i_ORGEH_36id = req.getParameter("i_ORGEH110");
				String i_ORGEH_36idTemp = null;
				if (!i_ORGEH_36id.equals("")) {
					i_ORGEH_36idTemp = i_ORGEH_36id;
				}
				String i_PERNR_37id = req.getParameter("i_PERNR112");
				String i_PERNR_37idTemp = null;
				if (!i_PERNR_37id.equals("")) {
					i_PERNR_37idTemp = i_PERNR_37id;
				}
				String i_STEXT_38id = req.getParameter("i_STEXT114");
				String i_STEXT_38idTemp = null;
				if (!i_STEXT_38id.equals("")) {
					i_STEXT_38idTemp = i_STEXT_38id;
				}
				String i_ZCODE_39id = req.getParameter("i_ZCODE116");
				String i_ZCODE_39idTemp = null;
				if (!i_ZCODE_39id.equals("")) {
					i_ZCODE_39idTemp = i_ZCODE_39id;
				}
				String flag_40id = req.getParameter("flag118");
				String flag_40idTemp = null;
				if (!flag_40id.equals("")) {
					flag_40idTemp = flag_40id;
				}
				String ZMM_GSYS_REREQUEST_DISPLAY97mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_DISPLAY(
						i_BUDAT_FROM_31idTemp, i_BUDAT_TO_32idTemp, i_BUKRS_33idTemp, i_ENAME_34idTemp,
						i_MBLNR_35idTemp, i_ORGEH_36idTemp, i_PERNR_37idTemp, i_STEXT_38idTemp, i_ZCODE_39idTemp,
						flag_40idTemp);
				if (ZMM_GSYS_REREQUEST_DISPLAY97mtemp == null) {
					rtn = ZMM_GSYS_REREQUEST_DISPLAY97mtemp;
				} else {
					String tempResultreturnp98 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_DISPLAY97mtemp));
					rtn = tempResultreturnp98;
				}
				break;
			case 120:
				gotMethod = true;
				String i_Afnam_41id = req.getParameter("i_Afnam123");
				String i_Afnam_41idTemp = null;
				if (!i_Afnam_41id.equals("")) {
					i_Afnam_41idTemp = i_Afnam_41id;
				}
				String i_Remblnr_42id = req.getParameter("i_Remblnr125");
				String i_Remblnr_42idTemp = null;
				if (!i_Remblnr_42id.equals("")) {
					i_Remblnr_42idTemp = i_Remblnr_42id;
				}
				String i_Status_43id = req.getParameter("i_Status127");
				String i_Status_43idTemp = null;
				if (!i_Status_43id.equals("")) {
					i_Status_43idTemp = i_Status_43id;
				}
				String xmlData_44id = req.getParameter("xmlData129");
				String xmlData_44idTemp = null;
				if (!xmlData_44id.equals("")) {
					xmlData_44idTemp = xmlData_44id;
				}
				String flag_45id = req.getParameter("flag131");
				String flag_45idTemp = null;
				if (!flag_45id.equals("")) {
					flag_45idTemp = flag_45id;
				}
				String ZMM_GSYS_REREQUEST_CHECK120mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_CHECK(
						i_Afnam_41idTemp, i_Remblnr_42idTemp, i_Status_43idTemp, xmlData_44idTemp, flag_45idTemp);
				if (ZMM_GSYS_REREQUEST_CHECK120mtemp == null) {
					rtn = ZMM_GSYS_REREQUEST_CHECK120mtemp;
				} else {
					String tempResultreturnp121 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_CHECK120mtemp));

					rtn = tempResultreturnp121;
				}
				break;
			case 133:
				gotMethod = true;
				String i_Bukrs_46id = req.getParameter("i_Bukrs136");
				String i_Bukrs_46idTemp = null;
				if (!i_Bukrs_46id.equals("")) {
					i_Bukrs_46idTemp = i_Bukrs_46id;
				}
				String i_Mblnr_47id = req.getParameter("i_Mblnr138");
				String i_Mblnr_47idTemp = null;
				if (!i_Mblnr_47id.equals("")) {
					i_Mblnr_47idTemp = i_Mblnr_47id;
				}
				String i_Orgeh_48id = req.getParameter("i_Orgeh140");
				String i_Orgeh_48idTemp = null;
				if (!i_Orgeh_48id.equals("")) {
					i_Orgeh_48idTemp = i_Orgeh_48id;
				}
				String i_Pernr_49id = req.getParameter("i_Pernr142");
				String i_Pernr_49idTemp = null;
				if (!i_Pernr_49id.equals("")) {
					i_Pernr_49idTemp = i_Pernr_49id;
				}
				String i_Matnr_50id = req.getParameter("i_Matnr144");
				String i_Matnr_50idTemp = null;
				if (!i_Matnr_50id.equals("")) {
					i_Matnr_50idTemp = i_Matnr_50id;
				}
				String flag_51id = req.getParameter("flag146");
				String flag_51idTemp = null;
				if (!flag_51id.equals("")) {
					flag_51idTemp = flag_51id;
				}
				String ZMM_GSYS_REREQUEST_IV_CHECK133mtemp = cowayService1SoapProxyid.ZMM_GSYS_REREQUEST_IV_CHECK(
						i_Bukrs_46idTemp, i_Mblnr_47idTemp, i_Orgeh_48idTemp, i_Pernr_49idTemp, i_Matnr_50idTemp,
						flag_51idTemp);
				if (ZMM_GSYS_REREQUEST_IV_CHECK133mtemp == null) {
					rtn = ZMM_GSYS_REREQUEST_IV_CHECK133mtemp;
				} else {
					String tempResultreturnp134 = JspUtils.markup(String.valueOf(ZMM_GSYS_REREQUEST_IV_CHECK133mtemp));
					rtn = tempResultreturnp134;
				}
				break;
			case 148:
				gotMethod = true;
				String i_Maktx_52id = req.getParameter("i_Maktx151");
				String i_Maktx_52idTemp = null;
				if (!i_Maktx_52id.equals("")) {
					i_Maktx_52idTemp = i_Maktx_52id;
				}
				String i_Matnr_53id = req.getParameter("i_Matnr153");
				String i_Matnr_53idTemp = null;
				if (!i_Matnr_53id.equals("")) {
					i_Matnr_53idTemp = i_Matnr_53id;
				}
				String i_Orgeh_54id = req.getParameter("i_Orgeh155");
				String i_Orgeh_54idTemp = null;
				if (!i_Orgeh_54id.equals("")) {
					i_Orgeh_54idTemp = i_Orgeh_54id;
				}
				String i_Zcode_55id = req.getParameter("i_Zcode157");
				String i_Zcode_55idTemp = null;
				if (!i_Zcode_55id.equals("")) {
					i_Zcode_55idTemp = i_Zcode_55id;
				}
				String flag_56id = req.getParameter("flag159");
				String flag_56idTemp = null;
				if (!flag_56id.equals("")) {
					flag_56idTemp = flag_56id;
				}
				String ZMM_GSYS_GIREQUEST_DISPLAY148mtemp = cowayService1SoapProxyid.ZMM_GSYS_GIREQUEST_DISPLAY(
						i_Maktx_52idTemp, i_Matnr_53idTemp, i_Orgeh_54idTemp, i_Zcode_55idTemp, flag_56idTemp);
				if (ZMM_GSYS_GIREQUEST_DISPLAY148mtemp == null) {
					rtn = ZMM_GSYS_GIREQUEST_DISPLAY148mtemp;
				} else {
					String tempResultreturnp149 = JspUtils.markup(String.valueOf(ZMM_GSYS_GIREQUEST_DISPLAY148mtemp));
					rtn = tempResultreturnp149;
				}
				break;
			case 161:
				gotMethod = true;
				String flag_57id = req.getParameter("flag164");
				String flag_57idTemp = null;
				if (!flag_57id.equals("")) {
					flag_57idTemp = flag_57id;
				}
				String ZMM_GSYS_ZCODE_DISPLAY161mtemp = cowayService1SoapProxyid.ZMM_GSYS_ZCODE_DISPLAY(flag_57idTemp);
				if (ZMM_GSYS_ZCODE_DISPLAY161mtemp == null) {
					rtn = ZMM_GSYS_ZCODE_DISPLAY161mtemp;
				} else {
					String tempResultreturnp162 = JspUtils.markup(String.valueOf(ZMM_GSYS_ZCODE_DISPLAY161mtemp));
					rtn = tempResultreturnp162;
				}
				break;
			case 166:
				gotMethod = true;
				String xmlData1_58id = req.getParameter("xmlData1169");
				String xmlData1_58idTemp = null;
				if (!xmlData1_58id.equals("")) {
					xmlData1_58idTemp = xmlData1_58id;
				}
				String fnc166mtemp = cowayService1SoapProxyid.fnc(xmlData1_58idTemp);
				if (fnc166mtemp == null) {
					rtn = fnc166mtemp;
				} else {
					String tempResultreturnp167 = JspUtils.markup(String.valueOf(fnc166mtemp));
					rtn = tempResultreturnp167;
				}
				break;
			}

		} catch (Exception e) {
			e.printStackTrace();
			// Exception: rtn = JspUtils.markup(e.toString()) %>
			// Message: rtn = JspUtils.markup(e.getMessage()) %>
			// return;
		}
		if (!gotMethod) {
			rtn = "result: N/A";
		}
		return rtn;
	}
}
