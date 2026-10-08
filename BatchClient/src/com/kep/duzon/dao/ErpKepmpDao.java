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
public class ErpKepmpDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	private String _CD_COMPANY = "TEST";

	public ErpKepmpDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
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
	 * IF_ID 채번
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public String selectIfId(Map<String, String> pMap) throws Exception {
		
		String IF_ID = "";
		String pStr = "X";
		List<Map<String, String>> rMaps = this.sqlMapper.queryForList("selectIfId", pMap);
		
		if ( "1000".equals(this._CD_COMPANY)) {
			pStr = "";	// 운영환경일 경우 if_id 값에 변경 없음.
		} else {
			pStr = "X";	// 개발환경일 경우 if_id 값에에 "X"를 붙여 구분함.
		}
		
		if (rMaps.size() > 0) {
			IF_ID = pStr + rMaps.get(0).get("IF_ID");
		} else {
			throw new Exception("IF ID 채번 오류.");
		}
		
		return IF_ID;
	}
	
	/**
	 * AR 생성 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectArKepmpList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectArKepmpList", pMap);
	}
	
	/**
	 * AR 전송 결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void updateArKepmp(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateArKepmp", pMap);
	}
	
	/**
	 * AR 취합건 삭제 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void deleteARCloseConfirm(Map<String, String> pMap) throws Exception {
		this.sqlMapper.delete("deleteARCloseConfirm", pMap);
	}
	/**
	 * AR 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateCancelArKepmp(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateCancelArKepmp", pMap);
	}
	
	/**
	 * AR 미마감대상자 리스트 조회
	 * @param pMap
	 * @throws Exception
	 */
	public List<Map<String, String>> selectArBillCloseUser(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectArBillCloseUser", pMap);
	}
	
	/**
	 * AR 미마감 대상자 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateArBillCloseUserKepmp(List<Map<String, String>> pMap) throws Exception {
		for(int i=0; i < pMap.size(); i++) {
			this.sqlMapper.update("updateArBillCloseUserKepmp", pMap.get(i));
		}
			
	}
	
	/**
	 * AP 생성 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectApKepmpList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectApKepmpList", pMap);
	}
	/**
	 * AP 전송 결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void updateApKepmp(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateApKepmp", pMap);
	}
	
	/**
	 * AP 취합건 삭제 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void deleteAPCloseConfirm(Map<String, String> pMap) throws Exception {
		this.sqlMapper.delete("deleteAPCloseConfirm", pMap);
	}
	
	/**
	 * AP 미마감대상자 리스트 조회
	 * @param pMap
	 * @throws Exception
	 */
	public List<Map<String, String>> selectApBillCloseUser(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectApBillCloseUser", pMap);
	}
	
	/**
	 * AP 미마감 대상자 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateApBillCloseUserKepmp(List<Map<String, String>> pMap) throws Exception {
		for(int i=0; i < pMap.size(); i++) {
			this.sqlMapper.update("updateApBillCloseUserKepmp", pMap.get(i));
		}
	}
	
	/**
	 * AP 취소 처리.
	 * @param pMap
	 * @throws Exception
	 */
	public void updateCancelApKepmp(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateCancelApKepmp", pMap);
	}

	/**
	 * 더존ERP로 전송할 FI데이터를 조회한다.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectFiDocu() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectFiDocu", pMap);
	}
	
	/**
	 * 더존ERP로 전송한 결과를 저장한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateFiDocu(Map<String, String> pMap) throws Exception {
		log.debug("FI : " + pMap.get("ROW_ID")  + " : " + pMap.get("IF_MSG"));
		return this.sqlMapper.update("updateFiDocu", pMap);
	}
	
	/**
	 * FiDocu 생성
	 * @param pMap
	 * @throws Exception
	 */
	public void insertErpFiEpdocu(Map<String, String> pMap) throws Exception {
		log.debug("FI : " + pMap.get("ROW_ID")  + " : " + pMap.get("IF_ID"));
		this.sqlMapper.insert("insertErpFiEpdocu", pMap);
	}
	
	/**
	 * FiDocuR 생성
	 * @param pMap
	 * @throws Exception
	 */
	public void insertErpFiEpdocuR(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertErpFiEpdocuR", pMap);
	}

	/**
	 * 영업시스템에 전송할 취소 데이터
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectFiDocuR(Map<String, String> pMap) throws Exception {
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectFiDocuR", pMap);
	}
	
	/**
	 * 더존ERP로 전송한 결과를 저장한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateFiDocuR(Map<String, String> pMap) throws Exception {
		log.debug("FI_R : " + pMap.get("ROW_ID")  + " : " + pMap.get("IF_MSG"));
		return this.sqlMapper.update("updateFiDocuR", pMap);
	}
	
	/**
	 * 회사 일반정보 전송 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPartnerTemp() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerTemp", pMap);
	}
	
	/**
	 * 회사 일반정보 전송 처리 결과 반영
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updatePartnerTemp(Map<String, String> pMap) throws Exception {
		log.debug("Result : " + pMap.get("CD_PARTNER") + " / " + pMap.get("IF_FLAG") +" / "+ pMap.get("IF_MSG") );
		return this.sqlMapper.update("updatePartnerTemp", pMap);
	}
	
	/**
	 * 회사 은행정보 전송 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPartnerDeposit() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerDeposit", pMap);
	}
	
	/**
	 * 회사 은행정보 전송 처리 결과 반영
	 * 반영시 은행계좌필드를 ******로 변경한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updatePartnerDeposit(Map<String, String> pMap) throws Exception {
		log.debug("Result : " + pMap.get("CD_PARTNER") + " / " + pMap.get("IF_FLAG") +" / "+ pMap.get("IF_MSG") );
		return this.sqlMapper.update("updatePartnerDeposit", pMap);
	}
	
	/**
	 * 매출원가 내역 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectSaleCost() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectSaleCost", pMap);
	}
	
	/**
	 * 매출원가 결과 반영
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateSaleCost(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.update("updateSaleCost", pMap);
	}
	
	/**
	 * 거래처 일반 정보 이벤트 대상 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPartnerTempKepmp() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerTempKepmp", pMap);
	}
	
	/**
	 * 거래처 일반 정보 이벤트 대상 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void insertPartnerTemp(Map<String,String> pMap) throws Exception {
		this.sqlMapper.insert("insertPartnerTemp", pMap);
	}
	
	/**
	 * 거래처 일반 정보 이벤트 대상 처리결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public int updatePartnerTempKepmp(Map<String,String> pMap) throws Exception {
		log.debug("Result : " + pMap.get("COM_CODE") + " / " + pMap.get("IF_SEND_FLAG"));
		return this.sqlMapper.update("updatePartnerTempKepmp", pMap);
	}

	/**
	 * 거래처 은행 정보 이벤트 처리
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPartnerDepositKepmp() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerDepositKepmp", pMap);
	}
	
	/**
	 * 거래처 은행 정보 이벤트 대상 저장
	 * @param pMap
	 * @throws Exception
	 */
	public void insertPartnerDeposit(Map<String,String> pMap) throws Exception {
		this.sqlMapper.insert("insertPartnerDeposit", pMap);
	}
	
	/**
	 * 거래처 은행 정보 이벤트 대상 처리결과 저장
	 * @param pMap
	 * @throws Exception
	 */
	public int updatePartnerDepositKepmp(Map<String,String> pMap) throws Exception {
		log.debug("Result : " + pMap.get("SUPPLIER") + " / " + pMap.get("IF_SEND_FLAG"));
		return this.sqlMapper.update("updatePartnerDepositKepmp", pMap);
	}
	
	/**
	 * 거래처 정보를 전송한 이력이 있는지 체크한다. 전송한 이력이 있을 경우 데이터를 스킵한다.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int checkPartnerTemp(Map<String,String> pMap)  throws Exception {
		
		int rtn = 0;
		
		List<Map<String,String>> cMaps = this.sqlMapper.queryForList("checkPartnerTemp", pMap);
		
		if (cMaps.size() > 0) {
			rtn = Integer.parseInt( cMaps.get(0).get("CNT") );
		} else {
			rtn = 0;
		}
		
		return rtn;
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
	 * ERP에서 변경된 은행정보 이력을 EAI에 저장.
	 * @param pMap
	 * @throws Exception
	 */
	public void insertPartnerDepositR(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertPartnerDepositR", pMap);
	}
	
	/**
	 * ACNTSUPL에 반영할 대상을 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectPartnerDepositRKepmp() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPartnerDepositRKepmp", pMap);
	}
	
	/**
	 * ACNTSUPL에 반영 결과 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updatePartnerDepositRKepmp(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updatePartnerDepositRKepmp", pMap);
	}
	
	/**
	 * ERP에서 변경된 계좌정보를 구매대행 ACNTSUPL에 반영
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateACNTSUPL(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateACNTSUPL", pMap);
	}
	
	/**
	 * ERP에서 회신 받은 NO_DOCU 저장.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateNoDocu(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateNoDocu", pMap);
	}
	
	/**
	 * 판촉몰에 전송할 NO_DOCU 목록 조회
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectArPrmtFiNoList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectArPrmtFiNoList", pMap);
	}
	
	/**
	 * NO_DOCU 전송 후 처리결과 저장.
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateArPrmtFiNoRtnFlag(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateArPrmtFiNoRtnFlag", pMap);
	}
	
	/**
	 * 거래처 은행정보 변경사항 반영 후 삭제 처리. (정상처리건만 삭제)
	 */
	public int deletePartnerDepositRKepmp() throws Exception {
		return this.sqlMapper.delete("deletePartnerDepositRKepmp");
	}

	/**
	 * 판촉몰 카드 입금내역 조회
	 * 조회시 전표 생성을 위한 기초 자료를 모드 가져온다.
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectPgCreditList() throws Exception {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPgCreditList", pMap);
	}
	
	/**
	 * 입금내역 전송 결과 저장
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updatePgCreditResult(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updatePgCreditResult", pMap);
	}
	
	/**
	 * 판촉몰 FiNo 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,String>> selectFiNoDocu(Map<String, String> pMap) throws Exception {
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectFiNoDocu", pMap);
	}
	
	/**
	 * 판촉몰 FiNo 처리 결과
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	public int updateFiNoDocuResult(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateFiNoDocuResult", pMap);
	}
	
	public List<Map<String,String>> selectPGFiNoDocuR(Map<String, String> pMap) throws Exception {
		pMap.put("CD_COMPANY", this._CD_COMPANY);	// 개발:TEST, 운영:1000
		return this.sqlMapper.queryForList("selectPGFiNoDocuR", pMap);
	}

	
}