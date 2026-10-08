package com.master.mall.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.vo.GrdtVo;

public class WmsBarDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public WmsBarDao() {
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
	
	public boolean insertWmsBar (Map<String, String> iMap)  {
		boolean bRtn = false;
		
		try {
			bRtn = true;
			this.sqlMapper.insert("insertWmsBar", iMap);  
			
		} catch (Exception e) {
			bRtn = false;
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
		return bRtn;
	}
	
	public void logWrite(Map<String, String> pMap) throws SQLException {

		List<Map<String, String>> chkSumInfo = null;
		int TOT_CNT = 0;
		int ERR_CNT = 0;
		int DEL_CNT = 0;

		if (TOT_CNT == DEL_CNT) pMap.put("STATUS", "D");
		else pMap.put("STATUS", "C");
		
		pMap.put("REMARK", pMap.get("FILE_NAME"));
		if ( pMap.get("IF_CHK_FLAG").equals("E") || TOT_CNT == 0 ) {
			pMap.put("IF_FLAG", "A");
			pMap.put("ERR_MSG", "I/F파일 오류입니다(전산실문의)!!!");
		} else {
			if (ERR_CNT == 0) {
				pMap.put("IF_FLAG", "Z");
				pMap.put("ERR_MSG", "작업중입니다!!!");
			} else {
				pMap.put("IF_FLAG", "A");
				pMap.put("ERR_MSG", "데이타에 오류가 있습니다!!!");
			}
		}
		try {
			this.sqlMapper.update("mergeIfProgress", pMap);
			this.sqlMapper.update("updateIfAdmin", pMap);
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
	
}
