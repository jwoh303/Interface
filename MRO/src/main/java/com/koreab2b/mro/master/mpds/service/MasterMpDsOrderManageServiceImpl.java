package com.koreab2b.mro.master.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpds.dao.MasterMpDsOrderManageDao;

@Service("masterMpDsOrderManageService")
public class MasterMpDsOrderManageServiceImpl implements MasterMpDsOrderManageService {
	
	@Autowired
	private MasterMpDsOrderManageDao masterMpDsOrderManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpDsOrderManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsOrderManageDao.updateSelectedData(formData, gridData);
	}	

	// 맵핑
	@Transactional
	public String mappingSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsOrderManageDao.mappingSelectedData(formData, gridData);
	}
}
