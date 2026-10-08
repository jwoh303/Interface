package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqKepStndrdCategorySelPopDao;

@Service("masterMpRqKepStndrdCategorySelPopService")
public class MasterMpRqKepStndrdCategorySelPopServiceImpl implements MasterMpRqKepStndrdCategorySelPopService {
	
	@Autowired
	private MasterMpRqKepStndrdCategorySelPopDao masterMpRqKepStndrdCategorySelPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpRqKepStndrdCategorySelPopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String> formData) {
		return masterMpRqKepStndrdCategorySelPopDao.getCategorySelPop(formData);
	}	
	

}
