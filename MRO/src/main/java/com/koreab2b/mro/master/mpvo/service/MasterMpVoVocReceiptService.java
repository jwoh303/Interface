package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

public interface MasterMpVoVocReceiptService {
	
	// 저장
	public String saveMasterMpVoVocReceiptList(Map<String,String>  formData);
	// VOC 팝업 등록
	public List<Map<String,String>> getMasterMpVoVocRegPop(Map<String,Object>  formData);
}
