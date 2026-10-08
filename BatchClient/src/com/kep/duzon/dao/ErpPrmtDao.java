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
public class ErpPrmtDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	public String _CD_COMPANY = "TEST";

	public ErpPrmtDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_PRMT_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_PRMT_Dev.xml";
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
	 * AR 생성 목록 조회 (판촉몰)
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectArPrmtList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectArPrmtList", pMap);
	}
	
	/**
	 * AR 전송 결과 저장 (판촉몰)
	 * @param pMap
	 * @throws Exception
	 */
	public int updateArPrmt(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateArPrmt", pMap);
	}
	
	/**
	 * AR-FI전표정보 업데이트 (판촉몰)
	 * @param pMap
	 * @throws Exception
	 */
	public int updateArPrmtFiNo(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateArPrmtFiNo", pMap);
	}
	
	/**
	 * AR 취소 처리. (판촉몰)
	 * @param pMap
	 * @throws Exception
	 */
	public int updateCancelArPrmt(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateCancelArPrmt", pMap);
	}

	/**
	 * AP 생성 목록 조회 (판촉몰)
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectApPrmtList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectApPrmtList", pMap);
	}

	/**
	 * AR 전송 결과 저장 (판촉몰)
	 * @param pMap
	 * @throws Exception
	 */
	public void updateApPrmt(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateApPrmt", pMap);
	}

	/**
	 * AR 취소 처리. (판촉몰)
	 * @param pMap
	 * @throws Exception
	 */
	public void updateCancelApPrmt(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateCancelApPrmt", pMap);
	}
	
	/**
	 * 입금내역 판촉몰에 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void insertPgCreditList(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertPgCreditList", pMap);
	}
	
	/**
	 * FiNoDocu 적용 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateErpFiNo(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.update("updateErpFiNo", pMap);
	}

	/**
	 * 입금내역 Fi_no_docu 적용
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateErpCreditFiNo(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.update("updateErpCreditFiNo", pMap);
	}
	
	/**
	 * 주문번호 기준으로 선수금 여부 확인.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectAdvancedPointChk(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectAdvancedPointChk", pMap);
	}
	
	/**
	 * 입금내역 판촉몰에 merge
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int mergePgCredit(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.update("mergePgCredit", pMap);
	}
	
	/**
	 * 판촉몰 입금내역 전표 매핑 삭제
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateCancelPgPrmt(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.update("updateCancelPgPrmt", pMap);
	}
}