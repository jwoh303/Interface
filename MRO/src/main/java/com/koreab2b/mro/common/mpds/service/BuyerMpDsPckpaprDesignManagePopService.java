package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpDsPckpaprDesignManagePopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	/*저장*/
	public String regEsFiReg(Map<String, String> formData);
	public String regMMReg(Map<String, String> formData);
	public String regDDReg(Map<String, String> formData);
	public String regEEReg(Map<String, String> formData);
	public String regEsMkReg(Map<String, String> formData);
	public String regEsPdReg(Map<String, String> formData);
	public String regEsQaReg(Map<String, String> formData);

}
