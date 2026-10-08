package com.kep.josu.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.hwin.app.send.dao.AppSendDaoImpl;

@SuppressWarnings("unchecked")
public class JosuKepmpDaoImpl implements JosuKepmpDao {

	private static Logger log	= Logger.getLogger( AppSendDaoImpl.class.getName() );

	private SqlMapClient sqlMapper;
	
	public JosuKepmpDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
		
		
	}

	/**
	 * 조선호텔 예산 대상을 조회한다.
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, String>> selectbdgtList() throws Exception {
		return sqlMapper.queryForList("selectbdgtList");
	}


	/**
	 * 조선호텔 예산 정보 동기화
	 * @return
	 * @throws Exception
	 */
	@Override
	public int insertBdgt(Map<String, Object> paramMap)throws Exception {
		int result = 1;
		try {
			this.sqlMapper.update("insertBdgt", paramMap);	
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
		}
		return result;
	}

	/**
	 * 사용예산 조선호텔에 전송 후 결과 값 update
	 * @return
	 * @throws Exception
	 */
	@Override
	public void updateResult(Map<String, Object> paramMap) throws Exception {
		this.sqlMapper.update("updateResult", paramMap);	
	}

	
	
	/**
	 * 전송한 조선호텔 예산 정보 조회
	 * @return
	 * @throws Exception
	 */
	@Override
	public void updateIfFlag(Map<String, Object> updateMap) throws Exception {
		this.sqlMapper.update("updateIfFlag", updateMap);	
		
	}

	/**
	 * 전송한 조선호텔 예산 정보 조회
	 * @return
	 * @throws Exception
	 */
	@Override
	public void updateRevFlag(Map<String, Object> updateMap) throws Exception {
		this.sqlMapper.update("updateRevFlag", updateMap);	
		
	}
	
	
	/**
	 * 예산 동기화 후에 처리 프로시져 실행
	 * @return
	 * @throws Exception
	 */
	@Override
	public void callProcBdgt() throws Exception {
		this.sqlMapper.update("PROC_JOSUN_BDGT");
		
	}

	/**
	 * 전송한 조선호텔 예산 정보 조회 hd
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectbdgtSendListHd() throws Exception {
		return sqlMapper.queryForList("selectbdgtSendListHd");
	}

	
	/**
	 * 전송한 조선호텔 예산 정보 조회
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectbdgtSendList(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlMapper.queryForList("selectbdgtSendList", map);
	}


	/**
	 * 조선호텔 디비 컨넥션 체크
	 * @return
	 * @throws Exception
	 */
	@Override
	public void insertJosuDbChk(Map<String, Object> selectMap) throws Exception {
		this.sqlMapper.update("insertJosuErr", selectMap);	 
		
	}
	
	/**
	 * 전송될 마감 데이터 조회
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map<String, Object>> selectFiClose(Map<String, String> map) throws Exception {
		return sqlMapper.queryForList("selectFiClose", map);
	}
	
}
