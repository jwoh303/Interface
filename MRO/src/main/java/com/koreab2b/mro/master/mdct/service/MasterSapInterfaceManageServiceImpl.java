package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterSapInterfaceManageDao;

@Service("masterSapInterfaceManageService")
public class MasterSapInterfaceManageServiceImpl implements MasterSapInterfaceManageService {
	
	@Autowired
	private MasterSapInterfaceManageDao masterSapInterfaceManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterSapInterfaceManageDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterSapInterfaceManageDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterSapInterfaceManageDao.deleteSelectedData(formData, gridData);
	}
}
