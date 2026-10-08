package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoVocReceiptDao;

@Service("masterMpVoVocReceiptService")
public class MasterMpVoVocReceiptServiceImpl implements MasterMpVoVocReceiptService {
	
	@Autowired
	private MasterMpVoVocReceiptDao masterMpVoVocReceiptDao;

	// 저장
	@Transactional
	public String saveMasterMpVoVocReceiptList(Map<String,String>  formData) {
		return masterMpVoVocReceiptDao.saveMasterMpVoVocReceiptList(formData);
	}
	// VOC 팝업 등록
	public List<Map<String,String>> getMasterMpVoVocRegPop(Map<String,Object> formData) {
		return masterMpVoVocReceiptDao.selectMasterMpVoVocRegPop(formData);
	}

}
