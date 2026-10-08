package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeBuyerChoiceMultiPopDao;

@Service("commonNoNeBuyerChoiceMultiPopService")
public class CommonNoNeBuyerChoiceMultiPopServiceImpl implements CommonNoNeBuyerChoiceMultiPopService {
	@Autowired
	private CommonNoNeBuyerChoiceMultiPopDao commonNoNeBuyerChoiceMultiPopDao;

	// 조회
	public List<Map<String,String>> getCommonNoNeBuyerChoiceMultiPop(Map<String,String> formData) {
		return commonNoNeBuyerChoiceMultiPopDao.getCommonNoNeBuyerChoiceMultiPop(formData);
	}
}
