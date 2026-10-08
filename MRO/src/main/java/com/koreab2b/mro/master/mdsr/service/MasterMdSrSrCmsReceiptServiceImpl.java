package com.koreab2b.mro.master.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdsr.dao.MasterMdSrSrCmsReceiptDao;

@Service("masterMdSrSrCmsReceiptService")
public class MasterMdSrSrCmsReceiptServiceImpl implements MasterMdSrSrCmsReceiptService {
	
	@Autowired
	private MasterMdSrSrCmsReceiptDao masterMdSrSrCmsReceiptDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdSrSrCmsReceiptDao.selectList(param);
	}	

}
