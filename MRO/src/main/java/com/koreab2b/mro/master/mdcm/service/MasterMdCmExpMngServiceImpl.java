package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmExpMngDao;

@Service("masterMdCmExpMngService")
public class MasterMdCmExpMngServiceImpl implements MasterMdCmExpMngService {
	
	@Autowired
	private MasterMdCmExpMngDao masterMdCmExpMngDao;
	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmExpMngDao.selectList(param);
	}	
	// 품목매핑
	public String saveMasterMdCmExpMng(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmExpMngDao.saveMasterMdCmExpMng(formData,gridData);
	}

}
