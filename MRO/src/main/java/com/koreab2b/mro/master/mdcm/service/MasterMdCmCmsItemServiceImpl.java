package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemDao;

@Service("masterMdCmCmsItemService")
public class MasterMdCmCmsItemServiceImpl implements MasterMdCmCmsItemService {

	@Autowired
	private MasterMdCmCmsItemDao masterMdCmCmsItemDao;

	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectList(param);
	}

	public Map<String,String> getDetail(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectDetail(param);
	}

	public List<Map<String,String>> getDetailAttrList(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectDetailAttrList(param);
	}

	public List<Map<String,String>> getDetailBuyInfoList(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectDetailBuyInfoList(param);
	}

	public List<Map<String,String>> getHistoryList(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectHistoryList(param);
	}

	public List<Map<String,String>> getBasePriceHistoryList(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectBasePriceHistoryList(param);
	}

	public Map<String,String> getBasePriceInfo(Map<String,Object> param) {
		return masterMdCmCmsItemDao.selectBasePriceInfo(param);
	}

	/**
	 * 기준가 변경 저장
	 *   인상 -> 즉시 반영, 빈 문자열 반환
	 *   인하 -> 신청만 만들고 채번된 PM_NO 반환. 화면은 그 번호로 결재 팝업을 띄운다
	 * 인상/인하는 화면이 아니라 DB 현재값으로 가른다.
	 */
	public String saveBasePrice(Map<String,String> param) {
		if (masterMdCmCmsItemDao.applyBasePrice(param) > 0) {
			return "";
		}
		return masterMdCmCmsItemDao.requestBasePriceDown(param);
	}

	/**
	 * 기준가 일괄 반영
	 * 인하 건이 하나라도 있으면 그 전부를 한 신청으로 묶고 채번된 PM_NO 를 돌려준다.
	 */
	public String saveBasePriceBulk(Map<String,String> param, List<Object> gridData) {
		return masterMdCmCmsItemDao.saveBasePriceBulk(param, gridData);
	}

	public String saveSelectedMsdsMapping(Map<String,String> param, List<Object> gridData) {
		return masterMdCmCmsItemDao.saveSelectedMsdsMapping(param, gridData);
	}

	public String saveSelectedMsdsClean(Map<String,String> param, List<Object> gridData) {
		return masterMdCmCmsItemDao.saveSelectedMsdsClean(param, gridData);
	}
}
