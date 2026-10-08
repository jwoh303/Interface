package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoCatalogAlterPopDao;

@Service("commonCoCoCatalogAlterPopService")
public class CommonCoCoCatalogAlterPopServiceImpl  implements CommonCoCoCatalogAlterPopService {
	@Autowired
	private CommonCoCoCatalogAlterPopDao commonCoCoCatalogAlterPopDao;
	
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return commonCoCoCatalogAlterPopDao.selectList(param);
	}
}
