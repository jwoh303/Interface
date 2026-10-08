package com.kep.mail.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class SendMailDaoImpl implements SendMailDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public SendMailDaoImpl() {
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
	public List<Map<String, String>> getTargetList() throws Exception {
		return this.sqlMapper.queryForList("selectMailTargetList");
	}

	@Override
	public List<Map<String, Object>> getExcelDataList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectArDataList",pMap);
	}

	@Override
	public void setResult(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateEvent", pMap);
	}

	@Override
	public List<Map<String, String>> getCretecItemTargetList() throws Exception {
		return null;
	}

	@Override
	public List<Map<String, String>> selectCowayScrapRecvMailList() throws Exception {
		return this.sqlMapper.queryForList("selectCowayScrapRecvMailList");
	}

	@Override
	public List<Map<String, Object>> selectCowayScrapList(Map<String, String> iMap) throws Exception {
		return this.sqlMapper.queryForList("selectCowayScrapList", iMap);
	}
}