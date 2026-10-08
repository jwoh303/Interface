package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoPrewarhsngRequestRegPopDao;

@Service("masterMpSoPrewarhsngRequestRegPopService")
public class MasterMpSoPrewarhsngRequestRegPopServiceImpl implements MasterMpSoPrewarhsngRequestRegPopService {
	
	@Autowired
	private MasterMpSoPrewarhsngRequestRegPopDao masterMpSoPrewarhsngRequestRegPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoPrewarhsngRequestRegPopDao.selectList(formData);
	}	
	

}
