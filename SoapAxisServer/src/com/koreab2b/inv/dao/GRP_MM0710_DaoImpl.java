package com.koreab2b.inv.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

@SuppressWarnings("unchecked")
public class GRP_MM0710_DaoImpl implements GRP_MM0710_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public GRP_MM0710_DaoImpl() {
		try {
		      Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
		      this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		      log.error(e.getMessage());
		      throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public List<Map<String, String>> selectIVHeader(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectIVHeader", pMap);
	}

	@Override
	public List<Map<String, String>> selectIKDetail(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectIKDetail", pMap);
	}

	@Override
	public List<Map<String, String>> selectIKHeader(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectIKHeader", pMap);
	}

	@Override
	public List<Map<String, String>> selectIVDetail(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectIVDetail", pMap);
	}

	@Override
	public int saveIVLegacyIvSerial(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("saveIVLegacyIvSerial", pMap);
	}

	@Override
	public int saveIKLegacyIvSerial(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("saveIKLegacyIvSerial", pMap);
	}

	@Override
	public int saveLIKP(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("saveLIKP", pMap);
	}

	@Override
	public int saveLIPS(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("saveLIPS", pMap);
	}

	@Override
	public List<Map<String, String>> getIvTargets() throws Exception {
		return this.sqlMapper.queryForList("selectListIvTarget");
	}

}
