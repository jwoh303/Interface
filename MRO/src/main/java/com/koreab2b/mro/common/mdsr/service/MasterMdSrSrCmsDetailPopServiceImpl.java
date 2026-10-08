package com.koreab2b.mro.common.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdsr.dao.MasterMdSrSrCmsDetailPopDao;

@Service("masterMdSrSrCmsDetailPopServiceImpl")
public class MasterMdSrSrCmsDetailPopServiceImpl  implements MasterMdSrSrCmsDetailPopService {
	@Autowired
	private MasterMdSrSrCmsDetailPopDao masterMdSrSrCmsDetailPopDao;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrCmsDetailPop(Map<String,Object> formData) {
		return masterMdSrSrCmsDetailPopDao.getMasterMdSrSrCmsDetailPop(formData);
	}
	
	// 저장
	public String saveMasterMdSrSrCmsDetailPop(Map<String,String>  formData) {
		return masterMdSrSrCmsDetailPopDao.saveMasterMdSrSrCmsDetailPop(formData);
	}
	
	// 형상관리
	public String historyMasterMdSrSrCmsDetailPop(Map<String,String>  formData) {
		return masterMdSrSrCmsDetailPopDao.historyMasterMdSrSrCmsDetailPop(formData);
	}

}
