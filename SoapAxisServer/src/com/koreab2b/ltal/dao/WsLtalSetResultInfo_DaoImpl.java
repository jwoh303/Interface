package com.koreab2b.ltal.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonUtil;
import com.koreab2b.ltal.vo.ResultVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetResultInfo_DaoImpl implements WsLtalSetResultInfo_Dao {

	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalSetResultInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public ReturnVO setResultInfo(ResultVO[] resultVOList) throws Exception{
		ReturnVO ret = new ReturnVO();
		
		try {
			this.sqlMapper.startTransaction();
			
			for(int i=0;i<resultVOList.length;i++){
				sqlMapper.insert("setResultVO",resultVOList[i]);
			}
			
			this.sqlMapper.commitTransaction();
			
			ret.setResult("S");
		} catch (Exception e) {
			e.printStackTrace();
			log.error("WsLtalSetResultInfo_Dao " + CommonUtil.printStackTraceToString(e));
			ret.setResult("E");
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return ret;
	}
}
