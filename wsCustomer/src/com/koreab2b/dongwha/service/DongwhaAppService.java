package com.koreab2b.dongwha.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ;
import com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SOProxy;
import com.dongwha.COMMON.COMMON11.COMMON11_MRO_REQ_SOServiceLocator;
import com.dongwha.COMMON.COMMON11.COMMON11_MRO_RESP;
import com.koreab2b.dongwha.dao.COMMON11_MRO_REQROW_Dao;
import com.koreab2b.dongwha.dao.MM51_MRO_REQROW_Dao;

public class DongwhaAppService {
	private Logger log = Logger.getLogger(this.getClass());
	
	public void execute() throws Exception {
		
		
		COMMON11_MRO_REQROW_Dao dao = new COMMON11_MRO_REQROW_Dao();
		List<Map<String,String>> pMaps = dao.SelectDongWhaAppList();
		
		log.info(pMaps);
		
		String xmldata = getXml(pMaps);
		
		log.info("xmldata : " + xmldata);
		
		String arr[] = {"test","main"};

		  COMMON11_MRO_REQ arrReq = new COMMON11_MRO_REQ(
				  "MR202001220",
				  "PR20000",
				  arr,
				  "ORGEH",
				  "4002628",
				  xmldata,
				  "MM002",
				  "0001",
				  "KR",
				  "KO",
				  "K100",
				  "TEST",
				  "2000",
				  "TITLE"
				  );

		  
		  COMMON11_MRO_REQ_SOServiceLocator port = new COMMON11_MRO_REQ_SOServiceLocator();
		  
		  System.out.println("port.getHTTP_PortAddress() : " + port.getHTTP_PortAddress());
		  log.info("port.getHTTP_PortAddress() : " + port.getHTTP_PortAddress());
		  
		  COMMON11_MRO_REQ_SOProxy proxy = new COMMON11_MRO_REQ_SOProxy( port.getHTTP_PortAddress());
		  
		  log.info("AAAAAA");
		  
		  COMMON11_MRO_RESP  arrres = proxy.COMMON11_MRO_REQ_SO(arrReq);
			
		  log.info("arrres.getIFSTATUS() :  " + arrres.getIFSTATUS());
		  
	}
	
	public String getXml(List<Map<String,String>> objs) throws Exception {
		
//		System.out.println("amount : " + objs.get(0).get("AMOUT"));
		StringBuffer xml	= new StringBuffer();
		String BANFN = "";
		xml.append("<ROOT>");
		
		xml.append("  <HEADER>");
		xml.append("  <LANGUAGE>ENG</LANGUAGE>");
		xml.append("    <AMOUNT>" + "20000" + "</AMOUNT>");
		xml.append("  </HEADER>");
		
		xml.append("    <TABLE>");
		xml.append("    <RECORD>");

        for(Map<String,String> iMap : objs) {


            xml.append("<BANFN>PR18000002</BANFN>");
            xml.append("<BNFPO>000001</BNFPO>");
			xml.append("<ERNAM>"+iMap.get("ERNAM")+"</ERNAM>");
			xml.append("<NAME_TEXTC><![CDATA[이승헌]]></NAME_TEXTC>");  // ?
			xml.append("<PSTYP></PSTYP>");
			xml.append("<EKGRP></EKGRP>");
			xml.append("<EKNAM></EKNAM>");
			xml.append("<MATNR>"+iMap.get("MATNR")+"</MATNR>");
			xml.append("<TXZ01><![CDATA["+iMap.get("TXZ01")+"]]></TXZ01>");
			xml.append("<MENGE>"+String.valueOf(iMap.get("MENGE"))+"</MENGE>");
			xml.append("<MEINS>"+iMap.get("MEINS")+"</MEINS>");
			xml.append("<ZREQA>"+String.valueOf(iMap.get("ZREQA"))+"</ZREQA>");
//			xml.append("<WAERS>"+iMap.get("WAERS")+"</WAERS>");
			xml.append("<WAERS>KT00</WAERS>");
			
			xml.append("<WERKS>"+iMap.get("WERKS")+"</WERKS>");
			xml.append("<NAME1>"+iMap.get("NAME1")+"</NAME1>");
			xml.append("<LFDAT>"+iMap.get("LFDAT")+"</LFDAT>");			
			xml.append("<MATKL></MATKL>");
			xml.append("<WGBEZ><![CDATA[]]></WGBEZ>");
			xml.append("<AUFNR>　</AUFNR>");
			xml.append("<ZKTEXT><![CDATA[　]]></ZKTEXT>");
			xml.append("<FRGKZ></FRGKZ>");
			xml.append("<KTEXT><![CDATA["+iMap.get("KTEXT")+"]]></KTEXT>");
			xml.append("<TXT20><![CDATA["+iMap.get("TXT20")+"]]></TXT20>");
			xml.append("<GSTRP></GSTRP>");
			xml.append("<LGORT>"+iMap.get("LGORT")+"</LGORT>");
			xml.append("<LGOBE></LGOBE>");
			xml.append("<PREIS>"+String.valueOf(iMap.get("PREIS"))+"</PREIS>");
			xml.append("<ZIURL1><![CDATA[]]></ZIURL1>");
			xml.append("<ZIURL2><![CDATA[]]></ZIURL2>");
			xml.append("<ZIURL3><![CDATA[]]></ZIURL3>");
			xml.append("<WAERS1> </WAERS1>");
			xml.append("<ANLN1>"+iMap.get("ANLN1")+"</ANLN1>");
			xml.append("<BUDAT> </BUDAT> ");
			xml.append("<BPMNG> </BPMNG>");
			xml.append("<BPRME> </BPRME>");
			xml.append("<LBKUM> </LBKUM>");
			xml.append("<SLBKM> </SLBKM>");
			xml.append("<AVSTK> </AVSTK>");
			xml.append("<ZIURL><![CDATA[]]></ZIURL>");

        }
        
		xml.append("    </RECORD>");
		xml.append("  </TABLE>");
		xml.append("</ROOT>");
        
		return xml.toString();
	}
}
