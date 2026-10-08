package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayDoctorDao {

	/**
	 * 코웨이 닥터AS 목록 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectCowayDoctorAsList(Map<String, Object> pMap);
	
	/**
	 * 코웨이 닥터AS 임시저장 건 삭제 처리.
	 * @param pGridData
	 * @return
	 */
	public String deleteMasterMpIfCowayDoctorAsList(List<Object> pGridData);
	
	/**
	 * 코웨이 닥터AS 임시저장
	 * @param pGridData
	 * @return
	 */
	public String insertMasterMpIfCowayDoctorAsList(List<Object> pGridData);
	
	/**
	 * 코웨이 닥터AS 전송대기 상태로 변경
	 * @param pGridData
	 * @return
	 */
	public String sendMasterMpIfCowayDoctorAsList(List<Object> pGridData);
	
	/**
	 * 코웨이 닥터AS 비고 내용 저장
	 * @param pGridData
	 * @return
	 */
	public String saveMasterMpIfCowayDoctorAsList(List<Object> pGridData);
}
