package com.koreab2b.mro.master.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpds.dao.MasterMpDsUserDao;

@Service("masterMpDsUserService")
public class MasterMpDsUserServiceImpl implements MasterMpDsUserService {

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpDsUserDao.selectList(param);
	}	

	// 저장
	@Autowired
	private MasterMpDsUserDao masterMpDsUserDao;

	public int updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return masterMpDsUserDao.updateSelectedData(formData, gridData);
	}	

	
}
