package com.seller.msms.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class MsmsRsDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public MsmsRsDao() {
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
	public void PORS_Update(Map <String,String> iMap) throws SQLException {
		int cnt = (Integer)this.sqlMapper.queryForObject("MsmsPodt", iMap);
		
		if (cnt == 0) {
			iMap.put("ERROR_MSG", "발주내역 없음.");
			logwrite(iMap);
		}
		
		cnt = (Integer)this.sqlMapper.queryForObject("MsmsPors", iMap);
		
		if (cnt == 0 ) {
			iMap.put("ERROR_MSG", "예정정보 없음.");
			logwrite(iMap);
		}
		
		this.sqlMapper.update("MSMS_PODT_Update", iMap);
		this.sqlMapper.update("MSMS_PORS_Update", iMap);
		
	}
	
	
	public void logwrite (Map <String,String> iMap) throws SQLException {
		iMap.put("STAUTS", "C");
		iMap.put("IF_FLAG", "A");
		
		this.sqlMapper.update("MSMS_RS_logwrite",iMap);
		
	}
	
}
