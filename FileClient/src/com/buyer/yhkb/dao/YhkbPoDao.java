package com.buyer.yhkb.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

public class YhkbPoDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public YhkbPoDao() {
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
	
	public boolean insertPodtYHKB(Map<String, String> pMap)  {
		boolean bRtn = false;
		
		try {
				this.sqlMapper.update("insertPodtYHKB", pMap);
				bRtn = true;
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
	public void YhkbMailSend(Map<String, String> pMap) {
		
		pMap.put("MAIL_RECEIVE_EMAIL","coolkim@koreab2b.com;comanche@koreab2b.com;junwoo.hong@koreab2b.com");
	    pMap.put("MAIL_RECEIVE_NAME", "김시원;김승우;홍준우");
	    pMap.put("BR", "<br>");
	    pMap.put("MAIL_CONTENTS",pMap.get("FILE_NAME"));
	    try {
			this.sqlMapper.insert("YhkbMailSend", pMap);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	}
}
