package com.kep.hwDefense.app.status.dao;

import java.util.List;
import java.util.Map;

public interface AppStatusDao {

	public List<Map<String, String>> getAppList() throws Exception;
	
	public void updateAppStatus(Map<String, String> pMap) throws Exception;
	
	public Map<String, String> getAppInfo(Map<String, String> pMap)throws Exception;
	
	public void updateAppCurOrder(Map<String, String> pMap)throws Exception;
	
	public List<Map<String, String>> getNextAppLine(Map<String, String> pMap) throws Exception;
	
	public void updateAppFinal(Map<String, String> pMap) throws Exception;
	
	public void updateAppFinal2(Map<String, String> pMap) throws Exception;
	
	public void updateApping(Map<String, String> pMap) throws Exception;
	
	// 상신 취소
	public void modifyICOGDOCU_PASSSTATUS(Map<String, String> pMap) throws Exception;
	
	// 상신취소
	public void modifyICOGPASSLN_PASSKN(Map<String, String> pMap) throws Exception;
	
	// 주문취소
	public void updatePrCancel(Map<String, String> pMap) throws Exception;
	
	// 예산복원
	public void updateReturnPrBudget(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, String>> selectPrCancelInfoList(Map<String, String> pMap) throws Exception;
	
	public void saveAPPR_STATUS_HwDefense(Map<String, Object> pMap) throws Exception ;
}