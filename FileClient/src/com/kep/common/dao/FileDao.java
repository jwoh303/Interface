package com.kep.common.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.vo.GrdtUCVo;
import com.kep.common.vo.IvdtUCVo;
import com.kep.common.vo.PodtUCVo;
import com.kep.common.vo.PodtVo;
import com.kep.common.vo.RedtUCVo;

@SuppressWarnings("unchecked")
public class FileDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public FileDao() {
		try {	
			String source	= "";
			
			String dbConn = "";	// 2:운영, 0:개발
			String dbType = CommonProperty.getDB_TYPE();	// KEPMP, KEPCON

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				dbConn = "Live";
			} else {
				dbConn = "Dev";
			}
			
			source = "conf/SqlMapConfig_"+dbType+"_"+dbConn+".xml";
			// EX) conf/SqlMapConfig_KEPMP_Live.xml, conf/SqlMapConfig_KEPCON_Dev.xml
			
			log.debug("Source Info : " + source);
			System.out.println("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public List<Map<String, String>> selectWorkHdList() throws SQLException {
		return this.sqlMapper.queryForList("selectWorkHdList");
	}
	
	public List<Map<String, String>> selectWorkDtList(Map<String, String> pMap) throws SQLException {
		return this.sqlMapper.queryForList("selectWorkDtList", pMap);
	}
	
	public Map<String, String> selectWorkHdInfo(Map<String, String> pMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("selectWorkHdInfo", pMap);
	}

	public void insertPodtUC(PodtUCVo vo) throws SQLException {
		this.sqlMapper.insert("insertPodtUc", vo);
	}

	public void insertGrdtUC(GrdtUCVo vo) throws SQLException {
		this.sqlMapper.insert("insertGrdtUc", vo);
	}
	
	public void insertIvdtUC(IvdtUCVo vo) throws SQLException {
		this.sqlMapper.insert("insertIvdtUc", vo);
	}
	
	public void insertRedtUC(RedtUCVo vo) throws SQLException {
		this.sqlMapper.insert("insertRedtUc", vo);
	}	
	public Map<String, String> YHKB_getBuyerItemNo(Map<String, String> pMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("YHKB_getBuyerItemNo", pMap);
	}
}