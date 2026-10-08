package com.kep.cretec.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;

public class CretecIfIv extends CretecBaseImpl {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private String order_id		= "Iv";
	private String iv_url	= "/ctxext/relsDataByDate.do";
	private String callUrl	= "";
	
	public CretecIfIv(String jSessionID) {
		super();
		this.JSESSIONID = jSessionID;
	}

	public void statusIv(String gubun) {
		Map<String, Object> rMap = null;
		
		Map<String, String> iMap = new HashMap<String, String>();
		iMap.put("server_mode", CommonProperty.getDB_CONN());
		
		callUrl = this.cretec_domain+this.cretec_path+this.iv_url;
		
		try {
			rMap = super.sendHttpPost(callUrl, gubun);
			
			if("S".equals(rMap.get("flag"))) {
				JSONParser parser = new JSONParser();
				JSONArray ivResult = (JSONArray)parser.parse((String) rMap.get("response"));
				
				for (int i = 0; i < ivResult.size(); i++) {
					Map<String, String> resultMap	= new HashMap<String, String>();
					JSONObject getObj = (JSONObject) ivResult.get(i);
					
					if(!"".equals(getObj.get("KEP_PO_NO")) && getObj.get("KEP_PO_NO") != null ) {
						resultMap.put("SITE", "KA"); 
						resultMap.put("BUYER",((String) getObj.get("KEP_PO_NO")).substring(0, 10)); 
						resultMap.put("STATUS", (String) getObj.get("STATUS")); 
						resultMap.put("LEGACY_IV_NO", (String) getObj.get("LEGACY_IV_NO")); 
						resultMap.put("LEGACY_IV_SEQ", (String) getObj.get("LEGACY_IV_SEQ")); 
						resultMap.put("PO_NO",  ((String) getObj.get("KEP_PO_NO")).substring(11, 21));
						resultMap.put("PO_SEQ", ((String) getObj.get("KEP_PO_NO")).substring(22));
						resultMap.put("BUYER_ITEM_NO", (String) getObj.get("BUYER_ITEM_NO")); 
						resultMap.put("INVOICE_DATE", (String) getObj.get("INVOICE_DATE")); 
						resultMap.put("PARCEL_COM_CODE", (String) getObj.get("PARCEL_COM_CODE")); 
						resultMap.put("PARCEL_INV_NO", (String) getObj.get("PARCEL_INV_NO")); 
						resultMap.put("INV_QTY", Double.toString((double) getObj.get("INV_QTY"))); 
	
						dao.insertCretecIv(resultMap);
					}
				}
			} else {
					dao.insertCretecIvMail();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
}
