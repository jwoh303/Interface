package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderInfoAlterBeforePopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	
	public List<Map<String,String>> getSysopOrderChangePoBeforeHDPop(Map<String,String>  formData);
	
	public String getPrCardUseCheck(Map<String,String>  formData);
	
	
	
	
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop(Map<String,Object>  formData);
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getSysopOrderChangePoBeforeDivisionDTPop(Map<String,Object>  formData);
	public List<Map<String,String>> getUnitMeasureInfo(Map<String,String>  formData);
	public List<Map<String,String>> getHubCode(Map<String,String>  formData);
	
	/**
	 * 주문정보수정 통합처리 로직 
	 */
	public String saveOrderChangeCombineLogic(Map<String,String>  formData, List<Object> gridData);
	/**
	 * 주문정보수정 수량분할 통합처리 로직 
	 */
	public String saveOrderChangeDivisionCombineLogic(Map<String,String>  formData, List<Object> gridData);
	
	public List<Map<String,String>> getSysopOrderTotalAmtMainPop(Map<String,Object>  formData);
	public List<Map<String,String>> getSysopOrderTotalBuyerAmtMainPop(Map<String,Object>  formData);
	
	public String saveSysopOrderChangeClear(Map<String,String>  formData, List<Object> gridData);
	public String saveSysopOrderChangeEnd(Map<String,String>  formData, List<Object> gridData); 
	public String setSysopOrderChangeBeforeDelete(Map<String,String>  formData, List<Object> gridData);
	
	
	public String setSysopOrderChangeBeforeSave(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeBeforeProcessTypeModify(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeBeforeAgentModify(Map<String,String>  formData, List<Object> gridData);
	public String setCheckInterBizPoStatus(Map<String,String>  formData, List<Object> gridData);
	public double getBuyerRateInfo(Map<String,String>  formData, List<Object> gridData);
	public double getProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData);
	public double getBuyerStandardRate(Map<String,String>  formData, List<Object> gridData);
	public String getBuyerRateAdaptFlag(Map<String,String>  formData, List<Object> gridData);
	public List<Map<String, String>> getTotProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData);	
	
	public double getBuyerRateInfo2(Map<String, String> pMap);
	public double getKePBuyerRateInfo(Map<String, String> pMap);
	public String getBuyerRateAdaptFlag2(Map<String, String> pMap);
	public double getProcessTypeRateInfo2(Map<String, String> pMap);
	
	public String setSysopOrderUpdateEmegancyPo(Map<String,String>  formData, List<Object> gridData);
	

}
