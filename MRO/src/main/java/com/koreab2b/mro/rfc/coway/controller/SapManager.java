package com.koreab2b.mro.rfc.coway.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Properties;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

/**
 * SAP RFC 유틸
 * @author		박용서
 * @since		2018. 2. 20.
 * @see			https://gs.saro.me/dev?tn=562
 */
public class SapManager {
	
	static String CONN_FILE_NAME = "SAP"; 
	
	// newSapManagerBinder 통해 부르세요.
	public SapManager() {
	}
	
	public SapManager(String destName) {
		this.CONN_FILE_NAME = destName;
		System.out.println("CONN_FILE_NAME : " + this.CONN_FILE_NAME);
	}
	
	/** 연결을 시도합니다. 
	 * @throws JCoException */
	public SapRfcFunction getRfcFunction(String rfcFunctionName) throws JCoException {
		return new SapRfcFunction(CONN_FILE_NAME, rfcFunctionName);
	}
	
	/**
	 * 함수를 선언합니다.
	 * @author		박용서
	 * @since		2018. 2. 20.
	 */
	public class SapRfcFunction {
		
		public SimpleDateFormat ymdhms = new SimpleDateFormat("yyyyMMddHHmmss");
		public JCoFunction function;
		public JCoDestination destination;
		public String functionName;
		JCoParameterList tables;
		JCoParameterList imports;
		JCoParameterList exports;
		
		long startTime = 0L;
		
		// 생성
		private SapRfcFunction(String connectionFileName, String rfcFunctionName) throws JCoException {
			this.functionName = rfcFunctionName;

			String path = "../../../../../../../usr/local/tomcat8.5.57/";
			System.out.println(path + connectionFileName);
			
			destination = JCoDestinationManager.getDestination(path + connectionFileName);
			function = destination.getRepository().getFunction(rfcFunctionName);
		}
		
		/**
		 * import 값을 입력합니다.<br>
		 * execute() 이전에 불려야 합니다.
		 * @return JCoParameterList
		 */
		public JCoParameterList imports() {
			if (imports == null) {
				imports = function.getImportParameterList();
			}
			return imports;
		}
		
		/**
		 * import 할 테이블을 가져옵니다.
		 * @param tableName
		 * @return
		 */
		public JCoTable importTable(String tableName) {
			return function.getTableParameterList().getTable(tableName);
		}
		
		/**
		 * export 값을 출력합니다.<br>
		 * execute() 이후 불려야합니다.
		 * @return JCoParameterList
		 */
		public JCoParameterList exports() {
			if (exports == null) {
				exports = function.getExportParameterList();
			}
			return exports;
		}
		
		/**
		 * 실행
		 * @throws JCoException
		 */
		public void execute() throws JCoException {
			function.execute(destination);
		}
		
		/**
		 * 테이블 갯수를 가져옵니다.<br>
		 * execute() 이후에 불려야합니다.
		 * @return
		 */
		public int getTableCount() {
			if (tables == null) {
				tables = function.getTableParameterList();
			}
			return tables.getFieldCount();
		}
	}
	
	/** 연결을 시도합니다. */
	public SapManagerBinder newSapManagerBinder() {
		return new SapManagerBinder(new Properties());
	}

	/**
	 * 커넥터 연결
	 * @author		박용서
	 * @since		2018. 2. 20.
	 */
	public class SapManagerBinder {
		
		// 환경
		Properties properties;
		
		// 내부함수
		SapManagerBinder(Properties properties) {
			this.properties = properties;
		}
		
		public SapManager bind() throws JCoException, IOException {
			return bind(false);
		}
		
		/** 바인드 */
		public SapManager bind(boolean force) throws JCoException, IOException {
			
			String path = "../../../../../../../usr/local/tomcat8.5.57/";
			System.out.println("Path : " + path);
			
			File connectionFile = new File(path + CONN_FILE_NAME+".jcoDestination");
			if (force && connectionFile.exists()) {
				System.out.println( "CONN_FILE exists. ");
				connectionFile.delete();
			}
			if (!connectionFile.exists()) {
				System.out.println( "CONN_FILE create. ");
				FileOutputStream fos = new FileOutputStream(connectionFile, false);
				properties.store(fos, "make connection file");
				fos.close();
			}
			return new SapManager();
		}
		
		/** 값 세팅 */
		public SapManagerBinder set(String key, String value) {
			System.out.println(key + " / " + value);
			properties.setProperty(key, value);
			return this;
		}
	}
	
	/**
	 * 처음 생성된 Column을 보여주는 뷰입니다.
	 * @author		박용서
	 * @since		2018. 2. 20.
	 */
	public interface ColumnDefiner<CDO> {
		CDO call(String[] rows) throws Exception;
	}
	
	/**
	 * 행 매핑
	 * @author		박용서
	 * @since		2018. 2. 20.
	 */
	public interface RowMapper<CDO, RC> {
		RC call(CDO columnDefiner, String[] rows, Object[] values) throws Exception;
	}
	
	private String underscoreToCamelcase(String camelcase) {
		if (camelcase == null) {
			return null;
		}
		boolean flag = false;
		char[] under = camelcase.toCharArray();
		char[] camel = new char[under.length];
		int pos = 0;
		
		for (char c : under) {
			if (c == '_') {
				flag = true;
			} else {
				camel[pos++] = flag ? Character.toUpperCase(c) : Character.toLowerCase(c);
				flag = false;
			}
		}
		
		return new String(camel, 0 , pos);
	}
}