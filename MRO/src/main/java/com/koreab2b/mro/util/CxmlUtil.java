package com.koreab2b.mro.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class CxmlUtil {

	private DocumentBuilderFactory factory;
	private DocumentBuilder builder; 
	private XPath xpath;
	private static final Logger LOGGER = LoggerFactory.getLogger(CxmlUtil.class.getName()); 
	
	public CxmlUtil() {
		try {
			this.factory = DocumentBuilderFactory.newInstance();
			this.builder = factory.newDocumentBuilder();
			this.xpath = XPathFactory.newInstance().newXPath();
		} catch (ParserConfigurationException e) {
			LOGGER.error(e.getMessage());
		}		
	}
	
	public Document createResponse(Map<String, String> pMap, String gubun) throws Exception{
	
		Document xmlDoc = builder.newDocument();
		
		// basic response
		Element root	= xmlDoc.createElement("cXML");
	
		Element Response = xmlDoc.createElement("Response");
		Element Status = xmlDoc.createElement("Status");
		
		xmlDoc.appendChild(root);
		Response.appendChild(Status);
		root.appendChild(Response);
		
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
		String timeStamp = dayTime.format(new Date(time));

		String timestamp_fixed = timeStamp.substring(0,timeStamp.length()-2)+":"+timeStamp.substring(timeStamp.length()-2,timeStamp.length());
		
		root.setAttribute("xml:lang", "ko-KR");
		root.setAttribute("timestamp", timestamp_fixed);
		root.setAttribute("payloadID", "1233444-200@koreab2b.com");
		
		Status.setAttribute("code", pMap.get("CODE"));
		Status.setAttribute("text", pMap.get("TEXT"));		
		
		if(gubun.equals("PUNCHOUT")){
			Element PunchOutSetupResponse = xmlDoc.createElement("PunchOutSetupResponse");
			Element StartPage = xmlDoc.createElement("StartPage");
			Element URL = xmlDoc.createElement("URL");
			
			StartPage.appendChild(URL);
			PunchOutSetupResponse.appendChild(StartPage);
			Response.appendChild(PunchOutSetupResponse);
			URL.setTextContent(pMap.get("URL"));
		}
		
		return xmlDoc;
	}
	 
	public Document createPunchoutOrderMessage(List<Map<String, String>> pMaps) throws Exception {
		
		Document xmlDoc = builder.newDocument();
		
		/* time_stamp */
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
		String timeStamp = dayTime.format(new Date(time));
		String timestamp_fixed = timeStamp.substring(0,timeStamp.length()-2)+":"+timeStamp.substring(timeStamp.length()-2,timeStamp.length());
		
		// xml Root Element 생성
		Element root	= xmlDoc.createElement("cXML");
		
		root.setAttribute("xml:lang", pMaps.get(0).get("LANG_TYPE"));
		root.setAttribute("timestamp", timestamp_fixed);
		root.setAttribute("payloadID", "1233444-200@koreab2b.com");
		
		xmlDoc.appendChild(root);
		
		Element header = xmlDoc.createElement("Header");
		Element from = xmlDoc.createElement("From");
		Element fromCredential = xmlDoc.createElement("Credential");
		
		Element fromIdentity = xmlDoc.createElement("Identity");
		Element to = xmlDoc.createElement("To");
		Element toCredential = xmlDoc.createElement("Credential");
		Element toIdentity = xmlDoc.createElement("Identity");
		
		Element sender = xmlDoc.createElement("Sender");
		Element senderCredential = xmlDoc.createElement("Credential");
		Element senderIdentity = xmlDoc.createElement("Identity");
		Element userAgent = xmlDoc.createElement("UserAgent");
		
		Element message = xmlDoc.createElement("Message");
		Element punchOutOrderMessage = xmlDoc.createElement("PunchOutOrderMessage");
		Element buyerCookie = xmlDoc.createElement("BuyerCookie");
		Element punchOutOrderMessageHeader = xmlDoc.createElement("PunchOutOrderMessageHeader");
		
		Element total = xmlDoc.createElement("Total");
		Element money = xmlDoc.createElement("Money");
		
		fromCredential.setAttribute("domain",pMaps.get(0).get("FROM_DOMAIN")); //확인 필요.
		fromIdentity.setTextContent(pMaps.get(0).get("FROM_IDENTITY"));
		
		toCredential.setAttribute("domain", pMaps.get(0).get("TO_DOMAIN"));
		toIdentity.setTextContent(pMaps.get(0).get("TO_IDENTITY"));
		
		senderCredential.setAttribute("domain", pMaps.get(0).get("FROM_DOMAIN"));
		senderIdentity.setTextContent(pMaps.get(0).get("FROM_IDENTITY"));
		userAgent.setTextContent("");
		punchOutOrderMessageHeader.setAttribute("operationAllowed", "create");
		buyerCookie.setTextContent(pMaps.get(0).get("BUYERCOOKIE"));
		
		//메세지
		/*buyer cookie punchoutreqeust에서 준 값 저장해야함.*/
		
		/*xml구성*/
		root.appendChild(header);
		root.appendChild(message);
		
		header.appendChild(from);
		header.appendChild(to);
		header.appendChild(sender);
		
		from.appendChild(fromCredential);
		fromCredential.appendChild(fromIdentity);
		
		to.appendChild(toCredential);
		toCredential.appendChild(toIdentity);
		
		sender.appendChild(senderCredential);
		sender.appendChild(userAgent);
		senderCredential.appendChild(senderIdentity);
		
		message.appendChild(punchOutOrderMessage);
		
		punchOutOrderMessage.appendChild(buyerCookie);
		punchOutOrderMessage.appendChild(punchOutOrderMessageHeader);
		
		punchOutOrderMessageHeader.appendChild(total);
		total.appendChild(money);
		
		money.setAttribute("currency", pMaps.get(0).get("CURRENCY"));
		money.setTextContent(pMaps.get(0).get("PO_TTL_AMT")); // 변수
		
		for(int i=0; i<pMaps.size(); i++){
			Element itemIn = xmlDoc.createElement("ItemIn");
			Element itemID = xmlDoc.createElement("ItemID");
			Element supplierPartID = xmlDoc.createElement("SupplierPartID");
			Element supplierPartAuxiliaryID = xmlDoc.createElement("SupplierPartAuxiliaryID");
			Element itemDetail = xmlDoc.createElement("ItemDetail");
			Element detailMoney = xmlDoc.createElement("Money");
			Element description = xmlDoc.createElement("Description");
			Element unitPrice = xmlDoc.createElement("UnitPrice");
			Element unitOfMeasure = xmlDoc.createElement("UnitOfMeasure");
			Element classification = xmlDoc.createElement("Classification");
			Element manufacturerPartID = xmlDoc.createElement("ManufacturerPartID");
			Element manufacturerName = xmlDoc.createElement("ManufacturerName");
			
			itemIn.setAttribute("quantity", pMaps.get(i).get("ITEM_QTY"));
			supplierPartID.setTextContent(pMaps.get(i).get("BUYER_ITEM_NO"));
			detailMoney.setAttribute("currency", pMaps.get(i).get("CURRENCY"));
			detailMoney.setTextContent(pMaps.get(i).get("UNIT_PRICE"));
			description.setTextContent(pMaps.get(i).get("DESCRIPTION"));
			unitOfMeasure.setTextContent(pMaps.get(i).get("UNIT_MEASURE"));
			//classification.setAttribute("domain", "SPSC"); Veronika confirmed
			classification.setTextContent(pMaps.get(i).get("CATEGORY_NO"));
			manufacturerPartID.setTextContent(pMaps.get(i).get("SELLER_ITEM_NO"));
			//manufacturerName.setTextContent(pMaps.get(i).get("MAKER_NAME"));
			manufacturerName.setTextContent(".");
			
			itemIn.appendChild(itemID);
			itemIn.appendChild(itemDetail);
			itemID.appendChild(supplierPartID);
			itemID.appendChild(supplierPartAuxiliaryID);
			itemDetail.appendChild(unitPrice);
			itemDetail.appendChild(description);
			itemDetail.appendChild(unitOfMeasure);
			itemDetail.appendChild(classification);
			itemDetail.appendChild(manufacturerPartID);
			itemDetail.appendChild(manufacturerName);
			
			unitPrice.appendChild(detailMoney);
			
			punchOutOrderMessage.appendChild(itemIn);
		}

		return xmlDoc;
	}
	
	public Document createFakePunchoutOrderMessage(List<Map<String, String>> pMaps) throws Exception {
		
		Document xmlDoc = builder.newDocument();
		
		/* time_stamp */
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
		String timeStamp = dayTime.format(new Date(time));
		String timestamp_fixed = timeStamp.substring(0,timeStamp.length()-2)+":"+timeStamp.substring(timeStamp.length()-2,timeStamp.length());
		
		// xml Root Element 생성
		Element root	= xmlDoc.createElement("cXML");
		
		root.setAttribute("xml:lang", pMaps.get(0).get("LANG_TYPE"));
		root.setAttribute("timestamp", timestamp_fixed);
		root.setAttribute("payloadID", "1233444-200@koreab2b.com");
		
		xmlDoc.appendChild(root);
		
		Element header = xmlDoc.createElement("Header");
		Element from = xmlDoc.createElement("From");
		Element fromCredential = xmlDoc.createElement("Credential");
		
		Element fromIdentity = xmlDoc.createElement("Identity");
		Element to = xmlDoc.createElement("To");
		Element toCredential = xmlDoc.createElement("Credential");
		Element toIdentity = xmlDoc.createElement("Identity");
		
		Element sender = xmlDoc.createElement("Sender");
		Element senderCredential = xmlDoc.createElement("Credential");
		Element senderIdentity = xmlDoc.createElement("Identity");
		Element userAgent = xmlDoc.createElement("UserAgent");
		
		Element message = xmlDoc.createElement("Message");
		Element punchOutOrderMessage = xmlDoc.createElement("PunchOutOrderMessage");
		Element buyerCookie = xmlDoc.createElement("BuyerCookie");
		Element punchOutOrderMessageHeader = xmlDoc.createElement("PunchOutOrderMessageHeader");
		
		Element total = xmlDoc.createElement("Total");
		Element money = xmlDoc.createElement("Money");
		
		fromCredential.setAttribute("domain",pMaps.get(0).get("FROM_DOMAIN")); //확인 필요.
		fromIdentity.setTextContent(pMaps.get(0).get("FROM_IDENTITY"));
		
		toCredential.setAttribute("domain", pMaps.get(0).get("TO_DOMAIN"));
		toIdentity.setTextContent(pMaps.get(0).get("TO_IDENTITY"));
		
		senderCredential.setAttribute("domain", pMaps.get(0).get("FROM_DOMAIN"));
		senderIdentity.setTextContent(pMaps.get(0).get("FROM_IDENTITY"));
		userAgent.setTextContent("");
		punchOutOrderMessageHeader.setAttribute("operationAllowed", "create");
		buyerCookie.setTextContent(pMaps.get(0).get("BUYERCOOKIE"));
		
		//메세지
		/*buyer cookie punchoutreqeust에서 준 값 저장해야함.*/
		
		/*xml구성*/
		root.appendChild(header);
		root.appendChild(message);
		
		header.appendChild(from);
		header.appendChild(to);
		header.appendChild(sender);
		
		from.appendChild(fromCredential);
		fromCredential.appendChild(fromIdentity);
		
		to.appendChild(toCredential);
		toCredential.appendChild(toIdentity);
		
		sender.appendChild(senderCredential);
		sender.appendChild(userAgent);
		senderCredential.appendChild(senderIdentity);
		
		message.appendChild(punchOutOrderMessage);
		
		punchOutOrderMessage.appendChild(buyerCookie);
		punchOutOrderMessage.appendChild(punchOutOrderMessageHeader);
		
		punchOutOrderMessageHeader.appendChild(total);
		total.appendChild(money);
		
		money.setAttribute("currency", "KRW");
		money.setTextContent("1"); // 변수
		
		//for(int i=0; i<pMaps.size(); i++){
			Element itemIn = xmlDoc.createElement("ItemIn");
			Element itemID = xmlDoc.createElement("ItemID");
			Element supplierPartID = xmlDoc.createElement("SupplierPartID");
			Element supplierPartAuxiliaryID = xmlDoc.createElement("SupplierPartAuxiliaryID");
			Element itemDetail = xmlDoc.createElement("ItemDetail");
			Element detailMoney = xmlDoc.createElement("Money");
			Element description = xmlDoc.createElement("Description");
			Element unitPrice = xmlDoc.createElement("UnitPrice");
			Element unitOfMeasure = xmlDoc.createElement("UnitOfMeasure");
			Element classification = xmlDoc.createElement("Classification");
			Element manufacturerPartID = xmlDoc.createElement("ManufacturerPartID");
			Element manufacturerName = xmlDoc.createElement("ManufacturerName");
			
			itemIn.setAttribute("quantity", "1");
			supplierPartID.setTextContent(".");
			detailMoney.setAttribute("currency", "KRW");
			detailMoney.setTextContent("1");
			description.setTextContent(".");
			unitOfMeasure.setTextContent(".");
			//classification.setAttribute("domain", "SPSC"); Veronika confirmed
			classification.setTextContent(".");
			manufacturerPartID.setTextContent(".");
			//manufacturerName.setTextContent(pMaps.get(i).get("MAKER_NAME"));
			manufacturerName.setTextContent(".");
			
			itemIn.appendChild(itemID);
			itemIn.appendChild(itemDetail);
			itemID.appendChild(supplierPartID);
			itemID.appendChild(supplierPartAuxiliaryID);
			itemDetail.appendChild(unitPrice);
			itemDetail.appendChild(description);
			itemDetail.appendChild(unitOfMeasure);
			itemDetail.appendChild(classification);
			itemDetail.appendChild(manufacturerPartID);
			itemDetail.appendChild(manufacturerName);
			
			unitPrice.appendChild(detailMoney);
			
			punchOutOrderMessage.appendChild(itemIn);
		//}

		return xmlDoc;
	}
	
	public Map<String, String> parsePunchoutRequest(Document doc) throws Exception {
		
		Map<String, String> retMap = new HashMap<String, String>();
		
		retMap.put("fromIdentity", (String) xpath.evaluate("/cXML/Header/From/Credential/Identity", doc, XPathConstants.STRING));
		retMap.put("toIdentity", (String) xpath.evaluate("/cXML/Header/To/Credential/Identity", doc, XPathConstants.STRING));
		retMap.put("senderIdentity", (String) xpath.evaluate("/cXML/Header/Sender/Credential/Identity", doc, XPathConstants.STRING));
		retMap.put("senderSharedSecret", (String) xpath.evaluate("/cXML/Header/Sender/Credential/SharedSecret", doc, XPathConstants.STRING));
		retMap.put("requestExtrinsicName", (String) xpath.evaluate("/cXML/Request/PunchOutSetupRequest/Extrinsic[@name='User']", doc, XPathConstants.STRING));
		retMap.put("buyerCookie", (String) xpath.evaluate("/cXML/Request/PunchOutSetupRequest/BuyerCookie", doc, XPathConstants.STRING));
		retMap.put("browserFormPosURL", (String) xpath.evaluate("/cXML/Request/PunchOutSetupRequest/BrowserFormPost/URL", doc, XPathConstants.STRING));
		retMap.put("contactName", (String) xpath.evaluate("/cXML/Request/PunchOutSetupRequest/Contact/Name", doc, XPathConstants.STRING));
		retMap.put("contactEmail", (String) xpath.evaluate("/cXML/Request/PunchOutSetupRequest/Contact/Email", doc, XPathConstants.STRING));
		
		return retMap;
	}
	
	public List<Map<String, String>> parseOrderMessage(Document doc) throws Exception {

		List<Map<String, String>> retList = new ArrayList<Map<String, String>>();
		
		NodeList detailList = (NodeList)xpath.evaluate("//ItemOut", doc, XPathConstants.NODESET);

		String orderId = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderID", doc);
		String orderDate = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate", doc);
		String orderType = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@type", doc);
		
		
		String fromIdentity =  (String) xpath.evaluate("/cXML/Header/From/Credential/Identity", doc, XPathConstants.STRING);
		String toIdentity = (String) xpath.evaluate("/cXML/Header/To/Credential/Identity", doc, XPathConstants.STRING);
		String senderIdentity = (String) xpath.evaluate("/cXML/Header/Sender/Credential/Identity", doc, XPathConstants.STRING);
		String senderSharedSecret = (String) xpath.evaluate("/cXML/Header/Sender/Credential/SharedSecret", doc, XPathConstants.STRING);
		
		orderDate = orderDate.substring(0, 10).replace("-", "");
		orderId = orderId.substring(0,orderId.indexOf(":"));
		
		String deliveryTo = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo", doc);
		String email = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Email", doc);
		
		String purchaseUserInfo = deliveryTo + "^" + email; // NAME, EMAIL, 
		
		String ackreqd = "";
		String ackbydate = "";
		String suppnote = "";
		String tandc = "";
		
		String status = "";
		if(orderType.equals("new")){
			status = "C";
		}else if(orderType.equals("update")){
			status = "R";
		}else {
			status = "D";
		}
		
		//반복
		for(int i=0; i<detailList.getLength(); i++){
			
			String lineNum =  xpath.evaluate("./ItemDetail/Extrinsic[@name='LINENUM']", detailList.item(i));
			String supplierPartID = xpath.evaluate("./ItemID/SupplierPartID", detailList.item(i));
			String quantity = xpath.evaluate("./@quantity", detailList.item(i));
			String requestedDeliveryDate = xpath.evaluate("./@requestedDeliveryDate", detailList.item(i));
			
			requestedDeliveryDate = requestedDeliveryDate.substring(0, 10).replace("-", "");
			
			String currency = xpath.evaluate("./ItemDetail/UnitPrice/Money/@currency", detailList.item(i));
			String unitPrice = xpath.evaluate("./ItemDetail/UnitPrice/Money", detailList.item(i));
			String description = xpath.evaluate("./ItemDetail/Description", detailList.item(i));
			String unitOfMeasure = xpath.evaluate("./ItemDetail/UnitOfMeasure", detailList.item(i));
			
			String classification = xpath.evaluate("./ItemDetail/Classification", detailList.item(i));
			String manufacturerPartID = xpath.evaluate("./ItemDetail/ManufacturerPartID", detailList.item(i));
			String manufacturerName = xpath.evaluate("./ItemDetail/ManufacturerName", detailList.item(i));
			
			String comments = xpath.evaluate("./ItemDetail/Comments", detailList.item(i));
			String city = xpath.evaluate("./ShipTo/Address/PostalAddress/City", detailList.item(i));
			NodeList streets = (NodeList)xpath.evaluate("./ShipTo/Address/PostalAddress/Street", detailList.item(i), XPathConstants.NODESET);
			String dely_to_location = xpath.evaluate("./ShipTo/Address/PostalAddress/PostalCode", detailList.item(i))+" ";
			
			for(int ix=0; ix<streets.getLength(); ix++){
				dely_to_location += xpath.evaluate(".", streets.item(ix))+" ";
			}
			dely_to_location += city;
			
			Map<String, String> detailMap = new HashMap<String, String>();
			
			detailMap.put("fromIdentity", fromIdentity);
			detailMap.put("toIdentity", toIdentity);
			detailMap.put("senderIdentity", senderIdentity);
			detailMap.put("senderSharedSecret", senderSharedSecret);
			
			detailMap.put("legacy_po_no", orderId);
			detailMap.put("legacy_po_seq", lineNum);
			detailMap.put("buyer_item_no", supplierPartID);
			detailMap.put("item_qty", quantity);
			detailMap.put("currency_code", currency);
			detailMap.put("unit_price", unitPrice);
			detailMap.put("description", description);
			detailMap.put("specification", classification);
			detailMap.put("unit_measure", unitOfMeasure);
			detailMap.put("add_date", orderDate);
			detailMap.put("rd_date", requestedDeliveryDate);
			detailMap.put("remark", comments);
			detailMap.put("status", status);
			detailMap.put("dely_to_location", dely_to_location);
			detailMap.put("req_user_info", purchaseUserInfo);
			detailMap.put("hd_remark", " ");
			detailMap.put("iv_column"," ");
			
			retList.add(detailMap);
		}
		
		
		
		return retList;
	}
	
	public List<Map<String, String>> parseOrderMessageFagb(Document doc) throws Exception {

		List<Map<String, String>> retList = new ArrayList<Map<String, String>>();
		
		NodeList detailList = (NodeList)xpath.evaluate("//ItemOut", doc, XPathConstants.NODESET);

		String orderId = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderID", doc);
		String orderDate = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate", doc);
		String orderType = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@type", doc);
		
		
		String fromIdentity =  (String) xpath.evaluate("/cXML/Header/From/Credential/Identity", doc, XPathConstants.STRING);
		String toIdentity = (String) xpath.evaluate("/cXML/Header/To/Credential/Identity", doc, XPathConstants.STRING);
		String senderIdentity = (String) xpath.evaluate("/cXML/Header/Sender/Credential/Identity", doc, XPathConstants.STRING);
		String senderSharedSecret = (String) xpath.evaluate("/cXML/Header/Sender/Credential/SharedSecret", doc, XPathConstants.STRING);
		
		orderDate = orderDate.substring(0, 10).replace("-", "");
		
		
		String deliveryTo = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo", doc);
		String email = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Email", doc);
		String addressId = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID", doc);
		
		String purchaseUserInfo = deliveryTo + "^" + email; // NAME, EMAIL, 
		
		
		String status = "";
		if(orderType.equals("new")){
			status = "C";
		}else if(orderType.equals("update")){
			status = "R";
		}else if(orderType.equals("delete")){
			status = "D";
		} else {
			status = "ERR";
		}
		
		if(addressId.equals("0074-KR")) { // 안산
			addressId = "0074";
		} else if(addressId.equals("0297-KR")) { // 창원
			addressId = "0297";
		} else if(addressId.equals("7297-KR")) { // 서울
			addressId = "7297";
		} else if(addressId.equals("8297-KR")) { // 전주
			addressId = "8297";
		}
		
		//반복
		for(int i=0; i<detailList.getLength(); i++){
			
			String lineNum =  xpath.evaluate("./@lineNumber", detailList.item(i));
			String supplierPartID = xpath.evaluate("./ItemID/SupplierPartID", detailList.item(i));
			String quantity = xpath.evaluate("./@quantity", detailList.item(i));
			String requestedDeliveryDate = xpath.evaluate("./@requestedDeliveryDate", detailList.item(i));
			
			requestedDeliveryDate = requestedDeliveryDate.replace("-", "");
			
			String currency = xpath.evaluate("./ItemDetail/UnitPrice/Money/@currency", detailList.item(i));
			String unitPrice = xpath.evaluate("./ItemDetail/UnitPrice/Money", detailList.item(i));
			String description = xpath.evaluate("./ItemDetail/Description", detailList.item(i));
			String unitOfMeasure = xpath.evaluate("./ItemDetail/UnitOfMeasure", detailList.item(i));
			
			String classification = xpath.evaluate("./ItemDetail/Classification", detailList.item(i));
			String manufacturerPartID = xpath.evaluate("./ItemDetail/ManufacturerPartID", detailList.item(i));
			String manufacturerName = xpath.evaluate("./ItemDetail/ManufacturerName", detailList.item(i));
			
			String comments = xpath.evaluate("./ItemDetail/Comments", detailList.item(i));
			String city = xpath.evaluate("./ShipTo/Address/PostalAddress/City", detailList.item(i));
			NodeList streets = (NodeList)xpath.evaluate("./ShipTo/Address/PostalAddress/Street", detailList.item(i), XPathConstants.NODESET);
			String dely_to_location = xpath.evaluate("./ShipTo/Address/PostalAddress/PostalCode", detailList.item(i))+" ";
			
			for(int ix=0; ix<streets.getLength(); ix++){
				dely_to_location += xpath.evaluate(".", streets.item(ix))+" ";
			}
			dely_to_location += city;
			
			Map<String, String> detailMap = new HashMap<String, String>();
			
			detailMap.put("fromIdentity", fromIdentity);
			detailMap.put("toIdentity", toIdentity);
			detailMap.put("senderIdentity", senderIdentity);
			detailMap.put("senderSharedSecret", senderSharedSecret);
			
			detailMap.put("legacy_po_no", orderId);
			detailMap.put("legacy_po_seq", lineNum);
			detailMap.put("buyer_item_no", supplierPartID);
			detailMap.put("item_qty", quantity);
			detailMap.put("currency_code", currency);
			detailMap.put("unit_price", unitPrice);
			detailMap.put("description", description);
			detailMap.put("specification", classification);
			detailMap.put("unit_measure", unitOfMeasure);
			detailMap.put("add_date", orderDate);
			detailMap.put("rd_date", requestedDeliveryDate);
			detailMap.put("remark", comments);
			detailMap.put("status", status);
			detailMap.put("dely_to_location", dely_to_location);
			detailMap.put("req_user_info", purchaseUserInfo);
			detailMap.put("hd_remark", " ");
			detailMap.put("iv_column"," ");
			detailMap.put("plant", addressId);
			
			retList.add(detailMap);
		}
		
		
		
		return retList;
	}
	
	public List<Map<String, String>> parseOrderMessageYHKB(Document doc) throws Exception {

		List<Map<String, String>> retList = new ArrayList<Map<String, String>>();
		
		NodeList detailList = (NodeList)xpath.evaluate("//ItemOut", doc, XPathConstants.NODESET);

		String orderId = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderID", doc);
		String orderDate = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@orderDate", doc);
		String orderType = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/@type", doc);
		
		
		String fromIdentity =  (String) xpath.evaluate("/cXML/Header/From/Credential/Identity", doc, XPathConstants.STRING);
		String toIdentity = (String) xpath.evaluate("/cXML/Header/To/Credential/Identity", doc, XPathConstants.STRING);
		String senderIdentity = (String) xpath.evaluate("/cXML/Header/Sender/Credential/Identity", doc, XPathConstants.STRING);
		String senderSharedSecret = (String) xpath.evaluate("/cXML/Header/Sender/Credential/SharedSecret", doc, XPathConstants.STRING);
		
		orderDate = orderDate.substring(0, 10).replace("-", "");
		
		
		String deliveryTo = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/PostalAddress/DeliverTo", doc);
		String email = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/Email", doc);
		String addressId = xpath.evaluate("/cXML/Request/OrderRequest/OrderRequestHeader/ShipTo/Address/@addressID", doc);
		
		String purchaseUserInfo = deliveryTo + "^" + email; // NAME, EMAIL, 
		
		
		String status = "";
		if(orderType.equals("new")){
			status = "C";
		}else if(orderType.equals("update")){
			status = "R";
		}else if(orderType.equals("delete")){
			status = "D";
		} else {
			status = "ERR";
		}
		String reAddressId = "";
		
		if(addressId.indexOf("5132") > -1) { // 김천
			reAddressId = "5132";
		} else if(addressId.indexOf("5133") > -1) { // 대전
			reAddressId = "5133";
		} else if(addressId.indexOf("5134") > -1) { // 충주
			reAddressId = "5134";
		} else {
			reAddressId = "ERR";
		}
		
		//반복
		for(int i=0; i<detailList.getLength(); i++){
			
			String lineNum =  xpath.evaluate("./@lineNumber", detailList.item(i));
			String supplierPartID = xpath.evaluate("./ItemID/SupplierPartID", detailList.item(i));
			String quantity = xpath.evaluate("./@quantity", detailList.item(i));
			String requestedDeliveryDate = xpath.evaluate("./@requestedDeliveryDate", detailList.item(i));
			
			requestedDeliveryDate = requestedDeliveryDate.replace("-", "");
			
			String currency = xpath.evaluate("./ItemDetail/UnitPrice/Money/@currency", detailList.item(i));
			String unitPrice = xpath.evaluate("./ItemDetail/UnitPrice/Money", detailList.item(i));
			String description = xpath.evaluate("./ItemDetail/Description", detailList.item(i));
			String unitOfMeasure = xpath.evaluate("./ItemDetail/UnitOfMeasure", detailList.item(i));
			
			String classification = xpath.evaluate("./ItemDetail/Classification", detailList.item(i));
			String manufacturerPartID = xpath.evaluate("./ItemDetail/ManufacturerPartID", detailList.item(i));
			String manufacturerName = xpath.evaluate("./ItemDetail/ManufacturerName", detailList.item(i));
			
			String comments = xpath.evaluate("./ItemDetail/Comments", detailList.item(i));
			String city = xpath.evaluate("./ShipTo/Address/PostalAddress/City", detailList.item(i));
			NodeList streets = (NodeList)xpath.evaluate("./ShipTo/Address/PostalAddress/Street", detailList.item(i), XPathConstants.NODESET);
			String dely_to_location = xpath.evaluate("./ShipTo/Address/PostalAddress/PostalCode", detailList.item(i))+" ";
			
			for(int ix=0; ix<streets.getLength(); ix++){
				dely_to_location += xpath.evaluate(".", streets.item(ix))+" ";
			}
			dely_to_location += city;
			
			Map<String, String> detailMap = new HashMap<String, String>();
			
			detailMap.put("fromIdentity", fromIdentity);
			detailMap.put("toIdentity", toIdentity);
			detailMap.put("senderIdentity", senderIdentity);
			detailMap.put("senderSharedSecret", senderSharedSecret);
			
			detailMap.put("legacy_po_no", orderId);
			detailMap.put("legacy_po_seq", lineNum);
			detailMap.put("buyer_item_no", supplierPartID);
			detailMap.put("item_qty", quantity);
			detailMap.put("currency_code", currency);
			detailMap.put("unit_price", unitPrice);
			detailMap.put("description", description);
			detailMap.put("specification", classification);
			detailMap.put("unit_measure", unitOfMeasure);
			detailMap.put("add_date", orderDate);
			detailMap.put("rd_date", requestedDeliveryDate);
			detailMap.put("remark", comments);
			detailMap.put("status", status);
			detailMap.put("dely_to_location", dely_to_location);
			detailMap.put("req_user_info", purchaseUserInfo);
			detailMap.put("hd_remark", " ");
			detailMap.put("iv_column",addressId);
			detailMap.put("plant", reAddressId);
			
			retList.add(detailMap);
		}
		
		
		
		return retList;
	}
}
