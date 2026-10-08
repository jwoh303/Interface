package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

public interface MasterClMgCreditDeptPopService {
	
		// 리스트조회
		public List<Map<String,String>> getList(Map<String,Object>  param);
		// 생성
		public String saveMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData);
		//삭제
		public String deleteMasterClMgCreditDeptPop(Map<String,String>  formData, List<Object> gridData);
		// 여신한도 매핑 리스트조회
		public List<Map<String,String>> getMasterClMgCreditBondPop(Map<String,Object>  param);
		// 여신한도 매핑 생성
		public String saveMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData);
		//여신한도 매핑 삭제
		public String deleteMasterClMgCreditBondPop(Map<String,String>  formData, List<Object> gridData);
		// 여신한도 예외 리스트조회
		public List<Map<String,String>> getMasterClMgBondExcpPop(Map<String,Object>  param);
		// 여신한도 예외 생성
		public String saveMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData);
		//여신한도 예외 삭제
		public String deleteMasterClMgBondExcpPop(Map<String,String>  formData, List<Object> gridData);
}
