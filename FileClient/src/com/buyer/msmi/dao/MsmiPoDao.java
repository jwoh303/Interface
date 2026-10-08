package com.buyer.msmi.dao;

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

public class MsmiPoDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public MsmiPoDao() {
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
	
	public Map<String, String> MsmiPo_getBuyerItemNo(Map<String, String> pMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("MsmiPo_getBuyerItemNo", pMap);
	}
	
	public void Msmi_POIFLOAD_Insert(Map<String, String> item) throws SQLException {
		this.sqlMapper.update("Msmi_POIFLOAD_Insert", item);
	}
	public void POIFLOAD_Insert2(Map<String, String> item) throws SQLException {
		
            if ("C".equals(item.get("DATA_CLASSIFICATION"))) {
            	this.sqlMapper.update("Msmi_POIFLOAD_Insert2", item);
            } else {
            	this.sqlMapper.update("Msmi_POIFLOAD_Insert2_C", item);
            }
	}
	
	public void logWrite(Map<String, String> pMap) throws SQLException {

		List<Map<String, String>> chkSumInfo = null;
		int TOT_CNT = 0;
		int ERR_CNT = 0;
		int DEL_CNT = 0;
		
		chkSumInfo = this.sqlMapper.queryForList("MsmiPo_selectPoCheck", pMap);
		
		Map<String, String> iMap = chkSumInfo.get(0);
		TOT_CNT = Integer.parseInt(iMap.get("TOT_CNT"));
		ERR_CNT = Integer.parseInt(iMap.get("ERR_CNT"));
		DEL_CNT = Integer.parseInt(iMap.get("DEL_CNT"));
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
