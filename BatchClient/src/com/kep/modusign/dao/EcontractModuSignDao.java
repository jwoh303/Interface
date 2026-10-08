package com.kep.modusign.dao;

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

@SuppressWarnings("unchecked")
public class EcontractModuSignDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private SqlMapClient sqlMap;

	public EcontractModuSignDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			log.debug("DB1 Connection Starting");
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
			log.debug("DB1 Connection Finishing");
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	/**
	 * 전자계약서 전송 대상을 조회한다.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectEcontSendList() throws Exception {
		return sqlMap.queryForList("selectEcontSendList");
	}
	
	/**
	 * 특정 업체에 대한 전자 계약서 정보를 조회한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> selectEcontInfo(Map<String, String> pMap) throws Exception {
		
		List<Map<String, String>> maps = sqlMap.queryForList("selectEcontInfo", pMap);
		Map<String, String> rtn = new HashMap<String, String>();
		rtn.clear();
		
		if (maps.size() > 0) {
			rtn.putAll(maps.get(0));
		}
		
		return rtn;
	}
	
	/**
	 * 전저계약서 전송이벤트에 대한 처리 결과를 저장한다.
	 * @param pMap
	 * @throws SQLException
	 */
	public void updateEcontResult(Map<String,String> pMap) throws SQLException {
		sqlMap.update("updateEcontSendResult", pMap);
		if ("Y".equals(pMap.get("RESULT_FLAG")) ) {
			sqlMap.update("updateEcDocId", pMap);	
		}
	}
	
	/**
	 * 전자계약서의 상태를 저장한다.
	 * @param pMap
	 * @throws SQLException
	 */
	public void updateEcontStatus(Map<String,String> pMap) throws SQLException {
		sqlMap.update("updateEcontStatus", pMap);
		
		// 계약완료시 업체승인 처리 한다.
		if ("F".equals(pMap.get("E_CONTRACT_TYPE"))) {
			sqlMap.update("updateEcontCmpy", pMap);
			sqlMap.update("updateEcontLusr", pMap);
			sqlMap.update("updateEcontSuplinfo2", pMap);
			sqlMap.update("updateEcontAcntsupl", pMap);
		}
	}
	
	/**
	 * 진행중인 전자계약서 목록을 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectEcontStatusList() throws Exception {
		return sqlMap.queryForList("selectEcontStatusList");
	}
}