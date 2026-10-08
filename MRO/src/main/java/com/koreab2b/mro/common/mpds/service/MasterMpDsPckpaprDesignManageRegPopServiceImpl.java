package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsPckpaprDesignManageRegPopDao;

@Service("masterMpDsPckpaprDesignManageRegPopService")
public class MasterMpDsPckpaprDesignManageRegPopServiceImpl implements MasterMpDsPckpaprDesignManageRegPopService {
	
	@Autowired
	private MasterMpDsPckpaprDesignManageRegPopDao masterMpDsPckpaprDesignManageRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsPckpaprDesignManageRegPopDao.selectList(formData);
	}	

	/*등록*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpDsPckpaprDesignManageRegPopDao.updateSelectedData(formData, gridData);
	}		

}
