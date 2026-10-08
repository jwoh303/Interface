package com.koreab2b.mro.seller.none.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerNoNeSaleshookProposalDao")
@Transactional
public class SellerNoNeSaleshookProposalDaoImpl implements SellerNoNeSaleshookProposalDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerNoNeSaleshookProposalDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> param) {

		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("seller.none.selectSellerNoNeSaleshookProposalList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		return resultList;
	}
	
	public String insertSellerNoNeSaleshookProposal(Map<String,String> formData) {
		
		String _rtnMsg = "";
		String _itemNo = "0";
		
		try{
			// item_no 채번
			_itemNo = sqlSessionTemplate.selectOne("seller.none.selectPromoteMaxItemNo");
			
			formData.put("st_item_no", _itemNo);
			
			// PRMTITEM INSERT
			sqlSessionTemplate.update("seller.none.insertSellerNoNeSaleshookProposalReg", formData);
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("신규상품제안 등록중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}

}
