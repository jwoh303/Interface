package com.koreab2b.mro.manager.user.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.manager.user.dao.UserAuthDao;
import com.koreab2b.mro.manager.user.dao.UserDao;
import com.koreab2b.mro.manager.user.domain.User;
import com.koreab2b.mro.manager.user.domain.UserAuth;

@Service("userService")
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;

	@Autowired
	private UserAuthDao userAuthDao;

	public List<User> getUsers(User pUser) {
		return userDao.selectUsers(pUser);
	}

	public User getUser(String pUserId) {
		User _user = userDao.selectUserByUserId(pUserId);
		List<UserAuth> _authIds = userAuthDao.selectUserAuthsByUserId(pUserId);
		_user.setUserAuthors(_authIds);
		return _user;
	}

	public void saveUser(User pUser) {
		User _user = userDao.selectUserByUserId(pUser.getUserId());

		if (_user != null) {
			userDao.updateUser(pUser);
		} else {
			userDao.insertUser(pUser);
		}

		userAuthDao.deleteUserAuthByUserId(pUser.getUserId());

		for (UserAuth _tmp : pUser.getUserAuthors()) {
			userAuthDao.insertUserAuth(_tmp);
		}
	}

	public void deleteUser(String[] pUserIds) {
		for (String _tmpUserId : pUserIds) {
			userDao.deleteUser(_tmpUserId);
		}
	}
}
