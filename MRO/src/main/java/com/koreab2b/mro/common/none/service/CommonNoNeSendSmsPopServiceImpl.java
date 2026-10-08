package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.none.dao.CommonNoNeSendSmsPopDao;

@Service("commonNoNeSendSmsPopService")
public class CommonNoNeSendSmsPopServiceImpl implements CommonNoNeSendSmsPopService {
	@Autowired
	private CommonNoNeSendSmsPopDao commonNoNeSendSmsPopDao;

	/*저장*/
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return commonNoNeSendSmsPopDao.updateSelectedData(formData, gridData);
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return commonNoNeSendSmsPopDao.selectList(formData);
	}
}
