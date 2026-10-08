package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mprq.dao.SellerMpRqBulkQuotationPriceRegPopDao;


@Service("SellerMpRqBulkQuotationPriceRegPopService")
public class SellerMpRqBulkQuotationPriceRegPopServiceImpl implements SellerMpRqBulkQuotationPriceRegPopService {
	
	@Autowired
	private SellerMpRqBulkQuotationPriceRegPopDao SellerMpRqBulkQuotationPriceRegDao;

	// 엑셀 업로드
	public String batchSellerMpRqBulkQuotationPriceReg(Map<String, String> param,List<Object> gridData){
		return SellerMpRqBulkQuotationPriceRegDao.batchdata(param , gridData);
	}
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> checkSellerMpRqBulkQuotationPriceReg(Map<String, String> param) {
		return  SellerMpRqBulkQuotationPriceRegDao.selectdata(param);
	}
	// 단가 등록
	@Override
	public String saveSellerMpRqBulkQuotationPriceReg(Map<String, String> param) {
		return  SellerMpRqBulkQuotationPriceRegDao.savedata(param);
	}

}
