import { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Layout from '../components/Layout';
import Header from '../components/Header';
import { api } from '../lib/api';

function Spinner() {
  return (
    <div style={{ padding: '48px 0', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 16 }}>
      <div style={{
        width: 40,
        height: 40,
        border: '3px solid var(--green-border)',
        borderTopColor: 'var(--green)',
        borderRadius: '50%',
        animation: 'spin 0.8s linear infinite',
      }} />
      <p style={{ color: 'var(--text-dim)', fontSize: 14 }}>Jaarboek laden...</p>
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}

export default function Yearbook() {
  const navigate = useNavigate();
  const [query, setQuery] = useState('');
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    let alive = true;
    (async () => {
      setLoading(true);
      try {
        const res = await api.students();
        if (!alive) return;
        setStudents(res.students || []);
      } catch (e) {
        if (!alive) return;
        setError(e?.message || 'Kon jaarboek niet laden.');
      } finally {
        if (alive) setLoading(false);
      }
    })();
    return () => { alive = false; };
  }, []);

  const filtered = useMemo(() => {
    if (!query.trim()) return students;
    const q = query.toLowerCase();
    return students.filter(s =>
      s.naam.toLowerCase().includes(q) || s.klas.toLowerCase().includes(q)
    );
  }, [query, students]);

  return (
    <Layout>
      <Header showBack={false} />

      <div style={{ padding: '0 16px 24px', display: 'flex', flexDirection: 'column', gap: 16 }}>

        {/* Search bar — always visible */}
        <div style={{ display: 'flex', gap: 8, animation: 'fadeUp 0.4s ease both' }}>
          <input
            type="search"
            placeholder="Zoek op naam of klas..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            style={{ flex: 1 }}
          />
          <button
            style={{
              background: 'rgba(0,60,0,0.5)',
              border: '1.5px solid var(--green-border)',
              borderRadius: 8,
              width: 48, height: 48,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              cursor: 'pointer',
              color: 'var(--green)',
              fontSize: 18,
              flexShrink: 0,
            }}
            aria-label="Zoeken"
          >
            🔍
          </button>
        </div>

        {/* Loading state */}
        {loading && <Spinner />}

        {/* Error state */}
        {!loading && error && (
          <div style={{
            background: 'rgba(80,0,0,0.35)',
            border: '1.5px solid rgba(255,100,100,0.5)',
            borderRadius: 12,
            padding: '16px',
            textAlign: 'center',
            color: 'rgba(255,200,200,0.95)',
          }}>
            <p style={{ fontWeight: 600, marginBottom: 4 }}>⚠ Fout bij laden</p>
            <p style={{ fontSize: 13 }}>{error}</p>
            <button
              onClick={() => window.location.reload()}
              style={{
                marginTop: 12,
                background: 'none',
                border: '1px solid rgba(255,100,100,0.5)',
                borderRadius: 6,
                color: 'rgba(255,200,200,0.8)',
                padding: '6px 16px',
                cursor: 'pointer',
                fontSize: 13,
              }}
            >
              Opnieuw proberen
            </button>
          </div>
        )}

        {/* Empty state — no students at all */}
        {!loading && !error && students.length === 0 && (
          <div style={{
            padding: '56px 24px',
            textAlign: 'center',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: 12,
            animation: 'fadeUp 0.4s ease both',
          }}>
            <span style={{ fontSize: 48 }}>🎓</span>
            <p style={{ fontWeight: 700, fontSize: 18, color: 'var(--green)' }}>Jaarboek is leeg</p>
            <p style={{ color: 'var(--text-dim)', fontSize: 14 }}>
              Er zijn nog geen leerlingen toegevoegd aan het jaarboek.
            </p>
          </div>
        )}

        {/* Empty state — search has no results */}
        {!loading && !error && students.length > 0 && filtered.length === 0 && (
          <div style={{
            padding: '40px 24px',
            textAlign: 'center',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            gap: 10,
            animation: 'fadeUp 0.4s ease both',
          }}>
            <span style={{ fontSize: 36 }}>🔍</span>
            <p style={{ fontWeight: 600, color: 'var(--green)' }}>Geen resultaten</p>
            <p style={{ color: 'var(--text-dim)', fontSize: 13 }}>
              Niemand gevonden voor "{query}". Probeer een andere naam of klas.
            </p>
            <button
              onClick={() => setQuery('')}
              style={{
                marginTop: 4,
                background: 'none',
                border: '1.5px solid var(--green-border)',
                borderRadius: 8,
                color: 'var(--green)',
                padding: '8px 20px',
                cursor: 'pointer',
                fontFamily: 'var(--font-main)',
                fontSize: 14,
              }}
            >
              Zoekopdracht wissen
            </button>
          </div>
        )}

        {/* Student cards */}
        {!loading && !error && filtered.map((student, i) => (
          <button
            key={student.id}
            onClick={() => navigate(`/jaarboek/${student.id}`)}
            className="card"
            style={{
              display: 'block',
              cursor: 'pointer',
              position: 'relative',
              overflow: 'hidden',
              width: '100%',
              textAlign: 'left',
              animation: `fadeUp 0.4s ease ${i * 0.06}s both`,
            }}
          >
            <img
              src={student.foto}
              alt={student.naam}
              style={{
                width: '100%',
                height: 220,
                objectFit: 'cover',
                display: 'block',
                filter: 'brightness(0.85)',
              }}
              loading="lazy"
            />
            <div style={{
              position: 'absolute',
              bottom: 0, left: 0, right: 0,
              background: 'rgba(0,20,0,0.75)',
              padding: '10px 16px',
              backdropFilter: 'blur(4px)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
            }}>
              <span style={{ fontWeight: 700, fontSize: 16, color: 'var(--green)' }}>
                {student.naam}
              </span>
              <span style={{ fontSize: 11, color: 'var(--text-dim)', fontWeight: 500 }}>
                {student.klas}
              </span>
            </div>
          </button>
        ))}
      </div>
    </Layout>
  );
}