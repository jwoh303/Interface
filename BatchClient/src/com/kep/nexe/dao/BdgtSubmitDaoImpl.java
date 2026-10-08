package com.kep.nexe.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class BdgtSubmitDaoImpl implements BdgtSubmitDao {

	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	public BdgtSubmitDaoImpl() {
		try {
			String source	= "";
			if ("5".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_CZC_Live.xml";
			} else if ("6".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_CZC_Live.xml";
			} else if ("2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else if ("7".equals(CommonProperty.getDB_CONN()) || "8".equals(CommonProperty.getDB_CONN())) {
				source	= "conf/SqlMapConfig_CN_Live.xml";
			}else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("BdgtSubmitDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	/**
	 * 가져올 예산 정보 리스트 조회
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> selectNexeAccountCdList() throws Exception {
		return sqlMapper.queryForList("selectNexeAccountCdList");
	}

	@Override
	public void insertNexeBudget(Map<String, Object> resultMap) throws Exception {
		this.sqlMapper.insert("insertNexeBudget", resultMap);
	}
}
