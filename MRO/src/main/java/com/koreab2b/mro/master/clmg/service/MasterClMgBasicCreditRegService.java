package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

public interface MasterClMgBasicCreditRegService {
	
	// 리스트조회
		public List<Map<String,String>> getList(Map<String,Object>  param);

		// 저장
		public String insertSelectedData(Map<String,String>  formData, List<Object> gridData);
		
		// 삭제
		public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
		// 품의상신
		public String apprMasterClMgBasicCreditReg(Map<String,String>  formData, List<Object> gridData);
}
