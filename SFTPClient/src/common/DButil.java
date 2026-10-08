package common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

public class DButil {

	private Connection conn	= null;
	private String conStr;
	private String id;
	private String pw;
	
	private Logger log = null;
	
	private IFProperties prop = null;
	
	public DButil() {
		this.log	= Logger.getLogger(this.getClass());
		
		String propDir = "";
		
//		if ("2".equals(CommonProperty.getDB_CONN())) {
//			propDir = "./properties/dbcon.properties";
//		}
		
		this.prop = new IFProperties();
		log.debug("DB_CONN : "+CommonProperty.getDB_CONN());
		if(CommonProperty.getDB_CONN().equals("0")){ // 개발
			conStr	= prop.getProperty("dbdev.conStr");
			id		= prop.getProperty("dbdev.id");
			pw		= prop.getProperty("dbdev.pw");
		}else{										 // 운영
			conStr	= prop.getProperty("db.conStr");
			id		= prop.getProperty("db.id");
			pw		= prop.getProperty("db.pw");
		}
	}
	
	private void getDBConnection() {
	  
    	try {
    		if (this.conn == null || this.conn.isClosed() ) {
    			Class.forName("oracle.jdbc.driver.OracleDriver");
        		this.conn		= DriverManager.getConnection(conStr, id, pw);     
			}
		} catch (Exception e) {
			log.debug(e.getMessage());
			try {if(this.conn != null) {this.conn.close();} } catch (Exception e2) {}
		}
	}
	
