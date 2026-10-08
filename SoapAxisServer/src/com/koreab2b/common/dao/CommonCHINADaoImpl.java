package com.koreab2b.common.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.vo.LogVo;

public class CommonCHINADaoImpl implements CommonCHINADao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public CommonCHINADaoImpl() {
		try {
		      Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig_KEPCON.xml");
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
		
		System.out.println("INTERFACE_ID : " + obj.getINTERFACE_ID());
		
		this.sqlMapper.insert("insertWebServiceLog", obj);
	}

}
