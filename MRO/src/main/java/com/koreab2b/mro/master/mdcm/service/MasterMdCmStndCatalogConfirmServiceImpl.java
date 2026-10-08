package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmStndCatalogConfirmDao;

@Service("masterMdCmStndCatalogConfirmService")
public class MasterMdCmStndCatalogConfirmServiceImpl implements MasterMdCmStndCatalogConfirmService {
	
	@Autowired
	private MasterMdCmStndCatalogConfirmDao masterMdCmStndCatalogConfirmDao;
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmStndCatalogConfirmDao.selectList(param);
	}	
	// 승인
	public String saveMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogConfirmDao.saveMasterMpRqConfirmCatlg(formData, gridData);
	}
	// 반려
	public String rejectMasterMpRqConfirmCatlg(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogConfirmDao.rejectMasterMpRqConfirmCatlg(formData, gridData);
	}	 
}
