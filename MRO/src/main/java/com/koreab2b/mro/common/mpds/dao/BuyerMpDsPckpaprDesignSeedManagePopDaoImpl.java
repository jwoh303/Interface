package com.koreab2b.mro.common.mpds.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpDsPckpaprDesignSeedManagePopDao")
@Transactional
public class BuyerMpDsPckpaprDesignSeedManagePopDaoImpl implements BuyerMpDsPckpaprDesignSeedManagePopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectBuyerMpDsPckpaprDesignSeedManagePopList", formData);
	}

	//저장
	public String updateSelectedData_1(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_reg", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_2(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_order_packing_update_dd_reg", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_3(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_order_packing_update_ee_reg", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_4(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_es_mk1_reg", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_5(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_es_pd1_reg", formData);
			if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
				formData.put("st_user_dept", "PD1");
				formData.put("st_remark", formData.get("st_es_pd1_remark"));
				sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_6(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_es_qa1_reg", formData);
			if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
				formData.put("st_user_dept", "QA1");
				formData.put("st_remark", formData.get("st_es_qa1_remark"));
				sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
			}

	}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_7(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_order_packing_update_es_fi_reg", formData);
			if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
				formData.put("st_user_dept", "FI");
				formData.put("st_remark", formData.get("st_es_fi_remark"));
				sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
			}

	}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_8(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_es_mk_reg", formData);
			if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
				formData.put("st_user_dept", "MK");
				formData.put("st_remark", formData.get("st_es_mk_remark"));
				sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
			}

	}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String updateSelectedData_9(Map<String, String> formData) {
		String _rtnMsg = "저장이 성공적으로 이루어 졌습니다.";
	try{
			sqlSessionTemplate.update("common.mpds.buyer_dongbu_jongja_order_packing_update_es_pd_reg", formData);

			if( "GB".equals(formData.get("db_recv_flag"))){	//반려의 경우 반려이력을 남김
				formData.put("st_user_dept", "PD");
				formData.put("st_remark", formData.get("st_es_pd_remark"));
				sqlSessionTemplate.update("common.mpds.buyerUpdateGbHistory", formData);
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
