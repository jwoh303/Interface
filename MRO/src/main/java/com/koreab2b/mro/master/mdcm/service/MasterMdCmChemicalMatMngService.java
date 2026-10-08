package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmChemicalMatMngService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 협력사 반려
	public String returnMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData);
	// 검토요청
	public String reqMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData);
	// 상태변경
	public String updateStatusMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData);
	// 최종승인
	public String confirmMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData);
	// 발주 후 제출
	public String afterMasterrMdCtChemicalMat(Map<String,String>  formData, List<Object> gridData);

}
