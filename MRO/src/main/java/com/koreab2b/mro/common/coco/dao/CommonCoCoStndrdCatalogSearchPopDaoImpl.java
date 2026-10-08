package com.koreab2b.mro.common.coco.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("commonCoCoStndrdCatalogSearchPopDao")
public class CommonCoCoStndrdCatalogSearchPopDaoImpl  implements CommonCoCoStndrdCatalogSearchPopDao {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoStndrdCatalogSearchPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

}
