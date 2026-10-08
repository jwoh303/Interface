package com.koreab2b.mro.common.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdct.dao.MasterMdCtBuyerGroupChoicePopDao;

@Service("masterMdCtBuyerGroupChoicePopService")
public class MasterMdCtBuyerGroupChoicePopServiceImpl implements MasterMdCtBuyerGroupChoicePopService {
	@Autowired
	private MasterMdCtBuyerGroupChoicePopDao masterMdCtBuyerGroupChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCtBuyerGroupChoicePopDao.selectList(formData);
	}	
}
