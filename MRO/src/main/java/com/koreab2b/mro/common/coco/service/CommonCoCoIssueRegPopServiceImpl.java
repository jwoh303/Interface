package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonCoCoIssueRegPopDao;

@Service("commonCoCoIssueRegPopService")
@Transactional
public class CommonCoCoIssueRegPopServiceImpl implements CommonCoCoIssueRegPopService {

	@Autowired
	private CommonCoCoIssueRegPopDao commonCoCoIssueRegPopDao;  
	
	public String insertCommonCoCoIssueRegPop(Map<String,String> _pMap){
		return commonCoCoIssueRegPopDao.insertCommonCoCoIssueRegPop(_pMap);
	}
	
	// 리스트조회
	public List<Map<String,String>> getCommonCoCoIssueHistHistList(Map<String,Object>  param) {
		return commonCoCoIssueRegPopDao.getCommonCoCoIssueHistHistList(param);
	}
}
