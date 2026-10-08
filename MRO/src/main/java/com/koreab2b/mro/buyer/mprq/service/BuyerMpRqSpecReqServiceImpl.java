package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mprq.dao.BuyerMpRqSpecReqDao;

@Service("BuyerMpRqSpecReqService")
public class BuyerMpRqSpecReqServiceImpl implements BuyerMpRqSpecReqService {

	@Autowired
	private BuyerMpRqSpecReqDao BuyerMpRqSpecReqDao;
	
	/*규격의뢰*/
	@Transactional
	public String saveData(List<Object> gridData, Map<String,String>  formData){
		return BuyerMpRqSpecReqDao.updateData(gridData, formData);
	}
 
}
