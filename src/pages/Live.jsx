import { useState, useRef, useEffect } from 'react';
import Layout from '../components/Layout';
import Header from '../components/Header';
import { useAuth } from '../context/AuthContext';

const STORAGE_KEY = 'glr_live_chat_messages';

const defaultMessages = [
  { user: 'Leerling', text: 'Hallo allemaal! 🎓', time: '14:02' },
  { user: 'Docent',   text: 'Hoi iedereen, welkom bij de uitreiking!', time: '14:03' },
  { user: 'Familie',  text: 'Super trots op jullie! 🥳', time: '14:04' },
];

// Replace with your actual embed URL when the stream goes live.
// Set to null or '' to show the "stream not live yet" placeholder.
const VIMEO_EMBED = 'https://player.vimeo.com/video/76979871?autoplay=0';

function loadMessages() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (raw) return JSON.parse(raw);
  } catch {
    // localStorage may fail in private browsing — fall back to defaults
  }
  return defaultMessages;
}

function saveMessages(msgs) {
  try {
    // Keep only the last 100 messages to avoid storage limits
    const toSave = msgs.slice(-100);
    localStorage.setItem(STORAGE_KEY, JSON.stringify(toSave));
  } catch {
    // Silently ignore storage errors
  }
}

export default function Live() {
  const [messages, setMessages] = useState(loadMessages);
  const [input, setInput] = useState('');
  const [streamError, setStreamError] = useState(false);
  const { isAdmin } = useAuth();
  const chatEndRef = useRef(null);

  // Persist messages to localStorage whenever they change
  useEffect(() => {
    saveMessages(messages);
  }, [messages]);

  // Auto-scroll to latest message
  useEffect(() => {
    chatEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  function sendMessage() {
    const text = input.trim();
    if (!text) return;
    const newMsg = {
      user: isAdmin ? 'Docent' : 'Jij',
      text,
      time: new Date().toLocaleTimeString('nl-NL', { hour: '2-digit', minute: '2-digit' }),
    };
    setMessages(prev => [...prev, newMsg]);
    setInput('');
  }

  const streamIsLive = Boolean(VIMEO_EMBED);

  return (
    <Layout scrollable={false}>
      <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
        <Header showBack={false} />

        {/* Video player */}
        <div style={{ padding: '0 16px 16px', flexShrink: 0 }}>
          <div style={{
            background: '#000',
            borderRadius: 16,
            overflow: 'hidden',
            aspectRatio: '16/9',
            position: 'relative',
            border: '2px solid var(--green)',
            boxShadow: '0 0 30px rgba(127,255,0,0.2)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}>
            {/* Stream not live placeholder */}
            {(!streamIsLive || streamError) && (
              <div style={{
                position: 'absolute',
                inset: 0,
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 12,
                background: 'rgba(0,10,0,0.95)',
                zIndex: 2,
              }}>
                <span style={{ fontSize: 40 }}>📡</span>
                <p style={{ fontWeight: 700, fontSize: 16, color: 'var(--green)' }}>
                  Stream is nog niet live
                </p>
                <p style={{ color: 'var(--text-dim)', fontSize: 13, textAlign: 'center', padding: '0 24px' }}>
                  De livestream start zodra de uitreiking begint.
                  {streamError && ' Ververs de pagina om opnieuw te proberen.'}
                </p>
                {streamError && (
                  <button
                    onClick={() => setStreamError(false)}
                    style={{
                      marginTop: 4,
                      background: 'none',
                      border: '1.5px solid var(--green-border)',
                      borderRadius: 8,
                      color: 'var(--green)',
                      padding: '8px 20px',
                      cursor: 'pointer',
                      fontFamily: 'var(--font-main)',
                      fontSize: 13,
                    }}
                  >
                    Opnieuw proberen
                  </button>
                )}
              </div>
            )}

            {/* Vimeo iframe — only mounted when URL is set */}
            {streamIsLive && !streamError && (
              <iframe
                src={VIMEO_EMBED}
                style={{ width: '100%', height: '100%', border: 'none', position: 'absolute', inset: 0 }}
                allow="autoplay; fullscreen; picture-in-picture"
                title="Diploma Uitreiking 2026 Livestream"
                onError={() => setStreamError(true)}
              />
            )}

            {/* LIVE badge — only shown when stream URL is set and no error */}
            {streamIsLive && !streamError && (
              <div style={{
                position: 'absolute',
                top: 12, left: 12,
                background: 'rgba(0,0,0,0.75)',
                border: '1px solid rgba(255,64,64,0.6)',
                borderRadius: 6,
                padding: '3px 10px',
                display: 'flex',
                alignItems: 'center',
                gap: 6,
                zIndex: 3,
              }}>
                <span style={{
                  width: 7, height: 7,
                  borderRadius: '50%',
                  background: '#ff4040',
                  animation: 'pulse-green 2s infinite',
                }} />
                <span style={{ fontSize: 11, fontWeight: 700, color: '#ff6060', letterSpacing: 1 }}>LIVE</span>
              </div>
            )}
          </div>
        </div>

        {/* Live chat */}
        <div style={{
          flex: 1,
          margin: '0 16px',
          marginBottom: 8,
          background: 'rgba(0,20,0,0.7)',
          borderRadius: 14,
          border: '1.5px solid var(--green-border)',
          display: 'flex',
          flexDirection: 'column',
          overflow: 'hidden',
          minHeight: 0,
        }}>
          {/* Chat header */}
          <div style={{
            padding: '12px 16px',
            borderBottom: '1px solid var(--green-border)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{
                width: 8, height: 8,
                borderRadius: '50%',
                background: '#ff4040',
                animation: 'pulse-green 2s infinite',
              }} />
              <span style={{ fontWeight: 700, fontSize: 15, letterSpacing: 1 }}>LIVE CHAT</span>
            </div>
            <span style={{ color: 'var(--text-dim)', fontSize: 12 }}>
              {messages.length} berichten
            </span>
          </div>

          {/* Messages */}
          <div style={{
            flex: 1,
            overflowY: 'auto',
            padding: '12px 16px',
            display: 'flex',
            flexDirection: 'column',
            gap: 10,
            minHeight: 0,
          }}>
            {messages.map((msg, i) => (
              <div
                key={i}
                style={{ borderBottom: '1px solid rgba(127,255,0,0.1)', paddingBottom: 10 }}
              >
                <span style={{ fontWeight: 700, fontSize: 14 }}>{msg.user}: </span>
                <span style={{ color: 'rgba(200,255,150,0.85)', fontSize: 14 }}>{msg.text}</span>
                <span style={{ float: 'right', color: 'var(--text-dim)', fontSize: 11, marginTop: 2 }}>
                  {msg.time}
                </span>
              </div>
            ))}
            <div ref={chatEndRef} />
          </div>

          {/* Input */}
          <div style={{
            padding: '10px 12px',
            borderTop: '1px solid var(--green-border)',
            display: 'flex',
            gap: 8,
          }}>
            <input
              type="text"
              placeholder="Type je bericht..."
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && sendMessage()}
              style={{ flex: 1, padding: '10px 14px', fontSize: 14 }}
            />
            <button
              onClick={sendMessage}
              disabled={!input.trim()}
              style={{
                background: input.trim() ? 'var(--green-dim)' : 'rgba(0,30,0,0.3)',
                border: '1.5px solid var(--green-border)',
                borderRadius: 8,
                width: 44,
                height: 44,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                cursor: input.trim() ? 'pointer' : 'default',
                color: input.trim() ? 'var(--green)' : 'var(--text-dim)',
                fontSize: 18,
                flexShrink: 0,
                transition: 'all 0.15s',
              }}
              aria-label="Verstuur"
            >
              ➤
            </button>
          </div>
        </div>
      </div>
    </Layout>
  );
}