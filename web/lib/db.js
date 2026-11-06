// Połączenia z Oracle. Każdy zalogowany użytkownik ma własną małą pulę połączeń
// na swoim koncie Oracle, więc uprawnienia działają tak samo jak w programie Delphi.
'use strict';
const oracledb = require('oracledb');

const connectString = process.env.PLANSOFT_DB_CONNECT || 'localhost:1521/XEPDB1';

// Oracle 10/11: tryb Thick z Oracle Instant Client (ORACLE_CLIENT_DIR ustawia instalator).
// Oracle 12 i nowsze: tryb Thin, bez klienta Oracle.
if (process.env.ORACLE_CLIENT_DIR) {
  oracledb.initOracleClient({ libDir: process.env.ORACLE_CLIENT_DIR });
}

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;
oracledb.fetchAsString = [oracledb.CLOB];

async function createUserPool(user, password) {
  const pool = await oracledb.createPool({
    user, password, connectString,
    poolMin: 0, poolMax: 4, poolIncrement: 1, poolTimeout: 120,
  });
  // createPool nie sprawdza hasła przy poolMin = 0 - sprawdzamy pierwszym połączeniem
  try {
    const conn = await pool.getConnection();
    await conn.close();
  } catch (e) {
    await pool.close(0).catch(() => {});
    throw e;
  }
  return pool;
}

async function query(pool, sql, binds = {}) {
  const conn = await pool.getConnection();
  try {
    return (await conn.execute(sql, binds)).rows;
  } finally {
    await conn.close();
  }
}

// kilka poleceń w jednej transakcji: commit po udanym wykonaniu fn(conn), w razie błędu rollback
async function transaction(pool, fn) {
  const conn = await pool.getConnection();
  try {
    const result = await fn(conn);
    await conn.commit();
    return result;
  } catch (e) {
    await conn.rollback().catch(() => {});
    throw e;
  } finally {
    await conn.close();
  }
}

// komunikat dla użytkownika zamiast surowego błędu Oracle
function loginErrorMessage(e) {
  const code = e && e.errorNum;
  if (code === 1017) return 'Nieprawidłowa nazwa użytkownika lub hasło.';
  if (code === 28000) return 'Konto jest zablokowane. Skontaktuj się z administratorem.';
  if (code === 28001) return 'Hasło wygasło. Zmień hasło w programie Plansoft.org lub skontaktuj się z administratorem.';
  if (e && /NJS-(500|503|511)|ECONNREFUSED|ORA-12541|ORA-12514/.test(e.message)) return 'Brak połączenia z bazą danych.';
  return 'Nie udało się zalogować: ' + (e && e.message ? e.message : e);
}

// błąd zapisu (ORA-xxxxx) jako czytelny komunikat; pierwsza linia komunikatu Oracle bez stosu
function writeErrorMessage(e) {
  const code = e && e.errorNum;
  if (code === 1) return 'Taki rekord już istnieje (powtórzona wartość, która musi być unikalna).';
  if (code === 1400) return 'Nie wypełniono wymaganego pola.';
  if (code === 2292) return 'Nie można usunąć - rekord jest używany (np. ma zaplanowane zajęcia lub powiązania).';
  if (code === 12899) return 'Wpisana wartość jest za długa.';
  if (code === 1031) return 'Brak uprawnień w bazie danych do tej operacji.';
  const msg = String((e && e.message) || e).split('\n')[0];
  return msg.replace(/^ORA-20\d{3}: /, '');
}

module.exports = { createUserPool, query, transaction, loginErrorMessage, writeErrorMessage, connectString };
