package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

public interface MasterMdAmMakerManageRegPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	/**
	 * 업데이트
	 * @param formData
	 * @return
	 */
	public String updateSelectedData(Map<String,String>  formData);
	
	/*등록*/
	public String insertSelectedData(Map<String,String>  formData);
	
	/*대표 제조사 등록*/
	public String insertSelectedMgData(Map<String,String>  formData);
	

}
