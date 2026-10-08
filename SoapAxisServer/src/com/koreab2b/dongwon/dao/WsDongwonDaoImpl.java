package com.koreab2b.dongwon.dao;

import java.io.Reader;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.dongwon.vo.POData;
import com.koreab2b.dongwon.vo.Response;

public class WsDongwonDaoImpl implements WsDongwonDao {
	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public WsDongwonDaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public Response savePO(POData iMap) {
		Response rMap	= new Response();
		try {
			sqlMapper.startTransaction();
			sqlMapper.insert("insertPODT_UC", iMap);	
			
			// 실행 가능한 상태로 변경
			sqlMapper.update("updatePODT_UC");
			
			sqlMapper.commitTransaction();
			rMap.setMESSAGE("SUCCESS");
			rMap.setTYPE("S");
		} catch (Exception e) {
			e.printStackTrace();
			rMap.setMESSAGE("Error : " + CommonUtil.printStackTraceToString(e));
			rMap.setTYPE("F");
			log.error("WsDongwonDao savePO Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			try {
				sqlMapper.endTransaction();
			} catch (SQLException e2) {
				e2.printStackTrace();
			}
		}
		
		return rMap;
	}
}