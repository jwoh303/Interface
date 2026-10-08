package com.koreab2b.common.dao;

import java.io.Reader;
import java.util.Date;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.vo.LogVo;

public class CommonDaoImpl implements CommonDao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public CommonDaoImpl() {
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
	public void saveLog(LogVo obj) throws Exception {
		
		Date toDay = new Date();
		log.info("INTERFACE_ID : " + obj.getINTERFACE_ID() + " / " + obj.getFLAG());
		this.sqlMapper.insert("insertWebServiceLog", obj);
	}
	
	@Override
	public void updateIfStatus(Map<String, String> pMap) throws Exception{
		this.sqlMapper.update("updateIfStatus", pMap);
	}
}
