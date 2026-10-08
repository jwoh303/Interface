package com.koreab2b.mro.common.mpiv.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.CommonMpIvDlvryNoticePopDao;

@Service("commonMpIvDlvryNoticePopService")
public class CommonMpIvDlvryNoticePopServiceImpl implements CommonMpIvDlvryNoticePopService {
	
	@Autowired
	private CommonMpIvDlvryNoticePopDao commonMpIvDlvryNoticePopDao;

	// 저장
	public String updateCommonMpIvDlvryNoticePop(Map<String,String> pMap) {
		return commonMpIvDlvryNoticePopDao.updateCommonMpIvDlvryNoticePop(pMap);
	}
}
