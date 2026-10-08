package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfDlvrysttmntStatusPopDao;

@Service("masterMpIfDlvrysttmntStatusPopService")
public class MasterMpIfDlvrysttmntStatusPopServiceImpl implements MasterMpIfDlvrysttmntStatusPopService {
	
	@Autowired
	private MasterMpIfDlvrysttmntStatusPopDao masterMpIfDlvrysttmntStatusPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfDlvrysttmntStatusPopDao.selectList(formData);
	}	
	

}
