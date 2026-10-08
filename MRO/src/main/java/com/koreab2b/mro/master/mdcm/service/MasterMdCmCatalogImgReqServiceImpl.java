package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogImgReqDao;

@Service("masterMdCmCatalogImgReqService")
public class MasterMdCmCatalogImgReqServiceImpl implements MasterMdCmCatalogImgReqService {
	
	@Autowired
	private MasterMdCmCatalogImgReqDao masterMdCmCatalogImgReqDao;
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogImgReqDao.selectList(param);
	}	
	// 승인
	public String saveMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogImgReqDao.saveMasterMpRqConfirmStndCatlg(formData, gridData);
	}
	// 반려
	public String rejectMasterMpRqConfirmStndCatlg(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogImgReqDao.rejectMasterMpRqConfirmStndCatlg(formData, gridData);
	}	 
}
