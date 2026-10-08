package com.koreab2b.mro.master.mpvo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpvo.dao.MasterMpVoStateDownloadDao;

@Service("masterMpVoStateDownloadService")
public class MasterMpVoStateDownloadServiceImpl implements MasterMpVoStateDownloadService {
	
	@Autowired
	private MasterMpVoStateDownloadDao masterMpVoStateDownloadDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpVoStateDownloadDao.selectList(param);
	}	

}
