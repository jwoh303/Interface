/**
 * 
 */
package com.kep.amorepacific.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

/**
 * @author jiwon
 *
 */
public class AmorepacificDaoImpl implements AmorepacificDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public AmorepacificDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			//테스트 고정
			//source	= "conf/SqlMapConfig_Dev.xml";
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("####### AmorepacificDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, String>> selectAmorepacificCheckParam() throws Exception {
		return this.sqlMapper.queryForList("selectAmorepacificCheckParam");
	}
	
	@Override
	public List<Map<String, String>> selectAmorepacificPrList() throws Exception {
		return this.sqlMapper.queryForList("selectAmorepacificPrList");
	}
	
	@Override
	public List<Map<String, String>> selectAmorepacificOrderParam(Map<String,String> pr) throws Exception {
		return this.sqlMapper.queryForList("selectAmorepacificOrderParam", pr);
	}


	@Override
	public void updateAmorepacificOrderParam(List<Map<String, String>> reqTmp, Map<String, Object> result) throws Exception {
		try{
			for(Map<String,String> item : reqTmp) {
				item.put("IFRESULT", (String) result.get("IFRESULT"));
				item.put("RESULT_MSG", (String) result.get("PE_CHKYN"));
				this.sqlMapper.update("updateAmorepacificOrderParam", item);
			}			
		}catch(Exception e){
			throw new Exception(e);
		}	
	}

	@Override
	public void insertAmorepacificOrderProgress(List<Map<String,String>> reqTmp) throws Exception {
		Set<String> pxSet = new HashSet<>();		
		String px = "";
		List<Map<String,String>> chkPx = null;
		try{
			for(Map<String,String> item : reqTmp) {
				chkPx = new ArrayList<Map<String,String>>();
				chkPx = this.sqlMapper.queryForList("selectAmorepacificCheckPx", item);
				if(chkPx.size() < 1) {					
					px = item.get("PX_NO");
					if(!"D".equals(item.get("GUBUN"))) {
						if(!pxSet.contains(px)) {
							this.sqlMapper.insert("insertAmorepacificOrderProgress", item);
							pxSet.add(px);
						}
					}else {
						if(!pxSet.contains(px)) {
							pxSet.add(px);
						}
					}
				}
			}			
		}catch(Exception e){
			throw new Exception(e);
		}		
	}

	@Override
	public void updateAmorepacificOrderPrdt(List<Map<String, String>> reqTmp, Map<String, Object> result) throws Exception {
		try{
			for(Map<String,String> item : reqTmp) {
				item.put("ERR_MSG", (String) result.get("PE_CHKYN"));
				this.sqlMapper.update("updateAmorepacificOrderPrdt", item);
			}			
		}catch(Exception e){
			throw new Exception(e);
		}		
	}
	
	@Override
	public void updateAmorepacificError(Map<String, Object> result) throws Exception {
		this.sqlMapper.update("updateAmorepacificError", result);
	}


}
