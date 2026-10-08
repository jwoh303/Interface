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

@SuppressWarnings("unchecked")
public class GRP_MM0710_FBR_Dao {

	private Logger log = Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public GRP_MM0710_FBR_Dao() {
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
	
	public void updateIF_KOLON_LIKP_FBR() throws SQLException {
		sqlMapper.update("updateIF_KOLON_LIKP_FBR");
	}
	
	public List<Map<String, String>> selectFBRInvoiceList() throws SQLException {
		return sqlMapper.queryForList("selectFBRInvoiceList");
	}
	
	public List<Map<String, String>> selectFBRInvoiceHeader(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectFBRInvoiceHeader", pMap);
	}
	
	public List<Map<String, String>> selectFBRInvoiceDetails(Map<String, String> pMap) throws SQLException {
		return sqlMapper.queryForList("selectFBRInvoiceDetails", pMap);
	}
	
	public void updateLIKPResult(Map<String, String> pMap) throws SQLException {
		sqlMapper.update("updateFBRLIKPResult", pMap);
	}
	
	public void updateLIPSResult(Map<String, String> pMap) throws SQLException {
		sqlMapper.update("updateFBRLIPSResult", pMap);
	}
}
