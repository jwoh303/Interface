package com.koreab2b.mro.common.mdcm.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmItemDetailInfoViewPopDao;

@Service("masterMdCmItemDetailInfoViewPopService")
public class MasterMdCmItemDetailInfoViewPopServiceImpl implements MasterMdCmItemDetailInfoViewPopService {
	
	@Autowired
	private MasterMdCmItemDetailInfoViewPopDao masterMdCmItemDetailInfoViewPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCmItemDetailInfoViewPopDao.selectList(formData);
	}

	public String procMasterMdCmItemDetailInfoViewPop(Map<String,String> formData) {
		return masterMdCmItemDetailInfoViewPopDao.updateMasterMdCmItemDetailInfoViewPop(formData);
	}
	

}
