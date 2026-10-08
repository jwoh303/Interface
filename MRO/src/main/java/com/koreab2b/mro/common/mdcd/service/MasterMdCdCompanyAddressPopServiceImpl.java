package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcd.dao.MasterMdCdCompanyAddressPopDao;

@Service("masterMdCdCompanyAddressPopService")
public class MasterMdCdCompanyAddressPopServiceImpl implements MasterMdCdCompanyAddressPopService {
	
	@Autowired
	private MasterMdCdCompanyAddressPopDao masterMdCdCompanyAddressPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCdCompanyAddressPopDao.selectList(formData);
	}

	// 삭제
	public Map<String,String> deleteData(Map<String, String> formData) {		
		return masterMdCdCompanyAddressPopDao.deleteData(formData);
	}

	// 저장
	public Map<String,String> saveData(Map<String, String> formData) {		
		return masterMdCdCompanyAddressPopDao.saveData(formData);
	}

	// 추가
	public Map<String,String> addData(Map<String, String> formData) {		
		return masterMdCdCompanyAddressPopDao.addData(formData);
	}
	
}
