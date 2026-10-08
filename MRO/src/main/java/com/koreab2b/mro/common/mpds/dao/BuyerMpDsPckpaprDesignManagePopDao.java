package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpDsPckpaprDesignManagePopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	/*저장*/
	public String updateEsFiReg(Map<String, String> formData);
	public String updateMMReg(Map<String, String> formData);
	public String updateDDReg(Map<String, String> formData);
	public String updateEEReg(Map<String, String> formData);
	public String updateEsMkReg(Map<String, String> formData);
	public String updateEsPdReg(Map<String, String> formData);
	public String updateEsQaReg(Map<String, String> formData);
}
