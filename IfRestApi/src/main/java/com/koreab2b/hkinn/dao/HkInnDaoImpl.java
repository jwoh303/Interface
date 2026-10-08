/**
 * 
 */
package com.koreab2b.hkinn.dao;

import java.io.Reader;
import java.util.ArrayList;
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
@Repository("hkInnDao")
@Transactional
public class HkInnDaoImpl implements HkInnDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(HkInnDaoImpl.class);//	
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";
	
	public HkInnDaoImpl() {
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
			LOGGER.error("####### HkInnDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public String insertHkInnPoData(Map<String, Object> poData) throws Exception {		
		 
		String _rtnMsg = null;
		String[] chkLst = {"LEGACY_PO_NO","LEGACY_PO_SEQ"}; 
		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poData.get("PO_ITEM");
			if(itemLst.size() < 1) {
				_rtnMsg = "발주 정보가 존재하지 않습니다.";
			}else{				
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
					for(Map<String,Object> item : itemLst) {
						this.sqlMapper.insert("insertHkInnPoData", item);
					}	
					LOGGER.info("####### HkInnDaoImpl 발주 데이터 저장완료 : ");
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

	public String insertHkInnGrData(Map<String, Object> grData) throws Exception {
		 
		String _rtnMsg = null;
		String[] chkLst = {"LEGACY_PO_NO","LEGACY_PO_SEQ"}; 
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) grData.get("GR_ITEM");
			if(itemLst.size() < 1) {
				_rtnMsg = "입고 정보가 존재하지 않습니다.";
			}else{
				boolean isChk = CommonUtil.chkNull(chkLst, itemLst);
				if(isChk) {
					for(Map<String,Object> item : itemLst) {
						this.sqlMapper.insert("insertHkInnGrData", item);
					}			
					LOGGER.info("####### HkInnDaoImpl 입고 데이터 저장완료 : ");	
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

	public List<Map<String, Object>> selectBrandLst() throws Exception {
		return this.sqlMapper.queryForList("selectBrandLst");
	}

}
