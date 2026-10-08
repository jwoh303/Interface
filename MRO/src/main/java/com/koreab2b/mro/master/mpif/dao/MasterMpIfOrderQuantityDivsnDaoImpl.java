package com.koreab2b.mro.master.mpif.dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
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
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIfOrderQuantityDivsnDao")
@Transactional
public class MasterMpIfOrderQuantityDivsnDaoImpl implements MasterMpIfOrderQuantityDivsnDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfOrderQuantityDivsnDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfOrderQuantityDivsnList", param);
	}
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectExcelList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
		sqlSessionTemplate.select("master.mpif.selectMasterMpIfOrderQuantityDivsnExcel", param,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		Map<String, String> lastLoginList = null;
		
		_rtnMsg = "저장완료.";
		Map<String,Object>  data = new HashMap<String,Object>();
		String _dataList = "";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				_dataList += formData.get("LEGACY_PO_NO") + "^" + formData.get("LEGACY_PO_SEQ") + "^" + formData.get("BUYER_ITEM_NO") + "@@";
				
				lastLoginList = sqlSessionTemplate.selectOne("master.mpif.selectLastLoginIdWithIfInfo", formData);
				
				// 주문요청자, 발주자 마지막 로그인정보 UPDATE
				formData.put("LAST_LOGIN_ID", lastLoginList.get("REQ_USER_ID"));
				formData.put("LAST_LOGIN_ID1",lastLoginList.get("PURCHASER_USER_ID"));
				
				// 주문요청자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime", formData);
		        
		        // 발주자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime1", formData);
			}
			
			List<String> _list = new ArrayList< String >( );
			_list = CommonUtil.getStringArrary((String) _dataList,"@@");
			
			if(_list.size() > 0) {
				data.put("if_divsn_array", _list);
			} 
			
			List<Map<String,String>> _divsnList = sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfOrderQuantityDivsnSaveList", data);
			
			for (int i=0; i < _divsnList.size(); i++) {
				Map<String,String>  pMap = new HashMap<String,String>();
				pMap.clear();
				pMap.putAll((Map<String, String>)_divsnList.get(i));
				setDaewoo_POIF_DATA_Check(pMap);
			}
			
			String pr_result = setDaewoo_Proxybuy_Create_PR(data);     // PR , PO 생성
			
			
			if (pr_result == "OK") {
				_rtnMsg = "발주가 정상적으로 이루어 졌습니다.";
			} else {
				_rtnMsg = "발주가 실패하였습니다.\n\n운영자에게 문의하시기 바랍니다.";
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("발주가 실패하였습니다.\n\n운영자에게 문의하시기 바랍니다.");
		}
		
		return _rtnMsg;
	}
	
	public String setDaewoo_Proxybuy_Create_PR(Map<String,Object>  formData) {

		String pre_legacy_po_no = "";
        String cur_legacy_po_no = "";
        String next_legacy_po_no = "";

        String cur_legacy_po_seq  = "";
        String next_legacy_po_seq = "";
        
        String pr_no  = "";
        String pr_seq = "0";
        String pr_status = "";
        String px_no  = "";
        String pr_start_no = "";
        String pr_end_no = "";
        List<Map<String,String>> _divsnListTemp =  sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfOrderQuantityDivsnSaveList2", formData);
        List<Map<String,String>> _divsnList = CommonUtil.getListNvl(_divsnListTemp);
        
        try {
			for (int i=0; i < _divsnList.size(); i++) {
				Map<String,String>  pMap = new HashMap<String,String>();
				pMap.putAll((Map<String, String>)_divsnList.get(i));
				
				 cur_legacy_po_no  = pMap.get("LEGACY_PO_NO");
	             cur_legacy_po_seq = pMap.get("LEGACY_PO_SEQ");
	             
				if (i+1 != _divsnList.size()) {
					Map<String,String>  nextMap = new HashMap<String,String>();
					nextMap.putAll((Map<String, String>)_divsnList.get(i+1));
					next_legacy_po_no  = nextMap.get("LEGACY_PO_NO");
	                next_legacy_po_seq = nextMap.get("LEGACY_PO_SEQ");
	            } else {
	                next_legacy_po_no = "";
	                next_legacy_po_seq = "";
	            }
				
				if (!cur_legacy_po_no.equals(pre_legacy_po_no)) {
					Map<String,String>  tmpMap = new HashMap<String,String>();
					Map<String,String>  oMap = new HashMap<String,String>();
					tmpMap = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnIcomprdtSeq", pMap);
	                
	                if (tmpMap != null) {
	                	 pr_no  = tmpMap.get("PR_NO");
	                     pr_seq = String.valueOf(tmpMap.get("PR_SEQ"));
	                     pr_status = "UPDATE";
	                } else {
	                	oMap.put("COMPANY", "KRDAEW0016");
	                	oMap.put("DOC_TYPE", "PR");
	                	pr_no  = getDivsnOrderNo(oMap);
						pr_seq = "0";
						pr_status = "INSERT";
	                }
	                
	                oMap.clear();
	                oMap.put("COMPANY", "KRDAEW0016");
	            	oMap.put("DOC_TYPE", "PX");
	                px_no  = getDivsnOrderNo(oMap);
					pr_start_no = pr_seq;
	            } else {
	                pr_seq = String.valueOf(Integer.parseInt(pr_seq)+1);
	            }
				
				pre_legacy_po_no = cur_legacy_po_no;
				
				pMap.put("PR_NO", pr_no);
				pMap.put("PR_SEQ", String.valueOf(Integer.parseInt(pr_seq)+1));
				pMap.put("PX_NO", px_no);
				
				pMap.put("MAKER_PART_NO", CommonUtil.nvl(pMap.get("MAKER_PART_NO")));
				sqlSessionTemplate.update("master.mpif.insertMasterMpIfOrderQuantityDivsnIcomprdt", pMap);

				// 다음 요청번호와 다를경우 ICOMPRHD 생성
				if (!cur_legacy_po_no.equals(next_legacy_po_no)) {
					pr_end_no = pr_seq;
	                
					int prhd_cnt = 0;
					if (pr_status.equals("INSERT")) {
						prhd_cnt = sqlSessionTemplate.insert("master.mpif.insertMasterMpIfOrderQuantityDivsnIcomprhd", pMap);
					} else {	
						prhd_cnt = sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderQuantityDivsnIcomprhd", pMap);
					}
	
					if (prhd_cnt != 1) {
						throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  INSERT ICOMPRHD OR UPDATE ICOMPRHD");
					} else {  //  PO생성
						String po_result =  setDaewoo_Proxybuy_Create_PO(pr_no, pr_start_no, pr_end_no, pMap);
						if (!po_result.equals("OK")) {
							throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  INSERT ICOMPODT OR INSERT ICOMPOHD");
						}
					}	// end else
				}	// 다음 요청번호와 다를경우 ICOMPRHD 생성 끝
	
				//  POIFLOAD.IF_FLAG ='Y' 로 업데이트
				if ((!cur_legacy_po_seq.equals(next_legacy_po_seq) || !cur_legacy_po_no.equals(next_legacy_po_no)) && !cur_legacy_po_no.equals("")) {
					int poifload_cnt = 0;
					poifload_cnt = sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderQuantityDivsnIfPodt2", pMap);
	            	 
					if (poifload_cnt != 1) {
						throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  UPDATE POIFLOAD");
					}
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("\n\n대우조선 분할발주 PR 생성 중 에러가 발생 하였습니다.");
		}
		
		return "OK";
	}
	
	public String setDaewoo_Proxybuy_Create_PO(String pr_no, String pr_start_no, String pr_end_no, Map<String,String>  formData) {
		String po_no  = "";
		String po_seq = "0";
		
		int po_start_index  = Integer.parseInt(pr_start_no);
		int po_end_index    = Integer.parseInt(pr_end_no)+1;
		
		Map<String,Object>  data = new HashMap<String,Object>();
		String _dataList = "";

		try {
			for (int t = po_start_index ; t < po_end_index ; t++) {
				_dataList += pr_no + "^" + (t+1) + "@@";  
			}
			
			List<String> _list = new ArrayList< String >( );
			_list = CommonUtil.getStringArrary((String) _dataList,"@@");
			
			if(_list.size() > 0) {
				data.put("if_divsn_array", _list);
			}
	
			List<Map<String,String>> _divsnList = sqlSessionTemplate.selectList("master.mpif.selectMasterMpIfOrderQuantityDivsnSaveList3", data);
			
			for (int i=0; i < _divsnList.size(); i++) {
				Map<String,String>  curMap = new HashMap<String,String>();
				Map<String,String>  preMap = new HashMap<String,String>();
				Map<String,String>  nextMap = new HashMap<String,String>();
				
				curMap.putAll((Map<String, String>)_divsnList.get(i));
				if (i > 0) {
					preMap.putAll((Map<String, String>)_divsnList.get(i-1));
				}
				if (i+1 != _divsnList.size()) {
					nextMap.putAll((Map<String, String>)_divsnList.get(i+1));
				}	

				if ( !curMap.get("AGENT").equals(preMap.get("AGENT")) || !curMap.get("REQ_USER_INFO").equals(preMap.get("REQ_USER_INFO")) || !curMap.get("DOC_TYPE").equals(preMap.get("DOC_TYPE")) || !curMap.get("DELY_TO_LOCATION").equals(preMap.get("DELY_TO_LOCATION")) || !curMap.get("PROCESS_TYPE").equals(preMap.get("PROCESS_TYPE"))) { // 공급사가 다를경우 PO번호 생성
					Map<String,String>  oMap = new HashMap<String,String>();
					oMap.put("COMPANY", "KRDAEW0016");
		            oMap.put("DOC_TYPE", "PO");
					po_no  = getDivsnOrderNo(oMap);
					po_seq = "0";
				} else {
					po_seq = String.valueOf(Integer.parseInt(po_seq)+1);
				}
				
				curMap.put("PO_NO", po_no);
				curMap.put("PO_SEQ", String.valueOf(Integer.parseInt(po_seq)+1));
				
				int podt_cnt = 0;
				podt_cnt = sqlSessionTemplate.insert("master.mpif.insertMasterMpIfOrderQuantityDivsnIcompodt", curMap);
	
				if (podt_cnt != 1) {
					throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  INSERT ICOMPODT");
				}
				
				int cqdt_cnt = 0;
				cqdt_cnt = sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderQuantityDivsnIcomcqdt", curMap);
	
				if (cqdt_cnt != 1) {
					throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  UPDATE ICOMCQDT");
				}
				
				// 공급사가 다를경우
				if ( !curMap.get("AGENT").equals(nextMap.get("AGENT")) || !curMap.get("REQ_USER_INFO").equals(nextMap.get("REQ_USER_INFO")) || !curMap.get("DOC_TYPE").equals(nextMap.get("DOC_TYPE")) || !curMap.get("DELY_TO_LOCATION").equals(nextMap.get("DELY_TO_LOCATION")) || !curMap.get("PROCESS_TYPE").equals(nextMap.get("PROCESS_TYPE"))) {
					int pohd_cnt = 0;
					//PO_NO가 같은 금액을 ICOMPODT 테이블에서 SUM 해서 등록
					pohd_cnt = sqlSessionTemplate.insert("master.mpif.insertMasterMpIfOrderQuantityDivsnIcompohd", curMap);
					//메일전송
					sqlSessionTemplate.update("master.mpif.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO", curMap);
	
					if (pohd_cnt != 1) {
						throw new RuntimeException("\n\n대우조선 분할발주 중 에러가 발생 하였습니다.  ==>  INSERT ICOMPOHD");
					}
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			
			throw new RuntimeException("\n\n대우조선 분할발주 PO 생성 중 에러가 발생 하였습니다.");
		}
		
		return "OK";
	}
	
	public String getDivsnOrderNo(Map<String,String>  formData) {
		String orderNo = "";
		Map<String,String> orderMap = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnOrderNo", formData);
		
		if (orderMap == null) {
			sqlSessionTemplate.insert("master.mpif.insertMasterMpIfOrderQuantityDivsnOrderNo", formData);
			
			int year_num = Calendar.getInstance().get(Calendar.YEAR);
			String year_str = String.valueOf(year_num);
			orderNo = formData.get("DOC_TYPE") + year_str.substring(2,4) + "000001";
		} else {
			orderNo = orderMap.get("ORDER_NO");
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderQuantityDivsnOrderNo", formData);
		}
		
		return orderNo;
	}
	
	public void setDaewoo_POIF_DATA_Check(Map<String,String>  formData) {
		Map<String, String> pMap = new HashMap<String, String>();
 
		pMap.put("ERROR_MSG", "");
		pMap.put("STATUS", formData.get("STATUS"));
		pMap.put("IF_FLAG", formData.get("IF_FLAG"));
		pMap.put("BUYER", formData.get("BUYER"));
		pMap.put("LEGACY_PO_NO", formData.get("LEGACY_PO_NO"));
		pMap.put("LEGACY_PO_SEQ", formData.get("LEGACY_PO_SEQ"));
		pMap.put("BUYER_ITEM_NO", formData.get("BUYER_ITEM_NO"));
		
		if( !"S".equals(formData.get("STATUS")) && "0".equals(formData.get("UNIT_PRICE")) && "0".equals(formData.get("ITEM_QTY")) && "0".equals(formData.get("ITEM_AMT"))) {
			pMap.put("st_status", "D");
        }
		
		try {
			pMap.putAll(POIF_DATA_Check_000(formData));
			pMap.putAll(POIF_DATA_Check_001(formData));
			pMap.putAll(POIF_DATA_Check_002(formData));
			pMap.putAll(POIF_DATA_Check_004(formData));
			pMap.putAll(POIF_DATA_Check_005(formData));
			pMap.putAll(POIF_DATA_Check_006(formData));
			
			sqlSessionTemplate.update("master.mpif.updateMasterMpIfOrderQuantityDivsnIfPodt", pMap);
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("POIFLOAD 데이타 체크에 실패하였습니다.");
		}
	}
	
	public Map<String, String> POIF_DATA_Check_000(Map<String, String>  formData) {
		
		Map<String,String> _poif000Map = new HashMap<String,String>();
		String _ifPodtCnt = "0";
		String _ifPodtCnt2 = "0";
		try {
			if (formData.get("STATUS").equals("S")) {
				_poif000Map.put("IF_FLAG", "Y");
			} else {
				_ifPodtCnt = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnIcomprdtCnt", formData);
				
				if (Integer.parseInt(_ifPodtCnt) == 0) {
					if (formData.get("STATUS").equals("D")) {
						_poif000Map.put("ERROR_MSG", "삭제대상없음");
					} else {
						_poif000Map.put("STATUS", "C");
					}
				} else {
					_ifPodtCnt2 = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnIcomprdtCnt2", formData);
					if (Integer.parseInt(_ifPodtCnt2) == 1) {
						_poif000Map.put("STATUS", "S");
						_poif000Map.put("IF_FLAG", "Y");
					} else {
						_poif000Map.put("STATUS", "R");
					}
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_000 체크에 실패하였습니다.");
		}

		return _poif000Map;
	}
	
	public Map<String, String> POIF_DATA_Check_001(Map<String, String>  formData) {
		Map<String,String> _poif001Map = new HashMap<String,String>();
		Map<String,String> _temp001Map = new HashMap<String,String>();
		try {
			_temp001Map = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnBycaComorg", formData);
			
			_poif001Map.put("BYIT_COMORG_CODE", _temp001Map.get("BYCA_COMORG_CODE"));
			
			if (Integer.parseInt(String.valueOf(_temp001Map.get("CNT"))) != 1) {
				_poif001Map.put("ERROR_MSG", "조직코드 에러");
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_001 체크에 실패하였습니다.");
		}
		
		return _poif001Map;
	}
	
	public Map<String, String> POIF_DATA_Check_002(Map<String, String>  formData) {
		Map<String,String> _poif002Map = new HashMap<String,String>();

		try {
			if (!formData.get("STATUS").equals("D") && !formData.get("STATUS").equals("S")) {
				Map<String, String> _temp002Map = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnPurchaserUserId", formData);
				
				if (_temp002Map != null) {
					_poif002Map.put("PURCHASER_USER_ID", _temp002Map.get("USER_ID"));
					_poif002Map.put("PURCHASER_USER_DEPT", _temp002Map.get("DEPARTMENT"));
					
					_poif002Map.putAll(POIF_DATA_Check_003(formData));
				} else {
					_poif002Map.put("ERROR_MSG", "발주자 미등록");
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_002 체크에 실패하였습니다.");
		}
		return _poif002Map;
	}

	public Map<String, String> POIF_DATA_Check_003(Map<String, String>  formData) {
		Map<String,String> _poif003Map = new HashMap<String,String>();
		Map<String, String> _result = null;
		Map<String, String> _result2 = null;
		Map<String, String> _result3 = null;

		
		String unitPrice = "0";
		try {
			if (!formData.get("STATUS").equals("D") && !formData.get("STATUS").equals("R")) {
				_result = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnKepbyit", formData);
				
				if (_result == null) {
					_poif003Map.put("ERROR_MSG", "품목코드 미등록");
				} else {
					if (_result.get("PRODUCT_CLOSE_FLAG").equals("N")) {
						_poif003Map.put("ERROR_MSG", "품목코드 단종");
					}
				}
				
				if (formData.get("PO_AGENT").equals("")) {
					_result2 = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnKepbyit2", formData);
					
					_poif003Map.put("PO_AGENT", _result2.get("AGENT"));
					_poif003Map.put("CONTRACT_NO",_result2.get("CONTRACT_NO"));
					_poif003Map.put("CONTRACT_SEQ", _result2.get("CONTRACT_SEQ"));
				} else {
					if (("KRDAEW0016").equals(formData.get("BUYER"))) {
						_result3 = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnUnitPrice", formData);
						
						if (_result3 != null) {
							unitPrice = String.valueOf(_result3.get("UNIT_PRICE"));
						}
					} else {
						_result3 = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnUnitPrice2", formData);
						
						if (_result3 != null) {
							unitPrice = String.valueOf(_result3.get("UNIT_PRICE"));
							_poif003Map.put("CONTRACT_NO", _result3.get("CONTRACT_NO"));
							_poif003Map.put("CONTRACT_SEQ", _result3.get("CONTRACT_SEQ"));
						}
						
						if (!formData.get("DOC_TYPE").equals("S")) {
							if (_result3 == null) {
								_poif003Map.put("ERROR_MSG", "해당 공급업체 없음");
							} else {
								if (!formData.get("UNIT_PRICE").equals(unitPrice)) {
									_poif003Map.put("ERROR_MSG", "판매단가 불일치");
			                    }
							}
						}
					}
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_003 체크에 실패하였습니다.");
		}
		return _poif003Map;
	}
	
	public Map<String, String> POIF_DATA_Check_004(Map<String, String>  formData) {
		Map<String,String> _poif004Map = new HashMap<String,String>();
		try {
			if (!formData.get("STATUS").equals("D") && !formData.get("STATUS").equals("S")) {
					String _result = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnDelyToLocation", formData);
				
				if (Integer.parseInt(_result) == 0) {
					_poif004Map.put("ERROR_MSG", "도착지코드 미등록");
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_004 체크에 실패하였습니다.");
		}
		return _poif004Map;
	}
	
	public Map<String, String> POIF_DATA_Check_005(Map<String, String>  formData) {
		Map<String,String> _poif005Map = new HashMap<String,String>();
		try {
			if (!formData.get("STATUS").equals("S")) {
				String _result = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnIcompodtCnt", formData);
				
				if (Integer.parseInt(_result) != 0) {
					_poif005Map.put("ERROR_MSG", "수주접수 완료(수정불가)");
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_005 체크에 실패하였습니다.");
		}
		return _poif005Map;
	}
	
	public Map<String, String> POIF_DATA_Check_006(Map<String, String>  formData) {
		Map<String,String> _poif006Map = new HashMap<String,String>();
		try {
			if (formData.get("STATUS").equals("D") || formData.get("STATUS").equals("R")) {
				String _result = sqlSessionTemplate.selectOne("master.mpif.getMasterMpIfOrderQuantityDivsnIcomprdtCnt3", formData);
				
				if (Integer.parseInt(_result) != 0) {
					_poif006Map.put("ERROR_MSG", "아이피스 변경 불가");
				}
				
				if (formData.get("DOC_TYPE").equals("S")) {
					_poif006Map.put("ERROR_MSG", "선입고 변경 불가");
				}
			}
		} catch (Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("POIF_DATA_Check_005 체크에 실패하였습니다.");
		}
		return _poif006Map;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		Map<String, String> lastLoginList = null;
		
		_rtnMsg = "삭제가 정상적으로 이루어 졌습니다.";
		
		try {
			for (int i=0; i < gridData.size(); i++) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				lastLoginList = sqlSessionTemplate.selectOne("master.mpif.selectLastLoginIdWithIfInfo", formData);
				
				// 주문요청자, 발주자 마지막 로그인정보 UPDATE
				formData.put("LAST_LOGIN_ID", CommonUtil.nvl(lastLoginList.get("REQ_USER_ID"), ""));
				formData.put("LAST_LOGIN_ID1",CommonUtil.nvl(lastLoginList.get("PURCHASER_USER_ID"), ""));
				
				// 주문요청자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime", formData);
		        
		        // 발주자 마지막 로그인 정보 UPDATE
		        sqlSessionTemplate.insert("login.saveLogintime1", formData);
		        
				sqlSessionTemplate.update("master.mpif.deleteMasterMpIfOrderQuantityDivsn", formData);
			}
		} catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("삭제가 실패 하였습니다.\\n\\n운영자에게 문의하시기 바랍니다.");
		}

		return _rtnMsg;		
		
	}	

}
