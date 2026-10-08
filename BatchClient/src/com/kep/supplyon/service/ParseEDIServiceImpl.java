package com.kep.supplyon.service;

import java.io.File;
import java.io.FileInputStream;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.kep.supplyon.dao.ParseEDIDaoImpl;

public class ParseEDIServiceImpl implements ParseEDIService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute() {
		
		/*로컬 테스트용*/
		//String path = "C:/mendelson_opensource_as2/messages/kepas2/inbox/converted/";
		String path = "D:/mendelson_opensource_as2/messages/kepas2/inbox/converted/";

		File dirFile = new File(path);
		File []fileList = dirFile.listFiles();
		
		ParseEDIDaoImpl dao = new ParseEDIDaoImpl();
		Map<String, String> pMap = new HashMap<String, String>();
		
		boolean isMoved = false;
		
		for(File tf : fileList){
			
			isMoved = false;
			
			if(tf.isFile()){
				
				try {					
					InputSource is = new InputSource(new FileInputStream(new File(path+tf.getName())));
					Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);

					XPath xpath = XPathFactory.newInstance().newXPath();
     
					pMap.clear();
					pMap = new HashMap<String, String>();
					
					
					NodeList tmpList = (NodeList)xpath.evaluate("//element[@Id='NAD01']", document, XPathConstants.NODESET);
					
					Node poInfo = null;
					
					for( int idx=0; idx<tmpList.getLength(); idx++ ){
						if(tmpList.item(idx).getTextContent().equals("CN")){
							poInfo = tmpList.item(idx).getParentNode().getParentNode();
							break;
						}
					}
					
					/* 헤더정보 파싱 */
					String legacy_po_no = (String) xpath.evaluate("//element[@Id='BGM02']", document, XPathConstants.STRING); //
					String add_date = (String) xpath.evaluate("//element[@Id='DTM01']/subelement[@Sequence='2']", document, XPathConstants.STRING);
					
					String plant = xpath.evaluate(".//element[@Id='NAD02']/subelement[@Sequence='1']", poInfo);
					String srm_addr1 = xpath.evaluate(".//element[@Id='NAD04']/subelement[@Sequence='1']", poInfo);
					String srm_addr2 = xpath.evaluate(".//element[@Id='NAD04']/subelement[@Sequence='2']", poInfo);
					String srm_user_info = xpath.evaluate(".//element[@Id='NAD04']/subelement[@Sequence='3']", poInfo);
					String addr1 = xpath.evaluate(".//element[@Id='NAD05']", poInfo);
					String addr2 = xpath.evaluate(".//element[@Id='NAD06']", poInfo);
					String addr4 = xpath.evaluate(".//element[@Id='NAD08']", poInfo);
					
					NodeList tList = (NodeList)xpath.evaluate("//element[@Id='LOC01']", poInfo, XPathConstants.NODESET);
					Node unloadingPoint = null;
					for( int idx=0; idx<tList.getLength(); idx++ ){
						if(tList.item(idx).getTextContent().equals("11")){
							unloadingPoint = tList.item(idx).getParentNode();
							break;
						}
					}
					Node factoryNo = null;
					for( int idx=0; idx<tList.getLength(); idx++ ){
						if(tList.item(idx).getTextContent().equals("18")){
							factoryNo = tList.item(idx).getParentNode();
							break;
						}
					}
					String unloadingPointStr = "";
					String purchaser_user_id = "XXXXXX";
					String factoryNoStr = "";
					
					
					
					if(legacy_po_no.startsWith("800")){
						purchaser_user_id = xpath.evaluate(".//element[@Id='LOC02']", unloadingPoint);
					}else{
						unloadingPointStr = xpath.evaluate(".//element[@Id='LOC02']", unloadingPoint);
						if(factoryNo != null){
							factoryNoStr = xpath.evaluate(".//element[@Id='LOC02']", factoryNo);
						}
					};
					
					String iv_column = srm_addr1+"^"+srm_addr2+"^"+srm_user_info+"^"+addr1+"^"+addr4+"^"+" / "+addr2+"^"+factoryNoStr;
					
					String req_user_id = "";
					
					
					/* 라인 정보 가져오기 */
					NodeList poDetails = (NodeList)xpath.evaluate("//loop[@Id='SG28']", document, XPathConstants.NODESET);
					
					//라인별 노드
					for( int idx=0; idx<poDetails.getLength(); idx++ ){
					
						pMap.clear();
						
						Node tNode = poDetails.item(idx);
				
						String legacy_po_seq = xpath.evaluate(".//segment[@Id='LIN']/element[@Id='LIN01']", tNode);
						String buyer_item_no = "";
						String ref_if_no = "";
						String status = xpath.evaluate(".//segment[@Id='LIN']/element[@Id='LIN02']", tNode).trim();
						String req_user_info ="";
						String hd_remark = ""; // unloading point
						
						/*SRM 발주 케이스*/
						if(legacy_po_no.startsWith("800")){
							buyer_item_no = xpath.evaluate(".//segment[@Id='PIA']/element[@Id='PIA02']/subelement[@Sequence='1']", tNode);
							ref_if_no = xpath.evaluate(".//segment[@Id='PIA']/element[@Id='PIA02']/subelement[@Sequence='1']", tNode);
							req_user_id = purchaser_user_id; // SRM 건물번호
							
						}
						/*SAP 발주 케이스*/
						else {
							buyer_item_no = xpath.evaluate(".//segment[@Id='LIN']/element[@Id='LIN03']/subelement[@Sequence='1']", tNode);
							ref_if_no = xpath.evaluate(".//segment[@Id='PIA']/element[@Id='PIA02']/subelement[@Sequence='1']", tNode);
							hd_remark = unloadingPointStr; // 언로딩 포인트
							if(hd_remark.equals("---")) hd_remark = "";
						}
						
						String description = xpath.evaluate(".//segment[@Id='IMD']/element[@Id='IMD03']/subelement[@Sequence='4']", tNode);
						String rd_date = xpath.evaluate(".//segment[@Id='DTM']/element[@Id='DTM01']/subelement[@Sequence='2']", tNode);
						String item_amt = xpath.evaluate(".//segment[@Id='MOA']/element[@Id='MOA01']/subelement[@Sequence='2']", tNode);
						String item_qty = xpath.evaluate(".//segment[@Id='QTY']/element[@Id='QTY01']/subelement[@Sequence='2']", tNode);
						String unit_price = xpath.evaluate(".//loop[@Id='SG32']/segment[@Id='PRI']/element[@Id='PRI01']/subelement[@Sequence='2']", tNode);
						String currency_code = xpath.evaluate(".//loop[@Id='SG32']/segment[@Id='CUX']/element[@Id='CUX01']/subelement[@Sequence='2']", tNode);
						String dely_to_location = "XX";
						
//						System.out.println(purchaser_user_id+"/"+legacy_po_no+"/"+ legacy_po_seq + "/" + buyer_item_no + "/" + ref_if_no + "/" + description+ "/" +rd_date + "/" + item_amt + "/" + item_qty + "/" + unit_price + "/" + currency_code);
						//System.out.println(legacy_po_no+"^"+legacy_po_seq+"^"+hd_remark+"^"+req_user_id+"^"+purchaser_user_id);
						
						req_user_info = req_user_info + " " + req_user_id;
						
						pMap.put("BUYER", "FAGB");
						pMap.put("LEGACY_PO_NO", legacy_po_no.trim());
						pMap.put("LEGACY_PO_SEQ", legacy_po_seq.trim());
						pMap.put("PLANT", plant.trim());
						pMap.put("BUYER_ITEM_NO", buyer_item_no.trim());
						pMap.put("DESCRIPTION", description.trim());
						/* 장지은 주임 품목명 비고1 추가 요청건 */
						pMap.put("REMARK", description.trim());
						pMap.put("RD_DATE", rd_date.trim());
						pMap.put("ITEM_AMT", item_amt.trim());
						pMap.put("ITEM_QTY", item_qty.trim());
						pMap.put("UNIT_PRICE", unit_price.trim());
						pMap.put("CURRENCY_CODE", currency_code.trim());
						pMap.put("IV_COLUMN", iv_column.trim());
						pMap.put("PURCHASER_USER_ID", purchaser_user_id.trim());
						pMap.put("REQ_USER_ID", req_user_id.trim());
						pMap.put("REF_IF_NO", ref_if_no.trim());
						pMap.put("ADD_DATE", add_date.trim());
						pMap.put("REQ_USER_INFO", req_user_info.trim());
						/* UNLOADING POINT 추가 건 */
						pMap.put("HD_REMARK", hd_remark.trim());
						pMap.put("DELY_TO_LOCATION",dely_to_location.trim());
						/*발주/발주변경 분기 필요.*/
						// ORDCHG
						// status = 1 -> added
						// status = 2 -> cancel
						// status = 3 -> changed
						
						if(status.equals("1")){
								pMap.put("STATUS", "C");
							}else if(status.equals("2")){
								pMap.put("STATUS", "D");
							}else if(status.equals("3")){
								pMap.put("STATUS", "R");
						}
						
						
						dao.insertPurchaseOrder(pMap);

						
					}
					
					long time = System.currentTimeMillis(); 
					SimpleDateFormat dayTime = new SimpleDateFormat("yyyymmddhhmmss");
					String cTime = dayTime.format(new Date(time));

					log.info(cTime+"_"+legacy_po_no+"_"+tf.getName() + "has processed");
					
					File mFile = new File(path+"back/"+cTime+"_"+legacy_po_no+"_"+tf.getName());
					
					/*renameTo 특성상 실패할 확률이 있어 반복문으로 구현*/
					for(int i=0;i<20;i++){	
						isMoved = tf.renameTo(mFile);
						if(isMoved){
							log.info("File moved to /back directory successfully");
							break;
						}
					}
				} catch (Exception e) {
					log.error("insertPurchaseOrder error");
					try {
						dao.informErrorOccurs(pMap);
					} catch (Exception e1) {
						log.error(this.getClass().getName() + " Error : " + e1.getMessage());
					}
				} 
		        				
			}
		}
		
		/* 디비 적용 */
		
		
		
		/* */
	}

}
