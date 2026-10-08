package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderInfoAlterAfterPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	
	
	public List<Map<String,String>> getSysopOrderChangePoAfterHDPop(Map<String,String>  formData);
	public List<Map<String,String>> getSysopOrderChangePoAfterDTPop(Map<String,Object>  formData);
	
	
	public String setSysopOrderChangeAfterSave(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterProcessTypeModify(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterAgentModify(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterDelete(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterPrice(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterRdDate(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterPoInit(Map<String,String>  formData, List<Object> gridData);
	public String setSysopOrderChangeAfterPrice2(Map<String,String>  formData, List<Object> gridData);
	public String setCheckInterBizPoStatus(Map<String,String>  formData, List<Object> gridData);

}
