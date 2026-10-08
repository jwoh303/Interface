package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDlvryChoicePopDao;

@Service("commonMpIvDlvryChoicePopService")
public class CommonMpIvDlvryChoicePopServiceImpl implements CommonMpIvDlvryChoicePopService {
	
	@Autowired
	private CommonMpIvDlvryChoicePopDao commonMpIvDlvryChoicePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvDlvryChoicePopDao.selectList(formData);
	}	
	

}
