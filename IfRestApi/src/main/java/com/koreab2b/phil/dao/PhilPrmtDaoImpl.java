package com.koreab2b.phil.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

@Repository("philPrmtDao")
public class PhilPrmtDaoImpl implements PhilPrmtDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(PhilPrmtDaoImpl.class);	
	private SqlMapClient sqlMapper;	
	
	public PhilPrmtDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_PRMT_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_PRMT_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error("####### PhilPrmtDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public void insertPointBatch(List<Map<String, Object>> pointList) throws Exception {
		// 실제 INSERT 전에 연결 확인
	    checkConnection();
		int idx = 0;
		
		for (Map<String, Object> paramMap : pointList) {
			idx++;
			try {
				this.sqlMapper.insert("insertPointBatch", paramMap);
			} catch (Exception e) {
				LOGGER.error("insertPointBatch DAO ERR INDEX :: " + idx, e);
				throw new Exception("insertPointBatch err idx : " + idx, e);
			}
		}

	}
	
	private void checkConnection() throws Exception {
	    try {
	        this.sqlMapper.queryForObject("checkConnection");
	    } catch (Exception e) {
	        LOGGER.warn("MySQL 유휴 커넥션 오류, 새 커넥션으로 재시도", e);
	        // 두 번째도 실패하면 그대로 예외 발생
	        this.sqlMapper.queryForObject("checkConnection");
	    }
	}


}
