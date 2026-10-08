package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.MasterMpIvObtnodrNyreceiptManagePopDao;

@Service("masterMpIvObtnodrNyreceiptManagePopService")
public class MasterMpIvObtnodrNyreceiptManagePopServiceImpl implements MasterMpIvObtnodrNyreceiptManagePopService {
	
	@Autowired
	private MasterMpIvObtnodrNyreceiptManagePopDao masterMpIvObtnodrNyreceiptManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIvObtnodrNyreceiptManagePopDao.selectList(formData);
	}	
	

}
