package com.koreab2b.mro.master.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdsr.dao.MasterMdSrSrCmsStateDao;

@Service("masterMdSrSrCmsStateService")
public class MasterMdSrSrCmsStateServiceImpl implements MasterMdSrSrCmsStateService {
	
	@Autowired
	private MasterMdSrSrCmsStateDao masterMdSrSrCmsStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdSrSrCmsStateDao.selectList(param);
	}	
}
