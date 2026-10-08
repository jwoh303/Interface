package com.koreab2b.ltal.dao;

import java.io.Reader;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.ltal.vo.GoodsReceiveVO;
import com.koreab2b.ltal.vo.ReturnVO;

public class WsLtalSetGRInfo_DaoImpl implements WsLtalSetGRInfo_Dao {
	
	private Logger log	= Logger.getLogger(this.getClass().getName());
	private SqlMapClient sqlMapper;
	
	public WsLtalSetGRInfo_DaoImpl() {
		try {
			Reader reader = Resources.getResourceAsReader("conf/SqlMapConfig.xml");
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public ReturnVO setGrInfo(GoodsReceiveVO[] goodsReceiveVOList) throws Exception{
		ReturnVO ret = new ReturnVO();
		
		try {
			this.sqlMapper.startTransaction();
			
			for(int i=0;i<goodsReceiveVOList.length;i++){
				
				sqlMapper.insert("setGoodsReceive",goodsReceiveVOList[i]);
				
			}
			ret.setResult("Y");
			this.sqlMapper.commitTransaction();
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			ret.setResult("E");
		} finally {
			this.sqlMapper.endTransaction();
		}
		
		return ret;
	}
}