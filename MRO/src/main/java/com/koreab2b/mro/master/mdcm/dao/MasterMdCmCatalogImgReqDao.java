package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogImgReqDao {

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 승인
	public String saveMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData);
	// 반려
	public String rejectMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData);
	

}
