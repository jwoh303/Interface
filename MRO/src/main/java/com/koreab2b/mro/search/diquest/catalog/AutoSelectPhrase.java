package com.koreab2b.mro.search.diquest.catalog;

import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.SelectSet;

public class AutoSelectPhrase {

	public SelectSet[] get() {
		SelectSet[] _selectSet = new SelectSet[] { 
				new SelectSet("DISPLAY", Protocol.SelectSet.NONE)
				
		};
		
		return _selectSet;
	}
}
