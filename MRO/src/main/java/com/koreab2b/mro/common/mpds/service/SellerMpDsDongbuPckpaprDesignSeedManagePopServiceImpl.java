package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsDongbuPckpaprDesignSeedManagePopDao;

@Service("sellerMpDsDongbuPckpaprDesignSeedManagePopService")
public class SellerMpDsDongbuPckpaprDesignSeedManagePopServiceImpl implements SellerMpDsDongbuPckpaprDesignSeedManagePopService {
	
	@Autowired
	private SellerMpDsDongbuPckpaprDesignSeedManagePopDao sellerMpDsDongbuPckpaprDesignSeedManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsDongbuPckpaprDesignSeedManagePopDao.selectList(formData);
	}	
	

}
