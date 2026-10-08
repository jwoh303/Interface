package com.koreab2b.mro.common.wmst.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmstNoticeDetailPopDao;

@Service("masterWmstNoticeDetailPopService")
public class MasterWmstNoticeDetailPopServiceImpl implements MasterWmstNoticeDetailPopService {
	
	@Autowired
	private MasterWmstNoticeDetailPopDao masterWmstNoticeDetailPopDao;

	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData){
		return masterWmstNoticeDetailPopDao.selectDetail(formData);
	}
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData) {
		return masterWmstNoticeDetailPopDao.deleteSelectedData(formData);
	}

}
