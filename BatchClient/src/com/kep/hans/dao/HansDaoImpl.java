package com.kep.hans.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class HansDaoImpl implements HansDao {

	private static Logger log	= Logger.getLogger(HansDaoImpl.class.getName() );
	
	private SqlMapClient sqlMapper;
	
	public HansDaoImpl() {
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
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
		
		
	}
	@Override
	public List<Map<String, Object>> selectHansPrTargetList() throws Exception {
		return sqlMapper.queryForList("selectHansPrTargetList");
	}
	
	@Override
	public List<Map<String, Object>> selectPrList(Map<String, Object> map) throws Exception {
		return sqlMapper.queryForList("selectHansPrList", map);
	}
	@Override
	public List<Map<String, Object>> selectHansGrList() throws Exception {
		return sqlMapper.queryForList("selectHansGrList");
	}
	@Override
	public void updatePrResult(Map<String, Object> paramMap) throws Exception {
		this.sqlMapper.update("updateHansResultData", paramMap);
		this.sqlMapper.update("updateHansLegecyPoInfo", paramMap);
	}
	@Override
	public void updatePrError(Map<String, Object> errorMap) throws Exception{
		this.sqlMapper.update("updateHansResultData", errorMap);
		
	}
	@Override
	public List<Map<String, Object>> selectHansPoStatusList() throws Exception {
		return sqlMapper.queryForList("selectHansPoStatusList");
	}
	@Override
	public void updatePoStatusResult(Map<String, Object> paramMap) throws Exception {
		this.sqlMapper.update("updateHansPoStatus", paramMap);
		
	}
	@Override
	public void updateHansGr(Map<String, Object> iMap) throws Exception {
		this.sqlMapper.update("updateHansGr", iMap);
	}
	@Override
	public List<Map<String, String>> selectMailInfo(Map<String, Object> errorMap) throws Exception {
		return sqlMapper.queryForList("selectHansMailInfo", errorMap);
	}
	@Override
	public void insertHansMail(Map<String, Object> errorMap) throws Exception {
		this.sqlMapper.insert("insertHansMail", errorMap);
	}
	@Override
	public void updateIfProgress(List<Map<String, Object>> successList) throws Exception {
		this.sqlMapper.update("insertHansIfProgress", successList.get(0));
	}

}
