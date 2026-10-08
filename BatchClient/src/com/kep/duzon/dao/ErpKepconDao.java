package com.kep.duzon.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class ErpKepconDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	private String _CD_COMPANY = "TEST";

	public ErpKepconDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_KEPCON_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_KEPCON_Dev.xml";
				this._CD_COMPANY = "TEST";
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
	 * AR 생성 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectArKepconList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectArKepconList", pMap);
	}
	
	/**
	 * AR 전송 결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void updateArKepcon(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateArKepcon", pMap);
	}
	
	/**
	 * AR 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateCancelArKepcon(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateArCancelKepcon", pMap);
	}
	
	/**
	 * AP 생성 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectApKepconList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectApKepconList", pMap);
	}
	
	/**
	 * AR 전송 결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void updateApKepcon(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateApKepcon", pMap);
	}
	
	/**
	 * AR 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateCancelApKepcon(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateCancelApKepcon", pMap);
	}
	
	/**
	 * 거래처 일반 정보 이벤트 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPartnerTempKepcon() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerTempKepcon", pMap);
	}
	
	/**
	 * 거래처 일반 정보 이벤트 대상 처리결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public int updatePartnerTempKepcon(Map<String,String> pMap) throws Exception {
		log.info("Result : " + pMap.get("IF_SYSTEM") +" / "+ pMap.get("COM_CODE") + " / " + pMap.get("IF_SEND_FLAG"));
		return this.sqlMapper.update("updatePartnerTempKepcon", pMap);
	}

	/**
	 * 기존 여신 정보 삭제
	 * @throws Exception
	 */
	public void deleteCredit() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		this.sqlMapper.delete("deleteCredit", pMap);
	}

	/**
	 * 신규 여신 정보 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void insertCredit(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertCredit", pMap);
	}
	
	/**
	 * 유통 매출원가 내역 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectSaleCostKW() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectSaleCostKW", pMap);
	}
	
	/**
	 * 건설 매출원가 내역 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectSaleCostSA() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectSaleCostSA", pMap);
	}
	
	/**
	 * kepcon 매출원가 전송 결과 반영
	 * @param pMap
	 * @throws Exception
	 */
	public void updateSaleCostKepcon(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateSaleCostKepcon", pMap);
	}

	/**
	 * 유통 채권에이징 금액 확인대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectCreditAgingTargetList() throws Exception {
		return this.sqlMapper.queryForList("selectCreditAgingTargetList");
	}

	/**
	 * 유통 채권에이징 데이터 merge 
	 * @param pMap
	 * @throws Exception
	 */
	public void mergeCreditAging(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("mergeCreditAging", pMap);
	}
	
	/**
	 * 유통 채권에이징 데이터 삭제
	 * @throws Exception
	 */
	public void deleteCreditAging() throws Exception {
		this.sqlMapper.delete("deleteCreditAging");
	}
	
	/**
	 * 
	 * @param pMap
	 * @throws Exception
	 */
	public void insertCreditAging(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertCreditAging", pMap);
	}
}