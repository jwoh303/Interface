package com.buyer.fagb.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class FagbIdDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public FagbIdDao() {
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
	
	public boolean insertFagbId(Map<String, String> pMap)  {
		boolean bRtn = false;
		
		try {
			int vCnt = (Integer)this.sqlMapper.queryForObject("selectFagbIdEventCnt", pMap);
			if (vCnt == 0) {
				this.sqlMapper.insert("insertFagbId", pMap);
				bRtn = true;
			} else {
				log.debug("Dup : " + pMap.get("LEGACY_PO_NO") + " / " + pMap.get("LEGACY_PO_SEQ"));
			}
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
}