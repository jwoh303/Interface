package com.kep.cretec.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.xpath.XPathConstants;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;

public class CretecItem extends CretecBaseImpl {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private String item_id	= "ProductSearch";
	private String item_url	= "/ctxext/productsearch.do";
	private String callUrl	= "";

	public CretecItem(String jSessionID) {
		super();
		this.JSESSIONID = jSessionID;
	}

	public void checkItemInfo() {
		
		List<Map<String, String>> itemList	= null;
		int cnt	= 0;
		String sellerItemNos	=	"";
		boolean	bSuccess	= false;

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			dao.deleteCretecItemInfo();
			itemList	= dao.getItemCheckList();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( itemList.size() ));
			
			for(Map<String, String> iMap : itemList) {
				
				if ( cnt%50 == 0 ) {
					sellerItemNos	= iMap.get("SELLER_ITEM_NO");
				} else {
					sellerItemNos	+= "," + iMap.get("SELLER_ITEM_NO");
				}
				
				if ( cnt%50 == 49 ) {
					bSuccess	= getCretecItemInfo(sellerItemNos);
					if (bSuccess) {
						log.info("Cretec Item Progress .... " + (cnt + 1) );
					} else {
						log.info("ItemInfo Error : " + sellerItemNos);
					}
					sellerItemNos	= "";
				}
				cnt++;
			}
			
			if (cnt > 0 && cnt%50 != 0 ) {
				bSuccess	= getCretecItemInfo(sellerItemNos);
				if (bSuccess) {
					log.info("Cretec Item Progress .... " + cnt);
				} else {
					log.info("ItemInfo Error : " + sellerItemNos);
				}
			}
			
		} catch (Exception e) {
			log.error("checkItemInfo Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
	
	/**
	 * Comment : 크레텍 품목중에서 단종 처리된 내역에 대해서 단종 처리함.
	 * 1. GPL 정보의 단종여부 변경.
	 * 2. 특정 고객사의 경우 재고유무까지 판단해서 단종여부 변경.
	 */
	public void closeItem() {
		
		try {
			
			List<Map<String, String>> targetList	= dao.getCretecTargetCatalogList();
			dao.deleteAlertList();
			
			for(Map<String, String> iMap : targetList) {
				dao.insertCretecItemCloseAlertList(iMap);
				dao.updateCretecItemClose(iMap);
				dao.insertCretecItemRecoverAlertList(iMap);
				dao.updateCretecItemRecover(iMap);
			}
			
		} catch (Exception e) {
			log.error("closeItem Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	private boolean getCretecItemInfo(String sellerItemNos) {

		boolean bRtn = false;
		Document xmlDoc	= null;
		Map<String, Object> rMap = null;
		String stockYn	= "";
		String item_use_cd	= "";
		int rCnt	= 0;
		String itemCnt	= "";
		
		try {
			xmlDoc	= super.getDocument(this.item_id);
			Element	root	= xmlDoc.getDocumentElement();
			Element body	= xmlDoc.createElement(this.item_id);
			
			body.setAttribute("start", "1");
			body.setAttribute("end", "50");
			
			Element item_cd	= xmlDoc.createElement("item_cd");
			Element search			= xmlDoc.createElement("search");
			Element item_nm			= xmlDoc.createElement("item_nm");
			Element brnd_nm			= xmlDoc.createElement("brnd_nm");
			Element item_stdz		= xmlDoc.createElement("item_stdz");
			Element modl_no			= xmlDoc.createElement("modl_no");
			Element item_remd_cd	= xmlDoc.createElement("item_remd_cd");
			Element procode			= xmlDoc.createElement("procode");
			procode.setTextContent(sellerItemNos);

			body.appendChild(search);
			body.appendChild(item_nm);
			body.appendChild(brnd_nm);
			body.appendChild(item_stdz);
			body.appendChild(modl_no);
			body.appendChild(item_remd_cd);
			body.appendChild(procode);
			body.appendChild(item_cd);
			root.appendChild(body);
			
			callUrl	= this.cretec_domain+this.cretec_path+this.item_url;
			rMap	= super.sendHttpPost(callUrl, xmlDoc);

			if ("S".equals(rMap.get("RTN_FLAG"))) {
				bRtn = true;
				
				Document rDoc = (Document)rMap.get("RTN_DATA");
				
				NodeList itemRtns	= (NodeList) this.xpath.evaluate("/Response/ProductSearch/Product", rDoc, XPathConstants.NODESET);
				itemCnt	= (String) this.xpath.evaluate("/Response/ProductSearch/total", rDoc, XPathConstants.STRING);
				
				for ( int i = 0 ; i < itemRtns.getLength(); i++) {
					rCnt++;
					Node iNode = itemRtns.item(i);
					
					HashMap<String, String> iMap	= new HashMap<String,String>();
					
					super._dataNode	=	iNode;

					// 재고 유무 확인
					stockYn	= "Y";
					if ( "무".equals(super.getXmlString("d1sum")) && "무".equals(super.getXmlString("s1sum"))) {
						stockYn = "N";
					}

					// 상품 사용 상태 확인.
					item_use_cd	= super.getXmlString("item_use_cd"); 
					
					iMap.put("SELLER_ITEM_NO", super.getXmlString("prod_cd").replace("-",""));
					iMap.put("DESCRIPTION", super.getXmlString("item_nm"));
					iMap.put("SPECIFICATION", super.getXmlString("item_stdz"));
					iMap.put("UNIT_MEASURE", super.getXmlString("unit_nm"));
					iMap.put("MOQ_QTY", super.getXmlString("moq_qty"));
					iMap.put("PUR_UNIT_QTY", super.getXmlString("rels_unit_qty"));
					iMap.put("STOCK_YN", stockYn);
					iMap.put("MAKER_NAME", super.getXmlString("brnd_nm"));
					iMap.put("MODEL_NO", super.getXmlString("modl_no"));
					iMap.put("PRODUCT_CLOSE_FLAG", item_use_cd);
					iMap.put("STATUS", item_use_cd);
					iMap.put("AGENT_PRICE", super.getXmlString("std_unit_pric"));
					iMap.put("SALES_PRICE", super.getXmlString("std_sale_pric"));
					
					// 품목 데이터 저장.
					dao.insertCretecItemInfo(iMap);
				}
				
			} else {
				bRtn = false;
			}
		} catch (Exception e) {
			log.error("checkItems Error : " + CommonUtil.printStackTraceToString(e));
			bRtn = false;
		}

		log.debug("sellerItemNos[" + itemCnt + " / " + rCnt + "] : " +sellerItemNos);
		
		return bRtn;
	}
	
	public void changeItemStatus() {
		try {
			dao.updateCretecItemStatus();	
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
}