package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvWarehousingDetailPopDao;

@Service("commonMpIvWarehousingDetailPopService")
public class CommonMpIvWarehousingDetailPopServiceImpl implements CommonMpIvWarehousingDetailPopService {
	
	@Autowired
	private CommonMpIvWarehousingDetailPopDao commonMpIvWarehousingDetailPopDao;

	// 조회
	public Map<String,String> getList1(Map<String,String> formData) {
		return commonMpIvWarehousingDetailPopDao.selectList1(formData);
	}	
	public List<Map<String,String>> getList2(Map<String,String> formData) {
		return commonMpIvWarehousingDetailPopDao.selectList2(formData);
	}	
	

}
