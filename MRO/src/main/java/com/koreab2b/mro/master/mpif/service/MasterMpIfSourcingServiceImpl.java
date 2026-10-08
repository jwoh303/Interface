package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfSourcingDao;

@Service("masterMpIfSourcingService")
public class MasterMpIfSourcingServiceImpl implements MasterMpIfSourcingService {
	
	@Autowired
	private MasterMpIfSourcingDao masterMpIfSourcingDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfSourcingDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfSourcingDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpIfSourcingDao.deleteSelectedData(formData, gridData);
	}

	@Override
	public String[] negoSelectedData(Map<String, String> pFormData, List<Object> pGridData) {
		return masterMpIfSourcingDao.negoCreateSelectedData(pFormData, pGridData);
	}
}
