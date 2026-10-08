package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsPckpaprDesignSeedManagePopDao;

@Service("masterMpDsPckpaprDesignSeedManagePopService")
public class MasterMpDsPckpaprDesignSeedManagePopServiceImpl implements MasterMpDsPckpaprDesignSeedManagePopService {
	
	@Autowired
	private MasterMpDsPckpaprDesignSeedManagePopDao masterMpDsPckpaprDesignSeedManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsPckpaprDesignSeedManagePopDao.selectList(formData);
	}	
	

}
