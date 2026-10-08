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

public class SgsDaoDevImpl implements SgsDao {
	
	private Logger LOGGER = LoggerFactory.getLogger(SgsDaoDevImpl.class);

	private SqlMapClient sqlMap;

	public SgsDaoDevImpl() {
		try {
			String source	= "conf/SqlMapConfig_Dev.xml";
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
			
			System.out.println("pMap.get(\"dely_to_location_code\") :::" +pMap.get("dely_to_location_code"));
			System.out.println("null::"+ pMap.get("dely_to_location_code") == null);
			System.out.println("qlsrkqt :: " + pMap.get("dely_to_location_code").equals(""));
			
			if(pMap.get("dely_to_location_code") == null && pMap.get("dely_to_location_code").equals("")){
				System.out.println("pMap.dely_to_location_code IS NULL !!!!!");
				pMap.put("dely_to_location_code",pMap.get("dely_to_location_code_name"));
			}
			System.out.println("pMap :::" + pMap);
			sqlMap.update("insertSgsPo", pMap);
		}
		_rtnMsg = "SUCCESS";
		
		return _rtnMsg;
	}

	public void saveLog(Map<String, String> pMap) throws Exception {
		sqlMap.insert("insertWebServiceLog", pMap);
	}

}
