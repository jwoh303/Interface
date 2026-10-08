package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtNewReBuyerDetailPopDao;

@Service("masterMdCtNewReBuyerDetailPopService")
public class MasterMdCtNewReBuyerDetailPopServiceImpl implements MasterMdCtNewReBuyerDetailPopService {
	@Autowired
	private MasterMdCtNewReBuyerDetailPopDao masterMdCtNewReBuyerDetailPopDao; 
	
	// 조회
	public List<Map<String,String>> getMasterMdCtNewReBuyerDetailPop(Map<String,Object>  pMap){
		return masterMdCtNewReBuyerDetailPopDao.selectMasterMdCtNewReBuyerDetailPop(pMap);
	}
}