package com.koreab2b.mro.common.wmst.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmstNoticeWritePopDao;

@Service("masterWmstNoticeWritePopService")
public class MasterWmstNoticeWritePopServiceImpl implements MasterWmstNoticeWritePopService {
	
	@Autowired
	private MasterWmstNoticeWritePopDao masterWmstNoticeWritePopDao;

	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData){
		return masterWmstNoticeWritePopDao.selectDetail(formData);
	}
	
	// 물류센터코드
	public Map<String,String> getWarehouseCode(Map<String,String>  formData){
		return masterWmstNoticeWritePopDao.selectWarehouseCode(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		return masterWmstNoticeWritePopDao.updateSelectedData(formData);
	}

}
