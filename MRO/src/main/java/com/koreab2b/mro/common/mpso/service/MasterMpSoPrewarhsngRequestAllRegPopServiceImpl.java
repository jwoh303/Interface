package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoPrewarhsngRequestAllRegPopDao;

@Service("masterMpSoPrewarhsngRequestAllRegPopService")
public class MasterMpSoPrewarhsngRequestAllRegPopServiceImpl implements MasterMpSoPrewarhsngRequestAllRegPopService {
	
	@Autowired
	private MasterMpSoPrewarhsngRequestAllRegPopDao masterMpSoPrewarhsngRequestAllRegPopDao;
	
	public String setExcelUp(Map<String,String>  formData){
		return masterMpSoPrewarhsngRequestAllRegPopDao.saveExcelUp(formData);
	}

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoPrewarhsngRequestAllRegPopDao.selectList(formData);
	}
	
	// 선입고 요청 등록
	@Transactional
	public String updateMasterMpSoPrewarhsngRequestAllRegPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngRequestAllRegPopDao.updateMasterMpSoPrewarhsngRequestAllRegPop(formData, gridData);
	}

}
