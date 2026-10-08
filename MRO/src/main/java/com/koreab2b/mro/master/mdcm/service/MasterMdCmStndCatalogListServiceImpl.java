package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmStndCatalogListDao;

@Service("masterMdCmStndCatalogListService")
public class MasterMdCmStndCatalogListServiceImpl implements MasterMdCmStndCatalogListService {
	
	@Autowired
	private MasterMdCmStndCatalogListDao masterMdCmStndCatalogListDao;

	// 승인
	public String saveMasterMpRqConfirmStndCatlg(Map<String,String>  formData){
		return masterMdCmStndCatalogListDao.saveMasterMpRqConfirmStndCatlg(formData);
	}	 

}
