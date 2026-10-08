package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfCowayChargeDao {

	/**
	 * 코웨이 수수료 내역 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectCowayChargeList(Map<String, Object> pMap);
	
	/**
	 * 코웨이 수수료 내역 엑셀 업로드
	 * @param pGridData
	 * @return
	 */
	public String insertMasterMpIfCowayChargeList(List<Object> pGridData);
	
	/**
	 * 코웨이 수수료 내역 삭제 처리.
	 * @param pGridData
	 * @return
	 */
	public String deleteMasterMpIfCowayChargeList(List<Object> pGridData);
}
