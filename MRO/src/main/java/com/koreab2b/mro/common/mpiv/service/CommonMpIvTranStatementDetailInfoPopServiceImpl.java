package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvTranStatementDetailInfoPopDao;

@Service("commonMpIvTranStatementDetailInfoPopService")
public class CommonMpIvTranStatementDetailInfoPopServiceImpl implements CommonMpIvTranStatementDetailInfoPopService {
	
	@Autowired
	private CommonMpIvTranStatementDetailInfoPopDao commonMpIvTranStatementDetailInfoPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvTranStatementDetailInfoPopDao.selectList(formData);
	}	
	

}
