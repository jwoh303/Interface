/**
 * 
 */
package com.koreab2b.skpc.dao;

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
@Repository("skPcDao")
@Transactional
@SuppressWarnings("unchecked")
public class SkPcDaoImpl implements SkPcDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SkPcDaoImpl.class);//	
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	public SkPcDaoImpl() {
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
			LOGGER.error("####### SkPcDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	
	public String updateSkPcRe(Map<String, Object> poData) throws Exception {	
		Map<String, Object> reBody = new HashMap<String, Object>();
		String _rtnMsg = "정상적으로 견적 정보를 등록하였습니다.";
		String[] chkLst = {"QUOTATION_NO","QUOTATION_SEQ","BUYER_ITEM_NO"}; 
		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poData.get("RE_ITEM");
			
			if(itemLst.size() < 1) {
				_rtnMsg = "견적 정보가 존재하지 않습니다.";
			}else{				
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {					
					for(Map<String,Object> item : itemLst) {
						reBody.put("re_item", item);
						this.sqlMapper.update("insertSkPcRe", reBody);
					}	
					LOGGER.info("####### SkPcDaoImpl 견적 데이터 저장완료 : ");
				}else {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}
			}
		}catch(Exception e){
			_rtnMsg = "견적 등록에 실패하였습니다.";
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}
	
	public String insertSkPcPo(Map<String, Object> poData) throws Exception {		
		 
		Map<String, Object> poBody = new HashMap<String, Object>();
		String _rtnMsg = "정상적으로 발주 정보를 등록하였습니다.";
		String[] chkLst = {"LEGACY_PO_NO","LEGACY_PO_SEQ","REF_IF_NO"}; 
		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poData.get("PO_ITEM");
			if(itemLst.size() < 1) {
				_rtnMsg = "발주 아이템 정보가 존재하지 않습니다.";
			}else{				
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
//					poBody.put("po_header", poData.get("po_header"));
					for(Map<String,Object> item : itemLst) {
						poBody.put("po_item", item);
						this.sqlMapper.insert("insertSkPcPo", poBody);
					}	
					LOGGER.info("####### SkPcDaoImpl 발주 데이터 저장완료 : ");
				}else {
					_rtnMsg = "필수 값이 존재하지 않습니다.";
				}
			}
		}catch(Exception e){
			_rtnMsg = "발주 등록에 실패하였습니다.";
			LOGGER.info("####### catch error : "+ e.getMessage());
			throw new Exception(e);
		}finally {
			return _rtnMsg;
		}		
	}

	public String insertSkPcGr(Map<String, Object> grData) throws Exception {
		 
		Map<String, Object> grBody = new HashMap<String, Object>();
		String _rtnMsg = "정상적으로 입고 정보를 등록하였습니다.";
		String[] chkLst = {"LEGACY_PO_NO","LEGACY_PO_SEQ","LEGACY_GR_NO","LEGACY_GR_SEQ"};
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) grData.get("GR_ITEM");
			if(itemLst.size() < 1) {
				_rtnMsg = "입고 아이템 정보가 존재하지 않습니다.";
			}else{
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
//					grBody.put("gr_header", grData.get("gr_header"));
					for(Map<String,Object> item : itemLst) {
						grBody.put("gr_item", item);
						LOGGER.info("####### SkPcDaoImpl 입고 데이터 저장완료 : ");	
						this.sqlMapper.insert("insertSkPcGr", grBody);
					}			
					LOGGER.info("####### SkPcDaoImpl 입고 데이터 저장완료 : ");	
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
