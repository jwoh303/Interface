package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpif.dao.MasterMpIfWarehousingPopDao;

@Service("masterMpIfWarehousingPopService")
public class MasterMpIfWarehousingPopServiceImpl implements MasterMpIfWarehousingPopService {
	
	@Autowired
	private MasterMpIfWarehousingPopDao masterMpIfWarehousingPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpIfWarehousingPopDao.selectList(formData);
	}	
	

}
