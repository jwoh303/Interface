package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoTrReleaseDeletePopDao;

@Service("masterMpSoTrReleaseDeletePopService")
public class MasterMpSoTrReleaseDeletePopServiceImpl implements MasterMpSoTrReleaseDeletePopService {
	
	@Autowired
	private MasterMpSoTrReleaseDeletePopDao masterMpSoTrReleaseDeletePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoTrReleaseDeletePopDao.selectList(formData);
	}	
	

}
