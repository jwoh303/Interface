package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfProgressStateMainDao;

@Service("masterMpIfProgressStateMainService")
public class MasterMpIfProgressStateMainServiceImpl implements MasterMpIfProgressStateMainService {
	
	@Autowired
	private MasterMpIfProgressStateMainDao masterMpIfProgressStateMainDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfProgressStateMainDao.selectList(param);
	}	

	// 저장
//	@Transactional
//	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterMpIfProgressStateMainDao.updateSelectedData(formData, gridData);
//	}	

	// 삭제
//	@Transactional
//	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		return masterMpIfProgressStateMainDao.deleteSelectedData(formData, gridData);
//	}
}
