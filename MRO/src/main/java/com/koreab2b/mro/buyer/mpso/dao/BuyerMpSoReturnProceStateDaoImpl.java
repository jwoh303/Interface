package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpSoReturnProceStateDao")
@Transactional
public class BuyerMpSoReturnProceStateDaoImpl implements BuyerMpSoReturnProceStateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoReturnProceStateDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mpso.selectBuyerMpSoReturnProceStateList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		List<Map<String,String>>_list = null;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				_list = sqlSessionTemplate.selectList("buyer.mpso.getBuyerMpSoReturnProceStateCheck",formData);
				String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
				if(check_flag.equals("0")){	
					sqlSessionTemplate.insert("buyer.mpso.insertBuyerMpSoReturnProceStateCreate", formData);
					sqlSessionTemplate.update("buyer.mpso.updateBuyerMpSoReturnProceStateRq",formData);
					
				}else{
					_rtnMsg = "중복된 데이터가 존재합니다.";
					throw new RuntimeException(_rtnMsg);
					
				}	
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("장바구니 담기에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	
}
