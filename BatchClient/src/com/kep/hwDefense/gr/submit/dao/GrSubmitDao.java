package com.kep.hwDefense.gr.submit.dao;

import java.util.List;
import java.util.Map;

public interface GrSubmitDao {

	/**
	 * 입고 전송 대상
	 * @return
	 */
	public List<Map<String, String>> selectHwDefenseGrList() throws Exception;
	
	/**
	 * 입고전송 후 처리
	 */
	public void updateResultGrSubmit(List<Map<String, Object>> grResultList) throws Exception;
}
