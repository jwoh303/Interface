package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@SuppressWarnings("unchecked")
@Repository("masterMpIfSecItemInfoDao")
@Transactional
public class MasterMpIfSecItemInfoDaoImpl implements MasterMpIfSecItemInfoDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfSecItemInfoDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfSecItemInfoList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	@Override
	public String deleteItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			for( int i = 0 ; i < pGridData.size() ; i++ ) {
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				pFormData.put("P_MSG", "[삭제]");
				sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);	
			}
			
			_rtnMsg	= "삭제되었습니다.";
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품목IF이력 삭제중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	@Override
	public String updateItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			/**
			 * update icombyit
			 * update icomcqdt
			 * update kepqtdt
			 * udpate keprqdt
			 */
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				sqlSessionTemplate.update("updateIcombyitInfo", pFormData);
				sqlSessionTemplate.update("updateIcomcqdtInfo", pFormData);
				sqlSessionTemplate.update("updateKepqtdtInfo", pFormData);
				sqlSessionTemplate.update("updateKeprqdtInfo", pFormData);
				pFormData.put("P_MSG", "[수정]");
				sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);
			}

			_rtnMsg	= "수정되었습니다.";
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품목정보 수정중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	@Override
	public String requotItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			/**
			 * update keprqdt
			 * update kepqtdt
			 * update eai.if_sec_item_info_send
			 */
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));

				sqlSessionTemplate.update("updateIcombyitForDel", pFormData);
				sqlSessionTemplate.update("updateIcomcqdtForDel", pFormData);
				sqlSessionTemplate.update("deleteIcombyitForIf", pFormData);
				sqlSessionTemplate.update("deleteIcomcqdtForIf", pFormData);
				sqlSessionTemplate.update("requotKeprqdtInfo", pFormData);
				sqlSessionTemplate.update("requotKepqtdtInfo", pFormData);
				pFormData.put("P_MSG", "[재견적]");
				sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);
			}
			_rtnMsg	= "협력사선정완료 상태로 복원했습니다.";
			
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재견적 처리중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	@Override
	public String registItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "";
		
		try {
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				String buyer_item_no	= pFormData.get("BUYER_ITEM_NO");
				String cms_catlg_id		= pFormData.get("CMS_CATLG_ID");
				pFormData.put("P_MSG", "[재등록]");
				sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);
				
				pFormData.put("TARGET","KRSAMS0123");
				pFormData.put("KEY_1",buyer_item_no);
				pFormData.put("KEY_2","REGIST_ITEM");
				if (!"".equals(buyer_item_no) && !cms_catlg_id.equals(buyer_item_no)) {
					pFormData.put("KEY_3","INITIAL_REGIST");	
				} else {
					pFormData.put("KEY_3","");
				}
				pFormData.put("KEY_4","");
				pFormData.put("KEY_5","");
				pFormData.put("KEY_6","");
				pFormData.put("KEY_7","");
				pFormData.put("KEY_8","");
				pFormData.put("KEY_9","");
				pFormData.put("KEY_10","");
				sqlSessionTemplate.insert("master.mpif.insertSecItemEvent", pFormData);
			}

			_rtnMsg	= "재등록되었습니다.";
		} catch (Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("품목재등록중 오류가 발생했습니다.");
		}
		return _rtnMsg;
	}
	@Override
	public String cancelItemInfo(Map<String, String> pFormData, List<Object> pGridData) {
		// TODO Auto-generated method stub
		String _rtnMsg = "견적을 취소 하였습니다.";
  		
  		try{
  			for(int i=0; i < pGridData.size(); i++){
  				pFormData.putAll((Map<String, String>)pGridData.get(i));		
  				sqlSessionTemplate.update("master.mpif.deleteQuotReceipt", pFormData);
  				logger.error("deleteMasterMpRqReqQuotReceipt_1 실행 완료");
  				
  				/*프로시저 실행*/
  				sqlSessionTemplate.selectList("master.mprq.procQtItemCatalogDelete", pFormData);
  							
  				if("SUCCESS".equals(pFormData.get("RESULT"))){
  					pFormData.put("P_MSG", "[견적취소]"+pFormData.get("CANCEL_REMARK")+" / ");
  					sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);
  				}
  				else if(!"SUCCESS".equals(pFormData.get("RESULT"))){
  					_rtnMsg = "프로시저[PROC_QT_ITEM_CATALOG_DELETE]가 실행되지 못했습니다..";
  					throw new RuntimeException(_rtnMsg);
  //					return _rtnMsg;
  				}  				
  			}
  		}catch(Exception e){
  			logger.error("SQL ERROR : ", e);
  			throw new RuntimeException("견적 취소에 실패하였습니다.");
  		}

  		return _rtnMsg;		
	}
	
	@Override
	public String resendPrice(Map<String, String> pFormData, List<Object> pGridData) {
		String _rtnMsg = "단가변경 이벤트를 등록했습니다.";

  		try{
			for(int i = 0 ; i < pGridData.size() ; i++ ){
				pFormData.putAll((Map<String, String>)pGridData.get(i));
				
				String buyer_item_no	= pFormData.get("BUYER_ITEM_NO");
				String st_pm_buyer		= pFormData.get("PM_BUYER");
				String st_pm_no		= pFormData.get("PM_NO");
				String st_pm_seq		= pFormData.get("PM_SEQ");
				String st_result_msg	= pFormData.get("RESULT_MSG");
				String if_flag	= pFormData.get("IF_FLAG");
				
				if (  !"S".equals(if_flag) || !"".equals(st_result_msg)  ) {
					throw new RuntimeException("품목["+buyer_item_no+"]은 재전송 대상이 아닙니다.");
				}
				
				pFormData.put("P_MSG", "[단가재전송]");
				sqlSessionTemplate.update("master.mpif.deleteSecItemInfo", pFormData);
				
				if ( "KRKORE0001".equals(st_pm_buyer) ) {
					pFormData.put("TARGET","KRSAMSG001");
				} else {
					pFormData.put("TARGET",st_pm_buyer);	
				}
				pFormData.put("KEY_1",buyer_item_no);
				pFormData.put("KEY_2","CHANGE_PRICE");
				pFormData.put("KEY_3",st_pm_no);
				pFormData.put("KEY_4",st_pm_seq);
				pFormData.put("KEY_5","");
				pFormData.put("KEY_6","");
				pFormData.put("KEY_7","");
				pFormData.put("KEY_8","");
				pFormData.put("KEY_9","");
				pFormData.put("KEY_10","");
				sqlSessionTemplate.insert("master.mpif.insertSecItemEvent", pFormData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(e.getMessage());
		}
		return _rtnMsg;
	}
	
}
