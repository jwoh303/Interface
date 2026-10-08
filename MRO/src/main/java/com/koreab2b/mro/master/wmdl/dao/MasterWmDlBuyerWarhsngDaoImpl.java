package com.koreab2b.mro.master.wmdl.dao;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmDlBuyerWarhsngDao")
@Transactional
public class MasterWmDlBuyerWarhsngDaoImpl implements MasterWmDlBuyerWarhsngDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<String> buyerParam;
		buyerParam = Arrays.asList( ((String)param.get("st_buyer_code")).split("@@"));
		
		
	    if(buyerParam.size() >0 || !"".equals((String)param.get("st_buyer_code")) )
	    {
	    	param.put("buyerParam",buyerParam);
	    	param.put("buyerCnt","1");
	    }
		return sqlSessionTemplate.selectList("master.wmdl.selectMasterWmDlBuyerWarhsngList", param);
	}


}
