package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsPckpaprDesignManageSeedRegPopDao;

@Service("masterMpDsPckpaprDesignManageSeedRegPopService")
public class MasterMpDsPckpaprDesignManageSeedRegPopServiceImpl implements MasterMpDsPckpaprDesignManageSeedRegPopService {
	
	@Autowired
	private MasterMpDsPckpaprDesignManageSeedRegPopDao masterMpDsPckpaprDesignManageSeedRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsPckpaprDesignManageSeedRegPopDao.selectList(formData);
	}	
	
	/*등록*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsPckpaprDesignManageSeedRegPopDao.updateSelectedData(formData, gridData);
	}
}
