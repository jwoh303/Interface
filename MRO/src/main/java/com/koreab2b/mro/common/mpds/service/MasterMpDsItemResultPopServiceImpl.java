package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsItemResultPopDao;

@Service("masterMpDsItemResultPopService")
public class MasterMpDsItemResultPopServiceImpl implements MasterMpDsItemResultPopService {
	
	@Autowired
	private MasterMpDsItemResultPopDao masterMpDsItemResultPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpDsItemResultPopDao.selectList(formData);
	}	
	

}
