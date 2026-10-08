package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemAltCodeSelPopDao;

@Service("masterMdCmCmsItemAltCodeSelPopService")
public class MasterMdCmCmsItemAltCodeSelPopServiceImpl implements MasterMdCmCmsItemAltCodeSelPopService {

	@Autowired
	private MasterMdCmCmsItemAltCodeSelPopDao masterMdCmCmsItemAltCodeSelPopDao;

	public Map<String,String> getBase(Map<String,Object> param) {
		return masterMdCmCmsItemAltCodeSelPopDao.selectBase(param);
	}

	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCmsItemAltCodeSelPopDao.selectList(param);
	}

}
