package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDlvryDetailInfoPopDao;

@Service("commonMpIvDlvryDetailInfoPopService")
public class CommonMpIvDlvryDetailInfoPopServiceImpl implements CommonMpIvDlvryDetailInfoPopService {
	
	@Autowired
	private CommonMpIvDlvryDetailInfoPopDao commonMpIvDlvryDetailInfoPopDao;

	// 조회
	public Map<String, String> getInfo(Map<String,String> formData) {
		return commonMpIvDlvryDetailInfoPopDao.selectInfo(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return commonMpIvDlvryDetailInfoPopDao.selectList(formData);
	}

}
