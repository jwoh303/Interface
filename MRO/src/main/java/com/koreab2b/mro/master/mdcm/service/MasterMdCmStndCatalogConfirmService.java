package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmStndCatalogConfirmService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 승인
	public String saveMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData);
	// 반려
	public String rejectMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData);

}
