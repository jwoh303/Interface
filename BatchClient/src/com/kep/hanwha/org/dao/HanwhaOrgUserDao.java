package com.kep.hanwha.org.dao;

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

@SuppressWarnings("unchecked")
public class HanwhaOrgUserDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public HanwhaOrgUserDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("HanwhaOrgDao Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	/**
	 * 한화 COMPANY_ID 값 조회.
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String, String>> selectHanwhaCompanyID() throws SQLException {
		return this.sqlMapper.queryForList("selectHanwhaCompanyID");
	}

	/**
	 * KEP에 등록된 사용자 기준으로 목록 확인.
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String,String>> selectHanwhaKepUserList(Map<String, String> pMap) throws SQLException {
		return this.sqlMapper.queryForList("selectHanwhaKepUserList", pMap);
	}
	
	/**
	 * KEP에 등록된 부서 기준으로 정관리자의 목록을 추출한다.
	 * @return
	 * @throws SQLException
	 */
	public List<Map<String,String>> selectHanwhaOrgManagerList(Map<String, String> pMap) throws SQLException {
		return this.sqlMapper.queryForList("selectHanwhaOrgManagerList", pMap);
	}
	
	/**
	 * 확인된 사용자의 정보를 EAI.HANWHA_USER에 저장한다.
	 * @param pMap
	 * @return
	 * @throws SQLException
	 */
	public int mergeHanwhaOrgUser(Map<String, String> pMap) throws SQLException{
		return this.sqlMapper.update("mergeHanwhaOrgUser", pMap);
	}
}
