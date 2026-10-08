package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqSellerChoicePopDao;

@Service("masterMpRqSellerChoicePopService")
public class MasterMpRqSellerChoicePopServiceImpl implements MasterMpRqSellerChoicePopService {
	
	@Autowired
	private MasterMpRqSellerChoicePopDao masterMpRqSellerChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqSellerChoicePopDao.selectList(formData);
	}	
	
	// 비고 조회
	public List<Map<String,String>> getListRemark(Map<String,Object> formData) {
		return masterMpRqSellerChoicePopDao.selectListRemark(formData);
	}
	
	// 추가라운드요청
	public String saveAgentRoundReq(Map<String,String>  formData, List<Object> gridData){
		return masterMpRqSellerChoicePopDao.saveAgentRoundReq(formData, gridData);
	}
	
}
