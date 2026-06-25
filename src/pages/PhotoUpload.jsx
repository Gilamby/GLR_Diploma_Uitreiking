import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import Layout from '../components/Layout';
import Header from '../components/Header';
import { useAuth } from '../context/AuthContext';
import { api } from '../lib/api';

export default function PhotoUpload() {
  const navigate = useNavigate();
  const { isAdmin } = useAuth();
  const fileRef = useRef(null);

  const [preview, setPreview] = useState(null);
  const [titel, setTitel] = useState('');
  const [klas, setKlas] = useState('');
  const [classes, setClasses] = useState([]);
  const [classesLoading, setClassesLoading] = useState(true);
  const [uploaded, setUploaded] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [validationError, setValidationError] = useState('');
  const [file, setFile] = useState(null);

  // Load classes from API (same source as Photos page — not hardcoded)
  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        const res = await api.classes();
        if (!alive) return;
        const list = res.classes || [];
        setClasses(list);
        if (list.length > 0) setKlas(list[0].name);
      } catch {
        // Fallback to common class names if API fails
        const fallback = ['BEROEPS2', 'BEROEPS3', 'BEROEPS4', 'BEROEPS5'];
        if (!alive) return;
        setClasses(fallback.map((n, i) => ({ id: i, name: n })));
        setKlas(fallback[0]);
      } finally {
        if (alive) setClassesLoading(false);
      }
    })();
    return () => { alive = false; };
  }, []);

  // Redirect non-admins
  if (!isAdmin) {
    return (
      <Layout>
        <Header showBack />
        <div style={{ padding: 32, textAlign: 'center' }}>
          <p style={{ color: 'var(--text-dim)', fontSize: 16 }}>
            Geen toegang. Dit gedeelte is alleen voor admins.
          </p>
        </div>
      </Layout>
    );
  }

  function handleFileChange(e) {
    const f = e.target.files[0];
    if (!f) return;
    setFile(f);
    const reader = new FileReader();
    reader.onload = (ev) => setPreview(ev.target.result);
    reader.readAsDataURL(f);
    setUploaded(false);
    setError('');
    setValidationError('');
  }

  function handleDrop(e) {
    e.preventDefault();
    const f = e.dataTransfer.files[0];
    if (!f) return;
    setFile(f);
    const reader = new FileReader();
    reader.onload = (ev) => setPreview(ev.target.result);
    reader.readAsDataURL(f);
    setUploaded(false);
    setError('');
    setValidationError('');
  }

  // Validate and return first missing field message, or empty string if all ok
  function validate() {
    if (!file || !preview) return 'Selecteer eerst een foto om te uploaden.';
    if (!titel.trim()) return 'Vul een titel in voor de foto.';
    if (!klas) return 'Kies een examenklas.';
    return '';
  }

  async function handleSubmit() {
    const msg = validate();
    if (msg) {
      setValidationError(msg);
      return;
    }
    setValidationError('');
    setLoading(true);
    try {
      await api.uploadPhoto({ file, titel, klas });
      setLoading(false);
      setUploaded(true);
      setPreview(null);
      setTitel('');
      setFile(null);
      setError('');
    } catch (e) {
      setLoading(false);
      setError(e?.message || 'Uploaden mislukt.');
    }
  }

  return (
    <Layout>
      <Header
        showBack
        rightLabel="Bevestigen"
        rightAction={handleSubmit}
      />

      <div style={{ padding: '8px 16px 32px', display: 'flex', flexDirection: 'column', gap: 20 }}>

        {/* Upload zone */}
        <div
          className="card"
          onClick={() => fileRef.current?.click()}
          onDragOver={(e) => e.preventDefault()}
          onDrop={handleDrop}
          style={{
            minHeight: 220,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            cursor: 'pointer',
            position: 'relative',
            overflow: 'hidden',
            animation: 'fadeUp 0.4s ease both',
            // Highlight border red if validation failed on file
            border: validationError && (!file || !preview)
              ? '1.5px solid rgba(255,100,100,0.7)'
              : undefined,
          }}
        >
          {preview ? (
            <img
              src={preview}
              alt="Preview"
              style={{ width: '100%', height: '100%', objectFit: 'cover', position: 'absolute', inset: 0 }}
            />
          ) : (
            <div style={{ textAlign: 'center', padding: 24 }}>
              <p style={{ fontSize: 48, marginBottom: 8 }}>📷</p>
              <p style={{ color: 'var(--text-dim)', fontSize: 15 }}>
                Tik om foto te selecteren<br />
                <span style={{ fontSize: 13 }}>of sleep een foto hierheen</span>
              </p>
            </div>
          )}
          <input
            ref={fileRef}
            type="file"
            accept="image/*"
            style={{ display: 'none' }}
            onChange={handleFileChange}
          />
        </div>

        {/* Titel field */}
        <div style={{ animation: 'fadeUp 0.4s ease 0.1s both' }}>
          <label style={{ display: 'block', color: 'var(--green)', fontWeight: 600, marginBottom: 8, fontSize: 15 }}>
            Titel
          </label>
          <input
            type="text"
            placeholder="Bijv. Diploma-uitreiking klas 4B"
            value={titel}
            onChange={(e) => {
              setTitel(e.target.value);
              if (validationError) setValidationError('');
            }}
            style={{
              border: validationError && !titel.trim()
                ? '1.5px solid rgba(255,100,100,0.7)'
                : undefined,
            }}
          />
        </div>

        {/* Klas selector — loaded from API */}
        <div style={{ animation: 'fadeUp 0.4s ease 0.15s both' }}>
          <label style={{ display: 'block', color: 'var(--green)', fontWeight: 600, marginBottom: 8, fontSize: 15 }}>
            Examenklas
          </label>
          {classesLoading ? (
            <div style={{
              background: 'rgba(0,60,0,0.4)',
              border: '1.5px solid var(--green-border)',
              borderRadius: 8,
              padding: '12px 16px',
              color: 'var(--text-dim)',
              fontSize: 14,
            }}>
              Klassen laden...
            </div>
          ) : (
            <select
              value={klas}
              onChange={(e) => setKlas(e.target.value)}
              style={{
                background: 'rgba(0,60,0,0.4)',
                border: '1.5px solid var(--green-border)',
                borderRadius: 8,
                color: 'var(--green)',
                fontFamily: 'var(--font-main)',
                fontSize: 16,
                padding: '12px 16px',
                width: '100%',
                outline: 'none',
              }}
            >
              {classes.map(c => (
                <option key={c.id} value={c.name}>{c.name}</option>
              ))}
            </select>
          )}
        </div>

        {/* Validation error — shown when user tries to submit with missing fields */}
        {validationError && (
          <div style={{
            background: 'rgba(80,0,0,0.35)',
            border: '1.5px solid rgba(255,100,100,0.5)',
            borderRadius: 12,
            padding: '12px 16px',
            display: 'flex',
            alignItems: 'center',
            gap: 10,
            animation: 'fadeUp 0.3s ease both',
          }}>
            <span style={{ fontSize: 18 }}>⚠</span>
            <p style={{ color: 'rgba(255,200,200,0.95)', fontSize: 14 }}>
              {validationError}
            </p>
          </div>
        )}

        {/* Submit button */}
        <button
          onClick={handleSubmit}
          disabled={loading}
          className="btn btn-green"
          style={{
            animation: 'fadeUp 0.4s ease 0.2s both',
            opacity: loading ? 0.7 : 1,
          }}
        >
          {loading ? 'Uploaden...' : 'Foto Uploaden'}
        </button>

        {/* API error */}
        {error && (
          <div style={{
            background: 'rgba(80,0,0,0.35)',
            border: '1.5px solid rgba(255,100,100,0.5)',
            borderRadius: 12,
            padding: '14px 16px',
            textAlign: 'center',
            color: 'rgba(255,200,200,0.95)',
          }}>
            <p style={{ fontWeight: 600, marginBottom: 4 }}>Upload mislukt</p>
            <p style={{ fontSize: 13 }}>{error}</p>
          </div>
        )}

        {/* Success */}
        {uploaded && (
          <div style={{
            background: 'rgba(0,80,0,0.6)',
            border: '1.5px solid var(--green)',
            borderRadius: 12,
            padding: '16px',
            textAlign: 'center',
            animation: 'fadeUp 0.3s ease both',
          }}>
            <p style={{ fontWeight: 600, fontSize: 15 }}>✅ Foto succesvol geüpload!</p>
            <button
              onClick={() => navigate('/fotos')}
              style={{
                marginTop: 12,
                background: 'none',
                border: '1px solid var(--green-border)',
                borderRadius: 8,
                color: 'var(--green)',
                padding: '8px 20px',
                cursor: 'pointer',
                fontFamily: 'var(--font-main)',
                fontSize: 14,
              }}
            >
              Bekijk alle foto's →
            </button>
          </div>
        )}
      </div>
    </Layout>
  );
}