package com.aeky.budget.send.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.aeky.budget.send.dao.AeKyRFCBudgetSendDao;

import com.aeky.budget.send.service.SapManager.SapRfcFunction;
import com.sap.conn.jco.JCoTable;

public class ZMRO_BD_CREATE extends AeKyRFCService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	public void execute() {
		String functionName	= "ZFI_MRO_ISSUE_EAI";
		AeKyRFCBudgetSendDao dao = new AeKyRFCBudgetSendDao();
		List<Map<String, String>> hMaps	= null;
		List<Map<String, String>> dMap	= null;
		
		try {
			super.openConnection();
			
			log.debug("############################################");
			log.debug("# SAP RFC START....");
			log.debug("# FUNCTION NAME : " + functionName);
			
			hMaps = dao.ZMRO_BD_LIST_HD();
			
			for(Map<String,String> iMap : hMaps) {
				SapRfcFunction rfc = this.sap.getRfcFunction(functionName);
				JCoTable h_tables = rfc.function.getTableParameterList().getTable("IT_HEADER");
				JCoTable d_tables = rfc.function.getTableParameterList().getTable("IT_ITEM");
				
				
				h_tables.setValue("BUKRS",	iMap.get("BUKRS")); // BUKRS
				h_tables.setValue("ZISSID",	iMap.get("ZISSID")); //ZISSID
				h_tables.setValue("ZMKDT",	iMap.get("ZMKDT")); //ZMKDT 	
				h_tables.setValue("HWAER",	iMap.get("HWAER")); //HWAER
				h_tables.setValue("HWBAS",	iMap.get("HWBAS")); //HWBAS
				h_tables.setValue("HWSTE",	iMap.get("HWSTE")); //HWSTE
				h_tables.setValue("ZTTAT",	iMap.get("ZTTAT")); //ZTTAT
				h_tables.setValue("ZORG_ID",	iMap.get("ZORG_ID")); //ZORG_ID
				
				System.out.println("iMap : " + iMap);
				
				dMap = dao.ZMRO_BD_LIST_DT();
				
				for(Map<String, String> pMap : dMap) {
					d_tables.appendRow();
					d_tables.setValue("BUKRS",	pMap.get("BUKRS")); //BUKRS
					d_tables.setValue("ZISSID",	pMap.get("ZISSID")); //ZISSID
					d_tables.setValue("MBLP",	pMap.get("MBLP")); //MBLP
					d_tables.setValue("KOSTL",	pMap.get("KOSTL")); //KOSTL
					d_tables.setValue("HKONT",	pMap.get("HKONT")); //HKONT
					d_tables.setValue("HWBAS",	pMap.get("HWBAS")); //HWBAS
					d_tables.setValue("HWSTE",	pMap.get("HWSTE")); //HWSTE
					d_tables.setValue("ZTTAT",	pMap.get("ZTTAT")); //ZTTAT
					System.out.println("pMap : " + pMap);
				}
				
				rfc.execute();
				
				String rtnCode = rfc.function.getExportParameterList().getString("E_RTCD");
			    String rtnMsg = rfc.function.getExportParameterList().getString("E_MSGTXT");
			    
			    System.out.println("rtnCode : " + rtnCode);
			    System.out.println("rtnMsg : " + rtnMsg);
			    
				h_tables.clear();
				d_tables.clear();
			}
			
			log.debug("# SAP RFC END....");
			log.debug("############################################");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
