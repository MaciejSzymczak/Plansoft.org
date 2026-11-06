// Wyszukiwanie "Dowolna fraza" (jak buildFilter w DM.pas): kilka fraz oddzielonych przecinkiem,
// porównanie bez wielkości liter i bez polskich znaków.
'use strict';

const SEARCH = {
  LECTURERS: `org_units.name||org_units.code||lecturers.abbreviation||lecturers.title||' '||lecturers.first_name||' '||lecturers.last_name
    ||lecturers.email||lecturers.diff_message||lecturers.attribs_01||lecturers.attribs_02||lecturers.attribs_03||lecturers.attribs_04
    ||lecturers.attribs_05||lecturers.attribs_06||lecturers.attribs_07||lecturers.attribs_08||lecturers.attribs_09||lecturers.attribs_10
    ||lecturers.attribs_11||lecturers.attribs_12||lecturers.attribs_13||lecturers.attribs_14||lecturers.attribs_15
    ||lecturers.desc1||lecturers.desc2||'#'||lecturers.integration_id||'#'`,
  GROUPS: `org_units.name||org_units.code||groups.name||groups.abbreviation||groups.email||groups.desc1||groups.desc2||groups.attribs_01
    ||groups.attribs_02||groups.attribs_03||groups.attribs_04||groups.attribs_05||groups.attribs_06||groups.attribs_07||groups.attribs_08
    ||groups.attribs_09||groups.attribs_10||groups.attribs_11||groups.attribs_12||groups.attribs_13||groups.attribs_14||groups.attribs_15
    ||'#'||groups.integration_id||'#'`,
  ROOMS: `org_units.name||org_units.code||rooms.name||rooms.desc1||rooms.desc2||rooms.email||rooms.attribs_01||rooms.attribs_02
    ||rooms.attribs_03||rooms.attribs_04||rooms.attribs_05||rooms.attribs_06||rooms.attribs_07||rooms.attribs_08||rooms.attribs_09
    ||rooms.attribs_10||rooms.attribs_11||rooms.attribs_12||rooms.attribs_13||rooms.attribs_14||rooms.attribs_15
    ||'#'||rooms.integration_id||'#'`,
  PERIODS: `periods.created_by||periods.name||periods.desc1||periods.desc2||periods.attribs_01||periods.attribs_02||periods.attribs_03
    ||periods.attribs_04||periods.attribs_05||periods.attribs_06||periods.attribs_07||periods.attribs_08||periods.attribs_09
    ||periods.attribs_10||periods.attribs_11||periods.attribs_12||periods.attribs_13||periods.attribs_14||periods.attribs_15
    ||'#'||periods.integration_id||'#'`,
};

const POLISH = { 'Ą': 'A', 'Ć': 'C', 'Ę': 'E', 'Ł': 'L', 'Ń': 'N', 'Ó': 'O', 'Ś': 'S', 'Ź': 'Z', 'Ż': 'Z' };

// fraza -> tablica słów (wielkie litery, bez polskich znaków)
function searchTokens(phrase) {
  return String(phrase || '').toUpperCase().replace(/[ĄĆĘŁŃÓŚŹŻ]/g, c => POLISH[c])
    .split(',').map(t => t.trim()).filter(Boolean).slice(0, 10);
}

// fraza "abc, def" -> (wyrażenie like :s0 or wyrażenie like :s1); expr = nazwa z SEARCH albo własne wyrażenie
function searchFilter(table, phrase, binds, prefix = 's') {
  const tokens = searchTokens(phrase);
  if (!tokens.length) return '0=0';
  const expr = `xxmsz_tools.erasePolishChars(upper(${SEARCH[table] || table}))`;
  return '(' + tokens.map((t, i) => { binds[prefix + i] = '%' + t + '%'; return `${expr} like :${prefix}${i}`; }).join(' or ') + ')';
}

module.exports = { SEARCH, POLISH, searchTokens, searchFilter };
