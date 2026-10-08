package com.koreab2b.rfq.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.rfq.vo.RFQ_HEADER;

public class INFMPO0040_DaoImpl implements INFMPO0040_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public INFMPO0040_DaoImpl() {
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
	public int updateRfqCancel(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("updateRfqCancel", obj);
	}

	@Override
	public int insertRfqNegoRQDT(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("insertRfqNegoRQDT", obj);
	}

	@Override
	public int insertRfqNegoQTDT(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("insertRfqNegoQTDT", obj);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String,String>> selectBuyer(Map<String, String> obj) throws Exception {
		return this.sqlMapper.queryForList("selectBuyer", obj);
	}

	@Override
	public int updateQTDTClose(Map<String, String> obj) throws Exception {
		return this.sqlMapper.update("updateQTDTClose", obj);
	}
	
}
