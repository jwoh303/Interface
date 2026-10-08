package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBottomOrgCodePopDao;

@Service("commonCoCoBottomOrgCodePopService")
public class CommonCoCoBottomOrgCodePopServiceImpl implements CommonCoCoBottomOrgCodePopService {
	@Autowired
	private CommonCoCoBottomOrgCodePopDao commonCoCoBottomOrgCodePopDao; 

	public List<Map<String, String>> getCommonCoCoBottomOrgCodePop(Map<String, String> pMap) {
		return commonCoCoBottomOrgCodePopDao.getCommonCoCoBottomOrgCodePop(pMap);
	}
}
