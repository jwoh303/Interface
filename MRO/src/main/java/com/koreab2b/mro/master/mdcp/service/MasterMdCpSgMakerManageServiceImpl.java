package com.koreab2b.mro.master.mdcp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcp.dao.MasterMdCpSgMakerManageDao;

@Service("masterMdCpSgMakerManageService")
public class MasterMdCpSgMakerManageServiceImpl implements MasterMdCpSgMakerManageService {
	
	@Autowired
	private MasterMdCpSgMakerManageDao masterMdCpSgMakerManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCpSgMakerManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManageDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCpSgMakerManageDao.deleteSelectedData(formData, gridData);
	}
}
