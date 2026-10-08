package com.koreab2b.mro.manager.user.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.user.domain.UserAuth;

@Repository("userAuthorDao")
@Transactional
public class UserAuthDaoImpl implements UserAuthDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<UserAuth> selectUserAuthsByUserId(String pUserId){
		return sqlSessionTemplate.selectList("userAuth.selectUserAuthsByUserId", pUserId);
	}
	
	public void insertUserAuth(UserAuth pUserAuth) {
		sqlSessionTemplate.insert("userAuth.insertUserAuth", pUserAuth);
	}
	
	public void updateUserAuth(UserAuth pUserAuth) {
		sqlSessionTemplate.update("userAuth.updateUserAuth", pUserAuth);
	}
	
	public void deleteUserAuthByUserId(String pUserId) {
		sqlSessionTemplate.delete("userAuth.deleteUserAuthByUserId", pUserId);
	}
}
