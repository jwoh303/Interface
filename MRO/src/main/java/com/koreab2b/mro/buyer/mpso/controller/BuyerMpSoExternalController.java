
package com.koreab2b.mro.buyer.mpso.controller;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;







import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoExternalService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.CxmlUtil;

@SuppressWarnings("unchecked")
@Controller("buyerMpSoExternalController")
public class BuyerMpSoExternalController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoExternalController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoExternalService buyerMpSoExternalService;

	@NoLoginCheck
	@RequestMapping(value = "/mpso/getKwangdongGWList.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getKwangdongGWList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		JSONObject jObj		= null;
		JSONArray jObjList	= new JSONArray();
		
		List<Map<String,String>> rtn	= buyerMpSoExternalService.getKwangdongGWList(pMap);
		
		for(Map<String, String> tMap : rtn) {
			jObj	= new JSONObject();
			jObj.putAll(tMap);
			jObjList.add(jObj);
		}
		
		_response.put("data", jObjList);
		
		return _response;
	}

	@RequestMapping(value = "/mpso/setMisumiQT.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String setMisumiQT(ModelMap pModel, @RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		
		String Rtn	= "";

		try {
			
			String st_buyer	= req.getParameter("st_buyer");
			String st_quotation_no	= req.getParameter("st_quotation_no");
			String st_quotation_seq	= req.getParameter("st_quotation_seq");
			String st_revision	= req.getParameter("st_revision");
			String st_kep_user	= req.getParameter("st_kep_user");
			String st_val	= req.getParameter("cxml-base64");

			//수신받은 xml확인
			/*
			LOGGER.debug(("st_buyer............"+st_buyer);
			LOGGER.debug(("st_quotation_no............"+st_quotation_no);
			LOGGER.debug(("st_quotation_seq............"+st_quotation_seq);
			LOGGER.debug(("st_kep_user............"+st_kep_user);
			LOGGER.debug(("st_val............\n"+ new String(Base64.decodeBase64(st_val)) );
			*/
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new ByteArrayInputStream(Base64.decodeBase64(st_val)));
			
			XPath xpath = XPathFactory.newInstance().newXPath();
			
	        NodeList col1 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemID/SupplierPartID", doc, XPathConstants.NODESET);
	        NodeList col2 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/UnitOfMeasure", doc, XPathConstants.NODESET);
	        NodeList col4 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/LeadTime", doc, XPathConstants.NODESET);
	        NodeList col5 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/URL", doc, XPathConstants.NODESET);
	        NodeList col6 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/ImageURL", doc, XPathConstants.NODESET);
	        NodeList col7 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/Extrinsic", doc, XPathConstants.NODESET);
	        NodeList col8 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn/ItemDetail/UnitPrice/Money", doc, XPathConstants.NODESET);
	        
	        String SupplierPartID = col1.item(0).getChildNodes().item(0).getNodeValue();
	        String UnitOfMeasure = col2.item(0).getChildNodes().item(0).getNodeValue();
	        String LeadTime = col4.item(0).getChildNodes().item(0).getNodeValue();
	        String URL = col5.item(0).getChildNodes().item(0).getNodeValue();
	        String ImageURL = col6.item(0).getChildNodes().item(0).getNodeValue();
	        String StoaListPrice	= col8.item(0).getChildNodes().item(0).getNodeValue();
	        String MinOrderQty = col7.item(5).getChildNodes().item(0).getNodeValue();
	        String brand = col7.item(7).getChildNodes().item(0).getNodeValue();
	        String taxRate	= col7.item(0).getChildNodes().item(0).getNodeValue();
	        String soUnitQty	= col7.item(4).getChildNodes().item(0).getNodeValue();
/*
			LOGGER.debug("SupplierPartID............"+SupplierPartID);
			LOGGER.debug("UnitOfMeasure............"+UnitOfMeasure);
			LOGGER.debug("LeadTime............"+LeadTime);
			LOGGER.debug("URL............"+URL);
			LOGGER.debug("ImageURL............"+ImageURL);
			LOGGER.debug("MinOrderQty............"+MinOrderQty);
			LOGGER.debug("brand............"+brand);
			LOGGER.debug("StoaListPrice............"+StoaListPrice);
			LOGGER.debug("taxRate............"+taxRate);
			LOGGER.debug("soUnitQty............"+soUnitQty);
*/
			Map<String, String> iMap = new HashMap<String, String>();
			
			iMap.put("BUYER", st_buyer);
			iMap.put("QUOTATION_NO", st_quotation_no);
			iMap.put("QUOTATION_SEQ", st_quotation_seq);
			iMap.put("REVISION", st_revision);
			iMap.put("RFQ_KEP_USER", st_kep_user);
			iMap.put("SELLER_ITEM_NO", SupplierPartID+"※"+brand);
			iMap.put("UNIT_MEASURE", UnitOfMeasure);
			iMap.put("LEAD_TIME", LeadTime);
			iMap.put("DETAIL_URL", URL);
			iMap.put("IMG_URL", ImageURL);
			iMap.put("MOQ", MinOrderQty);
			iMap.put("TAX_RATE", taxRate);
			iMap.put("PUR_UNIT_QTY", soUnitQty);
			iMap.put("STOA_LIST_PRICE", StoaListPrice);
			
			Rtn = buyerMpSoExternalService.setMisumiCheckOut(iMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			Rtn	= "ERROR";
		}
		
		pModel.addAttribute("RESULT", Rtn);
		
		return "master/mprq/masterMpRqQuotationMisumiReturn";
	}

	@RequestMapping(value = "/mpso/setMisumiItSave.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String setMisumiItSave(ModelMap pModel, @RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		
		String Rtn	= "";

		try {
			
			String st_buyer	= req.getParameter("st_buyer");
			String st_doc_no	= req.getParameter("st_doc_no");
			String st_user_id	= req.getParameter("st_user");
			String st_val	= req.getParameter("cxml-base64");

			//수신받은 xml확인
			LOGGER.debug("st_buyer............"+st_buyer);
			LOGGER.debug("st_doc_no............"+st_doc_no);
			LOGGER.debug("st_user_id............"+st_user_id);
			LOGGER.debug("st_val............\n"+ new String(Base64.decodeBase64(st_val)) );
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new ByteArrayInputStream(Base64.decodeBase64(st_val)));
			
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			NodeList col1 = (NodeList)xpath.evaluate("//cXML/Request/OrderRequest/ItemIn", doc, XPathConstants.NODESET);
			
	        String SupplierPartID	= "";
	        String UnitOfMeasure	= "";
	        String ManufacturerPartID	= "";
	        String LeadTime	= "";
	        String URL	= "";
	        String ImageURL	= "";
	        String StoaListPrice	= "";
	        String MinOrderQty	= "";
	        String brand	= "";
	        String taxRate	= "";
	        String SoUnitQty	= "";
	        String maker_name	= "MISUMI";
	        String specification	= "";
	        String originCode	= "";
	        String description	= "";
	        String itemQty	= "";
	        String seq	= "";
	        String BefDescSlideUPrice	= "";

        	Map<String, String> uMap	= new HashMap<String, String>();
        	Map<String, String> map	= new HashMap<String, String>();
	        if (col1.getLength() > 0 ) {
	        	map.put("st_user_id", st_user_id);
	        	uMap	= buyerMpSoExternalService.getUserInfo(map);
	        }
	        
	        List<Map<String, String>> iMaps	= new ArrayList<Map<String,String>>();
			
			for( int i = 0 ; i < col1.getLength() ; i++ ) {
				
				seq	= col1.item(i).getAttributes().item(0).getNodeValue();
				itemQty	= col1.item(i).getAttributes().item(1).getNodeValue();
				
				SupplierPartID		= col1.item(i).getChildNodes().item(1).getChildNodes().item(1).getChildNodes().item(0).getNodeValue();
				StoaListPrice		= col1.item(i).getChildNodes().item(3).getChildNodes().item(1).getChildNodes().item(1).getChildNodes().item(0).getNodeValue();
				BefDescSlideUPrice	= col1.item(i).getChildNodes().item(3).getChildNodes().item(1).getChildNodes().item(3).getChildNodes().item(0).getNodeValue();
				description			= col1.item(i).getChildNodes().item(3).getChildNodes().item(5).getChildNodes().item(1).getChildNodes().item(0).getNodeValue();
				
				UnitOfMeasure	= col1.item(i).getChildNodes().item(3).getChildNodes().item(7).getChildNodes().item(0).getNodeValue();
				LeadTime		= col1.item(i).getChildNodes().item(3).getChildNodes().item(21).getChildNodes().item(0).getNodeValue();
				URL				= col1.item(i).getChildNodes().item(3).getChildNodes().item(17).getChildNodes().item(0).getNodeValue();
				ImageURL		= col1.item(i).getChildNodes().item(3).getChildNodes().item(19).getChildNodes().item(0).getNodeValue();
				
				taxRate			= col1.item(i).getChildNodes().item(3).getChildNodes().item(25).getChildNodes().item(0).getNodeValue();
				SoUnitQty		= col1.item(i).getChildNodes().item(3).getChildNodes().item(33).getChildNodes().item(0).getNodeValue();
				MinOrderQty		= col1.item(i).getChildNodes().item(3).getChildNodes().item(35).getChildNodes().item(0).getNodeValue();
				brand			= col1.item(i).getChildNodes().item(3).getChildNodes().item(39).getChildNodes().item(0).getNodeValue();
				if (col1.item(i).getChildNodes().item(3).getChildNodes().item(53).getChildNodes().item(0) != null)
					specification	= SupplierPartID + ";" + col1.item(i).getChildNodes().item(3).getChildNodes().item(53).getChildNodes().item(0).getNodeValue().replaceAll("[|]", ";");
				else 
					specification	= SupplierPartID + "^" + brand;
				if (!"NA".equals(col1.item(i).getChildNodes().item(3).getChildNodes().item(55).getChildNodes().item(0).getNodeValue()))
					originCode	= col1.item(i).getChildNodes().item(3).getChildNodes().item(55).getChildNodes().item(0).getNodeValue();
				else
					originCode	= "Z1";

				LOGGER.debug("["+i+"]seq : " + seq);
				LOGGER.debug("["+i+"]itemQty : " + itemQty);
				LOGGER.debug("["+i+"]SupplierPartID : " + SupplierPartID);
				LOGGER.debug("["+i+"]StoaListPrice : " + StoaListPrice);
				LOGGER.debug("["+i+"]BefDescSlideUPrice : " + BefDescSlideUPrice);
				LOGGER.debug("["+i+"]description : " + description);
				LOGGER.debug("["+i+"]UnitOfMeasure : " + UnitOfMeasure);
				LOGGER.debug("["+i+"]LeadTime : " + LeadTime);
				LOGGER.debug("["+i+"]URL : " + URL);
				LOGGER.debug("["+i+"]ImageURL : " + ImageURL);
				LOGGER.debug("["+i+"]taxRate : " + taxRate);
				LOGGER.debug("["+i+"]SoUnitQty : " + SoUnitQty);
				LOGGER.debug("["+i+"]MinOrderQty : " + MinOrderQty);
				LOGGER.debug("["+i+"]brand : " + brand);
				LOGGER.debug("["+i+"]specification : " + specification);
				LOGGER.debug("["+i+"]originCode : " + originCode);
				
				Map<String, String> iMap = new HashMap<String, String>();
				
				iMap.put("st_buyer", st_buyer);
				iMap.put("QUOTATION_SEQ", seq);
				iMap.put("RECV_FLAG", "TS");
				iMap.put("st_buyer_item_no", "");
				iMap.put("st_description", description);
				iMap.put("st_specification", specification);
				iMap.put("st_unit_measure", UnitOfMeasure);
				iMap.put("st_maker_name", "MISUMI");	// MK003805
				iMap.put("st_origin_code", originCode);
				iMap.put("st_btoa_end_date", uMap.get("BTOA_END_DATE"));	// 7일 후 로 세팅...
				iMap.put("st_user_id", st_user_id);
				iMap.put("st_user_name", uMap.get("USER_NAME_LOC"));
				iMap.put("st_user_dept", uMap.get("DEPARTMENT"));
				iMap.put("st_btoa_user_tel", uMap.get("PHONE_NUMBER"));
				iMap.put("st_btoa_user_fax", uMap.get("FAX_NUMBER"));
				iMap.put("st_btoa_user_mail", uMap.get("EMAIL"));
				iMap.put("st_buyer_target_price", BefDescSlideUPrice);
				iMap.put("st_item_qty", itemQty);
				iMap.put("st_agent_name", " ");
				iMap.put("st_btoa_remark", " ");
				iMap.put("st_image_key", " ");
				iMap.put("st_req_price_type", "M");
				iMap.put("GW_NO", "");
				
				iMaps.add(iMap);
			}
			Rtn = buyerMpSoExternalService.setMisumiBuyerCheckOut(iMaps);
			
		} catch (Exception e) {
			e.printStackTrace();
			Rtn	= "ERROR";
		}
		
		
		pModel.addAttribute("RESULT", Rtn);
		
		return "master/mprq/masterMpRqQuotationMisumiReturn";
	}
	

	@RequestMapping(value = "/mprq/masterMpRqQuotationMisumiReturn.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String getmasterMpRqQuotationMisumiReq(ModelMap pModel, @RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		return "master/mprq/masterMpRqQuotationMisumiReturn";
	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setGRCompareEvent.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setGRCompareEvent(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		try {
			buyerMpSoExternalService.saveGRCompareEvent(pMap);
			_response.put("RTN_FLAG", "SUCCESS");
			_response.put("RTN_MSG", "");
		} catch (Exception e) {
			_response.put("RTN_FLAG", "FAIL");
			_response.put("RTN_MSG", e.getMessage());
		}
		
		return _response;
	}

	@NoLoginCheck
	@RequestMapping(value = "/setYPZincCartEvent.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public void setYPZincCartEvent(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		
		try {
			// 서버 운용 모두 확인 ---- 2:운영 , 0:개발
			String st_server_mode	= "0";
			st_server_mode	= CommonUtil.getDevRealLocalFlag(req);
			pMap.put("st_server_mode", st_server_mode);
			buyerMpSoExternalService.saveYPZincCartEvent(pMap);
		} catch (Exception e) {
			LOGGER.error("setYPZincCartEvent Error : " + CommonUtil.printStackTraceToString(e));			
		}
		return ;
	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getLoginXmlForSGS.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getLoginXmlForSGS(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {

		Map<String, String> retMap = new HashMap<String, String>();
		Map<String, String> reqMap = new HashMap<String, String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		
		try {

			LOGGER.debug("starts");
			
//			String st_val = req.getParameter("cxml-base64");
//
//			System.out.println("st_val : "+st_val);
			
			/* 1. XML Input 처리*/		
			
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getLoginXmlForSGS_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			/* 3. XML Data 파싱 */
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			reqMap = cxmlGenerator.parsePunchoutRequest(doc);
						
			/* 4. Data 검증 */
			
			/*
			if(!xmlMap.get("senderSharedSecret").equals("keppassword")){
				
			}
			*/
			
			/* 5. 사용자 인증 및 PO request URL 저장 */
			
			retMap = buyerMpSoExternalService.getLoginXmlForSGS(reqMap);
			
			String st_server_mode = "0";
			st_server_mode = CommonUtil.getDevRealLocalFlag(req);
			if(st_server_mode.equals("2")){
				//운영
				retMap.put("URL","https://www.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}else{
				//개발
				retMap.put("URL","http://kepdev.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			System.out.println(CommonUtil.printStackTraceToString(e));
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			retMap.put("URL","");
			
		} finally {
			
			try {
				
				if(retMap.get("LEGACY_USER_ID") == null || retMap.get("LEGACY_USER_ID").equals("")){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PUNCHOUT");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
				
				Map<String, String> logMap = new HashMap<String, String>();
				logMap.put("INTERFACE_ID", "PUNCHOUT");
				logMap.put("CONTENTS", "getLoginXmlForSGS_return_"+out.toString());
				logMap.put("FLAG", "Y");
				logMap.put("ERROR_MSG", "");
				
				buyerMpSoExternalService.saveLog(logMap);
				
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

		// pModel.addAttribute("RESULT", Rtn);
		
	}

	@NoLoginCheck
	@RequestMapping(value = "/mpso/getPurchaseOrderXmlForSGS.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getPurchaseOrderXmlForSGS(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {

		String Rtn = "";

		Map<String, String> retMap = new HashMap<String,String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		List<Map<String, String>> parsedList = new ArrayList<Map<String, String>>();
		Enumeration headerNames = req.getHeaderNames();
		Enumeration paramNames = req.getParameterNames();
		
		Map<String, String> logMap = new HashMap<String, String>();
		String headersStr1 = "";
		String headersStr2 = "";
		System.out.println("Header info Starts..");
		
		System.out.println("AuthType : " + req.getAuthType());
		System.out.println("RemoteUser : " + req.getRemoteUser());
		System.out.println("RemoteAddr : " + req.getRemoteAddr());
		System.out.println("RemoteHost : " + req.getRemoteHost());
		System.out.println("RemotePort : " + req.getRemotePort());
		System.out.println("Scheme : " + req.getScheme());
		System.out.println("isSecure : " + req.isSecure());
		
		LOGGER.info("AuthType : " + req.getAuthType());
		LOGGER.info("RemoteUser : " + req.getRemoteUser());
		LOGGER.info("RemoteAddr : " + req.getRemoteAddr());
		LOGGER.info("RemoteHost : " + req.getRemoteHost());
		LOGGER.info("RemotePort : " + req.getRemotePort());
		LOGGER.info("Scheme : " + req.getScheme());
		LOGGER.info("isSecure / " + req.isSecure());
		
		headersStr1 = headersStr1 + "AuthType : " + req.getAuthType() + "; ";
		headersStr1 = headersStr1 + "RemoteUser : " + req.getRemoteUser() + "; ";
		headersStr1 = headersStr1 + "RemoteAddr : " + req.getRemoteAddr() + "; ";
		headersStr1 = headersStr1 + "RemoteHost : " + req.getRemoteHost() + "; ";
		headersStr1 = headersStr1 + "RemotePort : " + req.getRemotePort() + "; ";
		headersStr1 = headersStr1 + "Scheme : " + req.getScheme() + "; ";
		headersStr1 = headersStr1 + "isSecure : " + req.isSecure() + "; ";
		
		while(headerNames.hasMoreElements()){
			String hName = (String)headerNames.nextElement();
			String hValue = req.getHeader(hName);
			
			System.out.println("sysout Header name : "+ hName + " / " + "Header value : " + hValue );
			LOGGER.info("logger Header name : "+ hName + " / " + "Header value : " + hValue);
			headersStr2 = headersStr2 + "Header name : "+ hName + " / " + "Header value : " + hValue + "; ";
		}
		
		System.out.println("Header info End..");
		
		System.out.println("Body parameter Starts..");
		
		while(paramNames.hasMoreElements()){
			String pName = (String)paramNames.nextElement();
			String pValue = req.getParameter(pName);
			
			System.out.println("sysout parameter name : "+ pName + " / " + "parameter value : " + pValue );
			LOGGER.info("logger parameter name : "+ pName + " / " + "parameter value : " + pValue);
			
			headersStr2 = headersStr2 + "parameter name : "+ pName + " / " + "parameter value : " + pValue + "; ";
		}
		
		System.out.println("Body parameter End..");
		
		try {
			
			logMap.clear();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_requestheader_"+headersStr1+headersStr2);
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			
			System.out.println("1. getPurchaseOrderXmlForSGS starts");
			
			/* 1. XML Input 처리*/
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"cXML.dtd\">", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			System.out.println("2. save logs_1 ");
			logMap.clear();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_1_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			XPath xpath = XPathFactory.newInstance().newXPath();
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));
			
			System.out.println("3. Order Parsing to Map");
			parsedList = cxmlGenerator.parseOrderMessage(doc);
			
			System.out.println("4. save logs_2");
			logMap.clear();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_2_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			
			String ret = "ERROR";
			
			if(parsedList.size()>0){
				ret = buyerMpSoExternalService.saveSgsPurchaseOrder(parsedList);
			}else{
				throw new Exception("can't parse po data");
			}
			
			if(ret.equals("ERROR")){
				throw new Exception("cant create po data");
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			
		} finally {
			
			try {
				
				if(retMap.isEmpty()){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PURCHASE_ORDER");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
				logMap.clear();
				logMap.put("INTERFACE_ID", "PUNCHOUT");
				logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_return_"+out.toString());
				logMap.put("FLAG", "Y");
				logMap.put("ERROR_MSG", "");
				
				buyerMpSoExternalService.saveLog(logMap);
				
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getLoginXmlForFAGB.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getLoginXmlForFAGB(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		LOGGER.info("getLoginXmlForFAGB Start");
		Map<String, String> retMap = new HashMap<String, String>();
		Map<String, String> reqMap = new HashMap<String, String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		
		try {

			LOGGER.debug("starts");
						
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getLoginXmlForFAGB_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			/* 3. XML Data 파싱 */
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			reqMap = cxmlGenerator.parsePunchoutRequest(doc);
			
			/* 5. 사용자 인증 및 PO request URL 저장 */
			
			retMap = buyerMpSoExternalService.getLoginXmlForFAGB(reqMap);
			
			String st_server_mode = "0";
			st_server_mode = CommonUtil.getDevRealLocalFlag(req);
			if(st_server_mode.equals("2")){
				//운영
				retMap.put("URL","https://www.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}else{
				//개발
				retMap.put("URL","http://kepdev.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			System.out.println(CommonUtil.printStackTraceToString(e));
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			retMap.put("URL","");
			
		} finally {
			
			try {
				
				if(retMap.get("LEGACY_USER_ID") == null || retMap.get("LEGACY_USER_ID").equals("")){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PUNCHOUT");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
				
				Map<String, String> logMap = new HashMap<String, String>();
				logMap.put("INTERFACE_ID", "PUNCHOUT");
				logMap.put("CONTENTS", "getLoginXmlForFAGB_return_"+out.toString());
				logMap.put("FLAG", "Y");
				logMap.put("ERROR_MSG", "");
				
				buyerMpSoExternalService.saveLog(logMap);
				
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

		// pModel.addAttribute("RESULT", Rtn);
		
	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getLoginXmlForPMK.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getLoginXmlForPMK(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		LOGGER.info("getLoginXmlForPMK Start");
		Map<String, String> retMap = new HashMap<String, String>();
		Map<String, String> reqMap = new HashMap<String, String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		
		try {

			LOGGER.debug("starts");
						
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getLoginXmlForPMK_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			/* 3. XML Data 파싱 */
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			reqMap = cxmlGenerator.parsePunchoutRequest(doc);
			
			/* 5. 사용자 인증 및 PO request URL 저장 */
			
			retMap = buyerMpSoExternalService.getLoginXmlForPMK(reqMap);
			
			String st_server_mode = "0";
			st_server_mode = CommonUtil.getDevRealLocalFlag(req);
			if(st_server_mode.equals("2")){
				//운영
				retMap.put("URL","https://www.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}else{
				//개발
				retMap.put("URL","http://kepdev.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			System.out.println(CommonUtil.printStackTraceToString(e));
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			retMap.put("URL","");
			
		} finally {
			
			try {
				
				if(retMap.get("LEGACY_USER_ID") == null || retMap.get("LEGACY_USER_ID").equals("")){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PUNCHOUT");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
				
				Map<String, String> logMap = new HashMap<String, String>();
				logMap.put("INTERFACE_ID", "PUNCHOUT");
				logMap.put("CONTENTS", "getLoginXmlForPMK_return_"+out.toString());
				logMap.put("FLAG", "Y");
				logMap.put("ERROR_MSG", "");
				
				buyerMpSoExternalService.saveLog(logMap);
				
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

		// pModel.addAttribute("RESULT", Rtn);
		
	}
	@NoLoginCheck
	@RequestMapping(value = "/mpso/createLoginForYHKB.do", method = { RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> createLoginForYHKB(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
			
		try {
			String result = buyerMpSoExternalService.saveYhkbSignUp(pMap);
			if(result.equals("OK")) {
				returnMap.put("resultCode", "OK");
				returnMap.put("URL", "http://www.koreab2b.com/sso_login.jsp?st_com_code="+pMap.get("st_buyer")+"&st_user_id="+pMap.get("st_legacy_user_id"));
			} else {
				returnMap.put("resultCode", "ERROR");
				returnMap.put("URL", "");
			}
			
		} catch (Exception e) {
			LOGGER.error("createLoginForYHKB ERROR !!!: ", e);
			returnMap.put("resultCode", "ERROR");
			returnMap.put("URL", "");
		}
		
		return returnMap;
		
	}
	
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getLoginXmlForYHKB.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getLoginXmlForYHKB(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		LOGGER.info("getLoginXmlForYHKB Start");
		Map<String, String> retMap = new HashMap<String, String>();
		Map<String, String> reqMap = new HashMap<String, String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		
		try {

			LOGGER.debug("starts");
						
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getLoginXmlForYHKB_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			/* 3. XML Data 파싱 */
			
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			XPath xpath = XPathFactory.newInstance().newXPath();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			reqMap = cxmlGenerator.parsePunchoutRequest(doc);
			
			/* 5. 사용자 인증 및 PO request URL 저장 */
			
			retMap = buyerMpSoExternalService.getLoginXmlForYHKB(reqMap);		
			
			
			String st_server_mode = "0";
			st_server_mode = CommonUtil.getDevRealLocalFlag(req);
			if(st_server_mode.equals("2")){
				//운영
				retMap.put("URL","https://www.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}else{
				//개발
				retMap.put("URL","http://kepdev.koreab2b.com/sso_login.jsp?st_com_code="+retMap.get("COM_CODE")+"&st_user_id="+retMap.get("LEGACY_USER_ID"));
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
			System.out.println(CommonUtil.printStackTraceToString(e));
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			retMap.put("URL","");
			
		} finally {
			
			try {
				
				if(retMap.get("LEGACY_USER_ID") == null || retMap.get("LEGACY_USER_ID").equals("")){
					retMap.put("CODE", "200");
					retMap.put("TEXT", "OK");
					retMap.put("URL","https://www.koreab2b.com/yhkb_login_test.jsp?st_email="+reqMap.get("contactEmail")+"&st_user_name_loc="+reqMap.get("contactName")+"&st_legacy_user_id="+reqMap.get("requestExtrinsicName"));
					Map<String, String> logMap = new HashMap<String, String>();
					logMap.put("INTERFACE_ID", "PUNCHOUT");
					logMap.put("CONTENTS", "signUpYHKB_st_email="+reqMap.get("contactEmail")+"&buyerCookie="+reqMap.get("buyerCookie")+"&browserFormPosURL="+reqMap.get("browserFormPosURL"));
					logMap.put("FLAG", "Y");
					logMap.put("ERROR_MSG", "");
					buyerMpSoExternalService.saveLog(logMap);
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PUNCHOUT");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
				
				Map<String, String> logMap = new HashMap<String, String>();
				logMap.put("INTERFACE_ID", "PUNCHOUT");
				logMap.put("CONTENTS", "getLoginXmlForYHKB_return_"+out.toString());
				logMap.put("FLAG", "Y");
				logMap.put("ERROR_MSG", "");
				
				buyerMpSoExternalService.saveLog(logMap);
				
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

		// pModel.addAttribute("RESULT", Rtn);
		
	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getPurchaseOrderXmlForFAGB.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getPurchaseOrderXmlForFAGB(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {

		Map<String, String> retMap = new HashMap<String,String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		List<Map<String, String>> parsedList = new ArrayList<Map<String, String>>();
		
		String remoteAddr = "";
		
		remoteAddr = req.getRemoteAddr();
		
		
		
		try {
			System.out.println("1. getPurchaseOrderXmlForFAGB starts");
			
			
			
			/* 1. XML Input 처리*/
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"cXML.dtd\">", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForFAGB_1_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", remoteAddr);			
			
			buyerMpSoExternalService.saveLog(logMap);

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			parsedList = cxmlGenerator.parseOrderMessageFagb(doc);  
			
					
			
			buyerMpSoExternalService.saveLog(logMap);
			
			String ret = "ERROR";
			
			if(parsedList.size()>0){
				ret = buyerMpSoExternalService.saveFagbPurchaseOrder(parsedList);
			}else{
				throw new Exception("can't parse po data");
			}
			
			
			if(ret.equals("ERROR")){
				throw new Exception("cant create po data");
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error("Step 1. " + e.getMessage());
			
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			
		} finally {
			
			try {
				
				if(retMap.isEmpty()){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PURCHASE_ORDER");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
								
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getPurchaseOrderXmlForPMK.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getPurchaseOrderXmlForPMK(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {

		Map<String, String> retMap = new HashMap<String,String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		List<Map<String, String>> parsedList = new ArrayList<Map<String, String>>();
		
		String remoteAddr = "";
		
		remoteAddr = req.getRemoteAddr();
		
		
		
		try {
			System.out.println("1. getPurchaseOrderXmlForPMK starts");
			
			
			
			/* 1. XML Input 처리*/
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"cXML.dtd\">", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForPMK_1_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", remoteAddr);			
			
			buyerMpSoExternalService.saveLog(logMap);

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			parsedList = cxmlGenerator.parseOrderMessageFagb(doc);  
			
					
			
			buyerMpSoExternalService.saveLog(logMap);
			
			String ret = "ERROR";
			
			if(parsedList.size()>0){
				ret = buyerMpSoExternalService.savePMKPurchaseOrder(parsedList);
			}else{
				throw new Exception("can't parse po data");
			}
			
			
			if(ret.equals("ERROR")){
				throw new Exception("cant create po data");
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error("Step 1. " + e.getMessage());
			
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			
		} finally {
			
			try {
				
				if(retMap.isEmpty()){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PURCHASE_ORDER");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
								
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getPurchaseOrderXmlForYHKB.do", method = { RequestMethod.POST })
	@ResponseBody
	public void getPurchaseOrderXmlForYHKB(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {

		Map<String, String> retMap = new HashMap<String,String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		List<Map<String, String>> parsedList = new ArrayList<Map<String, String>>();
		
		String remoteAddr = "";
		
		remoteAddr = req.getRemoteAddr();
		
		
		
		try {
			System.out.println("1. getPurchaseOrderXmlForYHKB starts");
			
			
			
			/* 1. XML Input 처리*/
			String ts = null;
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), "UTF-8"));
			
			/* 2. Input XML의 BOM 제거 */
			while ((ts = br.readLine()) != null) {
				ts = ts.replace("EEBBBF", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"cXML.dtd\">", "");
				ts = ts.replace("<!DOCTYPE cXML SYSTEM \"http://xml.cxml.org/schemas/cXML/1.1.007/cXML.dtd\">", "");
				sb.append(ts);
			}
			
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForYHKB_1_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", remoteAddr);			
			
			buyerMpSoExternalService.saveLog(logMap);

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			parsedList = cxmlGenerator.parseOrderMessageYHKB(doc);  
			
					
			
			buyerMpSoExternalService.saveLog(logMap);
			
			String ret = "ERROR";
			
			if(parsedList.size()>0){
				ret = buyerMpSoExternalService.saveYHKBPurchaseOrder(parsedList);
			}else{
				throw new Exception("can't parse po data");
			}
			
			
			if(ret.equals("ERROR")){
				throw new Exception("cant create po data");
			}
			
			retMap.put("CODE", "200");
			retMap.put("TEXT", "OK");
			
		} catch (Exception e) {
			LOGGER.error("Step 1. " + e.getMessage());
			
			retMap.put("CODE", "400");
			retMap.put("TEXT", "Bad Request");
			
		} finally {
			
			try {
				
				if(retMap.isEmpty()){
					retMap.put("CODE", "406");
					retMap.put("TEXT", "Not Acceptable");
					retMap.put("URL","");
				}
				
				/* 6. Response 생성 */
				responseDoc = cxmlGenerator.createResponse(retMap, "PURCHASE_ORDER");
				
				Transformer tf = TransformerFactory.newInstance().newTransformer();
				tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
				tf.setOutputProperty(OutputKeys.INDENT,"yes");
				Writer out = new StringWriter();
				tf.transform(new DOMSource(responseDoc), new StreamResult(out));
				
								
				/* 7. Response 전달 */
				resp.setContentType("application/xml");
				resp.setCharacterEncoding("utf-8");
				resp.setHeader("Cache-Control", "no-cache");
				resp.getWriter().print(out.toString());
				
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
			}
		}

	}
	
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getWhaninPrXml.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public void getWhaninPrXml(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		
		Map<String, Object> _response = new HashMap<String, Object>();

		Document responseDoc = null;
		
		System.out.println("PR_NO : "+pMap.get("PR_NO"));
		System.out.println("BUYER : "+pMap.get("BUYER"));
				
		List<Map<String,String>> rtn	= buyerMpSoExternalService.getWhaninPrList(pMap);
		DocumentBuilderFactory factory;
		DocumentBuilder builder; 
		
		Writer out = null;
		
		try {
			
			factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
			responseDoc =  builder.newDocument();
			
			responseDoc = createWhaninPrXml(rtn);
			
			Transformer tf = TransformerFactory.newInstance().newTransformer();
			tf.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
			tf.setOutputProperty(OutputKeys.INDENT,"yes");
			out = new StringWriter();
			tf.transform(new DOMSource(responseDoc), new StreamResult(out));
			
			/* 7. Response 전달 */
			resp.setContentType("application/xml");
			resp.setCharacterEncoding("utf-8");
			resp.setHeader("Cache-Control", "no-cache");
			resp.getWriter().print(out.toString());
			
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}
	}
	
	public Document createWhaninPrXml(List<Map<String, String>> pMaps) throws Exception {
		
		DocumentBuilderFactory factory;
		DocumentBuilder builder;
		
		factory = DocumentBuilderFactory.newInstance();
		builder = factory.newDocumentBuilder();
				
		Document xmlDoc = builder.newDocument();
		
		// xml Root Element 생성
		Element root	= xmlDoc.createElement("ITEM_LIST");
		
		xmlDoc.appendChild(root);
		
		/*xml구성*/
		for(int i=0; i<pMaps.size(); i++){
			
			Map<String, String> pMap = pMaps.get(i);
			
			Element item = xmlDoc.createElement("ITEM");
			
			Element buyer = xmlDoc.createElement("BUYER");
			Element pr_no = xmlDoc.createElement("PR_NO");
			Element pr_seq = xmlDoc.createElement("PR_SEQ");
			Element buyer_item_no = xmlDoc.createElement("BUYER_ITEM_NO");
			Element add_date = xmlDoc.createElement("ADD_DATE");
			Element add_time = xmlDoc.createElement("ADD_TIME");
			Element description = xmlDoc.createElement("DESCRIPTION");
			Element specification = xmlDoc.createElement("SPECIFICATION");
			Element unit_measure = xmlDoc.createElement("UNIT_MEASURE");
			Element item_qty = xmlDoc.createElement("ITEM_QTY");
			Element unit_price = xmlDoc.createElement("UNIT_PRICE");
			Element item_amt = xmlDoc.createElement("ITEM_AMT");
			Element rd_date = xmlDoc.createElement("RD_DATE");
			
			
			buyer.setTextContent(pMap.get("BUYER"));
			pr_no.setTextContent(pMap.get("PR_NO"));
			pr_seq.setTextContent(pMap.get("PR_SEQ"));
			buyer_item_no.setTextContent(pMap.get("BUYER_ITEM_NO"));
			add_date.setTextContent(pMap.get("ADD_DATE"));
			add_time.setTextContent(pMap.get("ADD_TIME"));
			description.setTextContent(pMap.get("DESCRIPTION"));
			specification.setTextContent(pMap.get("SPECIFICATION"));
			unit_measure.setTextContent(pMap.get("UNIT_MEASURE"));
			item_qty.setTextContent(String.valueOf(pMap.get("ITEM_QTY")));
			unit_price.setTextContent(String.valueOf(pMap.get("UNIT_PRICE")));
			item_amt.setTextContent(String.valueOf(pMap.get("ITEM_AMT")));
			rd_date.setTextContent(String.valueOf(pMap.get("RD_DATE")));
			
			item.appendChild(buyer);
			item.appendChild(pr_no);
			item.appendChild(pr_seq);
			item.appendChild(buyer_item_no);
			item.appendChild(add_date);
			item.appendChild(add_time);
			item.appendChild(description);
			item.appendChild(specification);
			item.appendChild(unit_measure);
			item.appendChild(item_qty);
			item.appendChild(unit_price);
			item.appendChild(item_amt);
			item.appendChild(rd_date);
			
			root.appendChild(item);
		}

		return xmlDoc;
	}

	// 엔씨켐 결재 상신 정보 
	@RequestMapping(value = "/mpso/getNCCHAppReq.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String getNCCHAppReq(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		pMap = CommonUtil.PagingPrc(pMap);
		List<Map<String, String>> _Hdata = null;
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("pr_no", req.getParameter("pr_no"));
		
		String opFlag = CommonUtil.getDevRealLocalFlag(req);
		pMap.put("opFlag",opFlag);
		
		List<Map<String, String>> _data = buyerMpSoExternalService.getNCCHAppReqList(pMap);
		
		pModel.addAttribute("AppData", _data);
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "buyer/mpso/buyerMpSoNCCHAppReq_v2";
		}else{
			return "buyer/mpso/buyerMpSoNCCHAppReq";
		}
	}
	
	/**
	 * 엔씨템 결재 후처리 로직 추가.
	 * @param pMap
	 * @param req
	 * @return
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setExternNCCHApproval.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setExternApproval(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String rtnMsg	= buyerMpSoExternalService.setExternNCCHApproval(pMap);
		
		_response.put("message", rtnMsg);
		
		return _response;
	}
	/**
	 * 큐라티스 - hiworks
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/quratis_callback.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public void setQuratisCallback(@RequestParam Map<String, String> pMap, HttpServletRequest req) throws IOException {
		
		// pMap : office_id={오피스고유번호}&approval_key={문서 KEY}&approval_id={문서 아이디}&approval_code={문서 번호}&state={기안 상태}&request_hash={해쉬값} 
		
		System.out.println("pMap : " + pMap);
		String [] request_hash = pMap.get("request_hash").split("\\^");
		
		pMap.put("BUYER",request_hash[0]);
		pMap.put("PR_NO",request_hash[1]);
		
		buyerMpSoExternalService.setQuratisCallbackList(pMap);
		
	}
	
	/**
	 * 큐라티스
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/quratisBizboxCallback.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setQuratisBizBoxCallback(@RequestBody Map<String, Object> pMap, HttpServletRequest req) throws IOException {
		
		Map<String, Object> rtn = new HashMap<String, Object>();
		
		/* pMap : "bodyMap":{"erpCompSeq":"", "processId":"", "approKey":"", "compSeq":"", "docSts":"", 
		 *                   "deptSeq":"","erpEmpSeq":"", "langCode":"", "groupSeq":"", "formId":"", 
		 *                   "empSeq":"", docTitle":"", "userId":"", "docId":"", "userSe":"", "bizSeq":""} 
		 */
		/* STATUS : 10/임시보관, 20/상신, 30/진행, 100/반려, 90/종결 */
		// TODO : buyer, pr_no는 어떻게 구하지?
		try {
			
			System.out.println("pMap : " + pMap);
			
			String status = (String)pMap.get("docSts");
			String approKey = (String)pMap.get("approKey");	// BUYER + PR_NO
			String approval_id = (String)pMap.get("docId");	// 용도
			
			Map<String, String> iMap = new HashMap<String, String>();
			
			iMap.put("STATUS",status);
			iMap.put("approval_id",approval_id);
			iMap.put("BUYER",approKey.substring(0, 10));
			iMap.put("PR_NO",approKey.substring(10, 20));
			
			System.out.println("iMap : " + iMap);
			
			buyerMpSoExternalService.setQuratisBizboxCallbackList(iMap);
			rtn.put("resultCode", "SUCCESS");	// 상태값 확인
			rtn.put("resultMessage", "성공했습니다.");	// 메세지?
		} catch (Exception e) {
			rtn.put("resultCode", "FAIL");
			rtn.put("resultMessage", e.getMessage());	// 메세지?
			LOGGER.error("Bizbox Error" + CommonUtil.printStackTraceToString(e));
		}
		
		return rtn;
	}
	/**
	 * 홍익대학교
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setApprovalHongIk.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String setHongikCallback(@RequestParam Map<String, String> pMap, HttpServletRequest req) throws IOException {
		
		String rtn = "";
		
		try {
			if (pMap == null || pMap.isEmpty()) {
				rtn = "FAIL";
			} else {
				//https://www.koreab2.com/mpso/setApprovalHongIk.do?st_connkey=KRHONG0020_PR21000001&st_status=XX
				String [] st_connkey = pMap.get("st_connkey").split("_");
				
				pMap.put("BUYER",st_connkey[0]);
				pMap.put("PR_NO",st_connkey[1]);
				
				buyerMpSoExternalService.setHongIkCallbackList(pMap);
				
				rtn = "OK";
			}
		} catch (Exception e) {
			rtn = "FAIL";
		}
		
		return rtn;
	}
	
	/**
	 * 엘앤에프
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setLnfAppSend.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public List<Map<String,String>> setLnfAppSend(@RequestParam Map<String, String> pMap, HttpServletRequest req) throws IOException {
		
		List<Map<String,String>> rtn = buyerMpSoExternalService.setLnfAppSendList(pMap);
		
		System.out.println("LNF rtn : " + rtn);
		
		return rtn;
	}
	
	/**
	 * 엘앤에프
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setLnfAppStatus.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String setLnfAppStatus(@RequestParam Map<String, String> pMap, HttpServletRequest req) throws IOException {
		
		String str = "";
		
		pMap.put("PR_NO", pMap.get("DOC_NO"));
		System.out.println("LNF pmap : " + pMap);
		try {
			buyerMpSoExternalService.setLnfCallbackList(pMap);
			str = "OK";
		} catch (Exception e) {
			str = "FAIL";
		}
		return str;
	}
	
	
	/**
	 * 솔브레인
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setSoulbrainMsdsStatus.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setSoulbrainMsdsStatus(@RequestParam Map<String, String> pMap, HttpServletRequest req) throws IOException {
		//KEY_ID , STATUS, MSG 
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		System.out.println("Soulbrain pmap : " + pMap);
		try {
			buyerMpSoExternalService.setSoulbrainMsdsStatus(pMap);
			returnMap.put("CODE", "OK");
		} catch (Exception e) {
			returnMap.put("CODE","FAIL");
			returnMap.put("MSG", "data error");
			LOGGER.error("Soulbrain Error : " + CommonUtil.printStackTraceToString(e));
		}
		return returnMap;
	}
	
	
	/**
	 * 애경
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setAeKyAppStatus.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String setAeKyAppStatus(@RequestParam Map<String, Object> pMap, HttpServletRequest req) throws IOException {
		
		String str = "";
		String type = "PR";
		try {
			buyerMpSoExternalService.setAeKyAppStatus(pMap, type);
			str = "OK";
		} catch (Exception e) {
			str = "FAIL";
		}
		return str;
	}
	/**
	 * (주) 한화 사용자 조회. 한번에 1명만 조회 가능.
	 * @param req
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getHanwhaUserInfo.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String getHanwhaUserInfo(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getHanwhaUserInfo 요청 파라미터 for jsp : {}", pMap); 

		String _endPoint = "";
		String _mode = CommonUtil.getDevRealLocalFlag(req);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String comCode = _sessionInfo.getComCode();
		String testUserId = _sessionInfo.getUserId();

		Map<String, String> slgMap = CommonUtil.getSpecialCheckReturnMap(comCode, "P11-0000004");
		
		String _plant = pMap.get("PLANT");
		
		if ( slgMap != null ) {
			_endPoint = slgMap.get("COL02_DATA");
		} else {			
			throw new RuntimeException("조회된 endPoint 정보가 없습니다.");
		}
		_endPoint = _endPoint + _plant;
		
		LOGGER.debug("getHanwhaUserInfo endpoint : " + _endPoint);
		
		com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.vo.OrgUserVO[] users = null;
		com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy proxy = new com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy(_endPoint);
		
		//클래버스 조직정보
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.vo.OrgUserVO[] cleverseUsers = null;
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.service.NeoOrgWsProxy cleverseProxy = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.service.NeoOrgWsProxy(_endPoint);
				
		String _gubun = pMap.get("USER_FLAG");
		List<Map<String, String>> _data = new ArrayList<Map<String,String>>();
		if(!_plant.equals("501")) { // 기계, 글로벌
			
			try {
				if ("NAME".equals(_gubun)) {
					users = proxy.searchUserByUserName(pMap.get("USER_NAME_LOC"));	
				} else if ("EMPNO".equals(_gubun)) {
					users = proxy.searchUserByEmpolyeeNo(pMap.get("USER_NAME_LOC"));	
				} else if ("ID".equals(_gubun)) {
					users = proxy.searchUserByUserId(pMap.get("USER_NAME_LOC"));	
				}
				
				if ( users.length > 0 ) {
					for ( int k = 0 ; k < users.length ; k++) {
						Map<String, String> neoMap = new HashMap<String, String>();
						neoMap.put("COM_CODE", comCode);
						neoMap.put("USER_NAME_LOC", users[k].getUserName());			// 이름
						neoMap.put("LEGACY_USER_ID", users[k].getUserId());				// ID
						neoMap.put("POSITION_CODE", users[k].getJobPositionId());		// 직급코드
						neoMap.put("POSITION", users[k].getJobPositionName());			// 직급명
						neoMap.put("POSITION_EN", users[k].getJobPositionNameEn());		// 직급명(영문)
						neoMap.put("PLANT", users[k].getCompanyId());					// 플랜트
						neoMap.put("EMP_NO", users[k].getEmployeeNo());					// 사번
						neoMap.put("DEPARTMENT", users[k].getDeptName());				// 부서명
						neoMap.put("DEPT_CODE",users[k].getDeptCode());					// 부서코드
						neoMap.put("DEPT_ID",users[k].getDeptId());						// 부서아이디
						neoMap.put("DEPT_PATH", users[k].getDeptFullPath());			// 부서패스
						neoMap.put("DEPT_EN", users[k].getDeptNameEn());				// 부서영문
						neoMap.put("ADDRESS", "서울시 중구 청계천로 86(장교동) 한화빌딩");			// 주소
						
						// EAI.HANWHA_USER - 시스템에 등록된 사용자 및 결재자의 정보를 저장한다. 
						//Map<String, String> rMap = buyerMpSoExternalService.setHanwhaUser(pMap); 
						_data.add(neoMap);
					}
				}
			} catch (Exception e) {
				LOGGER.error("Error : " + CommonUtil.printStackTraceToString(e));
			}
	
			pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
			pModel.addAttribute("result","S");
		} else { // 한화 에어로스페이스
			try {
				if ("NAME".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByUserName(pMap.get("USER_NAME_LOC"));	
				} else if ("EMPNO".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByEmpolyeeNo(pMap.get("USER_NAME_LOC"));	
				} else if ("ID".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByUserId(pMap.get("USER_NAME_LOC"));	
				}
				
				if ( cleverseUsers.length > 0 ) {
					for ( int k = 0 ; k < cleverseUsers.length ; k++) {
						Map<String, String> neMap = new HashMap<String, String>();
						neMap.put("COM_CODE", comCode);
						neMap.put("USER_NAME_LOC", cleverseUsers[k].getUserName());			// 이름
						neMap.put("LEGACY_USER_ID", cleverseUsers[k].getUserId());			// ID
						neMap.put("POSITION_CODE", cleverseUsers[k].getJobPositionId());	// 직급코드
						neMap.put("POSITION", cleverseUsers[k].getJobPositionName());		// 직급명
						neMap.put("POSITION_EN", cleverseUsers[k].getJobPositionNameEn());	// 직급명
						neMap.put("PLANT", cleverseUsers[k].getCompanyId());				// 플랜트
						neMap.put("EMP_NO", cleverseUsers[k].getEmployeeNo());				// 사번
						neMap.put("DEPARTMENT", cleverseUsers[k].getDeptName());			// 부서명
						neMap.put("DEPT_CODE",cleverseUsers[k].getDeptCode());				// 부서코드
						neMap.put("DEPT_ID",cleverseUsers[k].getDeptId());					// 부서아이디
						neMap.put("DEPT_PATH", cleverseUsers[k].getDeptFullPath());			// 부서패스
						neMap.put("DEPT_EN", cleverseUsers[k].getDeptNameEn());				// 부서영문
						neMap.put("ADDRESS", "서울시 중구 청계천로 86(장교동) 한화빌딩");				// 주소
						
						// EAI.HANWHA_USER - 시스템에 등록된 사용자 및 결재자의 정보를 저장한다. 
						//Map<String, String> rMap = buyerMpSoExternalService.setHanwhaUser(pMap);
						_data.add(neMap);
					}
				}
			} catch (Exception e) {
				LOGGER.error("Error : " + CommonUtil.printStackTraceToString(e));
			}
			pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
			pModel.addAttribute("result","S");
		}
		
		return "common/popup/approvalHanwhaHumanEditPop";
	}
	@RequestMapping(value = "/mpso/getHanwhaUserInfo_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getHanwhaUserInfo_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		LOGGER.debug("getHanwhaUserInfo 요청 파라미터 for jsp : {}", pMap); 

		Map<String,String> param = new HashMap<String, String>();
		//Map<String,Object> 를 Map<String,String>으로 변환
		for(Map.Entry<String, Object> entry : pMap.entrySet()){
			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
		}
		
		String _endPoint = "";
		String _mode = CommonUtil.getDevRealLocalFlag(req);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String comCode = _sessionInfo.getComCode();
		String testUserId = _sessionInfo.getUserId();

		Map<String, String> slgMap = CommonUtil.getSpecialCheckReturnMap(comCode, "P11-0000004");
		
		String _plant = param.get("PLANT");
		
		if ( slgMap != null ) {
			_endPoint = slgMap.get("COL02_DATA");
		} else {			
			throw new RuntimeException("조회된 endPoint 정보가 없습니다.");
		}
		_endPoint = _endPoint + _plant;
		
		LOGGER.debug("getHanwhaUserInfo endpoint : " + _endPoint);
		
		com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.vo.OrgUserVO[] users = null;
		com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy proxy = new com.koreab2b.mro.webservice.hanwha.neo.branch.ss.org.service.NeoOrgWsProxy(_endPoint);
		
		//클래버스 조직정보
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.vo.OrgUserVO[] cleverseUsers = null;
		com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.service.NeoOrgWsProxy cleverseProxy = new com.koreab2b.mro.webservice.hanwhaCleverse.neo.branch.ss.org.service.NeoOrgWsProxy(_endPoint);
				
		String _gubun = param.get("USER_FLAG");
		List<Map<String, String>> _data = new ArrayList<Map<String,String>>();
		if(!_plant.equals("501")) { // 기계, 글로벌
			
			try {
				if ("NAME".equals(_gubun)) {
					users = proxy.searchUserByUserName(param.get("USER_NAME_LOC"));	
				} else if ("EMPNO".equals(_gubun)) {
					users = proxy.searchUserByEmpolyeeNo(param.get("USER_NAME_LOC"));	
				} else if ("ID".equals(_gubun)) {
					users = proxy.searchUserByUserId(param.get("USER_NAME_LOC"));	
				}
				
				if ( users.length > 0 ) {
					for ( int k = 0 ; k < users.length ; k++) {
						Map<String, String> neoMap = new HashMap<String, String>();
						neoMap.put("COM_CODE", comCode);
						neoMap.put("USER_NAME_LOC", users[k].getUserName());			// 이름
						neoMap.put("LEGACY_USER_ID", users[k].getUserId());				// ID
						neoMap.put("POSITION_CODE", users[k].getJobPositionId());		// 직급코드
						neoMap.put("POSITION", users[k].getJobPositionName());			// 직급명
						neoMap.put("POSITION_EN", users[k].getJobPositionNameEn());		// 직급명(영문)
						neoMap.put("PLANT", users[k].getCompanyId());					// 플랜트
						neoMap.put("EMP_NO", users[k].getEmployeeNo());					// 사번
						neoMap.put("DEPARTMENT", users[k].getDeptName());				// 부서명
						neoMap.put("DEPT_CODE",users[k].getDeptCode());					// 부서코드
						neoMap.put("DEPT_ID",users[k].getDeptId());						// 부서아이디
						neoMap.put("DEPT_PATH", users[k].getDeptFullPath());			// 부서패스
						neoMap.put("DEPT_EN", users[k].getDeptNameEn());				// 부서영문
						neoMap.put("ADDRESS", "서울시 중구 청계천로 86(장교동) 한화빌딩");			// 주소
						
						// EAI.HANWHA_USER - 시스템에 등록된 사용자 및 결재자의 정보를 저장한다. 
						//Map<String, String> rMap = buyerMpSoExternalService.setHanwhaUser(pMap); 
						_data.add(neoMap);
					}
				}
			} catch (Exception e) {
				LOGGER.error("Error : " + CommonUtil.printStackTraceToString(e));
			}
	
		} else { // 한화 에어로스페이스
			try {
				if ("NAME".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByUserName(param.get("USER_NAME_LOC"));	
				} else if ("EMPNO".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByEmpolyeeNo(param.get("USER_NAME_LOC"));	
				} else if ("ID".equals(_gubun)) {
					cleverseUsers = cleverseProxy.searchUserByUserId(param.get("USER_NAME_LOC"));	
				}
				
				if ( cleverseUsers.length > 0 ) {
					for ( int k = 0 ; k < cleverseUsers.length ; k++) {
						Map<String, String> neMap = new HashMap<String, String>();
						neMap.put("COM_CODE", comCode);
						neMap.put("USER_NAME_LOC", cleverseUsers[k].getUserName());			// 이름
						neMap.put("LEGACY_USER_ID", cleverseUsers[k].getUserId());			// ID
						neMap.put("POSITION_CODE", cleverseUsers[k].getJobPositionId());	// 직급코드
						neMap.put("POSITION", cleverseUsers[k].getJobPositionName());		// 직급명
						neMap.put("POSITION_EN", cleverseUsers[k].getJobPositionNameEn());	// 직급명
						neMap.put("PLANT", cleverseUsers[k].getCompanyId());				// 플랜트
						neMap.put("EMP_NO", cleverseUsers[k].getEmployeeNo());				// 사번
						neMap.put("DEPARTMENT", cleverseUsers[k].getDeptName());			// 부서명
						neMap.put("DEPT_CODE",cleverseUsers[k].getDeptCode());				// 부서코드
						neMap.put("DEPT_ID",cleverseUsers[k].getDeptId());					// 부서아이디
						neMap.put("DEPT_PATH", cleverseUsers[k].getDeptFullPath());			// 부서패스
						neMap.put("DEPT_EN", cleverseUsers[k].getDeptNameEn());				// 부서영문
						neMap.put("ADDRESS", "서울시 중구 청계천로 86(장교동) 한화빌딩");				// 주소
						
						// EAI.HANWHA_USER - 시스템에 등록된 사용자 및 결재자의 정보를 저장한다. 
						//Map<String, String> rMap = buyerMpSoExternalService.setHanwhaUser(pMap);
						_data.add(neMap);
					}
				}
			} catch (Exception e) {
				LOGGER.error("Error : " + CommonUtil.printStackTraceToString(e));
			}
		}
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	//한화 결재자 선택 시 로직
	@RequestMapping(value = "/mpso/saveHanwhaUserInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveHanwhaUserInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		String flag = "Y";

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> userMap = new HashMap<String, String>();
		
		String[] userInfo = pMap.get("checkbox" +pMap.get("index")).split("@");
		
		userMap.put("COM_CODE", pMap.get("COMPANY"));
		userMap.put("USER_NAME_LOC", userInfo[1]);				// 이름
		userMap.put("LEGACY_USER_ID", userInfo[4]);				// ID
		userMap.put("POSITION", userInfo[2]);					// 직급명
		userMap.put("PLANT",  userInfo[7]);						// 플랜트
		userMap.put("EMP_NO",  userInfo[8]);					// 사번
		userMap.put("POSITION_CODE",  userInfo[5]);				// 직급코드
		userMap.put("POSITION_EN",  userInfo[9]);			    // 직급(영문)
		userMap.put("DEPARTMENT", userInfo[3]);			    	// 부서명
		userMap.put("DEPT_CODE", userInfo[6]);					// 부서코드
		userMap.put("DEPT_ID",  userInfo[10]);					// 부서아이디
		userMap.put("DEPT_PATH",  userInfo[11]);				// 부서패스
		userMap.put("DEPT_EN",  userInfo[12]);			    	// 부서영문
		
		Map<String, String> result = buyerMpSoExternalService.setHanwhaUser(userMap);
		
		_response.put("msg", flag);
		_response.put("userResult", result);

		return  _response;
	}
	//한화 결재자 선택 시 로직
	@RequestMapping(value = "/mpso/saveHanwhaUserInfo_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveHanwhaUserInfo_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("COM_CODE", formData.get("COMPANY"));
		
		for(int i=0; i < gridData.size(); i++){
			formData.putAll((Map<String, String>)gridData.get(i));
			buyerMpSoExternalService.setHanwhaUser(formData);
		}
		
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
//		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}

	@RequestMapping(value = "/mpso/getHanwhaAppUserIds_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getHanwhaAppUserIds_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> _userMap = new HashMap<String, String>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		String _legacyUserIds = CommonUtil.nvl(pMap.get("LEGACY_USER_IDS"));
		List<String> _idList = new ArrayList<String>();
		String[] _ids = _legacyUserIds.split(",");
		for (int i = 0; i < _ids.length; i++) {
			String _id = _ids[i].trim();
			if (!"".equals(_id)) {
				_idList.add(_id);
			}
		}

		if (!_idList.isEmpty()) {
			Map<String, Object> _param = new HashMap<String, Object>();
			_param.put("COM_CODE", _sessionInfo.getComCode());
			_param.put("legacyUserIdArray", _idList);

			List<Map<String, String>> _dataList = buyerMpSoExternalService.getHanwhaAppUserList(_param);
			if (_dataList != null) {
				for (int i = 0; i < _dataList.size(); i++) {
					Map<String, String> _row = _dataList.get(i);
					_userMap.put(CommonUtil.nvl(_row.get("LEGACY_USER_ID")), CommonUtil.nvl(_row.get("USER_ID")));
				}
			}
		}

		_response.put("userMap", _userMap);
		return _response;
	}

	/**
	 * 판촉 롯데칠성 결재연동
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/getLotteMpRqAppSend.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getLotteMpRqAppSend(@RequestParam Map<String, Object> pMap, HttpServletRequest req) throws IOException {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		try {
			returnMap = buyerMpSoExternalService.getLotteMpRqAppSend(pMap);
		} catch (Exception e) {
			LOGGER.error("getLotteMpRqAppSend ERROR !!!: ", e);
			returnMap.put("resultCode", "FAIL");
		}
		
		return returnMap;
	}
	
	/**
	 * 애경 단가합의 상신 결과
	 * @param pMap
	 * @param req
	 * @return
	 * @throws IOException 
	 */
	@NoLoginCheck
	@RequestMapping(value = "/mpso/setAeKyRqAppStatus.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String setAeKyRqAppStatus(@RequestParam Map<String, Object> pMap, HttpServletRequest req) throws IOException {
		
		String str = "";
		String type = "RQ";
		try {
			buyerMpSoExternalService.setAeKyAppStatus(pMap, type);
			str = "OK";
		} catch (Exception e) {
			str = "FAIL";
		}
		return str;
	}
}
