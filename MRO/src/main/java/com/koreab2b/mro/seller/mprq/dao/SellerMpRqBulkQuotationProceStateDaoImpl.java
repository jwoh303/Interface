package com.koreab2b.mro.seller.mprq.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpRqBulkQuotationProceStateDao")
@Transactional
public class SellerMpRqBulkQuotationProceStateDaoImpl implements SellerMpRqBulkQuotationProceStateDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpRqBulkQuotationProceStateDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	/*조회*/
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object>  param) {
		String str = (String) param.get("st_burq_rfq_no");
		
		String[] str_arr = str.split(",");
		
		List<String> burq_rfq_no_list = new ArrayList<String>();
		for(int i = 0; i < str_arr.length; i++) {
			burq_rfq_no_list.add(str_arr[i]);
		}
		param.put("st_burq_rfq_no_all", burq_rfq_no_list);
		
		logger.debug("selectList param : {} ", param);
		
		// 조회될 견적 건 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		sqlSessionTemplate.update("seller.mprq.updateSellerMpRqBulkQuotationProceStateRfqStatus", param);
		
		// 조회될 수 있는 프로젝트 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		sqlSessionTemplate.update("seller.mprq.updateSellerSelProject", param);
		
		return  sqlSessionTemplate.selectList("seller.mprq.selectSellerMpRqBulkQuotationProceState", param);
	}
	
}
