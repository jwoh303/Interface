package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfCatalogAlterPopDao;

@Service("masterMpIfCatalogAlterPopService")
public class MasterMpIfCatalogAlterPopServiceImpl implements MasterMpIfCatalogAlterPopService {
	
	@Autowired
	private MasterMpIfCatalogAlterPopDao masterMpIfCatalogAlterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfCatalogAlterPopDao.selectList(formData);
	}	
	

}
