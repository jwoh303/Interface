package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface MasterMpDsPckpaprDesignCropProtectManagePopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	//저장
	public String regSave(Map<String, String> formData);
	public String regSaveMM(Map<String, String> formData);
	//종결
	public String regSave01(Map<String, String> formData);
	//바코드부여
	public String getBarCode(Map<String, String> formData);

}
