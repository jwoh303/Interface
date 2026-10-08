package com.kep.hanwha.Nego.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

@SuppressWarnings("unchecked")
public class HanWhaNegoSubmitDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HanWhaNegoSubmitDao() {
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
			log.error("AppSubmitDao Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public List<Map<String, String>> selectIFTargetList() throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoIFTargetList");
	}
	public List<Map<String, String>> selectHanWhaNegoBuyerList(Map <String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoBuyerList", pMap);
	}
	public List<Map<String, String>> selectHanWhaNegoList(Map <String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoList", pMap);
	}
	public List<Map<String, String>> selectHanWhaNegoPriceList(Map <String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoPriceList", pMap);
	}
	public List<Map<String, String>> selectAtchList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhagetRqIcomatch", pMap);
	}
	public void insertIfAplSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertHanWhaNegoIfAplSend", pMap);
	}
	public void insertIfApmSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertHanWhaNegoIfApmSend", pMap);
	}
	public Map<String, Object> selectAppsendList(Map<String, String> pMap) throws Exception {
		return (Map<String, Object>) this.sqlMapper.queryForObject("selectHanWhaNegoAppSendList", pMap);
	}
	public List<Map<String, String>> selectAppPassList(Map<String, Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoPassln", pMap);
	}
	public List<Map<String, String>> selectAppPassList_refer(Map<String, Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaNegoPassln_refer", pMap);
	}
	public void updateAppSubmitResult(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("updateHanWhaNegoSubmitResult", pMap);
	}
	public Map<String, String> selectHanWhaNegoSumPrice(Map<String, String> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHanWhaNegoSumPrice", pMap);
	}
	public void insertMail (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.insert("HanWhaNegoMailSend", pMap);
	}
	
	/**
	 * 한화 기본 결재선 구성 기능
	 *  - 현재 기본 결재선을 여부를 확인한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int selectHanwhaApptCnt(Map<String, Object> pMap) throws Exception {
		int rtnCnt = 0;
		rtnCnt = (Integer)this.sqlMapper.queryForObject("selectHanwhaApptCnt", pMap);
		return rtnCnt;
	}
	
	/**
	 * 한화 기본 결재선 구성 기능
	 *  - 기본 결재선을 저장한다.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertHanwhaAppt(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.insert("insertHanwhaAppt", pMap);
	}
	
	/**
	 * 현재 저장된 기본 결재선의 상세 정보를 삭제한다.
	 * @param pMap
	 * @throws Exception
	 */
	public void deleteHanwhaApse(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.delete("deleteHanwhaApse", pMap);
	}
	
	/**
	 * 신규 기본 결재선 정보를 저장한다.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertHanwhaApse(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("insertHanwhaApse", pMap);
	}
}
