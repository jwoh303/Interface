package com.koreab2b.mro.master.wmgr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrTrGrCreDao;

@Service("masterWmGrTrGrCreService")
public class MasterWmGrTrGrCreServiceImpl implements MasterWmGrTrGrCreService {
	
	@Autowired
	private MasterWmGrTrGrCreDao masterWmGrTrGrCreDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmGrTrGrCreDao.selectList(param);
	}	

	
	// 리스트 조회
	public List<Map<String,String>> getPop(Map<String,String> param) {
		return masterWmGrTrGrCreDao.selectPop(param);
	}	
	// 입고저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrTrGrCreDao.updateSelectedData(formData, gridData);
	}	
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrTrGrCreDao.updateSelectedData_v2(formData, gridData);
	}

	// 출고지시
	public String updateSelectedDataIvt(Map<String,String>  formData, List<Object> gridData) {
		return masterWmGrTrGrCreDao.updateSelectedDataIvt(formData, gridData);
	}
	
	
	// DOOSANIF
	public String saveMasterWmGrTrGrCreDoosanIF(Map<String,String>  formData) {
		return masterWmGrTrGrCreDao.saveMasterWmGrTrGrCreDoosanIF(formData);
	}	
	
	// 지연사유저장
	public void saveMasterWmCoDelayPop(Map<String, String> pMap) {
		masterWmGrTrGrCreDao.saveMasterWmCoDelayPop(pMap);
	}
}
