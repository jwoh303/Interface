package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterCmClApCloseConfirmDao")
@Transactional
public class MasterCmClApCloseConfirmDaoImpl implements MasterCmClApCloseConfirmDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterCmClApCloseConfirmDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApCloseConfirmList", param);
	}

	// 저장
		@SuppressWarnings("unchecked")
		public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
			String _jobKind = formData.get("job_kind");
			
			try {
				
				if ( "cancle".equals(_jobKind) ) {
					_rtnMsg = "제출취소 처리 완료 되었습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {
						formData.putAll((Map<String, String>)gridData.get(i));
						String siteName = CommonUtil.nvl(formData.get("SITE"), "");
						
						// 기존 데이터 삭제
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_delete", formData);
						// BILL_CLOSE_USER_LIST 업데이트
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_cancle", formData);						
						// 마감제출 FLAG 변경(MRO, 건설, 유통 분리)
						if(siteName.equals("KOREAB2B")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_mro", formData);
						} else if(siteName.equals("KWAY")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_kway", formData);
						} else if(siteName.equals("건설MRO")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_sa", formData);
						}
						
					}
				}
				
				// 회계전송
				else if ( "send".equals(_jobKind) ) {
					_rtnMsg = "세금계산서 전송이 완료 되었습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));
						String siteName = CommonUtil.nvl(formData.get("SITE"), "");						
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_send", formData);
						
						// ERP 전송(MRO, 건설, 유통 분리)
						if(siteName.equals("KOREAB2B")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_mro", formData);
						} else if(siteName.equals("KWAY")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_kway", formData);
						} else if(siteName.equals("건설MRO")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_sa", formData);
						}
					}
				}
				
				// 저장
				else if ( "save".equals(_jobKind) ) {
					_rtnMsg = "저장하였습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));					
						formData.put("LAST_MONTH_STOCK_AMT", CommonUtil.nvl(formData.get("LAST_MONTH_STOCK_AMT"),""));
						formData.put("THIS_MONTH_SELL_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_SELL_AMT"),""));
						formData.put("THIS_MONTH_BUY_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_BUY_AMT"),""));
						formData.put("THIS_MONTH_STOCK_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_STOCK_AMT"),""));
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_save", formData);
					}
				}
				// 추가제출
				else if ( "submit".equals(_jobKind) ) {
					_rtnMsg = "추가제출 처리하였습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_submit", formData);
					}
				}
				
				// 재고생성
				else if ( "stckAdd".equals(_jobKind) ) {
					_rtnMsg = "재고생성 하였습니다.";
					String count = "";
					List<Map<String,String>>_list = null;
					
					// 재고생성 중복 체크
					count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClApCloseConfirm_stck", formData);
									
					if(!count.equals("0")) {					
						throw new RuntimeException("이미 해당 월 재고생성 완료하였습니다.\nDX팀 확인 바랍니다.");					
					}					

					// 중복 생성 못하도록 추가
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_CloseStck", formData);
					
					// 재고생성
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck", formData);
					
					// 센터 확인
					_list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApCloseConfirm_wmsStck",formData);
					
					for(int i = 0; i < _list.size(); i++) {
						// 재고 당월 매입 추가
						_list.get(i).put("CLOSE_MONTH", formData.get("st_from_date"));
						sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck_ap", _list.get(i));	
						
						// 재고 매출 건 생성
						sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck_ar", _list.get(i));
					}
					
					
					
				}
				
			} catch (Exception e){
				
				if ( e instanceof RuntimeException ) {
				    throw new RuntimeException(e.getMessage());
				}
								else if ( "cancle".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 제출취소 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
				else if ( "send".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 회계전송 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
				else if ( "submit".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 추가제출 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
			}
			
			return _rtnMsg;
		}	
		
		// 저장
		@SuppressWarnings("unchecked")
		public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData) {
			String _jobKind = formData.get("job_kind");
			
			try {
				
				if ( "cancle".equals(_jobKind) ) {
					_rtnMsg = "제출취소 처리 완료 되었습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {
						formData.putAll((Map<String, String>)gridData.get(i));
						String siteName = CommonUtil.nvl(formData.get("SITE"), "");
						
						// 기존 데이터 삭제
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_delete", formData);
						// BILL_CLOSE_USER_LIST 업데이트
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_cancle", formData);						
						// 마감제출 FLAG 변경(MRO, 건설, 유통 분리)
						if(siteName.equals("KOREAB2B")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_mro", formData);
						} else if(siteName.equals("KWAY")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_kway", formData);
						} else if(siteName.equals("건설MRO")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirmFlag_sa", formData);
						}
						
					}
				}
				
				// 회계전송
				else if ( "send".equals(_jobKind) ) {
					_rtnMsg = "세금계산서 전송이 완료 되었습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));
						String siteName = CommonUtil.nvl(formData.get("SITE"), "");						
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_send", formData);
						
						// ERP 전송(MRO, 건설, 유통 분리)
						if(siteName.equals("KOREAB2B")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_mro", formData);
						} else if(siteName.equals("KWAY")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_kway", formData);
						} else if(siteName.equals("건설MRO")) {
							sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseErpSendFlag_sa", formData);
						}
					}
				}
				
				// 저장
				else if ( "save".equals(_jobKind) ) {
					_rtnMsg = "저장하였습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));					
						formData.put("LAST_MONTH_STOCK_AMT", CommonUtil.nvl(formData.get("LAST_MONTH_STOCK_AMT"),""));
						formData.put("THIS_MONTH_SELL_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_SELL_AMT"),""));
						formData.put("THIS_MONTH_BUY_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_BUY_AMT"),""));
						formData.put("THIS_MONTH_STOCK_AMT", CommonUtil.nvl(formData.get("THIS_MONTH_STOCK_AMT"),""));
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_save", formData);
					}
				}
				// 추가제출
				else if ( "submit".equals(_jobKind) ) {
					_rtnMsg = "추가제출 처리하였습니다.";
					
					for ( int i=0; i < gridData.size(); i++ ) {						
						formData.putAll((Map<String, String>)gridData.get(i));
						sqlSessionTemplate.update("master.cmcl.updateMasterCmClApCloseConfirm_submit", formData);
					}
				}
				
				// 재고생성
				else if ( "stckAdd".equals(_jobKind) ) {
					_rtnMsg = "재고생성 하였습니다.";
					String count = "";
					List<Map<String,String>>_list = null;
					
					// 재고생성 중복 체크
					count = (String) sqlSessionTemplate.selectOne("master.cmcl.selectMasterCmClApCloseConfirm_stck", formData);
									
					if(!count.equals("0")) {					
						throw new RuntimeException("이미 해당 월 재고생성 완료하였습니다.\nDX팀 확인 바랍니다.");					
					}					

					// 중복 생성 못하도록 추가
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_CloseStck", formData);
					
					// 재고생성
					sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck", formData);
					
					// 센터 확인
					_list = sqlSessionTemplate.selectList("master.cmcl.selectMasterCmClApCloseConfirm_wmsStck",formData);
					
					for(int i = 0; i < _list.size(); i++) {
						// 재고 당월 매입 추가
						_list.get(i).put("CLOSE_MONTH", formData.get("st_from_date"));
						sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck_ap_v2", _list.get(i));	
						
						// 재고 매출 건 생성
						sqlSessionTemplate.update("master.cmcl.insertMasterCmClApCloseConfirm_stck_ar", _list.get(i));
					}
					
					
					
				}
				
			} catch (Exception e){
				
				if ( e instanceof RuntimeException ) {
				    throw new RuntimeException(e.getMessage());
				}
								else if ( "cancle".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 제출취소 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
				else if ( "send".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 회계전송 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
				else if ( "submit".equals(_jobKind) ) {
					throw new RuntimeException("\n\n[ 추가제출 처리 실패 ]\n\n관리자에게 문의 하시기 바랍니다.");
				}
			}
			
			return _rtnMsg;
		}

}
