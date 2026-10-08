package com.kep.josu.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.hwin.app.send.dao.AppSendDaoImpl;

public class JosuPoDaoImpl implements JosuPoDao {
	private static Logger log	= Logger.getLogger( AppSendDaoImpl.class.getName() );
	
	private SqlMapClient sqlMapper;
	
	public JosuPoDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Josu_Po_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Josu_Po_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppSendDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public void insertPohd(Map<String, Object> map) throws Exception {
		this.sqlMapper.update("insertPohd", map);	
	}
	

	@Override
	public void insertPodt(Map<String, Object> map) throws Exception {
		this.sqlMapper.update("insertPodt", map);	
	}

	@Override
	public void updatePohd(Map<String, Object> map) throws Exception {
		this.sqlMapper.update("updatePohd", map);	
		
	}

	@Override
	public void updatePodt(Map<String, Object> map) throws Exception {
		this.sqlMapper.update("updatePodt", map);	
		
	}

	@Override
	public int selectPoCnt(Map<String, Object> map) throws Exception {
		int rtnCnt = 0;
		rtnCnt = (Integer)this.sqlMapper.queryForObject("selectPoCnt", map);
		return rtnCnt;
	}

	@Override
	public int selectHdCnt(Map<String, Object> poSelectMap) throws Exception {
		int rtnCnt = 0;
		rtnCnt = (Integer)this.sqlMapper.queryForObject("selectHdCnt", poSelectMap);
		return rtnCnt;
	}

	@Override
	public int selectDtCnt(Map<String, Object> poSelectMap) throws Exception {
		int rtnCnt = 0;
		rtnCnt = (Integer)this.sqlMapper.queryForObject("selectDtCnt", poSelectMap);
		return rtnCnt;
	}

	//조선호텔 예산 사용 전송 시 vpn 연결 상태 확인용 
	@Override
	public int selectJosunPoCnt() throws Exception {
		int rtnCnt = 0;
		rtnCnt = (Integer)this.sqlMapper.queryForObject("selectJosunPoCnt");
		return rtnCnt;
	}
}
