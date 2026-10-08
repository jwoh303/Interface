package com.kep.hwDefense.app.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class AppSubmitDaoImpl implements AppSubmitDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public AppSubmitDaoImpl() {
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
			log.error("AppSubmitDao Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, Object>> selectAppResendList() throws Exception {
		return sqlMapper.queryForList("selectHwDefenseAppReSendList");
	}

	@Override
	public List<Map<String, String>> selectAppPassList(Map<String, String> pMap) throws Exception {
		return sqlMapper.queryForList("selectHwDefenseAppSubmitPassList", pMap);
	}

	@Override
	public void updateAppSubmitResult(Map<String, String> pMap) throws Exception {
		sqlMapper.update("updateHwDefenseSubmitResult", pMap);
	}

	@Override
	public List<Map<String, String>> selectHanhwaAttFileList(Map<String, Object> apmData) throws Exception {
		return sqlMapper.queryForList("selectHanhwaAttFileList", apmData);
	}
}