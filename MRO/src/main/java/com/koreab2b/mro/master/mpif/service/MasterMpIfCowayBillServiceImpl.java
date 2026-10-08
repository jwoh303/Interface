package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfCowayBillDao;
/**
 * @author jinsoo97
 *
 */
@Service("masterMpIfCowayBillService")
public class MasterMpIfCowayBillServiceImpl implements MasterMpIfCowayBillService {


	@Autowired
	private MasterMpIfCowayBillDao masterMpIfCowayBillDao;
	
	@Override
	public List<Map<String, String>> getMasterMpIfCowayBillList(Map<String, Object> pMap) {
		return masterMpIfCowayBillDao.selectMasterMpIfCowayBillList(pMap);
	}

	@Override
	public String sendMasterMpIfCowayBill(Map<String, Object> pMap) {
		// TODO Auto-generated method stub
		return null;
	}

}
