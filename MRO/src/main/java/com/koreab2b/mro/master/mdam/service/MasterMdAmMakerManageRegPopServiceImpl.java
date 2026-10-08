package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMakerManageRegPopDao;

@Service("MasterMdAmMakerManageRegPopService")
public class MasterMdAmMakerManageRegPopServiceImpl implements MasterMdAmMakerManageRegPopService {
	
	@Autowired
	private MasterMdAmMakerManageRegPopDao MasterMdAmMakerManageRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return MasterMdAmMakerManageRegPopDao.selectList(formData);
	}	
	
	/*등록*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return MasterMdAmMakerManageRegPopDao.updateSelectedData(formData);
		
	}
	/*등록*/
	@Transactional
	public String insertSelectedData(Map<String,String>  formData ) {
		return MasterMdAmMakerManageRegPopDao.insertSelectedData(formData);
		
	}
	/*제조사 등록*/
	@Transactional
	public String insertSelectedMgData(Map<String,String>  formData ) {
		return MasterMdAmMakerManageRegPopDao.insertSelectedMgData(formData);
	}	
}
