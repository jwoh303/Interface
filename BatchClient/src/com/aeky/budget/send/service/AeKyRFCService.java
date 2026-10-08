package com.aeky.budget.send.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.aeky.budget.send.dao.AeKyRFCBudgetSendDao;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class AeKyRFCService {
	private Connection conn	= null;
	public SapManager sap = new SapManager("SAP");
	JCoDestination destination;
	private IFProperties prop = null;
	public AeKyRFCBudgetSendDao dao = new AeKyRFCBudgetSendDao();
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	public int numberOfRows;
	public int numberOfCols;
	
	public void openConnection() {
		try {
			
			List<Map<String, String>> jco_connInfo = dao.getRfcAeKyProperties();
			
			log.debug("** Properties : " + jco_connInfo.get(0).get("JCO_CLIENT")  + " / " + jco_connInfo.get(0).get("JCO_USER")  + " / " + jco_connInfo.get(0).get("JCO_PASSWD")  + " / " + jco_connInfo.get(0).get("JCO_LANG")  + " / " + jco_connInfo.get(0).get("JCO_ASHOST")  + " / " + jco_connInfo.get(0).get("JCO_SYSNR") + " / ");

			this.sap = SapManager.newSapManagerBinder()
					.set(DestinationDataProvider.JCO_CLIENT,	jco_connInfo.get(0).get("JCO_CLIENT"))
					.set(DestinationDataProvider.JCO_USER,		jco_connInfo.get(0).get("JCO_USER"))
					.set(DestinationDataProvider.JCO_PASSWD,	jco_connInfo.get(0).get("JCO_PASSWD"))
					.set(DestinationDataProvider.JCO_LANG,		jco_connInfo.get(0).get("JCO_LANG"))
					.set(DestinationDataProvider.JCO_ASHOST,	jco_connInfo.get(0).get("JCO_ASHOST"))
					.set(DestinationDataProvider.JCO_SYSNR,		jco_connInfo.get(0).get("JCO_SYSNR"))
					.set(DestinationDataProvider.JCO_GROUP,		jco_connInfo.get(0).get("JCO_GROUP"))
					.set(DestinationDataProvider.JCO_R3NAME,	jco_connInfo.get(0).get("JCO_R3NAME"))
					.bind();
            
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Map<String, String>> receiveTable(JCoTable tables) {

        this.numberOfRows = tables.getNumRows();
        this.numberOfCols = tables.getFieldCount();
        
        List<Map<String, String>> ret = new ArrayList<Map<String, String>>();
        
        try {
	        if (numberOfRows > 0) {
	        	do {
	        		Map<String, String> dataMap = new HashMap<String, String>();

	        		for (JCoFieldIterator e = tables.getFieldIterator(); e.hasNextField(); ) {
	        			JCoField field = e.nextField();

	        			dataMap.put(field.getName(), field.getString());

	        			log.debug("filedName : "+ field.getName() +", filedValue : "+field.getString());

		            }
	        		ret.add(dataMap);
	        	}
	        	while (tables.nextRow());
	        } else {
	        	log.debug( "Return:No results found!");
	        }

		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		}

        return ret;
    }
}
