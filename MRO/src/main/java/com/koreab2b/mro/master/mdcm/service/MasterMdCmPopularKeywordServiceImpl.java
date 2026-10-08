package com.koreab2b.mro.master.mdcm.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmPopularKeywordDao;

@Service("masterMdCmPopularKeywordService")
public class MasterMdCmPopularKeywordServiceImpl implements MasterMdCmPopularKeywordService {
	
	@Autowired
	private MasterMdCmPopularKeywordDao masterMdCmPopularKeywordDao;

	// 리스트 조회
	public Map<String,String> getList(Map<String,Object> param) {
		return masterMdCmPopularKeywordDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  param) {
		return masterMdCmPopularKeywordDao.updateSelectedData(param);
	}	

}
