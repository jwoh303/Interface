/**
 * 
 */
package com.koreab2b.skmw.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;

/**
 * @author jiwon
 *
 */
@Repository("skMwDao")
@Transactional
@SuppressWarnings("unchecked")
public class SkMwDaoImpl implements SkMwDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SkMwDaoImpl.class);//	
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	public SkMwDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error("####### SkMwDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	
	public String updateSkMwItem(Map<String, Object> poData) throws Exception {		
		String _rtnMsg = "정상적으로 품목 정보를 등록하였습니다.";
		String[] chkLst = {"if_plant_cd","item_cd","sap_item_cd"}; 
		List<Map<String, Object>> itemLst = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> byitTmp = new ArrayList<Map<String,Object>>();
		Map<String, Object> byit = new HashMap<String,Object>();
		List<Map<String, Object>> confirmTmp = new ArrayList<Map<String,Object>>();
		Map<String, Object> newItem = new HashMap<String, Object>();
		
		try{
			newItem = (Map<String, Object>) poData.get("newitem_reg");
			itemLst.add(newItem);
			
			if(itemLst.size() < 1) {
				_rtnMsg = "품목 정보가 존재하지 않습니다.";
			}else{				
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
					byitTmp = this.sqlMapper.queryForList("selectSkMwItemSend", newItem);		
					byit = byitTmp.get(0); 
					newItem.put("req_div", byit.get("REQ_DIV"));
//					confirmTmp = this.sqlMapper.queryForList("selectSkMwItemSendConfirm", newItem);
//					LOGGER.info("@@@@ confirmTmp : " + confirmTmp.toString());
					if(byitTmp.size() < 1){
						_rtnMsg = "확인되지 않는 품목코드입니다.";					
					}else {
						if(byit.get("REQ_DIV").equals("E")){
							_rtnMsg = "품목코드 확장이 완료되었습니다.";						
							this.sqlMapper.update("updateSkMwItemSend", newItem);
						}else if(byit.get("REQ_DIV").equals("U")){
							_rtnMsg = "품목정보 수정이 완료되었습니다.";						
							this.sqlMapper.update("updateSkMwItemSend", newItem);							
						}else {
							newItem.put("buyer", byit.get("BUYER"));
							newItem.put("below_comorg_code", byit.get("BELOW_COMORG_CODE"));
							newItem.put("quotation_no", byit.get("QUOTATION_NO"));
							newItem.put("quotation_seq", byit.get("QUOTATION_SEQ"));						
							newItem.put("result_flag", "Y");
							newItem.put("result_msg", " ");
							this.sqlMapper.update("updateSkMwItemSend", newItem);
							LOGGER.info("### ItemSend 등록완료.");
							if(!"RE25A00001".equals(byit.get("QUOTATION_NO"))) {								
								this.sqlMapper.update("insertSkMwCod4", newItem);
								LOGGER.info("### Icomcod4 등록완료.");
								//여기로 다시 내리기 
								this.sqlMapper.update("updateSkMwCqdt", newItem);
								LOGGER.info("### Cqdt 등록완료.");
								this.sqlMapper.update("updateSkMwByit", newItem);
								LOGGER.info("### Byit 등록완료.");
								if("X".equals(byit.get("QUOTATION_NO"))) {
									this.sqlMapper.update("updateSkMwCqep", newItem);
									LOGGER.info("### Cqep 수정완료.");								
								}else {
									this.sqlMapper.update("updateSkMwRqdt", newItem);
									LOGGER.info("### Rqdt 등록완료.");
									this.sqlMapper.update("updateSkMwQtdt", newItem);
									LOGGER.info("### Qtdt 등록완료.");
									this.sqlMapper.insert("insertSkMwCqep", newItem);
									LOGGER.info("### Cqep 등록완료.");
								}
							}
							this.sqlMapper.update("updateSkMwItemSendConfirm", newItem);
							LOGGER.info("### Confirm 등록완료.");
							
							LOGGER.info("####### SkMwDaoImpl 품목 데이터 저장완료 : ");
						}
					}
				}else {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}
			}
		}catch(Exception e){
			_rtnMsg = "품목 등록에 실패하였습니다.";
			newItem.put("result_flag", 'E');
			newItem.put("result_msg", e.getMessage());
			this.sqlMapper.update("updateSkMwItemSendConfirm", newItem);
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}
	
	public String insertSkMwPo(Map<String, Object> poData) throws Exception {		
		 
		Map<String, Object> poBody = new HashMap<String, Object>();
		String _rtnMsg = "정상적으로 발주 정보를 등록하였습니다.";
		String[] chkLst = {"if_po_no","if_po_lno"}; 
		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poData.get("po_items");
			if(itemLst.size() < 1) {
				_rtnMsg = "발주 아이템 정보가 존재하지 않습니다.";
			}else{				
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
					poBody.put("po_header", poData.get("po_header"));
					for(Map<String,Object> item : itemLst) {
						poBody.put("po_item", item);
						this.sqlMapper.insert("insertSkMwPo", poBody);
					}	
					LOGGER.info("####### SkMwDaoImpl 발주 데이터 저장완료 : ");
				}else {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}
			}
		}catch(Exception e){
			_rtnMsg = "발주 등록에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}

	public String insertSkMwGr(Map<String, Object> grData) throws Exception {
		 
		Map<String, Object> grBody = new HashMap<String, Object>();
		String _rtnMsg = "정상적으로 입고 정보를 등록하였습니다.";
		String[] chkLst = {"if_gr_no","if_gr_lno"};
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) grData.get("gr_items");
			if(itemLst.size() < 1) {
				_rtnMsg = "입고 아이템 정보가 존재하지 않습니다.";
			}else{
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
					grBody.put("gr_header", grData.get("gr_header"));
					for(Map<String,Object> item : itemLst) {
						grBody.put("gr_item", item);
						LOGGER.info("####### SkMwDaoImpl 입고 데이터 저장완료 : ");	
						this.sqlMapper.insert("insertSkMwGr", grBody);
					}			
					LOGGER.info("####### SkMwDaoImpl 입고 데이터 저장완료 : ");	
				}else {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}				
			}
		}catch(Exception e){
			_rtnMsg = "입고 등록에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}

}
