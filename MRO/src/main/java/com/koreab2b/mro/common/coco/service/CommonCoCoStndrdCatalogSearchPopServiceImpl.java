package com.koreab2b.mro.common.coco.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonCoCoStndrdCatalogSearchPopDao;

@Service("commonCoCoStndrdCatalogSearchPopService")
public class CommonCoCoStndrdCatalogSearchPopServiceImpl   implements CommonCoCoStndrdCatalogSearchPopService {
	@Autowired
	private CommonCoCoStndrdCatalogSearchPopDao commonCoCoStndrdCatalogSearchPopDao;

}
