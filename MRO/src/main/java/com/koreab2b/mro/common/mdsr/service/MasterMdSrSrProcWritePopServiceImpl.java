package com.koreab2b.mro.common.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdsr.dao.MasterMdSrSrProcWritePopDao;

@Service("masterMdSrSrProcWritePopServiceImpl")
public class MasterMdSrSrProcWritePopServiceImpl  implements MasterMdSrSrProcWritePopService {
	@Autowired
	private MasterMdSrSrProcWritePopDao masterMdSrSrProcWritePopDao;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrProcWritePop(Map<String,Object> formData) {
		return masterMdSrSrProcWritePopDao.getMasterMdSrSrProcWritePop(formData);
	}
	
	// 저장
	public String saveMasterMdSrSrProcWritePop(Map<String,String>  formData) {
		return masterMdSrSrProcWritePopDao.saveMasterMdSrSrProcWritePop(formData);
	}

}
