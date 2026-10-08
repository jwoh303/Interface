package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoBottomOrgCodeMultiPopDao;

@Service("commonCoCoBottomOrgCodeMultiPopService")
public class CommonCoCoBottomOrgCodeMultiPopServiceImpl implements CommonCoCoBottomOrgCodeMultiPopService {
	@Autowired
	private CommonCoCoBottomOrgCodeMultiPopDao commonCoCoBottomOrgCodeMultiPopDao; 

	public List<Map<String, String>> getCommonCoCoBottomOrgCodeMultiPop(Map<String, String> pMap) {
		return commonCoCoBottomOrgCodeMultiPopDao.getCommonCoCoBottomOrgCodeMultiPop(pMap);
	}
}
