package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmHarmfulChemistryDao;

@Service("masterMdCmHarmfulChemistryService")
public class MasterMdCmHarmfulChemistryServiceImpl implements MasterMdCmHarmfulChemistryService {
	
	@Autowired
	private MasterMdCmHarmfulChemistryDao masterMdCmHarmfulChemistryDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmHarmfulChemistryDao.selectList(param);
	}	
	// 실적데이터 생성
	public String createMasterMdCmHarmfulChemistry(Map<String,String>  formData){
		return masterMdCmHarmfulChemistryDao.createMasterMdCmHarmfulChemistry(formData);
	}	 
}
