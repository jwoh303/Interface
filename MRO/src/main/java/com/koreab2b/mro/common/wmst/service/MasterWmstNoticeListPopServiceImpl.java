package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmst.dao.MasterWmstNoticeListPopDao;

@Service("masterWmstNoticeListPopService")
public class MasterWmstNoticeListPopServiceImpl implements MasterWmstNoticeListPopService {
	
	@Autowired
	private MasterWmstNoticeListPopDao masterWmstNoticeListPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterWmstNoticeListPopDao.selectList(formData);
	}
	
	// 상세
	public Map<String,String> getDetail(Map<String,String>  formData){
		return masterWmstNoticeListPopDao.selectDetail(formData);
	}

}
