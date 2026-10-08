package com.kep.cretec.service;

import java.io.StringWriter;
import java.util.List;
import java.util.Map;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPathConstants;

import org.apache.log4j.Logger;
import org.w3c.dom.CDATASection;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.kep.common.CommonUtil;

public class CretecIfPO extends CretecBaseImpl {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private String regist_id	= "RegistInChest";
	private String regist_url	= "/ctxext/regist.do";
	private String order_id		= "Order";
	private String order_url	= "/ctxext/order.do";
	private String print_id		= "OrderPrintInfo";
	private String print_url	= "/ctxext/regOrderPrintInfo.do";
	private String callUrl	= "";
	
	public CretecIfPO(String jSessionID) {
		super();
		this.JSESSIONID = jSessionID;
	}
	
	public void sendPO() {
		List<Map<String, String>> poList = null;
		boolean bRegist = false;
		boolean printFlag = false;
		String orderNo = "";
		
		try {
			poList = dao.getPOList();
			
			for(Map<String, String> iMap : poList) {
				bRegist = false;
				printFlag= false;
				orderNo = "";
				String errorMsg = "";
				
				bRegist = registItems(iMap);
				
				if(bRegist) {
					orderNo = orderItems(iMap);
				}
				
				if ( bRegist && !"".equals(orderNo) && orderNo != null ) {
					iMap.put("AGENT_PO_NO",orderNo);
					iMap.put("RTN_FLAG", "S");
					iMap.put("RTN_MSG", "성공.");
					
					log.info("iMap! " + iMap);
					/**
					 * 1. PORS_ADD EVENT DUP CHECK
					 * 2. INSERT PORS_ADD EVENT
					 */
					int evenCnt	= dao.checkPORSEvent(iMap);
					if (evenCnt == 0) {
						dao.insertPORSEvent(iMap);
					}
					
					printFlag = printItems(iMap);
					
					if (!printFlag) {
						errorMsg = "출력물 정보 전송 오류";
						iMap.put("RTN_FLAG", "F");
					}
					
				} else {
					iMap.put("RTN_FLAG", "F");
					
					if (!bRegist) {
						errorMsg = "장바구니 등록 오류.";
					} else if (!"".equals(orderNo)) {
						errorMsg = "발주 생성 오류.";
					}
					iMap.put("RTN_MSG", errorMsg);
				}
				
				dao.updatePOResult(iMap);
			}
			
		} catch (Exception e) {
			log.error("CretecIfPO " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	private boolean printItems(Map<String, String> iMap) {
		boolean bRtn = false;
		Document xmlDoc	= null;
		Map<String, Object> rMap = null;
		
		try {
			xmlDoc = super.getDocument(this.print_id);
			Element root = xmlDoc.getDocumentElement();	// root element 확인.
			Element body = xmlDoc.createElement(this.print_id);
			
			Element print = xmlDoc.createElement("PrintInfo");
			
			print.setAttribute("ctx_sale_ord_no", iMap.get("AGENT_PO_NO")); 		// 크레텍 주문번호
			print.setAttribute("cretec_prod_cd", iMap.get("SELLER_ITEM_NO")); 		//크레텍 상품코드
			print.setAttribute("item_cd", iMap.get("")); 		                    //크레텍 상품코드
			print.setAttribute("image_info", iMap.get("REMARK")); 	//QR
			print.setAttribute("brnd_nm", iMap.get("COM_NAME_LOC"));//라벨명
			print.setAttribute("comp_box_no", ""); 					  				//BOX 수량
			print.setAttribute("pur_ord_no", iMap.get("REMARK"));  //발주번호
			print.setAttribute("item_nm", iMap.get("DESCRIPTION"));//품명
			print.setAttribute("opt", iMap.get("SPECIFICATION")); 	//규격
			print.setAttribute("req_qty",  String.valueOf(iMap.get("ITEM_QTY")));   //수량
			print.setAttribute("stype", iMap.get("UNIT_MEASURE"));  				//단위
			print.setAttribute("orig_coun",  iMap.get("MAKER_NAME"));  //제조사
			print.setAttribute("barcode",  iMap.get("REMARK"));      				    //바코드
			print.setAttribute("cust_po_no", iMap.get("TEXT6") + iMap.get("TEXT5")); 	//물류센터
			print.setAttribute("prod_cd", iMap.get("DELY_TO_ADDRESS")); 				   //고객인수자
			print.setAttribute("makr_cd", iMap.get("POHD_REMARK")); 				  //성명
			print.setAttribute("dire_ship_code", String.valueOf(iMap.get("AGENT_PRICE"))); 		  //매입단가
			print.setAttribute("gbl_num", String.valueOf(iMap.get("AGENT_ITEM_AMT"))); 				  //매입금액
			print.setAttribute("memo", ""); 						//비고1
			print.setAttribute("ref_no", ""); 						//비고2
		
			body.appendChild(print);
			
			root.appendChild(body);
			
			callUrl = this.cretec_domain+this.cretec_path+this.print_url;
			rMap = super.sendHttpPost(callUrl, xmlDoc);
			
			log.info("print !!! rMap" + rMap );
				if ("S".equals(rMap.get("RTN_FLAG"))) {
					bRtn = true;
				} else {
					bRtn = false;
				}
			
		} catch (Exception e) {
			
			log.error("registItems Error : " + CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
	
	 public static String kepReplaceBrAll(String str) { 
	    	String tmp = String.valueOf(str); 
	    	
	    	tmp = tmp.replaceAll(  ">","&gt;");
	    	tmp = tmp.replaceAll(  "<","&lt;");
	    	tmp = tmp.replaceAll(  "&nbsp;", "&amp;nbsp;");
	    	tmp = tmp.replaceAll(  "\"\"","&quot;");
	    	tmp = tmp.replaceAll(  "'","&#39;");
			tmp = tmp.replaceAll(  "\"", "&#34;");
			
	    	return tmp;
	    }
	    

	private boolean registItems(Map<String, String> poDtList) {
		boolean bRtn = false;
		Document xmlDoc	= null;
		Map<String, Object> rMap = null;

		try {
			log.error("poDtList" + poDtList);
			
			xmlDoc = super.getDocument(this.regist_id);
			Element root = xmlDoc.getDocumentElement();	// root element 확인.
			Element body = xmlDoc.createElement(this.regist_id);
			
			Element item = xmlDoc.createElement("item");
			item.setAttribute("prod_cd", (String)poDtList.get("SELLER_ITEM_NO"));
			item.setAttribute("qty", String.valueOf(poDtList.get("ITEM_QTY")));
			item.setAttribute("pack_no", "");
				
			body.appendChild(item);
			
			root.appendChild(body);
			
			callUrl = this.cretec_domain+this.cretec_path+this.regist_url;
			rMap = super.sendHttpPost(callUrl, xmlDoc);
			
			if ("S".equals(rMap.get("RTN_FLAG"))) {
				bRtn = true;
			} else {
				bRtn = false;
			}
		} catch (Exception e) {
			log.error("registItems Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
		}
		
		return bRtn;
	}
	
	private String orderItems(Map<String, String> poHD) {

		String rtnStr = "";
		Document xmlDoc	= null;
		Map<String, Object> rMap = null;

		try {
			xmlDoc = super.getDocument(this.order_id);
			Element root = xmlDoc.getDocumentElement();	// root element 확인.
			Element body = xmlDoc.createElement(this.order_id);
			body.setAttribute("deliveryArea", poHD.get("DELIVERYAREA"));
			body.setAttribute("deliveryGb", poHD.get("DELIVERYGB"));
			body.setAttribute("deliveryList", poHD.get("DELIVERYLIST"));
			
			Element OrderitemList = xmlDoc.createElement("itemList");
			
			Element item = xmlDoc.createElement("orderItem");
			item.setAttribute("prod_cd", (String)poHD.get("SELLER_ITEM_NO"));
			
			if ("KRCRET0001".equals(poHD.get("AGENT"))) {
				item.setAttribute("comp_cd", "C");
			}else {
				item.setAttribute("comp_cd", "W");
			
			}
				
			OrderitemList.appendChild(item);
			
			Element remark = xmlDoc.createElement("remark");

			String remarkText = poHD.get("PO_REMARK");
			
			if (remarkText != null && remarkText.contains("&")) {
			
			    CDATASection cdata = xmlDoc.createCDATASection(remarkText);
			    remark.appendChild(cdata);
			} else {
			    remark.setTextContent(remarkText);
			}
			
			Element directCheck = xmlDoc.createElement("directCheck");
			directCheck.setTextContent("N");
			
			Element cargo = xmlDoc.createElement("cargo");
			cargo.setTextContent("1");
			
			Element cargoBiz = xmlDoc.createElement("cargoBiz");
			cargoBiz.setTextContent("1");
			
			Element postCd = xmlDoc.createElement("postCd");
			postCd.setTextContent("1");
			
			Element addr1 = xmlDoc.createElement("addr1");
			addr1.setTextContent("1");
			
			Element addr2 = xmlDoc.createElement("addr2");
			addr2.setTextContent("1");
			
			Element deliveryDirectNm = xmlDoc.createElement("deliveryDirectNm");
			deliveryDirectNm.setTextContent(poHD.get("DELIVERYDIRECTNM"));	// 인수자명
			
			Element deliveryDirectTel = xmlDoc.createElement("deliveryDirectTel");
			deliveryDirectTel.setTextContent(poHD.get("DELIVERYDIRECTTEL"));	// 인수자전화
			
			Element deliveryDirectHp = xmlDoc.createElement("deliveryDirectHp");
			deliveryDirectHp.setTextContent(poHD.get("DELIVERYDIRECTHP"));	// 인수자핸드폰
			
			Element deliveryBigo = xmlDoc.createElement("deliveryBigo");
			deliveryBigo.setTextContent(poHD.get("DELIVERYBIGO"));	// 배송비고
			
			Element cashDelvPayClsCd = xmlDoc.createElement("cashDelvPayClsCd");
			cashDelvPayClsCd.setTextContent("2");	// 현불:1, 착불:2
			
			Element innerInfoYn = xmlDoc.createElement("innerInfoYn");
			innerInfoYn.setTextContent("N");	// 내품정보출력여부
			
			Element tradIssYn = xmlDoc.createElement("tradIssYn");
			tradIssYn.setTextContent("N");	// 거래명세서출력여부
			
			body.appendChild(remark);
			body.appendChild(directCheck);
			body.appendChild(cargo);
			body.appendChild(cargoBiz);
			body.appendChild(postCd);
			body.appendChild(addr1);
			body.appendChild(addr2);
			body.appendChild(deliveryDirectNm);
			body.appendChild(deliveryDirectTel);
			body.appendChild(deliveryDirectHp);
			body.appendChild(deliveryBigo);
			body.appendChild(cashDelvPayClsCd);
			body.appendChild(innerInfoYn);
			body.appendChild(tradIssYn);
			body.appendChild(OrderitemList);
			
			root.appendChild(body);
			
			callUrl = this.cretec_domain+this.cretec_path+this.order_url;
			
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer = tf.newTransformer();
			
			StringWriter writer = new StringWriter();
			
			transformer.transform(new DOMSource(xmlDoc), new StreamResult(writer));
			
			log.info("xml data ====== \n" + writer.toString());
			
			rMap = super.sendHttpPost(callUrl, xmlDoc);
			Document rDoc = (Document)rMap.get("RTN_DATA");
			
			if ("S".equals(rMap.get("RTN_FLAG"))) {
				rtnStr = (String)this.xpath.evaluate("/Response/orderNo", rDoc, XPathConstants.STRING);
			} else {
				rtnStr = "";
			}
		} catch (Exception e) {
			log.error("orderItems Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
		}
		
		return rtnStr;
	}
}