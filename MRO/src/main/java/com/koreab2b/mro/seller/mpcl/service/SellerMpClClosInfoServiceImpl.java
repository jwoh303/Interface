package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClClosInfoDao;

@Service("sellerMpClClosInfoService")
public class SellerMpClClosInfoServiceImpl implements SellerMpClClosInfoService {

	@Autowired
	private SellerMpClClosInfoDao sellerMpClClosInfoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectList(param);
	}

	// 리뉴얼 버전 리스트 조회 (검색조건 추가)
	public List<Map<String,String>> getList_V2(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectList_V2(param);
	}

	// 마감 대상 내역 조회
	public List<Map<String,String>> getTargetList_V2(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectTargetList_V2(param);
	}
	public List<Map<String,String>> getTargetList_V3(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectTargetList_V3(param);
	}

	// 탭5 전용 리스트 조회
	public List<Map<String,String>> getTab5List(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectTab5List(param);
	}
	public List<Map<String,String>> getTab5List_v2(Map<String,Object> param) {
		return sellerMpClClosInfoDao.selectTab5List_v2(param);
	}
}
