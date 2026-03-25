const API_BASE = import.meta.env.VITE_API_BASE || '/api';

export function getToken() {
  return localStorage.getItem('auth_token') || '';
}

export function setToken(token) {
  if (token) localStorage.setItem('auth_token', token);
  else localStorage.removeItem('auth_token');
}

async function request(path, { method = 'GET', body, headers = {}, isForm = false } = {}) {
  const token = getToken();
  const res = await fetch(`${API_BASE}${path}`, {
    method,
    headers: {
      ...(isForm ? {} : { 'Content-Type': 'application/json' }),
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
    body: body == null ? undefined : (isForm ? body : JSON.stringify(body)),
  });

  const data = await res.json().catch(() => ({}));
  if (!res.ok || data?.ok === false) {
    const msg = data?.error || `Request failed (${res.status})`;
    const err = new Error(msg);
    err.status = res.status;
    err.data = data;
    throw err;
  }
  return data;
}

export const api = {
  health: () => request('/health.php'),
  login: (code) => request('/login.php', { method: 'POST', body: { code } }),
  classes: () => request('/classes.php'),
  photos: ({ klas } = {}) => {
    const qs = klas ? `?klas=${encodeURIComponent(klas)}` : '';
    return request(`/photos.php${qs}`);
  },
  uploadPhoto: ({ file, titel, klas, klasId } = {}) => {
    const fd = new FormData();
    fd.append('file', file);
    fd.append('titel', titel || '');
    if (klasId) fd.append('klasId', String(klasId));
    if (klas) fd.append('klas', klas);
    return request('/upload_photo.php', { method: 'POST', body: fd, isForm: true });
  },
  students: ({ q } = {}) => {
    const qs = q ? `?q=${encodeURIComponent(q)}` : '';
    return request(`/students.php${qs}`);
  },
  student: (id) => request(`/student.php?id=${encodeURIComponent(String(id))}`),
};

