package com.buyer.daew.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class DaewIvDownDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public DaewIvDownDao() {
		try {	
			String source	= "";
			
			String dbConn = "";	// 2:운영, 0:개발
			String dbType = CommonProperty.getDB_TYPE();	// KEPMP, KEPCON

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				dbConn = "Live";
			} else {
				dbConn = "Dev";
			}
			
			source = "conf/SqlMapConfig_"+dbType+"_"+dbConn+".xml";
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public int DBDispatcher() throws SQLException {
		return (Integer)this.sqlMapper.queryForObject("DaewIvDown_DBDispatcher");
	}
	public List<Map<String, String>> DBDispatcherList() throws SQLException {
		return this.sqlMapper.queryForList("DaewIvDown_DBDispatcherList");
	}
	public int SEND_Check(Map<String,String> iMap) throws SQLException {
		int cnt1 = (Integer)this.sqlMapper.queryForObject("SEND_Check1", iMap);
		int cnt2 = (Integer)this.sqlMapper.queryForObject("SEND_Check2", iMap);
		
		return cnt1 + cnt2;
	}
	public List<Map<String, String>> IVDT_Select(Map<String,String> iMap) throws SQLException{
		return this.sqlMapper.queryForList("DaewIvDown_IVDT_Select", iMap);  
	}
	public void TrxlUpdate(Map<String, String> iMap) throws SQLException {
		this.sqlMapper.update("DaewIvDown_TrxlUpdate", iMap);
	}
	public void IVHD_Update(Map<String, String> iMap) throws SQLException {
		
		
		String ret = "";
		
		if ("000".equals(iMap.get("LEGACY_IV_SERIAL"))) {
			Map<String, String> tMap = (Map<String, String>)this.sqlMapper.queryForObject("IV_SERIAL"); 
			ret = tMap.get("TEMP_LEGACY_IV_SERIAL");
		} else {
			ret = iMap.get("LEGACY_IV_SERIAL");
		}
		
		iMap.put("LEGACY_IV_SERIAL", ret);
		
		if ("0".equals(iMap.get("PROCESS_TYPE"))) {
			this.sqlMapper.update("IVHD_Update2", iMap);
		} else {
			this.sqlMapper.update("IVHD_Update1", iMap);
		}
	}
	public void TRXL_Dequeue(Map<String, String> iMap) throws SQLException {

			this.sqlMapper.delete("DaewIvDown_TRXL_Dequeue", iMap);
		
	}
	public String IVDT_Assign(Map<String, String> iMap) throws SQLException {
		String str = "DL";
		str = str + iMap.get("DATE");
		str = str + "DL";
		str = str + iMap.get("SEQ");
		str = str + "/";
		str = str + String.valueOf(iMap.get("INV_SEQ"));
		str = str + "/";
		str = str + iMap.get("LEGACY_PO_NO");
		str = str + "/";
		str = str + iMap.get("LEGACY_PO_SEQ");
		str = str + "/";
		str = str + iMap.get("INVOICE_DATE");
		str = str + "/";
		str = str + String.valueOf(iMap.get("INV_QTY"));
		str = str + "/";
		str = str + iMap.get("CAR_NO");
		str = str + "/";
		str = str + iMap.get("CAR_PERSON_NAME");
		
		return str;
	}
}
