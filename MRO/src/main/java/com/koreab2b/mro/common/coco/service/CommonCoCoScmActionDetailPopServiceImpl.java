package com.koreab2b.mro.common.coco.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.dao.CommonCoCoScmActionDetailPopDao;

@Service("commonCoCoScmActionDetailPopService")
@Transactional
public class CommonCoCoScmActionDetailPopServiceImpl implements CommonCoCoScmActionDetailPopService {

	@Autowired
	private CommonCoCoScmActionDetailPopDao commonCoCoScmActionDetailPopDao;  
	
	public Map<String,String> getScmList(Map<String,String> _pMap){
		return commonCoCoScmActionDetailPopDao.getScmList(_pMap);
	}
	
	public String updateCommonCoCoScmActionDetailPop(Map<String,String> _pMap){
		return commonCoCoScmActionDetailPopDao.updateCommonCoCoScmActionDetailPop(_pMap);
	}
}
