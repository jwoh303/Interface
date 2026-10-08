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
public class ItSubmitDaoImpl implements ItSubmitDao {
	
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	
	public ItSubmitDaoImpl() {
		try {
			String source	= "";
			if ("5".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_CZC_Live.xml";
			} else if ("2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else if ("7".equals(CommonProperty.getDB_CONN()) || "8".equals(CommonProperty.getDB_CONN())) {
				source	= "conf/SqlMapConfig_CN_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("PrSubmitDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	
	@Override
	public List<Map<String, String>> selectItemTargetList() throws Exception {
		return sqlMapper.queryForList("selectNexeItemTargetList");
	}


	@Override
	public void updateNexeItSendResult(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.update("updateNexeItSendResult", resultMap);
	}


	@Override
	public void insertNexeItSendResult(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.insert("insertNexeItSendResult", resultMap);
		
	}


	@Override
	public void execQuotationSend() throws Exception {
		try {
			this.sqlMapper.update("execQuotationSend");
		} catch (Exception e) {
			log.error(this.getClass().getName() + "execQuotationSend Error : " + e.getMessage());
		}
	}


	@Override
	public void execRtnProcess() throws Exception {
		try {
			this.sqlMapper.update("execRtnProcess");
		} catch (Exception e) {
			log.error(this.getClass().getName() + "execRtnProcess Error : " + e.getMessage());
		}
	}

}
