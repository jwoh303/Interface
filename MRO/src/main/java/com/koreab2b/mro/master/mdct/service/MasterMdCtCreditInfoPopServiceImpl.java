package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdct.dao.MasterMdCtCreditInfoPopDao;

@Service("masterMdCtCreditInfoPopService")
public class MasterMdCtCreditInfoPopServiceImpl implements MasterMdCtCreditInfoPopService {
	@Autowired
	private MasterMdCtCreditInfoPopDao masterMdCtCreditInfoPopDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCtCreditInfoPopDao.selectList(param);
	}
}
