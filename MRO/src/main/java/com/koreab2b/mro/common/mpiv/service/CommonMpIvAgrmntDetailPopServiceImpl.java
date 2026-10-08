package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvAgrmntDetailPopDao;

@Service("commonMpIvAgrmntDetailPopService")
public class CommonMpIvAgrmntDetailPopServiceImpl implements CommonMpIvAgrmntDetailPopService {
	
	@Autowired
	private CommonMpIvAgrmntDetailPopDao commonMpIvAgrmntDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvAgrmntDetailPopDao.selectList(formData);
	}	
	
	public String getMailYn(Map<String,String> formData) {
		return commonMpIvAgrmntDetailPopDao.selectMailYn(formData);
	}	
	
	public String insertCommonCoCoScmActionDetailPop(Map<String,String> formData) {
		return commonMpIvAgrmntDetailPopDao.insertCommonCoCoScmActionDetailPop(formData);
	}	
	

}
