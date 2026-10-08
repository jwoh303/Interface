package com.koreab2b.mro.common.cmco.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.cmco.dao.MasterCmCoBuyerAgntcmpyPopDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("masterCmCoBuyerAgntcmpyPopService")
public class MasterCmCoBuyerAgntcmpyPopServiceImpl implements MasterCmCoBuyerAgntcmpyPopService {
	
	@Autowired
	private MasterCmCoBuyerAgntcmpyPopDao masterCmCoBuyerAgntcmpyPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterCmCoBuyerAgntcmpyPopDao.selectList(formData);
	}	
	

}
