package com.koreab2b.mro.common.wmgr.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("masterWmGrWarehousingPopDao")
@Transactional
public class MasterWmGrWarehousingPopDaoImpl implements MasterWmGrWarehousingPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrWarehousingPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectPop(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrWarehousingPopDetail", formData);
	}
	public List<Map<String,String>> selectPop_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrWarehousingPopDetail_v2", formData);
	}
	
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrWarehousingPopList", formData);
	}

	
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "OK";
		
		try{
			//입고삭제가 가능한지 검사 	
			Map<String,Object> pMap = new HashMap<String,Object>();
//			pMap.putAll(formData);
//			Map<String,Object> checkMap = thisselectPop(pMap).get(0);
//			BigDecimal _grQty = new BigDecimal(checkMap.get("WMS_GR_QTY").toString());
//			BigDecimal _ivkQty = new BigDecimal(checkMap.get("WMS_IVK_QTY").toString());
//			BigDecimal _zero = new BigDecimal("0");
//			if(_grQty.compareTo(_zero) ==0  ){
//				_rtnMsg = "센타 입고 전의 상태입니다.\n삭제하실 수 없습니다.";
//				return _rtnMsg;
//			}
//			if(_ivkQty.compareTo(_zero)  >0 ){
//				_rtnMsg = "센타 송장 작성 이후의 단계입니다.\n삭제하실 수 없습니다.";
//				return _rtnMsg;
//			}
			if(formData.get("HUB_YN").equals("Y")){ // 간선 입고확정 or 간선출고 삭제
				if(formData.get("HUB_DEL_FLAG").equals("Y")){ // 간선출고 삭제
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "G");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					// HUBIVDT 변경
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingHubIvDel", formData);
				}else{ // 간선 입고확정 삭제
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "Y");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					// HUBIVDT 변경
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingHubGrDel", formData);
				}
			}else{ // 기존 입고확정 삭제
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingPopList", formData);	
			}
			
			logger.error("deleteMasterWmGrStockGrCre 실행 완료");
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "입고 삭제에 실패하였습니다.";
			throw new RuntimeException("입고 삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "OK";
		
		try{
			//입고삭제가 가능한지 검사 	
			Map<String,Object> pMap = new HashMap<String,Object>();
//			pMap.putAll(formData);
//			Map<String,Object> checkMap = thisselectPop(pMap).get(0);
//			BigDecimal _grQty = new BigDecimal(checkMap.get("WMS_GR_QTY").toString());
//			BigDecimal _ivkQty = new BigDecimal(checkMap.get("WMS_IVK_QTY").toString());
//			BigDecimal _zero = new BigDecimal("0");
//			if(_grQty.compareTo(_zero) ==0  ){
//				_rtnMsg = "센타 입고 전의 상태입니다.\n삭제하실 수 없습니다.";
//				return _rtnMsg;
//			}
//			if(_ivkQty.compareTo(_zero)  >0 ){
//				_rtnMsg = "센타 송장 작성 이후의 단계입니다.\n삭제하실 수 없습니다.";
//				return _rtnMsg;
//			}
			if(formData.get("HUB_YN").equals("Y")){ // 간선 입고확정 or 간선출고 삭제
				if(formData.get("HUB_DEL_FLAG").equals("Y")){ // 간선출고 삭제
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "G");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdt", formData);
					// HUBIVDT 변경
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingHubIvDel", formData);
				}else{ // 간선 입고확정 삭제
					// ICOMIVDT.HUB_FLAG 변경
					formData.put("HUB_FLAG", "Y");
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrTrGrCreHubIcomivdtDel_v2", formData); //delivery_date 도 null처리
					// HUBIVDT 변경
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingHubGrDel", formData);
				}
			}else{ // 기존 입고확정 삭제
				int hubIvdtCheck = sqlSessionTemplate.selectOne("master.wmgr.getMasterWmGrTrCreHubIvdtCount_v2", formData);
				if(hubIvdtCheck == 0) { //순수입고센터
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingPopList_v2", formData);	
				}else {
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrWarehousingPopList", formData);	
				}
			}
			
			logger.error("deleteMasterWmGrStockGrCre 실행 완료");
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "입고 삭제에 실패하였습니다.";
			throw new RuntimeException("입고 삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	
}
