package com.koreab2b.fiber.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.dao.UpdateIfStatus_DaoImpl;

@SuppressWarnings("unchecked")
public class INFMPO0030_FBR_Dao {
	
	private static 	Logger		log		= Logger.getLogger(UpdateIfStatus_DaoImpl.class);
	private SqlMapClient sqlMapper;

	public INFMPO0030_FBR_Dao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public void updateIF_RfqTarget_FBR() throws SQLException {
		this.sqlMapper.update("updateIF_RfqTarget_FBR");
	}
	
	public void updateIF_RfqResult_FBR(Map<String, String> pMap) throws SQLException {
		this.sqlMapper.update("updateIF_RfqResult_FBR", pMap);
	}
	
	public List<Map<String, String>> selectSendList() throws SQLException {
		return sqlMapper.queryForList("selectSendListFBR");
	}
	
	public List<Map<String, String>> selectRfqHeaderList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectRfqHeaderListFBR", pMap);
	}
	
	public List<Map<String, String>> selectRfqItemList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectRfqItemListFBR", pMap);
	}
	
	public List<Map<String, String>> selectRfqVendorList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectRfqVendorListFBR", pMap);
	}
	
	public List<Map<String, String>> selectQtaHeaderList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectQtaHeaderListFBR", pMap);
	}
	
	public List<Map<String, String>> selectQtaItemList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectQtaItemListFBR", pMap);
	}
	
	public List<Map<String, String>> selectQtaRefVendorList(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectQtaRefVendorListFBR", pMap);
	}
}
