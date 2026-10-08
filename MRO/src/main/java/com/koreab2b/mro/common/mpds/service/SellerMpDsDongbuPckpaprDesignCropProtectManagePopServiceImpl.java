package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsDongbuPckpaprDesignCropProtectManagePopDao;

@Service("sellerMpDsDongbuPckpaprDesignCropProtectManagePopService")
public class SellerMpDsDongbuPckpaprDesignCropProtectManagePopServiceImpl implements SellerMpDsDongbuPckpaprDesignCropProtectManagePopService {
	
	@Autowired
	private SellerMpDsDongbuPckpaprDesignCropProtectManagePopDao sellerMpDsDongbuPckpaprDesignCropProtectManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsDongbuPckpaprDesignCropProtectManagePopDao.selectList(formData);
	}	
	

}
