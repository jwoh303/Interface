package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeUserChoiceMultiPopDao;

@Service("commonNoNeUserChoiceMultiPopService")
public class CommonNoNeUserChoiceMultiPopServiceImpl implements CommonNoNeUserChoiceMultiPopService {
	@Autowired
	private CommonNoNeUserChoiceMultiPopDao commonNoNeUserChoiceMultiPopDao;

	// 조회
	public List<Map<String,String>> getCommonNoNeUserChoiceMultiPop(Map<String,String> formData) {
		return commonNoNeUserChoiceMultiPopDao.getCommonNoNeUserChoiceMultiPop(formData);
	}
}
