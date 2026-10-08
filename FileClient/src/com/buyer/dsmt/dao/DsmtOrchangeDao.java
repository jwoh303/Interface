package com.buyer.dsmt.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

public class DsmtOrchangeDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public DsmtOrchangeDao() {
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
			// EX) conf/SqlMapConfig_KEPMP_Live.xml, conf/SqlMapConfig_KEPCON_Dev.xml
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	
	public boolean DI_ORDER_CHANGE_INSERT (Map<String, String> iMap)  {
		boolean bRtn = false;
		
		try {
			bRtn = true;
			this.sqlMapper.insert("DI_ORDER_CHANGE_INSERT", iMap);  
			
		} catch (Exception e) {
			bRtn = false;
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
	
	public void IF_PODT_Update (Map<String, String> iMap)  {

		try {
			if ("D".equals(iMap.get("STATUS"))) {
				this.sqlMapper.insert("IF_PODT_Update_D", iMap);
			} else {
				this.sqlMapper.insert("IF_PODT_Update_R", iMap);
			}
			
			this.sqlMapper.insert("IF_PROGRESS_UPDATE", iMap);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}	
}
