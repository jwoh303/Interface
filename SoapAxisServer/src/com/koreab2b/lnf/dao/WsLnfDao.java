package com.koreab2b.lnf.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.lnf.vo.AppData;
import com.koreab2b.lnf.vo.RtnVO;

public class WsLnfDao {

	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public WsLnfDao() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public RtnVO setApp(AppData iMap) {
		
		RtnVO rtn = new RtnVO();
		
		try {
			
		} catch (Exception e) {
			
		}
		
		return rtn;
	}
}
