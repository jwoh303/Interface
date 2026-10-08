package com.koreab2b.mro.common.mpcl.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpClPositionCodePopDaoImpl")
@Transactional
public class SellerMpClPositionCodePopDaoImpl implements SellerMpClPositionCodePopDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpClPositionCodePopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	private String _rtnMsg;

	// 조회
	public Map<String,String> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectOne("common.mpcl.selectSellerMpClPositionCodePop", formData);
	}
	
	// 저장
	public String insertSelectedData(Map<String,String> formData) {

		_rtnMsg = "Ok";
		String _resultCount = "";
		int res_cnt = 0;
		
		try {
			// 회사별 코드관리 count
			_resultCount = sqlSessionTemplate.selectOne("common.mpcl.selectSellerMpClPositionCodePop_Count", formData);
			
			if ( !"0".equals(_resultCount) ) {
				_rtnMsg = "Duplicate";
			} else {
				// 회사별 코드관리 insert
				res_cnt = sqlSessionTemplate.insert("common.mpcl.insertSellerMpClPositionCodePop", formData);
				
				if ( res_cnt != 1 ) {
					_rtnMsg = "Fail";
				}
			}
			
            
		} catch( Exception e ) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 직급코드 입력 실패 ]");
		}
		
		return _rtnMsg;
	}
	
	// 수정
	public String updateSelectedData(Map<String,String> formData) {
		
		_rtnMsg = "Ok";
		int res_cnt = 0;
		
		try {
			// 회사별 코드관리 update
			res_cnt = sqlSessionTemplate.update("common.mpcl.updateSellerMpClPositionCodePop", formData);
			
			if ( res_cnt != 1 ) {
				_rtnMsg = "Fail";
			}
			
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 직급코드 수정 실패 ]");
		}
		
		return _rtnMsg;
	}
	
	// 삭제
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData) {
		
		_rtnMsg = "Ok";
		int res_cnt = 0;
		
		try {
			// 구매대행재고수불 delete
            res_cnt = sqlSessionTemplate.delete("common.mpcl.deleteSellerMpClPositionCodePop", formData);
			
            if ( res_cnt != 1 ) {
            	_rtnMsg = "Fail";
            }
            
		} catch(Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("\n\n[ 직급코드 삭제 실패 ]");
		}

		return _rtnMsg;		
	}	
	
}
