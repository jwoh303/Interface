package com.koreab2b.extern.buyer.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonUtil;

public class SgsDaoLiveImpl implements SgsDao {
	
	private Logger LOGGER = LoggerFactory.getLogger(SgsDaoLiveImpl.class);

	private SqlMapClient sqlMap;

	public SgsDaoLiveImpl() {
		try {
			String source	= "conf/SqlMapConfig_Live.xml";
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMap = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error(this.getClass().getName() + " Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public String saveSgsPurchaseOrder(List<Map<String, String>> pMaps) throws Exception {
		String _rtnMsg 	= "";

		for(Map<String, String> pMap : pMaps) {	
			sqlMap.update("insertSgsPo", pMap);
		}
		_rtnMsg = "SUCCESS";
		
		return _rtnMsg;
	}

	public void saveLog(Map<String, String> pMap) throws Exception {
		sqlMap.insert("insertWebServiceLog", pMap);
	}

}
