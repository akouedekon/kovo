import React from 'react';

const cards = [
  { label: 'Utilisateurs', value: '1,284', note: '+12 aujourd’hui' },
  { label: 'Trajets', value: '342', note: '28 en cours' },
  { label: 'Réservations', value: '913', note: '98% validées' },
  { label: 'Paiements', value: '1.8M FCFA', note: 'Taux de succès 99%' },
];

export default function App() {
  return (
    <div style={styles.page}>
      <aside style={styles.sidebar}>
        <h1 style={styles.brand}>Kovo Admin</h1>
        <p style={styles.sidebarText}>Gestion des opérations, de la sécurité et des paiements</p>
        <nav style={styles.nav}>
          <a href="#dashboard">Dashboard</a>
          <a href="#users">Utilisateurs</a>
          <a href="#rides">Trajets</a>
          <a href="#bookings">Réservations</a>
          <a href="#payments">Paiements</a>
        </nav>
      </aside>

      <main style={styles.main}>
        <header style={styles.header}>
          <div>
            <h2 style={{ margin: 0 }}>Tableau de bord</h2>
            <p style={{ margin: '6px 0 0', color: '#64748b' }}>Vue globale du système Kovo</p>
          </div>
          <button style={styles.button}>Nouvelle action</button>
        </header>

        <section style={styles.grid}>
          {cards.map((card) => (
            <article key={card.label} style={styles.card}>
              <div style={{ color: '#64748b' }}>{card.label}</div>
              <div style={styles.value}>{card.value}</div>
              <div style={{ color: '#16a34a', fontSize: 13 }}>{card.note}</div>
            </article>
          ))}
        </section>

        <section style={styles.panel}>
          <h3 style={{ marginTop: 0 }}>Activité récente</h3>
          <div style={styles.list}>
            <div>✅ 14 nouvelles réservations validées</div>
            <div>🚗 6 nouveaux trajets publiés</div>
            <div>💳 4 paiements en attente de confirmation</div>
            <div>🛡️ 2 comptes revus par support</div>
          </div>
        </section>
      </main>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    display: 'grid',
    gridTemplateColumns: '260px 1fr',
    minHeight: '100vh',
    background: '#f8fafc',
    color: '#0f172a',
    fontFamily: 'Inter, system-ui, sans-serif',
  },
  sidebar: {
    background: 'linear-gradient(180deg, #0f172a, #1e293b)',
    color: 'white',
    padding: 24,
  },
  sidebarText: {
    color: '#cbd5e1',
    marginTop: -16,
    marginBottom: 24,
    lineHeight: 1.5,
  },
  brand: {
    marginTop: 0,
    marginBottom: 32,
  },
  nav: {
    display: 'grid',
    gap: 12,
  },
  navLink: {
    color: '#e2e8f0',
    textDecoration: 'none',
    padding: '10px 12px',
    borderRadius: 12,
    background: 'rgba(255,255,255,0.06)',
  },
  main: {
    padding: 28,
  },
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  button: {
    border: 'none',
    background: '#16a34a',
    color: 'white',
    padding: '12px 18px',
    borderRadius: 12,
    fontWeight: 700,
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
    gap: 16,
    marginBottom: 24,
  },
  card: {
    background: 'white',
    borderRadius: 18,
    padding: 20,
    boxShadow: '0 10px 30px rgba(15, 23, 42, 0.08)',
  },
  value: {
    fontSize: 32,
    fontWeight: 800,
    margin: '8px 0',
  },
  panel: {
    background: 'white',
    borderRadius: 18,
    padding: 24,
    boxShadow: '0 10px 30px rgba(15, 23, 42, 0.08)',
  },
  list: {
    display: 'grid',
    gap: 14,
    color: '#334155',
  },
};
