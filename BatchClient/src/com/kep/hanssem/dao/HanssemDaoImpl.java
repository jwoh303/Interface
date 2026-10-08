/**
 * 
 */
package com.kep.hanssem.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

/**
 * @author jiwon
 *
 */
public class HanssemDaoImpl implements HanssemDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HanssemDaoImpl() {
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
			log.error("####### HanssemDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemToken(Map<String,Object> target) throws Exception {
		return this.sqlMapper.queryForList("selectHanssemToken", target);
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemAvailBdgtParam() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemAvailBdgtParam");
	}
	
	@Override
	public void insertHanssemAvailBdgt(Map<String,Object> availBdgtItem) throws Exception {		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) availBdgtItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemAvailBdgt 예산가용성 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {
					this.sqlMapper.insert("insertHanssemAvailBdgt", item);
				}	
				log.info("####### insertHanssemAvailBdgt 예산가용성 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemBdgtParam() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemBdgtParam");
	}
	
	@Override
	public void insertHanssemBdgt(Map<String, Object> bdgtItem) throws Exception {
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) bdgtItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemBdgt 예산 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {
					this.sqlMapper.insert("insertHanssemBdgt", item);
				}	
				log.info("####### insertHanssemBdgt 예산 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void updateHanssemArSend(Map<String, Object> result) throws Exception {
		this.sqlMapper.update("updateHanssemArSend", result);
	}

	@Override
	public List<Map<String, Object>> selectHanssemCcParam() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemCcParam");
	}
	
	@Override
	public void insertHanssemCostCenter(Map<String, Object> cstCntrItem) throws Exception {
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) cstCntrItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemCostCenter 코스트센터 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {										
					this.sqlMapper.insert("insertHanssemCostCenter", item);
				}	
				log.info("####### insertHanssemCostCenter 코스트센터 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void insertHanssemGLAccount(Map<String, Object> glAccntItem) throws Exception {
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) glAccntItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemGLAccount G/L 계정 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {
					this.sqlMapper.insert("insertHanssemGLAccount", item);
				}	
				log.info("####### insertHanssemGLAccount G/L 계정 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void updateHanssemGrSend(Map<String, Object> result) throws Exception {
		this.sqlMapper.update("updateHanssemGrSend", result);
	}

	@Override
	public void insertHanssemPoList(Map<String, Object> poLstItem) throws Exception {
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poLstItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemPoList 주문내역대사 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {					
					this.sqlMapper.insert("insertHanssemPoList", item);
				}	
				log.info("####### insertHanssemPoList 주문내역대사 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void updateHanssemPoSend(Map<String, Object> poItem) throws Exception {		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) poItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### updateHanssemPoSend 주문 데이터 없음. ");
				poItem.put("isItem", false);
				this.sqlMapper.update("updateHanssemPoSend", poItem);
			}else{
				for(Map<String,Object> item : itemLst) {
					item.put("isItem", true);
					this.sqlMapper.update("updateHanssemPoSend", item);
				}	
				log.info("####### updateHanssemPoSend 주문 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void insertHanssemUser(Map<String, Object> userItem) throws Exception {
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) userItem.get("ET_TAB");
			if(itemLst.size() < 1) {
				log.info("####### insertHanssemUser 회원정보 계정 데이터 없음. ");
			}else{
				for(Map<String,Object> item : itemLst) {
					this.sqlMapper.insert("insertHanssemUser", item);
				}	
				log.info("####### insertHanssemUser 회원정보 계정 데이터 저장 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public List<Map<String, Object>> selectHanssemTrxlPol() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemTrxlPol");
	}

	@Override
	public void updateHanssemTrxlPol(Map<String, Object> result) throws Exception {
		this.sqlMapper.update("updateHanssemTrxlPol", result);
	}

	@Override
	public List<Map<String, Object>> selectHanssemArSend() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemArSend");
	}

	@Override
	public List<Map<String, Object>> selectHanssemPoSend() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemPoSend");
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemPoDate(Map<String, Object> poData) throws Exception {
		return this.sqlMapper.queryForList("selectHanssemPoDate", poData);
	}

	@Override
	public List<Map<String, Object>> selectHanssemGrSend() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemGrSend");
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemGrDate() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemGrDate");
	}
	
	@Override
	public List<Map<String, Object>> selectHanssemArDate() throws Exception {
		return this.sqlMapper.queryForList("selectHanssemArDate");
	}

	@Override
	public void updateHanssemTrxlAvailBdgt(Map<String, Object> result) throws Exception {		
		try{
			List<Map<String, Object>> itemLst = (List<Map<String, Object>>) result.get("TRXL");			
			if(itemLst.size() < 1) {
				if("E".equals(result.get("IFRESULT"))) {
					result.put("ERR", true);
					result.put("TARGET", "KRHANS0308");
					this.sqlMapper.update("updateHanssemTrxlAvailBdgt", result);
				}
				log.info("####### updateHanssemTrxlAvailBdgt TRXL 데이터 없음. ");
				
			}else{
				for(Map<String,Object> item : itemLst) {
					item.put("IFRESULT", result.get("IFRESULT"));
					item.put("IFMSG", result.get("IFMSG"));
					item.put("ERR", false);
					this.sqlMapper.update("updateHanssemTrxlAvailBdgt", item);
				}	
				log.info("####### updateHanssemTrxlAvailBdgt TRXL 업데이트 완료. ");			
			}
		}catch(Exception e){
			throw new Exception(e);
		}
	}

	@Override
	public void execHanssemAvailBdgtProc() throws Exception {
		try {
			this.sqlMapper.update("execHanssemAvailBdgtProc");
		} catch (Exception e) {
			log.error(this.getClass().getName() + "execHanssemAvailBdgtProc Error : " + e.getMessage());
		}
	}

	@Override
	public void insertHanssemDtoA() throws Exception {
		this.sqlMapper.insert("insertHanssemDtoA");
	}

	@Override
	public void insertHanssemDtoD() throws Exception {
		this.sqlMapper.insert("insertHanssemDtoD");
	}

	@Override
	public void execHanssemUserProc() throws Exception {
		try {
			this.sqlMapper.update("execHanssemUserProc");
		} catch (Exception e) {
			log.error(this.getClass().getName() + "execHanssemUserProc Error : " + e.getMessage());
		}
	}
}