	public String[] selectConnectionInfo(String buyer) {
    	
		String[] rtn	= null;
		
		PreparedStatement stmt	= null;
		ResultSet rs			= null;
		StringBuffer sql		= null;
		
		try {
			getDBConnection();
			sql	= new StringBuffer();
			
			sql.append("SELECT KEY_1,	\n");
			sql.append("       KEY_2,	\n");
			sql.append("       KEY_3	\n");
			sql.append("  FROM ICOMTRXL	\n");
			sql.append(" WHERE DOC_NAME = 'INTERFACE'	\n");
			sql.append("   AND TARGET = ?				\n");
			
			stmt	= this.conn.prepareStatement(sql.toString(), ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);

			stmt.setString(1, buyer);
			rs	= stmt.executeQuery();

			ResultSetMetaData metadata	=	rs.getMetaData();
			int colCnt = metadata.getColumnCount();
			
			rtn	= new String[colCnt];
			
			while(rs.next()){
				for(int i = 0 ; i < colCnt ; i++) {
					rtn[i]	= rs.getString(i+1);
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		} finally {
			try{ if(rs != null) rs.close(); } catch(Exception e2) {}
			try{ if(stmt != null) stmt.close(); } catch(Exception e2) {}
			try{ if(this.conn != null) this.conn.close(); } catch(Exception e2) {}
		}
		
		return rtn;
    }
	
	public String[][] selectConnectionInfo_sygp() {
    	
		String[][] rtn	= null;
		
		PreparedStatement stmt	= null;
		ResultSet rs			= null;
		StringBuffer sql		= null;

		try {
			getDBConnection();
			sql	= new StringBuffer();
	
			sql.append("SELECT TARGET,	\n");
			sql.append("       KEY_1,	\n");
			sql.append("       KEY_2,	\n");
			sql.append("       KEY_3	\n");
			sql.append("  FROM ICOMTRXL	\n");
			sql.append(" WHERE DOC_NAME = 'MSDS'	\n");
			sql.append("   AND KEY_9 IN ('1','9')	\n");
			sql.append("   AND TARGET IN (select text4 from icomcod2 where type = 'PLNT')		\n");
						
			stmt	= this.conn.prepareStatement(sql.toString(), ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
			rs	= stmt.executeQuery();

			rs.last();
			int rowCount = rs.getRow();
			rs.beforeFirst();
			
			rtn	= new String[rowCount][4];
			
			int i=0;
			
			while(rs.next()){			 	
					rtn[i][0]	= rs.getString("TARGET");
					rtn[i][1]	= rs.getString("KEY_1");
					rtn[i][2]	= rs.getString("KEY_2");
					rtn[i][3]	= rs.getString("KEY_3");
				i++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		} finally {
			try{ if(rs != null) rs.close(); } catch(Exception e2) {}
			try{ if(stmt != null) stmt.close(); } catch(Exception e2) {}
			try{ if(this.conn != null) this.conn.close(); } catch(Exception e2) {}
		}
		
		return rtn;
    }

	public ArrayList<String> selectInfo_sygp(String [][] connections, int i) {
		//수정필요
		ArrayList<String> rtnLst	= new ArrayList<String>();		
		PreparedStatement stmt	= null;
		ResultSet rs			= null;
		StringBuffer sql		= null;
		
		try {
			getDBConnection();
			sql	= new StringBuffer();
			
			sql.append("SELECT distinct(des_file_name)	\n");
			sql.append("  FROM keprqdt rqdt, kepmsdsdt msdt, icomatch atch	\n");
			sql.append(" WHERE rqdt.buyer  = ?	\n");
			sql.append("   AND rqdt.quotation_no = ?	\n");
			sql.append("   AND rqdt.quotation_seq= ?	\n");
			sql.append("   AND rqdt.revision     = ?	\n");
			sql.append("   AND rqdt.msds_no      = msdt.msds_no	\n");
			sql.append("   AND msdt.image_key    = atch.doc_no	\n");
			sql.append("   AND atch.type         = 'MSDS'	\n");
			
	    	stmt	= this.conn.prepareStatement(sql.toString(), ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	
			stmt.setString(1, connections[i][0]);
			stmt.setString(2, connections[i][1]);
			stmt.setString(3, connections[i][2]);
			stmt.setString(4, connections[i][3]);
			
			rs	= stmt.executeQuery();
	
			while(rs.next()){
				rtnLst.add(rs.getString("des_file_name"));
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
		} finally {
			try{ if(rs != null) rs.close(); } catch(Exception e2) {}
			try{ if(stmt != null) stmt.close(); } catch(Exception e2) {}
			try{ if(this.conn != null) this.conn.close(); } catch(Exception e2) {}
		}
		
		return rtnLst;
	}
		
	public void updateInfo_sygp(String [][] connections,int i, String check) {
		
		PreparedStatement stmt	= null;
		StringBuffer sql = null;
		
		
		
		try {
			getDBConnection();    		
			this.conn.setAutoCommit(false);
			
			sql	= new StringBuffer();
			sql.append(" UPDATE ICOMTRXL	\n");
			sql.append("    SET KEY_9 = CASE WHEN KEY_9 = '1' THEN ? ELSE 'Y' END 	\n");
			sql.append("      , KEY_10 = TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')	\n");
			sql.append("  WHERE DOC_NAME = 'MSDS'\n");
			sql.append("    AND TARGET = ?		\n");
			sql.append("    AND KEY_1 = ?		\n");
			sql.append("    AND KEY_2 = ?		\n");
			sql.append("    AND KEY_3 = ?		\n");
			sql.append("    AND KEY_9 IN ('1', '9')		\n");	// 9 : 파일만 재전송
			
			stmt	= this.conn.prepareStatement(sql.toString());
			stmt.setString(1, check);
			stmt.setString(2, connections[i][0]);
			stmt.setString(3, connections[i][1]);
			stmt.setString(4, connections[i][2]);
			stmt.setString(5, connections[i][3]);
					
			stmt.executeUpdate();
			
			this.conn.commit();
		} catch (Exception e) {
			
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {e2.printStackTrace();}
			
		} finally {
			
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
			
		}
	}

	public void updateConnectionInfo(int key_3, String target) {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" UPDATE ICOMTRXL	\n");
    		sql.append("    SET KEY_3 = ?	\n");
    		sql.append("      , KEY_4 = SYSDATE	\n");
    		sql.append("  WHERE DOC_NAME = 'INTERFACE'\n");
    		sql.append("    AND TARGET = ?		\n");

			stmt	= this.conn.prepareStatement(sql.toString());
			
			stmt.setInt(1, key_3);
			stmt.setString(2, target);
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {e2.printStackTrace();}
			
		} finally {
			
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
			
		}
    }
	
	public void updateLastUpdateDateInfo(String target) {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		log.debug("Target : " + target);
    		
    		sql	= new StringBuffer();
    		sql.append(" UPDATE EAI.IF_ERR_MNG	\n");
    		sql.append("    SET LAST_UPDATE_DATE = SYSDATE	\n");
    		sql.append("      , IF_STATUS = 'ON'	\n");
    		sql.append("  WHERE COM_CODE = ? \n");
    		sql.append("    AND TASK_GUBUN = 'ETC'		\n");
    		sql.append("    AND IF_TYPE = 'FTP-01-송신'		\n");
    		
			stmt	= this.conn.prepareStatement(sql.toString());

			stmt.setString(1, target);
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {e2.printStackTrace();}
			
		} finally {
			
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
			
		}
    }
	
	public void sendWarningEmail() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" INSERT INTO KEP_MAIL(	\n");
    		sql.append("         SEQ,			\n");
    		sql.append("         SEND_EMAIL,	\n");
    		sql.append("         SEND_NAME,		\n");
    		sql.append("         RECEIVE_EMAIL,	\n");
    		sql.append("         RECEIVE_NAME,	\n");
    		sql.append("         SUBJECT,		\n");
    		sql.append("         CONTENTS,		\n");
    		sql.append("         CREATE_DATE,	\n");
    		sql.append("         JOB_FLAG		\n");
    		sql.append(" )VALUES(				\n");
    		sql.append("         SEQ_KEP_MAIL.NEXTVAL,		\n");
    		sql.append("         'koreab2b@koreab2b.com',	\n");
    		sql.append("         '운영자',		\n");
    		sql.append("         'comanche@koreab2b.com;coolkim@koreab2b.com;jwoh@koreab2b.com;',	\n");
    		sql.append("         '김승우;김시원;오지원;',		\n");
    		sql.append("         '[KEP-미스미] 고객사향 MSMI 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',	\n");
    		sql.append("         '** [KEP-미스미] 고객사향 MSMI 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',					\n");
    		sql.append("         sysdate,		\n");
    		sql.append("         'N'			\n");
    		sql.append(" ) 						\n");

			stmt	= this.conn.prepareStatement(sql.toString());
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {
					e2.printStackTrace();
					log.debug(e2.getMessage());
					}
			
		} finally {
			
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
			
		}
    }
	
