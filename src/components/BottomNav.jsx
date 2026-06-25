import { useLocation, useNavigate } from 'react-router-dom';

const NAV_ITEMS = [
  { path: '/home',     label: 'Home',     icon: '🏠' },
  { path: '/live',     label: 'Live',     icon: '📡' },
  { path: '/fotos',    label: "Foto's",   icon: '📷' },
  { path: '/jaarboek', label: 'Jaarboek', icon: '🎓' },
];

export default function BottomNav() {
  const location = useLocation();
  const navigate = useNavigate();

  // Match active tab: /jaarboek/123 → still highlights /jaarboek
  function isActive(path) {
    return location.pathname === path || location.pathname.startsWith(path + '/');
  }

  return (
    <nav style={{
      position: 'fixed',
      bottom: 0,
      left: 0,
      right: 0,
      height: 'var(--nav-height)',
      background: 'rgba(0,10,0,0.92)',
      backdropFilter: 'blur(12px)',
      borderTop: '1.5px solid var(--green-border)',
      display: 'flex',
      alignItems: 'stretch',
      zIndex: 100,
    }}>
      {NAV_ITEMS.map((item) => {
        const active = isActive(item.path);
        return (
          <button
            key={item.path}
            onClick={() => navigate(item.path)}
            aria-label={item.label}
            aria-current={active ? 'page' : undefined}
            style={{
              flex: 1,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: 4,
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              padding: '8px 4px',
              position: 'relative',
              transition: 'opacity 0.15s',
            }}
          >
            {/* Active indicator line at top */}
            <div style={{
              position: 'absolute',
              top: 0,
              left: '20%',
              right: '20%',
              height: 2,
              borderRadius: '0 0 2px 2px',
              background: active ? 'var(--green)' : 'transparent',
              boxShadow: active ? '0 0 8px rgba(127,255,0,0.6)' : 'none',
              transition: 'background 0.2s, box-shadow 0.2s',
            }} />

            {/* Icon */}
            <span style={{
              fontSize: 22,
              filter: active ? 'none' : 'grayscale(1) opacity(0.5)',
              transition: 'filter 0.2s',
            }}>
              {item.icon}
            </span>

            {/* Label */}
            <span style={{
              fontSize: 10,
              fontFamily: 'var(--font-main)',
              fontWeight: active ? 700 : 400,
              color: active ? 'var(--green)' : 'var(--text-dim)',
              letterSpacing: active ? 0.5 : 0,
              transition: 'color 0.2s, font-weight 0.2s',
            }}>
              {item.label}
            </span>
          </button>
        );
      })}
    </nav>
  );
}