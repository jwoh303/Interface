package com.koreab2b.mro.master.mpiv.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpiv.dao.MasterMpIvOrderReceiptDelayListDao;

@Service("masterMpIvOrderReceiptDelayListService")
public class MasterMpIvOrderReceiptDelayListServiceImpl implements MasterMpIvOrderReceiptDelayListService {
	
	@Autowired
	private MasterMpIvOrderReceiptDelayListDao masterMpIvOrderReceiptDelayListDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIvOrderReceiptDelayListDao.selectList(param);
	}
}