	public void sendWarningEmailForMSMS() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" INSERT INTO KEP_MAIL(	\n");
    		sql.append("         SEQ,			\n");
    		sql.append("         SEND_EMAIL,	\n");
    		sql.append("         SEND_NAME,		\n");
    		sql.append("         RECEIVE_EMAIL,	\n");
    		sql.append("         RECEIVE_NAME,	\n");
    		sql.append("         SUBJECT,		\n");
    		sql.append("         CONTENTS,		\n");
    		sql.append("         CREATE_DATE,	\n");
    		sql.append("         JOB_FLAG		\n");
    		sql.append(" )VALUES(				\n");
    		sql.append("         SEQ_KEP_MAIL.NEXTVAL,		\n");
    		sql.append("         'koreab2b@koreab2b.com',	\n");
    		sql.append("         '운영자',		\n");
    		sql.append("         'comanche@koreab2b.com;coolkim@koreab2b.com;jwoh@koreab2b.com;kr_network@misumi.co.kr;msm-KeP-troubleinform-kr@ml.misumi.co.jp;',	\n");
    		sql.append("         '김승우;김시원;오지원;김태우;미스미;',		\n");
    		sql.append("         '[KEP-MISUMI] IF SERVER Connection Error ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',	\n");
    		sql.append("         '<B>* [KEP-MISUMI SFTP Connection Error] ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')<br>* necessary to confirm and change server IP </B><br><br>[ 담당자 : 공민우 주임 / Tel.02-3016-8917 ]',					\n");
    		sql.append("         sysdate,		\n");
    		sql.append("         'N'			\n");
    		sql.append(" ) 						\n");

			stmt	= this.conn.prepareStatement(sql.toString());
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {
					e2.printStackTrace();
					log.debug(e2.getMessage());
					}
			
		} finally {
			
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
			
		}
    }
	
	public void sendWarningEmailForIYPC() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" INSERT INTO KEP_MAIL(	\n");
    		sql.append("         SEQ,			\n");
    		sql.append("         SEND_EMAIL,	\n");
    		sql.append("         SEND_NAME,		\n");
    		sql.append("         RECEIVE_EMAIL,	\n");
    		sql.append("         RECEIVE_NAME,	\n");
    		sql.append("         SUBJECT,		\n");
    		sql.append("         CONTENTS,		\n");
    		sql.append("         CREATE_DATE,	\n");
    		sql.append("         JOB_FLAG		\n");
    		sql.append(" )VALUES(				\n");
    		sql.append("         SEQ_KEP_MAIL.NEXTVAL,		\n");
    		sql.append("         'koreab2b@koreab2b.com',	\n");
    		sql.append("         '운영자',		\n");
    		sql.append("         'comanche@koreab2b.com;coolkim@koreab2b.com;jwoh@koreab2b.com;',	\n");
    		sql.append("         '김승우;김시원;오지원;',		\n");
    		sql.append("         '[KEP-일양] 일양택배 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',	\n");
    		sql.append("         '** [KEP-일양] 일양택배 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',					\n");
    		sql.append("         sysdate,		\n");
    		sql.append("         'N'			\n");
    		sql.append(" ) 						\n");

			stmt	= this.conn.prepareStatement(sql.toString());
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {
				e2.printStackTrace();
				log.debug(e2.getMessage());
			}
		} finally {
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
		}
    }
	
	public void sendWarningEmailForSYGP() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" INSERT INTO KEP_MAIL(	\n");
    		sql.append("         SEQ,			\n");
    		sql.append("         SEND_EMAIL,	\n");
    		sql.append("         SEND_NAME,		\n");
    		sql.append("         RECEIVE_EMAIL,	\n");
    		sql.append("         RECEIVE_NAME,	\n");
    		sql.append("         SUBJECT,		\n");
    		sql.append("         CONTENTS,		\n");
    		sql.append("         CREATE_DATE,	\n");
    		sql.append("         JOB_FLAG		\n");
    		sql.append(" )VALUES(				\n");
    		sql.append("         SEQ_KEP_MAIL.NEXTVAL,		\n");
    		sql.append("         'koreab2b@koreab2b.com',	\n");
    		sql.append("         '운영자',		\n");
    		sql.append("         'comanche@koreab2b.com;coolkim@koreab2b.com;jwoh@koreab2b.com;',	\n");
    		sql.append("         '김승우;김시원;오지원;',		\n");
    		sql.append("         '[KEP-삼양사] 삼양사 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',	\n");
    		sql.append("         '** [KEP-삼양사] 삼양사 인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',					\n");
    		sql.append("         sysdate,		\n");
    		sql.append("         'N'			\n");
    		sql.append(" ) 						\n");

			stmt	= this.conn.prepareStatement(sql.toString());
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {
				e2.printStackTrace();
				log.debug(e2.getMessage());
			}
		} finally {
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
		}
    }
	
	public void sendWarningEmailForSOIL() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	
    	try {
    		getDBConnection();    		
    		this.conn.setAutoCommit(false);
    		
    		sql	= new StringBuffer();
    		sql.append(" INSERT INTO KEP_MAIL(	\n");
    		sql.append("         SEQ,			\n");
    		sql.append("         SEND_EMAIL,	\n");
    		sql.append("         SEND_NAME,		\n");
    		sql.append("         RECEIVE_EMAIL,	\n");
    		sql.append("         RECEIVE_NAME,	\n");
    		sql.append("         SUBJECT,		\n");
    		sql.append("         CONTENTS,		\n");
    		sql.append("         CREATE_DATE,	\n");
    		sql.append("         JOB_FLAG		\n");
    		sql.append(" )VALUES(				\n");
    		sql.append("         SEQ_KEP_MAIL.NEXTVAL,		\n");
    		sql.append("         'koreab2b@koreab2b.com',	\n");
    		sql.append("         '운영자',		\n");
    		sql.append("         'comanche@koreab2b.com;coolkim@koreab2b.com;jwoh@koreab2b.com;',	\n");
    		sql.append("         '김승우;김시원;오지원;',		\n");
    		sql.append("         '[KEP-SOIL] SOIL인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',	\n");
    		sql.append("         '** [KEP-SOIL] SOIL인터페이스 서버 연결 오류 발생 ('||to_char(sysdate,'YYYY/MM/DD HH24:MI:SS')||')',					\n");
    		sql.append("         sysdate,		\n");
    		sql.append("         'N'			\n");
    		sql.append(" ) 						\n");

			stmt	= this.conn.prepareStatement(sql.toString());
					
			stmt.executeUpdate();
			
    		this.conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.debug(e.getMessage());
			try {this.conn.rollback();} catch (Exception e2) {
				e2.printStackTrace();
				log.debug(e2.getMessage());
			}
		} finally {
			try {if(stmt != null) {stmt.close();} } catch (Exception ex) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception ex) {}
		}
    }
	
	public List<Map<String, String>> getFileMoveList() {
    	
		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	ResultSet rs = null;
    	
    	List<Map<String, String>> rMaps = null;
    	
    	try {
    		getDBConnection();
    		sql = new StringBuffer();
    		sql.append("SELECT CODE, TEXT1 AS URL, TEXT2 AS PORT, TEXT3 AS ID, TEXT4 AS PASSWD, TEXT5 AS SOURCE, TEXT6 AS TARGET FROM ICOMCOD1 WHERE TYPE = 'FTP_IN' AND FLAG = 'Y'");
    		stmt	= this.conn.prepareStatement(sql.toString());
    		
    		rs = stmt.executeQuery();
    		
    		rMaps = CommonUtil.convertResultSetToMapsString(rs);
			
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try{ if(rs != null) rs.close(); } catch(Exception e2) {}
			try{ if(stmt != null) stmt.close(); } catch(Exception e2) {}
			try{ if(this.conn != null) this.conn.close(); } catch(Exception e2) {}
		}
		
    	return rMaps;
	}
	
	public void updateIfStatus(Map<String, String> pMap) {

		PreparedStatement stmt	= null;
    	StringBuffer sql = null;
    	int idx = 1;
    	try {
    		getDBConnection();
    		sql = new StringBuffer();
        	sql.append("UPDATE EAI.IF_ERR_MNG	\n");
        	sql.append("   SET LAST_UPDATE_DATE = SYSDATE, IF_STATUS = 'ON'	\n");
        	sql.append(" WHERE COM_CODE = ?	\n");
        	sql.append("   AND TASK_GUBUN = ?	\n");
        	sql.append("   AND IF_TYPE = ?	\n");
        	sql.append("   AND TASK_ORDER = ?	\n");
        	
        	stmt	= this.conn.prepareStatement(sql.toString());
        	idx = 1;
        	stmt.setString(idx++, pMap.get("COM_CODE"));
        	stmt.setString(idx++, pMap.get("TASK_GUBUN"));
        	stmt.setString(idx++, pMap.get("IF_TYPE"));
        	stmt.setString(idx++, pMap.get("TASK_ORDER"));
        	
        	stmt.executeUpdate();
        	
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		} finally {
			try{ if(stmt != null) stmt.close(); } catch(Exception e2) {}
			try{ if(this.conn != null) this.conn.close(); } catch(Exception e2) {}
		}
	}
}