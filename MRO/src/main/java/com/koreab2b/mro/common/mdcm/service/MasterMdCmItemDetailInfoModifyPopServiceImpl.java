package com.koreab2b.mro.common.mdcm.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmItemDetailInfoModifyPopDao;

@Service("masterMdCmItemDetailInfoModifyPopService")
public class MasterMdCmItemDetailInfoModifyPopServiceImpl implements MasterMdCmItemDetailInfoModifyPopService {
	
	@Autowired
	private MasterMdCmItemDetailInfoModifyPopDao masterMdCmItemDetailInfoModifyPopDao;

	// 조회
	public Map<String,String> getList(Map<String,String> formData) {
		return masterMdCmItemDetailInfoModifyPopDao.selectList(formData);
	}	
	
	// 판촉물 삭제반려처리
	public String saveMasterMdCmItemDetailInfoDeleteNotAccept(Map<String,String> formData){
		return masterMdCmItemDetailInfoModifyPopDao.updateMasterMdCmItemDetailInfoDeleteNotAccept(formData);
	}
	
	public String saveMasterMdCmItemDetailInfoModifyPop(Map<String,String> formData){
		return masterMdCmItemDetailInfoModifyPopDao.updateMasterMdCmItemDetailInfoModifyPop(formData);
	}
	
}
