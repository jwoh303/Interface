package com.koreab2b.mro.manager.user.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.user.domain.User;

@Repository("userDao")
@Transactional
public class UserDaoImpl implements UserDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<User> selectUsers(User pUser) {
		return sqlSessionTemplate.selectList("user.selectUsers", pUser);
	}

	public User selectUserByUserId(String pUserId) {
		return sqlSessionTemplate.selectOne("user.selectUserByUserId", pUserId);
	}

	public void insertUser(User pUser) {
		sqlSessionTemplate.insert("user.insertUser", pUser);
	}
	
	public void updateUser(User pUser) {
		sqlSessionTemplate.update("user.updateUser", pUser);
	}
	
	public void deleteUser(String pUserId) {
		sqlSessionTemplate.update("user.deleteUserByUserId", pUserId);
	}
}
