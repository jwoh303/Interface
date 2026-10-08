package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocReceiptDao {
	
	// 저장
	public String saveMasterMpVoVocReceiptList(Map<String,String>  formData);
	// VOC등록 팝업 조회 
	public List<Map<String,String>> selectMasterMpVoVocRegPop(Map<String,Object> formData);

}
