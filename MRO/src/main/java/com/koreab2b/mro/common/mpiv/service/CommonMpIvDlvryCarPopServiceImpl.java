package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDlvryCarPopDao;

@Service("CommonMpIvDlvryCarPopService")
public class CommonMpIvDlvryCarPopServiceImpl implements CommonMpIvDlvryCarPopService {
	
	@Autowired
	private CommonMpIvDlvryCarPopDao commonMpIvDlvryCarPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return commonMpIvDlvryCarPopDao.selectList(pMap);
	}	
	
	// 저장
	public String saveCommonMpIvDlvryCarPop(Map<String,String>  pMap){
		return commonMpIvDlvryCarPopDao.saveCommonMpIvDlvryCarPop(pMap);
	}

}
