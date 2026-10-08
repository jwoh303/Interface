package com.seller.msms.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class MsmsPoDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public MsmsPoDao() {
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
		return (Integer)this.sqlMapper.queryForObject("MSMS_PO_DBDispatcher");
	}
	public List<Map<String, String>> TRXL_Select() throws SQLException {
		this.sqlMapper.update("MSMS_PO_TRXL_Dequeue");
		return this.sqlMapper.queryForList("MSMS_PO_TRXL_Select");
	}
	public List<Map<String, String>>  POHD_Select(Map<String, String> tMap) throws SQLException{
		return this.sqlMapper.queryForList("MSMS_POHD_Select", tMap);
	}
	
	public Map<String, String> REQ_Info (Map<String, String> iMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("REQ_Info", iMap);
	}
	public Map<String, String> ADD_Info (Map<String, String> iMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("ADD_Info", iMap);
	}
	public Map<String, String> COM_Info_IRS (Map<String, String> iMap) throws SQLException {
		Map<String, String> COM = (Map<String, String>)this.sqlMapper.queryForObject("COM_Info_IRS1", iMap);
		
		if (COM.size() == 0) {
			COM = (Map<String, String>)this.sqlMapper.queryForObject("COM_Info", iMap);
		}
		return COM;
	}
	public Map<String, String> COM_Info (Map<String, String> iMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("COM_Info", iMap);
	}
	
	public Map<String, String> getReq (Map<String, String> iMap) throws SQLException {
		
		String legacy_po_no = iMap.get("LEGACY_PO_NO");
		
		 if (!" ".equals(legacy_po_no)) {
			legacy_po_no =  iMap.get("LEGACY_PO_NO").substring(0,2);
		 } 
		
		if("2".equals(iMap.get("PROCESS_TYPE")) && !"KRSAMS0123".equals(iMap.get("BUYER"))) {
			return (Map<String, String>)this.sqlMapper.queryForObject("getReq1", iMap);
		} else if ("KRHWAS0045".equals(iMap.get("BUYER"))) {
			Map<String, String> REQ = (Map<String, String>)this.sqlMapper.queryForObject("getReq2", iMap);
			if (REQ.size() == 0) {
				REQ.put("REQ_USER_INFO", " ");
			}
			return REQ;
		} else if ("KRDOOD0001".equals(iMap.get("BUYER")) || "KRHWAS0045".equals(iMap.get("KRDOOS0004"))) {
			Map<String, String> REQ = (Map<String, String>)this.sqlMapper.queryForObject("getReq3", iMap);
			if (REQ.size() == 0) {
				REQ.put("REQ_USER_INFO", " ");
			}
			return REQ;
		} 
		else if("KRDONG0838".equals(iMap.get("BUYER")) || "OF".equals(legacy_po_no)) {
			Map<String, String> REQ = (Map<String, String>)this.sqlMapper.queryForObject("getReq4", iMap);
			if (REQ.size() == 0) {
				REQ.put("REQ_USER_INFO", " ");
			}
			return REQ;
		} else {
			Map<String, String> REQ = new HashMap<String,String>();
			REQ.put("REQ_NAME", iMap.get("REQ_NAME"));
			REQ.put("REQ_TEL", iMap.get("REQ_TEL"));
			REQ.put("REQ_USER_INFO", iMap.get("REQ_USER_INFO"));
			
			return REQ;
		}
	}
	
	public Map<String, String> getHub (Map<String, String> iMap) throws SQLException {
		Map<String, String> HUB = (Map<String, String>)this.sqlMapper.queryForObject("getHub", iMap);
		if (HUB.size() == 0) {
			HUB.put("HUB_NAME", " ");
			HUB.put("HUB_ZIP", " ");
			HUB.put("HUB_ADD", " ");
			
		}
		return HUB;
	}
	public Map<String, String> getKEP (Map<String, String> iMap) throws SQLException {
		Map<String, String> KEP = (Map<String, String>)this.sqlMapper.queryForObject("getKEP", iMap);
		
		return KEP;
	}
	
	public void POHD_SendUpdate (Map<String, String> iMap) throws SQLException {
		this.sqlMapper.update("MSMS_POHD_SendUpdate", iMap);
	}
	public void PODT_SendUpdate (Map<String, String> iMap) throws SQLException {
		this.sqlMapper.update("MSMS_PODT_SendUpdate", iMap);
	}
	public void TRXL_Delete (Map<String, String> iMap) throws SQLException {
		this.sqlMapper.delete("MSMS_TRXL_Delete", iMap);
	}

	public int getBuyerInfo(Map<String, String> iMap) throws SQLException{
		return (Integer)this.sqlMapper.queryForObject("MSMS_getBuyerInfo", iMap);
	}

	public List<Map<String, String>> getMailContent(Map<String, String> iMap) throws Exception{
		return this.sqlMapper.queryForList("Msms_Mail_Content", iMap);
	}

	public void insertMail(Map<String, String> mailMap) throws SQLException{
		this.sqlMapper.insert("Msms_Mail_Send", mailMap);
	}

	public void insertCode(Map<String, String> iMap) throws SQLException {
		this.sqlMapper.insert("Msms_code_insert", iMap);
		
	}
	
}
