package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeDeptChoiceMultiPopDao;

@Service("commonNoNeDeptChoiceMultiPopService")
public class CommonNoNeDeptChoiceMultiPopServiceImpl implements CommonNoNeDeptChoiceMultiPopService {
	@Autowired
	private CommonNoNeDeptChoiceMultiPopDao commonNoNeDeptChoiceMultiPopDao;

	// 조회
	public List<Map<String,String>> getCommonNoNeDeptChoiceMultiPop(Map<String,String> formData) {
		return commonNoNeDeptChoiceMultiPopDao.getCommonNoNeDeptChoiceMultiPop(formData);
	}
}
