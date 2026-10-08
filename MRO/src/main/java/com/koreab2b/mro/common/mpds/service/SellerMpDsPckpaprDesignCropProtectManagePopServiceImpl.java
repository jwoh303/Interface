package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsPckpaprDesignCropProtectManagePopDao;

@Service("sellerMpDsPckpaprDesignCropProtectManagePopService")
public class SellerMpDsPckpaprDesignCropProtectManagePopServiceImpl implements SellerMpDsPckpaprDesignCropProtectManagePopService {
	
	@Autowired
	private SellerMpDsPckpaprDesignCropProtectManagePopDao sellerMpDsPckpaprDesignCropProtectManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsPckpaprDesignCropProtectManagePopDao.selectList(formData);
	}	
	

}
