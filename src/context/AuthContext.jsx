import { createContext, useContext, useEffect, useState } from 'react';
import { api, setToken, getToken } from '../lib/api';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [role, setRole] = useState(null);
  const [userId, setUserId] = useState(null);

  useEffect(() => {
    if (getToken()) {
      const storedRole = localStorage.getItem('auth_role');
      const storedUserId = localStorage.getItem('auth_user_id');
      if (storedRole) setRole(storedRole);
      if (storedUserId) setUserId(Number(storedUserId));
    }
  }, []);

  async function login(code) {
    const res = await api.login(code);
    setToken(res.token);
    setRole(res.user.role);
    setUserId(res.user.id);
    localStorage.setItem('auth_role', res.user.role);
    localStorage.setItem('auth_user_id', String(res.user.id));
    return true;
  }

  function logout() {
    setRole(null);
    setUserId(null);
    setToken('');
    localStorage.removeItem('auth_role');
    localStorage.removeItem('auth_user_id');
  }

  return (
    <AuthContext.Provider value={{ userId, role, isLoggedIn: !!role, isAdmin: role === 'admin', login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}