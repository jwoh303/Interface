package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoYuHanKimChonPopDao {

	// 조회
	public List<Map<String,String>> selectLegacyUserIdList(Map<String,String> formData);
	public List<Map<String,String>> selectRefHdInfoList(Map<String,String> formData);
	
	
	public String  selectUserNameLoc(Map<String,String>  formData);
	public String  selectUserAddressLoc(Map<String,String>  formData);
	public String  selectCenterCode(Map<String,String>  formData);
	public String  selectprofitSegmentCode(Map<String,String>  formData);
	
	public String  saveBuyerYuhanRetUpdate(Map<String,String>  formData);
	
 

}
