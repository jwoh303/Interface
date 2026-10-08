package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesTaxsheetRaIssueService {

	/**
	 * 매출세금계산서역발행 내역 조회
	 * @param param
	 * @return
	 */
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	/**
	 * 스마트빌 역발행 전송 정보 확인.
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> SendARMasterCmClSalesTaxsheetRaIssueFormat(Map<String, Object> pMap);
	
	/**
	 * 매출 전표 삭제 처리.
	 * @param formData
	 * @param gridData
	 * @return
	 */
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
}
