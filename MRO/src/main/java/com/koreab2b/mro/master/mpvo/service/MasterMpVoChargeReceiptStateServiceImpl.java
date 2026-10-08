package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoChargeReceiptStateDao;

@Service("masterMpVoChargeReceiptStateService")
public class MasterMpVoChargeReceiptStateServiceImpl implements MasterMpVoChargeReceiptStateService {
	
	@Autowired
	private MasterMpVoChargeReceiptStateDao masterMpVoChargeReceiptStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpVoChargeReceiptStateDao.selectList(param);
	}	

}
