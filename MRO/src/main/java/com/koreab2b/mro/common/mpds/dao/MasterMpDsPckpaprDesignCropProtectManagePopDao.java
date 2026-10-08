package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpDsPckpaprDesignCropProtectManagePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public String selectBarCode(Map<String,String> formData);
	/*저장*/
	public String updateReg(Map<String, String> formData);
	public String updateRegMM(Map<String, String> formData);
	/*종결*/
	public String updateReg01(Map<String, String> formData);

}
