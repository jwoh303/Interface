package com.koreab2b.extern.buyer.controller;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
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
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import com.koreab2b.extern.buyer.service.SgsService;
import com.koreab2b.extern.buyer.service.SgsServiceImpl;
import com.koreab2b.extern.util.CxmlUtil;

@Controller("sgsController")
public class SgsController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SgsController.class);

	@RequestMapping(value="/prodPurchaseOrderXmlForSGS.do", method = {RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public void getProdPurchaseOrderXmlForSGS(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		String db_conn = "2";
		pMap.put("db_conn", db_conn);
		
		getPurchaseOrderXmlForSGS(pMap, req, resp);
	}

	@RequestMapping(value="/devPurchaseOrderXmlForSGS.do", method = {RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public void getDevPurchaseOrderXmlForSGS(@RequestParam Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		String db_conn = "0";
		pMap.put("db_conn", db_conn);
		System.out.println(" devPurchaseOrderXmlForSGS start :::");
		getPurchaseOrderXmlForSGS(pMap, req, resp);
	}

	private void getPurchaseOrderXmlForSGS(Map<String, String> pMap, HttpServletRequest req, HttpServletResponse resp) {
		System.out.println("SGSPUNCHOUT_XML_LIST pMap :: " + pMap);
		System.out.println("SGSPUNCHOUT_XML_LIST req :: " + req);
		Map<String, String> retMap = new HashMap<String,String>();
		Document doc = null;
		Document responseDoc = null;
		StringBuffer sb = null;
		CxmlUtil cxmlGenerator = new CxmlUtil();
		List<Map<String, String>> parsedList = new ArrayList<Map<String, String>>();
		
		String db_conn = pMap.get("db_conn");
		
		String remoteAddr = "";
		
		remoteAddr = req.getRemoteAddr();
		
		SgsService sgsService	= null;
		
		try {
			System.out.println("1. getPurchaseOrderXmlForSGS starts"); //catalina.out
			
			sgsService = new SgsServiceImpl();
			
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
			logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_1_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", remoteAddr);
			logMap.put("db_conn", db_conn);
			
			sgsService.saveLog(logMap);

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			
			doc = builder.parse(new ByteArrayInputStream(sb.toString().getBytes("UTF-8")));

			parsedList = cxmlGenerator.parseOrderMessage(doc);  
			
			logMap.clear();
			logMap.put("INTERFACE_ID", "PUNCHOUT");
			logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_2_"+sb.toString());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", remoteAddr);
			logMap.put("db_conn", db_conn);
			
			sgsService.saveLog(logMap);
			
			String ret = "ERROR";
			
			if(parsedList.size()>0){
				System.out.println("SGSPUNCHOUT_XML_LIST :: " + parsedList);
				ret = sgsService.saveSgsPurchaseOrder(parsedList, pMap);
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
				
//				Map<String, String> logMap = new HashMap<String, String>();
//				logMap.put("INTERFACE_ID", "PUNCHOUT");
//				logMap.put("CONTENTS", "getPurchaseOrderXmlForSGS_return_"+out.toString());
//				logMap.put("FLAG", "Y");
//				logMap.put("ERROR_MSG", "");
//				logMap.put("db_conn", db_conn);
//				sgsService.saveLog(logMap);
				
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
}
